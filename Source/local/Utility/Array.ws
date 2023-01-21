//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_ArrayHandler
{
	public var fileName: name;
		default fileName = 'PotP Array Manager';

	private var UUIDINT: int;
		default UUIDINT = 1000;
		
	private var UUIDSTR: string;
		default UUIDSTR = "XS";

	//---------------------------------------------------
	
	public var MasterList_Quests		:array<PotP_PreviewEntry>;
	public var MasterList_Quests_Lookup	:array<string>;
	
	public var MainQuests_Prologue		: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Velen	: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Novigrad	: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Skellige	: array<PotP_PreviewEntry>;
	public var MainQuests_Act2			: array<PotP_PreviewEntry>;
	public var MainQuests_Act3			: array<PotP_PreviewEntry>;
	public var MainQuests_DLC1			: array<PotP_PreviewEntry>;
	public var MainQuests_DLC2			: array<PotP_PreviewEntry>;
	public var MainQuests_Vizima		: array<PotP_PreviewEntry>;

	public var SideQuests_WhiteOrchard	: array<PotP_PreviewEntry>;
	public var SideQuests_Velen			: array<PotP_PreviewEntry>;
	public var SideQuests_Novigrad		: array<PotP_PreviewEntry>;
	public var SideQuests_Skellige		: array<PotP_PreviewEntry>;
	public var SideQuests_KaerMorhen	: array<PotP_PreviewEntry>;
	public var SideQuests_Toussaint		: array<PotP_PreviewEntry>;
	public var SideQuests_NonRegional	: array<PotP_PreviewEntry>;
	
	public var ContQuests_WhiteOrchard	: array<PotP_PreviewEntry>;
	public var ContQuests_Velen			: array<PotP_PreviewEntry>;
	public var ContQuests_Novigrad		: array<PotP_PreviewEntry>;
	public var ContQuests_Skellige		: array<PotP_PreviewEntry>;
	public var ContQuests_Toussaint		: array<PotP_PreviewEntry>;
	
	public var ScavQuests_Griffin		: array<PotP_PreviewEntry>;
	public var ScavQuests_Feline		: array<PotP_PreviewEntry>;
	public var ScavQuests_Ursine		: array<PotP_PreviewEntry>;
	public var ScavQuests_Wolven		: array<PotP_PreviewEntry>;
	public var ScavQuests_Others		: array<PotP_PreviewEntry>;
	
	public var HuntQuests_WhiteOrchard	: array<PotP_PreviewEntry>;
	public var HuntQuests_Velen			: array<PotP_PreviewEntry>;
	public var HuntQuests_Novigrad		: array<PotP_PreviewEntry>;
	public var HuntQuests_Skellige		: array<PotP_PreviewEntry>;
	public var HuntQuests_Toussaint		: array<PotP_PreviewEntry>;

	public var MissableQuests_InstantFails	: array<PotP_PreviewEntry>;
	public var MissableQuests_Q001			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q401			: array<PotP_PreviewEntry>;
	public var MissableQuests_SQ101			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q303			: array<PotP_PreviewEntry>;
	public var MissableQuests_SQ106			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q501			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q206			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q210			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q112			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q403			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q702			: array<PotP_PreviewEntry>;
	
	//---------------------------------------------------

	public var MasterList_Events		:array<PotP_PreviewEntry>;
	public var MasterList_Events_Lookup	:array<name>;
	
	public var RandomEvents_Velen		: array<PotP_PreviewEntry>;
	public var RandomEvents_Novigrad	: array<PotP_PreviewEntry>;
	public var RandomEvents_Skellige	: array<PotP_PreviewEntry>;
	public var RandomEvents_KaerMorhen	: array<PotP_PreviewEntry>;	
	
	//---------------------------------------------------

	public var MasterList_World				:array<PotP_PreviewEntry>;
	public var MasterList_World_Lookup		:array<name>;
	
	public var BanditCamps_WhiteOrchard		: array<PotP_PreviewEntry>;
	public var BanditCamps_Velen			: array<PotP_PreviewEntry>;
	public var BanditCamps_Novigrad			: array<PotP_PreviewEntry>;
	public var BanditCamps_Skellige			: array<PotP_PreviewEntry>;
	public var BanditCamps_Toussaint		: array<PotP_PreviewEntry>;
	
	public var MonsterDens_Velen			: array<PotP_PreviewEntry>;
	public var MonsterDens_Novigrad			: array<PotP_PreviewEntry>;
	public var MonsterDens_Skellige			: array<PotP_PreviewEntry>;
	public var MonsterDens_Toussaint		: array<PotP_PreviewEntry>;

	public var MonsterNests_WhiteOrchard	: array<PotP_PreviewEntry>;
	public var MonsterNests_Velen			: array<PotP_PreviewEntry>;
	public var MonsterNests_Novigrad		: array<PotP_PreviewEntry>;
	public var MonsterNests_Skellige		: array<PotP_PreviewEntry>;
	public var MonsterNests_Toussaint		: array<PotP_PreviewEntry>;

	public var PlacesOfPower_WhiteOrchard	: array<PotP_PreviewEntry>;
	public var PlacesOfPower_Velen			: array<PotP_PreviewEntry>;
	public var PlacesOfPower_Novigrad		: array<PotP_PreviewEntry>;
	public var PlacesOfPower_Skellige		: array<PotP_PreviewEntry>;
	public var PlacesOfPower_KaerMorhen		: array<PotP_PreviewEntry>;
	public var PlacesOfPower_Toussaint		: array<PotP_PreviewEntry>;
	public var PlacesOfPower_TheSpiral		: array<PotP_PreviewEntry>;

	public var Signposts_WhiteOrchard		: array<PotP_PreviewEntry>;
	public var Signposts_Velen				: array<PotP_PreviewEntry>;
	public var Signposts_Novigrad			: array<PotP_PreviewEntry>;
	public var Signposts_Skellige			: array<PotP_PreviewEntry>;
	public var Signposts_KaerMorhen			: array<PotP_PreviewEntry>;
	public var Signposts_Toussaint			: array<PotP_PreviewEntry>;
	
	//---------------------------------------------------

	public var MasterList_Items			:array<PotP_PreviewEntry>;
	public var MasterList_Items_Lookup	:array<name>;
	
	public var Relic_Trophies			: array<PotP_PreviewEntry>;
	public var Relic_Crossbows			: array<PotP_PreviewEntry>;
	public var Relic_SteelSwords		: array<PotP_PreviewEntry>;
	public var Relic_SilverSwords		: array<PotP_PreviewEntry>;	
	
	public var Armor_DolBlathanna		: array<PotP_PreviewEntry>;	
	public var Armor_ForgottenWolven	: array<PotP_PreviewEntry>;	
	public var Armor_HenGaidth			: array<PotP_PreviewEntry>;	
	public var Armor_NewMoon			: array<PotP_PreviewEntry>;	
	public var Armor_Nilfgaardian		: array<PotP_PreviewEntry>;	
	public var Armor_Ofieri				: array<PotP_PreviewEntry>;	
	public var Armor_Temerian			: array<PotP_PreviewEntry>;	
	public var Armor_TeshamMutna		: array<PotP_PreviewEntry>;	
	public var Armor_Undvik				: array<PotP_PreviewEntry>;	
	public var Armor_WhiteTiger			: array<PotP_PreviewEntry>;	
	
	public var DLC_CosWiecej			: array<PotP_PreviewEntry>;	
	public var DLC_Dimeritium			: array<PotP_PreviewEntry>;	
	public var DLC_Gothic				: array<PotP_PreviewEntry>;	
	public var DLC_Meteorite			: array<PotP_PreviewEntry>;	
	public var DLC_SezonBurz			: array<PotP_PreviewEntry>;	
	
	public var Shades_Assassin			: array<PotP_PreviewEntry>;	
	public var Shades_Berserker			: array<PotP_PreviewEntry>;	
	public var Shades_Bismarck			: array<PotP_PreviewEntry>;	
	public var Shades_BloodHunter		: array<PotP_PreviewEntry>;	
	public var Shades_CrowFeathered		: array<PotP_PreviewEntry>;	
	public var Shades_FallenKnight		: array<PotP_PreviewEntry>;	
	public var Shades_Faraam			: array<PotP_PreviewEntry>;	
	public var Shades_Headtaker			: array<PotP_PreviewEntry>;	
	public var Shades_Hitokiri			: array<PotP_PreviewEntry>;	
	public var Shades_Kara				: array<PotP_PreviewEntry>;	
	public var Shades_LionHunter		: array<PotP_PreviewEntry>;	
	public var Shades_OldHunter			: array<PotP_PreviewEntry>;	
	public var Shades_Revenant			: array<PotP_PreviewEntry>;	
	public var Shades_SilverSwords		: array<PotP_PreviewEntry>;	
	public var Shades_Sithis			: array<PotP_PreviewEntry>;	
	public var Shades_Stalker			: array<PotP_PreviewEntry>;	
	public var Shades_SteelSwords		: array<PotP_PreviewEntry>;	
	public var Shades_Taifeng			: array<PotP_PreviewEntry>;	
	public var Shades_Unseen			: array<PotP_PreviewEntry>;	

	public var Gwent_MonstersDeck		: array<PotP_PreviewEntry>;
	public var Gwent_NeutralDeck		: array<PotP_PreviewEntry>;
	public var Gwent_NilfgaardDeck		: array<PotP_PreviewEntry>;
	public var Gwent_NorthernRealms		: array<PotP_PreviewEntry>;
	public var Gwent_Scoiatael			: array<PotP_PreviewEntry>;
	public var Gwent_Skellige			: array<PotP_PreviewEntry>;
	
	public var TotalEntList: array<PotP_PreviewEntry>;
	public var TotalVarList: array<name>;
	public var TotalGrpList: array<name>;
	public var TotalIdeList: array<string>;

	//---------------------------------------------------
	
	public function initialise()
	{		
		this.GotoState('Idle');
		this.GotoState('Running');
	}

	//---------------------------------------------------
	
	public function CreateUniqueIdentifier() : string 
	{
		var Ret: string = UUIDSTR + IntToString(UUIDINT);
		
		while (this.TotalIdeList.FindFirst(Ret) != -1) 
		{
			UUIDINT += 1;
			Ret = UUIDSTR + IntToString(UUIDINT);
		}
		
		UUIDINT += 1;
		return Ret;
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_ArrayHandler 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
	}	
}

//---------------------------------------------------
//-- Running State ----------------------------------
//---------------------------------------------------

state Running in CProgressOnThePath_ArrayHandler
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Running]", , parent.fileName);
		
		this.Running_Main();
		parent.GotoState('Idle');
	}	

	entry function Running_Main() 
	{	
		this.BuildQuestArrays();
		this.BuildWorldArrays();
		this.BuildItemsArrays();
		this.BuildEntryArrays();
	}

//---------------------------------------------------

	latent function BuildEntryArrays() 
	{
		var i: int;

		parent.TotalVarList.Clear();
		parent.TotalGrpList.Clear();
		parent.TotalIdeList.Clear();
		parent.TotalEntList.Clear();
		
		for ( i = 0; i < parent.MasterList_Quests.Size(); i += 1 ) 
		{
			if (parent.TotalVarList.FindFirst(parent.MasterList_Quests[i].uuid) != -1) 
			{
				PotP_Logger("Duplicate Entry Found - " + parent.MasterList_Quests[i].localname, , parent.fileName);
				continue;
			}
			
			parent.TotalEntList.PushBack(parent.MasterList_Quests[i]);
			parent.TotalVarList.PushBack(parent.MasterList_Quests[i].uuid);
			parent.TotalGrpList.PushBack(parent.MasterList_Quests[i].group);
			parent.TotalIdeList.PushBack(parent.MasterList_Quests[i].identifier);
		}
		
		for ( i = 0; i < parent.MasterList_Events.Size(); i += 1 ) 
		{
			if (parent.TotalVarList.FindFirst(parent.MasterList_Events[i].uuid) != -1) 
			{
				PotP_Logger("Duplicate Entry Found - " + parent.MasterList_Events[i].localname, , parent.fileName);
				continue;
			}
			
			parent.TotalEntList.PushBack(parent.MasterList_Events[i]);
			parent.TotalVarList.PushBack(parent.MasterList_Events[i].uuid);
			parent.TotalGrpList.PushBack(parent.MasterList_Events[i].group);
			parent.TotalIdeList.PushBack(parent.MasterList_Events[i].identifier);
		}

		for ( i = 0; i < parent.MasterList_World.Size(); i += 1 ) 
		{
			if (parent.TotalVarList.FindFirst(parent.MasterList_World[i].uuid) != -1) 
			{
				PotP_Logger("Duplicate Entry Found - " + parent.MasterList_World[i].uuid, , parent.fileName);
				continue;
			}
			
			parent.TotalEntList.PushBack(parent.MasterList_World[i]);
			parent.TotalVarList.PushBack(parent.MasterList_World[i].uuid);
			parent.TotalGrpList.PushBack(parent.MasterList_World[i].group);
			parent.TotalIdeList.PushBack(parent.MasterList_World[i].identifier);
		}
		
		for ( i = 0; i < parent.MasterList_Items.Size(); i += 1 ) 
		{
			if (parent.TotalVarList.FindFirst(parent.MasterList_Items[i].uuid) != -1) 
			{
				PotP_Logger("Duplicate Entry Found - " + parent.MasterList_Items[i].uuid, , parent.fileName);
				continue;
			}
			
			parent.TotalEntList.PushBack(parent.MasterList_Items[i]);
			parent.TotalVarList.PushBack(parent.MasterList_Items[i].uuid);
			parent.TotalGrpList.PushBack(parent.MasterList_Items[i].group);
			parent.TotalIdeList.PushBack(parent.MasterList_Items[i].identifier);
		}
	}

//---------------------------------------------------

	latent function BuildQuestArrays() 
	{
		parent.MasterList_Quests.Clear();
		parent.MasterList_Events.Clear();
		parent.MasterList_Quests_Lookup.Clear();
		parent.MasterList_Events_Lookup.Clear();
		
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

		this.Initialise_MainQuests();
		this.Initialise_SideQuests_Misc();
		this.Initialise_SideQuests_Velen();
		this.Initialise_SideQuests_Novigrad();
		this.Initialise_SideQuests_Skellige();
		this.Initialise_SideQuests_Toussaint();
		this.Initialise_MiscQuests_Contracts();
		this.Initialise_MiscQuests_ScavangerHunts();
		this.Initialise_MiscQuests_TreasureHunts();
		this.Initialise_RandomEvents();
	}

//---------------------------------------------------

	latent function BuildWorldArrays() 
	{
		parent.MasterList_World.Clear();
		parent.MasterList_World_Lookup.Clear();
		
		this.Initialise_WorldMap_BanditCamps();
		this.Initialise_WorldMap_MonsterDens();
		this.Initialise_WorldMap_MonsterNests();
		this.Initialise_WorldMap_PlacesOfPower();
		
		this.Initialise_WorldMap_Signposts_1();
		this.Initialise_WorldMap_Signposts_2();
		this.Initialise_WorldMap_Signposts_3();
	}
	
