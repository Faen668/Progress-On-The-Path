// Achievements that mods add, from a potp_achievements.xml in their mod folder. The overlay reads the files and
// decides what's unlocked (customach.cpp). This only does what it can't:
//   - it's told once what to look at: potpach_begin, a potpach_probe for each thing, a potpach_define for each
//     achievement with a potpach_reward for each part of its reward, then potpach_end
//   - PotPAch_Answer: what each probe says now, V|generation|count|language|value|value... (a section answers done:total)
//   - PotPAch_RewardNames: the reward items' names in the game's language, in the order they were told
//   - potpach_text, PotPAch_Texts: the packs' own .w3strings keys, and their text in the game's language
//   - potpach_unlock: sets the achievement's fact to the date, which keeps the unlock in the save, and gives its reward
//   - potpach_seen: for one that only counts from now on, whether it was already met when this save first saw it
// Text comes over with every character but letters and digits as _ and two hex digits: see PotPAch_Decode.

class CPotPAch_Probe
{
	public var kind			: string;   // F fact, B quest block, Q quest, K kills, I item, L level, C crowns, E PotP entry, S PotP section
	public var key			: string;
	public var item			: name;
	public var journal		: CJournalBase;
	public var tries		: int;
	public var section		: array<CPotP_Entry>;
	public var section_from	: CPotP_Catalog;
	public var section_size	: int;
}

class CPotPAch_Reward
{
	public var kind		: int;   // 0 crowns, 1 an item, 2 experience
	public var amount	: int;
	public var item		: name;
}

class CPotPAch_Def
{
	public var fact		: string;
	public var seen		: string;   // empty when it counts what happened before too
	public var rewards	: array<CPotPAch_Reward>;
}

// Quest blocks fire once, so each one that's watched leaves a fact behind: one for the output it fired, one for any
class CPotPAch_Listener extends CNQH_Listener
{
	public function OnBlockFinished(guid : string, output : name)
	{
		var fired : string = NameToString(output);

		if (fired == "")
		{
			fired = "None";
		}
		FactsAdd("potp_achqb." + StrLower(guid) + "." + fired, 1);
		FactsAdd("potp_achqb." + StrLower(guid) + ".*", 1);
	}
}

class CPotPAch_Store
{
	public var generation	: int;
	public var ready		: bool;
	public var probes		: array<CPotPAch_Probe>;
	public var defs			: array<CPotPAch_Def>;
	public var text_keys	: array<string>;
	public var player		: CR4Player;
	public var answers		: int;
}

@addField(CR4Game)
var potp_ach : CPotPAch_Store;

//---------------------------------------------------

// Printable ASCII from the space on, with ? standing in for " and \, which never come over
function PotPAch_Characters() : string
{
	return " !?#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[?]^_`abcdefghijklmnopqrstuvwxyz{|}~";
}

function PotPAch_Hex(digit: string) : int
{
	return StrFindFirst("0123456789ABCDEF", digit);
}

function PotPAch_Decode(text: string) : string
{
	var parts	: array<string> = StrSplit(text, "_");
	var table	: string = PotPAch_Characters();
	var result	: string;
	var code	: int;
	var Idx		: int;

	if (parts.Size() == 0)
	{
		return text;
	}
	result = parts[0];
	for (Idx = 1; Idx < parts.Size(); Idx += 1)
	{
		code = PotPAch_Hex(StrMid(parts[Idx], 0, 1)) * 16 + PotPAch_Hex(StrMid(parts[Idx], 1, 1));
		if (code >= 32 && code <= 126)
		{
			result += StrMid(table, code - 32, 1);
		}
		result += StrMid(parts[Idx], 2);
	}
	return result;
}

//---------------------------------------------------

exec function potpach_begin(generation: int)
{
	var game	: CR4Game = theGame;
	var store	: CPotPAch_Store;

	store = new CPotPAch_Store in theGame;
	store.generation = generation;
	game.potp_ach = store;
}

