//---------------------------------------------------
//-- Dynamic Pins -----------------------------------
//---------------------------------------------------
// Builds world entries for map pin types that have no names of their own, such as
// Smugglers' Caches. Each is named after the nearest signpost or harbour, with a
// distance and compass direction, so it can be found even on open water.

// The name of the map pin whose name reads as this text, from every area's pins, or none
function PotP_FindPinName(text: string) : name
{
	var map_manager	: CCommonMapManager = theGame.GetCommonMapManager();
	var areas		: array<SAreaMapPinInfo> = map_manager.GetAreaMapPins();
	var pins		: array<SEntityMapPinInfo>;
	var Adx, Idx	: int;

	for (Adx = 0; Adx < areas.Size(); Adx += 1)
	{
		pins = map_manager.GetEntityMapPins(areas[Adx].worldPath);
		for (Idx = 0; Idx < pins.Size(); Idx += 1)
		{
			if (NameToString(pins[Idx].entityName) == text)
			{
				return pins[Idx].entityName;
			}
		}
	}
	return '';
}

//---------------------------------------------------

class CPotP_DynamicPins
{
	var anchor_names		: array<name>;
	var anchor_labels		: array<string>;
	var anchor_positions	: array<Vector>;

	//---------------------------------------------------

	public function Build(catalog: CPotP_Catalog, pin_type: name, uuid_prefix: string, header_prefix: string, filter_value: PotP_Preview_World_Filter)
	{
		var map_manager		: CCommonMapManager;
		var areas			: array<SAreaMapPinInfo>;
		var pins			: array<SEntityMapPinInfo>;
		var seen			: array<name>;
		var found			: array<CPotP_Entry>;
		var tracked			: CPotP_Entry;
		var region_value	: PotP_Preview_Region;
		var pin_name		: name;
		var title			: string;
		var nearest			: int;
		var Adx, Idx, Rdx	: int;

		map_manager = theGame.GetCommonMapManager();
		areas = map_manager.GetAreaMapPins();

		for (Adx = 0; Adx < areas.Size(); Adx += 1)
		{
			pins = map_manager.GetEntityMapPins(areas[Adx].worldPath);
			CollectAnchors(pins);

			for (Idx = 0; Idx < pins.Size(); Idx += 1)
			{
				pin_name = pins[Idx].entityName;

				if (pins[Idx].entityType != pin_type || seen.Contains(pin_name) || IsExcluded(pin_name) || IsTracked(catalog, pin_name))
				{
					continue;
				}
				seen.PushBack(pin_name);

				region_value = GetAreaRegion(areas[Adx].areaName);
				title = NameToString(pin_name);

				nearest = FindNearest(pins[Idx].entityPosition);
				if (nearest != -1)
				{
					region_value = GetAnchorRegion(catalog, anchor_names[nearest], region_value);
					title = FormatTitle(pins[Idx].entityPosition, nearest);
				}

				tracked = (new CPotP_Entry in catalog).Init(uuid_prefix + PotP_SanitizeUuid(NameToString(pin_name)), PotP_A_World, PotP_E_Primary, region_value, filter_value, 0);
				tracked.title = title;
				tracked.pin_name = pin_name;
				found.PushBack(tracked);
			}
		}

		// One section per region, in region order, so section positions stay stable.
		for (Rdx = 1; Rdx <= 8; Rdx += 1)
		{
			AddRegionSection(catalog, found, Rdx, uuid_prefix, header_prefix + IntToString(Rdx));
		}
	}

	//---------------------------------------------------

	private function AddRegionSection(catalog: CPotP_Catalog, found: array<CPotP_Entry>, region_index: int, uuid_prefix: string, header_key: string)
	{
		var in_region	: array<CPotP_Entry>;
		var Idx			: int;

		for (Idx = 0; Idx < found.Size(); Idx += 1)
		{
			if ((int)found[Idx].region == region_index)
			{
				in_region.PushBack(found[Idx]);
			}
		}

		if (in_region.Size() == 0)
		{
			return;
		}

		catalog.BeginSection(PotP_Book_World, header_key, PotP_A_World, uuid_prefix);
		for (Idx = 0; Idx < in_region.Size(); Idx += 1)
		{
			catalog.AddPrepared(in_region[Idx]);
		}
		catalog.EndSection();
	}

