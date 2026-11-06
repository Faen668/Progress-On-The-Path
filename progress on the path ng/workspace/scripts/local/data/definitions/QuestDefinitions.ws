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
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream", 343480);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer", 546202);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt", 343481);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack", 343482);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_02(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_2", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_VelenAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent", 349703);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron", 337285);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch", 1048662);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues", 337286);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure", 1044031);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race", 1048663);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad", 1048664);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch", 1049419);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer", 335171);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches", 337287);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit", 402780);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps", 1050489);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_03(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_3", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_NovigradAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer", 318699);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer", 1001953);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion", 337281);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia", 337290);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu", 1049230);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure", 337291);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid", 1051872);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play", 1049269);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion", 1049270);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple", 1049271);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_04(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_4", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_SkelligeAct1");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige", 1049822);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception", 170874);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm", 1050493);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten", 1048552);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden", 1048568);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven", 1048567);

	if (PotP_UsingBIA())
	{
		catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "Q205 A Mysterious Passenger", 1054662);
	}
	else
	{
		catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly", 1054662);
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
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium", 1050687);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope", 1055911);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel", 1050688);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery", 1050684);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion", 1050685);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse", 1050686);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen", 1083645);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad", 1083643);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige", 1083644);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard", 1083646);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists", 439463);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen", 314235);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle", 549717);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_06(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_6", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Act3");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith", 337344);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad", 1048539);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl", 320718);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break", 543298);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out", 320730);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral", 1049318);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations", 1051436);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris", 318703);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr", 1051434);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab", 538022);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave", 549139);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin", 532443);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach", 453758);
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress", 318697);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_07(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_7", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_HeartsOfStone");
	catalog.AddQuest("_01", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro", 1133983);
	catalog.AddQuest("_02", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding", 1097419);
	catalog.AddQuest("_03", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank", 1104514);
	catalog.AddQuest("_04", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion", 1125063);
	catalog.AddQuest("_05", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman", 1107463);
	catalog.AddQuest("_06", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist", 1107498);
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion", 1106717);
	catalog.AddQuest("_08", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale", 1108644);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_08(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_8", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_BloodAndWine");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook", 1175249);
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival", 1151724);
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff", 1189583);
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture", 1160909);
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast", 1189588);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine", 1186423);
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art", 1186426);
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one", 1157072);
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting", 1180369);
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land", 1155686);
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt", 1117672);
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires", 1180678);
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff", 1187564);
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony", 1154470);
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison", 1154465);
	catalog.AddQuest("_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home", 1178196);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_09(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_MainQ_9", PotP_A_Quest, "PotP_TrackingGroup_MainQuests_Vizima");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace", 1048443);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_10(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_1", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_WhiteOrchard");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed", 1034547);
	catalog.AddQuest("_02", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "mq5004horse", 1077058);
	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother", 584020);
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman", 547346);
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods", 1025960);
	catalog.AddQuest("_06", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith", 1037281);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_11(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_2", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail", 352169);
	catalog.AddQuest("_02", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira", 527424);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit", 562681);
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower", 318700);
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness", 503624);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers", 358211);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom", 540320);
	catalog.AddQuest("_08", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber", 1049156);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house", 1077096);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods", 389505);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers", 1062169);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting", 1047220);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "SQ107 Pigs", 521042);
	catalog.AddQuest("_14", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup", 354543);
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve", 308555);
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith", 404537);
	catalog.AddQuest("_17", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho", 440766);
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "CG : No Man's Land", 1076752);
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death", 355813);
	catalog.AddQuest("_20", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite", 389089);
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress", 507108);
	catalog.AddQuest("_22", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch", 455889);
	catalog.AddQuest("_23", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira", 1034372);
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men", 593165);
	catalog.AddQuest("_25", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps", 318701);

	if (PotP_UsingWeatherArtifact())
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "weatherartifactquest");
		catalog.AddQuestAltJournal("mod003_weathermachine");   // older versions of Weather Artifact Remastered
	}

	catalog.AddQuest("_26", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash", 1105282);
	catalog.AddQuest("_27", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores", 1012885);
	catalog.AddQuest("_28", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars", 454220);
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass", 1051279);
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare", 1089166);
	catalog.AddQuest("_32", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf", 471968);
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender", 431183);

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_34", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit", 1222166);
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
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests", 1052986);
	catalog.AddQuest("_02", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game", 503027);
	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ315 Talar", 1070297);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3039_crows", 548706);
	catalog.AddQuest("_05", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira", 1049075);
	catalog.AddQuest("_06", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ301 Triss", 433339);
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "q602romance", 1107524);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire", 1011723);
	catalog.AddQuest("_09", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal", 531186);
	catalog.AddQuest("_10", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ312 Ves", 527713);

	if (PotP_UsingW3QE_UngratefulMage()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_94", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "dlcmoritz");
		// W3QE completes it however it ended, leaving him to burn included
		catalog.AddMissedUnless("sq301_completed", "sq301_met_ungrt_mage");
		catalog.AddOutcomeFacts("PotP_Event_MageAtTheStake_NG", "q309_ungrtf_mage_to_triss", "q309_ungrtf_mage_alone");
		catalog.AddAlsoMissedFact(PotP_Fact_EventMissed("PotP_Event_MageAtTheStake_NG"));
	}

	catalog.AddQuest("_11", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "q603painting", 1125335);
	catalog.AddQuest("_12", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ303 Brothel", 320689);
	catalog.AddQuest("_13", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q308 Psycho", 430009);
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction", 472938);
	catalog.AddQuest("_15", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1", 1130863);
	catalog.AddQuest("_16", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0", 1131840);
	catalog.AddQuest("_17", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance", 532936);
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting", 1047103);
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Novigrad", 1076791);

	if (PotP_UsingW3QE_Masque()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_92", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "sq301_gwent");
	}

	if (PotP_UsingW3QE_Hearts()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "cg600_gwent");
	}

	catalog.AddQuest("_20", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Innkeepers", 1076777);
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "CG: Talar", 1076788);
	catalog.AddQuest("_22", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer", 1084795);
	catalog.AddQuest("_23", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant", 1077279);
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad", 535628);
	catalog.AddQuest("_25", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "SQ306 Maverick", 573611);
	catalog.AddQuest("_26", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt", 514063);
	catalog.AddQuest("_27", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster", 1048569);

	if (PotP_UsingW3QE_Friends()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_93", PotP_E_ModAdded, PotP_R_NO, PotP_I_Sides, "sq301_party_mingling");
	}

	catalog.AddQuest("_28", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood", 449737);
	catalog.AddQuest("_29", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest", 1020614);
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards", 454017);
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control", 1056117);
	catalog.AddQuest("_32", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "Q309 Casablanca", 344386);
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja", 353938);
	catalog.AddQuest("_34", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith", 491891);
	catalog.AddQuest("_35", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence", 1049516);
	catalog.AddQuest("_36", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing", 1042279);
	catalog.AddQuest("_37", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6001merchant", 1134832);
	catalog.AddQuest("_38", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3035_emhyr", 1071758);
	catalog.AddQuest("_39", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "SQ302 Philippa", 566187);
	catalog.AddQuest("_40", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose", 1127650);
	catalog.AddQuest("_41", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts", 466882);
	catalog.AddQuest("_42", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse", 478626);
	catalog.AddQuest("_43", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ1028 Courier", 407710);
	catalog.AddQuest("_44", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs", 370453);
	catalog.AddQuest("_45", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette", 1036777);
	catalog.AddQuest("_46", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette", 1036778);
	catalog.AddQuest("_47", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector", 1123181);
	catalog.AddQuest("_48", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll", 408856);
	catalog.AddQuest("_49", PotP_E_Missable, PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune", 547583);
	catalog.AddQuest("_50", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Sides, "mq6002_cannibals", 1127948);
	catalog.AddQuest("_51", PotP_E_Primary, PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2", 1139998);

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_52", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2", 1130865);
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
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition", 351309);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn", 458983);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2010 human trap", 1073377);
	catalog.AddQuest("_04", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business", 1051826);
	// sq209 only sets mq2051_unlocked as Geralt gets out of Lugos' prison, if he made the deal with Simun by then.
	catalog.AddMissedUnless("sq209_part_1_done", "mq2051_unlocked");
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits", 1062153);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage", 1049899);
	catalog.AddQuest("_07", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead", 409320);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2045_chains", 1028148);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers", 440795);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "Fist Fight Championship", 1047233);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting", 1047225);
	catalog.AddQuest("_12", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness", 1043323);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory", 1046212);
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2049_atheist", 1021084);
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle", 1028150);
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "CG: Skellige", 1076765);
	catalog.AddQuest("_17", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time", 349251);
	catalog.AddQuest("_18", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ201 Curse", 503314);
	catalog.AddQuest("_19", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden", 1018189);
	catalog.AddQuest("_20", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q206 Berserkers", 346828);
	catalog.AddQuest("_21", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena", 481365);
	catalog.AddQuest("_22", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest", 442722);
	catalog.AddQuest("_23", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q203 Him", 318698);
	catalog.AddQuest("_24", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist", 474119);
	catalog.AddQuest("_25", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence", 1028939);
	catalog.AddQuest("_26", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl", 477183);
	catalog.AddQuest("_27", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart", 460200);
	catalog.AddQuest("_28", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams", 1054990);
	catalog.AddQuest("_29", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu", 458375);
	catalog.AddQuest("_30", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund", 573921);
	catalog.AddQuest("_31", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship", 592396);
	catalog.AddQuest("_32", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal", 574884);
	catalog.AddQuest("_33", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde", 590360);
	catalog.AddQuest("_34", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "SQ202 Yen", 591749);
	catalog.AddQuest("_35", PotP_E_Missable, PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant", 159055);
	catalog.AddQuest("_36", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2030_nithing", 492258);
	catalog.AddQuest("_37", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power", 1015703);
	catalog.AddQuest("_38", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored", 1010848);
	catalog.AddQuest("_39", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers", 459470);

	if (PotP_UsingW3QE_SoundOfSilence()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_SK, PotP_I_Sides, "dlchornwallhorn");
	}

	catalog.AddQuest("_40", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower", 578567);
	catalog.AddQuest("_41", PotP_E_Primary, PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif", 1074000);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_14(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_5", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_KaerMorhen");
	catalog.AddQuest("_01", PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword", 1028037);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4002_anomaly", 1024080);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4003_lake", 1026248);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4004_bastion", 1029387);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_KM, PotP_I_Sides, "mq4006_armor", 1031235);

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
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree", 1104594);
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter", 1100863);
	catalog.AddQuest("_03", PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill", 1189584);
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund", 1197493);
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01", 1212680);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02", 1212706);
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03", 1212726);
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04", 1212817);
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05", 1212698);
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose", 1165568);
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles", 1108621);
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind", 1094366);
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights", 1126924);
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir", 1100360);
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards", 1169805);
	catalog.AddQuest("_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament", 1169800);
	catalog.AddQuest("_17", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo", 1214198);
	catalog.AddQuest("_18", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest", 1205338);
	catalog.AddQuest("_19", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one", 1107459);
	catalog.AddQuest("_20", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home", 1189396);
	catalog.AddQuest("_21", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory", 1092927);
	catalog.AddQuest("_22", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money", 1098004);
	catalog.AddQuest("_23", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master", 1207882);

	if (PotP_UsingW3QE_SecretGarden()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_91", PotP_E_ModAdded, PotP_R_TO, PotP_I_Sides, "dlcpalacegardens");
	}

	catalog.AddQuest("_24", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene", 1188340);
	catalog.AddQuest("_25", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash", 1201180);
	catalog.AddQuest("_26", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament", 1129249);
	catalog.AddQuest("_27", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones", 1201972);
	catalog.AddQuest("_28", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2", 1209307);
	catalog.AddQuest("_29", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace", 1094393);
	catalog.AddQuest("_30", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations", 1171831);
	catalog.AddQuest("_31", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01", 1205525);
	catalog.AddQuest("_32", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04", 1193633);
	catalog.AddQuest("_33", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02", 1205714);
	catalog.AddQuest("_34", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03", 1205790);
	catalog.AddQuest("_35", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03", 1207175);
	catalog.AddQuest("_36", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial", 1205976);
	catalog.AddQuest("_37", PotP_E_Missable_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium", 1205241);
	catalog.AddQuest("_38", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata", 1204773);
	catalog.AddQuest("_39", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret", 1204960);
	catalog.AddQuest("_40", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino", 1204774);

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

	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance", 498099);

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

	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All", 522071);

	if (PotP_UsingW3QE_DecoctionCollector()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_99", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "dlcdecoctioncollector");
	}

	catalog.AddQuest("_03", PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill", 592254);

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

	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "CG: Old Friends", 1076783);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith", 497149);

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
		catalog.AddQuest("_102", PotP_E_ModAdded, PotP_R_NA, PotP_I_Sides, "unsinkablequest");
		catalog.AddQuestAltJournal("mod001_boat");   // older versions of Unsinkable Quest Remastered
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_17(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_SideQ_8", PotP_A_Quest, "PotP_TrackingGroup_SideQuests_Vizima");
	if (PotP_UsingCutThroatRazor())
	{
		catalog.AddQuest("_01", PotP_E_ModAdded, PotP_R_VI, PotP_I_Sides, "Cut-Throat Razor");
		catalog.AddQuestAltJournal("mod002_razor");   // older versions of the Cut-Throat Razor mod
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_18(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_1", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_WhiteOrchard");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith", 1025961);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_19(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_2", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith", 411224);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas", 440626);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart", 442222);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard", 540318);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern", 557974);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice", 410130);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling", 443742);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake ", 1089358);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon", 1038351);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag", 443077);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma", 552318);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael", 465266);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_20(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_3", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Novigrad");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler", 576320);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus", 568243);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o", 573122);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy", 566290);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion", 1011771);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon", 445087);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan", 571590);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih", 577958);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_21(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_4", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Skellige");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail", 378969);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia", 1025655);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll", 370417);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend", 381738);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag", 368919);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt", 1090362);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior", 370714);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith", 1017266);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit", 386514);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_22(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ContQ_5", PotP_A_Quest, "PotP_TrackingGroup_ContractQuests_Toussaint");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars", 1122270);
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle", 1092729);
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror", 1150868);
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse", 1164807);
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight", 1102041);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_23(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_1", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Set", 1074577);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A", 1082083);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B", 1082084);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2", 1082085);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3", 1082086);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear", 1184435);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_24(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_2", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_FelineSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Set", 1074575);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a", 1077916);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b", 1077981);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2", 1077985);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3", 1077982);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_cat_gear", 1184434);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_25(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_3", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Set", 1074576);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A", 1078833);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B", 1078834);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2", 1078835);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3", 1078836);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_bear_gear", 1184447);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_26(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_4", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Set", 1092209);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A", 1092207);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B", 1092208);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2", 1092210);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b", 1104352);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3", 1092211);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b", 1104351);
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear", 1153467);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_27(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_ScavQ_5", PotP_A_Quest, "PotP_TrackingGroup_ScavengerHuntQuests_OtherSets");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "Viper Set", 1064512);

	if (PotP_UsingW3QE_ViperSet()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/9360
	{
		catalog.AddQuest("_90", PotP_E_ModAdded, PotP_R_NA, PotP_I_Scavs, "dlcvipercollection");
	}

	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th700_red_wolf", 1152256);

	if (PotP_IsUsingNextGen())
	{
		catalog.AddQuest("_06", PotP_E_Primary, PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades", 1223204);
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
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash", 1083526);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure", 1083525);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure", 1083527);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_29(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_2", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Velen");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure", 1078239);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24", 1078224);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2", 1078065);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41", 1078216);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39", 1077720);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest", 1077395);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40", 1078213);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure", 1078300);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier", 1077776);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11", 1078228);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note", 1084813);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure", 1077756);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure", 1077797);
	catalog.AddQuest("_14", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6", 1078104);
	catalog.AddQuest("_15", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34", 1078470);
	catalog.AddQuest("_16", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds", 1078231);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_30(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_3", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Novigrad");
	catalog.AddQuest("_01", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi26b", 1137126);
	catalog.AddQuest("_02", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi08", 1134729);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island", 1083524);
	catalog.AddQuest("_04", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor", 1135736);
	catalog.AddQuest("_05", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi01", 1136507);
	catalog.AddQuest("_06", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi10", 1113505);
	catalog.AddQuest("_07", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi02", 1133947);
	catalog.AddQuest("_08", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi26", 1130758);
	catalog.AddQuest("_09", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi05", 1113928);
	catalog.AddQuest("_10", PotP_E_Primary_DLC1, PotP_R_NO, PotP_I_Hunts, "ep1poi04", 1134728);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_31(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_4", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Skellige");
	catalog.AddQuest("_01", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005", 1077768);
	catalog.AddQuest("_02", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms", 1078235);
	catalog.AddQuest("_03", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057", 1078431);
	catalog.AddQuest("_04", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31", 1083593);
	catalog.AddQuest("_05", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056", 1078051);
	catalog.AddQuest("_06", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure", 1083528);
	catalog.AddQuest("_07", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042", 1077764);
	catalog.AddQuest("_08", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4", 1077775);
	catalog.AddQuest("_09", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships", 1083529);
	catalog.AddQuest("_10", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure", 347104);
	catalog.AddQuest("_11", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050", 1078052);
	catalog.AddQuest("_12", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38", 1084426);
	catalog.AddQuest("_13", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure", 347102);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineQuests_32(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_TreaQ_5", PotP_A_Quest, "PotP_TrackingGroup_TreasureHuntQuests_Toussaint");
	catalog.AddQuest("_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01", 1164725);
	catalog.AddQuest("_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05", 1183965);
	catalog.AddQuest("_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10", 1189798);
	catalog.AddQuest("_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04", 1206166);
	catalog.AddQuest("_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13", 1205868);
	catalog.AddQuest("_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05", 1206940);
	catalog.AddQuest("_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11", 1201851);
	catalog.AddQuest("_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02", 1165135);
	catalog.AddQuest("_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20", 1212650);
	catalog.AddQuest("_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08", 1166761);
	catalog.AddQuest("_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10", 1188095);
	catalog.AddQuest("_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14", 1172865);
	catalog.AddQuest("_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04", 1208911);
	catalog.AddQuest("_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10", 1194386);
	catalog.AddQuest("_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03", 1169837);
	catalog.EndSection();
}
