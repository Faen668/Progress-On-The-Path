#include "cardart.h"
#include <windows.h>
#include <dxgiformat.h>
#include <algorithm>
#include <atomic>
#include <cmath>
#include <cstring>
#include <filesystem>
#include <map>
#include <set>
#include "log.h"

namespace
{
	const char* const kResource = "gameplay\\gui_new\\swf\\gwint\\deck_builder.redswf";

	std::atomic<bool> g_ready{ false };
	std::map<std::string, std::vector<CardPiece>> g_frames[kClipCount];
	std::vector<GameTexture> g_atlases;

	bool Lz4Block(const uint8_t* in, size_t size, uint8_t* out, size_t room);

	uint32_t U32(const uint8_t* p) { uint32_t v; memcpy(&v, p, 4); return v; }
	uint16_t U16(const uint8_t* p) { uint16_t v; memcpy(&v, p, 2); return v; }

	bool Lz4Block(const uint8_t* in, size_t size, uint8_t* out, size_t room)
	{
		size_t i = 0, o = 0;
		while (i < size)
		{
			const uint8_t token = in[i++];
			size_t literals = token >> 4;
			if (literals == 15)
				for (uint8_t more = 255; more == 255 && i < size; literals += more)
					more = in[i++];
			if (i + literals > size || o + literals > room)
				return false;
			memcpy(out + o, in + i, literals);
			i += literals;
			o += literals;
			if (i >= size)
				break;
			if (i + 2 > size)
				return false;
			const size_t distance = U16(in + i);
			i += 2;
			size_t length = token & 15;
			if (length == 15)
				for (uint8_t more = 255; more == 255 && i < size; length += more)
					more = in[i++];
			length += 4;
			if (distance == 0 || distance > o || o + length > room)
				return false;
			for (size_t k = 0; k < length; ++k, ++o)
				out[o] = out[o - distance];
		}
		return o == room;
	}

	bool ReadFromBundle(const std::wstring& path, std::vector<uint8_t>& out)
	{
		const HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
		if (file == INVALID_HANDLE_VALUE)
			return false;
		const auto read = [&](uint64_t at, void* to, size_t count)
		{
			LARGE_INTEGER offset;
			offset.QuadPart = static_cast<LONGLONG>(at);
			DWORD got = 0;
			return SetFilePointerEx(file, offset, nullptr, FILE_BEGIN) && ReadFile(file, to, static_cast<DWORD>(count), &got, nullptr) && got == count;
		};
		bool done = false;
		uint8_t header[32];
		if (read(0, header, sizeof(header)) && memcmp(header, "POTATO70", 8) == 0 && (U16(header + 0x14) == 5 || U16(header + 0x14) == 3))
		{
			const bool older = U16(header + 0x14) == 3;   // what older tools made, as many mods still are
			const size_t kEntry = older ? 0x140 : 0x130;
			const size_t tocSize = U32(header + 0x10);
			std::vector<uint8_t> toc(tocSize);
			if (tocSize % kEntry == 0 && read(32, toc.data(), tocSize))
				for (size_t at = 0; at < tocSize && !done; at += kEntry)
				{
					const uint8_t* e = toc.data() + at;
					if (_stricmp(reinterpret_cast<const char*>(e), kResource) != 0)
						continue;
					uint64_t offset = U32(e + 0x11C);
					if (!older)
						memcpy(&offset, e + 0x110, 8);
					const uint32_t size = older ? U32(e + 0x114) : U32(e + 0x118), packed = older ? U32(e + 0x118) : U32(e + 0x11C), kind = older ? U32(e + 0x13C) : U32(e + 0x124);
					std::vector<uint8_t> in(packed);
					if (!read(offset, in.data(), packed))
						break;
					out.resize(size);
					switch (kind)
					{
					case 0: done = packed == size; if (done) out = std::move(in); break;
					case 1: done = InflateGameData(in.data(), packed, out.data(), size); break;
					case 4: case 5: done = UnpackLz4(in.data(), packed, out.data(), size); break;
					default: Log("card art: packed in a way that isn't handled (%u)", kind); break;
					}
					if (!done)
						Log("card art: can't unpack it from %ls", path.c_str());
				}
		}
		CloseHandle(file);
		return done;
	}

