// What PotpOverlay.asi reads to fill PotP's window. It asks for the catalog a piece at a time, one section
// per game tick, so opening the window never causes a hitch. Lines are separated by a backslash and an n, fields by a bar:
//   N|message                          nothing to show yet
//   H|version|done|total               the whole path
//   R|index|name                       a region's name, in the game's language
//   T|key|text                         the overlay's own text, in the game's language (see PotPOverlayText.ws)
//   S|book|kind|state|header|cutoff    a section (state: 0 nothing, 1 cutoff approaching, 2 cutoff passed; cutoff: the quest that closes it)
//   E|uuid|status|region|filter|flags|title|tip|manual|gamedone   an entry (flags: 1 missable, 2 mod-added, 4 and 8 the DLC; manual: 0 tracked automatically, 1 ignored, 2 completed, 3 missed; gamedone: the game itself counts it as done)
//     then, for an item, six empty fields and its template; for a Gwent card: |picture|power|faction|type|description|effects   (picture as the game's menus load it; power -1: a leader; effects separated by commas)
//     or, for a bestiary entry: |||||text|||image|weaknesses   (paragraphs of text separated by ^^; weaknesses separated by semicolons, each name~icon)
//   G|group|title|intro|presethint     a page of PotP's settings, as Settings.ws defines it
//   P|name                             a preset of that page
//   B|                                 a gap between settings
//   V|id|type|name|value|hint          a setting (type as Settings.ws gives it: TOGGLE, OPTIONS, SLIDER;min;max;steps)
//   O|name                             an option of that setting

@addField(CR4Player)
var potp_overlay_cursor : int;

function PotPOverlay_Clean(text: string) : string
{
	return StrReplace(text, "|", "/");
}

function PotPOverlay_Main() : CPotP_Main
{
	var main : CPotP_Main;

	if (!thePlayer)
	{
		return NULL;
	}
	main = PotP_Get();
	if (!main || !main.catalog.is_ready)
	{
		return NULL;
	}
	return main;
}

