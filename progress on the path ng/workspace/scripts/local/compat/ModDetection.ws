//---------------------------------------------------
//-- Mod Detection ----------------------------------
//---------------------------------------------------
// Supported mods add content only when installed. Detection is by DLC name, or by
// a string id the mod ships when it has no DLC.

//https://www.nexusmods.com/witcher3/mods/11260 - Verified 09.10.26
function PotP_UsingBIA() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlcbia');
}

//https://www.nexusmods.com/witcher3/mods/11471 - Verified 09.10.26
function PotP_UsingExtraStashes() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_extrastashes');
}

//https://www.nexusmods.com/witcher3/mods/7202 - Verified 09.10.26
function PotP_UsingFastTravelPack() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_fasttravel');
}

//https://www.nexusmods.com/witcher3/mods/13373 - Verified 09.10.26
function PotP_UsingCosWiecej() : bool
{
	return StrLen(GetLocStringById(2115152003)) > 0;
}

//https://www.nexusmods.com/witcher3/mods/14573 - Verified 07.11.26
function PotP_UsingSezonBurz() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_sezonburz');
}

//https://www.nexusmods.com/witcher3/mods/7858 - Verified 09.10.26
function PotP_UsingCutThroatRazor() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_razormax');
}

//https://www.nexusmods.com/witcher3/mods/7355 - Verified 09.10.26
function PotP_UsingUnsinkable() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_unsinkable');
}

//https://www.nexusmods.com/witcher3/mods/7028 - Verified 09.10.26
function PotP_UsingWeatherArtifact() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_weathermachine');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_Hearts() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_cardshos');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_Masque() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_cardsparty');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_Friends() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_partymingling');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_Conscience() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_treasurepang');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_UngratefulMage() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_moritz');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_SoundOfSilence() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_hornwallhorn');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_SecretGarden() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_palacegardens');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_ViperSet() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_vipercollection');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_BombCollector() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_bombcollector');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_OilTycoon() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_oiltycoon');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_PotionCollector() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_potioncollector');
}

//https://www.nexusmods.com/witcher3/mods/12991 - Verified 09.10.26
function PotP_UsingW3QE_DecoctionCollector() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_decoctioncollector');
}

function PotP_UsingShadesOfIron() : bool
{
	return StrLen(GetLocStringById(2115051416)) > 0;
}

//https://www.nexusmods.com/witcher3/mods/9453
function PotP_UsingAWitcherCanHideAnother() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlcngcl');
}

//https://www.nexusmods.com/witcher3/mods/5802
function PotP_UsingW3EE() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('reduxw3ee_dlc');
}

//https://www.nexusmods.com/witcher3/mods/3983
function PotP_UsingDLCArmorQuests() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc__dlcarmorquests');
}

//https://www.nexusmods.com/witcher3/mods/4670
function PotP_UsingANightToRemember() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_ntr');
}

//https://www.nexusmods.com/witcher3/mods/5178
function PotP_UsingThreeLittleSisters() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_threesisters');
}

//https://www.nexusmods.com/witcher3/mods/12476 (Missable Quest Tracking by relapse12)
function PotP_UsingMissableQuestTracking() : bool
{
	return StrLen(GetLocStringById(1124761000)) > 0;
}

//https://www.nexusmods.com/witcher3/mods/4585
function PotP_UsingCiriSoleMemento() : bool
{
	return theGame.GetDLCManager().IsDLCAvailable('dlc_solememento');
}

// The Essential Weapon Rework (modEssentialWeaponRework): its own string for Eredin's sword
function PotP_UsingEssentialWeaponRework() : bool
{
	return StrLen(GetLocStringById(2115104001)) > 0;
}