	struct Bits
	{
		const uint8_t* d;
		size_t p;
		int bit = 0;
		uint32_t U(int n)
		{
			uint32_t v = 0;
			for (int i = 0; i < n; ++i)
			{
				v = (v << 1) | ((d[p] >> (7 - bit)) & 1);
				if (++bit == 8)
				{
					bit = 0;
					++p;
				}
			}
			return v;
		}
		int32_t I(int n)
		{
			const uint32_t v = U(n);
			return n > 0 && (v >> (n - 1)) ? static_cast<int32_t>(v) - (1 << n) : static_cast<int32_t>(v);
		}
		size_t Align()
		{
			if (bit)
			{
				bit = 0;
				++p;
			}
			return p;
		}
	};

	// x' = a x + c y + tx, y' = b x + d y + ty
	struct Matrix
	{
		float a = 1.f, b = 0.f, c = 0.f, d = 1.f, tx = 0.f, ty = 0.f;
		Matrix Then(const Matrix& o) const   // this first, then o
		{
			Matrix m;
			m.a = o.a * a + o.c * b;
			m.b = o.b * a + o.d * b;
			m.c = o.a * c + o.c * d;
			m.d = o.b * c + o.d * d;
			m.tx = o.a * tx + o.c * ty + o.tx;
			m.ty = o.b * tx + o.d * ty + o.ty;
			return m;
		}
	};

	Matrix ReadMatrix(const uint8_t* d, size_t& p)
	{
		Bits r{ d, p };
		Matrix m;
		if (r.U(1))
		{
			const int n = static_cast<int>(r.U(5));
			m.a = r.I(n) / 65536.f;
			m.d = r.I(n) / 65536.f;
		}
		if (r.U(1))
		{
			const int n = static_cast<int>(r.U(5));
			m.b = r.I(n) / 65536.f;
			m.c = r.I(n) / 65536.f;
		}
		const int n = static_cast<int>(r.U(5));
		m.tx = r.I(n) / 20.f;
		m.ty = r.I(n) / 20.f;
		p = r.Align();
		return m;
	}

	size_t SkipRect(const uint8_t* d, size_t p)
	{
		Bits r{ d, p };
		const int n = static_cast<int>(r.U(5));
		for (int i = 0; i < 4; ++i)
			r.U(n);
		return r.Align();
	}

	struct SubImage { int atlas; uint16_t x0, y0, x1, y1; };
	struct Fill { uint16_t bitmap; Matrix m; };
	struct Placed { int character = -1; Matrix m; std::string name; };
	using Display = std::map<int, Placed>;
	struct Sprite { size_t at = 0, end = 0; };

	struct Gfx
	{
		const uint8_t* d = nullptr;
		std::map<int, SubImage> subs;
		std::map<int, std::string> atlasNames;
		std::map<int, std::vector<Fill>> shapes;
		std::map<int, Sprite> sprites;
		std::map<std::string, int> classes;
	};

	template <typename F>
	void EachTag(const uint8_t* d, size_t p, size_t end, F&& visit)
	{
		while (p + 2 <= end)
		{
			const uint16_t h = U16(d + p);
			p += 2;
			const int tag = h >> 6;
			size_t length = h & 63;
			if (length == 63)
			{
				length = U32(d + p);
				p += 4;
			}
			if (p + length > end)
				return;
			visit(tag, p, length);
			p += length;
			if (tag == 0)
				return;
		}
	}

	void ReadShape(Gfx& g, int tag, size_t p)
	{
		const uint8_t* d = g.d;
		const int id = U16(d + p);
		size_t q = SkipRect(d, p + 2);
		if (tag == 83)
			q = SkipRect(d, q) + 1;
		int count = d[q++];
		if (count == 255)
		{
			count = U16(d + q);
			q += 2;
		}
		std::vector<Fill> fills;
		for (int i = 0; i < count; ++i)
		{
			const int kind = d[q++];
			if (kind == 0)
			{
				q += tag >= 32 ? 4 : 3;
				continue;
			}
			if (kind < 0x40 || kind > 0x43)
				break;   // a gradient: nothing the card uses
			const uint16_t bitmap = U16(d + q);
			q += 2;
			Fill fill{ bitmap, ReadMatrix(d, q) };
			if (bitmap != 0xFFFF)
				fills.push_back(fill);
		}
		g.shapes[id] = std::move(fills);
	}

