//---------------------------------------------------
//-- Functions -------------------------------------- W3QE
//---------------------------------------------------

function PotP_UsingW3QE_Hearts() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_cardshos');
}

function PotP_UsingW3QE_Masque() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_cardsparty');
}

function PotP_UsingW3QE_Friends() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_partymingling');
}

function PotP_UsingW3QE_Conscience() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_treasurepang');
}

function PotP_UsingW3QE_UngratefulMage() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_moritz');
}

function PotP_UsingW3QE_SoundOfSilence() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_hornwallhorn');
}

function PotP_UsingW3QE_SecretGarden() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_palacegardens');
}

function PotP_UsingW3QE_ViperSet() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_vipercollection');
}

function PotP_UsingW3QE_BombCollector() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_bombcollector');
}

function PotP_UsingW3QE_OilTycoon() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_oiltycoon');
}

function PotP_UsingW3QE_PotionCollector() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_potioncollector');
}

function PotP_UsingW3QE_DecoctionCollector() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_decoctioncollector');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingEssentialWeaponRework() : bool 
{
	return StrLen(GetLocStringById(2115104003)) > 0;
}

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


function PotP_UsingExtraStashes() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_extrastashes');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingCutThroatRazor() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_razormax');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingUnsinkable() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_unsinkable');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingWeatherMachine() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_weathermachine');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingAWitcherCanHideAnother() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlcngcl');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingGwentRedux() : bool 
{
	return StrLen(GetLocStringById(2114287522)) > 0;
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

function PotP_UsingBIA() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlcbia');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_UsingANightToRemember() : bool 
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_ntr');
}

