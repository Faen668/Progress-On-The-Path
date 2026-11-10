#include "gameicons.h"
#include "book.h"
#include <windows.h>
#include <dxgiformat.h>
#include <algorithm>
#include <array>
#include <atomic>
#include <cstring>
#include <filesystem>
#include <map>
#include <unordered_map>
#include "log.h"

namespace
{
	constexpr uint32_t kMagic = 0x54584348;
	constexpr int kFooterSize = 32, kEntrySize = 52;
	constexpr uint64_t kPageSize = 4096;

	struct Entry { uint64_t offset; uint32_t packed, unpacked; uint16_t width, height, mips; uint8_t format; };
	struct Cache { std::wstring path; std::map<std::string, Entry> entries; };
	struct AnyTexture { uint32_t cache; Entry entry; };

	std::vector<Cache> g_caches;
	std::vector<std::wstring> g_cachePaths;
	std::unordered_map<uint64_t, AnyTexture> g_anyTextures;   // every texture, first found winning
	std::atomic<bool> g_ready{ false };

	uint32_t U32(const uint8_t* p) { uint32_t v; memcpy(&v, p, 4); return v; }
	uint16_t U16(const uint8_t* p) { uint16_t v; memcpy(&v, p, 2); return v; }

	struct File
	{
		HANDLE handle;
		explicit File(const std::wstring& path) : handle(CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr)) {}
		~File() { if (handle != INVALID_HANDLE_VALUE) CloseHandle(handle); }
		bool Open() const { return handle != INVALID_HANDLE_VALUE; }
		uint64_t Size() const { LARGE_INTEGER s{}; GetFileSizeEx(handle, &s); return static_cast<uint64_t>(s.QuadPart); }
		bool Read(uint64_t at, void* to, size_t count) const
		{
			LARGE_INTEGER offset;
			offset.QuadPart = static_cast<LONGLONG>(at);
			if (!SetFilePointerEx(handle, offset, nullptr, FILE_BEGIN))
				return false;
			DWORD got = 0;
			return ReadFile(handle, to, static_cast<DWORD>(count), &got, nullptr) && got == count;
		}
	};

	uint64_t HashOfKey(const std::string& key)
	{
		uint64_t h = 0xcbf29ce484222325ull;
		for (const char c : key)
			h = (h ^ static_cast<uint8_t>(c)) * 0x100000001b3ull;
		return h;
	}

	std::string KeyOf(std::string path)
	{
		for (char& c : path)
			c = c == '/' ? '\\' : static_cast<char>(tolower(static_cast<unsigned char>(c)));
		return path;
	}

	// Only the interface's pictures are kept: the game's cache lists far more. A DLC's are under its own folder,
	// dlc\\bob\\data\\gameplay\\gui_new\\..., but the path given for one starts at icons/ all the same.
	void ReadTable(const std::wstring& path)
	{
		const File file(path);
		if (!file.Open())
			return;
		const uint64_t size = file.Size();
		uint8_t footer[kFooterSize];
		if (size < kFooterSize || !file.Read(size - kFooterSize, footer, kFooterSize) || U32(footer + 24) != kMagic)
			return;
		const uint32_t count = U32(footer + 12), namesSize = U32(footer + 16);
		const uint64_t tableSize = static_cast<uint64_t>(count) * kEntrySize;
		if (size < kFooterSize + tableSize + namesSize)
			return;
		std::vector<uint8_t> names(namesSize), table(static_cast<size_t>(tableSize));
		const uint64_t tableAt = size - kFooterSize - tableSize;
		if (!file.Read(tableAt - namesSize, names.data(), names.size()) || !file.Read(tableAt, table.data(), table.size()))
			return;
		Cache cache;
		cache.path = path;
		const uint32_t cacheIndex = static_cast<uint32_t>(g_cachePaths.size());
		g_cachePaths.push_back(path);
		for (uint32_t i = 0; i < count; ++i)
		{
			const uint8_t* e = table.data() + static_cast<size_t>(i) * kEntrySize;
			const uint32_t nameAt = U32(e + 4);
			if (nameAt >= namesSize)
				continue;
			const char* name = reinterpret_cast<const char*>(names.data() + nameAt);
			const size_t length = strnlen(name, namesSize - nameAt);
			std::string key = KeyOf(std::string(name, length));
			g_anyTextures.emplace(HashOfKey(key), AnyTexture{ cacheIndex, Entry{ U32(e + 8) * kPageSize, U32(e + 12), U32(e + 16), U16(e + 24), U16(e + 26), std::max<uint16_t>(1, U16(e + 28)), e[48] } });
			const size_t from = key.find("gameplay\\gui_new\\");
			if (from == std::string::npos)
				continue;
			key.erase(0, from);
			cache.entries.emplace(std::move(key), Entry{ U32(e + 8) * kPageSize, U32(e + 12), U32(e + 16), U16(e + 24), U16(e + 26), std::max<uint16_t>(1, U16(e + 28)), e[48] });
		}
		if (!cache.entries.empty())
			g_caches.push_back(std::move(cache));
	}

	// DEFLATE, for the blocks a texture is stored in
	class Inflater
	{
		const uint8_t* in_;
		size_t size_, at_ = 0;
		uint64_t bits_ = 0;
		int count_ = 0;
		uint8_t* out_;
		size_t room_, wrote_ = 0;
		bool bad_ = false;
		int overrun_ = 0;

		void Fill()
		{
			while (count_ <= 56)
			{
				if (at_ < size_)
					bits_ |= static_cast<uint64_t>(in_[at_++]) << count_;
				else
					++overrun_;   // reads as zeros, and only matters if they're used
				count_ += 8;
			}
		}

		int Bit(int need)
		{
			if (need == 0)
				return 0;
			if (count_ < need)
				Fill();
			const int value = static_cast<int>(bits_ & ((1ull << need) - 1));
			bits_ >>= need;
			count_ -= need;
			if (overrun_ * 8 > count_)
				bad_ = true;
			return value;
		}

		// Codes of up to kFast bits found straight off in a table, the longer ones a bit at a time
		static constexpr int kFast = 10;
		struct Huffman { std::array<uint16_t, 16> counts{}; std::array<uint16_t, 320> symbols{}; std::array<uint16_t, 1 << kFast> fast{}; };

		static void Build(Huffman& h, const uint8_t* lengths, int n)
		{
			h.counts.fill(0);
			h.fast.fill(0);
			for (int i = 0; i < n; ++i)
				++h.counts[lengths[i]];
			h.counts[0] = 0;
			std::array<uint16_t, 16> offsets{}, next{};
			int code = 0;
			for (int i = 1; i < 16; ++i)
			{
				code = (code + (i > 1 ? h.counts[i - 1] : 0)) << 1;
				next[i] = static_cast<uint16_t>(code);
				if (i < 15)
					offsets[i + 1] = offsets[i] + h.counts[i];
			}
			for (int i = 0; i < n; ++i)
			{
				const int length = lengths[i];
				if (!length)
					continue;
				h.symbols[offsets[length]++] = static_cast<uint16_t>(i);
				const int assigned = next[length]++;
				if (length <= kFast)
				{
					int reversed = 0;
					for (int b = 0; b < length; ++b)
						reversed |= ((assigned >> b) & 1) << (length - 1 - b);
					for (int fill = reversed; fill < (1 << kFast); fill += 1 << length)
						h.fast[fill] = static_cast<uint16_t>((length << 9) | i);
				}
			}
		}

		int Symbol(const Huffman& h)
		{
			if (count_ < 15)
				Fill();
			const uint16_t entry = h.fast[bits_ & ((1u << kFast) - 1)];
			if (entry)
			{
				const int length = entry >> 9;
				bits_ >>= length;
				count_ -= length;
				if (overrun_ * 8 > count_)
					bad_ = true;
				return entry & 511;
			}
			int code = 0, first = 0, index = 0;
			for (int length = 1; length <= 15; ++length)
			{
				code |= Bit(1);
				if (bad_)
					return -1;
				const int n = h.counts[length];
				if (code - n < first)
					return h.symbols[index + (code - first)];
				index += n;
				first = (first + n) << 1;
				code <<= 1;
			}
			bad_ = true;
			return -1;
		}

		void Codes(const Huffman& literals, const Huffman& distances)
		{
			static const uint16_t lengthBase[29] = { 3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258 };
			static const uint8_t lengthExtra[29] = { 0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0 };
			static const uint16_t distanceBase[30] = { 1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577 };
			static const uint8_t distanceExtra[30] = { 0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13 };
			for (;;)
			{
				int symbol = Symbol(literals);
				if (bad_ || symbol == 256)
					return;
				if (symbol < 256)
				{
					if (wrote_ >= room_)
					{
						bad_ = true;
						return;
					}
					out_[wrote_++] = static_cast<uint8_t>(symbol);
					continue;
				}
				symbol -= 257;
				if (symbol >= 29)
				{
					bad_ = true;
					return;
				}
				const int length = lengthBase[symbol] + Bit(lengthExtra[symbol]);
				const int d = Symbol(distances);
				if (bad_ || d >= 30)
				{
					bad_ = true;
					return;
				}
				const size_t distance = static_cast<size_t>(distanceBase[d]) + Bit(distanceExtra[d]);
				if (distance > wrote_ || wrote_ + length > room_)
				{
					bad_ = true;
					return;
				}
				for (int i = 0; i < length; ++i, ++wrote_)
					out_[wrote_] = out_[wrote_ - distance];
			}
		}

	public:
		Inflater(const uint8_t* in, size_t size, uint8_t* out, size_t room) : in_(in), size_(size), out_(out), room_(room) {}

		size_t Written() const { return wrote_; }

		bool Run()
		{
			return RunToEnd() && wrote_ == room_;
		}

		bool RunToEnd()
		{
			at_ = 2;   // the zlib header
			int last;
			do
			{
				last = Bit(1);
				const int type = Bit(2);
				if (bad_)
					return false;
				if (type == 0)
				{
					// Back to the byte after the ones read ahead
					at_ -= count_ / 8;
					bits_ = 0;
					count_ = 0;
					overrun_ = 0;
					if (at_ + 4 > size_)
						return false;
					const size_t length = U16(in_ + at_);
					at_ += 4;
					if (at_ + length > size_ || wrote_ + length > room_)
						return false;
					memcpy(out_ + wrote_, in_ + at_, length);
					at_ += length;
					wrote_ += length;
				}
				else if (type == 1)
				{
					uint8_t lengths[320];
					int i = 0;
					for (; i < 144; ++i) lengths[i] = 8;
					for (; i < 256; ++i) lengths[i] = 9;
					for (; i < 280; ++i) lengths[i] = 7;
					for (; i < 288; ++i) lengths[i] = 8;
					Huffman literals, distances;
					Build(literals, lengths, 288);
					for (i = 0; i < 30; ++i) lengths[i] = 5;
					Build(distances, lengths, 30);
					Codes(literals, distances);
				}
				else if (type == 2)
				{
					static const uint8_t order[19] = { 16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15 };
					const int literalCount = Bit(5) + 257, distanceCount = Bit(5) + 1, codeCount = Bit(4) + 4;
					uint8_t lengths[320] = {};
					for (int i = 0; i < codeCount; ++i)
						lengths[order[i]] = static_cast<uint8_t>(Bit(3));
					Huffman codes;
					Build(codes, lengths, 19);
					memset(lengths, 0, sizeof(lengths));
					int i = 0;
					while (i < literalCount + distanceCount)
					{
						const int symbol = Symbol(codes);
						if (bad_)
							return false;
						if (symbol < 16)
						{
							lengths[i++] = static_cast<uint8_t>(symbol);
							continue;
						}
						uint8_t value = 0;
						int repeat;
						if (symbol == 16)
						{
							if (i == 0)
								return false;
							value = lengths[i - 1];
							repeat = 3 + Bit(2);
						}
						else
						{
							repeat = symbol == 17 ? 3 + Bit(3) : 11 + Bit(7);
						}
						if (i + repeat > literalCount + distanceCount)
							return false;
						while (repeat--)
							lengths[i++] = value;
					}
					Huffman literals, distances;
					Build(literals, lengths, literalCount);
					Build(distances, lengths + literalCount, distanceCount);
					Codes(literals, distances);
				}
				else
				{
					return false;
				}
				if (bad_)
					return false;
			} while (!last);
			return true;
		}
	};

	bool ReadPixels(const std::wstring& path, const Entry& e, std::vector<uint8_t>& out)
	{
		const File file(path);
		if (!file.Open())
			return false;
		out.resize(e.unpacked);
		std::vector<uint8_t> block;
		size_t filled = 0;
		uint64_t at = e.offset;
		const uint64_t end = e.offset + e.packed;
		while (at + 9 <= end && filled < out.size())
		{
			uint8_t header[9];
			if (!file.Read(at, header, 9))
				return false;
			const uint32_t packed = U32(header), unpacked = U32(header + 4);
			// A chunk has to fit in what's left of the entry: anything else isn't a chunk, whatever made this cache
			if (filled + unpacked > out.size() || packed > end - at - 9)
				return false;
			block.resize(packed);
			if (!file.Read(at + 9, block.data(), packed))
				return false;
			const bool zlib = packed > 2 && block[0] == 0x78 && (block[1] == 0x01 || block[1] == 0x5E || block[1] == 0x9C || block[1] == 0xDA);
			if (packed == unpacked && !zlib)
				memcpy(out.data() + filled, block.data(), unpacked);
			else if (!Inflater(block.data(), packed, out.data() + filled, unpacked).Run())
				return false;
			filled += unpacked;
			at += 9ull + packed;
		}
		return filled == out.size();
	}
}

