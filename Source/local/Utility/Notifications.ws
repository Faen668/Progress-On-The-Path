//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_Notifications
{
	private var BackGroundProcessingArray_Count: int;
	private var BackGroundProcessingArray_OverFlow: int;
	private var BackGroundProcessingArray_Name: array<string>;
	private var BackGroundProcessingArray_Icon: array<string>;

	private var BackGroundQuestArray_Name: array<string>;
	private var BackGroundQuestArray_Icon: array<string>;
	private var BackGroundQuestArray_Count: int;
	
	private var BackGroundItemArray_Name: array<string>;
	private var BackGroundItemArray_Icon: array<string>;
	private var BackGroundItemArray_Count: int;

	private var BackGroundWorldMapArray_Name: array<string>;
	private var BackGroundWorldMapArray_Icon: array<string>;
	private var BackGroundWorldMapArray_Count: int;
	
	private var TrackerUpdateArray_Count: int;
	private var TrackerUpdateArray_Name: array<string>;
	private var TrackerUpdateArray_Icon: array<string>;
	private var TrackerUpdateArray_Ints: array<int>;

	private var QuestUpdateArray_Name: array<string>;
	private var QuestUpdateArray_Icon: array<string>;
	private var QuestUpdateArray_Ints: array<int>;

	private var ItemUpdateArray_Name: array<string>;
	private var ItemUpdateArray_Icon: array<string>;
	private var ItemUpdateArray_Ints: array<int>;

	private var WorldMapUpdateArray_Name: array<string>;
	private var WorldMapUpdateArray_Icon: array<string>;
	private var WorldMapUpdateArray_Ints: array<int>;
	
	private var fontsize: int;
		default fontsize = 18;

	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Notifications
	{
		this.master = PotP_BaseClass;
		return this;
	}
	
	//---------------------------------------------------
	
	public function ResetTrackerUpdateArray() 
	{
		TrackerUpdateArray_Name.Clear();
		TrackerUpdateArray_Ints.Clear();
		TrackerUpdateArray_Icon.Clear();

		QuestUpdateArray_Name.Clear();
		QuestUpdateArray_Ints.Clear();
		QuestUpdateArray_Icon.Clear();

		ItemUpdateArray_Name.Clear();
		ItemUpdateArray_Ints.Clear();
		ItemUpdateArray_Icon.Clear();
		
		WorldMapUpdateArray_Name.Clear();
		WorldMapUpdateArray_Ints.Clear();
		WorldMapUpdateArray_Icon.Clear();
		
		TrackerUpdateArray_Count = 0;
	}

	//---------------------------------------------------
	
	public function ResetBackGroundProcessingArray()
	{
		BackGroundProcessingArray_Name.Clear();
		BackGroundProcessingArray_Icon.Clear();
		BackGroundProcessingArray_Count = 0;
		BackGroundProcessingArray_OverFlow = 0;

		BackGroundQuestArray_Name.Clear();
		BackGroundQuestArray_Icon.Clear();
		BackGroundQuestArray_Count = 0;
		
		BackGroundItemArray_Name.Clear();
		BackGroundItemArray_Icon.Clear();
		BackGroundItemArray_Count = 0;
		
		BackGroundWorldMapArray_Name.Clear();
		BackGroundWorldMapArray_Icon.Clear();
		BackGroundWorldMapArray_Count = 0;
	}
	
	//---------------------------------------------------

	private function GetNotificationFontSize() : int 
	{
		if ( (int) PotP_GetNotificationValue('ProgressOnThePath_GlobalNotification_Size') < 14 )
		{
			theGame.GetInGameConfigWrapper().SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Size', fontsize);
		}
		
		return (int) PotP_GetNotificationValue('ProgressOnThePath_GlobalNotification_Size');
	}

	//---------------------------------------------------
	
	private function GetNotificationTime() : float
	{
		return (float) PotP_GetNotificationValue('ProgressOnThePath_GlobalNotification_Time') * 1000.0;
	}
	
	//---------------------------------------------------

	private function GetNotificationColour() : string
	{
		switch ( (int) PotP_GetNotificationValue('ProgressOnThePath_GlobalNotification_Font') ) {
		
			case 1:
				return "<font color='#233067'>";
			
			case 2:
				return "<font color='#630F0F'>";

			case 3:
				return "<font color='#084A23'>";

			case 4:
				return "<font color='#431C53'>";
				
			default:
				return "<font color='#000000'>";
		}
	}
	
	//---------------------------------------------------
	
	private function GetNotificationHeader() : string 
	{
		return GetNotificationColour() + GetLocStringByKeyExt("PotP_NotificationHeader") + " " + GetTotalPercentage() + "<br/>" + "</font>";
	}	

	//---------------------------------------------------
	
	private function GetTotalPercentage() : string 
	{
		var cur: float = this.GetCurrentCount();
		var tot: float = this.GetTotalCount();
		
		return GetNotificationColour() + GetLocStringByKeyExt("PotP_Completed") + " (" +(int) cur + " / " + (int) tot + ") - " + " " + FloatToStringPrec(((cur / tot) * 100), 2) + "%" + "</font>";
	}

	//---------------------------------------------------

	private function GetCurrentCount() : float 
	{
		return (this.master.PotP_PersistentStorage.MasterList_Completed_V.Size() + this.master.PotP_PersistentStorage.MasterList_IsIgnored_V.Size());
	}

	//---------------------------------------------------

	private function GetTotalCount() : float 
	{
		var TotalEntList: array<PotP_PreviewEntry> = this.master.PotP_ArrayManager.TotalEntList;
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		var i, CardsFound: int;

		if (GwentManager.HasLootedCard())
		{
			if (GwentManager.IsDeckUnlocked(GwintFaction_Skellige))
			{
				return TotalEntList.Size();
			}
			else
			{
				for (i = 0; i < TotalEntList.Size(); i += 1)
				{
					if (TotalEntList[i].arrayType == PotP_A_Gwent && TotalEntList[i].filter == PotP_I_Skell)
					{
						CardsFound += 1;
					}
				}
				return (TotalEntList.Size() - CardsFound);			
			}
		}
		else
		{
			for (i = 0; i < TotalEntList.Size(); i += 1)
			{
				if (TotalEntList[i].arrayType == PotP_A_Gwent)
				{
					CardsFound += 1;
				}
			}
			return (TotalEntList.Size() - CardsFound);	
		}
	}
	
	//---------------------------------------------------
	
	public function _ShowListSizes() 
	{
		var Notification : string = "";
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Completed List - " + this.master.PotP_PersistentStorage.MasterList_Completed_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "InProgres List - " + this.master.PotP_PersistentStorage.MasterList_InProgres_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "IsIgnored List - " + this.master.PotP_PersistentStorage.MasterList_IsIgnored_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Collected List - " + this.master.PotP_PersistentStorage.MasterList_Collected_V.Size() + "</font>" + "<br/>";
		Notification +=" <br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Items Goblin - " + this.master.PotP_PersistentStorage.MasterList_ItemsGoblin.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Quest Goblin - " + this.master.PotP_PersistentStorage.MasterList_QuestGoblin.Size() + "</font>" + "<br/>";
		Notification +=" <br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Pending Messages - " + this.master.PotP_PersistentStorage.MasterList_Pl_Messages.Size() + "</font>" + "<br/>";
		
		theGame.GetGuiManager().ShowNotification(Notification, GetNotificationTime(), true);
	}
	
	//---------------------------------------------------

	private function FormatItemIcon(s: string) : string 
	{
		return "<img src='img://" + s + "' height='" + GetNotificationFontSize() + "' width='" + GetNotificationFontSize() + "' vspace='-5' />&nbsp;";
	}

	//---------------------------------------------------
	
	public function AddToQuestUpdateArray(entry_data: PotP_PreviewEntry)
	{
		var InsertedString: string = entry_data.popup_line;
		var InsertedIndexP: int = QuestUpdateArray_Name.FindFirst(InsertedString);

		if (InsertedIndexP == -1)
		{
			QuestUpdateArray_Name.PushBack(InsertedString);
			QuestUpdateArray_Ints.PushBack(1);
			QuestUpdateArray_Icon.PushBack(entry_data.icon_path);
			TrackerUpdateArray_Count += 1;
			LogChannel('PotP Notification Script', "Inserted - " + InsertedString + " Into the quest array");
		}
		else 
		{
			QuestUpdateArray_Ints[InsertedIndexP] += 1;
			LogChannel('PotP Notification Script', "Increased Count for - " + InsertedString + " to " + QuestUpdateArray_Ints[InsertedIndexP]);
		}
	}

	//---------------------------------------------------
	
	public function AddToWorldMapUpdateArray(entry_data: PotP_PreviewEntry) 
	{		
		var InsertedString: string = entry_data.popup_line;
		var InsertedIndexP: int = WorldMapUpdateArray_Name.FindFirst(InsertedString);

		if (InsertedIndexP == -1) 
		{
			WorldMapUpdateArray_Name.PushBack(InsertedString);
			WorldMapUpdateArray_Ints.PushBack(1);
			WorldMapUpdateArray_Icon.PushBack(entry_data.icon_path);
			TrackerUpdateArray_Count += 1;
			LogChannel('PotP Notification Script', "Inserted - " + InsertedString + " Into the world map array");
		}
		else 
		{
			WorldMapUpdateArray_Ints[InsertedIndexP] += 1;
			LogChannel('PotP Notification Script', "Increased Count for - " + InsertedString + " to " + WorldMapUpdateArray_Ints[InsertedIndexP]);
		}
	}

	//---------------------------------------------------
	
	public function AddToItemUpdateArray(entry_data: PotP_PreviewEntry) 
	{
		var InsertedString: string = entry_data.popup_line;
		var InsertedIndexP: int = ItemUpdateArray_Name.FindFirst(InsertedString);
		
		if (InsertedIndexP == -1) 
		{
			ItemUpdateArray_Name.PushBack(InsertedString);
			ItemUpdateArray_Ints.PushBack(1);
			ItemUpdateArray_Icon.PushBack(entry_data.icon_path);
			TrackerUpdateArray_Count += 1;
		}
		else 
		{
			ItemUpdateArray_Ints[InsertedIndexP] += 1;
		}
	}

	//---------------------------------------------------
	
	public function AddToBackGroundArray_Item(entry_data: PotP_PreviewEntry)
	{
		var InsertedString: string = GetLocStringByKeyExt("PotP_NotificationLine_Updated") + entry_data.localname;

		if (BackGroundItemArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (BackGroundProcessingArray_Count > 20) 
			{
				BackGroundProcessingArray_OverFlow += 1;
				return;
			}
			
			BackGroundItemArray_Name.PushBack(InsertedString);
			BackGroundItemArray_Icon.PushBack(thePlayer.GetInventory().GetItemIconPathByName(entry_data.item_name));
			BackGroundProcessingArray_Count += 1;
		}
	}

	//---------------------------------------------------
	
	public function AddToBackGroundArray_WorldMap(entry_data: PotP_PreviewEntry) 
	{
		var InsertedString: string = GetLocStringByKeyExt("PotP_NotificationLine_Updated") + entry_data.localname;
		
		if (entry_data.filter == PotP_I_Camps)
		{
			InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_BanditC") + entry_data.localname;
		}
		
		if (BackGroundWorldMapArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (BackGroundProcessingArray_Count > 20) 
			{
				BackGroundProcessingArray_OverFlow += 1;
				return;
			}
			
			BackGroundWorldMapArray_Name.PushBack(InsertedString);
			BackGroundWorldMapArray_Icon.PushBack(entry_data.icon_path);
			BackGroundProcessingArray_Count += 1;
		}
	}
	
	//---------------------------------------------------
	
	public function AddToBackGroundArray_Quest(entry_data: PotP_PreviewEntry, QuestStatus: int) 
	{
		var InsertedString: string = GetLocStringByKeyExt("PotP_NotificationLine_Updated");
		
		switch (QuestStatus)
		{
		case JS_Success:
		case JS_Failed:
			InsertedString += StrReplace(GetLocStringByKeyExt("PotP_NotificationLine_QuestUpdated"), "(QUESTNAME)", entry_data.localname + GetLocStringByKeyExt("PotP_QUESTCOMPLETE"));
			break;
			
		case JS_Active:
			InsertedString += StrReplace(GetLocStringByKeyExt("PotP_NotificationLine_QuestUpdated"), "(QUESTNAME)", entry_data.localname + GetLocStringByKeyExt("PotP_QUESTINPROGRESS"));
			break;
			
		default:
			return;
		}
			
		if (BackGroundQuestArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (BackGroundProcessingArray_Count > 20) 
			{
				BackGroundProcessingArray_OverFlow += 1;
				return;
			}
			
			BackGroundQuestArray_Name.PushBack(InsertedString);
			BackGroundQuestArray_Icon.PushBack(entry_data.icon_path);
			BackGroundProcessingArray_Count += 1;
		}
	}
	
	//---------------------------------------------------
	
	private function SortArrays(N: array<string>, I: array<string>, X: array<int>) 
	{
		var tmpN: array <string> = N;
		var tmpI: array <string> = I;
		var tmpX: array <int> = X;
		var i, f: int;
		
		if (tmpN.Size() == -1) 
		{ 
			return; 
		}
		
		ArraySortStrings(N);
		
		for (i = 0; i < N.Size(); i += 1)
		{ 
			f = tmpN.FindFirst(N[i]); 
			I[i] = tmpI[f]; 
			X[i] = tmpX[f]; 
		}
		
		for (i = 0; i < N.Size(); i += 1) 
		{
			TrackerUpdateArray_Name.PushBack(N[i]);
			TrackerUpdateArray_Icon.PushBack(I[i]);
			TrackerUpdateArray_Ints.PushBack(X[i]);
		}
	}

	//---------------------------------------------------
	
	private function SortBackgroundArrays() 
	{
		var temp_QuestNameArray, temp_ItemsNameArray, temp_WorldMapNameArray: array <string>;
		var temp_QuestIconArray, temp_ItemsIconArray, temp_WorldMapIconArray: array <string>;
		var i, f: int;
		
		temp_QuestNameArray = BackGroundQuestArray_Name;
		temp_QuestIconArray = BackGroundQuestArray_Icon;

		temp_ItemsNameArray = BackGroundItemArray_Name;
		temp_ItemsIconArray = BackGroundItemArray_Icon;

		temp_WorldMapNameArray = BackGroundWorldMapArray_Name;
		temp_WorldMapIconArray = BackGroundWorldMapArray_Icon;
		
		if (temp_QuestNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundQuestArray_Name);
			
			for (i = 0; i < BackGroundQuestArray_Name.Size(); i += 1) 
			{ 
				f = temp_QuestNameArray.FindFirst(BackGroundQuestArray_Name[i]); 
				BackGroundQuestArray_Icon[i] = temp_QuestIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundQuestArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundQuestArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundQuestArray_Icon[i]);
			}
		}

		if (temp_ItemsNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundItemArray_Name);
			
			for (i = 0; i < BackGroundItemArray_Name.Size(); i += 1) 
			{ 
				f = temp_ItemsNameArray.FindFirst(BackGroundItemArray_Name[i]); 
				BackGroundItemArray_Icon[i] = temp_ItemsIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundItemArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundItemArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundItemArray_Icon[i]);
			}
		}

		if (temp_WorldMapNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundWorldMapArray_Name);
			
			for (i = 0; i < BackGroundWorldMapArray_Name.Size(); i += 1) 
			{ 
				f = temp_WorldMapNameArray.FindFirst(BackGroundWorldMapArray_Name[i]); 
				BackGroundWorldMapArray_Icon[i] = temp_WorldMapIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundWorldMapArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundWorldMapArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundWorldMapArray_Icon[i]);
			}
		}
	}
	
	//---------------------------------------------------
	
	private function FormatNotification() : string 
	{
		var Notification : string = "";
		var i: int = 0;

		SortArrays(QuestUpdateArray_Name, QuestUpdateArray_Icon, QuestUpdateArray_Ints);
		SortArrays(WorldMapUpdateArray_Name, WorldMapUpdateArray_Icon, WorldMapUpdateArray_Ints);
		SortArrays(ItemUpdateArray_Name, ItemUpdateArray_Icon, ItemUpdateArray_Ints);
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
		
		if (this.TrackerUpdateArray_Count == 0) 
		{
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Nulls') ) 
			{
				Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + GetLocStringByKeyExt("PotP_NullMessage") + "<br/>" + "</font>"; 
				return Notification;
			}
			return "";
		}
		
		for (i = 0; i < TrackerUpdateArray_Name.Size(); i += 1) 
		{
			if (TrackerUpdateArray_Ints[i] > 0) 
			{
				Notification += FormatItemIcon(TrackerUpdateArray_Icon[i]) + FormatLine(TrackerUpdateArray_Ints[i], TrackerUpdateArray_Name[i]);
			}
		}		
		return Notification;
	}
	
	//---------------------------------------------------
	
	public function UpdateSingleEntry(entry_data: PotP_PreviewEntry, status: int)
	{
		var Notification : string = "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";

		switch (status)
		{
			case 0: Notification += FormatItemIcon(entry_data.icon_path) + FormatLine_BackGroundProcessingArray("Restored: " + entry_data.localname); break;
			case 1: Notification += FormatItemIcon(entry_data.icon_path) + FormatLine_BackGroundProcessingArray("Ignored: " + entry_data.localname);  break;
			case 2: Notification += FormatItemIcon(entry_data.icon_path) + FormatLine_BackGroundProcessingArray("Completed: " + entry_data.localname); break;
		}
		
		theGame.GetGuiManager().ShowNotification(Notification, GetNotificationTime(), true);
	}
	
	//---------------------------------------------------
	
	private function FormatMessage_BackGroundProcessingArray() : string 
	{
		var over_limit		: string = StrReplace(GetLocStringByKeyExt("ProgressOnThePath_MoreEntries"), "[COUNTS]", (BackGroundProcessingArray_OverFlow));
		var Notification 	: string = "";
		var i, f			: int = 0;

		SortBackgroundArrays();
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
			
		for (i = 0; i < BackGroundProcessingArray_Name.Size(); i += 1) 
		{
			Notification += FormatItemIcon(BackGroundProcessingArray_Icon[i]) + FormatLine_BackGroundProcessingArray(BackGroundProcessingArray_Name[i]);
		}
		
		if (BackGroundProcessingArray_OverFlow > 0) 
		{
			Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + over_limit + "</font>";
		}
		
		return Notification;
	}

	//---------------------------------------------------
	
	private function FormatLine_BackGroundProcessingArray(str: string) : string 
	{
		return "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + str + "<br/>" + "</font>";
	}
	
	//---------------------------------------------------
	
	private function FormatLine(counter: int, str: string) : string 
	{
		var returnStr: string = "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + GetLocStringByKeyExt("PotP_NotificationLine_Updated") + (string) counter + str + "<br/>" + "</font>";
		
		if (StrContains(returnStr, "(DYNAMC_REPLACE_TROPHY)")) 
		{
			if (counter == 1) 
			{
				return StrReplace(returnStr, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER2"));
			}
			else
			{
				return StrReplace(returnStr, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER1"));
			}
		}
	
		if (counter == 1)
		{
			return StrReplace(returnStr, "(DYNAMC_REPLACE)", "");
		}
		
		return StrReplace(returnStr, "(DYNAMC_REPLACE)", GetLocStringByKeyExt("PotP_PLURAL_REPLACER"));
	}
	
	//---------------------------------------------------	

	public function DisplayNotification() 
	{
		if (this.FullNotificationsEnabled()) 
		{
			theGame.GetGuiManager().ShowNotification(FormatNotification(), GetNotificationTime(), true);
		}
		this.ResetTrackerUpdateArray();
	}

	//---------------------------------------------------	

	public function NotifyPlayerFromBackgroundProcess() 
	{
		if (this.BackNotificationsEnabled() && this.BackGroundProcessingArray_Count > 0) 
		{
			theGame.GetGuiManager().ShowNotification(FormatMessage_BackGroundProcessingArray(), GetNotificationTime(), true);
		}
		this.ResetBackGroundProcessingArray();
	}	
	
	//---------------------------------------------------	

	private function FullNotificationsEnabled() : bool 
	{
		return (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Quest') 
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_World') 
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Items')
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Gwent')
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Event');
	}	

	//---------------------------------------------------	

	private function BackNotificationsEnabled() : bool 
	{
		return (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Quest') 
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_World') 
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Items')
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Gwent')
			|| (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Event');
	}	
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------