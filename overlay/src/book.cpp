// The Library's book: its mesh (data/book.mesh, written by the Resources' library-book/scripts/export_book.py) and
// its pictures (data/*.jpg, by pack_book_textures.py), built into the .asi, read into the model viewer's own structures;
// the book's text laid out into pages and written onto the parchment; and the page being turned.
#include "book.h"

#include <windows.h>
#include <wincodec.h>
#include <algorithm>
#include <array>
#include <atomic>
#include <cmath>
#include <cstring>
#include <list>
#include <map>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>

#include "gameicons.h"
#include "itemmodel.h"
#include "log.h"
#include "modelview.h"
#include "overlay.h"
#include "resources.h"

#define STB_TRUETYPE_IMPLEMENTATION
#define STBTT_STATIC
#include <imstb_truetype.h>

namespace
{
	// A JPEG or PNG from the .asi, as RGBA8, fitted within largestSide
	bool Decode(int resource, uint32_t largestSide, GameTexture& out)
	{
		const std::string_view bytes = EmbeddedFile(resource);
		if (bytes.empty())
			return false;
		const HRESULT init = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
		bool ok = false;
		IWICImagingFactory* factory = nullptr;
		IWICStream* stream = nullptr;
		IWICBitmapDecoder* decoder = nullptr;
		IWICBitmapFrameDecode* frame = nullptr;
		IWICBitmapScaler* scaler = nullptr;
		IWICFormatConverter* converter = nullptr;
		do
		{
			if (FAILED(CoCreateInstance(CLSID_WICImagingFactory, nullptr, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&factory))))
				break;
			if (FAILED(factory->CreateStream(&stream))
				|| FAILED(stream->InitializeFromMemory(reinterpret_cast<BYTE*>(const_cast<char*>(bytes.data())), static_cast<DWORD>(bytes.size()))))
				break;
			if (FAILED(factory->CreateDecoderFromStream(stream, nullptr, WICDecodeMetadataCacheOnDemand, &decoder)) || FAILED(decoder->GetFrame(0, &frame)))
				break;
			UINT width = 0, height = 0;
			frame->GetSize(&width, &height);
			if (width == 0 || height == 0)
				break;
			IWICBitmapSource* source = frame;
			if (width > largestSide || height > largestSide)
			{
				const double fit = static_cast<double>(largestSide) / std::max(width, height);
				const UINT w = std::max(1u, static_cast<UINT>(width * fit)), h = std::max(1u, static_cast<UINT>(height * fit));
				if (FAILED(factory->CreateBitmapScaler(&scaler)) || FAILED(scaler->Initialize(frame, w, h, WICBitmapInterpolationModeFant)))
					break;
				source = scaler;
				width = w;
				height = h;
			}
			if (FAILED(factory->CreateFormatConverter(&converter))
				|| FAILED(converter->Initialize(source, GUID_WICPixelFormat32bppRGBA, WICBitmapDitherTypeNone, nullptr, 0, WICBitmapPaletteTypeCustom)))
				break;
			out = GameTexture{};
			out.dxgiFormat = 28;   // RGBA8
			out.width = width;
			out.height = height;
			out.rowBytes = width * 4;
			out.rows = height;
			out.pixels.resize(static_cast<size_t>(out.rowBytes) * height);
			ok = SUCCEEDED(converter->CopyPixels(nullptr, out.rowBytes, static_cast<UINT>(out.pixels.size()), out.pixels.data()));
		} while (false);
		if (converter) converter->Release();
		if (scaler) scaler->Release();
		if (frame) frame->Release();
		if (decoder) decoder->Release();
		if (stream) stream->Release();
		if (factory) factory->Release();
		if (SUCCEEDED(init))
			CoUninitialize();
		if (!ok)
			Log("book: can't read built-in picture %d", resource);
		return ok;
	}

	// Each smaller level, by averaging four pixels into one, down to one pixel
	void AddMips(GameTexture& t)
	{
		t.lowerMips.clear();
		const GameTexture* from = &t;
		while ((from->width > 1 || from->height > 1) && t.lowerMips.size() < 15)
		{
			GameTexture level;
			level.dxgiFormat = t.dxgiFormat;
			level.width = std::max(1u, from->width / 2);
			level.height = std::max(1u, from->height / 2);
			level.rowBytes = level.width * 4;
			level.rows = level.height;
			level.pixels.resize(static_cast<size_t>(level.rowBytes) * level.height);
			for (uint32_t y = 0; y < level.height; ++y)
				for (uint32_t x = 0; x < level.width; ++x)
					for (int c = 0; c < 4; ++c)
					{
						const uint32_t x0 = std::min(x * 2, from->width - 1), x1 = std::min(x * 2 + 1, from->width - 1);
						const uint32_t y0 = std::min(y * 2, from->height - 1), y1 = std::min(y * 2 + 1, from->height - 1);
						const auto at = [&](uint32_t px, uint32_t py) { return from->pixels[static_cast<size_t>(py) * from->rowBytes + px * 4 + c]; };
						level.pixels[static_cast<size_t>(y) * level.rowBytes + x * 4 + c] = static_cast<uint8_t>((at(x0, y0) + at(x1, y0) + at(x0, y1) + at(x1, y1) + 2) / 4);
					}
			t.lowerMips.push_back(std::move(level));
			from = &t.lowerMips.back();
		}
	}

	template <typename T> bool Take(const char*& at, const char* end, T& value)
	{
		if (end - at < static_cast<ptrdiff_t>(sizeof(T)))
			return false;
		memcpy(&value, at, sizeof(T));
		at += sizeof(T);
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// The book as made (build_book.py): what the turning page and the blocks are worked out from
	// ------------------------------------------------------------------------------------------

	constexpr float kTilt = 50.f * 3.14159265f / 180.f;   // tipped back as on a lectern
	constexpr float kPageWidth = 0.235f, kGutter = 0.0f;
	constexpr float kMadeLeft = 0.026f, kMadeRight = 0.026f;   // the blocks' thickness as made: alike, so they meet in the V
	constexpr float kBaseRange = 0.03f;   // a block vertex's stack bottom, in its vertex colour's red: 0-255 for 0 to this
	constexpr float kAllPages = kMadeLeft + kMadeRight, kThinnest = 0.004f;

	// ------------------------------------------------------------------------------------------
	// Text: EB Garamond for the text, Cinzel for the first letter and the title page, as the overlay's own
	// ------------------------------------------------------------------------------------------

	// A page as it's written: 768 by 1080, the parchment's shape
	constexpr int kPageW = 768, kPageH = 1080;
	constexpr int kTop = 100, kBottom = 116, kInner = 74, kOuter = 60;
	constexpr float kTextPx = 31.f, kLineH = 41.f, kIndent = 34.f;
	constexpr int kDropLines = 3;

	struct Face
	{
		stbtt_fontinfo info{};
		bool ok = false;
	};

	struct Glyph
	{
		int w = 0, h = 0, x0 = 0, y0 = 0;
		std::vector<uint8_t> coverage;
	};

	std::mutex g_fontLock;
	Face g_serif, g_title;
	std::map<std::tuple<int, int, int>, Glyph> g_glyphs;   // face, pixel size x 10, codepoint

	bool Fonts()
	{
		std::lock_guard<std::mutex> hold(g_fontLock);
		if (!g_serif.ok)
		{
			const std::string_view serif = EmbeddedFile(POTP_RES_FONT_SERIF), title = EmbeddedFile(POTP_RES_FONT_TITLE);
			g_serif.ok = !serif.empty() && stbtt_InitFont(&g_serif.info, reinterpret_cast<const unsigned char*>(serif.data()), stbtt_GetFontOffsetForIndex(reinterpret_cast<const unsigned char*>(serif.data()), 0));
			g_title.ok = !title.empty() && stbtt_InitFont(&g_title.info, reinterpret_cast<const unsigned char*>(title.data()), stbtt_GetFontOffsetForIndex(reinterpret_cast<const unsigned char*>(title.data()), 0));
		}
		return g_serif.ok && g_title.ok;
	}

	Face& FaceOf(int face) { return face == 0 ? g_serif : g_title; }

	// Next codepoint from UTF-8
	uint32_t NextCodepoint(const std::string& s, size_t& i)
	{
		const unsigned char c = static_cast<unsigned char>(s[i]);
		uint32_t cp = c;
		int more = 0;
		if (c >= 0xF0) { cp = c & 0x07; more = 3; }
		else if (c >= 0xE0) { cp = c & 0x0F; more = 2; }
		else if (c >= 0xC0) { cp = c & 0x1F; more = 1; }
		++i;
		for (; more > 0 && i < s.size(); --more, ++i)
			cp = (cp << 6) | (static_cast<unsigned char>(s[i]) & 0x3F);
		return cp;
	}

	float Advance(int face, float px, uint32_t cp, uint32_t next)
	{
		Face& f = FaceOf(face);
		const float scale = stbtt_ScaleForPixelHeight(&f.info, px);
		int advance = 0, bearing = 0;
		stbtt_GetCodepointHMetrics(&f.info, static_cast<int>(cp), &advance, &bearing);
		float a = advance * scale;
		if (next)
			a += stbtt_GetCodepointKernAdvance(&f.info, static_cast<int>(cp), static_cast<int>(next)) * scale;
		return a;
	}

	float Measure(int face, float px, const std::string& text)
	{
		std::lock_guard<std::mutex> hold(g_fontLock);
		float w = 0.f;
		for (size_t i = 0; i < text.size();)
		{
			const uint32_t cp = NextCodepoint(text, i);
			size_t j = i;
			const uint32_t next = i < text.size() ? NextCodepoint(text, j) : 0;
			w += Advance(face, px, cp, next);
		}
		return w;
	}

	const Glyph& GlyphOf(int face, float px, uint32_t cp)
	{
		const auto key = std::make_tuple(face, static_cast<int>(px * 10.f), static_cast<int>(cp));
		const auto found = g_glyphs.find(key);
		if (found != g_glyphs.end())
			return found->second;
		Glyph g;
		Face& f = FaceOf(face);
		const float scale = stbtt_ScaleForPixelHeight(&f.info, px);
		unsigned char* bits = stbtt_GetCodepointBitmap(&f.info, scale, scale, static_cast<int>(cp), &g.w, &g.h, &g.x0, &g.y0);
		if (bits)
		{
			g.coverage.assign(bits, bits + static_cast<size_t>(g.w) * g.h);
			stbtt_FreeBitmap(bits, nullptr);
		}
		return g_glyphs.emplace(key, std::move(g)).first->second;
	}

	int Ascent(int face, float px)
	{
		Face& f = FaceOf(face);
		int ascent = 0, descent = 0, gap = 0;
		stbtt_GetFontVMetrics(&f.info, &ascent, &descent, &gap);
		return static_cast<int>(ascent * stbtt_ScaleForPixelHeight(&f.info, px) + 0.5f);
	}

	// How tall a capital stands at this size, in pixels: its H, from the baseline up
	float CapHeight(int face, float px)
	{
		Face& f = FaceOf(face);
		int x0 = 0, y0 = 0, x1 = 0, y1 = 0;
		stbtt_GetCodepointBox(&f.info, 'H', &x0, &y0, &x1, &y1);
		return y1 * stbtt_ScaleForPixelHeight(&f.info, px);
	}

	// The drop cap's size: a capital that stands from the third line's baseline to the top of the first line's capitals,
	// as a printer sets a three-line initial
	float DropPx()
	{
		const float wanted = (kDropLines - 1) * kLineH + CapHeight(0, kTextPx);
		return wanted / std::max(1.f, CapHeight(1, 100.f)) * 100.f;
	}

	struct Ink { uint8_t r, g, b; float strength; };
	constexpr Ink kInk{ 38, 25, 14, 0.94f }, kRed{ 122, 28, 18, 0.95f }, kFaint{ 70, 52, 34, 0.8f };

	// Text onto the page, its baseline at y
	void Write(GameTexture& page, int face, float px, float x, float baseline, const std::string& text, Ink ink)
	{
		std::lock_guard<std::mutex> hold(g_fontLock);
		for (size_t i = 0; i < text.size();)
		{
			const uint32_t cp = NextCodepoint(text, i);
			size_t j = i;
			const uint32_t next = i < text.size() ? NextCodepoint(text, j) : 0;
			const Glyph& g = GlyphOf(face, px, cp);
			const int gx = static_cast<int>(std::floor(x)) + g.x0, gy = static_cast<int>(std::floor(baseline)) + g.y0;
			for (int y = 0; y < g.h; ++y)
				for (int xx = 0; xx < g.w; ++xx)
				{
					const int X = gx + xx, Y = gy + y;
					if (X < 0 || Y < 0 || X >= static_cast<int>(page.width) || Y >= static_cast<int>(page.height))
						continue;
					const float a = g.coverage[static_cast<size_t>(y) * g.w + xx] / 255.f * ink.strength;
					if (a <= 0.f)
						continue;
					uint8_t* p = &page.pixels[static_cast<size_t>(Y) * page.rowBytes + X * 4];
					p[0] = static_cast<uint8_t>(p[0] + (ink.r - p[0]) * a);
					p[1] = static_cast<uint8_t>(p[1] + (ink.g - p[1]) * a);
					p[2] = static_cast<uint8_t>(p[2] + (ink.b - p[2]) * a);
				}
			x += Advance(face, px, cp, next);
		}
	}

	// A thin rule with a diamond in its middle, as a printer's flourish
	void Flourish(GameTexture& page, int cx, int cy, int half, Ink ink)
	{
		const auto dot = [&](int x, int y, float a)
		{
			if (x < 0 || y < 0 || x >= static_cast<int>(page.width) || y >= static_cast<int>(page.height))
				return;
			uint8_t* p = &page.pixels[static_cast<size_t>(y) * page.rowBytes + x * 4];
			a *= ink.strength;
			p[0] = static_cast<uint8_t>(p[0] + (ink.r - p[0]) * a);
			p[1] = static_cast<uint8_t>(p[1] + (ink.g - p[1]) * a);
			p[2] = static_cast<uint8_t>(p[2] + (ink.b - p[2]) * a);
		};
		for (int x = -half; x <= half; ++x)
		{
			const float fade = 1.f - std::abs(x) / static_cast<float>(half + 1);
			if (std::abs(x) > 12)
				dot(cx + x, cy, fade * 0.9f);
		}
		for (int y = -9; y <= 9; ++y)
			for (int x = -9; x <= 9; ++x)
			{
				const float d = std::abs(x) + std::abs(y) * 1.0f;
				if (d <= 9.f)
					dot(cx + x, cy + y, std::clamp(9.5f - d, 0.f, 1.f));
			}
	}

	// ------------------------------------------------------------------------------------------
	// Layout: the text into lines, the lines into pages
	// ------------------------------------------------------------------------------------------

	struct Line
	{
		std::vector<std::string> words;
		float x = 0.f, width = 0.f;   // where it starts, from the text's left edge, and the room it has
		bool justify = false;
	};

	struct Page
	{
		std::vector<Line> lines;
		bool dropCap = false;
		std::string drop;    // the first letter, when this page starts the text
	};

	struct Book
	{
		std::string title, section;
		std::vector<Page> pages;   // the text's pages: the book's page 1 is the title page, then these
		int Count() const { return 1 + static_cast<int>(pages.size()); }
	};

	std::mutex g_bookLock;
	std::map<std::string, std::shared_ptr<const Book>> g_books;

	std::vector<std::string> Words(const std::string& text)
	{
		std::vector<std::string> out;
		std::string word;
		for (const char c : text)
			if (c == ' ' || c == '\t' || c == '\n' || c == '\r')
			{
				if (!word.empty())
					out.push_back(std::move(word));
				word.clear();
			}
			else
				word += c;
		if (!word.empty())
			out.push_back(std::move(word));
		return out;
	}

	std::shared_ptr<const Book> Lay(const std::string& title, const std::string& section, const std::vector<std::string>& paragraphs)
	{
		auto book = std::make_shared<Book>();
		book->title = title;
		book->section = section;
		if (!Fonts())
			return book;
		const float textW = static_cast<float>(kPageW - kInner - kOuter);
		const int linesPerPage = static_cast<int>((kPageH - kTop - kBottom) / kLineH);
		const float space = Measure(0, kTextPx, " ");
		std::vector<Line> lines;
		std::vector<int> paragraphStarts;
		std::string drop;
		float dropW = 0.f;
		bool first = true;
		for (const std::string& paragraph : paragraphs)
		{
			std::vector<std::string> words = Words(paragraph);
			if (words.empty())
				continue;
			if (first)
			{
				// The first letter large, in red, three lines deep; the rest of its word goes on as usual
				size_t i = 0;
				NextCodepoint(words[0], i);
				drop = words[0].substr(0, i);
				words[0] = words[0].substr(i);
				dropW = Measure(1, DropPx(), drop) + 12.f;
				if (words[0].empty())
					words.erase(words.begin());
			}
			paragraphStarts.push_back(static_cast<int>(lines.size()));
			Line line;
			const auto lineStart = [&](int index)
			{
				Line l;
				if (first && index < kDropLines)
					l.x = dropW;
				else if (!first && index == 0)
					l.x = kIndent;
				l.width = textW - l.x;
				return l;
			};
			int index = 0;
			line = lineStart(index);
			float used = 0.f;
			// A word wider than a line (a long name, or text that came without its spaces) is split to fit
			std::vector<std::string> fitted;
			for (const std::string& word : words)
			{
				if (Measure(0, kTextPx, word) <= textW - kIndent)
				{
					fitted.push_back(word);
					continue;
				}
				std::string piece;
				for (size_t i = 0; i < word.size();)
				{
					const size_t from = i;
					NextCodepoint(word, i);
					const std::string next = piece + word.substr(from, i - from);
					if (!piece.empty() && Measure(0, kTextPx, next) > textW - kIndent - dropW)
					{
						fitted.push_back(piece);
						piece = word.substr(from, i - from);
					}
					else
						piece = next;
				}
				if (!piece.empty())
					fitted.push_back(piece);
			}
			for (const std::string& word : fitted)
			{
				const float w = Measure(0, kTextPx, word);
				if (!line.words.empty() && used + space + w > line.width)
				{
					line.justify = true;
					lines.push_back(std::move(line));
					line = lineStart(++index);
					used = 0.f;
				}
				used += (line.words.empty() ? 0.f : space) + w;
				line.words.push_back(word);
			}
			if (!line.words.empty())
				lines.push_back(std::move(line));
			first = false;
		}
		// Into pages, the first carrying the drop cap
		for (size_t at = 0; at < lines.size(); at += linesPerPage)
		{
			Page page;
			page.lines.assign(lines.begin() + static_cast<ptrdiff_t>(at), lines.begin() + static_cast<ptrdiff_t>(std::min(lines.size(), at + linesPerPage)));
			if (at == 0 && !drop.empty())
			{
				page.dropCap = true;
				page.drop = drop;
			}
			book->pages.push_back(std::move(page));
		}
		return book;
	}

	// ------------------------------------------------------------------------------------------
	// Writing a page: the parchment, then the text, or the title page, or nothing past the end
	// ------------------------------------------------------------------------------------------

	bool ParchmentPage(GameTexture& out)
	{
		static std::mutex lock;
		static GameTexture plain;
		std::lock_guard<std::mutex> hold(lock);
		if (plain.pixels.empty() && !Decode(POTP_RES_PARCHMENT, kPageH, plain))
			return false;
		out = plain;
		out.lowerMips.clear();
		return true;
	}

	// The page darkening as it curves down into the binding: the renderer has no shadow of its own for the V
	void ShadeGutter(GameTexture& page, bool left)
	{
		constexpr float kReach = 110.f;
		for (uint32_t x = 0; x < page.width; ++x)
		{
			const float d = static_cast<float>(left ? page.width - 1 - x : x);
			if (d >= kReach)
				continue;
			const float t = d / kReach;
			const float keep = 0.62f + 0.38f * t * t * (3.f - 2.f * t);
			for (uint32_t y = 0; y < page.height; ++y)
			{
				uint8_t* p = &page.pixels[static_cast<size_t>(y) * page.rowBytes + x * 4];
				for (int c = 0; c < 3; ++c)
					p[c] = static_cast<uint8_t>(p[c] * keep);
			}
		}
	}

	// The paper in the book's look (below, after LookOf): its colour and spots before the text, its stains after
	void AgePaper(const std::string& uuid, int n, GameTexture& page, bool overText);

	// The text of the book's page n (0 the title page) on its paper. Left pages (even) have their wide margin to the
	// right, by the spine.
	void WriteText(const Book* book, int n, GameTexture& out)
	{
		if (!book || !Fonts())
			return;
		const bool left = n % 2 == 0;
		const float x0 = static_cast<float>(left ? kOuter : kInner);
		const float textW = static_cast<float>(kPageW - kInner - kOuter);
		if (n == 0)
		{
			// The title page: the book's name in capitals, wrapped and centred, a flourish, and the shelf it's on
			std::vector<std::string> lines;
			std::string line;
			for (const std::string& word : Words(book->title))
			{
				const std::string tried = line.empty() ? word : line + " " + word;
				if (!line.empty() && Measure(1, 40.f, tried) > textW - 40.f)
				{
					lines.push_back(line);
					line = word;
				}
				else
					line = tried;
			}
			if (!line.empty())
				lines.push_back(line);
			const float lineH = 56.f;
			float y = kPageH * 0.36f - lines.size() * lineH * 0.5f + Ascent(1, 40.f);
			for (const std::string& l : lines)
			{
				Write(out, 1, 40.f, x0 + (textW - Measure(1, 40.f, l)) * 0.5f, y, l, kInk);
				y += lineH;
			}
			Flourish(out, static_cast<int>(x0 + textW * 0.5f), static_cast<int>(y + 6.f), 150, kRed);
			if (!book->section.empty())
				Write(out, 0, 26.f, x0 + (textW - Measure(0, 26.f, book->section)) * 0.5f, y + 70.f, book->section, kFaint);
			return;
		}
		const int index = n - 1;
		if (index >= static_cast<int>(book->pages.size()))
		{
			// Past the end: blank, but for a flourish on the page after the last
			if (index == static_cast<int>(book->pages.size()))
				Flourish(out, static_cast<int>(x0 + textW * 0.5f), kPageH / 3, 90, kFaint);
			return;
		}
		const Page& page = book->pages[index];
		const float space = Measure(0, kTextPx, " ");
		float baseline = static_cast<float>(kTop) + Ascent(0, kTextPx);
		if (page.dropCap)
		{
			const float px = DropPx();
			Write(out, 1, px, x0, static_cast<float>(kTop) + kLineH * (kDropLines - 1) + Ascent(0, kTextPx), page.drop, kRed);
		}
		for (const Line& line : page.lines)
		{
			float x = x0 + line.x;
			float gap = space;
			if (line.justify && line.words.size() > 1)
			{
				float words = 0.f;
				for (const std::string& w : line.words)
					words += Measure(0, kTextPx, w);
				gap = std::min(space * 2.2f, (line.width - words) / (line.words.size() - 1));
			}
			for (const std::string& w : line.words)
			{
				Write(out, 0, kTextPx, x, baseline, w, kInk);
				x += Measure(0, kTextPx, w) + gap;
			}
			baseline += kLineH;
		}
		// Its number, at the foot
		const std::string number = std::to_string(n);
		Write(out, 0, 20.f, x0 + (textW - Measure(0, 20.f, number)) * 0.5f, static_cast<float>(kPageH - 64), number, kFaint);
	}

	// The book's page n: its paper in the book's look, the text, then the stains over it
	bool WritePage(const std::string& uuid, const Book* book, int n, GameTexture& out)
	{
		if (!ParchmentPage(out))
			return false;
		AgePaper(uuid, n, out, false);
		ShadeGutter(out, n % 2 == 0);
		WriteText(book, n, out);
		AgePaper(uuid, n, out, true);
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// Each book's look: its leather's dye, its tooling and its corners, chosen from its id, so a book always looks the
	// same and no two on the shelf match. The atlas is recoloured for it (WriteLookMap) with the masks bake_masks.py
	// made: how much of the dye each pixel holds, and where the gilt and the brass are.
	// ------------------------------------------------------------------------------------------

	constexpr float kOxblood[3] = { 0.030f, 0.0095f, 0.0062f };   // texture_book.py's OXBLOOD, linear: book_d's dye
	constexpr float kDyeScale = 1.7f;                               // book_m's red holds a / 1.7

	enum Tooling { kToolGilt, kToolBlind, kToolSilver };   // gold leaf, pressed with no leaf, or silver
	enum Metal { kMetalBrass, kMetalIron, kMetalSilver };  // the corners

	// Each book's title and shelf, as the Library gives them (BookSetTitle)
	std::mutex g_titleLock;
	std::map<std::string, std::string> g_titles;
	std::map<std::string, int> g_shelves;

	std::string TitleOf(const std::string& uuid)
	{
		std::lock_guard<std::mutex> hold(g_titleLock);
		const auto found = g_titles.find(uuid);
		return found == g_titles.end() ? std::string() : found->second;
	}

	int ShelfOf(const std::string& uuid)
	{
		std::lock_guard<std::mutex> hold(g_titleLock);
		const auto found = g_shelves.find(uuid);
		return found == g_shelves.end() ? 0 : found->second;
	}

	// Kinds of book, and the bindings each tends to: what its leathers are, its tooling and corners, how old and how
	// knocked about. A book is of the first kind with a word in its id (the game's own item name, in English) or its
	// title; else a monster tome by its shelf; else a plain lore book. Weights in kDyes' order.
	struct Kind
	{
		const char* words[14];
		float dyes[9];        // oxblood, calf, tan, black, green, navy, plum, ochre, grey green
		float gilt, blind;    // the rest silver
		float brass, iron;    // the rest silver
		float age;            // added to its age
		float water, scorch, mould;   // times the chance of each
	};

	const Kind kKinds[] = {
		// The Empire's: black and gold, kept well
		{ { "nilfgaard", "emperor", "empire", "emhyr", "vicovaro" }, { 0, 0, 0, 10, 0, 1, 0, 0, 0 }, 0.95f, 0.f, 0.9f, 0.f, -0.25f, 0.4f, 0.4f, 0.4f },
		// Alchemy and herbs: greens and ochres, stained and damp
		{ { "alchem", "potion", "elixir", "herb", "mutagen", "decoction", "formula", "apothecar", "toxic" }, { 1, 2, 1, 1, 5, 0, 0, 3, 4 }, 0.5f, 0.35f, 0.5f, 0.4f, 0.f, 1.6f, 1.f, 2.f },
		// Skellige: plain hide, silver and iron, sea-wet
		{ { "skellig", "isles", "craite", "hindarsfjall", "freya", "svalblod", "undvik" }, { 1, 4, 4, 1, 1, 1, 0, 0, 1 }, 0.3f, 0.3f, 0.2f, 0.5f, 0.05f, 1.6f, 1.f, 1.f },
		// Faith: oxblood and plum, gilt
		{ { "melitele", "eternal fire", "lebioda", "prophet", "temple", "church", "faith", "kreve", "coram", "prayer" }, { 5, 1, 0, 1, 0, 1, 4, 0, 0 }, 0.85f, 0.05f, 0.7f, 0.2f, 0.f, 1.f, 1.f, 1.f },
		// The Elder Races and magic: pale leathers, silver, very old
		{ { "elder", "elven", "elves", "aen ", "ichaer", "aelirenn", "conjunction", "sorcer", "magic", "lodge", "chaos", "dwarv", "gnom" }, { 0, 1, 3, 0, 1, 2, 1, 2, 1 }, 0.45f, 0.1f, 0.3f, 0.1f, 0.15f, 1.f, 1.f, 1.f },
		// Toussaint, chivalry and verse: navy and plum, gilt, young
		{ { "toussaint", "beauclair", "knight", "chivalr", "duchess", "romance", "poem", "ballad", "verse", "noble" }, { 2, 0, 1, 0, 0, 4, 4, 0, 0 }, 0.9f, 0.f, 0.8f, 0.f, -0.15f, 0.6f, 0.6f, 0.6f },
		// War and the Northern Kingdoms: hard-used calf and black, iron, scorched
		{ { "warfare", " war", "_war", "arms", "tactic", "army", "temeria", "redania", "kaedwen", "battle", "siege", "soldier" }, { 2, 4, 2, 3, 1, 0, 0, 0, 2 }, 0.5f, 0.4f, 0.3f, 0.6f, 0.1f, 1.f, 1.8f, 1.f },
		// Monsters: dark and rough, iron, old, burnt and damp
		{ { "beast", "bestiar", "monster", "vampir", "necrophag", "wraith", "spectre", "specter", "curse", "draconid", "relict", "ogroid" }, { 3, 5, 1, 4, 2, 0, 0, 0, 3 }, 0.4f, 0.45f, 0.3f, 0.6f, 0.2f, 1.4f, 2.5f, 1.5f },
		// A lore book
		{ {}, { 4, 4, 2, 3, 3, 2, 2, 1, 1 }, 0.68f, 0.22f, 0.6f, 0.28f, 0.f, 1.f, 1.f, 1.f },
	};
	constexpr int kKindMonster = 7, kKindLore = 8;

	const Kind& KindOf(const std::string& uuid)
	{
		std::string text = uuid + " " + TitleOf(uuid);
		for (char& c : text)
			c = static_cast<char>(tolower(static_cast<unsigned char>(c)));
		for (int k = 0; k < kKindLore; ++k)
			for (const char* word : kKinds[k].words)
				if (word && text.find(word) != std::string::npos)
					return kKinds[k];
		return kKinds[ShelfOf(uuid) == 1 ? kKindMonster : kKindLore];
	}

	// A mark on the cover, a water stain or a scorch: where on the unrolled binding (Binding), and how large
	struct Mark
	{
		bool on = false;
		float w = 0.f, y = 0.f, radius = 0.f;
	};

	struct Look
	{
		float dye[3];
		Tooling tooling;
		Metal corners;
		float age = 0.f;          // 0 hardly handled, 1 falling apart: wear, rubbed edges, grime, the gilt rubbed off
		uint32_t seed = 0;        // where the wear falls
		Mark water, scorch;
		float mould = 0.f;        // how much of the cover has mildew on it, 0 none
		float sunned = 0.f;       // the spine faded by the light, as one on a shelf is
		// The hide's own character, which the atlas is baked without (texture_book.py's CLEAN), so each book's lies where
		// its own does: its patterns turned by angle, the mottle of its tone, stains soaked into it, the faint tide lines of
		// an old wetting all over it, a craquelure in patches, and its finish, added to its roughness
		float angle = 0.f;
		float toneScale = 14.f, tone = 1.f;
		float stainScale = 9.f, stain = 0.5f;
		float tideScale = 5.f, tides = 0.f;
		float cracks = 0.f;
		float finish = 0.f;
		float paper[3] = { 1.f, 1.f, 1.f };   // the paper's colour, times the parchment's, linear
		// The paper's own character: clouded in the sheet, blotched, laid (the lines of the mould it was made on: laid lines
		// laidGap apart, chain lines chainGap apart), and specks of what was in the pulp. Each sheet clouded its own way.
		float cloud = 0.05f, cloudScale = 14.f;
		float blotch = 0.f, blotchScale = 8.f;
		float laid = 0.f, laidGap = 0.001f, chainGap = 0.025f, chainAt = 0.f;
		float specks = 0.f;
	};

	// FNV-1a over the id, then the salt mixed in by murmur3's finish, so ids alike but for their ends differ in every choice
	uint32_t Hash(const std::string& text, uint32_t salt)
	{
		uint32_t h = 2166136261u;
		for (const char ch : text)
			h = (h ^ static_cast<uint8_t>(ch)) * 16777619u;
		h ^= salt * 0x9E3779B9u;
		h ^= h >> 16;
		h *= 0x85ebca6bu;
		h ^= h >> 13;
		h *= 0xc2b2ae35u;
		h ^= h >> 16;
		return h;
	}

	float Unit(uint32_t h) { return (h >> 8) / 16777216.f; }

	// The unrolled binding: w across it, the front board's edge -kEdgeW, the spine 0, the back board's edge +kEdgeW; y up it
	constexpr float kEdgeW = 0.265f, kEdgeY = 0.175f;

	// A point on the binding's edge, where the wet or the fire came in: a corner more often than not
	Mark MarkAt(const std::string& uuid, uint32_t salt, float smallest, float largest)
	{
		Mark m;
		m.on = true;
		const float side = Unit(Hash(uuid, salt)), along = Unit(Hash(uuid, salt + 1)) * 2.f - 1.f;
		const float corner = along < 0.f ? -1.f : 1.f;
		const float t = std::abs(along) > 0.5f ? corner : along;   // half of them right in a corner
		if (side < 0.5f)
		{
			m.w = (side < 0.25f ? -kEdgeW : kEdgeW);
			m.y = t * kEdgeY;
		}
		else
		{
			m.w = t * kEdgeW;
			m.y = side < 0.75f ? -kEdgeY : kEdgeY;
		}
		m.radius = smallest + (largest - smallest) * Unit(Hash(uuid, salt + 2));
		return m;
	}

	Look LookOf(const std::string& uuid)
	{
		Look look{ { kOxblood[0], kOxblood[1], kOxblood[2] }, kToolGilt, kMetalBrass };
		if (uuid.empty())
			return look;
		// Leathers a binder had, linear, about as dark as the oxblood; how likely each is the book's kind's (kKinds)
		const Kind& kind = KindOf(uuid);
		static constexpr float kDyes[9][3] = {
			{ 0.030f, 0.0095f, 0.0062f },   // oxblood
			{ 0.040f, 0.022f, 0.012f },     // undyed calf
			{ 0.068f, 0.039f, 0.019f },     // tan
			{ 0.0085f, 0.0078f, 0.0072f },  // black
			{ 0.011f, 0.019f, 0.011f },     // forest green
			{ 0.010f, 0.012f, 0.025f },     // navy, faded
			{ 0.024f, 0.008f, 0.015f },     // plum
			{ 0.058f, 0.041f, 0.014f },     // ochre
			{ 0.027f, 0.029f, 0.021f },     // grey green
		};
		float total = 0.f;
		for (const float weight : kind.dyes)
			total += weight;
		float pick = Unit(Hash(uuid, 1)) * total;
		const float* chosen = kDyes[0];
		for (int d = 0; d < 9; ++d)
		{
			if (kind.dyes[d] <= 0.f)
				continue;
			chosen = kDyes[d];
			if ((pick -= kind.dyes[d]) < 0.f)
				break;
		}
		// Each skin a little lighter or darker, a little warmer or cooler, than the next
		const float light = 0.8f + 0.45f * Unit(Hash(uuid, 2));
		for (int k = 0; k < 3; ++k)
			look.dye[k] = chosen[k] * light * (0.92f + 0.16f * Unit(Hash(uuid, 10 + k)));
		const float tooling = Unit(Hash(uuid, 3)), corners = Unit(Hash(uuid, 4));
		look.tooling = tooling < kind.gilt ? kToolGilt : tooling < kind.gilt + kind.blind ? kToolBlind : kToolSilver;
		look.corners = corners < kind.brass ? kMetalBrass : corners < kind.brass + kind.iron ? kMetalIron : kMetalSilver;
		// Its life since: most books well used, a few nearly new, a few ruined
		look.age = std::clamp(0.1f + 0.9f * std::pow(Unit(Hash(uuid, 5)), 0.75f) + kind.age, 0.05f, 1.f);
		look.seed = Hash(uuid, 6);
		if (Unit(Hash(uuid, 20)) < 0.4f * kind.water)
			look.water = MarkAt(uuid, 21, 0.07f, 0.2f);
		if (Unit(Hash(uuid, 30)) < 0.14f * kind.scorch)
			look.scorch = MarkAt(uuid, 31, 0.03f, 0.08f);
		if (Unit(Hash(uuid, 40)) < 0.2f * kind.mould)
			look.mould = 0.4f + 0.6f * Unit(Hash(uuid, 41));
		if (Unit(Hash(uuid, 50)) < 0.35f)
			look.sunned = 0.35f + 0.5f * Unit(Hash(uuid, 51));
		// The hide's character
		look.angle = Unit(Hash(uuid, 70)) * 6.2832f;
		look.toneScale = 7.f + 16.f * Unit(Hash(uuid, 71));
		look.tone = 0.35f + 0.95f * Unit(Hash(uuid, 72));
		look.stainScale = 5.f + 10.f * Unit(Hash(uuid, 73));
		look.stain = Unit(Hash(uuid, 74)) < 0.7f ? (0.25f + 0.75f * Unit(Hash(uuid, 75))) * (0.5f + look.age) : 0.f;
		if (Unit(Hash(uuid, 76)) < 0.3f * kind.water)
		{
			look.tides = 0.5f + 0.5f * Unit(Hash(uuid, 77));
			look.tideScale = 3.f + 5.f * Unit(Hash(uuid, 78));
		}
		if (Unit(Hash(uuid, 79)) < 0.1f + 0.55f * look.age * look.age)
			look.cracks = 0.4f + 0.6f * Unit(Hash(uuid, 80));
		look.finish = (Unit(Hash(uuid, 81)) - 0.5f) * 0.24f;
		// Its paper, of the kinds a binder had; the cheaper and the browned ones likelier the older the book
		struct Paper
		{
			float tint[3];
			float young, old;      // how likely, in a new book and an old one
			float cloud, blotch;   // how clouded and blotched the sheets of it are, most
			float laid, specks;    // how likely it's laid, how specked
		};
		static const Paper kPapers[] = {
			{ { 1.f, 1.f, 1.f }, 4, 3, 0.14f, 0.5f, 0.3f, 0.2f },          // cream, as the parchment is
			{ { 1.07f, 1.04f, 0.9f }, 3, 2, 0.12f, 0.4f, 0.5f, 0.1f },     // ivory
			{ { 1.2f, 1.2f, 1.17f }, 3, 0.5f, 0.07f, 0.2f, 0.6f, 0.1f },   // a good white rag
			{ { 1.06f, 1.1f, 1.22f }, 3, 1, 0.12f, 0.4f, 0.4f, 0.3f },     // grey-white
			{ { 0.9f, 1.f, 1.2f }, 1.5f, 1, 0.14f, 0.4f, 0.4f, 0.3f },     // blue-grey
			{ { 0.9f, 1.02f, 0.84f }, 1, 1, 0.16f, 0.5f, 0.3f, 0.4f },        // green-grey
			{ { 1.1f, 0.94f, 0.9f }, 1, 0.5f, 0.12f, 0.4f, 0.5f, 0.2f },  // a rose rag
			{ { 1.05f, 0.95f, 0.68f }, 1, 4, 0.18f, 0.8f, 0.3f, 0.3f },     // yellowed
			{ { 0.85f, 0.72f, 0.52f }, 0.3f, 2.5f, 0.22f, 0.9f, 0.2f, 0.4f },  // toasted brown
			{ { 1.02f, 0.9f, 0.74f }, 1, 2, 0.4f, 1.f, 0.f, 0.f },        // vellum: skin, heavily clouded, no mould's lines
			{ { 0.8f, 0.79f, 0.74f }, 1, 2, 0.18f, 0.6f, 0.f, 1.f },        // a cheap grey pulp, full of specks
		};
		float paperTotal = 0.f;
		for (const Paper& p : kPapers)
			paperTotal += p.young + (p.old - p.young) * look.age;
		float paperPick = Unit(Hash(uuid, 60)) * paperTotal;
		const Paper* paperOf = &kPapers[0];
		for (const Paper& p : kPapers)
		{
			paperOf = &p;
			if ((paperPick -= p.young + (p.old - p.young) * look.age) < 0.f)
				break;
		}
		const float jitter = 0.94f + 0.1f * Unit(Hash(uuid, 61));
		for (int k = 0; k < 3; ++k)
			look.paper[k] = paperOf->tint[k] * jitter * (0.97f + 0.06f * Unit(Hash(uuid, 62 + k)));
		look.cloud = paperOf->cloud * (0.3f + 0.7f * Unit(Hash(uuid, 65)));
		look.cloudScale = 6.f + 26.f * Unit(Hash(uuid, 66));
		look.blotch = Unit(Hash(uuid, 67)) < 0.75f ? paperOf->blotch * (0.3f + 0.7f * Unit(Hash(uuid, 68))) * (0.4f + look.age) : 0.f;
		look.blotchScale = 4.f + 10.f * Unit(Hash(uuid, 69));
		if (Unit(Hash(uuid, 90)) < paperOf->laid)
		{
			look.laid = 0.5f + 0.5f * Unit(Hash(uuid, 91));
			look.laidGap = 0.0008f + 0.0006f * Unit(Hash(uuid, 92));
			look.chainGap = 0.02f + 0.012f * Unit(Hash(uuid, 93));
			look.chainAt = Unit(Hash(uuid, 94)) * look.chainGap;
		}
		look.specks = paperOf->specks * Unit(Hash(uuid, 95));
		return look;
	}

	float ToLinear(uint8_t v)
	{
		static const auto table = [] { std::array<float, 256> t{}; for (int i = 0; i < 256; ++i) { const float c = i / 255.f; t[i] = c <= 0.04045f ? c / 12.92f : std::pow((c + 0.055f) / 1.055f, 2.4f); } return t; }();
		return table[v];
	}

	uint8_t ToSrgb(float v)
	{
		static const auto table = [] { std::array<uint8_t, 4096> t{}; for (int i = 0; i < 4096; ++i) { const float c = i / 4095.f; t[i] = static_cast<uint8_t>(std::clamp((c <= 0.0031308f ? c * 12.92f : 1.055f * std::pow(c, 1.f / 2.4f) - 0.055f) * 255.f + 0.5f, 0.f, 255.f)); } return t; }();
		return table[static_cast<size_t>(std::clamp(v, 0.f, 1.f) * 4095.f + 0.5f)];
	}

	// A metal's specular colour, sRGB, as another metal: its brightness kept, its colour that metal's
	void AsMetal(uint8_t* p, Metal metal)
	{
		const float lum = 0.2126f * ToLinear(p[0]) + 0.7152f * ToLinear(p[1]) + 0.0722f * ToLinear(p[2]);
		static constexpr float kIron[3] = { 0.52f, 0.52f, 0.55f }, kSilver[3] = { 1.3f, 1.3f, 1.36f };
		const float* tint = metal == kMetalIron ? kIron : kSilver;
		for (int k = 0; k < 3; ++k)
			p[k] = ToSrgb(lum * tint[k]);
	}

	// A smooth value noise, 0 to 1, and three octaves of it, for where the wear falls
	float LookNoise(float x, float y, uint32_t seed)
	{
		const auto hash = [seed](int i, int j) { uint32_t h = static_cast<uint32_t>(i) * 374761393u + static_cast<uint32_t>(j) * 668265263u + seed * 2654435761u; h = (h ^ (h >> 13)) * 1274126177u; return (h ^ (h >> 16)) / 4294967295.f; };
		const int i = static_cast<int>(std::floor(x)), j = static_cast<int>(std::floor(y));
		float u = x - i, v = y - j;
		u = u * u * (3 - 2 * u);
		v = v * v * (3 - 2 * v);
		return (hash(i, j) * (1 - u) + hash(i + 1, j) * u) * (1 - v) + (hash(i, j + 1) * (1 - u) + hash(i + 1, j + 1) * u) * v;
	}

	float Fbm(float x, float y, uint32_t seed)
	{
		return (LookNoise(x, y, seed) * 0.57f + LookNoise(x * 2.1f, y * 2.1f, seed + 1) * 0.29f + LookNoise(x * 4.3f, y * 4.3f, seed + 2) * 0.14f);
	}

	float Smooth(float edge0, float edge1, float x)
	{
		const float t = std::clamp((x - edge0) / (edge1 - edge0), 0.f, 1.f);
		return t * t * (3.f - 2.f * t);
	}

	// Cells, as cracked leather's: how far a point is from the edge between its cell and the next, in cells, 0 on it
	float CellEdge(float x, float y, uint32_t seed)
	{
		const int i = static_cast<int>(std::floor(x)), j = static_cast<int>(std::floor(y));
		float first = 9.f, second = 9.f;
		for (int dj = -1; dj <= 1; ++dj)
			for (int di = -1; di <= 1; ++di)
			{
				uint32_t h = static_cast<uint32_t>(i + di) * 374761393u + static_cast<uint32_t>(j + dj) * 668265263u + seed * 2654435761u;
				h = (h ^ (h >> 13)) * 1274126177u;
				h ^= h >> 16;
				const float px = i + di + Unit(h), py = j + dj + Unit(h * 747796405u + 2891336453u);
				const float d = std::hypot(px - x, py - y);
				if (d < first)
				{
					second = first;
					first = d;
				}
				else if (d < second)
					second = d;
			}
		return (second - first) * 0.5f;
	}

	// The atlas's three maps as they're built in, read once
	struct Atlas
	{
		GameTexture diffuse, specular, normal, mask;   // normal: roughness in its alpha
		bool ok = false;
	};

	const Atlas& BaseAtlas()
	{
		static std::mutex lock;
		static Atlas atlas;
		static bool tried = false;
		std::lock_guard<std::mutex> hold(lock);
		if (!tried)
		{
			tried = true;
			GameTexture rough;
			atlas.ok = Decode(POTP_RES_BOOK_DIFFUSE, 1024, atlas.diffuse) && Decode(POTP_RES_BOOK_SPECULAR, 1024, atlas.specular)
				&& Decode(POTP_RES_BOOK_NORMAL, 1024, atlas.normal) && Decode(POTP_RES_BOOK_ROUGHNESS, 1024, rough)
				&& Decode(POTP_RES_BOOK_MASK, 1024, atlas.mask);
			for (const GameTexture* t : { &atlas.specular, &atlas.normal, &rough, &atlas.mask })
				atlas.ok = atlas.ok && t->width == atlas.diffuse.width && t->height == atlas.diffuse.height;
			if (atlas.ok)
				for (size_t i = 3; i < atlas.normal.pixels.size(); i += 4)
					atlas.normal.pixels[i] = rough.pixels[i - 3];
		}
		return atlas;
	}

	// Where each pixel of the atlas lies on the binding unrolled flat (w, y), the open book's parts and the closed one's
	// alike, so a mark on the cover is in the same place whichever is shown. Made once from the mesh: its atlas parts'
	// triangles drawn into the atlas, then spread a few pixels into the margins round each island.
	struct Binding
	{
		int width = 0, height = 0;
		std::vector<float> w, y;      // NaN where no part is
		std::vector<float> spine;     // 1 on the spine, 0 on the boards
	};

	const Binding& BindingOf(int width, int height)
	{
		static std::mutex lock;
		static Binding binding;
		std::lock_guard<std::mutex> hold(lock);
		if (binding.width == width && binding.height == height)
			return binding;
		binding = Binding{};
		binding.width = width;
		binding.height = height;
		const size_t count = static_cast<size_t>(width) * height;
		binding.w.assign(count, NAN);
		binding.y.assign(count, NAN);
		binding.spine.assign(count, 0.f);
		const std::string_view data = EmbeddedFile(POTP_RES_BOOK_MESH);
		if (data.size() < 8 || (memcmp(data.data(), "PBK2", 4) != 0 && memcmp(data.data(), "PBK3", 4) != 0))
			return binding;
		const size_t stride = memcmp(data.data(), "PBK3", 4) == 0 ? 23 : 13;   // floats a vertex
		const char* at = data.data() + 4;
		const char* const end = data.data() + data.size();
		uint32_t parts = 0;
		Take(at, end, parts);
		for (uint32_t p = 0; p < parts; ++p)
		{
			uint8_t nameLength = 0, material = 0;
			if (!Take(at, end, nameLength) || end - at < nameLength)
				break;
			const std::string name(at, nameLength);
			at += nameLength;
			uint32_t vertices = 0, indices = 0;
			if (!Take(at, end, material) || !Take(at, end, vertices) || end - at < static_cast<ptrdiff_t>(vertices * stride * 4))
				break;
			const float* v = reinterpret_cast<const float*>(at);
			at += static_cast<size_t>(vertices) * stride * 4;
			if (!Take(at, end, indices) || end - at < static_cast<ptrdiff_t>(indices) * 4)
				break;
			const uint32_t* index = reinterpret_cast<const uint32_t*>(at);
			at += static_cast<size_t>(indices) * 4;
			if (material != 0)
				continue;
			// The open book lies spread with its spine on x = 0, the front board at -x. The closed one lies shut, its spine
			// at x = -0.13 and its front board on top: its boards unrolled about the spine, the spine itself across its height.
			const bool closed = name.compare(0, 7, "closed_") == 0;
			const auto unroll = [closed](const float* q, float& w, float& onSpine)
			{
				if (!closed)
				{
					w = q[0];
					onSpine = Smooth(0.04f, 0.03f, std::abs(q[0]));
					return;
				}
				constexpr float kSpineX = -0.13f, kMidZ = 0.033f;
				if (q[0] < -0.121f)
				{
					w = -(q[2] - kMidZ) * 0.9f;
					onSpine = 1.f;
				}
				else
				{
					w = q[2] > kMidZ ? -(q[0] - kSpineX) : q[0] - kSpineX;
					onSpine = 0.f;
				}
			};
			for (uint32_t t = 0; t + 2 < indices; t += 3)
			{
				const float* c[3] = { v + index[t] * stride, v + index[t + 1] * stride, v + index[t + 2] * stride };
				float px[3], py[3], ww[3], yy[3], ss[3];
				for (int k = 0; k < 3; ++k)
				{
					px[k] = c[k][10] * width - 0.5f;
					py[k] = c[k][11] * height - 0.5f;
					unroll(c[k], ww[k], ss[k]);
					yy[k] = c[k][1];
				}
				const float area = (px[1] - px[0]) * (py[2] - py[0]) - (px[2] - px[0]) * (py[1] - py[0]);
				if (std::abs(area) < 1e-8f)
					continue;
				const int x0 = std::max(0, static_cast<int>(std::floor(std::min({ px[0], px[1], px[2] })))), x1 = std::min(width - 1, static_cast<int>(std::ceil(std::max({ px[0], px[1], px[2] }))));
				const int y0 = std::max(0, static_cast<int>(std::floor(std::min({ py[0], py[1], py[2] })))), y1 = std::min(height - 1, static_cast<int>(std::ceil(std::max({ py[0], py[1], py[2] }))));
				for (int y = y0; y <= y1; ++y)
					for (int x = x0; x <= x1; ++x)
					{
						const float b1 = ((x - px[0]) * (py[2] - py[0]) - (px[2] - px[0]) * (y - py[0])) / area;
						const float b2 = ((px[1] - px[0]) * (y - py[0]) - (x - px[0]) * (py[1] - py[0])) / area;
						const float b0 = 1.f - b1 - b2;
						if (b0 < -0.01f || b1 < -0.01f || b2 < -0.01f)
							continue;
						const size_t i = static_cast<size_t>(y) * width + x;
						binding.w[i] = b0 * ww[0] + b1 * ww[1] + b2 * ww[2];
						binding.y[i] = b0 * yy[0] + b1 * yy[1] + b2 * yy[2];
						binding.spine[i] = b0 * ss[0] + b1 * ss[1] + b2 * ss[2];
					}
			}
		}
		// Into the margins, as a bake does, so the smaller levels don't take in pixels with no place
		for (int pass = 0; pass < 4; ++pass)
		{
			const std::vector<float> w = binding.w, y = binding.y, s = binding.spine;
			for (int py = 0; py < height; ++py)
				for (int px = 0; px < width; ++px)
				{
					const size_t i = static_cast<size_t>(py) * width + px;
					if (!std::isnan(w[i]))
						continue;
					static constexpr int kStep[4][2] = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } };
					for (const auto& step : kStep)
					{
						const int nx = px + step[0], ny = py + step[1];
						if (nx < 0 || ny < 0 || nx >= width || ny >= height)
							continue;
						const size_t j = static_cast<size_t>(ny) * width + nx;
						if (!std::isnan(w[j]))
						{
							binding.w[i] = w[j];
							binding.y[i] = y[j];
							binding.spine[i] = s[j];
							break;
						}
					}
				}
		}
		return binding;
	}

	// What the years did at one place on the binding: the leather's colour (linear) and roughness changed, the leaf
	// rubbed off. leather: how much of the pixel is the dyed leather (the rest metal, silk or paper).
	struct Wear
	{
		float colour[3];
		float rough;
		float leafLost = 0.f;   // the gilt or silver here rubbed through to the leather, 0 to 1
		float burnt = 0.f;      // charred: any metal here blackened too
	};

	// The hide's own character where the bake left it plain (texture_book.py's CLEAN): its tone mottled, stains soaked in,
	// an old wetting's faint tide lines, and a craquelure in patches, each book's turned and placed its own way
	void Character(const Look& look, float w, float y, float leather, Wear& out)
	{
		if (leather <= 0.f)
			return;
		const uint32_t seed = look.seed;
		const float cs = std::cos(look.angle), sn = std::sin(look.angle);
		const float u = w * cs - y * sn + 3.7f, v = w * sn + y * cs + 1.3f;
		float* c = out.colour;
		// Tone: darker and lighter, as the bake had it at the middle of (0.8 to 1.15 of the dye)
		const float tone = Smooth(0.3f, 0.7f, Fbm(u * look.toneScale, v * look.toneScale, seed + 80));
		float mul = 1.f + ((0.8f + 0.35f * tone) / 0.975f - 1.f) * look.tone;
		// Stains soaked in, darker and a little glossier
		if (look.stain > 0.f)
		{
			const float s = Smooth(0.56f, 0.72f, Fbm(u * look.stainScale, v * look.stainScale, seed + 81)) * look.stain;
			mul *= 1.f - 0.3f * std::min(1.f, s);
			out.rough += (0.42f - out.rough) * std::min(1.f, s) * 0.5f * leather;
		}
		// An old wetting's tide lines, faint, wandering all over
		if (look.tides > 0.f)
		{
			const float line = Smooth(0.03f, 0.f, std::abs(Fbm(u * look.tideScale, v * look.tideScale, seed + 82) - 0.5f)) * look.tides;
			mul *= 1.f - 0.3f * line;
		}
		// Craquelure: fine cracks between small cells, longer along the spine, in patches
		if (look.cracks > 0.f)
		{
			const float patch = Smooth(0.5f, 0.64f, Fbm(u * 11.f, v * 11.f, seed + 83)) * look.cracks;
			if (patch > 0.f)
			{
				const float crack = Smooth(0.05f, 0.f, CellEdge(u * 140.f, v * 85.f, seed + 84)) * patch;
				mul *= 1.f - 0.6f * crack;
				out.rough += (0.85f - out.rough) * crack * leather;
			}
		}
		for (int k = 0; k < 3; ++k)
			c[k] *= 1.f + (mul - 1.f) * leather;
		out.rough = std::clamp(out.rough + look.finish * leather, 0.f, 1.f);
	}

	void Weather(const Look& look, float w, float y, float spine, float leather, Wear& out)
	{
		Character(look, w, y, leather, out);
		const uint32_t seed = look.seed;
		float* c = out.colour;
		const float lum = 0.2126f * c[0] + 0.7152f * c[1] + 0.0722f * c[2];
		const float age = look.age;
		// Sun on the spine: faded, paler and greyer, as it stood on a shelf
		if (look.sunned > 0.f && spine > 0.f)
		{
			const float f = look.sunned * spine * leather * (0.8f + 0.4f * Fbm(w * 40.f, y * 8.f, seed + 70));
			for (int k = 0; k < 3; ++k)
				c[k] += ((c[k] * 0.5f + lum * 0.5f) * 1.9f + 0.006f - c[k]) * f;
		}
		// Handled: every edge and corner rubbed pale, more the older it is, and the grain scuffed through in small patches
		// near them, where hands hold it; a paler shade of the leather itself with a little of the bare hide's brown
		const float edge = std::min(kEdgeW - std::abs(w), kEdgeY - std::abs(y));
		const float nearEdge = Smooth(0.07f, 0.f, edge);
		const float scuffs = Smooth(0.7f, 0.8f, Fbm(w * 26.f, y * 26.f, seed + 1) + 0.12f * nearEdge * age);
		const float worn = scuffs * age * leather * (0.35f + 0.65f * nearEdge);
		const float rubbed = Smooth(0.005f + 0.012f * age, 0.f, edge) * (0.5f + 0.5f * Fbm(w * 60.f, y * 60.f, seed + 2)) * age * leather;
		static constexpr float kHide[3] = { 0.05f, 0.028f, 0.017f };
		const float shade = 0.8f + 0.4f * Fbm(w * 90.f, y * 90.f, seed + 3);
		for (int k = 0; k < 3; ++k)
		{
			const float paler = (look.dye[k] * 1.7f * 0.6f + kHide[k] * 0.4f) * shade;
			c[k] += (paler - c[k]) * worn * 0.6f;
			c[k] += (paler * 1.35f - c[k]) * rubbed * 0.55f;
		}
		out.rough += (0.8f - out.rough) * worn * 0.8f;
		// Grime from hands, darkest along the fore-edges where it's held
		const float grime = age * leather * Smooth(0.45f, 0.75f, Fbm(w * 24.f, y * 24.f, seed + 4)) * (0.4f + 0.6f * Smooth(0.05f, 0.f, edge));
		for (int k = 0; k < 3; ++k)
			c[k] *= 1.f - 0.35f * grime;
		// The leaf rubbed off the tooling with use
		out.leafLost = Smooth(0.75f - 0.45f * age, 0.85f - 0.4f * age, Fbm(w * 70.f, y * 70.f, seed + 5));
		// A wetting: the dye lifted inside it, paler and drier, and a dark tide line where the water stopped, a fainter
		// one inside where it stood a while
		if (look.water.on)
		{
			const float d = std::hypot(w - look.water.w, y - look.water.y) / look.water.radius + (Fbm(w * 14.f, y * 14.f, seed + 6) - 0.5f) * 0.55f;
			const float inside = Smooth(1.02f, 0.96f, d);
			const float tide = std::exp(-std::pow((d - 1.f) / 0.022f, 2.f)) + 0.45f * std::exp(-std::pow((d - 0.72f) / 0.018f, 2.f));
			for (int k = 0; k < 3; ++k)
			{
				c[k] += ((c[k] * 0.6f + lum * 0.4f) * 1.45f - c[k]) * inside * 0.55f * leather;
				c[k] *= 1.f - std::min(0.4f, tide * 0.35f) * leather;
			}
			out.rough += (0.86f - out.rough) * (inside * 0.6f + std::min(1.f, tide)) * leather;
			out.leafLost = std::max(out.leafLost, inside * 0.5f);
		}
		// Mildew: pale grey-green blooms in clusters, where it was kept damp
		if (look.mould > 0.f)
		{
			// soft-edged and thin, the leather showing through: a bloom, not paint
			const float bloom = Smooth(0.56f, 0.8f, Fbm(w * 70.f, y * 70.f, seed + 8)) * Smooth(0.45f, 0.7f, Fbm(w * 7.f, y * 7.f, seed + 9)) * look.mould;
			static constexpr float kMildew[3] = { 0.075f, 0.08f, 0.065f };
			const float bright = std::min(1.f, 0.6f + 20.f * lum);   // fainter on the darkest leathers
			for (int k = 0; k < 3; ++k)
				c[k] += (kMildew[k] * bright - c[k]) * bloom * 0.4f;
			out.rough += (0.92f - out.rough) * bloom * 0.7f;
		}
		// Fire: charred black and crazed at the heart, browned round it
		if (look.scorch.on)
		{
			const float d = std::hypot(w - look.scorch.w, y - look.scorch.y) / look.scorch.radius + (Fbm(w * 30.f, y * 30.f, seed + 10) - 0.5f) * 0.8f;
			const float burnt = Smooth(0.95f, 0.55f, d), browned = Smooth(1.7f, 0.9f, d) * (1.f - burnt);
			const float crazed = 0.6f + 0.8f * Fbm(w * 160.f, y * 160.f, seed + 11);
			for (int k = 0; k < 3; ++k)
			{
				c[k] *= 1.f - 0.6f * browned;
				c[k] += (0.008f * crazed - c[k]) * burnt;
			}
			out.rough += (0.93f - out.rough) * burnt;
			out.burnt = burnt;
			out.leafLost = std::max(out.leafLost, burnt);
		}
	}

	// A book's look on the atlas: its three maps, made together, the last few kept
	struct LookMaps
	{
		std::string uuid;
		GameTexture diffuse, specular, normal;
	};

	std::shared_ptr<const LookMaps> MakeLookMaps(const std::string& uuid)
	{
		static std::mutex lock;
		static std::list<std::shared_ptr<const LookMaps>> kept;
		{
			std::lock_guard<std::mutex> hold(lock);
			for (const auto& k : kept)
				if (k->uuid == uuid)
					return k;
		}
		const Atlas& atlas = BaseAtlas();
		if (!atlas.ok)
			return nullptr;
		auto made = std::make_shared<LookMaps>();
		made->uuid = uuid;
		made->diffuse = atlas.diffuse;
		made->specular = atlas.specular;
		made->normal = atlas.normal;
		const Look look = LookOf(uuid);
		const Binding& binding = BindingOf(static_cast<int>(atlas.diffuse.width), static_cast<int>(atlas.diffuse.height));
		float shift[3], pressed[3];
		for (int k = 0; k < 3; ++k)
		{
			shift[k] = look.dye[k] - kOxblood[k];
			pressed[k] = look.dye[k] * 0.5f;   // blind tooling: the leather pressed darker, no leaf
		}
		const uint8_t* mask = atlas.mask.pixels.data();
		const size_t count = made->diffuse.pixels.size() / 4;
		for (size_t i = 0; i < count; ++i)
		{
			uint8_t* d = &made->diffuse.pixels[i * 4];
			uint8_t* s = &made->specular.pixels[i * 4];
			uint8_t* n = &made->normal.pixels[i * 4];
			const uint8_t* m = &mask[i * 4];
			const float dyed = m[0] / 255.f * kDyeScale, gilt = m[1] / 255.f, brass = m[2] / 255.f;
			Wear wear{};
			for (int k = 0; k < 3; ++k)
				wear.colour[k] = ToLinear(d[k]) + dyed * shift[k];
			wear.rough = n[3] / 255.f;
			// The tooling's leaf: none on a blind-tooled book, as if it had all rubbed off
			if (look.tooling == kToolBlind)
				for (int k = 0; k < 3; ++k)
					wear.colour[k] += (pressed[k] - wear.colour[k]) * gilt;
			if (look.tooling == kToolBlind)
				wear.rough += (0.72f - wear.rough) * gilt;
			// The years: on the leather's colour, and the leaf and the corners where it's rubbed or burnt
			const float leather = std::clamp(dyed * 2.f, 0.f, 1.f);
			if (!binding.w.empty() && !std::isnan(binding.w[i]) && (leather > 0.f || gilt > 0.f || brass > 0.f))
				Weather(look, binding.w[i], binding.y[i], binding.spine[i], leather, wear);
			else
				wear.leafLost = 0.f;
			// Leaf lost: the leather shows through, as on the book as baked where it's rubbed
			const float lost = look.tooling == kToolBlind ? 0.f : gilt * wear.leafLost * 0.8f;
			for (int k = 0; k < 3; ++k)
				wear.colour[k] += (pressed[k] * 1.6f - wear.colour[k]) * lost;
			wear.rough += (0.7f - wear.rough) * lost;
			for (int k = 0; k < 3; ++k)
				d[k] = ToSrgb(wear.colour[k]);
			n[3] = static_cast<uint8_t>(std::clamp(wear.rough, 0.f, 1.f) * 255.f + 0.5f);
			// Specular: the leaf as the book's metal, or none; the corners' metal; fire dulls them all
			if (gilt > 0.f && look.tooling != kToolGilt)
			{
				uint8_t to[3] = { s[0], s[1], s[2] };
				if (look.tooling == kToolSilver)
					AsMetal(to, kMetalSilver);
				else
					to[0] = to[1] = to[2] = 59;   // leather's 0.04
				for (int k = 0; k < 3; ++k)
					s[k] = static_cast<uint8_t>(s[k] + (to[k] - s[k]) * gilt + 0.5f);
			}
			if (brass > 0.f && look.corners != kMetalBrass)
			{
				uint8_t to[3] = { s[0], s[1], s[2] };
				AsMetal(to, look.corners);
				for (int k = 0; k < 3; ++k)
					s[k] = static_cast<uint8_t>(s[k] + (to[k] - s[k]) * brass + 0.5f);
				if (look.corners == kMetalIron)
					n[3] = static_cast<uint8_t>(n[3] + (std::max<int>(n[3], 140) - n[3]) * brass);
			}
			const float dull = std::max(lost, wear.burnt * std::max(gilt, brass));
			if (dull > 0.f)
				for (int k = 0; k < 3; ++k)
					s[k] = static_cast<uint8_t>(s[k] + (59 - s[k]) * dull + 0.5f);
		}
		std::lock_guard<std::mutex> hold(lock);
		kept.push_front(made);
		while (kept.size() > 3)
			kept.pop_back();
		return made;
	}

	enum AtlasMap { kAtlasDiffuse, kAtlasSpecular, kAtlasNormal };

	bool WriteLookMap(AtlasMap map, const std::string& uuid, GameTexture& out)
	{
		const std::shared_ptr<const LookMaps> maps = MakeLookMaps(uuid);
		if (!maps)
			return false;
		out = map == kAtlasDiffuse ? maps->diffuse : map == kAtlasSpecular ? maps->specular : maps->normal;
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// The paper in a book's look: its colour, browned towards its edges and spotted with foxing the older it is, and the
	// water or fire that marked its cover come through to its pages at the same place
	// ------------------------------------------------------------------------------------------

	constexpr float kPaperW = 0.235f, kPaperH = 0.33f;   // a page, metres (build_book.py), its spine edge on the spine

	void AgePaper(const std::string& uuid, int n, GameTexture& page, bool overText)
	{
		if (uuid.empty() || page.pixels.empty())
			return;
		const Look look = LookOf(uuid);
		const int width = static_cast<int>(page.width), height = static_cast<int>(page.height);
		const bool left = n % 2 == 0;
		const float metre = kPaperW / width;   // a pixel's width
		const uint32_t seed = look.seed + 1000;
		const auto pixel = [&](int x, int y) { return &page.pixels[static_cast<size_t>(y) * page.rowBytes + x * 4]; };
		// Where a pixel lies: out from the spine, and up the page from its middle, metres
		const auto place = [&](int x, int y, float& out, float& up)
		{
			out = (left ? width - 1 - x : x) * metre;
			up = kPaperH * 0.5f - y * (kPaperH / height);
		};
		if (!overText)
		{
			// The paper's colour, and browned in from its three open edges (not the spine's) as it aged
			const float reach = 0.004f + 0.02f * look.age;
			const uint32_t sheet = seed + 100 + n * 7;
			for (int y = 0; y < height; ++y)
				for (int x = 0; x < width; ++x)
				{
					float out, up;
					place(x, y, out, up);
					const float edge = std::min(kPaperW - out, kPaperH * 0.5f - std::abs(up));
					const float brown = Smooth(reach, 0.f, edge + (Fbm(out * 90.f, up * 90.f, seed) - 0.5f) * reach * 0.8f) * (0.25f + 0.45f * look.age);
					// The sheet's clouding, its own on every leaf; a blotch or two; the mould's laid and chain lines
					float shade = 1.f + (Fbm(out * look.cloudScale, up * look.cloudScale, sheet) - 0.5f) * 5.f * look.cloud;
					const float blotch = look.blotch > 0.f ? Smooth(0.5f, 0.72f, Fbm(out * look.blotchScale, up * look.blotchScale, sheet + 3)) * look.blotch : 0.f;
					if (look.laid > 0.f)
					{
						const float chain = std::abs(std::fmod(out + look.chainAt, look.chainGap) - look.chainGap * 0.5f);
						shade *= 1.f - look.laid * (0.05f * (0.5f + 0.5f * std::cos(up * 6.2832f / look.laidGap)) + 0.1f * Smooth(look.chainGap * 0.5f - 0.0016f, look.chainGap * 0.5f, chain));
					}
					uint8_t* p = pixel(x, y);
					static constexpr float kBrowned[3] = { 0.8f, 0.62f, 0.42f }, kBlotch[3] = { 0.76f, 0.66f, 0.5f };
					for (int k = 0; k < 3; ++k)
						p[k] = ToSrgb(ToLinear(p[k]) * look.paper[k] * shade * (1.f + (kBlotch[k] - 1.f) * blotch) * (1.f + (kBrowned[k] - 1.f) * brown));
				}
			// Specks of what was in the pulp: bark, rag and dirt, small and dark
			const int specks = static_cast<int>(look.specks * 450.f * (0.6f + 0.8f * Unit(Hash(uuid, 4000 + n))));
			for (int sp = 0; sp < specks; ++sp)
			{
				const uint32_t g = Hash(uuid, 9000 + n * 512 + sp);
				const float x = Unit(g) * width, y = Unit(g * 747796405u + 3) * height;
				const float r = 0.5f + Unit(g ^ 0x27d4eb2du) * 1.4f, strength = 0.25f + 0.5f * Unit(g * 2891336453u + 7);
				for (int yy = std::max(0, static_cast<int>(y - r * 2.f)); yy < std::min(height, static_cast<int>(y + r * 2.f) + 1); ++yy)
					for (int xx = std::max(0, static_cast<int>(x - r * 2.f)); xx < std::min(width, static_cast<int>(x + r * 2.f) + 1); ++xx)
					{
						const float f = std::exp(-((xx - x) * (xx - x) + (yy - y) * (yy - y)) / (r * r)) * strength;
						uint8_t* p = pixel(xx, yy);
						for (int k = 0; k < 3; ++k)
							p[k] = ToSrgb(ToLinear(p[k]) * (1.f - 0.75f * f));
					}
			}
			// Foxing: small rust-brown spots, in clusters, more of them the older the book
			const int clusters = static_cast<int>(look.age * look.age * 9.f + Unit(Hash(uuid, 1000 + n)) * 3.f * look.age);
			for (int c = 0; c < clusters; ++c)
			{
				const uint32_t h = Hash(uuid, 2000 + n * 64 + c);
				const float cx = Unit(h) * width, cy = Unit(h * 2654435761u + 1) * height;
				const int spots = 1 + static_cast<int>(Unit(h ^ 0x5bd1e995u) * 7.f);
				for (int sp = 0; sp < spots; ++sp)
				{
					const uint32_t g = Hash(uuid, 5000 + n * 512 + c * 8 + sp);
					const float x = cx + (Unit(g) - 0.5f) * 70.f, y = cy + (Unit(g * 747796405u + 3) - 0.5f) * 70.f;
					const float r = 1.5f + Unit(g ^ 0x27d4eb2du) * 4.5f, strength = 0.15f + 0.3f * Unit(g * 2891336453u + 7);
					for (int yy = std::max(0, static_cast<int>(y - r * 2.5f)); yy < std::min(height, static_cast<int>(y + r * 2.5f) + 1); ++yy)
						for (int xx = std::max(0, static_cast<int>(x - r * 2.5f)); xx < std::min(width, static_cast<int>(x + r * 2.5f) + 1); ++xx)
						{
							const float f = std::exp(-((xx - x) * (xx - x) + (yy - y) * (yy - y)) / (r * r)) * strength;
							uint8_t* p = pixel(xx, yy);
							static constexpr float kRust[3] = { 0.36f, 0.2f, 0.09f };
							for (int k = 0; k < 3; ++k)
							{
								const float v = ToLinear(p[k]);
								p[k] = ToSrgb(v + (kRust[k] * v / 0.5f - v) * f);
							}
						}
				}
			}
			return;
		}
		// Over the text, as the ink ran with it: a wetting's stain and tide lines, and a scorch's browning and char.
		// The block lies against the board the mark is on, so each page gets it, a little stronger or weaker.
		if (!look.water.on && !look.scorch.on)
			return;
		const float strength = 0.75f + 0.25f * Unit(Hash(uuid, 3000 + n));
		for (int y = 0; y < height; ++y)
			for (int x = 0; x < width; ++x)
			{
				float out, up;
				place(x, y, out, up);
				float mul[3] = { 1.f, 1.f, 1.f };
				if (look.water.on)
				{
					const float d = std::hypot(out - std::abs(look.water.w), up - look.water.y) / look.water.radius + (Fbm(out * 16.f, up * 16.f, seed + 6) - 0.5f) * 0.5f;
					const float inside = Smooth(1.02f, 0.95f, d) * strength;
					const float tide = (std::exp(-std::pow((d - 1.f) / 0.02f, 2.f)) + 0.5f * std::exp(-std::pow((d - 0.7f) / 0.015f, 2.f))) * strength;
					static constexpr float kWet[3] = { 0.94f, 0.88f, 0.76f }, kTide[3] = { 0.7f, 0.56f, 0.4f };
					for (int k = 0; k < 3; ++k)
						mul[k] *= (1.f + (kWet[k] - 1.f) * inside) * (1.f + (kTide[k] - 1.f) * std::min(1.f, tide));
				}
				if (look.scorch.on)
				{
					const float d = std::hypot(out - std::abs(look.scorch.w), up - look.scorch.y) / (look.scorch.radius * 0.8f) + (Fbm(out * 40.f, up * 40.f, seed + 10) - 0.5f) * 0.7f;
					const float browned = Smooth(1.6f, 0.85f, d) * strength, charred = Smooth(0.75f, 0.5f, d);
					static constexpr float kScorched[3] = { 0.55f, 0.38f, 0.22f };
					for (int k = 0; k < 3; ++k)
						mul[k] *= (1.f + (kScorched[k] - 1.f) * browned) * (1.f - 0.92f * charred);
				}
				if (mul[0] == 1.f && mul[1] == 1.f && mul[2] == 1.f)
					continue;
				uint8_t* p = pixel(x, y);
				for (int k = 0; k < 3; ++k)
					p[k] = ToSrgb(ToLinear(p[k]) * mul[k]);
			}
	}

	// The page edges' sheets in the book's paper, darker the older it is
	bool WriteEdges(const std::string& uuid, uint32_t largestSide, GameTexture& out)
	{
		static std::mutex lock;
		static GameTexture base;
		{
			std::lock_guard<std::mutex> hold(lock);
			if (base.pixels.empty() && !Decode(POTP_RES_BOOK_EDGES, std::max<uint32_t>(largestSide, 2048), base))
				return false;
			out = base;
		}
		const Look look = LookOf(uuid);
		float mul[3];
		for (int k = 0; k < 3; ++k)
			mul[k] = (1.f + (look.paper[k] - 1.f) * 0.5f) * (1.f - 0.22f * look.age);   // half the tint: the sheets' edges are already its colour
		for (size_t i = 0; i < out.pixels.size(); i += 4)
			for (int k = 0; k < 3; ++k)
				out.pixels[i + k] = ToSrgb(ToLinear(out.pixels[i + k]) * mul[k]);
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// The cover: the book's title in gilt capitals, on a plate the renderer cuts away round the letters
	// ------------------------------------------------------------------------------------------

	constexpr int kCoverW = 1024, kCoverH = 768;   // build_book.py's TITLE_W x TITLE_H
	// The title's words into lines at a size: false when a word alone is wider than the plate
	bool WrapTitle(const std::string& title, float px, float width, std::vector<std::string>& lines)
	{
		lines.clear();
		std::string line;
		for (const std::string& word : Words(title))
		{
			if (Measure(1, px, word) > width)
				return false;
			const std::string tried = line.empty() ? word : line + " " + word;
			if (!line.empty() && Measure(1, px, tried) > width)
			{
				lines.push_back(line);
				line = word;
			}
			else
				line = tried;
		}
		if (!line.empty())
			lines.push_back(line);
		return true;
	}

	// Where the letters are, 0 to 1 a pixel: the title in Cinzel capitals, centred, as large as fits (at most four
	// lines, a long title smaller)
	std::vector<float> TitleCoverage(const std::string& title)
	{
		std::vector<float> c(static_cast<size_t>(kCoverW) * kCoverH, 0.f);
		if (title.empty() || !Fonts())
			return c;
		constexpr float kMargin = 64.f;
		const float width = kCoverW - 2 * kMargin;
		std::vector<std::string> lines;
		float px = 128.f;
		for (; px > 40.f; px -= 4.f)
			if (WrapTitle(title, px, width, lines) && lines.size() <= 4 && lines.size() * px * 1.18f <= kCoverH - 2 * kMargin)
				break;
		if (lines.empty())
			WrapTitle(title, px, 1e9f, lines);
		const float lineH = px * 1.18f;
		float baseline = (kCoverH - lines.size() * lineH) * 0.5f + Ascent(1, px);
		std::lock_guard<std::mutex> hold(g_fontLock);
		for (const std::string& l : lines)
		{
			float x = 0.f;
			for (size_t i = 0; i < l.size();)
			{
				const uint32_t cp = NextCodepoint(l, i);
				size_t j = i;
				x += Advance(1, px, cp, i < l.size() ? NextCodepoint(l, j) : 0);
			}
			x = (kCoverW - x) * 0.5f;
			for (size_t i = 0; i < l.size();)
			{
				const uint32_t cp = NextCodepoint(l, i);
				size_t j = i;
				const uint32_t next = i < l.size() ? NextCodepoint(l, j) : 0;
				const Glyph& g = GlyphOf(1, px, cp);
				const int gx = static_cast<int>(std::floor(x)) + g.x0, gy = static_cast<int>(std::floor(baseline)) + g.y0;
				for (int y = 0; y < g.h; ++y)
					for (int xx = 0; xx < g.w; ++xx)
					{
						const int X = gx + xx, Y = gy + y;
						if (X < 0 || Y < 0 || X >= kCoverW || Y >= kCoverH)
							continue;
						float& a = c[static_cast<size_t>(Y) * kCoverW + X];
						a = std::max(a, g.coverage[static_cast<size_t>(y) * g.w + xx] / 255.f);
					}
				x += Advance(1, px, cp, next);
			}
			baseline += lineH;
		}
		return c;
	}

	// A box blur, across then down, twice over: near enough a soft round one
	std::vector<float> Blur(const std::vector<float>& in, int r)
	{
		std::vector<float> a = in, b(in.size());
		for (int pass = 0; pass < 2; ++pass)
		{
			for (int y = 0; y < kCoverH; ++y)
			{
				float sum = 0.f;
				const float* row = &a[static_cast<size_t>(y) * kCoverW];
				for (int x = -r; x <= r; ++x)
					sum += row[std::clamp(x, 0, kCoverW - 1)];
				for (int x = 0; x < kCoverW; ++x)
				{
					b[static_cast<size_t>(y) * kCoverW + x] = sum / (2 * r + 1);
					sum += row[std::min(x + r + 1, kCoverW - 1)] - row[std::max(x - r, 0)];
				}
			}
			for (int x = 0; x < kCoverW; ++x)
			{
				float sum = 0.f;
				for (int y = -r; y <= r; ++y)
					sum += b[static_cast<size_t>(std::clamp(y, 0, kCoverH - 1)) * kCoverW + x];
				for (int y = 0; y < kCoverH; ++y)
				{
					a[static_cast<size_t>(y) * kCoverW + x] = sum / (2 * r + 1);
					sum += b[static_cast<size_t>(std::min(y + r + 1, kCoverH - 1)) * kCoverW + x] - b[static_cast<size_t>(std::max(y - r, 0)) * kCoverW + x];
				}
			}
		}
		return a;
	}

	// A small smooth noise, 0 to 1, for where the gilt's rubbed off
	float CoverNoise(float x, float y)
	{
		const auto hash = [](int i, int j) { uint32_t h = static_cast<uint32_t>(i) * 374761393u + static_cast<uint32_t>(j) * 668265263u; h = (h ^ (h >> 13)) * 1274126177u; return (h ^ (h >> 16)) / 4294967295.f; };
		const int i = static_cast<int>(std::floor(x)), j = static_cast<int>(std::floor(y));
		float u = x - i, v = y - j;
		u = u * u * (3 - 2 * u);
		v = v * v * (3 - 2 * v);
		return (hash(i, j) * (1 - u) + hash(i + 1, j) * u) * (1 - v) + (hash(i, j + 1) * (1 - u) + hash(i + 1, j + 1) * u) * v;
	}

	// The cover's three pictures, as a binder's tooling is: the letters stamped into the leather, gilt in the bottom of
	// the impression and rubbed through in places, and the leather round each one pressed down and burnished darker.
	// The plate shows only the letters and that pressed rim; the rest is cut away, so the cover's own leather shows.
	//   colour: the leather's dark where pressed, near black where it's gilt (metal: its colour is its specular)
	//   specular: gold where gilt, leather's 0.04 elsewhere          normal: the impression, roughness in the alpha
	enum CoverLayer { kCoverColour, kCoverSpecular, kCoverNormal };

	GameTexture NewCover()
	{
		GameTexture t;
		t.dxgiFormat = 28;   // RGBA8
		t.width = kCoverW;
		t.height = kCoverH;
		t.rowBytes = kCoverW * 4;
		t.rows = kCoverH;
		t.pixels.assign(static_cast<size_t>(kCoverW) * kCoverH * 4, 0);
		return t;
	}

	// The title's letters laid out once for its three pictures, which the viewer reads at the same time: the last few
	struct CoverShape { std::string title; std::vector<float> letters, soft, spread; };
	std::mutex g_shapeLock;
	std::list<std::pair<std::string, std::shared_ptr<const CoverShape>>> g_shapes;

	std::shared_ptr<const CoverShape> ShapeOf(const std::string& uuid)
	{
		const std::string title = TitleOf(uuid);
		std::lock_guard<std::mutex> hold(g_shapeLock);   // held while it's made: the other two pictures wait for it
		for (const auto& [key, shape] : g_shapes)
			if (key == uuid && shape->title == title)
				return shape;
		auto shape = std::make_shared<CoverShape>();
		shape->title = title;
		shape->letters = TitleCoverage(title);
		shape->soft = Blur(shape->letters, 2);       // the letters' sloped walls
		shape->spread = Blur(shape->letters, 7);     // the pressed rim round them
		g_shapes.emplace_front(uuid, shape);
		while (g_shapes.size() > 4)
			g_shapes.pop_back();
		return shape;
	}

	bool WriteCover(const std::string& uuid, CoverLayer layer, GameTexture& out)
	{
		const std::shared_ptr<const CoverShape> shape = ShapeOf(uuid);
		const std::vector<float>& letters = shape->letters;
		const std::vector<float>& soft = shape->soft;
		const std::vector<float>& spread = shape->spread;
		out = NewCover();
		// In the book's own leather and leaf (LookOf): sRGB, as book_s holds them. Blind tooling: the letters pressed, no leaf.
		const Look look = LookOf(uuid);
		float leather[3], giltDark[3] = { 40.f, 28.f, 12.f }, gold[3] = { 150.f, 104.f, 46.f };
		constexpr float kDielectric = 59.f;
		for (int k = 0; k < 3; ++k)
			leather[k] = ToSrgb(look.dye[k] * 0.42f);
		if (look.tooling == kToolSilver)
		{
			const float silverDark[3] = { 34.f, 34.f, 36.f }, silver[3] = { 168.f, 168.f, 174.f };
			std::copy(silverDark, silverDark + 3, giltDark);
			std::copy(silver, silver + 3, gold);
		}
		const float leaf = look.tooling == kToolBlind ? 0.f : 1.f;
		for (int y = 0; y < kCoverH; ++y)
			for (int x = 0; x < kCoverW; ++x)
			{
				const size_t i = static_cast<size_t>(y) * kCoverW + x;
				uint8_t* p = &out.pixels[i * 4];
				const float rim = std::clamp(spread[i] * 3.5f, 0.f, 1.f);
				// Gilt in the letters, rubbed through where the noise is high and towards their edges
				const float rub = std::clamp((CoverNoise(x / 46.f, y / 46.f) * 0.7f + CoverNoise(x / 9.f, y / 9.f) * 0.3f - 0.6f) * 6.f, 0.f, 1.f);
				const float gilt = std::clamp((letters[i] - 0.35f) * 3.f, 0.f, 1.f) * (1.f - rub * 0.85f) * leaf;
				if (layer == kCoverColour)
				{
					// Darker the nearer the letter, where the tool pressed hardest
					const float press = 1.f - 0.45f * std::clamp(spread[i] * 2.f, 0.f, 1.f);
					for (int k = 0; k < 3; ++k)
						p[k] = static_cast<uint8_t>(leather[k] * press + (giltDark[k] - leather[k] * press) * gilt);
					p[3] = static_cast<uint8_t>(std::max(rim, letters[i]) * 255.f);
				}
				else if (layer == kCoverSpecular)
				{
					for (int k = 0; k < 3; ++k)
						p[k] = static_cast<uint8_t>(kDielectric + (gold[k] - kDielectric) * gilt);
					p[3] = 255;
				}
				else
				{
					// The impression: the letters sunk, their walls sloping, the rim easing down into them
					const auto h = [&](int xx, int yy)
					{
						const size_t j = static_cast<size_t>(std::clamp(yy, 0, kCoverH - 1)) * kCoverW + std::clamp(xx, 0, kCoverW - 1);
						return -(soft[j] * 0.8f + spread[j] * 0.35f);
					};
					constexpr float kDepth = 3.f;
					const float dx = (h(x + 1, y) - h(x - 1, y)) * kDepth, dy = (h(x, y + 1) - h(x, y - 1)) * kDepth;
					const float len = std::sqrt(dx * dx + dy * dy + 1.f);
					p[0] = static_cast<uint8_t>((-dx / len * 0.5f + 0.5f) * 255.f);
					p[1] = static_cast<uint8_t>((dy / len * 0.5f + 0.5f) * 255.f);
					p[2] = static_cast<uint8_t>((1.f / len * 0.5f + 0.5f) * 255.f);
					p[3] = static_cast<uint8_t>((1.f - gilt) * 255.f);   // roughness: gilt smooth, leather matte
				}
			}
		return true;
	}

	// Pages already written, the most recent first: a turn needs three, and going back needs them again
	std::mutex g_pageLock;
	std::list<std::pair<std::string, std::shared_ptr<GameTexture>>> g_written;

	std::shared_ptr<GameTexture> PageFor(const std::string& uuid, int n)
	{
		const std::string key = uuid + "#" + std::to_string(n);
		{
			std::lock_guard<std::mutex> hold(g_pageLock);
			for (auto it = g_written.begin(); it != g_written.end(); ++it)
				if (it->first == key)
				{
					g_written.splice(g_written.begin(), g_written, it);
					return it->second;
				}
		}
		std::shared_ptr<const Book> book;
		{
			std::lock_guard<std::mutex> hold(g_bookLock);
			const auto found = g_books.find(uuid);
			if (found != g_books.end())
				book = found->second;
		}
		auto page = std::make_shared<GameTexture>();
		if (!WritePage(uuid, book.get(), n, *page))
			return nullptr;
		AddMips(*page);
		std::lock_guard<std::mutex> hold(g_pageLock);
		g_written.emplace_front(key, page);
		while (g_written.size() > 10)
			g_written.pop_back();
		return page;
	}

	// ------------------------------------------------------------------------------------------
	// The book shown, and its page turning
	// ------------------------------------------------------------------------------------------

	// The page slots its model was loaded with: what each one's picture is known by
	enum Slot { kSlotLeft, kSlotRight, kSlotFront, kSlotBack, kSlots };
	const char* const kSlotNames[kSlots] = { "L", "R", "F", "B" };

	std::string SlotName(const std::string& uuid, int page, int slot)
	{
		return std::string(kBuiltinTexture) + "page:" + std::to_string(page) + ":" + kSlotNames[slot] + ":" + uuid;
	}

	struct Shown
	{
		std::string uuid, request;
		int spread = 0;
		int loadedSpread = 0;            // the spread its pictures were named for as it loaded
		int turning = 0;                 // 1 forward, -1 back, 0 still
		float t = 0.f;                   // how far through the turn
		int settle = 0;                  // frames the leaf stays down after a turn, while the page under it changes
		std::shared_ptr<std::atomic<bool>> ready;   // the pictures for the turn are in place
		float shut = 0.f;                // how far it's shut, 0 open to 1 shut
		int shutting = 0;                // 1 shutting, -1 opening, 0 still
	};
	Shown g_shown;
	std::map<std::string, int> g_spreadOf;   // where each book was left open

	int Spreads(const std::string& uuid)
	{
		std::lock_guard<std::mutex> hold(g_bookLock);
		const auto found = g_books.find(uuid);
		return found == g_books.end() ? 1 : (found->second->Count() + 1) / 2;
	}

	void Swap(int slot, int page)
	{
		const std::shared_ptr<GameTexture> picture = PageFor(g_shown.uuid, page);
		if (picture)
			ModelViewReplaceTexture(SlotName(g_shown.uuid, g_shown.loadedSpread * 2 + (slot == kSlotLeft || slot == kSlotBack ? 0 : 1), slot), *picture);
	}

	float Ease(float t) { return t * t * (3.f - 2.f * t); }
}

bool ReadBuiltinTexture(const std::string& name, uint32_t largestSide, GameTexture& out, bool withMips)
{
	const std::string key = name.compare(0, strlen(kBuiltinTexture), kBuiltinTexture) == 0 ? name.substr(strlen(kBuiltinTexture)) : name;
	bool ok = false;
	if (key.compare(0, 5, "page:") == 0)
	{
		// page:n:slot:uuid
		const size_t a = key.find(':', 5), b = a == std::string::npos ? a : key.find(':', a + 1);
		if (b == std::string::npos)
			return false;
		const std::shared_ptr<GameTexture> page = PageFor(key.substr(b + 1), atoi(key.c_str() + 5));
		if (!page)
			return false;
		out = *page;
		return true;
	}
	// The cover's title, its three pictures: cover:, cover_s: (specular), cover_n: (normal), then the book
	const CoverLayer layer = key.compare(0, 6, "cover:") == 0 ? kCoverColour : key.compare(0, 8, "cover_s:") == 0 ? kCoverSpecular
		: key.compare(0, 8, "cover_n:") == 0 ? kCoverNormal : static_cast<CoverLayer>(-1);
	if (layer != static_cast<CoverLayer>(-1))
	{
		ok = WriteCover(key.substr(key.find(':') + 1), layer, out);
		if (ok && withMips)
			AddMips(out);
		return ok;
	}
	// The atlas in a book's look: book_d:, book_s: and book_n: (normal and roughness), then the book
	const AtlasMap map = key.compare(0, 7, "book_d:") == 0 ? kAtlasDiffuse : key.compare(0, 7, "book_s:") == 0 ? kAtlasSpecular
		: key.compare(0, 7, "book_n:") == 0 ? kAtlasNormal : static_cast<AtlasMap>(-1);
	if (map != static_cast<AtlasMap>(-1))
	{
		ok = WriteLookMap(map, key.substr(7), out);
		if (ok && withMips)
			AddMips(out);
		return ok;
	}
	if (key == "book_d")
		ok = Decode(POTP_RES_BOOK_DIFFUSE, largestSide, out);
	else if (key == "book_s")
		ok = Decode(POTP_RES_BOOK_SPECULAR, largestSide, out);
	else if (key == "parchment")
		ok = Decode(POTP_RES_PARCHMENT, largestSide, out);
	else if (key.compare(0, 6, "edges:") == 0)
		ok = WriteEdges(key.substr(6), largestSide, out);   // the page edges in a book's paper
	else if (key == "edges" || key == "edges_n")
	{
		// The page edges' sheets, a line every few pixels: kept at their full 2048, as fitting them in less blurs them
		ok = Decode(key == "edges" ? POTP_RES_BOOK_EDGES : POTP_RES_BOOK_EDGES_N, std::max<uint32_t>(largestSide, 2048), out);
		if (ok && key == "edges_n")
			for (size_t i = 3; i < out.pixels.size(); i += 4)
				out.pixels[i] = 255;   // the roughness the renderer reads from the alpha: paper's, set by the part
	}
	else if (key == "book_n")
	{
		// The normal map, with its roughness put in the alpha, as the renderer reads it
		GameTexture rough;
		ok = Decode(POTP_RES_BOOK_NORMAL, largestSide, out) && Decode(POTP_RES_BOOK_ROUGHNESS, largestSide, rough)
			&& rough.width == out.width && rough.height == out.height;
		if (ok)
			for (size_t i = 3; i < out.pixels.size(); i += 4)
				out.pixels[i] = rough.pixels[i - 3];
	}
	if (ok && withMips)
		AddMips(out);
	return ok;
}

bool LoadBookModel(const std::string& which, ItemModel& out)
{
	// "closed:uuid", or "open:spread:uuid": the closed book's parts (closed_...), or the open one's with its pages named
	// for that book at that spread, and the leaf to turn. Either way the front cover carries that book's title.
	const bool closed = which.compare(0, 6, "closed") == 0;
	int spread = 0;
	std::string uuid;
	if (closed && which.size() > 7)
		uuid = which.substr(7);
	else if (!closed && which.compare(0, 5, "open:") == 0)
	{
		const size_t colon = which.find(':', 5);
		spread = atoi(which.c_str() + 5);
		uuid = colon == std::string::npos ? std::string() : which.substr(colon + 1);
	}
	const std::string_view data = EmbeddedFile(POTP_RES_BOOK_MESH);
	const char* at = data.data();
	const char* const end = at + data.size();
	uint32_t parts = 0;
	// PBK2 adds a 13th float a vertex: the height of the stack's underside under it. PBK3 ten more: the book shut
	// (export_book.py), for the shader to close it.
	const bool withShut = data.size() >= 8 && memcmp(at, "PBK3", 4) == 0;
	const bool withBase = withShut || (data.size() >= 8 && memcmp(at, "PBK2", 4) == 0);
	if (data.size() < 8 || (memcmp(at, "PBK1", 4) != 0 && !withBase))
	{
		out.problem = "the book's mesh isn't in the overlay";
		return false;
	}
	at += 4;
	Take(at, end, parts);
	out = ItemModel{};
	out.worn = true;   // it lies as it's made, the pages up: never stood on its longest side as a weapon would be
	for (int k = 0; k < 3; ++k)
	{
		out.boundsMin[k] = 1e9f;
		out.boundsMax[k] = -1e9f;
	}
	const float c = cosf(kTilt), s = sinf(kTilt);
	const auto finish = [&](ModelPart& part, uint8_t role)
	{
		// Tipped back as on a lectern, the pages toward the viewer and their heads up: the viewer looks along +Y, Z up.
		// A moving part's role goes in its vertex colour's alpha, for the vertex shader (modelview.cpp, BookPart).
		for (ModelVertex& v : part.vertices)
		{
			for (float* d : { v.position, v.normal, v.tangent })
			{
				const float y = d[1], z = d[2];
				d[1] = y * c - z * s;
				d[2] = y * s + z * c;
			}
			v.colour[3] = role;
			for (int k = 0; k < 3; ++k)
			{
				out.boundsMin[k] = std::min(out.boundsMin[k], v.position[k]);
				out.boundsMax[k] = std::max(out.boundsMax[k], v.position[k]);
			}
		}
		out.parts.push_back(std::move(part));
	};
	const auto paper = [&](ModelPart& part, const std::string& picture)
	{
		part.diffuse = picture;
		part.roughMin = part.roughMax = 0.85f;
		part.specColour[0] = part.specColour[1] = part.specColour[2] = 0.03f;
	};
	for (uint32_t p = 0; p < parts; ++p)
	{
		uint8_t nameLength = 0, material = 0;
		if (!Take(at, end, nameLength) || end - at < nameLength)
			break;
		const std::string name(at, nameLength);
		at += nameLength;
		uint32_t vertices = 0, indices = 0;
		const size_t floats = withShut ? 23 : withBase ? 13 : 12;
		if (!Take(at, end, material) || !Take(at, end, vertices) || end - at < static_cast<ptrdiff_t>(vertices * floats * 4))
			break;
		ModelPart part;
		part.vertices.resize(vertices);
		if (withShut)
			part.shut.resize(vertices);
		for (size_t i = 0; i < part.vertices.size(); ++i)
		{
			ModelVertex& v = part.vertices[i];
			float f[23] = {};
			memcpy(f, at, floats * 4);
			at += floats * 4;
			if (withShut)
			{
				// Not tilted as the rest is (finish): the shader works on the book untilted
				ShutVertex& s = part.shut[i];
				memcpy(s.place, f + 13, 12);
				memcpy(s.normal, f + 16, 12);
				memcpy(s.tangent, f + 19, 12);
				s.fold = f[22];
			}
			memcpy(v.position, f, 12);
			memcpy(v.normal, f + 3, 12);
			memcpy(v.tangent, f + 6, 16);
			memcpy(v.uv, f + 10, 8);
			// The shader thickens and thins the stack above this, so its arch off the board stays as it is
			v.colour[0] = static_cast<uint8_t>(std::clamp(f[12] / kBaseRange * 255.f + 0.5f, 0.f, 255.f));
		}
		if (!Take(at, end, indices) || end - at < static_cast<ptrdiff_t>(indices) * 4)
			break;
		part.indices.resize(indices);
		memcpy(part.indices.data(), at, static_cast<size_t>(indices) * 4);
		at += static_cast<size_t>(indices) * 4;
		if ((name.compare(0, 7, "closed_") == 0) != closed)
			continue;
		uint8_t role = 255;
		if (name == "ribbon" || name == "closed_ribbon")
			role = 5;   // not moved, but left out of the framing (modelview.cpp)
		if (name == "pages_left" || name == "page_edges_left")
			role = closed ? 255 : 1;
		else if (name == "pages_right" || name == "page_edges_right")
			role = closed ? 255 : 2;
		if (material == 0)
		{
			// The atlas, in this book's look (LookOf): its leather, its tooling and its corners
			const std::string look = uuid.empty() ? std::string() : ":" + uuid;
			part.diffuse = std::string(kBuiltinTexture) + "book_d" + look;
			part.normal = std::string(kBuiltinTexture) + "book_n" + look;
			part.specular = std::string(kBuiltinTexture) + "book_s" + look;
			finish(part, role);
			continue;
		}
		if (material == 4)
		{
			// The title plate: the book's title stamped into the leather and gilt, written for it (WriteCover), the rest
			// of the plate cut away
			if (uuid.empty())
				continue;
			part.diffuse = std::string(kBuiltinTexture) + "cover:" + uuid;
			part.specular = std::string(kBuiltinTexture) + "cover_s:" + uuid;
			part.normal = std::string(kBuiltinTexture) + "cover_n:" + uuid;
			part.masked = true;
			part.roughMin = 0.22f;   // the gilt
			part.roughMax = 0.8f;    // the pressed leather
			finish(part, role);
			continue;
		}
		if (material == 3)
		{
			// The page edges: the sheets' own tiling texture, one sheet a line, matte paper
			paper(part, std::string(kBuiltinTexture) + (uuid.empty() ? std::string("edges") : "edges:" + uuid));
			part.normal = std::string(kBuiltinTexture) + "edges_n";   // a faint groove at each sheet's edge
			finish(part, role);
			continue;
		}
		if (material == 1)
		{
			// The left page reads from its outer edge: its u runs from there to the spine
			for (ModelVertex& v : part.vertices)
				v.uv[0] = 1.f - v.uv[0];
			paper(part, SlotName(uuid, spread * 2, kSlotLeft));
			finish(part, role);
			continue;
		}
		// The right page, and from it the leaf that's turned: its front this page, its back the next, facing the other way
		ModelPart front = part, back = part;
		paper(part, SlotName(uuid, spread * 2 + 1, kSlotRight));
		finish(part, role);
		paper(front, SlotName(uuid, spread * 2 + 1, kSlotFront));
		finish(front, 3);
		for (ModelVertex& v : back.vertices)
			v.uv[0] = 1.f - v.uv[0];
		for (size_t i = 0; i + 2 < back.indices.size(); i += 3)
			std::swap(back.indices[i + 1], back.indices[i + 2]);
		paper(back, SlotName(uuid, spread * 2, kSlotBack));
		finish(back, 4);
	}
	if (out.parts.empty())
	{
		out.problem = "the book's mesh couldn't be read";
		return false;
	}
	return true;
}

void BookSetText(const std::string& uuid, const std::string& title, const std::string& section, const std::vector<std::string>& paragraphs)
{
	{
		std::lock_guard<std::mutex> hold(g_bookLock);
		const auto found = g_books.find(uuid);
		if (found != g_books.end() && found->second->title == title && found->second->section == section)
			return;
	}
	// The game's book texts break their lines with line breaks as well as <br>: each line its own paragraph
	std::vector<std::string> lines;
	for (const std::string& paragraph : paragraphs)
	{
		size_t from = 0;
		for (;;)
		{
			const size_t at = paragraph.find_first_of("\r\n", from);
			std::string line = paragraph.substr(from, at == std::string::npos ? std::string::npos : at - from);
			if (line.find_first_not_of(" \t") != std::string::npos)
				lines.push_back(std::move(line));
			if (at == std::string::npos)
				break;
			from = at + 1;
		}
	}
	std::shared_ptr<const Book> book = Lay(title, section, lines);
	{
		std::lock_guard<std::mutex> hold(g_bookLock);
		g_books[uuid] = book;
	}
	std::lock_guard<std::mutex> hold(g_pageLock);
	g_written.remove_if([&](const auto& item) { return item.first.compare(0, uuid.size() + 1, uuid + "#") == 0; });
}

bool BookHasText(const std::string& uuid)
{
	std::lock_guard<std::mutex> hold(g_bookLock);
	return g_books.count(uuid) != 0;
}

void BookSetTitle(const std::string& uuid, const std::string& title, int shelf)
{
	std::lock_guard<std::mutex> hold(g_titleLock);
	g_titles[uuid] = title;
	g_shelves[uuid] = shelf;
}

std::string BookClosedRequest(const std::string& uuid)
{
	return std::string(kModelBook) + "closed:" + uuid;
}

std::string BookRequest(const std::string& uuid)
{
	if (g_shown.uuid != uuid)
	{
		if (!g_shown.uuid.empty())
			g_spreadOf[g_shown.uuid] = g_shown.spread;
		g_shown = Shown{};
		g_shown.uuid = uuid;
		const auto found = g_spreadOf.find(uuid);
		g_shown.spread = found == g_spreadOf.end() ? 0 : std::clamp(found->second, 0, Spreads(uuid) - 1);
		g_shown.loadedSpread = g_shown.spread;
		g_shown.request = std::string(kModelBook) + "open:" + std::to_string(g_shown.spread) + ":" + uuid;
	}
	return g_shown.request;
}

bool BookTurn(int direction)
{
	if (g_shown.uuid.empty() || g_shown.turning != 0 || g_shown.settle > 0 || g_shown.shut > 0.f || g_shown.shutting != 0)
		return false;
	const int to = g_shown.spread + direction;
	if (to < 0 || to >= Spreads(g_shown.uuid))
		return false;
	g_shown.turning = direction;
	g_shown.t = direction > 0 ? 0.f : 1.f;
	g_shown.ready = std::make_shared<std::atomic<bool>>(false);
	// The pictures it needs, written on a thread of their own so the window doesn't wait: the leaf's two sides, and the
	// page it uncovers. Forward the leaf lifts off the right, back off the left.
	const int s = g_shown.spread;
	const std::string uuid = g_shown.uuid;
	const int loaded = g_shown.loadedSpread;
	std::shared_ptr<std::atomic<bool>> ready = g_shown.ready;
	std::thread([uuid, loaded, s, direction, ready]
	{
		const auto put = [&](int slot, int page)
		{
			const std::shared_ptr<GameTexture> picture = PageFor(uuid, page);
			if (picture)
				ModelViewReplaceTexture(SlotName(uuid, loaded * 2 + (slot == kSlotLeft || slot == kSlotBack ? 0 : 1), slot), *picture);
		};
		if (direction > 0)
		{
			put(kSlotFront, s * 2 + 1);
			put(kSlotBack, s * 2 + 2);
			put(kSlotRight, s * 2 + 3);
		}
		else
		{
			put(kSlotFront, s * 2 - 1);
			put(kSlotBack, s * 2);
			put(kSlotLeft, s * 2 - 2);
		}
		*ready = true;
	}).detach();
	return true;
}

bool BookShut(bool shut)
{
	if (g_shown.uuid.empty() || g_shown.turning != 0 || g_shown.settle > 0)
		return false;
	g_shown.shutting = shut ? 1 : -1;
	return true;
}

bool BookShutting() { return g_shown.shutting > 0 || (g_shown.shutting == 0 && g_shown.shut > 0.f); }

namespace
{
	float g_testShut = -1.f;
}

void BookTestShut(float shut) { g_testShut = shut; }

void BookTick(float dt)
{
	constexpr float kTurnSeconds = 0.75f, kShutSeconds = 1.2f;
	float sheet[4] = { -1.f, 1.f, 1.f, kPageWidth }, sheet2[4] = { cosf(kTilt), sinf(kTilt), kMadeLeft / kMadeRight, kGutter };
	float progress = static_cast<float>(g_shown.spread);
	if (g_shown.turning != 0 && g_shown.ready && *g_shown.ready)
	{
		// A frame or two for the leaf's pictures to reach the card before it lifts
		g_shown.t = std::clamp(g_shown.t + g_shown.turning * dt / kTurnSeconds, 0.f, 1.f);
		const bool done = g_shown.turning > 0 ? g_shown.t >= 1.f : g_shown.t <= 0.f;
		sheet[0] = Ease(g_shown.t);
		progress = g_shown.spread + (g_shown.turning > 0 ? Ease(g_shown.t) : Ease(g_shown.t) - 1.f);
		if (done)
		{
			// Landed: the page under it becomes what the leaf shows, and the leaf stays a few frames while that happens
			const int s = g_shown.spread + g_shown.turning;
			if (g_shown.turning > 0)
				Swap(kSlotLeft, s * 2);
			else
				Swap(kSlotRight, s * 2 + 1);
			g_shown.spread = s;
			g_shown.settle = 4;
			g_shown.turning = 0;
			g_spreadOf[g_shown.uuid] = s;
		}
	}
	else if (g_shown.settle > 0)
	{
		// Lying where it landed until the page beneath has changed
		--g_shown.settle;
		sheet[0] = g_shown.t >= 0.5f ? 1.f : 0.f;
		progress = static_cast<float>(g_shown.spread);
	}
	// The blocks: thicker on the left the further through
	const int spreads = std::max(1, Spreads(g_shown.uuid) - 1);
	const float f = std::clamp(progress / spreads, 0.f, 1.f);
	const float left = kThinnest + (kAllPages - 2.f * kThinnest) * (0.3f + 0.4f * f);
	const float right = kAllPages - left;
	sheet[1] = right / kMadeRight;
	sheet[2] = left / kMadeLeft;
	// Shutting or opening: the front half over onto the back on the end of the spine, the spine bending from flat to half
	// round and lengthening to it (kSpineOpen to kSpineShut, export_book.py), its pages flattening as it goes, and the
	// book moved over so it stays in the middle (shut, it lies from its spine's back, kShutLeft, to its boards' edge)
	if (g_shown.shutting != 0)
	{
		g_shown.shut = std::clamp(g_shown.shut + g_shown.shutting * dt / kShutSeconds, 0.f, 1.f);
		if (g_shown.shut <= 0.f || g_shown.shut >= 1.f)
			g_shown.shutting = 0;
	}
	constexpr float kShutLeft = -0.0045f, kShutRight = 0.265f, kBoardT = 0.0055f;
	constexpr float kSpineOpen = 0.06f, kSpineShut = 3.14159265f * ((kMadeLeft + kMadeRight) / 2.f + kBoardT);
	const float how = g_testShut >= 0.f ? g_testShut : Ease(g_shown.shut);
	const float flat = std::clamp((how - 0.05f) / 0.85f, 0.f, 1.f);
	const float shut[4] = { how, (kShutLeft + kShutRight) / 2.f, kSpineOpen + (kSpineShut - kSpineOpen) * how, Ease(flat) };
	ModelViewBook(sheet, sheet2, shut);
}

int BookSpread() { return g_shown.spread; }
int BookSpreadCount() { return Spreads(g_shown.uuid); }
int BookPageCount() { std::lock_guard<std::mutex> hold(g_bookLock); const auto f = g_books.find(g_shown.uuid); return f == g_books.end() ? 0 : f->second->Count(); }
bool BookTurning() { return g_shown.turning != 0 || g_shown.settle > 0; }