	//---------------------------------------------------
	// Signposts and harbours of one world that have a name in the current language.

	private function CollectAnchors(pins: array<SEntityMapPinInfo>)
	{
		var label	: string;
		var Idx		: int;

		anchor_names.Clear();
		anchor_labels.Clear();
		anchor_positions.Clear();

		for (Idx = 0; Idx < pins.Size(); Idx += 1)
		{
			if (pins[Idx].entityType != 'RoadSign' && pins[Idx].entityType != 'Harbor')
			{
				continue;
			}

			label = PotP_CleanTitle(PotP_LocOrDefault(StrLower("map_location_" + NameToString(pins[Idx].entityName)), ""));
			if (label == "")
			{
				continue;
			}

			anchor_names.PushBack(pins[Idx].entityName);
			anchor_labels.PushBack(label);
			anchor_positions.PushBack(pins[Idx].entityPosition);
		}
	}

	//---------------------------------------------------

	private function FindNearest(position: Vector) : int
	{
		var distance	: float;
		var best		: float;
		var nearest		: int;
		var Idx			: int;

		nearest = -1;
		for (Idx = 0; Idx < anchor_positions.Size(); Idx += 1)
		{
			distance = VecDistance2D(position, anchor_positions[Idx]);
			if (nearest == -1 || distance < best)
			{
				best = distance;
				nearest = Idx;
			}
		}
		return nearest;
	}

	//---------------------------------------------------

	private function FormatTitle(position: Vector, anchor_index: int) : string
	{
		var title		: string;
		var distance	: int;

		// Rounded to 10m: precise enough to tell neighbours apart, without false accuracy.
		distance = RoundMath(VecDistance2D(position, anchor_positions[anchor_index]) / 10.0) * 10;

		title = PotP_LocOrDefault("potp_pin_title", "[PLACE] - [DIST]m [DIR]");
		title = StrReplace(title, "[PLACE]", anchor_labels[anchor_index]);
		title = StrReplace(title, "[DIST]", IntToString(distance));
		title = StrReplace(title, "[DIR]", GetDirection(position.X - anchor_positions[anchor_index].X, position.Y - anchor_positions[anchor_index].Y));
		return title;
	}

	//---------------------------------------------------
	// Eight compass points. North is +Y and east is +X on the world map.

	private function GetDirection(east: float, north: float) : string
	{
		var diagonal	: float = 0.4142; // tan(22.5 degrees)
		var index		: int;

		if (AbsF(east) < AbsF(north) * diagonal)
		{
			if (north > 0)	{ index = 0; }
			else			{ index = 4; }
		}
		else if (AbsF(north) < AbsF(east) * diagonal)
		{
			if (east > 0)	{ index = 2; }
			else			{ index = 6; }
		}
		else if (north > 0)
		{
			if (east > 0)	{ index = 1; }
			else			{ index = 7; }
		}
		else
		{
			if (east > 0)	{ index = 3; }
			else			{ index = 5; }
		}

		switch (index)
		{
		case 0:		return PotP_LocOrDefault("potp_pin_dir_0", "N");
		case 1:		return PotP_LocOrDefault("potp_pin_dir_1", "NE");
		case 2:		return PotP_LocOrDefault("potp_pin_dir_2", "E");
		case 3:		return PotP_LocOrDefault("potp_pin_dir_3", "SE");
		case 4:		return PotP_LocOrDefault("potp_pin_dir_4", "S");
		case 5:		return PotP_LocOrDefault("potp_pin_dir_5", "SW");
		case 6:		return PotP_LocOrDefault("potp_pin_dir_6", "W");
		default:	return PotP_LocOrDefault("potp_pin_dir_7", "NW");
		}
	}

	//---------------------------------------------------

	private function IsTracked(catalog: CPotP_Catalog, pin_name: name) : bool
	{
		var Idx : int;

		for (Idx = 0; Idx < catalog.world_entries.Size(); Idx += 1)
		{
			if (catalog.world_entries[Idx].pin_name == pin_name || catalog.world_entries[Idx].alt_pin_name == pin_name)
			{
				return true;
			}
		}
		return false;
	}

