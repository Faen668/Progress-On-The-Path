//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingShadesOfIron() : bool 
{
	return StrLen(GetLocStringById(2115051416)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingGwentRedux() : bool 
{
	return StrLen(GetLocStringById(2114287601)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingW3EE() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingVladimirUI() : bool
{
	return StrLen(GetLocStringById(2112698555)) > 0;
}
		
//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingFriendlyMeditation() : bool
{
	return StrLen(GetLocStringById(2112067001)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingDLCFastTravel() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_fasttravel');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingSezonBurz() : bool 
{
	return StrLen(GetLocStringById(2112771001)) > 0;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingCosWiecej() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_wiecej');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingDLCArmorQuests() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc__dlcarmorquests');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingThreeLittleSisters() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_threesisters');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingCiriSoleMemento() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_solememento');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingANightToRemember() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_ntr');
}

