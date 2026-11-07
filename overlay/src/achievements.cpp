// Reads the player's achievements from whichever store the game is running on. witcher3.exe is the same file on every
// store: it loads one plugin from bin\ddi, named after the store (it looks for steam, gog, epic, origin or battlenet in
// the name), and that plugin loads the store's own SDK. So the SDK that's loaded says which store this is.
//
// Steam and GOG are read directly, as they have the dates. Anything else, or either of those when it can't answer,
// falls back on the game's own IsAchievementUnlocked, through PotPOverlay_Achievements in the scripts. It works
// everywhere but has no dates, so those are kept as the day the overlay first saw them.
#define PSAPI_VERSION 2
#include <windows.h>
#include <psapi.h>
#include <algorithm>
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <map>
#include <mutex>
#include <unordered_map>
#include "achievements.h"
#include "gameicons.h"
#include "log.h"
#include "overlay.h"
#include "resources.h"

namespace
{
	// ------------------------------------------------------------------------------------------
	// The pack
	// ------------------------------------------------------------------------------------------

	struct PackEntry
	{
		std::string script, store;
		int group = 0;
		bool hidden = false;
		std::vector<std::string> text;   // a title and a description for each language
	};

	std::mutex g_mutex;
	std::vector<std::string> g_languages;
	std::vector<PackEntry> g_pack;
	GameTexture g_iconPixels;
	AchievementIconSheet g_sheet;
	std::shared_ptr<const AchievementList> g_list;
	std::string g_gameLanguage = "english";

	std::vector<std::string> SplitOn(const std::string& line, char separator)
	{
		std::vector<std::string> fields;
		size_t start = 0;
		for (;;)
		{
			const size_t end = line.find(separator, start);
			if (end == std::string::npos)
			{
				fields.push_back(line.substr(start));
				return fields;
			}
			fields.push_back(line.substr(start, end - start));
			start = end + 1;
		}
	}

	uint32_t U32(std::string_view data, size_t at)
	{
		uint32_t value;
		memcpy(&value, data.data() + at, 4);
		return value;
	}

	// The pack is built into the .asi. The test program can point at a file of its own instead.
	std::string_view PackBytes()
	{
#ifdef POTP_OVERLAY_TEST
		wchar_t path[MAX_PATH] = L"";
		if (GetEnvironmentVariableW(L"POTP_OVERLAY_ACHIEVEMENTS", path, MAX_PATH) > 0)
		{
			static std::vector<char> file;
			std::ifstream stream(std::filesystem::path(path), std::ios::binary);
			file.assign(std::istreambuf_iterator<char>(stream), std::istreambuf_iterator<char>());
			return { file.data(), file.size() };
		}
#endif
		return EmbeddedFile(POTP_RES_ACHIEVEMENTS);
	}

	// The store's language names, for the languages the window's fonts can show. The rest read in English.
	std::string LanguageFromGame(std::string code)
	{
		std::transform(code.begin(), code.end(), code.begin(), [](unsigned char c) { return static_cast<char>(tolower(c)); });
		static const std::map<std::string, std::string> kNames = {
			{ "en", "english" }, { "br", "brazilian" }, { "cz", "czech" }, { "de", "german" }, { "es", "spanish" }, { "esmx", "spanish" },
			{ "fr", "french" }, { "hu", "hungarian" }, { "it", "italian" }, { "pl", "polish" }, { "ru", "russian" },
		};
		const auto found = kNames.find(code);
		return found != kNames.end() ? found->second : "english";
	}

	// ------------------------------------------------------------------------------------------
	// First seen
	// ------------------------------------------------------------------------------------------

