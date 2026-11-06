//---------------------------------------------------
//-- World Definitions ------------------------------
//---------------------------------------------------

function PotP_DefineWorld(catalog: CPotP_Catalog)
{
	PotP_DefineWorld_01(catalog);
	PotP_DefineWorld_02(catalog);
	PotP_DefineWorld_03(catalog);
	PotP_DefineWorld_04(catalog);
	PotP_DefineWorld_05(catalog);
	PotP_DefineWorld_06(catalog);
	PotP_DefineWorld_07(catalog);
	PotP_DefineWorld_08(catalog);
	PotP_DefineWorld_09(catalog);
	PotP_DefineWorld_10(catalog);
	PotP_DefineWorld_11(catalog);
	PotP_DefineWorld_12(catalog);
	PotP_DefineWorld_13(catalog);
	PotP_DefineWorld_14(catalog);
	PotP_DefineWorld_15(catalog);
	PotP_DefineWorld_16(catalog);
	PotP_DefineWorld_17(catalog);
	PotP_DefineWorld_18(catalog);
	PotP_DefineWorld_19(catalog);
	PotP_DefineWorld_20(catalog);
	PotP_DefineWorld_21(catalog);
	PotP_DefineWorld_22(catalog);
	PotP_DefineWorld_23(catalog);
	PotP_DefineWorld_24(catalog);
	PotP_DefineWorld_25(catalog);
	PotP_DefineWorld_26(catalog);
	PotP_DefineWorld_27(catalog);
	PotP_DefineWorld_28(catalog);
	PotP_DefineWorld_29(catalog);
	PotP_DefineWorld_30(catalog);
	PotP_DefineWorld_31(catalog);
	PotP_DefineWorld_32(catalog);
	PotP_DefineWorld_33(catalog);
	PotP_DefineWorld_34(catalog);
	PotP_DefineWorld_35(catalog);
	PotP_DefineWorld_36(catalog);
	PotP_DefineWorld_37(catalog);
	PotP_DefineWorld_38(catalog);
	PotP_DefineWorld_39(catalog);
	PotP_DefineWorld_40(catalog);
	PotP_DefineWorld_41(catalog);
	PotP_DefineWorld_42(catalog);
	PotP_DefineWorld_43(catalog);
	PotP_DefineWorld_44(catalog);
	PotP_DefineWorld_45(catalog);
	PotP_DefineWorld_46(catalog);
	PotP_DefineWorld_47(catalog);
	PotP_DefineWorld_48(catalog);
	PotP_DefineWorld_49(catalog);
	PotP_DefineWorld_50(catalog);
	PotP_DefineWorld_51(catalog);
}

//---------------------------------------------------

