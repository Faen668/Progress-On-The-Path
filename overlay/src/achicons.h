#pragma once
#include <string>
#include <vector>

struct GameTexture;

// PotP's own achievement icons (achievement_icons.inc, made by overlay/tools/gen_achievement_icons.py): SVG path data
// in a 24 by 24 box, turned into lines here once, for the overlay to draw at any size and in any colour.
struct IconLine
{
	std::vector<float> points;   // x, y, x, y... in the 24 by 24 box
	bool closed = false;
};

// Null for a name that isn't one of them
const std::vector<IconLine>* BuiltinAchievementIcon(const std::string& name);

// A pack's own picture, a PNG or JPEG, read with Windows' own decoder and scaled to fit largestSide. RGBA.
bool ReadPictureFile(const std::wstring& path, unsigned largestSide, GameTexture& out);
