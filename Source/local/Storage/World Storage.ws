//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_WorldStorage
{		
	var MasterList_World			:array<PotP_PreviewEntry>;
	
	var AbandonedSites_WhiteOrchard	: array<PotP_PreviewEntry>;
	var AbandonedSites_Velen		: array<PotP_PreviewEntry>;
	var AbandonedSites_Novigrad		: array<PotP_PreviewEntry>;
	var AbandonedSites_Skellige		: array<PotP_PreviewEntry>;
	var AbandonedSites_Toussaint	: array<PotP_PreviewEntry>;
	
	var BanditCamps_WhiteOrchard	: array<PotP_PreviewEntry>;
	var BanditCamps_Velen			: array<PotP_PreviewEntry>;
	var BanditCamps_Novigrad		: array<PotP_PreviewEntry>;
	var BanditCamps_Skellige		: array<PotP_PreviewEntry>;
	var BanditCamps_Toussaint		: array<PotP_PreviewEntry>;
	
	var GuardedTreasure_WhiteOrchard	: array<PotP_PreviewEntry>;
	var GuardedTreasure_Velen			: array<PotP_PreviewEntry>;
	var GuardedTreasure_Novigrad		: array<PotP_PreviewEntry>;
	var GuardedTreasure_Skellige		: array<PotP_PreviewEntry>;
	var GuardedTreasure_KaerMorhen		: array<PotP_PreviewEntry>;
	var GuardedTreasure_Toussaint		: array<PotP_PreviewEntry>;
	
	var DistressedKnights_Toussaint	: array<PotP_PreviewEntry>;
	var InfestedVineyards_Toussaint	: array<PotP_PreviewEntry>;
	var HanseBases					: array<PotP_PreviewEntry>;
	
	var MonsterDens_Velen			: array<PotP_PreviewEntry>;
	var MonsterDens_Novigrad		: array<PotP_PreviewEntry>;
	var MonsterDens_Skellige		: array<PotP_PreviewEntry>;
	var MonsterDens_Toussaint		: array<PotP_PreviewEntry>;

	var MonsterNests_WhiteOrchard	: array<PotP_PreviewEntry>;
	var MonsterNests_Velen			: array<PotP_PreviewEntry>;
	var MonsterNests_Novigrad		: array<PotP_PreviewEntry>;
	var MonsterNests_Skellige		: array<PotP_PreviewEntry>;
	var MonsterNests_Toussaint		: array<PotP_PreviewEntry>;

	var PersonsInDistress_Velen		: array<PotP_PreviewEntry>;
	var PersonsInDistress_Skellige	: array<PotP_PreviewEntry>;
	var PersonsInDistress_Toussaint	: array<PotP_PreviewEntry>;
	
	var PlacesOfPower_WhiteOrchard	: array<PotP_PreviewEntry>;
	var PlacesOfPower_Velen			: array<PotP_PreviewEntry>;
	var PlacesOfPower_Novigrad		: array<PotP_PreviewEntry>;
	var PlacesOfPower_Skellige		: array<PotP_PreviewEntry>;
	var PlacesOfPower_KaerMorhen	: array<PotP_PreviewEntry>;
	var PlacesOfPower_Toussaint		: array<PotP_PreviewEntry>;
	var PlacesOfPower_TheSpiral		: array<PotP_PreviewEntry>;

	var Signposts_WhiteOrchard		: array<PotP_PreviewEntry>;
	var Signposts_Velen				: array<PotP_PreviewEntry>;
	var Signposts_Novigrad			: array<PotP_PreviewEntry>;
	var Signposts_Skellige			: array<PotP_PreviewEntry>;
	var Signposts_KaerMorhen		: array<PotP_PreviewEntry>;
	var Signposts_Toussaint			: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP World Storage';

//---------------------------------------------------
	
	function inititalise()
	{
		this.GotoState('Build');
	}
	
//---------------------------------------------------
	
	function CreateEntry() : PotP_PreviewEntry
	{
		return new PotP_PreviewEntry in this; 
	}

//---------------------------------------------------

	function CreateUniqueIdentifier() : string 
	{
		UUIDINT += 1;
		return "WX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_WorldStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Build State ------------------------------------
//---------------------------------------------------
	
state Build in CProgressOnThePath_WorldStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	

	entry function Build()
	{
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MasterList_World.Clear();
		
		this.Build_Sites();
		this.Build_Camp();
		this.Build_Guard();
		this.Build_Dens();
		this.Build_Nest();
		this.Build_Plac();
		this.Build_Distr();
		this.Build_Sign();
		this.Build_Toussaint();

		for ( Idx = 0; Idx < parent.MasterList_World.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_World[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_World[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_World[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_World[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_World[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_World[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_World[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Toussaint()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_DistressedKnights_Toussaint";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.DistressedKnights_Toussaint.Clear();
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_bar_a_12_mp'));     
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_a_09_mp')); 
		parent.DistressedKnights_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Knigh, PotP_E_Primary, 'poi_gor_d_07_mp')); 
		
		PotP_SortPreviewData(parent.DistressedKnights_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_InfestedVineyards_Toussaint";
		
		parent.InfestedVineyards_Toussaint.Clear();
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_01_mp'));     
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_dun_a_02_mp'));
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'poi_vin_a_02_mp')); 		
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_poi_ww_cor_1_mp')); 		
		parent.InfestedVineyards_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Infes, PotP_E_Primary, 'lw_ww_poi_bel_9_mp')); 				
		
		PotP_SortPreviewData(parent.InfestedVineyards_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_HanseBases_Toussaint";
		
		parent.HanseBases.Clear();
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_bar_a_01_mp'));     
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_gor_d_05_mp'));
		parent.HanseBases.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Hanse, PotP_E_Primary, 'poi_ved_a_01_mp')); 							
		
		PotP_SortPreviewData(parent.HanseBases, PotP_A_World, master);
		
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Sites()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_AbandonedSites_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.AbandonedSites_WhiteOrchard.Clear();
		parent.AbandonedSites_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'lumbermill_camp_mp'));     
		parent.AbandonedSites_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Sites, PotP_E_Primary, 'road_protection_shrine')); 
		
		PotP_SortPreviewData(parent.AbandonedSites_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Velen";
		
		parent.AbandonedSites_Velen.Clear();
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_de29'));     
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'cp5_town_resc'));
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr11_b')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr12_town')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_gr27')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb10')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb14')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_sb3')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm3')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'nml_mp_tm4')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_08_mp_rt')); 		
		parent.AbandonedSites_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_30_mp')); 				
		
		PotP_SortPreviewData(parent.AbandonedSites_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Novigrad";
		
		parent.AbandonedSites_Novigrad.Clear();
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi20_mp'));     
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi_37_mp'));
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi07_mp')); 		
		parent.AbandonedSites_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Sites, PotP_E_Primary, 'ep1_poi06_mp')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Skellige";
		
		parent.AbandonedSites_Skellige.Clear();
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk34_mp'));     
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk33_mp'));
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk52_mp_skellige')); 		
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk75_mp_skellige')); 					
		parent.AbandonedSites_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Sites, PotP_E_Primary, 'sk51_mp_skellige')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_AbandonedSites_Toussaint";
		
		parent.AbandonedSites_Toussaint.Clear();
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_a_03_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_bar_b_04_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_car_b_03_mp')); 		
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_b_12_mp')); 	
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_c_03_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_gor_d_06_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'poi_ved_a_02_mp')); 		
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_cor_2_mp')); 	
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_10_mp'));     
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_poi_ww_ver_12_mp'));
		parent.AbandonedSites_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Sites, PotP_E_Primary, 'lw_ww_poi_bel_5_mp')); 					
		
		PotP_SortPreviewData(parent.AbandonedSites_Toussaint, PotP_A_World, master);
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Camp()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.BanditCamps_WhiteOrchard.Clear();
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_camp'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire2')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire3')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_road'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire'));  
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_sanctuary'));
		
		PotP_SortPreviewData(parent.BanditCamps_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Skellige";
		
		parent.BanditCamps_Skellige.Clear();
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk10_mp_giantfoot_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk16_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk28_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk36_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk111_mp_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk86_mp_skl'));
		
		PotP_SortPreviewData(parent.BanditCamps_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint";
		
		parent.BanditCamps_Toussaint.Clear();
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_17_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_09_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_07_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_car_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_18_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_b_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_07_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_13_mp_ban'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_a_09_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_12_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_vin_b_06_mp'));
		
		PotP_SortPreviewData(parent.BanditCamps_Toussaint, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad";
		
		parent.BanditCamps_Novigrad.Clear();
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gf42'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_hs16'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi17_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'gf203_mp_nml'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi16_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi23_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi09_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi_ofir_camp_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi11_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi12_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi13_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi14_mp'));
		
		PotP_SortPreviewData(parent.BanditCamps_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Velen";
		
		parent.BanditCamps_Velen.Clear();
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cb18'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_bm2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de101'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de102'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de25'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gr31'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'pit_camp_nml_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'mp2_nml_mappin'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cp37'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb23'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb30'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb20'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb12'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb5'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb7_camp_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb5b_mp_nml_yet'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb7'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb18'));
		
		PotP_SortPreviewData(parent.BanditCamps_Velen, PotP_A_World, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Guard()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_GuardedTreasure_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.GuardedTreasure_WhiteOrchard.Clear();
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'beached_boats'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'boat_wreck'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'cemetary_wraith'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'dead_horses_prologue'));
		parent.GuardedTreasure_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Guard, PotP_E_Primary, 'waterhag_mappin'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Velen";
		
		parent.GuardedTreasure_Velen.Clear();
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_a'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm1_b'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm3'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_bm4'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cb19'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp11'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp14'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp36'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_cp38'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr100'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gr15b_mp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'gf204_mp_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_mp5'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_wraith_nml_sp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb11'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb19'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_sb24_swamp'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'de100_mp_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_de27'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm100'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm101'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'mp_tm201_nml'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'nml_mp_tm5'));
		parent.GuardedTreasure_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_VE, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_33_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Novigrad";
		
		parent.GuardedTreasure_Novigrad.Clear();
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'hs22_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_gr33'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'nml_mp_hs11'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf202_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf200_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'gf201_mp_nml'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_24_mp'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi03_mp'));
		parent.GuardedTreasure_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Guard, PotP_E_Primary, 'ep1_poi_35_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Novigrad, PotP_A_World, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Skellige";

		parent.GuardedTreasure_Skellige.Clear();
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk1_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk18_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk22_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk23_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk26_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk27_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk32_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk37_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk46_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk72_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk7_mp'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk110_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk106_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk151_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk105_mp_skellige'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk76_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk78_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk79_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk80a_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk81_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk82_mp_skl'));
		parent.GuardedTreasure_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_SK, PotP_I_Guard, PotP_E_Primary, 'sk90_mp_skl'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Skellige, PotP_A_World, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_KaerMorhen";
		
		parent.GuardedTreasure_KaerMorhen.Clear();
		parent.GuardedTreasure_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_leshy'));
		parent.GuardedTreasure_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_KM, PotP_I_Guard, PotP_E_Primary, 'km_poi_wyvern'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_KaerMorhen, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_GuardedTreasure_Toussaint";
		
		parent.GuardedTreasure_Toussaint.Clear();
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_02_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_08_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_09_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_bar_a_11_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_05_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_car_a_07_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_dun_b_08_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_a_08_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_d_17_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_gor_d_19_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_04_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_san_b_06_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_ved_a_07_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_ved_a_08_mp_post'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'poi_vin_b_04_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_cor_5_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_poi_ww_ver_9_mp'));
		parent.GuardedTreasure_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_TO, PotP_I_Guard, PotP_E_Primary, 'lw_ww_poi_bel_6_mp'));
		
		PotP_SortPreviewData(parent.GuardedTreasure_Toussaint, PotP_A_World, master);		
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Dens()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterDens_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MonsterDens_Velen.Clear();
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gr38'));
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de24'));
		
		PotP_SortPreviewData(parent.MonsterDens_Velen, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad";
		
		parent.MonsterDens_Novigrad.Clear();
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gf2'));
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de30'));
		
		PotP_SortPreviewData(parent.MonsterDens_Novigrad, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Skellige";
		
		parent.MonsterDens_Skellige.Clear();
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk12_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk25_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk60_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk86_mp'));
		
		PotP_SortPreviewData(parent.MonsterDens_Skellige, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint";
		
		parent.MonsterDens_Toussaint.Clear();
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_05_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_ved_a_04_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_dun_a_04_cave_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_gor_b_11_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_14_mp'));
		
		PotP_SortPreviewData(parent.MonsterDens_Toussaint, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Nest()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MonsterNests_WhiteOrchard.Clear();
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_hengestone_ghoulnest_pin'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_monster_nest_ghoul5'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_ghouls_nest01'));
		
		PotP_SortPreviewData(parent.MonsterNests_WhiteOrchard, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Velen";
		
		parent.MonsterNests_Velen.Clear();
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr36_nekkers_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr16_pc_nest_rotfiend'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr28_harpynest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_mp4_rotfiend_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_boss'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp34_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'nml_cp5_nest_mp'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'de8_nekker_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_4'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_2'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_02'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp21_drowner_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'bm7_drowners_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'hs13_rotfiend_nest'));		
		
		PotP_SortPreviewData(parent.MonsterNests_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad";
		
		parent.MonsterNests_Novigrad.Clear();
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_34_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'lw_nest_ep1_poi_31_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_19_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi32_nest'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest01'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest02'));	
		
		PotP_SortPreviewData(parent.MonsterNests_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Skellige";
		
		parent.MonsterNests_Skellige.Clear();
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk15_drowner_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk14_nest_sirens'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk74_harpy_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk75_siren_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk_poi_107_nest'));
		
		PotP_SortPreviewData(parent.MonsterNests_Skellige, PotP_A_World, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint";
		
		parent.MonsterNests_Toussaint.Clear();
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_01'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_02'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_gor_b_13_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_b_05_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_dun_a_04_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_a_03_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_car_b_09_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'lw_ww_poi_bel_8_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_b_07_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_a_13_nest'));
		
		PotP_SortPreviewData(parent.MonsterNests_Toussaint, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Plac()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.PlacesOfPower_WhiteOrchard.Clear();
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_ignii_prologue_01'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_axii_prologue_04'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_aard_prologue_02'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_quen_prologue_03'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'pop_quen2_prlg'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_yrden_prologue_05'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_WhiteOrchard, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen";
		
		parent.PlacesOfPower_Velen.Clear();
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_ignii2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_aard'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'lw_ancient_castle_pop'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_quen2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_yrden2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_yrden'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad";
		
		parent.PlacesOfPower_Novigrad.Clear();
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_axii'));
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_ignii'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige";
		
		parent.PlacesOfPower_Skellige.Clear();
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_ignii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_mp_igniii_skellige'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_axii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_axii'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_aard'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Place, PotP_E_Missable, 'skl_pop_quen2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_quen_skellige_mp'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_yrden2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_yrden_mp_skellige'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Skellige, PotP_A_World, master);		

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen";
		
		parent.PlacesOfPower_KaerMorhen.Clear();
		parent.PlacesOfPower_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Place, PotP_E_Primary, 'km_mp_pop_igniii'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_KaerMorhen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint";
		
		parent.PlacesOfPower_Toussaint.Clear();
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_igni_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_axii_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_aard_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_quen_0002'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_yrden_0002'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_Toussaint, PotP_A_World, master);	
		
		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral";
		
		parent.PlacesOfPower_TheSpiral.Clear();
		parent.PlacesOfPower_TheSpiral.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TS, PotP_I_Place, PotP_E_Missable, 	'aard_gasforest'));
		
		PotP_SortPreviewData(parent.PlacesOfPower_TheSpiral, PotP_A_World, master);	
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Distr()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.PersonsInDistress_Velen.Clear();
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_cp13'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr13'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_gr29'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_hs2'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'nml_mp_tm12'));
		parent.PersonsInDistress_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Distr, PotP_E_Primary, 'ep1_pan_dziedzina_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Velen, PotP_A_World, master);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Skellige";
		
		parent.PersonsInDistress_Skellige.Clear();
		parent.PersonsInDistress_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk29_mp'));
		parent.PersonsInDistress_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Distr, PotP_E_Primary, 'sk90_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Skellige, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_PersonsInDistress_Toussaint";
		
		parent.PersonsInDistress_Toussaint.Clear();
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_bar_a_02_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'poi_ved_a_05_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_cor_3_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_poi_ww_ver_11_mp'));
		parent.PersonsInDistress_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Distr, PotP_E_Primary, 'lw_ww_poi_bel_7_mp'));
		
		PotP_SortPreviewData(parent.PersonsInDistress_Toussaint, PotP_A_World, master);	
	}
	
	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Sign()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.Signposts_KaerMorhen.Clear();
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_eye'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_mine_dam'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'kaer_morhen_entrance'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'lake_house'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'km_outpost_ruins'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{ 
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'chort_cave'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'circle_of_elements'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_courtyard'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_valley'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'trials_cave'));
		}

		PotP_SortPreviewData(parent.Signposts_KaerMorhen, PotP_A_World, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Novigrad";
		
		parent.Signposts_Novigrad.Clear();
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'demolished_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'retting_ponds'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_arnskrone_castle'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_marsh_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_wedding_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'smugglers_den'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_lighthouse_last_hope'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'rocky_pass'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'goose_cunt_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noonwraith_tower'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_dragon_valley_outpost'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_isle_round_square'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_forest_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'philippa_ruins'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'eternal_fire_chapel'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_road_to_olgiers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_southeast_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_south_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_grainfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ruin_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_herbalist'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'triss_house'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noblemans_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hunters_hut'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'midget_forgers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_kilkerin'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'grassy_knoll_lighthouse'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dwarven_woodchucks'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'lucjans_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'plantation_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'vacant_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_piers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_east'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_harbor'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_shouth_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyards'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'seven_cats_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_bridge_south'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'roches_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'nov_main_gate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ofir_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ursten'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dawn_estate_entrance'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hilltop'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_von_everecs_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_west'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'cropfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'widow_cave'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyard_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_55", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'Slone_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_56", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_zutzer_castle'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_88", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'barrengarth'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_89", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'crippled_kate'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'farcorners'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_gildorf'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_harborside'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'hattori_workshop'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bridge'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_academy'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'passiflora'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'bathhouse'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_98", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_silverton'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_99", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bits'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Novigrad, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Skellige";
		
		parent.Signposts_Skellige.Clear();
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'abandoned_lumber_mill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'elven_vault'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arinbjorn'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rocky_bay'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'blandare_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ravens_home_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'kaer_trolde_bridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_blacksmith'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'stolen_road'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'distillery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ice_giant_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'druid_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'northern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'southern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fayrlund'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'halgrims_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'herbarium'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fyresdal'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holy_oak'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'giants_foot'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arsehole_cave'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_vantage_point'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holmstein_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_arena_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'huindarsfjal_destroyed_farmstead'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'prison_island'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fort_gelen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lugos_keep'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'craite_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'larvik'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofotten'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofoten_cemetery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lurthen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_shore_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'miners_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ancient_perimeter'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rannvaig'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'redgill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ragnar_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_roast_kipper_tavern'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'sheperd_huts'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_avallach_lab'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_ridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'an_skellig_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_3'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'whaleyard'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'wild_shores'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ridgetop'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'skellige_tomb_3'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'ard_hugtand'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'castle_tuirseach'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_dhu'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_nyssen'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_trolde_village'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'melusine_cave'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'snidhall_isle'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'hemdall_shrine'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Skellige, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard";
		
		parent.Signposts_WhiteOrchard.Clear();
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'well_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Broken_bridge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'bridge_gate'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Crossroads'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'River_crossing'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Windmill'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Nilfgaard_camp'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'ransacked_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woodcutters_lodge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woesong_bridge'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_WO, PotP_I_Signs, PotP_E_ModAdded, 'king_desmond_bridge'));
		}
		
		PotP_SortPreviewData(parent.Signposts_WhiteOrchard, PotP_A_World, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Toussaint";
		
		parent.Signposts_Toussaint.Clear();
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ardaiso_quarry_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'swamps_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lake_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_palace_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'belgard_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'castel_ravello_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'casteldaccia_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'longhollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_north_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'coronata_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'corvo_bianco_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'watermill_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmill_west_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'northern_dun_tynne_crossing_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_vineyards_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'flovive_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'abandoned_castle_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'fox_hollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'francollarts_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'gelenser_farmstead_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'harbour_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ronneville_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'temple_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_cemetery_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_east_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'mont_crane_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'upper_city_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'palace_gardens_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'vermentino_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'feet_of_lebioda_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'sawmill_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lower_city_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmills_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'elven_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'termes_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tesham_mutna_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'cockatrice_inn_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'main_square_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'village_by_swamp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tournament_meadows_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'prison_island_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'merchants_camp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'trastamara_mansion_ft'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'abandoned_storehouse'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_91", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'bastoy_prison_ruins'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'doren_alma_estate'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lac_celavy'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lafargue_workshop'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'belles'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'vermentino_vineyard'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'villa_vedette'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Toussaint, PotP_A_World, master);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Velen";
		
		parent.Signposts_Velen.Clear();
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_01", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cp_abandoned_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_02", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'incredibly_big_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_03", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_slaver_camp'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_04", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'benek_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_05", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'snots_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_06", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'boatmakers_hut'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_07", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'halver_isle'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_08", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'burned_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_09", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_brickmakers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_10", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'glinsk_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_11", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'shipwreck_shore'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_12", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'stray_kings_quarry'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_13", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'massacred_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_14", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'road_to_baldenfort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_15", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_yard'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_16", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'baldenfort_bastion'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_17", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'plague_pit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_18", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'downwarren'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_19", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'griffin_dungeon_exit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_20", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_deserted_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_21", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'roadside_chapel'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_22", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bayors_ferry_station'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_23", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sb_forest_house'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_24", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mudwell'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_25", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'popiels_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_26", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'Dungeon 5'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_27", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'nml_hangman_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_28", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'hangmans_ave'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_29", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'wagon_top'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_30", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'heatherton_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_31", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fort_mar'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_32", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fortfified_farmstead'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_33", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'crossroads_inn'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_34", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'seaside_shack'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_35", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'swamp_edge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_36", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'midcopse'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_37", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'reef_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_38", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'lanka_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_39", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'marauders_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_40", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mouth_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_41", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'poppystone'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_42", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'novigrad_garrison'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_43", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'willows_grove'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_44", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'rudnik'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_45", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'descent_hunting_lodge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_46", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'doomsday_worshippers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_47", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bald_mountain'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_48", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cb_swamp_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_49", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'freckle_hill'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_50", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'ladies_of_the_wood'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_51", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'toderas_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_52", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'old_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_53", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'haunted_estate'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_54", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'debris_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_55", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sacred_circle'));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_56", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_castle'));
		}
		
		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_90", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'crookback_bog'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_92", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'honorton'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_93", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'mowshurst'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_94", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_bridge'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_95", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'pellar_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_96", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'witch_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(master.PotP_EntityHelper, group + "_97", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'nilfgaardian_camp'));
		}
		
		PotP_SortPreviewData(parent.Signposts_Velen, PotP_A_World, master);	
	}
}

