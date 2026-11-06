//---------------------------------------------------
//-- Quest Definitions ------------------------------
//---------------------------------------------------

function PotP_DefineQuests(catalog: CPotP_Catalog)
{
	PotP_DefineQuests_01(catalog);
	PotP_DefineQuests_02(catalog);
	PotP_DefineQuests_03(catalog);
	PotP_DefineQuests_04(catalog);
	PotP_DefineQuests_05(catalog);
	PotP_DefineQuests_06(catalog);
	PotP_DefineQuests_07(catalog);
	PotP_DefineQuests_08(catalog);
	PotP_DefineQuests_09(catalog);
	PotP_DefineQuests_10(catalog);
	PotP_DefineQuests_11(catalog);
	PotP_DefineQuests_12(catalog);
	PotP_DefineQuests_13(catalog);
	PotP_DefineQuests_14(catalog);
	PotP_DefineQuests_15(catalog);
	PotP_DefineQuests_16(catalog);
	PotP_DefineQuests_17(catalog);
	PotP_DefineQuests_18(catalog);
	PotP_DefineQuests_19(catalog);
	PotP_DefineQuests_20(catalog);
	PotP_DefineQuests_21(catalog);
	PotP_DefineQuests_22(catalog);
	PotP_DefineQuests_23(catalog);
	PotP_DefineQuests_24(catalog);
	PotP_DefineQuests_25(catalog);
	PotP_DefineQuests_26(catalog);
	PotP_DefineQuests_27(catalog);
	PotP_DefineQuests_28(catalog);
	PotP_DefineQuests_29(catalog);
	PotP_DefineQuests_30(catalog);
	PotP_DefineQuests_31(catalog);
	PotP_DefineQuests_32(catalog);
}

//---------------------------------------------------

