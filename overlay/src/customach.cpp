// Achievements that mods add. Each mod ships mods\<its folder>\potp_achievements.xml (the format is in
// research/achievement-injector/schema.md). This reads them with XmlLite, which is part of Windows, and decides what's
// unlocked. The scripts (PotPOverlayCustomAchievements.ws) are told once what to look at, a list of probes: a fact, a
// quest, a count of kills, an item and so on. Once a second they answer with a value for each, and this works out the
// conditions from those. An unlock goes back to them: they set its fact, which keeps it in the save, and give its reward.
//
// Strings go to the scripts through the console's exec functions, which take bare words. So any character that isn't a
// letter or a digit is written as _ and two hex digits, and the scripts undo it. Item names are the exception: the
// scripts need them as names, which only the console can make from text, so they go across as they are.
#include <windows.h>
#include <shlwapi.h>
#include <xmllite.h>
#include <algorithm>
#include <atomic>
#include <cstdio>
#include <ctime>
#include <map>
#include <mutex>
#include <set>
#include "achicons.h"
#include "customach.h"
#include "log.h"
#include "overlay.h"
#include "text.h"

namespace
{
	// ------------------------------------------------------------------------------------------
	// Reading XML
	// ------------------------------------------------------------------------------------------

	std::string Utf8(const wchar_t* text)
	{
		if (!text || !*text)
			return {};
		const int size = WideCharToMultiByte(CP_UTF8, 0, text, -1, nullptr, 0, nullptr, nullptr);
		std::string out(static_cast<size_t>(size > 0 ? size - 1 : 0), '\0');
		if (size > 1)
			WideCharToMultiByte(CP_UTF8, 0, text, -1, out.data(), size, nullptr, nullptr);
		return out;
	}

