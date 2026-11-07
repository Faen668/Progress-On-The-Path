#pragma once
#include <map>
#include <memory>
#include <string>
#include <vector>

// The catalog as the script sends it. Built on the game's tick, then published whole, so the window
// never sees a half-read list and keeps showing the old one while a new one is being read.
enum EntryStatus { kAvailable = 0, kInProgress = 1, kCompleted = 2, kIgnored = 3, kMissed = 4 };
enum EntryFlags { kFlagMissable = 1, kFlagModAdded = 2 };
enum BookId { kBookQuest = 0, kBookWorld = 1, kBookItems = 2, kBookGwent = 3, kBookMissable = 4, kBookBestiary = 5 };
constexpr int kBookCount = 6;
constexpr int kRegionCount = 9;

struct Entry
{
	std::string uuid, title, tip;
	int status = kAvailable, region = 0, filter = 0, flags = 0;
	int manual = 0;   // set by hand: 0 no, 1 ignored, 2 completed, 3 missed
	bool gameDone = false;   // the game itself counts it as done
	bool masked = false;     // shown without its name and the rest, as the spoiler settings ask
	// Witcher gear: each tier of a piece is its own entry, and the piece shows as one row, the best tier owned
	std::string upgradeGroup;   // what its tiers share, within the section
	int upgradeTier = -1, upgradeTiers = 0;
	bool upgradeHidden = false;         // another tier of the piece shows for it
	std::vector<char> upgradeOwned;     // the row's: each tier, owned or not
	std::string upgradeNote;            // and what's next, under its name
	std::string picture, description;   // a Gwent card's, as the game's menus name its picture
	int power = -1, faction = 0, cardType = 0;
	bool neutral = false;   // a neutral card: faction is the deck it's drawn in
	std::vector<int> effects;
	std::string itemTemplate;   // an item's: the name its model is found by
	std::string image;          // a bestiary entry's: its picture's file name, under the game's journal and icon folders
	std::string creatureTemplate;   // and its model's npc template, for the Live Bestiary
	struct Weakness { std::string name, icon; };
	std::vector<Weakness> weaknesses;
	bool Done() const { return status == kCompleted || status == kIgnored; }
};

struct Section
{
	int book = 0, kind = 0, state = 0;
	std::string header;
	std::string cutoff;   // a missable group's: the quest that closes it
	std::string pin;      // a World Map group's: the map's pin for its kind of place
	int part = -1;        // an Items section's group in the list: weapons, armour sets and so on (kItemParts)
	std::vector<Entry> entries;
};

enum ModVarType { kVarToggle, kVarSlider, kVarOptions, kVarColour };   // a colour's value is RRGGBB in hex

struct ModVar
{
	std::string id, head, label, value, hint;   // head: the part of the menu's name before its colon
	std::string fallback;                       // its default, as Settings.ws defines it
	int type = kVarToggle;
	float low = 0.f, high = 1.f, step = 1.f;
	std::vector<std::string> options;
	bool startsGroup = false;             // a gap comes before it
	bool fixedRange = true;               // false: the game gave a slider no range, so it only shows its value
};

struct ModPage
{
	std::string id, title, intro, presetHint;
	std::vector<std::string> presets;
	std::vector<ModVar> vars;
};

struct Model
{
	std::string version, message;
	int done = 0, total = 0;
	std::string regions[kRegionCount];   // 0: what a Gwent card with no known place is
	std::vector<Section> sections;
	std::vector<ModPage> pages;
	std::vector<std::string> gear;   // the templates of what Geralt has on, each with #its dye if it has one
	std::map<std::string, std::string> dyeNames;   // dye_red: what the game calls it
};

// Reads one chunk from the script into a model being built. False when the chunk said there's nothing to show.
bool ParseChunk(Model& model, const std::string& text);

// Without the Flash markup and placeholders the game's strings carry
std::string CleanGameText(const std::string& in);