function PotP_DefineQuests_01(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_1", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Prologue");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_02(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_2", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_VelenAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_03(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_3", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_NovigradAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_04(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_4", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_SkelligeAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven");

	if (PotP_UsingBIA())
	{
		catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "Q205 A Mysterious Passenger");
	}
	else
	{
		catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly");
	}

	// The game deletes this quest from the journal once the Baron's part of Ciri's story
	// is told, whether or not Geralt has spoken to Donar, so the journal cannot be trusted.
	catalog.AddQuestFacts("q205_spoke_to_donar", "q103_nml_part1_ciri");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_05(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_5", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Act2");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_06(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_6", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Act3");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach");
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_07(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_7", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_HeartsOfStone");
	catalog.AddQuest("_01", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro");
	catalog.AddQuest("_02", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding");
	catalog.AddQuest("_03", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank");
	catalog.AddQuest("_04", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion");
	catalog.AddQuest("_05", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman");
	catalog.AddQuest("_06", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist");
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion");
	catalog.AddQuest("_08", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_08(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_8", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_BloodAndWine");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook");
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival");
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff");
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture");
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine");
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art");
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one");
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting");
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land");
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt");
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires");
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff");
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony");
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison");
	catalog.AddQuest("_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_09(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_9", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Vizima");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_10(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_1", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_WhiteOrchard");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_WO, PotP_I_Sides, "mq5004horse");
	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother");
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman");
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods");
	catalog.AddQuest("_06", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_11(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_2", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail");
	catalog.AddQuest("_02", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit");
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower");
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom");
	catalog.AddQuest("_08", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "SQ107 Pigs");
	catalog.AddQuest("_14", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup");
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve");
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith");
	catalog.AddQuest("_17", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho");
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "CG : No Man's Land");
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death");
	catalog.AddQuest("_20", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite");
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress");
	catalog.AddQuest("_22", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch");
	catalog.AddQuest("_23", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira");
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men");
	catalog.AddQuest("_25", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps");

	if (PotP_UsingWeatherArtifact())
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "mod003_weathermachine");
	}

	catalog.AddQuest("_26", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash");
	catalog.AddQuest("_27", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores");
	catalog.AddQuest("_28", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars");
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass");
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare");
	catalog.AddQuest("_32", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf");
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender");

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_34", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit");
	}

	if (PotP_UsingThreeLittleSisters()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5178
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "threesisters_little_sisters");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_12(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_3", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Novigrad");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests");
	catalog.AddQuest("_02", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game");
	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ315 Talar");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3039_crows");
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira");
	catalog.AddQuest("_06", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ301 Triss");
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "q602romance");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire");
	catalog.AddQuest("_09", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal");
	catalog.AddQuest("_10", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ312 Ves");

	if (PotP_UsingW3QE_UngratefulMage()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_94", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "dlcmoritz");
		// W3QE completes it however it ended, leaving him to burn included
		catalog.AddMissedUnless("sq301_completed", "sq301_met_ungrt_mage");
		catalog.AddOutcomeFacts("PotP_Event_MageAtTheStake_NG", "q309_ungrtf_mage_to_triss", "q309_ungrtf_mage_alone");
		catalog.AddAlsoMissedFact(PotP_Fact_EventMissed("PotP_Event_MageAtTheStake_NG"));
	}

	catalog.AddQuest("_11", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "q603painting");
	catalog.AddQuest("_12", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ303 Brothel");
	catalog.AddQuest("_13", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q308 Psycho");
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction");
	catalog.AddQuest("_15", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1");
	catalog.AddQuest("_16", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0");
	catalog.AddQuest("_17", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance");
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting");
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Novigrad");

	if (PotP_UsingW3QE_Masque()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_92", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "sq301_gwent");
	}

	if (PotP_UsingW3QE_Hearts()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "cg600_gwent");
	}

	catalog.AddQuest("_20", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Innkeepers");
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Talar");
	catalog.AddQuest("_22", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer");
	catalog.AddQuest("_23", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant");
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad");
	catalog.AddQuest("_25", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "SQ306 Maverick");
	catalog.AddQuest("_26", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt");
	catalog.AddQuest("_27", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster");

	if (PotP_UsingW3QE_Friends()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_93", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "sq301_party_mingling");
	}

	catalog.AddQuest("_28", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood");
	catalog.AddQuest("_29", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest");
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards");
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control");
	catalog.AddQuest("_32", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q309 Casablanca");
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja");
	catalog.AddQuest("_34", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith");
	catalog.AddQuest("_35", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence");
	catalog.AddQuest("_36", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing");
	catalog.AddQuest("_37", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6001merchant");
	catalog.AddQuest("_38", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3035_emhyr");
	catalog.AddQuest("_39", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ302 Philippa");
	catalog.AddQuest("_40", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose");
	catalog.AddQuest("_41", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts");
	catalog.AddQuest("_42", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse");
	catalog.AddQuest("_43", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ1028 Courier");
	catalog.AddQuest("_44", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs");
	catalog.AddQuest("_45", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette");
	catalog.AddQuest("_46", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette");
	catalog.AddQuest("_47", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector");
	catalog.AddQuest("_48", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll");
	catalog.AddQuest("_49", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune");
	catalog.AddQuest("_50", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6002_cannibals");
	catalog.AddQuest("_51", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2");

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_52", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2");
	}

	if (PotP_UsingCiriSoleMemento()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/4585
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "solememento_sole_memento");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_13(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_4", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Skellige");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2010 human trap");
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business");
	// sq209 only sets mq2051_unlocked as Geralt gets out of Lugos' prison, if he made the deal with Simun by then.
	catalog.AddMissedUnless("sq209_part_1_done", "mq2051_unlocked");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage");
	catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2045_chains");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "Fist Fight Championship");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting");
	catalog.AddQuest("_12", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory");
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2049_atheist");
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle");
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "CG: Skellige");
	catalog.AddQuest("_17", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time");
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ201 Curse");
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden");
	catalog.AddQuest("_20", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q206 Berserkers");
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena");
	catalog.AddQuest("_22", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest");
	catalog.AddQuest("_23", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q203 Him");
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist");
	catalog.AddQuest("_25", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence");
	catalog.AddQuest("_26", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl");
	catalog.AddQuest("_27", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart");
	catalog.AddQuest("_28", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams");
	catalog.AddQuest("_29", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu");
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund");
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship");
	catalog.AddQuest("_32", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal");
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde");
	catalog.AddQuest("_34", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ202 Yen");
	catalog.AddQuest("_35", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant");
	catalog.AddQuest("_36", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2030_nithing");
	catalog.AddQuest("_37", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power");
	catalog.AddQuest("_38", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored");
	catalog.AddQuest("_39", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers");

	if (PotP_UsingW3QE_SoundOfSilence()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_SK, PotP_I_Sides, "dlchornwallhorn");
	}

	catalog.AddQuest("_40", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower");
	catalog.AddQuest("_41", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_14(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_5", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_KaerMorhen");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4002_anomaly");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4003_lake");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4004_bastion");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4006_armor");

	if (PotP_UsingW3QE_Conscience()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_KM, PotP_I_Sides, "dlc10_treasurepang");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_15(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_6", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Toussaint");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree");
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter");
	catalog.AddQuest("_03", PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill");
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund");
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02");
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03");
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04");
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05");
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose");
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles");
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind");
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights");
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir");
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards");
	catalog.AddQuest("_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament");
	catalog.AddQuest("_17", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo");
	catalog.AddQuest("_18", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest");
	catalog.AddQuest("_19", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one");
	catalog.AddQuest("_20", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home");
	catalog.AddQuest("_21", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory");
	catalog.AddQuest("_22", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money");
	catalog.AddQuest("_23", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master");

	if (PotP_UsingW3QE_SecretGarden()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_TO, PotP_I_Sides, "dlcpalacegardens");
	}

	catalog.AddQuest("_24", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene");
	catalog.AddQuest("_25", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash");
	catalog.AddQuest("_26", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament");
	catalog.AddQuest("_27", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones");
	catalog.AddQuest("_28", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2");
	catalog.AddQuest("_29", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace");
	catalog.AddQuest("_30", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations");
	catalog.AddQuest("_31", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01");
	catalog.AddQuest("_32", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04");
	catalog.AddQuest("_33", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02");
	catalog.AddQuest("_34", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03");
	catalog.AddQuest("_35", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03");
	catalog.AddQuest("_36", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial");
	catalog.AddQuest("_37", PotP_E_Missable_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium");
	catalog.AddQuest("_38", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata");
	catalog.AddQuest("_39", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret");
	catalog.AddQuest("_40", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino");

	if (PotP_UsingANightToRemember()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/4670
	{
		catalog.AddQuest("_90", PotP_E_ModAdded_DLC2, PotP_R_TO, PotP_I_Sides, "ntr_nighttoremember");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_16(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_7", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_NonRegional");
	if (PotP_UsingAWitcherCanHideAnother()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9453
	{
		catalog.AddQuest("_100", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "A Witcher Can Hide Another");
	}

	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance");

	if (PotP_UsingW3QE_BombCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcbombcollector001");
	}

	if (PotP_UsingW3QE_BombCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcbombcollector002");
	}

	if (PotP_UsingW3QE_BombCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_92", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcbombcollector003");
	}

	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All");

	if (PotP_UsingW3QE_DecoctionCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_99", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcdecoctioncollector");
	}

	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill");

	if (PotP_UsingW3QE_PotionCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_96", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcpotioncollector001");
	}

	if (PotP_UsingW3QE_PotionCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_97", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcpotioncollector002");
	}

	if (PotP_UsingW3QE_PotionCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_98", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcpotioncollector003");
	}

	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "CG: Old Friends");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith");

	if (PotP_UsingW3QE_OilTycoon()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_93", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcoiltycoon001");
	}

	if (PotP_UsingW3QE_OilTycoon()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_94", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcoiltycoon002");
	}

	if (PotP_UsingW3QE_OilTycoon()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_95", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcoiltycoon003");
	}

	if (PotP_UsingAWitcherCanHideAnother()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9453
	{
		catalog.AddQuest("_101", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "Mysterious Disappearance");
	}

	if (PotP_UsingUnsinkable())
	{
		catalog.AddQuest("_102", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "mod001_boat");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_17(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_8", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Vizima");
	if (PotP_UsingCutThroatRazor())
	{
		catalog.AddQuest("_01", PotP_E_ModAdded, PotP_R_VI, PotP_I_Sides, "mod002_razor");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_18(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_1", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_WhiteOrchard");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_19(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_2", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake ");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_20(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_3", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Novigrad");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_21(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_4", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Skellige");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_22(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_5", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Toussaint");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars");
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle");
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror");
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse");
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_23(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_1", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Set");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_24(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_2", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_FelineSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Set");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_cat_gear");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_25(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_3", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Set");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_bear_gear");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_26(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_4", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Set");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b");
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_27(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_5", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_OtherSets");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Viper Set");

	if (PotP_UsingW3QE_ViperSet()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_NA, PotP_I_Scavs, "dlcvipercollection");
	}

	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th700_red_wolf");

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades");
	}

	if (PotP_UsingDLCArmorQuests()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/3983
	{
		catalog.AddQuest("_03", PotP_E_ModAdded, PotP_R_NA, PotP_I_Scavs, "temeriatreasurehunt");
		catalog.AddQuest("_04", PotP_E_ModAdded, PotP_R_NA, PotP_I_Scavs, "nilfgaardtreasurehunt");
		catalog.AddQuest("_05", PotP_E_ModAdded, PotP_R_NA, PotP_I_Scavs, "skelligetreasurehunt");
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_28(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_1", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_29(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_2", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure");
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6");
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34");
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_30(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_3", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Novigrad");
	catalog.AddQuest("_01", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi26b");
	catalog.AddQuest("_02", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi08");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island");
	catalog.AddQuest("_04", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor");
	catalog.AddQuest("_05", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi01");
	catalog.AddQuest("_06", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi10");
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi02");
	catalog.AddQuest("_08", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi26");
	catalog.AddQuest("_09", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi05");
	catalog.AddQuest("_10", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi04");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_31(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_4", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Skellige");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005");
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms");
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057");
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056");
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure");
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042");
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4");
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships");
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure");
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050");
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38");
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure");
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_32(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_5", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Toussaint");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01");
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05");
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10");
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04");
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13");
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05");
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11");
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02");
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20");
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08");
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10");
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14");
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04");
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10");
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03");
	catalog.EndSection();
}
