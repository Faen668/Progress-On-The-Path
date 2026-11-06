//---------------------------------------------------
//-- Utilities --------------------------------------
//---------------------------------------------------

function PotP_Get() : CPotP_Main
{
	return thePlayer.potp_main;
}

//---------------------------------------------------

function PotP_Log(message: string, optional channel: name)
{
	if (channel == '')
	{
		channel = 'PotP';
	}
	LogChannel(channel, message);
}

//---------------------------------------------------

function PotP_IsUsingNextGen() : bool
{
	return !StrStartsWith(theGame.GetApplicationVersion(), "v 3");
}

//---------------------------------------------------

function PotP_PlayerIsMeditating() : bool
{
	var state_name : name = thePlayer.GetCurrentStateName();

	return state_name == 'Meditation' || state_name == 'W3EEMeditation';
}

//---------------------------------------------------

// A scene, a fade or a fight. Building the list and its first pass only wait for these.
function PotP_IsInSceneOrFight() : bool
{
	if (PotP_PlayerIsMeditating())
	{
		return false;
	}

	return thePlayer.IsInNonGameplayCutscene()
		|| theGame.IsLoadingScreenVideoPlaying()
		|| thePlayer.IsInGameplayScene()
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

// Too busy to be interrupted by a message. Places that block weapons, like the Vegelbud ball, count as busy too.
function PotP_IsPlayerBusy() : bool
{
	if (PotP_IsInSceneOrFight())
	{
		return true;
	}
	if (PotP_PlayerIsMeditating())
	{
		return false;
	}

	return !thePlayer.IsActionAllowed(EIAB_DrawWeapon) && theGame.GetCommonMapManager().GetCurrentArea() != 'AN_Wyzima';
}

//---------------------------------------------------

function PotP_IsMenuOpen() : bool
{
	return theGame.GetGuiManager().IsAnyMenu();
}

//---------------------------------------------------

function PotP_LocOrDefault(loc_key: string, fallback_text: string) : string
{
	var text_value : string = GetLocStringByKeyExt(loc_key);

	if (text_value == "" || StrStartsWith(text_value, "#"))
	{
		return fallback_text;
	}
	return text_value;
}

//---------------------------------------------------

function PotP_CleanTitle(raw_title: string) : string
{
	var title : string = raw_title;

	title = StrReplaceAll(title, "<br>", " ");
	title = StrReplaceAll(title, "<BR>", " ");
	title = StrReplaceAll(title, "<br/>", " ");
	title = StrReplaceAll(title, "<BR/>", " ");
	title = StrReplaceAll(title, "<br />", " ");
	title = StrReplaceAll(title, "<BR />", " ");
	title = StrReplaceAll(title, "\r\n", " ");
	title = StrReplaceAll(title, "\n", " ");
	title = StrReplaceAll(title, "\r", " ");

	while (StrFindFirst(title, "  ") != -1)
	{
		title = StrReplaceAll(title, "  ", " ");
	}
	return title;
}

//---------------------------------------------------

function PotP_SanitizeUuid(raw_text: string) : string
{
	var text_value : string = raw_text;

	text_value = StrReplaceAll(text_value, "\t", "_");
	text_value = StrReplaceAll(text_value, "\r\n", " ");
	text_value = StrReplaceAll(text_value, "\n", " ");
	text_value = StrReplaceAll(text_value, "\r", " ");

	text_value = StrReplaceAll(text_value, "'", "");
	text_value = StrReplaceAll(text_value, "`", "");
	text_value = StrReplaceAll(text_value, "‘", "");
	text_value = StrReplaceAll(text_value, "’", "");
	text_value = StrReplaceAll(text_value, "“", "");
	text_value = StrReplaceAll(text_value, "”", "");

	text_value = StrReplaceAll(text_value, "-", "_");
	text_value = StrReplaceAll(text_value, "–", "_");
	text_value = StrReplaceAll(text_value, "—", "_");

	text_value = StrReplaceAll(text_value, ".", "_");
	text_value = StrReplaceAll(text_value, ",", "_");
	text_value = StrReplaceAll(text_value, ":", "_");
	text_value = StrReplaceAll(text_value, ";", "_");
	text_value = StrReplaceAll(text_value, "/", "_");
	text_value = StrReplaceAll(text_value, "\\", "_");
	text_value = StrReplaceAll(text_value, "(", "_");
	text_value = StrReplaceAll(text_value, ")", "_");
	text_value = StrReplaceAll(text_value, "[", "_");
	text_value = StrReplaceAll(text_value, "]", "_");
	text_value = StrReplaceAll(text_value, "<", "_");
	text_value = StrReplaceAll(text_value, ">", "_");
	text_value = StrReplaceAll(text_value, "!", "_");
	text_value = StrReplaceAll(text_value, "?", "_");
	text_value = StrReplaceAll(text_value, "&", "_");
	text_value = StrReplaceAll(text_value, "+", "_");
	text_value = StrReplaceAll(text_value, "=", "_");
	text_value = StrReplaceAll(text_value, "*", "_");
	text_value = StrReplaceAll(text_value, "%", "_");
	text_value = StrReplaceAll(text_value, "#", "_");
	text_value = StrReplaceAll(text_value, "@", "_");
	text_value = StrReplaceAll(text_value, "$", "_");
	text_value = StrReplaceAll(text_value, "|", "_");
	text_value = StrReplaceAll(text_value, "~", "_");
	text_value = StrReplaceAll(text_value, "^", "_");
	text_value = StrReplaceAll(text_value, "{", "_");
	text_value = StrReplaceAll(text_value, "}", "_");

	while (StrFindFirst(text_value, "  ") != -1)
	{
		text_value = StrReplaceAll(text_value, "  ", " ");
	}
	text_value = StrReplaceAll(text_value, " ", "_");

	while (StrFindFirst(text_value, "__") != -1)
	{
		text_value = StrReplaceAll(text_value, "__", "_");
	}
	return text_value;
}
