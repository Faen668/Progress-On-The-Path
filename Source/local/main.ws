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
		var newModVersion_Str: string = "5.2.8.2";
		var newModVersion_Int: int = 5282;

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
			if (FactsQuerySum(VersStr) < 5282) { 
				PotP_PersistentStorage.PotP_LoadStorageCollection('Quest'); 
				PotP_PersistentStorage.PotP_LoadStorageCollection('World');
				FactsSet(VersStr, 5282);
			}
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

