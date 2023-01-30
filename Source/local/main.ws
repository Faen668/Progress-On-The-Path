//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath extends SU_BaseBootstrappedMod {
	
	public var fileName: name;
		default fileName = 'PotP Main';
		
	public saved var PotP_PersistentStorage: CProgressOnThePath_Storage;
	
	public var PotP_UpdaterClass:		CProgressOnThePath_UpdaterClass;
	public var PotP_ArrayManager: 		CProgressOnThePath_ArrayHandler;
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

	public var PotP_QuestBook: 			CProgressOnTheBath_QuestPreviewBook;
	public var PotP_WorldBook: 			CProgressOnTheBath_WorldPreviewBook;
	public var PotP_ItemsBook: 			CProgressOnTheBath_ItemsPreviewBook;
	public var PotP_MissaBook: 			CProgressOnTheBath_MissaPreviewBook;
	public var PotP_GwentBook: 			CProgressOnTheBath_GwentPreviewBook;
		
	public var LastUpdateTime: float;
		default LastUpdateTime = 0;
		
	default tag = 'CProgressOnThePath_BootStrapper';

	//---------------------------------------------------
	
	public function start() 
	{			
		PotP_Logger("Bootstrapped successfully with Magic, prayers and wishful thinking...", , this.fileName);
		
		this.LoadStorage();
		
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
		PotP_ArrayManager = new CProgressOnThePath_ArrayHandler in this;
		PotP_Notifications = new CProgressOnThePath_Notifications in this;
		PotP_PinManager = new CProgressOnThePath_MapPins in this;
		PotP_EventListener = new CProgressOnThePath_EventListener in this;
		PotP_MeditationListener = new CProgressOnThePath_MeditationListener in this;

		PotP_QuestBook = new CProgressOnTheBath_QuestPreviewBook in this;
		PotP_WorldBook = new CProgressOnTheBath_WorldPreviewBook in this;
		PotP_ItemsBook = new CProgressOnTheBath_ItemsPreviewBook in this;
		PotP_MissaBook = new CProgressOnTheBath_MissaPreviewBook in this;
		PotP_GwentBook = new CProgressOnTheBath_GwentPreviewBook in this;
		
		this.GotoState('Initialising');
	}	

	//---------------------------------------------------

	private function LoadStorage() 
	{ 
		if (!this.PotP_PersistentStorage)
		{
			this.PotP_PersistentStorage = new CProgressOnThePath_Storage in this;
			PotP_Logger("Progress On The Path: New storage instance created.", , this.fileName);
		}
		else
		{
			PotP_Logger("Progress On The Path: Loading Saved Storage [MasterList_Completed_V] with a size of [" + this.PotP_PersistentStorage.MasterList_Completed_V.Size() + "]", , this.fileName);
			PotP_Logger("Progress On The Path: Loading Saved Storage [MasterList_InProgres_V] with a size of [" + this.PotP_PersistentStorage.MasterList_InProgres_V.Size() + "]", , this.fileName);
			PotP_Logger("Progress On The Path: Loading Saved Storage [MasterList_IsIgnored_V] with a size of [" + this.PotP_PersistentStorage.MasterList_IsIgnored_V.Size() + "]", , this.fileName);
			PotP_Logger("Progress On The Path: Loading Saved Storage [MasterList_Collected_V] with a size of [" + this.PotP_PersistentStorage.MasterList_Collected_V.Size() + "]", , this.fileName);
			PotP_Logger("Progress On The Path: Loading Saved Storage [MasterList_Pl_Messages] with a size of [" + this.PotP_PersistentStorage.MasterList_Pl_Messages.Size() + "]", , this.fileName);
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
		default curVersionStr = "5.1.0";
		
	private var curVersionInt: int;
		default curVersionInt = 510;
	
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
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}

		parent.PotP_ArrayManager		.initialise(parent);
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

		parent.PotP_QuestBook			.initialise(parent);
		parent.PotP_WorldBook			.initialise(parent);
		parent.PotP_ItemsBook			.initialise(parent);
		parent.PotP_MissaBook			.initialise(parent);
		parent.PotP_GwentBook			.initialise(parent);
			
		this.SetModVersion();
		this.AddGlosssaryEntries();

		parent.PotP_PinManager.GotoState('Idle');
		parent.PotP_WorldGoblin.GotoState('Idle');
		parent.PotP_EventListener.GotoState('Idle');
		parent.PotP_MeditationListener.GotoState('Idle');
		
		//GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Ready To Use");
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
			if (FactsQuerySum(VersStr) < 510) { FactsSet(VersStr, 510); hasUpdated = true; }
		}
	}
	
	//---------------------------------------------------
	
	latent function AddGlosssaryEntries() 
	{
		var TutorialBook1: ProgressOnTheBath_TutorialBook1;
		var TutorialBook2: ProgressOnTheBath_TutorialBook2;
		var TutorialBook3: ProgressOnTheBath_TutorialBook3;
		var TutorialBook4: ProgressOnTheBath_TutorialBook4;
		var TutorialBook5: ProgressOnTheBath_TutorialBook5;
		var TutorialBook6: ProgressOnTheBath_TutorialBook6;
		var TutorialBook7: ProgressOnTheBath_TutorialBook7;

		TutorialBook1 = new ProgressOnTheBath_TutorialBook1 in thePlayer;
		TutorialBook2 = new ProgressOnTheBath_TutorialBook2 in thePlayer;
		TutorialBook3 = new ProgressOnTheBath_TutorialBook3 in thePlayer;
		TutorialBook4 = new ProgressOnTheBath_TutorialBook4 in thePlayer;
		TutorialBook5 = new ProgressOnTheBath_TutorialBook5 in thePlayer;
		TutorialBook6 = new ProgressOnTheBath_TutorialBook6 in thePlayer;
		TutorialBook7 = new ProgressOnTheBath_TutorialBook7 in thePlayer;
		
		parent.PotP_QuestBook.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		parent.PotP_WorldBook.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		parent.PotP_ItemsBook.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		parent.PotP_MissaBook.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		parent.PotP_GwentBook.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		
		TutorialBook1.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook2.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook3.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook4.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook5.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook6.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		TutorialBook7.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		
		parent.PotP_QuestBook.drop_down_tag = 'ProgressOnThePath_Previews';
		parent.PotP_WorldBook.drop_down_tag = 'ProgressOnThePath_Previews';
		parent.PotP_ItemsBook.drop_down_tag = 'ProgressOnThePath_Previews';
		parent.PotP_MissaBook.drop_down_tag = 'ProgressOnThePath_Previews';
		parent.PotP_GwentBook.drop_down_tag = 'ProgressOnThePath_Previews';

		TutorialBook1.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook2.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook3.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook4.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook5.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook6.drop_down_tag = 'ProgressOnThePath_Tutorials';
		TutorialBook7.drop_down_tag = 'ProgressOnThePath_Tutorials';
		
		parent.PotP_QuestBook.title = GetLocStringByKeyExt("PotP_PreviewBook_Quest_Name");
		parent.PotP_WorldBook.title = GetLocStringByKeyExt("PotP_PreviewBook_World_Name");
		parent.PotP_ItemsBook.title = GetLocStringByKeyExt("PotP_PreviewBook_Items_Name");
		parent.PotP_MissaBook.title = GetLocStringByKeyExt("PotP_PreviewBook_Missa_Name");
		parent.PotP_GwentBook.title = GetLocStringByKeyExt("PotP_PreviewBook_Gwent_Name");

		TutorialBook1.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook1_Name");
		TutorialBook2.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook2_Name");
		TutorialBook3.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook3_Name");
		TutorialBook4.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook4_Name");
		TutorialBook5.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook5_Name");
		TutorialBook6.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook6_Name");
		TutorialBook7.title = GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook7_Name");
		
		parent.PotP_QuestBook.icon_path = "icons/PotP/qp.png";
		parent.PotP_WorldBook.icon_path = "icons/PotP/map.png";
		parent.PotP_GwentBook.icon_path = "icons/PotP/gwint_north.png";
		parent.PotP_ItemsBook.icon_path = "icons/PotP/collect.png";
		parent.PotP_MissaBook.icon_path = "icons/PotP/qp_miss.png";
		
		TutorialBook1.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook2.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook3.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook4.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook5.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook6.icon_path = "icons/PotP/qp_alt.png";
		TutorialBook7.icon_path = "icons/PotP/qp_alt.png";
		
		parent.PotP_QuestBook.sort_index = 30005;
		parent.PotP_WorldBook.sort_index = 30004;
		parent.PotP_ItemsBook.sort_index = 30003;
		parent.PotP_GwentBook.sort_index = 30002;
		parent.PotP_MissaBook.sort_index = 30001;
		
		TutorialBook1.sort_index = 30010;
		TutorialBook2.sort_index = 30011;
		TutorialBook3.sort_index = 30012;
		TutorialBook4.sort_index = 30013;
		TutorialBook5.sort_index = 30014;
		TutorialBook6.sort_index = 30015;
		TutorialBook7.sort_index = 30016;
		
		SU_addGlossaryEntry(parent.PotP_QuestBook);
		SU_addGlossaryEntry(parent.PotP_WorldBook);
		SU_addGlossaryEntry(parent.PotP_ItemsBook);
		SU_addGlossaryEntry(parent.PotP_MissaBook);
		SU_addGlossaryEntry(parent.PotP_GwentBook);
		
		SU_addGlossaryEntry(TutorialBook1);
		SU_addGlossaryEntry(TutorialBook2);
		SU_addGlossaryEntry(TutorialBook3);
		SU_addGlossaryEntry(TutorialBook4);
		SU_addGlossaryEntry(TutorialBook5);
		SU_addGlossaryEntry(TutorialBook6);
		SU_addGlossaryEntry(TutorialBook7);
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

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------