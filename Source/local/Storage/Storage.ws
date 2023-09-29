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

