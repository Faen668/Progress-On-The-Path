//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_QuestStorage
{		
	var MasterList_Quests			:array<PotP_PreviewEntry>;
	var MasterList_Quests_Lookup	:array<string>;
	
	var MainQuests_Prologue			: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Velen		: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Novigrad	: array<PotP_PreviewEntry>;
	var MainQuests_Act1_Skellige	: array<PotP_PreviewEntry>;
	var MainQuests_Act2				: array<PotP_PreviewEntry>;
	var MainQuests_Act3				: array<PotP_PreviewEntry>;
	var MainQuests_DLC1				: array<PotP_PreviewEntry>;
	var MainQuests_DLC2				: array<PotP_PreviewEntry>;
	var MainQuests_Vizima			: array<PotP_PreviewEntry>;
	
	var SideQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var SideQuests_Velen			: array<PotP_PreviewEntry>;
	var SideQuests_Novigrad			: array<PotP_PreviewEntry>;
	var SideQuests_Skellige			: array<PotP_PreviewEntry>;
	var SideQuests_KaerMorhen		: array<PotP_PreviewEntry>;
	var SideQuests_Toussaint		: array<PotP_PreviewEntry>;
	var SideQuests_NonRegional		: array<PotP_PreviewEntry>;
	
	var ContQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var ContQuests_Velen			: array<PotP_PreviewEntry>;
	var ContQuests_Novigrad			: array<PotP_PreviewEntry>;
	var ContQuests_Skellige			: array<PotP_PreviewEntry>;
	var ContQuests_Toussaint		: array<PotP_PreviewEntry>;
	
	var ScavQuests_Griffin			: array<PotP_PreviewEntry>;
	var ScavQuests_Feline			: array<PotP_PreviewEntry>;
	var ScavQuests_Ursine			: array<PotP_PreviewEntry>;
	var ScavQuests_Wolven			: array<PotP_PreviewEntry>;
	var ScavQuests_Others			: array<PotP_PreviewEntry>;
	
	var HuntQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	var HuntQuests_Velen			: array<PotP_PreviewEntry>;
	var HuntQuests_Novigrad			: array<PotP_PreviewEntry>;
	var HuntQuests_Skellige			: array<PotP_PreviewEntry>;
	var HuntQuests_Toussaint		: array<PotP_PreviewEntry>;
	
	var MissableQuests_InstantFails	: array<PotP_PreviewEntry>;
	var MissableQuests_Q001			: array<PotP_PreviewEntry>;
	var MissableQuests_Q401			: array<PotP_PreviewEntry>;
	var MissableQuests_SQ101		: array<PotP_PreviewEntry>;
	var MissableQuests_Q301			: array<PotP_PreviewEntry>;
	var MissableQuests_Q303			: array<PotP_PreviewEntry>;
	var MissableQuests_SQ106		: array<PotP_PreviewEntry>;
	var MissableQuests_Q501			: array<PotP_PreviewEntry>;
	var MissableQuests_Q206			: array<PotP_PreviewEntry>;
	var MissableQuests_Q210			: array<PotP_PreviewEntry>;
	var MissableQuests_Q112			: array<PotP_PreviewEntry>;
	var MissableQuests_Q403			: array<PotP_PreviewEntry>;
	var MissableQuests_Q702			: array<PotP_PreviewEntry>;	
	var MissableQuests_Ugly			: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Quest Storage';

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
		return "QX" + IntToString(UUIDINT);
	}

