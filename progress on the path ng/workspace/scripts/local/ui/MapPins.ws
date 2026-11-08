//---------------------------------------------------
//-- Map Pins ---------------------------------------
//---------------------------------------------------
// PotP's own event map pins, on the world map and the minimap. Built on the map pin code
// from Shared Utils (by Faen90 and Aeltoth), brought in so PotP no longer needs it.

class CPotP_MapPin
{
	var tag				: string;
	var label			: string;
	var description		: string;
	var type			: string;
	var filtered_type	: string;
	var position		: Vector;
	var radius			: float;
	var region			: string;
	var from_hour		: int;
	var to_hour			: int;

	//---------------------------------------------------

	public function IsVisibleAtHour(hour: int) : bool
	{
		if (from_hour < 0 || to_hour < 0 || from_hour == to_hour)
		{
			return true;
		}
		if (from_hour < to_hour)
		{
			return hour >= from_hour && hour < to_hour;
		}
		// The hours run past midnight.
		return hour >= from_hour || hour < to_hour;
	}
}

//---------------------------------------------------

class CPotP_MapPins
{
	var master			: CPotP_Main;
	var pins			: array<CPotP_MapPin>;

	// The ids of the pins on the minimap now, and the area and hour they were chosen for.
	var minimap_ids		: array<int>;
	var minimap_area	: name;
	var minimap_hour	: int;
		default minimap_hour = -1;

	// The ids of the engine's own pins are small numbers or name hashes. Ours start far above the small ones.
	var pin_id_base	: int;
		default pin_id_base = 2080000000;

	var tag_prefix		: string;
		default tag_prefix = "PotP_";

	//---------------------------------------------------

	public function Initialise(main: CPotP_Main)
	{
		master = main;
	}

	//---------------------------------------------------

	public function Refresh()
	{
		var events	: array<CPotP_Entry> = master.catalog.event_entries;
		var radius	: float;
		var type	: string;
		var Idx		: int;

		pins.Clear();

		if (PotP_SettingFlag('ProgressOnThePath_EventMapPins_ShowMapPins'))
		{
			radius = (float) PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinRadius');
			type = GetPinType();

			for (Idx = 0; Idx < events.Size(); Idx += 1)
			{
				if (events[Idx].IsDone() || events[Idx].status == PotP_S_Missed || !PotP_IsEventUnlocked(events[Idx]))
				{
					continue;
				}
				pins.PushBack(NewPin(events[Idx], type, radius));
			}
		}

		UpdateMinimap(true);
	}

	//---------------------------------------------------

	public function RemovePin(tracked: CPotP_Entry)
	{
		var pin_tag	: string = tag_prefix + tracked.uuid;
		var Idx		: int;

		for (Idx = pins.Size() - 1; Idx >= 0; Idx -= 1)
		{
			if (pins[Idx].tag == pin_tag)
			{
				pins.Erase(Idx);
			}
		}
		UpdateMinimap(true);
	}

	//---------------------------------------------------

	private function NewPin(tracked: CPotP_Entry, type: string, radius: float) : CPotP_MapPin
	{
		var pin : CPotP_MapPin = new CPotP_MapPin in this;

		pin.tag				= tag_prefix + tracked.uuid;
		pin.label			= GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Name");
		pin.description		= GetDescription(tracked);
		pin.type			= type;
		pin.filtered_type	= "QuestVermentino";
		pin.position		= tracked.position;
		pin.radius			= radius;
		pin.region			= tracked.map_region;
		pin.from_hour		= tracked.from_hour;
		pin.to_hour			= tracked.to_hour;
		return pin;
	}

	//---------------------------------------------------
	//-- World Map --------------------------------------
	//---------------------------------------------------

