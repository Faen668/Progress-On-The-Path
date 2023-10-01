//Depreciated Classes to remove on next new game version
class CProgressOnThePath_ArrayHandler {
}

//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

class CProgressOnThePath extends SU_BaseBootstrappedMod {
	
	public var fileName: name;
		default fileName = 'PotP Main';
		
	public saved var PotP_PersistentStorage: CProgressOnThePath_Storage;
	
	public var PotP_UpdaterClass:		CProgressOnThePath_UpdaterClass;
	public var PotP_PinManager: 		CProgressOnThePath_MapPins;
	public var PotP_QuestPreview: 		CProgressOnThePath_QuestPreview;
	public var PotP_WorldPreview: 		CProgressOnThePath_WorldPreview;
	public var PotP_ItemsPreview: 		CProgressOnThePath_ItemsPreview;
	public var PotP_GwentPreview: 		CProgressOnThePath_GwentPreview;
	public var PotP_MissablePreview: 	CProgressOnThePath_MissablePreview;	
	public var PotP_Notifications: 		CProgressOnThePath_Notifications;
	public var PotP_PopupManager: 		CProgressOnThePath_TutorialPopup;
	public var PotP_ItemsGoblin: 		CProgressOnThePath_ItemsGoblin;
	public var PotP_QuestGoblin: 		CProgressOnThePath_QuestGoblin;
	public var PotP_WorldGoblin: 		CProgressOnThePath_WorldGoblin;
	public var PotP_EventListener: 		CProgressOnThePath_EventListener;
	public var PotP_MeditationListener: CProgressOnThePath_MeditationListener;
	public var PotP_EntityHelper:		CProgressOnThePath_PreviewEntryHelper;
	
	//Depreciated Classes to remove on next new game version
	public var PotP_ArrayManager: 		CProgressOnThePath_ArrayHandler;		
	default tag = 'CProgressOnThePath_BootStrapper';

	public var LastUpdateTime: float;
		default LastUpdateTime = 0;
			
	//---------------------------------------------------
	
	public function start() 
	{			
		PotP_Logger("Bootstrapped successfully with Magic, prayers and wishful thinking...", , this.fileName);
		
		theInput.RegisterListener(this, 'UpdateProgressOnThePath', 'UpdateProgressOnThePath');
		theInput.RegisterListener(this, 'DisplayProgressPreview', 'DisplayProgressPreview');
		
		PotP_UpdaterClass = new	CProgressOnThePath_UpdaterClass in this;
		PotP_PopupManager = new CProgressOnThePath_TutorialPopup in this;
		PotP_EntityHelper = new CProgressOnThePath_PreviewEntryHelper in this;
		
		PotP_ItemsGoblin = new CProgressOnThePath_ItemsGoblin in this;
		PotP_QuestGoblin = new CProgressOnThePath_QuestGoblin in this;
		PotP_WorldGoblin = new CProgressOnThePath_WorldGoblin in this;
		
		PotP_QuestPreview = new CProgressOnThePath_QuestPreview in this;
		PotP_WorldPreview = new CProgressOnThePath_WorldPreview in this;
		PotP_ItemsPreview = new CProgressOnThePath_ItemsPreview in this;
		PotP_GwentPreview = new CProgressOnThePath_GwentPreview in this;
		PotP_MissablePreview = new CProgressOnThePath_MissablePreview in this;
		
		PotP_Notifications = new CProgressOnThePath_Notifications in this;
		PotP_PinManager = new CProgressOnThePath_MapPins in this;
		PotP_EventListener = new CProgressOnThePath_EventListener in this;
		PotP_MeditationListener = new CProgressOnThePath_MeditationListener in this;
		
		//Init Storage
		if (!PotP_PersistentStorage) 
		{
			PotP_PersistentStorage = new CProgressOnThePath_Storage in this;
			PotP_Logger("New storage instance created.", , 'PotP Storage');
		}
		PotP_PersistentStorage.PotP_LoadStorageCollection();
	}	
	
	//---------------------------------------------------
	
	public function SetModVersion() 
	{
		var newModVersion_Str: string = "5.2.8.1";
		var newModVersion_Int: int = 5281;

		var initStr: string = "PotP_Initialised";
		var VersStr: string = "ProgressOnThePath_CurrentModVersion";

		//pt_checkfact("ProgressOnThePath_CurrentModVersion")
		
		if (FactsQuerySum(initStr) != 1) 
		{
			this.LoadDefaults();
			FactsSet(initStr, 1);
			FactsSet(VersStr, newModVersion_Int);

			PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_InstallMessage"), "PotP_InstallMessage", "Hint", true);
			return;
		}

		if (this.UpdateMod(VersStr, newModVersion_Int)) 
		{
			PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_UpdatedMessage") + newModVersion_Str, "", "Hint", false);
		}
	}
	
	//---------------------------------------------------
	
	private function UpdateMod(VersStr: string, newModVersion_Int: int) : bool
	{
		if (FactsQuerySum(VersStr) < newModVersion_Int) 
		{
			if (FactsQuerySum(VersStr) < 527) { PotP_PersistentStorage.PotP_LoadStorageCollection('All'); FactsSet(VersStr, 527);}
			if (FactsQuerySum(VersStr) < 5281) { FactsSet(VersStr, 5281);}
			return true;
		}
		
		return false;
	}
	
	//---------------------------------------------------
	
	public function LoadDefaults() 
	{	
		var VarManager: CInGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_MeditationUpdate', 					"true");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EnableHotKey', 						"true");
		
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ShowMapPins', 			"true");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinDescription', 	"true");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinRadius', 			"30");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinType', 			"1");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ShowMiniMap', 			"false");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ArrowPointers', 		"false");
		VarManager.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_HighlightedPointers', 	"false");
		
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview', 							"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_Comp', 						"true");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_Igno', 						"false");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_Iden', 						"false");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_QArea', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_QType', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_IType', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_GArea', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_GType', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_GExtra', 					"false");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_WArea', 						"0");
		VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview_WType', 						"0");

		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Time', 		"7");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Size', 		"18");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Font', 		"1");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Quest', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_World', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Items', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Gwent', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Event', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Nulls', 		"true");
		
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Quest', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_World', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Items', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Gwent', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Event', 		"true");
		
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Event', 		"true");
		VarManager.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Enter', 		"true");
	}
	
	//---------------------------------------------------

	public function DisplayProgressPreview(action : SInputAction) 
	{ 
		var messagetitle	: string;
		var activefilters	: string;
		var description		: string;
		var countstring		: string;
		
		switch ( (int) PotP_GetPreviewValue('ProgressOnThePath_Preview') )
		{
		case 0:
			messagetitle   = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_QuestPreviewMessage_T") + "<br/>";
			activefilters  = PotP_QuestPreview.GetActiveFilters() + "</p><br/>";
			description    = PotP_QuestPreview.GetBookDescription();
			countstring	   = PotP_QuestPreview.GetTotalCountsForPreview();
		
			if (PotP_QuestPreview.IsCompleted())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
			}
			
			if (description == "")
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
			}
 
			PotP_PopupManager.Showpopup(StrReplace((messagetitle + activefilters), "REPLACECOUNT", countstring), description, "", "PopUp", false);
			break;
			
		case 1:
			messagetitle   = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_WorldPreviewMessage_T") + "<br/>";
			activefilters  = PotP_WorldPreview.GetActiveFilters() + "</p><br/>";
			description    = PotP_WorldPreview.GetBookDescription();
			countstring	   = PotP_WorldPreview.GetTotalCountsForPreview();
		
			if (PotP_WorldPreview.IsCompleted())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
			}
			
			if (description == "")
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
			}

			PotP_PopupManager.Showpopup(StrReplace((messagetitle + activefilters), "REPLACECOUNT", countstring), description, "", "PopUp", false);
			break;
			
		case 2:
			messagetitle   = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_ItemsPreviewMessage_T") + "<br/>";
			activefilters  = PotP_ItemsPreview.GetActiveFilters() + "</p><br/>";
			description    = PotP_ItemsPreview.GetBookDescription();
			countstring	   = PotP_ItemsPreview.GetTotalCountsForPreview();
		
			if (PotP_ItemsPreview.IsCompleted())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
			}
			
			if (description == "")
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
			}

			PotP_PopupManager.Showpopup(StrReplace((messagetitle + activefilters), "REPLACECOUNT", countstring), description, "", "PopUp", false);
			break;
			
		case 3:
			messagetitle   = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_GwentPreviewMessage_T") + "<br/>";
			activefilters  = PotP_GwentPreview.GetActiveFilters() + "</p><br/>";
			description    = PotP_GwentPreview.GetBookDescription();
			countstring	   = PotP_GwentPreview.GetTotalCountsForPreview();

			if (PotP_GwentPreview.IsCompleted())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
			}
			
			if (!PotP_GwentPreview.CanAccess())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterGwentDeck") + "</p>";
			}
			
			if (description == "")
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
			}

			PotP_PopupManager.Showpopup(StrReplace((messagetitle + activefilters), "REPLACECOUNT", countstring), description, "", "PopUp", false);
			break;

		case 4:
			messagetitle   = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_MissablePreviewMessage_T") + "</p><br/>";
			description    = PotP_MissablePreview.GetBookDescription();
			countstring	   = PotP_MissablePreview.GetTotalCountsForPreview();
		
			if (PotP_MissablePreview.IsCompleted())
			{
				description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
			}

			PotP_PopupManager.Showpopup(StrReplace((messagetitle), "REPLACECOUNT", countstring), description, "", "PopUp", false);
			break;
		}
	}
	
	//---------------------------------------------------

	public function UpdateProgressOnThePath(action : SInputAction) 
	{
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_EnableHotKey') )
		{
			if ((theGame.GetEngineTimeAsSeconds() - LastUpdateTime) > 5) 
			{
				LastUpdateTime = theGame.GetEngineTimeAsSeconds();
				PotP_UpdaterClass.StartUpdate(false);
			}
		}
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_ItemsGoblin extends IInventoryScriptedListener
{
	public var filename: name; 
		default filename = 'PotP Item Goblin';
	
	public var ent_list: array<PotP_PreviewEntry>;
	public var itm_list: array<name>;

	public var player_inv: CInventoryComponent;
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	public var notifications: CProgressOnThePath_Notifications;
	public var last_addition_time: float;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.storage = master.PotP_PersistentStorage;
		this.entity_helper = master.PotP_EntityHelper;
		this.notifications = master.PotP_Notifications;
		
		this.itm_list = storage.pItemsStorage.SupportedItemsList;
		this.ent_list = storage.pItemsStorage.SupportedItemsList_Entity;
		this.player_inv = thePlayer.inv;
		
		player_inv.AddListener(this);
	}
	
	//---------------------------------------------------
	
	event OnInventoryScriptedEvent( eventType : EInventoryEventType, itemId : SItemUniqueId, quantity : int, fromAssociatedInventory : bool ) 
	{
		PotP_Logger("Got Proc with " + player_inv.GetItemName(itemId));
		
		if (eventType != IET_ItemAdded) 
		{
			return true;
		}
		
		if (this.IsInState('Disabled')) 
		{
			PotP_Logger("Got Disabled");
			return true;
		}
		
		PotP_Logger("Got Enabled");
		PotP_Logger("List size = " + itm_list.Size());
		
		if ( itm_list.Contains(player_inv.GetItemName(itemId)) )
		{
			PotP_Logger("Got Item");
			this.storage.MasterList_ItemsGoblin.PushBack(itemId);
			this.last_addition_time = theGame.GetEngineTimeAsSeconds();
			
			if (!this.IsInState('ItemAdded')) 
			{ 
				this.GotoState('ItemAdded'); 
			}
		}
		PotP_Logger("Got No Item");
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_ItemsGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_ItemsGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		if (parent.storage.MasterList_ItemsGoblin.Size() > 0)
		{
			parent.GotoState('ItemAdded');
		}
		else
		{
			parent.notifications.NotifyPlayerFromBackgroundProcess();
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state ItemAdded in CProgressOnThePath_ItemsGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [ItemAdded]", , parent.filename);
	
		this.ItemAdded_Entry();
	}

//---------------------------------------------------

	entry function ItemAdded_Entry()
	{	
		var current_time, sleep_time: float;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		current_time = theGame.GetEngineTimeAsSeconds();
		sleep_time = 3;
		
		while (current_time - parent.last_addition_time < sleep_time)
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			Sleep(1);
		}
		
		this.ProcessItem();
		parent.storage.MasterList_ItemsGoblin.Erase(0);
		parent.GotoState('Idle');
	}

//---------------------------------------------------
	
	latent function ProcessItem()
	{
		var Idx, Edx, min, max: int;
		var item_name: name;
		var entry_data: PotP_PreviewEntry;

		item_name = parent.player_inv.GetItemName(parent.storage.MasterList_ItemsGoblin[0]);
			
		Edx = parent.itm_list.FindFirst(item_name);
		if (Edx == -1)
		{
			return;
		}
		
		entry_data = parent.ent_list[Edx];
		
		parent.player_inv.GetItemQualityFromName(item_name, min, max);
		if ( parent.entity_helper.IsPlayable(entry_data) && (min >= 4 || parent.player_inv.ItemHasTag(parent.storage.MasterList_ItemsGoblin[0], 'GwintCard') ) ) 
		{
			PotP_Logger("Processing " + entry_data.item_name, , parent.filename);
			parent.entity_helper.AddToBackgroundQueue(entry_data);
			parent.entity_helper.SetCompleted(entry_data);
		}
		
		SleepOneFrame();
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_QuestGoblin
{	
	public var filename: name;
		default filename = 'PotP Quest Goblin';

	public var quest_entity_array: array<PotP_PreviewEntry>;
	public var quest_lookup_array: array<string>;

	public var manager: CWitcherJournalManager;
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	public var last_addition_time: float;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		this.storage = master.PotP_PersistentStorage;
		
		this.quest_entity_array = storage.pQuestStorage.MasterList_Quests;
		this.quest_lookup_array = storage.pQuestStorage.MasterList_Quests_Lookup;
		this.manager = theGame.GetJournalManager();
	}
	
	//---------------------------------------------------
	
	public function _OnQuestUpdate(journalQuest : CJournalQuest) 
	{
		if (this.IsInState('Disabled')) 
		{ 
			return;
		}

		if ( quest_lookup_array.Contains(journalQuest.baseName) )
		{
			this.storage.MasterList_QuestGoblin.PushBack(journalQuest);
			this.last_addition_time = theGame.GetEngineTimeAsSeconds();
			
			if (!this.IsInState('QuestUpdated')) 
			{ 
				this.GotoState('QuestUpdated'); 
			}
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_QuestGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_QuestGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);

		if (parent.storage.MasterList_QuestGoblin.Size() > 0)
		{
			parent.GotoState('QuestUpdated');
		}
		else
		{
			parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state QuestUpdated in CProgressOnThePath_QuestGoblin
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [QuestUpdated]", , parent.filename);
	
		this._QuestUpdated_Entry();
	}

//---------------------------------------------------

	entry function _QuestUpdated_Entry() 
	{	
		var current_time, sleep_time: float;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		current_time = theGame.GetEngineTimeAsSeconds();
		sleep_time = 3;
		
		while (current_time - parent.last_addition_time < sleep_time)
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			Sleep(1);
		}

		this.ProcessQuest();
		parent.storage.MasterList_QuestGoblin.Erase(0);
		parent.GotoState('Idle');
	}

//---------------------------------------------------
	
	latent function ProcessQuest() 
	{	
		var Idx: int = parent.quest_lookup_array.FindFirst(parent.storage.MasterList_QuestGoblin[0].baseName);
		var status: int = parent.manager.GetEntryStatus(parent.storage.MasterList_QuestGoblin[0]);

		if (Idx != -1 && parent.entity_helper.UpdateQuestEntry(parent.quest_entity_array[Idx], status))
		{			
			parent.entity_helper.AddToBackgroundQueue(parent.quest_entity_array[Idx], status);
		}
			
		SleepOneFrame();		
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_WorldGoblin
{
	public var filename: name; 
		default filename = 'PotP World Goblin';
	
	public var master: CProgressOnThePath;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_WorldGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_WorldGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);

		this.Idle_Entry();
	}

//---------------------------------------------------

	entry function Idle_Entry() {

		Sleep( 5 );

		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.GotoState('Checking');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Checking in CProgressOnThePath_WorldGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Checking]", , parent.filename);
		
		this.Checking_Main();
	}

//---------------------------------------------------

	entry function Checking_Main()
	{	
		var MapManager: CCommonMapManager = theGame.GetCommonMapManager();		
		var pData_E: array<PotP_PreviewEntry> = parent.master.PotP_PersistentStorage.pWorldStorage.MasterList_World;		
		var Idx: int;

		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{
			if (this.IsMapPinEligible(pData_E[Idx], MapManager)) {
				parent.entity_helper.SetCompleted(pData_E[Idx]);
				parent.entity_helper.AddToBackgroundQueue(pData_E[Idx]);
			}
		}
		
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	private function IsMapPinEligible(entry_data: PotP_PreviewEntry, MapManager: CCommonMapManager) : bool {
		
		if (!parent.entity_helper.IsPlayable(entry_data))
		{
			return false;
		}

		if (entry_data.pin_name == 'ep1_poi09_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi09_mp_bugfix');
		}

		if (entry_data.pin_name == 'ep1_poi23_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi23_mp_bugfix');
		}
		
		if (entry_data.filter == PotP_I_Signs) {
			return MapManager.IsEntityMapPinDiscovered(entry_data.pin_name);
		}
		
		return MapManager.IsEntityMapPinDisabled(entry_data.pin_name);
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_EventListener
{
	
	public var filename: name; 
		default filename = 'PotP Event Listener';
	
	public var master: CProgressOnThePath;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);

		this.Idle_Main();
	}

//---------------------------------------------------

	entry function Idle_Main() { 
		
		Sleep(5);
		
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.GotoState('Checking');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Checking in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Checking]", , parent.filename);
		
		this.Checking_Main();
	}

//---------------------------------------------------

	entry function Checking_Main()
	{	
		var events_array	: array<PotP_PreviewEntry>;
		var i: int;
		
		events_array = parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
		
		for ( i = 0; i < events_array.Size(); i += 1 ) 
		{
			if (FactsQuerySum(events_array[i].entryname) > 0) 
			{
				if (!parent.entity_helper.IsPlayable(events_array[i])) 
				{
					continue;
				}
				
				PotP_CompleteEventByString(events_array[i].entryname);
			}
		}
		parent.GotoState('Idle');
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_MeditationListener {

	public var filename: name; 
	default filename = 'PotP Meditation Listener';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_MeditationListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_MeditationListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		this.Idle_Entry();
	}

//---------------------------------------------------

	entry function Idle_Entry() 
	{        
		while (!PotP_PlayerIsMeditating()) 
		{
			SleepOneFrame();
		}
		
		parent.GotoState('Update');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Update in CProgressOnThePath_MeditationListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Update]", , parent.filename);
		
		this.Update_Entry();
	}