bool InflateGameData(const uint8_t* in, size_t size, uint8_t* out, size_t room)
{
	return Inflater(in, size, out, room).Run();
}

bool InflateGameDataUpTo(const uint8_t* in, size_t size, std::vector<uint8_t>& out)
{
	Inflater inflater(in, size, out.data(), out.size());
	if (!inflater.RunToEnd())
		return false;
	out.resize(inflater.Written());
	return true;
}

void BuildGameIconIndex(const std::wstring& game)
{
	namespace fs = std::filesystem;
	std::error_code ec;
	// Mods over DLC over the game, as the game looks for them
	for (const wchar_t* folder : { L"mods", L"dlc" })
	{
		std::vector<fs::path> found;
		for (const auto& item : fs::directory_iterator(fs::path(game) / folder, ec))
			if (item.is_directory(ec))
				found.push_back(item.path());
		std::sort(found.begin(), found.end());
		for (const fs::path& mod : found)
			ReadTable((mod / L"content" / L"texture.cache").wstring());
	}
	ReadTable((fs::path(game) / L"content" / L"content0" / L"texture.cache").wstring());
	size_t total = 0;
	for (const Cache& c : g_caches)
		total += c.entries.size();
	Log("game icons: %zu in %zu texture caches", total, g_caches.size());
	g_ready = true;
}

