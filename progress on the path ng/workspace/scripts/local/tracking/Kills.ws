//---------------------------------------------------
//-- Kills ------------------------------------------
//---------------------------------------------------
// What the player has killed, by name: Geralt, and Ciri in her parts. It lives in the save, so loading an older save takes the counts back with it.
// It isn't part of the mod's totals.

@addField(W3PlayerWitcher)
saved var potp_kill_keys : array<string>;   // a name's string id, or =its text when the game's files don't know it

@addField(W3PlayerWitcher)
saved var potp_kill_counts : array<int>;

@addField(W3PlayerWitcher)
saved var potp_kill_meta : array<int>;      // see PotP_KillMeta

@addField(W3PlayerWitcher)
saved var potp_kill_hows : array<string>;   // an item's name key, or #what the last blow was

@addField(W3PlayerWitcher)
saved var potp_kill_whys : array<int>;      // why it's on the Unique page: a contract's title id, or one of the below

// Ciri's kills wait here while she's the player, since Geralt's lists are out of reach, and join his when he's back
@addField(CR4Game)
saved var potp_ciri_kill_keys : array<string>;

@addField(CR4Game)
saved var potp_ciri_kill_counts : array<int>;

@addField(CR4Game)
saved var potp_ciri_kill_meta : array<int>;

@addField(CR4Game)
saved var potp_ciri_kill_hows : array<string>;

@addField(CR4Game)
saved var potp_ciri_kill_whys : array<int>;

@addField(CNewNPC)
var potp_kill_counted : bool;

@addField(CR4Game)
var potp_kill_ids : array<int>;

@addField(CR4Game)
var potp_kill_texts : array<string>;

//---------------------------------------------------

@wrapMethod(CNewNPC) function OnDeath(damageAction: W3DamageAction)
{
	PotP_RecordKill(this, damageAction);
	PotP_CheckEventKills(this);
	wrappedMethod(damageAction);
}

//---------------------------------------------------

function PotP_KillWhyNone() : int		{ return 0; }
function PotP_KillWhyBoss() : int		{ return -1; }
function PotP_KillWhyContract() : int	{ return -2; }
function PotP_KillWhyNamed() : int		{ return -3; }

// Which lines to choose from: 0 monsters, 1 people, 2 someone with a name, 3 "the" something, a contract's target.
// random: which line of those. The overlay has the lines, so a save moved to another language tells it in that language.
function PotP_KillMeta(pool: int, category: int, region_value: int, random: int) : int
{
	return pool + category * 10 + region_value * 1000 + random * 100000;
}

//---------------------------------------------------

function PotP_KillAbs(value: int) : int
{
	if (value < 0)
	{
		return -value;
	}
	return value;
}

// The list of names, as text in the game's language: looked through when something dies, which isn't often
function PotP_KillNamesReady()
{
	var game : CR4Game = theGame;
	var ids : array<int>;
	var Idx : int;

	if (game.potp_kill_ids.Size() > 0)
	{
		return;
	}
	PotP_KillNameIds(ids);
	game.potp_kill_ids = ids;
	game.potp_kill_texts.Resize(ids.Size());
	for (Idx = 0; Idx < ids.Size(); Idx += 1)
	{
		game.potp_kill_texts[Idx] = GetLocStringById(PotP_KillAbs(ids[Idx]));
	}
}

function PotP_KillRegion() : int
{
	var manager : CCommonMapManager = theGame.GetCommonMapManager();
	var area : name = manager.GetCurrentJournalAreaByPosition(thePlayer.GetWorldPosition());

	switch (area)
	{
	case 'AN_Prologue_Village':
		return PotP_R_WO;
	case 'AN_Velen':
		return PotP_R_VE;
	case 'AN_NMLandNovigrad':
		return PotP_R_NO;
	case 'AN_Skellige_ArdSkellig':
		return PotP_R_SK;
	case 'AN_Bob':
	case 'AN_Dlc_Bob':
		return PotP_R_TO;
	case 'AN_Kaer_Morhen':
		return PotP_R_KM;
	case 'AN_Wyzima':
		return PotP_R_VI;
	case 'AN_Spiral':
		return PotP_R_TS;
	}
	return PotP_R_NA;
}