	// What's on show in a sprite at each labelled frame, playing its timeline from the start
	void PlaySprite(const Gfx& g, const Sprite& s, std::map<std::string, Display>* labelled, Display* firstFrame)
	{
		Display display;
		int frame = 0;
		std::vector<std::pair<std::string, int>> labels;
		std::map<int, Display> frames;
		const uint8_t* d = g.d;
		EachTag(d, s.at, s.end, [&](int tag, size_t p, size_t)
		{
			if (tag == 1)
			{
				frames[frame++] = display;
			}
			else if (tag == 43)
			{
				labels.emplace_back(reinterpret_cast<const char*>(d + p), frame);
			}
			else if (tag == 28)
			{
				display.erase(U16(d + p));
			}
			else if (tag == 5)
			{
				display.erase(U16(d + p + 2));
			}
			else if (tag == 26 || tag == 70)
			{
				size_t q = p;
				const uint8_t flags = d[q++];
				uint8_t more = 0;
				if (tag == 70)
					more = d[q++];
				const int depth = U16(d + q);
				q += 2;
				if (tag == 70 && (more & 8))
					q += strlen(reinterpret_cast<const char*>(d + q)) + 1;
				Placed& placed = display[depth];
				if (!(flags & 1))
					placed = Placed{};
				if (flags & 2)
				{
					placed.character = U16(d + q);
					q += 2;
				}
				if (flags & 4)
					placed.m = ReadMatrix(d, q);
				if (flags & 8)
				{
					Bits r{ d, q };
					const uint32_t add = r.U(1), multiply = r.U(1);
					const int n = static_cast<int>(r.U(4));
					for (uint32_t i = 0; i < 4 * (add + multiply); ++i)
						r.U(n);
					q = r.Align();
				}
				if (flags & 16)
					q += 2;
				if (flags & 32)
					placed.name = reinterpret_cast<const char*>(d + q);
			}
		});
		if (firstFrame && frames.count(0))
			*firstFrame = frames[0];
		if (labelled)
			for (const auto& [name, at] : labels)
				if (frames.count(at))
					(*labelled)[name] = frames[at];
	}

	void Collect(const Gfx& g, const Display& display, const Matrix& outer, std::vector<CardPiece>& out, int level = 0)
	{
		if (level > 6)
			return;
		for (const auto& [depth, placed] : display)
		{
			const Matrix m = placed.m.Then(outer);
			const auto shape = g.shapes.find(placed.character);
			if (shape != g.shapes.end())
			{
				for (const Fill& fill : shape->second)
				{
					const auto sub = g.subs.find(fill.bitmap);
					if (sub == g.subs.end())
						continue;
					Matrix f = fill.m;
					f.a /= 20.f; f.b /= 20.f; f.c /= 20.f; f.d /= 20.f;
					const Matrix whole = f.Then(m);
					const float w = static_cast<float>(sub->second.x1 - sub->second.x0), h = static_cast<float>(sub->second.y1 - sub->second.y0);
					CardPiece piece;
					piece.atlas = sub->second.atlas;
					piece.u0 = sub->second.x0;
					piece.v0 = sub->second.y0;
					piece.u1 = sub->second.x1;
					piece.v1 = sub->second.y1;
					const float cx[4] = { 0.f, w, w, 0.f }, cy[4] = { 0.f, 0.f, h, h };
					for (int i = 0; i < 4; ++i)
					{
						piece.x[i] = whole.a * cx[i] + whole.c * cy[i] + whole.tx;
						piece.y[i] = whole.b * cx[i] + whole.d * cy[i] + whole.ty;
					}
					out.push_back(piece);
				}
				continue;
			}
			const auto sprite = g.sprites.find(placed.character);
			if (sprite != g.sprites.end())
			{
				Display inner;
				PlaySprite(g, sprite->second, nullptr, &inner);
				Collect(g, inner, m, out, level + 1);
			}
		}
	}