exec function potpach_probe(kind: string, key: string, item: name)
{
	var store	: CPotPAch_Store = theGame.potp_ach;
	var probe	: CPotPAch_Probe;

	if (!store)
	{
		return;
	}
	probe = new CPotPAch_Probe in store;
	probe.kind = kind;
	probe.key = PotPAch_Decode(key);
	probe.item = item;
	store.probes.PushBack(probe);
}

exec function potpach_define(fact: string, seen: string)
{
	var store	: CPotPAch_Store = theGame.potp_ach;
	var defined	: CPotPAch_Def;

	if (!store)
	{
		return;
	}
	defined = new CPotPAch_Def in store;
	defined.fact = PotPAch_Decode(fact);
	defined.seen = StrReplaceAll(PotPAch_Decode(seen), " ", "");
	store.defs.PushBack(defined);
}

exec function potpach_reward(kind: int, amount: int, item: name)
{
	var store	: CPotPAch_Store = theGame.potp_ach;
	var prize	: CPotPAch_Reward;

	if (!store || store.defs.Size() == 0)
	{
		return;
	}
	prize = new CPotPAch_Reward in store;
	prize.kind = kind;
	prize.amount = amount;
	prize.item = item;
	store.defs[store.defs.Size() - 1].rewards.PushBack(prize);
}

exec function potpach_text(key: string)
{
	var store : CPotPAch_Store = theGame.potp_ach;

	if (store)
	{
		store.text_keys.PushBack(PotPAch_Decode(key));
	}
}

exec function potpach_end(generation: int, probes: int, defs: int, texts: int)
{
	var store : CPotPAch_Store = theGame.potp_ach;

	if (!store)
	{
		return;
	}
	store.ready = store.generation == generation && store.probes.Size() == probes && store.defs.Size() == defs && store.text_keys.Size() == texts;
	store.player = NULL;
	PotP_Log("Custom achievements: " + defs + " achievements and " + probes + " probes, ready " + store.ready, 'Achievements');
}

//---------------------------------------------------

// A new save, or the first answer: the quest blocks to listen for, and nothing kept from the last save
function PotPAch_NewSession(store: CPotPAch_Store)
{
	var listener	: CPotPAch_Listener;
	var Idx			: int;

	listener = new CPotPAch_Listener in store;
	for (Idx = 0; Idx < store.probes.Size(); Idx += 1)
	{
		store.probes[Idx].journal = NULL;
		store.probes[Idx].tries = 0;
		store.probes[Idx].section_from = NULL;
		if (store.probes[Idx].kind == "B")
		{
			listener.watched.PushBack(StrBeforeFirst(store.probes[Idx].key, "."));
		}
	}
	if (listener.watched.Size() > 0)
	{
		NQH_Register('PotPAchievements', listener);
	}
}

// The quest by its journal name, among the ones the journal has started. Looked for again now and then until found.
function PotPAch_FindQuest(probe: CPotPAch_Probe)
{
	var found	: array<CJournalBase>;
	var journal_quest	: CJournalQuest;
	var Idx		: int;

	probe.tries += 1;
	if (probe.tries % 10 != 1)
	{
		return;
	}
	theGame.GetJournalManager().GetActivatedOfType('CJournalQuest', found);
	for (Idx = 0; Idx < found.Size(); Idx += 1)
	{
		journal_quest = (CJournalQuest)found[Idx];
		if (journal_quest && journal_quest.baseName == probe.key)
		{
			probe.journal = found[Idx];
			return;
		}
	}
}

function PotPAch_QuestValue(probe: CPotPAch_Probe) : string
{
	var status : EJournalStatus;

	if (!probe.journal)
	{
		PotPAch_FindQuest(probe);
	}
	if (!probe.journal)
	{
		return "0";
	}
	status = theGame.GetJournalManager().GetEntryStatus(probe.journal);
	switch (status)
	{
	case JS_Active:		return "1";
	case JS_Success:	return "2";
	case JS_Failed:		return "3";
	}
	return "0";
}

function PotPAch_KillsValue(probe: CPotPAch_Probe) : string
{
	var witcher	: W3PlayerWitcher = GetWitcherPlayer();
	var total	: int;
	var Idx		: int;

	if (!witcher)
	{
		return "0";
	}
	for (Idx = 0; Idx < witcher.potp_kill_keys.Size(); Idx += 1)
	{
		if (StrBeforeFirst(witcher.potp_kill_keys[Idx] + "@", "@") == probe.key)
		{
			total += witcher.potp_kill_counts[Idx];
		}
	}
	return IntToString(total);
}

