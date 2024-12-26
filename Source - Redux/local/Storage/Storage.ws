//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------

enum PotP_Storage_load_Type
{
	PotP_Reset_None = 0,
	PotP_Reset_All = 1,
	PotP_Reset_Quest = 2,
	PotP_Reset_Event = 3, 
	PotP_Reset_World = 4,
	PotP_Reset_Items = 5,
	PotP_Reset_Array = 6,
	PotP_Reset_QuestAndEvent = 7,
	PotP_Reset_QuestAndWorld = 8,
	PotP_Reset_NewGamePlus = 9,
}

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
	
	var force_refresh: PotP_Storage_load_Type;
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

	function PotP_LoadStorageCollection(load_type: PotP_Storage_load_Type, optional debug: bool) 
	{
		this.force_refresh = load_type;
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
		
		if (!master.PotP_PersistentStorage || parent.force_refresh == PotP_Reset_NewGamePlus) 
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
			if (parent.force_refresh == PotP_Reset_All || parent.force_refresh == PotP_Reset_Array)
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
			if (parent.force_refresh == PotP_Reset_All 
				|| parent.force_refresh == PotP_Reset_Quest 
				|| parent.force_refresh == PotP_Reset_QuestAndEvent 
				|| parent.force_refresh == PotP_Reset_QuestAndWorld
			)
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
			if (parent.force_refresh == PotP_Reset_All || parent.force_refresh == PotP_Reset_Event || parent.force_refresh == PotP_Reset_QuestAndEvent)
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
			if (parent.force_refresh == PotP_Reset_All || parent.force_refresh == PotP_Reset_World || parent.force_refresh == PotP_Reset_QuestAndWorld)
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
			if (parent.force_refresh == PotP_Reset_All || parent.force_refresh == PotP_Reset_Items)
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
		
		master.finish_init();
		parent.GotoState('Disabled');
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

