//---------------------------------------------------
//-- Settings ---------------------------------------
//---------------------------------------------------
// The mod's settings: what they are, here, and their values, in a map on theGame that everything reads.
// The overlay keeps the values in its own potp_overlay.ini. As the scripts start it sends them over, and whenever
// one changes, from its Settings page or from a script, it sees the map's version move and saves them again.
// Until it has sent them, and without it, each setting has its default.

class CPotP_Setting
{
	public var group		: name;
	public var id			: name;		// None for a separator
	public var type_text	: string;	// TOGGLE, OPTIONS, SLIDER;min;max;steps, COLOUR (RRGGBB in hex) or SUBTLE_SEPARATOR
	public var label		: string;	// a string key
	public var hint_key		: string;	// a string key, or ""
	public var default_value: string;
	public var value		: string;
	public var options		: array<string>;	// an OPTIONS setting's choices, as string keys: the value is the index
}

class CPotP_SettingGroup
{
	public var id			: name;
	public var label		: string;
	public var intro		: string;
	public var preset_hint	: string;
	public var presets		: array<CPotP_SettingPreset>;
}

class CPotP_SettingPreset
{
	public var label		: string;
	public var ids			: array<name>;
	public var values		: array<string>;
}

class CPotP_Settings
{
	public var groups	: array<CPotP_SettingGroup>;
	public var settings	: array<CPotP_Setting>;
	public var ids		: array<name>;	// beside settings, for finding one
	public var version	: int;			// moves with every change, so the overlay knows to save
	public var loaded	: bool;			// the overlay has sent the saved values

	private var current	: CPotP_SettingGroup;

	public function Group(id: name, label: string, optional intro: string, optional preset_hint: string)
	{
		current = new CPotP_SettingGroup in this;
		current.id = id;
		current.label = label;
		current.intro = intro;
		current.preset_hint = preset_hint;
		groups.PushBack(current);
	}

	public function Add(id: name, type_text: string, default_value: string, label_key: string, hint_key: string) : CPotP_Setting
	{
		var setting : CPotP_Setting = new CPotP_Setting in this;

		setting.group = current.id;
		setting.id = id;
		setting.type_text = type_text;
		setting.label = label_key;
		setting.hint_key = hint_key;
		setting.default_value = default_value;
		setting.value = default_value;
		settings.PushBack(setting);
		ids.PushBack(id);
		return setting;
	}

	public function Separator()
	{
		var setting : CPotP_Setting = new CPotP_Setting in this;

		setting.group = current.id;
		setting.type_text = "SUBTLE_SEPARATOR";
		settings.PushBack(setting);
		ids.PushBack('');
	}

	public function Preset(label: string) : CPotP_SettingPreset
	{
		var preset : CPotP_SettingPreset = new CPotP_SettingPreset in this;

		preset.label = label;
		current.presets.PushBack(preset);
		return preset;
	}

	public function Find(id: name) : CPotP_Setting
	{
		var Idx : int;

		if (!IsNameValid(id))
		{
			return NULL;
		}
		Idx = ids.FindFirst(id);
		if (Idx < 0)
		{
			return NULL;
		}
		return settings[Idx];
	}

	public function FindGroup(id: name) : CPotP_SettingGroup
	{
		var Idx : int;

		for (Idx = 0; Idx < groups.Size(); Idx += 1)
		{
			if (groups[Idx].id == id)
			{
				return groups[Idx];
			}
		}
		return NULL;
	}

	public function Set(id: name, value: string)
	{
		var setting : CPotP_Setting = Find(id);

		if (setting && setting.value != value)
		{
			setting.value = value;
			version += 1;
		}
	}

	public function ApplyPreset(group_id: name, index: int)
	{
		var group	: CPotP_SettingGroup = FindGroup(group_id);
		var Idx		: int;

		if (!group || index < 0 || index >= group.presets.Size())
		{
			return;
		}
		for (Idx = 0; Idx < group.presets[index].ids.Size(); Idx += 1)
		{
			Set(group.presets[index].ids[Idx], group.presets[index].values[Idx]);
		}
	}