// What landed the last blow
function PotP_KillHow(action: W3DamageAction, charmed: bool) : string
{
	var attack	: W3Action_Attack;
	var effect	: CBaseGameplayEffect;
	var petard	: W3Petard;
	var bolt	: W3ArrowProjectile;
	var inv		: CInventoryComponent;
	var item	: SItemUniqueId;
	var skill	: ESkill;

	if (charmed)
	{
		return "#charmed";
	}
	inv = thePlayer.GetInventory();

	effect = (CBaseGameplayEffect)action.causer;
	if (effect)
	{
		switch (effect.GetEffectType())
		{
		case EET_Burning:
			return "#burning";
		case EET_Bleeding:
		case EET_Bleeding1:
		case EET_Bleeding2:
		case EET_Bleeding3:
		case EET_BleedingTracking:
			return "#bleeding";
		case EET_Poison:
		case EET_PoisonCritical:
			return "#poison";
		}
		return "";
	}

	petard = (W3Petard)action.causer;
	if (petard)
	{
		return inv.GetItemLocalizedNameByName(petard.PotP_ItemName());
	}

	bolt = (W3ArrowProjectile)action.causer;
	if (bolt)
	{
		if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, item))
		{
			return inv.GetItemLocalizedNameByUniqueID(item);
		}
		return "#crossbow";
	}

	skill = action.GetSignSkill();
	if (skill != S_SUndefined)
	{
		switch (action.GetSignType())
		{
		case ST_Aard:
			return "#aard";
		case ST_Yrden:
			return "#yrden";
		case ST_Igni:
			return "#igni";
		case ST_Quen:
			return "#quen";
		case ST_Axii:
			return "#axii";
		}
	}

	attack = (W3Action_Attack)action;
	if (attack)
	{
		item = attack.GetWeaponId();
		if (inv.IsIdValid(item))
		{
			if (inv.IsItemFists(item))
			{
				return "#fists";
			}
			return inv.GetItemLocalizedNameByUniqueID(item);
		}
	}

	// A finisher, a counter or any other blow the game deals itself names no weapon: the sword in his hand did it
	item = inv.GetCurrentlyHeldSword();
	if (inv.IsIdValid(item))
	{
		return inv.GetItemLocalizedNameByUniqueID(item);
	}
	return "#fists";
}

@addMethod(W3Petard) function PotP_ItemName() : name
{
	return GetOwner().GetInventory().GetItemName(itemId);
}

//---------------------------------------------------