	bool ReadGfx(Gfx& g, const std::vector<uint8_t>& file)
	{
		const uint8_t* d = g.d = file.data();
		const size_t start = SkipRect(d, 0) + 4;
		EachTag(d, start, file.size(), [&](int tag, size_t p, size_t length)
		{
			switch (tag)
			{
			case 1008:
				if (length >= 12)
					g.subs[U16(d + p)] = SubImage{ U16(d + p + 2), U16(d + p + 4), U16(d + p + 6), U16(d + p + 8), U16(d + p + 10) };
				break;
			case 1009:
			{
				size_t q = p + 10;
				q += 1 + d[q];
				g.atlasNames[U16(d + p)] = std::string(reinterpret_cast<const char*>(d + q + 1), d[q]);
				break;
			}
			case 2: case 22: case 32: case 83:
				ReadShape(g, tag, p);
				break;
			case 39:
				g.sprites[U16(d + p)] = Sprite{ p + 4, p + length };
				break;
			case 76:
			{
				const int count = U16(d + p);
				size_t q = p + 2;
				for (int i = 0; i < count; ++i)
				{
					const int id = U16(d + q);
					const std::string name = reinterpret_cast<const char*>(d + q + 2);
					q += 3 + name.size();
					g.classes[name] = id;
				}
				break;
			}
			default:
				break;
			}
		});
		return g.classes.count("CardSlotRef") != 0;
	}

	struct Texture { std::string name; size_t data = 0, end = 0; };

	// Its exports: the menu's GFX, then each picture it was cut into
	bool ReadResource(const std::vector<uint8_t>& file, std::vector<uint8_t>& gfx, std::vector<Texture>& textures)
	{
		const uint8_t* b = file.data();
		if (file.size() < 160 || memcmp(b, "CR2W", 4) != 0)
			return false;
		const auto table = [&](int i, uint32_t& at, uint32_t& count) { at = U32(b + 40 + i * 12); count = U32(b + 44 + i * 12); };
		uint32_t stringsAt, stringsSize, namesAt, nameCount, exportsAt, exportCount;
		table(0, stringsAt, stringsSize);
		table(1, namesAt, nameCount);
		table(4, exportsAt, exportCount);
		std::vector<std::string> names(nameCount);
		for (uint32_t i = 0; i < nameCount; ++i)
			names[i] = reinterpret_cast<const char*>(b + stringsAt + U32(b + namesAt + i * 8));
		for (uint32_t i = 0; i < exportCount; ++i)
		{
			const uint8_t* e = b + exportsAt + i * 24;
			const std::string& type = names[U16(e)];
			const uint32_t size = U32(e + 8), offset = U32(e + 12);
			size_t p = offset + 1;
			std::string linkage;
			while (p + 8 <= offset + size)
			{
				const uint16_t name = U16(b + p);
				if (name == 0)
				{
					p += 2;
					break;
				}
				const uint32_t valueSize = U32(b + p + 4);
				if (names[name] == "linkageName" && valueSize > 5)
					linkage.assign(reinterpret_cast<const char*>(b + p + 9), valueSize - 5);
				p += 4 + valueSize;
			}
			if (type == "CSwfResource")
			{
				for (size_t at = p; at + 8 < offset + size && at < p + 256; ++at)
				{
					if ((b[at] != 'C' && b[at] != 'G' && b[at] != 'F') || (memcmp(b + at + 1, "FX", 2) != 0 && memcmp(b + at + 1, "WS", 2) != 0))
						continue;
					const uint32_t length = U32(b + at + 4);
					if (length < 8)
						continue;
					// Its header's size can be a little out, so it's only a guide
					if (b[at] == 'C')
					{
						gfx.resize(static_cast<size_t>(length) * 2);
						if (!InflateGameDataUpTo(b + at + 8, offset + size - at - 8, gfx))
							return false;
					}
					else
					{
						gfx.assign(b + at + 8, b + offset + size);
					}
					break;
				}
			}
			else if (type == "CSwfTexture")
			{
				textures.push_back(Texture{ linkage, p, offset + size });
			}
		}
		return !gfx.empty();
	}