function PotPOverlay_ExportBegin() : string
{
	var player	: CR4Player;
	var main	: CPotP_Main;
	var result	: string;
	var total	: int;
	var done	: int;
	var Idx		: int;

	if (!thePlayer)
	{
		return "N|" + PotPOverlay_Clean(GetLocStringByKeyExt("potp_overlay_load_a_save"));
	}
	main = PotP_Get();
	if (!main)
	{
		return "N|" + PotPOverlay_Clean(GetLocStringByKeyExt("potp_overlay_not_started"));
	}
	if (!main.catalog.is_ready)
	{
		return "N|" + PotPOverlay_Clean(GetLocStringByKeyExt("potp_overlay_building"));
	}

	player = thePlayer;
	player.potp_overlay_cursor = 0;
	main.tracker.CheckBestiary();
	main.catalog.CountProgress(total, done);
	result = "H|" + main.version_text + "|" + IntToString(done) + "|" + IntToString(total);
	for (Idx = 1; Idx <= 8; Idx += 1)
	{
		result += "\nR|" + IntToString(Idx) + "|" + PotPOverlay_Clean(GetLocStringByKeyExt("potp_ov_area_" + IntToString(Idx)));
	}
	// What a Gwent card with no known place is: won at random
	result += "\nR|0|" + PotPOverlay_Clean(GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_RA"));
	return result + PotPOverlay_ExportGear() + PotPOverlay_ExportDyes() + PotPOverlay_ExportText() + PotPOverlay_ExportSettings();
}

// What Geralt has on, for the wardrobe to dress him in: each piece's template, a path, so with its backslashes turned.
function PotPOverlay_GearTemplate(item_name: name) : string
{
	if (item_name == '')
	{
		return "";
	}
	return "|" + PotPOverlay_Clean(StrReplaceAll(theGame.GetDefinitionsManager().GetItemEquipTemplate(item_name), StrChar(92), "/"));
}

function PotPOverlay_GearOnSlot(witcher: W3PlayerWitcher, slot: EEquipmentSlots) : string
{
	var item : SItemUniqueId;

	if (witcher.GetItemEquippedOnSlot(slot, item))
	{
		return PotPOverlay_GearTemplate(witcher.GetInventory().GetItemName(item)) + PotPOverlay_GearDye(witcher, item);
	}
	return "";
}

// A dyed piece's template says which dye: the piece's appearances are named after them
function PotPOverlay_GearDye(witcher: W3PlayerWitcher, item: SItemUniqueId) : string
{
	var dye : name = witcher.GetInventory().GetItemColor(item);

	if (!IsNameValid(dye) || dye == 'None')
	{
		return "";
	}
	return "#" + NameToString(dye);
}

// Every piece of armour there is, for the wardrobe, which can show more than the mod tracks:
// WARD, then A|kind|template|title. Many share a model, which the overlay sorts out.
function PotPOverlay_WardrobeItems() : string
{
	var dm			: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var items		: array<name>;
	var result		: string = "WARD";
	var title		: string;
	var category	: name;
	var Idx			: int;

	items = dm.GetItemsWithTag('Armor');
	for (Idx = 0; Idx < items.Size(); Idx += 1)
	{
		if (dm.ItemHasTag(items[Idx], 'NoShow'))
		{
			continue;
		}
		category = dm.GetItemCategory(items[Idx]);
		if (category != 'armor' && category != 'pants' && category != 'boots' && category != 'gloves')
		{
			continue;
		}
		title = GetLocStringByKeyExt(dm.GetItemLocalisationKeyName(items[Idx]));
		if (StrLen(title) == 0 || StrBeginsWith(title, "#"))
		{
			continue;
		}
		result += "\nA|" + NameToString(category) + PotPOverlay_GearTemplate(items[Idx]) + "|" + PotPOverlay_Clean(title);
	}
	return result;
}

// The dyes' names, in the game's language
function PotPOverlay_ExportDyes() : string
{
	var dyes	: array<string>;
	var result	: string;
	var Idx		: int;

	dyes.PushBack("dye_black");
	dyes.PushBack("dye_blue");
	dyes.PushBack("dye_brown");
	dyes.PushBack("dye_gray");
	dyes.PushBack("dye_green");
	dyes.PushBack("dye_orange");
	dyes.PushBack("dye_pink");
	dyes.PushBack("dye_purple");
	dyes.PushBack("dye_red");
	dyes.PushBack("dye_turquoise");
	dyes.PushBack("dye_white");
	dyes.PushBack("dye_yellow");
	for (Idx = 0; Idx < dyes.Size(); Idx += 1)
	{
		result += "\nY|" + dyes[Idx] + "|" + PotPOverlay_Clean(GetLocStringByKeyExt("item_name_" + dyes[Idx]));
	}
	return result;
}

function PotPOverlay_ExportGear() : string
{
	var witcher	: W3PlayerWitcher = GetWitcherPlayer();
	var hair	: array<SItemUniqueId>;
	var result	: string;
	var Idx		: int;

	if (!witcher)
	{
		return "";
	}
	result = "\nW" + PotPOverlay_GearOnSlot(witcher, EES_Armor) + PotPOverlay_GearOnSlot(witcher, EES_Pants)
		+ PotPOverlay_GearOnSlot(witcher, EES_Boots) + PotPOverlay_GearOnSlot(witcher, EES_Gloves)
		+ PotPOverlay_GearOnSlot(witcher, EES_SteelSword) + PotPOverlay_GearOnSlot(witcher, EES_SilverSword)
		+ PotPOverlay_GearOnSlot(witcher, EES_RangedWeapon);
	hair = witcher.GetInventory().GetItemsByCategory('hair');
	for (Idx = 0; Idx < hair.Size(); Idx += 1)
	{
		if (witcher.GetInventory().IsItemMounted(hair[Idx]))
		{
			result += PotPOverlay_GearTemplate(witcher.GetInventory().GetItemName(hair[Idx]));
			break;
		}
	}
	return result;
}

// The card as the game's own menus draw it (gwintBaseMenu.ws, CardSlot.as): its picture, or the DLC's alternative
// art if that's switched on. The menu treats a leader as having no type, and gives a neutral card the banner of the deck in use.
function PotPOverlay_ItemFields(tracked: CPotP_Entry) : string
{
	if (tracked.category != PotP_A_Items || tracked.item_name == '')
	{
		return "";
	}
	// A path, whose backslashes could read as the \n between lines (a folder starting with n)
	return "|||||||" + PotPOverlay_Clean(StrReplaceAll(theGame.GetDefinitionsManager().GetItemEquipTemplate(tracked.item_name), StrChar(92), "/"));
}

// The paragraphs the game's bestiary shows (CR4GlossaryBestiaryMenu.GetDescription): those the journal has reached, in
// order. One not discovered yet has all of its own, for when they're asked to be shown.
function PotPOverlay_CreatureText(creature: CJournalCreature, tracked: CPotP_Entry) : string
{
	var journal		: CWitcherJournalManager = theGame.GetJournalManager();
	var group		: CJournalCreatureDescriptionGroup;
	var line		: CJournalCreatureDescriptionEntry;
	var lines		: array<CJournalCreatureDescriptionEntry>;
	var result		: string;
	var Idx, Jdx	: int;

	if (creature)
	{
		for (Idx = 0; Idx < creature.GetNumChildren() && !group; Idx += 1)
		{
			group = (CJournalCreatureDescriptionGroup)creature.GetChild(Idx);
		}
	}
	if (group)
	{
		for (Idx = 0; Idx < group.GetNumChildren(); Idx += 1)
		{
			line = (CJournalCreatureDescriptionEntry)group.GetChild(Idx);
			if (line && journal.GetEntryStatus(line) == JS_Active)
			{
				Jdx = lines.Size();
				while (Jdx > 0 && lines[Jdx - 1].GetOrder() > line.GetOrder())
				{
					Jdx -= 1;
				}
				lines.Insert(Jdx, line);
			}
		}
	}
	for (Idx = 0; Idx < lines.Size(); Idx += 1)
	{
		result += GetLocStringById(lines[Idx].GetDescriptionStringId()) + "^^";
	}
	if (result == "")
	{
		for (Idx = 0; Idx < tracked.creature_texts.Size(); Idx += 1)
		{
			result += GetLocStringById(tracked.creature_texts[Idx]) + "^^";
		}
	}
	return PotPOverlay_Clean(result);
}

function PotPOverlay_CreatureWeaknesses(tracked: CPotP_Entry) : string
{
	var definitions	: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var item		: name;
	var title		: string;
	var icon		: string;
	var result		: string;
	var Idx			: int;

	for (Idx = 0; Idx < tracked.creature_items.Size(); Idx += 1)
	{
		item = tracked.creature_items[Idx];
		switch (item)
		{
		// The pictures the game's own bestiary shows (CR4GlossaryBestiaryMenu.TryGetSignData)
		case 'Aard':	title = "Aard";		icon = "hud/radialmenu/mcAard.png"; break;
		case 'Igni':	title = "Igni";		icon = "hud/radialmenu/mcIgni.png"; break;
		case 'Yrden':	title = "Yrden";	icon = "hud/radialmenu/mcYrden.png"; break;
		case 'Quen':	title = "Quen";		icon = "hud/radialmenu/mcQuen.png"; break;
		case 'Axii':	title = "Axii";		icon = "hud/radialmenu/mcAxii.png"; break;
		default:
			title = definitions.GetItemLocalisationKeyName(item);
			icon = definitions.GetItemIconPath(item);
			break;
		}
		// The journal also names a leftover item the game no longer has
		if (title == "")
		{
			continue;
		}
		if (result != "")
		{
			result += ";";
		}
		result += PotPOverlay_Clean(StrReplaceAll(GetLocStringByKeyExt(title), ";", ",")) + "~" + StrReplaceAll(icon, StrChar(92), "/");
	}
	return result;
}

function PotPOverlay_CreatureFields(main: CPotP_Main, tracked: CPotP_Entry) : string
{
	var creature	: CJournalCreature;
	var image		: string;

	if (tracked.category != PotP_A_Bestiary)
	{
		return "";
	}
	creature = main.tracker.resolver.KnownCreatureOf(tracked);
	image = tracked.creature_image;
	if (creature)
	{
		// Some change their picture as a quest goes on
		image = thePlayer.ProcessGlossaryImageOverride(creature.GetImage(), creature.GetUniqueScriptTag());
	}
	return "|||||" + PotPOverlay_CreatureText(creature, tracked) + "|||" + PotPOverlay_Clean(image) + "|" + PotPOverlay_CreatureWeaknesses(tracked) + "|" + PotPOverlay_Clean(tracked.creature_template);
}

function PotPOverlay_CardFields(gwent: CR4GwintManager, tracked: CPotP_Entry) : string
{
	var card	: SCardDefinition;
	var picture	: string;
	var power	: int;
	var type_flags	: int;
	var faction		: int;
	var effects	: string;
	var Idx		: int;

	if (tracked.category != PotP_A_Gwent || tracked.card_names.Size() == 0 || !gwent.GetGwentCard(tracked.card_names[0], card))
	{
		return "";
	}
	picture = card.picture;
	if (IsNameValid(card.dlcPictureFlag) && theGame.GetDLCManager().IsDLCAvailable('dlc_008_001') && theGame.GetInGameConfigWrapper().GetVarValue('DLC', 'dlc_008_001') == "true")
	{
		picture = card.dlcPicture;
	}
	power = card.power;
	type_flags = card.typeFlags;
	faction = (int)card.faction;
	if (card.faction == GwintFaction_Neutral)
	{
		faction = (int)gwent.GetSelectedPlayerDeck();
	}
	if (gwent.IsKingCard(card))
	{
		power = -1;
		type_flags = 0;
	}
	for (Idx = 0; Idx < card.effectFlags.Size(); Idx += 1)
	{
		if (Idx > 0)
		{
			effects += ",";
		}
		effects += IntToString((int)card.effectFlags[Idx]);
	}
	return "|" + PotPOverlay_Clean(picture) + "|" + IntToString(power) + "|" + IntToString(faction) + "|" + IntToString(type_flags) + "|" + PotPOverlay_Clean(GetLocStringByKeyExt(card.description)) + "|" + effects;
}

function PotPOverlay_Hint(key: string) : string
{
	if (key == "")
	{
		return "";
	}
	return PotPOverlay_Clean(GetLocStringByKeyExt(key));
}

// The mod's settings, from their definitions in Settings.ws, for the overlay's Settings page
function PotPOverlay_ExportSettings() : string
{
	var store	: CPotP_Settings = PotP_Settings();
	var group	: CPotP_SettingGroup;
	var setting	: CPotP_Setting;
	var result	: string;
	var Idx		: int;
	var Var		: int;
	var Sub		: int;

	for (Idx = 0; Idx < store.groups.Size(); Idx += 1)
	{
		group = store.groups[Idx];
		result += "\nG|" + NameToString(group.id) + "|" + PotPOverlay_Clean(GetLocStringByKeyExt(group.label)) + "|" + PotPOverlay_Hint(group.intro) + "|" + PotPOverlay_Hint(group.preset_hint);
		for (Sub = 0; Sub < group.presets.Size(); Sub += 1)
		{
			result += "\nP|" + PotPOverlay_Clean(GetLocStringByKeyExt(group.presets[Sub].label));
		}

		for (Var = 0; Var < store.settings.Size(); Var += 1)
		{
			setting = store.settings[Var];
			if (setting.group != group.id)
			{
				continue;
			}
			if (setting.type_text == "SUBTLE_SEPARATOR")
			{
				result += "\nB|";
				continue;
			}
			// It only reports what the window already shows
			if (setting.id == 'ProgressOnThePath_MiscNotification_Enter')
			{
				continue;
			}
			result += "\nV|" + NameToString(setting.id) + "|" + setting.type_text + "|" + PotPOverlay_Clean(GetLocStringByKeyExt(setting.label)) + "|" + setting.value + "|" + PotPOverlay_Hint(setting.hint_key);
			for (Sub = 0; Sub < setting.options.Size(); Sub += 1)
			{
				result += "\nO|" + PotPOverlay_Clean(GetLocStringByKeyExt(setting.options[Sub]));
			}
		}
	}
	return result;
}

exec function potpoverlay_setvar(group_name: name, var_name: name, value: string)
{
	PotP_SetSetting(var_name, value);
}

exec function potpoverlay_preset(group_name: name, preset: int)
{
	PotP_Settings().ApplyPreset(group_name, preset);
}

exec function potpoverlay_resetgroup(group_name: name)
{
	PotP_Settings().ResetGroup(group_name);
}

// When the window closes after a setting changed
function PotPOverlay_SettingsClosed()
{
	var main : CPotP_Main;

	if (thePlayer)
	{
		main = PotP_Get();
		if (main)
		{
			main.OnSettingsClosed();
		}
	}
}

function PotPOverlay_ExportSection(section: CPotP_Section) : string
{
	var result		: string;
	var tracked		: CPotP_Entry;
	var gwent		: CR4GwintManager = theGame.GetGwintManager();
	var skellige	: bool = gwent.IsDeckUnlocked(GwintFaction_Skellige);
	var flags		: int;
	var _state		: int = 0;
	var header		: string;
	var cutoff		: string;
	var tip			: string;
	var manual		: int;
	var game_done	: bool;
	var listed		: EPotP_Status;
	var Idx			: int;

	if (section.IsCutoffApproaching())
	{
		_state = 1;
	}
	else if (section.IsCutoffPassed())
	{
		_state = 2;
	}

	header = PotP_GetMissableHeader(section);
	if (section.cutoff)
	{
		cutoff = section.cutoff.title;
	}
	result = "S|" + IntToString((int)section.book) + "|" + IntToString((int)section.missable_kind) + "|" + IntToString(_state) + "|" + PotPOverlay_Clean(header) + "|" + PotPOverlay_Clean(cutoff);

	for (Idx = 0; Idx < section.entries.Size(); Idx += 1)
	{
		tracked = section.entries[Idx];

		listed = tracked.status;
		if (section.book == PotP_Book_Missable)
		{
			if (!PotP_ShowInMissableTab(tracked))
			{
				continue;
			}
			listed = PotP_GetMissableStatus(tracked);
		}

		// The same cards CountProgress leaves out, so the books add up to the whole
		if (tracked.category == PotP_A_Gwent && tracked.sub_filter == PotP_I_Skell && !skellige)
		{
			continue;
		}

		flags = 0;
		if (tracked.is_missable)
		{
			flags += 1;
		}
		if (tracked.is_modadded)
		{
			flags += 2;
		}
		flags += tracked.dlc_index * 4;

		tip = PotPOverlay_Clean(PotP_GetMissableTip(tracked));

		// Without a status set by hand, its status is the game's. Otherwise it has to be asked.
		manual = FactsQuerySum(PotP_Fact_Override(tracked.uuid));
		game_done = listed == PotP_S_Completed;
		if (manual != 0)
		{
			game_done = PotP_Get().tracker.IsDoneByGame(tracked);
		}

		result += "\nE|" + tracked.uuid + "|" + IntToString((int)listed) + "|" + IntToString((int)tracked.region) + "|" + IntToString(tracked.filter) + "|" + IntToString(flags) + "|" + PotPOverlay_Clean(tracked.title) + "|" + tip + "|" + IntToString(manual) + "|" + IntToString((int)game_done) + PotPOverlay_CardFields(gwent, tracked) + PotPOverlay_ItemFields(tracked) + PotPOverlay_CreatureFields(PotP_Get(), tracked);
	}
	return result;
}

// The next section, or an empty string when there are no more
function PotPOverlay_ExportNext() : string
{
	var main	: CPotP_Main = PotPOverlay_Main();
	var player	: CR4Player;
	var cursor	: int;
	var count	: int;
	var extra	: int;

	if (!main)
	{
		return "";
	}

	count = main.catalog.sections.Size();
	extra = main.catalog.missable_sections.Size();

	player = thePlayer;
	while (player.potp_overlay_cursor < count + extra)
	{
		cursor = player.potp_overlay_cursor;
		player.potp_overlay_cursor += 1;

		if (cursor >= count)
		{
			return PotPOverlay_ExportSection(main.catalog.missable_sections[cursor - count]);
		}
		if (main.catalog.sections[cursor].book != PotP_Book_Missable && main.catalog.sections[cursor].IsVisible())
		{
			return PotPOverlay_ExportSection(main.catalog.sections[cursor]);
		}
	}
	return "";
}

// Sets an entry's status by hand, or with 0 gives it back to automatic tracking
// A number as the game's tooltips show it. A percentage is kept as a fraction.
function PotPOverlay_StatNumber(value: float, percentage: bool) : string
{
	if (percentage)
	{
		return IntToString(RoundMath(value * 100)) + " %";
	}
	return IntToString(RoundMath(value));
}

// What the game's tooltips say about an item, from its definition, so it needn't be owned:
// I|uuid|category|description|rarity|required level|too high|weight|slots, then A|primary|text for each stat.
function PotPOverlay_ItemStats(tracked: CPotP_Entry) : string
{
	var witcher		: W3PlayerWitcher = GetWitcherPlayer();
	var inventory	: CInventoryComponent;
	var dm			: CDefinitionsManagerAccessor;
	var stats		: array<SAttributeTooltip>;
	var abilities	: array<name>;
	var weights		: array<float>;
	var low, high	: SAbilityAttributeValue;
	var category	: name;
	var description	: string;
	var rarity		: string;
	var weight_text	: string;
	var result		: string;
	var line		: string;
	var quality_min, quality_max, level, Idx, Jdx : int;
	var low_value, high_value : float;
	var too_high	: bool;

	if (!witcher)
	{
		return "";
	}
	inventory = witcher.GetInventory();
	dm = theGame.GetDefinitionsManager();
	category = dm.GetItemCategory(tracked.item_name);

	description = GetLocStringByKeyExt(dm.GetItemLocalisationKeyDesc(tracked.item_name));
	if (description == "")
	{
		description = GetLocStringByKeyExt("item_category_" + NameToString(category) + "_desc");
	}

	inventory.GetItemQualityFromName(tracked.item_name, quality_min, quality_max);
	switch (quality_max)
	{
		case 1: rarity = GetLocStringByKeyExt("panel_inventory_item_rarity_type_common"); break;
		case 2: rarity = GetLocStringByKeyExt("panel_inventory_item_rarity_type_masterwork"); break;
		case 3: rarity = GetLocStringByKeyExt("panel_inventory_item_rarity_type_magic"); break;
		case 4: rarity = GetLocStringByKeyExt("panel_inventory_item_rarity_type_relic"); break;
		case 5: rarity = GetLocStringByKeyExt("panel_inventory_item_rarity_type_set"); break;
		default: rarity = ""; break;
	}

	dm.GetItemAbilitiesWithWeights(tracked.item_name, true, abilities, weights, Idx, Jdx);
	dm.GetAbilitiesAttributeValue(abilities, 'weight', low, high);
	if (high.valueBase != 0)
	{
		weight_text = GetLocStringByKeyExt("attribute_name_weight") + " " + FloatToStringPrec(high.valueBase, 2);
	}

	level = dm.GetItemLevelFromName(tracked.item_name);
	too_high = level > witcher.GetLevel();

	result = "I|" + tracked.uuid + "|" + PotPOverlay_Clean(GetLocStringByKeyExt("item_category_" + NameToString(category)))
		+ "|" + PotPOverlay_Clean(description) + "|" + PotPOverlay_Clean(rarity);
	if (level > 0)
	{
		result += "|" + PotPOverlay_Clean(GetLocStringByKeyExt("panel_inventory_item_requires_level")) + " " + IntToString(level);
	}
	else
	{
		result += "|";
	}
	if (too_high)
	{
		result += "|1";
	}
	else
	{
		result += "|0";
	}
	result += "|" + PotPOverlay_Clean(weight_text) + "|" + IntToString(dm.GetItemEnhancementSlotCount(tracked.item_name));

	inventory.GetItemStatsFromName(tracked.item_name, stats);
	for (Idx = 0; Idx < stats.Size(); Idx += 1)
	{
		// The range it can roll, where it has one, as the crafting menu shows its main stat
		dm.GetAbilitiesAttributeValue(abilities, stats[Idx].originName, low, high);
		if (stats[Idx].percentageValue)
		{
			low_value = low.valueMultiplicative;
			high_value = high.valueMultiplicative;
		}
		else
		{
			low_value = low.valueBase + low.valueAdditive;
			high_value = high.valueBase + high.valueAdditive;
		}
		if (RoundMath(low_value * 100) != RoundMath(high_value * 100) && low_value != 0)
		{
			line = PotPOverlay_StatNumber(low_value, stats[Idx].percentageValue) + " - " + PotPOverlay_StatNumber(high_value, stats[Idx].percentageValue);
		}
		else
		{
			line = PotPOverlay_StatNumber(stats[Idx].value, stats[Idx].percentageValue);
		}
		if (stats[Idx].primaryStat)
		{
			result += "\nA|1|" + PotPOverlay_Clean(line + " " + stats[Idx].attributeName);
		}
		else
		{
			if (stats[Idx].value > 0)
			{
				line = "+" + line;
			}
			result += "\nA|0|" + PotPOverlay_Clean(line + " " + stats[Idx].attributeName);
		}
	}
	return result + PotPOverlay_ItemSetLines(witcher, tracked.item_name);
}

// What wearing the set gives, as the game's tooltip tells it:
// C|pieces worn|pieces there are, then S|pieces needed|1 if it's working now|what it does
function PotPOverlay_ItemSetLines(witcher: W3PlayerWitcher, item_name: name) : string
{
	var set_type	: EItemSetType;
	var bonus		: EItemSetBonus;
	var result		: string;
	var text		: string;
	var active		: string;
	var Idx			: int;

	if (!witcher)
	{
		return "";
	}
	set_type = witcher.CheckSetTypeByName(item_name);
	if (set_type == EIST_Undefined || set_type == EIST_Viper)
	{
		return "";
	}
	result = "\nC|" + IntToString(witcher.GetSetPartsEquipped(set_type)) + "|" + IntToString(theGame.params.ITEMS_REQUIRED_FOR_MAJOR_SET_BONUS);
	for (Idx = 1; Idx <= 2; Idx += 1)
	{
		bonus = witcher.ItemSetTypeToItemSetBonus(set_type, Idx);
		if (bonus == EISB_Undefined)
		{
			continue;
		}
		text = witcher.GetSetBonusTooltipDescription(bonus);
		if (StrLen(text) == 0)
		{
			continue;
		}
		active = "0";
		if (witcher.IsSetBonusActive(bonus))
		{
			active = "1";
		}
		if (Idx == 1)
		{
			result += "\nS|" + IntToString(theGame.params.ITEMS_REQUIRED_FOR_MINOR_SET_BONUS) + "|" + active + "|" + PotPOverlay_Clean(text);
		}
		else
		{
			result += "\nS|" + IntToString(theGame.params.ITEMS_REQUIRED_FOR_MAJOR_SET_BONUS) + "|" + active + "|" + PotPOverlay_Clean(text);
		}
	}
	return result;
}

exec function potpoverlay_itemstats(uuid_value: string)
{
	var main	: CPotP_Main = PotPOverlay_Main();
	var tracked	: CPotP_Entry;

	if (!main)
	{
		return;
	}
	tracked = main.catalog.FindByUuid(uuid_value);
	if (tracked)
	{
		if (tracked.category == PotP_A_Items && tracked.item_name != '')
		{
			main.notifications.QueueForOverlay(PotPOverlay_ItemStats(tracked));
		}
	}
}

//---------------------------------------------------

exec function potpoverlay_updatekey()
{
	var main : CPotP_Main = PotPOverlay_Main();

	if (main)
	{
		main.OnUpdateKey();
	}
}

exec function potpoverlay_setstatus(uuid_value: string, value: int)
{
	var main	: CPotP_Main = PotPOverlay_Main();
	var tracked	: CPotP_Entry;

	if (!main)
	{
		return;
	}
	tracked = main.catalog.FindByUuid(uuid_value);
	if (tracked)
	{
		main.tracker.SetManualStatus(tracked, value, true);
	}
}

function PotPOverlay_Pause()
{
	if (thePlayer)
	{
		theGame.Pause("PotPOverlay");
	}
}

function PotPOverlay_Unpause()
{
	if (thePlayer)
	{
		theGame.Unpause("PotPOverlay");
	}
}