	public function ResetGroup(group_id: name)
	{
		var Idx : int;

		for (Idx = 0; Idx < settings.Size(); Idx += 1)
		{
			if (settings[Idx].group == group_id && IsNameValid(settings[Idx].id))
			{
				Set(settings[Idx].id, settings[Idx].default_value);
			}
		}
	}
}

@addField(CR4Game)
var potp_settings : CPotP_Settings;

//---------------------------------------------------

function PotP_Settings() : CPotP_Settings
{
	var game	: CR4Game = theGame;
	var store	: CPotP_Settings = theGame.potp_settings;

	if (!store)
	{
		store = new CPotP_Settings in theGame;
		PotP_DefineSettings(store);
		game.potp_settings = store;
	}
	return store;
}

function PotP_GetSetting(id: name) : string
{
	var setting : CPotP_Setting = PotP_Settings().Find(id);

	if (!setting)
	{
		return "";
	}
	return setting.value;
}

function PotP_SettingFlag(id: name) : bool
{
	return PotP_GetSetting(id) == "true";
}

function PotP_SettingInt(id: name) : int
{
	return StringToInt(PotP_GetSetting(id));
}

function PotP_SetSetting(id: name, value: string)
{
	PotP_Settings().Set(id, value);
}

function PotP_MissableNotificationsOn() : bool
{
	return PotP_GetSetting('ProgressOnThePath_MiscNotification_Missable') != "false";
}

function PotP_TrackerNotesOn() : bool
{
	return PotP_GetSetting('ProgressOnThePath_MiscNotification_Tracker') != "false";
}

//---------------------------------------------------

