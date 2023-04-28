//---------------------------------------------------
//-- Preview Entry  ---------------------------------
//---------------------------------------------------

enum PotP_Preview_CardOrigin
{
	PotP_G_NoIdea = 0, //Unknown
	PotP_G_Bought = 1, //Bought
	PotP_G_Looted = 2, //looted
	PotP_G_Reward = 3, //Quest Reward
	PotP_G_Dualed = 4, //Unique Dual
}

enum PotP_Preview_CardType
{
	PotP_G_None = 0, //Undefined
	PotP_G_Lead = 1, //Leader
	PotP_G_Hero = 2, //Hero
	PotP_G_Unit = 3, //Unit
}

enum PotP_Preview_Region 
{
	PotP_R_NA = 0, //All
	PotP_R_WO = 1, //White Orchard
	PotP_R_VE = 2, //Velen
	PotP_R_NO = 3, //Novigrad
	PotP_R_SK = 4, //Skellige
	PotP_R_TO = 5, //Toussaint
	PotP_R_KM = 6, //Kaer Morhen
	PotP_R_VI = 7, //Vizima
	PotP_R_TS = 8  //The Spiral
}

enum PotP_Preview_Array_Type 
{
	PotP_A_Quest = 0, // Quest
	PotP_A_World = 1, // World
	PotP_A_Items = 2, // Items
	PotP_A_Event = 3, // Event
	PotP_A_Gwent = 4  // Gwent
}

enum PotP_Preview_Entry_Type 
{
	PotP_E_Primary  	 = 0, // Normal Entry
	PotP_E_Primary_DLC1  = 1, // Normal Entry (HOS)
	PotP_E_Primary_DLC2  = 2, // Normal Entry (BAW)
	
	PotP_E_Missable 	 = 3, // Missable Entry
	PotP_E_Missable_DLC1 = 4, // Missable Entry (HOS)
	PotP_E_Missable_DLC2 = 5, // Missable Entry (BAW)
	
	PotP_E_ModAdded		 = 6, // Mod Added Entry
	PotP_E_ModAdded_DLC1 = 7, // Mod Added Entry (HOS)
	PotP_E_ModAdded_DLC2 = 8  // Mod Added Entry (BAW)
}

enum PotP_Preview_Items_Underlying_Filter
{
	PotP_U_Armor  	 = 1,
	PotP_U_Boots  	 = 2,
	PotP_U_Pants  	 = 3,
	PotP_U_Glove  	 = 4,
	PotP_U_Head  	 = 5,
	PotP_U_Steel  	 = 6,
	PotP_U_Silve  	 = 7,
	PotP_U_Cross	 = 8,
	PotP_U_Troph	 = 9,
}

enum PotP_Preview_Items_Filter
{
	PotP_I_Relic  	 = 1,
	PotP_I_Gears  	 = 2,
	PotP_I_Troph  	 = 3,
	PotP_I_Gwent  	 = 4,
	PotP_I_Sezon	 = 5,
	PotP_I_Shade	 = 6,
	PotP_I_W3eer	 = 7,
	PotP_I_Wiecej	 = 8,
};

enum PotP_Preview_World_Filter
{
	PotP_I_Camps	 = 1,
	PotP_I_MDens	 = 2,
	PotP_I_Nests	 = 3,
	PotP_I_Place	 = 4,
	PotP_I_Signs	 = 5,
	PotP_I_Sites	 = 6,
	PotP_I_Guard	 = 7,
	PotP_I_Distr	 = 8,
	PotP_I_Knigh	 = 9,
	PotP_I_Infes	 = 10,
	PotP_I_Hanse	 = 11,
}

enum PotP_Preview_Quest_Filter
{
	PotP_I_Event	 = 1,
	PotP_I_Mains	 = 2,
	PotP_I_Sides	 = 3,
	PotP_I_Conts	 = 4,
	PotP_I_Scavs	 = 5,
	PotP_I_Hunts	 = 6,
}

enum PotP_Preview_Gwent_Filter
{
	PotP_I_Monst	 = 1,
	PotP_I_Nilfg	 = 2,
	PotP_I_North	 = 3,
	PotP_I_Conts	 = 4,
	PotP_I_Scoia	 = 5,
	PotP_I_Skell	 = 6,
	PotP_I_Neutr	 = 7,
}
	
class PotP_PreviewEntry
{
	//Items Only Variables
	var item_name		: name;
	var variations		: array<name>;
	