bool GameIconIndexReady()
{
	return g_ready;
}

namespace
{
	bool ReadEntryTexture(const std::wstring& cachePath, const Entry& e, const std::string& gamePath, uint32_t largestSide, GameTexture& out, bool withMips = false);
}

// Remastered merged some DLC into the game, while files can still name its old folder
static std::unordered_map<uint64_t, AnyTexture>::const_iterator FindAnyTexture(const std::string& gamePath)
{
	const std::string key = KeyOf(gamePath);
	auto found = g_anyTextures.find(HashOfKey(key));
	if (found == g_anyTextures.end() && key.rfind("dlc\\", 0) == 0)
	{
		const size_t data = key.find("\\data\\");
		if (data != std::string::npos)
			found = g_anyTextures.find(HashOfKey(key.substr(data + 6)));
	}
	return found;
}

bool GameTextureExists(const std::string& gamePath)
{
	return g_ready && FindAnyTexture(gamePath) != g_anyTextures.end();
}

bool ReadGameTexture(const std::string& gamePath, uint32_t largestSide, GameTexture& out, bool withMips)
{
	// PotP's own, built into the .asi: the Library's book
	if (gamePath.compare(0, strlen(kBuiltinTexture), kBuiltinTexture) == 0)
		return ReadBuiltinTexture(gamePath, largestSide, out, withMips);
	if (!g_ready)
		return false;
	const auto found = FindAnyTexture(gamePath);
	if (found == g_anyTextures.end())
		return false;
	return ReadEntryTexture(g_cachePaths[found->second.cache], found->second.entry, gamePath, largestSide, out, withMips);
}