	//---------------------------------------------------
	// Hidden treasure pins that aren't places of their own. Most are only quest objectives:
	// they have no discovery trigger, so exploring never reveals them, and their quest hides
	// them again once found. Taken from the world files (see map-pin-report.txt).

	private function IsExcluded(pin_name: name) : bool
	{
		switch (pin_name)
		{
		// Feline, Griffin and Ursine gear hunts, Velen and Novigrad.
		case 'th1003_mp_armor_set':
		case 'th1003_mp_crossbow':
		case 'th1003_mp_silver_sword':
		case 'th1003_mp_steel_sword':
		case 'th1005_mp_armor_set':
		case 'th1005_mp_silver_sword':
		case 'th1005_mp_steel_sword':
		case 'th1007_mp_upgrade_2a':
		case 'th1007_mp_upgrade_2b':
		case 'th1007_mp_upgrade_2c':
		case 'th1007_mp_upgrade_3a':
		case 'th1007_mp_upgrade_3b':
		case 'th1007_mp_upgrade_3c':

		// Griffin and Ursine gear hunts, Skellige.
		case 'th1005_mp_upgrade_2a':
		case 'th1005_mp_upgrade_2b':
		case 'th1005_mp_upgrade_2c':
		case 'th1005_mp_upgrade_3a':
		case 'th1005_mp_upgrade_3c':
		case 'th1007_mp_armor_set':
		case 'th1007_mp_crossbow':
		case 'th1007_mp_silver_sword':
		case 'th1007_mp_steel_sword':
		case 'th1007_mp_upgrade_1':
		case 'th1007_mp_upgrade_1b':
		case 'th1007_mp_upgrade_1c':
		case 'th1007_mp_upgrade_1d':
		case 'th1007_mp_upgrade_1e':
		case 'th1007_mp_upgrade_1f':

		// Wolven gear hunt, Kaer Morhen.
		case 'th1009_mp_upgrade_1b_a2':
		case 'th1009_mp_upgrade_1b_b2':
		case 'th1009_mp_upgrade_1b_c2':
		case 'th1009_mp_upgrade_2b_a2':
		case 'th1009_mp_upgrade_2b_b2':
		case 'th1009_mp_upgrade_2b_c2':

		// Key to the Chest, and the treasure notes for the sk55 and sk58 caves, Skellige.
		case 'mq2006_chest1_mappin':
		case 'mq2006_chest2_mappin':
		case 'mp_lw_sk55_treasure_hunt':
		case 'mp_lw_sk58_treasure_hunt':

		// The later state of Toussaint bandit camp 'poi_gor_d_18_mp', which counts for both.
		case 'poi_gor_d_18_mp_post':
			return true;

		default:
			return false;
		}
	}

	//---------------------------------------------------
	// Velen and Novigrad share one world, so the nearest signpost decides between them.

	private function GetAnchorRegion(catalog: CPotP_Catalog, anchor_name: name, fallback: PotP_Preview_Region) : PotP_Preview_Region
	{
		var Idx : int;

		for (Idx = 0; Idx < catalog.world_entries.Size(); Idx += 1)
		{
			if (catalog.world_entries[Idx].pin_name == anchor_name)
			{
				return catalog.world_entries[Idx].region;
			}
		}
		return fallback;
	}

	//---------------------------------------------------

	private function GetAreaRegion(area: name) : PotP_Preview_Region
	{
		switch (area)
		{
		case 'AN_Prologue_Village':
		case 'AN_Prologue_Village_Winter':
			return PotP_R_WO;

		case 'AN_Skellige_ArdSkellig':
			return PotP_R_SK;

		case 'AN_Kaer_Morhen':
			return PotP_R_KM;

		case 'AN_Bob':
		case 'AN_Dlc_Bob':
			return PotP_R_TO;

		case 'AN_Wyzima':
			return PotP_R_VI;

		case 'AN_Spiral':
			return PotP_R_TS;

		default:
			return PotP_R_VE;
		}
	}
}