//---------------------------------------------------

	entry function Update_Entry() 
	{		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_MeditationUpdate') )
		{
			parent.master.PotP_UpdaterClass.StartUpdate(true);
		}
		
        while (PotP_PlayerIsMeditating()) 
		{
			SleepOneFrame();
		}
		parent.GotoState('Idle');
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_GwentPreview
{
	public var fileName: name;
		default fileName = 'PotP Gwent Preview';	
	
	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_GwentPreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.CanAccess() && this.completed_count == this.total_count;
	}	

	//---------------------------------------------------
	
	public function CanAccess() : bool 
	{
		return theGame.GetGwintManager().HasLootedCard();
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_GType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_GArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_GType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_GArea_" + areaFilter);
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string 
	{
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		
		if (!GwentManager.HasLootedCard()) 
		{
			return "";
		}
		
		build("PotP_Preview_Gwent_1", master.PotP_PersistentStorage.pItemsStorage.Gwent_MonstersDeck);
		build("PotP_Preview_Gwent_2", master.PotP_PersistentStorage.pItemsStorage.Gwent_NeutralDeck);
		build("PotP_Preview_Gwent_3", master.PotP_PersistentStorage.pItemsStorage.Gwent_NilfgaardDeck);
		build("PotP_Preview_Gwent_4", master.PotP_PersistentStorage.pItemsStorage.Gwent_NorthernRealms);
		build("PotP_Preview_Gwent_5", master.PotP_PersistentStorage.pItemsStorage.Gwent_Scoiatael);
		
		if (GwentManager.IsDeckUnlocked(GwintFaction_Skellige))
		{
			build("PotP_Preview_Gwent_6", master.PotP_PersistentStorage.pItemsStorage.Gwent_Skellige);
		}
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_GwentCardBuilder in thePlayer)
			.init(master)
			.setFilters(this.areaFilter, this.typeFilter)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_ItemsPreview
{
	public var fileName: name;
		default fileName = 'PotP Items Preview';	

	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_ItemsPreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.completed_count == this.total_count;
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_IType');
		return GetLocStringByKeyExt("preset_value_QT_Option_IType_" + typeFilter);
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string 
	{
		build("PotP_Preview_GearS_1", master.PotP_PersistentStorage.pItemsStorage.Armor_DolBlathanna);
		build("PotP_Preview_GearS_2", master.PotP_PersistentStorage.pItemsStorage.Armor_ForgottenWolven);
		build("PotP_Preview_GearS_3", master.PotP_PersistentStorage.pItemsStorage.Armor_HenGaidth);
		build("PotP_Preview_GearS_4", master.PotP_PersistentStorage.pItemsStorage.Armor_NewMoon);
		build("PotP_Preview_GearS_5", master.PotP_PersistentStorage.pItemsStorage.Armor_Nilfgaardian);
		build("PotP_Preview_GearS_6", master.PotP_PersistentStorage.pItemsStorage.Armor_Ofieri);	
		build("PotP_Preview_GearS_7", master.PotP_PersistentStorage.pItemsStorage.Armor_Temerian);
		build("PotP_Preview_GearS_8", master.PotP_PersistentStorage.pItemsStorage.Armor_TeshamMutna);
		build("PotP_Preview_GearS_9", master.PotP_PersistentStorage.pItemsStorage.Armor_Undvik);
		build("PotP_Preview_GearS_A", master.PotP_PersistentStorage.pItemsStorage.Armor_WhiteTiger);

		build("PotP_Preview_DLCC_1",  master.PotP_PersistentStorage.pItemsStorage.DLC_CosWiecej);
		build("PotP_Preview_DLCC_5",  master.PotP_PersistentStorage.pItemsStorage.DLC_Dimeritium);
		build("PotP_Preview_DLCC_3",  master.PotP_PersistentStorage.pItemsStorage.DLC_Gothic);
		build("PotP_Preview_DLCC_4",  master.PotP_PersistentStorage.pItemsStorage.DLC_Meteorite);
		build("PotP_Preview_DLCC_2",  master.PotP_PersistentStorage.pItemsStorage.DLC_SezonBurz);

		build("PotP_Preview_Shad_01", master.PotP_PersistentStorage.pItemsStorage.Shades_Berserker);
		build("PotP_Preview_Shad_02", master.PotP_PersistentStorage.pItemsStorage.Shades_Bismarck);
		build("PotP_Preview_Shad_03", master.PotP_PersistentStorage.pItemsStorage.Shades_BloodHunter);
		build("PotP_Preview_Shad_04", master.PotP_PersistentStorage.pItemsStorage.Shades_CrowFeathered);
		build("PotP_Preview_Shad_05", master.PotP_PersistentStorage.pItemsStorage.Shades_FallenKnight);
		build("PotP_Preview_Shad_06", master.PotP_PersistentStorage.pItemsStorage.Shades_Faraam);
		build("PotP_Preview_Shad_07", master.PotP_PersistentStorage.pItemsStorage.Shades_Headtaker);
		build("PotP_Preview_Shad_08", master.PotP_PersistentStorage.pItemsStorage.Shades_Hitokiri);
		build("PotP_Preview_Shad_09", master.PotP_PersistentStorage.pItemsStorage.Shades_Kara);
		build("PotP_Preview_Shad_10", master.PotP_PersistentStorage.pItemsStorage.Shades_LionHunter);
		build("PotP_Preview_Shad_11", master.PotP_PersistentStorage.pItemsStorage.Shades_Assassin);
		build("PotP_Preview_Shad_12", master.PotP_PersistentStorage.pItemsStorage.Shades_OldHunter);
		build("PotP_Preview_Shad_13", master.PotP_PersistentStorage.pItemsStorage.Shades_Revenant);
		build("PotP_Preview_Shad_14", master.PotP_PersistentStorage.pItemsStorage.Shades_Stalker);
		build("PotP_Preview_Shad_15", master.PotP_PersistentStorage.pItemsStorage.Shades_Taifeng);
		build("PotP_Preview_Shad_16", master.PotP_PersistentStorage.pItemsStorage.Shades_Unseen);
		build("PotP_Preview_Shad_17", master.PotP_PersistentStorage.pItemsStorage.Shades_Sithis);
		build("PotP_Preview_Shad_18", master.PotP_PersistentStorage.pItemsStorage.Shades_SilverSwords);
		build("PotP_Preview_Shad_19", master.PotP_PersistentStorage.pItemsStorage.Shades_SteelSwords);

		build("PotP_Preview_Troph_1", master.PotP_PersistentStorage.pItemsStorage.Relic_Trophies);
		build("PotP_Preview_Relic_3", master.PotP_PersistentStorage.pItemsStorage.Relic_Crossbows);
		build("PotP_Preview_Relic_2", master.PotP_PersistentStorage.pItemsStorage.Relic_SteelSwords);
		build("PotP_Preview_Relic_1", master.PotP_PersistentStorage.pItemsStorage.Relic_SilverSwords);
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(0, this.typeFilter)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_MissablePreview
{
	public var fileName: name;
		default fileName = 'PotP Gwent Preview';	
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_MissablePreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.completed_count == this.total_count;
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string 
	{
		var start: float = theGame.GetLocalTimeAsMilliseconds();
		
		build("PotP_Preview_Missable_00", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_InstantFails);
		build("PotP_Preview_Missable_01", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q001);
		build("PotP_Preview_Missable_13", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Ugly);
		build("PotP_Preview_Missable_02", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q401);
		build("PotP_Preview_Missable_03", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_SQ101);
		build("PotP_Preview_Missable_12", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q301);
		build("PotP_Preview_Missable_04", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q303);
		build("PotP_Preview_Missable_05", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_SQ106);
		build("PotP_Preview_Missable_06", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q501);
		build("PotP_Preview_Missable_07", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q206);
		build("PotP_Preview_Missable_08", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q210);
		build("PotP_Preview_Missable_09", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q112);
		build("PotP_Preview_Missable_10", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q403);
		build("PotP_Preview_Missable_11", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q702);
		
		PotP_Logger("Missable Preview Took " + (theGame.GetLocalTimeAsMilliseconds() - start) + " Milliseconds To Generate");
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(0, 0)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_QuestPreview
{
	public var fileName: name;
		default fileName = 'PotP Quest Preview';	

	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_QuestPreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.completed_count == this.total_count;
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_QType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_QArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_QType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_QArea_" + areaFilter);
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string
	{
		build("PotP_Preview_Event_1", master.PotP_PersistentStorage.pEventStorage.RandomEvents_Velen);
		build("PotP_Preview_Event_2", master.PotP_PersistentStorage.pEventStorage.RandomEvents_Novigrad);
		build("PotP_Preview_Event_3", master.PotP_PersistentStorage.pEventStorage.RandomEvents_Skellige);
		build("PotP_Preview_Event_4", master.PotP_PersistentStorage.pEventStorage.RandomEvents_KaerMorhen);
		
		build("PotP_Preview_MainQ_1", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Prologue);
		build("PotP_Preview_MainQ_2", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Act1_Velen);
		build("PotP_Preview_MainQ_3", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Act1_Novigrad);
		build("PotP_Preview_MainQ_4", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Act1_Skellige);
		build("PotP_Preview_MainQ_5", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Act2);
		build("PotP_Preview_MainQ_6", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Act3);
		build("PotP_Preview_MainQ_7", master.PotP_PersistentStorage.pQuestStorage.MainQuests_DLC1);
		build("PotP_Preview_MainQ_8", master.PotP_PersistentStorage.pQuestStorage.MainQuests_DLC2);
		build("PotP_Preview_MainQ_9", master.PotP_PersistentStorage.pQuestStorage.MainQuests_Vizima);		
		
		build("PotP_Preview_SideQ_1", master.PotP_PersistentStorage.pQuestStorage.SideQuests_WhiteOrchard);
		build("PotP_Preview_SideQ_2", master.PotP_PersistentStorage.pQuestStorage.SideQuests_Velen);
		build("PotP_Preview_SideQ_3", master.PotP_PersistentStorage.pQuestStorage.SideQuests_Novigrad);
		build("PotP_Preview_SideQ_4", master.PotP_PersistentStorage.pQuestStorage.SideQuests_Skellige);
		build("PotP_Preview_SideQ_5", master.PotP_PersistentStorage.pQuestStorage.SideQuests_KaerMorhen);
		build("PotP_Preview_SideQ_6", master.PotP_PersistentStorage.pQuestStorage.SideQuests_Toussaint);
		build("PotP_Preview_SideQ_7", master.PotP_PersistentStorage.pQuestStorage.SideQuests_NonRegional);	
		
		build("PotP_Preview_ContQ_1", master.PotP_PersistentStorage.pQuestStorage.ContQuests_WhiteOrchard);
		build("PotP_Preview_ContQ_2", master.PotP_PersistentStorage.pQuestStorage.ContQuests_Velen);
		build("PotP_Preview_ContQ_3", master.PotP_PersistentStorage.pQuestStorage.ContQuests_Novigrad);
		build("PotP_Preview_ContQ_4", master.PotP_PersistentStorage.pQuestStorage.ContQuests_Skellige);
		build("PotP_Preview_ContQ_5", master.PotP_PersistentStorage.pQuestStorage.ContQuests_Toussaint);	
		
		build("PotP_Preview_ScavQ_1", master.PotP_PersistentStorage.pQuestStorage.ScavQuests_Griffin);
		build("PotP_Preview_ScavQ_2", master.PotP_PersistentStorage.pQuestStorage.ScavQuests_Feline);
		build("PotP_Preview_ScavQ_3", master.PotP_PersistentStorage.pQuestStorage.ScavQuests_Ursine);
		build("PotP_Preview_ScavQ_4", master.PotP_PersistentStorage.pQuestStorage.ScavQuests_Wolven);
		build("PotP_Preview_ScavQ_5", master.PotP_PersistentStorage.pQuestStorage.ScavQuests_Others);		
		
		build("PotP_Preview_TreaQ_1", master.PotP_PersistentStorage.pQuestStorage.HuntQuests_WhiteOrchard);
		build("PotP_Preview_TreaQ_2", master.PotP_PersistentStorage.pQuestStorage.HuntQuests_Velen);
		build("PotP_Preview_TreaQ_3", master.PotP_PersistentStorage.pQuestStorage.HuntQuests_Novigrad);
		build("PotP_Preview_TreaQ_4", master.PotP_PersistentStorage.pQuestStorage.HuntQuests_Skellige);
		build("PotP_Preview_TreaQ_5", master.PotP_PersistentStorage.pQuestStorage.HuntQuests_Toussaint);
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(this.areaFilter, this.typeFilter)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_WorldPreview
{
	public var fileName: name;
		default fileName = 'PotP World Preview';	

	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_WorldPreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.completed_count == this.total_count;
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_WType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_WArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_WType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_WArea_" + areaFilter);
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string 
	{
		build("PotP_Preview_Sites_1", master.PotP_PersistentStorage.pWorldStorage.AbandonedSites_WhiteOrchard);
		build("PotP_Preview_Sites_2", master.PotP_PersistentStorage.pWorldStorage.AbandonedSites_Velen);
		build("PotP_Preview_Sites_3", master.PotP_PersistentStorage.pWorldStorage.AbandonedSites_Novigrad);
		build("PotP_Preview_Sites_4", master.PotP_PersistentStorage.pWorldStorage.AbandonedSites_Skellige);
		build("PotP_Preview_Sites_5", master.PotP_PersistentStorage.pWorldStorage.AbandonedSites_Toussaint);
	
		build("PotP_Preview_Camps_1", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_WhiteOrchard);
		build("PotP_Preview_Camps_2", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Velen);
		build("PotP_Preview_Camps_3", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Novigrad);
		build("PotP_Preview_Camps_4", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Skellige);
		build("PotP_Preview_Camps_5", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Toussaint);

		build("PotP_Preview_Guard_1", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_WhiteOrchard);
		build("PotP_Preview_Guard_2", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_Velen);
		build("PotP_Preview_Guard_3", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_Novigrad);
		build("PotP_Preview_Guard_4", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_Skellige);
		build("PotP_Preview_Guard_5", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_KaerMorhen);
		build("PotP_Preview_Guard_6", master.PotP_PersistentStorage.pWorldStorage.GuardedTreasure_Toussaint);
		
		build("PotP_Preview_DensM_1", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Velen);
		build("PotP_Preview_DensM_2", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Novigrad);
		build("PotP_Preview_DensM_3", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Skellige);
		build("PotP_Preview_DensM_4", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Toussaint);
		
		build("PotP_Preview_NestM_1", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_WhiteOrchard);
		build("PotP_Preview_NestM_2", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Velen);
		build("PotP_Preview_NestM_3", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Novigrad);
		build("PotP_Preview_NestM_4", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Skellige);
		build("PotP_Preview_NestM_5", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Toussaint);
		
		build("PotP_Preview_Touss_1", master.PotP_PersistentStorage.pWorldStorage.HanseBases);
		build("PotP_Preview_Touss_2", master.PotP_PersistentStorage.pWorldStorage.DistressedKnights_Toussaint);
		build("PotP_Preview_Touss_3", master.PotP_PersistentStorage.pWorldStorage.InfestedVineyards_Toussaint);
		
		build("PotP_Preview_Place_1", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_WhiteOrchard);
		build("PotP_Preview_Place_2", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Velen);
		build("PotP_Preview_Place_3", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Novigrad);
		build("PotP_Preview_Place_4", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Skellige);
		build("PotP_Preview_Place_5", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_KaerMorhen);
		build("PotP_Preview_Place_6", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Toussaint);
		build("PotP_Preview_Place_7", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_TheSpiral);

		build("PotP_Preview_Distr_1", master.PotP_PersistentStorage.pWorldStorage.PersonsInDistress_Velen);
		build("PotP_Preview_Distr_2", master.PotP_PersistentStorage.pWorldStorage.PersonsInDistress_Skellige);
		build("PotP_Preview_Distr_3", master.PotP_PersistentStorage.pWorldStorage.PersonsInDistress_Toussaint);
		
		build("PotP_Preview_SignP_1", master.PotP_PersistentStorage.pWorldStorage.Signposts_WhiteOrchard);
		build("PotP_Preview_SignP_2", master.PotP_PersistentStorage.pWorldStorage.Signposts_Velen);	
		build("PotP_Preview_SignP_3", master.PotP_PersistentStorage.pWorldStorage.Signposts_Novigrad);
		build("PotP_Preview_SignP_4", master.PotP_PersistentStorage.pWorldStorage.Signposts_Skellige);
		build("PotP_Preview_SignP_5", master.PotP_PersistentStorage.pWorldStorage.Signposts_KaerMorhen);
		build("PotP_Preview_SignP_6", master.PotP_PersistentStorage.pWorldStorage.Signposts_Toussaint);
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(this.areaFilter, this.typeFilter)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
class CProgressOnThePath_ArrayStorage
{
	var TotalEntList	: array<PotP_PreviewEntry>;
	var TotalVarList	: array<string>;
	var TotalGrpList	: array<string>;
	var TotalIdeList	: array<string>;

	var fileName		: name;
	default fileName 	= 'PotP Array Storage';

//---------------------------------------------------

	function inititalise()
	{
		this.TotalVarList.Clear();
		this.TotalGrpList.Clear();
		this.TotalIdeList.Clear();
		this.TotalEntList.Clear();
	}
}

//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_EventStorage
{		
	var MasterList_Events			:array<PotP_PreviewEntry>;
	
	var RandomEvents_Velen			: array<PotP_PreviewEntry>;
	var RandomEvents_Novigrad		: array<PotP_PreviewEntry>;
	var RandomEvents_Skellige		: array<PotP_PreviewEntry>;
	var RandomEvents_KaerMorhen		: array<PotP_PreviewEntry>;	
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Event Storage';

//---------------------------------------------------
	
	function inititalise()
	{
		this.GotoState('Build');
	}

//---------------------------------------------------
	
	function CreateEntry() : PotP_PreviewEntry
	{
		return new PotP_PreviewEntry in this; 
	}

//---------------------------------------------------

	function CreateUniqueIdentifier() : string 
	{
		UUIDINT += 1;
		return "EX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_EventStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Build State ------------------------------------
//---------------------------------------------------
	
state Build in CProgressOnThePath_EventStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	

	entry function Build()
	{
		var group    : string;
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);

		parent.MasterList_Events.Clear();

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_RandomEvents_Velen";
		
		parent.RandomEvents_Velen.Clear();
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_1_NG", 	Vector(641.454102, 533.142456)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_CaravanAttack_NG_1", 			Vector(1311.539551, 404.800537)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "no_mans_land", "PotP_Event_CaravanAttack_NG_2", 			Vector(207.837814, 75.866135)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_DeadlyCrossing_3_NG", 			Vector(-29.826519, -101.255219)	)); //Troll Bridge
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "no_mans_land", "PotP_Event_DeadlyCrossing_1_NG", 			Vector(794.722107, 266.272644)	));	//Lindenvale
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_DeadlyCrossing_2_NG", 			Vector(1087.826294, -295.390381))); //Dragonslayer's Grotto
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_FaceMeIfYouDare_1_NG", 			Vector(213.855240, -32.358776)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HarassingATroll_NG", 			Vector(138.532272, 811.463623)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HighwayRobbery_NG", 				Vector(300.595459, -135.326324)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HighwaymansCache_NG", 			Vector(519.180176, -212.923065)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersHeatherton_NG", 			Vector(151.509430, 508.062775)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersCodgersQuarry_NG", 		Vector(1221.132690, 831.181274)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersToderas_NG", 				Vector(1720.736694, 67.942719)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_MansBestFriend_NG", 				Vector(643.049805, 799.665344)	));
		
		PotP_SortPreviewData(parent.RandomEvents_Velen, PotP_A_Event, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_Novigrad";
		
		parent.RandomEvents_Novigrad.Clear();
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_AWarmWelcome_NG", 				Vector(1347.046143, 1591.817261)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_2_NG", 		Vector(393.423737, 1265.788696)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_DrunkenRabble_NG", 				Vector(543.444885, 1839.808228)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_2_NG", 			Vector(899.003479, 1732.530640)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_3_NG", 			Vector(505.266266, 1915.563843)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_KarmicJustice_NG", 				Vector(862.002502, 1831.773438)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_NeverTrustChildren_NG", 		Vector(765.527771, 1932.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_RacistsOfNovigradFC_NG", 			Vector(858.879944, 1819.517700)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_RacistsOfNovigradHS_NG", 		Vector(553.651428, 1677.662231)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_StrangersInTheNight_NG", 		Vector(1370.983887, 1507.835815)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_StrumpetInDistress_NG", 		Vector(411.762390, 1672.084839)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_SuspiciousShakedown_NG", 			Vector(739.579529, 1761.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_TheFlameOfHatred_NG_1", 		Vector(714.057678, 1861.176392)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_TheFlameOfHatred_NG_2", 			Vector(793.164673, 1868.151978)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_TheMostTruestOfBasilisks_NG", 	Vector(1911.729736, 1141.309082)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_ThePriceOfPassage_NG_1", 		Vector(1678.246338, 1037.727295)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_2", 			Vector(1766.244873, 1038.741089)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_3", 			Vector(1932.989990, 1070.466309)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_WitchHunterRaids_NG", 			Vector(580.663086, 1569.924316)		));
		
		PotP_SortPreviewData(parent.RandomEvents_Novigrad, PotP_A_Event, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_Skellige";
		
		parent.RandomEvents_Skellige.Clear();
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_CallOfTheWild_NG", 			Vector(-526.447571, -340.631042)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_FartingTrolls_NG", 			Vector(-283.890625, -769.414673)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_SirensCall_NG", 			Vector(-409.181061, -202.543701)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_SweetBait_NG", 				Vector(-443.542175, -307.774261)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_TheFourFacesOfHemdall_NG", 	Vector(2011.217651, -1851.521729)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_WoeIsMe_NG", 				Vector(552.972961, -411.028778)		));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_YustiannaDisturbed_NG", 	Vector(677.762207, 635.591064)		));
		
		PotP_SortPreviewData(parent.RandomEvents_Skellige, PotP_A_Event, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_KaerMorhen";
		
		parent.RandomEvents_KaerMorhen.Clear();
		parent.RandomEvents_KaerMorhen.PushBack(parent.CreateEntry().initEvent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_KM, PotP_I_Event, true, "kaer_morhen", "PotP_Event_TrailOfEchoes_NG", Vector(-327.778656, 175.190674)	));
		
		PotP_SortPreviewData(parent.RandomEvents_KaerMorhen, PotP_A_Event, master);

		//------------------------------------------------------

		for ( Idx = 0; Idx < parent.MasterList_Events.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Events[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Events[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Events[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Events[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Events[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Events[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Events[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}
}

//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_ItemsStorage
{		
	var master 						:CProgressOnThePath;
	
	var MasterList_Items			:array<PotP_PreviewEntry>;
	
	var Relic_Trophies				: array<PotP_PreviewEntry>;
	var Relic_Crossbows				: array<PotP_PreviewEntry>;
	var Relic_SteelSwords			: array<PotP_PreviewEntry>;
	var Relic_SilverSwords			: array<PotP_PreviewEntry>;	
	
	var Armor_DolBlathanna			: array<PotP_PreviewEntry>;	
	var Armor_ForgottenWolven		: array<PotP_PreviewEntry>;	
	var Armor_HenGaidth				: array<PotP_PreviewEntry>;	
	var Armor_NewMoon				: array<PotP_PreviewEntry>;	
	var Armor_Nilfgaardian			: array<PotP_PreviewEntry>;	
	var Armor_Ofieri				: array<PotP_PreviewEntry>;	
	var Armor_Temerian				: array<PotP_PreviewEntry>;	
	var Armor_TeshamMutna			: array<PotP_PreviewEntry>;	
	var Armor_Undvik				: array<PotP_PreviewEntry>;	
	var Armor_WhiteTiger			: array<PotP_PreviewEntry>;	
	
	var DLC_CosWiecej				: array<PotP_PreviewEntry>;	
	var DLC_Dimeritium				: array<PotP_PreviewEntry>;	
	var DLC_Gothic					: array<PotP_PreviewEntry>;	
	var DLC_Meteorite				: array<PotP_PreviewEntry>;	
	var DLC_SezonBurz				: array<PotP_PreviewEntry>;	
	
	var Shades_Assassin				: array<PotP_PreviewEntry>;	
	var Shades_Berserker			: array<PotP_PreviewEntry>;	
	var Shades_Bismarck				: array<PotP_PreviewEntry>;	
	var Shades_BloodHunter			: array<PotP_PreviewEntry>;	
	var Shades_CrowFeathered		: array<PotP_PreviewEntry>;	
	var Shades_FallenKnight			: array<PotP_PreviewEntry>;	
	var Shades_Faraam				: array<PotP_PreviewEntry>;	
	var Shades_Headtaker			: array<PotP_PreviewEntry>;	
	var Shades_Hitokiri				: array<PotP_PreviewEntry>;	
	var Shades_Kara					: array<PotP_PreviewEntry>;	
	var Shades_LionHunter			: array<PotP_PreviewEntry>;	
	var Shades_OldHunter			: array<PotP_PreviewEntry>;	
	var Shades_Revenant				: array<PotP_PreviewEntry>;	
	var Shades_SilverSwords			: array<PotP_PreviewEntry>;	
	var Shades_Sithis				: array<PotP_PreviewEntry>;	
	var Shades_Stalker				: array<PotP_PreviewEntry>;	
	var Shades_SteelSwords			: array<PotP_PreviewEntry>;	
	var Shades_Taifeng				: array<PotP_PreviewEntry>;	
	var Shades_Unseen				: array<PotP_PreviewEntry>;

	var Gwent_MonstersDeck			: array<PotP_PreviewEntry>;
	var Gwent_NeutralDeck			: array<PotP_PreviewEntry>;
	var Gwent_NilfgaardDeck			: array<PotP_PreviewEntry>;
	var Gwent_NorthernRealms		: array<PotP_PreviewEntry>;
	var Gwent_Scoiatael				: array<PotP_PreviewEntry>;
	var Gwent_Skellige				: array<PotP_PreviewEntry>;	

	var SupportedItemsList			: array<name>;
	var SupportedItemsList_Entity	: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Items Storage';

//---------------------------------------------------
	
	function inititalise()
	{
		this.GotoState('Build');
	}

//---------------------------------------------------
	
	function CreateEntry() : PotP_PreviewEntry
	{
		return new PotP_PreviewEntry in this; 
	}

//---------------------------------------------------

	function CreateUniqueIdentifier() : string 
	{
		UUIDINT += 1;
		return "IX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_ItemsStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Build State ------------------------------------
//---------------------------------------------------
	
state Build in CProgressOnThePath_ItemsStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	
	
	//-----------------------------------------------
	
	entry function Build()
	{
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MasterList_Items.Clear();
		
		this.BuildVanilla();	
		this.BuildModAdded();
		
		if (PotP_UsingGwentRedux()) {
			this.BuildGwentReduxCards();
		}
		else {
			this.BuildGwentCards();
		}		

		for ( Idx = 0; Idx < parent.MasterList_Items.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Items[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Items[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Items[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Items[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Items[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Items[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Items[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}
	
	//-----------------------------------------------
	
	latent function BuildVanilla()
	{	
		var group	: string;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_Relics_SteelSwords_W3EE";
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna_crafted')	.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword_crafted')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'PC Caretaker Shovel')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')							.compilevariations(''));
		
			PotP_SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items, master);

			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_SilverSwords_W3EE";
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe_crafted')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned_crafted')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Adversary Silver Sword')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment_crafted')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')						.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items, master);

			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_Crossbows_W3EE";
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.Relic_Crossbows, PotP_A_Items, master);
		}
		else
		{		
			group = "PotP_TrackingGroup_Relics_SteelSwords";
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Angivare')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator')						.compilevariations('Arbitrator_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ashrune')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie')						.compilevariations('Beannshie_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn')						.compilevariations('Blackunicorn_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Bloedeaedd')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Karabela')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caroline')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cleaver')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dyaebl')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dancer')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Daystar')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 2')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 1')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Forgottenvransword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwestog')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Harvall')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hjalmar_Short_Steel_Sword')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Vynbleidd')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw')							.compilevariations('Longclaw_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Mourner')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Iron Poker')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Squire steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gnomish sword 2')					.compilevariations('Gnomish sword 2_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl2 steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl1 steel sword 3')			.compilevariations('Guard lvl1 steel sword 3 Autogen'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Toussaint steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_53", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hanza steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_54", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_55", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Abarad')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_56", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_57", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Wolf')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_58", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_59", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Top Notch Steel')					.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_SilverSwords";
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Addandeith')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 3R')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anathema')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anth')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Arainne')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bladeofys')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'WitcherSilverWolf')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Breathofthenorth')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 1R')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deargdeith')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deithwen')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 1')				.compilevariations('Serpent Silver Sword 1 Autogen'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations('Serpent Silver Sword 3'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvael')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvaelaedd')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy')								.compilevariations('Harpy_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Loathen')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Moonblade')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator')							.compilevariations('Negotiator_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'DLC10_Remorse')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 2')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Torzirael')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'mq4005 Silver sword 6_crafted')		.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper')								.compilevariations('Weeper_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q505 crafted sword')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Top Notch Silver')					.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items, master);	

			//------------------------------------------------------
		
			group = "PotP_TrackingGroup_Relics_Crossbows";
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow 7')			.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
		
			PotP_SortPreviewData(parent.Relic_Crossbows, PotP_A_Items, master);
		}

		group = "PotP_TrackingGroup_Trophies";
		
		parent.Relic_Trophies.Clear();
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh102_arachas_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'sq108_griffin_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh201_cave_troll_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh107_czart_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh101_cockatrice_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q603_sharley_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh305_doppler_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh306_dao_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh210_lamia_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh104_ekimma_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh206_fiend_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh108_fogling_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh208_forktail_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q704_garkain_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q701_cyclops_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh106_gravehag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh301_gryphon_trophy')			.compilevariations('q002_griffin_trophy', 'mq7009_griffin_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7002_spriggan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh304_katakan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q602_pig_contest_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh204_leshy_trophy')				.compilevariations('mh302_leshy_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh202_nekker_warrior_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh103_nightwraith_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq0003_noonwraith_trophy')		.compilevariations('mh308_noonwraith_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh701_sharley_matriarch_trophy')	.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7018_basilisk_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7010_dracolizard_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh303_succubus_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'camm_trophy')						.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7017_zmora_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh203_water_hag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q702_wicht_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh307_minion_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh207_wraith_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh105_wyvern_trophy')				.compilevariations('mq1051_wyvern_trophy'));
		
		PotP_SortPreviewData(parent.Relic_Trophies, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_ForgottenWolven";
		parent.Armor_ForgottenWolven.Clear();
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Netflix Armor')		.compilevariations('Netflix Armor 1', 			'Netflix Armor 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Netflix Boots')		.compilevariations('Netflix Boots 1', 			'Netflix Boots 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Netflix Gloves')		.compilevariations('Netflix Gloves 1', 			'Netflix Gloves 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Netflix Pants')		.compilevariations('Netflix Pants 1', 			'Netflix Pants 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Netflix steel sword')	.compilevariations('Netflix steel sword 1', 	'Netflix steel sword 2',  'Reinald Netflix steel sword'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'Netflix silver sword')	.compilevariations('Netflix silver sword 1', 	'Netflix silver sword 2', 'Reinald Netflix silver sword'));
		
		PotP_SortPreviewData(parent.Armor_ForgottenWolven, PotP_A_Items, master);

		//------------------------------------------------------
	
		group = "PotP_TrackingGroup_GearSets_DolBlathanna";
		parent.Armor_DolBlathanna.Clear();
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Dol Blathanna Armor')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Dol Blathanna Boots')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Dol Blathanna Gloves')		 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Dol Blathanna Pants')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Dol Blathanna longsword')		 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'White Widow of Dol Blathanna') .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_DolBlathanna, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_WhiteTiger";
		parent.Armor_WhiteTiger.Clear();
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'White Tiger Armor')	 .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'White Tiger Boots')	 .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'White Tiger Gloves') .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'White Tiger Pants')	 .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_WhiteTiger, PotP_A_Items, master);			

		//------------------------------------------------------

		group = "PotP_TrackingGroup_GearSets_HenGaidth";
		parent.Armor_HenGaidth.Clear();
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q704_vampire_armor')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q704_vampire_boots')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q704_vampire_gloves') .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q704_vampire_mask')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q704_vampire_pants')	 .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_HenGaidth, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_NewMoon";
		parent.Armor_NewMoon.Clear();
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Thief Armor')	.compilevariations('Thief Armor No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Thief Boots')	.compilevariations('Thief Boots No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Thief Gloves') .compilevariations('Thief Gloves No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Thief Pants')	.compilevariations('Thief Pants No Medallion'));
		
		PotP_SortPreviewData(parent.Armor_NewMoon, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Nilfgaardian";
		parent.Armor_Nilfgaardian.Clear();
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC5 Nilfgaardian Armor')	 .compilevariations('NGP DLC5 Nilfgaardian Armor'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC5 Nilfgaardian Boots')	 .compilevariations('NGP DLC5 Nilfgaardian Boots'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC5 Nilfgaardian Gloves') .compilevariations('NGP DLC5 Nilfgaardian Gloves'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC5 Nilfgaardian Pants')	 .compilevariations('NGP DLC5 Nilfgaardian Pants'));
		
		PotP_SortPreviewData(parent.Armor_Nilfgaardian, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Ofieri";
		parent.Armor_Ofieri.Clear();
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Crafted Ofir Armor') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Crafted Ofir Boots') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Crafted Ofir Gloves') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Crafted Ofir Pants') 	.compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_Ofieri, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Temerian";
		parent.Armor_Temerian.Clear();
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC1 Temerian Armor')	 .compilevariations('NGP DLC1 Temerian Armor'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC1 Temerian Boots')	 .compilevariations('NGP DLC1 Temerian Boots'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC1 Temerian Gloves') .compilevariations('NGP DLC1 Temerian Gloves'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC1 Temerian Pants')	 .compilevariations('NGP DLC1 Temerian Pants'));
		
		PotP_SortPreviewData(parent.Armor_Temerian, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_TeshamMutna";
		parent.Armor_TeshamMutna.Clear();
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q702_vampire_armor')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q702_vampire_boots')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q702_vampire_gloves')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q702_vampire_mask')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q702_vampire_pants')	.compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_TeshamMutna, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Undvik";
		parent.Armor_Undvik.Clear();
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC14 Skellige Armor')		.compilevariations('NGP DLC14 Skellige Armor'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC14 Skellige Boots')		.compilevariations('NGP DLC14 Skellige Boots'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC14 Skellige Gloves')		.compilevariations('NGP DLC14 Skellige Gloves'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC14 Skellige Pants')		.compilevariations('NGP DLC14 Skellige Pants'));
		
		PotP_SortPreviewData(parent.Armor_Undvik, PotP_A_Items, master);
	}

	latent function BuildModAdded()
	{
		var group	: string;
		var master : CProgressOnThePath;
		GetPotP(master);	
		
		if (PotP_UsingSezonBurz()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/2818
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_SezonBurz";
			parent.DLC_SezonBurz.Clear();
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Armor, 'Sezon Burz Armor')			.compilevariations('Sezon Burz Armor NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Pants, 'Sezon Burz Pants')			.compilevariations('Sezon Burz Pants NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Glove, 'Sezon Burz Gloves')			.compilevariations('Sezon Burz Gloves NGP', 'Sezon Burz Fingerless Gloves', 'Sezon Burz Fingerless Gloves NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Boots, 'Sezon Burz Boots')			.compilevariations('Sezon Burz Boots NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Silve, 'Sezon Burz Silver Sword')		.compilevariations('Sezon Burz Silver Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Steel, 'Sezon Burz Steel Sword')		.compilevariations('Sezon Burz Steel Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Cross, 'Sezon Burz Crossbow 1')		.compilevariations('Sezon Burz Crossbow 2', 'Sezon Burz Crossbow 3'));
			
			PotP_SortPreviewData(parent.DLC_SezonBurz, PotP_A_Items, master);
		}

		//------------------------------------------------------

		if (PotP_UsingCosWiecej()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5986
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_CosWiecej";
			parent.DLC_CosWiecej.Clear();
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Armor, 'wiecej')				.compilevariations('wiecej ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Glove, 'wiecej gloves')		.compilevariations('wiecej gloves ngp', 'wiecej gloves 2', 'wiecej gloves 2 ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Pants, 'wiecej pants')		.compilevariations('wiecej pants ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Boots, 'wiecej boots')		.compilevariations('wiecej boots ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'wiecej steel')		.compilevariations('wiecej steel ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Silve, 'wiecej silver')		.compilevariations('wiecej silver ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'rune sihil')			.compilevariations('rune sihil ngp', 'rune sihil 2', 'rune sihil 2 ngp'));
			
			PotP_SortPreviewData(parent.DLC_CosWiecej, PotP_A_Items, master);
		}

		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic";
			parent.DLC_Gothic.Clear();
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v1_1')			.compilevariations('kotw_armor_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v1_1')			.compilevariations('kotw_gloves_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v1_1')				.compilevariations('kotw_legs_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v1_1')			.compilevariations('kotw_boots_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v1_1_usable')		.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Gothic, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite";
			parent.DLC_Meteorite.Clear();
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v2_1')			.compilevariations('kotw_armor_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v2_1')		.compilevariations('kotw_gloves_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v2_1')			.compilevariations('kotw_legs_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v2_1')			.compilevariations('kotw_boots_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v2_1_usable')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Meteorite, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium";
			parent.DLC_Dimeritium.Clear();
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v3_1')		.compilevariations('kotw_armor_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v3_1')		.compilevariations('kotw_gloves_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v3_1')			.compilevariations('kotw_legs_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v3_1')		.compilevariations('kotw_boots_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v3_1_usable')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Dimeritium, PotP_A_Items, master);
		}

		if (PotP_UsingShadesOfIron()) //Github ID: https://github.com/Amasiuncula/Shades-of-Iron
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker";
			parent.Shades_Berserker.Clear();
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Berserker Armor')	.compilevariations('Shades Berserker Armor 1', 	'Shades Berserker Armor 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Berserker Boots')	.compilevariations('Shades Berserker Boots 1', 	'Shades Berserker Boots 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Berserker Gloves')	.compilevariations('Shades Berserker Gloves 1', 'Shades Berserker Gloves 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Berserker Pants')	.compilevariations('Shades Berserker Pants 1', 	'Shades Berserker Pants 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Cage')	.compilevariations(''));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Berserker, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck";
			parent.Shades_Bismarck.Clear();
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Bismarck Armor')		.compilevariations('Shades Bismarck Armor 1', 	'Shades Bismarck Armor 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Bismarck Boots')		.compilevariations('Shades Bismarck Boots 1', 	'Shades Bismarck Boots 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Bismarck Gloves')	.compilevariations('Shades Bismarck Gloves 1', 	'Shades Bismarck Gloves 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Bismarck Pants')		.compilevariations('Shades Bismarck Pants 1', 	'Shades Bismarck Pants 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Bismarck Helm')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Bismarck, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter";
			parent.Shades_BloodHunter.Clear();
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Hunter Armor')	.compilevariations('Shades Hunter Armor 1', 	'Shades Hunter Armor 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Hunter Boots')	.compilevariations('Shades Hunter Boots 1', 	'Shades Hunter Boots 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Hunter Gloves')	.compilevariations('Shades Hunter Gloves 1', 	'Shades Hunter Gloves 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Hunter Pants')	.compilevariations('Shades Hunter Pants 1', 	'Shades Hunter Pants 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Hat')		.compilevariations(''));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_BloodHunter, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow";
			parent.Shades_CrowFeathered.Clear();
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Crow Armor')	.compilevariations('Shades Crow Armor 1', 	'Shades Crow Armor 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Crow Boots')	.compilevariations('Shades Crow Boots 1', 	'Shades Crow Boots 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Crow Gloves')	.compilevariations('Shades Crow Gloves 1', 	'Shades Crow Gloves 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Crow Pants')	.compilevariations('Shades Crow Pants 1', 	'Shades Crow Pants 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Crow Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_CrowFeathered, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight";
			parent.Shades_FallenKnight.Clear();
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Fallen Armor')	.compilevariations('Shades Fallen Armor 1', 	'Shades Fallen Armor 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Fallen Boots')	.compilevariations('Shades Fallen Boots 1', 	'Shades Fallen Boots 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Fallen Gloves')	.compilevariations('Shades Fallen Gloves 1', 	'Shades Fallen Gloves 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Fallen Pants')	.compilevariations('Shades Fallen Pants 1', 	'Shades Fallen Pants 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Fallen Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_FallenKnight, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam";
			parent.Shades_Faraam.Clear();
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Faraam Armor')		.compilevariations('Shades Faraam Armor 1', 	'Shades Faraam Armor 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Faraam Boots')		.compilevariations('Shades Faraam Boots 1', 	'Shades Faraam Boots 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Faraam Gloves')	.compilevariations('Shades Faraam Gloves 1', 	'Shades Faraam Gloves 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Faraam Pants')		.compilevariations('Shades Faraam Pants 1', 	'Shades Faraam Pants 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Faraam Helm')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Faraam, PotP_A_Items, master);				
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker";
			parent.Shades_Headtaker.Clear();
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Headtaker Armor')		.compilevariations('Shades Headtaker Armor 1', 	'Shades Headtaker Armor 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Headtaker Boots')		.compilevariations('Shades Headtaker Boots 1', 	'Shades Headtaker Boots 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Headtaker Gloves')		.compilevariations('Shades Headtaker Gloves 1', 'Shades Headtaker Gloves 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Headtaker Pants')		.compilevariations('Shades Headtaker Pants 1', 	'Shades Headtaker Pants 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Headtaker Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Headtaker, PotP_A_Items, master);
			
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri";
			parent.Shades_Hitokiri.Clear();
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Viper Armor')		.compilevariations('Shades Viper Armor 1', 	'Shades Viper Armor 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Viper Boots')		.compilevariations('Shades Viper Boots 1', 	'Shades Viper Boots 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Viper Gloves')		.compilevariations('Shades Viper Gloves 1', 'Shades Viper Gloves 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Viper Pants')		.compilevariations('Shades Viper Pants 1', 	'Shades Viper Pants 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hitokiri Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Hitokiri, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara";
			parent.Shades_Kara.Clear();
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Kara Armor')		.compilevariations('Shades Kara Armor 1', 	'Shades Kara Armor 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Kara Boots')		.compilevariations('Shades Kara Boots 1', 	'Shades Kara Boots 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Kara Gloves')	.compilevariations('Shades Kara Gloves 1', 	'Shades Kara Gloves 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Kara Pants')		.compilevariations('Shades Kara Pants 1', 	'Shades Kara Pants 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Kara Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Kara, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter";
			parent.Shades_LionHunter.Clear();
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Lionhunter Armor')		.compilevariations('Shades Lionhunter Armor 1', 	'Shades Lionhunter Armor 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Lionhunter Boots')		.compilevariations('Shades Lionhunter Boots 1', 	'Shades Lionhunter Boots 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Lionhunter Gloves')	.compilevariations('Shades Lionhunter Gloves 1', 	'Shades Lionhunter Gloves 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Lionhunter Pants')		.compilevariations('Shades Lionhunter Pants 1', 	'Shades Lionhunter Pants 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Lionhunter Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_LionHunter, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin";
			parent.Shades_Assassin.Clear();
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Ezio Armor')		.compilevariations('Shades Ezio Armor 1', 	'Shades Ezio Armor 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Ezio Boots')		.compilevariations('Shades Ezio Boots 1', 	'Shades Ezio Boots 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Ezio Gloves')	.compilevariations('Shades Ezio Gloves 1', 	'Shades Ezio Gloves 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Ezio Pants')		.compilevariations('Shades Ezio Pants 1', 	'Shades Ezio Pants 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ezio Hood')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Assassin, PotP_A_Items, master);		
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter";
			parent.Shades_OldHunter.Clear();
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Oldhunter Armor')	.compilevariations('Shades Oldhunter Armor 1', 	'Shades Oldhunter Armor 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Oldhunter Boots')	.compilevariations('Shades Oldhunter Boots 1', 	'Shades Oldhunter Boots 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Oldhunter Gloves')	.compilevariations('Shades Oldhunter Gloves 1', 'Shades Oldhunter Gloves 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Oldhunter Pants')	.compilevariations('Shades Oldhunter Pants 1', 	'Shades Oldhunter Pants 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Oldhunter Cap')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_OldHunter, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant";
			parent.Shades_Revenant.Clear();
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Revenant Armor')		.compilevariations('Shades Revenant Armor 1', 	'Shades Revenant Armor 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Revenant Boots')		.compilevariations('Shades Revenant Boots 1', 	'Shades Revenant Boots 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Revenant Gloves')	.compilevariations('Shades Revenant Gloves 1', 	'Shades Revenant Gloves 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Revenant Pants')		.compilevariations('Shades Revenant Pants 1', 	'Shades Revenant Pants 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Revenant Hood')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Revenant, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker";
			parent.Shades_Stalker.Clear();
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Undertaker Armor')	.compilevariations('Shades Undertaker Armor 1', 	'Shades Undertaker Armor 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Undertaker Boots')	.compilevariations('Shades Undertaker Boots 1', 	'Shades Undertaker Boots 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Undertaker Gloves')	.compilevariations('Shades Undertaker Gloves 1', 	'Shades Undertaker Gloves 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Undertaker Pants')	.compilevariations('Shades Undertaker Pants 1', 	'Shades Undertaker Pants 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Undertaker Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Stalker, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng";
			parent.Shades_Taifeng.Clear();
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Taifeng Armor')	.compilevariations('Shades Taifeng Armor 1', 	'Shades Taifeng Armor 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Taifeng Boots')	.compilevariations('Shades Taifeng Boots 1', 	'Shades Taifeng Boots 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Taifeng Gloves')	.compilevariations('Shades Taifeng Gloves 1', 	'Shades Taifeng Gloves 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Taifeng Pants')	.compilevariations('Shades Taifeng Pants 1', 	'Shades Taifeng Pants 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ronin Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Taifeng, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen";
			parent.Shades_Unseen.Clear();
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Yahargul Armor')	.compilevariations('Shades Yahargul Armor 1', 	'Shades Yahargul Armor 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Yahargul Boots')	.compilevariations('Shades Yahargul Boots 1', 	'Shades Yahargul Boots 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Yahargul Gloves')	.compilevariations('Shades Yahargul Gloves 1', 	'Shades Yahargul Gloves 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Yahargul Pants')	.compilevariations('Shades Yahargul Pants 1', 	'Shades Yahargul Pants 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Yahargul Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Unseen, PotP_A_Items, master);		
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis";
			parent.Shades_Sithis.Clear();
			parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Sithis Armor')	.compilevariations('Shades Sithis Armor 1', 	'Shades Sithis Armor 2'));
			parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Sithis Hood')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Sithis, PotP_A_Items, master);	
	
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords";
			parent.Shades_SilverSwords.Clear();
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Eagle Sword')			.compilevariations('Shades Silver Eagle Sword 1', 			'Shades Silver Eagle Sword 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ares')				.compilevariations('Shades Silver Ares 1', 					'Shades Silver Ares 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Doomblade')			.compilevariations('Shades Silver Doomblade 1', 			'Shades Silver Doomblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Beastcutter')			.compilevariations('Shades Silver Beastcutter 1', 			'Shades Silver Beastcutter 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blackdawn')			.compilevariations('Shades Silver Blackdawn 1', 			'Shades Silver Blackdawn 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blooddusk')			.compilevariations('Shades Silver Blooddusk 1', 			'Shades Silver Blooddusk 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodletter')			.compilevariations('Shades Silver Bloodletter 1', 			'Shades Silver Bloodletter 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodshot')			.compilevariations('Shades Silver Bloodshot 1', 			'Shades Silver Bloodshot 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Claymore')			.compilevariations('Shades Silver Claymore 1', 				'Shades Silver Claymore 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kingslayer')			.compilevariations('Shades Silver Kingslayer 1', 			'Shades Silver Kingslayer 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Cursed Khopesh')		.compilevariations('Shades Silver Cursed Khopesh 1',		'Shades Silver Cursed Khopesh 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Dragonbane')			.compilevariations('Shades Silver Dragonbane 1', 			'Shades Silver Dragonbane 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ejderblade')			.compilevariations('Shades Silver Ejderblade 1', 			'Shades Silver Ejderblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Flameborn')			.compilevariations('Shades Silver Flameborn 1', 			'Shades Silver Flameborn 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Frostmourne')			.compilevariations('Shades Silver Frostmourne 1', 			'Shades Silver Frostmourne 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Gorgonslayer')		.compilevariations('Shades Silver Gorgonslayer 1', 			'Shades Silver Gorgonslayer 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Graveripper')			.compilevariations('Shades Silver Graveripper 1', 			'Shades Silver Graveripper 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Guandao')				.compilevariations('Shades Silver Guandao 1', 				'Shades Silver Guandao 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Crownbreaker')		.compilevariations('Shades Silver Crownbreaker 1', 			'Shades Silver Crownbreaker 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hades Grasp')			.compilevariations('Shades Silver Hades Grasp 1', 			'Shades Silver Hades Grasp 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Haoma')				.compilevariations('Shades Silver Haoma 1', 				'Shades Silver Haoma 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Heavenspire')			.compilevariations('Shades Silver Heavenspire 1', 			'Shades Silver Heavenspire 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hellspire')			.compilevariations('Shades Silver Hellspire 1', 			'Shades Silver Hellspire 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Icarus Tears')		.compilevariations('Shades Silver Icarus Tears 1', 			'Shades Silver Icarus Tears 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ryu Katana')			.compilevariations('Shades Silver Ryu Katana 1', 			'Shades Silver Ryu Katana 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Lion Sword')			.compilevariations('Shades Silver Lion Sword 1', 			'Shades Silver Lion Sword 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oathblade')			.compilevariations('Shades Silver Oathblade 1', 			'Shades Silver Oathblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oblivion')			.compilevariations('Shades Silver Oblivion 1', 				'Shades Silver Oblivion 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hitokiri Katana')		.compilevariations('Shades Silver Hitokiri Katana 1', 		'Shades Silver Hitokiri Katana 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Pridefall')			.compilevariations('Shades Silver Pridefall 1', 			'Shades Silver Pridefall 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Rakuyo')				.compilevariations('Shades Silver Rakuyo 1', 				'Shades Silver Rakuyo 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Blade')	.compilevariations('Shades Silver Realmdrifter Blade 1', 	'Shades Silver Realmdrifter Blade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Divider').compilevariations('Shades Silver Realmdrifter Divider 1', 	'Shades Silver Realmdrifter Divider 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kukri')				.compilevariations('Shades Silver Kukri 1', 				'Shades Silver Kukri 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sinner')				.compilevariations('Shades Silver Sinner 1', 				'Shades Silver Sinner 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sithis Blade')		.compilevariations('Shades Silver Sithis Blade 1', 			'Shades Silver Sithis Blade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Voidblade')			.compilevariations('Shades Silver Voidblade 1', 			'Shades Silver Voidblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Vulcan')				.compilevariations('Shades Silver Vulcan 1', 				'Shades Silver Vulcan 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Knife')				.compilevariations('Shades Silver Knife 1', 				'Shades Silver Knife 2'));
				
			PotP_SortPreviewData(parent.Shades_SilverSwords, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords";
			parent.Shades_SteelSwords.Clear();
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Eagle Sword')			.compilevariations('Shades Steel Eagle Sword 1', 			'Shades Steel Eagle Sword 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ares')					.compilevariations('Shades Steel Ares 1', 					'Shades Steel Ares 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Doomblade')				.compilevariations('Shades Steel Doomblade 1', 				'Shades Steel Doomblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Beastcutter')			.compilevariations('Shades Steel Beastcutter 1', 			'Shades Steel Beastcutter 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blackdawn')				.compilevariations('Shades Steel Blackdawn 1', 				'Shades Steel Blackdawn 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blooddusk')				.compilevariations('Shades Steel Blooddusk 1', 				'Shades Steel Blooddusk 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodletter')			.compilevariations('Shades Steel Bloodletter 1', 			'Shades Steel Bloodletter 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodshot')				.compilevariations('Shades Steel Bloodshot 1', 				'Shades Steel Bloodshot 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Claymore')				.compilevariations('Shades Steel Claymore 1', 				'Shades Steel Claymore 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kingslayer')			.compilevariations('Shades Steel Kingslayer 1', 			'Shades Steel Kingslayer 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Cursed Khopesh')		.compilevariations('Shades Steel Cursed Khopesh 1',			'Shades Steel Cursed Khopesh 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Dragonbane')			.compilevariations('Shades Steel Dragonbane 1', 			'Shades Steel Dragonbane 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ejderblade')			.compilevariations('Shades Steel Ejderblade 1', 			'Shades Steel Ejderblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Flameborn')				.compilevariations('Shades Steel Flameborn 1', 				'Shades Steel Flameborn 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Frostmourne')			.compilevariations('Shades Steel Frostmourne 1', 			'Shades Steel Frostmourne 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Gorgonslayer')			.compilevariations('Shades Steel Gorgonslayer 1', 			'Shades Steel Gorgonslayer 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Graveripper')			.compilevariations('Shades Steel Graveripper 1', 			'Shades Steel Graveripper 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Guandao')				.compilevariations('Shades Steel Guandao 1', 				'Shades Steel Guandao 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Crownbreaker')			.compilevariations('Shades Steel Crownbreaker 1', 			'Shades Steel Crownbreaker 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hades Grasp')			.compilevariations('Shades Steel Hades Grasp 1', 			'Shades Steel Hades Grasp 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Haoma')					.compilevariations('Shades Steel Haoma 1', 					'Shades Steel Haoma 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Heavenspire')			.compilevariations('Shades Steel Heavenspire 1', 			'Shades Steel Heavenspire 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hellspire')				.compilevariations('Shades Steel Hellspire 1', 				'Shades Steel Hellspire 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Icarus Tears')			.compilevariations('Shades Steel Icarus Tears 1', 			'Shades Steel Icarus Tears 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ryu Katana')			.compilevariations('Shades Steel Ryu Katana 1', 			'Shades Steel Ryu Katana 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Lion Sword')			.compilevariations('Shades Steel Lion Sword 1', 			'Shades Steel Lion Sword 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oathblade')				.compilevariations('Shades Steel Oathblade 1', 				'Shades Steel Oathblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oblivion')				.compilevariations('Shades Steel Oblivion 1', 				'Shades Steel Oblivion 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hitokiri Katana')		.compilevariations('Shades Steel Hitokiri Katana 1', 		'Shades Steel Hitokiri Katana 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Pridefall')				.compilevariations('Shades Steel Pridefall 1', 				'Shades Steel Pridefall 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Rakuyo')				.compilevariations('Shades Steel Rakuyo 1', 				'Shades Steel Rakuyo 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Blade')	.compilevariations('Shades Steel Realmdrifter Blade 1', 	'Shades Steel Realmdrifter Blade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Divider')	.compilevariations('Shades Steel Realmdrifter Divider 1', 	'Shades Steel Realmdrifter Divider 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kukri')					.compilevariations('Shades Steel Kukri 1', 					'Shades Steel Kukri 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sinner')				.compilevariations('Shades Steel Sinner 1', 				'Shades Steel Sinner 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sithis Blade')			.compilevariations('Shades Steel Sithis Blade 1', 			'Shades Steel Sithis Blade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Voidblade')				.compilevariations('Shades Steel Voidblade 1', 				'Shades Steel Voidblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Vulcan')				.compilevariations('Shades Steel Vulcan 1', 				'Shades Steel Vulcan 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Knife')					.compilevariations('Shades Steel Knife 1', 					'Shades Steel Knife 2'));
				
			PotP_SortPreviewData(parent.Shades_SteelSwords, PotP_A_Items, master);
		}
	}

	latent function BuildGwentReduxCards()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Monsters_Redux";
		var master : CProgressOnThePath;
		GetPotP(master);	
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_gold')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_caranthir')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_emiel')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_striga')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_avallach')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_moon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul3')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cow')						.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dagon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dettlaff')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_endrega')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_earth_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fogling')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_katakan')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_griffin')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_iris')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul2')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_drakkar')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nithral')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_mrmirror')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_savolla')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_alp')						.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_53", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_garkain')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_54", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas2')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_55", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_mrmirror_foglet')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_56", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_white')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_57", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_hound')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_58", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_navigator')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_59", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_rider')			.compilevariations('gwint_card_wildhunt_rider2', 'gwint_card_wildhunt_rider3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_60", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_warrior')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_61", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas3')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_62", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_63", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_centipede')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_GwentCards_NeutralCards_Redux";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_azar_javed')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_geralt')			.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_ciri')				.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dummy')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_horn')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_professor')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_vesemir')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_yennefer')			.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_silver')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_gold')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_moorvran')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_henrietta')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_letho')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade1')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_albrich')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_siege_support')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_artorius')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_assire')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade3')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cahir')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_renuald')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_catriona')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cynthia')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa3')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa2')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_fringilla')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_heavy_zerri')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_joachim')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade4')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_menno')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_milton')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_palmerin')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_morteisen')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_puttkammer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rainfarn')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rotten')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_shilard')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_combat_engineer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_stefan')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_sweers')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_syanna')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_tibor')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vanhemar')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vattier')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vicovaro')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer2')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vivienne')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vreemde')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_zerri')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_NorthernRealms_Redux";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_gold')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_philippa')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_anseis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_beggar')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_bloody_baron')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_blue_stripes1')		.compilevariations('gwint_card_blue_stripes2', 'gwint_card_blue_stripes3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_boris')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_botchling')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult2')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_carlo')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_cleric_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_crinfrid')			.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_crownsplitter')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_cutup')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_dijkstra')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_igor')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_jacques')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_francis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_knight_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_lebioda')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_hailstorm')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_nathaniel')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_peach')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_wyvern')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_vincent')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_53", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_54", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_whoreson')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_55", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_56", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_57", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_zoltan')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_Scoiatael_Redux";
		
		parent.Gwent_Scoiatael.Clear();	
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_morenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_aglais')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_braenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam5')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_grovekeeper')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam3')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam4')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_fauve')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_scorch')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Missable, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support3')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_nature')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam2')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_treant_boar')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_treant_mantis')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_villen')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_water')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_Skellige_Redux";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_bronze')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_silver')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_gold')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_platinium')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cock')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_tyr')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_an_craite_marauder')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_an_craite_whaler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_artis')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_athak')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_boatbuilders')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_dreams')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_captain')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_smuggler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_djenge_frett')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_draig')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ermion')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cerys')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_jutta')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_knut')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_coral')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_werewolf')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_olaf')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_freya')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ragh_nar_roog')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_skellige_storm')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_skjall')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_sukrus')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_svalblod')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_tuirseach_skirmisher')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_vabjorn')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_yoana')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent, master);
	}
	
	latent function BuildGwentCards()
	{
		var master: CProgressOnThePath;
		var group	: string = "PotP_TrackingGroup_GwentCards_Monsters";
		GetPotP(master);
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_gold')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas')				.compilevariations('gwint_card_arachas2', 'gwint_card_arachas3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_botchling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_earth_elemental')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_endrega')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fogling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations('gwint_card_ghoul2', 'gwint_card_ghoul3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_griffin')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_garkain')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_katakan')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_werewolf')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wyvern')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NeutralCards";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_ciri')				.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_geralt')				.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_avallach')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_yennefer')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_horn')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dummy')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_scorch')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_cow')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Missable,PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_emiel')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_mrmirror')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_mrmirror_foglet')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_vesemir')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_villen')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_zoltan')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_skellige_storm')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_silver')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_gold')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_letho')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_menno')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_moorvran')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_tibor')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_albrich')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_assire')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer')		.compilevariations('gwint_card_black_archer2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cahir')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cynthia')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support')	.compilevariations('gwint_card_archer_support2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_fringilla')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_heavy_zerri')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade')	.compilevariations('gwint_card_impera_brigade2', 'gwint_card_impera_brigade3', 'gwint_card_impera_brigade4'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_morteisen')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa')			.compilevariations('gwint_card_nausicaa2', 'gwint_card_nausicaa3'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_puttkammer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rainfarn')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_renuald')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rotten')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_shilard')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_combat_engineer')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_siege_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_stefan')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_sweers')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vanhemar')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vattier')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vreemde')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary')	.compilevariations('gwint_card_young_emissary2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_zerri')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NorthernRealms";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_gold')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Missable,PotP_I_Gwent, PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_philippa')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult')				.compilevariations('gwint_card_catapult2'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_crinfrid')				.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_dijkstra')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent, master);		

		group = "PotP_TrackingGroup_GwentCards_Scoiatael";
		
		parent.Gwent_Scoiatael.Clear();
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations('gwint_card_dol_infantry2', 'gwint_card_dol_infantry3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations('gwint_card_elf_skirmisher2', 'gwint_card_elf_skirmisher3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations('gwint_card_havekar_nurse2', 'gwint_card_havekar_nurse3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations('gwint_card_havekar_support2', 'gwint_card_havekar_support3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations('gwint_card_mahakam2', 'gwint_card_mahakam3', 'gwint_card_mahakam4', 'gwint_card_mahakam5'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations('gwint_card_vrihedd_brigade2'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent, master);

		group = "PotP_TrackingGroup_GwentCards_Skellige";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_bronze')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cerys')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ermion')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_draig')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cock')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_olaf')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent, master);
	}
}



