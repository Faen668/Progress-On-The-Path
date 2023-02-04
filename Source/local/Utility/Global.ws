//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsUsingNextGen() : bool 
{
	return !StrStartsWith(theGame.GetApplicationVersion(), "v 3");
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP(out master: CProgressOnThePath, optional caller: string): bool 
{
	PotP_Logger("GetPotP Called by [" + caller + "]");
	master = (CProgressOnThePath)SUTB_getModByTag('CProgressOnThePath_BootStrapper');
	
	if (master)
	{
		return true;
	}
	return false;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_QuestGoblin(optional caller: string): CProgressOnThePath_QuestGoblin 
{
	var master: CProgressOnThePath;
	
	if (!GetPotP(master, caller)) 
	{ 
		return NULL; 
	}
	
	return master.PotP_QuestGoblin;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsPlayerBusy(): bool 
{
	if (PotP_PlayerIsMeditating()) 
	{
		return false;
	}
	
	return thePlayer.IsInNonGameplayCutscene()
		|| theGame.IsLoadingScreenVideoPlaying()
		|| thePlayer.IsInGameplayScene()
		|| (!thePlayer.IsActionAllowed(EIAB_DrawWeapon) && theGame.GetCommonMapManager().GetCurrentArea() != AN_Wyzima)
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
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_PlayerIsMeditating() : bool 
{
	return thePlayer.GetCurrentStateName() == 'Meditation' || thePlayer.GetCurrentStateName() == 'W3EEMeditation';
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_Logger(message: string, optional ShowInGUI: bool, optional filename: name) 
{	
	/*Comment The Line Out On Release Version */ if ( StrContains(message, "Entered state") ) { return; }
	
	if (filename == '') 
	{
		filename = 'PotP';
	}
	
	LogChannel(filename, message);
  
	if (ShowInGUI)
	{
		GetWitcherPlayer().DisplayHudMessage(NameToString(filename) + ": " + message);
	}
}

