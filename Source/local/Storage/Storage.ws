//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
class CProgressOnThePath_Storage
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
}

function PotP_LoadStorageCollection(master: CProgressOnThePath, optional force_refresh: name) 
{
	if (!master.PotP_PersistentStorage) 
	{
		PotP_Logger("New storage instance created.", , 'PotP Storage');
		master.PotP_PersistentStorage = new CProgressOnThePath_Storage in master;
	}
	else 
	{
		PotP_Logger("Existing master storage instance loaded.", , 'PotP Storage');
	}

//---------------------------------------------------

	if (!master.PotP_PersistentStorage.pArrayStorage)
	{
		master.PotP_PersistentStorage.pArrayStorage = new CProgressOnThePath_ArrayStorage in master.PotP_PersistentStorage;
		master.PotP_PersistentStorage.pArrayStorage.inititalise();
		PotP_Logger("New array storage instance created.", , 'PotP Storage');
	}
	else 
	{
		if (force_refresh == 'All' || force_refresh == 'Array')
		{
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
		master.PotP_PersistentStorage.pQuestStorage = new CProgressOnThePath_QuestStorage in master.PotP_PersistentStorage;
		master.PotP_PersistentStorage.pQuestStorage.inititalise(master);
		PotP_Logger("New quest storage instance created.", , 'PotP Storage');
	}
	else 
	{
		if (force_refresh == 'All' || force_refresh == 'Quest' || PotP_ModAddedOrRemoved('Quest'))
		{
			master.PotP_PersistentStorage.pQuestStorage.inititalise(master);
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
		master.PotP_PersistentStorage.pEventStorage = new CProgressOnThePath_EventStorage in master.PotP_PersistentStorage;
		master.PotP_PersistentStorage.pEventStorage.inititalise(master);
		PotP_Logger("New event storage instance created.", , 'PotP Storage');
	}
	else 
	{
		if (force_refresh == 'All' || force_refresh == 'Event')
		{
			master.PotP_PersistentStorage.pEventStorage.inititalise(master);
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
		master.PotP_PersistentStorage.pWorldStorage = new CProgressOnThePath_WorldStorage in master.PotP_PersistentStorage;
		master.PotP_PersistentStorage.pWorldStorage.inititalise(master);
		PotP_Logger("New world storage instance created.", , 'PotP Storage');
	}
	else 
	{
		if (force_refresh == 'All' || force_refresh == 'World'|| PotP_ModAddedOrRemoved('World'))
		{
			master.PotP_PersistentStorage.pWorldStorage.inititalise(master);
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
		master.PotP_PersistentStorage.pItemsStorage = new CProgressOnThePath_ItemsStorage in master.PotP_PersistentStorage;
		master.PotP_PersistentStorage.pItemsStorage.inititalise(master);
		PotP_Logger("New items storage instance created.", , 'PotP Storage');
	}
	else 
	{
		if (force_refresh == 'All' || force_refresh == 'Items'|| PotP_ModAddedOrRemoved('Items'))
		{
			master.PotP_PersistentStorage.pItemsStorage.inititalise(master);
			PotP_Logger("Existing items storage instance rebuilt with a size of: " + master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(), , 'PotP Storage');
		}
		else
		{
			PotP_Logger("Existing items storage instance loaded with a size of: " + master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(), , 'PotP Storage');
		}
	}

//---------------------------------------------------
	
	PotP_ApplyDLCFacts();
}

function PotP_ApplyDLCFacts() : void
{
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
}

function PotP_ModAddedOrRemoved(section : name) : bool
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