//---------------------------------------------------

	function AddToMissableArray(pData: PotP_PreviewEntry) 
	{	
		switch (pData.uuid)
		{
		case "PotP_TrackingGroup_SideQuests_Novigrad_01":
		case "PotP_TrackingGroup_SideQuests_Velen_01":
		case "PotP_TrackingGroup_SideQuests_Velen_23":
		case "PotP_TrackingGroup_SideQuests_Novigrad_49":		
			this.MissableQuests_InstantFails.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_01":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_03":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_04":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_05":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_06":
			this.MissableQuests_Q001.PushBack(pData);
			break;
			
		case "PotP_TrackingGroup_SideQuests_Skellige_34":
		case "PotP_TrackingGroup_SideQuests_NonRegional_03":
			this.MissableQuests_Q401.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Velen_22":
			this.MissableQuests_SQ101.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_09":
			this.MissableQuests_Q303.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_12":
			this.MissableQuests_SQ106.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_38":
		case "PotP_TrackingGroup_ContractQuests_WhiteOrchard_01":	
			this.MissableQuests_Q501.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_26":
		case "PotP_TrackingGroup_SideQuests_Skellige_28":
			this.MissableQuests_Q206.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_07":
		case "PotP_TrackingGroup_SideQuests_Skellige_23":
		case "PotP_TrackingGroup_SideQuests_Skellige_35":
			this.MissableQuests_Q210.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_45":
		case "PotP_TrackingGroup_SideQuests_Novigrad_46":
			this.MissableQuests_Q112.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_02":
		case "PotP_TrackingGroup_SideQuests_Novigrad_03":
		case "PotP_TrackingGroup_SideQuests_Velen_02":
		case "PotP_TrackingGroup_SideQuests_Novigrad_06":
		case "PotP_TrackingGroup_SideQuests_Velen_04":
		case "PotP_TrackingGroup_SideQuests_Novigrad_10":
		case "PotP_TrackingGroup_SideQuests_Velen_05":
		case "PotP_TrackingGroup_SideQuests_KaerMorhen_01":
		case "PotP_TrackingGroup_SideQuests_Novigrad_12":
		case "PotP_TrackingGroup_SideQuests_Novigrad_13":
		case "PotP_TrackingGroup_SideQuests_Velen_08":
		case "PotP_TrackingGroup_SideQuests_Novigrad_17":
		case "PotP_TrackingGroup_SideQuests_Velen_14":
		case "PotP_TrackingGroup_SideQuests_Velen_17":
		case "PotP_TrackingGroup_SideQuests_Skellige_20":
		case "PotP_TrackingGroup_SideQuests_Novigrad_32":
		case "PotP_TrackingGroup_SideQuests_Novigrad_39":
		case "PotP_TrackingGroup_SideQuests_Velen_25":
		case "PotP_TrackingGroup_SideQuests_Velen_27":
			this.MissableQuests_Q403.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_Toussaint_03":
			this.MissableQuests_Q702.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_22":
			this.MissableQuests_Q301.PushBack(pData);
			break;

		case "PotP_TrackingGroup_MainQuests_SkelligeAct1_07":
			this.MissableQuests_Ugly.PushBack(pData);
			break;
			
		default:
			PotP_Logger("Unrecognised Missable Quest Detected - " + pData.localname);
			break;
		}	
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_QuestStorage 
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
	
state Build in CProgressOnThePath_QuestStorage 
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
		
		parent.MasterList_Quests.Clear();
		parent.MasterList_Quests_Lookup.Clear();
		
		parent.MissableQuests_InstantFails.Clear();
		parent.MissableQuests_Q001.Clear();
		parent.MissableQuests_Q401.Clear();
		parent.MissableQuests_SQ101.Clear();
		parent.MissableQuests_Q303.Clear();
		parent.MissableQuests_SQ106.Clear();
		parent.MissableQuests_Q501.Clear();
		parent.MissableQuests_Q206.Clear();
		parent.MissableQuests_Q210.Clear();
		parent.MissableQuests_Q112.Clear();
		parent.MissableQuests_Q403.Clear();
		parent.MissableQuests_Q702.Clear();
		parent.MissableQuests_Q301.Clear();
		parent.MissableQuests_Ugly.Clear();
		
		this.Build_Main();
		this.Build_Side();
		this.Build_Cont();
		this.Build_Scav();
		this.Build_Hunt();
		
		for ( Idx = 0; Idx < parent.MasterList_Quests.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Quests[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Quests[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Quests[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Quests[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Quests[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Quests[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Quests[Idx].identifier);			

		}
		
		parent.GotoState('Idle');
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Main()
	{
		var group: string = "PotP_TrackingGroup_MainQuests_Prologue";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MainQuests_Prologue.Clear();
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack"));
		
		PotP_SortPreviewData(parent.MainQuests_Prologue, PotP_A_Quest, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Vizima";
		
		parent.MainQuests_Vizima.Clear();
		parent.MainQuests_Vizima.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace"));
		
		PotP_SortPreviewData(parent.MainQuests_Vizima, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_VelenAct1";
		
		parent.MainQuests_Act1_Velen.Clear();
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Velen, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_NovigradAct1";
		
		parent.MainQuests_Act1_Novigrad.Clear();
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Novigrad, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_SkelligeAct1";
		
		parent.MainQuests_Act1_Skellige.Clear();
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Missable, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly"));
		
		PotP_SortPreviewData(parent.MainQuests_Act1_Skellige, PotP_A_Quest, master);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Act2";
		
		parent.MainQuests_Act2.Clear();
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle"));
		
		PotP_SortPreviewData(parent.MainQuests_Act2, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_Act3";
		
		parent.MainQuests_Act3.Clear();
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress"));
		
		PotP_SortPreviewData(parent.MainQuests_Act3, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_HeartsOfStone";
		
		parent.MainQuests_DLC1.Clear();
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale"));
		
		PotP_SortPreviewData(parent.MainQuests_DLC1, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_MainQuests_BloodAndWine";
		
		parent.MainQuests_DLC2.Clear();
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home"));
		
		PotP_SortPreviewData(parent.MainQuests_DLC2, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Side()
	{
		var group: string = "PotP_TrackingGroup_SideQuests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.SideQuests_WhiteOrchard.Clear();
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_WO, PotP_I_Sides, "mq5004horse"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith"));
		
		PotP_SortPreviewData(parent.SideQuests_WhiteOrchard, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_KaerMorhen";
		
		parent.SideQuests_KaerMorhen.Clear();
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4002_anomaly"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4003_lake"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4004_bastion"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4006_armor"));
		
		PotP_SortPreviewData(parent.SideQuests_KaerMorhen, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_NonRegional";
		
		parent.SideQuests_NonRegional.Clear();
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "CG: Old Friends"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith"));
		
		PotP_SortPreviewData(parent.SideQuests_NonRegional, PotP_A_Quest, master);

		//------------------------------------------------------
				
		group = "PotP_TrackingGroup_SideQuests_Velen";
		
		parent.SideQuests_Velen.Clear();
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ107 Pigs"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "CG : No Man's Land"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit"));
		}

		if (PotP_UsingThreeLittleSisters()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5178
		{ 
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "threesisters_little_sisters"));
		}		

		PotP_SortPreviewData(parent.SideQuests_Velen, PotP_A_Quest, master);
		
		//------------------------------------------------------
				
		group = "PotP_TrackingGroup_SideQuests_Novigrad";
		
		parent.SideQuests_Novigrad.Clear();
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ315 Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "mq3039_crows"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ301 Triss"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1,	PotP_R_NO, PotP_I_Sides, "q602romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ312 Ves"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "q603painting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ303 Brothel"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q308 Psycho"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Innkeepers"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ306 Maverick"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q309 Casablanca"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6001merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3035_emhyr"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ302 Philippa"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1028 Courier"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_45", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_46", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_47", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_49", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_50", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6002_cannibals"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_52", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2"));
		}

		if (PotP_UsingCiriSoleMemento()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/4585
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "solememento_sole_memento"));
		}

		PotP_SortPreviewData(parent.SideQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_Skellige";
		
		parent.SideQuests_Skellige.Clear();
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2010 human trap"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2045_chains"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "Fist Fight Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2049_atheist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "CG: Skellige"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ201 Curse"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q206 Berserkers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q203 Him"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ202 Yen"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2030_nithing"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif"));

		PotP_SortPreviewData(parent.SideQuests_Skellige, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_Toussaint";
		
		parent.SideQuests_Toussaint.Clear();
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_17", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_18", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_19", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_20", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_21", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_22", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_23", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_24", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_25", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_26", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_27", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_28", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_29", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_30", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_31", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_32", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_33", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_34", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_35", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_36", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_37", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_38", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_39", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_40", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino"));

		if (PotP_UsingANightToRemember()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/4670
		{
			parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_90", PotP_E_ModAdded_DLC2, PotP_R_TO, PotP_I_Sides, "ntr_nighttoremember"));
		}
		
		PotP_SortPreviewData(parent.SideQuests_Toussaint, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------

	latent function Build_Cont()
	{
		var group: string = "PotP_TrackingGroup_ContractQuests_WhiteOrchard";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.ContQuests_WhiteOrchard.Clear();
		parent.ContQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith"));
		
		PotP_SortPreviewData(parent.ContQuests_WhiteOrchard, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Velen";
		
		parent.ContQuests_Velen.Clear();
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake "));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael"));
		
		PotP_SortPreviewData(parent.ContQuests_Velen, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Novigrad";
		
		parent.ContQuests_Novigrad.Clear();
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih"));
		
		PotP_SortPreviewData(parent.ContQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Skellige";
		
		parent.ContQuests_Skellige.Clear();
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit"));
		
		PotP_SortPreviewData(parent.ContQuests_Skellige, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Toussaint";
		
		parent.ContQuests_Toussaint.Clear();
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight"));
		
		PotP_SortPreviewData(parent.ContQuests_Toussaint, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Scav()
	{
		var group: string = "PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.ScavQuests_Griffin.Clear();
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Set"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Griffin, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_FelineSet";
		
		parent.ScavQuests_Feline.Clear();
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Set"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_cat_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Feline, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet";
		
		parent.ScavQuests_Ursine.Clear();
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Set"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_bear_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Ursine, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet";
		
		parent.ScavQuests_Wolven.Clear();
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Set"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear"));
		
		PotP_SortPreviewData(parent.ScavQuests_Wolven, PotP_A_Quest, master);		

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_OtherSets";
		
		parent.ScavQuests_Others.Clear();
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Viper Set"));
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th700_red_wolf"));

		if (PotP_IsUsingNextGen()) 
		{
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades"));
		}

		if (PotP_UsingDLCArmorQuests()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/3983
		{ 
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "temeriatreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "nilfgaardtreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "skelligetreasurehunt"));
		}
		
		PotP_SortPreviewData(parent.ScavQuests_Others, PotP_A_Quest, master);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard";
		
		parent.HuntQuests_WhiteOrchard.Clear();
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure"));
		
		PotP_SortPreviewData(parent.HuntQuests_WhiteOrchard, PotP_A_Quest, master);
	}

	//---------------------------------------------------
	//-- Functions --------------------------------------
	//---------------------------------------------------
	
	latent function Build_Hunt()
	{
		var group: string = "PotP_TrackingGroup_TreasureHuntQuests_Velen";
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.HuntQuests_Velen.Clear();
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds"));
		
		PotP_SortPreviewData(parent.HuntQuests_Velen, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Novigrad";
		
		parent.HuntQuests_Novigrad.Clear();
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26b"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi08"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 		PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi01"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi10"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi02"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi05"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi04"));
		
		PotP_SortPreviewData(parent.HuntQuests_Novigrad, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Skellige";
		
		parent.HuntQuests_Skellige.Clear();
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure"));
		
		PotP_SortPreviewData(parent.HuntQuests_Skellige, PotP_A_Quest, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Toussaint";
		
		parent.HuntQuests_Toussaint.Clear();
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(master.PotP_EntityHelper, group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03"));
		
		PotP_SortPreviewData(parent.HuntQuests_Toussaint, PotP_A_Quest, master);
	}
}

