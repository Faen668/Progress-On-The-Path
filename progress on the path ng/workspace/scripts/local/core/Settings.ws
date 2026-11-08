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
	var store : CPotP_Settings = PotP_Settings();

	store.loaded = true;
	PotP_Log("Settings from the overlay: " + IntToString(count), 'Settings');
}
