// The Library's book: its mesh (data/book.mesh, written by the Resources' library-book/scripts/export_book.py) and
// its pictures (data/*.jpg, by pack_book_textures.py), built into the .asi, read into the model viewer's own structures;
// the book's text laid out into pages and written onto the parchment; and the page being turned.
#include "book.h"

#include <windows.h>
#include <wincodec.h>
#include <algorithm>
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

	// The book's page n (0 the title page). Left pages (even) have their wide margin to the right, by the spine.
	bool WritePage(const Book* book, int n, GameTexture& out)
	{
		if (!ParchmentPage(out))
			return false;
		ShadeGutter(out, n % 2 == 0);
		if (!book || !Fonts())
			return true;
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
			return true;
		}
		const int index = n - 1;
		if (index >= static_cast<int>(book->pages.size()))
		{
			// Past the end: blank, but for a flourish on the page after the last
			if (index == static_cast<int>(book->pages.size()))
				Flourish(out, static_cast<int>(x0 + textW * 0.5f), kPageH / 3, 90, kFaint);
			return true;
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
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// The cover: the book's title in gilt capitals, on a plate the renderer cuts away round the letters
	// ------------------------------------------------------------------------------------------

	constexpr int kCoverW = 1024, kCoverH = 768;   // build_book.py's TITLE_W x TITLE_H
	std::mutex g_titleLock;
	std::map<std::string, std::string> g_titles;

	std::string TitleOf(const std::string& uuid)
	{
		std::lock_guard<std::mutex> hold(g_titleLock);
		const auto found = g_titles.find(uuid);
		return found == g_titles.end() ? std::string() : found->second;
	}

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
		constexpr float kLeather[3] = { 30.f, 11.f, 8.f }, kGiltDark[3] = { 40.f, 28.f, 12.f };
		constexpr float kGold[3] = { 150.f, 104.f, 46.f }, kDielectric = 59.f;   // sRGB, as book_s holds them
		for (int y = 0; y < kCoverH; ++y)
			for (int x = 0; x < kCoverW; ++x)
			{
				const size_t i = static_cast<size_t>(y) * kCoverW + x;
				uint8_t* p = &out.pixels[i * 4];
				const float rim = std::clamp(spread[i] * 3.5f, 0.f, 1.f);
				// Gilt in the letters, rubbed through where the noise is high and towards their edges
				const float rub = std::clamp((CoverNoise(x / 46.f, y / 46.f) * 0.7f + CoverNoise(x / 9.f, y / 9.f) * 0.3f - 0.6f) * 6.f, 0.f, 1.f);
				const float gilt = std::clamp((letters[i] - 0.35f) * 3.f, 0.f, 1.f) * (1.f - rub * 0.85f);
				if (layer == kCoverColour)
				{
					// Darker the nearer the letter, where the tool pressed hardest
					const float press = 1.f - 0.45f * std::clamp(spread[i] * 2.f, 0.f, 1.f);
					for (int k = 0; k < 3; ++k)
						p[k] = static_cast<uint8_t>(kLeather[k] * press + (kGiltDark[k] - kLeather[k] * press) * gilt);
					p[3] = static_cast<uint8_t>(std::max(rim, letters[i]) * 255.f);
				}
				else if (layer == kCoverSpecular)
				{
					for (int k = 0; k < 3; ++k)
						p[k] = static_cast<uint8_t>(kDielectric + (kGold[k] - kDielectric) * gilt);
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
		if (!WritePage(book.get(), n, *page))
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
	if (key == "book_d")
		ok = Decode(POTP_RES_BOOK_DIFFUSE, largestSide, out);
	else if (key == "book_s")
		ok = Decode(POTP_RES_BOOK_SPECULAR, largestSide, out);
	else if (key == "parchment")
		ok = Decode(POTP_RES_PARCHMENT, largestSide, out);
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
	// PBK2 adds a 13th float a vertex: the height of the stack's underside under it
	const bool withBase = data.size() >= 8 && memcmp(at, "PBK2", 4) == 0;
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
		const size_t floats = withBase ? 13 : 12;
		if (!Take(at, end, material) || !Take(at, end, vertices) || end - at < static_cast<ptrdiff_t>(vertices * floats * 4))
			break;
		ModelPart part;
		part.vertices.resize(vertices);
		for (ModelVertex& v : part.vertices)
		{
			float f[13] = {};
			memcpy(f, at, floats * 4);
			at += floats * 4;
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
			part.diffuse = std::string(kBuiltinTexture) + "book_d";
			part.normal = std::string(kBuiltinTexture) + "book_n";
			part.specular = std::string(kBuiltinTexture) + "book_s";
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
			paper(part, std::string(kBuiltinTexture) + "edges");
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

void BookSetTitle(const std::string& uuid, const std::string& title)
{
	std::lock_guard<std::mutex> hold(g_titleLock);
	g_titles[uuid] = title;
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
	if (g_shown.uuid.empty() || g_shown.turning != 0 || g_shown.settle > 0)
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

void BookTick(float dt)
{
	constexpr float kTurnSeconds = 0.75f;
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
	ModelViewBook(sheet, sheet2);
}

int BookSpread() { return g_shown.spread; }
int BookSpreadCount() { return Spreads(g_shown.uuid); }
int BookPageCount() { std::lock_guard<std::mutex> hold(g_bookLock); const auto f = g_books.find(g_shown.uuid); return f == g_books.end() ? 0 : f->second->Count(); }
bool BookTurning() { return g_shown.turning != 0 || g_shown.settle > 0; }