bool ReadGameIcon(const std::string& gamePath, uint32_t largestSide, GameTexture& out)
{
	if (!g_ready)
		return false;
	std::string key = KeyOf(gamePath);
	if (const size_t from = key.find("gameplay\\gui_new\\"); from != std::string::npos)
		key.erase(0, from);   // a path that names its DLC's folder
	else
		key = "gameplay\\gui_new\\" + key;
	for (const Cache& cache : g_caches)
	{
		const auto found = cache.entries.find(key);
		if (found == cache.entries.end())
			continue;
		return ReadEntryTexture(cache.path, found->second, gamePath, largestSide, out);
	}
	Log("game icons: no texture for %s", gamePath.c_str());
	return false;
}

namespace
{
	bool ReadEntryTexture(const std::wstring& cachePath, const Entry& e, const std::string& gamePath, uint32_t largestSide, GameTexture& out, bool withMips)
	{
		int dxgi = DXGI_FORMAT_UNKNOWN;
		uint32_t blockBytes = 0;
		switch (e.format)
		{
		case 7: dxgi = DXGI_FORMAT_BC1_UNORM; blockBytes = 8; break;
		case 8: case 13: dxgi = DXGI_FORMAT_BC3_UNORM; blockBytes = 16; break;
		case 10: dxgi = DXGI_FORMAT_BC7_UNORM; blockBytes = 16; break;
		case 14: dxgi = DXGI_FORMAT_BC4_UNORM; blockBytes = 8; break;
		case 15: dxgi = DXGI_FORMAT_BC5_UNORM; blockBytes = 16; break;
		case 253: dxgi = DXGI_FORMAT_R8G8B8A8_UNORM; break;
		default:
			Log("game icons: %s has format %d, which isn't handled", gamePath.c_str(), e.format);
			return false;
		}
		std::vector<uint8_t> pixels;
		if (!ReadPixels(cachePath, e, pixels))
		{
			Log("game icons: can't read %s", gamePath.c_str());
			return false;
		}

		// The largest mip level that's small enough, as the icons are often far bigger than they're shown.
		// A compressed texture has to start on whole blocks.
		const auto bytes = [&](uint32_t w, uint32_t h) -> size_t
		{
			return blockBytes ? static_cast<size_t>(std::max(1u, (w + 3) / 4)) * std::max(1u, (h + 3) / 4) * blockBytes : static_cast<size_t>(w) * h * 4;
		};
		const auto usable = [&](uint32_t w, uint32_t h) { return !blockBytes || (w % 4 == 0 && h % 4 == 0); };
		uint32_t w = e.width, h = e.height;
		size_t offset = 0;
		for (int mip = 1; mip < e.mips && std::max(w, h) > largestSide; ++mip)
		{
			const uint32_t nextW = std::max(1u, w / 2), nextH = std::max(1u, h / 2);
			if (!usable(nextW, nextH))
				break;
			offset += bytes(w, h);
			w = nextW;
			h = nextH;
		}
		const size_t size = bytes(w, h);
		if (offset + size > pixels.size())
			return false;
		out.dxgiFormat = dxgi;
		out.width = w;
		out.height = h;
		out.rowBytes = blockBytes ? std::max(1u, (w + 3) / 4) * blockBytes : w * 4;
		out.rows = blockBytes ? std::max(1u, (h + 3) / 4) : h;
		out.pixels.assign(pixels.begin() + static_cast<ptrdiff_t>(offset), pixels.begin() + static_cast<ptrdiff_t>(offset + size));
		if (withMips)
		{
			uint32_t mw = w, mh = h;
			size_t at = offset + size;
			while ((mw > 1 || mh > 1) && out.lowerMips.size() < 15)
			{
				mw = std::max(1u, mw / 2);
				mh = std::max(1u, mh / 2);
				const size_t levelSize = bytes(mw, mh);
				if (at + levelSize > pixels.size())
				{
					// A chain that stops short can't be given to the card as it is
					out.lowerMips.clear();
					break;
				}
				GameTexture level;
				level.dxgiFormat = dxgi;
				level.width = mw;
				level.height = mh;
				level.rowBytes = blockBytes ? std::max(1u, (mw + 3) / 4) * blockBytes : mw * 4;
				level.rows = blockBytes ? std::max(1u, (mh + 3) / 4) : mh;
				level.pixels.assign(pixels.begin() + static_cast<ptrdiff_t>(at), pixels.begin() + static_cast<ptrdiff_t>(at + levelSize));
				out.lowerMips.push_back(std::move(level));
				at += levelSize;
			}
		}
		return true;
	}
}