function PotP_DefineWorld_01(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Sites_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_AbandonedSites_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'lumbermill_camp_mp');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'road_protection_shrine');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_02(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Sites_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_AbandonedSites_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_de29');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'cp5_town_resc');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr11_b');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr12_town');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr27');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb10');
	catalog.AddWorld("_07", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb14');
	catalog.AddWorld("_08", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb3');
	catalog.AddWorld("_09", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm3');
	catalog.AddWorld("_10", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm4');
	catalog.AddWorld("_11", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_08_mp_rt');
	catalog.AddWorld("_12", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_30_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_03(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Sites_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_AbandonedSites_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi20_mp');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_37_mp');
	catalog.AddWorld("_03", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi07_mp');
	catalog.AddWorld("_04", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi06_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_04(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Sites_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_AbandonedSites_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk34_mp');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk33_mp');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk52_mp_skellige');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk75_mp_skellige');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk51_mp_skellige');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_05(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Sites_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_AbandonedSites_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_a_03_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_b_04_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_car_b_03_mp');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_b_12_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_c_03_mp');
	catalog.AddWorld("_06", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_d_06_mp');
	catalog.AddWorld("_07", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_ved_a_02_mp');
	catalog.AddWorld("_08", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_cor_2_mp');
	catalog.AddWorld("_09", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_10_mp');
	catalog.AddWorld("_10", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_12_mp');
	catalog.AddWorld("_11", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_ww_poi_bel_5_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_06(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Camps_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_camp');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire2');
	catalog.AddWorld("_03", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire3');
	catalog.AddWorld("_04", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_road');
	catalog.AddWorld("_05", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire');
	catalog.AddWorld("_06", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_sanctuary');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_07(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Camps_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_BanditCamp_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de2');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cb18');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_bm2');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de101');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de102');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de25');
	catalog.AddWorld("_07", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gr31');
	catalog.AddWorld("_08", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'pit_camp_nml_mp');
	catalog.AddWorld("_09", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'mp2_nml_mappin');
	catalog.AddWorld("_10", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cp37');
	catalog.AddWorld("_11", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb23');
	catalog.AddWorld("_12", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb30');
	catalog.AddWorld("_13", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb20');
	catalog.AddWorld("_14", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb12');
	catalog.AddWorld("_15", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb5');
	catalog.AddWorld("_16", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb7_camp_mp');
	catalog.AddWorld("_17", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb5b_mp_nml_yet');
	catalog.AddWorld("_18", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb7');
	catalog.AddWorld("_19", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb18');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_08(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Camps_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gf42');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_hs16');
	catalog.AddWorld("_03", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi17_mp');
	catalog.AddWorld("_04", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'gf203_mp_nml');
	catalog.AddWorld("_05", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi16_mp');
	catalog.AddWorld("_06", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi23_mp');
	catalog.AddWorld("_07", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi09_mp');
	catalog.AddWorld("_08", PotP_R_NO, PotP_I_Camps, PotP_E_Missable, 'ep1_poi_ofir_camp_mp');
	catalog.AddWorld("_09", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi11_mp');
	catalog.AddWorld("_10", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi12_mp');
	catalog.AddWorld("_11", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi13_mp');
	catalog.AddWorld("_12", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi14_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_09(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Camps_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_BanditCamp_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk10_mp_giantfoot_skellige');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk16_mp');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk28_mp');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk36_mp');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk111_mp_skellige');
	catalog.AddWorld("_06", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk86_mp_skl');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_10(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Camps_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_17_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_09_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_07_mp_b');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_car_a_06_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_08_mp');
	catalog.AddWorld("_06", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_18_mp');
	catalog.AddWorld("_07", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_b_06_mp');
	catalog.AddWorld("_08", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_07_mp');
	catalog.AddWorld("_09", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_13_mp_ban');
	catalog.AddWorld("_10", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_08_mp');
	catalog.AddWorld("_11", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_a_09_mp_b');
	catalog.AddWorld("_12", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_06_mp');
	catalog.AddWorld("_13", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_12_mp_b');
	catalog.AddWorld("_14", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_vin_b_06_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_11(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'beached_boats');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'boat_wreck');
	catalog.AddWorld("_03", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'cemetary_wraith');
	catalog.AddWorld("_04", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'dead_horses_prologue');
	catalog.AddWorld("_05", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'waterhag_mappin');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_12(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_a');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_b');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm3');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm4');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cb19');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp11');
	catalog.AddWorld("_07", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp14');
	catalog.AddWorld("_08", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp36');
	catalog.AddWorld("_09", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp38');
	catalog.AddWorld("_10", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr100');
	catalog.AddWorld("_11", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gr15b_mp');
	catalog.AddWorld("_12", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gf204_mp_nml');
	catalog.AddWorld("_13", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_mp5');
	catalog.AddWorld("_14", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_wraith_nml_sp');
	catalog.AddWorld("_15", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb11');
	catalog.AddWorld("_16", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb19');
	catalog.AddWorld("_17", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb24_swamp');
	catalog.AddWorld("_18", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'de100_mp_nml');
	catalog.AddWorld("_19", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_de27');
	catalog.AddWorld("_20", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm100');
	catalog.AddWorld("_21", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm101');
	catalog.AddWorld("_22", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_tm201_nml');
	catalog.AddWorld("_23", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm5');
	catalog.AddWorld("_24", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_33_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_13(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'hs22_mp_nml');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr33');
	catalog.AddWorld("_03", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_hs11');
	catalog.AddWorld("_04", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf202_mp_nml');
	catalog.AddWorld("_05", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf200_mp_nml');
	catalog.AddWorld("_06", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf201_mp_nml');
	catalog.AddWorld("_07", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_24_mp');
	catalog.AddWorld("_08", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi03_mp');
	catalog.AddWorld("_09", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_35_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_14(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk1_mp_skellige');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk18_mp');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk22_mp');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk23_mp');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk26_mp');
	catalog.AddWorld("_06", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk27_mp');
	catalog.AddWorld("_07", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk32_mp');
	catalog.AddWorld("_08", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk37_mp');
	catalog.AddWorld("_09", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk46_mp');
	catalog.AddWorld("_10", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk72_mp');
	catalog.AddWorld("_11", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk7_mp');
	catalog.AddWorld("_12", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk110_mp_skellige');
	catalog.AddWorld("_13", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk106_mp_skellige');
	catalog.AddWorld("_14", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk151_mp_skl');
	catalog.AddWorld("_15", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk105_mp_skellige');
	catalog.AddWorld("_16", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk76_mp_skl');
	catalog.AddWorld("_17", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk78_mp_skl');
	catalog.AddWorld("_18", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk79_mp_skl');
	catalog.AddWorld("_19", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk80a_mp_skl');
	catalog.AddWorld("_20", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk81_mp_skl');
	catalog.AddWorld("_21", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk82_mp_skl');
	catalog.AddWorld("_22", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk90_mp_skl');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_15(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_KaerMorhen");
	catalog.AddWorld("_01", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_leshy');
	catalog.AddWorld("_02", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_wyvern');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_16(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Guard_6", PotP_A_World, "PotP_TrackingGroup_WorldMap_GuardedTreasure_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_02_mp_post');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_08_mp_post');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_09_mp_post');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_11_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_05_mp');
	catalog.AddWorld("_06", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_07_mp');
	catalog.AddWorld("_07", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_dun_b_08_mp');
	catalog.AddWorld("_08", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_a_08_mp');
	// _09, _13 and _14 were the later states of bandit camps _01, _08 and _05, which count for both.
	catalog.AddWorld("_10", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_d_19_mp');
	catalog.AddWorld("_11", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_04_mp');
	catalog.AddWorld("_12", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_06_mp');
	catalog.AddWorld("_15", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_vin_b_04_mp');
	catalog.AddWorld("_16", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_cor_5_mp');
	catalog.AddWorld("_17", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_ver_9_mp');
	catalog.AddWorld("_18", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_ww_poi_bel_6_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_17(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_DensM_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterDens_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gr38');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de24');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_18(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_DensM_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gf2');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de30');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_19(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_DensM_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterDens_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk12_mp');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk25_mp');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk60_mp');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk86_mp');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk55_mp_skellige');
	catalog.AddWorld("_06", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk58_mp_skellige');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_20(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_DensM_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_05_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_MDens, PotP_E_Primary, 'poi_ved_a_04_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_MDens, PotP_E_Primary, 'poi_dun_a_04_cave_mp');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_MDens, PotP_E_Primary, 'poi_gor_b_11_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_14_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_21(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_NestM_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_hengestone_ghoulnest_pin');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_monster_nest_ghoul5');
	catalog.AddWorld("_03", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_ghouls_nest01');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_22(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_NestM_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterNests_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr36_nekkers_nest');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr16_pc_nest_rotfiend');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr28_harpynest_01');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_mp4_rotfiend_nest');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_1');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_boss');
	catalog.AddWorld("_07", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul');
	catalog.AddWorld("_08", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul_01');
	catalog.AddWorld("_09", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr35_ghouls_nest');
	catalog.AddWorld("_10", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp34_ghouls_nest');
	catalog.AddWorld("_11", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp35_ghouls_nest');
	catalog.AddWorld("_12", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'nml_cp5_nest_mp');
	catalog.AddWorld("_13", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'de8_nekker_nest');
	catalog.AddWorld("_14", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_1');
	catalog.AddWorld("_15", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_4');
	catalog.AddWorld("_16", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_2');
	catalog.AddWorld("_17", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_01');
	catalog.AddWorld("_18", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_02');
	catalog.AddWorld("_19", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp21_drowner_nest');
	catalog.AddWorld("_20", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'bm7_drowners_nest');
	catalog.AddWorld("_21", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'hs13_rotfiend_nest');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_23(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_NestM_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_34_mp');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'lw_nest_ep1_poi_31_mp');
	catalog.AddWorld("_03", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_19_mp');
	catalog.AddWorld("_04", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi32_nest');
	catalog.AddWorld("_05", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest01');
	catalog.AddWorld("_06", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest02');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_24(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_NestM_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterNests_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk15_drowner_nest');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk14_nest_sirens');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk74_harpy_nest');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk75_siren_nest');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk_poi_107_nest');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_25(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_NestM_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_01');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_02');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_gor_b_13_mp');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_b_05_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_dun_a_04_mp');
	catalog.AddWorld("_06", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_a_03_mp');
	catalog.AddWorld("_07", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_car_b_09_mp');
	catalog.AddWorld("_08", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'lw_ww_poi_bel_8_mp');
	catalog.AddWorld("_09", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_b_07_mp');
	catalog.AddWorld("_10", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_a_13_nest');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_26(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Touss_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_HanseBases_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_bar_a_01_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_gor_d_05_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_ved_a_01_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_27(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Touss_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_DistressedKnights_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_bar_a_12_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_a_09_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_d_07_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_28(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Touss_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_InfestedVineyards_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_01_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_02_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_vin_a_02_mp');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_poi_ww_cor_1_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_ww_poi_bel_9_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_29(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_ignii_prologue_01');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_axii_prologue_04');
	catalog.AddWorld("_03", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_aard_prologue_02');
	catalog.AddWorld("_04", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_quen_prologue_03');
	catalog.AddWorld("_05", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'pop_quen2_prlg');
	catalog.AddWorld("_06", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_yrden_prologue_05');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_30(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_ignii2_nml_mp');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_aard');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'lw_ancient_castle_pop');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_quen2_nml_mp');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_yrden2_nml_mp');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_yrden');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_31(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_axii');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_ignii');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_32(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'skl_pop_ignii2_new');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'pop_mp_igniii_skellige');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'skl_pop_axii2_new');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'ard_skellig_pop_axii');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'ard_skellig_pop_aard');
	catalog.AddWorld("_06", PotP_R_SK, PotP_I_Place, PotP_E_Missable, 'skl_pop_quen2_new');
	catalog.AddWorld("_07", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'pop_quen_skellige_mp');
	catalog.AddWorld("_08", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'skl_pop_yrden2_new');
	catalog.AddWorld("_09", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 'pop_yrden_mp_skellige');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_33(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen");
	catalog.AddWorld("_01", PotP_R_KM, PotP_I_Place, PotP_E_Primary, 'km_mp_pop_igniii');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_34(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_6", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 'bob_place_of_power_igni_0001');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 'bob_place_of_power_axii_0001');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 'bob_place_of_power_aard_0001');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 'bob_place_of_power_quen_0002');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 'bob_place_of_power_yrden_0002');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_35(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Place_7", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral");
	catalog.AddWorld("_01", PotP_R_TS, PotP_I_Place, PotP_E_Missable, 'aard_gasforest');
	catalog.AddWorldAltPin("MISSING_NAME_DC68A555-450512C2-0354139F-CDA274E2");   // vanilla's own name for it: Brothers In Arms renames it aard_gasforest
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_36(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Distr_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_PersonsInDistress_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_cp13');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr13');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr29');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_hs2');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_tm12');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'ep1_pan_dziedzina_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_37(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Distr_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_PersonsInDistress_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk29_mp');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk90_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_38(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_Distr_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_PersonsInDistress_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_bar_a_02_mp');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_ved_a_05_mp');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_cor_3_mp');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_ver_11_mp');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_ww_poi_bel_7_mp');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_39(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard");
	catalog.AddWorld("_01", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'well_village');
	catalog.AddWorld("_02", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Broken_bridge');
	catalog.AddWorld("_03", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'bridge_gate');
	catalog.AddWorld("_04", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Crossroads');
	catalog.AddWorld("_05", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'River_crossing');
	catalog.AddWorld("_06", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Windmill');
	catalog.AddWorld("_07", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Nilfgaard_camp');
	catalog.AddWorld("_08", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'ransacked_village');
	catalog.AddWorld("_09", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woodcutters_lodge');
	catalog.AddWorld("_10", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woesong_bridge');

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_11", PotP_R_WO, PotP_I_Signs, PotP_E_ModAdded, 'king_desmond_bridge');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_40(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_Velen");
	catalog.AddWorld("_01", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cp_abandoned_tower');
	catalog.AddWorld("_02", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'incredibly_big_tree');
	catalog.AddWorld("_03", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_slaver_camp');
	catalog.AddWorld("_04", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'benek_village');
	catalog.AddWorld("_05", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'snots_village');
	catalog.AddWorld("_06", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'boatmakers_hut');
	catalog.AddWorld("_07", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'halver_isle');
	catalog.AddWorld("_08", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'burned_ruins');
	catalog.AddWorld("_09", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_brickmakers');
	catalog.AddWorld("_10", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'glinsk_village');
	catalog.AddWorld("_11", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'shipwreck_shore');
	catalog.AddWorld("_12", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'stray_kings_quarry');
	catalog.AddWorld("_13", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'massacred_village');
	catalog.AddWorld("_14", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'road_to_baldenfort');
	catalog.AddWorld("_15", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_yard');
	catalog.AddWorld("_16", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'baldenfort_bastion');
	catalog.AddWorld("_17", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'plague_pit');
	catalog.AddWorld("_18", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'downwarren');
	catalog.AddWorld("_19", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'griffin_dungeon_exit');
	catalog.AddWorld("_20", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_deserted_village');
	catalog.AddWorld("_21", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'roadside_chapel');
	catalog.AddWorld("_22", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bayors_ferry_station');
	catalog.AddWorld("_23", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sb_forest_house');
	catalog.AddWorld("_24", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mudwell');
	catalog.AddWorld("_25", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'popiels_tower');
	catalog.AddWorld("_26", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'Dungeon 5');
	catalog.AddWorld("_27", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'nml_hangman_tree');
	catalog.AddWorld("_28", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'hangmans_ave');
	catalog.AddWorld("_29", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'wagon_top');
	catalog.AddWorld("_30", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'heatherton_village');
	catalog.AddWorld("_31", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fort_mar');
	catalog.AddWorld("_32", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fortfified_farmstead');
	catalog.AddWorld("_33", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'crossroads_inn');
	catalog.AddWorld("_34", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'seaside_shack');
	catalog.AddWorld("_35", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'swamp_edge');
	catalog.AddWorld("_36", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'midcopse');
	catalog.AddWorld("_37", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'reef_fort');
	catalog.AddWorld("_38", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'lanka_village');
	catalog.AddWorld("_39", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'marauders_bridge');
	catalog.AddWorld("_40", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mouth_village');
	catalog.AddWorld("_41", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'poppystone');
	catalog.AddWorld("_42", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'novigrad_garrison');
	catalog.AddWorld("_43", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'willows_grove');
	catalog.AddWorld("_44", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'rudnik');
	catalog.AddWorld("_45", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'descent_hunting_lodge');
	catalog.AddWorld("_46", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'doomsday_worshippers');
	catalog.AddWorld("_47", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bald_mountain');
	catalog.AddWorld("_48", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cb_swamp_ruins');
	catalog.AddWorld("_49", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'freckle_hill');
	catalog.AddWorld("_50", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'ladies_of_the_wood');
	catalog.AddWorld("_51", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'toderas_village');
	catalog.AddWorld("_52", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'old_bridge');
	catalog.AddWorld("_53", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'haunted_estate');
	catalog.AddWorld("_54", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'debris_fort');
	catalog.AddWorld("_55", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sacred_circle');

	if (PotP_IsUsingNextGen())
	{
		catalog.AddWorld("_56", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_castle');
	}

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_90", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'crookback_bog');
		catalog.AddWorld("_92", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'honorton');
		catalog.AddWorld("_93", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'mowshurst');
		catalog.AddWorld("_94", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_bridge');
		catalog.AddWorld("_95", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'pellar_hut');
		catalog.AddWorld("_96", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'witch_hut');
		catalog.AddWorld("_97", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'nilfgaardian_camp');
		catalog.AddWorld("_98", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'cestersover');
		catalog.AddWorld("_99", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'fireburst_harbor');
		catalog.AddWorld("_100", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'swamp_bint_harbor');
		catalog.AddWorld("_101", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'aard_cerbin');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_41(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_Novigrad");
	catalog.AddWorld("_01", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'demolished_mansion');
	catalog.AddWorld("_02", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_farmstead');
	catalog.AddWorld("_03", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'retting_ponds');
	catalog.AddWorld("_04", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_arnskrone_castle');
	catalog.AddWorld("_05", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_marsh_village');
	catalog.AddWorld("_06", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_wedding_village');
	catalog.AddWorld("_07", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill_village');
	catalog.AddWorld("_08", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'smugglers_den');
	catalog.AddWorld("_09", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_lighthouse_last_hope');
	catalog.AddWorld("_10", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'rocky_pass');
	catalog.AddWorld("_11", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'goose_cunt_inn');
	catalog.AddWorld("_12", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill');
	catalog.AddWorld("_13", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noonwraith_tower');
	catalog.AddWorld("_14", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_dragon_valley_outpost');
	catalog.AddWorld("_15", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_isle_round_square');
	catalog.AddWorld("_16", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_forest_village');
	catalog.AddWorld("_17", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'philippa_ruins');
	catalog.AddWorld("_18", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'eternal_fire_chapel');
	catalog.AddWorld("_19", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_road_to_olgiers');
	catalog.AddWorld("_20", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_southeast_gate_1');
	catalog.AddWorld("_21", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_south_gate_2');
	catalog.AddWorld("_22", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_grainfields');
	catalog.AddWorld("_23", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ruin_village');
	catalog.AddWorld("_24", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_herbalist');
	catalog.AddWorld("_25", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'triss_house');
	catalog.AddWorld("_26", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noblemans_estate');
	catalog.AddWorld("_27", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hunters_hut');
	catalog.AddWorld("_28", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'midget_forgers');
	catalog.AddWorld("_29", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_kilkerin');
	catalog.AddWorld("_30", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'grassy_knoll_lighthouse');
	catalog.AddWorld("_31", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dwarven_woodchucks');
	catalog.AddWorld("_32", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'lucjans_windmill');
	catalog.AddWorld("_33", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'plantation_estate');
	catalog.AddWorld("_34", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'vacant_estate');
	catalog.AddWorld("_35", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_piers');
	catalog.AddWorld("_36", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_east');
	catalog.AddWorld("_37", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_2');
	catalog.AddWorld("_38", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_harbor');
	catalog.AddWorld("_39", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_shouth_gate_1');
	catalog.AddWorld("_40", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyards');
	catalog.AddWorld("_41", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'seven_cats_inn');
	catalog.AddWorld("_42", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_1');
	catalog.AddWorld("_43", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_bridge_south');
	catalog.AddWorld("_44", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'roches_camp');
	catalog.AddWorld("_45", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'nov_main_gate');
	catalog.AddWorld("_46", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ofir_camp');
	catalog.AddWorld("_47", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ursten');
	catalog.AddWorld("_48", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dawn_estate_entrance');
	catalog.AddWorld("_49", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hilltop');
	catalog.AddWorld("_50", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_von_everecs_mansion');
	catalog.AddWorld("_51", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_west');
	catalog.AddWorld("_52", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'cropfields');
	catalog.AddWorld("_53", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'widow_cave');
	catalog.AddWorld("_54", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyard_farmstead');
	catalog.AddWorld("_55", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'Slone_village');
	catalog.AddWorld("_56", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_zutzer_castle');

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_88", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'barrengarth');
		catalog.AddWorld("_89", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'crippled_kate');
		catalog.AddWorld("_90", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'farcorners');
		catalog.AddWorld("_91", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_gildorf');
		catalog.AddWorld("_92", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_harborside');
		catalog.AddWorld("_93", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'hattori_workshop');
		catalog.AddWorld("_94", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bridge');
		catalog.AddWorld("_95", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_academy');
		catalog.AddWorld("_96", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'passiflora');
		catalog.AddWorld("_97", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'bathhouse');
		catalog.AddWorld("_98", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_silverton');
		catalog.AddWorld("_99", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bits');
		catalog.AddWorld("_100", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'vilmerius_hospital');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_42(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_Skellige");
	catalog.AddWorld("_01", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'abandoned_lumber_mill');
	catalog.AddWorld("_02", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_2');
	catalog.AddWorld("_03", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'elven_vault');
	catalog.AddWorld("_04", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arinbjorn');
	catalog.AddWorld("_05", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rocky_bay');
	catalog.AddWorld("_06", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'blandare_village');
	catalog.AddWorld("_07", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ravens_home_ruins');
	catalog.AddWorld("_08", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'kaer_trolde_bridge');
	catalog.AddWorld("_09", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_blacksmith');
	catalog.AddWorld("_10", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'stolen_road');
	catalog.AddWorld("_11", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'distillery');
	catalog.AddWorld("_12", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ice_giant_village');
	catalog.AddWorld("_13", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'druid_camp');
	catalog.AddWorld("_14", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'northern_torch');
	catalog.AddWorld("_15", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'southern_torch');
	catalog.AddWorld("_16", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fayrlund');
	catalog.AddWorld("_17", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'halgrims_village');
	catalog.AddWorld("_18", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'herbarium');
	catalog.AddWorld("_19", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fyresdal');
	catalog.AddWorld("_20", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holy_oak');
	catalog.AddWorld("_21", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'giants_foot');
	catalog.AddWorld("_22", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arsehole_cave');
	catalog.AddWorld("_23", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_vantage_point');
	catalog.AddWorld("_24", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor');
	catalog.AddWorld("_25", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holmstein_harbor');
	catalog.AddWorld("_26", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_arena_village');
	catalog.AddWorld("_27", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'huindarsfjal_destroyed_farmstead');
	catalog.AddWorld("_28", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'prison_island');
	catalog.AddWorld("_29", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fort_gelen');
	catalog.AddWorld("_30", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lugos_keep');
	catalog.AddWorld("_31", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'craite_harbor');
	catalog.AddWorld("_32", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'larvik');
	catalog.AddWorld("_33", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofotten');
	catalog.AddWorld("_34", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofoten_cemetery');
	catalog.AddWorld("_35", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lurthen');
	catalog.AddWorld("_36", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_shore_harbor');
	catalog.AddWorld("_37", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'miners_camp');
	catalog.AddWorld("_38", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_ruins');
	catalog.AddWorld("_39", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ancient_perimeter');
	catalog.AddWorld("_40", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rannvaig');
	catalog.AddWorld("_41", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'redgill');
	catalog.AddWorld("_42", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ragnar_village');
	catalog.AddWorld("_43", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_roast_kipper_tavern');
	catalog.AddWorld("_44", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'sheperd_huts');
	catalog.AddWorld("_45", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_harbor');
	catalog.AddWorld("_46", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_avallach_lab');
	catalog.AddWorld("_47", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_ridge');
	catalog.AddWorld("_48", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor_2');
	catalog.AddWorld("_49", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'an_skellig_harbor');
	catalog.AddWorld("_50", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_3');
	catalog.AddWorld("_51", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'whaleyard');
	catalog.AddWorld("_52", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'wild_shores');
	catalog.AddWorld("_53", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ridgetop');
	catalog.AddWorld("_54", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'skellige_tomb_3');

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_90", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'ard_hugtand');
		catalog.AddWorld("_91", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'castle_tuirseach');
		catalog.AddWorld("_92", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_dhu');
		catalog.AddWorld("_93", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_nyssen');
		catalog.AddWorld("_94", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_trolde_village');
		catalog.AddWorld("_95", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'melusine_cave');
		catalog.AddWorld("_96", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'snidhall_isle');
		catalog.AddWorld("_97", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'hemdall_shrine');
		catalog.AddWorld("_98", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'holmstein_village');
		catalog.AddWorld("_99", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'sq210_tower');
		catalog.AddWorld("_100", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'old_bridge_mod');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_43(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen");
	catalog.AddWorld("_01", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_eye');
	catalog.AddWorld("_02", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_mine_dam');
	catalog.AddWorld("_03", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'kaer_morhen_entrance');
	catalog.AddWorld("_04", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'lake_house');
	catalog.AddWorld("_05", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'km_outpost_ruins');

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_06", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'chort_cave');
		catalog.AddWorld("_07", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'circle_of_elements');
		catalog.AddWorld("_08", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_courtyard');
		catalog.AddWorld("_09", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_valley');
		catalog.AddWorld("_10", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'trials_cave');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_44(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_World, "PotP_Preview_SignP_6", PotP_A_World, "PotP_TrackingGroup_WorldMap_Signposts_Toussaint");
	catalog.AddWorld("_01", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ardaiso_quarry_ft');
	catalog.AddWorld("_02", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'swamps_ft');
	catalog.AddWorld("_03", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lake_village_ft');
	catalog.AddWorld("_04", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_palace_ft');
	catalog.AddWorld("_05", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_harbor_ft');
	catalog.AddWorld("_06", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'belgard_vineyard_ft');
	catalog.AddWorld("_07", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'castel_ravello_ft');
	catalog.AddWorld("_08", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'casteldaccia_vineyard_ft');
	catalog.AddWorld("_09", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'longhollow_ft');
	catalog.AddWorld("_10", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_north_gate_ft');
	catalog.AddWorld("_11", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'coronata_vineyard_ft');
	catalog.AddWorld("_12", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'corvo_bianco_ft');
	catalog.AddWorld("_13", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'watermill_ft');
	catalog.AddWorld("_14", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmill_west_ft');
	catalog.AddWorld("_15", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_ft');
	catalog.AddWorld("_16", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'northern_dun_tynne_crossing_ft');
	catalog.AddWorld("_17", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_vineyards_ft');
	catalog.AddWorld("_18", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'flovive_ft');
	catalog.AddWorld("_19", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'abandoned_castle_ft');
	catalog.AddWorld("_20", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_ruins_ft');
	catalog.AddWorld("_21", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'fox_hollow_ft');
	catalog.AddWorld("_22", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'francollarts_ft');
	catalog.AddWorld("_23", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'gelenser_farmstead_ft');
	catalog.AddWorld("_24", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'harbour_gate_ft');
	catalog.AddWorld("_25", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ronneville_ft');
	catalog.AddWorld("_26", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'temple_gate_ft');
	catalog.AddWorld("_27", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_cemetery_ft');
	catalog.AddWorld("_28", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_east_gate_ft');
	catalog.AddWorld("_29", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'mont_crane_ft');
	catalog.AddWorld("_30", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'upper_city_harbor_ft');
	catalog.AddWorld("_31", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'palace_gardens_ft');
	catalog.AddWorld("_32", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'vermentino_vineyard_ft');
	catalog.AddWorld("_33", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'feet_of_lebioda_ft');
	catalog.AddWorld("_34", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'sawmill_village_ft');
	catalog.AddWorld("_35", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lower_city_ft');
	catalog.AddWorld("_36", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmills_ft');
	catalog.AddWorld("_37", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'elven_ruins_ft');
	catalog.AddWorld("_38", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'termes_ruins_ft');
	catalog.AddWorld("_39", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tesham_mutna_ft');
	catalog.AddWorld("_40", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'cockatrice_inn_ft');
	catalog.AddWorld("_41", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'main_square_ft');
	catalog.AddWorld("_42", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'village_by_swamp_ft');
	catalog.AddWorld("_43", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tournament_meadows_ft');
	catalog.AddWorld("_44", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'prison_island_ft');
	catalog.AddWorld("_45", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'merchants_camp_ft');
	catalog.AddWorld("_46", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'trastamara_mansion_ft');

	if (PotP_UsingFastTravelPack())
	{
		catalog.AddWorld("_90", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'abandoned_storehouse');
		catalog.AddWorld("_91", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'bastoy_prison_ruins');
		catalog.AddWorld("_92", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'doren_alma_estate');
		catalog.AddWorld("_93", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lac_celavy');
		catalog.AddWorld("_94", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lafargue_workshop');
		catalog.AddWorld("_95", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'belles');
		catalog.AddWorld("_96", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'vermentino_vineyard');
		catalog.AddWorld("_97", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'villa_vedette');
	}
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineWorld_45(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_1", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_WhiteOrchard");
		catalog.AddWorld("_01", PotP_R_WO, PotP_I_Stash, PotP_E_Primary, 'prolog_player_stash');

		catalog.AddWorld("_02", PotP_R_WO, PotP_I_Stash, PotP_E_ModAdded, 'wo_nilfgaardian_garrison');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_46(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_2", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_Velen");
		catalog.AddWorld("_01", PotP_R_VE, PotP_I_Stash, PotP_E_Primary, 'player_stash_velen');

		catalog.AddWorld("_02", PotP_R_VE, PotP_I_Stash, PotP_E_ModAdded, 've_plague_pit');
		catalog.AddWorld("_03", PotP_R_VE, PotP_I_Stash, PotP_E_ModAdded, 've_inn_at_the_crossroads');
		catalog.AddWorld("_04", PotP_R_VE, PotP_I_Stash, PotP_E_ModAdded, 've_keira_metz_house');
		catalog.AddWorld("_05", PotP_R_VE, PotP_I_Stash, PotP_E_ModAdded, 've_nilfgaardian_camp');
		catalog.AddWorld("_06", PotP_R_VE, PotP_I_Stash, PotP_E_ModAdded, 've_reardon_manor');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_47(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_3", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_Novigrad");
		catalog.AddWorld("_04", PotP_R_NO, PotP_I_Stash, PotP_E_Primary, 'player_stash_novigrad');

		catalog.AddWorld("_01", PotP_R_NO, PotP_I_Stash, PotP_E_ModAdded, 'no_hattori_workshop');
		catalog.AddWorld("_02", PotP_R_NO, PotP_I_Stash, PotP_E_ModAdded, 'no_midgetforgers');
		catalog.AddWorld("_03", PotP_R_NO, PotP_I_Stash, PotP_E_ModAdded, 'ox_oxenfurt_armorer');
		catalog.AddWorld("_05", PotP_R_NO, PotP_I_Stash, PotP_E_ModAdded, 'no_runewright');
		catalog.AddWorld("_06", PotP_R_NO, PotP_I_Stash, PotP_E_ModAdded, 'no_temerian_hideout');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_48(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_4", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_Skellige");
		catalog.AddWorld("_06", PotP_R_SK, PotP_I_Stash, PotP_E_Primary, 'skellige_player_stash');

		catalog.AddWorld("_01", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_gremistalab');
		catalog.AddWorld("_02", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_faroe');
		catalog.AddWorld("_03", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_kaer_muire');
		catalog.AddWorld("_04", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_hindarsfjall');
		catalog.AddWorld("_05", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_undvik');
		catalog.AddWorld("_07", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_spikeroog');
		catalog.AddWorld("_08", PotP_R_SK, PotP_I_Stash, PotP_E_ModAdded, 'sk_anskellig');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_49(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_5", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_KaerMorhen");
		catalog.AddWorld("_01", PotP_R_KM, PotP_I_Stash, PotP_E_Primary, 'km_player_stash');

		catalog.AddWorld("_02", PotP_R_KM, PotP_I_Stash, PotP_E_ModAdded, 'km_ruined_watchtower');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_50(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_6", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_Toussaint");
		catalog.AddWorld("_03", PotP_R_TO, PotP_I_Stash, PotP_E_Primary, 'mq7024_player_stash');

		catalog.AddWorld("_01", PotP_R_TO, PotP_I_Stash, PotP_E_ModAdded, 'to_ardaiso_quarry');
		catalog.AddWorld("_02", PotP_R_TO, PotP_I_Stash, PotP_E_ModAdded, 'to_castel_ravello');
		catalog.AddWorld("_04", PotP_R_TO, PotP_I_Stash, PotP_E_ModAdded, 'to_francollarts');
		catalog.AddWorld("_05", PotP_R_TO, PotP_I_Stash, PotP_E_ModAdded, 'to_lafargue_workshop');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineWorld_51(catalog: CPotP_Catalog)
{
	if (PotP_UsingExtraStashes())
	{
		catalog.BeginSection(PotP_Book_World, "PotP_Preview_Stash_7", PotP_A_World, "PotP_TrackingGroup_WorldMap_PlayerStashes_Vizima");
		catalog.AddWorld("_01", PotP_R_VI, PotP_I_Stash, PotP_E_ModAdded, 'wc_yennefers_study');
		catalog.EndSection();
	}
}
