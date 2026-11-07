//---------------------------------------------------
//-- Notifications ----------------------------------
//---------------------------------------------------

class CPotP_NoticeList
{
	var texts	: array<string>;
	var icons	: array<string>;
	var counts	: array<int>;

	//---------------------------------------------------

	public function Size() : int
	{
		return texts.Size();
	}

	//---------------------------------------------------

	public function Clear()
	{
		texts.Clear();
		icons.Clear();
		counts.Clear();
	}

	//---------------------------------------------------

	public function Contains(text_value: string) : bool
	{
		return texts.Contains(text_value);
	}

	//---------------------------------------------------

	public function Add(text_value: string, icon_path: string)
	{
		texts.PushBack(text_value);
		icons.PushBack(icon_path);
		counts.PushBack(1);
	}

	//---------------------------------------------------

	public function Increment(text_value: string, icon_path: string)
	{
		var Idx : int = texts.FindFirst(text_value);

		if (Idx == -1)
		{
			Add(text_value, icon_path);
			return;
		}
		counts[Idx] = counts[Idx] + 1;
	}

	//---------------------------------------------------

	public function Sort()
	{
		var current_text	: string;
		var current_icon	: string;
		var current_count	: int;
		var Idx, Jdx		: int;

		for (Idx = 1; Idx < texts.Size(); Idx += 1)
		{
			current_text = texts[Idx];
			current_icon = icons[Idx];
			current_count = counts[Idx];
			Jdx = Idx - 1;

			while (Jdx >= 0)
			{
				if (StrCmp(texts[Jdx], current_text) <= 0)
				{
					break;
				}
				texts[Jdx + 1] = texts[Jdx];
				icons[Jdx + 1] = icons[Jdx];
				counts[Jdx + 1] = counts[Jdx];
				Jdx -= 1;
			}

			texts[Jdx + 1] = current_text;
			icons[Jdx + 1] = current_icon;
			counts[Jdx + 1] = current_count;
		}
	}
}

//---------------------------------------------------

class CPotP_Notifications
{
	var master				: CPotP_Main;

	var summary_quest		: CPotP_NoticeList;
	var summary_world		: CPotP_NoticeList;
	var summary_items		: CPotP_NoticeList;

	var background_quest	: CPotP_NoticeList;
	var background_world	: CPotP_NoticeList;
	var background_items	: CPotP_NoticeList;
	var background_overflow	: int;

	var background_limit	: int;
		default background_limit = 20;

	// Waiting for the overlay to take them and draw them. Only the latest are kept, in case it isn't loaded.
	var overlay_messages	: array<string>;
	var overlay_limit		: int;
		default overlay_limit = 20;

	//---------------------------------------------------

	public function Initialise(main: CPotP_Main)
	{
		master = main;

		summary_quest		= new CPotP_NoticeList in this;
		summary_world		= new CPotP_NoticeList in this;
		summary_items		= new CPotP_NoticeList in this;
		background_quest	= new CPotP_NoticeList in this;
		background_world	= new CPotP_NoticeList in this;
		background_items	= new CPotP_NoticeList in this;
	}

	//---------------------------------------------------
	//-- Summary ----------------------------------------
	//---------------------------------------------------

	public function ResetSummary()
	{
		summary_quest.Clear();
		summary_world.Clear();
		summary_items.Clear();
	}

	//---------------------------------------------------