function PotPAch_EntryValue(probe: CPotPAch_Probe) : string
{
	var main	: CPotP_Main = PotP_Get();
	var tracked	: CPotP_Entry;

	if (!main || !main.catalog.is_ready)
	{
		return "-1";
	}
	tracked = main.catalog.FindByUuid(probe.key);
	if (!tracked)
	{
		return "-1";
	}
	return IntToString((int)tracked.status);
}

// Every entry whose uuid starts with the section's prefix, kept until the catalog is rebuilt
function PotPAch_SectionValue(probe: CPotPAch_Probe) : string
{
	var main	: CPotP_Main = PotP_Get();
	var catalog	: CPotP_Catalog;
	var done	: int;
	var Idx		: int;

	if (!main || !main.catalog.is_ready)
	{
		return "0:0";
	}
	catalog = main.catalog;
	if (probe.section_from != catalog || probe.section_size != catalog.entries.Size())
	{
		probe.section.Clear();
		for (Idx = 0; Idx < catalog.entries.Size(); Idx += 1)
		{
			if (StrBeginsWith(catalog.entries[Idx].uuid, probe.key + "_"))
			{
				probe.section.PushBack(catalog.entries[Idx]);
			}
		}
		probe.section_from = catalog;
		probe.section_size = catalog.entries.Size();
	}
	for (Idx = 0; Idx < probe.section.Size(); Idx += 1)
	{
		if (probe.section[Idx].IsDone())
		{
			done += 1;
		}
	}
	return IntToString(done) + ":" + IntToString(probe.section.Size());
}

// How many he has: in his inventory, in the stash, or both. The stash is the horse's inventory, as PotP's own item
// tracking reads it, and what the horse has on counts as in it.
function PotPAch_ItemCount(probe: CPotPAch_Probe) : int
{
	var horse	: W3HorseManager;
	var stashed	: int;
	var carried	: int;

	if (probe.key != "stash")
	{
		carried = thePlayer.GetInventory().GetItemQuantityByName(probe.item);
	}
	if (probe.key != "inventory")
	{
		horse = GetWitcherPlayer().GetHorseManager();
		if (horse)
		{
			stashed = horse.GetInventoryComponent().GetItemQuantityByName(probe.item);
			if (stashed == 0 && horse.IsItemEquippedByName(probe.item))
			{
				stashed = 1;
			}
		}
	}
	return carried + stashed;
}

function PotPAch_ProbeValue(probe: CPotPAch_Probe) : string
{
	switch (probe.kind)
	{
	case "F":	return IntToString(FactsQuerySum(probe.key));
	case "B":	return IntToString(FactsQuerySum("potp_achqb." + probe.key));
	case "Q":	return PotPAch_QuestValue(probe);
	case "K":	return PotPAch_KillsValue(probe);
	case "I":	return IntToString(PotPAch_ItemCount(probe));
	case "L":	return IntToString(thePlayer.GetLevel());
	case "C":	return IntToString(thePlayer.GetMoney());
	case "E":	return PotPAch_EntryValue(probe);
	case "S":	return PotPAch_SectionValue(probe);
	}
	return "0";
}

// N: no save loaded. U: this list isn't here, so the overlay sends it.
function PotPAch_Answer() : string
{
	var store		: CPotPAch_Store = theGame.potp_ach;
	var audio		: string;
	var subtitles	: string;
	var result		: string;
	var Idx		: int;

	if (!thePlayer || !GetWitcherPlayer())
	{
		return "N";
	}
	if (!store || !store.ready)
	{
		return "U";
	}
	if (store.player != thePlayer)
	{
		store.player = thePlayer;
		PotPAch_NewSession(store);
	}
	store.answers += 1;
	theGame.GetGameLanguageName(audio, subtitles);
	result = "V|" + IntToString(store.generation) + "|" + IntToString(store.probes.Size()) + "|" + StrLower(subtitles);
	for (Idx = 0; Idx < store.probes.Size(); Idx += 1)
	{
		result += "|" + PotPAch_ProbeValue(store.probes[Idx]);
	}
	return result;
}