	// Adds the pins for the area the world map is showing, as the map builds its pins.
	public function AddToWorldMap(out flash_array: CScriptedFlashArray, storage: CScriptedFlashValueStorage, shown_area: name)
	{
		var map_manager		: CCommonMapManager = theGame.GetCommonMapManager();
		var flash_object	: CScriptedFlashObject;
		var shown_region	: string = PotP_NormaliseRegion(NameToString(shown_area));
		var hour			: int = GameTimeHours(theGame.GetGameTime());
		var pin				: CPotP_MapPin;
		var Idx				: int;

		for (Idx = 0; Idx < pins.Size(); Idx += 1)
		{
			pin = pins[Idx];

			if (pin.region != shown_region || !pin.IsVisibleAtHour(hour))
			{
				continue;
			}

			flash_object = storage.CreateTempFlashObject("red.game.witcher3.data.StaticMapPinData");
			flash_object.SetMemberFlashUInt(	"id",				pin_id_base + Idx);
			flash_object.SetMemberFlashUInt(	"areaId",			NameToFlashUInt(shown_area));
			flash_object.SetMemberFlashUInt(	"journalAreaId",	NameToFlashUInt(map_manager.GetJournalAreaByPosition(shown_area, pin.position)));
			flash_object.SetMemberFlashNumber(	"posX",				pin.position.X);
			flash_object.SetMemberFlashNumber(	"posY",				pin.position.Y);
			flash_object.SetMemberFlashString(	"type",				pin.type);
			flash_object.SetMemberFlashString(	"filteredType",		pin.filtered_type);
			flash_object.SetMemberFlashString(	"label",			pin.label);
			flash_object.SetMemberFlashString(	"description",		pin.description);
			flash_object.SetMemberFlashNumber(	"radius",			RoundF(pin.radius));
			flash_object.SetMemberFlashNumber(	"rotation",			0);
			flash_object.SetMemberFlashBool(	"isQuest",			false);
			flash_object.SetMemberFlashBool(	"isFastTravel",		false);
			flash_object.SetMemberFlashBool(	"isPlayer",			false);
			flash_object.SetMemberFlashBool(	"isUserPin",		false);
			flash_object.SetMemberFlashBool(	"highlighted",		false);
			flash_object.SetMemberFlashBool(	"tracked",			false);
			flash_object.SetMemberFlashBool(	"hidden",			false);
			flash_array.PushBackFlashObject(flash_object);
		}
	}

	//---------------------------------------------------
	//-- Minimap ----------------------------------------
	//---------------------------------------------------

	// Called every second by the world watcher: redraws the minimap pins when the area or the hour changes.
	public function Tick()
	{
		if (theGame.GetCommonMapManager().GetCurrentArea() != minimap_area || GameTimeHours(theGame.GetGameTime()) != minimap_hour)
		{
			UpdateMinimap(true);
		}
	}

	//---------------------------------------------------

	// The minimap has just been set up, so the pins it had are gone.
	public function OnMinimapReady()
	{
		minimap_ids.Clear();
		UpdateMinimap(false);
	}

	//---------------------------------------------------

	private function UpdateMinimap(remove_old: bool)
	{
		var flash_module	: CScriptedFlashSprite = GetMinimapFlash();
		var add_pin			: CScriptedFlashFunction;
		var move_pin		: CScriptedFlashFunction;
		var delete_pin		: CScriptedFlashFunction;
		var region			: string;
		var hour			: int;
		var pin				: CPotP_MapPin;
		var pin_id			: int;
		var Idx				: int;

		minimap_area = theGame.GetCommonMapManager().GetCurrentArea();
		minimap_hour = GameTimeHours(theGame.GetGameTime());

		if (!flash_module)
		{
			minimap_ids.Clear();
			return;
		}

		if (remove_old)
		{
			delete_pin = flash_module.GetMemberFlashFunction("DeleteMapPin");
			for (Idx = 0; Idx < minimap_ids.Size(); Idx += 1)
			{
				delete_pin.InvokeSelfOneArg(FlashArgInt(minimap_ids[Idx]));
			}
		}
		minimap_ids.Clear();

		if (!PotP_SettingFlag('ProgressOnThePath_EventMapPins_ShowOnMinimap'))
		{
			return;
		}

		add_pin = flash_module.GetMemberFlashFunction("AddMapPin");
		move_pin = flash_module.GetMemberFlashFunction("MoveMapPin");
		region = PotP_NormaliseRegion(NameToString(minimap_area));

		for (Idx = 0; Idx < pins.Size(); Idx += 1)
		{
			pin = pins[Idx];

			if (pin.region != region || !pin.IsVisibleAtHour(minimap_hour))
			{
				continue;
			}

			pin_id = pin_id_base + Idx;

			// id, tag, type, radius, can be pointed at by arrows, priority, is quest, is user pin, highlighted
			add_pin.InvokeSelfNineArgs(
				FlashArgInt(pin_id),
				FlashArgString(pin.tag),
				FlashArgString(pin.type),
				FlashArgNumber(pin.radius),
				FlashArgBool(false),
				FlashArgInt(0),
				FlashArgBool(false),
				FlashArgBool(false),
				FlashArgBool(false));

			// id, x, y, z (the height, for the minimap's up and down arrows)
			move_pin.InvokeSelfFourArgs(
				FlashArgInt(pin_id),
				FlashArgNumber(pin.position.X),
				FlashArgNumber(pin.position.Y),
				FlashArgNumber(pin.position.Z));

			minimap_ids.PushBack(pin_id);
		}

		PotP_Log(minimap_ids.Size() + " event pins on the minimap in " + region + " at " + minimap_hour + ":00", 'MapPins');
	}