function PotP_DefineSettings(s: CPotP_Settings)
{
	var preset : CPotP_SettingPreset;

	s.Group('ProgressOnThePath_GeneralSettings', "potp_ov_set_page_general", "potp_ov_set_page_general_intro");
	s.Add('ProgressOnThePath_MeditationUpdate',				"TOGGLE",			"true",	"potp_ov_set_meditation", "potp_ov_set_meditation_hint");
	s.Add('ProgressOnThePath_EnableHotKey',					"TOGGLE",			"true",	"potp_ov_set_hotkey", "potp_ov_set_hotkey_hint");
	s.Add('ProgressOnThePath_ShowCollectabilityTooltips',	"TOGGLE",			"true",	"potp_ov_set_tooltips", "potp_ov_set_tooltips_hint");
	s.Separator();
	s.Add('ProgressOnThePath_EventMapPins_ShowMapPins',		"TOGGLE",			"true",	"potp_ov_set_pins_show", "potp_ov_set_pins_show_hint");
	s.Add('ProgressOnThePath_EventMapPins_ShowOnMinimap',		"TOGGLE",			"true",	"potp_ov_set_pins_minimap", "potp_ov_set_pins_minimap_hint");
	s.Add('ProgressOnThePath_EventMapPins_MapPinDescription',	"TOGGLE",		"true",	"potp_ov_set_pins_description", "potp_ov_set_pins_description_hint");
	s.Add('ProgressOnThePath_EventMapPins_MapPinRadius',		"SLIDER;5;60;55",	"30",	"potp_ov_set_pins_radius", "potp_ov_set_pins_radius_hint");
	PotP_SettingOptions(s.Add('ProgressOnThePath_EventMapPins_MapPinType', "OPTIONS", "1", "potp_ov_set_pins_type", "potp_ov_set_pins_type_hint"), "potp_ov_set_pins_type_", 5);
	s.Separator();
	s.Add('ProgressOnThePath_ResetForNGPlus',				"TOGGLE",			"false", "potp_ov_set_ngplus", "potp_ov_set_ngplus_hint");

	s.Group('ProgressOnThePath_NotificationSettings', "potp_ov_set_page_notifications", "potp_ov_set_page_notifications_intro", "potp_ov_set_page_notifications_presets");
	s.Add('ProgressOnThePath_ShowUpdateNotifications',		"TOGGLE",			"true",	"potp_ov_set_notify_modupdate", "potp_ov_set_notify_modupdate_hint");
	s.Add('ProgressOnThePath_GlobalNotification_Size',		"SLIDER;14;34;20",	"18",	"potp_ov_set_notify_size", "potp_ov_set_notify_size_hint");
	s.Add('ProgressOnThePath_GlobalNotification_Font',		"COLOUR",			"9DB4FF", "potp_ov_set_notify_colour", "potp_ov_set_notify_colour_hint");
	s.Add('ProgressOnThePath_GlobalNotification_Time',		"SLIDER;1;15;14",	"7",	"potp_ov_set_notify_time", "potp_ov_set_notify_time_hint");
	s.Separator();
	s.Add('ProgressOnThePath_FullNotification_Quest',		"TOGGLE",			"true",	"potp_ov_set_full_quest", "potp_ov_set_full_quest_hint");
	s.Add('ProgressOnThePath_FullNotification_World',		"TOGGLE",			"true",	"potp_ov_set_full_world", "potp_ov_set_full_world_hint");
	s.Add('ProgressOnThePath_FullNotification_Items',		"TOGGLE",			"true",	"potp_ov_set_full_items", "potp_ov_set_full_items_hint");
	s.Add('ProgressOnThePath_FullNotification_Gwent',		"TOGGLE",			"true",	"potp_ov_set_full_gwent", "potp_ov_set_full_gwent_hint");
	s.Add('ProgressOnThePath_FullNotification_Event',		"TOGGLE",			"true",	"potp_ov_set_full_event", "potp_ov_set_full_event_hint");
	s.Add('ProgressOnThePath_FullNotification_Nulls',		"TOGGLE",			"true",	"potp_ov_set_full_nulls", "potp_ov_set_full_nulls_hint");
	s.Separator();
	s.Add('ProgressOnThePath_BackNotification_Quest',		"TOGGLE",			"true",	"potp_ov_set_back_quest", "potp_ov_set_back_quest_hint");
	s.Add('ProgressOnThePath_BackNotification_World',		"TOGGLE",			"true",	"potp_ov_set_back_world", "potp_ov_set_back_world_hint");
	s.Add('ProgressOnThePath_BackNotification_Items',		"TOGGLE",			"true",	"potp_ov_set_back_items", "potp_ov_set_back_items_hint");
	s.Add('ProgressOnThePath_BackNotification_Gwent',		"TOGGLE",			"true",	"potp_ov_set_back_gwent", "potp_ov_set_back_gwent_hint");
	s.Add('ProgressOnThePath_BackNotification_Event',		"TOGGLE",			"true",	"potp_ov_set_back_event", "potp_ov_set_back_event_hint");
	s.Separator();
	s.Add('ProgressOnThePath_MiscNotification_Event',		"TOGGLE",			"true",	"potp_ov_set_misc_event", "potp_ov_set_misc_event_hint");
	s.Add('ProgressOnThePath_MiscNotification_Enter',		"TOGGLE",			"true",	"potp_ov_set_misc_enter", "");
	s.Add('ProgressOnThePath_MiscNotification_Missable',	"TOGGLE",			"true",	"potp_ov_set_misc_missable", "potp_ov_set_misc_missable_hint");
	s.Add('ProgressOnThePath_MiscNotification_Tracker',		"TOGGLE",			"true",	"potp_ov_set_misc_tracker", "potp_ov_set_misc_tracker_hint");
	PotP_SettingOptions(s.Add('ProgressOnThePath_MiscNotification_TrackerStyle', "OPTIONS", "0", "potp_ov_set_misc_tracker_style", "potp_ov_set_misc_tracker_style_hint"), "potp_ov_set_misc_tracker_style_", 2);

	// Disabled, Lite and Enabled: everything off; brief pop-ups only; everything on
	preset = s.Preset("potp_ov_set_preset_disabled");
	PotP_PresetNotifications(preset, "0", "E8E6E3", "0", "false", "false", "false");
	preset = s.Preset("potp_ov_set_preset_lite");
	PotP_PresetNotifications(preset, "18", "9DB4FF", "3", "true", "false", "true");
	preset = s.Preset("potp_ov_set_preset_enabled");
	PotP_PresetNotifications(preset, "18", "9DB4FF", "7", "true", "true", "true");

	// Tracked Contents: a toggle a kind of content. Off, a kind isn't counted, announced, pinned or warned about; it's
	// still listed, marked as not tracked. The Library's are off to begin with: it's for reading, not for counting.
	s.Group('ProgressOnThePath_TrackedContents', "potp_ov_set_page_tracked", "potp_ov_set_page_tracked_intro");
	s.Add('ProgressOnThePath_Track_Quest_Main', "TOGGLE", "true", "potp_ov_set_track_quest_main", "");
	s.Add('ProgressOnThePath_Track_Quest_Side', "TOGGLE", "true", "potp_ov_set_track_quest_side", "");
	s.Add('ProgressOnThePath_Track_Quest_Contract', "TOGGLE", "true", "potp_ov_set_track_quest_contract", "");
	s.Add('ProgressOnThePath_Track_Quest_Scavenger', "TOGGLE", "true", "potp_ov_set_track_quest_scavenger", "");
	s.Add('ProgressOnThePath_Track_Quest_Treasure', "TOGGLE", "true", "potp_ov_set_track_quest_treasure", "");
	s.Add('ProgressOnThePath_Track_Event', "TOGGLE", "true", "potp_ov_set_track_event", "");
	s.Separator();
	s.Add('ProgressOnThePath_Track_World_Camps', "TOGGLE", "true", "potp_ov_set_track_world_camps", "");
	s.Add('ProgressOnThePath_Track_World_Dens', "TOGGLE", "true", "potp_ov_set_track_world_dens", "");
	s.Add('ProgressOnThePath_Track_World_Nests', "TOGGLE", "true", "potp_ov_set_track_world_nests", "");
	s.Add('ProgressOnThePath_Track_World_Places', "TOGGLE", "true", "potp_ov_set_track_world_places", "");
	s.Add('ProgressOnThePath_Track_World_Signs', "TOGGLE", "true", "potp_ov_set_track_world_signs", "");
	s.Add('ProgressOnThePath_Track_World_Sites', "TOGGLE", "true", "potp_ov_set_track_world_sites", "");
	s.Add('ProgressOnThePath_Track_World_Guarded', "TOGGLE", "true", "potp_ov_set_track_world_guarded", "");
	s.Add('ProgressOnThePath_Track_World_Distress', "TOGGLE", "true", "potp_ov_set_track_world_distress", "");
	s.Add('ProgressOnThePath_Track_World_Knights', "TOGGLE", "true", "potp_ov_set_track_world_knights", "");
	s.Add('ProgressOnThePath_Track_World_Infested', "TOGGLE", "true", "potp_ov_set_track_world_infested", "");
	s.Add('ProgressOnThePath_Track_World_Hanse', "TOGGLE", "true", "potp_ov_set_track_world_hanse", "");
	s.Add('ProgressOnThePath_Track_World_Stashes', "TOGGLE", "true", "potp_ov_set_track_world_stashes", "");
	s.Add('ProgressOnThePath_Track_World_Caches', "TOGGLE", "true", "potp_ov_set_track_world_caches", "");
	s.Add('ProgressOnThePath_Track_World_Spoils', "TOGGLE", "true", "potp_ov_set_track_world_spoils", "");
	s.Add('ProgressOnThePath_Track_World_Hidden', "TOGGLE", "true", "potp_ov_set_track_world_hidden", "");
	s.Separator();
	s.Add('ProgressOnThePath_Track_Items_Silver', "TOGGLE", "true", "potp_ov_set_track_items_silver", "");
	s.Add('ProgressOnThePath_Track_Items_Steel', "TOGGLE", "true", "potp_ov_set_track_items_steel", "");
	s.Add('ProgressOnThePath_Track_Items_Crossbows', "TOGGLE", "true", "potp_ov_set_track_items_crossbows", "");
	s.Add('ProgressOnThePath_Track_Items_Relics', "TOGGLE", "true", "potp_ov_set_track_items_relics", "");
	s.Add('ProgressOnThePath_Track_Items_Sets', "TOGGLE", "true", "potp_ov_set_track_items_sets", "");
	s.Add('ProgressOnThePath_Track_Items_Witcher', "TOGGLE", "true", "potp_ov_set_track_items_witcher", "");
	s.Add('ProgressOnThePath_Track_Items_Horse', "TOGGLE", "true", "potp_ov_set_track_items_horse", "");
	s.Add('ProgressOnThePath_Track_Items_Trophies', "TOGGLE", "true", "potp_ov_set_track_items_trophies", "");
	s.Add('ProgressOnThePath_Track_Items_Mods', "TOGGLE", "true", "potp_ov_set_track_items_mods", "");
	s.Separator();
	s.Add('ProgressOnThePath_Track_Gwent_Monsters', "TOGGLE", "true", "potp_ov_set_track_gwent_monsters", "");
	s.Add('ProgressOnThePath_Track_Gwent_Nilfgaard', "TOGGLE", "true", "potp_ov_set_track_gwent_nilfgaard", "");
	s.Add('ProgressOnThePath_Track_Gwent_North', "TOGGLE", "true", "potp_ov_set_track_gwent_north", "");
	s.Add('ProgressOnThePath_Track_Gwent_Scoiatael', "TOGGLE", "true", "potp_ov_set_track_gwent_scoiatael", "");
	s.Add('ProgressOnThePath_Track_Gwent_Skellige', "TOGGLE", "true", "potp_ov_set_track_gwent_skellige", "");
	s.Add('ProgressOnThePath_Track_Gwent_Neutral', "TOGGLE", "true", "potp_ov_set_track_gwent_neutral", "");
	s.Separator();
	s.Add('ProgressOnThePath_Track_Bestiary', "TOGGLE", "true", "potp_ov_set_track_bestiary", "");
	s.Separator();
	s.Add('ProgressOnThePath_Track_Library_Lore', "TOGGLE", "false", "potp_ov_set_track_library_lore", "");
	s.Add('ProgressOnThePath_Track_Library_Tomes', "TOGGLE", "false", "potp_ov_set_track_library_tomes", "");
	s.Add('ProgressOnThePath_Track_Library_Journals', "TOGGLE", "false", "potp_ov_set_track_library_journals", "");
	s.Add('ProgressOnThePath_Track_Library_Letters', "TOGGLE", "false", "potp_ov_set_track_library_letters", "");
	s.Add('ProgressOnThePath_Track_Library_Notices', "TOGGLE", "false", "potp_ov_set_track_library_notices", "");
	s.Add('ProgressOnThePath_Track_Library_Notes', "TOGGLE", "false", "potp_ov_set_track_library_notes", "");
}

