// What PotpOverlay.asi reads to fill PotP's window. It asks for the catalog a piece at a time, one section
// per game tick, so opening the window never causes a hitch. Lines are separated by a backslash and an n, fields by a bar:
//   N|message                          nothing to show yet
//   H|version|done|total               the whole path
//   R|index|name                       a region's name, in the game's language
//   T|key|text                         the overlay's own text, in the game's language (see PotPOverlayText.ws)
//   S|book|kind|state|header|cutoff|pin    a section (state: 0 nothing, 1 cutoff approaching, 2 cutoff passed; cutoff: the quest that closes it;
//                                      pin: the world map's pin for its kind of place, as the map menu names it)
//   E|uuid|status|region|filter|flags|title|tip|manual|gamedone   an entry (flags: 1 missable, 2 mod-added, 4 and 8 the DLC; manual: 0 tracked automatically, 1 ignored, 2 completed, 3 missed; gamedone: the game itself counts it as done)
//     then, for an item, six empty fields and its template; for a Gwent card: |picture|power|faction|type|description|effects   (picture as the game's menus load it; power -1: a leader; faction 10 more for a neutral card, which takes the deck's; effects separated by commas)
//     or, for a bestiary entry: |||||text|||image|weaknesses   (paragraphs of text separated by ^^; weaknesses separated by semicolons, each name~icon)
//   G|group|title|intro|presethint     a page of PotP's settings, as Settings.ws defines it
//   P|name                             a preset of that page
//   B|                                 a gap between settings
//   V|id|type|name|value|hint|default  a setting (type as Settings.ws gives it: TOGGLE, OPTIONS, SLIDER;min;max;steps, COLOUR)
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

