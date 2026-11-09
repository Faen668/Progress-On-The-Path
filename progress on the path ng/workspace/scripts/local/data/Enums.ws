//---------------------------------------------------
//-- Enums ------------------------------------------
//---------------------------------------------------
// Values are persisted in user settings (filters) and used by the definition
// files, so existing numbers must never change.

enum PotP_Preview_CardOrigin
{
	PotP_G_Random		= 0,
	PotP_G_Velen		= 1,
	PotP_G_Novigrad		= 2,
	PotP_G_Skellige		= 3,
	PotP_G_WhiteOrchard	= 4,
	PotP_G_KaerMorhen	= 5,
	PotP_G_Vizima		= 6,
}

enum PotP_Preview_CardType
{
	PotP_G_None = 0,
	PotP_G_Lead = 1,
	PotP_G_Hero = 2,
	PotP_G_Unit = 3,
}

enum PotP_Preview_Region
{
	PotP_R_NA = 0, // All
	PotP_R_WO = 1, // White Orchard
	PotP_R_VE = 2, // Velen
	PotP_R_NO = 3, // Novigrad
	PotP_R_SK = 4, // Skellige
	PotP_R_TO = 5, // Toussaint
	PotP_R_KM = 6, // Kaer Morhen
	PotP_R_VI = 7, // Vizima
	PotP_R_TS = 8, // The Spiral
}

enum PotP_Preview_Array_Type
{
	PotP_A_Quest = 0,
	PotP_A_World = 1,
	PotP_A_Items = 2,
	PotP_A_Event = 3,
	PotP_A_Gwent = 4,
	PotP_A_Bestiary = 5,
	PotP_A_Library = 6,
}

enum PotP_Preview_Entry_Type
{
	PotP_E_Primary			= 0,
	PotP_E_Primary_DLC1		= 1,
	PotP_E_Primary_DLC2		= 2,
	PotP_E_Missable			= 3,
	PotP_E_Missable_DLC1	= 4,
	PotP_E_Missable_DLC2	= 5,
	PotP_E_ModAdded			= 6,
	PotP_E_ModAdded_DLC1	= 7,
	PotP_E_ModAdded_DLC2	= 8,
}

enum PotP_Preview_Items_Filter
{
	PotP_I_Relic	= 1,
	PotP_I_Gears	= 2,
	PotP_I_Troph	= 3,
	PotP_I_Gwent	= 4,
	PotP_I_Sezon	= 5,
	PotP_I_Shade	= 6,
	PotP_I_W3eer	= 7,
	PotP_I_Wiecej	= 8,
	PotP_I_Witch	= 9,	// witcher school gear
	PotP_I_Horse	= 10,	// named horse gear
}

enum PotP_Preview_Items_Underlying_Filter
{
	PotP_U_Armor	= 1,
	PotP_U_Boots	= 2,
	PotP_U_Pants	= 3,
	PotP_U_Glove	= 4,
	PotP_U_Head		= 5,
	PotP_U_Steel	= 6,
	PotP_U_Silve	= 7,
	PotP_U_Cross	= 8,
	PotP_U_Troph	= 9,
	PotP_U_Horse	= 10,
}

enum PotP_Preview_World_Filter
{
	PotP_I_Camps	= 1,
	PotP_I_MDens	= 2,
	PotP_I_Nests	= 3,
	PotP_I_Place	= 4,
	PotP_I_Signs	= 5,
	PotP_I_Sites	= 6,
	PotP_I_Guard	= 7,
	PotP_I_Distr	= 8,
	PotP_I_Knigh	= 9,
	PotP_I_Infes	= 10,
	PotP_I_Hanse	= 11,
	PotP_I_Stash	= 12,
	PotP_I_Cache	= 13,
	PotP_I_Spoil	= 14,
	PotP_I_Hiddn	= 15,
}

enum PotP_Preview_Quest_Filter
{
	PotP_I_Event	= 1,
	PotP_I_Mains	= 2,
	PotP_I_Sides	= 3,
	PotP_I_Conts	= 4,
	PotP_I_Scavs	= 5,
	PotP_I_Hunts	= 6,
}

enum PotP_Preview_Gwent_Underlying_Filter
{
	PotP_I_Monst	= 1,
	PotP_I_Nilfg	= 2,
	PotP_I_North	= 3,
	PotP_I_Scoia	= 5,
	PotP_I_Skell	= 6,
	PotP_I_Neutr	= 7,
}

//---------------------------------------------------

enum EPotP_Status
{
	PotP_S_Available	= 0,
	PotP_S_InProgress	= 1,
	PotP_S_Completed	= 2,
	PotP_S_Ignored		= 3,
	PotP_S_Missed		= 4,
}

enum EPotP_Book
{
	PotP_Book_Quest		= 0,
	PotP_Book_World		= 1,
	PotP_Book_Items		= 2,
	PotP_Book_Gwent		= 3,
	PotP_Book_Missable	= 4,
	PotP_Book_Bestiary	= 5,
	PotP_Book_Library	= 6,
}

enum EPotP_UpdateSource
{
	PotP_Src_Silent		= 0,
	PotP_Src_Full		= 1,
	PotP_Src_Background	= 2,
}

enum pStatus
{
	ignored		= 1,
	completed	= 2,
	missed		= 3,
}

//---------------------------------------------------

enum EPotP_MissableKind
{
	PotP_M_Cutoff	= 0,
	PotP_M_Choice	= 1,
	PotP_M_Failable	= 2,
}

enum EPotP_CutoffTrigger
{
	PotP_T_None			= 0,
	PotP_T_Started		= 1,
	PotP_T_Completed	= 2,
	PotP_T_Ended		= 3,
}