	std::string FirstSeenPath()
	{
		HMODULE self = nullptr;
		GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, reinterpret_cast<LPCSTR>(&FirstSeenPath), &self);
		char path[MAX_PATH] = "";
		GetModuleFileNameA(self, path, MAX_PATH);
		std::string s = path;
		return s.substr(0, s.find_last_of('\\') + 1) + "potp_achievements.ini";
	}

	long long FirstSeen(const std::string& script, bool save)
	{
		const std::string path = FirstSeenPath();
		char text[32] = "";
		GetPrivateProfileStringA("FirstSeen", script.c_str(), "", text, sizeof(text), path.c_str());
		long long when = atoll(text);
		if (when == 0 && save)
		{
			when = static_cast<long long>(time(nullptr));
			snprintf(text, sizeof(text), "%lld", when);
			WritePrivateProfileStringA("FirstSeen", script.c_str(), text, path.c_str());
		}
		return when;
	}

	// ------------------------------------------------------------------------------------------
	// What a store said
	// ------------------------------------------------------------------------------------------

	struct StoreAnswer
	{
		bool unlocked = false;
		uint32_t when = 0;
		float percent = -1.f;
		std::string title, description;
	};
	using StoreAnswers = std::unordered_map<std::string, StoreAnswer>;

	template <class T>
	bool Find(HMODULE module, const char* name, T& out)
	{
		out = reinterpret_cast<T>(GetProcAddress(module, name));
		return out != nullptr;
	}

	// ------------------------------------------------------------------------------------------
	// Steam, through the flat API in the game's steam_api64.dll
	// ------------------------------------------------------------------------------------------

	struct Steam
	{
		void* (*userStats)() = nullptr;
		bool (*running)() = nullptr;
		bool (*getAchievement)(void*, const char*, bool*, uint32_t*) = nullptr;
		const char* (*attribute)(void*, const char*, const char*) = nullptr;
		bool (*percent)(void*, const char*, float*) = nullptr;
		uint64_t (*askPercents)(void*) = nullptr;
		bool asked = false;
		bool usable = false;
		bool looked = false;
	} g_steam;

	void FindSteam(HMODULE module)
	{
		g_steam.looked = true;
		// The accessor carries the SDK's version in its name: the game's on 13, a patch could move it on
		for (int version = 20; version >= 11 && !g_steam.userStats; --version)
		{
			char name[64];
			snprintf(name, sizeof(name), "SteamAPI_SteamUserStats_v%03d", version);
			if (Find(module, name, g_steam.userStats))
				Log("achievements: %s", name);
		}
		g_steam.usable = g_steam.userStats
			&& Find(module, "SteamAPI_IsSteamRunning", g_steam.running)
			&& Find(module, "SteamAPI_ISteamUserStats_GetAchievementAndUnlockTime", g_steam.getAchievement)
			&& Find(module, "SteamAPI_ISteamUserStats_GetAchievementDisplayAttribute", g_steam.attribute);
		Find(module, "SteamAPI_ISteamUserStats_GetAchievementAchievedPercent", g_steam.percent);
		Find(module, "SteamAPI_ISteamUserStats_RequestGlobalAchievementPercentages", g_steam.askPercents);
		if (!g_steam.usable)
			Log("achievements: this steam_api64.dll lacks a call we need, so the game's own answer is used");
	}

	bool ReadSteam(const std::vector<PackEntry>& pack, StoreAnswers& out)
	{
		if (!g_steam.usable || !g_steam.running())
			return false;
		void* stats = g_steam.userStats();
		if (!stats)
			return false;
		if (!g_steam.asked && g_steam.askPercents)
		{
			g_steam.asked = true;
			g_steam.askPercents(stats);
		}
		for (const PackEntry& entry : pack)
		{
			StoreAnswer answer;
			if (!g_steam.getAchievement(stats, entry.store.c_str(), &answer.unlocked, &answer.when))
				return false;   // its copy of the stats hasn't arrived yet
			if (const char* text = g_steam.attribute(stats, entry.store.c_str(), "name"))
				answer.title = text;
			if (const char* text = g_steam.attribute(stats, entry.store.c_str(), "desc"))
				answer.description = text;
			float percent = 0.f;
			if (g_steam.percent && g_steam.percent(stats, entry.store.c_str(), &percent))
				answer.percent = percent;
			out[entry.store] = std::move(answer);
		}
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// GOG, through Galaxy64.dll. The order of IStats' functions was checked against the game's
	// Galaxy64.dll, where each one logs its own name.
	// ------------------------------------------------------------------------------------------

	// Its own copy constructor, so it goes on the stack the way the SDK passes it
	struct GalaxyID
	{
		GalaxyID() = default;
		GalaxyID(const GalaxyID& other) : value(other.value) {}
		GalaxyID& operator=(const GalaxyID& other) { value = other.value; return *this; }
		uint64_t value = 0;
	};

	class IGalaxyStats
	{
	public:
		virtual ~IGalaxyStats() = default;
		virtual void RequestUserStatsAndAchievements(GalaxyID user, void* listener) = 0;
		virtual int32_t GetStatInt(const char*, GalaxyID) = 0;
		virtual float GetStatFloat(const char*, GalaxyID) = 0;
		virtual void SetStatInt(const char*, int32_t) = 0;
		virtual void SetStatFloat(const char*, float) = 0;
		virtual void UpdateAvgRateStat(const char*, float, double) = 0;
		virtual void GetAchievement(const char* name, bool& unlocked, uint32_t& when, GalaxyID user) = 0;
		virtual void SetAchievement(const char*) = 0;
		virtual void ClearAchievement(const char*) = 0;
		virtual void StoreStatsAndAchievements(void*) = 0;
		virtual void ResetStatsAndAchievements(void*) = 0;
		virtual const char* GetAchievementDisplayName(const char* name) = 0;
		virtual void GetAchievementDisplayNameCopy(const char*, char*, uint32_t) = 0;
		virtual const char* GetAchievementDescription(const char* name) = 0;
	};

	struct Galaxy
	{
		IGalaxyStats* (*stats)() = nullptr;
		const void* (*error)() = nullptr;
		bool asked = false;
		bool usable = false;
		bool looked = false;
	} g_galaxy;

	void FindGalaxy(HMODULE module)
	{
		g_galaxy.looked = true;
		g_galaxy.usable = Find(module, "?Stats@api@galaxy@@YAPEAVIStats@12@XZ", g_galaxy.stats) && Find(module, "?GetError@api@galaxy@@YAPEBVIError@12@XZ", g_galaxy.error);
		if (!g_galaxy.usable)
			Log("achievements: this Galaxy64.dll lacks a call we need, so the game's own answer is used");
	}

	bool ReadGalaxy(const std::vector<PackEntry>& pack, StoreAnswers& out)
	{
		if (!g_galaxy.usable)
			return false;
		IGalaxyStats* stats = g_galaxy.stats();
		if (!stats || g_galaxy.error())
			return false;
		for (const PackEntry& entry : pack)
		{
			StoreAnswer answer;
			stats->GetAchievement(entry.store.c_str(), answer.unlocked, answer.when, GalaxyID{});
			if (g_galaxy.error())
			{
				// The game asks for them itself: once more in case it hasn't yet
				if (!g_galaxy.asked)
				{
					g_galaxy.asked = true;
					stats->RequestUserStatsAndAchievements(GalaxyID{}, nullptr);
				}
				return false;
			}
			if (const char* text = stats->GetAchievementDisplayName(entry.store.c_str()))
				answer.title = text;
			g_galaxy.error();
			if (const char* text = stats->GetAchievementDescription(entry.store.c_str()))
				answer.description = text;
			g_galaxy.error();
			out[entry.store] = std::move(answer);
		}
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// Which store
	// ------------------------------------------------------------------------------------------

	enum StoreKind { kStoreUnknown, kStoreSteam, kStoreGog, kStoreEpic, kStoreOrigin, kStoreBattleNet };

	const char* StoreName(StoreKind kind)
	{
		switch (kind)
		{
		case kStoreSteam: return "Steam";
		case kStoreGog: return "GOG";
		case kStoreEpic: return "Epic Games";
		case kStoreOrigin: return "EA";
		case kStoreBattleNet: return "Battle.net";
		default: return "";
		}
	}

	// The plugin from bin\ddi, by the same words the game looks for in its name. The SDKs are the fallback, as the game
	// can be told to use another folder.
	StoreKind DetectStore()
	{
		HMODULE modules[1024];
		DWORD needed = 0;
		if (!EnumProcessModules(GetCurrentProcess(), modules, sizeof(modules), &needed))
			return kStoreUnknown;
		const DWORD count = std::min<DWORD>(needed / sizeof(HMODULE), 1024);
		for (DWORD i = 0; i < count; ++i)
		{
			wchar_t path[MAX_PATH] = L"";
			if (!GetModuleFileNameW(modules[i], path, MAX_PATH))
				continue;
			std::wstring lower = path;
			std::transform(lower.begin(), lower.end(), lower.begin(), ::towlower);
			const size_t ddi = lower.find(L"\\ddi\\");
			if (ddi == std::wstring::npos)
				continue;
			const std::wstring name = lower.substr(ddi + 5);
			if (name.find(L"steam") != std::wstring::npos)
				return kStoreSteam;
			if (name.find(L"gog") != std::wstring::npos)
				return kStoreGog;
			if (name.find(L"epic") != std::wstring::npos)
				return kStoreEpic;
			if (name.find(L"origin") != std::wstring::npos)
				return kStoreOrigin;
			if (name.find(L"battlenet") != std::wstring::npos)
				return kStoreBattleNet;
		}
		if (GetModuleHandleW(L"steam_api64.dll"))
			return kStoreSteam;
		if (GetModuleHandleW(L"Galaxy64.dll"))
			return kStoreGog;
		return kStoreUnknown;
	}

	// Both SDKs are ours to look after: a store's update mustn't take the game down with it. No C++ objects with
	// destructors in here, so __try can be used.
	bool GuardedRead(bool (*read)(const std::vector<PackEntry>&, StoreAnswers&), const std::vector<PackEntry>& pack, StoreAnswers& out, bool& crashed)
	{
		__try
		{
			return read(pack, out);
		}
		__except (EXCEPTION_EXECUTE_HANDLER)
		{
			crashed = true;
			return false;
		}
	}

	// ------------------------------------------------------------------------------------------
	// Putting them together
	// ------------------------------------------------------------------------------------------

	struct GameAnswer
	{
		bool unlocked = false;
		int value = -1, target = 0;
	};

	// From the scripts: L|language, then A|name|unlocked|value|target for each one
	void ParseScriptAnswer(const std::string& text, std::unordered_map<std::string, GameAnswer>& out, std::string& language)
	{
		size_t start = 0;
		while (start < text.size())
		{
			size_t end = text.find("\\n", start);
			if (end == std::string::npos)
				end = text.size();
			const std::vector<std::string> fields = SplitOn(text.substr(start, end - start), '|');
			start = end + 2;
			if (fields.size() >= 2 && fields[0] == "L")
				language = fields[1];
			else if (fields.size() >= 5 && fields[0] == "A")
				out[fields[1]] = { fields[2] == "1", atoi(fields[3].c_str()), atoi(fields[4].c_str()) };
		}
	}

	void Publish(const std::vector<PackEntry>& pack, const std::vector<std::string>& languages, const StoreAnswers& store, bool storeAnswered,
		const std::unordered_map<std::string, GameAnswer>& game, bool gameAnswered, const std::string& languageName, const std::string& storeName)
	{
		size_t language = 0;
		for (size_t i = 0; i < languages.size(); ++i)
			if (languages[i] == languageName)
				language = i;

		auto list = std::make_shared<AchievementList>();
		list->storeName = storeName;
		list->fromStore = storeAnswered;
		list->fromGame = gameAnswered;
		list->items.reserve(pack.size());
		int disagree = 0;
		for (size_t i = 0; i < pack.size(); ++i)
		{
			const PackEntry& entry = pack[i];
			Achievement item;
			item.script = entry.script;
			item.store = entry.store;
			item.group = entry.group;
			item.hidden = entry.hidden;
			item.icon = static_cast<int>(i);
			const auto storeSaid = store.find(entry.store);
			const auto gameSaid = game.find(entry.script);
			const bool haveStore = storeAnswered && storeSaid != store.end();
			const bool haveGame = gameAnswered && gameSaid != game.end();
			if (haveStore && haveGame && storeSaid->second.unlocked != gameSaid->second.unlocked)
				++disagree;
			item.unlocked = haveStore ? storeSaid->second.unlocked : haveGame && gameSaid->second.unlocked;
			if (haveGame)
			{
				item.value = gameSaid->second.value;
				item.target = gameSaid->second.target;
			}
			if (haveStore)
			{
				item.percent = storeSaid->second.percent;
				if (storeSaid->second.when != 0)
					item.when = storeSaid->second.when;
			}
			if (item.unlocked && item.when == 0)
			{
				item.when = FirstSeen(entry.script, true);
				item.whenFirstSeen = true;
			}

			// In the game's language, like the rest of the window. English when the pack doesn't have that, or the store's own.
			const auto pick = [&](size_t which, const std::string& fromStore)
			{
				const size_t at = language * 2 + which;
				if (at < entry.text.size() && !entry.text[at].empty())
					return entry.text[at];
				if (!fromStore.empty())
					return fromStore;
				return which < entry.text.size() ? entry.text[which] : std::string{};
			};
			item.title = pick(0, haveStore ? storeSaid->second.title : std::string{});
			item.description = pick(1, haveStore ? storeSaid->second.description : std::string{});
			list->items.push_back(std::move(item));
		}
		static int loggedDisagree = -1;
		if (disagree != loggedDisagree)
		{
			loggedDisagree = disagree;
			if (disagree > 0)
				Log("achievements: the store and the game disagree about %d of them. The store's answer is used.", disagree);
		}

		std::lock_guard lock(g_mutex);
		g_list = std::move(list);
	}
}

void LoadAchievementPack()
{
	const std::string_view data = PackBytes();
	constexpr size_t kHeader = 36;
	if (data.size() < kHeader || memcmp(data.data(), "POTPACH1", 8) != 0)
	{
		Log("achievements: the built-in pack is missing");
		return;
	}
	const uint32_t textSize = U32(data, 8), textPacked = U32(data, 12), width = U32(data, 16), height = U32(data, 20), iconsPacked = U32(data, 24), cell = U32(data, 28), columns = U32(data, 32);
	if (data.size() < kHeader + static_cast<size_t>(textPacked) + iconsPacked || cell == 0 || columns == 0)
	{
		Log("achievements: the built-in pack is cut short");
		return;
	}
	std::string text(textSize, '\0');
	GameTexture pixels;
	pixels.dxgiFormat = 28;   // RGBA8
	pixels.width = width;
	pixels.height = height;
	pixels.rowBytes = width * 4;
	pixels.rows = height;
	pixels.pixels.resize(static_cast<size_t>(pixels.rowBytes) * height);
	const auto* bytes = reinterpret_cast<const uint8_t*>(data.data());
	if (!InflateGameData(bytes + kHeader, textPacked, reinterpret_cast<uint8_t*>(text.data()), text.size())
		|| !InflateGameData(bytes + kHeader + textPacked, iconsPacked, pixels.pixels.data(), pixels.pixels.size()))
	{
		Log("achievements: can't unpack the built-in pack");
		return;
	}

	std::vector<std::string> languages;
	std::vector<PackEntry> pack;
	const std::vector<std::string> lines = SplitOn(text, '\n');
	for (size_t i = 0; i < lines.size(); ++i)
	{
		std::vector<std::string> fields = SplitOn(lines[i], '\t');
		if (i == 0)
		{
			languages = std::move(fields);
			continue;
		}
		if (fields.size() < 6)
			continue;
		PackEntry entry;
		entry.script = fields[0];
		entry.store = fields[1];
		entry.group = atoi(fields[2].c_str());
		entry.hidden = fields[3] == "1";
		entry.text.assign(fields.begin() + 4, fields.end());
		pack.push_back(std::move(entry));
	}

	{
		std::lock_guard lock(g_mutex);
		g_languages = std::move(languages);
		g_pack = std::move(pack);
		g_iconPixels = std::move(pixels);
		g_sheet.pixels = &g_iconPixels;
		g_sheet.cell = static_cast<int>(cell);
		g_sheet.columns = static_cast<int>(columns);
		g_sheet.rows = static_cast<int>(height / cell / 2);
	}
	Log("achievements: %zu in the pack", g_pack.size());
	Publish(g_pack, g_languages, {}, false, {}, false, "english", "");
}

void AchievementsTick(const std::string& fromScript, bool answered)
{
	if (g_pack.empty())
		return;

	std::unordered_map<std::string, GameAnswer> game;
	std::string code;
	if (answered)
		ParseScriptAnswer(fromScript, game, code);
	if (!code.empty())
		g_gameLanguage = LanguageFromGame(code);

	static StoreKind store = kStoreUnknown;
	static bool storeOff = false;
	if (store == kStoreUnknown)
	{
		store = DetectStore();
		if (store != kStoreUnknown)
			Log("achievements: running on %s", StoreName(store));
	}

	StoreAnswers answers;
	bool storeAnswered = false;
	if (!storeOff && (store == kStoreSteam || store == kStoreGog))
	{
		const wchar_t* const sdk = store == kStoreSteam ? L"steam_api64.dll" : L"Galaxy64.dll";
		if (HMODULE module = GetModuleHandleW(sdk))
		{
			if (store == kStoreSteam && !g_steam.looked)
				FindSteam(module);
			if (store == kStoreGog && !g_galaxy.looked)
				FindGalaxy(module);
			bool crashed = false;
			storeAnswered = GuardedRead(store == kStoreSteam ? ReadSteam : ReadGalaxy, g_pack, answers, crashed);
			if (crashed)
			{
				storeOff = true;
				storeAnswered = false;
				answers.clear();
				Log("achievements: reading %s crashed, so the game's own answer is used from now on", StoreName(store));
			}
		}
	}

	static int logged = -1;
	const int state = (storeAnswered ? 1 : 0) + (answered && !game.empty() ? 2 : 0);
	if (state != logged)
	{
		logged = state;
		Log("achievements: %s %s, the game's scripts %s", StoreName(store), storeAnswered ? "answered" : "didn't answer", answered && !game.empty() ? "answered" : "didn't answer");
	}
	Publish(g_pack, g_languages, answers, storeAnswered, game, answered && !game.empty(), g_gameLanguage, StoreName(store));
}

#ifdef POTP_OVERLAY_TEST
void AchievementsTestAnswer(const std::string& text)
{
	if (g_pack.empty())
		return;
	// As the scripts answer, with lines the store would have answered: D|store name|unix time|percent, and S|store's name
	std::unordered_map<std::string, GameAnswer> game;
	std::string code, storeName;
	ParseScriptAnswer(text, game, code);
	StoreAnswers answers;
	size_t start = 0;
	while (start < text.size())
	{
		size_t end = text.find("\\n", start);
		if (end == std::string::npos)
			end = text.size();
		const std::vector<std::string> fields = SplitOn(text.substr(start, end - start), '|');
		start = end + 2;
		if (fields.size() >= 2 && fields[0] == "S")
			storeName = fields[1];
		if (fields.size() >= 4 && fields[0] == "D")
		{
			StoreAnswer& answer = answers[fields[1]];
			answer.when = static_cast<uint32_t>(atoll(fields[2].c_str()));
			answer.unlocked = answer.when != 0;
			answer.percent = static_cast<float>(atof(fields[3].c_str()));
		}
	}
	Publish(g_pack, g_languages, answers, !answers.empty(), game, !game.empty(), LanguageFromGame(code.empty() ? "en" : code), storeName);
}
#endif

std::shared_ptr<const AchievementList> GetAchievements()
{
	std::lock_guard lock(g_mutex);
	return g_list;
}

AchievementIconSheet GetAchievementIcons()
{
	std::lock_guard lock(g_mutex);
	return g_sheet;
}
