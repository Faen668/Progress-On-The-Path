//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_Notifications
{	
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
	public var storage: CProgressOnThePath_Storage;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Notifications
	{
		this.master = PotP_BaseClass;
		this.storage = PotP_BaseClass.PotP_PersistentStorage;
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
		var TotalEntList: array<PotP_PreviewEntry> = this.master.PotP_PersistentStorage.pArrayStorage.TotalEntList;
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
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Completed List - " + storage.MasterList_Completed_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "InProgres List - " + storage.MasterList_InProgres_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "IsIgnored List - " + storage.MasterList_IsIgnored_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Collected List - " + storage.MasterList_Collected_V.Size() + "</font>" + "<br/>";
		Notification +=" <br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Items Goblin - " + storage.MasterList_ItemsGoblin.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Quest Goblin - " + storage.MasterList_QuestGoblin.Size() + "</font>" + "<br/>";
		Notification +=" <br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Pending Messages - " + storage.MasterList_Pl_Messages.Size() + "</font>" + "<br/>";
		
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

		if (storage.pItemsStorageArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (storage.BackGroundProcessingArray_Count > 20) 
			{
				storage.BackGroundProcessingArray_Oflow += 1;
				return;
			}
			
			storage.pItemsStorageArray_Name.PushBack(InsertedString);
			storage.pItemsStorageArray_Icon.PushBack(thePlayer.GetInventory().GetItemIconPathByName(entry_data.item_name));
			storage.BackGroundProcessingArray_Count += 1;
			storage.BackGroundProcessingArray_bItems = true;
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
		
		if (storage.pWorldStorageArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (storage.BackGroundProcessingArray_Count > 20) 
			{
				storage.BackGroundProcessingArray_Oflow += 1;
				return;
			}
			
			storage.pWorldStorageArray_Name.PushBack(InsertedString);
			storage.pWorldStorageArray_Icon.PushBack(entry_data.icon_path);
			storage.BackGroundProcessingArray_Count += 1;
			storage.BackGroundProcessingArray_bWorld = true;
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
			
		if (storage.pQuestStorageArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (storage.BackGroundProcessingArray_Count > 20) 
			{
				storage.BackGroundProcessingArray_Oflow += 1;
				return;
			}
			
			storage.pQuestStorageArray_Name.PushBack(InsertedString);
			storage.pQuestStorageArray_Icon.PushBack(entry_data.icon_path);
			storage.BackGroundProcessingArray_Count += 1;
			storage.BackGroundProcessingArray_bQuest = true;
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
		
		temp_QuestNameArray = storage.pQuestStorageArray_Name;
		temp_QuestIconArray = storage.pQuestStorageArray_Icon;

		temp_ItemsNameArray = storage.pItemsStorageArray_Name;
		temp_ItemsIconArray = storage.pItemsStorageArray_Icon;

		temp_WorldMapNameArray = storage.pWorldStorageArray_Name;
		temp_WorldMapIconArray = storage.pWorldStorageArray_Icon;
		
		if (temp_QuestNameArray.Size() > 0) 
		{ 
			ArraySortStrings(storage.pQuestStorageArray_Name);
			
			for (i = 0; i < storage.pQuestStorageArray_Name.Size(); i += 1) 
			{ 
				f = temp_QuestNameArray.FindFirst(storage.pQuestStorageArray_Name[i]); 
				storage.pQuestStorageArray_Icon[i] = temp_QuestIconArray[f]; 
			}
			
			for (i = 0; i < storage.pQuestStorageArray_Name.Size(); i += 1) 
			{
				storage.BackGroundProcessingArray_Name.PushBack(storage.pQuestStorageArray_Name[i]);
				storage.BackGroundProcessingArray_Icon.PushBack(storage.pQuestStorageArray_Icon[i]);
			}
		}

		if (temp_ItemsNameArray.Size() > 0) 
		{ 
			ArraySortStrings(storage.pItemsStorageArray_Name);
			
			for (i = 0; i < storage.pItemsStorageArray_Name.Size(); i += 1) 
			{ 
				f = temp_ItemsNameArray.FindFirst(storage.pItemsStorageArray_Name[i]); 
				storage.pItemsStorageArray_Icon[i] = temp_ItemsIconArray[f]; 
			}
			
			for (i = 0; i < storage.pItemsStorageArray_Name.Size(); i += 1) 
			{
				storage.BackGroundProcessingArray_Name.PushBack(storage.pItemsStorageArray_Name[i]);
				storage.BackGroundProcessingArray_Icon.PushBack(storage.pItemsStorageArray_Icon[i]);
			}
		}

		if (storage.pWorldStorageArray_Name.Size() > 0) 
		{ 
			ArraySortStrings(storage.pWorldStorageArray_Name);
			
			for (i = 0; i < storage.pWorldStorageArray_Name.Size(); i += 1) 
			{ 
				f = temp_WorldMapNameArray.FindFirst(storage.pWorldStorageArray_Name[i]); 
				storage.pWorldStorageArray_Icon[i] = temp_WorldMapIconArray[f]; 
			}
			
			for (i = 0; i < storage.pWorldStorageArray_Name.Size(); i += 1) 
			{
				storage.BackGroundProcessingArray_Name.PushBack(storage.pWorldStorageArray_Name[i]);
				storage.BackGroundProcessingArray_Icon.PushBack(storage.pWorldStorageArray_Icon[i]);
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
		var over_limit		: string = StrReplace(GetLocStringByKeyExt("ProgressOnThePath_MoreEntries"), "[COUNTS]", (storage.BackGroundProcessingArray_Oflow));
		var Notification 	: string = "";
		var i, f			: int = 0;

		SortBackgroundArrays();
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
			
		for (i = 0; i < storage.BackGroundProcessingArray_Name.Size(); i += 1) 
		{
			Notification += FormatItemIcon(storage.BackGroundProcessingArray_Icon[i]) + FormatLine_BackGroundProcessingArray(storage.BackGroundProcessingArray_Name[i]);
		}
		
		if (storage.BackGroundProcessingArray_Oflow > 0) 
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
		if (storage.pQuestStorageArray_Name.Size() > 0 || storage.pWorldStorageArray_Name.Size() > 0 || storage.pItemsStorageArray_Name.Size() > 0)
		{
			PotP_Logger('PotP Notifications', "Pushing Basckground Notification...");
			theGame.GetGuiManager().ShowNotification(FormatMessage_BackGroundProcessingArray(), GetNotificationTime(), true);
			storage.ResetBackGroundProcessingArray();
		}
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
}