	//---------------------------------------------------

	private function GetMinimapFlash() : CScriptedFlashSprite
	{
		var hud		: CR4ScriptedHud;
		var minimap	: CR4HudModuleMinimap2;

		hud = (CR4ScriptedHud)theGame.GetHud();
		if (!hud)
		{
			return NULL;
		}
		minimap = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
		if (!minimap)
		{
			return NULL;
		}
		return minimap.GetModuleFlash();
	}

	//---------------------------------------------------

	private function GetDescription(tracked: CPotP_Entry) : string
	{
		if (PotP_SettingFlag('ProgressOnThePath_EventMapPins_MapPinDescription'))
		{
			return GetLocStringByKeyExt(tracked.entry_name + "_Description");
		}
		return GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Description");
	}

	//---------------------------------------------------

	private function GetPinType() : string
	{
		switch ((int) PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinType'))
		{
		case 0:		return "QuestAvailable";
		case 2:		return "QuestAvailableBaW";
		case 3:		return "StoryQuest";
		case 4:		return "NotDiscoveredPOI";
		default:	return "QuestAvailableHoS";
		}
	}
}

//---------------------------------------------------

// The region names the event definitions use, from the map's area names.
function PotP_NormaliseRegion(area: string) : string
{
	switch (area)
	{
	case "novigrad":
	case "AN_Velen":
	case "AN_NMLandNovigrad":
		return "no_mans_land";

	case "prolog_village_winter":
	case "AN_Prologue_Village_Winter":
	case "AN_Prologue_Village":
		return "prolog_village";

	case "skellige":
	case "AN_Skellige_ArdSkellig":
		return "skellige";

	case "bob":
	case "AN_Bob":
	case "AN_Dlc_Bob":
		return "bob";

	case "kaer_morhen":
	case "AN_Kaer_Morhen":
		return "kaer_morhen";
	}
	return area;
}

//---------------------------------------------------

function PotP_GetMapPins() : CPotP_MapPins
{
	var main : CPotP_Main = thePlayer.potp_main;

	if (!main || !main.catalog || !main.catalog.is_ready)
	{
		return NULL;
	}
	return main.map_pins;
}

//---------------------------------------------------

@wrapMethod(CR4MapMenu) function UpdateUserMapPins(out flashArray: CScriptedFlashArray, indexToUpdate: int)
{
	var map_pins : CPotP_MapPins;

	wrappedMethod(flashArray, indexToUpdate);

	// -1 is the full build of the map's pins; other values update one user pin.
	if (indexToUpdate <= -1)
	{
		map_pins = PotP_GetMapPins();
		if (map_pins)
		{
			map_pins.AddToWorldMap(flashArray, GetMenuFlashValueStorage(), m_shownArea);
		}
	}
}

//---------------------------------------------------

@wrapMethod(CR4HudModuleMinimap2) function OnConfigUI()
{
	var result		: bool;
	var map_pins	: CPotP_MapPins;

	result = wrappedMethod();

	map_pins = PotP_GetMapPins();
	if (map_pins)
	{
		map_pins.OnMinimapReady();
	}
	return result;
}