//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_QuestStorage
{		
	var MasterList_Quests			:array<PotP_PreviewEntry>;
	var MasterList_Quests_Lookup	:array<string>;
	
	var MainQuests_Prologue			: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Velen		: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Novigrad	: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Skellige	: array<PotP_PreviewEntry>;
	var MainQuests_Act2				: array<PotP_PreviewEntry>;
	var MainQuests_Act3				: array<PotP_PreviewEntry>;
	var MainQuests_DLC1				: array<PotP_PreviewEntry>;
	var MainQuests_DLC2				: array<PotP_PreviewEntry>;
	var MainQuests_Vizima			: array<PotP_PreviewEntry>;
	
	var SideQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var SideQuests_Velen			: array<PotP_PreviewEntry>;
	var SideQuests_Novigrad			: array<PotP_PreviewEntry>;
	var SideQuests_Skellige			: array<PotP_PreviewEntry>;
	var SideQuests_KaerMorhen		: array<PotP_PreviewEntry>;
	var SideQuests_Toussaint		: array<PotP_PreviewEntry>;
	var SideQuests_NonRegional		: array<PotP_PreviewEntry>;
	
	var ContQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var ContQuests_Velen			: array<PotP_PreviewEntry>;
	var ContQuests_Novigrad			: array<PotP_PreviewEntry>;
	var ContQuests_Skellige			: array<PotP_PreviewEntry>;
	var ContQuests_Toussaint		: array<PotP_PreviewEntry>;
	
	var ScavQuests_Griffin			: array<PotP_PreviewEntry>;
	var ScavQuests_Feline			: array<PotP_PreviewEntry>;
	var ScavQuests_Ursine			: array<PotP_PreviewEntry>;
	var ScavQuests_Wolven			: array<PotP_PreviewEntry>;
	var ScavQuests_Others			: array<PotP_PreviewEntry>;
	
	var HuntQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var HuntQuests_Velen			: array<PotP_PreviewEntry>;
	var HuntQuests_Novigrad			: array<PotP_PreviewEntry>;
	var HuntQuests_Skellige			: array<PotP_PreviewEntry>;
	var HuntQuests_Toussaint		: array<PotP_PreviewEntry>;
	
	var MissableQuests_InstantFails	: array<PotP_PreviewEntry>;
	var MissableQuests_Q001			: array<PotP_PreviewEntry>;
	var MissableQuests_Q401			: array<PotP_PreviewEntry>;
	var MissableQuests_SQ101		: array<PotP_PreviewEntry>;
	var MissableQuests_Q301			: array<PotP_PreviewEntry>;
	var MissableQuests_Q303			: array<PotP_PreviewEntry>;
	var MissableQuests_SQ106		: array<PotP_PreviewEntry>;
	var MissableQuests_Q501			: array<PotP_PreviewEntry>;
	var MissableQuests_Q206			: array<PotP_PreviewEntry>;
	var MissableQuests_Q210			: array<PotP_PreviewEntry>;
	var MissableQuests_Q112			: array<PotP_PreviewEntry>;
	var MissableQuests_Q403			: array<PotP_PreviewEntry>;
	var MissableQuests_Q702			: array<PotP_PreviewEntry>;	
	var MissableQuests_Ugly			: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Quest Storage';

//---------------------------------------------------
	
	function inititalise()
	{
		this.GotoState('Build');
	}

//---------------------------------------------------
	
	function CreateEntry() : PotP_PreviewEntry
	{
		return new PotP_PreviewEntry in this; 
	}

//---------------------------------------------------

	function CreateUniqueIdentifier() : string 
	{
		UUIDINT += 1;
		return "QX" + IntToString(UUIDINT);
	}

//---------------------------------------------------

	function AddToMissableArray(pData: PotP_PreviewEntry) 
	{	
		switch (pData.uuid)
		{
		case "PotP_TrackingGroup_SideQuests_Novigrad_01":
		case "PotP_TrackingGroup_SideQuests_Velen_01":
		case "PotP_TrackingGroup_SideQuests_Velen_23":
		case "PotP_TrackingGroup_SideQuests_Novigrad_49":		
			this.MissableQuests_InstantFails.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_01":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_03":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_04":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_05":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_06":
			this.MissableQuests_Q001.PushBack(pData);
			break;
			
		case "PotP_TrackingGroup_SideQuests_Skellige_34":
		case "PotP_TrackingGroup_SideQuests_NonRegional_03":
			this.MissableQuests_Q401.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Velen_22":
			this.MissableQuests_SQ101.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_09":
			this.MissableQuests_Q303.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_12":
			this.MissableQuests_SQ106.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_38":
		case "PotP_TrackingGroup_ContractQuests_WhiteOrchard_01":	
			this.MissableQuests_Q501.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_26":
		case "PotP_TrackingGroup_SideQuests_Skellige_28":
			this.MissableQuests_Q206.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_07":
		case "PotP_TrackingGroup_SideQuests_Skellige_23":
		case "PotP_TrackingGroup_SideQuests_Skellige_35":
			this.MissableQuests_Q210.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_45":
		case "PotP_TrackingGroup_SideQuests_Novigrad_46":
			this.MissableQuests_Q112.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_02":
		case "PotP_TrackingGroup_SideQuests_Novigrad_03":
		case "PotP_TrackingGroup_SideQuests_Velen_02":
		case "PotP_TrackingGroup_SideQuests_Novigrad_06":
		case "PotP_TrackingGroup_SideQuests_Velen_04":
		case "PotP_TrackingGroup_SideQuests_Novigrad_10":
		case "PotP_TrackingGroup_SideQuests_Velen_05":
		case "PotP_TrackingGroup_SideQuests_KaerMorhen_01":
		case "PotP_TrackingGroup_SideQuests_Novigrad_12":
		case "PotP_TrackingGroup_SideQuests_Novigrad_13":
		case "PotP_TrackingGroup_SideQuests_Velen_08":
		case "PotP_TrackingGroup_SideQuests_Novigrad_17":
		case "PotP_TrackingGroup_SideQuests_Velen_14":
		case "PotP_TrackingGroup_SideQuests_Velen_17":
		case "PotP_TrackingGroup_SideQuests_Skellige_20":
		case "PotP_TrackingGroup_SideQuests_Novigrad_32":
		case "PotP_TrackingGroup_SideQuests_Novigrad_39":
		case "PotP_TrackingGroup_SideQuests_Velen_25":
		case "PotP_TrackingGroup_SideQuests_Velen_27":
			this.MissableQuests_Q403.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_Toussaint_03":
			this.MissableQuests_Q702.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_22":
			this.MissableQuests_Q301.PushBack(pData);
			break;

		case "PotP_TrackingGroup_MainQuests_SkelligeAct1_07":
			this.MissableQuests_Ugly.PushBack(pData);
			break;
			
		default:
			PotP_Logger("Unrecognised Missable Quest Detected - " + pData.localname);
			break;
		}	
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_QuestStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Build State ------------------------------------
//---------------------------------------------------
	
state Build in CProgressOnThePath_QuestStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	

	entry function Build()
	{
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MasterList_Quests.Clear();
		parent.MasterList_Quests_Lookup.Clear();
		
		parent.MissableQuests_InstantFails.Clear();
		parent.MissableQuests_Q001.Clear();
		parent.MissableQuests_Q401.Clear();
		parent.MissableQuests_SQ101.Clear();
		parent.MissableQuests_Q303.Clear();
		parent.MissableQuests_SQ106.Clear();
		parent.MissableQuests_Q501.Clear();
		parent.MissableQuests_Q206.Clear();
		parent.MissableQuests_Q210.Clear();
		parent.MissableQuests_Q112.Clear();
		parent.MissableQuests_Q403.Clear();
		parent.MissableQuests_Q702.Clear();
		parent.MissableQuests_Q301.Clear();
		parent.MissableQuests_Ugly.Clear();
		
		this.Build_Main();
		this.Build_Side();
		this.Build_Cont();
		this.Build_Scav();
		this.Build_Hunt();
		
		for ( Idx = 0; Idx < parent.MasterList_Quests.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Quests[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Quests[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Quests[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Quests[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Quests[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Quests[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Quests[Idx].identifier);			

		}
		
		parent.GotoState('Idle');
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Main()
	{
		var group: string = "PotP_TrackingGroup_MainQuests_Prologue";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MainQuests_Prologue.Clear();
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack"));
		
		PotP_SortPreviewData(parent.MainQuests_Prologue, PotP_A_Quest, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Vizima";
		
		parent.MainQuests_Vizima.Clear();
		parent.MainQuests_Vizima.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace"));
		
		PotP_SortPreviewData(parent.MainQuests_Vizima, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_VelenAct1";
		
		parent.MainQuests_Act1_Velen.Clear();
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Velen, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_NovigradAct1";
		
		parent.MainQuests_Act1_Novigrad.Clear();
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Novigrad, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_SkelligeAct1";
		
		parent.MainQuests_Act1_Skellige.Clear();
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Skellige, PotP_A_Quest, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Act2";
		
		parent.MainQuests_Act2.Clear();
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle"));
		
		PotP_SortPreviewData(parent.MainQuests_Act2, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Act3";
		
		parent.MainQuests_Act3.Clear();
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress"));
		
		PotP_SortPreviewData(parent.MainQuests_Act3, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_HeartsOfStone";
		
		parent.MainQuests_DLC1.Clear();
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale"));
		
		PotP_SortPreviewData(parent.MainQuests_DLC1, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_BloodAndWine";
		
		parent.MainQuests_DLC2.Clear();
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home"));
		
		PotP_SortPreviewData(parent.MainQuests_DLC2, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Side()
	{
		var group: string = "PotP_TrackingGroup_SideQuests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.SideQuests_WhiteOrchard.Clear();
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_WO, PotP_I_Sides, "mq5004horse"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith"));
		
		PotP_SortPreviewData(parent.SideQuests_WhiteOrchard, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_KaerMorhen";
		
		parent.SideQuests_KaerMorhen.Clear();
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4002_anomaly"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4003_lake"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4004_bastion"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4006_armor"));
		
		PotP_SortPreviewData(parent.SideQuests_KaerMorhen, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_NonRegional";
		
		parent.SideQuests_NonRegional.Clear();
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "CG: Old Friends"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith"));
		
		PotP_SortPreviewData(parent.SideQuests_NonRegional, PotP_A_Quest, master);

		//------------------------------------------------------
				
		group = "PotP_TrackingGroup_SideQuests_Velen";
		
		parent.SideQuests_Velen.Clear();
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ107 Pigs"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "CG : No Man's Land"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit"));
		}

		if (PotP_UsingThreeLittleSisters()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5178
		{ 
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "threesisters_little_sisters"));
		}		

		PotP_SortPreviewData(parent.SideQuests_Velen, PotP_A_Quest, master);
		
		//------------------------------------------------------
				
		group = "PotP_TrackingGroup_SideQuests_Novigrad";
		
		parent.SideQuests_Novigrad.Clear();
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ315 Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "mq3039_crows"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ301 Triss"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1,	PotP_R_NO, PotP_I_Sides, "q602romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ312 Ves"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "q603painting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ303 Brothel"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q308 Psycho"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Innkeepers"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ306 Maverick"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q309 Casablanca"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6001merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3035_emhyr"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ302 Philippa"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1028 Courier"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_45", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_46", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_47", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_49", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_50", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6002_cannibals"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_52", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2"));
		}

		if (PotP_UsingCiriSoleMemento()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/4585
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "solememento_sole_memento"));
		}

		PotP_SortPreviewData(parent.SideQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_Skellige";
		
		parent.SideQuests_Skellige.Clear();
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2010 human trap"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2045_chains"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "Fist Fight Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2049_atheist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "CG: Skellige"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ201 Curse"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q206 Berserkers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q203 Him"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ202 Yen"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2030_nithing"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif"));

		PotP_SortPreviewData(parent.SideQuests_Skellige, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_Toussaint";
		
		parent.SideQuests_Toussaint.Clear();
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino"));

		if (PotP_UsingANightToRemember()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/4670
		{
			parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded_DLC2, PotP_R_TO, PotP_I_Sides, "ntr_nighttoremember"));
		}
		
		PotP_SortPreviewData(parent.SideQuests_Toussaint, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------

	latent function Build_Cont()
	{
		var group: string = "PotP_TrackingGroup_ContractQuests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.ContQuests_WhiteOrchard.Clear();
		parent.ContQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith"));
		
		PotP_SortPreviewData(parent.ContQuests_WhiteOrchard, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Velen";
		
		parent.ContQuests_Velen.Clear();
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake "));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael"));
		
		PotP_SortPreviewData(parent.ContQuests_Velen, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Novigrad";
		
		parent.ContQuests_Novigrad.Clear();
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih"));
		
		PotP_SortPreviewData(parent.ContQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Skellige";
		
		parent.ContQuests_Skellige.Clear();
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit"));
		
		PotP_SortPreviewData(parent.ContQuests_Skellige, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Toussaint";
		
		parent.ContQuests_Toussaint.Clear();
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight"));
		
		PotP_SortPreviewData(parent.ContQuests_Toussaint, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Scav()
	{
		var group: string = "PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.ScavQuests_Griffin.Clear();
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Set"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Griffin, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_FelineSet";
		
		parent.ScavQuests_Feline.Clear();
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Set"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_cat_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Feline, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet";
		
		parent.ScavQuests_Ursine.Clear();
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Set"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_bear_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Ursine, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet";
		
		parent.ScavQuests_Wolven.Clear();
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Set"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Wolven, PotP_A_Quest, master);		

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_OtherSets";
		
		parent.ScavQuests_Others.Clear();
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Viper Set"));
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th700_red_wolf"));

		if (PotP_IsUsingNextGen()) 
		{
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades"));
		}

		if (PotP_UsingDLCArmorQuests()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/3983
		{ 
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "temeriatreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "nilfgaardtreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "skelligetreasurehunt"));
		}
		
		PotP_SortPreviewData(parent.ScavQuests_Others, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard";
		
		parent.HuntQuests_WhiteOrchard.Clear();
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure"));
		
		PotP_SortPreviewData(parent.HuntQuests_WhiteOrchard, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Hunt()
	{
		var group: string = "PotP_TrackingGroup_TreasureHuntQuests_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.HuntQuests_Velen.Clear();
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds"));
		
		PotP_SortPreviewData(parent.HuntQuests_Velen, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Novigrad";
		
		parent.HuntQuests_Novigrad.Clear();
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26b"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi08"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi01"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi10"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi02"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi05"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi04"));
		
		PotP_SortPreviewData(parent.HuntQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Skellige";
		
		parent.HuntQuests_Skellige.Clear();
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure"));
		
		PotP_SortPreviewData(parent.HuntQuests_Skellige, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Toussaint";
		
		parent.HuntQuests_Toussaint.Clear();
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03"));
		
		PotP_SortPreviewData(parent.HuntQuests_Toussaint, PotP_A_Quest, master);
	}
}

//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Storage
{		
	var MasterList_Completed_V: array<string>;
	var MasterList_InProgres_V: array<string>;
	var MasterList_IsIgnored_V: array<string>;
	var MasterList_Collected_V: array<string>;

	var MasterList_ItemsGoblin: array<SItemUniqueId>;
	var MasterList_QuestGoblin: array<CJournalQuest>;	
	var MasterList_Pl_Messages: array<PotP_PlayerNotification>;

	var pArrayStorage: CProgressOnThePath_ArrayStorage;
	var pEventStorage: CProgressOnThePath_EventStorage;
	var pQuestStorage: CProgressOnThePath_QuestStorage;
	var pQuestStorageArray_Name: array<string>;
	var pQuestStorageArray_Icon: array<string>;

	var pWorldStorage: CProgressOnThePath_WorldStorage;
	var pWorldStorageArray_Name: array<string>;
	var pWorldStorageArray_Icon: array<string>;
	
	var pItemsStorage: CProgressOnThePath_ItemsStorage;
	var pItemsStorageArray_Name: array<string>;
	var pItemsStorageArray_Icon: array<string>;

	var BackGroundProcessingArray_Name: array<string>;
	var BackGroundProcessingArray_Icon: array<string>;
	var BackGroundProcessingArray_Count: int;
	var BackGroundProcessingArray_Oflow: int;
	var BackGroundProcessingArray_bItems: bool;
	var BackGroundProcessingArray_bWorld: bool;
	var BackGroundProcessingArray_bQuest: bool;
	
	var force_refresh: name;
	var debug: bool;
	
	function ResetBackGroundProcessingArray() : void
	{
		BackGroundProcessingArray_Count = 0;
		BackGroundProcessingArray_Oflow = 0;
		BackGroundProcessingArray_Name.Clear();
		BackGroundProcessingArray_Icon.Clear();
		
		if (BackGroundProcessingArray_bItems) { resetItemsVariables(); }
		if (BackGroundProcessingArray_bWorld) { resetWorldVariables(); }
		if (BackGroundProcessingArray_bQuest) { resetQuestVariables(); }
		
		BackGroundProcessingArray_bItems = false;
		BackGroundProcessingArray_bWorld = false;
		BackGroundProcessingArray_bQuest = false;
	}
	
	function resetItemsVariables() : void
	{
		pItemsStorageArray_Name.Clear();
		pItemsStorageArray_Icon.Clear();
	}

	function resetWorldVariables() : void
	{
		pWorldStorageArray_Name.Clear();
		pWorldStorageArray_Icon.Clear();
	}

	function resetQuestVariables() : void
	{
		pQuestStorageArray_Name.Clear();
		pQuestStorageArray_Icon.Clear();
	}

	function PotP_LoadStorageCollection(optional force_refresh: name, optional debug: bool) 
	{
		this.force_refresh = force_refresh;
		this.debug = debug;
		this.GotoState('Disabled');
		this.GotoState('Process');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_Storage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , 'PotP Storage');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Process in CProgressOnThePath_Storage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Process]", , 'PotP Storage');
		
		this.LoadStorage();
		
	}
	
	//---------------------------------------------------
	
	entry function LoadStorage() 
	{
		var master: CProgressOnThePath;

		while (theGame.IsLoadingScreenVideoPlaying()) 
		{
		  Sleep(1);
		}
		
		PotP_Logger("Loading Screen Finished", , 'PotP Storage');
		
		while ( PotP_IsPlayerBusy() ) 
		{
			Sleep(0.5);
		}
		
		PotP_Logger("Player is no longer busy", , 'PotP Storage');

		Sleep(0.5);
		
		if (!GetPotP(master, 'Load Storage')) 
		{ 
			GetWitcherPlayer().DisplayHudMessage("Unable To Retrieve PotP");
			GotoState('Disabled');
		}
		
		if (!master.PotP_PersistentStorage) 
		{
			master.PotP_PersistentStorage = new CProgressOnThePath_Storage in master;
			PotP_Logger("New storage instance created.", , 'PotP Storage');
		}
		else 
		{
			PotP_Logger("Existing master storage instance loaded.", , 'PotP Storage');
		}

		//---------------------------------------------------
		
		master.PotP_EntityHelper.initialise(master);
		
		if (!master.PotP_PersistentStorage.pArrayStorage)
		{
			SleepOneFrame();
			master.PotP_PersistentStorage.pArrayStorage = new CProgressOnThePath_ArrayStorage in master.PotP_PersistentStorage;
			master.PotP_PersistentStorage.pArrayStorage.inititalise();
			PotP_Logger("New array storage instance created.", , 'PotP Storage');
		}
		else 
		{
			if (parent.force_refresh == 'All' || parent.force_refresh == 'Array')
			{
				SleepOneFrame();
				master.PotP_PersistentStorage.pArrayStorage.inititalise();
				PotP_Logger("Existing array storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pArrayStorage.TotalEntList.Size(), , 'PotP Storage');
			}
			else
			{
				PotP_Logger("Existing array storage instance loaded with a size of: " + master.PotP_PersistentStorage.pArrayStorage.TotalEntList.Size(), , 'PotP Storage');
			}
		}

	//---------------------------------------------------
		
		if (!master.PotP_PersistentStorage.pQuestStorage)
		{
			SleepOneFrame();
			master.PotP_PersistentStorage.pQuestStorage = new CProgressOnThePath_QuestStorage in master.PotP_PersistentStorage;
			PotP_Logger("New quest storage instance created.", , 'PotP Storage');
			master.PotP_PersistentStorage.pQuestStorage.inititalise();
			PotP_Logger("New quest storage instance initialised.", , 'PotP Storage');
		}
		else 
		{
			if (parent.force_refresh == 'All' || parent.force_refresh == 'Quest' || PotP_ModAddedOrRemoved('Quest'))
			{
				SleepOneFrame();
				master.PotP_PersistentStorage.pQuestStorage.inititalise();
				PotP_Logger("Existing quest storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.Size(), , 'PotP Storage');
			}
			else
			{
				PotP_Logger("Existing quest storage instance loaded with a size of: " + master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.Size(), , 'PotP Storage');
			}
		}

	//---------------------------------------------------
		
		if (!master.PotP_PersistentStorage.pEventStorage)
		{
			SleepOneFrame();
			master.PotP_PersistentStorage.pEventStorage = new CProgressOnThePath_EventStorage in master.PotP_PersistentStorage;
			PotP_Logger("New event storage instance created.", , 'PotP Storage');
			master.PotP_PersistentStorage.pEventStorage.inititalise();
			PotP_Logger("New event storage instance initialised.", , 'PotP Storage');
		}
		else 
		{
			if (parent.force_refresh == 'All' || parent.force_refresh == 'Event')
			{
				SleepOneFrame();
				master.PotP_PersistentStorage.pEventStorage.inititalise();
				PotP_Logger("Existing event storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(), , 'PotP Storage');
			}
			else
			{
				PotP_Logger("Existing event storage instance loaded with a size of: " + master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(), , 'PotP Storage');
			}
		}

	//---------------------------------------------------

		if (!master.PotP_PersistentStorage.pWorldStorage)
		{
			SleepOneFrame();
			master.PotP_PersistentStorage.pWorldStorage = new CProgressOnThePath_WorldStorage in master.PotP_PersistentStorage;
			PotP_Logger("New world storage instance created.", , 'PotP Storage');
			master.PotP_PersistentStorage.pWorldStorage.inititalise();
			PotP_Logger("New world storage instance initialised.", , 'PotP Storage');
		}
		else 
		{
			if (parent.force_refresh == 'All' || parent.force_refresh == 'World'|| PotP_ModAddedOrRemoved('World'))
			{
				SleepOneFrame();
				master.PotP_PersistentStorage.pWorldStorage.inititalise();
				PotP_Logger("Existing world storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pWorldStorage.MasterList_World.Size(), , 'PotP Storage');
			}
			else
			{
				PotP_Logger("Existing world storage instance loaded with a size of: " + master.PotP_PersistentStorage.pWorldStorage.MasterList_World.Size(), , 'PotP Storage');
			}
		}

	//---------------------------------------------------

		if (!master.PotP_PersistentStorage.pItemsStorage)
		{
			SleepOneFrame();
			master.PotP_PersistentStorage.pItemsStorage = new CProgressOnThePath_ItemsStorage in master.PotP_PersistentStorage;
			PotP_Logger("New items storage instance created.", , 'PotP Storage');
			master.PotP_PersistentStorage.pItemsStorage.inititalise();
			PotP_Logger("New items storage instance initialised.", , 'PotP Storage');
		}
		else 
		{
			if (parent.force_refresh == 'All' || parent.force_refresh == 'Items'|| PotP_ModAddedOrRemoved('Items'))
			{
				SleepOneFrame();
				master.PotP_PersistentStorage.pItemsStorage.inititalise();
				PotP_Logger("Existing items storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(), , 'PotP Storage');
			}
			else
			{
				PotP_Logger("Existing items storage instance loaded with a size of: " + master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(), , 'PotP Storage');
			}
		}

		//---------------------------------------------------
		
		PotP_ApplyDLCFacts();
		
		if (parent.debug) {
			GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Reload Completed...");
		}

		master.PotP_UpdaterClass		.initialise(master);
		master.PotP_PinManager			.initialise(master);
		master.PotP_QuestPreview		.initialise(master);
		master.PotP_WorldPreview		.initialise(master);
		master.PotP_ItemsPreview		.initialise(master);
		master.PotP_GwentPreview		.initialise(master);
		master.PotP_MissablePreview		.initialise(master);
		master.PotP_Notifications		.initialise(master);
		master.PotP_ItemsGoblin			.initialise(master);
		master.PotP_QuestGoblin			.initialise(master);
		master.PotP_WorldGoblin			.initialise(master);
		master.PotP_EventListener		.initialise(master);
		master.PotP_MeditationListener	.initialise(master);
		master.PotP_PopupManager		.initialise(master);
		master.SetModVersion();
		
		(new ProgressOnTheBath_TutorialBook1 in master).addBook();
		(new ProgressOnTheBath_TutorialBook2 in master).addBook();
		(new ProgressOnTheBath_TutorialBook3 in master).addBook();
		(new ProgressOnTheBath_TutorialBook4 in master).addBook();
		(new ProgressOnTheBath_TutorialBook5 in master).addBook();
		(new ProgressOnTheBath_TutorialBook6 in master).addBook();
		(new ProgressOnTheBath_TutorialBook7 in master).addBook();
		
		(new CProgressOnTheBath_QuestPreviewBook in master).addBook(master);
		(new CProgressOnTheBath_WorldPreviewBook in master).addBook(master);
		(new CProgressOnTheBath_ItemsPreviewBook in master).addBook(master);
		(new CProgressOnTheBath_MissaPreviewBook in master).addBook(master);
		(new CProgressOnTheBath_GwentPreviewBook in master).addBook(master);
		
		master.PotP_PinManager.GotoState('Idle');
		master.PotP_ItemsGoblin.GotoState('Idle');
		master.PotP_WorldGoblin.GotoState('Idle');
		master.PotP_EventListener.GotoState('Idle');
		master.PotP_MeditationListener.GotoState('Idle');
		parent.GotoState('Disabled');
	}
	
	//---------------------------------------------------
	
	latent function PotP_ApplyDLCFacts() : void
	{
		SleepOneFrame();
		FactsSet("PotP_UsingDLCArmorQuests", 		(int) PotP_UsingDLCArmorQuests());
		FactsSet("PotP_UsingThreeLittleSisters", 	(int) PotP_UsingThreeLittleSisters());
		FactsSet("PotP_UsingCiriSoleMemento", 		(int) PotP_UsingCiriSoleMemento());
		FactsSet("PotP_UsingANightToRemember", 		(int) PotP_UsingANightToRemember());
		FactsSet("PotP_UsingDLCFastTravel", 		(int) PotP_UsingDLCFastTravel());
		FactsSet("PotP_UsingShadesOfIron", 			(int) PotP_UsingShadesOfIron());
		FactsSet("PotP_UsingGwentRedux", 			(int) PotP_UsingGwentRedux());
		FactsSet("PotP_UsingW3EE",					(int) PotP_UsingW3EE());
		FactsSet("PotP_UsingSezonBurz", 			(int) PotP_UsingSezonBurz());
		FactsSet("PotP_UsingCosWiecej", 			(int) PotP_UsingCosWiecej());
		
		PotP_Logger("DLC Facts Applied...", , 'PotP Storage');
	}
	
	//---------------------------------------------------
	
	private function PotP_ModAddedOrRemoved(section : name) : bool
	{
		if (section == 'Quest' && (PotP_UsingDLCArmorQuests() 		!= (bool) FactsQuerySum("PotP_UsingDLCArmorQuests")) ) 		{ return true; }
		if (section == 'Quest' && (PotP_UsingThreeLittleSisters()	!= (bool) FactsQuerySum("PotP_UsingThreeLittleSisters")) ) 	{ return true; }
		if (section == 'Quest' && (PotP_UsingCiriSoleMemento() 		!= (bool) FactsQuerySum("PotP_UsingCiriSoleMemento")) ) 	{ return true; }
		if (section == 'Quest' && (PotP_UsingANightToRemember() 	!= (bool) FactsQuerySum("PotP_UsingANightToRemember")) ) 	{ return true; }
		
		if (section == 'World' && (PotP_UsingDLCFastTravel() 		!= (bool) FactsQuerySum("PotP_UsingDLCFastTravel")) ) 		{ return true; }
		
		if (section == 'Items' && (PotP_UsingShadesOfIron() 		!= (bool) FactsQuerySum("PotP_UsingShadesOfIron")) ) 		{ return true; }
		if (section == 'Items' && (PotP_UsingGwentRedux() 			!= (bool) FactsQuerySum("PotP_UsingGwentRedux")) ) 			{ return true; }
		if (section == 'Items' && (PotP_UsingW3EE() 				!= (bool) FactsQuerySum("PotP_UsingW3EE")) ) 				{ return true; }
		if (section == 'Items' && (PotP_UsingSezonBurz() 			!= (bool) FactsQuerySum("PotP_UsingSezonBurz")) ) 			{ return true; }
		if (section == 'Items' && (PotP_UsingCosWiecej() 			!= (bool) FactsQuerySum("PotP_UsingCosWiecej")) ) 			{ return true; }
		
		return false;
	}
}

//---------------------------------------------------
//-- Settings Access Functions ----------------------
//---------------------------------------------------

function PotP_GetGeneralValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_GeneralSettings', variable);
}

function PotP_GetPreviewValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_PreviewSettings', variable);
}

function PotP_GetNotificationValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_NotificationSettings', variable);
}

//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_WorldStorage
{		
	var MasterList_World			:array<PotP_PreviewEntry>;
	
	var AbandonedSites_WhiteOrchard	: array<PotP_PreviewEntry>;
	var AbandonedSites_Velen		: array<PotP_PreviewEntry>;
	var AbandonedSites_Novigrad		: array<PotP_PreviewEntry>;
	var AbandonedSites_Skellige		: array<PotP_PreviewEntry>;
	var AbandonedSites_Toussaint	: array<PotP_PreviewEntry>;
	
	var BanditCamps_WhiteOrchard	: array<PotP_PreviewEntry>;
	var BanditCamps_Velen			: array<PotP_PreviewEntry>;
	var BanditCamps_Novigrad		: array<PotP_PreviewEntry>;
	var BanditCamps_Skellige		: array<PotP_PreviewEntry>;
	var BanditCamps_Toussaint		: array<PotP_PreviewEntry>;
	
	var GuardedTreasure_WhiteOrchard	: array<PotP_PreviewEntry>;
	var GuardedTreasure_Velen			: array<PotP_PreviewEntry>;
	var GuardedTreasure_Novigrad		: array<PotP_PreviewEntry>;
	var GuardedTreasure_Skellige		: array<PotP_PreviewEntry>;
	var GuardedTreasure_KaerMorhen		: array<PotP_PreviewEntry>;
	var GuardedTreasure_Toussaint		: array<PotP_PreviewEntry>;
	
	var DistressedKnights_Toussaint	: array<PotP_PreviewEntry>;
	var InfestedVineyards_Toussaint	: array<PotP_PreviewEntry>;
	var HanseBases					: array<PotP_PreviewEntry>;
	
	var MonsterDens_Velen			: array<PotP_PreviewEntry>;
	var MonsterDens_Novigrad		: array<PotP_PreviewEntry>;
	var MonsterDens_Skellige		: array<PotP_PreviewEntry>;
	var MonsterDens_Toussaint		: array<PotP_PreviewEntry>;

	var MonsterNests_WhiteOrchard	: array<PotP_PreviewEntry>;
	var MonsterNests_Velen			: array<PotP_PreviewEntry>;
	var MonsterNests_Novigrad		: array<PotP_PreviewEntry>;
	var MonsterNests_Skellige		: array<PotP_PreviewEntry>;
	var MonsterNests_Toussaint		: array<PotP_PreviewEntry>;

	var PersonsInDistress_Velen		: array<PotP_PreviewEntry>;
	var PersonsInDistress_Skellige	: array<PotP_PreviewEntry>;
	var PersonsInDistress_Toussaint	: array<PotP_PreviewEntry>;
	
	var PlacesOfPower_WhiteOrchard	: array<PotP_PreviewEntry>;
	var PlacesOfPower_Velen			: array<PotP_PreviewEntry>;
	var PlacesOfPower_Novigrad		: array<PotP_PreviewEntry>;
	var PlacesOfPower_Skellige		: array<PotP_PreviewEntry>;
	var PlacesOfPower_KaerMorhen	: array<PotP_PreviewEntry>;
	var PlacesOfPower_Toussaint		: array<PotP_PreviewEntry>;
	var PlacesOfPower_TheSpiral		: array<PotP_PreviewEntry>;

	var Signposts_WhiteOrchard		: array<PotP_PreviewEntry>;
	var Signposts_Velen				: array<PotP_PreviewEntry>;
	var Signposts_Novigrad			: array<PotP_PreviewEntry>;
	var Signposts_Skellige			: array<PotP_PreviewEntry>;
	var Signposts_KaerMorhen		: array<PotP_PreviewEntry>;
	var Signposts_Toussaint			: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP World Storage';

//---------------------------------------------------
	
	function inititalise()
	{
		this.GotoState('Build');
	}
	
//---------------------------------------------------
	
	function CreateEntry() : PotP_PreviewEntry
	{
		return new PotP_PreviewEntry in this; 
	}

//---------------------------------------------------

	function CreateUniqueIdentifier() : string 
	{
		UUIDINT += 1;
		return "WX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_WorldStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Build State ------------------------------------
//---------------------------------------------------
	
state Build in CProgressOnThePath_WorldStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	

	entry function Build()
	{
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MasterList_World.Clear();
		
		this.Build_Sites();
		this.Build_Camp();
		this.Build_Guard();
		this.Build_Dens();
		this.Build_Nest();
		this.Build_Plac();
		this.Build_Distr();
		this.Build_Sign();
		this.Build_Toussaint();

		for ( Idx = 0; Idx < parent.MasterList_World.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_World[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_World[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_World[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_World[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_World[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_World[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_World[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Toussaint()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_DistressedKnights_Toussaint";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.DistressedKnights_Toussaint.Clear();
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_bar_a_12_mp'));     
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_a_09_mp')); 
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_d_07_mp')); 
		
		PotP_SortPreviewData(parent.DistressedKnights_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_InfestedVineyards_Toussaint";
		
		parent.InfestedVineyards_Toussaint.Clear();
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_01_mp'));     
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_02_mp'));
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_vin_a_02_mp')); 		
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_poi_ww_cor_1_mp')); 		
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_ww_poi_bel_9_mp')); 				
		
		PotP_SortPreviewData(parent.InfestedVineyards_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_HanseBases_Toussaint";
		
		parent.HanseBases.Clear();
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_bar_a_01_mp'));     
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_gor_d_05_mp'));
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_ved_a_01_mp')); 							
		
		PotP_SortPreviewData(parent.HanseBases, PotP_A_World, master);
		
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Sites()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_AbandonedSites_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.AbandonedSites_WhiteOrchard.Clear();
		parent.AbandonedSites_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'lumbermill_camp_mp'));     
		parent.AbandonedSites_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'road_protection_shrine')); 
		
		PotP_SortPreviewData(parent.AbandonedSites_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Velen";
		
		parent.AbandonedSites_Velen.Clear();
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_de29'));     
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'cp5_town_resc'));
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr11_b')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr12_town')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr27')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb10')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb14')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb3')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm3')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm4')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_08_mp_rt')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_30_mp')); 				
		
		PotP_SortPreviewData(parent.AbandonedSites_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Novigrad";
		
		parent.AbandonedSites_Novigrad.Clear();
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi20_mp'));     
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_37_mp'));
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi07_mp')); 		
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi06_mp')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Skellige";
		
		parent.AbandonedSites_Skellige.Clear();
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk34_mp'));     
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk33_mp'));
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk52_mp_skellige')); 		
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk75_mp_skellige')); 					
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk51_mp_skellige')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Toussaint";
		
		parent.AbandonedSites_Toussaint.Clear();
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_a_03_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_b_04_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_car_b_03_mp')); 		
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_b_12_mp')); 	
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_c_03_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_d_06_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_ved_a_02_mp')); 		
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_cor_2_mp')); 	
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_10_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_12_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_ww_poi_bel_5_mp')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Toussaint, PotP_A_World, master);
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Camp()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.BanditCamps_WhiteOrchard.Clear();
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_camp'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire2')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire3')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_road'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire'));  
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_sanctuary'));
		
		PotP_SortPreviewData(parent.BanditCamps_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Skellige";
		
		parent.BanditCamps_Skellige.Clear();
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk10_mp_giantfoot_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk16_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk28_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk36_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk111_mp_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk86_mp_skl'));
		
		PotP_SortPreviewData(parent.BanditCamps_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint";
		
		parent.BanditCamps_Toussaint.Clear();
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_17_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_09_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_07_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_car_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_18_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_b_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_07_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_13_mp_ban'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_a_09_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_12_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_vin_b_06_mp'));
		
		PotP_SortPreviewData(parent.BanditCamps_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad";
		
		parent.BanditCamps_Novigrad.Clear();
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gf42'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_hs16'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi17_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'gf203_mp_nml'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi16_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi23_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi09_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi_ofir_camp_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi11_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi12_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi13_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi14_mp'));
		
		PotP_SortPreviewData(parent.BanditCamps_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Velen";
		
		parent.BanditCamps_Velen.Clear();
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cb18'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_bm2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de101'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de102'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de25'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gr31'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'pit_camp_nml_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'mp2_nml_mappin'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cp37'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb23'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb30'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb20'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb12'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb5'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb7_camp_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb5b_mp_nml_yet'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb7'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb18'));
		
		PotP_SortPreviewData(parent.BanditCamps_Velen, PotP_A_World, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Guard()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_GuardedTreasure_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.GuardedTreasure_WhiteOrchard.Clear();
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'beached_boats'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'boat_wreck'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'cemetary_wraith'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'dead_horses_prologue'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'waterhag_mappin'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Velen";
		
		parent.GuardedTreasure_Velen.Clear();
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_a'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_b'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm3'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm4'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cb19'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp11'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp14'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp36'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp38'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr100'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gr15b_mp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gf204_mp_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_mp5'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_wraith_nml_sp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb11'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb19'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb24_swamp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'de100_mp_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_de27'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm100'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm101'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_tm201_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm5'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_33_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Novigrad";
		
		parent.GuardedTreasure_Novigrad.Clear();
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'hs22_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr33'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_hs11'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf202_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf200_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf201_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_24_mp'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi03_mp'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_35_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Novigrad, PotP_A_World, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Skellige";

		parent.GuardedTreasure_Skellige.Clear();
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk1_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk18_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk22_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk23_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk26_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk27_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk32_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk37_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk46_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk72_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk7_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk110_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk106_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk151_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk105_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk76_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk78_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk79_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk80a_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk81_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk82_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk90_mp_skl'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Skellige, PotP_A_World, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_KaerMorhen";
		
		parent.GuardedTreasure_KaerMorhen.Clear();
		parent.GuardedTreasure_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_leshy'));
		parent.GuardedTreasure_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_wyvern'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_KaerMorhen, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Toussaint";
		
		parent.GuardedTreasure_Toussaint.Clear();
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_02_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_08_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_09_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_11_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_05_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_07_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_dun_b_08_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_a_08_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_d_17_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_d_19_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_04_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_06_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_ved_a_07_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_ved_a_08_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_vin_b_04_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_cor_5_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_ver_9_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_ww_poi_bel_6_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Toussaint, PotP_A_World, master);		
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Dens()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterDens_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MonsterDens_Velen.Clear();
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gr38'));
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de24'));
		
		PotP_SortPreviewData(parent.MonsterDens_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad";
		
		parent.MonsterDens_Novigrad.Clear();
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gf2'));
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de30'));
		
		PotP_SortPreviewData(parent.MonsterDens_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Skellige";
		
		parent.MonsterDens_Skellige.Clear();
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk12_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk25_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk60_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk86_mp'));
		
		PotP_SortPreviewData(parent.MonsterDens_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint";
		
		parent.MonsterDens_Toussaint.Clear();
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_05_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_ved_a_04_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_dun_a_04_cave_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_gor_b_11_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_14_mp'));
		
		PotP_SortPreviewData(parent.MonsterDens_Toussaint, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Nest()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MonsterNests_WhiteOrchard.Clear();
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_hengestone_ghoulnest_pin'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_monster_nest_ghoul5'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_ghouls_nest01'));
		
		PotP_SortPreviewData(parent.MonsterNests_WhiteOrchard, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Velen";
		
		parent.MonsterNests_Velen.Clear();
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr36_nekkers_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr16_pc_nest_rotfiend'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr28_harpynest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_mp4_rotfiend_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_boss'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp34_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'nml_cp5_nest_mp'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'de8_nekker_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_4'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_2'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_02'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp21_drowner_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'bm7_drowners_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'hs13_rotfiend_nest'));		
		
		PotP_SortPreviewData(parent.MonsterNests_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad";
		
		parent.MonsterNests_Novigrad.Clear();
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_34_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'lw_nest_ep1_poi_31_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_19_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi32_nest'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest01'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest02'));	
		
		PotP_SortPreviewData(parent.MonsterNests_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Skellige";
		
		parent.MonsterNests_Skellige.Clear();
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk15_drowner_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk14_nest_sirens'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk74_harpy_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk75_siren_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk_poi_107_nest'));
		
		PotP_SortPreviewData(parent.MonsterNests_Skellige, PotP_A_World, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint";
		
		parent.MonsterNests_Toussaint.Clear();
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_01'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_02'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_gor_b_13_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_b_05_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_dun_a_04_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_a_03_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_car_b_09_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'lw_ww_poi_bel_8_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_b_07_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_a_13_nest'));
		
		PotP_SortPreviewData(parent.MonsterNests_Toussaint, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Plac()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.PlacesOfPower_WhiteOrchard.Clear();
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_ignii_prologue_01'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_axii_prologue_04'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_aard_prologue_02'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_quen_prologue_03'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'pop_quen2_prlg'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_yrden_prologue_05'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_WhiteOrchard, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen";
		
		parent.PlacesOfPower_Velen.Clear();
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_ignii2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_aard'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'lw_ancient_castle_pop'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_quen2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_yrden2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_yrden'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad";
		
		parent.PlacesOfPower_Novigrad.Clear();
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_axii'));
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_ignii'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige";
		
		parent.PlacesOfPower_Skellige.Clear();
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_ignii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_mp_igniii_skellige'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_axii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_axii'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_aard'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Place, PotP_E_Missable, 'skl_pop_quen2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_quen_skellige_mp'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_yrden2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_yrden_mp_skellige'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Skellige, PotP_A_World, master);		

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen";
		
		parent.PlacesOfPower_KaerMorhen.Clear();
		parent.PlacesOfPower_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Place, PotP_E_Primary, 'km_mp_pop_igniii'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_KaerMorhen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint";
		
		parent.PlacesOfPower_Toussaint.Clear();
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_igni_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_axii_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_aard_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_quen_0002'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_yrden_0002'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Toussaint, PotP_A_World, master);	
		
		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral";
		
		parent.PlacesOfPower_TheSpiral.Clear();
		parent.PlacesOfPower_TheSpiral.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TS, PotP_I_Place, PotP_E_Missable, 	'aard_gasforest'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_TheSpiral, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Distr()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.PersonsInDistress_Velen.Clear();
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_cp13'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr13'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr29'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_hs2'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_tm12'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'ep1_pan_dziedzina_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Skellige";
		
		parent.PersonsInDistress_Skellige.Clear();
		parent.PersonsInDistress_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk29_mp'));
		parent.PersonsInDistress_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk90_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Skellige, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Toussaint";
		
		parent.PersonsInDistress_Toussaint.Clear();
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_bar_a_02_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_ved_a_05_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_cor_3_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_ver_11_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_ww_poi_bel_7_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Toussaint, PotP_A_World, master);	
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Sign()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.Signposts_KaerMorhen.Clear();
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_eye'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_mine_dam'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'kaer_morhen_entrance'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'lake_house'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'km_outpost_ruins'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{ 
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'chort_cave'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'circle_of_elements'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_courtyard'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_valley'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'trials_cave'));
		}

		PotP_SortPreviewData(parent.Signposts_KaerMorhen, PotP_A_World, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Novigrad";
		
		parent.Signposts_Novigrad.Clear();
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'demolished_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'retting_ponds'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_arnskrone_castle'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_marsh_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_wedding_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'smugglers_den'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_lighthouse_last_hope'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'rocky_pass'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'goose_cunt_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noonwraith_tower'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_dragon_valley_outpost'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_isle_round_square'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_forest_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'philippa_ruins'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'eternal_fire_chapel'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_road_to_olgiers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_southeast_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_south_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_grainfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ruin_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_herbalist'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'triss_house'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noblemans_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hunters_hut'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'midget_forgers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_kilkerin'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'grassy_knoll_lighthouse'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dwarven_woodchucks'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'lucjans_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'plantation_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'vacant_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_piers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_east'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_harbor'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_shouth_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyards'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'seven_cats_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_bridge_south'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'roches_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'nov_main_gate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ofir_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ursten'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dawn_estate_entrance'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hilltop'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_von_everecs_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_west'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'cropfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'widow_cave'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyard_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_55", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'Slone_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_56", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_zutzer_castle'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_88", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'barrengarth'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_89", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'crippled_kate'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'farcorners'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_gildorf'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_harborside'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'hattori_workshop'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bridge'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_academy'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'passiflora'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'bathhouse'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_98", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_silverton'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_99", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bits'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Skellige";
		
		parent.Signposts_Skellige.Clear();
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'abandoned_lumber_mill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'elven_vault'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arinbjorn'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rocky_bay'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'blandare_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ravens_home_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'kaer_trolde_bridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_blacksmith'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'stolen_road'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'distillery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ice_giant_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'druid_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'northern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'southern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fayrlund'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'halgrims_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'herbarium'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fyresdal'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holy_oak'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'giants_foot'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arsehole_cave'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_vantage_point'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holmstein_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_arena_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'huindarsfjal_destroyed_farmstead'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'prison_island'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fort_gelen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lugos_keep'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'craite_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'larvik'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofotten'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofoten_cemetery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lurthen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_shore_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'miners_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ancient_perimeter'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rannvaig'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'redgill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ragnar_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_roast_kipper_tavern'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'sheperd_huts'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_avallach_lab'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_ridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'an_skellig_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_3'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'whaleyard'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'wild_shores'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ridgetop'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'skellige_tomb_3'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'ard_hugtand'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'castle_tuirseach'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_dhu'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_nyssen'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_trolde_village'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'melusine_cave'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'snidhall_isle'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'hemdall_shrine'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Skellige, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard";
		
		parent.Signposts_WhiteOrchard.Clear();
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'well_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Broken_bridge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'bridge_gate'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Crossroads'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'River_crossing'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Windmill'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Nilfgaard_camp'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'ransacked_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woodcutters_lodge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woesong_bridge'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_WO, PotP_I_Signs, PotP_E_ModAdded, 'king_desmond_bridge'));
		}
		
		PotP_SortPreviewData(parent.Signposts_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Toussaint";
		
		parent.Signposts_Toussaint.Clear();
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ardaiso_quarry_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'swamps_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lake_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_palace_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'belgard_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'castel_ravello_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'casteldaccia_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'longhollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_north_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'coronata_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'corvo_bianco_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'watermill_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmill_west_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'northern_dun_tynne_crossing_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_vineyards_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'flovive_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'abandoned_castle_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'fox_hollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'francollarts_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'gelenser_farmstead_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'harbour_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ronneville_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'temple_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_cemetery_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_east_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'mont_crane_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'upper_city_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'palace_gardens_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'vermentino_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'feet_of_lebioda_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'sawmill_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lower_city_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmills_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'elven_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'termes_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tesham_mutna_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'cockatrice_inn_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'main_square_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'village_by_swamp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tournament_meadows_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'prison_island_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'merchants_camp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'trastamara_mansion_ft'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'abandoned_storehouse'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'bastoy_prison_ruins'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'doren_alma_estate'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lac_celavy'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lafargue_workshop'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'belles'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'vermentino_vineyard'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'villa_vedette'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Toussaint, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Velen";
		
		parent.Signposts_Velen.Clear();
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cp_abandoned_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'incredibly_big_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_slaver_camp'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'benek_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'snots_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'boatmakers_hut'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'halver_isle'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'burned_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_brickmakers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'glinsk_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'shipwreck_shore'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'stray_kings_quarry'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'massacred_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'road_to_baldenfort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_yard'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'baldenfort_bastion'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'plague_pit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'downwarren'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'griffin_dungeon_exit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_deserted_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'roadside_chapel'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bayors_ferry_station'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sb_forest_house'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mudwell'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'popiels_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'Dungeon 5'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'nml_hangman_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'hangmans_ave'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'wagon_top'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'heatherton_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fort_mar'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fortfified_farmstead'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'crossroads_inn'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'seaside_shack'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'swamp_edge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'midcopse'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'reef_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'lanka_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'marauders_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mouth_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'poppystone'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'novigrad_garrison'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'willows_grove'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'rudnik'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'descent_hunting_lodge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'doomsday_worshippers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bald_mountain'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cb_swamp_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'freckle_hill'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'ladies_of_the_wood'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'toderas_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'old_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'haunted_estate'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'debris_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_55", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sacred_circle'));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_56", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_castle'));
		}
		
		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'crookback_bog'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'honorton'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'mowshurst'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_bridge'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'pellar_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'witch_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'nilfgaardian_camp'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Velen, PotP_A_World, master);	
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Event_Updater
{
	var filename: name;
		default filename = 'PotP Event Script';
	
	public var master: CProgressOnThePath;
	public var entity: PotP_PreviewEntry;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Event_Updater
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('UpdateAll');
	}
	
	//---------------------------------------------------
	
	public function UpdateEvent(entity: PotP_PreviewEntry) : void
	{
		this.entity = entity;
		this.GotoState('Idle');
		this.GotoState('UpdateOne');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state UpdateAll in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [UpdateAll]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.UpdateAll_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function UpdateAll_Main() 
	{
		var pData_E: array<PotP_PreviewEntry> = parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
		var Idx: int;
		
		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{				
			if (parent.entity_helper.IsPlayable(pData_E[Idx]) && FactsQuerySum(pData_E[Idx].entryname) > 0) 
			{
				parent.entity_helper.SetCompleted(pData_E[Idx]);
				parent.entity_helper.AddToNotificationQueue(pData_E[Idx]);
			}
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state UpdateOne in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [UpdateOne]", , parent.filename);
		
		this.UpdateOne_Entry();
	}

//---------------------------------------------------

	entry function UpdateOne_Entry() 
	{
		this.UpdateOne_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function UpdateOne_Main() 
	{
		FactsSet(parent.entity.entryname, 1);
		
		parent.entity_helper.SetCompleted(parent.entity);
		parent.entity_helper.AddToBackgroundQueue(parent.entity, 2);

		while (PotP_IsPlayerBusy())
		{
			SleepOneFrame();
		}

		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

quest function PotP_CompleteEvent(fact_name: name, optional fact_name_string: string)
{
	var filename		: name = 'PotP_CompleteEvent';
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;
	
	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(NameToString(fact_name), 1);
		PotP_Logger("Setting Event Fact - " + fact_name, , filename);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// If a match is found, send the entity to the event update class.	
		if (pEvent_List[Idx].entryname == NameToString(fact_name) && master.PotP_EntityHelper.IsPlayable(pEvent_List[Idx]))
		{
			master.PotP_UpdaterClass.PotP_Event.UpdateEvent(pEvent_List[Idx]);
		}		
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

function PotP_CompleteEventByString(fact_name: string)
{
	var filename		: name = 'PotP_CompleteEventByString';
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;
	
	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(fact_name, 1);
		PotP_Logger("Setting Event Fact - " + fact_name, , filename);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// If a match is found, send the entity to the event update class.	
		if (pEvent_List[Idx].entryname == fact_name && master.PotP_EntityHelper.IsPlayable(pEvent_List[Idx]))
		{
			master.PotP_UpdaterClass.PotP_Event.UpdateEvent(pEvent_List[Idx]);
		}	
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

quest function PotP_UnlockEvent(UUID: string, Location: string, Fact: string)
{
	var filename		: name = 'PotP_UnlockEvent';
	var PopupMessage	: string = GetLocStringByKeyExt("PotP_NewEventMessage1");
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;

	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(Fact + "_unlocked", 1);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// Try to assign the name and location of the unlocked event.
		if (pEvent_List[Idx].uuid == UUID)
		{
			// If the event is already unlocked, return.
			if (master.PotP_EntityHelper.IsEventUnlocked(pEvent_List[Idx]))
			{
				return;
			}
			
			//Unlock the event.
			master.PotP_EntityHelper.UnlockEvent(pEvent_List[Idx]);
			
			//Reset Map Pins to show unlocked event on the world map.
			master.PotP_PinManager.GotoState('Updating');
			
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Event') )
			{
				//Replace the popup message tags with the event name and location.
				PopupMessage = StrReplace(PopupMessage, "[EVENTNAME]", pEvent_List[Idx].localname);
				PopupMessage = StrReplace(PopupMessage, "[EVENTLOCATION]", GetLocStringByKeyExt(Location));
				
				//Add the message to the notification queue for display.
				
				master.PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), PopupMessage, pEvent_List[Idx].entryname, "Hint", false);
			}
		}
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Relic_Updater {

	var filename: name;
		default filename = 'PotP Items Script';
	
	public var master: CProgressOnThePath;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Relic_Updater
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Relic_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_Relic_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.Updating_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function Updating_Main() 
	{
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		var pData_E: array<PotP_PreviewEntry> 	= parent.master.PotP_PersistentStorage.pItemsStorage.MasterList_Items;
		var Idx: int;
		
		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{			
			if (pData_E[Idx].arrayType == PotP_A_Gwent)
			{
				if (!GwentManager.HasLootedCard() || (pData_E[Idx].filter == PotP_I_Skell && !GwentManager.IsDeckUnlocked(GwintFaction_Skellige)))
				{
					continue;
				}
				
				if (this.IsCardCollected(pData_E[Idx]) && parent.entity_helper.IsPlayable(pData_E[Idx]))
				{
					parent.entity_helper.SetCompleted(pData_E[Idx]);
					parent.entity_helper.AddToNotificationQueue(pData_E[Idx]);
				}
				continue;
			}
			
			if (this.IsItemCollected(pData_E[Idx]) && parent.entity_helper.IsPlayable(pData_E[Idx]))
			{
				parent.entity_helper.SetCompleted(pData_E[Idx]);
				parent.entity_helper.AddToNotificationQueue(pData_E[Idx]);
			}
		}
	}

//---------------------------------------------------

	private function IsItemCollected(pData_E: PotP_PreviewEntry) : bool 
	{
		var PInventory: CInventoryComponent = thePlayer.GetInventory();
		var SInventory: CInventoryComponent = GetWitcherPlayer().GetHorseManager().GetInventoryComponent();
		var Idx, min, max: int;
		
		for (Idx = 0; Idx < pData_E.variations.Size(); Idx += 1) 
		{
			PInventory.GetItemQualityFromName(pData_E.variations[Idx], min, max);

			if (min >= 4 && (parent.entity_helper.IsCollected(pData_E) || PInventory.HasItem(pData_E.variations[Idx]) || SInventory.HasItem(pData_E.variations[Idx]) || GetWitcherPlayer().GetHorseManager().IsItemEquippedByName(pData_E.variations[Idx])))
			{ 
				return true;
			}
		}
		return false;
	}

//---------------------------------------------------

	private function IsCardCollected(pData_E: PotP_PreviewEntry) : bool {
		
		var Idx: int;

		if ( pData_E.item_name == 'BASEDECK' || thePlayer.GetInventory().HasItem(pData_E.item_name) )
		{ 
			return true; 
		}
		
		for ( Idx = 0; Idx < pData_E.variations.Size(); Idx += 1 )
		{
			if ( thePlayer.GetInventory().HasItem(pData_E.variations[Idx]) ) 
			{
				return true;
			} 
		}
		return false;
	}
}		

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Quest_Updater
{
	public var filename: name;
	default filename = 'PotP Quest Script';
	
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Quest_Updater
	{
		this.master = master;
		this.storage = master.PotP_PersistentStorage;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Quest_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_Quest_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.Updating_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function Updating_Main() 
	{
		var QstManager: CWitcherJournalManager = theGame.GetJournalManager();	
		var ent_arr: array<CJournalBase>;
		
		var quest_entity_array: array<PotP_PreviewEntry> 	= parent.master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests;
		var quest_lookup_array: array<string> 				= parent.master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests_Lookup;
		
		var Idx, Edx, status: int;
		
		QstManager.GetActivatedOfType('CJournalQuest', ent_arr );

		for ( Idx = 0; Idx < ent_arr.Size(); Idx += 1 ) 
		{
			status = QstManager.GetEntryStatus(ent_arr[Idx]);
			
			Edx = quest_lookup_array.FindFirst(ent_arr[Idx].baseName);
			if (Edx == -1)
			{	
				PotP_Logger("Unsupported Quest Found - " + ent_arr[Idx].baseName, , parent.filename);
				continue;
			}
			
			if (parent.entity_helper.UpdateQuestEntry(quest_entity_array[Edx], status) && (status == JS_Success || status == JS_Failed))
			{
				parent.entity_helper.AddToNotificationQueue(quest_entity_array[Edx]);
			}				
		}
	}
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_World_Updater extends CEntity
{
	var filename: name;
		default filename = 'PotP World Script';
	
	public var master: CProgressOnThePath;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_World_Updater
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_World_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_World_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.Updating_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function Updating_Main() 
	{	
		var MapManager	: CCommonMapManager = theGame.GetCommonMapManager();
		var pData_E		: array<PotP_PreviewEntry> = parent.master.PotP_PersistentStorage.pWorldStorage.MasterList_World;
		var Idx			: int;

		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 ) {

			if (this.IsMapPinEligible(pData_E[Idx], MapManager)) {
				parent.entity_helper.SetCompleted(pData_E[Idx]);
				parent.entity_helper.AddToNotificationQueue(pData_E[Idx]);
			}
		}	
	}

//---------------------------------------------------

	private function IsMapPinEligible(entry_data: PotP_PreviewEntry, MapManager: CCommonMapManager) : bool {
		
		if (!parent.entity_helper.IsPlayable(entry_data))
		{
			return false;
		}

		if (entry_data.pin_name == 'ep1_poi09_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi09_mp_bugfix');
		}

		if (entry_data.pin_name == 'ep1_poi23_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi23_mp_bugfix');
		}
		
		if (entry_data.filter == PotP_I_Signs) {
			return MapManager.IsEntityMapPinDiscovered(entry_data.pin_name);
		}
		
		return MapManager.IsEntityMapPinDisabled(entry_data.pin_name);
	}
}

//---------------------------------------------------
//-- Bootstrapper Class -----------------------------
//---------------------------------------------------

state CProgressOnThePath_BootStrapper in SU_TinyBootstrapperManager extends BaseMod 
{
	public function getTag(): name 
	{
		return 'CProgressOnThePath_BootStrapper';
	}
	
	public function getMod(): SU_BaseBootstrappedMod 
	{
		return new CProgressOnThePath in parent;
	}
}

//---------------------------------------------------
//-- Builder Result ---------------------------------
//---------------------------------------------------

struct PotP_Builder_Result 
{
  var message: string;
  var total_count: float;
  var completed_count: float;
}

//---------------------------------------------------
//-- Builder ----------------------------------------
//---------------------------------------------------

class ProgressOnThepath_StringBuilder
{
	private var data		: array<PotP_PreviewEntry>;
	private var n_entryList	: array<PotP_PreviewEntry>;
	private var m_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;
		
	private var master: CProgressOnThePath;
	private var entity_helper: CProgressOnThePath_PreviewEntryHelper;
		
	//---------------------------------------------------
	
	public function init(master: CProgressOnThePath) : ProgressOnThepath_StringBuilder 
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function setFilters(areaFilter: int, typeFilter: int) : ProgressOnThepath_StringBuilder 
	{
		// Sets the area and type filter based on user settings.
		this.areaFilter = areaFilter;
		this.typeFilter = typeFilter;
		return this;
	}
	
	//---------------------------------------------------
	
	public function addHeader(header: string) : ProgressOnThepath_StringBuilder 
	{
		// Adds the localised header that should be used for this build.
		this.header = GetLocStringByKeyExt(header);
		
		return this;
	}

	//---------------------------------------------------
	
	public function addDataSet(data: array<PotP_PreviewEntry>) : ProgressOnThepath_StringBuilder 
	{
		// Adds the data array the builder will process.
		this.data = data;
		
		return this;
	}

	//---------------------------------------------------
	
	private function addEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		n_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addMissableEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		m_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	private function FormatHeaderIcon(data: PotP_PreviewEntry, header: string) : string
	{
		return StrReplace(header, "[ICON_PATH]", "<img src='img://" + entity_helper.GetIconPath(data) + "' height='20' width='20' vspace='-5' />&nbsp;");
	}
	
	//---------------------------------------------------
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, m_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		
		// Traverse and separate normal and missable entries from the data array.
		for (Idx = 0; Idx < this.data.Size(); Idx += 1)
		{
			if (this.data[Idx].is_missable) {
				this.addMissableEntry(this.data[Idx]);
				continue;
			}
			this.addEntry(this.data[Idx]);
		}
		
		// Traverse normal entries array (potentially empty)
		for ( Idx = 0; Idx < n_entryList.Size(); Idx += 1 )
		{
			entry_line = this.GetString(n_entryList[Idx]);
			
			if (entry_line != "")
			{
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(n_entryList[Idx], header);
					n_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Traverse missable entries array (potentially empty)
		for ( Idx = 0; Idx < m_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(m_entryList[Idx]);
			
			if (entry_line != "")
			{
				
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(m_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!m_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Missable");
					m_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) !entity_helper.IsPlayable(this.data[Idx]);
		}
		
		// Return message and counts as a result.
		return PotP_Builder_Result
		(
			// Dynamically replace a hard coded tag in the message header with a string containing the current counts.
			StrReplace(messagebody, "[COUNTS]", "(" + (int) FloatToString(completed_count) + " / " + FloatToString(total_count) + ")"),
			total_count, 
			completed_count
		);
	}

	//---------------------------------------------------
	
	private function GetString(entry_data: PotP_PreviewEntry) : string 
	{
		var localName: 		string = entity_helper.getID(entry_data) + entry_data.localname;
		var isCompleted: 	bool = entity_helper.IsCompleted(entry_data);
		var isIgnored: 		bool = entity_helper.IsIgnored(entry_data);
		var isInProgress: 	bool = entity_helper.IsInProgress(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0)
		{
			if (entry_data.arrayType == PotP_A_Items)
			{
				if (entry_data.sub_filter != this.typeFilter)
				{
					return "";
				}		
			}
			else
			{
				if (entry_data.filter != this.typeFilter)
				{
					return "";
				}				
			}
		}

		// Apply line height modifications for a list style effect.
		entry_line = "  - " + localName;
		
		// Increase line height and add colour for missable quests.
		if (entry_data.is_missable)
		{
			entry_line = "<font color='#D79D3A'>       - </font>" + localName;
		}	
		
		// Apply a coloured 'Mod Added' tag to any entries that are not part of the official game.
		if (entry_data.is_modadded) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_MA");
		}		
		
		// Apply a coloured 'In Progress' tag to any active quests that are not yet completed.
		if (isInProgress) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IP");
		}
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_CO");
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IG");
		}
		
		// Return the formatted string back to the builder.
		return entry_line;
	}
}

//---------------------------------------------------
//-- Builder ----------------------------------------
//---------------------------------------------------

class ProgressOnThepath_GwentCardBuilder
{
	private var data		: array<PotP_PreviewEntry>;
	private var u_entryList	: array<PotP_PreviewEntry>;
	private var h_entryList	: array<PotP_PreviewEntry>;
	private var l_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;

	private var filterString: string;
		default filterString = "";
		
	private var master: CProgressOnThePath;
	private var entity_helper: CProgressOnThePath_PreviewEntryHelper;
		
	//---------------------------------------------------
	
	public function init(master: CProgressOnThePath) : ProgressOnThepath_GwentCardBuilder 
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function setFilters(areaFilter: int, typeFilter: int) : ProgressOnThepath_GwentCardBuilder 
	{
		// Sets the area and type filter based on user settings.
		this.areaFilter = areaFilter;
		this.typeFilter = typeFilter;
		return this;
	}
	
	//---------------------------------------------------
	
	public function addHeader(header: string) : ProgressOnThepath_GwentCardBuilder 
	{
		// Adds the localised header that should be used for this build.
		this.header = GetLocStringByKeyExt(header);
		
		return this;
	}

	//---------------------------------------------------
	
	public function addDataSet(data: array<PotP_PreviewEntry>) : ProgressOnThepath_GwentCardBuilder 
	{
		// Adds the data array the builder will process.
		this.data = data;
		
		return this;
	}

	//---------------------------------------------------
	
	private function addUnitEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		u_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addHeroEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		h_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	private function addLeaderEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		l_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function FormatHeaderIcon(data: PotP_PreviewEntry, header: string) : string
	{
		return StrReplace(header, "[ICON_PATH]", "<img src='img://" + entity_helper.GetIconPath(data) + "' height='20' width='20' vspace='-5' />&nbsp;");
	}
	
	//---------------------------------------------------
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, u_headerAdded, h_headerAdded, l_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		
		// Traverse and separate normal and missable entries from the data array.
		for (Idx = 0; Idx < this.data.Size(); Idx += 1)
		{
			if (this.data[Idx].card_type == PotP_G_Lead) {
				this.addLeaderEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].card_type == PotP_G_Hero) {
				this.addHeroEntry(this.data[Idx]);
				continue;
			}
			
			this.addUnitEntry(this.data[Idx]);
		}
		
		// Traverse Leader entries array (potentially empty)
		for ( Idx = 0; Idx < l_entryList.Size(); Idx += 1 )
		{
			entry_line = this.GetString(l_entryList[Idx]);
			
			if (entry_line != "")
			{
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(l_entryList[Idx], header);
					n_headerAdded = true;
				}

				if (!l_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Lead");
					l_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse Hero entries array (potentially empty)
		for ( Idx = 0; Idx < h_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(h_entryList[Idx]);
			
			if (entry_line != "")
			{				
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(h_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!h_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Hero");
					h_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse Unit entries array (potentially empty)	
		for ( Idx = 0; Idx < u_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(u_entryList[Idx]);
			
			if (entry_line != "")
			{
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(u_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!u_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Unit");
					u_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) !entity_helper.IsPlayable(this.data[Idx]);
		}
		
		// Return message and counts as a result.
		return PotP_Builder_Result
		(
			// Dynamically replace a hard coded tag in the message header with a string containing the current counts.
			StrReplace(messagebody, "[COUNTS]", "(" + (int) FloatToString(completed_count) + " / " + FloatToString(total_count) + ")"),
			total_count, 
			completed_count
		);
	}

	//---------------------------------------------------
	
	private function GetString(entry_data: PotP_PreviewEntry) : string 
	{
		var localName: 		string = entity_helper.getID(entry_data) + entry_data.localname;
		var isCompleted: 	bool = entity_helper.IsCompleted(entry_data);
		var isIgnored: 		bool = entity_helper.IsIgnored(entry_data);
		var isInProgress: 	bool = entity_helper.IsInProgress(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0 && entry_data.sub_filter != this.typeFilter)
		{
			return "";
		}	
		
		entry_line = "<font size='25'>       - " + localName + "</font>";

		// Apply a coloured 'Missable' tag to valid gwent cards.
		if (entry_data.is_missable) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_MI");
		}
		
		if ( (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_GExtra') ) 
		{
			// Apply a coloured 'Bought From Vendor' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Bought)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_BO");
			}	

			// Apply a coloured 'Lootable' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Looted)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_LO");
			}	

			// Apply a coloured 'Quest Reward' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Reward)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_QR");
			}	

			// Apply a coloured 'Won in Dual' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Dualed)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_WO");
			}
		}
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_CO");
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IG");
		}
		
		// Return the formatted string back to the builder.
		return entry_line;
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_pos() 
{
	GetWitcherPlayer().DisplayHudMessage(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));
	LogChannel('PotP Position', VecToString(thePlayer.GetWorldPosition()));
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_spiral()
{
	theGame.ScheduleWorldChangeToMapPin( "levels\the_spiral\spiral.w2w", '' );
	theGame.RequestAutoSave( "fast travel", true );
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_forest() 
{
	if(theGame.GetCommonMapManager().GetCurrentArea() == 7) {
		thePlayer.Teleport(Vector(-671.004,-2248.409,81.81971,1));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_reload() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_reload'))
	{
		master.PotP_PersistentStorage.PotP_LoadStorageCollection('All', true);
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------
//pt_LogPins('BanditCamp')
exec function pt_LogPins(PinType: name) {

	var MapPins: array<SEntityMapPinInfo> = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());
	var Idx: int;	
	
	for (Idx = 0; Idx < MapPins.Size(); Idx += 1) {
	  
		if ( MapPins[Idx].entityType != PinType ) {
			continue;
		}
		
		LogChannel('Progress on the Path Map Pin', Idx + ": baseName = " + MapPins[Idx].entityName + " | LocaName = " + GetLocStringByKeyExt("Map_Location_"+NameToString(MapPins[Idx].entityName)));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_update()
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_update'))
	{
		master.PotP_UpdaterClass.StartUpdate();
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_state() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_state'))
	{
		PotP_Logger("Got master from GetPotP()", false, 'pt_state');
		GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Current State = " + NameToString(master.GetCurrentStateName()));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_reset() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_reset'))
	{
		master.PotP_PersistentStorage.MasterList_Completed_V.Clear();
		master.PotP_PersistentStorage.MasterList_IsIgnored_V.Clear();
		master.PotP_PersistentStorage.MasterList_InProgres_V.Clear();
		GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Reset Completed");
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_testtest() 
{
	var master: CProgressOnThePath;
	var storage: CProgressOnThePath_Storage;
	
	var I, Q, W: PotP_PreviewEntry;	
	var Edx, x, y, z: int;
	
	if (GetPotP(master, 'pt_testtest'))
	{
		storage = master.PotP_PersistentStorage;
		
		x = storage.pItemsStorage.MasterList_Items.Size();
		y = storage.pQuestStorage.MasterList_Quests.Size();
		z = storage.pWorldStorage.MasterList_World.Size();
		
		Edx = Min(x, y);	
		Edx = Min(Edx, z);
		Edx = RandRange(Edx, 0);
		
		I = storage.pItemsStorage.MasterList_Items[Edx];
		Q = storage.pQuestStorage.MasterList_Quests[Edx];
		W = storage.pWorldStorage.MasterList_World[Edx];
		
		master.PotP_EntityHelper.AddToBackgroundQueue(I);
		master.PotP_EntityHelper.AddToBackgroundQueue(Q, 2);
		master.PotP_EntityHelper.AddToBackgroundQueue(W);
			
		master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_checkfact(s: string) {
	
	var exist: bool = FactsDoesExist(s);
	var value: int = FactsQuerySum(s);
	
	if (exist) { GetWitcherPlayer().DisplayHudMessage("PotP Fact: [" + s + "] exists with a value of - [" + value + "]"); }
	else { GetWitcherPlayer().DisplayHudMessage("PotP Fact: [" + s + "] does not exist"); }
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_sizes()
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_sizes'))
	{
		PotP_Logger("Got master from GetPotP()", false, 'pt_sizes');
		master.PotP_Notifications._ShowListSizes();
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_complete()
{
	var master: CProgressOnThePath;
	var Idx: int;
	
	if (GetPotP(master, 'pt_complete'))
	{
		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pEventStorage.MasterList_Events[Idx]);
		}
		
		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests[Idx]);
		}

		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pWorldStorage.MasterList_World.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pWorldStorage.MasterList_World[Idx]);
		}

		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pItemsStorage.MasterList_Items[Idx]);
		}	
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddSteelSwords(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('PlayerSteelWeapon');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddSilverSwords(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('PlayerSilverWeapon');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);

			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddCrossbows(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {

			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);

			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddTrophies(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('Trophy');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddQuestItems(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('Quest');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_LogGwentCards(only_variations: bool)
{
	var master: CProgressOnThePath;
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('GwintCard');
	
	var CardArray: array<name>;
	var CardNames: array<string>;
	var CardBases: array< array< name > >;
	var CardName: string;
	var CardBase: name;
	var Idx, Edx: int;
	
	if (!GetPotP(master, 'pt_LogGwentCards'))
	{
		return;
	}	
	
	master.PotP_ItemsGoblin.GotoState('Disabled');
	
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1)
	{
		CardArray.Clear();
		
		PInventory.AddAnItem(ent_arr[Idx], 1);
		
		CardBase = ent_arr[Idx];
		CardName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(CardBase));
		
		if (CardNames.Contains(CardName))
		{
			Edx = CardNames.FindFirst(CardName);
			CardBases[Edx].PushBack(CardBase);
		}
		else
		{
			CardArray.PushBack(CardBase);
			CardNames.PushBack(CardName);
			CardBases.PushBack(CardArray);
		}	
	}
	
	for (Idx = 0; Idx < CardNames.Size(); Idx += 1)
	{
		if (only_variations && CardBases[Idx].Size() == 1)
		{
			continue;
		}
		
		LogChannel('PotP Gwent Card Logger', "["+ Idx +"] Local Name = " + CardNames[Idx]);
		LogChannel('PotP Gwent Card Logger', "["+ Idx +"] Variations = " + CardBases[Idx].Size());
		
		for (Edx = 0; Edx < CardBases[Idx].Size(); Edx += 1)
		{
			LogChannel('PotP Gwent Card Logger', "Variation ["+ Edx +"] = " + CardBases[Idx][Edx]);
		}
		
		LogChannel('PotP Gwent Card Logger', " ");
	}

	master.PotP_ItemsGoblin.GotoState('Idle');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

//pt_AddItemsByName(Forgotten Wolven, true, 999, 1, false, 'All') {

exec function pt_AddItemsByName(itemName: string, LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool, optional section: name) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	
	var a_arr, w_arr, c_arr: array< name >;
	var dup_arr, fin_arr: array< name >;
	var Idx, min, max: int;
	var localName: string;
	
	if (section == 'Armor' || section == 'All') {
		
		a_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Armor');
		
		for (Idx = 0; Idx < a_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(a_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(a_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(a_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(a_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(a_arr[Idx]);
				}
			}
		}
	}
	
	if (section == 'Weapon' || section == 'All') {
		
		w_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Weapon');
		
		for (Idx = 0; Idx < w_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(w_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(w_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(w_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(w_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(w_arr[Idx]);
				}
			}
		}
	}

	if (section == 'Crossbow' || section == 'All') {
		
		c_arr = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
		
		for (Idx = 0; Idx < c_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(c_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(c_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(c_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(c_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(c_arr[Idx]);
				}
			}
		}
	}
	
	for (Idx = 0; Idx < fin_arr.Size(); Idx += 1) {
		PInventory.AddAnItem(fin_arr[Idx], Quantity);
		PInventory.GetItemQualityFromName(fin_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			if (LogEntries) {
				LogChannel('Console Added Items', "["+ Idx +"] BaseName = " + fin_arr[Idx]);
				LogChannel('Console Added Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(fin_arr[Idx])));
				LogChannel('Console Added Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('Console Added Items', " ");	
			}	

			if (RemoveAfter) {
				PInventory.RemoveItemByName(fin_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddItemsByQuality(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool, optional section: name) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	
	var a_arr, w_arr, c_arr: array< name >;
	var dup_arr, fin_arr: array< name >;
	var Idx, min, max: int;
	var localName: string;
	
	if (section == 'Armor' || section == 'All') {
		
		a_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Armor');
		
		for (Idx = 0; Idx < a_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(a_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(a_arr[Idx]) != -1) {
					continue;
				}
				dup_arr.PushBack(a_arr[Idx]);
				fin_arr.PushBack(a_arr[Idx]);
			}
		}
	}
	
	if (section == 'Weapon' || section == 'All') {
		
		w_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Weapon');
		
		for (Idx = 0; Idx < w_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(w_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(w_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(w_arr[Idx]);
				fin_arr.PushBack(w_arr[Idx]);
			}
		}
	}

	if (section == 'Crossbow' || section == 'All') {
		
		c_arr = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
		
		for (Idx = 0; Idx < c_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(c_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(c_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(c_arr[Idx]);
				fin_arr.PushBack(c_arr[Idx]);
			}
		}
	}
	
	for (Idx = 0; Idx < fin_arr.Size(); Idx += 1) {
		PInventory.AddAnItem(fin_arr[Idx], Quantity);
		PInventory.GetItemQualityFromName(fin_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			if (LogEntries) {
				LogChannel('Console Added Items', "["+ Idx +"] BaseName = " + fin_arr[Idx]);
				LogChannel('Console Added Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(fin_arr[Idx])));
				LogChannel('Console Added Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('Console Added Items', " ");	
			}	

			if (RemoveAfter) {
				PInventory.RemoveItemByName(fin_arr[Idx], Quantity);
			}
		}
	}
}

exec function pt_dlc()
{
	var dlcManager : CDLCManager;
	var dlcNames : array<name>;
	var Idx : int;

	dlcManager = theGame.GetDLCManager();
	dlcManager.GetDLCs(dlcNames);
			
	for (Idx = 0; Idx < dlcNames.Size(); Idx += 1)
	{
		if (dlcManager.IsDLCAvailable(dlcNames[Idx]))
		{
			PotP_Logger(NameToString(dlcNames[Idx]), false);
		}
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_variation(type: name, only_variations: bool)
{
	/*Allowed Types
	 *pt_variation('PlayerSilverWeapon', true)
	 *pt_variation('PlayerSteelWeapon', true)
	 *pt_variation('Trophy', true)
	 */
	 
	var master: CProgressOnThePath;
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag(type);
	
	var ItemArray: array<name>;
	var ItemNames: array<string>;
	var ItemBases: array< array< name > >;
	var ItemName: string;
	var ItemBase: name;
	var Idx, Edx, min, max: int;
	
	if (!GetPotP(master, 'pt_LogGwentCards'))
	{
		return;
	}	
	
	master.PotP_ItemsGoblin.GotoState('Disabled');
	
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1)
	{
		ItemArray.Clear();

		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == 4) 
		{	
			PInventory.AddAnItem(ent_arr[Idx], 1);
			
			ItemBase = ent_arr[Idx];
			ItemName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ItemBase));
			
			if (ItemNames.Contains(ItemName))
			{
				Edx = ItemNames.FindFirst(ItemName);
				ItemBases[Edx].PushBack(ItemBase);
			}
			else
			{
				ItemArray.PushBack(ItemBase);
				ItemNames.PushBack(ItemName);
				ItemBases.PushBack(ItemArray);
			}	
		}
	}
	
	for (Idx = 0; Idx < ItemNames.Size(); Idx += 1)
	{
		if (only_variations && ItemBases[Idx].Size() == 1)
		{
			continue;
		}
		
		LogChannel('PotP Variation Logger', "["+ Idx +"] Local Name = " + ItemNames[Idx]);
		LogChannel('PotP Variation Logger', "["+ Idx +"] Variations = " + ItemBases[Idx].Size());
		
		for (Edx = 0; Edx < ItemBases[Idx].Size(); Edx += 1)
		{
			LogChannel('PotP Variation Logger', "Variation ["+ Edx +"] = " + ItemBases[Idx][Edx]);
		}
		
		LogChannel('PotP Variation Logger', " ");
	}

	master.PotP_ItemsGoblin.GotoState('Idle');
}

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

enum PotP_Preview_Items_Filter
{
	PotP_I_Relic  	 = 1,
	PotP_I_Gears  	 = 2,
	PotP_I_Troph  	 = 3,
	PotP_I_Gwent     = 4,
	PotP_I_Sezon	 = 5,
	PotP_I_Shade	 = 6,
	PotP_I_W3eer	 = 7,
	PotP_I_Wiecej	 = 8,
};

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

enum PotP_Preview_Gwent_Underlying_Filter
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
	function initQuest(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, entryname: string): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.entryname 		= entryname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);

		return this;
	}
	
	// init function called when creating the instance of this Random Event.
	function initEvent(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, initially_unlocked: bool, pin_region: string, factname: string, pin_position: Vector): PotP_PreviewEntry 
	{	
		this.type			= type;
		this.entryname 		= factname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);
		
		this.region_string 	= pin_region;
		this.position 		= pin_position;
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (initially_unlocked) { entity_helper.UnlockEvent(this); }
		
		return this;
	}

	// init function called when creating the instance of this World Map pin.
	function initWorld(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, region: PotP_Preview_Region, filter: PotP_Preview_World_Filter, type: PotP_Preview_Entry_Type, pin: name): PotP_PreviewEntry 
	{	
		this.type 			= type;
		this.pin_name 		= pin;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);	
			
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		return this;
	}

	// init function called when creating the instance of this Item.
	function initItems(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, sub_filter: PotP_Preview_Items_Underlying_Filter, item_name: name): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.item_name 	 	= item_name;
		this.uuid 			= uuid;
		this.filter	    	= filter;
		this.sub_filter    	= sub_filter;
		entity_helper.SetType(this);

		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (entity_helper.IsItemCollected(this))
		{
			entity_helper.SetCompleted(this);
		}

		return this;
	}

	// init function called when creating the instance of this Gwent Card.
	function initGwent(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, sub_filter: PotP_Preview_Gwent_Underlying_Filter, item_name: name, optional card_type: PotP_Preview_CardType): PotP_PreviewEntry 
	{	
		this.type 		 	= type;
		this.item_name 	 	= item_name;
		this.uuid 		 	= uuid;
		this.filter	     	= filter;
		this.sub_filter    	= sub_filter;
		entity_helper.SetType(this);
		
		entity_helper.SetCardOrigin(this);
		entity_helper.SetCardType(this, card_type);
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		//PotP_Logger(localname + " is a " + this.card_type + " card that can be " + this.card_origin, , 'PotP Preview Entry');
		return this;
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
	
	function addvariation(variation_name: name) : void
	{
		this.variations.PushBack(variation_name);
		//PotP_Logger("Variation [" + variation_name + "] Assigned to Base Item " + this.item_name,, this.fileName);
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

exec function ptc(identifier: string, optional value: pStatus) 
{
	PotP_ChangeQuestStatus( identifier, value );
}

exec function pt_changestatus(identifier: string, optional value: pStatus) 
{
	PotP_ChangeQuestStatus( identifier, value );
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsUsingNextGen() : bool 
{
	return !StrStartsWith(theGame.GetApplicationVersion(), "v 3");
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP(out master: CProgressOnThePath, optional caller: string): bool 
{
	PotP_Logger("GetPotP Called by [" + caller + "]");
	master = (CProgressOnThePath)SUTB_getModByTag('CProgressOnThePath_BootStrapper');
	
	if (master)
	{
		return true;
	}
	return false;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_QuestGoblin(optional caller: string): CProgressOnThePath_QuestGoblin 
{
	var master: CProgressOnThePath;
	
	if (!GetPotP(master, caller)) 
	{ 
		return NULL; 
	}
	
	return master.PotP_QuestGoblin;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Mappins(): CProgressOnThePath_MapPins 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_PinManager;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Storage(): CProgressOnThePath_Storage 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_PersistentStorage;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Notifications(): CProgressOnThePath_Notifications 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_Notifications;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsPlayerBusy(): bool 
{
	if (PotP_PlayerIsMeditating()) 
	{
		return false;
	}
	
	return thePlayer.IsInNonGameplayCutscene()
		|| theGame.IsLoadingScreenVideoPlaying()
		|| thePlayer.IsInGameplayScene()
		|| (!thePlayer.IsActionAllowed(EIAB_DrawWeapon) && theGame.GetCommonMapManager().GetCurrentArea() != AN_Wyzima)
		|| thePlayer.IsCiri()
		|| theGame.IsDialogOrCutscenePlaying()
		|| theGame.IsCurrentlyPlayingNonGameplayScene()
		|| theGame.IsFading()
		|| theGame.IsBlackscreen()
		|| thePlayer.IsInFistFightMiniGame()
		|| thePlayer.IsInCombat()
		|| !thePlayer.IsAlive();
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_PlayerIsMeditating() : bool 
{
	return thePlayer.GetCurrentStateName() == 'Meditation' || thePlayer.GetCurrentStateName() == 'W3EEMeditation';
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_SortPreviewData(out pData: array<PotP_PreviewEntry>, type: PotP_Preview_Array_Type, master: CProgressOnThePath) 
{
	var data: array<PotP_PreviewEntry>;
	var temp: array<string>;
	var Idx, Edx, Rdx: int;
	
	data = pData;

	for ( Idx = 0; Idx < pData.Size(); Idx += 1 ) 
	{
		temp.PushBack(pData[Idx].localname);
	}
	
	ArraySortStrings(temp);
	pData.Clear();
	
	for ( Idx = 0; Idx < temp.Size(); Idx += 1 ) 
	{
		for ( Edx = 0; Edx < data.Size(); Edx += 1 ) 
		{
			if (temp[Idx] == data[Edx].localname) 
			{
				data[Edx].arrayType  	= type;
					
				pData.PushBack( data[Edx] );
				
				switch ( type )
				{
				case PotP_A_Quest:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pQuestStorage.CreateUniqueIdentifier();
					if ( data[Edx].is_missable ) 
					{
						master.PotP_PersistentStorage.pQuestStorage.AddToMissableArray( data[Edx] );
					}
					master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.PushBack( data[Edx] );
					master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests_Lookup.PushBack( data[Edx].entryname );
					break;
					
				case PotP_A_Event:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pEventStorage.CreateUniqueIdentifier();
					master.PotP_PersistentStorage.pEventStorage.MasterList_Events.PushBack( data[Edx] );
					break;
					
				case PotP_A_World:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pWorldStorage.CreateUniqueIdentifier();
					master.PotP_PersistentStorage.pWorldStorage.MasterList_World.PushBack( data[Edx] );
					break;
					
				case PotP_A_Items:
				case PotP_A_Gwent:	
					
					data[Edx].identifier = master.PotP_PersistentStorage.pItemsStorage.CreateUniqueIdentifier();
					for ( Rdx = 0; Rdx < data[Edx].variations.Size(); Rdx += 1 )
					{
						master.PotP_PersistentStorage.pItemsStorage.SupportedItemsList.PushBack( data[Edx].variations[Rdx] );
						master.PotP_PersistentStorage.pItemsStorage.SupportedItemsList_Entity.PushBack( data[Edx] );
					}
					master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.PushBack( data[Edx] );
					break;
				}
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_ChangeQuestStatus(identifier: string, optional value: pStatus)
{
	var master: CProgressOnThePath;	
	var EntList: array<PotP_PreviewEntry>;
	var IdeList: array<string>;
	var Idx: int;

	if (!GetPotP(master, "PotP_ChangeQuesyStatus")) 
		return;

	EntList = master.PotP_PersistentStorage.pArrayStorage.TotalEntList;	
	IdeList = master.PotP_PersistentStorage.pArrayStorage.TotalIdeList;
	
	Idx = IdeList.FindFirst(identifier);
	
	if (Idx == -1) 
		return;
	
	switch (value) 
	{
	case completed:	
		master.PotP_EntityHelper.SetCompleted(EntList[Idx], true);
		break;
		
	case ignored:
		master.PotP_EntityHelper.SetIgnored(EntList[Idx], true);
		break;
		
	default:
		master.PotP_EntityHelper.SetAvailable(EntList[Idx], true);
		break;
	}
}
	
//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_Logger(message: string, optional ShowInGUI: bool, optional filename: name) 
{	
	/*Comment The Line Out On Release Version */ if ( StrContains(message, "Entered state") ) { return; }
	
	if (filename == '') 
	{
		filename = 'PotP';
	}
	
	LogChannel(filename, message);
  
	if (ShowInGUI)
	{
		GetWitcherPlayer().DisplayHudMessage(NameToString(filename) + ": " + message);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_QuestPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_QuestPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Quest_Name");
		this.icon_path = "icons/PotP/qp.png";
		this.sort_index = 30005;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_QuestPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_QuestPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_QuestPreview.GetBookDescription();
		var countstring		: string = master.PotP_QuestPreview.GetTotalCountsForPreview();
		
		if (master.PotP_QuestPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_WorldPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_WorldPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_World_Name");
		this.icon_path = "icons/PotP/map.png";
		this.sort_index = 30004;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_WorldPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_WorldPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_WorldPreview.GetBookDescription();
		var countstring		: string = master.PotP_WorldPreview.GetTotalCountsForPreview();
		
		if (master.PotP_WorldPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_ItemsPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_ItemsPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Items_Name");
		this.icon_path = "icons/PotP/collect.png";
		this.sort_index = 30003;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_ItemsPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_ItemsPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_ItemsPreview.GetBookDescription();
		var countstring		: string = master.PotP_ItemsPreview.GetTotalCountsForPreview();
		
		if (master.PotP_ItemsPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_GwentPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_GwentPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Gwent_Name");
		this.icon_path = "icons/PotP/gwint_north.png";
		this.sort_index = 30002;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_GwentPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_GwentPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_GwentPreview.GetBookDescription();
		var countstring		: string = master.PotP_GwentPreview.GetTotalCountsForPreview();

		if (master.PotP_GwentPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}

		if (!master.PotP_GwentPreview.CanAccess())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterGwentDeck") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_MissaPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_MissaPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Missa_Name");
		this.icon_path = "icons/PotP/qp_miss.png";
		this.sort_index = 30001;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_MissablePreviewMessage_T") + "</p><br/>";
		var description		: string = master.PotP_MissablePreview.GetBookDescription();
		var countstring		: string = master.PotP_MissablePreview.GetTotalCountsForPreview();

		if (master.PotP_MissablePreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}

		return StrReplace((messagetitle + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook1 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook1';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook1_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30016;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook1_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook2 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook2';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook2_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30015;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook2_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook3 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook3';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook3_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30014;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook3_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook4 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook4';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook4_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30013;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook4_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook5 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook5';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook5_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30012;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook5_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook6 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook6';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook6_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30011;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook6_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook7 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook7';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook7_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30010;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook7_Desc");
	}
}

//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

class CProgressOnThePath_RemoveAllMapPins extends SU_PredicateInterfaceRemovePin 
{
	function predicate(pin: SU_MapPin): bool {
		return StrStartsWith(pin.tag, "PotP_");
	}
}

statemachine class CProgressOnThePath_MapPins extends SU_MapPin {

	public var fileName: name;
		default fileName = 'PotP Map Pin Manager';

	public var master: CProgressOnThePath;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	public var builder: SU_MapPinsBuilder;

	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
	}

	//---------------------------------------------------
	
	public function InitialiseBuilder() 
	{
		builder = new SU_MapPinsBuilder in thePlayer;
	}

	//---------------------------------------------------
	
	public function Build() 
	{
		builder.build();
	}
	
	//---------------------------------------------------
	
	public function RefreshPin(entry_data: PotP_PreviewEntry)
	{
		if (!entity_helper.IsEventUnlocked(entry_data) || !entity_helper.IsPlayable(entry_data))
		{
			return;
		}
		
		builder.tag_prefix("PotP_")
		.pin()
			.tag				(entry_data.uuid)
			.label				(GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Name"))
			.description		(this.GetPinDesc(entity_helper.GetEventDescription(entry_data)))
			.type				(this.GetPinType())
			.filtered_type		("QuestVermentino")
			.radius				(this.GetPinSize())
			.position			(entry_data.position)
			.region 			(entry_data.region_string)
			.is_quest			(false)
			.appears_on_minimap	(false)
			.pointed_by_arrow	(false)
			.highlighted		(false)
		.add();
	}

	//---------------------------------------------------
	
	public function GetPinType() : string {
		
		switch ( (int) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinType') ) {

			case 0:
				return "QuestAvailable";
				
			case 1:
				return "QuestAvailableHoS";
			
			case 2:
				return "QuestAvailableBaW";

			case 3:
				return "StoryQuest";
				
			case 4:
				return "NotDiscoveredPOI";
				
			default:
				return "QuestAvailableHoS";
		}
	}

	//---------------------------------------------------
	
	public function GetPinShow() : bool {
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ShowMapPins');
	}
	
	//---------------------------------------------------
	
	public function GetPinSize() : int {
		return (int) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinRadius');
	}
	
	//---------------------------------------------------
	
	public function GetPinDesc(description: string) : string {
	
		switch ( (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinDescription') )
		{
			case true:
				return description;
				
			default: 
				return GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Description");
		}
	}
}

//---------------------------------------------------
//-- Disabled State ---------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
		
		this.Idle_Main();
	}

//---------------------------------------------------

	entry function Idle_Main() 
	{			
		while (PotP_IsPlayerBusy())
		{
			Sleep(3);
		}
		parent.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- Waiting State ----------------------------------
//---------------------------------------------------

state Waiting in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Waiting]", , parent.fileName);
		
		this.Waiting_Main();
	}

//---------------------------------------------------

	entry function Waiting_Main() 
	{	
		this.Waiting_MonitorForChanges();
	}
	
	latent function Waiting_MonitorForChanges() 
	{
		
		var _GetPinShow: bool 		= parent.GetPinShow();
		var _GetPinDesc: string		= parent.GetPinDesc("_");
		var _GetPinSize: int		= parent.GetPinSize();
		var _GetPinType: string		= parent.GetPinType();

		while( true ) 
		{
			if ( _GetPinShow == parent.GetPinShow() && _GetPinDesc == parent.GetPinDesc("_") && _GetPinSize == parent.GetPinSize() && _GetPinType == parent.GetPinType() )
			{
				Sleep(5);
			}
			else
			{
				while( PotP_IsPlayerBusy() ) 
				{
					SleepOneFrame();
				}
				parent.GotoState('Updating');
				break;
			}
		}
	}
}

//---------------------------------------------------
//-- Tracker Update State ---------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.fileName);
		this.Updating_MapPins_Main();
	}	

	//---------------------------------------------------

	entry function Updating_MapPins_Main() { 
		
		var predicate: CProgressOnThePath_RemoveAllMapPins;
		var Idx: int;

		if (!parent.GetPinShow()) {
			predicate = new CProgressOnThePath_RemoveAllMapPins in thePlayer;
			SU_removeCustomPinByPredicate(predicate);
			parent.GotoState('Waiting');
			return;
		}
		
		parent.InitialiseBuilder();
		
		for (Idx = 0; Idx < parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(); Idx += 1)  {
			parent.RefreshPin(parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events[Idx]);
		}
		
		parent.Build();	
		parent.GotoState('Waiting');
	}
}

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
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Notifications
	{
		this.master = master;
		this.storage = master.PotP_PersistentStorage;
		this.entity_helper = master.PotP_EntityHelper;
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
		var InsertedString: string = entity_helper.GetQuestlocalisedNotificationLine(entry_data, entry_data.filter);
		var InsertedIndexP: int = QuestUpdateArray_Name.FindFirst(InsertedString);

		if (InsertedIndexP == -1)
		{
			QuestUpdateArray_Name.PushBack(InsertedString);
			QuestUpdateArray_Ints.PushBack(1);
			QuestUpdateArray_Icon.PushBack(entity_helper.GetIconPath(entry_data));
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
		var InsertedString: string = entity_helper.GetWorldlocalisedNotificationLine(entry_data.filter);
		var InsertedIndexP: int = WorldMapUpdateArray_Name.FindFirst(InsertedString);

		if (InsertedIndexP == -1) 
		{
			WorldMapUpdateArray_Name.PushBack(InsertedString);
			WorldMapUpdateArray_Ints.PushBack(1);
			WorldMapUpdateArray_Icon.PushBack(entity_helper.GetIconPath(entry_data));
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
		var InsertedString: string = entity_helper.GetItemslocalisedNotificationLine(entry_data.filter);
		var InsertedIndexP: int = ItemUpdateArray_Name.FindFirst(InsertedString);
		
		if (InsertedIndexP == -1) 
		{
			ItemUpdateArray_Name.PushBack(InsertedString);
			ItemUpdateArray_Ints.PushBack(1);
			ItemUpdateArray_Icon.PushBack(entity_helper.GetIconPath(entry_data));
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
		
		switch (entry_data.filter)
		{
		case PotP_I_Camps: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_BanditC") + entry_data.localname; break;
		case PotP_I_Sites: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_AbandonedSite") + entry_data.localname; break;
		case PotP_I_Guard: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_GuardedTreasure") + entry_data.localname; break;
		case PotP_I_Distr: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_PersonInDistress") + entry_data.localname; break;
		case PotP_I_Knigh: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_KnightInDistress") + entry_data.localname; break;
		case PotP_I_Infes: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_InfestedVineyard") + entry_data.localname; break;
		case PotP_I_Hanse: InsertedString = GetLocStringByKeyExt("PotP_NotificationLine_HanseBase") + entry_data.localname; break;
		default : break;
		}
		
		if (storage.pWorldStorageArray_Name.FindFirst(InsertedString) == -1 ) 
		{
			if (storage.BackGroundProcessingArray_Count > 20) 
			{
				storage.BackGroundProcessingArray_Oflow += 1;
				return;
			}
			
			storage.pWorldStorageArray_Name.PushBack(InsertedString);
			storage.pWorldStorageArray_Icon.PushBack(entity_helper.GetIconPath(entry_data));
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
			storage.pQuestStorageArray_Icon.PushBack(entity_helper.GetIconPath(entry_data));
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
			case 0: Notification += FormatItemIcon(entity_helper.GetIconPath(entry_data)) + FormatLine_BackGroundProcessingArray("Restored: " + entry_data.localname); break;
			case 1: Notification += FormatItemIcon(entity_helper.GetIconPath(entry_data)) + FormatLine_BackGroundProcessingArray("Ignored: " + entry_data.localname);  break;
			case 2: Notification += FormatItemIcon(entity_helper.GetIconPath(entry_data)) + FormatLine_BackGroundProcessingArray("Completed: " + entry_data.localname); break;
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

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingShadesOfIron() : bool 
{
	return StrLen(GetLocStringById(2115051416)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingGwentRedux() : bool 
{
	return StrLen(GetLocStringById(2114287601)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingW3EE() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingVladimirUI() : bool
{
	return StrLen(GetLocStringById(2112698555)) > 0;
}
		
//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingFriendlyMeditation() : bool
{
	return StrLen(GetLocStringById(2112067001)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingDLCFastTravel() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_fasttravel');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingSezonBurz() : bool 
{
	return StrLen(GetLocStringById(2112771001)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingCosWiecej() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_wiecej');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingDLCArmorQuests() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc__dlcarmorquests');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingThreeLittleSisters() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_threesisters');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingCiriSoleMemento() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_solememento');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingANightToRemember() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_ntr');
}

//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

struct PotP_PlayerNotification
{
	var message_uuid	: string;
	var message_title	: string;
	var message_body	: string;
	
	var is_unique		: bool;
}

statemachine class CProgressOnThePath_TutorialPopup
{	
	public var filename: name;
		default filename = 'PotP Popup Manager';
	
	public var master: CProgressOnThePath;

	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		
		//Display Pending Messages in persistent storage.
		if (master.PotP_PersistentStorage.MasterList_Pl_Messages.Size() > 0)
		{
			this.GotoState('ShowMessage');
		}
	}
	
	//---------------------------------------------------
		
	public function Showpopup(title: string, body: string, uuid: string, type: string, is_unique: bool) 
	{		
		if (type == "PopUp")
		{
			this.DisplayUserMessage(PotP_PlayerNotification(uuid, title, body, is_unique));
			return;
		}
		
		if (!is_unique && uuid == "")
		{
			uuid = "PotP_GenericMessageID";
		}
		
		master.PotP_PersistentStorage.MasterList_Pl_Messages.PushBack(PotP_PlayerNotification(uuid, title, body, is_unique));
		if (!this.IsInState('ShowMessage')) 
		{ 
			this.GotoState('ShowMessage'); 
		}
	}

//---------------------------------------------------

	private function DisplayUserMessage(message: PotP_PlayerNotification) {

		var popup_data: PotP_PopupData = new PotP_PopupData in thePlayer;

		popup_data.SetMessageTitle( message.message_title );
		popup_data.SetMessageText( message.message_body );
		popup_data.PauseGame = true;
		
		if (PotP_UsingVladimirUI()) 
		{
			popup_data.ScreenPosX = 400.0 / 1920.0;
		}
		
		theGame.RequestMenu('PopupMenu', popup_data);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_TutorialPopup 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		if (parent.master.PotP_PersistentStorage.MasterList_Pl_Messages.Size() > 0)
		{
			parent.GotoState('ShowMessage');
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state ShowMessage in CProgressOnThePath_TutorialPopup 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [ShowMessage]", , parent.filename);
		
		this.ShowMessage_Entry();
	}
	
//---------------------------------------------------

	entry function ShowMessage_Entry()
	{
		var message: PotP_PlayerNotification;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		message = parent.master.PotP_PersistentStorage.MasterList_Pl_Messages[0];
		
		this.DisplayUserMessage(message);

		if (message.is_unique)
		{
			FactsSet(message.message_uuid, 1);
		}
			
		parent.master.PotP_PersistentStorage.MasterList_Pl_Messages.Erase(0);
		parent.GotoState('Idle');
	}
	
//---------------------------------------------------

	latent function DisplayUserMessage(message: PotP_PlayerNotification) {

		var m_tutorialHintDataObj: W3TutorialPopupData = new W3TutorialPopupData in thePlayer;

		m_tutorialHintDataObj.managerRef = theGame.GetTutorialSystem();
		m_tutorialHintDataObj.messageTitle = message.message_title;
		m_tutorialHintDataObj.messageText = "<p align=\"center\">" + message.message_body + "</p>";
		m_tutorialHintDataObj.enableGlossoryLink = false;		
		m_tutorialHintDataObj.autosize = true;
		m_tutorialHintDataObj.blockInput = false;
		m_tutorialHintDataObj.pauseGame = false;
		m_tutorialHintDataObj.fullscreen = false;
		m_tutorialHintDataObj.canBeShownInMenus = true;
		m_tutorialHintDataObj.imagePath = "icons/PotP/wolf.png";
		
		m_tutorialHintDataObj.posX = 0.f;
		m_tutorialHintDataObj.posY = 0.40f;
		
		m_tutorialHintDataObj.duration = ( (float) PotP_GetNotificationValue('ProgressOnThePath_GloballNotification_Time') * 1000 );
		if (message.is_unique)
		{
			m_tutorialHintDataObj.duration = (10 * 1000);
		}
		
		theGame.GetTutorialSystem().ShowTutorialHint(m_tutorialHintDataObj);
		Sleep(m_tutorialHintDataObj.duration);
	}
}
	
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------
	
class PotP_PopupData extends BookPopupFeedback {

	public function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject {
		var objResult : CScriptedFlashObject;
		objResult = super.GetGFxData(parentFlashValueStorage);
		objResult.SetMemberFlashString("iconPath", "img://icons/inventory/scrolls/scroll2.dds");
		return objResult;
	}

	public function SetupOverlayRef(target : CR4MenuPopup) : void {
		super.SetupOverlayRef(target);
		PopupRef.GetMenuFlash().GetChildFlashSprite("background").SetAlpha(100.0);
	}
}

//---------------------------------------------------
//-- Updater Class ----------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_UpdaterClass
{
	public var filename: name; 
		default filename = 'PotP Update';
		
	public var SleepBeforeMeditation: float;
		default SleepBeforeMeditation = 0;

	public var PotP_Quest: CProgressOnThePath_Quest_Updater;
	public var PotP_Event: CProgressOnThePath_Event_Updater;
	public var PotP_World: CProgressOnThePath_World_Updater;	
	public var PotP_Items: CProgressOnThePath_Relic_Updater;
	
	public var master: CProgressOnThePath;
	
//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) 
	{
		this.master = PotP_BaseClass;
		
		this.PotP_Quest = (new CProgressOnThePath_Quest_Updater in this).initialise(PotP_BaseClass);
		this.PotP_Event = (new CProgressOnThePath_Event_Updater in this).initialise(PotP_BaseClass);
		this.PotP_World = (new CProgressOnThePath_World_Updater in this).initialise(PotP_BaseClass);
		this.PotP_Items = (new CProgressOnThePath_Relic_Updater in this).initialise(PotP_BaseClass);
	}
	
//---------------------------------------------------

	public function StartUpdate(optional delay: bool) 
	{
		SleepBeforeMeditation = this.ValidateSleepTime(PotP_UsingW3EE(), PotP_UsingFriendlyMeditation(), delay);
		this.GotoState('Updating');
	}

	//---------------------------------------------------
	
	private function ValidateSleepTime(W3EE: bool, FM: bool, Delay: bool) : float 
	{
		if (Delay) 
		{ 
			return 0.16f; 
		} 
		
		if ((W3EE || FM) && PotP_PlayerIsMeditating()) 
		{
			return 2.75f;
		} 
		return 0;
	}
}

//---------------------------------------------------
//-- Tracker Idle State -----------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_UpdaterClass 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}
	
//---------------------------------------------------
//-- Tracker Update State ---------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_UpdaterClass 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		this.Updating_Main();
	}	

//---------------------------------------------------

	entry function Updating_Main() 
	{
		Sleep(parent.SleepBeforeMeditation);
		
		while (PotP_IsPlayerBusy())
		{
			SleepOneFrame();
		}
		
		parent.master.PotP_Notifications.ResetTrackerUpdateArray();
		
		parent.PotP_Quest.Update();
		parent.PotP_Event.Update();
		parent.PotP_World.Update();
		parent.PotP_Items.Update();
		
		parent.master.PotP_Notifications.DisplayNotification();
		parent.GotoState('Idle');
	}
}

