//---------------------------------------------------
//-- Settings ---------------------------------------
//---------------------------------------------------

function PotP_GetGeneralValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_GeneralSettings', variable);
}

function PotP_GetNotificationValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_NotificationSettings', variable);
}

//---------------------------------------------------

function PotP_GeneralFlag(variable: name) : bool
{
	return (bool) PotP_GetGeneralValue(variable);
}

function PotP_NotificationFlag(variable: name) : bool
{
	return (bool) PotP_GetNotificationValue(variable);
}

//---------------------------------------------------

function PotP_MissableNotificationsOn() : bool
{
	return PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Missable') != "false";
}

//---------------------------------------------------

function PotP_TrackerNotesOn() : bool
{
	return PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Tracker') != "false";
}

//---------------------------------------------------

function PotP_LoadDefaultSettings()
{
	PotP_LoadGeneralDefaults();
	PotP_LoadNotificationDefaults();
}

//---------------------------------------------------

function PotP_LoadGeneralDefaults()
{
	var config : CInGameConfigWrapper = theGame.GetInGameConfigWrapper();

	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_MeditationUpdate',					"true");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EnableHotKey',						"true");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_ShowCollectabilityTooltips',		"true");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_ResetForNGPlus',					"false");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ShowMapPins',			"true");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinDescription',	"true");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinRadius',			"30");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_MapPinType',			"1");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ShowMiniMap',			"false");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_ArrowPointers',		"false");
	config.SetVarValue('ProgressOnThePath_GeneralSettings', 'ProgressOnThePath_EventMapPins_HighlightedPointers',	"false");
}

//---------------------------------------------------

function PotP_LoadNotificationDefaults()
{
	var config : CInGameConfigWrapper = theGame.GetInGameConfigWrapper();

	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_ShowUpdateNotifications',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Time',	"7");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Size',	"18");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_GlobalNotification_Font',	"1");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Quest',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_World',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Items',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Gwent',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Event',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_FullNotification_Nulls',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Quest',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_World',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Items',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Gwent',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_BackNotification_Event',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Event',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Enter',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Missable',	"true");
	config.SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_MiscNotification_Tracker',	"true");
}
