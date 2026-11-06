#pragma once
#include <memory>
#include <string>
#include <vector>

struct GameTexture;

// The game's achievements, on whichever store it's running on. Three sources, as each one has what the others lack:
// the pack that ships with the mod (titles, descriptions and icons, the same on every store), the store's own API
// (unlock dates, and how many players have each one), and the game's scripts (what's unlocked on any store, and this
// save's counts). None of this counts towards the mod's own completion.
struct Achievement
{
	std::string script, store;        // its name in the scripts (EA_...) and on Steam and GOG
	std::string title, description;
	int group = 0;                    // 0 the base game, 1 Hearts of Stone, 2 Blood and Wine
	int icon = 0;                     // its place in the icons' picture
	bool hidden = false;              // the stores keep it secret until it's unlocked
	bool unlocked = false;
	long long when = 0;               // unix time, 0 when there's no date
	bool whenFirstSeen = false;       // the store gave no date: when the overlay first saw it unlocked
	float percent = -1.f;             // of all players, -1 when the store doesn't say
	int value = -1, target = 0;       // this save's count towards it, when the game keeps one
	// One a mod added (customach.h): no store, no icon in the pack's picture
	bool custom = false;
	int ring = 0;                     // 0 gold, 1 silver, 2 bronze, 3 none
	std::string reward;               // what it gives, empty for nothing
	std::string picture;              // builtin:<name>, game:<path in the game's files> or file:<full path>
};

struct AchievementList
{
	std::vector<Achievement> items;
	std::string storeName;   // "Steam", "GOG", "Epic Games" and so on, empty until it can be told
	bool fromStore = false;  // the store's API answered
	bool fromGame = false;   // the game's scripts answered
};

// Reads PotP's achievements.dat, in mods\modProgressOnThePathNG or its folder under another name: on a thread of its own
void LoadAchievementPack(const std::wstring& gameFolder);

// On the game's tick, with what PotPOverlay_Achievements returned. answered: the script exists and ran.
void AchievementsTick(const std::string& fromScript, bool answered);

// What the off-screen test pretends the store and the scripts said
#ifdef POTP_OVERLAY_TEST
void AchievementsTestAnswer(const std::string& text);
#endif

// Null until the pack has been read
std::shared_ptr<const AchievementList> GetAchievements();

// The icons' picture: colour above, grey below. Null until the pack has been read.
struct AchievementIconSheet
{
	const GameTexture* pixels = nullptr;
	int cell = 64, columns = 10, rows = 0;   // rows in each half
};
AchievementIconSheet GetAchievementIcons();