function PotP_RecordKill(npc: CNewNPC, action: W3DamageAction)
{
	var witcher		: W3PlayerWitcher = GetWitcherPlayer();
	var ciri		: W3ReplacerCiri;
	var killer		: CActor;
	var tracked	: CJournalQuest;
	var category	: EMonsterCategory;
	var sound_name	: name;
	var unused		: bool;
	var charmed		: bool;
	var text		: string;
	var key			: string;
	var meta		: int;
	var why			: int;
	var pool		: int;
	var id			: int;
	var Idx			: int;

	ciri = (W3ReplacerCiri)thePlayer;
	if ((!witcher && !ciri) || npc.potp_kill_counted || !action)
	{
		return;
	}
	killer = (CActor)action.attacker;
	charmed = killer && killer != thePlayer && killer.HasBuff(EET_AxiiGuardMe);
	if (killer != thePlayer && !charmed)
	{
		return;
	}
	// A fist fight's loser only sleeps, and the game keeps some deaths out of its own counts too
	if (npc.IsKnockedUnconscious() || thePlayer.IsInFistFightMiniGame() || npc.IsHorse() || npc.HasTag('AchievementKillDontCount'))
	{
		return;
	}
	npc.potp_kill_counted = true;

	theGame.GetMonsterParamsForActor(npc, category, sound_name, unused, unused, unused);
	text = npc.GetDisplayName(false);

	PotP_KillNamesReady();
	for (Idx = 0; Idx < theGame.potp_kill_texts.Size(); Idx += 1)
	{
		if (theGame.potp_kill_texts[Idx] == text)
		{
			id = theGame.potp_kill_ids[Idx];
			break;
		}
	}
	if (id != 0)
	{
		key = IntToString(PotP_KillAbs(id));
	}
	else if (StrLen(text) > 0)
	{
		key = "=" + text;
	}
	else
	{
		key = "?" + IntToString((int)category);   // no name at all: the overlay says what kind of thing it was
	}

	if (npc.HasTag('MonsterHuntTarget') || (W3MonsterHuntNPC)npc)
	{
		why = PotP_KillWhyContract();
		tracked = theGame.GetJournalManager().GetTrackedQuest();
		if (tracked && tracked.GetType() == MonsterHunt)
		{
			why = tracked.GetTitleStringId();
			key += "@" + IntToString(why);
		}
		else
		{
			key += "@";
		}
		pool = 3;
	}
	else if (npc.GetCharacterStats().HasAbilityWithTag('Boss'))
	{
		why = PotP_KillWhyBoss();
		pool = 2;
	}
	else if (id < 0)
	{
		why = PotP_KillWhyNamed();
		pool = 2;
	}
	else
	{
		why = PotP_KillWhyNone();
		pool = 0;
		if (category == MC_Human)
		{
			pool = 1;
		}
	}

	meta = PotP_KillMeta(pool, (int)category, PotP_KillRegion(), RandRange(1000));

	if (witcher)
	{
		witcher.PotP_AddKill(key, 1, meta, PotP_KillHow(action, charmed), why);
	}
	else
	{
		theGame.PotP_AddCiriKill(key, 1, meta, PotP_KillHow(action, charmed), why);
	}
}

@addMethod(W3PlayerWitcher) function PotP_AddKill(key: string, count: int, meta: int, how: string, why: int)
{
	var Idx : int = potp_kill_keys.FindFirst(key);

	if (Idx < 0)
	{
		potp_kill_keys.PushBack(key);
		potp_kill_counts.PushBack(count);
		potp_kill_meta.PushBack(meta);
		potp_kill_hows.PushBack(how);
		potp_kill_whys.PushBack(why);
	}
	else
	{
		potp_kill_counts[Idx] += count;
		potp_kill_meta[Idx] = meta;
		potp_kill_hows[Idx] = how;
	}
}

@addMethod(CR4Game) function PotP_AddCiriKill(key: string, count: int, meta: int, how: string, why: int)
{
	var Idx : int = potp_ciri_kill_keys.FindFirst(key);

	if (Idx < 0)
	{
		potp_ciri_kill_keys.PushBack(key);
		potp_ciri_kill_counts.PushBack(count);
		potp_ciri_kill_meta.PushBack(meta);
		potp_ciri_kill_hows.PushBack(how);
		potp_ciri_kill_whys.PushBack(why);
	}
	else
	{
		potp_ciri_kill_counts[Idx] += count;
		potp_ciri_kill_meta[Idx] = meta;
		potp_ciri_kill_hows[Idx] = how;
	}
}

//---------------------------------------------------

