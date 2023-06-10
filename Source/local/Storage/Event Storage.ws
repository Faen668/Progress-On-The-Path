//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_EventStorage
{		
	var master 						:CProgressOnThePath;
	
	var MasterList_Events			:array<PotP_PreviewEntry>;
	
	var RandomEvents_Velen			: array<PotP_PreviewEntry>;
	var RandomEvents_Novigrad		: array<PotP_PreviewEntry>;
	var RandomEvents_Skellige		: array<PotP_PreviewEntry>;
	var RandomEvents_KaerMorhen		: array<PotP_PreviewEntry>;	
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Event Storage';

//---------------------------------------------------
	
	function inititalise(master: CProgressOnThePath)
	{
		this.master = master;
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
		return "EX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_EventStorage 
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
	
state Build in CProgressOnThePath_EventStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	

	entry function Build()
	{
		var group    : string;
		var Idx, Edx : int;

		parent.MasterList_Events.Clear();

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_RandomEvents_Velen";
		
		parent.RandomEvents_Velen.Clear();
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_1_NG", 	Vector(641.454102, 533.142456)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_CaravanAttack_NG_1", 			Vector(1311.539551, 404.800537)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "no_mans_land", "PotP_Event_CaravanAttack_NG_2", 			Vector(207.837814, 75.866135)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_DeadlyCrossing_3_NG", 			Vector(-29.826519, -101.255219)	)); //Troll Bridge
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "no_mans_land", "PotP_Event_DeadlyCrossing_1_NG", 			Vector(794.722107, 266.272644)	));	//Lindenvale
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_DeadlyCrossing_2_NG", 			Vector(1087.826294, -295.390381))); //Dragonslayer's Grotto
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_FaceMeIfYouDare_1_NG", 		Vector(213.855240, -32.358776)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HarassingATroll_NG", 			Vector(138.532272, 811.463623)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HighwayRobbery_NG", 			Vector(300.595459, -135.326324)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_HighwaymansCache_NG", 			Vector(519.180176, -212.923065)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersHeatherton_NG", 		Vector(151.509430, 508.062775)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersCodgersQuarry_NG", 		Vector(1221.132690, 831.181274)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_LootersToderas_NG", 			Vector(1720.736694, 67.942719)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "no_mans_land", "PotP_Event_MansBestFriend_NG", 			Vector(643.049805, 799.665344)	));
		
		PotP_SortPreviewData(parent.RandomEvents_Velen, PotP_A_Event, parent.master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_Novigrad";
		
		parent.RandomEvents_Novigrad.Clear();
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_AWarmWelcome_NG", 				Vector(1347.046143, 1591.817261)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_2_NG", 	Vector(393.423737, 1265.788696)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_DrunkenRabble_NG", 				Vector(543.444885, 1839.808228)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_2_NG", 			Vector(899.003479, 1732.530640)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_3_NG", 			Vector(505.266266, 1915.563843)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_KarmicJustice_NG", 				Vector(862.002502, 1831.773438)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_NeverTrustChildren_NG", 		Vector(765.527771, 1932.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_RacistsOfNovigradFC_NG", 		Vector(858.879944, 1819.517700)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_RacistsOfNovigradHS_NG", 		Vector(553.651428, 1677.662231)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_StrangersInTheNight_NG", 		Vector(1370.983887, 1507.835815)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_11", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_StrumpetInDistress_NG", 		Vector(411.762390, 1672.084839)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_12", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_SuspiciousShakedown_NG", 		Vector(739.579529, 1761.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_13", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_TheFlameOfHatred_NG_1", 		Vector(714.057678, 1861.176392)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_19", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_TheFlameOfHatred_NG_2", 		Vector(793.164673, 1868.151978)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_14", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_TheMostTruestOfBasilisks_NG", 	Vector(1911.729736, 1141.309082)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_15", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"no_mans_land", "PotP_Event_ThePriceOfPassage_NG_1", 		Vector(1678.246338, 1037.727295)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_17", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_2", 		Vector(1766.244873, 1038.741089)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_18", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_3", 		Vector(1932.989990, 1070.466309)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_16", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "no_mans_land", "PotP_Event_WitchHunterRaids_NG", 			Vector(580.663086, 1569.924316)		));
		
		PotP_SortPreviewData(parent.RandomEvents_Novigrad, PotP_A_Event, parent.master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_Skellige";
		
		parent.RandomEvents_Skellige.Clear();
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_CallOfTheWild_NG", 			Vector(-526.447571, -340.631042)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_FartingTrolls_NG", 			Vector(-283.890625, -769.414673)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_SirensCall_NG", 			Vector(-409.181061, -202.543701)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_SweetBait_NG", 				Vector(-443.542175, -307.774261)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_TheFourFacesOfHemdall_NG", 	Vector(2011.217651, -1851.521729)	));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_WoeIsMe_NG", 				Vector(552.972961, -411.028778)		));
		parent.RandomEvents_Skellige.PushBack(parent.CreateEntry().initEvent(group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Event, true, 	"skellige", "PotP_Event_YustiannaDisturbed_NG", 	Vector(677.762207, 635.591064)		));
		
		PotP_SortPreviewData(parent.RandomEvents_Skellige, PotP_A_Event, parent.master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_KaerMorhen";
		
		parent.RandomEvents_KaerMorhen.Clear();
		parent.RandomEvents_KaerMorhen.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_KM, PotP_I_Event, true, "kaer_morhen", "PotP_Event_TrailOfEchoes_NG", Vector(-327.778656, 175.190674)	));
		
		PotP_SortPreviewData(parent.RandomEvents_KaerMorhen, PotP_A_Event, parent.master);

		//------------------------------------------------------

		for ( Idx = 0; Idx < parent.MasterList_Events.Size(); Idx += 1 ) 
		{
			Edx = parent.master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Events[Idx].uuid);
			
			if (Edx != -1)
			{
				parent.master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Events[Idx];
				parent.master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Events[Idx].uuid;
				parent.master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Events[Idx].identifier;
				continue;
			}

			parent.master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Events[Idx]);
			parent.master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Events[Idx].uuid);
			parent.master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Events[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}
}

