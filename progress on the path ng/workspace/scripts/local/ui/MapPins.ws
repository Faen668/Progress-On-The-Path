//---------------------------------------------------
//-- Map Pins ---------------------------------------
//---------------------------------------------------

class CPotP_MapPins
{
	var master		: CPotP_Main;

	var tag_prefix	: string;
		default tag_prefix = "PotP_";

	//---------------------------------------------------

	public function Initialise(main: CPotP_Main)
	{
		master = main;
	}

	//---------------------------------------------------

	public function Refresh()
	{
		var builder	: SU_MapPinsBuilder;
		var events	: array<CPotP_Entry> = master.catalog.event_entries;
		var Idx		: int;

		if (!PotP_SettingFlag('ProgressOnThePath_EventMapPins_ShowMapPins'))
		{
			SU_removeCustomPinByTagPrefix(tag_prefix);
			return;
		}

		builder = (new SU_MapPinsBuilder in master).tag_prefix(tag_prefix);

		for (Idx = 0; Idx < events.Size(); Idx += 1)
		{
			if (events[Idx].IsDone() || events[Idx].status == PotP_S_Missed || !PotP_IsEventUnlocked(events[Idx]))
			{
				continue;
			}

			builder = builder.pin()
				.tag				(events[Idx].uuid)
				.label				(GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Name"))
				.description		(GetDescription(events[Idx]))
				.type				(GetPinType())
				.filtered_type		("QuestVermentino")
				.radius				((int) PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinRadius'))
				.position			(events[Idx].position)
				.region				(events[Idx].map_region)
				.is_quest			(false)
				.appears_on_minimap	(false)
				.pointed_by_arrow	(false)
				.highlighted		(false)
				.visible_between	(events[Idx].from_hour, events[Idx].to_hour)
			.add();
		}

		// build() clears every pin with our prefix before adding the new set.
		builder.build();
	}

	//---------------------------------------------------

	public function RemovePin(tracked: CPotP_Entry)
	{
		SU_removeCustomPinByTag(tag_prefix + tracked.uuid);
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
