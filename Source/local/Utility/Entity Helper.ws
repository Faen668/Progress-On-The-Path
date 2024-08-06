//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_PreviewEntryHelper
{
	var master: CProgressOnThePath;
	var storage: CProgressOnThePath_Storage;
	var mappins: CProgressOnThePath_MapPins;
	var notifications: CProgressOnThePath_Notifications;
	
	var fileName: name;	
	default fileName = 'PotP Entity Helper';
	
	function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.mappins = master.PotP_PinManager;
		this.storage = master.PotP_PersistentStorage;
		this.notifications = master.PotP_Notifications;
	}
	
	//---------------------------------------------------
	
	function GetEntityByItemName(itemName: name, out entity: PotP_PreviewEntry) : bool
	{
		var Idx : int;
		var lst: array<name>;
		
		if (!storage) {
			return false;
		}
		
		lst = storage.pItemsStorage.SupportedItemsList;
		for ( Idx = 0 ; Idx < lst.Size() ; Idx += 1 )
		{
			if (itemName == lst[Idx]) {
				entity = storage.pItemsStorage.SupportedItemsList_Entity[Idx];
				return true;
			}
		}
		
		return false;
	}
	
	//---------------------------------------------------
	
	function IsPlayable(entity: PotP_PreviewEntry) : bool
	{
		return !storage.MasterList_Completed_V.Contains(entity.uuid) && !storage.MasterList_IsIgnored_V.Contains(entity.uuid);
	}

	//---------------------------------------------------
	
	function IsCompleted(entity: PotP_PreviewEntry) : bool
	{	
		return storage.MasterList_Completed_V.Contains(entity.uuid);
	}
	
	//---------------------------------------------------
	
	function IsIgnored(entity: PotP_PreviewEntry) : bool
	{
		return storage.MasterList_IsIgnored_V.Contains(entity.uuid);
	}
	
	//---------------------------------------------------
	
	function IsInProgress(entity: PotP_PreviewEntry) : bool
	{
		return storage.MasterList_InProgres_V.Contains(entity.uuid);
	}
	
	//---------------------------------------------------
	
	function IsCollected(entity: PotP_PreviewEntry) : bool
	{	
		return storage.MasterList_Collected_V.Contains(entity.uuid);
	}

	//---------------------------------------------------
	
	function SetCompleted(entity: PotP_PreviewEntry, optional user_forced: bool) : void
	{
		if (!entity) {
			return;
		}

		if (!IsCompleted(entity)) 
		{
			storage.MasterList_Completed_V.PushBack(entity.uuid);
			PotP_Logger("Added - " + entity.localname + " to persistent GetPotP_Storage() list 'Completed'", , this.fileName);
		}

		if (entity.arrayType == PotP_A_Items)
		{
			this.SetCollected(entity);
		}

		if (entity.arrayType == PotP_A_Event)
		{
			SU_removeCustomPinByTag("PotP_" + entity.uuid);
			PotP_Logger("Removed Map Pin: " + entity.localname, , this.fileName);
		}		
		
		this.RemoveInProgress(entity);
		this.RemoveIgnored(entity);

		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(entity, 2);
		}
	}		

	//---------------------------------------------------
	
	function SetCollected(entity: PotP_PreviewEntry) : void
	{
		if (!IsCollected(entity)) 
		{
			FactsSet(entity.item_name + "_collected", 1);
			storage.MasterList_Collected_V.PushBack(entity.uuid);
			PotP_Logger("Added - " + entity.localname + " to persistent GetPotP_Storage() list 'Collected'", , this.fileName);
		}
	}	
	
	//---------------------------------------------------
	
	function SetInProgress(entity: PotP_PreviewEntry) : void
	{
		if (!IsInProgress(entity))
		{
			storage.MasterList_InProgres_V.PushBack(entity.uuid);
			PotP_Logger("Added - " + entity.localname + " to persistent GetPotP_Storage() list 'In Progress'", , this.fileName);
		}
			
		this.RemoveCompleted(entity);
		this.RemoveIgnored(entity);
	}

	//---------------------------------------------------
	
	function SetIgnored(entity: PotP_PreviewEntry, optional user_forced: bool) : void
	{
		if (!IsIgnored(entity)) 
		{
			storage.MasterList_IsIgnored_V.PushBack(entity.uuid);
			PotP_Logger("Added - " + entity.localname + " to persistent GetPotP_Storage() list 'Ignored'", , this.fileName);
		}

		if (entity.arrayType == PotP_A_Event)
		{
			SU_removeCustomPinByTag("PotP_" + entity.uuid);
			PotP_Logger("Removed Map Pin: " + entity.localname, , this.fileName);
		}
			
		this.RemoveInProgress(entity);
		this.RemoveCompleted(entity);
		
		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(entity, 1);
		}
	}
	
	//---------------------------------------------------
	
	function SetAvailable(entity: PotP_PreviewEntry, optional user_forced: bool) : void
	{
		this.RemoveCompleted(entity);
		this.RemoveIgnored(entity);

		if (entity.arrayType == PotP_A_Event)
		{
			mappins.GotoState('Updating');
		}
		
		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(entity, 0);
		}
	}
	
	//---------------------------------------------------
	
	function UpdateQuestEntry(entity: PotP_PreviewEntry, status: int) : bool 
	{	
		switch (status) 
		{	
		case JS_Success:
		case JS_Failed:
			if (!IsCompleted(entity)) { this.SetCompleted(entity); return true; }
			return false;

		case JS_Active:		
			if (!IsInProgress(entity)) { this.SetInProgress(entity); return true; }
			return false;
					
		default: 
			return false;
		}
	}

	//---------------------------------------------------
	
	function RemoveIgnored(entity: PotP_PreviewEntry) : void
	{
		var Idx: int = storage.MasterList_IsIgnored_V.FindFirst(entity.uuid);
		
		if (Idx != -1)
		{ 
			storage.MasterList_IsIgnored_V.EraseFast(Idx);
			PotP_Logger("Removed - " + entity.localname + " from persistent GetPotP_Storage() list 'Ignored'", , this.fileName);
		}
	}
	
	//---------------------------------------------------
	
	function RemoveCompleted(entity: PotP_PreviewEntry) : void
	{
		var Idx: int = storage.MasterList_Completed_V.FindFirst(entity.uuid);
	
		if (Idx != -1)
		{
			storage.MasterList_Completed_V.EraseFast(Idx);
			PotP_Logger("Removed - " + entity.localname + " from persistent GetPotP_Storage() list 'Completed'", , this.fileName);
		}
	}
	
	//---------------------------------------------------
	
	function RemoveInProgress(entity: PotP_PreviewEntry) : void
	{
		var Idx: int = storage.MasterList_InProgres_V.FindFirst(entity.uuid);
		
		if (Idx != -1)
		{ 
			storage.MasterList_InProgres_V.EraseFast(Idx);
			PotP_Logger("Removed - " + entity.localname + " from persistent GetPotP_Storage() list 'In Progress'", , this.fileName);
		}
	}
	
	//---------------------------------------------------
	
	function AddToNotificationQueue(entity: PotP_PreviewEntry) : void
	{
		switch (entity.arrayType)
		{
		case PotP_A_Quest:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Quest') ) 
			{
				notifications.AddToQuestUpdateArray(entity);
			}
			break;
			
		case PotP_A_Event:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Event') ) 
			{
				notifications.AddToQuestUpdateArray(entity);
			}
			break;
		
		case PotP_A_World:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_World') ) 
			{
				notifications.AddToWorldMapUpdateArray(entity);
			}
			break;
		
		case PotP_A_Items:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Items') ) 
			{
				notifications.AddToItemUpdateArray(entity);
			}
			break;
			
		case PotP_A_Gwent:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Gwent') ) 
			{
				notifications.AddToItemUpdateArray(entity);
			}
			break;
			
		default:
			break;
		}
	}
	
	//---------------------------------------------------
	
	function AddToBackgroundQueue(entity: PotP_PreviewEntry, optional status: int) : void
	{		
		switch (entity.arrayType)
		{
		case PotP_A_Quest:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Quest') ) 
			{
				notifications.AddToBackGroundArray_Quest(entity, status);
			}
			break;
			
		case PotP_A_Event:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Event') ) 
			{
				notifications.AddToBackGroundArray_Quest(entity, status);
			}
			break;
		
		case PotP_A_World:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_World') ) 
			{
				notifications.AddToBackGroundArray_WorldMap(entity);
			}
			break;
		
		case PotP_A_Items:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Items') ) 
			{
				notifications.AddToBackGroundArray_Item(entity);
			}
			break;
			
		case PotP_A_Gwent:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Gwent') ) 
			{
				PotP_Logger("Adding " + entity.item_name, , this.fileName);
				notifications.AddToBackGroundArray_Item(entity);
			}
			break;
			
		default:
			break;
		}
	}
	
	//---------------------------------------------------
	
	function UnlockEvent(entity: PotP_PreviewEntry) : void
	{
		FactsSet(entity.entryname + "_unlocked", 1);
		PotP_Logger("Unlocked Event " + entity.localname);
	}
	
	//---------------------------------------------------
	
	function IsEventUnlocked(entity: PotP_PreviewEntry) : bool
	{
		return FactsQuerySum(entity.entryname + "_unlocked") > 0;	
	}

	//---------------------------------------------------
	
	function GetEventDescription(entity: PotP_PreviewEntry) : string
	{
		return GetLocStringByKeyExt(entity.entryname + "_Description");
	}
	
	//---------------------------------------------------
	
	function GetEventLocation(entity: PotP_PreviewEntry) : string
	{	
		switch (entity.region)
		{
		case PotP_R_VE:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_2");
			
		case PotP_R_NO:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_3");

		case PotP_R_SK:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_4");	

		case PotP_R_KM:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_6");
		
		default:
			return "";
		}	
	}
	
	//---------------------------------------------------
	
	function GetIconPath(entity: PotP_PreviewEntry) : string
	{
		var icon_path: string = thePlayer.GetInventory().GetItemIconPathByName(entity.item_name);

		switch(entity.arrayType)
		{
			case PotP_A_Event: return GetQuestIconPath(entity); break;
			case PotP_A_Quest: return GetQuestIconPath(entity); break;
			case PotP_A_World: return GetWorldIconpath(entity); break;
			case PotP_A_Gwent: if (icon_path == "") { return "icons/inventory/gwint/ico_gwent_hero_neutral.png"; } return icon_path; break;
			case PotP_A_Items: if (icon_path == "") { return "icons/inventory/weapons/silver_unique_aerondight_64x128.png"; } return icon_path; break;
		}
	}

	//---------------------------------------------------

	function SetCardType(entity: PotP_PreviewEntry, preset_type: PotP_Preview_CardType) : void
	{
		var gwintManager 	: CR4GwintManager;
		var cardDefinition 	: SCardDefinition;
		
		if (preset_type != PotP_G_None)
		{
			entity.card_type = preset_type;
			return;
		}
		
		gwintManager = theGame.GetGwintManager();
		cardDefinition = gwintManager.GetCardDefinition(GetWitcherPlayer().GetGwentCardIndex(entity.item_name));
		
		if (cardDefinition.index >= 1000) 
		{
			entity.card_type = PotP_G_Lead;
			return;
		}
		
		if ((cardDefinition.typeFlags & GwintType_Hero) == GwintType_Hero)
		{
			entity.card_type = PotP_G_Hero;
			return;
		}
		
		entity.card_type = PotP_G_Unit;
		return;
	}
	
	//---------------------------------------------------
	
	function SetCardOrigin(entity: PotP_PreviewEntry) : void
	{
		var request: string = "Source";
		var sourceCSV : C2dArray;
		var Idx: int;
		
		sourceCSV = LoadCSV("qa\card_sources.csv");
		
		if ( PotP_UsingGwentRedux() )
		{
			sourceCSV = LoadCSV("gameplay\globals\card_sources.csv");
			request = "Details";
		}

		for ( Idx = 0 ; Idx < sourceCSV.GetNumRows() ; Idx += 1 )
		{
			if (sourceCSV.GetValueAsName("CardName", Idx) == entity.item_name)
			{
				switch(sourceCSV.GetValue(request, Idx))
				{
				case "Quest":
				case "gwint_source_quest":
					entity.card_origin = PotP_G_Reward;
					break;
				
				case "Won":
				case "gwint_source_duel":
					entity.card_origin =  PotP_G_Dualed;
					break;
				
				case "Loot":
				case "gwint_source_loot":
					entity.card_origin =  PotP_G_Looted;
					break;
				
				case "Bought":
				case "gwint_source_shop":
					entity.card_origin =  PotP_G_Bought;
					break;					
			
				default:
					entity.card_origin =  PotP_G_Dualed;
					break;
				}
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Global Functions                             //
	////////////////////////////////////////////////////////////////////////////////
	
	function SetType(entity: PotP_PreviewEntry) : void
	{
		switch (entity.type)
		{
		case PotP_E_Missable:
			entity.is_missable = true;
			break;

		case PotP_E_Missable_DLC1:
			entity.is_missable = true;
			entity.is_dlc1 = true;
			break;
			
		case PotP_E_Missable_DLC2:
			entity.is_missable = true;
			entity.is_dlc2 = true;
			break;

		case PotP_E_ModAdded:
			entity.is_modadded = true;
			break;		

		case PotP_E_ModAdded_DLC1:
			entity.is_modadded = true;
			entity.is_dlc1 = true;
			break;		

		case PotP_E_ModAdded_DLC2:
			entity.is_modadded = true;
			entity.is_dlc2 = true;
			break;		
	
		case PotP_E_Primary_DLC1:
			entity.is_dlc1 = true;
			break;	

		case PotP_E_Primary_DLC2:
			entity.is_dlc2 = true;
			break;	
		
		default:
			entity.is_missable = false;
			entity.is_modadded = false;
			entity.is_dlc1 = false;
			entity.is_dlc2 = false;
			break;
		}
	}

	//---------------------------------------------------
	
	function getID(entity: PotP_PreviewEntry) : string 
	{
		if ( (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Iden') ) 
		{
			return "[" + entity.identifier + "] - ";
		}
		return "";
	}
	
	//---------------------------------------------------
	
	function IsItemCollected(entity: PotP_PreviewEntry) : bool
	{
		return FactsQuerySum(entity.item_name + "_collected") > 0;	
	}
	
	//---------------------------------------------------
	
	function isVariation(entity: PotP_PreviewEntry, item_name: name) : bool
	{
		return !isBase(entity, item_name) && entity.variations.Contains(item_name);
	}
	
	//---------------------------------------------------
	
	function isBase(entity: PotP_PreviewEntry, item_name: name) : bool
	{
		return item_name == entity.item_name;
	}
	
	//---------------------------------------------------
	
	function GetItemslocalisedNotificationLine(filter: PotP_Preview_Items_Filter) : string
	{
		switch(filter)
		{
		case PotP_I_Troph:
			return GetLocStringByKeyExt("PotP_NotificationLine_Troph");

		case PotP_I_Relic:
			return GetLocStringByKeyExt("PotP_NotificationLine_Relic");

		case PotP_I_Gwent:
			return GetLocStringByKeyExt("PotP_NotificationLine_Gwent");
			
		case PotP_I_Gears:
			return GetLocStringByKeyExt("PotP_NotificationLine_GearSet");
			
		case PotP_I_Shade:
			return GetLocStringByKeyExt("PotP_NotificationLine_ShadesOfIron");

		case PotP_I_Wiecej:
			return GetLocStringByKeyExt("PotP_NotificationLine_CosWiecej");

		case PotP_I_Sezon:
			return GetLocStringByKeyExt("PotP_NotificationLine_SezonBurz");

		case PotP_I_W3eer:
			return GetLocStringByKeyExt("PotP_NotificationLine_W3EE");
			
		default:
			return "";
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               World Functions                              //
	////////////////////////////////////////////////////////////////////////////////
	
	function GetWorldIconpath(entity: PotP_PreviewEntry) : string
	{
		switch (entity.filter)
		{
			case PotP_I_Camps: return "icons/PotP/tracked_banditcamp_dark.png";
			case PotP_I_MDens: return "icons/PotP/tracked_monsterden_dark.png";
			case PotP_I_Nests: return "icons/PotP/tracked_monsternest_dark.png";
			case PotP_I_Place: return "icons/PotP/tracked_placeofpower_dark.png";
			case PotP_I_Signs: return "icons/PotP/tracked_roadsign_dark.png";
			case PotP_I_Sites: return "icons/PotP/tracked_AbandonedSite_dark.png";
			case PotP_I_Guard: return "icons/PotP/tracked_guardedtreasure_dark.png";
			case PotP_I_Distr: return "icons/PotP/tracked_personindistress_dark.png";
			case PotP_I_Knigh: return "icons/PotP/tracked_DistressedKnight_dark.png";
			case PotP_I_Infes: return "icons/PotP/tracked_VineyardInfestation_dark.png";
			case PotP_I_Hanse: return "icons/PotP/tracked_HanseBase_dark.png";
		}
	}
	
	//---------------------------------------------------
	
	function GetWorldlocalisedNotificationLine(filter: PotP_Preview_World_Filter) : string
	{
		switch(filter)
		{
		case PotP_I_Camps:
			return GetLocStringByKeyExt("PotP_NotificationLine_Camps");

		case PotP_I_MDens:
			return GetLocStringByKeyExt("PotP_NotificationLine_MoDen");
			
		case PotP_I_Nests:
			return GetLocStringByKeyExt("PotP_NotificationLine_MoNes");

		case PotP_I_Place:
			return GetLocStringByKeyExt("PotP_NotificationLine_Place");
			
		case PotP_I_Signs:
			return GetLocStringByKeyExt("PotP_NotificationLine_SignP");

		case PotP_I_Sites:
			return GetLocStringByKeyExt("PotP_NotificationLine_Sites");

		case PotP_I_Guard:
			return GetLocStringByKeyExt("PotP_NotificationLine_Guard");

		case PotP_I_Distr:
			return GetLocStringByKeyExt("PotP_NotificationLine_Distress");
			
		case PotP_I_Knigh:
			return GetLocStringByKeyExt("PotP_NotificationLine_Knigh");
	
		case PotP_I_Infes:
			return GetLocStringByKeyExt("PotP_NotificationLine_Infes");
	
		case PotP_I_Hanse:
			return GetLocStringByKeyExt("PotP_NotificationLine_Hanse");

		default:
			return "";
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//                               Quest Functions                              //
	////////////////////////////////////////////////////////////////////////////////
	
	function GetQuestIconPath(entity: PotP_PreviewEntry) : string
	{
		if (entity.is_dlc1) 
		{ 
			return "icons/PotP/tracked_blue.png";
		}
		
		if (entity.is_dlc2) 
		{ 
			return "icons/PotP/tracked_red.png";
		}
		
		return "icons/PotP/tracked_gold.png";
	}
	
	//---------------------------------------------------
	
	function GetQuestlocalisedNotificationLine(entity: PotP_PreviewEntry, filter: PotP_Preview_Quest_Filter) : string
	{
		switch(filter)
		{
		case PotP_I_Mains:
			
			switch (entity.type)
			{
			case PotP_E_Primary_DLC1:
			case PotP_E_Missable_DLC1:
			case PotP_E_ModAdded_DLC1:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai2");

			case PotP_E_Primary_DLC2:
			case PotP_E_Missable_DLC2:
			case PotP_E_ModAdded_DLC2:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai3");
			
			default:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai1");
			}

		case PotP_I_Sides:
			
			switch (entity.type)
			{
			case PotP_E_Primary_DLC1:
			case PotP_E_Missable_DLC1:
			case PotP_E_ModAdded_DLC1:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid2");

			case PotP_E_Primary_DLC2:
			case PotP_E_Missable_DLC2:
			case PotP_E_ModAdded_DLC2:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid3");
			
			default:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid1");
			}

		case PotP_I_Conts:
		
			switch (entity.type)
			{
			case PotP_E_Primary_DLC1:
			case PotP_E_Missable_DLC1:
			case PotP_E_ModAdded_DLC1:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con2");

			case PotP_E_Primary_DLC2:
			case PotP_E_Missable_DLC2:
			case PotP_E_ModAdded_DLC2:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con3");
			
			default:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con1");
			}
			
		case PotP_I_Hunts:
			
			switch (entity.type)
			{
			case PotP_E_Primary_DLC1:
			case PotP_E_Missable_DLC1:
			case PotP_E_ModAdded_DLC1:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre2");

			case PotP_E_Primary_DLC2:
			case PotP_E_Missable_DLC2:
			case PotP_E_ModAdded_DLC2:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre3");
			
			default:
				return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre1");
			}

		case PotP_I_Scavs:
			return GetLocStringByKeyExt("PotP_NotificationLine_Quest_Scav");

		case PotP_I_Event:
			return GetLocStringByKeyExt("PotP_NotificationLine_Event");
		
		default:
			return "";
		}
	}
}