	//Gwent Only Variables
	var card_type		: PotP_Preview_CardType;
	var card_origin		: PotP_Preview_CardOrigin;

	//World Only Variables
	var pin_name		: name;
	
	//Event Only Variables
	var region_string	: string;
	var position		: Vector;
	
	//Quest Only Variables
	var is_dlc1 		: bool;
	var is_dlc2 		: bool;
	
	// Global Variables
	var fileName		: name;
	var storage			: CProgressOnThePath_Storage;
	var mappins			: CProgressOnThePath_MapPins;
	var notifications	: CProgressOnThePath_Notifications;
	
	var type			: PotP_Preview_Entry_Type;
	var arrayType		: PotP_Preview_Array_Type;
	var filter			: int;
	var sub_filter		: int;
	var entryname		: string;
	var localname		: string;
	var uuid			: string;
	var identifier		: string;
	var region			: PotP_Preview_Region;
	var is_missable		: bool;
	var is_modadded		: bool;
	
	default fileName = 'PotP Entity';
	
	// init function called when creating the instance of this quest.
	function initQuest(uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, entryname: string): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.entryname 		= entryname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		this.SetType();
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);

		return this;
	}
	
	// init function called when creating the instance of this Random Event.
	function initEvent(uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, initially_unlocked: bool, pin_region: string, factname: string, pin_position: Vector): PotP_PreviewEntry 
	{	
		this.type			= type;
		this.entryname 		= factname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		this.SetType();
		
		this.region_string 	= pin_region;
		this.position 		= pin_position;
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (initially_unlocked) { UnlockEvent(); }
		
		return this;
	}

	// init function called when creating the instance of this World Map pin.
	function initWorld(uuid: string, region: PotP_Preview_Region, filter: PotP_Preview_World_Filter, type: PotP_Preview_Entry_Type, pin: name): PotP_PreviewEntry 
	{	
		this.type 			= type;
		this.pin_name 		= pin;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		this.SetType();	
			
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		return this;
	}

	// init function called when creating the instance of this Item.
	function initItems(uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, sub_filter: PotP_Preview_Items_Underlying_Filter, item_name: name): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.item_name 	 	= item_name;
		this.uuid 			= uuid;
		this.filter	    	= filter;
		this.sub_filter    	= sub_filter;
		this.SetType();

		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (this.IsItemCollected())
		{
			this.SetCompleted();
		}

		return this;
	}

	// init function called when creating the instance of this Gwent Card.
	function initGwent(uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Gwent_Filter, item_name: name, optional card_type: PotP_Preview_CardType): PotP_PreviewEntry 
	{	
		this.type 		 	= type;
		this.item_name 	 	= item_name;
		this.uuid 		 	= uuid;
		this.filter	     	= filter;
		this.SetType();
		
		this.SetCardOrigin();
		this.SetCardType(card_type);
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		//PotP_Logger(localname + " is a " + this.card_type + " card that can be " + this.card_origin, , 'PotP Preview Entry');
		return this;
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Storage Functions                            //
	////////////////////////////////////////////////////////////////////////////////
	
	function IsPlayable() : bool
	{
		return !storage.MasterList_Completed_V.Contains(this.uuid)
			&& !storage.MasterList_IsIgnored_V.Contains(this.uuid);
	}

	//---------------------------------------------------
	
	function IsCompleted() : bool
	{
		return storage.MasterList_Completed_V.Contains(this.uuid);
	}
	
	//---------------------------------------------------
	
	function IsIgnored() : bool
	{
		return storage.MasterList_IsIgnored_V.Contains(this.uuid);
	}
	
	//---------------------------------------------------
	
	function IsInProgress() : bool
	{
		return storage.MasterList_InProgres_V.Contains(this.uuid);
	}
	
	//---------------------------------------------------
	
	function IsCollected() : bool
	{	
		return storage.MasterList_Collected_V.Contains(this.uuid);
	}

	//---------------------------------------------------
	
	function SetCompleted(optional user_forced: bool) : void
	{
		if (!IsCompleted()) 
		{
			storage.MasterList_Completed_V.PushBack(this.uuid);
			PotP_Logger("Added - " + this.localname + " to persistent storage list 'Completed'", , this.fileName);
		}

		if (this.arrayType == PotP_A_Items)
		{
			this.SetCollected();
		}

		if (this.arrayType == PotP_A_Event)
		{
			SU_removeCustomPinByTag("PotP_" + this.uuid);
			PotP_Logger("Removed Map Pin: " + this.localname, , this.fileName);
		}		
		
		this.RemoveInProgress();
		this.RemoveIgnored();

		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(this, 2);
		}
	}		

	//---------------------------------------------------
	
	function SetCollected() : void
	{
		if (!IsCollected()) 
		{
			FactsSet(this.item_name + "_collected", 1);
			storage.MasterList_Collected_V.PushBack(this.uuid);
			PotP_Logger("Added - " + this.localname + " to persistent storage list 'Collected'", , this.fileName);
		}
	}	
	
	//---------------------------------------------------
	
	function SetInProgress() : void
	{
		if (!IsInProgress())
		{
			storage.MasterList_InProgres_V.PushBack(this.uuid);
			PotP_Logger("Added - " + this.localname + " to persistent storage list 'In Progress'", , this.fileName);
		}
			
		this.RemoveCompleted();
		this.RemoveIgnored();
	}

	//---------------------------------------------------
	
	function SetIgnored(optional user_forced: bool) : void
	{
		if (!IsIgnored()) 
		{
			storage.MasterList_IsIgnored_V.PushBack(this.uuid);
			PotP_Logger("Added - " + this.localname + " to persistent storage list 'Ignored'", , this.fileName);
		}

		if (this.arrayType == PotP_A_Event)
		{
			SU_removeCustomPinByTag("PotP_" + this.uuid);
			PotP_Logger("Removed Map Pin: " + this.localname, , this.fileName);
		}
			
		this.RemoveInProgress();
		this.RemoveCompleted();
		
		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(this, 1);
		}
	}
	
	//---------------------------------------------------
	
	function SetAvailable(optional user_forced: bool) : void
	{
		this.RemoveCompleted();
		this.RemoveIgnored();

		if (this.arrayType == PotP_A_Event)
		{
			mappins.GotoState('Updating');
		}
		
		if ( user_forced && (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Enter') )
		{
			notifications.UpdateSingleEntry(this, 0);
		}
	}
	
	//---------------------------------------------------
	
	function UpdateQuestEntry(status: int) : bool 
	{	
		switch (status) 
		{	
		case JS_Success:
		case JS_Failed:
			if (!IsCompleted()) { this.SetCompleted(); return true; }
			return false;

		case JS_Active:		
			if (!IsInProgress()) { this.SetInProgress(); return true; }
			return false;
					
		default: 
			return false;
		}
	}

	//---------------------------------------------------
	
	function RemoveIgnored() : void
	{
		var Idx: int = storage.MasterList_IsIgnored_V.FindFirst(this.uuid);
		
		if (Idx != -1)
		{ 
			storage.MasterList_IsIgnored_V.EraseFast(Idx);
			PotP_Logger("Removed - " + this.localname + " from persistent storage list 'Ignored'", , this.fileName);
		}
	}
	
	//---------------------------------------------------
	
	function RemoveCompleted() : void
	{
		var Idx: int = storage.MasterList_Completed_V.FindFirst(this.uuid);
	
		if (Idx != -1)
		{
			storage.MasterList_Completed_V.EraseFast(Idx);
			PotP_Logger("Removed - " + this.localname + " from persistent storage list 'Completed'", , this.fileName);
		}
	}
	
	//---------------------------------------------------
	
	function RemoveInProgress() : void
	{
		var Idx: int = storage.MasterList_InProgres_V.FindFirst(this.uuid);
		
		if (Idx != -1)
		{ 
			storage.MasterList_InProgres_V.EraseFast(Idx);
			PotP_Logger("Removed - " + this.localname + " from persistent storage list 'In Progress'", , this.fileName);
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Notifications                                //
	////////////////////////////////////////////////////////////////////////////////
	
	function AddToNotificationQueue() : void
	{
		switch (this.arrayType)
		{
		case PotP_A_Quest:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Quest') ) 
			{
				notifications.AddToQuestUpdateArray(this);
			}
			break;
			
		case PotP_A_Event:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Event') ) 
			{
				notifications.AddToQuestUpdateArray(this);
			}
			break;
		
		case PotP_A_World:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_World') ) 
			{
				notifications.AddToWorldMapUpdateArray(this);
			}
			break;
		
		case PotP_A_Items:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Items') ) 
			{
				notifications.AddToItemUpdateArray(this);
			}
			break;
			
		case PotP_A_Gwent:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_FullNotification_Gwent') ) 
			{
				notifications.AddToItemUpdateArray(this);
			}
			break;
			
		default:
			break;
		}
	}
	
	//---------------------------------------------------
	
	function AddToBackgroundQueue(optional status: int) : void
	{		
		switch (this.arrayType)
		{
		case PotP_A_Quest:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Quest') ) 
			{
				notifications.AddToBackGroundArray_Quest(this, status);
			}
			break;
			
		case PotP_A_Event:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Event') ) 
			{
				notifications.AddToBackGroundArray_Quest(this, status);
			}
			break;
		
		case PotP_A_World:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_World') ) 
			{
				notifications.AddToBackGroundArray_WorldMap(this);
			}
			break;
		
		case PotP_A_Items:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Items') ) 
			{
				notifications.AddToBackGroundArray_Item(this);
			}
			break;
			
		case PotP_A_Gwent:
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_BackNotification_Gwent') ) 
			{
				PotP_Logger("Adding " + this.item_name, , this.fileName);
				notifications.AddToBackGroundArray_Item(this);
			}
			break;
			
		default:
			break;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//                               Event Functions                              //
	////////////////////////////////////////////////////////////////////////////////
	
	function UnlockEvent() : void
	{
		FactsSet(this.entryname + "_unlocked", 1);
		//PotP_Logger("Unlocked Event " + this.localname);
	}
	
	//---------------------------------------------------
	
	function IsEventUnlocked() : bool
	{
		return FactsQuerySum(this.entryname + "_unlocked") > 0;	
	}

	//---------------------------------------------------
	
	function GetEventDescription() : string
	{
		return GetLocStringByKeyExt(this.entryname + "_Description");
	}
	
	//---------------------------------------------------
	
	function GetEventLocation() : string
	{	
		switch (this.region)
		{
		case PotP_R_VE:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_2");
			break;
			
		case PotP_R_NO:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_3");
			break;

		case PotP_R_SK:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_4");
			break;			

		case PotP_R_KM:
			return GetLocStringByKeyExt("preset_value_QT_Option_GArea_6");
			break;		
		
		default:
			break;
		}	
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Gwent Functions                              //
	////////////////////////////////////////////////////////////////////////////////
	
	function GetIconPath() : string
	{
		var icon_path: string = thePlayer.GetInventory().GetItemIconPathByName(this.item_name);

		switch(this.arrayType)
		{
			case PotP_A_Event: return GetQuestIconPath(); break;
			case PotP_A_Quest: return GetQuestIconPath(); break;
			case PotP_A_World: return GetWorldIconpath(); break;
			case PotP_A_Gwent: if (icon_path == "") { return "icons/inventory/gwint/ico_gwent_hero_neutral.png"; } return icon_path; break;
			case PotP_A_Items: if (icon_path == "") { return "icons/inventory/weapons/silver_unique_aerondight_64x128.png"; } return icon_path; break;
		}
	}

	//---------------------------------------------------

	function SetCardType(preset_type: PotP_Preview_CardType) : void
	{
		var gwintManager 	: CR4GwintManager;
		var cardDefinition 	: SCardDefinition;
		
		if (preset_type != PotP_G_None)
		{
			this.card_type = preset_type;
			return;
		}
		
		gwintManager = theGame.GetGwintManager();
		cardDefinition = gwintManager.GetCardDefinition(GetWitcherPlayer().GetGwentCardIndex(this.item_name));
		
		if (cardDefinition.index >= 1000) 
		{
			this.card_type = PotP_G_Lead;
			return;
		}
		
		if ((cardDefinition.typeFlags & GwintType_Hero) == GwintType_Hero)
		{
			this.card_type = PotP_G_Hero;
			return;
		}
		
		this.card_type = PotP_G_Unit;
		return;
	}
	
	//---------------------------------------------------
	
	function SetCardOrigin() : void
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
			if (sourceCSV.GetValueAsName("CardName", Idx) == this.item_name)
			{
				switch(sourceCSV.GetValue(request, Idx))
				{
				case "Quest":
				case "gwint_source_quest":
					this.card_origin = PotP_G_Reward;
					break;
				
				case "Won":
				case "gwint_source_duel":
					this.card_origin =  PotP_G_Dualed;
					break;
				
				case "Loot":
				case "gwint_source_loot":
					this.card_origin =  PotP_G_Looted;
					break;
				
				case "Bought":
				case "gwint_source_shop":
					this.card_origin =  PotP_G_Bought;
					break;					
			
				default:
					this.card_origin =  PotP_G_Dualed;
					break;
				}
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Global Functions                             //
	////////////////////////////////////////////////////////////////////////////////
	
	function SetType() : void
	{
		switch (this.type)
		{
		case PotP_E_Missable:
			this.is_missable = true;
			break;

		case PotP_E_Missable_DLC1:
			this.is_missable = true;
			this.is_dlc1 = true;
			break;
			
		case PotP_E_Missable_DLC2:
			this.is_missable = true;
			this.is_dlc2 = true;
			break;

		case PotP_E_ModAdded:
			this.is_modadded = true;
			break;		

		case PotP_E_ModAdded_DLC1:
			this.is_modadded = true;
			this.is_dlc1 = true;
			break;		

		case PotP_E_ModAdded_DLC2:
			this.is_modadded = true;
			this.is_dlc2 = true;
			break;		
	
		case PotP_E_Primary_DLC1:
			this.is_dlc1 = true;
			break;	

		case PotP_E_Primary_DLC2:
			this.is_dlc2 = true;
			break;	
		
		default:
			this.is_missable = false;
			this.is_modadded = false;
			this.is_dlc1 = false;
			this.is_dlc2 = false;
			break;
		}
	}

	//---------------------------------------------------
	
	function getID() : string 
	{
		if ( (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Iden') ) 
		{
			return "[" + this.identifier + "] - ";
		}
		return "";
	}

	////////////////////////////////////////////////////////////////////////////////
	//                               Items Functions                              //
	////////////////////////////////////////////////////////////////////////////////
	
	function IsItemCollected() : bool
	{
		return FactsQuerySum(this.item_name + "_collected") > 0;	
	}
	
	//---------------------------------------------------
	
	function compilevariations(optional var1: name, optional var2: name, optional var3: name, optional var4: name) : PotP_PreviewEntry
	{
		this.variations.Clear();
		this.variations.PushBack(this.item_name);
		
		if (var1 != '') { this.addvariation(var1); }
		if (var2 != '') { this.addvariation(var2); }
		if (var3 != '') { this.addvariation(var3); }
		if (var4 != '') { this.addvariation(var4); }
		
		return this;
	}
	
	//---------------------------------------------------
	
	function addvariation(variation_name: name)
	{
		this.variations.PushBack(variation_name);
		//PotP_Logger("Variation [" + variation_name + "] Assigned to Base Item " + this.item_name,, this.fileName);
	}
	
	//---------------------------------------------------
	
	function isVariation(item_name: name) : bool
	{
		return this.variations.Contains(item_name) && item_name != this.item_name;
	}
	
	//---------------------------------------------------
	
	function isBase(item_name: name) : bool
	{
		return item_name == this.item_name;
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
			
		case PotP_I_Gears:
			return GetLocStringByKeyExt("PotP_NotificationLine_GearSet");

		case PotP_I_Gwent:
			return GetLocStringByKeyExt("PotP_NotificationLine_Gwent");
			
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
	
	function GetWorldIconpath() : string
	{
		switch (this.filter)
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
	
	function GetQuestIconPath() : string
	{
		if (this.is_dlc1) 
		{ 
			return "icons/PotP/tracked_blue.png";
		}
		
		if (this.is_dlc2) 
		{ 
			return "icons/PotP/tracked_red.png";
		}
		
		return "icons/PotP/tracked_gold.png";
	}
	
	//---------------------------------------------------
	
	function GetQuestlocalisedNotificationLine(filter: PotP_Preview_Quest_Filter) : string
	{
		switch(filter)
		{
		case PotP_I_Mains:
			
			switch (this.type)
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
			
			switch (this.type)
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
		
			switch (this.type)
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
			
			switch (this.type)
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

//---------------------------------------------------
//-- Console Functions For Quest Update -------------
//---------------------------------------------------

enum pStatus
{
	completed = 2,
	ignored = 1,
}

exec function pt_changestatus(identifier: string, optional value: pStatus) 
{
	var master: CProgressOnThePath;	
	var EntList: array<PotP_PreviewEntry>;
	var IdeList: array<string>;
	var Idx: int;

	if (!GetPotP(master, "Storage")) { return; }

	EntList = master.PotP_PersistentStorage.pArrayStorage.TotalEntList;	
	IdeList = master.PotP_PersistentStorage.pArrayStorage.TotalIdeList;
	Idx = IdeList.FindFirst(identifier);
	
	if (Idx == -1) { return; }
	
	switch (value) 
	{
	case completed:	
		EntList[Idx].SetCompleted(true);
		break;
		
	case ignored:
		EntList[Idx].SetIgnored(true);
		break;
		
	default:
		EntList[Idx].SetAvailable(true);
		break;
	}
}