	bool Load(const std::vector<uint8_t>& resource)
	{
		std::vector<uint8_t> gfxFile;
		std::vector<Texture> textures;
		if (!ReadResource(resource, gfxFile, textures))
			return Log("card art: no menu in the resource"), false;
		Gfx g;
		if (!ReadGfx(g, gfxFile))
			return Log("card art: no card in the menu (%zu bytes, %zu classes, %zu sprites, %zu shapes)", gfxFile.size(), g.classes.size(), g.sprites.size(), g.shapes.size()), false;

		Display card;
		PlaySprite(g, g.sprites[g.classes["CardSlotRef"]], nullptr, &card);

		// The game's menu places these itself, from the card's top left corner (CardSlot.as)
		const struct { CardClip clip; const char* name; float x, y; bool fromSymbol; } clips[] = {
			{ kClipBanner, "mcFactionBanner", 0.f, 0.f, false },
			{ kClipPower, "mcPowerIndicator", 0.f, 0.f, false },
			{ kClipType, "mcTypeIcon", 68.5f, 167.5f, false },
			{ kClipEffect, "mcEffectIcon1", 43.5f, 292.f, false },
			{ kClipParchment, "mcDesc", 155.75f, 292.f, true },   // level with the picture's left edge
		};
		std::map<int, int> atlasSlots;
		for (const auto& clip : clips)
			for (const auto& [depth, placed] : card)
			{
				if (placed.name != clip.name)
					continue;
				Matrix at;
				at.tx = clip.x;
				at.ty = clip.y;
				if (clip.fromSymbol)
					at = placed.m.Then(at);
				std::map<std::string, Display> frames;
				const auto sprite = g.sprites.find(placed.character);
				if (sprite == g.sprites.end())
					continue;
				PlaySprite(g, sprite->second, &frames, nullptr);
				for (const auto& [label, display] : frames)
				{
					std::vector<CardPiece> pieces;
					Collect(g, display, at, pieces);
					g_frames[clip.clip][label] = std::move(pieces);
				}
			}

		// The faction shields, which the menu's deck list has
		for (const auto& [name, id] : g.classes)
		{
			const auto sprite = g.sprites.find(id);
			if (name.find("mcFactionIcon") == std::string::npos || sprite == g.sprites.end())
				continue;
			std::map<std::string, Display> frames;
			PlaySprite(g, sprite->second, &frames, nullptr);
			for (const auto& [label, display] : frames)
			{
				std::vector<CardPiece> pieces;
				Collect(g, display, Matrix{}, pieces);
				g_frames[kClipShield][label] = std::move(pieces);
			}
			break;
		}

		// Only the pictures the card uses, and each piece's place in its picture as 0 to 1
		for (auto& frames : g_frames)
			for (auto& [label, pieces] : frames)
				for (auto& piece : pieces)
				{
					auto slot = atlasSlots.find(piece.atlas);
					if (slot == atlasSlots.end())
					{
						GameTexture texture;
						const auto name = g.atlasNames.find(piece.atlas);
						if (name != g.atlasNames.end())
							for (const Texture& t : textures)
							{
								if (t.name != name->second)
									continue;
								const uint8_t* h = resource.data() + t.data;
								const uint32_t w = U32(h + 8), rows = U32(h + 12), pitch = U32(h + 16), size = U32(h + 20);
								const uint32_t blocks = std::max(1u, (w + 3) / 4);
								if (t.data + 28 + size > t.end || pitch == 0 || (pitch != blocks * 8 && pitch != blocks * 16) || w % 4 != 0 || rows % 4 != 0)
								{
									Log("card art: %s isn't a kind of picture that's handled", t.name.c_str());
									break;
								}
								texture.dxgiFormat = pitch == blocks * 16 ? DXGI_FORMAT_BC3_UNORM : DXGI_FORMAT_BC1_UNORM;
								texture.width = w;
								texture.height = rows;
								texture.rowBytes = pitch;
								texture.rows = (rows + 3) / 4;
								texture.pixels.assign(h + 28, h + 28 + size);
								break;
							}
						slot = atlasSlots.emplace(piece.atlas, static_cast<int>(g_atlases.size())).first;
						g_atlases.push_back(std::move(texture));
					}
					const GameTexture& texture = g_atlases[slot->second];
					piece.atlas = slot->second;
					const float w = std::max(1.f, static_cast<float>(texture.width)), h = std::max(1.f, static_cast<float>(texture.height));
					piece.u0 /= w;
					piece.u1 /= w;
					piece.v0 /= h;
					piece.v1 /= h;
				}
		return !g_frames[kClipBanner].empty();
	}
}

bool UnpackLz4(const uint8_t* in, size_t size, uint8_t* out, size_t room)
{
	return Lz4Block(in, size, out, room);
}