function PotP_SettingOptions(setting: CPotP_Setting, key_prefix: string, count: int)
{
	var Idx : int;

	for (Idx = 0; Idx < count; Idx += 1)
	{
		setting.options.PushBack(key_prefix + IntToString(Idx));
	}
}

function PotP_PresetNotifications(preset: CPotP_SettingPreset, size: string, colour: string, time: string, full: string, back: string, misc: string)
{
	PotP_PresetEntry(preset, 'ProgressOnThePath_GlobalNotification_Size', size);
	PotP_PresetEntry(preset, 'ProgressOnThePath_GlobalNotification_Font', colour);
	PotP_PresetEntry(preset, 'ProgressOnThePath_GlobalNotification_Time', time);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_Quest', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_World', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_Items', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_Gwent', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_Event', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_FullNotification_Nulls', full);
	PotP_PresetEntry(preset, 'ProgressOnThePath_BackNotification_Quest', back);
	PotP_PresetEntry(preset, 'ProgressOnThePath_BackNotification_World', back);
	PotP_PresetEntry(preset, 'ProgressOnThePath_BackNotification_Items', back);
	PotP_PresetEntry(preset, 'ProgressOnThePath_BackNotification_Gwent', back);
	PotP_PresetEntry(preset, 'ProgressOnThePath_BackNotification_Event', back);
	PotP_PresetEntry(preset, 'ProgressOnThePath_MiscNotification_Event', misc);
	PotP_PresetEntry(preset, 'ProgressOnThePath_MiscNotification_Enter', misc);
	PotP_PresetEntry(preset, 'ProgressOnThePath_MiscNotification_Missable', misc);
	PotP_PresetEntry(preset, 'ProgressOnThePath_MiscNotification_Tracker', misc);
	PotP_PresetEntry(preset, 'ProgressOnThePath_ShowUpdateNotifications', misc);
}

