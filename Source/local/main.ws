//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath extends SU_BaseBootstrappedMod {
	
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
		
	public var LastUpdateTime: float;
		default LastUpdateTime = 0;
		
	default tag = 'CProgressOnThePath_BootStrapper';

	//---------------------------------------------------
	
	public function start() 
	{			
		PotP_Logger("Bootstrapped successfully with Magic, prayers and wishful thinking...", , this.fileName);
		
		theInput.RegisterListener(this, 'UpdateProgressOnThePath', 'UpdateProgressOnThePath');
		theInput.RegisterListener(this, 'DisplayProgressPreview', 'DisplayProgressPreview');
		
		PotP_UpdaterClass = new	CProgressOnThePath_UpdaterClass in this;
		PotP_PopupManager = new CProgressOnThePath_TutorialPopup in this;

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
		
		this.GotoState('Initialising');
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
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_EnableHotKey') && this.IsInState('Idle') )
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
//-- Tracker Idle State -----------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Tracker Idle State -----------------------------
//---------------------------------------------------

state Initialising in CProgressOnThePath 
{
	private var curVersionStr: string;
		default curVersionStr = "5.2.7";
		
	private var curVersionInt: int;
		default curVersionInt = 527;
	
	private var hasUpdated: bool;
		default hasUpdated = false;
	
	private var initStr: string;
		default initStr = "PotP_Initialised";
		
	private var VersStr: string;
		default VersStr = "ProgressOnThePath_CurrentModVersion";

//---------------------------------------------------
		
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Initialising]", , parent.fileName);
		
		this.Initialising_Main();
	}

//---------------------------------------------------
	
	entry function Initialising_Main() 
	{		
		while (theGame.IsLoadingScreenVideoPlaying()) 
		{
		  Sleep(1);
		}
		
		PotP_Logger("Loading Screen Finished", , parent.fileName);
		
		while ( PotP_IsPlayerBusy() ) 
		{
			Sleep(0.5);
		}
		
		PotP_Logger("Player is no longer busy", , parent.fileName);
		
		Sleep(0.5);
		
		PotP_LoadStorageCollection(parent);

		parent.PotP_UpdaterClass		.initialise(parent);
		parent.PotP_PinManager			.initialise(parent);
		parent.PotP_QuestPreview		.initialise(parent);
		parent.PotP_WorldPreview		.initialise(parent);
		parent.PotP_ItemsPreview		.initialise(parent);
		parent.PotP_GwentPreview		.initialise(parent);
		parent.PotP_MissablePreview		.initialise(parent);
		parent.PotP_Notifications		.initialise(parent);
		parent.PotP_ItemsGoblin			.initialise(parent);
		parent.PotP_QuestGoblin			.initialise(parent);
		parent.PotP_WorldGoblin			.initialise(parent);
		parent.PotP_EventListener		.initialise(parent);
		parent.PotP_MeditationListener	.initialise(parent);
		
		parent.PotP_PopupManager		.initialise(parent);
			
		this.SetModVersion();
		
		(new ProgressOnTheBath_TutorialBook1 in this).addBook();
		(new ProgressOnTheBath_TutorialBook2 in this).addBook();
		(new ProgressOnTheBath_TutorialBook3 in this).addBook();
		(new ProgressOnTheBath_TutorialBook4 in this).addBook();
		(new ProgressOnTheBath_TutorialBook5 in this).addBook();
		(new ProgressOnTheBath_TutorialBook6 in this).addBook();
		(new ProgressOnTheBath_TutorialBook7 in this).addBook();
		
		(new CProgressOnTheBath_QuestPreviewBook in this).addBook(parent);
		(new CProgressOnTheBath_WorldPreviewBook in this).addBook(parent);
		(new CProgressOnTheBath_ItemsPreviewBook in this).addBook(parent);
		(new CProgressOnTheBath_MissaPreviewBook in this).addBook(parent);
		(new CProgressOnTheBath_GwentPreviewBook in this).addBook(parent);

		parent.PotP_PinManager.GotoState('Idle');
		parent.PotP_WorldGoblin.GotoState('Idle');
		parent.PotP_EventListener.GotoState('Idle');
		parent.PotP_MeditationListener.GotoState('Idle');
		parent.GotoState('Idle');
	}
	
	//---------------------------------------------------

	latent function SetModVersion() 
	{		
		if (FactsQuerySum(initStr) != 1) 
		{
			this.LoadDefaults();
			FactsSet(initStr, 1);
			FactsSet(VersStr, curVersionInt);

			parent.PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_InstallMessage"), "PotP_InstallMessage", "Hint", true);
			return;
		}

		this.UpdateMod();	
		
		if (hasUpdated) 
		{
			parent.PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), GetLocStringByKeyExt("PotP_UpdatedMessage") + curVersionStr, "", "Hint", false);
		}
	}
	
	//---------------------------------------------------
	
	latent function UpdateMod() 
	{
		if (FactsQuerySum(VersStr) < curVersionInt) 
		{
			if (FactsQuerySum(VersStr) < 527) { PotP_LoadStorageCollection(parent, 'All'); FactsSet(VersStr, 527); hasUpdated = true; }
		}
	}
	
	//---------------------------------------------------
	
	latent function LoadDefaults() 
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
}