bool UpscaleCardArt(const GameTexture& source, GameTexture& out)
{
	if ((source.dxgiFormat != DXGI_FORMAT_BC3_UNORM && source.dxgiFormat != DXGI_FORMAT_BC1_UNORM) || source.width == 0 || source.height == 0)
		return false;
	const bool alpha = source.dxgiFormat == DXGI_FORMAT_BC3_UNORM;
	const uint32_t w = source.width, h = source.height;
	const size_t blockBytes = alpha ? 16 : 8;
	if (source.pixels.size() < static_cast<size_t>(source.rows) * ((w + 3) / 4) * blockBytes)
		return false;

	// Out of its compression, into plain colours
	std::vector<uint8_t> rgba(static_cast<size_t>(w) * h * 4, 255);
	const uint8_t* block = source.pixels.data();
	for (uint32_t by = 0; by < source.rows; ++by)
		for (uint32_t bx = 0; bx < (w + 3) / 4; ++bx, block += blockBytes)
		{
			uint8_t alphas[8] = { 255, 255, 255, 255, 255, 255, 255, 255 };
			uint64_t alphaBits = 0;
			const uint8_t* colour = block;
			if (alpha)
			{
				const int a0 = block[0], a1 = block[1];
				alphas[0] = block[0];
				alphas[1] = block[1];
				if (a0 > a1)
				{
					for (int i = 1; i < 7; ++i)
						alphas[i + 1] = static_cast<uint8_t>(((7 - i) * a0 + i * a1) / 7);
				}
				else
				{
					for (int i = 1; i < 5; ++i)
						alphas[i + 1] = static_cast<uint8_t>(((5 - i) * a0 + i * a1) / 5);
					alphas[6] = 0;
					alphas[7] = 255;
				}
				memcpy(&alphaBits, block + 2, 6);
				colour = block + 8;
			}
			const uint16_t c0 = U16(colour), c1 = U16(colour + 2);
			const uint32_t bits = U32(colour + 4);
			const int r0 = (c0 >> 11) * 255 / 31, g0 = ((c0 >> 5) & 63) * 255 / 63, b0 = (c0 & 31) * 255 / 31;
			const int r1 = (c1 >> 11) * 255 / 31, g1 = ((c1 >> 5) & 63) * 255 / 63, b1 = (c1 & 31) * 255 / 31;
			int palette[4][3] = { { r0, g0, b0 }, { r1, g1, b1 }, {}, {} };
			const bool fourColours = alpha || c0 > c1;
			for (int ch = 0; ch < 3; ++ch)
			{
				palette[2][ch] = fourColours ? (2 * palette[0][ch] + palette[1][ch]) / 3 : (palette[0][ch] + palette[1][ch]) / 2;
				palette[3][ch] = fourColours ? (palette[0][ch] + 2 * palette[1][ch]) / 3 : 0;
			}
			for (uint32_t py = 0; py < 4; ++py)
				for (uint32_t px = 0; px < 4; ++px)
				{
					const uint32_t x = bx * 4 + px, y = by * 4 + py;
					if (x >= w || y >= h)
						continue;
					const int index = (bits >> (2 * (py * 4 + px))) & 3;
					uint8_t* o = rgba.data() + (static_cast<size_t>(y) * w + x) * 4;
					o[0] = static_cast<uint8_t>(palette[index][0]);
					o[1] = static_cast<uint8_t>(palette[index][1]);
					o[2] = static_cast<uint8_t>(palette[index][2]);
					o[3] = alpha ? alphas[(alphaBits >> (3 * (py * 4 + px))) & 7] : static_cast<uint8_t>(!fourColours && index == 3 ? 0 : 255);
				}
		}

	// A cubic filter a little sharper than the usual one, across and then down
	const auto weight = [](float t)
	{
		constexpr float a = -0.75f;
		t = fabsf(t);
		if (t < 1.f)
			return (a + 2.f) * t * t * t - (a + 3.f) * t * t + 1.f;
		if (t < 2.f)
			return a * t * t * t - 5.f * a * t * t + 8.f * a * t - 4.f * a;
		return 0.f;
	};
	// A new pixel X sits at X / 2 - 0.25 in the old picture: a quarter short of an old pixel when X is even, a
	// quarter past one when it's odd. Four old pixels each side of that, with these weights:
	float even[4], odd[4];
	for (int i = 0; i < 4; ++i)
	{
		even[i] = weight(static_cast<float>(i) - 1.75f);
		odd[i] = weight(static_cast<float>(i) - 1.25f);
	}
	const uint32_t W = w * 2, H = h * 2;
	std::vector<float> across(static_cast<size_t>(W) * h * 4);
	for (uint32_t y = 0; y < h; ++y)
		for (uint32_t X = 0; X < W; ++X)
		{
			const bool isOdd = X & 1;
			const int first = static_cast<int>(X / 2) - (isOdd ? 1 : 2);
			const float* f = isOdd ? odd : even;
			float* o = across.data() + (static_cast<size_t>(y) * W + X) * 4;
			for (int i = 0; i < 4; ++i)
			{
				const int sx = std::clamp(first + i, 0, static_cast<int>(w) - 1);
				const uint8_t* source4 = rgba.data() + (static_cast<size_t>(y) * w + sx) * 4;
				for (int ch = 0; ch < 4; ++ch)
					o[ch] += f[i] * source4[ch];
			}
		}
	out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	out.width = W;
	out.height = H;
	out.rowBytes = W * 4;
	out.rows = H;
	out.pixels.resize(static_cast<size_t>(W) * H * 4);
	for (uint32_t Y = 0; Y < H; ++Y)
	{
		const bool isOdd = Y & 1;
		const int first = static_cast<int>(Y / 2) - (isOdd ? 1 : 2);
		const float* f = isOdd ? odd : even;
		uint8_t* o = out.pixels.data() + static_cast<size_t>(Y) * W * 4;
		for (uint32_t X = 0; X < W; ++X, o += 4)
		{
			float sum[4] = {};
			for (int i = 0; i < 4; ++i)
			{
				const int sy = std::clamp(first + i, 0, static_cast<int>(h) - 1);
				const float* s = across.data() + (static_cast<size_t>(sy) * W + X) * 4;
				for (int ch = 0; ch < 4; ++ch)
					sum[ch] += f[i] * s[ch];
			}
			for (int ch = 0; ch < 4; ++ch)
				o[ch] = static_cast<uint8_t>(std::clamp(sum[ch] + 0.5f, 0.f, 255.f));
		}
	}
	return true;
}