function PotP_PresetEntry(preset: CPotP_SettingPreset, id: name, value: string)
{
	preset.ids.PushBack(id);
	preset.values.PushBack(value);
}

//---------------------------------------------------
//-- Tracked Contents -------------------------------
//---------------------------------------------------

// The setting an entry's kind is tracked by (Tracked Contents, above)
function PotP_TrackSetting(tracked: CPotP_Entry) : name
{
	switch (tracked.category)
	{
	case PotP_A_Event:
		return 'ProgressOnThePath_Track_Event';

	case PotP_A_Quest:
		switch (tracked.filter)
		{
		case PotP_I_Mains:	return 'ProgressOnThePath_Track_Quest_Main';
		case PotP_I_Sides:	return 'ProgressOnThePath_Track_Quest_Side';
		case PotP_I_Conts:	return 'ProgressOnThePath_Track_Quest_Contract';
		case PotP_I_Scavs:	return 'ProgressOnThePath_Track_Quest_Scavenger';
		case PotP_I_Hunts:	return 'ProgressOnThePath_Track_Quest_Treasure';
		case PotP_I_Event:	return 'ProgressOnThePath_Track_Event';
		}
		return '';

	case PotP_A_World:
		switch (tracked.filter)
		{
		case PotP_I_Camps:	return 'ProgressOnThePath_Track_World_Camps';
		case PotP_I_MDens:	return 'ProgressOnThePath_Track_World_Dens';
		case PotP_I_Nests:	return 'ProgressOnThePath_Track_World_Nests';
		case PotP_I_Place:	return 'ProgressOnThePath_Track_World_Places';
		case PotP_I_Signs:	return 'ProgressOnThePath_Track_World_Signs';
		case PotP_I_Sites:	return 'ProgressOnThePath_Track_World_Sites';
		case PotP_I_Guard:	return 'ProgressOnThePath_Track_World_Guarded';
		case PotP_I_Distr:	return 'ProgressOnThePath_Track_World_Distress';
		case PotP_I_Knigh:	return 'ProgressOnThePath_Track_World_Knights';
		case PotP_I_Infes:	return 'ProgressOnThePath_Track_World_Infested';
		case PotP_I_Hanse:	return 'ProgressOnThePath_Track_World_Hanse';
		case PotP_I_Stash:	return 'ProgressOnThePath_Track_World_Stashes';
		case PotP_I_Cache:	return 'ProgressOnThePath_Track_World_Caches';
		case PotP_I_Spoil:	return 'ProgressOnThePath_Track_World_Spoils';
		case PotP_I_Hiddn:	return 'ProgressOnThePath_Track_World_Hidden';
		}
		return '';

	case PotP_A_Items:
		switch (tracked.filter)
		{
		case PotP_I_Relic:
			switch (tracked.sub_filter)
			{
			case PotP_U_Silve:	return 'ProgressOnThePath_Track_Items_Silver';
			case PotP_U_Steel:	return 'ProgressOnThePath_Track_Items_Steel';
			case PotP_U_Cross:	return 'ProgressOnThePath_Track_Items_Crossbows';
			}
			return 'ProgressOnThePath_Track_Items_Relics';
		case PotP_I_Gears:	return 'ProgressOnThePath_Track_Items_Sets';
		case PotP_I_Witch:	return 'ProgressOnThePath_Track_Items_Witcher';
		case PotP_I_Horse:	return 'ProgressOnThePath_Track_Items_Horse';
		case PotP_I_Troph:	return 'ProgressOnThePath_Track_Items_Trophies';
		}
		// What mods' item packs add
		return 'ProgressOnThePath_Track_Items_Mods';

	case PotP_A_Gwent:
		switch (tracked.sub_filter)
		{
		case PotP_I_Monst:	return 'ProgressOnThePath_Track_Gwent_Monsters';
		case PotP_I_Nilfg:	return 'ProgressOnThePath_Track_Gwent_Nilfgaard';
		case PotP_I_North:	return 'ProgressOnThePath_Track_Gwent_North';
		case PotP_I_Scoia:	return 'ProgressOnThePath_Track_Gwent_Scoiatael';
		case PotP_I_Skell:	return 'ProgressOnThePath_Track_Gwent_Skellige';
		case PotP_I_Neutr:	return 'ProgressOnThePath_Track_Gwent_Neutral';
		}
		return '';

	case PotP_A_Bestiary:
		return 'ProgressOnThePath_Track_Bestiary';

	case PotP_A_Library:
		switch (tracked.shelf)
		{
		case 0:	return 'ProgressOnThePath_Track_Library_Lore';
		case 1:	return 'ProgressOnThePath_Track_Library_Tomes';
		case 2:	return 'ProgressOnThePath_Track_Library_Journals';
		case 3:	return 'ProgressOnThePath_Track_Library_Letters';
		case 4:	return 'ProgressOnThePath_Track_Library_Notices';
		}
		return 'ProgressOnThePath_Track_Library_Notes';
	}
	return '';
}