//---------------------------------------------------

	latent function BuildItemsArrays() 
	{
		this.Initialise_Items_Relics_SteelSwords();
		this.Initialise_Items_Relics_SilverSwords();
		this.Initialise_Items_Relics_Crossbows();
		this.Initialise_Items_Relics_MonsterTrophies();
		
		this.Initialise_Items_ArmorSets();
		this.Initialise_Items_ModAdded();
		
		if (PotP_UsingShadesOfIron()) //Github ID: https://github.com/Amasiuncula/Shades-of-Iron
		{ 
			this.Initialise_Items_ShadesOfIronGearSets();
			this.Initialise_Items_ShadesOfIronSwords();
		}

		if (PotP_UsingGwentRedux()) 
		{
			this.Initialise_GwentCards_Monsters_Redux();
			this.Initialise_GwentCards_Neutral_Redux();
			this.Initialise_GwentCards_Nilfgaard_Redux();
			this.Initialise_GwentCards_NorthernRealms_Redux();
			this.Initialise_GwentCards_Scoiatael_Redux();
			this.Initialise_GwentCards_Skellige_Redux();
		}
		else
		{
			this.Initialise_GwentCards_Monsters();
			this.Initialise_GwentCards_Neutral();
			this.Initialise_GwentCards_Nilfgaard();
			this.Initialise_GwentCards_NorthernRealms();
			this.Initialise_GwentCards_Scoiatael();
			this.Initialise_GwentCards_Skellige();
		}	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function SortPreviewData(out pData: array<PotP_PreviewEntry>, type: PotP_Preview_Array_Type) 
	{
		var data: array<PotP_PreviewEntry>;
		var temp: array<string>;
		var i, x: int;
		
		data = pData;

		for ( i = 0; i < pData.Size(); i += 1 ) 
		{
			temp.PushBack(pData[i].localname);
		}
		
		ArraySortStrings(temp);
		pData.Clear();
		
		for ( i = 0; i < temp.Size(); i += 1 ) 
		{
			for ( x = 0; x < data.Size(); x += 1 ) 
			{
				if (temp[i] == data[x].localname) 
				{
					data[x].identifier = parent.CreateUniqueIdentifier();
					data[x].arrayType  = type;
					
					pData.PushBack(data[x]);

					if (data[x].is_missable) 
					{
						this.AddToMissableArray(data[x]);
					}
					
					switch (type)
					{
					case PotP_A_Quest:
						parent.MasterList_Quests.PushBack(data[x]);
						parent.MasterList_Quests_Lookup.PushBack(data[x].entryname);
						break;
						
					case PotP_A_Event:
						parent.MasterList_Events.PushBack(data[x]);
						parent.MasterList_Events_Lookup.PushBack(data[x].uuid);
						break;
						
					case PotP_A_World:
						parent.MasterList_World.PushBack(data[x]);
						parent.MasterList_World_Lookup.PushBack(data[x].uuid);
						break;
						
					case PotP_A_Items:
					case PotP_A_Gwent:
						parent.MasterList_Items.PushBack(data[x]);
						parent.MasterList_Items_Lookup.PushBack(data[x].item_name);
						break;
					}
				}
			}
		}
	}	

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function AddToMissableArray(pData: PotP_PreviewEntry) 
	{	
		switch (pData.uuid)
		{
		case 'PotP_TrackingGroup_SideQuests_Novigrad_01':
		case 'PotP_TrackingGroup_SideQuests_Velen_01':
		case 'PotP_TrackingGroup_SideQuests_Velen_23':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_49':		
			parent.MissableQuests_InstantFails.PushBack(pData);
			break;
		
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard_01':
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard_03':
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard_04':
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard_05':
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard_06':
			parent.MissableQuests_Q001.PushBack(pData);
			break;
			
		case 'PotP_TrackingGroup_SideQuests_Skellige_34':
		case 'PotP_TrackingGroup_SideQuests_NonRegional_03':
			parent.MissableQuests_Q401.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Velen_22':
			parent.MissableQuests_SQ101.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Novigrad_09':
			parent.MissableQuests_Q303.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Skellige_12':
			parent.MissableQuests_SQ106.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Novigrad_38':
		case 'PotP_TrackingGroup_ContractQuests_WhiteOrchard_01':	
			parent.MissableQuests_Q501.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Skellige_26':
		case 'PotP_TrackingGroup_SideQuests_Skellige_28':
			parent.MissableQuests_Q206.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Skellige_07':
		case 'PotP_TrackingGroup_SideQuests_Skellige_23':
		case 'PotP_TrackingGroup_SideQuests_Skellige_35':
			parent.MissableQuests_Q210.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Novigrad_45':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_46':
			parent.MissableQuests_Q112.PushBack(pData);
			break;

		case 'PotP_TrackingGroup_SideQuests_Novigrad_02':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_03':
		case 'PotP_TrackingGroup_SideQuests_Velen_02':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_06':
		case 'PotP_TrackingGroup_SideQuests_Velen_04':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_10':
		case 'PotP_TrackingGroup_SideQuests_Velen_05':
		case 'PotP_TrackingGroup_SideQuests_KaerMorhen_01':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_12':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_13':
		case 'PotP_TrackingGroup_SideQuests_Velen_08':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_17':
		case 'PotP_TrackingGroup_SideQuests_Velen_14':
		case 'PotP_TrackingGroup_SideQuests_Velen_17':
		case 'PotP_TrackingGroup_SideQuests_Skellige_20':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_32':
		case 'PotP_TrackingGroup_SideQuests_Novigrad_39':
		case 'PotP_TrackingGroup_SideQuests_Velen_25':
		case 'PotP_TrackingGroup_SideQuests_Velen_27':
			parent.MissableQuests_Q403.PushBack(pData);
			break;
		
		case 'PotP_TrackingGroup_SideQuests_Toussaint_03':
			parent.MissableQuests_Q702.PushBack(pData);
			break;
			
		default:
			PotP_Logger("Unrecognised Missable Quest Detected - " + pData.localname);
			break;
		}	
	}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	latent function Initialise_MainQuests() 
	{	
		//---------------------- Main Quests - (Prologue)
		
		var group: name = 'PotP_TrackingGroup_MainQuests_Prologue';
		
		parent.MainQuests_Prologue.Clear();
		parent.MainQuests_Prologue.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Prologue_01', PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream"));
		parent.MainQuests_Prologue.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Prologue_02', PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer"));
		parent.MainQuests_Prologue.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Prologue_03', PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt"));
		parent.MainQuests_Prologue.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Prologue_04', PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack"));
		
		SortPreviewData(parent.MainQuests_Prologue, PotP_A_Quest);

		//---------------------- Main Quests - (Vizima)		
		
		group = 'PotP_TrackingGroup_MainQuests_Vizima';
		
		parent.MainQuests_Vizima.Clear();
		parent.MainQuests_Vizima.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Vizima_01', PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace"));
		
		SortPreviewData(parent.MainQuests_Vizima, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Velen)
		
		group = 'PotP_TrackingGroup_MainQuests_VelenAct1';
		
		parent.MainQuests_Act1_Velen.Clear();
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_01', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_02', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_03', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_04', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_05', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_06', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_07', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_08', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_09', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_10', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_11', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit"));
		parent.MainQuests_Act1_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_VelenAct1_12', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps"));
		
		SortPreviewData(parent.MainQuests_Act1_Velen, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Novigrad)
		
		group = 'PotP_TrackingGroup_MainQuests_NovigradAct1';
		
		parent.MainQuests_Act1_Novigrad.Clear();
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_01', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_02', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_03', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_04', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_05', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_06', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_07', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_08', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_09', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_NovigradAct1_10', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple"));
		
		SortPreviewData(parent.MainQuests_Act1_Novigrad, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Skellige)
		
		group = 'PotP_TrackingGroup_MainQuests_SkelligeAct1';
		
		parent.MainQuests_Act1_Skellige.Clear();
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_01', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_02', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_03', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_04', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_05', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_06', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven"));
		parent.MainQuests_Act1_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_SkelligeAct1_07', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly"));
		
		SortPreviewData(parent.MainQuests_Act1_Skellige, PotP_A_Quest);	
		
		//---------------------- Main Quests - (Act 2)

		group = 'PotP_TrackingGroup_MainQuests_Act2';
		
		parent.MainQuests_Act2.Clear();
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_01', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_02', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_03', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_04', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_05', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_06', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_07', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_08', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_09', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_10', PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_11', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_12', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen"));
		parent.MainQuests_Act2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act2_13', PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle"));
		
		SortPreviewData(parent.MainQuests_Act2, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 3)

		group = 'PotP_TrackingGroup_MainQuests_Act3';
		
		parent.MainQuests_Act3.Clear();
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_01', PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_02', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_03', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_04', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_05', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_06', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_07', PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_08', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_09', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_10', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_11', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_12', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_13', PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach"));
		parent.MainQuests_Act3.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_Act3_14', PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress"));
		
		SortPreviewData(parent.MainQuests_Act3, PotP_A_Quest);
		
		//---------------------- Main Quests - (Hearts of Stone)

		group = 'PotP_TrackingGroup_MainQuests_HeartsOfStone';
		
		parent.MainQuests_DLC1.Clear();
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_01', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_02', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_03', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_04', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_05', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_06', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_07', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion"));
		parent.MainQuests_DLC1.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_HeartsOfStone_08', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale"));
		
		SortPreviewData(parent.MainQuests_DLC1, PotP_A_Quest);
		
		//---------------------- Main Quests - (Blood and Wine)

		group = 'PotP_TrackingGroup_MainQuests_BloodAndWine';
		
		parent.MainQuests_DLC2.Clear();
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_01', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_02', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_03', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_04', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_05', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_06', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_07', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_08', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_09', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_10', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_11', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_12', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_13', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_14', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_15', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison"));
		parent.MainQuests_DLC2.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_MainQuests_BloodAndWine_16', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home"));
		
		SortPreviewData(parent.MainQuests_DLC2, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Misc() 
	{	
		var group: name = 'PotP_TrackingGroup_SideQuests_WhiteOrchard';
	
		parent.SideQuests_WhiteOrchard.Clear();
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_01', PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed"));
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_02', PotP_E_Primary,  PotP_R_WO, PotP_I_Sides, "mq5004horse"));
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_03', PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother"));
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_04', PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman"));
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_05', PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods"));
		parent.SideQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_WhiteOrchard_06', PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith"));
		
		SortPreviewData(parent.SideQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_SideQuests_KaerMorhen';
		
		parent.SideQuests_KaerMorhen.Clear();
		parent.SideQuests_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_KaerMorhen_01', PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword"));
		parent.SideQuests_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_KaerMorhen_02', PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4002_anomaly"));
		parent.SideQuests_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_KaerMorhen_03', PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4003_lake"));
		parent.SideQuests_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_KaerMorhen_04', PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4004_bastion"));
		parent.SideQuests_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_KaerMorhen_05', PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4006_armor"));
		
		SortPreviewData(parent.SideQuests_KaerMorhen, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_SideQuests_NonRegional';
		
		parent.SideQuests_NonRegional.Clear();
		parent.SideQuests_NonRegional.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_NonRegional_01', PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance"));
		parent.SideQuests_NonRegional.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_NonRegional_02', PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All"));
		parent.SideQuests_NonRegional.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_NonRegional_03', PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill"));
		parent.SideQuests_NonRegional.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_NonRegional_04', PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "CG: Old Friends"));
		parent.SideQuests_NonRegional.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_NonRegional_05', PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith"));
		
		SortPreviewData(parent.SideQuests_NonRegional, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_SideQuests_Velen() 
	{
		var group: name = 'PotP_TrackingGroup_SideQuests_Velen';
		
		parent.SideQuests_Velen.Clear();
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_01', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_02', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_03', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_04', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_05', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_06', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_07', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_08', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_09', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_10', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_11', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_12', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_13', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ107 Pigs"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_14', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_15', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_16', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_17', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_18', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "CG : No Man's Land"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_19', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_20', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_21', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_22', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_23', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_24', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_25', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_26', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_27', PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_28', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_30', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_31', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_32', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf"));
		parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_33', PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender"));
		
		if (PotP_IsUsingNextGen()) {
			parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_34', PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit"));
		}

		if (PotP_UsingThreeLittleSisters()) { //Nexus ID: https://www.nexusmods.com/witcher3/mods/5178
			parent.SideQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Velen_90', PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "threesisters_little_sisters"));
		}		

		SortPreviewData(parent.SideQuests_Velen, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Novigrad() 
	{
		var group: name = 'PotP_TrackingGroup_SideQuests_Novigrad';
		
		parent.SideQuests_Novigrad.Clear();
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_01', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_02', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_03', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ315 Talar"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_04', PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "mq3039_crows"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_05', PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_06', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ301 Triss"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_07', PotP_E_Primary_DLC1,	PotP_R_NO, PotP_I_Sides, "q602romance"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_08', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_09', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_10', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ312 Ves"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_11', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "q603painting"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_12', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ303 Brothel"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_13', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q308 Psycho"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_14', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_15', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_16', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_17', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_18', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_19', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Novigrad"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_20', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Innkeepers"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_21', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Talar"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_22', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_23', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_24', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_25', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ306 Maverick"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_26', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_27', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_28', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_29', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_30', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_31', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_32', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q309 Casablanca"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_33', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_34', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_35', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_36', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_37', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6001merchant"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_38', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3035_emhyr"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_39', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ302 Philippa"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_40', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_41', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_42', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_43', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1028 Courier"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_44', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_45', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_46', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_47', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_48', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_49', PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_50', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6002_cannibals"));
		parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_51', PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2"));
		
		if (PotP_IsUsingNextGen()) {
			parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_52', PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2"));
		}

		if (PotP_UsingCiriSoleMemento()) { //Nexus ID: https://www.nexusmods.com/witcher3/mods/4585
			parent.SideQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Novigrad_90', PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "solememento_sole_memento"));
		}

		SortPreviewData(parent.SideQuests_Novigrad, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Skellige() {	
		
		var group: name = 'PotP_TrackingGroup_SideQuests_Skellige';
		
		parent.SideQuests_Skellige.Clear();
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_01', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_02', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_03', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2010 human trap"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_04', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_05', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_06', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_07', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_08', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2045_chains"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_09', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_10', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "Fist Fight Championship"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_11', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_12', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_13', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_14', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2049_atheist"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_15', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_16', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "CG: Skellige"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_17', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_18', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ201 Curse"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_19', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_20', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q206 Berserkers"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_21', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_22', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_23', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q203 Him"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_24', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_25', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_26', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_27', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_28', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_29', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_30', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_31', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_32', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_33', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_34', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ202 Yen"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_35', PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_36', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2030_nithing"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_37', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_38', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_39', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_40', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower"));
		parent.SideQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Skellige_41', PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif"));

		SortPreviewData(parent.SideQuests_Skellige, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Toussaint() {	
		
		var group: name = 'PotP_TrackingGroup_SideQuests_Toussaint';
		
		parent.SideQuests_Toussaint.Clear();
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_01', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_02', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_03', PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_04', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_05', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_06', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_07', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_08', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_09', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_10', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_11', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_12', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_13', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_14', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_15', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_16', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_17', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_18', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_19', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_20', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_21', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_22', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_23', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_24', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_25', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_26', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_27', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_28', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_29', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_30', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_31', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_32', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_33', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_34', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_35', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_36', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_37', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_38', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_39', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret"));
		parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_40', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino"));

		if (PotP_UsingANightToRemember()) { // Nexus ID: https://www.nexusmods.com/witcher3/mods/4670
			parent.SideQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_SideQuests_Toussaint_90', PotP_E_ModAdded_DLC2, PotP_R_TO, PotP_I_Sides, "ntr_nighttoremember"));
		}
		
		SortPreviewData(parent.SideQuests_Toussaint, PotP_A_Quest);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_RandomEvents() {	
		
		var group: name = 'PotP_TrackingGroup_RandomEvents_Velen';
		
		parent.RandomEvents_Velen.Clear();
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_01', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_AtTheMercyOfStrangers_1_NG", Vector(641.454102, 533.142456)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_02', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_CaravanAttack_NG_1", 		Vector(1311.539551, 404.800537)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_14', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_CaravanAttack_NG_2", 		Vector(207.837814, 75.866135)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_03', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_DeadlyCrossing_3_NG", 		Vector(-29.826519, -101.255219)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_04', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_DeadlyCrossing_1_NG", 		Vector(794.722107, 266.272644)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_05', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_DeadlyCrossing_2_NG", 		Vector(1087.826294, -295.390381)	));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_06', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_FaceMeIfYouDare_1_NG", 		Vector(213.855240, -32.358776)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_07', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_HarassingATroll_NG", 		Vector(138.532272, 811.463623)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_08', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_HighwayRobbery_NG", 			Vector(300.595459, -135.326324)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_09', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_HighwaymansCache_NG", 		Vector(519.180176, -212.923065)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_10', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_LootersHeatherton_NG", 		Vector(151.509430, 508.062775)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_11', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_LootersCodgersQuarry_NG", 	Vector(1221.132690, 831.181274)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_12', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_LootersToderas_NG", 			Vector(1720.736694, 67.942719)		));
		parent.RandomEvents_Velen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Velen_13', PotP_E_Primary, PotP_R_VE, PotP_I_Event, "novigrad", "PotP_Event_MansBestFriend_NG", 			Vector(643.049805, 799.665344)		));
		
		SortPreviewData(parent.RandomEvents_Velen, PotP_A_Event);

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_RandomEvents_Novigrad';
		
		parent.RandomEvents_Novigrad.Clear();
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_01', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_AWarmWelcome_NG", 				Vector(1347.046143, 1591.817261)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_02', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_AtTheMercyOfStrangers_2_NG", 	Vector(393.423737, 1265.788696)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_03', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_DrunkenRabble_NG", 			Vector(543.444885, 1839.808228)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_04', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_FaceMeIfYouDare_2_NG", 		Vector(899.003479, 1732.530640)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_05', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_FaceMeIfYouDare_3_NG", 		Vector(505.266266, 1915.563843)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_06', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_KarmicJustice_NG", 			Vector(862.002502, 1831.773438)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_07', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_NeverTrustChildren_NG", 		Vector(765.527771, 1932.638062)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_08', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_RacistsOfNovigradFC_NG", 		Vector(858.879944, 1819.517700)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_09', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_RacistsOfNovigradHS_NG", 		Vector(553.651428, 1677.662231)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_10', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_StrangersInTheNight_NG", 		Vector(1370.983887, 1507.835815)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_11', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_StrumpetInDistress_NG", 		Vector(411.762390, 1672.084839)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_12', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_SuspiciousShakedown_NG", 		Vector(739.579529, 1761.638062)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_13', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_TheFlameOfHatred_NG_1", 		Vector(714.057678, 1861.176392)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_19', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_TheFlameOfHatred_NG_2", 		Vector(793.164673, 1868.151978)		));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_14', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_TheMostTruestOfBasilisks_NG", 	Vector(1911.729736, 1141.309082)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_15', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_ThePriceOfPassage_NG_1", 		Vector(1678.246338, 1037.727295)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_17', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_ThePriceOfPassage_NG_2", 		Vector(1766.244873, 1038.741089)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_18', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_ThePriceOfPassage_NG_3", 		Vector(1932.989990, 1070.466309)	));
		parent.RandomEvents_Novigrad.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Novigrad_16', PotP_E_Primary, PotP_R_NO, PotP_I_Event, "novigrad", "PotP_Event_WitchHunterRaids_NG", 			Vector(580.663086, 1569.924316)		));
		
		SortPreviewData(parent.RandomEvents_Novigrad, PotP_A_Event);

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_RandomEvents_Skellige';
		
		parent.RandomEvents_Skellige.Clear();
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_01', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_CallOfTheWild_NG", 		Vector(-526.447571, -340.631042)	));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_02', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_FartingTrolls_NG", 		Vector(-283.890625, -769.414673)	));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_03', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_SirensCall_NG", 			Vector(-409.181061, -202.543701)	));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_04', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_SweetBait_NG", 			Vector(-443.542175, -307.774261)	));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_05', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_TheFourFacesOfHemdall_NG", Vector(2011.217651, -1851.521729)	));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_06', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_WoeIsMe_NG", 				Vector(552.972961, -411.028778)		));
		parent.RandomEvents_Skellige.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_Skellige_07', PotP_E_Primary, PotP_R_SK, PotP_I_Event, "skellige", "PotP_Event_YustiannaDisturbed_NG", 	Vector(677.762207, 635.591064)		));
		
		SortPreviewData(parent.RandomEvents_Skellige, PotP_A_Event);

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_RandomEvents_KaerMorhen';
		
		parent.RandomEvents_KaerMorhen.Clear();
		parent.RandomEvents_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initEvent(group, 'PotP_TrackingGroup_RandomEvents_KaerMorhen_01', PotP_E_Primary, PotP_R_KM, PotP_I_Event, "kaer_morhen", "PotP_Event_TrailOfEchoes_NG", 	Vector(-327.778656, 175.190674)	));
		
		SortPreviewData(parent.RandomEvents_KaerMorhen, PotP_A_Event);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_Contracts() {	

		var group: name = 'PotP_TrackingGroup_ContractQuests_WhiteOrchard';
		
		parent.ContQuests_WhiteOrchard.Clear();
		parent.ContQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_WhiteOrchard_01', PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith"));
		
		SortPreviewData(parent.ContQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ContractQuests_Velen';
		
		parent.ContQuests_Velen.Clear();
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_01', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_02', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_03', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_04', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_05', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_06', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_07', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_08', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake "));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_09', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_10', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_11', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma"));
		parent.ContQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Velen_12', PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael"));
		
		SortPreviewData(parent.ContQuests_Velen, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ContractQuests_Novigrad';
		
		parent.ContQuests_Novigrad.Clear();
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_01', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_02', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_03', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_04', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_05', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_06', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_07', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan"));
		parent.ContQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Novigrad_08', PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih"));
		
		SortPreviewData(parent.ContQuests_Novigrad, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ContractQuests_Skellige';
		
		parent.ContQuests_Skellige.Clear();
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_01', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_02', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_03', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_04', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_05', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_06', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_07', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_08', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith"));
		parent.ContQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Skellige_09', PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit"));
		
		SortPreviewData(parent.ContQuests_Skellige, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ContractQuests_Toussaint';
		
		parent.ContQuests_Toussaint.Clear();
		parent.ContQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Toussaint_01', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars"));
		parent.ContQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Toussaint_02', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle"));
		parent.ContQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Toussaint_03', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror"));
		parent.ContQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Toussaint_04', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse"));
		parent.ContQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ContractQuests_Toussaint_05', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight"));
		
		SortPreviewData(parent.ContQuests_Toussaint, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_ScavangerHunts() {	

		var group: name = 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet';
		
		parent.ScavQuests_Griffin.Clear();
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_01', PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Set"));
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_02', PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A"));
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_03', PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B"));
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_04', PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2"));
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_05', PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3"));
		parent.ScavQuests_Griffin.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet_06', PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear"));
		
		SortPreviewData(parent.ScavQuests_Griffin, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet';
		
		parent.ScavQuests_Feline.Clear();
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_01', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Set"));
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_02', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a"));
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_03', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b"));
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_04', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2"));
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_05', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3"));
		parent.ScavQuests_Feline.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet_06', PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_cat_gear"));
		
		SortPreviewData(parent.ScavQuests_Feline, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet';
		
		parent.ScavQuests_Ursine.Clear();
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_01', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Set"));
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_02', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A"));
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_03', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B"));
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_04', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2"));
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_05', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3"));
		parent.ScavQuests_Ursine.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet_06', PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_bear_gear"));
		
		SortPreviewData(parent.ScavQuests_Ursine, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet';
		
		parent.ScavQuests_Wolven.Clear();
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_01', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Set"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_02', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_03', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_04', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_05', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_06', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_07', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b"));
		parent.ScavQuests_Wolven.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet_08', PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear"));
		
		SortPreviewData(parent.ScavQuests_Wolven, PotP_A_Quest);		

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets';
		
		parent.ScavQuests_Others.Clear();
		parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_01', PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Viper Set"));
		parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_02', PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th700_red_wolf"));

		if (PotP_IsUsingNextGen()) 
		{
			parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_06', PotP_E_Primary, 	PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades"));
		}

		if (PotP_UsingDLCArmorQuests()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/3983
		{ 
			parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_03', PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "temeriatreasurehunt"));
			parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_04', PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "nilfgaardtreasurehunt"));
			parent.ScavQuests_Others.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets_05', PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "skelligetreasurehunt"));
		}
		SortPreviewData(parent.ScavQuests_Others, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_TreasureHunts() {

		var group: name = 'PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard';
		
		parent.HuntQuests_WhiteOrchard.Clear();
		parent.HuntQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard_01', PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash"));
		parent.HuntQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard_02', PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure"));
		parent.HuntQuests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard_03', PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure"));
		
		SortPreviewData(parent.HuntQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_TreasureHuntQuests_Velen';
		
		parent.HuntQuests_Velen.Clear();
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_01', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_02', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_03', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_04', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_05', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_06', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_07', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_08', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_09', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_10', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_11', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_12', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_13', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_14', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_15', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34"));
		parent.HuntQuests_Velen.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Velen_16', PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds"));
		
		SortPreviewData(parent.HuntQuests_Velen, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad';
		
		parent.HuntQuests_Novigrad.Clear();
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_01', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26b"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_02', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi08"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_03', PotP_E_Primary, 		PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_04', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_05', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi01"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_06', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi10"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_07', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi02"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_08', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_09', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi05"));
		parent.HuntQuests_Novigrad.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad_10', PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi04"));
		
		SortPreviewData(parent.HuntQuests_Novigrad, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_TreasureHuntQuests_Skellige';
		
		parent.HuntQuests_Skellige.Clear();
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_01', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_02', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_03', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_04', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_05', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_06', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_07', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_08', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_09', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_10', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_11', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_12', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38"));
		parent.HuntQuests_Skellige.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Skellige_13', PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure"));
		
		SortPreviewData(parent.HuntQuests_Skellige, PotP_A_Quest);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint';
		
		parent.HuntQuests_Toussaint.Clear();
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_01', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_02', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_03', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_04', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_05', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_06', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_07', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_08', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_09', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_10', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_11', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_12', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_13', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_14', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10"));
		parent.HuntQuests_Toussaint.PushBack((new PotP_PreviewEntry in this).initQuest(group, 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint_15', PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03"));
		
		SortPreviewData(parent.HuntQuests_Toussaint, PotP_A_Quest);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_SteelSwords() 
	{
		var group: name;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{
			group = 'PotP_TrackingGroup_Relics_SteelSwords_W3EE';
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_01', PotP_E_Primary, PotP_I_Steel, 'Arbitrator_crafted'));                    //Arbitrator
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_02', PotP_E_Primary, PotP_I_Steel, 'Ardaenye_crafted'));                      //Ard'aenye
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_03', PotP_E_Primary, PotP_I_Steel, 'Barbersurgeon_crafted'));                 //Barber-Surgeon
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_04', PotP_E_Primary, PotP_I_Steel, 'Beannshie_crafted'));                     //Beann'shie
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_05', PotP_E_Primary, PotP_I_Steel, 'Blackunicorn_crafted'));                  //Black Unicorn
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_06', PotP_E_Primary, PotP_I_Steel, 'sq304 Novigraadan sword 4'));             //Blade from the Bits
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_07', PotP_E_Primary, PotP_I_Steel, 'Gwent steel sword 1'));                   //Blave
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_08', PotP_E_Primary, PotP_I_Steel, 'Caerme_crafted'));                        //Caerme
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_09', PotP_E_Primary, PotP_I_Steel, 'Deireadh_crafted'));                      //Deireadh
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_10', PotP_E_Primary, PotP_I_Steel, 'Devine_crafted'));                        //Devine
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_11', PotP_E_Primary, PotP_I_Steel, 'Gloryofthenorth_crafted'));               //Glory of the North
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_12', PotP_E_Primary, PotP_I_Steel, 'Robustswordofdolblathanna_crafted'));     //Glᥤdyv Blathanna
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_13', PotP_E_Primary, PotP_I_Steel, 'Knights steel sword 3'));                 //Greatsword of Camelot
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_14', PotP_E_Primary, PotP_I_Steel, 'Gwyhyr_crafted'));                        //Gwyhyr
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_15', PotP_E_Primary, PotP_I_Steel, 'Headtaker_crafted'));                     //Headhunter
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_16', PotP_E_Primary, PotP_I_Steel, 'q704 vampire steel sword'));              //Hen Gaidth steel sword
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_17', PotP_E_Primary, PotP_I_Steel, 'Inis_crafted'));                          //Inis
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_18', PotP_E_Primary, PotP_I_Steel, 'Olgierd Sabre'));                         //Iris
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_19', PotP_E_Primary, PotP_I_Steel, 'Longclaw_crafted'));                      //Longclaw
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_20', PotP_E_Primary, PotP_I_Steel, 'Lune_crafted'));                          //Lune
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_21', PotP_E_Primary, PotP_I_Steel, 'Ofir Sabre 1'));                          //Ofieri kilij
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_22', PotP_E_Primary, PotP_I_Steel, 'Crafted Ofir Steel Sword'));              //Ofieri saber
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_23', PotP_E_Primary, PotP_I_Steel, 'Crafted Burning Rose Sword'));            //Order of the Flaming Rose sword
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_24', PotP_E_Primary, PotP_I_Steel, 'Princessxenthiasword_crafted'));          //Princess Xenthia's sword
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_25', PotP_E_Primary, PotP_I_Steel, 'q702 vampire steel sword'));              //Tesham Mutna steel sword
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_26', PotP_E_Primary, PotP_I_Steel, 'PC Caretaker Shovel'));                   //The Caretaker's spade
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_27', PotP_E_Primary, PotP_I_Steel, 'Cheesecutter'));                          //The Emmentaler
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_28', PotP_E_Primary, PotP_I_Steel, 'Torlara_crafted'));                       //Tor Lara
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_29', PotP_E_Primary, PotP_I_Steel, 'Ultimatum_crafted'));                     //Ultimatum
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_30', PotP_E_Primary, PotP_I_Steel, 'Unique steel sword'));                    //Vitis
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_W3EE_31', PotP_E_Primary, PotP_I_Steel, 'q402 Skellige sword 3'));                 //Winter's Blade
			
			SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items);
			return;
		}
		
		group = 'PotP_TrackingGroup_Relics_SteelSwords';
		parent.Relic_SteelSwords.Clear();
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_01', PotP_E_Primary, PotP_I_Steel, 'Angivare'));                             // Angivare
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_02', PotP_E_Primary, PotP_I_Steel, 'Arbitrator'));                           // Arbitrator
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_03', PotP_E_Primary, PotP_I_Steel, 'Ardaenye'));                             // Ard'aenye
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_04', PotP_E_Primary, PotP_I_Steel, 'Ashrune'));                              // Ashrune
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_05', PotP_E_Primary, PotP_I_Steel, 'Barbersurgeon'));                        // Barber-Surgeon
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_06', PotP_E_Primary, PotP_I_Steel, 'Beannshie'));                            // Beann'shie
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_07', PotP_E_Primary, PotP_I_Steel, 'Serpent Steel Sword 3'));                // Belhaven blade
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_08', PotP_E_Primary, PotP_I_Steel, 'Blackunicorn'));                         // Black Unicorn
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_09', PotP_E_Primary, PotP_I_Steel, 'Novigraadan sword 4'));                  // Blade from the Bits
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_10', PotP_E_Primary, PotP_I_Steel, 'Gwent steel sword 1'));                  // Blave
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_11', PotP_E_Primary, PotP_I_Steel, 'Bloedeaedd'));                           // Bloed Aedd
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_12', PotP_E_Primary, PotP_I_Steel, 'Caerme'));                               // Caerme
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_13', PotP_E_Primary, PotP_I_Steel, 'Karabela'));                             // Carabella
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_14', PotP_E_Primary, PotP_I_Steel, 'Caroline'));                             // Caroline
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_15', PotP_E_Primary, PotP_I_Steel, 'Cleaver'));                              // Cleaver hood
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_16', PotP_E_Primary, PotP_I_Steel, 'Dyaebl'));                               // D'yaebl
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_17', PotP_E_Primary, PotP_I_Steel, 'Dancer'));                               // Dancer
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_18', PotP_E_Primary, PotP_I_Steel, 'Daystar'));                              // Daystar
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_19', PotP_E_Primary, PotP_I_Steel, 'Deireadh'));                             // Deireadh
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_20', PotP_E_Primary, PotP_I_Steel, 'Devine'));                               // Devine
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_21', PotP_E_Primary, PotP_I_Steel, 'Serpent Steel Sword 2'));                // Faithful Friend
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_22', PotP_E_Primary, PotP_I_Steel, 'Serpent Steel Sword 1'));             // Faramond's blade
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_23', PotP_E_Primary, PotP_I_Steel, 'Forgottenvransword'));                   // Forgotten vran sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_24', PotP_E_Primary, PotP_I_Steel, 'Gloryofthenorth'));                      // Glory of the North
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_25', PotP_E_Primary, PotP_I_Steel, 'Gwestog'));                              // Gwestog
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_26', PotP_E_Primary, PotP_I_Steel, 'Gwyhyr'));                               // Gwyhyr	
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_27', PotP_E_Primary, PotP_I_Steel, 'Harvall'));                              // Harvall
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_28', PotP_E_Primary, PotP_I_Steel, 'Headtaker'));                            // Headhunter
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_29', PotP_E_Primary, PotP_I_Steel, 'q704 vampire steel sword'));             // Hen Gaidth steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_30', PotP_E_Primary, PotP_I_Steel, 'Hjalmar_Short_Steel_Sword'));            // Hjalmar's steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_31', PotP_E_Primary, PotP_I_Steel, 'Vynbleidd'));                            // Hope
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_32', PotP_E_Primary, PotP_I_Steel, 'Inis'));                                 // Inis
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_33', PotP_E_Primary, PotP_I_Steel, 'Olgierd Sabre'));                        // Iris
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_34', PotP_E_Primary, PotP_I_Steel, 'Longclaw'));                             // Longclaw
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_35', PotP_E_Primary, PotP_I_Steel, 'Lune'));                                 // Lune
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_36', PotP_E_Primary, PotP_I_Steel, 'Mourner'));                              // Mourner
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_37', PotP_E_Primary, PotP_I_Steel, 'Ofir Sabre 1'));                         // Ofieri kilij		
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_38', PotP_E_Primary, PotP_I_Steel, 'Crafted Ofir Steel Sword'));             // Ofieri saber
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_39', PotP_E_Primary, PotP_I_Steel, 'Crafted Burning Rose Sword'));           // Order of the Flaming Rose sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_40', PotP_E_Primary, PotP_I_Steel, 'Iron Poker'));                           // Poker
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_41', PotP_E_Primary, PotP_I_Steel, 'Princessxenthiasword'));                 // Princess Xenthia's Sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_42', PotP_E_Primary, PotP_I_Steel, 'Squire steel sword 3'));                 // Squire's steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_43', PotP_E_Primary, PotP_I_Steel, 'Robustswordofdolblathanna'));            // Superior Dol Blathanna sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_44', PotP_E_Primary, PotP_I_Steel, 'q702 vampire steel sword'));             // Tesham Mutna steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_45', PotP_E_Primary, PotP_I_Steel, 'Cheesecutter'));                         // The Emmentaler
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_46', PotP_E_Primary, PotP_I_Steel, 'Gnomish sword 2'));                      // Tir Tochair blade 
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_47', PotP_E_Primary, PotP_I_Steel, 'Torlara'));                              // Tor Lara
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_48', PotP_E_Primary, PotP_I_Steel, 'Guard lvl2 steel sword 3'));             // Toussaint Ducal Guard Officer's steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_49', PotP_E_Primary, PotP_I_Steel, 'Guard lvl1 steel sword 3'));             // Toussaint Ducal Guardsman's steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_50', PotP_E_Primary, PotP_I_Steel, 'Knights steel sword 3'));                // Toussaint knight's steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_51', PotP_E_Primary, PotP_I_Steel, 'Toussaint steel sword 3'));              // Toussaint steel sword
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_52', PotP_E_Primary, PotP_I_Steel, 'Ultimatum'));                            // Ultimatum
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_53', PotP_E_Primary, PotP_I_Steel, 'Hanza steel sword 3'));                  // Viroledan blade
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_54', PotP_E_Primary, PotP_I_Steel, 'Unique steel sword'));                   // Vitis
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_55', PotP_E_Primary, PotP_I_Steel, 'Abarad'));                               // Winter Blade
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_56', PotP_E_Primary, PotP_I_Steel, 'q402 Skellige sword 3'));                // Winter's Blade
		parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_57', PotP_E_Primary, PotP_I_Steel, 'Wolf'));	                             // Wolf

		if (PotP_IsUsingNextGen()) 
		{
			parent.Relic_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SteelSwords_58', PotP_E_Primary, PotP_I_Steel, 'Steel Vixen'));	                      // Nine-Tailed Vixen Steel Sword
		}

		SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items);	
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_SilverSwords() 
	{
		var group: name;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{
			group = 'PotP_TrackingGroup_Relics_SilverSwords_W3EE';
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_01', PotP_E_Primary, PotP_I_Silve, 'Aerondight EP2'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_02', PotP_E_Primary, PotP_I_Silve, 'Azurewrath_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_03', PotP_E_Primary, PotP_I_Silve, 'Bloodsword_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_04', PotP_E_Primary, PotP_I_Silve, 'q704 vampire silver sword'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_05', PotP_E_Primary, PotP_I_Silve, 'EP2 Silver sword 2'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_06', PotP_E_Primary, PotP_I_Silve, 'Fate'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_07', PotP_E_Primary, PotP_I_Silve, 'Unique silver sword'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_08', PotP_E_Primary, PotP_I_Silve, 'Harpy_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_09', PotP_E_Primary, PotP_I_Silve, 'Havcaaren_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_10', PotP_E_Primary, PotP_I_Silve, 'Naevdeseidhe_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_11', PotP_E_Primary, PotP_I_Silve, 'Negotiator_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_12', PotP_E_Primary, PotP_I_Silve, 'Reachofthedamned_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_13', PotP_E_Primary, PotP_I_Silve, 'Roseofaelirenn'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_14', PotP_E_Primary, PotP_I_Silve, 'EP1 Crafted Witcher Silver Sword'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_15', PotP_E_Primary, PotP_I_Silve, 'Adversary Silver Sword'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_16', PotP_E_Primary, PotP_I_Silve, 'Virgin_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_17', PotP_E_Primary, PotP_I_Silve, 'Tlareg_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_18', PotP_E_Primary, PotP_I_Silve, 'Weeper_crafted'));
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_W3EE_19', PotP_E_Primary, PotP_I_Silve, 'Zerrikanterment_crafted'));
			
			SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items);
			return;
		}

		group = 'PotP_TrackingGroup_Relics_SilverSwords';
		parent.Relic_SilverSwords.Clear();
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_01', PotP_E_Primary, PotP_I_Silve, 'Addandeith'));                      //Addan Deith
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_02', PotP_E_Primary, PotP_I_Silve, 'Aerondight EP2'));                  //Aerondight
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_03', PotP_E_Primary, PotP_I_Silve, 'EP2 Silver sword 3R'));             //Ami
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_04', PotP_E_Primary, PotP_I_Silve, 'Anathema'));                        //Anathema
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_05', PotP_E_Primary, PotP_I_Silve, 'Anth'));                            //Anth
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_06', PotP_E_Primary, PotP_I_Silve, 'Arainne'));                         //Arainne
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_07', PotP_E_Primary, PotP_I_Silve, 'Azurewrath'));                      //Azure Wrath		
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_08', PotP_E_Primary, PotP_I_Silve, 'Bladeofys'));                       //Blade of Ys
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_09', PotP_E_Primary, PotP_I_Silve, 'WitcherSilverWolf'));               //Bleidd
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_10', PotP_E_Primary, PotP_I_Silve, 'Bloodsword'));                      //Bloodsword
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_11', PotP_E_Primary, PotP_I_Silve, 'Breathofthenorth'));                //Breath of the North
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_12', PotP_E_Primary, PotP_I_Silve, 'q704 vampire silver sword'));       //Cantata
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_13', PotP_E_Primary, PotP_I_Silve, 'EP2 Silver sword 2'));              //Casus Foederis
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_14', PotP_E_Primary, PotP_I_Silve, 'EP2 Silver sword 1R'));             //Dahlia
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_15', PotP_E_Primary, PotP_I_Silve, 'Deargdeith'));                      //Deargdeith
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_16', PotP_E_Primary, PotP_I_Silve, 'Deithwen'));                        //Deithwen
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_17', PotP_E_Primary, PotP_I_Silve, 'Fate'));                            //Fate
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_18', PotP_E_Primary, PotP_I_Silve, 'Serpent Silver Sword 1'));          //Fen'aeth
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_19', PotP_E_Primary, PotP_I_Silve, 'Unique silver sword'));             //Gesheft
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_20', PotP_E_Primary, PotP_I_Silve, 'Gynvael'));                         //Gynvael
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_21', PotP_E_Primary, PotP_I_Silve, 'Gynvaelaedd'));                     //Gynvael Aedd
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_22', PotP_E_Primary, PotP_I_Silve, 'Harpy'));                           //Harpy
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_23', PotP_E_Primary, PotP_I_Silve, 'Havcaaren'));                       //Hav'caaren
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_24', PotP_E_Primary, PotP_I_Silve, 'Loathen'));                         //Loathen
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_25', PotP_E_Primary, PotP_I_Silve, 'Aerondight'));                      //Maugrim
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_26', PotP_E_Primary, PotP_I_Silve, 'Moonblade'));                       //Moonblade
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_27', PotP_E_Primary, PotP_I_Silve, 'Naevdeseidhe'));                    //Naevde Seidhe
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_28', PotP_E_Primary, PotP_I_Silve, 'Negotiator'));                      //Negotiator
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_29', PotP_E_Primary, PotP_I_Silve, 'DLC10_Remorse'));                   //Pang of Conscience
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_30', PotP_E_Primary, PotP_I_Silve, 'Reachofthedamned'));                //Reach of the Damned
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_31', PotP_E_Primary, PotP_I_Silve, 'Roseofaelirenn'));                  //Rose of Shaerrawed
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_32', PotP_E_Primary, PotP_I_Silve, 'EP1 Crafted Witcher Silver Sword'));//Sarrim;
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_33', PotP_E_Primary, PotP_I_Silve, 'Serpent Silver Sword 2'));          //Tah'rel
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_34', PotP_E_Primary, PotP_I_Silve, 'Virgin'));                          //The Bride
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_35', PotP_E_Primary, PotP_I_Silve, 'Tlareg'));                          //Tlareg
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_36', PotP_E_Primary, PotP_I_Silve, 'Torzirael'));                       //Tor Zireael
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_37', PotP_E_Primary, PotP_I_Silve, 'mq4005 Silver sword 6_crafted'));   //Tor'haerne
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_38', PotP_E_Primary, PotP_I_Silve, 'Weeper'));                          //Weeper
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_39', PotP_E_Primary, PotP_I_Silve, 'Zerrikanterment'));                 //Zerrikanterment
		parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_40', PotP_E_Primary, PotP_I_Silve, 'q505 crafted sword'));              //Zireael	

		if (PotP_IsUsingNextGen()) 
		{
			parent.Relic_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_SilverSwords_41', PotP_E_Primary, PotP_I_Silve, 'Silver Vixen'));	              // Nine-Tailed Vixen Silver Sword
		}
		
		SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_Crossbows() 
	{
		var group: name;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = 'PotP_TrackingGroup_Relics_Crossbows_W3EE';
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_Crossbows_W3EE_01', PotP_E_Primary, PotP_I_Cross, 'Crossbow q206'));
			parent.Relic_Crossbows.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_Crossbows_W3EE_02', PotP_E_Primary, PotP_I_Cross, 'Ofir Crossbow R'));
			
			SortPreviewData(parent.Relic_Crossbows, PotP_A_Items);
			return;
		}
		
		group = 'PotP_TrackingGroup_Relics_Crossbows';
		parent.Relic_Crossbows.Clear();
		parent.Relic_Crossbows.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_Crossbows_01', PotP_E_Primary, PotP_I_Cross, 'Crossbow 7'));
		parent.Relic_Crossbows.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_Crossbows_02', PotP_E_Primary, PotP_I_Cross, 'Crossbow q206'));
		parent.Relic_Crossbows.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Relics_Crossbows_03', PotP_E_Primary, PotP_I_Cross, 'Ofir Crossbow R'));
		
		SortPreviewData(parent.Relic_Crossbows, PotP_A_Items);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_MonsterTrophies()
	{
		var group: name = 'PotP_TrackingGroup_Trophies';
		
		parent.Relic_Trophies.Clear();
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_01', PotP_E_Primary, PotP_I_Troph, 'mh102_arachas_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_02', PotP_E_Primary, PotP_I_Troph, 'sq108_griffin_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_03', PotP_E_Primary, PotP_I_Troph, 'mh201_cave_troll_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_04', PotP_E_Primary, PotP_I_Troph, 'mh107_czart_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_05', PotP_E_Primary, PotP_I_Troph, 'mh101_cockatrice_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_06', PotP_E_Primary, PotP_I_Troph, 'q603_sharley_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_07', PotP_E_Primary, PotP_I_Troph, 'mh305_doppler_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_08', PotP_E_Primary, PotP_I_Troph, 'mh306_dao_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_09', PotP_E_Primary, PotP_I_Troph, 'mh210_lamia_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_10', PotP_E_Primary, PotP_I_Troph, 'mh104_ekimma_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_11', PotP_E_Primary, PotP_I_Troph, 'mh206_fiend_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_12', PotP_E_Primary, PotP_I_Troph, 'mh108_fogling_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_13', PotP_E_Primary, PotP_I_Troph, 'mh208_forktail_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_14', PotP_E_Primary, PotP_I_Troph, 'q704_garkain_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_15', PotP_E_Primary, PotP_I_Troph, 'q701_cyclops_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_16', PotP_E_Primary, PotP_I_Troph, 'mh106_gravehag_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_17', PotP_E_Primary, PotP_I_Troph, 'mh301_gryphon_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_18', PotP_E_Primary, PotP_I_Troph, 'mq7002_spriggan_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_19', PotP_E_Primary, PotP_I_Troph, 'mh304_katakan_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_20', PotP_E_Primary, PotP_I_Troph, 'q602_pig_contest_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_21', PotP_E_Primary, PotP_I_Troph, 'mh204_leshy_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_22', PotP_E_Primary, PotP_I_Troph, 'mh202_nekker_warrior_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_23', PotP_E_Primary, PotP_I_Troph, 'mh103_nightwraith_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_24', PotP_E_Primary, PotP_I_Troph, 'mq0003_noonwraith_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_25', PotP_E_Primary, PotP_I_Troph, 'mh701_sharley_matriarch_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_26', PotP_E_Primary, PotP_I_Troph, 'mq7018_basilisk_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_27', PotP_E_Primary, PotP_I_Troph, 'mq7010_dracolizard_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_28', PotP_E_Primary, PotP_I_Troph, 'mh303_succubus_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_29', PotP_E_Primary, PotP_I_Troph, 'camm_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_30', PotP_E_Primary, PotP_I_Troph, 'mq7017_zmora_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_31', PotP_E_Primary, PotP_I_Troph, 'mh203_water_hag_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_32', PotP_E_Primary, PotP_I_Troph, 'q702_wicht_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_33', PotP_E_Primary, PotP_I_Troph, 'mh307_minion_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_34', PotP_E_Primary, PotP_I_Troph, 'mh207_wraith_trophy'));
		parent.Relic_Trophies.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_Trophies_35', PotP_E_Primary, PotP_I_Troph, 'mh105_wyvern_trophy'));
		
		SortPreviewData(parent.Relic_Trophies, PotP_A_Items);
	}	

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ArmorSets() 
	{
		var group: name;
		
		if (PotP_IsUsingNextGen()) 
		{
			group = 'PotP_TrackingGroup_GearSets_ForgottenWolven';
			parent.Armor_ForgottenWolven.Clear();
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_01', PotP_E_Primary, PotP_I_Armor, 'Netflix Armor'));
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_02', PotP_E_Primary, PotP_I_Boots, 'Netflix Boots'));
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_03', PotP_E_Primary, PotP_I_Glove, 'Netflix Gloves'));
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_04', PotP_E_Primary, PotP_I_Pants, 'Netflix Pants'));
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_05', PotP_E_Primary, PotP_I_Steel, 'Netflix steel sword'));
			parent.Armor_ForgottenWolven.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_ForgottenWolven_06', PotP_E_Primary, PotP_I_Silve, 'Netflix silver sword'));
			
			SortPreviewData(parent.Armor_ForgottenWolven, PotP_A_Items);

			//------------------------------------------------------
		
			group = 'PotP_TrackingGroup_GearSets_DolBlathanna';
			parent.Armor_DolBlathanna.Clear();
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_01', PotP_E_Primary, PotP_I_Armor, 'Dol Blathanna Armor'));
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_02', PotP_E_Primary, PotP_I_Boots, 'Dol Blathanna Boots'));
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_03', PotP_E_Primary, PotP_I_Glove, 'Dol Blathanna Gloves'));
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_04', PotP_E_Primary, PotP_I_Pants, 'Dol Blathanna Pants'));
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_05', PotP_E_Primary, PotP_I_Steel, 'Dol Blathanna longsword'));
			parent.Armor_DolBlathanna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_DolBlathanna_06', PotP_E_Primary, PotP_I_Silve, 'White Widow of Dol Blathanna'));
			
			SortPreviewData(parent.Armor_DolBlathanna, PotP_A_Items);

			//------------------------------------------------------
			
			group = 'PotP_TrackingGroup_GearSets_WhiteTiger';
			parent.Armor_WhiteTiger.Clear();
			parent.Armor_WhiteTiger.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_WhiteTiger_01', PotP_E_Primary, PotP_I_Armor, 'White Tiger Armor'));
			parent.Armor_WhiteTiger.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_WhiteTiger_02', PotP_E_Primary, PotP_I_Boots, 'White Tiger Boots'));
			parent.Armor_WhiteTiger.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_WhiteTiger_03', PotP_E_Primary, PotP_I_Glove, 'White Tiger Gloves'));
			parent.Armor_WhiteTiger.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_WhiteTiger_04', PotP_E_Primary, PotP_I_Pants, 'White Tiger Pants'));
			
			SortPreviewData(parent.Armor_WhiteTiger, PotP_A_Items);			
		}

		group = 'PotP_TrackingGroup_GearSets_HenGaidth';
		parent.Armor_HenGaidth.Clear();
		parent.Armor_HenGaidth.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_HenGaidth_01', PotP_E_Primary, PotP_I_Armor, 'q704_vampire_armor'));
		parent.Armor_HenGaidth.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_HenGaidth_02', PotP_E_Primary, PotP_I_Boots, 'q704_vampire_boots'));
		parent.Armor_HenGaidth.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_HenGaidth_03', PotP_E_Primary, PotP_I_Glove, 'q704_vampire_gloves'));
		parent.Armor_HenGaidth.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_HenGaidth_04', PotP_E_Primary, PotP_I_Head,  'q704_vampire_mask'));
		parent.Armor_HenGaidth.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_HenGaidth_05', PotP_E_Primary, PotP_I_Pants, 'q704_vampire_pants'));
		
		SortPreviewData(parent.Armor_HenGaidth, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_NewMoon';
		parent.Armor_NewMoon.Clear();
		parent.Armor_NewMoon.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_NewMoon_01', PotP_E_Primary, PotP_I_Armor, 'Thief Armor'));
		parent.Armor_NewMoon.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_NewMoon_02', PotP_E_Primary, PotP_I_Boots, 'Thief Boots'));
		parent.Armor_NewMoon.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_NewMoon_03', PotP_E_Primary, PotP_I_Glove, 'Thief Gloves'));
		parent.Armor_NewMoon.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_NewMoon_04', PotP_E_Primary, PotP_I_Pants, 'Thief Pants'));
		
		SortPreviewData(parent.Armor_NewMoon, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_Nilfgaardian';
		parent.Armor_Nilfgaardian.Clear();
		parent.Armor_Nilfgaardian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Nilfgaardian_01', PotP_E_Primary, PotP_I_Armor, 'DLC5 Nilfgaardian Armor'));
		parent.Armor_Nilfgaardian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Nilfgaardian_02', PotP_E_Primary, PotP_I_Boots, 'DLC5 Nilfgaardian Boots'));
		parent.Armor_Nilfgaardian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Nilfgaardian_03', PotP_E_Primary, PotP_I_Glove, 'DLC5 Nilfgaardian Gloves'));
		parent.Armor_Nilfgaardian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Nilfgaardian_04', PotP_E_Primary, PotP_I_Pants, 'DLC5 Nilfgaardian Pants'));
		
		SortPreviewData(parent.Armor_Nilfgaardian, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_Ofieri';
		parent.Armor_Ofieri.Clear();
		parent.Armor_Ofieri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Ofieri_01', PotP_E_Primary, PotP_I_Armor, 'Crafted Ofir Armor'));
		parent.Armor_Ofieri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Ofieri_02', PotP_E_Primary, PotP_I_Boots, 'Crafted Ofir Boots'));
		parent.Armor_Ofieri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Ofieri_03', PotP_E_Primary, PotP_I_Glove, 'Crafted Ofir Gloves'));
		parent.Armor_Ofieri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Ofieri_04', PotP_E_Primary, PotP_I_Pants, 'Crafted Ofir Pants'));
		
		SortPreviewData(parent.Armor_Ofieri, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_Temerian';
		parent.Armor_Temerian.Clear();
		parent.Armor_Temerian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Temerian_01', PotP_E_Primary, PotP_I_Armor, 'DLC1 Temerian Armor'));
		parent.Armor_Temerian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Temerian_02', PotP_E_Primary, PotP_I_Boots, 'DLC1 Temerian Boots'));
		parent.Armor_Temerian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Temerian_03', PotP_E_Primary, PotP_I_Glove, 'DLC1 Temerian Gloves'));
		parent.Armor_Temerian.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Temerian_04', PotP_E_Primary, PotP_I_Pants, 'DLC1 Temerian Pants'));
		
		SortPreviewData(parent.Armor_Temerian, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_TeshamMutna';
		parent.Armor_TeshamMutna.Clear();
		parent.Armor_TeshamMutna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_TeshamMutna_01', PotP_E_Primary, PotP_I_Armor, 'q702_vampire_armor'));
		parent.Armor_TeshamMutna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_TeshamMutna_02', PotP_E_Primary, PotP_I_Boots, 'q702_vampire_boots'));
		parent.Armor_TeshamMutna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_TeshamMutna_03', PotP_E_Primary, PotP_I_Glove, 'q702_vampire_gloves'));
		parent.Armor_TeshamMutna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_TeshamMutna_04', PotP_E_Primary, PotP_I_Head,  'q702_vampire_mask'));
		parent.Armor_TeshamMutna.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_TeshamMutna_05', PotP_E_Primary, PotP_I_Pants, 'q702_vampire_pants'));
		
		SortPreviewData(parent.Armor_TeshamMutna, PotP_A_Items);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_GearSets_Undvik';
		parent.Armor_Undvik.Clear();
		parent.Armor_Undvik.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Undvik_01', PotP_E_Primary, PotP_I_Armor, 'DLC14 Skellige Armor'));
		parent.Armor_Undvik.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Undvik_02', PotP_E_Primary, PotP_I_Boots, 'DLC14 Skellige Boots'));
		parent.Armor_Undvik.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Undvik_03', PotP_E_Primary, PotP_I_Glove, 'DLC14 Skellige Gloves'));
		parent.Armor_Undvik.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_GearSets_Undvik_04', PotP_E_Primary, PotP_I_Pants, 'DLC14 Skellige Pants'));
		
		SortPreviewData(parent.Armor_Undvik, PotP_A_Items);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ModAdded()
	{
		var group: name;
		
		if (PotP_UsingSezonBurz()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/2818
		{ 
			group = 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz';
			parent.DLC_SezonBurz.Clear();
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_01', PotP_E_ModAdded, PotP_I_Armor, 'Sezon Burz Armor'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_02', PotP_E_ModAdded, PotP_I_Pants, 'Sezon Burz Pants'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_03', PotP_E_ModAdded, PotP_I_Glove, 'Sezon Burz Gloves'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_04', PotP_E_ModAdded, PotP_I_Boots, 'Sezon Burz Boots'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_05', PotP_E_ModAdded, PotP_I_Silve, 'Sezon Burz Silver Sword'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_06', PotP_E_ModAdded, PotP_I_Steel, 'Sezon Burz Steel Sword'));
			parent.DLC_SezonBurz.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_SezonBurz_07', PotP_E_ModAdded, PotP_I_Cross, 'Sezon Burz Crossbow 1'));
			
			SortPreviewData(parent.DLC_SezonBurz, PotP_A_Items);
		}

		//------------------------------------------------------

		if (PotP_UsingCosWiecej()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5986
		{ 
			group = 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej';
			parent.DLC_CosWiecej.Clear();
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_01', PotP_E_ModAdded, PotP_I_Armor, 'wiecej'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_02', PotP_E_ModAdded, PotP_I_Glove, 'wiecej gloves'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_03', PotP_E_ModAdded, PotP_I_Pants, 'wiecej pants'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_04', PotP_E_ModAdded, PotP_I_Boots, 'wiecej boots'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_05', PotP_E_ModAdded, PotP_I_Steel, 'wiecej steel'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_06', PotP_E_ModAdded, PotP_I_Silve, 'wiecej silver'));
			parent.DLC_CosWiecej.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_CosWiecej_07', PotP_E_ModAdded, PotP_I_Steel, 'rune sihil'));
			
			SortPreviewData(parent.DLC_CosWiecej, PotP_A_Items);
		}

		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic';
			parent.DLC_Gothic.Clear();
			parent.DLC_Gothic.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic_01', PotP_E_ModAdded, PotP_I_Armor, 'kotw_armor_v1_1'));
			parent.DLC_Gothic.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic_02', PotP_E_ModAdded, PotP_I_Glove, 'kotw_gloves_v1_1'));
			parent.DLC_Gothic.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic_03', PotP_E_ModAdded, PotP_I_Pants, 'kotw_legs_v1_1'));
			parent.DLC_Gothic.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic_04', PotP_E_ModAdded, PotP_I_Boots, 'kotw_boots_v1_1'));
			parent.DLC_Gothic.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic_05', PotP_E_ModAdded, PotP_I_Head,  'kotw_helm_v1_1_usable'));
			
			SortPreviewData(parent.DLC_Gothic, PotP_A_Items);
			
			//------------------------------------------------------
			
			group = 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite';
			parent.DLC_Meteorite.Clear();
			parent.DLC_Meteorite.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite_01', PotP_E_ModAdded, PotP_I_Armor, 'kotw_armor_v2_1'));
			parent.DLC_Meteorite.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite_02', PotP_E_ModAdded, PotP_I_Glove, 'kotw_gloves_v2_1'));
			parent.DLC_Meteorite.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite_03', PotP_E_ModAdded, PotP_I_Pants, 'kotw_legs_v2_1'));
			parent.DLC_Meteorite.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite_04', PotP_E_ModAdded, PotP_I_Boots, 'kotw_boots_v2_1'));
			parent.DLC_Meteorite.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite_05', PotP_E_ModAdded, PotP_I_Head,  'kotw_helm_v2_1_usable'));
			
			SortPreviewData(parent.DLC_Meteorite, PotP_A_Items);
			
			//------------------------------------------------------
			
			group = 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium';
			parent.DLC_Dimeritium.Clear();
			parent.DLC_Dimeritium.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium_01', PotP_E_ModAdded, PotP_I_Armor, 'kotw_armor_v3_1'));
			parent.DLC_Dimeritium.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium_02', PotP_E_ModAdded, PotP_I_Glove, 'kotw_gloves_v3_1'));
			parent.DLC_Dimeritium.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium_03', PotP_E_ModAdded, PotP_I_Pants, 'kotw_legs_v3_1'));
			parent.DLC_Dimeritium.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium_04', PotP_E_ModAdded, PotP_I_Boots, 'kotw_boots_v3_1'));
			parent.DLC_Dimeritium.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium_05', PotP_E_ModAdded, PotP_I_Head,  'kotw_helm_v3_1_usable'));
			
			SortPreviewData(parent.DLC_Dimeritium, PotP_A_Items);
		}
	}	

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ShadesOfIronGearSets()
	{
		var group: name = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker';
		parent.Shades_Berserker.Clear();
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Berserker Armor'));
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_02', PotP_E_ModAdded, PotP_I_Head,  'Shades Berserker Cage'));
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Berserker Gloves'));
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_04', PotP_E_ModAdded, PotP_I_Boots, 'Shades Berserker Boots'));
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Berserker Helm'));
		parent.Shades_Berserker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker_06', PotP_E_ModAdded, PotP_I_Pants, 'Shades Berserker Pants'));
			
		SortPreviewData(parent.Shades_Berserker, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck';
		parent.Shades_Bismarck.Clear();
		parent.Shades_Bismarck.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Bismarck Armor'));
		parent.Shades_Bismarck.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Bismarck Boots'));
		parent.Shades_Bismarck.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Bismarck Gloves'));
		parent.Shades_Bismarck.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Bismarck Pants'));
		parent.Shades_Bismarck.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Bismarck Helm'));
			
		SortPreviewData(parent.Shades_Bismarck, PotP_A_Items);			

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter';
		parent.Shades_BloodHunter.Clear();
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_01', PotP_E_ModAdded, PotP_I_Boots, 'Shades Hunter Boots'));
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_02', PotP_E_ModAdded, PotP_I_Armor, 'Shades Hunter Armor'));
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Hunter Gloves'));
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_04', PotP_E_ModAdded, PotP_I_Head,  'Shades Hunter Hat'));
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Hunter Mask'));
		parent.Shades_BloodHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter_06', PotP_E_ModAdded, PotP_I_Pants, 'Shades Hunter Pants'));
			
		SortPreviewData(parent.Shades_BloodHunter, PotP_A_Items);			

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow';
		parent.Shades_CrowFeathered.Clear();
		parent.Shades_CrowFeathered.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Crow Armor'));
		parent.Shades_CrowFeathered.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Crow Boots'));
		parent.Shades_CrowFeathered.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Crow Gloves'));
		parent.Shades_CrowFeathered.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Crow Pants'));
		parent.Shades_CrowFeathered.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Crow Mask'));
			
		SortPreviewData(parent.Shades_CrowFeathered, PotP_A_Items);	

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight';
		parent.Shades_FallenKnight.Clear();
		parent.Shades_FallenKnight.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Fallen Armor'));
		parent.Shades_FallenKnight.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Fallen Boots'));
		parent.Shades_FallenKnight.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Fallen Gloves'));
		parent.Shades_FallenKnight.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Fallen Pants'));
		parent.Shades_FallenKnight.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Fallen Helm'));
			
		SortPreviewData(parent.Shades_FallenKnight, PotP_A_Items);			

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam';
		parent.Shades_Faraam.Clear();
		parent.Shades_Faraam.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Faraam Armor'));
		parent.Shades_Faraam.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Faraam Boots'));
		parent.Shades_Faraam.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Faraam Gloves'));
		parent.Shades_Faraam.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Faraam Pants'));
		parent.Shades_Faraam.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Faraam Helm'));
			
		SortPreviewData(parent.Shades_Faraam, PotP_A_Items);				

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker';
		parent.Shades_Headtaker.Clear();
		parent.Shades_Headtaker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Headtaker Armor'));
		parent.Shades_Headtaker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Headtaker Boots'));
		parent.Shades_Headtaker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Headtaker Gloves'));
		parent.Shades_Headtaker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Headtaker Pants'));
		parent.Shades_Headtaker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Headtaker Mask'));
			
		SortPreviewData(parent.Shades_Headtaker, PotP_A_Items);
		
		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri';
		parent.Shades_Hitokiri.Clear();
		parent.Shades_Hitokiri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Viper Armor'));
		parent.Shades_Hitokiri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Viper Boots'));
		parent.Shades_Hitokiri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Viper Gloves'));
		parent.Shades_Hitokiri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Viper Pants'));
		parent.Shades_Hitokiri.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Hitokiri Mask'));
			
		SortPreviewData(parent.Shades_Hitokiri, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara';
		parent.Shades_Kara.Clear();
		parent.Shades_Kara.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Kara Armor'));
		parent.Shades_Kara.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Kara Boots'));
		parent.Shades_Kara.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Kara Gloves'));
		parent.Shades_Kara.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Kara Pants'));
		parent.Shades_Kara.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Kara Hat'));
			
		SortPreviewData(parent.Shades_Kara, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter';
		parent.Shades_LionHunter.Clear();
		parent.Shades_LionHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Lionhunter Armor'));
		parent.Shades_LionHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Lionhunter Boots'));
		parent.Shades_LionHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Lionhunter Gloves'));
		parent.Shades_LionHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Lionhunter Pants'));
		parent.Shades_LionHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Lionhunter Hat'));
			
		SortPreviewData(parent.Shades_LionHunter, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin';
		parent.Shades_Assassin.Clear();
		parent.Shades_Assassin.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Ezio Armor'));
		parent.Shades_Assassin.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Ezio Boots'));
		parent.Shades_Assassin.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Ezio Gloves'));
		parent.Shades_Assassin.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Ezio Pants'));
		parent.Shades_Assassin.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Ezio Hood'));
			
		SortPreviewData(parent.Shades_Assassin, PotP_A_Items);		

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter';
		parent.Shades_OldHunter.Clear();
		parent.Shades_OldHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Oldhunter Armor'));
		parent.Shades_OldHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Oldhunter Boots'));
		parent.Shades_OldHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Oldhunter Gloves'));
		parent.Shades_OldHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Oldhunter Pants'));
		parent.Shades_OldHunter.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Oldhunter Cap'));
			
		SortPreviewData(parent.Shades_OldHunter, PotP_A_Items);	

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant';
		parent.Shades_Revenant.Clear();
		parent.Shades_Revenant.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Revenant Armor'));
		parent.Shades_Revenant.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Revenant Boots'));
		parent.Shades_Revenant.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Revenant Gloves'));
		parent.Shades_Revenant.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Revenant Pants'));
		parent.Shades_Revenant.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Revenant Hood'));
			
		SortPreviewData(parent.Shades_Revenant, PotP_A_Items);	

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker';
		parent.Shades_Stalker.Clear();
		parent.Shades_Stalker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Undertaker Armor'));
		parent.Shades_Stalker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Undertaker Boots'));
		parent.Shades_Stalker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Undertaker Gloves'));
		parent.Shades_Stalker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Undertaker Pants'));
		parent.Shades_Stalker.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Undertaker Mask'));
			
		SortPreviewData(parent.Shades_Stalker, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng';
		parent.Shades_Taifeng.Clear();
		parent.Shades_Taifeng.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Taifeng Armor'));
		parent.Shades_Taifeng.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Taifeng Boots'));
		parent.Shades_Taifeng.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Taifeng Gloves'));
		parent.Shades_Taifeng.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Taifeng Pants'));
		parent.Shades_Taifeng.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Ronin Hat'));
			
		SortPreviewData(parent.Shades_Taifeng, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen';
		parent.Shades_Unseen.Clear();
		parent.Shades_Unseen.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Yahargul Armor'));
		parent.Shades_Unseen.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen_02', PotP_E_ModAdded, PotP_I_Boots, 'Shades Yahargul Boots'));
		parent.Shades_Unseen.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen_03', PotP_E_ModAdded, PotP_I_Glove, 'Shades Yahargul Gloves'));
		parent.Shades_Unseen.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen_04', PotP_E_ModAdded, PotP_I_Pants, 'Shades Yahargul Pants'));
		parent.Shades_Unseen.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen_05', PotP_E_ModAdded, PotP_I_Head,  'Shades Yahargul Helm'));
			
		SortPreviewData(parent.Shades_Unseen, PotP_A_Items);		

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis';
		parent.Shades_Sithis.Clear();
		parent.Shades_Sithis.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis_01', PotP_E_ModAdded, PotP_I_Armor, 'Shades Sithis Armor'));
		parent.Shades_Sithis.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis_02', PotP_E_ModAdded, PotP_I_Head, 'Shades Sithis Hood'));
			
		SortPreviewData(parent.Shades_Sithis, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ShadesOfIronSwords() 
	{
		var group: name = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords';
		parent.Shades_SilverSwords.Clear();
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_01', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Eagle Sword'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_02', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Ares'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_03', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Doomblade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_04', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Beastcutter'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_05', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Blackdawn'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_06', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Blooddusk'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_07', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Bloodletter'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_08', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Bloodshot'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_09', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Claymore'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_10', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Kingslayer'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_11', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Cursed Khopesh'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_12', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Dragonbane'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_13', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Ejderblade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_14', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Flameborn'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_15', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Frostmourne'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_16', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Gorgonslayer'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_17', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Graveripper'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_18', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Guandao'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_19', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Crownbreaker'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_20', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Hades Grasp'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_21', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Haoma'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_22', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Heavenspire'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_23', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Hellspire'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_24', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Icarus Tears'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_25', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Ryu Katana'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_26', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Lion Sword'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_27', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Oathblade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_28', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Oblivion'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_29', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Hitokiri Katana'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_30', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Pridefall'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_31', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Rakuyo'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_32', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Realmdrifter Blade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_33', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Realmdrifter Divider'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_34', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Kukri'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_35', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Sinner'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_36', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Sithis Blade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_37', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Voidblade'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_38', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Vulcan'));
		parent.Shades_SilverSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords_39', PotP_E_ModAdded, PotP_I_Silve, 'Shades Silver Knife'));
			
		SortPreviewData(parent.Shades_SilverSwords, PotP_A_Items);

		//------------------------------------------------------
			
		group = 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords';
		parent.Shades_SteelSwords.Clear();
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_01', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Eagle Sword'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_02', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Ares'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_03', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Doomblade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_04', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Beastcutter'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_05', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Blackdawn'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_06', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Blooddusk'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_07', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Bloodletter'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_08', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Bloodshot'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_09', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Claymore'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_10', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Kingslayer'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_11', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Cursed Khopesh'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_12', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Dragonbane'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_13', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Ejderblade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_14', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Flameborn'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_15', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Frostmourne'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_16', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Gorgonslayer'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_17', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Graveripper'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_18', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Guandao'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_19', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Crownbreaker'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_20', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Hades Grasp'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_21', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Haoma'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_22', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Heavenspire'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_23', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Hellspire'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_24', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Icarus Tears'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_25', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Ryu Katana'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_26', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Lion Sword'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_27', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Oathblade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_28', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Oblivion'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_29', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Hitokiri Katana'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_30', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Pridefall'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_31', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Rakuyo'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_32', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Realmdrifter Blade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_33', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Realmdrifter Divider'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_34', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Kukri'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_35', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Sinner'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_36', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Sithis Blade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_37', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Voidblade'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_38', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Vulcan'));
		parent.Shades_SteelSwords.PushBack((new PotP_PreviewEntry in this).initItems(group, 'PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords_39', PotP_E_ModAdded, PotP_I_Steel, 'Shades Steel Knife'));
			
		SortPreviewData(parent.Shades_SteelSwords, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_BanditCamps() 
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard';
		
		parent.BanditCamps_WhiteOrchard.Clear();
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_01', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_camp'));     
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_02', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire2')); 
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_03', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire3')); 
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_04', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_road'));     
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_05', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire'));  
		parent.BanditCamps_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard_06', PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_sanctuary'));
		
		SortPreviewData(parent.BanditCamps_WhiteOrchard, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige';
		
		parent.BanditCamps_Skellige.Clear();
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_01', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk10_mp_giantfoot_skellige'));
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_02', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk16_mp'));
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_03', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk28_mp'));
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_04', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk36_mp'));
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_05', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk111_mp_skellige'));
		parent.BanditCamps_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige_06', PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk86_mp_skl'));
		
		SortPreviewData(parent.BanditCamps_Skellige, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint';
		
		parent.BanditCamps_Toussaint.Clear();
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_01', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_17_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_02', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_09_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_03', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_07_mp_b'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_04', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_car_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_05', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_06', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_18_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_07', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_b_06_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_08', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_07_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_09', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_13_mp_ban'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_10', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_11', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_a_09_mp_b'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_12', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_13', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_12_mp_b'));
		parent.BanditCamps_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint_14', PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_vin_b_06_mp'));
		
		SortPreviewData(parent.BanditCamps_Toussaint, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad';
		
		parent.BanditCamps_Novigrad.Clear();
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_01', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gf42'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_02', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_hs16'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_03', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi17_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_04', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'gf203_mp_nml'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_05', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi16_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_06', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi23_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_07', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi09_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_08', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi_ofir_camp_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_09', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi11_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_10', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi12_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_11', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi13_mp'));
		parent.BanditCamps_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad_12', PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi14_mp'));
		
		SortPreviewData(parent.BanditCamps_Novigrad, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen';
		
		parent.BanditCamps_Velen.Clear();
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_01', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de2'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_02', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cb18'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_03', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_bm2'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_04', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de101'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_05', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de102'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_06', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de25'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_07', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gr31'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_08', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'pit_camp_nml_mp'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_09', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'mp2_nml_mappin'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_10', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cp37'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_11', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb23'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_12', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb30'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_13', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb20'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_14', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb12'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_15', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb5'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_16', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb7_camp_mp'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_17', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb5b_mp_nml_yet'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_18', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb7'));
		parent.BanditCamps_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen_19', PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb18'));
		
		SortPreviewData(parent.BanditCamps_Velen, PotP_A_World);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_MonsterDens()
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_MonsterDens_Velen';
		
		parent.MonsterDens_Velen.Clear();
		parent.MonsterDens_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Velen_01', PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gr38'));
		parent.MonsterDens_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Velen_02', PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de24'));
		
		SortPreviewData(parent.MonsterDens_Velen, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad';
		
		parent.MonsterDens_Novigrad.Clear();
		parent.MonsterDens_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad_01', PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gf2'));
		parent.MonsterDens_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad_02', PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de30'));
		
		SortPreviewData(parent.MonsterDens_Novigrad, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige';
		
		parent.MonsterDens_Skellige.Clear();
		parent.MonsterDens_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige_01', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk12_mp'));
		parent.MonsterDens_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige_02', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk25_mp'));
		parent.MonsterDens_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige_03', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk60_mp'));
		parent.MonsterDens_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige_04', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk86_mp'));
		
		SortPreviewData(parent.MonsterDens_Skellige, PotP_A_World);

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint';
		
		parent.MonsterDens_Toussaint.Clear();
		parent.MonsterDens_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint_01', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_05_mp'));
		parent.MonsterDens_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint_02', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_ved_a_04_mp'));
		parent.MonsterDens_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint_03', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_dun_a_04_cave_mp'));
		parent.MonsterDens_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint_04', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_gor_b_11_mp'));
		parent.MonsterDens_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint_05', PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_14_mp'));
		
		SortPreviewData(parent.MonsterDens_Toussaint, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_MonsterNests()
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard';
		
		parent.MonsterNests_WhiteOrchard.Clear();
		parent.MonsterNests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard_01', PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_hengestone_ghoulnest_pin'));
		parent.MonsterNests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard_02', PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_monster_nest_ghoul5'));
		parent.MonsterNests_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard_03', PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_ghouls_nest01'));
		
		SortPreviewData(parent.MonsterNests_WhiteOrchard, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen';
		
		parent.MonsterNests_Velen.Clear();
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_01', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr36_nekkers_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_02', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr16_pc_nest_rotfiend'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_03', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr28_harpynest_01'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_04', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_mp4_rotfiend_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_05', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_1'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_06', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_boss'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_07', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_08', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul_01'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_09', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_10', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp34_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_11', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_12', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'nml_cp5_nest_mp'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_13', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'de8_nekker_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_14', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_1'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_15', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_4'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_16', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_2'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_17', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_01'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_18', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_02'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_19', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp21_drowner_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_20', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'bm7_drowners_nest'));
		parent.MonsterNests_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen_21', PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'hs13_rotfiend_nest'));		
		
		SortPreviewData(parent.MonsterNests_Velen, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad';
		
		parent.MonsterNests_Novigrad.Clear();
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_01', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_34_mp'));
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_02', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'lw_nest_ep1_poi_31_mp'));
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_03', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_19_mp'));
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_04', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi32_nest'));
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_05', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest01'));
		parent.MonsterNests_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad_06', PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest02'));	
		
		SortPreviewData(parent.MonsterNests_Novigrad, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige';
		
		parent.MonsterNests_Skellige.Clear();
		parent.MonsterNests_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige_01', PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk15_drowner_nest'));
		parent.MonsterNests_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige_02', PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk14_nest_sirens'));
		parent.MonsterNests_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige_03', PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk74_harpy_nest'));
		parent.MonsterNests_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige_04', PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk75_siren_nest'));
		parent.MonsterNests_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige_05', PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk_poi_107_nest'));
		
		SortPreviewData(parent.MonsterNests_Skellige, PotP_A_World);

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint';
		
		parent.MonsterNests_Toussaint.Clear();
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_01', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_01'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_02', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_02'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_03', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_gor_b_13_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_04', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_b_05_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_05', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_dun_a_04_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_06', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_a_03_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_07', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_car_b_09_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_08', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'lw_ww_poi_bel_8_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_09', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_b_07_mp'));
		parent.MonsterNests_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint_10', PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_a_13_nest'));
		
		SortPreviewData(parent.MonsterNests_Toussaint, PotP_A_World);		
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_PlacesOfPower() 
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard';
		
		parent.PlacesOfPower_WhiteOrchard.Clear();
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_01', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_ignii_prologue_01'));
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_02', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_axii_prologue_04'));
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_03', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_aard_prologue_02'));
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_04', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_quen_prologue_03'));
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_05', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'pop_quen2_prlg'));
		parent.PlacesOfPower_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard_06', PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_yrden_prologue_05'));
		
		SortPreviewData(parent.PlacesOfPower_WhiteOrchard, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen';
		
		parent.PlacesOfPower_Velen.Clear();
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_01', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_ignii2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_02', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_aard'));
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_03', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'lw_ancient_castle_pop'));
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_04', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_quen2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_05', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_yrden2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen_06', PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_yrden'));
		
		SortPreviewData(parent.PlacesOfPower_Velen, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad';
		
		parent.PlacesOfPower_Novigrad.Clear();
		parent.PlacesOfPower_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad_01', PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_axii'));
		parent.PlacesOfPower_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad_02', PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_ignii'));
		
		SortPreviewData(parent.PlacesOfPower_Novigrad, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige';
		
		parent.PlacesOfPower_Skellige.Clear();
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_01', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_ignii2_new'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_02', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_mp_igniii_skellige'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_03', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_axii2_new'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_04', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_axii'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_05', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_aard'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_06', PotP_R_SK, PotP_I_Place, PotP_E_Missable, 'skl_pop_quen2_new'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_07', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_quen_skellige_mp'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_08', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_yrden2_new'));
		parent.PlacesOfPower_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige_09', PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_yrden_mp_skellige'));
		
		SortPreviewData(parent.PlacesOfPower_Skellige, PotP_A_World);		

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen';
		
		parent.PlacesOfPower_KaerMorhen.Clear();
		parent.PlacesOfPower_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen_01', PotP_R_KM, PotP_I_Place, PotP_E_Primary, 	'km_mp_pop_igniii'));
		
		SortPreviewData(parent.PlacesOfPower_KaerMorhen, PotP_A_World);	

		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint';
		
		parent.PlacesOfPower_Toussaint.Clear();
		parent.PlacesOfPower_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint_01', PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_igni_0001'));
		parent.PlacesOfPower_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint_02', PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_axii_0001'));
		parent.PlacesOfPower_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint_03', PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_aard_0001'));
		parent.PlacesOfPower_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint_04', PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_quen_0002'));
		parent.PlacesOfPower_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint_05', PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_yrden_0002'));
		
		SortPreviewData(parent.PlacesOfPower_Toussaint, PotP_A_World);	
		
		//------------------------------------------------------

		group = 'PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral';
		
		parent.PlacesOfPower_TheSpiral.Clear();
		parent.PlacesOfPower_TheSpiral.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral_01', PotP_R_TS, PotP_I_Place, PotP_E_Missable, 	'aard_gasforest'));
		
		SortPreviewData(parent.PlacesOfPower_TheSpiral, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	latent function Initialise_WorldMap_Signposts_1() 
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen';
		
		parent.Signposts_KaerMorhen.Clear();
		parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_01', PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 	'morhen_eye'));
		parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_02', PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 	'morhen_mine_dam'));
		parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_03', PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 	'kaer_morhen_entrance'));
		parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_04', PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 	'lake_house'));
		parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_05', PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 	'km_outpost_ruins'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{ 
			parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_06', PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 	'chort_cave'));
			parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_07', PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 	'circle_of_elements'));
			parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_08', PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 	'kaer_morhen_courtyard'));
			parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_09', PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 	'kaer_morhen_valley'));
			parent.Signposts_KaerMorhen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen_10', PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 	'trials_cave'));
		}

		SortPreviewData(parent.Signposts_KaerMorhen, PotP_A_World);	
		
		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen';
		
		parent.Signposts_Novigrad.Clear();
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_01', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'demolished_mansion'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_02', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_farmstead'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_03', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'retting_ponds'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_04', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_arnskrone_castle'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_05', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_marsh_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_06', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_wedding_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_07', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_windmill_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_08', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'smugglers_den'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_09', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_lighthouse_last_hope'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_10', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'rocky_pass'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_11', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'goose_cunt_inn'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_12', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_windmill'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_13', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'noonwraith_tower'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_14', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_dragon_valley_outpost'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_15', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'temple_isle_round_square'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_16', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_forest_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_17', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'philippa_ruins'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_18', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'eternal_fire_chapel'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_19', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_road_to_olgiers'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_20', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_southeast_gate_1'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_21', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_south_gate_2'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_22', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_grainfields'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_23', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_ruin_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_24', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_herbalist'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_25', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'triss_house'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_26', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'noblemans_estate'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_27', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_hunters_hut'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_28', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'midget_forgers'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_29', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_kilkerin'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_30', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'grassy_knoll_lighthouse'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_31', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'dwarven_woodchucks'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_32', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'lucjans_windmill'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_33', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'plantation_estate'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_34', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'vacant_estate'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_35', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_piers'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_36', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'oxenfurt_east'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_37', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_east_gate_2'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_38', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'oxenfurt_harbor'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_39', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_shouth_gate_1'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_40', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_vinyards'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_41', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'seven_cats_inn'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_42', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'novigrad_east_gate_1'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_43', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'temple_bridge_south'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_44', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'roches_camp'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_45', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'nov_main_gate'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_46', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_ofir_camp'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_47', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ursten'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_48', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'dawn_estate_entrance'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_49', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_hilltop'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_50', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_von_everecs_mansion'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_51', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'oxenfurt_west'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_52', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'cropfields'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_53', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'widow_cave'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_54', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'gustfields_vinyard_farmstead'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_55', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'Slone_village'));
		parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_56', PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 	'ep1_zutzer_castle'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_88', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'barrengarth'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_89', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'crippled_kate'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_90', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'farcorners'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_91', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'novigrad_gildorf'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_92', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'novigrad_harborside'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_93', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'hattori_workshop'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_94', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'novigrad_bridge'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_95', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'oxenfurt_academy'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_96', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'passiflora'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_97', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'bathhouse'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_98', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'novigrad_silverton'));
			parent.Signposts_Novigrad.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad_99', PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 	'novigrad_bits'));
		}
		
		SortPreviewData(parent.Signposts_Novigrad, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_Signposts_2()
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_Signposts_Skellige';
		
		parent.Signposts_Skellige.Clear();
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_01', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'abandoned_lumber_mill'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_02', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'undvik_village_2'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_03', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'elven_vault'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_04', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'arinbjorn'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_05', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'rocky_bay'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_06', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'blandare_village'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_07', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'ravens_home_ruins'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_08', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'kaer_trolde_bridge'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_09', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'undvik_blacksmith'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_10', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'stolen_road'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_11', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'distillery'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_12', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'ice_giant_village'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_13', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'druid_camp'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_14', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'northern_torch'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_15', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'southern_torch'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_16', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'fayrlund'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_17', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'halgrims_village'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_18', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'herbarium'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_19', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'fyresdal'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_20', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'holy_oak'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_21', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'giants_foot'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_22', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'arsehole_cave'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_23', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'q210_vantage_point'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_24', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'faroe_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_25', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'holmstein_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_26', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'spikeroog_arena_village'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_27', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'huindarsfjal_destroyed_farmstead'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_28', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'prison_island'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_29', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'fort_gelen'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_30', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'lugos_keep'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_31', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'craite_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_32', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'larvik'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_33', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'lofotten'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_34', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'lofoten_cemetery'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_35', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'lurthen'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_36', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'undvik_shore_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_37', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'miners_camp'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_38', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'spikeroog_ruins'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_39', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'ancient_perimeter'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_40', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'rannvaig'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_41', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'redgill'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_42', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'ragnar_village'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_43', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'the_roast_kipper_tavern'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_44', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'sheperd_huts'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_45', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'spikeroog_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_46', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'q210_avallach_lab'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_47', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'the_ridge'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_48', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'faroe_harbor_2'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_49', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'an_skellig_harbor'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_50', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'undvik_village_3'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_51', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'whaleyard'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_52', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'wild_shores'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_53', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'ridgetop'));
		parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_54', PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 	'skellige_tomb_3'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_90', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'ard_hugtand'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_91', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'castle_tuirseach'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_92', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'kaer_dhu'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_93', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'kaer_nyssen'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_94', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'kaer_trolde_village'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_95', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'melusine_cave'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_96', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'snidhall_isle'));
			parent.Signposts_Skellige.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Skellige_97', PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 	'hemdall_shrine'));
		}
		
		SortPreviewData(parent.Signposts_Skellige, PotP_A_World);	

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard';
		
		parent.Signposts_WhiteOrchard.Clear();
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_01', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'well_village'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_02', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'Broken_bridge'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_03', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'bridge_gate'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_04', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'Crossroads'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_05', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'River_crossing'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_06', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'Windmill'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_07', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'Nilfgaard_camp'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_08', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'ransacked_village'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_09', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'woodcutters_lodge'));
		parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_10', PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 	'woesong_bridge'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_WhiteOrchard.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard_11', PotP_R_WO, PotP_I_Signs, PotP_E_ModAdded, 	'king_desmond_bridge'));
		}
		
		SortPreviewData(parent.Signposts_WhiteOrchard, PotP_A_World);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_Signposts_3()
	{
		var group: name = 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint';
		
		parent.Signposts_Toussaint.Clear();
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_01', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'ardaiso_quarry_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_02', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'swamps_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_03', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'lake_village_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_04', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'beauclair_palace_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_05', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'beauclair_harbor_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_06', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'belgard_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_07', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'castel_ravello_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_08', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'casteldaccia_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_09', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'longhollow_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_10', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'beauclair_north_gate_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_11', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'coronata_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_12', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'corvo_bianco_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_13', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'watermill_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_14', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'windmill_west_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_15', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'dun_tynne_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_16', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'northern_dun_tynne_crossing_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_17', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'dun_tynne_vineyards_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_18', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'flovive_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_19', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'abandoned_castle_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_20', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'old_ruins_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_21', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'fox_hollow_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_22', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'francollarts_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_23', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'gelenser_farmstead_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_24', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'harbour_gate_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_25', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'ronneville_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_26', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'temple_gate_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_27', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'old_cemetery_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_28', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'beauclair_east_gate_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_29', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'mont_crane_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_30', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'upper_city_harbor_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_31', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'palace_gardens_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_32', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'vermentino_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_33', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'feet_of_lebioda_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_34', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'sawmill_village_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_35', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'lower_city_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_36', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'windmills_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_37', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'elven_ruins_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_38', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'termes_ruins_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_39', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'tesham_mutna_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_40', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'cockatrice_inn_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_41', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'main_square_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_42', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'village_by_swamp_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_43', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'tournament_meadows_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_44', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'prison_island_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_45', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'merchants_camp_ft'));
		parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_46', PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 	'trastamara_mansion_ft'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_90', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'abandoned_storehouse'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_91', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'bastoy_prison_ruins'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_92', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'doren_alma_estate'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_93', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'lac_celavy'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_94', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'lafargue_workshop'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_95', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'belles'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_96', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'vermentino_vineyard'));
			parent.Signposts_Toussaint.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint_97', PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 	'villa_vedette'));
		}
		
		SortPreviewData(parent.Signposts_Toussaint, PotP_A_World);	

		//------------------------------------------------------
		
		group = 'PotP_TrackingGroup_WorldMap_Signposts_Velen';
		
		parent.Signposts_Velen.Clear();
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_01', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'cp_abandoned_tower'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_02', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'incredibly_big_tree'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_03', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'mire_slaver_camp'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_04', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'benek_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_05', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'snots_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_06', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'boatmakers_hut'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_07', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'halver_isle'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_08', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'burned_ruins'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_09', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'mire_brickmakers'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_10', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'glinsk_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_11', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'shipwreck_shore'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_12', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'stray_kings_quarry'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_13', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'massacred_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_14', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'road_to_baldenfort'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_15', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'barons_yard'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_16', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'baldenfort_bastion'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_17', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'plague_pit'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_18', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'downwarren'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_19', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'griffin_dungeon_exit'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_20', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'mire_deserted_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_21', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'roadside_chapel'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_22', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'bayors_ferry_station'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_23', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'sb_forest_house'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_24', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'mudwell'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_25', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'popiels_tower'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_26', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'Dungeon 5'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_27', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'nml_hangman_tree'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_28', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'hangmans_ave'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_29', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'wagon_top'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_30', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'heatherton_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_31', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'fort_mar'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_32', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'fortfified_farmstead'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_33', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'crossroads_inn'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_34', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'seaside_shack'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_35', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'swamp_edge'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_36', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'midcopse'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_37', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'reef_fort'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_38', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'lanka_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_39', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'marauders_bridge'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_40', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'mouth_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_41', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'poppystone'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_42', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'novigrad_garrison'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_43', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'willows_grove'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_44', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'rudnik'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_45', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'descent_hunting_lodge'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_46', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'doomsday_worshippers'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_47', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'bald_mountain'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_48', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'cb_swamp_ruins'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_49', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'freckle_hill'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_50', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'ladies_of_the_wood'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_51', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'toderas_village'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_52', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'old_bridge'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_53', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'haunted_estate'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_54', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'debris_fort'));
		parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_55', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 	'sacred_circle'));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_56', PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_castle'));
		}
		
		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_90', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'crookback_bog'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_92', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'honorton'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_93', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'mowshurst'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_94', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'oxenfurt_bridge'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_95', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'pellar_hut'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_96', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'witch_hut'));
			parent.Signposts_Velen.PushBack((new PotP_PreviewEntry in this).initWorld(group, 'PotP_TrackingGroup_WorldMap_Signposts_Velen_97', PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 	'nilfgaardian_camp'));
		}
		
		SortPreviewData(parent.Signposts_Velen, PotP_A_World);	
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Monsters() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Monsters';
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_01', PotP_E_Primary, PotP_I_Monst, 'BASEDECK'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_02', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_bronze'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_03', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_silver'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_04', PotP_E_Missable,PotP_I_Monst, 'gwint_card_eredin_gold'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_05', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_platinium'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_06', PotP_E_Primary, PotP_I_Monst, 'gwint_card_draug'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_07', PotP_E_Primary, PotP_I_Monst, 'gwint_card_imlerith'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_08', PotP_E_Primary, PotP_I_Monst, 'gwint_card_kayran'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_09', PotP_E_Primary, PotP_I_Monst, 'gwint_card_leshen'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_10', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_11', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas_behemoth'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_12', PotP_E_Primary, PotP_I_Monst, 'gwint_card_botchling'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_13', PotP_E_Primary, PotP_I_Monst, 'gwint_card_celaeno_harpy'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_14', PotP_E_Primary, PotP_I_Monst, 'gwint_card_cockatrice'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_15', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_brewess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_16', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_weavess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_17', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_whispess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_18', PotP_E_Primary, PotP_I_Monst, 'gwint_card_earth_elemental'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_19', PotP_E_Primary, PotP_I_Monst, 'gwint_card_endrega'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_20', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fiend'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_21', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fire_elemental'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_22', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fogling'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_23', PotP_E_Primary, PotP_I_Monst, 'gwint_card_forktail'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_24', PotP_E_Primary, PotP_I_Monst, 'gwint_card_frightener'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_25', PotP_E_Primary, PotP_I_Monst, 'gwint_card_gargoyle'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_26', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_27', PotP_E_Primary, PotP_I_Monst, 'gwint_card_grave_hag'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_28', PotP_E_Primary, PotP_I_Monst, 'gwint_card_griffin'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_29', PotP_E_Primary, PotP_I_Monst, 'gwint_card_harpy'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_30', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ice_giant'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_31', PotP_E_Primary, PotP_I_Monst, 'gwint_card_nekker'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_32', PotP_E_Primary, PotP_I_Monst, 'gwint_card_plague_maiden'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_33', PotP_E_Primary, PotP_I_Monst, 'gwint_card_toad'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_34', PotP_E_Primary, PotP_I_Monst, 'gwint_card_bruxa'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_35', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ekkima'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_36', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fleder'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_37', PotP_E_Primary, PotP_I_Monst, 'gwint_card_garkain'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_38', PotP_E_Primary, PotP_I_Monst, 'gwint_card_katakan'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_39', PotP_E_Primary, PotP_I_Monst, 'gwint_card_werewolf'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_40', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wyvern'));
		
		SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent);		
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Monsters_Redux() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Monsters_Redux';
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_01', PotP_E_Primary, PotP_I_Monst, 'BASEDECK'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_02', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_bronze'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_03', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_silver'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_04', PotP_E_Missable,PotP_I_Monst, 'gwint_card_eredin_gold'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_05', PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_platinium'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_06', PotP_E_Primary, PotP_I_Monst, 'gwint_card_caranthir'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_07', PotP_E_Primary, PotP_I_Monst, 'gwint_card_emiel'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_08', PotP_E_Primary, PotP_I_Monst, 'gwint_card_imlerith'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_09', PotP_E_Primary, PotP_I_Monst, 'gwint_card_grave_hag'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_10', PotP_E_Primary, PotP_I_Monst, 'gwint_card_striga'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_11', PotP_E_Primary, PotP_I_Monst, 'gwint_card_plague_maiden'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_12', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_13', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas_behemoth'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_14', PotP_E_Primary, PotP_I_Monst, 'gwint_card_avallach'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_15', PotP_E_Primary, PotP_I_Monst, 'gwint_card_moon'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_16', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul3'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_17', PotP_E_Primary, PotP_I_Monst, 'gwint_card_cow'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_18', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_weavess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_19', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_whispess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_20', PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_brewess'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_21', PotP_E_Primary, PotP_I_Monst, 'gwint_card_dagon'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_22', PotP_E_Primary, PotP_I_Monst, 'gwint_card_dettlaff'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_23', PotP_E_Primary, PotP_I_Monst, 'gwint_card_draug'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_24', PotP_E_Primary, PotP_I_Monst, 'gwint_card_endrega'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_25', PotP_E_Primary, PotP_I_Monst, 'gwint_card_earth_elemental'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_26', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fire_elemental'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_27', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fogling'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_28', PotP_E_Primary, PotP_I_Monst, 'gwint_card_frightener'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_29', PotP_E_Primary, PotP_I_Monst, 'gwint_card_katakan'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_30', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_31', PotP_E_Primary, PotP_I_Monst, 'gwint_card_forktail'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_32', PotP_E_Primary, PotP_I_Monst, 'gwint_card_harpy'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_33', PotP_E_Primary, PotP_I_Monst, 'gwint_card_griffin'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_34', PotP_E_Primary, PotP_I_Monst, 'gwint_card_iris'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_35', PotP_E_Primary, PotP_I_Monst, 'gwint_card_celaeno_harpy'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_36', PotP_E_Primary, PotP_I_Monst, 'gwint_card_kayran'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_37', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul2'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_38', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fiend'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_39', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ice_giant'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_40', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_drakkar'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_41', PotP_E_Primary, PotP_I_Monst, 'gwint_card_nekker'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_42', PotP_E_Primary, PotP_I_Monst, 'gwint_card_nithral'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_43', PotP_E_Primary, PotP_I_Monst, 'gwint_card_mrmirror'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_44', PotP_E_Primary, PotP_I_Monst, 'gwint_card_bruxa'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_45', PotP_E_Primary, PotP_I_Monst, 'gwint_card_gargoyle'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_46', PotP_E_Primary, PotP_I_Monst, 'gwint_card_savolla'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_47', PotP_E_Primary, PotP_I_Monst, 'gwint_card_dol_dwarf'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_48', PotP_E_Primary, PotP_I_Monst, 'gwint_card_cockatrice'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_49', PotP_E_Primary, PotP_I_Monst, 'gwint_card_toad'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_50', PotP_E_Primary, PotP_I_Monst, 'gwint_card_alp'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_51', PotP_E_Primary, PotP_I_Monst, 'gwint_card_ekkima'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_52', PotP_E_Primary, PotP_I_Monst, 'gwint_card_fleder'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_53', PotP_E_Primary, PotP_I_Monst, 'gwint_card_garkain'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_54', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas2'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_55', PotP_E_Primary, PotP_I_Monst, 'gwint_card_mrmirror_foglet'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_56', PotP_E_Primary, PotP_I_Monst, 'gwint_card_white'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_57', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_hound'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_58', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_navigator'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_59', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_rider'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_60', PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_warrior'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_61', PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas3'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_62', PotP_E_Primary, PotP_I_Monst, 'gwint_card_leshen'));
		parent.Gwent_MonstersDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Monsters_Redux_63', PotP_E_Primary, PotP_I_Monst, 'gwint_card_centipede'));
		
		SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent);			
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Neutral() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NeutralCards';
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_01', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_ciri'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_02', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_geralt'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_03', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_avallach'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_04', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_triss'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_05', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_yennefer'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_06', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_horn'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_07', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_dummy'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_08', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_scorch'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_09', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_cow'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_10', PotP_E_Missable,PotP_I_Neutr, 'gwint_card_dandelion'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_11', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_emiel'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_12', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_mrmirror'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_13', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_mrmirror_foglet'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_14', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_olgierd'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_15', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_vesemir'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_16', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_villen'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_17', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_zoltan'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_18', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_19', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_20', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_21', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_skellige_storm'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_22', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		
		SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Neutral_Redux() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux';
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_01', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_azar_javed'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_02', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_geralt'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_03', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_04', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_ciri'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_05', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_06', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_dummy'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_07', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_08', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_09', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_10', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_horn'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_11', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_professor'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_12', PotP_E_Primary, PotP_I_Neutr, 'BASEDECK'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_13', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_vesemir'));
		parent.Gwent_NeutralDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux_14', PotP_E_Primary, PotP_I_Neutr, 'gwint_card_yennefer'));
		
		SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent);				
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Nilfgaard() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire';
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_01', PotP_E_Primary, PotP_I_Nilfg, 'BASEDECK'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_02', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_bronze'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_03', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_silver'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_04', PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_emhyr_gold'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_05', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_platinium'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_06', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_letho'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_07', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_menno'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_08', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_moorvran'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_09', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_tibor'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_10', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_albrich'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_11', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_assire'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_12', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_13', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cahir'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_14', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cynthia'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_15', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_16', PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_fringilla'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_17', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_heavy_zerri'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_18', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_19', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_morteisen'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_20', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_21', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_puttkammer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_22', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rainfarn'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_23', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_renuald'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_24', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rotten'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_25', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_shilard'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_26', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_combat_engineer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_27', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_siege_support'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_28', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_stefan'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_29', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_sweers'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_30', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vanhemar'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_31', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vattier'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_32', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vreemde'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_33', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_34', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_zerri'));
		
		SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Nilfgaard_Redux() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux';
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_01', PotP_E_Primary, PotP_I_Nilfg, 'BASEDECK'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_02', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_bronze'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_03', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_silver'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_04', PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_emhyr_gold'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_05', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_platinium'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_06', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_moorvran'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_07', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_henrietta'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_08', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_letho'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_09', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade1'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_10', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_albrich'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_11', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_siege_support'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_12', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_artorius'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_13', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_assire'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_14', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade3'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_15', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_16', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cahir'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_17', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_renuald'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_18', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_catriona'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_19', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cynthia'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_20', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa3'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_21', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa2'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_22', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_23', PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_fringilla'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_24', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary2'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_25', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_heavy_zerri'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_26', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_joachim'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_27', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade4'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_28', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_menno'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_29', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_milton'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_30', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_31', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_palmerin'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_32', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_morteisen'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_33', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_puttkammer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_34', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rainfarn'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_35', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support2'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_36', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rotten'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_37', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade2'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_38', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_shilard'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_39', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_combat_engineer'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_40', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_stefan'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_41', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_sweers'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_42', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_syanna'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_43', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_tibor'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_44', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vanhemar'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_45', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vattier'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_46', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vicovaro'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_47', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer2'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_48', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vivienne'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_49', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vreemde'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_50', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary'));
		parent.Gwent_NilfgaardDeck.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux_51', PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_zerri'));
		
		SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_NorthernRealms() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NorthernRealms';
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_01', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_02', PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_bronze'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_03', PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_silver'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_04', PotP_E_Missable,PotP_I_North, 'gwint_card_foltest_gold'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_05', PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_platinium'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_06', PotP_E_Primary, PotP_I_North, 'gwint_card_esterad'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_07', PotP_E_Missable,PotP_I_North, 'gwint_card_natalis'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_08', PotP_E_Primary, PotP_I_North, 'gwint_card_philippa'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_09', PotP_E_Primary, PotP_I_North, 'gwint_card_vernon'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_10', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_11', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_12', PotP_E_Primary, PotP_I_North, 'gwint_card_catapult'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_13', PotP_E_Primary, PotP_I_North, 'gwint_card_crinfrid'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_14', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_15', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_16', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_17', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_18', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_19', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_20', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_21', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_22', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_23', PotP_E_Primary, PotP_I_North, 'gwint_card_siege_tower'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_24', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_25', PotP_E_Primary, PotP_I_North, 'gwint_card_dijkstra'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_26', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_27', PotP_E_Primary, PotP_I_North, 'gwint_card_thaler'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_28', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_29', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_30', PotP_E_Primary, PotP_I_North, 'BASEDECK'));
		
		SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_NorthernRealms_Redux() 
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux';
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_01', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_02', PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_bronze'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_03', PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_silver'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_04', PotP_E_Missable,	PotP_I_North, 'gwint_card_foltest_gold'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_05', PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_platinium'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_06', PotP_E_Missable,	PotP_I_North, 'gwint_card_natalis'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_07', PotP_E_Primary, 	PotP_I_North, 'gwint_card_olgierd'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_08', PotP_E_Primary, 	PotP_I_North, 'gwint_card_philippa'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_09', PotP_E_Primary, 	PotP_I_North, 'gwint_card_anseis'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_10', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_11', PotP_E_Primary, 	PotP_I_North, 'gwint_card_beggar'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_12', PotP_E_Primary, 	PotP_I_North, 'gwint_card_bloody_baron'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_13', PotP_E_Primary, 	PotP_I_North, 'gwint_card_blue_stripes1'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_14', PotP_E_Primary, 	PotP_I_North, 'gwint_card_boris'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_15', PotP_E_Primary, 	PotP_I_North, 'gwint_card_botchling'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_16', PotP_E_Primary, 	PotP_I_North, 'gwint_card_catapult2'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_17', PotP_E_Primary, 	PotP_I_North, 'gwint_card_carlo'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_18', PotP_E_Primary, 	PotP_I_North, 'gwint_card_catapult'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_19', PotP_E_Primary, 	PotP_I_North, 'gwint_card_cleric_rose'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_20', PotP_E_Primary, 	PotP_I_North, 'gwint_card_crinfrid'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_21', PotP_E_Primary, 	PotP_I_North, 'gwint_card_crownsplitter'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_22', PotP_E_Primary, 	PotP_I_North, 'gwint_card_cutup'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_23', PotP_E_Missable,	PotP_I_North, 'gwint_card_dandelion'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_24', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_25', PotP_E_Primary, 	PotP_I_North, 'gwint_card_dijkstra'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_26', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_27', PotP_E_Primary, 	PotP_I_North, 'gwint_card_igor'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_28', PotP_E_Primary, 	PotP_I_North, 'gwint_card_jacques'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_29', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_30', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_31', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_32', PotP_E_Primary, 	PotP_I_North, 'gwint_card_francis'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_33', PotP_E_Primary, 	PotP_I_North, 'gwint_card_knight_rose'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_34', PotP_E_Primary, 	PotP_I_North, 'gwint_card_lebioda'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_35', PotP_E_Primary, 	PotP_I_North, 'gwint_card_hailstorm'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_36', PotP_E_Primary, 	PotP_I_North, 'gwint_card_nathaniel'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_37', PotP_E_Primary, 	PotP_I_North, 'gwint_card_peach'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_38', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_39', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_40', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_41', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_42', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_43', PotP_E_Primary, 	PotP_I_North, 'gwint_card_siege_tower'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_44', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_45', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_46', PotP_E_Primary, 	PotP_I_North, 'gwint_card_wyvern'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_47', PotP_E_Primary, 	PotP_I_North, 'gwint_card_thaler'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_48', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_49', PotP_E_Primary, 	PotP_I_North, 'gwint_card_triss'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_50', PotP_E_Primary, 	PotP_I_North, 'gwint_card_vernon'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_51', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_52', PotP_E_Primary, 	PotP_I_North, 'gwint_card_vincent'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_53', PotP_E_Primary, 	PotP_I_North, 'gwint_card_esterad'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_54', PotP_E_Primary, 	PotP_I_North, 'gwint_card_whoreson'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_55', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_56', PotP_E_Primary, 	PotP_I_North, 'BASEDECK'));
		parent.Gwent_NorthernRealms.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux_57', PotP_E_Primary, 	PotP_I_North, 'gwint_card_zoltan'));
		
		SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Scoiatael()
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Scoiatael';
		
		parent.Gwent_Scoiatael.Clear();
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_01', PotP_E_Primary, 	PotP_I_Scoia, 'BASEDECK'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_02', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_bronze'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_03', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_silver'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_04', PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_francesca_gold'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_05', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_platinium'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_06', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_eithne'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_07', PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_iorveth'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_08', PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_isengrim'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_09', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_saskia'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_10', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_barclay'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_11', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ciaran'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_12', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dennis'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_13', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_archer'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_14', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_15', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_dwarf'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_16', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_17', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_filavandrel'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_18', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_19', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_20', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ida'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_21', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_22', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_milva'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_23', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_riordain'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_24', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_schirru'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_25', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_toruviel'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_26', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_cadet'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_27', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_28', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_yaevinn'));
		
		SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Scoiatael_Redux()
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux';
		
		parent.Gwent_Scoiatael.Clear();
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_01', PotP_E_Primary, 	PotP_I_Scoia, 'BASEDECK'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_02', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_bronze'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_03', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_silver'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_04', PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_francesca_gold'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_05', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_platinium'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_06', PotP_E_Missable, 	PotP_I_Scoia, 'gwint_card_iorveth'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_07', PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_morenn'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_08', PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_saskia'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_09', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse3'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_10', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_aglais'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_11', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_barclay'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_12', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_braenn'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_13', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam5'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_14', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ciaran'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_15', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dennis'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_16', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_archer'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_17', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_18', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_19', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_grovekeeper'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_20', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam3'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_21', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam4'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_22', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_23', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher3'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_24', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_25', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_fauve'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_26', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_filavandrel'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_27', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_scorch'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_28', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry3'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_29', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_30', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_31', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_32', PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_ida'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_33', PotP_E_Missable, 	PotP_I_Scoia, 'gwint_card_isengrim'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_34', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_35', PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_mahakam'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_36', PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_havekar_support3'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_37', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_milva'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_38', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_nature'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_39', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_40', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_riordain'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_41', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_schirru'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_42', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_eithne'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_43', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_toruviel'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_44', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_treant_boar'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_45', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_treant_mantis'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_46', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support2'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_47', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_villen'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_48', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_cadet'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_49', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_50', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_water'));
		parent.Gwent_Scoiatael.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux_51', PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_yaevinn'));
		
		SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Skellige()
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Skellige';
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_01', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_02', PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_bronze'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_03', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_04', PotP_E_Primary, PotP_I_Skell, 'gwint_card_cerys'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_05', PotP_E_Primary, PotP_I_Skell, 'gwint_card_ermion'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_06', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_07', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_08', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_09', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_10', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_11', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_pirate'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_12', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_13', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_14', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_15', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_16', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_17', PotP_E_Primary, PotP_I_Skell, 'gwint_card_draig'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_18', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_19', PotP_E_Primary, PotP_I_Skell, 'gwint_card_cock'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_20', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_21', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_22', PotP_E_Primary, PotP_I_Skell, 'gwint_card_olaf'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_23', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_24', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_25', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_26', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		
		SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Skellige_Redux()
	{
		var group: name = 'PotP_TrackingGroup_GwentCards_Skellige_Redux';
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_01', PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_bronze'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_02', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_03', PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_silver'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_04', PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_gold'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_05', PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_platinium'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_06', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_07', PotP_E_Primary, PotP_I_Skell, 'gwint_card_cock'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_08', PotP_E_Primary, PotP_I_Skell, 'gwint_card_tyr'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_09', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_an_craite_marauder'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_10', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_11', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_an_craite_whaler'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_12', PotP_E_Primary, PotP_I_Skell, 'gwint_card_artis'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_13', PotP_E_Primary, PotP_I_Skell, 'gwint_card_athak'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_14', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_15', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_16', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_17', PotP_E_Primary, PotP_I_Skell, 'gwint_card_boatbuilders'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_18', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_19', PotP_E_Primary, PotP_I_Skell, 'gwint_card_dreams'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_20', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_captain'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_21', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_pirate'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_22', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_smuggler'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_23', PotP_E_Primary, PotP_I_Skell, 'gwint_card_djenge_frett'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_24', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_25', PotP_E_Primary, PotP_I_Skell, 'gwint_card_draig'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_26', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_27', PotP_E_Primary, PotP_I_Skell, 'gwint_card_ermion'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_28', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_29', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_30', PotP_E_Primary, PotP_I_Skell, 'gwint_card_cerys'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_31', PotP_E_Primary, PotP_I_Skell, 'gwint_card_jutta'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_32', PotP_E_Primary, PotP_I_Skell, 'gwint_card_knut'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_33', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_34', PotP_E_Primary, PotP_I_Skell, 'gwint_card_coral'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_35', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_36', PotP_E_Primary, PotP_I_Skell, 'gwint_card_werewolf'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_37', PotP_E_Primary, PotP_I_Skell, 'gwint_card_olaf'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_38', PotP_E_Primary, PotP_I_Skell, 'gwint_card_freya'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_39', PotP_E_Primary, PotP_I_Skell, 'gwint_card_ragh_nar_roog'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_40', PotP_E_Primary, PotP_I_Skell, 'gwint_card_skellige_storm'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_41', PotP_E_Primary, PotP_I_Skell, 'gwint_card_skjall'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_42', PotP_E_Primary, PotP_I_Skell, 'gwint_card_sukrus'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_43', PotP_E_Primary, PotP_I_Skell, 'gwint_card_svalblod'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_44', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_45', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_46', PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_tuirseach_skirmisher'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_47', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_48', PotP_E_Primary, PotP_I_Skell, 'gwint_card_vabjorn'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_49', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_50', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_51', PotP_E_Primary, PotP_I_Skell, 'BASEDECK'));
		parent.Gwent_Skellige.PushBack((new PotP_PreviewEntry in this).initGwent(group, 'PotP_TrackingGroup_GwentCards_Skellige_Redux_52', PotP_E_Primary, PotP_I_Skell, 'gwint_card_yoana'));
		
		SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent);
	}
}