void BuildCardArt(const std::wstring& game)
{
	namespace fs = std::filesystem;
	std::error_code ec;

	// In the order the game looks: mods, DLC, then the game
	std::vector<fs::path> bundles;
	const auto add = [&](const fs::path& folder)
	{
		std::vector<fs::path> found;
		for (const auto& item : fs::directory_iterator(folder, ec))
			if (item.path().extension() == L".bundle")
				found.push_back(item.path());
		std::sort(found.begin(), found.end());
		bundles.insert(bundles.end(), found.begin(), found.end());
	};
	for (const wchar_t* top : { L"mods", L"dlc" })
	{
		std::vector<fs::path> owners;
		for (const auto& item : fs::directory_iterator(fs::path(game) / top, ec))
			if (item.is_directory(ec))
				owners.push_back(item.path());
		std::sort(owners.begin(), owners.end());
		for (const fs::path& owner : owners)
			add(owner / L"content");
	}
	add(fs::path(game) / L"content" / L"content0" / L"bundles");

	for (const fs::path& bundle : bundles)
	{
		std::vector<uint8_t> resource;
		if (!ReadFromBundle(bundle.wstring(), resource))
			continue;
		if (Load(resource))
		{
			Log("card art: %zu pictures from %ls", g_atlases.size(), bundle.filename().c_str());
			g_ready = true;
			return;
		}
		Log("card art: can't read the menu in %ls", bundle.c_str());
	}
	Log("card art: the Gwent menu wasn't found");
}

bool CardArtReady()
{
	return g_ready;
}

const std::vector<CardPiece>* CardArtFrame(CardClip clip, const std::string& label)
{
	if (!g_ready)
		return nullptr;
	const auto found = g_frames[clip].find(label);
	return found != g_frames[clip].end() ? &found->second : nullptr;
}

const GameTexture* CardArtAtlas(int atlas)
{
	return g_ready && atlas >= 0 && atlas < static_cast<int>(g_atlases.size()) && !g_atlases[atlas].pixels.empty() ? &g_atlases[atlas] : nullptr;
}
