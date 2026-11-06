#pragma once
#include <memory>
#include <string>
#include <vector>

// What Geralt has killed, as the scripts keep it in the save. It's nothing to do with the mod's totals.
enum KillPool { kKillMonster = 0, kKillPerson = 1, kKillNamed = 2, kKillContract = 3 };

struct KillRow
{
	int pool = 0, category = 0, region = 0, random = 0, count = 0;
	int why = 0;   // -1 a boss, -2 a contract's target, -3 someone with a name; above 0, the contract's title is in title
	std::string title, name, how;
	bool Unique() const { return pool >= kKillNamed; }
};

struct KillList
{
	std::vector<KillRow> rows;
};

// On the game's tick, with what PotPOverlay_Kills returned. An empty answer leaves the last reading up:
// it means it's Ciri's turn, or there's no save.
void KillsTick(const std::string& fromScript, bool answered);

// Null until it has been read
std::shared_ptr<const KillList> GetKills();