// When Geralt is the player: Ciri's kills join his, and the unique foes the save says are dead, from before PotP
// counted kills, are added once each
function PotP_KillsSettle()
{
	var witcher		: W3PlayerWitcher = GetWitcherPlayer();
	var game		: CR4Game = theGame;
	var ids			: array<int>;
	var regions		: array<int>;
	var contracts	: array<bool>;
	var facts		: array<string>;
	var unless		: array<string>;
	var row_facts	: array<string>;
	var key			: string;
	var why			: int;
	var dead		: bool;
	var Idx			: int;
	var Jdx			: int;

	if (!witcher)
	{
		return;
	}

	for (Idx = 0; Idx < game.potp_ciri_kill_keys.Size(); Idx += 1)
	{
		witcher.PotP_AddKill(game.potp_ciri_kill_keys[Idx], game.potp_ciri_kill_counts[Idx], game.potp_ciri_kill_meta[Idx],
			game.potp_ciri_kill_hows[Idx], game.potp_ciri_kill_whys[Idx]);
	}
	game.potp_ciri_kill_keys.Clear();
	game.potp_ciri_kill_counts.Clear();
	game.potp_ciri_kill_meta.Clear();
	game.potp_ciri_kill_hows.Clear();
	game.potp_ciri_kill_whys.Clear();

	PotP_KillBackfill(ids, regions, contracts, facts, unless);
	for (Idx = 0; Idx < ids.Size(); Idx += 1)
	{
		key = IntToString(ids[Idx]);
		if (PotP_KillKeyKnown(witcher, key))
		{
			continue;
		}
		if (StrLen(unless[Idx]) > 0 && FactsQuerySum(unless[Idx]) > 0)
		{
			continue;
		}
		row_facts = StrSplit(facts[Idx], ",");
		dead = false;
		for (Jdx = 0; Jdx < row_facts.Size(); Jdx += 1)
		{
			if (FactsQuerySum(row_facts[Jdx]) > 0)
			{
				dead = true;
				break;
			}
		}
		if (!dead)
		{
			continue;
		}

		if (contracts[Idx])
		{
			key += "@";
			why = PotP_KillWhyContract();
			witcher.PotP_AddKill(key, 1, PotP_KillMeta(3, 0, regions[Idx], RandRange(1000)), "", why);
		}
		else
		{
			why = PotP_KillWhyNamed();
			witcher.PotP_AddKill(key, 1, PotP_KillMeta(2, 0, regions[Idx], RandRange(1000)), "", why);
		}
		PotP_Log("Kill backfilled from the save: " + GetLocStringById(ids[Idx]), 'PotP Kills');
	}
}

// Already counted, as itself or as any contract's target
function PotP_KillKeyKnown(witcher: W3PlayerWitcher, key: string) : bool
{
	var Idx : int;

	for (Idx = 0; Idx < witcher.potp_kill_keys.Size(); Idx += 1)
	{
		if (witcher.potp_kill_keys[Idx] == key || StrBeginsWith(witcher.potp_kill_keys[Idx], key + "@"))
		{
			return true;
		}
	}
	return false;
}

//---------------------------------------------------

// For the overlay, one line for each name:
//   K|pool|category|region|random|count|why|contract title|name|how
function PotPOverlay_Kills() : string
{
	var witcher	: W3PlayerWitcher = GetWitcherPlayer();
	var result	: string = "K0";
	var key		: string;
	var name_text : string;
	var how		: string;
	var meta	: int;
	var why		: int;
	var title	: string;
	var Idx		: int;

	if (!witcher)
	{
		return "";   // Ciri's turn, or no save: the overlay keeps what it last read
	}
	for (Idx = 0; Idx < witcher.potp_kill_keys.Size(); Idx += 1)
	{
		key = witcher.potp_kill_keys[Idx];
		if (StrFindFirst(key, "@") >= 0)
		{
			key = StrBeforeFirst(key, "@");
		}
		if (StrBeginsWith(key, "="))
		{
			name_text = StrAfterFirst(key, "=");
		}
		else if (StrBeginsWith(key, "?"))
		{
			name_text = key;
		}
		else
		{
			name_text = GetLocStringById(StringToInt(key));
		}

		how = witcher.potp_kill_hows[Idx];
		if (StrLen(how) > 0 && !StrBeginsWith(how, "#"))
		{
			how = GetLocStringByKeyExt(how);
		}

		why = witcher.potp_kill_whys[Idx];
		title = "";
		if (why > 0)
		{
			title = GetLocStringById(why);
		}

		meta = witcher.potp_kill_meta[Idx];
		result += "\nK|" + IntToString(meta % 10)
			+ "|" + IntToString(meta / 10 % 100)
			+ "|" + IntToString(meta / 1000 % 100)
			+ "|" + IntToString(meta / 100000)
			+ "|" + IntToString(witcher.potp_kill_counts[Idx])
			+ "|" + IntToString(why)
			+ "|" + PotPOverlay_Clean(title)
			+ "|" + PotPOverlay_Clean(name_text)
			+ "|" + PotPOverlay_Clean(how);
	}
	return result;
}
