#pragma once
#include <functional>
#include <memory>
#include <string>
#include <vector>
#include "achievements.h"

// Achievements that mods add, from a potp_achievements.xml in their mod folder (research/achievement-injector/schema.md
// has the format). The overlay reads the files and decides what's unlocked. The scripts only answer what it asks about
// the game, keep each unlock in a fact, so it belongs to the save, and give the rewards.

struct CustomAchievementSection
{
	std::string header;
	std::vector<Achievement> items;   // custom = true on each
};

struct CustomAchievementList
{
	std::vector<CustomAchievementSection> sections;
	int packs = 0;
	int problems = 0;   // achievements or files that couldn't be read: the log says why
	bool live = false;  // the scripts have answered for this save
};

// Reads every mods\*\potp_achievements.xml. On the start thread.
void LoadCustomAchievementPacks(const std::wstring& gameFolder);

// On the game's tick: tells the scripts what to watch, asks them about the game once a second, and unlocks what's due
struct CustomAchievementCalls
{
	std::function<void(const std::string&)> exec;                 // runs an exec function, as the console would
	std::function<bool(const char*, std::string&)> callString;    // calls a script function that returns a string
};
void CustomAchievementsTick(const CustomAchievementCalls& calls);

// Null until the files have been read. A new list replaces it whenever something changes.
std::shared_ptr<const CustomAchievementList> GetCustomAchievements();