	public function AddToSummary(tracked: CPotP_Entry)
	{
		switch (tracked.category)
		{
		case PotP_A_Quest:
			if (PotP_SettingFlag('ProgressOnThePath_FullNotification_Quest'))
			{
				summary_quest.Increment(GetQuestLine(tracked), GetIcon(tracked));
			}
			break;

		case PotP_A_Event:
			if (PotP_SettingFlag('ProgressOnThePath_FullNotification_Event'))
			{
				summary_quest.Increment(GetQuestLine(tracked), GetIcon(tracked));
			}
			break;

		case PotP_A_World:
			if (PotP_SettingFlag('ProgressOnThePath_FullNotification_World'))
			{
				summary_world.Increment(GetWorldLine(tracked.filter), GetIcon(tracked));
			}
			break;

		case PotP_A_Items:
			if (PotP_SettingFlag('ProgressOnThePath_FullNotification_Items'))
			{
				summary_items.Increment(GetItemsLine(tracked.filter), GetIcon(tracked));
			}
			break;

		case PotP_A_Gwent:
			if (PotP_SettingFlag('ProgressOnThePath_FullNotification_Gwent'))
			{
				summary_items.Increment(GetItemsLine(tracked.filter), GetIcon(tracked));
			}
			break;
		}
	}

	//---------------------------------------------------

	public function ShowSummary()
	{
		var body	: string;
		var total	: int = summary_quest.Size() + summary_world.Size() + summary_items.Size();

		if (!SummaryEnabled())
		{
			ResetSummary();
			return;
		}

		if (total == 0 && !PotP_SettingFlag('ProgressOnThePath_FullNotification_Nulls'))
		{
			return;
		}

		body = OverlayHead();
		if (total == 0)
		{
			body += OverlayLine(0, "", GetLocStringByKeyExt("PotP_NullMessage"));
		}
		body += OverlayCounted(summary_quest, 0) + OverlayCounted(summary_items, 1) + OverlayCounted(summary_world, 2);
		QueueForOverlay(body);
		ResetSummary();
	}

	//---------------------------------------------------

	private function SummaryEnabled() : bool
	{
		return PotP_SettingFlag('ProgressOnThePath_FullNotification_Quest')
			|| PotP_SettingFlag('ProgressOnThePath_FullNotification_World')
			|| PotP_SettingFlag('ProgressOnThePath_FullNotification_Items')
			|| PotP_SettingFlag('ProgressOnThePath_FullNotification_Gwent')
			|| PotP_SettingFlag('ProgressOnThePath_FullNotification_Event');
	}

	//---------------------------------------------------