// Every piece of armour there is, and every mask, for the wardrobe, which can show more than the mod tracks:
// WARD, then A|kind|template|title, and |lowered for a hood mod's hood down (it has the same name as with it up).
// Many share a model, which the overlay sorts out.
function PotPOverlay_WardrobeItems() : string
{
	var dm			: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var items		: array<name>;
	var result		: string = "WARD";
	var title		: string;
	var category	: name;
	var template_name	: string;
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

	// Masks aren't armour: they're quick slot items, most from the masquerades. Only what's made for Geralt to wear:
	// those for women are left out (by name, or a woman's model: w_ or female in the template's name), placeholders, and
	// of the masquerades' masks only his own (sq301_item__geralt_..., q703's mandragora_mask_geralt), as the rest are
	// made for other guests' heads.
	items = dm.GetItemsWithTag('QuickSlot');
	for (Idx = 0; Idx < items.Size(); Idx += 1)
	{
		template_name = dm.GetItemEquipTemplate(items[Idx]);
		if (dm.GetItemCategory(items[Idx]) != 'mask' || dm.ItemHasTag(items[Idx], 'NoShow') || StrFindFirst(NameToString(items[Idx]), "woman") >= 0
			|| StrFindFirst(template_name, "__w_") >= 0 || StrFindFirst(template_name, "female") >= 0 || StrFindFirst(template_name, "placeholder") >= 0
			|| ((StrFindFirst(template_name, "sq301_item__") >= 0 || StrFindFirst(template_name, "mandragora") >= 0) && StrFindFirst(template_name, "geralt") < 0))
		{
			continue;
		}
		title = GetLocStringByKeyExt(dm.GetItemLocalisationKeyName(items[Idx]));
		if (StrLen(title) == 0 || StrBeginsWith(title, "#"))
		{
			continue;
		}
		result += "\nA|mask" + PotPOverlay_GearTemplate(items[Idx]) + "|" + PotPOverlay_Clean(title);
		if (StrFindFirst(NameToString(items[Idx]), "Lowered") >= 0)
		{
			result += "|lowered";
		}
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
	var dm			: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var upgrade		: string;
	var template_name	: string;
	var kind		: name;

	if (tracked.category != PotP_A_Items || tracked.item_name == '')
	{
		return "";
	}
	// A path, whose backslashes could read as the \n between lines (a folder starting with n). A piece of witcher gear adds,
	// four fields on, its upgrade: group~tier~tiers, so the overlay shows its tiers as one row.
	upgrade = "";
	if (tracked.upgrade_group != "")
	{
		upgrade = "||||" + tracked.upgrade_group + "~" + IntToString(tracked.upgrade_tier) + "~" + IntToString(tracked.upgrade_tiers);
	}
	// Horse gear the game names with _hd__ is known by that; a mod's, such as Sezon Burz's, by its kind before the name
	// (horse_saddle:...), so the overlay puts it on Roach, a saddle in place of hers
	template_name = dm.GetItemEquipTemplate(tracked.item_name);
	kind = dm.GetItemCategory(tracked.item_name);
	if (StrFindFirst(template_name, "_hd__") < 0 && (kind == 'horse_saddle' || kind == 'horse_bag' || kind == 'horse_blinder'))
	{
		template_name = NameToString(kind) + ":" + template_name;
	}
	return "|||||||" + PotPOverlay_Clean(StrReplaceAll(template_name, StrChar(92), "/")) + upgrade;
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

// The card's art as the game's menus load it, the alternative art when that DLC is switched on
function PotPOverlay_CardPicture(card: SCardDefinition) : string
{
	if (IsNameValid(card.dlcPictureFlag) && theGame.GetDLCManager().IsDLCAvailable('dlc_008_001') && theGame.GetInGameConfigWrapper().GetVarValue('DLC', 'dlc_008_001') == "true")
	{
		return card.dlcPicture;
	}
	return card.picture;
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
	picture = PotPOverlay_CardPicture(card);
	power = card.power;
	type_flags = card.typeFlags;
	faction = (int)card.faction;
	if (card.faction == GwintFaction_Neutral)
	{
		faction = 10 + (int)gwent.GetSelectedPlayerDeck();   // drawn in the deck's colours, as the game does; 10 more says it's neutral
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
			result += "\nV|" + NameToString(setting.id) + "|" + setting.type_text + "|" + PotPOverlay_Clean(GetLocStringByKeyExt(setting.label)) + "|" + setting.value + "|" + PotPOverlay_Hint(setting.hint_key) + "|" + setting.default_value;
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

// One of the game's own menu sounds, for the overlay's window: gui_global_highlight, gui_global_switch and the like,
// as the inventory and journal play them. They follow the game's sound effects volume.
exec function potpoverlay_sound(event_name: string)
{
	theSound.SoundEvent(event_name);
}

// The window has opened. The inventory's player stats sounds, which its enlarged view plays, are in gui_ep2.bnk, which
// the game's menus only load while one is open. Left loaded: it's small, and the menus' own load and unload pair up.
exec function potpoverlay_soundbanks()
{
	if (!theSound.SoundIsBankLoaded("gui_ep2.bnk"))
	{
		theSound.SoundLoadBank("gui_ep2.bnk", true);
	}
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
	result = "S|" + IntToString((int)section.book) + "|" + IntToString((int)section.missable_kind) + "|" + IntToString(_state) + "|" + PotPOverlay_Clean(header) + "|" + PotPOverlay_Clean(cutoff) + "|" + PotPOverlay_SectionPin(section);

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

// What the game says about a card, with its own strings: faction, type, row and strength, as the deck builder's tooltips
// have them, then every ability it has. Abilities go by the card's effect numbers (as PotPOverlay_CardFields sends them,
// in the order of the Gwent menus' own list), not the scripts' effect names, which no longer line up with the engine's.
// A leader's ability is its effect too (gwint_card_tooltip_ldr_...), not its description, which is its quote.
// K|uuid|faction label|faction|faction number|type label|type|row label|row|strength label|strength|abilities label
//   then a title and a text for each ability
function PotPOverlay_CardStats(tracked: CPotP_Entry) : string
{
	var gwent		: CR4GwintManager = theGame.GetGwintManager();
	var card		: SCardDefinition;
	var faction		: string;
	var kind		: string;
	var row			: string;
	var strength	: string;
	var label		: string;
	var abilities	: string;
	var key			: string;
	var flags		: int;
	var effect		: int;
	var Idx			: int;
	var leader		: bool;

	if (tracked.card_names.Size() == 0 || !gwent.GetGwentCard(tracked.card_names[0], card))
	{
		return "";
	}
	switch (card.faction)
	{
	case GwintFaction_Neutral:		faction = "gwint_faction_name_neutral"; break;
	case GwintFaction_NoMansLand:	faction = "gwint_faction_name_no_mans_land"; break;
	case GwintFaction_Nilfgaard:	faction = "gwint_faction_name_nilfgaard"; break;
	case GwintFaction_NothernKingdom:	faction = "gwint_faction_name_northern_kingdom"; break;
	case GwintFaction_Scoiatael:	faction = "gwint_faction_name_scoiatael"; break;
	case GwintFaction_Skellige:		faction = "gwint_faction_name_skellige"; break;
	}

	flags = card.typeFlags;
	leader = gwent.IsKingCard(card);
	if (leader)
	{
		kind = GetLocStringByKeyExt("gwint_tooltip_card_type_leader");
		label = GetLocStringByKeyExt("gwint_leader_ability");
		for (Idx = 0; Idx < card.effectFlags.Size(); Idx += 1)
		{
			key = "";
			switch ((int)card.effectFlags[Idx])
			{
			case 7: key = "ldr_melee_scorch"; break;
			case 8: key = "ldr_eleventh_card"; break;
			case 9: key = "ldr_clear_weather"; break;
			case 10: key = "ldr_pick_weather"; break;
			case 11: key = "ldr_pick_rain"; break;
			case 12: key = "ldr_pick_fog"; break;
			case 13: key = "ldr_pick_frost"; break;
			case 14: key = "ldr_view_enemy"; break;
			case 15: key = "ldr_resurect"; break;
			case 16: key = "ldr_resurect_enemy"; break;
			case 17: key = "ldr_bin_pick"; break;
			case 18: key = "ldr_melee_horn"; break;
			case 19: key = "ldr_range_horn"; break;
			case 20: key = "ldr_siege_horn"; break;
			case 21: key = "ldr_siege_scorch"; break;
			case 22: key = "ldr_counter_king"; break;
			case 36: key = "ldr_agile_reposition"; break;
			case 37: key = "ldr_random_ressurect"; break;
			case 38: key = "ldr_double_spy"; break;
			case 39: key = "ldr_ranged_scorch"; break;
			case 43: key = "ldr_weather_resistant"; break;
			case 44: key = "ldr_graveyard_shuffle"; break;
			}
			// As the deck builder's tooltip shows a leader (CardTooltip in deck_builder.redswf): "Leader Ability" over what
			// its effect does, with no title of its own. The leaders' _title strings aren't used by the game, and most
			// name another leader.
			if (key != "" && PotPOverlay_GwentText("gwint_card_tooltip_" + key) != "")
			{
				abilities += "||" + PotPOverlay_Clean(PotPOverlay_GwentText("gwint_card_tooltip_" + key));
			}
		}
	}
	else
	{
		if ((flags & GwintType_Creature) == GwintType_Creature)
		{
			if ((flags & GwintType_Hero) == GwintType_Hero)
			{
				kind = GetLocStringByKeyExt("gwint_card_tooltip_hero_title");
			}
			else
			{
				kind = GetLocStringByKeyExt("gwint_tooltip_card_type_creature");
			}
			if ((flags & GwintType_Melee) == GwintType_Melee)
			{
				row = StrReplaceAll(GetLocStringByKeyExt("gwint_tutorial_unit_range_close"), "<br>", "");
				if ((flags & GwintType_Ranged) == GwintType_Ranged)
				{
					row += ", " + StrReplaceAll(GetLocStringByKeyExt("gwint_tutorial_unit_range_long"), "<br>", "");
				}
			}
			else if ((flags & GwintType_Ranged) == GwintType_Ranged)
			{
				row = StrReplaceAll(GetLocStringByKeyExt("gwint_tutorial_unit_range_long"), "<br>", "");
			}
			else if ((flags & GwintType_Siege) == GwintType_Siege)
			{
				row = StrReplaceAll(GetLocStringByKeyExt("gwint_tutorial_unit_range_siege"), "<br>", "");
			}
			strength = IntToString(card.power);
			label = GetLocStringByKeyExt("gwint_tut_unitcardspecialability_title");

			// What the unit is, before what it does: a hero, and one that can go in either row
			if ((flags & GwintType_Hero) == GwintType_Hero)
			{
				abilities += PotPOverlay_CardAbility("hero");
			}
			if ((flags & GwintType_Ranged) == GwintType_Ranged && (flags & GwintType_Melee) == GwintType_Melee)
			{
				abilities += PotPOverlay_CardAbility("agile");
			}
		}
		else
		{
			kind = GetLocStringByKeyExt("gwint_tooltip_card_type_special");
			if ((flags & GwintType_Weather) == GwintType_Weather)
			{
				kind += ", " + GetLocStringByKeyExt("gwint_tooltip_card_type_weather");
			}
		}

		for (Idx = 0; Idx < card.effectFlags.Size(); Idx += 1)
		{
			key = "";
			effect = (int)card.effectFlags[Idx];
			switch (effect)
			{
			case 31:
				// Muster; Cerys's, card 502, summons her shield maidens (as the deck builder's tooltip has it)
				key = "summon_clones";
				if (gwent.GetIndex(card) == 502)
				{
					key = "summon_sm";
				}
				break;
			case 33: key = "nurse"; break;
			case 34: key = "spy"; break;
			case 35: key = "same_type_morale"; break;
			case 32: key = "improve_neightbours"; break;
			case 27: key = "horn"; break;
			case 29:
				// The Clan Dimun Pirate's, card 524, has the game's own text for a unit's Scorch
				key = "scorch";
				if (gwent.GetIndex(card) == 524)
				{
					key = "scorch_creature";
				}
				break;
			case 41: key = "mushroom"; break;
			case 42: key = "morph"; break;
			case 40: key = "suicide_summon"; break;
			case 26: key = "dummy"; break;
			case 30: key = "clearsky"; break;
			case 9: key = "clearsky"; break;
			case 23: key = "frost"; break;
			case 24:
				key = "fog";
				if (PotPOverlay_HasEffect(card, 25))
				{
					key = "skel_rain";
				}
				break;
			case 25:
				if (!PotPOverlay_HasEffect(card, 24))
				{
					key = "rain";
				}
				break;
			// A unit's own Scorch, for its row: Villentretenmerth, the Toad, Schirru
			case 7: key = "scorch_melee"; break;
			case 39: key = "scorch_ranged"; break;
			case 21: key = "scorch_siege"; break;
			}
			if (key == "scorch_melee" || key == "scorch_ranged" || key == "scorch_siege")
			{
				abilities += PotPOverlay_CardScorch(key);
			}
			else
			{
				abilities += PotPOverlay_CardAbility(key);
			}
		}
	}
	return "K|" + tracked.uuid
		+ "|" + PotPOverlay_Clean(GetLocStringByKeyExt("gwint_tooltip_faction_header")) + "|" + PotPOverlay_Clean(GetLocStringByKeyExt(faction)) + "|" + IntToString((int)card.faction)
		+ "|" + PotPOverlay_Clean(GetLocStringByKeyExt("gwint_tooltip_card_type")) + "|" + PotPOverlay_Clean(kind)
		+ "|" + PotPOverlay_Clean(GetLocStringByKeyExt("gwint_tut_unitcardrange_title")) + "|" + PotPOverlay_Clean(row)
		+ "|" + PotPOverlay_Clean(GetLocStringByKeyExt("gwint_tut_unitcardstrength_title")) + "|" + strength
		+ "|" + PotPOverlay_Clean(label) + abilities;
}

// Whether a card has an effect, by its number
function PotPOverlay_HasEffect(card: SCardDefinition, effect: int) : bool
{
	var Idx : int;

	for (Idx = 0; Idx < card.effectFlags.Size(); Idx += 1)
	{
		if ((int)card.effectFlags[Idx] == effect)
		{
			return true;
		}
	}
	return false;
}

// One ability, as |title|text, from the game's gwint_card_tooltip_<key> strings; nothing if it has none
function PotPOverlay_CardAbility(key: string) : string
{
	var title	: string;
	var text	: string;

	if (key == "")
	{
		return "";
	}
	title = PotPOverlay_GwentText("gwint_card_tooltip_" + key + "_title");
	text = PotPOverlay_GwentText("gwint_card_tooltip_" + key);
	if (title == "" && text == "")
	{
		return "";
	}
	return "|" + PotPOverlay_Clean(title) + "|" + PotPOverlay_Clean(text);
}

// A unit's own Scorch, for its row, as the game's strings for those cards have it
function PotPOverlay_CardScorch(key: string) : string
{
	var text : string;

	switch (key)
	{
	case "scorch_melee":	text = PotPOverlay_GwentText("gwint_card_villen_melee_scorch"); break;
	case "scorch_ranged":	text = PotPOverlay_GwentText("gwint_card_ranged_scorch"); break;
	default:				text = PotPOverlay_GwentText("gwint_card_siege_scorch"); break;
	}
	if (text == "")
	{
		text = PotPOverlay_GwentText("gwint_card_tooltip_scorch_creature");
	}
	return "|" + PotPOverlay_Clean(PotPOverlay_GwentText("gwint_card_tooltip_scorch_title")) + "|" + PotPOverlay_Clean(text);
}

// A Gwent string, or nothing if the game has none by that key
function PotPOverlay_GwentText(key: string) : string
{
	var text : string = GetLocStringByKeyExt(key);

	if (text == "" || StrBeginsWith(text, "#") || text == key)
	{
		return "";
	}
	return text;
}

exec function potpoverlay_cardstats(uuid_value: string)
{
	var main	: CPotP_Main = PotPOverlay_Main();
	var tracked	: CPotP_Entry;

	if (!main)
	{
		return;
	}
	tracked = main.catalog.FindByUuid(uuid_value);
	if (tracked && tracked.category == PotP_A_Gwent)
	{
		main.notifications.QueueForOverlay(PotPOverlay_CardStats(tracked));
	}
}

//---------------------------------------------------

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

// A quest's or random event's story so far, as the journal's own quest page shows it: J|uuid|then a paragraph a field.
// A lone - for an event with no story to tell.
exec function potpoverlay_questlore(uuid_value: string)
{
	var main	: CPotP_Main = PotPOverlay_Main();
	var tracked	: CPotP_Entry;

	if (!main)
	{
		return;
	}
	tracked = main.catalog.FindByUuid(uuid_value);
	if (tracked && tracked.category == PotP_A_Quest)
	{
		main.notifications.QueueForOverlay("J|" + uuid_value + PotPOverlay_QuestLore(PotPOverlay_LoreJournal(tracked, 0)));
	}
	else if (tracked && tracked.category == PotP_A_Event)
	{
		main.notifications.QueueForOverlay("J|" + uuid_value + PotPOverlay_EventLore(tracked));
	}
}

// A random event's: Brothers In Arms' Events' journal for it when that's installed and has it, as it has every choice
// in it, or else the opening PotP keeps for it (data/definitions/EventDefinitions.ws, AddEventLore)
function PotPOverlay_EventLore(tracked: CPotP_Entry) : string
{
	var text		: string;
	var outcomes	: string;

	if (tracked.lore_title > 0)
	{
		text = PotPOverlay_QuestLore(PotPOverlay_LoreJournal(tracked, tracked.lore_title));
		if (text != "")
		{
			return text;
		}
	}
	text = PotPOverlay_EventText("potp_lore_" + tracked.uuid);
	outcomes = PotPOverlay_EventOutcomes(tracked);
	// Some stages' openings are the start of what came of them: then the whole of it, not the start twice
	if (text != "" && outcomes != "" && StrBeginsWith(outcomes, "|" + text))
	{
		text = "";
	}
	if (text != "")
	{
		text = "|" + text;
	}
	text += outcomes;
	if (text == "")
	{
		return "|-";
	}
	return text;
}

// What came of it, as far as PotP heard (tracking/QuestListener.ws, AddEventOutcome): each paragraph, in the order told
function PotPOverlay_EventOutcomes(tracked: CPotP_Entry) : string
{
	var told	: array<int>;
	var text	: string;
	var Idx		: int;

	told = tracked.lore_outcomes;
	ArraySortInts(told);
	for (Idx = 0; Idx < told.Size(); Idx += 1)
	{
		if (FactsDoesExist(PotP_OutcomeFact(told[Idx])))
		{
			text += "|" + PotPOverlay_EventText("potp_outcome_" + told[Idx]);
		}
	}
	if (tracked.lore_done > 0 && tracked.IsDone())
	{
		text += "|" + PotPOverlay_EventText("potp_outcome_" + tracked.lore_done);
	}
	return text;
}

function PotPOverlay_EventText(key: string) : string
{
	var text : string = GetLocStringByKeyExt(key);

	if (text == "" || StrBeginsWith(text, "#"))
	{
		return "";
	}
	return PotPOverlay_Clean(text);
}

// The journal's quest for an entry: a quest by its name, or with title_id, the one with that title
function PotPOverlay_LoreJournal(tracked: CPotP_Entry, title_id: int) : CJournalQuest
{
	var quests	: array<CJournalBase>;
	var quest_entry	: CJournalQuest;
	var Idx		: int;

	theGame.GetJournalManager().GetActivatedOfType('CJournalQuest', quests);
	for (Idx = 0; Idx < quests.Size(); Idx += 1)
	{
		quest_entry = (CJournalQuest)quests[Idx];
		if (!quest_entry)
		{
			continue;
		}
		if (title_id > 0)
		{
			if (quest_entry.GetTitleStringId() == title_id)
			{
				return quest_entry;
			}
		}
		else if (quests[Idx].baseName == tracked.entry_name || (tracked.alt_entry_name != "" && quests[Idx].baseName == tracked.alt_entry_name))
		{
			return quest_entry;
		}
	}
	return NULL;
}

// The journal menu's GetDescription: the description entries it has reached, in their order, or the game's own line
// for a quest it has with none yet. Nothing for a quest the journal doesn't have yet: the overlay says so in its own words.
function PotPOverlay_QuestLore(journal_quest: CJournalQuest) : string
{
	var journal		: CWitcherJournalManager = theGame.GetJournalManager();
	var description_group	: CJournalQuestDescriptionGroup;
	var description	: CJournalQuestDescriptionEntry;
	var found		: array<CJournalQuestDescriptionEntry>;
	var text		: string;
	var paragraph	: string;
	var Idx			: int;
	var Jdx			: int;

	if (!journal_quest)
	{
		return "";
	}

	if (journal_quest)
	{
		for (Idx = 0; Idx < journal_quest.GetNumChildren(); Idx += 1)
		{
			description_group = (CJournalQuestDescriptionGroup)journal_quest.GetChild(Idx);
			if (description_group)
			{
				break;
			}
		}
	}

	if (description_group)
	{
		for (Idx = 0; Idx < description_group.GetNumChildren(); Idx += 1)
		{
			description = (CJournalQuestDescriptionEntry)description_group.GetChild(Idx);
			if (!description || journal.GetEntryStatus(description) == JS_Inactive)
			{
				continue;
			}
			for (Jdx = 0; Jdx < found.Size(); Jdx += 1)
			{
				if (found[Jdx].GetOrder() > description.GetOrder())
				{
					break;
				}
			}
			if (Jdx < found.Size())
			{
				found.Insert(Jdx, description);
			}
			else
			{
				found.PushBack(description);
			}
		}
	}

	for (Idx = 0; Idx < found.Size(); Idx += 1)
	{
		paragraph = GetLocStringById(found[Idx].GetDescriptionStringId());
		if (paragraph != "")
		{
			text += "|" + PotPOverlay_Clean(paragraph);
		}
	}
	if (text == "")
	{
		text = "|" + PotPOverlay_Clean(GetLocStringByKeyExt("panel_journal_quest_empty_description"));
	}
	return text;
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

//---------------------------------------------------

// The world map's pin for a World Map group's kind of place, as the map menu's frames are named
function PotPOverlay_SectionPin(section: CPotP_Section) : string
{
	var group : string = section.group;

	if (section.book != PotP_Book_World)
	{
		return "";
	}
	if (StrFindFirst(group, "_AbandonedSites_") >= 0)		{ return "RescuingTown"; }
	if (StrFindFirst(group, "_BanditCamp_") >= 0)			{ return "BanditCampfire"; }
	if (StrFindFirst(group, "_GuardedTreasure_") >= 0)		{ return "BossAndTreasure"; }
	if (StrFindFirst(group, "_MonsterDens_") >= 0)			{ return "DungeonCrawl"; }
	if (StrFindFirst(group, "_MonsterNests_") >= 0)			{ return "MonsterNest"; }
	if (StrFindFirst(group, "_HanseBases_") >= 0)			{ return "Hideout"; }
	if (StrFindFirst(group, "_DistressedKnights_") >= 0)	{ return "KnightErrant"; }
	if (StrFindFirst(group, "_InfestedVineyards_") >= 0)	{ return "InfestedVineyard"; }
	if (StrFindFirst(group, "_PlacesOfPower_") >= 0)		{ return "PlaceOfPower"; }
	if (StrFindFirst(group, "_PersonsInDistress_") >= 0)	{ return "BanditCamp"; }
	if (StrFindFirst(group, "_Signposts_") >= 0)			{ return "RoadSign"; }
	if (StrFindFirst(group, "_PlayerStashes_") >= 0)		{ return "PlayerStash"; }
	// The ones read from the map's own pins (DynamicPins.ws): named after the pin type
	if (group == "PotP_Cache_")								{ return "Contraband"; }
	if (group == "PotP_Spoils_")							{ return "SpoilsOfWar"; }
	if (group == "PotP_Hidden_")							{ return "TreasureHuntMappin"; }
	return "";
}