// A kind with no toggle of its own is tracked
function PotP_IsTracked(tracked: CPotP_Entry) : bool
{
	return PotP_GetSetting(PotP_TrackSetting(tracked)) != "false";
}

// Every toggle's value, to tell when one has changed
function PotP_TrackedSettings() : string
{
	var store	: CPotP_Settings = PotP_Settings();
	var result	: string;
	var Idx		: int;

	for (Idx = 0; Idx < store.settings.Size(); Idx += 1)
	{
		if (store.settings[Idx].group == 'ProgressOnThePath_TrackedContents' && IsNameValid(store.settings[Idx].id))
		{
			result += store.settings[Idx].value + "|";
		}
	}
	return result;
}

//---------------------------------------------------
//-- From and to the overlay ------------------------
//---------------------------------------------------

// The overlay looks for this before it sends anything, so older scripts don't get exec lines they don't know
function PotP_SettingsWanted() : bool
{
	return true;
}

// The overlay checks this a few times a second, and saves when it moves
function PotP_SettingsVersion() : int
{
	return PotP_Settings().version;
}

// Every setting as id=value, a line each, for the overlay to save
function PotP_SettingsValues() : string
{
	var store	: CPotP_Settings = PotP_Settings();
	var result	: string;
	var Idx		: int;

	for (Idx = 0; Idx < store.settings.Size(); Idx += 1)
	{
		if (IsNameValid(store.settings[Idx].id))
		{
			result += NameToString(store.settings[Idx].id) + "=" + store.settings[Idx].value + "\n";
		}
	}
	return result;
}

exec function potp_setting(id: name, value: string)
{
	var setting : CPotP_Setting = PotP_Settings().Find(id);

	// As saved: not a change to save again
	if (setting)
	{
		setting.value = PotPAch_Decode(value);
	}
}

exec function potp_settings_end(count: int)
{
	var store	: CPotP_Settings = PotP_Settings();
	var main	: CPotP_Main;

	store.loaded = true;
	PotP_Log("Settings from the overlay: " + IntToString(count), 'Settings');
	// What's tracked may be among them, and the catalog built already
	if (thePlayer)
	{
		main = PotP_Get();
		if (main && main.catalog.is_ready)
		{
			main.catalog.ApplyTracking();
		}
	}
}