	std::wstring Wide(const std::string& text)
	{
		if (text.empty())
			return {};
		const int size = MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, nullptr, 0);
		std::wstring out(static_cast<size_t>(size > 0 ? size - 1 : 0), L'\0');
		if (size > 1)
			MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, out.data(), size);
		return out;
	}

	struct XNode
	{
		std::string name, text;
		std::vector<std::pair<std::string, std::string>> attrs;
		std::vector<XNode> kids;
		UINT line = 0;

		const std::string* Attr(const char* key) const
		{
			for (const auto& [k, v] : attrs)
				if (k == key)
					return &v;
			return nullptr;
		}
	};

	template <class T>
	struct Released
	{
		T* p = nullptr;
		~Released() { if (p) p->Release(); }
	};

	bool ReadXml(const std::wstring& path, XNode& root, std::string& error)
	{
		Released<IStream> stream;
		if (FAILED(SHCreateStreamOnFileW(path.c_str(), STGM_READ | STGM_SHARE_DENY_WRITE, &stream.p)))
			return error = "can't be opened", false;
		Released<IXmlReader> reader;
		if (FAILED(CreateXmlReader(__uuidof(IXmlReader), reinterpret_cast<void**>(&reader.p), nullptr)))
			return error = "XmlLite isn't available", false;
		reader.p->SetProperty(XmlReaderProperty_DtdProcessing, DtdProcessing_Prohibit);
		if (FAILED(reader.p->SetInput(stream.p)))
			return error = "can't be read", false;

		std::vector<XNode*> open;   // only the newest child of each is ever open, so these stay put
		bool haveRoot = false;
		XmlNodeType type;
		HRESULT hr;
		while ((hr = reader.p->Read(&type)) == S_OK)
		{
			if (type == XmlNodeType_Element)
			{
				XNode node;
				const wchar_t* local = nullptr;
				reader.p->GetLocalName(&local, nullptr);
				node.name = Utf8(local);
				reader.p->GetLineNumber(&node.line);
				const bool empty = reader.p->IsEmptyElement() != FALSE;
				for (HRESULT a = reader.p->MoveToFirstAttribute(); a == S_OK; a = reader.p->MoveToNextAttribute())
				{
					const wchar_t* prefix = nullptr;
					UINT prefixLength = 0;
					reader.p->GetPrefix(&prefix, &prefixLength);
					const wchar_t* key = nullptr;
					reader.p->GetLocalName(&key, nullptr);
					if (prefixLength > 0 || wcscmp(key, L"xmlns") == 0)
						continue;   // xmlns and xsi:noNamespaceSchemaLocation
					const wchar_t* value = nullptr;
					reader.p->GetValue(&value, nullptr);
					node.attrs.emplace_back(Utf8(key), Utf8(value));
				}
				reader.p->MoveToElement();

				XNode* placed;
				if (open.empty())
				{
					if (haveRoot)
						return error = "has more than one root element", false;
					root = std::move(node);
					placed = &root;
					haveRoot = true;
				}
				else
				{
					open.back()->kids.push_back(std::move(node));
					placed = &open.back()->kids.back();
				}
				if (!empty)
					open.push_back(placed);
			}
			else if (type == XmlNodeType_EndElement)
			{
				if (!open.empty())
					open.pop_back();
			}
			else if (type == XmlNodeType_Text || type == XmlNodeType_CDATA)
			{
				const wchar_t* value = nullptr;
				reader.p->GetValue(&value, nullptr);
				if (!open.empty())
					open.back()->text += Utf8(value);
			}
		}
		if (FAILED(hr))
		{
			UINT line = 0;
			reader.p->GetLineNumber(&line);
			char text[96];
			snprintf(text, sizeof(text), "isn't valid XML near line %u (0x%08lx)", line, static_cast<unsigned long>(hr));
			return error = text, false;
		}
		if (!haveRoot)
			return error = "is empty", false;
		return true;
	}

	// ------------------------------------------------------------------------------------------
	// What a pack holds
	// ------------------------------------------------------------------------------------------

	enum class Kind { All, Any, AtLeast, Not, Fact, Quest, Block, Kills, Item, Level, Crowns, Entry, Section, Achievement, Vanilla };

	enum Op { kGe, kGt, kLe, kLt, kEq, kNe };

	struct Condition
	{
		Kind kind = Kind::All;
		int op = kGe, value = 1, n = 0;
		int state = 0;          // a quest's or an entry's, as listed in kQuestStates and kEntryStates
		bool percent = true;    // a section's unit
		int probe = -1;         // -1: can't be met, such as another pack's achievement that isn't installed
		std::string text;       // a vanilla achievement's EA_ name, another achievement's full ID
		std::string ref;
		std::vector<Condition> kids;
	};

	const char* const kQuestStates[] = { "done", "failed", "ended", "active", "started" };
	const char* const kEntryStates[] = { "completed", "missed", "ignored", "closed" };
	const char* const kOps[] = { "ge", "gt", "le", "lt", "eq", "ne" };
	const char* const kRings[] = { "gold", "silver", "bronze", "none" };

	struct Reward
	{
		int kind = 0;   // 0 crowns, 1 an item, 2 experience: the scripts use the same numbers
		int amount = 0;
		std::string item;
		std::string display;   // an item's name in the game's language, once the scripts have said
	};

	// A title or description in each language the pack has. The game's own language codes: en, pl, de...
	// Or a key into the mod's own .w3strings, which the scripts look up in the game's language: then the texts
	// written in the file are only for when the key can't be found
	struct Localised
	{
		std::vector<std::pair<std::string, std::string>> texts;   // language ("" for none), text
		std::string key;
		std::string looked;   // the key's text, as the scripts last said: empty when it isn't in any .w3strings

		// The key's text, else the game's language, else the one with no language, else English, else the first,
		// else the key itself, so a missing string shows what's missing
		std::string Pick(const std::string& language) const
		{
			if (!looked.empty())
				return looked;
			for (const char* want : { language.c_str(), "", "en" })
				for (const auto& [lang, text] : texts)
					if (lang == want && !text.empty())
						return text;
			for (const auto& [lang, text] : texts)
				if (!text.empty())
					return text;
			return key;
		}
	};

	struct CustomAch
	{
		std::string pack, id, full;
		Localised title, description;
		std::string icon = "builtin:trophy";   // a file's made into a full path
		int ring = 0;
		bool hidden = false, retroactive = true;
		Condition unlock;
		std::string progressOf;
		bool progressConditions = false;
		std::vector<Reward> rewards;
		int unlockProbe = -1, seenProbe = -1;

		// What the last answer said, on the game's tick only
		bool unlocked = false;
		int day = 0;   // the date it unlocked: days since 1 January 2020
		int value = -1, target = 0;
		bool asked = false;
		ULONGLONG askedAt = 0;
	};

	struct Pack
	{
		std::string id;
		Localised title;
		std::vector<size_t> items;   // into g_achievements
	};

	// One thing the scripts are asked about
	struct Probe
	{
		char kind;          // F fact, B quest block, Q quest, K kills, I item, L level, C crowns, E PotP entry, S PotP section
		std::string key;
		std::string item;   // an item's name, for I
	};

	// Made on the start thread, then only read; the live parts of CustomAch only change on the game's tick
	std::vector<Pack> g_packs;
	std::vector<CustomAch> g_achievements;
	std::vector<Probe> g_probes;
	std::map<std::string, int> g_probeIndex;
	int g_problems = 0;
	int g_generation = 0;
	std::atomic<bool> g_loaded{ false };
	std::string g_language = "en";   // the game's, as the scripts last said
	bool g_namesAsked = false;        // the items' names in that language
	std::wstring g_gameFolder;
	std::wstring g_packsSeen;         // each pack's path, time and size, to tell when one changes

	std::mutex g_viewMutex;
	std::shared_ptr<const CustomAchievementList> g_view;

	int AddProbe(char kind, const std::string& key, const std::string& item = std::string())
	{
		const std::string id = std::string(1, kind) + '\x1f' + key + '\x1f' + item;
		const auto found = g_probeIndex.find(id);
		if (found != g_probeIndex.end())
			return found->second;
		const int index = static_cast<int>(g_probes.size());
		g_probes.push_back({ kind, key, item });
		g_probeIndex.emplace(id, index);
		return index;
	}

	bool ValidId(const std::string& id, size_t longest)
	{
		if (id.empty() || id.size() > longest || id[0] < 'a' || id[0] > 'z')
			return false;
		return std::all_of(id.begin(), id.end(), [](char c) { return (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_'; });
	}

	bool ValidGuid(const std::string& guid)
	{
		if (guid.size() != 36)
			return false;
		for (size_t i = 0; i < guid.size(); ++i)
		{
			const bool dash = i == 8 || i == 13 || i == 18 || i == 23;
			if (dash ? guid[i] != '-' : !isxdigit(static_cast<unsigned char>(guid[i])))
				return false;
		}
		return true;
	}

	std::string Lower(std::string s)
	{
		std::transform(s.begin(), s.end(), s.begin(), [](unsigned char c) { return static_cast<char>(tolower(c)); });
		return s;
	}

	// Reading one file. Each problem goes to the log and is counted; a bad achievement is left out, the rest stay.
	struct Reader
	{
		std::string file;
		std::string where;   // the achievement being read
		bool bad = false;

		void Problem(const XNode& at, const std::string& what)
		{
			Log("custom achievements: %s line %u%s%s: %s", file.c_str(), at.line, where.empty() ? "" : ", ", where.c_str(), what.c_str());
			bad = true;
		}

		bool Int(const XNode& node, const char* key, int& out, int lowest, int highest, bool required)
		{
			const std::string* text = node.Attr(key);
			if (!text)
			{
				if (required)
					Problem(node, std::string("<") + node.name + "> needs " + key);
				return !required;
			}
			char* end = nullptr;
			const long value = strtol(text->c_str(), &end, 10);
			if (text->empty() || *end != 0 || value < lowest || value > highest)
			{
				Problem(node, std::string(key) + "=\"" + *text + "\" isn't a whole number from " + std::to_string(lowest) + " to " + std::to_string(highest));
				return false;
			}
			out = static_cast<int>(value);
			return true;
		}

		bool Text(const XNode& node, const char* key, std::string& out)
		{
			const std::string* text = node.Attr(key);
			if (!text || text->find_first_not_of(" \t\r\n") == std::string::npos)
			{
				Problem(node, std::string("<") + node.name + "> needs " + key);
				return false;
			}
			out = *text;
			return true;
		}

		int Choice(const XNode& node, const char* key, const char* const* names, int count, int fallback)
		{
			const std::string* text = node.Attr(key);
			if (!text)
				return fallback;
			for (int i = 0; i < count; ++i)
				if (*text == names[i])
					return i;
			Problem(node, std::string(key) + "=\"" + *text + "\" isn't one of the choices");
			return fallback;
		}

		bool Bool(const XNode& node, const char* key, bool fallback)
		{
			const std::string* text = node.Attr(key);
			if (!text)
				return fallback;
			if (*text == "true" || *text == "1")
				return true;
			if (*text == "false" || *text == "0")
				return false;
			Problem(node, std::string(key) + " must be true or false");
			return fallback;
		}

		void Compare(const XNode& node, Condition& c, int defaultValue = 1)
		{
			c.op = Choice(node, "op", kOps, 6, kGe);
			c.value = defaultValue;
			Int(node, "value", c.value, -2000000000, 2000000000, false);
		}

		bool ReadCondition(const XNode& node, Condition& c, std::set<std::string>& refs)
		{
			if (const std::string* ref = node.Attr("ref"))
			{
				if (!ValidId(*ref, 48) || !refs.insert(*ref).second)
					Problem(node, "ref=\"" + *ref + "\" isn't a valid name, or is used twice");
				c.ref = *ref;
			}
			const std::string& n = node.name;
			std::string text;
			if (n == "all" || n == "any" || n == "atLeast" || n == "not")
			{
				c.kind = n == "all" ? Kind::All : n == "any" ? Kind::Any : n == "atLeast" ? Kind::AtLeast : Kind::Not;
				if (c.kind == Kind::AtLeast)
					Int(node, "n", c.n, 1, 1000, true);
				for (const XNode& kid : node.kids)
				{
					c.kids.emplace_back();
					ReadCondition(kid, c.kids.back(), refs);
				}
				if (c.kids.empty() || (c.kind == Kind::Not && c.kids.size() != 1))
					Problem(node, c.kind == Kind::Not ? "<not> holds exactly one condition" : "<" + n + "> is empty");
			}
			else if (n == "fact")
			{
				c.kind = Kind::Fact;
				Compare(node, c);
				if (Text(node, "name", text))
					c.probe = AddProbe('F', text);
			}
			else if (n == "quest")
			{
				c.kind = Kind::Quest;
				c.state = Choice(node, "state", kQuestStates, 5, 0);
				if (Text(node, "journal", text))
					c.probe = AddProbe('Q', text);
			}
			else if (n == "questBlock")
			{
				c.kind = Kind::Block;
				if (Text(node, "guid", text))
				{
					if (!ValidGuid(text))
						Problem(node, "guid=\"" + text + "\" isn't a GUID");
					const std::string* output = node.Attr("output");
					c.probe = AddProbe('B', Lower(text) + "." + (output ? *output : std::string("*")));
				}
			}
			else if (n == "kills")
			{
				c.kind = Kind::Kills;
				Compare(node, c);
				int id = 0;
				if (Int(node, "nameId", id, 1, 2000000000, true))
					c.probe = AddProbe('K', std::to_string(id));
			}
			else if (n == "item" || n == "gwentCard")
			{
				// Gwent cards are items in the inventory too. Where: inventory, the stash (the horse's inventory, as
				// PotP's own item tracking reads it), or either, counted together
				c.kind = Kind::Item;
				Compare(node, c);
				static const char* const kWhere[] = { "either", "inventory", "stash" };
				const int place = Choice(node, "where", kWhere, 3, 0);
				if (Text(node, "name", text))
					c.probe = AddProbe('I', kWhere[place], text);
			}
			else if (n == "level" || n == "crowns")
			{
				c.kind = n == "level" ? Kind::Level : Kind::Crowns;
				Compare(node, c);
				c.probe = AddProbe(n == "level" ? 'L' : 'C', "");
			}
			else if (n == "potpEntry")
			{
				c.kind = Kind::Entry;
				c.state = Choice(node, "state", kEntryStates, 4, 0);
				if (Text(node, "uuid", text))
					c.probe = AddProbe('E', text);
			}
			else if (n == "potpSection")
			{
				c.kind = Kind::Section;
				const std::string* unit = node.Attr("unit");
				c.percent = !unit || *unit == "percent";
				if (unit && *unit != "percent" && *unit != "count")
					Problem(node, "unit must be percent or count");
				Compare(node, c, c.percent ? 100 : 1);
				if (Text(node, "id", text))
					c.probe = AddProbe('S', text);
			}
			else if (n == "achievement")
			{
				c.kind = Kind::Achievement;
				Text(node, "id", c.text);   // made into a full ID and a probe once every pack is read
			}
			else if (n == "vanillaAchievement")
			{
				c.kind = Kind::Vanilla;
				if (Text(node, "name", c.text) && c.text.rfind("EA_", 0) != 0)
					Problem(node, "name must be the game's EA_ name");
			}
			else
			{
				Problem(node, "<" + n + "> isn't a condition this version knows");
				return false;
			}
			return true;
		}
	};

	Localised Collect(const XNode& parent, const char* element)
	{
		Localised out;
		for (const XNode& kid : parent.kids)
			if (kid.name == element)
			{
				if (const std::string* key = kid.Attr("key"); key && out.key.empty())
					out.key = *key;
				const std::string* lang = kid.Attr("lang");
				if (!kid.text.empty() || lang)
					out.texts.emplace_back(lang ? *lang : std::string(), kid.text);
			}
		return out;
	}

	const Condition* FindRef(const Condition& c, const std::string& ref)
	{
		if (c.ref == ref)
			return &c;
		for (const Condition& kid : c.kids)
			if (const Condition* found = FindRef(kid, ref))
				return found;
		return nullptr;
	}

	bool Countable(Kind k)
	{
		return k == Kind::Fact || k == Kind::Kills || k == Kind::Item || k == Kind::Level || k == Kind::Crowns || k == Kind::Section;
	}

	void ReadPack(const std::wstring& path, const std::string& folder)
	{
		Reader r;
		r.file = folder + "\\potp_achievements.xml";
		XNode root;
		std::string error;
		if (!ReadXml(path, root, error))
		{
			Log("custom achievements: %s %s: skipped", r.file.c_str(), error.c_str());
			++g_problems;
			return;
		}
		int version = 0;
		if (root.name != "potpAchievements" || !r.Int(root, "schemaVersion", version, 1, 1000000, true) || version != 1)
		{
			Log("custom achievements: %s isn't a version 1 achievements pack: skipped", r.file.c_str());
			++g_problems;
			return;
		}
		Pack pack;
		if (!r.Text(root, "id", pack.id) || !ValidId(pack.id, 32))
		{
			Log("custom achievements: %s needs an id of lower case letters, digits and _: skipped", r.file.c_str());
			++g_problems;
			return;
		}
		for (const Pack& other : g_packs)
			if (other.id == pack.id)
			{
				Log("custom achievements: %s uses the pack id %s, which another pack has: skipped", r.file.c_str(), pack.id.c_str());
				++g_problems;
				return;
			}

		std::set<std::string> ids;
		for (const XNode& node : root.kids)
		{
			if (node.name == "about")
			{
				pack.title = Collect(node, "title");
			}
			else if (node.name == "achievement")
			{
				CustomAch a;
				a.pack = pack.id;
				r.bad = false;
				r.where.clear();
				if (!r.Text(node, "id", a.id) || !ValidId(a.id, 48))
					r.Problem(node, "needs an id of lower case letters, digits and _");
				r.where = a.id;
				if (!ids.insert(a.id).second)
					r.Problem(node, "this id is used twice");
				a.full = pack.id + "." + a.id;
				a.ring = r.Choice(node, "ring", kRings, 4, 0);
				if (const std::string* icon = node.Attr("icon"))
				{
					// A picture that can't be found falls back on the trophy: worth a line in the log, not losing the achievement
					const auto fallBack = [&](const std::string& why)
					{
						Log("custom achievements: %s, %s: icon=\"%s\" %s, so it has the trophy", r.file.c_str(), a.id.c_str(), icon->c_str(), why.c_str());
						++g_problems;
					};
					if (icon->rfind("builtin:", 0) == 0)
					{
						if (BuiltinAchievementIcon(icon->substr(8)))
							a.icon = *icon;
						else
							fallBack("isn't one of PotP's icons");
					}
					else if (icon->rfind("game:", 0) == 0 && icon->size() > 5)
					{
						std::string inGame = icon->substr(5);
						std::replace(inGame.begin(), inGame.end(), '\\', '/');
						a.icon = "game:" + inGame;
					}
					else if (icon->rfind("file:", 0) == 0 && icon->size() > 5 && icon->find("..") == std::string::npos)
					{
						std::string relative = icon->substr(5);
						std::replace(relative.begin(), relative.end(), '/', '\\');
						const std::wstring full = path.substr(0, path.find_last_of(L'\\') + 1) + Wide(relative);
						if (GetFileAttributesW(full.c_str()) != INVALID_FILE_ATTRIBUTES)
							a.icon = "file:" + Utf8(full.c_str());
						else
							fallBack("isn't in the pack's folder");
					}
					else
						fallBack("isn't builtin:, game: or file:");
				}
				a.hidden = r.Bool(node, "hidden", false);
				a.retroactive = r.Bool(node, "retroactive", true);
				a.title = Collect(node, "title");
				a.description = Collect(node, "description");
				if (a.title.Pick("en").empty())
					r.Problem(node, "needs a title");

				bool haveUnlock = false;
				std::set<std::string> refs;
				for (const XNode& kid : node.kids)
				{
					if (kid.name == "unlock")
					{
						if (kid.kids.size() != 1)
							r.Problem(kid, "<unlock> holds exactly one condition");
						else
						{
							haveUnlock = true;
							r.ReadCondition(kid.kids[0], a.unlock, refs);
						}
					}
					else if (kid.name == "progress")
					{
						if (const std::string* of = kid.Attr("of"))
							a.progressOf = *of;
						a.progressConditions = r.Bool(kid, "conditions", false);
					}
					else if (kid.name == "reward")
					{
						for (const XNode& part : kid.kids)
						{
							Reward reward;
							if (part.name == "crowns" || part.name == "experience")
							{
								reward.kind = part.name == "crowns" ? 0 : 2;
								r.Int(part, "amount", reward.amount, 1, 100000, true);
							}
							else if (part.name == "item")
							{
								reward.kind = 1;
								reward.amount = 1;
								r.Text(part, "name", reward.item);
								r.Int(part, "quantity", reward.amount, 1, 100, false);
							}
							else
							{
								r.Problem(part, "<" + part.name + "> isn't a reward this version knows");
								continue;
							}
							a.rewards.push_back(reward);
						}
						if (a.rewards.empty() || a.rewards.size() > 10)
							r.Problem(kid, "<reward> holds 1 to 10 rewards");
					}
					else if (kid.name != "title" && kid.name != "description")
					{
						r.Problem(kid, "<" + kid.name + "> isn't known here");
					}
				}
				if (!haveUnlock)
					r.Problem(node, "needs an <unlock>");
				if (!a.progressOf.empty())
				{
					const Condition* of = FindRef(a.unlock, a.progressOf);
					if (!of || !Countable(of->kind))
						r.Problem(node, "progress of=\"" + a.progressOf + "\" doesn't name a countable condition");
				}
				if (r.bad)
				{
					Log("custom achievements: %s: %s left out", r.file.c_str(), a.full.c_str());
					++g_problems;
					continue;
				}
				pack.items.push_back(g_achievements.size());
				g_achievements.push_back(std::move(a));
			}
			else
			{
				r.where.clear();
				r.Problem(node, "<" + node.name + "> isn't known here");
				++g_problems;
			}
		}
		if (pack.title.texts.empty())
			pack.title.texts.emplace_back(std::string(), pack.id);
		Log("custom achievements: %s: %zu achievements from pack %s", r.file.c_str(), pack.items.size(), pack.id.c_str());
		if (!pack.items.empty())
			g_packs.push_back(std::move(pack));
	}

	// Once every pack is read: another achievement's unlock, by its fact
	void ResolveAchievementConditions(Condition& c, const CustomAch& owner, const std::set<std::string>& known)
	{
		for (Condition& kid : c.kids)
			ResolveAchievementConditions(kid, owner, known);
		if (c.kind != Kind::Achievement)
			return;
		const std::string full = c.text.find('.') == std::string::npos ? owner.pack + "." + c.text : c.text;
		if (known.count(full))
			c.probe = AddProbe('F', "potp_ach." + full);
		else
			Log("custom achievements: %s needs %s, which isn't installed: that part can't be met", owner.full.c_str(), full.c_str());
	}

	// ------------------------------------------------------------------------------------------
	// Talking to the scripts
	// ------------------------------------------------------------------------------------------

	std::string Encode(const std::string& text)
	{
		static const char kHex[] = "0123456789ABCDEF";
		std::string out;
		for (unsigned char c : text)
		{
			if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
				out += static_cast<char>(c);
			else
			{
				out += '_';
				out += kHex[c >> 4];
				out += kHex[c & 15];
			}
		}
		return out.empty() ? "_20" : out;   // an empty argument would shift the rest
	}

	std::vector<std::string> g_queue;   // exec lines still to send
	size_t g_queueAt = 0;
	ULONGLONG g_nextAnswer = 0, g_queuedAt = 0;
	bool g_live = false;

	// Every text a pack gives as a .w3strings key, in a steady order: the scripts answer in the same one
	std::vector<Localised*> KeyedTexts()
	{
		std::vector<Localised*> out;
		const auto add = [&](Localised& text) { if (!text.key.empty()) out.push_back(&text); };
		for (Pack& pack : g_packs)
			add(pack.title);
		for (CustomAch& a : g_achievements)
		{
			add(a.title);
			add(a.description);
		}
		return out;
	}

	void QueueRegistration()
	{
		g_queue.clear();
		g_queueAt = 0;
		g_queue.push_back("potpach_begin(" + std::to_string(g_generation) + ")");
		for (const Probe& p : g_probes)
			g_queue.push_back("potpach_probe(" + std::string(1, p.kind) + ", " + Encode(p.key) + ", " + (p.item.empty() ? std::string("None") : p.item) + ")");
		for (const CustomAch& a : g_achievements)
		{
			g_queue.push_back("potpach_define(" + Encode("potp_ach." + a.full) + ", " + Encode(a.retroactive ? std::string() : "potp_achseen." + a.full) + ")");
			for (const Reward& r : a.rewards)
				g_queue.push_back("potpach_reward(" + std::to_string(r.kind) + ", " + std::to_string(r.amount) + ", " + (r.item.empty() ? std::string("None") : r.item) + ")");
		}
		std::vector<Localised*> keyed = KeyedTexts();
		for (const Localised* text : keyed)
			g_queue.push_back("potpach_text(" + Encode(text->key) + ")");
		g_queue.push_back("potpach_end(" + std::to_string(g_generation) + ", " + std::to_string(g_probes.size()) + ", " + std::to_string(g_achievements.size())
			+ ", " + std::to_string(keyed.size()) + ")");
		Log("custom achievements: telling the scripts about %zu achievements and %zu probes", g_achievements.size(), g_probes.size());
	}

	struct Value
	{
		long long a = 0, b = 0;   // b: a section's total
	};

	bool Compare(long long have, int op, long long want)
	{
		switch (op)
		{
		case kGt: return have > want;
		case kLe: return have <= want;
		case kLt: return have < want;
		case kEq: return have == want;
		case kNe: return have != want;
		default: return have >= want;
		}
	}

	bool VanillaUnlocked(const std::string& script)
	{
		const std::shared_ptr<const AchievementList> list = GetAchievements();
		if (!list)
			return false;
		for (const Achievement& a : list->items)
			if (a.script == script)
				return a.unlocked;
		return false;
	}

	bool Met(const Condition& c, const std::vector<Value>& v)
	{
		const auto at = [&](int probe) { return probe >= 0 && probe < static_cast<int>(v.size()) ? v[probe] : Value{}; };
		switch (c.kind)
		{
		case Kind::All:
			return std::all_of(c.kids.begin(), c.kids.end(), [&](const Condition& k) { return Met(k, v); });
		case Kind::Any:
			return std::any_of(c.kids.begin(), c.kids.end(), [&](const Condition& k) { return Met(k, v); });
		case Kind::AtLeast:
			return std::count_if(c.kids.begin(), c.kids.end(), [&](const Condition& k) { return Met(k, v); }) >= c.n;
		case Kind::Not:
			return !c.kids.empty() && !Met(c.kids[0], v);
		case Kind::Quest:
		{
			// The scripts answer 0 not started, 1 active, 2 done, 3 failed
			const long long s = at(c.probe).a;
			switch (c.state)
			{
			case 1: return s == 3;
			case 2: return s == 2 || s == 3;
			case 3: return s == 1;
			case 4: return s >= 1;
			default: return s == 2;
			}
		}
		case Kind::Block:
			return c.probe >= 0 && at(c.probe).a > 0;
		case Kind::Entry:
		{
			// PotP's own EPotP_Status: 2 completed, 3 ignored, 4 missed
			const long long s = at(c.probe).a;
			switch (c.state)
			{
			case 1: return s == 4;
			case 2: return s == 3;
			case 3: return s >= 2 && s <= 4;
			default: return s == 2;
			}
		}
		case Kind::Section:
		{
			const Value s = at(c.probe);
			if (c.probe < 0 || s.b <= 0)
				return false;
			return Compare(c.percent ? s.a * 100 / s.b : s.a, c.op, c.value);
		}
		case Kind::Achievement:
			return c.probe >= 0 && at(c.probe).a > 0;
		case Kind::Vanilla:
			return VanillaUnlocked(c.text);
		default:
			return c.probe >= 0 && Compare(at(c.probe).a, c.op, c.value);
		}
	}

	void Progress(CustomAch& a, const std::vector<Value>& v)
	{
		a.value = -1;
		a.target = 0;
		if (a.progressConditions)
		{
			const Condition& top = a.unlock;
			if (top.kids.empty())
				return;
			a.value = static_cast<int>(std::count_if(top.kids.begin(), top.kids.end(), [&](const Condition& k) { return Met(k, v); }));
			a.target = top.kind == Kind::AtLeast ? top.n : top.kind == Kind::Any ? 1 : static_cast<int>(top.kids.size());
			return;
		}
		if (a.progressOf.empty())
			return;
		const Condition* c = FindRef(a.unlock, a.progressOf);
		if (!c || c->probe < 0 || c->probe >= static_cast<int>(v.size()))
			return;
		const Value got = v[c->probe];
		if (c->kind == Kind::Section && c->percent)
		{
			a.value = static_cast<int>(got.a);
			a.target = static_cast<int>(got.b * c->value / 100);
		}
		else
		{
			a.value = static_cast<int>(got.a);
			a.target = c->value;
		}
	}

	std::string RewardText(const CustomAch& a)
	{
		std::string out;
		for (const Reward& r : a.rewards)
		{
			if (!out.empty())
				out += ", ";
			if (r.kind == 0)
				out += TxFill(r.amount == 1 ? T_custom_crown : T_custom_crowns, std::to_string(r.amount));
			else if (r.kind == 2)
				out += TxFill(T_custom_experience, std::to_string(r.amount));
			else
			{
				const std::string& name = r.display.empty() ? r.item : r.display;
				out += r.amount == 1 ? name : TxFill(T_custom_item, std::to_string(r.amount), name);
			}
		}
		return out;
	}

	std::string Clean(std::string text)
	{
		std::replace(text.begin(), text.end(), '|', '/');
		std::replace(text.begin(), text.end(), '\n', ' ');
		std::replace(text.begin(), text.end(), '\r', ' ');
		return text;
	}

	void Popup(const CustomAch& a)
	{
		std::string body = Clean(a.description.Pick(g_language));
		const std::string reward = RewardText(a);
		if (!reward.empty())
			body += (body.empty() ? "" : "<br/>") + TxFill(T_custom_reward_line, Clean(reward));
		// The herald banner, at the top of the screen
		UiPushPopup("H|achievement|8|" + Clean(a.title.Pick(g_language)) + "|" + body + "|" + Clean(a.icon) + "|" + std::to_string(a.ring));
	}

	// The date goes in a fact, and facts hold 16 bits in the save: days since 1 January 2020 last until 2109.
	// The scripts can't read the clock, so the date goes over with each unlock. The player's own calendar day.
	long long DaysFromCivil(int y, int m, int d)
	{
		y -= m <= 2;
		const long long era = (y >= 0 ? y : y - 399) / 400;
		const long long yoe = y - era * 400;
		const long long doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
		const long long doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
		return era * 146097 + doe - 719468;
	}

	int Today()
	{
		const time_t now = time(nullptr);
		tm local{};
		localtime_s(&local, &now);
		const long long day = DaysFromCivil(local.tm_year + 1900, local.tm_mon + 1, local.tm_mday) - DaysFromCivil(2020, 1, 1);
		return static_cast<int>(std::clamp(day, 0LL, 32765LL));
	}

	// Noon on that day, in the player's time zone, for the tab to show as a date like the game's own
	long long DayToTime(int day)
	{
		tm noon{};
		noon.tm_year = 2020 - 1900;
		noon.tm_mon = 0;
		noon.tm_mday = 1 + day;   // mktime carries the days over into months and years
		noon.tm_hour = 12;
		noon.tm_isdst = -1;
		return static_cast<long long>(mktime(&noon));
	}

	void Publish()
	{
		auto list = std::make_shared<CustomAchievementList>();
		list->packs = static_cast<int>(g_packs.size());
		list->problems = g_problems;
		list->live = g_live;
		// One section for each pack, locked and unlocked together in the file's order
		for (const Pack& pack : g_packs)
		{
			CustomAchievementSection section;
			section.header = pack.title.Pick(g_language);
			for (size_t index : pack.items)
			{
				const CustomAch& c = g_achievements[index];
				Achievement a;
				a.custom = true;
				a.script = "custom:" + c.full;
				a.title = c.title.Pick(g_language);
				a.description = c.description.Pick(g_language);
				a.hidden = c.hidden;
				a.unlocked = c.unlocked;
				a.ring = c.ring;
				a.picture = c.icon;
				a.value = c.value;
				a.target = c.target;
				a.reward = RewardText(c);
				if (c.unlocked)
					a.when = DayToTime(c.day);
				section.items.push_back(std::move(a));
			}
			if (!section.items.empty())
				list->sections.push_back(std::move(section));
		}
		std::lock_guard lock(g_viewMutex);
		g_view = std::move(list);
	}

	std::vector<std::string> Split(const std::string& text, char separator)
	{
		std::vector<std::string> out;
		size_t start = 0;
		for (;;)
		{
			const size_t end = text.find(separator, start);
			out.push_back(text.substr(start, end == std::string::npos ? std::string::npos : end - start));
			if (end == std::string::npos)
				return out;
			start = end + 1;
		}
	}

	void Answer(const std::string& text, const CustomAchievementCalls& calls)
	{
		const ULONGLONG now = GetTickCount64();
		if (text == "N")
		{
			// No save loaded
			if (g_live)
			{
				g_live = false;
				for (CustomAch& a : g_achievements)
					a.asked = false;
				Publish();
			}
			return;
		}
		const std::vector<std::string> f = Split(text, '|');
		// V|generation|probes|language|a value for each probe
		const bool ours = f.size() >= 4 && f[0] == "V" && atoi(f[1].c_str()) == g_generation && atoi(f[2].c_str()) == static_cast<int>(g_probes.size())
			&& f.size() == g_probes.size() + 4;
		if (!ours)
		{
			// The scripts don't have this list: a new session, a recompile, or a list sent before they were ready
			if (g_queue.empty() && now - g_queuedAt > 5000)
			{
				g_queuedAt = now;
				QueueRegistration();
			}
			return;
		}

		std::vector<Value> values(g_probes.size());
		for (size_t i = 0; i < g_probes.size(); ++i)
		{
			const std::string& field = f[i + 4];
			const size_t colon = field.find(':');
			values[i].a = atoll(field.c_str());
			if (colon != std::string::npos)
				values[i].b = atoll(field.c_str() + colon + 1);
		}

		bool changed = !g_live;
		g_live = true;
		if (f[3] != g_language)
		{
			g_language = f[3];
			g_namesAsked = false;
			changed = true;
		}
		if (!g_namesAsked)
		{
			// The reward items' names, in the order potpach_reward told them
			g_namesAsked = true;
			std::string names;
			if (calls.callString("PotPAch_RewardNames", names))
			{
				const std::vector<std::string> list = Split(names, '|');
				size_t next = 0;
				for (CustomAch& a : g_achievements)
					for (Reward& r : a.rewards)
						if (r.kind == 1 && next < list.size())
							r.display = list[next++];
				changed = true;
			}
			// The packs' .w3strings keys, in the game's language
			std::string texts;
			if (calls.callString("PotPAch_Texts", texts))
			{
				const std::vector<std::string> list = Split(texts, '|');
				const std::vector<Localised*> keyed = KeyedTexts();
				for (size_t k = 0; k < keyed.size(); ++k)
					keyed[k]->looked = k < list.size() ? list[k] : std::string();
				changed = true;
			}
		}
		for (size_t i = 0; i < g_achievements.size(); ++i)
		{
			CustomAch& a = g_achievements[i];
			const long long stored = values[a.unlockProbe].a;   // the day it unlocked, plus one
			const bool unlocked = stored > 0;
			if (unlocked != a.unlocked)
				changed = true;
			a.unlocked = unlocked;
			a.day = unlocked ? static_cast<int>(stored - 1) : 0;
			if (unlocked)
			{
				if (a.asked)
				{
					a.asked = false;
					Log("custom achievements: %s unlocked", a.full.c_str());
					Popup(a);
				}
				continue;
			}

			const int value = a.value, target = a.target;
			Progress(a, values);
			if (a.value != value || a.target != target)
				changed = true;
			const bool met = Met(a.unlock, values);

			if (!a.retroactive)
			{
				// Its seen fact: 0 not yet looked at on this save, 1 counting, 2 it was already met when first seen,
				// so it waits for it to stop being met before anything counts
				const long long seen = values[a.seenProbe].a;
				if (seen == 0 || (seen == 2 && !met))
				{
					calls.exec("potpach_seen(" + std::to_string(i) + ", " + (seen == 0 && met ? "2" : "1") + ")");
					continue;
				}
				if (seen == 2)
					continue;
			}

			if (met && (!a.asked || now - a.askedAt > 5000))
			{
				a.asked = true;
				a.askedAt = now;
				calls.exec("potpach_unlock(" + std::to_string(i) + ", " + std::to_string(Today()) + ")");
			}
		}
		if (changed)
			Publish();
	}
}

namespace
{
	// Each pack's folder name and path, in a steady order
	std::vector<std::pair<std::wstring, std::wstring>> FindPacks()
	{
		const std::wstring mods = g_gameFolder + L"\\mods\\";
		WIN32_FIND_DATAW found;
		HANDLE search = FindFirstFileW((mods + L"*").c_str(), &found);
		std::vector<std::pair<std::wstring, std::wstring>> packs;
		if (search != INVALID_HANDLE_VALUE)
		{
			do
			{
				if ((found.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && found.cFileName[0] != L'.')
				{
					const std::wstring path = mods + found.cFileName + L"\\potp_achievements.xml";
					if (GetFileAttributesW(path.c_str()) != INVALID_FILE_ATTRIBUTES)
						packs.emplace_back(found.cFileName, path);
				}
			} while (FindNextFileW(search, &found));
			FindClose(search);
		}
		std::sort(packs.begin(), packs.end(), [](const auto& a, const auto& b) { return _wcsicmp(a.first.c_str(), b.first.c_str()) < 0; });
		return packs;
	}

	// Changes when a pack is added, removed or saved
	std::wstring PacksSignature(const std::vector<std::pair<std::wstring, std::wstring>>& packs)
	{
		std::wstring signature;
		for (const auto& [folder, path] : packs)
		{
			WIN32_FILE_ATTRIBUTE_DATA data{};
			GetFileAttributesExW(path.c_str(), GetFileExInfoStandard, &data);
			signature += path + L"|" + std::to_wstring(data.ftLastWriteTime.dwLowDateTime) + L"." + std::to_wstring(data.ftLastWriteTime.dwHighDateTime)
				+ L"|" + std::to_wstring(data.nFileSizeLow) + L"\n";
		}
		return signature;
	}

	void LoadAll()
	{
		g_packs.clear();
		g_achievements.clear();
		g_probes.clear();
		g_probeIndex.clear();
		g_problems = 0;
		g_queue.clear();
		g_queueAt = 0;
		g_namesAsked = false;

		const auto packs = FindPacks();
		g_packsSeen = PacksSignature(packs);
		for (const auto& [folder, path] : packs)
			ReadPack(path, Utf8(folder.c_str()));

		std::set<std::string> known;
		for (const CustomAch& a : g_achievements)
			known.insert(a.full);
		for (CustomAch& a : g_achievements)
		{
			ResolveAchievementConditions(a.unlock, a, known);
			a.unlockProbe = AddProbe('F', "potp_ach." + a.full);
			if (!a.retroactive)
				a.seenProbe = AddProbe('F', "potp_achseen." + a.full);
		}
		// Different each time, so the scripts can tell this list from an earlier one and get sent it
		g_generation = static_cast<int>(GetTickCount64() % 1000000) + 1;
		Log("custom achievements: %zu packs, %zu achievements, %zu probes, %d problems", g_packs.size(), g_achievements.size(), g_probes.size(), g_problems);
		Publish();
	}
}

void LoadCustomAchievementPacks(const std::wstring& gameFolder)
{
	g_gameFolder = gameFolder;
	LoadAll();
	g_loaded = true;
}

std::string ExecText(const std::string& text)
{
	return Encode(text);
}

void CustomAchievementsTick(const CustomAchievementCalls& calls)
{
	if (!g_loaded)
		return;
	// A pack that's saved, added or removed is read again, so an author sees a change without restarting
	static ULONGLONG nextLook = 0;
	const ULONGLONG lookNow = GetTickCount64();
	if (lookNow >= nextLook)
	{
		nextLook = lookNow + 3000;
		if (PacksSignature(FindPacks()) != g_packsSeen)
		{
			Log("custom achievements: a pack changed, reading them again");
			LoadAll();
		}
	}
	if (g_achievements.empty())
		return;
	// The list goes over a few lines a tick, so a big pack never causes a hitch
	if (g_queueAt < g_queue.size())
	{
		for (int sent = 0; sent < 40 && g_queueAt < g_queue.size(); ++sent)
			calls.exec(g_queue[g_queueAt++]);
		if (g_queueAt >= g_queue.size())
		{
			g_queue.clear();
			g_queueAt = 0;
			g_nextAnswer = 0;
		}
		return;
	}
	const ULONGLONG now = GetTickCount64();
	if (now < g_nextAnswer)
		return;
	g_nextAnswer = now + 1000;
	std::string text;
	if (!calls.callString("PotPAch_Answer", text))
		return;   // no script for it: the scripts are older than this overlay
	Answer(text, calls);
}

std::shared_ptr<const CustomAchievementList> GetCustomAchievements()
{
	std::lock_guard lock(g_viewMutex);
	return g_view;
}