// The packs' keys in the mod's own .w3strings, in the game's language, separated by bars. Empty for one no .w3strings has.
function PotPAch_Texts() : string
{
	var store	: CPotPAch_Store = theGame.potp_ach;
	var result	: string;
	var text	: string;
	var Idx		: int;

	if (!store || !store.ready)
	{
		return "";
	}
	for (Idx = 0; Idx < store.text_keys.Size(); Idx += 1)
	{
		text = GetLocStringByKeyExt(store.text_keys[Idx]);
		if (StrStartsWith(text, "#"))
		{
			text = "";
		}
		if (Idx > 0)
		{
			result += "|";
		}
		result += StrReplaceAll(text, "|", "/");
	}
	return result;
}

// Each reward item's name as the game shows it, separated by bars
function PotPAch_RewardNames() : string
{
	var store		: CPotPAch_Store = theGame.potp_ach;
	var definitions	: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var result		: string;
	var shown		: string;
	var count		: int;
	var Idx			: int;
	var Other		: int;

	if (!store || !store.ready)
	{
		return "";
	}
	for (Idx = 0; Idx < store.defs.Size(); Idx += 1)
	{
		for (Other = 0; Other < store.defs[Idx].rewards.Size(); Other += 1)
		{
			if (store.defs[Idx].rewards[Other].kind != 1)
			{
				continue;
			}
			shown = GetLocStringByKeyExt(definitions.GetItemLocalisationKeyName(store.defs[Idx].rewards[Other].item));
			if (shown == "" || StrStartsWith(shown, "#"))
			{
				shown = NameToString(store.defs[Idx].rewards[Other].item);
			}
			if (count > 0)
			{
				result += "|";
			}
			count += 1;
			result += StrReplaceAll(shown, "|", "/");
		}
	}
	return result;
}

//---------------------------------------------------

function PotPAch_Give(prize: CPotPAch_Reward)
{
	var witcher : W3PlayerWitcher = GetWitcherPlayer();

	switch (prize.kind)
	{
	case 0:
		witcher.AddMoney(prize.amount);
		break;
	case 1:
		if (theGame.GetDefinitionsManager().GetItemCategory(prize.item) == '')
		{
			PotP_Log("Custom achievements: the game has no item called " + prize.item + ", so it isn't given", 'Achievements');
			return;
		}
		witcher.GetInventory().AddAnItem(prize.item, prize.amount);
		// PotP's own reward swords come in at Geralt's level, not the one below that the game builds them at
		PotP_ScaleRewardSwords();
		break;
	case 2:
		witcher.AddPoints(EExperiencePoint, prize.amount, true);
		break;
	}
}

// day: the date, days since 1 January 2020, from the overlay, as the scripts can't read the clock
exec function potpach_unlock(index: int, day: int)
{
	var store	: CPotPAch_Store = theGame.potp_ach;
	var defined	: CPotPAch_Def;
	var Idx		: int;

	if (!store || !store.ready || index < 0 || index >= store.defs.Size() || !GetWitcherPlayer())
	{
		return;
	}
	defined = store.defs[index];
	if (FactsDoesExist(defined.fact))
	{
		return;
	}
	// Facts hold 16 bits in the save: PotP_FactSetStored adds one
	PotP_FactSetStored(defined.fact, Clamp(day, 0, 32765));
	for (Idx = 0; Idx < defined.rewards.Size(); Idx += 1)
	{
		PotPAch_Give(defined.rewards[Idx]);
	}
	PotP_Log("Custom achievements: unlocked " + defined.fact + " on day " + day + ", " + defined.rewards.Size() + " rewards given", 'Achievements');
}

exec function potpach_seen(index: int, value: int)
{
	var store : CPotPAch_Store = theGame.potp_ach;

	if (!store || !store.ready || index < 0 || index >= store.defs.Size() || store.defs[index].seen == "")
	{
		return;
	}
	FactsSet(store.defs[index].seen, value);
}
