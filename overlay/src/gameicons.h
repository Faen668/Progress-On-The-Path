#pragma once
#include <cstdint>
#include <string>
#include <vector>

// A picture from the game's own files, found by the path the game's menus use for it: "icons/inventory/weapons/axe_01_64x128.png".
// Their textures are in the texture.cache of each mod, DLC and the game, under gameplay\gui_new\ and that path.
struct GameTexture
{
	int dxgiFormat = 0;
	uint32_t width = 0, height = 0;
	uint32_t rowBytes = 0, rows = 0;   // for a compressed format, rows are rows of blocks
	std::vector<uint8_t> pixels;
	std::vector<GameTexture> lowerMips;   // the smaller levels, when asked for
};

void BuildGameIconIndex(const std::wstring& gameFolder);   // reads the caches' tables: on a thread of its own
bool GameIconIndexReady();
bool InflateGameData(const uint8_t* in, size_t size, uint8_t* out, size_t room);   // a zlib stream
bool InflateGameDataUpTo(const uint8_t* in, size_t size, std::vector<uint8_t>& out);   // when its size isn't known exactly: out is as large as it might be
bool GameTextureExists(const std::string& gamePath);   // any texture, by its full path
bool ReadGameTexture(const std::string& gamePath, uint32_t largestSide, GameTexture& out, bool withMips = false);
bool ReadGameIcon(const std::string& gamePath, uint32_t largestSide, GameTexture& out);
