#include "cardart.h"
#include <windows.h>
#include <dxgiformat.h>
#include <algorithm>
#include <array>
#include <cfloat>
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

	bool ReadFromBundle(const std::wstring& path, std::vector<uint8_t>& out, const char* resource = kResource)
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
					if (_stricmp(reinterpret_cast<const char*>(e), resource) != 0)
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
	struct Placed { int character = -1; Matrix m; std::string name; float mul[4] = { 1.f, 1.f, 1.f, 1.f }, add[4] = {}; bool mask = false; };   // colour: c * mul + add, 0 to 1
	using Display = std::map<int, Placed>;
	struct Sprite { size_t at = 0, end = 0; };

	struct Gfx
	{
		const uint8_t* d = nullptr;
		std::map<int, std::pair<int, size_t>> shapeAt;   // a shape's tag and where it starts, for drawing it whole
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
		g.shapeAt[id] = { tag, p };
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
					for (int i = 0; i < 4; ++i)
						placed.mul[i] = multiply ? r.I(n) / 256.f : 1.f;
					for (int i = 0; i < 4; ++i)
						placed.add[i] = add ? r.I(n) / 255.f : 0.f;
					q = r.Align();
				}
				if (flags & 16)
					q += 2;
				if (flags & 32)
				{
					placed.name = reinterpret_cast<const char*>(d + q);
					q += placed.name.size() + 1;
				}
				if (flags & 64)
					placed.mask = true;   // it clips what's above it, and isn't drawn itself
			}
		});
		if (firstFrame && frames.count(0))
			*firstFrame = frames[0];
		if (labelled)
			for (const auto& [name, at] : labels)
				if (frames.count(at))
					(*labelled)[name] = frames[at];
	}

	// A shape drawn with outlines and colours rather than a picture, as Cow's ability is: drawn into a picture of its own
	// (further down, with the map pins' drawing). Its place on the card in box: left, top, right, bottom.
	bool DrawCardShape(const Gfx& g, int shape, const Matrix& m, GameTexture& out, float box[4]);

	using VectorParts = std::vector<std::pair<int, Matrix>>;

	void Collect(const Gfx& g, const Display& display, const Matrix& outer, std::vector<CardPiece>& out, int level = 0, VectorParts* vectors = nullptr)
	{
		if (level > 6)
			return;
		for (const auto& [depth, placed] : display)
		{
			const Matrix m = placed.m.Then(outer);
			const auto shape = g.shapes.find(placed.character);
			if (shape != g.shapes.end())
			{
				if (shape->second.empty() && vectors)
				{
					vectors->emplace_back(placed.character, m);
					continue;
				}
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
				Collect(g, inner, m, out, level + 1, vectors);
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
					VectorParts vectors;
					Collect(g, display, at, pieces, 0, &vectors);
					for (const auto& [shape, m] : vectors)
					{
						GameTexture picture;
						float box[4];
						if (!DrawCardShape(g, shape, m, picture, box))
							continue;
						// Its own picture, not one of the menu's, so a key of its own below theirs
						const int key = -2 - static_cast<int>(g_atlases.size());
						CardPiece piece;
						piece.atlas = key;
						piece.u0 = 0.f;
						piece.v0 = 0.f;
						piece.u1 = static_cast<float>(picture.width);
						piece.v1 = static_cast<float>(picture.height);
						const float px[4] = { box[0], box[2], box[2], box[0] }, py[4] = { box[1], box[1], box[3], box[3] };
						for (int i = 0; i < 4; ++i)
						{
							piece.x[i] = px[i];
							piece.y[i] = py[i];
						}
						atlasSlots[key] = static_cast<int>(g_atlases.size());
						g_atlases.push_back(std::move(picture));
						pieces.push_back(piece);
					}
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
			std::string labels;
			for (const auto& [label, pieces] : g_frames[kClipShield])
				labels += " " + label;
			Log("card art: faction shields:%s", labels.c_str());
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

// Out of its compression, into plain colours
bool DecodeCardArt(const GameTexture& source, std::vector<uint8_t>& rgba)
{
	// One of ours, drawn from a shape: already plain colours
	if (source.dxgiFormat == DXGI_FORMAT_R8G8B8A8_UNORM && source.pixels.size() >= static_cast<size_t>(source.width) * source.height * 4)
	{
		rgba.assign(source.pixels.begin(), source.pixels.begin() + static_cast<size_t>(source.width) * source.height * 4);
		return true;
	}
	if ((source.dxgiFormat != DXGI_FORMAT_BC3_UNORM && source.dxgiFormat != DXGI_FORMAT_BC1_UNORM) || source.width == 0 || source.height == 0)
		return false;
	const bool alpha = source.dxgiFormat == DXGI_FORMAT_BC3_UNORM;
	const uint32_t w = source.width, h = source.height;
	const size_t blockBytes = alpha ? 16 : 8;
	if (source.pixels.size() < static_cast<size_t>(source.rows) * ((w + 3) / 4) * blockBytes)
		return false;
	rgba.assign(static_cast<size_t>(w) * h * 4, 255);
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
	return true;
}

bool UpscaleCardArt(const GameTexture& source, GameTexture& out)
{
	std::vector<uint8_t> rgba;
	if (!DecodeCardArt(source, rgba))
		return false;
	const uint32_t w = source.width, h = source.height;

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

// Every bundle, in the order the game looks: mods, DLC, then the game
static std::vector<std::filesystem::path> GameBundles(const std::wstring& game)
{
	namespace fs = std::filesystem;
	std::error_code ec;
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
	return bundles;
}

void BuildCardArt(const std::wstring& game)
{
	namespace fs = std::filesystem;
	for (const fs::path& bundle : GameBundles(game))
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

// Its smaller levels, each averaged from the one above, colour weighted by how opaque it is so a clear surround
// doesn't darken an edge. The picture is plain RGBA.
static void AddSmallerLevels(GameTexture& out)
{
	const GameTexture* from = &out;
	std::vector<GameTexture> mips;
	mips.reserve(8);
	while (from->width >= 2 && from->height >= 2 && mips.size() < 6)
	{
		GameTexture m;
		m.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
		m.width = from->width / 2;
		m.height = from->height / 2;
		m.rowBytes = m.width * 4;
		m.rows = m.height;
		m.pixels.resize(static_cast<size_t>(m.width) * m.height * 4);
		for (uint32_t y = 0; y < m.height; ++y)
			for (uint32_t x = 0; x < m.width; ++x)
			{
				// Colour weighted by how opaque it is, so a mark's clear surround doesn't darken its edge
				const auto px = [&](uint32_t fx, uint32_t fy) { return from->pixels.data() + (static_cast<size_t>(fy) * from->width + fx) * 4; };
				const uint8_t* q[4] = { px(x * 2, y * 2), px(x * 2 + 1, y * 2), px(x * 2, y * 2 + 1), px(x * 2 + 1, y * 2 + 1) };
				int a = 0, c[3] = {};
				for (const uint8_t* p : q)
				{
					a += p[3];
					for (int k = 0; k < 3; ++k)
						c[k] += p[k] * p[3];
				}
				uint8_t* o = m.pixels.data() + (static_cast<size_t>(y) * m.width + x) * 4;
				for (int k = 0; k < 3; ++k)
					o[k] = static_cast<uint8_t>(a > 0 ? c[k] / a : (q[0][k] + q[1][k] + q[2][k] + q[3][k]) / 4);
				o[3] = static_cast<uint8_t>((a + 2) / 4);
			}
		mips.push_back(std::move(m));
		from = &mips.back();
	}
	out.lowerMips = std::move(mips);
}

// The menu's pictures cut its marks small for the deck list, but the window draws them smaller still: with its own
// smaller levels, each averaged from the one above, they stay smooth instead of losing pixels
bool CardArtAtlasWithMips(int atlas, GameTexture& out)
{
	const GameTexture* source = CardArtAtlas(atlas);
	std::vector<uint8_t> rgba;
	if (!source || !DecodeCardArt(*source, rgba))
		return false;
	out = GameTexture{};
	out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	out.width = source->width;
	out.height = source->height;
	out.rowBytes = out.width * 4;
	out.rows = out.height;
	out.pixels = std::move(rgba);
	AddSmallerLevels(out);
	return true;
}

const GameTexture* CardArtAtlas(int atlas)
{
	return g_ready && atlas >= 0 && atlas < static_cast<int>(g_atlases.size()) && !g_atlases[atlas].pixels.empty() ? &g_atlases[atlas] : nullptr;
}

static constexpr float kPiF = 3.14159265f;

// The world map's pins. The map menu draws them as shapes, not pictures: outlines filled with colours and gradients,
// so they're drawn here into pictures of our own, once, from the menu the game would load (a mod's, a DLC's, or its own).
namespace
{
	struct VFill
	{
		int kind = 0;                 // 0 solid, 0x10 linear, 0x12 or 0x13 radial, 0x40 to 0x43 a picture
		float colour[4] = { 0.f, 0.f, 0.f, 1.f };
		Matrix m;                     // a gradient's or a picture's: from its own space into the shape's, translation in pixels
		std::vector<std::pair<float, std::array<float, 4>>> stops;
		int bitmap = -1;
	};
	struct VLine { float width = 1.f; VFill fill; };
	struct VEdge { float x0, y0, x1, y1; int fill0, fill1, line; };   // styles are indexes into the shape's lists, -1 none
	struct VShape { std::vector<VFill> fills; std::vector<VLine> lines; std::vector<VEdge> edges; };

	void ReadColour(const uint8_t* d, size_t& q, bool alpha, float out[4])
	{
		out[0] = d[q] / 255.f;
		out[1] = d[q + 1] / 255.f;
		out[2] = d[q + 2] / 255.f;
		out[3] = alpha ? d[q + 3] / 255.f : 1.f;
		q += alpha ? 4 : 3;
	}

	bool ReadVFill(const uint8_t* d, size_t& q, int tag, VFill& f)
	{
		const bool alpha = tag >= 32;
		f.kind = d[q++];
		if (f.kind == 0)
		{
			ReadColour(d, q, alpha, f.colour);
			return true;
		}
		if (f.kind == 0x10 || f.kind == 0x12 || f.kind == 0x13)
		{
			f.m = ReadMatrix(d, q);
			const int count = d[q++] & 15;
			for (int i = 0; i < count; ++i)
			{
				const float ratio = d[q++] / 255.f;
				std::array<float, 4> c{};
				ReadColour(d, q, alpha, c.data());
				f.stops.emplace_back(ratio, c);
			}
			if (f.kind == 0x13)
				q += 2;   // the focal point: drawn as a plain radial one
			return true;
		}
		if (f.kind >= 0x40 && f.kind <= 0x43)
		{
			f.bitmap = U16(d + q);
			q += 2;
			f.m = ReadMatrix(d, q);
			return true;
		}
		return false;
	}

	bool ReadVStyles(const uint8_t* d, size_t& q, int tag, VShape& s, int& fillBase, int& lineBase)
	{
		fillBase = static_cast<int>(s.fills.size());
		lineBase = static_cast<int>(s.lines.size());
		int count = d[q++];
		if (count == 255 && tag != 2)
		{
			count = U16(d + q);
			q += 2;
		}
		for (int i = 0; i < count; ++i)
		{
			VFill f;
			if (!ReadVFill(d, q, tag, f))
				return false;
			s.fills.push_back(std::move(f));
		}
		count = d[q++];
		if (count == 255)
		{
			count = U16(d + q);
			q += 2;
		}
		for (int i = 0; i < count; ++i)
		{
			VLine l;
			l.width = U16(d + q) / 20.f;
			q += 2;
			if (tag == 83)
			{
				const uint16_t flags = static_cast<uint16_t>(d[q] << 8 | d[q + 1]);
				q += 2;
				if (((flags >> 12) & 3) == 2)
					q += 2;   // a mitre limit
				if (flags & 0x0800)
				{
					if (!ReadVFill(d, q, tag, l.fill))
						return false;
				}
				else
					ReadColour(d, q, true, l.fill.colour);
			}
			else
				ReadColour(d, q, tag >= 32, l.fill.colour);
			s.lines.push_back(std::move(l));
		}
		return true;
	}

	bool ReadVShape(const Gfx& g, int tag, size_t p, VShape& s)
	{
		const uint8_t* d = g.d;
		size_t q = SkipRect(d, p + 2);
		if (tag == 83)
			q = SkipRect(d, q) + 1;
		int fillBase = 0, lineBase = 0;
		if (!ReadVStyles(d, q, tag, s, fillBase, lineBase))
			return false;
		Bits r{ d, q };
		int fillBits = static_cast<int>(r.U(4)), lineBits = static_cast<int>(r.U(4));
		float x = 0.f, y = 0.f;
		int fill0 = -1, fill1 = -1, line = -1;
		const auto styleOf = [](uint32_t v, int base) { return v == 0 ? -1 : base + static_cast<int>(v) - 1; };
		const auto edge = [&](float nx, float ny)
		{
			s.edges.push_back(VEdge{ x, y, nx, ny, fill0, fill1, line });
			x = nx;
			y = ny;
		};
		for (int guard = 0; guard < 200000; ++guard)
		{
			if (r.U(1) == 0)
			{
				const uint32_t flags = r.U(5);
				if (flags == 0)
					return true;
				if (flags & 1)
				{
					const int n = static_cast<int>(r.U(5));
					x = r.I(n) / 20.f;
					y = r.I(n) / 20.f;
				}
				if (flags & 2)
					fill0 = styleOf(r.U(fillBits), fillBase);
				if (flags & 4)
					fill1 = styleOf(r.U(fillBits), fillBase);
				if (flags & 8)
					line = styleOf(r.U(lineBits), lineBase);
				if (flags & 16)
				{
					size_t at = r.Align();
					if (!ReadVStyles(d, at, tag, s, fillBase, lineBase))
						return false;
					r = Bits{ d, at };
					fillBits = static_cast<int>(r.U(4));
					lineBits = static_cast<int>(r.U(4));
					fill0 = fill1 = line = -1;
				}
			}
			else if (r.U(1) == 1)
			{
				const int n = static_cast<int>(r.U(4)) + 2;
				float dx = 0.f, dy = 0.f;
				if (r.U(1))
				{
					dx = r.I(n) / 20.f;
					dy = r.I(n) / 20.f;
				}
				else if (r.U(1))
					dy = r.I(n) / 20.f;
				else
					dx = r.I(n) / 20.f;
				edge(x + dx, y + dy);
			}
			else
			{
				const int n = static_cast<int>(r.U(4)) + 2;
				const float cx = x + r.I(n) / 20.f, cy = y + r.I(n) / 20.f;
				const float ax = cx + r.I(n) / 20.f, ay = cy + r.I(n) / 20.f;
				const float sx = x, sy = y;
				constexpr int kSteps = 10;
				for (int i = 1; i <= kSteps; ++i)
				{
					const float t = static_cast<float>(i) / kSteps, u = 1.f - t;
					edge(u * u * sx + 2.f * u * t * cx + t * t * ax, u * u * sy + 2.f * u * t * cy + t * t * ay);
				}
			}
		}
		return false;
	}

	struct VInstance { int shape; Matrix m; float mul[4], add[4]; };

	void CollectVector(const Gfx& g, const Display& display, const Matrix& outer, const float mul[4], const float add[4], std::vector<VInstance>& out, int level = 0)
	{
		if (level > 8)
			return;
		for (const auto& [depth, placed] : display)
		{
			if (placed.mask)
				continue;   // the pins stay within their masks, so they're simply left out
			const Matrix m = placed.m.Then(outer);
			float cm[4], ca[4];
			for (int i = 0; i < 4; ++i)
			{
				cm[i] = placed.mul[i] * mul[i];
				ca[i] = placed.add[i] * mul[i] + add[i];
			}
			if (g.shapeAt.count(placed.character))
			{
				VInstance v{ placed.character, m, {}, {} };
				std::copy(cm, cm + 4, v.mul);
				std::copy(ca, ca + 4, v.add);
				out.push_back(v);
				continue;
			}
			const auto sprite = g.sprites.find(placed.character);
			if (sprite != g.sprites.end())
			{
				Display inner;
				PlaySprite(g, sprite->second, nullptr, &inner);
				CollectVector(g, inner, m, cm, ca, out, level + 1);
			}
		}
	}

	struct Affine { float a, b, c, d, tx, ty; };   // x' = a x + c y + tx
	Affine Invert(const Affine& m)
	{
		const float det = m.a * m.d - m.b * m.c;
		const float k = fabsf(det) > 1e-12f ? 1.f / det : 0.f;
		Affine r{ m.d * k, -m.b * k, -m.c * k, m.a * k, 0.f, 0.f };
		r.tx = -(r.a * m.tx + r.c * m.ty);
		r.ty = -(r.b * m.tx + r.d * m.ty);
		return r;
	}

	// Pictures a pin's fills can use, out of their compression on first use
	struct PinAtlas { uint32_t w = 0, h = 0; std::vector<uint8_t> rgba; };

	struct PinMenu
	{
		std::vector<uint8_t> file, gfx;
		std::vector<Texture> textures;
		Gfx g;
		std::map<int, VShape> shapes;
		std::map<std::string, PinAtlas> atlases;
	};

	const PinAtlas* PinAtlasFor(PinMenu& menu, int sub, SubImage& where)
	{
		const auto found = menu.g.subs.find(sub);
		if (found == menu.g.subs.end())
			return nullptr;
		where = found->second;
		const auto name = menu.g.atlasNames.find(where.atlas);
		if (name == menu.g.atlasNames.end())
			return nullptr;
		auto& atlas = menu.atlases[name->second];
		if (atlas.rgba.empty())
			for (const Texture& t : menu.textures)
			{
				if (t.name != name->second)
					continue;
				const uint8_t* h = menu.file.data() + t.data;
				GameTexture texture;
				const uint32_t w = U32(h + 8), rows = U32(h + 12), pitch = U32(h + 16), size = U32(h + 20);
				const uint32_t blocks = std::max(1u, (w + 3) / 4);
				if (t.data + 28 + size > t.end || pitch == 0 || (pitch != blocks * 8 && pitch != blocks * 16))
					break;
				texture.dxgiFormat = pitch == blocks * 16 ? DXGI_FORMAT_BC3_UNORM : DXGI_FORMAT_BC1_UNORM;
				texture.width = w;
				texture.height = rows;
				texture.rowBytes = pitch;
				texture.rows = (rows + 3) / 4;
				texture.pixels.assign(h + 28, h + 28 + size);
				if (DecodeCardArt(texture, atlas.rgba))
				{
					atlas.w = w;
					atlas.h = rows;
				}
				break;
			}
		return atlas.rgba.empty() ? nullptr : &atlas;
	}

	// One fill's colour at a point of the shape (in its pixels), straight (not premultiplied)
	std::array<float, 4> FillColour(PinMenu& menu, const VFill& f, float sx, float sy)
	{
		if (f.kind == 0)
			return { f.colour[0], f.colour[1], f.colour[2], f.colour[3] };
		const Affine to{ f.m.a / 20.f, f.m.b / 20.f, f.m.c / 20.f, f.m.d / 20.f, f.m.tx, f.m.ty };
		const Affine back = Invert(to);
		const float gx = back.a * sx + back.c * sy + back.tx, gy = back.b * sx + back.d * sy + back.ty;
		if (f.bitmap >= 0)
		{
			SubImage where{};
			const PinAtlas* atlas = PinAtlasFor(menu, f.bitmap, where);
			if (!atlas)
				return { 0.f, 0.f, 0.f, 0.f };
			const float w = static_cast<float>(where.x1 - where.x0), h = static_cast<float>(where.y1 - where.y0);
			const float u = std::clamp(gx, 0.f, w - 1.f), v = std::clamp(gy, 0.f, h - 1.f);
			const auto texel = [&](int px, int py)
			{
				px = std::clamp(px + where.x0, 0, static_cast<int>(atlas->w) - 1);
				py = std::clamp(py + where.y0, 0, static_cast<int>(atlas->h) - 1);
				return atlas->rgba.data() + (static_cast<size_t>(py) * atlas->w + px) * 4;
			};
			const int x0 = static_cast<int>(u), y0 = static_cast<int>(v);
			const float fx = u - x0, fy = v - y0;
			std::array<float, 4> c{};
			const uint8_t* q[4] = { texel(x0, y0), texel(x0 + 1, y0), texel(x0, y0 + 1), texel(x0 + 1, y0 + 1) };
			const float wt[4] = { (1 - fx) * (1 - fy), fx * (1 - fy), (1 - fx) * fy, fx * fy };
			for (int k = 0; k < 4; ++k)
				for (int i = 0; i < 4; ++i)
					c[k] += q[i][k] / 255.f * wt[i];
			return c;
		}
		if (f.stops.empty())
			return { 0.f, 0.f, 0.f, 0.f };
		float t = f.kind == 0x10 ? (gx + 16384.f) / 32768.f : std::sqrt(gx * gx + gy * gy) / 16384.f;
		t = std::clamp(t, 0.f, 1.f);
		if (t <= f.stops.front().first)
			return f.stops.front().second;
		for (size_t i = 1; i < f.stops.size(); ++i)
			if (t <= f.stops[i].first)
			{
				const float span = std::max(f.stops[i].first - f.stops[i - 1].first, 1e-6f);
				const float k = (t - f.stops[i - 1].first) / span;
				std::array<float, 4> c{};
				for (int j = 0; j < 4; ++j)
					c[j] = f.stops[i - 1].second[j] * (1.f - k) + f.stops[i].second[j] * k;
				return c;
			}
		return f.stops.back().second;
	}

	// Coverage of the edges with the non-zero rule, a sample in the middle of each small pixel
	struct Seg { float x0, y0, x1, y1; };
	void Cover(const std::vector<Seg>& segs, int size, std::vector<uint8_t>& mask)
	{
		mask.assign(static_cast<size_t>(size) * size, 0);
		std::vector<std::pair<float, int>> hits;
		for (int y = 0; y < size; ++y)
		{
			const float sy = y + 0.5f;
			hits.clear();
			for (const Seg& s : segs)
			{
				if ((s.y0 <= sy) == (s.y1 <= sy))
					continue;
				const float t = (sy - s.y0) / (s.y1 - s.y0);
				hits.emplace_back(s.x0 + (s.x1 - s.x0) * t, s.y1 > s.y0 ? 1 : -1);
			}
			std::sort(hits.begin(), hits.end());
			int winding = 0;
			for (size_t i = 0; i + 1 < hits.size(); ++i)
			{
				winding += hits[i].second;
				if (winding == 0)
					continue;
				const int from = std::max(0, static_cast<int>(std::ceil(hits[i].first - 0.5f)));
				const int to = std::min(size - 1, static_cast<int>(std::ceil(hits[i + 1].first - 0.5f)) - 1);
				for (int x = from; x <= to; ++x)
					mask[static_cast<size_t>(y) * size + x] = 1;
			}
		}
	}

	// One pin, fitted into a square picture of the size asked for, with its smaller levels
	bool DrawPin(PinMenu& menu, const Display& frame, uint32_t size, GameTexture& out)
	{
		const float one[4] = { 1.f, 1.f, 1.f, 1.f }, none[4] = {};
		std::vector<VInstance> parts;
		CollectVector(menu.g, frame, Matrix{}, one, none, parts);
		if (parts.empty())
			return false;
		float minX = FLT_MAX, minY = FLT_MAX, maxX = -FLT_MAX, maxY = -FLT_MAX;
		for (const VInstance& v : parts)
		{
			auto found = menu.shapes.find(v.shape);
			if (found == menu.shapes.end())
			{
				VShape s;
				const auto at = menu.g.shapeAt.at(v.shape);
				ReadVShape(menu.g, at.first, at.second, s);
				found = menu.shapes.emplace(v.shape, std::move(s)).first;
			}
			for (const VEdge& e : found->second.edges)
				for (int i = 0; i < 2; ++i)
				{
					const float x = i ? e.x1 : e.x0, y = i ? e.y1 : e.y0;
					const float px = v.m.a * x + v.m.c * y + v.m.tx, py = v.m.b * x + v.m.d * y + v.m.ty;
					minX = std::min(minX, px);
					maxX = std::max(maxX, px);
					minY = std::min(minY, py);
					maxY = std::max(maxY, py);
				}
		}
		if (minX >= maxX || minY >= maxY)
			return false;

		constexpr int kSuper = 4;
		const int big = static_cast<int>(size) * kSuper;
		const float margin = big * 0.04f;
		const float k = (big - 2.f * margin) / std::max(maxX - minX, maxY - minY);
		const float offX = margin + ((big - 2.f * margin) - (maxX - minX) * k) * 0.5f - minX * k;
		const float offY = margin + ((big - 2.f * margin) - (maxY - minY) * k) * 0.5f - minY * k;
		std::vector<float> canvas(static_cast<size_t>(big) * big * 4, 0.f);   // premultiplied
		std::vector<uint8_t> mask;
		std::vector<Seg> segs;

		for (const VInstance& v : parts)
		{
			const VShape& s = menu.shapes[v.shape];
			const Affine place{ v.m.a * k, v.m.b * k, v.m.c * k, v.m.d * k, v.m.tx * k + offX, v.m.ty * k + offY };
			const Affine back = Invert(place);
			const auto at = [&](float x, float y) { return std::make_pair(place.a * x + place.c * y + place.tx, place.b * x + place.d * y + place.ty); };
			const auto paint = [&](const VFill& fill)
			{
				for (int y = 0; y < big; ++y)
					for (int x = 0; x < big; ++x)
					{
						if (!mask[static_cast<size_t>(y) * big + x])
							continue;
						const float px = x + 0.5f, py = y + 0.5f;
						const float sx = back.a * px + back.c * py + back.tx, sy = back.b * px + back.d * py + back.ty;
						std::array<float, 4> c = FillColour(menu, fill, sx, sy);
						for (int i = 0; i < 4; ++i)
							c[i] = std::clamp(c[i] * v.mul[i] + v.add[i], 0.f, 1.f);
						float* o = canvas.data() + (static_cast<size_t>(y) * big + x) * 4;
						const float a = c[3];
						for (int i = 0; i < 3; ++i)
							o[i] = c[i] * a + o[i] * (1.f - a);
						o[3] = a + o[3] * (1.f - a);
					}
			};
			// Fills, in the order the shape lists them
			for (int f = 0; f < static_cast<int>(s.fills.size()); ++f)
			{
				segs.clear();
				for (const VEdge& e : s.edges)
				{
					const auto [ax, ay] = at(e.x0, e.y0);
					const auto [bx, by] = at(e.x1, e.y1);
					if (e.fill1 == f)
						segs.push_back(Seg{ ax, ay, bx, by });
					if (e.fill0 == f)
						segs.push_back(Seg{ bx, by, ax, ay });
				}
				if (segs.empty())
					continue;
				Cover(segs, big, mask);
				paint(s.fills[f]);
			}
			// Then outlines: each piece of line as a band, with a round end
			const float scale = std::sqrt(fabsf(place.a * place.d - place.b * place.c));
			for (int l = 0; l < static_cast<int>(s.lines.size()); ++l)
			{
				segs.clear();
				const float half = std::max(s.lines[l].width * scale, static_cast<float>(kSuper)) * 0.5f;
				const auto blob = [&](float cx, float cy)
				{
					constexpr int kSides = 10;
					for (int i = 0; i < kSides; ++i)
					{
						const float a0 = i * 2.f * kPiF / kSides, a1 = (i + 1) * 2.f * kPiF / kSides;
						segs.push_back(Seg{ cx + cosf(a0) * half, cy + sinf(a0) * half, cx + cosf(a1) * half, cy + sinf(a1) * half });
					}
				};
				for (const VEdge& e : s.edges)
				{
					if (e.line != l)
						continue;
					const auto [ax, ay] = at(e.x0, e.y0);
					const auto [bx, by] = at(e.x1, e.y1);
					const float dx = bx - ax, dy = by - ay, len = std::sqrt(dx * dx + dy * dy);
					if (len > 1e-4f)
					{
						const float nx = -dy / len * half, ny = dx / len * half;
						const float qx[4] = { ax + nx, bx + nx, bx - nx, ax - nx }, qy[4] = { ay + ny, by + ny, by - ny, ay - ny };
						// one way round, whichever way the line runs, so the bands add up rather than cancel
						const float area = (qx[1] - qx[0]) * (qy[2] - qy[0]) - (qx[2] - qx[0]) * (qy[1] - qy[0]);
						for (int i = 0; i < 4; ++i)
						{
							const int a = area >= 0 ? i : 3 - i, b = area >= 0 ? (i + 1) % 4 : (6 - i) % 4;
							segs.push_back(Seg{ qx[a], qy[a], qx[b], qy[b] });
						}
					}
					blob(bx, by);
				}
				if (segs.empty())
					continue;
				Cover(segs, big, mask);
				paint(s.lines[l].fill);
			}
		}

		// Down to the size asked for, each pixel the average of its small ones
		out = GameTexture{};
		out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
		out.width = out.height = size;
		out.rowBytes = size * 4;
		out.rows = size;
		out.pixels.assign(static_cast<size_t>(size) * size * 4, 0);
		for (uint32_t y = 0; y < size; ++y)
			for (uint32_t x = 0; x < size; ++x)
			{
				float sum[4] = {};
				for (int j = 0; j < kSuper; ++j)
					for (int i = 0; i < kSuper; ++i)
					{
						const float* c = canvas.data() + ((static_cast<size_t>(y) * kSuper + j) * big + x * kSuper + i) * 4;
						for (int n = 0; n < 4; ++n)
							sum[n] += c[n];
					}
				uint8_t* o = out.pixels.data() + (static_cast<size_t>(y) * size + x) * 4;
				const float a = sum[3] / (kSuper * kSuper);
				for (int n = 0; n < 3; ++n)
					o[n] = static_cast<uint8_t>(std::clamp(a > 0.f ? sum[n] / sum[3] : 0.f, 0.f, 1.f) * 255.f + 0.5f);
				o[3] = static_cast<uint8_t>(std::clamp(a, 0.f, 1.f) * 255.f + 0.5f);
			}
		AddSmallerLevels(out);
		return true;
	}

	std::map<std::string, GameTexture> g_pins;
	std::atomic<bool> g_pinsReady{ false };

	bool DrawCardShape(const Gfx& g, int shape, const Matrix& m, GameTexture& out, float box[4])
	{
		const auto found = g.shapeAt.find(shape);
		if (found == g.shapeAt.end())
			return false;
		VShape s;
		if (!ReadVShape(g, found->second.first, found->second.second, s) || s.edges.empty())
			return false;
		float minX = FLT_MAX, minY = FLT_MAX, maxX = -FLT_MAX, maxY = -FLT_MAX;
		for (const VEdge& e : s.edges)
			for (int i = 0; i < 2; ++i)
			{
				const float x = i ? e.x1 : e.x0, y = i ? e.y1 : e.y0;
				const float px = m.a * x + m.c * y + m.tx, py = m.b * x + m.d * y + m.ty;
				minX = std::min(minX, px);
				maxX = std::max(maxX, px);
				minY = std::min(minY, py);
				maxY = std::max(maxY, py);
			}
		// Room for outlines, and a pixel round it
		float widest = 0.f;
		for (const VLine& l : s.lines)
			widest = std::max(widest, l.width);
		const float pad = widest * std::sqrt(fabsf(m.a * m.d - m.b * m.c)) * 0.5f + 1.f;
		minX -= pad;
		minY -= pad;
		maxX += pad;
		maxY += pad;
		if (minX >= maxX || minY >= maxY)
			return false;

		// Four pixels to a unit of the card, which is drawn up to about twice its size, each from four by four samples
		constexpr float kPixels = 4.f;
		constexpr int kSuper = 4;
		const uint32_t size = static_cast<uint32_t>(std::ceil(std::max(maxX - minX, maxY - minY) * kPixels));
		if (size == 0 || size > 1024)
			return false;
		const int big = static_cast<int>(size) * kSuper;
		const float k = kPixels * kSuper;
		const Affine place{ m.a * k, m.b * k, m.c * k, m.d * k, (m.tx - minX) * k, (m.ty - minY) * k };
		const auto at = [&](float x, float y) { return std::make_pair(place.a * x + place.c * y + place.tx, place.b * x + place.d * y + place.ty); };
		std::vector<float> canvas(static_cast<size_t>(big) * big * 4, 0.f);   // premultiplied
		std::vector<uint8_t> mask;
		std::vector<Seg> segs;
		const auto paint = [&](const float c[4])
		{
			for (size_t i = 0; i < mask.size(); ++i)
			{
				if (!mask[i])
					continue;
				float* o = canvas.data() + i * 4;
				for (int n = 0; n < 3; ++n)
					o[n] = c[n] * c[3] + o[n] * (1.f - c[3]);
				o[3] = c[3] + o[3] * (1.f - c[3]);
			}
		};
		// Fills, in the order the shape lists them: plain colours only, as the card's shapes have
		for (int f = 0; f < static_cast<int>(s.fills.size()); ++f)
		{
			if (s.fills[f].kind != 0)
				continue;
			segs.clear();
			for (const VEdge& e : s.edges)
			{
				const auto [ax, ay] = at(e.x0, e.y0);
				const auto [bx, by] = at(e.x1, e.y1);
				if (e.fill1 == f)
					segs.push_back(Seg{ ax, ay, bx, by });
				if (e.fill0 == f)
					segs.push_back(Seg{ bx, by, ax, ay });
			}
			if (segs.empty())
				continue;
			Cover(segs, big, mask);
			paint(s.fills[f].colour);
		}
		// Outlines, as the pins' are drawn
		const float scale = std::sqrt(fabsf(place.a * place.d - place.b * place.c));
		for (int l = 0; l < static_cast<int>(s.lines.size()); ++l)
		{
			segs.clear();
			const float half = std::max(s.lines[l].width * scale, static_cast<float>(kSuper)) * 0.5f;
			for (const VEdge& e : s.edges)
			{
				if (e.line != l)
					continue;
				const auto [ax, ay] = at(e.x0, e.y0);
				const auto [bx, by] = at(e.x1, e.y1);
				const float dx = bx - ax, dy = by - ay, len = std::sqrt(dx * dx + dy * dy);
				if (len > 1e-4f)
				{
					const float nx = -dy / len * half, ny = dx / len * half;
					const float qx[4] = { ax + nx, bx + nx, bx - nx, ax - nx }, qy[4] = { ay + ny, by + ny, by - ny, ay - ny };
					const float area = (qx[1] - qx[0]) * (qy[2] - qy[0]) - (qx[2] - qx[0]) * (qy[1] - qy[0]);
					for (int i = 0; i < 4; ++i)
					{
						const int a = area >= 0 ? i : 3 - i, b = area >= 0 ? (i + 1) % 4 : (6 - i) % 4;
						segs.push_back(Seg{ qx[a], qy[a], qx[b], qy[b] });
					}
				}
				constexpr int kSides = 10;
				for (int i = 0; i < kSides; ++i)
				{
					const float a0 = i * 2.f * kPiF / kSides, a1 = (i + 1) * 2.f * kPiF / kSides;
					segs.push_back(Seg{ bx + cosf(a0) * half, by + sinf(a0) * half, bx + cosf(a1) * half, by + sinf(a1) * half });
				}
			}
			if (segs.empty())
				continue;
			Cover(segs, big, mask);
			paint(s.lines[l].fill.colour);
		}

		out = GameTexture{};
		out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
		out.width = out.height = size;
		out.rowBytes = size * 4;
		out.rows = size;
		out.pixels.assign(static_cast<size_t>(size) * size * 4, 0);
		for (uint32_t y = 0; y < size; ++y)
			for (uint32_t x = 0; x < size; ++x)
			{
				float sum[4] = {};
				for (int j = 0; j < kSuper; ++j)
					for (int i = 0; i < kSuper; ++i)
					{
						const float* c = canvas.data() + ((static_cast<size_t>(y) * kSuper + j) * big + x * kSuper + i) * 4;
						for (int n = 0; n < 4; ++n)
							sum[n] += c[n];
					}
				uint8_t* o = out.pixels.data() + (static_cast<size_t>(y) * size + x) * 4;
				const float a = sum[3] / (kSuper * kSuper);
				for (int n = 0; n < 3; ++n)
					o[n] = static_cast<uint8_t>(std::clamp(a > 0.f ? sum[n] / sum[3] : 0.f, 0.f, 1.f) * 255.f + 0.5f);
				o[3] = static_cast<uint8_t>(std::clamp(a, 0.f, 1.f) * 255.f + 0.5f);
			}
		box[0] = minX;
		box[1] = minY;
		box[2] = minX + size / kPixels;
		box[3] = minY + size / kPixels;
		return true;
	}
}

void BuildMapPins(const std::wstring& game)
{
	constexpr const char* kMapMenu = "gameplay\\gui_new\\swf\\worldmap\\panel_worldmap.redswf";
	for (const std::filesystem::path& bundle : GameBundles(game))
	{
		PinMenu menu;
		if (!ReadFromBundle(bundle.wstring(), menu.file, kMapMenu))
			continue;
		if (!ReadResource(menu.file, menu.gfx, menu.textures))
		{
			Log("map pins: can't read the map menu in %ls", bundle.c_str());
			continue;
		}
		ReadGfx(menu.g, menu.gfx);
		const auto pinIcon = std::find_if(menu.g.classes.begin(), menu.g.classes.end(), [](const auto& c) { return c.first.find("PinIcon_") != std::string::npos && c.first.find("Tracker") == std::string::npos; });
		if (pinIcon == menu.g.classes.end() || !menu.g.sprites.count(pinIcon->second))
		{
			Log("map pins: the map menu in %ls has no pins", bundle.c_str());
			continue;
		}
		std::map<std::string, Display> frames;
		PlaySprite(menu.g, menu.g.sprites[pinIcon->second], &frames, nullptr);
		int drawn = 0;
		for (const auto& [label, display] : frames)
		{
			GameTexture picture;
			if (DrawPin(menu, display, 128, picture))
			{
				g_pins[label] = std::move(picture);
				++drawn;
			}
		}
		Log("map pins: %d of %zu drawn, from %ls", drawn, frames.size(), bundle.filename().c_str());
#ifdef POTP_OVERLAY_TEST
		// For a look at them all: POTP_PIN_DUMP names a folder for each as a 32-bit picture. POTP_ICON_DUMP lists
		// other game icons (by their menu paths, separated by ;) to save there too.
		wchar_t dump[MAX_PATH] = L"";
		if (GetEnvironmentVariableW(L"POTP_PIN_DUMP", dump, MAX_PATH))
		{
			const auto save = [&](const std::string& name, const GameTexture& picture)
			{
				std::vector<uint8_t> rgba;
				if (picture.dxgiFormat == DXGI_FORMAT_R8G8B8A8_UNORM)
					rgba = picture.pixels;
				else if (!DecodeCardArt(picture, rgba))
					return;
				const std::wstring path = std::wstring(dump) + L"\\" + std::wstring(name.begin(), name.end()) + L".bmp";
				FILE* f = nullptr;
				if (_wfopen_s(&f, path.c_str(), L"wb") || !f)
					return;
				const uint32_t w = picture.width, h = picture.height, bytes = w * h * 4;
				uint8_t head[54] = { 'B', 'M' };
				const auto put = [&](int at, uint32_t v) { memcpy(head + at, &v, 4); };
				put(2, 54 + bytes); put(10, 54); put(14, 40); put(18, w); put(22, h);
				head[26] = 1; head[28] = 32;
				put(34, bytes);
				fwrite(head, 1, 54, f);
				for (uint32_t y = 0; y < h; ++y)
					for (uint32_t x = 0; x < w; ++x)
					{
						const uint8_t* c = rgba.data() + ((static_cast<size_t>(h - 1 - y) * w) + x) * 4;
						const uint8_t bgra[4] = { c[2], c[1], c[0], c[3] };
						fwrite(bgra, 1, 4, f);
					}
				fclose(f);
			};
			for (const auto& [label, picture] : g_pins)
				save(label, picture);
			char list[4096] = "";
			if (GetEnvironmentVariableA("POTP_ICON_DUMP", list, sizeof(list)))
			{
				std::string all = list;
				for (size_t at = 0; at < all.size();)
				{
					size_t semi = all.find(';', at);
					if (semi == std::string::npos)
						semi = all.size();
					const std::string path = all.substr(at, semi - at);
					at = semi + 1;
					GameTexture icon;
					if (!ReadGameIcon(path, 256, icon))
					{
						Log("icon dump: %s not found", path.c_str());
						continue;
					}
					std::string name = path.substr(path.find_last_of('/') + 1);
					save("icon_" + name.substr(0, name.find('.')), icon);
				}
			}
		}
#endif
		g_pinsReady = true;
		return;
	}
	Log("map pins: the map menu wasn't found");
}

const GameTexture* MapPinPicture(const std::string& label)
{
	if (!g_pinsReady)
		return nullptr;
	const auto found = g_pins.find(label);
	return found != g_pins.end() ? &found->second : nullptr;
}

// A square cut from the top of a card's art, where the face usually is, shrunk to the size asked for with each pixel
// the average of those it covers, and its smaller levels: for a mark next to the card's name
bool MakeCardPortrait(const GameTexture& art, uint32_t size, GameTexture& out)
{
	std::vector<uint8_t> rgba;
	if (art.dxgiFormat == DXGI_FORMAT_R8G8B8A8_UNORM && art.pixels.size() >= static_cast<size_t>(art.width) * art.height * 4)
		rgba = art.pixels;
	else if (!DecodeCardArt(art, rgba))
		return false;
	const float w = static_cast<float>(art.width), h = static_cast<float>(art.height);
	const float side = std::min(w * 0.84f, h);
	const float x0 = (w - side) * 0.5f, y0 = std::min(h * 0.05f, h - side);
	out = GameTexture{};
	out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	out.width = out.height = size;
	out.rowBytes = size * 4;
	out.rows = size;
	out.pixels.assign(static_cast<size_t>(size) * size * 4, 255);
	const float step = side / size;
	const int samples = std::max(1, static_cast<int>(std::ceil(step)));
	for (uint32_t y = 0; y < size; ++y)
		for (uint32_t x = 0; x < size; ++x)
		{
			float sum[4] = {};
			for (int j = 0; j < samples; ++j)
				for (int i = 0; i < samples; ++i)
				{
					const int sx = std::clamp(static_cast<int>(x0 + (x + (i + 0.5f) / samples) * step), 0, static_cast<int>(art.width) - 1);
					const int sy = std::clamp(static_cast<int>(y0 + (y + (j + 0.5f) / samples) * step), 0, static_cast<int>(art.height) - 1);
					const uint8_t* p = rgba.data() + (static_cast<size_t>(sy) * art.width + sx) * 4;
					for (int k = 0; k < 4; ++k)
						sum[k] += p[k];
				}
			uint8_t* o = out.pixels.data() + (static_cast<size_t>(y) * size + x) * 4;
			for (int k = 0; k < 3; ++k)
				o[k] = static_cast<uint8_t>(sum[k] / (samples * samples) + 0.5f);
			o[3] = 255;
		}
	AddSmallerLevels(out);
	return true;
}

// An item's icon for a small square: the empty space round it cut away, a tall weapon turned to lie corner to corner,
// and fitted into a picture of the size asked for, each pixel averaged from samples of the one before, with its smaller
// levels. Colour is weighted by how opaque it is, so its edges don't darken.
bool MakeItemTile(const GameTexture& icon, bool weapon, uint32_t size, GameTexture& out)
{
	struct Picture
	{
		int w = 0, h = 0;
		std::vector<float> p;   // premultiplied RGBA, 0 to 1
		std::array<float, 4> At(int x, int y) const
		{
			if (x < 0 || y < 0 || x >= w || y >= h)
				return { 0.f, 0.f, 0.f, 0.f };
			const float* q = p.data() + (static_cast<size_t>(y) * w + x) * 4;
			return { q[0], q[1], q[2], q[3] };
		}
		std::array<float, 4> Sample(float x, float y) const   // bilinear, x and y in pixels
		{
			x -= 0.5f;
			y -= 0.5f;
			const int x0 = static_cast<int>(std::floor(x)), y0 = static_cast<int>(std::floor(y));
			const float fx = x - x0, fy = y - y0;
			const auto a = At(x0, y0), b = At(x0 + 1, y0), c = At(x0, y0 + 1), d = At(x0 + 1, y0 + 1);
			std::array<float, 4> r{};
			for (int k = 0; k < 4; ++k)
				r[k] = (a[k] * (1 - fx) + b[k] * fx) * (1 - fy) + (c[k] * (1 - fx) + d[k] * fx) * fy;
			return r;
		}
		// The smallest box holding what isn't clear
		Picture Trimmed() const
		{
			int x0 = w, y0 = h, x1 = -1, y1 = -1;
			for (int y = 0; y < h; ++y)
				for (int x = 0; x < w; ++x)
					if (p[(static_cast<size_t>(y) * w + x) * 4 + 3] > 0.04f)
					{
						x0 = std::min(x0, x); x1 = std::max(x1, x);
						y0 = std::min(y0, y); y1 = std::max(y1, y);
					}
			if (x1 < x0)
				return *this;
			Picture t;
			t.w = x1 - x0 + 1;
			t.h = y1 - y0 + 1;
			t.p.resize(static_cast<size_t>(t.w) * t.h * 4);
			for (int y = 0; y < t.h; ++y)
				memcpy(t.p.data() + static_cast<size_t>(y) * t.w * 4, p.data() + (static_cast<size_t>(y + y0) * w + x0) * 4, static_cast<size_t>(t.w) * 4 * sizeof(float));
			return t;
		}
	};

	std::vector<uint8_t> rgba;
	if (icon.dxgiFormat == DXGI_FORMAT_R8G8B8A8_UNORM && icon.pixels.size() >= static_cast<size_t>(icon.width) * icon.height * 4)
		rgba = icon.pixels;
	else if (!DecodeCardArt(icon, rgba))
		return false;
	Picture src;
	src.w = static_cast<int>(icon.width);
	src.h = static_cast<int>(icon.height);
	src.p.resize(static_cast<size_t>(src.w) * src.h * 4);
	for (size_t i = 0; i < static_cast<size_t>(src.w) * src.h; ++i)
	{
		const float a = rgba[i * 4 + 3] / 255.f;
		for (int k = 0; k < 3; ++k)
			src.p[i * 4 + k] = rgba[i * 4 + k] / 255.f * a;
		src.p[i * 4 + 3] = a;
	}
	Picture item = src.Trimmed();

	// A long weapon stands upright in its icon: turned 38 degrees clockwise it fills a square far better
	if (weapon && item.h > item.w * 1.4f)
	{
		const float angle = 38.f * 3.14159265f / 180.f, cs = std::cos(angle), sn = std::sin(angle);
		const float cx = item.w * 0.5f, cy = item.h * 0.5f;
		Picture turned;
		turned.w = static_cast<int>(std::ceil(item.w * cs + item.h * sn)) + 2;
		turned.h = static_cast<int>(std::ceil(item.w * sn + item.h * cs)) + 2;
		turned.p.assign(static_cast<size_t>(turned.w) * turned.h * 4, 0.f);
		const float ox = turned.w * 0.5f, oy = turned.h * 0.5f;
		for (int y = 0; y < turned.h; ++y)
			for (int x = 0; x < turned.w; ++x)
			{
				// back from the turned picture into the upright one
				const float dx = x + 0.5f - ox, dy = y + 0.5f - oy;
				const float sx = cs * dx + sn * dy + cx, sy = -sn * dx + cs * dy + cy;
				const auto c = item.Sample(sx, sy);
				std::copy(c.begin(), c.end(), turned.p.begin() + (static_cast<size_t>(y) * turned.w + x) * 4);
			}
		item = turned.Trimmed();
	}

	// Into the square, the longer side filling it, four by four samples a pixel
	out = GameTexture{};
	out.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
	out.width = out.height = size;
	out.rowBytes = size * 4;
	out.rows = size;
	out.pixels.assign(static_cast<size_t>(size) * size * 4, 0);
	const float k = static_cast<float>(size) / std::max(item.w, item.h);
	const float offX = (size - item.w * k) * 0.5f, offY = (size - item.h * k) * 0.5f;
	constexpr int kSamples = 4;
	for (uint32_t y = 0; y < size; ++y)
		for (uint32_t x = 0; x < size; ++x)
		{
			float sum[4] = {};
			for (int j = 0; j < kSamples; ++j)
				for (int i = 0; i < kSamples; ++i)
				{
					const float px = (x + (i + 0.5f) / kSamples - offX) / k, py = (y + (j + 0.5f) / kSamples - offY) / k;
					const auto c = item.Sample(px, py);
					for (int n = 0; n < 4; ++n)
						sum[n] += c[n];
				}
			uint8_t* o = out.pixels.data() + (static_cast<size_t>(y) * size + x) * 4;
			const float a = sum[3] / (kSamples * kSamples);
			for (int n = 0; n < 3; ++n)
				o[n] = static_cast<uint8_t>(std::clamp(sum[3] > 0.f ? sum[n] / sum[3] : 0.f, 0.f, 1.f) * 255.f + 0.5f);
			o[3] = static_cast<uint8_t>(std::clamp(a, 0.f, 1.f) * 255.f + 0.5f);
		}
	AddSmallerLevels(out);
	return true;
}

// The pin's own colour: its bright, solid pixels, a quarter of the way down from the brightest
bool MapPinColour(const std::string& label, uint8_t rgb[3])
{
	const GameTexture* pin = MapPinPicture(label);
	if (!pin)
		return false;
	std::vector<const uint8_t*> bright;
	for (size_t i = 0; i + 3 < pin->pixels.size(); i += 4)
	{
		const uint8_t* p = pin->pixels.data() + i;
		if (p[3] > 200 && std::max({ p[0], p[1], p[2] }) > 120)
			bright.push_back(p);
	}
	if (bright.empty())
		return false;
	std::sort(bright.begin(), bright.end(), [](const uint8_t* a, const uint8_t* b) { return a[0] + a[1] + a[2] > b[0] + b[1] + b[2]; });
	const uint8_t* p = bright[bright.size() / 4];
	rgb[0] = p[0];
	rgb[1] = p[1];
	rgb[2] = p[2];
	return true;
}

// The pin in white, its dark outline kept: for a mark drawn over a pin in its colour. Made the first time it's
// asked for, on the drawing thread.
const GameTexture* MapPinWhite(const std::string& label)
{
	static std::map<std::string, GameTexture> made;
	const auto found = made.find(label);
	if (found != made.end())
		return &found->second;
	const GameTexture* pin = MapPinPicture(label);
	if (!pin)
		return nullptr;
	GameTexture white;
	white.dxgiFormat = pin->dxgiFormat;
	white.width = pin->width;
	white.height = pin->height;
	white.rowBytes = pin->rowBytes;
	white.rows = pin->rows;
	white.pixels = pin->pixels;
	for (size_t i = 0; i + 3 < white.pixels.size(); i += 4)
	{
		uint8_t* p = white.pixels.data() + i;
		const uint8_t top = std::max({ p[0], p[1], p[2] });
		p[0] = p[1] = p[2] = top > 90 ? 255 : top;
	}
	AddSmallerLevels(white);
	return &made.emplace(label, std::move(white)).first->second;
}

std::vector<std::string> MapPinLabels()
{
	std::vector<std::string> labels;
	if (g_pinsReady)
		for (const auto& [label, picture] : g_pins)
			labels.push_back(label);
	return labels;
}
