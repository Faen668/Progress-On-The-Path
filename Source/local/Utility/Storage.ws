//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
class CProgressOnThePath_Storage
{	
	var MasterList_Completed_V: array<string>;
	var MasterList_InProgres_V: array<string>;
	var MasterList_IsIgnored_V: array<string>;
	var MasterList_Collected_V: array<string>;
	var MasterList_Pl_Messages: array<PotP_PlayerNotification>;
	var MasterList_ItemsGoblin: array<SItemUniqueId>;
	var MasterList_QuestGoblin: array<CJournalQuest>;
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

