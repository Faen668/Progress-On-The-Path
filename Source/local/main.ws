//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath {
	
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

	public var LastUpdateTime: float;
		default LastUpdateTime = 0;

	public var LastSwitchTime: float;
		default LastSwitchTime = 0;
		
	public var has_updated: bool;
		default has_updated = false;
	
	public var current_version_string: string;
		default current_version_string = "6.0.1.4";

	public var current_version_int: int;
		default current_version_int = 6014;
		
	//---------------------------------------------------
	
	public function EvaluateOptionsOnMenuClose()
	{
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_ResetForNGPlus') ) {
			theGame.GetInGameConfigWrapper().SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_ResetForNGPlus', "false");
			reset_for_ng_plus();
		}
	}
	
	public function reset_for_ng_plus()
	{
		PotP_PersistentStorage.pEventStorage.ClearFacts();
		PotP_PersistentStorage.pItemsStorage.ClearFacts();
		PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_NewGamePlus);
		PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_NewGamePlusMessage"), "", "Hint", false);
	}
	
	public function start() 
	{
		var initStr: string = "PotP_Initialised";
		var VersStr: string = "ProgressOnThePath_CurrentModVersion";
		
		PotP_Logger("Bootstrapped successfully with Magic, prayers and wishful thinking...", , this.fileName);
		
		if (!FactsDoesExist("q001_nightmare_ended")) 
		{
			PotP_Logger("Waiting For State Release...", , this.fileName);
			GotoState('waiting');
			return;
		}

		theInput.RegisterListener(this, 'UpdateProgressOnThePath', 'UpdateProgressOnThePath');
		theInput.RegisterListener(this, 'DisplayProgressPreview', 'DisplayProgressPreview');
		theInput.RegisterListener(this, 'SwitchProgressPreview', 'SwitchProgressPreview');
		
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
		
		if (!PotP_PersistentStorage) 
		{
			PotP_PersistentStorage = new CProgressOnThePath_Storage in this;
			PotP_Logger("New storage instance created.", , 'PotP Storage');
		}

		//Mod is not initialised
		if (FactsQuerySum(initStr) != 1) 
		{
			FactsSet(initStr, 1);
			FactsSet(VersStr, current_version_int);
			this.LoadDefaults();
			
			PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_None);
			PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_InstallMessage"), "PotP_InstallMessage", "Hint", true);
		}
		else
		{
			if (FactsQuerySum(VersStr) < current_version_int) 
			{
				has_updated = true;
				
				if (FactsQuerySum(VersStr) < 527) 
				{
					FactsSet(VersStr, 527);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_All); 
				}
				
				if (FactsQuerySum(VersStr) < 5281) 
				{ 
					FactsSet(VersStr, 5281);
				}
				
				if (FactsQuerySum(VersStr) < 5282) 
				{ 
					FactsSet(VersStr, 5282);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_QuestAndWorld); 
				}
				
				if (FactsQuerySum(VersStr) < 6006) 
				{
					FactsSet(VersStr, 6006);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_QuestAndEvent);
				}

				if (FactsQuerySum(VersStr) < 6008) 
				{
					FactsSet(VersStr, 6008);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_Quest);
				}
				
				if (FactsQuerySum(VersStr) < 6013) 
				{
					FactsSet(VersStr, 6013);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_QuestAndItems);
				}
				
				if (FactsQuerySum(VersStr) < 6014) 
				{
					FactsSet(VersStr, 6014);
					PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_WorldAndItems);
				}
			}
			else
			{
				PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_None);
			}
		}
	}	
	
	//---------------------------------------------------
	
	public function finish_init()
	{
		PotP_UpdaterClass		.initialise(this);
		PotP_PinManager			.initialise(this);
		PotP_QuestPreview		.initialise(this);
		PotP_WorldPreview		.initialise(this);
		PotP_ItemsPreview		.initialise(this);
		PotP_GwentPreview		.initialise(this);
		PotP_MissablePreview	.initialise(this);
		PotP_Notifications		.initialise(this);
		PotP_ItemsGoblin		.initialise(this);
		PotP_QuestGoblin		.initialise(this);
		PotP_WorldGoblin		.initialise(this);
		PotP_EventListener		.initialise(this);
		PotP_MeditationListener	.initialise(this);
		PotP_PopupManager		.initialise(this);
		PotP_EntityHelper		.initialise(this);
		
		(new ProgressOnTheBath_TutorialBook1 in this).addBook();
		(new ProgressOnTheBath_TutorialBook2 in this).addBook();
		(new ProgressOnTheBath_TutorialBook3 in this).addBook();
		(new ProgressOnTheBath_TutorialBook4 in this).addBook();
		(new ProgressOnTheBath_TutorialBook5 in this).addBook();
		(new ProgressOnTheBath_TutorialBook6 in this).addBook();
		(new ProgressOnTheBath_TutorialBook7 in this).addBook();
		
		(new CProgressOnTheBath_QuestPreviewBook in this).addBook(this);
		(new CProgressOnTheBath_WorldPreviewBook in this).addBook(this);
		(new CProgressOnTheBath_ItemsPreviewBook in this).addBook(this);
		(new CProgressOnTheBath_MissaPreviewBook in this).addBook(this);
		(new CProgressOnTheBath_GwentPreviewBook in this).addBook(this);
		
		PotP_PinManager.GotoState('Idle');
		PotP_ItemsGoblin.GotoState('Idle');
		PotP_WorldGoblin.GotoState('Idle');
		PotP_EventListener.GotoState('Idle');
		PotP_MeditationListener.GotoState('Idle');
		
		if (has_updated)
		{
			has_updated = false;
			PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_UpdatedMessage") + current_version_string, "", "Hint", false);
		}
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

	public function SwitchProgressPreview(action : SInputAction) 
	{ 
		var VarManager	: CInGameConfigWrapper;
		var currentOpt 	: int;

		if ((theGame.GetEngineTimeAsSeconds() - LastSwitchTime) > 0.5) 
		{
			LastSwitchTime = theGame.GetEngineTimeAsSeconds();
			
			VarManager = theGame.GetInGameConfigWrapper();
			currentOpt = StringToInt(VarManager.GetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview')) + 1;

			if (currentOpt > 4)
				currentOpt = 0;
			
			VarManager.SetVarValue('ProgressOnThePath_PreviewSettings', 'ProgressOnThePath_Preview', IntToString(currentOpt));
			PotP_Notifications.DisplaySwitchStatus(currentOpt);
		}
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
//-- States -----------------------------------------
//---------------------------------------------------

state waiting in CProgressOnThePath
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [waiting]", , parent.fileName);
		wait_for_release();
	}
	
	entry function wait_for_release()
	{
		while (!FactsDoesExist("q001_nightmare_ended")) 
		{
			PotP_Logger("Waiting For State Release...", , parent.fileName);
			Sleep(5);
		}
		parent.GotoState('running');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state running in CProgressOnThePath
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [running]", , parent.fileName);
		start_mod();
	}
	
	entry function start_mod()
	{
		PotP_Logger("Starting PotP...", , parent.fileName);
		parent.start();	
	}
}