	private function CountedText(lines: CPotP_NoticeList, Idx: int) : string
	{
		var line : string = IntToString(lines.counts[Idx]) + lines.texts[Idx];

		if (StrContains(line, "(DYNAMC_REPLACE_TROPHY)"))
		{
			if (lines.counts[Idx] == 1)
			{
				line = StrReplace(line, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER2"));
			}
			else
			{
				line = StrReplace(line, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER1"));
			}
		}

		if (lines.counts[Idx] == 1)
		{
			return StrReplace(line, "(DYNAMC_REPLACE)", "");
		}
		return StrReplace(line, "(DYNAMC_REPLACE)", GetLocStringByKeyExt("PotP_PLURAL_REPLACER"));
	}

	//---------------------------------------------------
	//-- Background -------------------------------------
	//---------------------------------------------------

	public function AddToBackground(tracked: CPotP_Entry)
	{
		switch (tracked.category)
		{
		case PotP_A_Quest:
			if (PotP_SettingFlag('ProgressOnThePath_BackNotification_Quest'))
			{
				AddUnique(background_quest, GetQuestUpdateText(tracked), GetIcon(tracked));
			}
			break;

		case PotP_A_Event:
			if (PotP_SettingFlag('ProgressOnThePath_BackNotification_Event'))
			{
				AddUnique(background_quest, GetQuestUpdateText(tracked), GetIcon(tracked));
			}
			break;

		case PotP_A_World:
			if (PotP_SettingFlag('ProgressOnThePath_BackNotification_World'))
			{
				AddUnique(background_world, GetWorldUpdatePrefix(tracked.filter) + tracked.title, GetIcon(tracked));
			}
			break;

		case PotP_A_Items:
			if (PotP_SettingFlag('ProgressOnThePath_BackNotification_Items'))
			{
				AddUnique(background_items, GetLocStringByKeyExt("PotP_NotificationLine_Updated") + tracked.title, GetIcon(tracked));
			}
			break;

		case PotP_A_Gwent:
			if (PotP_SettingFlag('ProgressOnThePath_BackNotification_Gwent'))
			{
				AddUnique(background_items, GetLocStringByKeyExt("PotP_NotificationLine_Updated") + tracked.title, GetIcon(tracked));
			}
			break;
		}
	}

	//---------------------------------------------------

	private function AddUnique(lines: CPotP_NoticeList, text_value: string, icon_path: string)
	{
		if (lines.Contains(text_value))
		{
			return;
		}

		if (background_quest.Size() + background_world.Size() + background_items.Size() >= background_limit)
		{
			background_overflow += 1;
			return;
		}
		lines.Add(text_value, icon_path);
	}

	//---------------------------------------------------

	public function FlushBackground()
	{
		var body : string;

		if (background_quest.Size() + background_world.Size() + background_items.Size() == 0)
		{
			return;
		}

		body = OverlayHead() + OverlayPlain(background_quest, 0) + OverlayPlain(background_items, 1) + OverlayPlain(background_world, 2);
		if (background_overflow > 0)
		{
			body += "\nM|" + IntToString(background_overflow);
		}
		QueueForOverlay(body);
		background_quest.Clear();
		background_world.Clear();
		background_items.Clear();
		background_overflow = 0;
	}

	//---------------------------------------------------
	//-- One-off messages -------------------------------
	//---------------------------------------------------

	public function ShowSingleUpdate(tracked: CPotP_Entry, value: int)
	{
		QueueForOverlay(OverlayHead() + OverlayLine(0, GetIcon(tracked), GetLocStringByKeyExt("PotP_Notification_SingleUpdate_" + IntToString(value)) + tracked.title));
	}

	//---------------------------------------------------

	public function ShowMissed(missed: array<CPotP_Entry>)
	{
		var body	: string;
		var Idx		: int;

		body = OverlayHead();
		for (Idx = 0; Idx < missed.Size(); Idx += 1)
		{
			body += OverlayLine(0, GetIcon(missed[Idx]), GetLocStringByKeyExt("PotP_Notification_SingleUpdate_3") + missed[Idx].title);
		}
		QueueForOverlay(body);
	}

	//---------------------------------------------------

	public function ShowMissableWarning(group: CPotP_Section, outstanding: array<CPotP_Entry>)
	{
		var list	: string;
		var body	: string;
		var Idx		: int;

		for (Idx = 0; Idx < outstanding.Size(); Idx += 1)
		{
			list += "<font color='#D79D3A'>" + outstanding[Idx].title + "</font><br/>";
		}

		body = GetLocStringByKeyExt("potp_missable_warning_body");
		body = StrReplace(body, "[QUEST]", group.cutoff.title);
		body = StrReplace(body, "[CUTOFF]", GetLocStringByKeyExt(group.header));
		body = StrReplace(body, "[LIST]", list);

		master.popup.ShowWarning(GetLocStringByKeyExt("potp_missable_warning_title"), body, "PotP_MissableWarning_" + group.header);
	}

	//---------------------------------------------------
	//-- The overlay ------------------------------------
	//---------------------------------------------------
	// Lines are separated by a backslash and an n, fields by a bar:
	//   N|seconds|font size|colour|done|total
	//   L|group|complete|icon|text        group: 0 quests, 1 items and cards, 2 the world map
	//   M|count                           this many more than fit

	//---------------------------------------------------

	//---------------------------------------------------

	public function QueueForOverlay(message: string)
	{
		if (overlay_messages.Size() >= overlay_limit)
		{
			overlay_messages.Erase(0);
		}
		overlay_messages.PushBack(message);
	}

	//---------------------------------------------------

	public function TakeOverlayMessage() : string
	{
		var message : string;

		if (overlay_messages.Size() == 0)
		{
			return "";
		}
		message = overlay_messages[0];
		overlay_messages.Erase(0);
		return message;
	}

	//---------------------------------------------------

	private function OverlayHead() : string
	{
		var total_count, done_count : int;

		master.catalog.CountProgress(total_count, done_count);
		return "N|" + PotP_GetSetting('ProgressOnThePath_GlobalNotification_Time') + "|" + IntToString(GetFontSize()) + "|" + PotP_GetSetting('ProgressOnThePath_GlobalNotification_Font')
			+ "|" + IntToString(done_count) + "|" + IntToString(total_count);
	}

	//---------------------------------------------------
	// The window shows a line's state with a mark, and what kind it is with a heading

	private function OverlayLine(group: int, icon_path: string, text_value: string) : string
	{
		var complete	: string = GetLocStringByKeyExt("PotP_QUESTCOMPLETE");
		var progress	: string = GetLocStringByKeyExt("PotP_QUESTINPROGRESS");
		var updated		: string = GetLocStringByKeyExt("PotP_NotificationLine_Updated");
		var word		: string = StrReplace(updated, ": ", " ");
		var done		: string = "0";

		if (complete != "" && StrContains(text_value, complete))
		{
			text_value = StrReplace(text_value, complete, "");
			done = "1";
		}
		else if (progress != "" && StrContains(text_value, progress))
		{
			text_value = StrReplace(text_value, progress, "");
			done = "2";
		}
		text_value = StrReplace(text_value, updated, "");
		// World map lines say it as "Updated Bandit Camp: "
		if (word != updated && StrLeft(text_value, StrLen(word)) == word)
		{
			text_value = StrRight(text_value, StrLen(text_value) - StrLen(word));
		}
		text_value = StrReplace(text_value, "|", "/");
		return "\nL|" + IntToString(group) + "|" + done + "|" + icon_path + "|" + text_value;
	}

	//---------------------------------------------------

	private function OverlayPlain(lines: CPotP_NoticeList, group: int) : string
	{
		var body	: string;
		var Idx		: int;

		lines.Sort();
		for (Idx = 0; Idx < lines.Size(); Idx += 1)
		{
			body += OverlayLine(group, lines.icons[Idx], lines.texts[Idx]);
		}
		return body;
	}

	//---------------------------------------------------

	private function OverlayCounted(lines: CPotP_NoticeList, group: int) : string
	{
		var body	: string;
		var Idx		: int;

		lines.Sort();
		for (Idx = 0; Idx < lines.Size(); Idx += 1)
		{
			body += OverlayLine(group, lines.icons[Idx], CountedText(lines, Idx));
		}
		return body;
	}

	private function GetFontSize() : int
	{
		if ((int) PotP_GetSetting('ProgressOnThePath_GlobalNotification_Size') < 14)
		{
			PotP_SetSetting('ProgressOnThePath_GlobalNotification_Size', "18");
		}
		return (int) PotP_GetSetting('ProgressOnThePath_GlobalNotification_Size');
	}

	//---------------------------------------------------
	//-- Line text --------------------------------------
	//---------------------------------------------------

	private function GetQuestUpdateText(tracked: CPotP_Entry) : string
	{
		var suffix : string = GetLocStringByKeyExt("PotP_QUESTCOMPLETE");

		if (tracked.status == PotP_S_InProgress)
		{
			suffix = GetLocStringByKeyExt("PotP_QUESTINPROGRESS");
		}

		return GetLocStringByKeyExt("PotP_NotificationLine_Updated") + StrReplace(GetLocStringByKeyExt("PotP_NotificationLine_QuestUpdated"), "(QUESTNAME)", tracked.title + suffix);
	}

	//---------------------------------------------------

	private function GetQuestLine(tracked: CPotP_Entry) : string
	{
		var dlc_suffix : string = IntToString(tracked.dlc_index + 1);

		switch (tracked.filter)
		{
		case PotP_I_Mains:	return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai" + dlc_suffix);
		case PotP_I_Sides:	return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid" + dlc_suffix);
		case PotP_I_Conts:	return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con" + dlc_suffix);
		case PotP_I_Hunts:	return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre" + dlc_suffix);
		case PotP_I_Scavs:	return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Scav");
		case PotP_I_Event:	return GetLocStringByKeyExt("PotP_NotificationLine_Event");
		default:			return "";
		}
	}

	//---------------------------------------------------

	private function GetWorldLine(filter_value: int) : string
	{
		switch (filter_value)
		{
		case PotP_I_Camps:	return GetLocStringByKeyExt("PotP_NotificationLine_Camps");
		case PotP_I_MDens:	return GetLocStringByKeyExt("PotP_NotificationLine_MoDen");
		case PotP_I_Nests:	return GetLocStringByKeyExt("PotP_NotificationLine_MoNes");
		case PotP_I_Place:	return GetLocStringByKeyExt("PotP_NotificationLine_Place");
		case PotP_I_Signs:	return GetLocStringByKeyExt("PotP_NotificationLine_SignP");
		case PotP_I_Sites:	return GetLocStringByKeyExt("PotP_NotificationLine_Sites");
		case PotP_I_Guard:	return GetLocStringByKeyExt("PotP_NotificationLine_Guard");
		case PotP_I_Distr:	return GetLocStringByKeyExt("PotP_NotificationLine_Distr");
		case PotP_I_Knigh:	return GetLocStringByKeyExt("PotP_NotificationLine_Knigh");
		case PotP_I_Infes:	return GetLocStringByKeyExt("PotP_NotificationLine_Infes");
		case PotP_I_Hanse:	return GetLocStringByKeyExt("PotP_NotificationLine_Hanse");
		case PotP_I_Stash:	return GetLocStringByKeyExt("PotP_NotificationLine_Stash");
		case PotP_I_Cache:	return GetLocStringByKeyExt("PotP_NotificationLine_Cache");
		case PotP_I_Spoil:	return GetLocStringByKeyExt("PotP_NotificationLine_Spoil");
		case PotP_I_Hiddn:	return GetLocStringByKeyExt("PotP_NotificationLine_Hiddn");
		default:			return "";
		}
	}

	//---------------------------------------------------

	private function GetWorldUpdatePrefix(filter_value: int) : string
	{
		switch (filter_value)
		{
		case PotP_I_Camps:	return GetLocStringByKeyExt("PotP_NotificationLine_BanditC");
		case PotP_I_Sites:	return GetLocStringByKeyExt("PotP_NotificationLine_AbandonedSite");
		case PotP_I_Guard:	return GetLocStringByKeyExt("PotP_NotificationLine_GuardedTreasure");
		case PotP_I_Distr:	return GetLocStringByKeyExt("PotP_NotificationLine_PersonInDistress");
		case PotP_I_Knigh:	return GetLocStringByKeyExt("PotP_NotificationLine_KnightInDistress");
		case PotP_I_Infes:	return GetLocStringByKeyExt("PotP_NotificationLine_InfestedVineyard");
		case PotP_I_Hanse:	return GetLocStringByKeyExt("PotP_NotificationLine_HanseBase");
		case PotP_I_Stash:	return GetLocStringByKeyExt("PotP_NotificationLine_PlayerStash");
		case PotP_I_Cache:	return GetLocStringByKeyExt("PotP_NotificationLine_SmugglersCache");
		case PotP_I_Spoil:	return GetLocStringByKeyExt("PotP_NotificationLine_SpoilsOfWar");
		case PotP_I_Hiddn:	return GetLocStringByKeyExt("PotP_NotificationLine_HiddenTreasure");
		default:			return GetLocStringByKeyExt("PotP_NotificationLine_Updated");
		}
	}

	//---------------------------------------------------

	private function GetItemsLine(filter_value: int) : string
	{
		switch (filter_value)
		{
		case PotP_I_Troph:	return GetLocStringByKeyExt("PotP_NotificationLine_Troph");
		case PotP_I_Relic:	return GetLocStringByKeyExt("PotP_NotificationLine_Relic");
		case PotP_I_Gwent:	return GetLocStringByKeyExt("PotP_NotificationLine_Gwent");
		case PotP_I_Gears:	return GetLocStringByKeyExt("PotP_NotificationLine_GearSet");
		case PotP_I_Shade:	return GetLocStringByKeyExt("PotP_NotificationLine_ShadesOfIron");
		case PotP_I_Wiecej:	return GetLocStringByKeyExt("PotP_NotificationLine_CosWiecej");
		case PotP_I_Sezon:	return GetLocStringByKeyExt("PotP_NotificationLine_SezonBurz");
		case PotP_I_W3eer:	return GetLocStringByKeyExt("PotP_NotificationLine_W3EE");
		case PotP_I_Witch:	return GetLocStringByKeyExt("PotP_NotificationLine_WitcherGear");
		case PotP_I_Horse:	return GetLocStringByKeyExt("PotP_NotificationLine_HorseGear");
		default:			return "";
		}
	}

	//---------------------------------------------------
	//-- Icons ------------------------------------------
	//---------------------------------------------------

	public function GetIcon(tracked: CPotP_Entry) : string
	{
		var icon_path	: string;
		var card		: SCardDefinition;

		switch (tracked.category)
		{
		case PotP_A_Quest:
		case PotP_A_Event:
			// The world map's quest diamond, in the colour the map gives each part of the game, with its exclamation mark
			if (tracked.dlc_index == 1) { return "pin:QuestObjectiveOther%QuestAvailableHoS"; }
			if (tracked.dlc_index == 2) { return "pin:QuestObjectiveOther%QuestAvailableBaW"; }
			return "pin:QuestObjectiveOther%QuestAvailable";

		case PotP_A_World:
			return GetWorldIcon(tracked.filter);

		case PotP_A_Gwent:
			// The card's own art, which the overlay cuts a portrait from
			if (tracked.card_names.Size() > 0 && theGame.GetGwintManager().GetGwentCard(tracked.card_names[0], card))
			{
				return "card:" + PotPOverlay_CardPicture(card);
			}
			icon_path = thePlayer.GetInventory().GetItemIconPathByName(tracked.item_name);
			if (icon_path == "") { return "icons/inventory/gwint/ico_gwent_hero_neutral.png"; }
			return icon_path;

		default:
			icon_path = thePlayer.GetInventory().GetItemIconPathByName(tracked.item_name);
			if (icon_path == "") { return "icons/inventory/weapons/silver_unique_aerondight_64x128.png"; }
			return icon_path;
		}
	}

	//---------------------------------------------------

	// The world map's own pin for each kind of place, which the overlay draws from the map menu
	private function GetWorldIcon(filter_value: int) : string
	{
		switch (filter_value)
		{
		case PotP_I_Camps:	return "pin:BanditCampfire";
		case PotP_I_MDens:	return "pin:DungeonCrawl";
		case PotP_I_Nests:	return "pin:MonsterNest";
		case PotP_I_Place:	return "pin:PlaceOfPower";
		case PotP_I_Signs:	return "pin:RoadSign";
		case PotP_I_Sites:	return "pin:RescuingTown";
		case PotP_I_Guard:	return "pin:BossAndTreasure";
		case PotP_I_Distr:	return "pin:BanditCamp";
		case PotP_I_Knigh:	return "pin:KnightErrant";
		case PotP_I_Infes:	return "pin:InfestedVineyard";
		case PotP_I_Hanse:	return "pin:Hideout";
		case PotP_I_Cache:	return "pin:Contraband";
		case PotP_I_Spoil:	return "pin:SpoilsOfWar";
		case PotP_I_Hiddn:	return "pin:TreasureHuntMappin";
		default:			return "pin:PlayerStash";
		}
	}
}
