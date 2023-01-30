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
	
	public var MasterList_Quests			:array<PotP_PreviewEntry>;
	public var MasterList_Quests_Lookup		:array<string>;
		
	public var MainQuests_Prologue			: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Velen		: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Novigrad		: array<PotP_PreviewEntry>;
	public var MainQuests_Act1_Skellige		: array<PotP_PreviewEntry>;
	public var MainQuests_Act2				: array<PotP_PreviewEntry>;
	public var MainQuests_Act3				: array<PotP_PreviewEntry>;
	public var MainQuests_DLC1				: array<PotP_PreviewEntry>;
	public var MainQuests_DLC2				: array<PotP_PreviewEntry>;
	public var MainQuests_Vizima			: array<PotP_PreviewEntry>;
	
	public var SideQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	public var SideQuests_Velen				: array<PotP_PreviewEntry>;
	public var SideQuests_Novigrad			: array<PotP_PreviewEntry>;
	public var SideQuests_Skellige			: array<PotP_PreviewEntry>;
	public var SideQuests_KaerMorhen		: array<PotP_PreviewEntry>;
	public var SideQuests_Toussaint			: array<PotP_PreviewEntry>;
	public var SideQuests_NonRegional		: array<PotP_PreviewEntry>;
		
	public var ContQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	public var ContQuests_Velen				: array<PotP_PreviewEntry>;
	public var ContQuests_Novigrad			: array<PotP_PreviewEntry>;
	public var ContQuests_Skellige			: array<PotP_PreviewEntry>;
	public var ContQuests_Toussaint			: array<PotP_PreviewEntry>;
		
	public var ScavQuests_Griffin			: array<PotP_PreviewEntry>;
	public var ScavQuests_Feline			: array<PotP_PreviewEntry>;
	public var ScavQuests_Ursine			: array<PotP_PreviewEntry>;
	public var ScavQuests_Wolven			: array<PotP_PreviewEntry>;
	public var ScavQuests_Others			: array<PotP_PreviewEntry>;
		
	public var HuntQuests_WhiteOrchard		: array<PotP_PreviewEntry>;
	public var HuntQuests_Velen				: array<PotP_PreviewEntry>;
	public var HuntQuests_Novigrad			: array<PotP_PreviewEntry>;
	public var HuntQuests_Skellige			: array<PotP_PreviewEntry>;
	public var HuntQuests_Toussaint			: array<PotP_PreviewEntry>;
	
	public var MissableQuests_InstantFails	: array<PotP_PreviewEntry>;
	public var MissableQuests_Q001			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q401			: array<PotP_PreviewEntry>;
	public var MissableQuests_SQ101			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q301			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q303			: array<PotP_PreviewEntry>;
	public var MissableQuests_SQ106			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q501			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q206			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q210			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q112			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q403			: array<PotP_PreviewEntry>;
	public var MissableQuests_Q702			: array<PotP_PreviewEntry>;	
	
	//---------------------------------------------------

	public var MasterList_Events			:array<PotP_PreviewEntry>;
	
	public var RandomEvents_Velen			: array<PotP_PreviewEntry>;
	public var RandomEvents_Novigrad		: array<PotP_PreviewEntry>;
	public var RandomEvents_Skellige		: array<PotP_PreviewEntry>;
	public var RandomEvents_KaerMorhen		: array<PotP_PreviewEntry>;	
	
	//---------------------------------------------------

	public var MasterList_World				:array<PotP_PreviewEntry>;
	
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

	public var MasterList_Items				:array<PotP_PreviewEntry>;
		
	public var Relic_Trophies				: array<PotP_PreviewEntry>;
	public var Relic_Crossbows				: array<PotP_PreviewEntry>;
	public var Relic_SteelSwords			: array<PotP_PreviewEntry>;
	public var Relic_SilverSwords			: array<PotP_PreviewEntry>;	
		
	public var Armor_DolBlathanna			: array<PotP_PreviewEntry>;	
	public var Armor_ForgottenWolven		: array<PotP_PreviewEntry>;	
	public var Armor_HenGaidth				: array<PotP_PreviewEntry>;	
	public var Armor_NewMoon				: array<PotP_PreviewEntry>;	
	public var Armor_Nilfgaardian			: array<PotP_PreviewEntry>;	
	public var Armor_Ofieri					: array<PotP_PreviewEntry>;	
	public var Armor_Temerian				: array<PotP_PreviewEntry>;	
	public var Armor_TeshamMutna			: array<PotP_PreviewEntry>;	
	public var Armor_Undvik					: array<PotP_PreviewEntry>;	
	public var Armor_WhiteTiger				: array<PotP_PreviewEntry>;	
		
	public var DLC_CosWiecej				: array<PotP_PreviewEntry>;	
	public var DLC_Dimeritium				: array<PotP_PreviewEntry>;	
	public var DLC_Gothic					: array<PotP_PreviewEntry>;	
	public var DLC_Meteorite				: array<PotP_PreviewEntry>;	
	public var DLC_SezonBurz				: array<PotP_PreviewEntry>;	
		
	public var Shades_Assassin				: array<PotP_PreviewEntry>;	
	public var Shades_Berserker				: array<PotP_PreviewEntry>;	
	public var Shades_Bismarck				: array<PotP_PreviewEntry>;	
	public var Shades_BloodHunter			: array<PotP_PreviewEntry>;	
	public var Shades_CrowFeathered			: array<PotP_PreviewEntry>;	
	public var Shades_FallenKnight			: array<PotP_PreviewEntry>;	
	public var Shades_Faraam				: array<PotP_PreviewEntry>;	
	public var Shades_Headtaker				: array<PotP_PreviewEntry>;	
	public var Shades_Hitokiri				: array<PotP_PreviewEntry>;	
	public var Shades_Kara					: array<PotP_PreviewEntry>;	
	public var Shades_LionHunter			: array<PotP_PreviewEntry>;	
	public var Shades_OldHunter				: array<PotP_PreviewEntry>;	
	public var Shades_Revenant				: array<PotP_PreviewEntry>;	
	public var Shades_SilverSwords			: array<PotP_PreviewEntry>;	
	public var Shades_Sithis				: array<PotP_PreviewEntry>;	
	public var Shades_Stalker				: array<PotP_PreviewEntry>;	
	public var Shades_SteelSwords			: array<PotP_PreviewEntry>;	
	public var Shades_Taifeng				: array<PotP_PreviewEntry>;	
	public var Shades_Unseen				: array<PotP_PreviewEntry>;	
	
	public var Gwent_MonstersDeck			: array<PotP_PreviewEntry>;
	public var Gwent_NeutralDeck			: array<PotP_PreviewEntry>;
	public var Gwent_NilfgaardDeck			: array<PotP_PreviewEntry>;
	public var Gwent_NorthernRealms			: array<PotP_PreviewEntry>;
	public var Gwent_Scoiatael				: array<PotP_PreviewEntry>;
	public var Gwent_Skellige				: array<PotP_PreviewEntry>;
		
	public var TotalEntList					: array<PotP_PreviewEntry>;
	public var TotalVarList					: array<string>;
	public var TotalGrpList					: array<string>;
	public var TotalIdeList					: array<string>;
	
	public var SupportedItemsList			: array<name>;
	public var SupportedItemsList_Entity	: array<PotP_PreviewEntry>;
	
	public var master						: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;

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

	//---------------------------------------------------
	
	public function CreateEntry() : PotP_PreviewEntry 
	{
		return new PotP_PreviewEntry in this;
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
			parent.TotalIdeList.PushBack(parent.MasterList_Items[i].identifier);
		}
	}

//---------------------------------------------------

	latent function BuildQuestArrays() 
	{
		parent.MasterList_Quests.Clear();
		parent.MasterList_Events.Clear();
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
		parent.SupportedItemsList.Clear();
		parent.SupportedItemsList_Entity.Clear();
		
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
		var Idx, Edx, Rdx: int;
		
		data = pData;

		for ( Idx = 0; Idx < pData.Size(); Idx += 1 ) 
		{
			temp.PushBack(pData[Idx].localname);
		}
		
		ArraySortStrings(temp);
		pData.Clear();
		
		for ( Idx = 0; Idx < temp.Size(); Idx += 1 ) 
		{
			for ( Edx = 0; Edx < data.Size(); Edx += 1 ) 
			{
				if (temp[Idx] == data[Edx].localname) 
				{
					data[Edx].identifier 	= parent.CreateUniqueIdentifier();
					data[Edx].arrayType  	= type;

					data[Edx].storage 		= parent.master.PotP_PersistentStorage;
					data[Edx].notifications = parent.master.PotP_Notifications;
					data[Edx].mappins 		= parent.master.PotP_PinManager;
					
					for ( Rdx = 0; Rdx < data[Edx].variations.Size(); Rdx += 1 )
					{
						parent.SupportedItemsList.PushBack( data[Edx].variations[Rdx] );
						parent.SupportedItemsList_Entity.PushBack( data[Edx] );
					}
						
					pData.PushBack( data[Edx] );

					if ( data[Edx].is_missable ) 
					{
						this.AddToMissableArray( data[Edx] );
					}
					
					switch ( type )
					{
					case PotP_A_Quest:
						parent.MasterList_Quests.PushBack( data[Edx] );
						parent.MasterList_Quests_Lookup.PushBack( data[Edx].entryname );
						break;
						
					case PotP_A_Event:
						parent.MasterList_Events.PushBack( data[Edx] );
						break;
						
					case PotP_A_World:
						parent.MasterList_World.PushBack( data[Edx] );
						break;
						
					case PotP_A_Items:
					case PotP_A_Gwent:						
						parent.MasterList_Items.PushBack( data[Edx] );
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
		case "PotP_TrackingGroup_SideQuests_Novigrad_01":
		case "PotP_TrackingGroup_SideQuests_Velen_01":
		case "PotP_TrackingGroup_SideQuests_Velen_23":
		case "PotP_TrackingGroup_SideQuests_Novigrad_49":		
			parent.MissableQuests_InstantFails.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_01":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_03":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_04":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_05":
		case "PotP_TrackingGroup_SideQuests_WhiteOrchard_06":
			parent.MissableQuests_Q001.PushBack(pData);
			break;
			
		case "PotP_TrackingGroup_SideQuests_Skellige_34":
		case "PotP_TrackingGroup_SideQuests_NonRegional_03":
			parent.MissableQuests_Q401.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Velen_22":
			parent.MissableQuests_SQ101.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_09":
			parent.MissableQuests_Q303.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_12":
			parent.MissableQuests_SQ106.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_38":
		case "PotP_TrackingGroup_ContractQuests_WhiteOrchard_01":	
			parent.MissableQuests_Q501.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_26":
		case "PotP_TrackingGroup_SideQuests_Skellige_28":
			parent.MissableQuests_Q206.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Skellige_07":
		case "PotP_TrackingGroup_SideQuests_Skellige_23":
		case "PotP_TrackingGroup_SideQuests_Skellige_35":
			parent.MissableQuests_Q210.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_45":
		case "PotP_TrackingGroup_SideQuests_Novigrad_46":
			parent.MissableQuests_Q112.PushBack(pData);
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
			parent.MissableQuests_Q403.PushBack(pData);
			break;
		
		case "PotP_TrackingGroup_SideQuests_Toussaint_03":
			parent.MissableQuests_Q702.PushBack(pData);
			break;

		case "PotP_TrackingGroup_SideQuests_Novigrad_22":
			parent.MissableQuests_Q301.PushBack(pData);
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
		
		var group: string = "PotP_TrackingGroup_MainQuests_Prologue";
		
		parent.MainQuests_Prologue.Clear();
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Dream"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q001 Find Yennefer"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Griffin hunt"));
		parent.MainQuests_Prologue.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q002 Bandit attack"));
		
		SortPreviewData(parent.MainQuests_Prologue, PotP_A_Quest);

		//---------------------- Main Quests - (Vizima)		
		
		group = "PotP_TrackingGroup_MainQuests_Vizima";
		
		parent.MainQuests_Vizima.Clear();
		parent.MainQuests_Vizima.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q002 Vizima Palace"));
		
		SortPreviewData(parent.MainQuests_Vizima, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Velen)
		
		group = "PotP_TrackingGroup_MainQuests_VelenAct1";
		
		parent.MainQuests_Act1_Velen.Clear();
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q101 Agent"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q102 Baron"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Arrival to Crow Perch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Family Issues"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Epic Goat Adventure"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 The Race"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q103 Departure to Novigrad"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Looking for a Witch"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q104 Mysterious Sorcerer"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Witches"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Evil Spirit"));
		parent.MainQuests_Act1_Velen.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q105 Ciri escape from swamps"));
		
		SortPreviewData(parent.MainQuests_Act1_Velen, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Novigrad)
		
		group = "PotP_TrackingGroup_MainQuests_NovigradAct1";
		
		parent.MainQuests_Act1_Novigrad.Clear();
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q301 Find Dreamer"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q304 Looking For Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Mafia"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q302 Ciri - Rescuing Dudu"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q303 Treasure"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "q302 Favour For Radovid"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 The Play"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Looking for Dandelion"));
		parent.MainQuests_Act1_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q305 Ciri - chase to the temple"));
		
		SortPreviewData(parent.MainQuests_Act1_Novigrad, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 1: Skellige)
		
		group = "PotP_TrackingGroup_MainQuests_SkelligeAct1";
		
		parent.MainQuests_Act1_Skellige.Clear();
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Travel to Skellige"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q201 Brans Reception"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q203 Cataclysm"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Lofoten"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 The Garden"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q205 Ciri - safe heaven"));
		parent.MainQuests_Act1_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "[metaquest] Search for ugly"));
		
		SortPreviewData(parent.MainQuests_Act1_Skellige, PotP_A_Quest);	
		
		//---------------------- Main Quests - (Act 2)

		group = "PotP_TrackingGroup_MainQuests_Act2";
		
		parent.MainQuests_Act2.Clear();
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q401 Konsylium"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Megascope"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 Hunt With Eskel"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Phylactery"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Reunion"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q401 The Curse"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q402 Allies in Velen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q402 Allies in Novigrad"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Allies in Skellige"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_VI, PotP_I_Mains, "Q402 Ally in Nilfgaard"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q402 Isle of Mists"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q403 Battle of Kaer Morhen"));
		parent.MainQuests_Act2.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary, PotP_R_KM, PotP_I_Mains, "Q110 Postbattle"));
		
		SortPreviewData(parent.MainQuests_Act2, PotP_A_Quest);
		
		//---------------------- Main Quests - (Act 3)

		group = "PotP_TrackingGroup_MainQuests_Act3";
		
		parent.MainQuests_Act3.Clear();
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Mains, "Q111 Imlerith"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "STORY - Chapter 3 - Preparations in Novigrad"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 A Blind Owl"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Prison Break"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q310 Ciri's Night Out"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q311 The Spiral"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Mains, "Q210 Preparations"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Pre Canaris"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Emhyr"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Avallach lab"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q210 Skjall Grave"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q501 Eredin"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Mains, "Q502 Avallach"));
		parent.MainQuests_Act3.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary, PotP_R_WO, PotP_I_Mains, "Q504 Ciri Empress"));
		
		SortPreviewData(parent.MainQuests_Act3, PotP_A_Quest);
		
		//---------------------- Main Quests - (Hearts of Stone)

		group = "PotP_TrackingGroup_MainQuests_HeartsOfStone";
		
		parent.MainQuests_DLC1.Clear();
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q601intro"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q602wedding"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603bank"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603diversion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603getinman"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q603vaultspecialist"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q604mansion"));
		parent.MainQuests_DLC1.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Mains, "q605finale"));
		
		SortPreviewData(parent.MainQuests_DLC1, PotP_A_Quest);
		
		//---------------------- Main Quests - (Blood and Wine)

		group = "PotP_TrackingGroup_MainQuests_BloodAndWine";
		
		parent.MainQuests_DLC2.Clear();
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701A Hook"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q701_Festival"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Reverb Mixture"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q702 Lair Of The Beast"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Wine"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 Art"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q703 All for one"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Starting"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704B Fairy Land"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Monster Hunt"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Vampires"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q704 Dettlaff"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Ceremony"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Prison"));
		parent.MainQuests_DLC2.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Mains, "Q705 Home"));
		
		SortPreviewData(parent.MainQuests_DLC2, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Misc() 
	{	
		var group: string = "PotP_TrackingGroup_SideQuests_WhiteOrchard";
	
		parent.SideQuests_WhiteOrchard.Clear();
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0004 Locked Shed"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary,  PotP_R_WO, PotP_I_Sides, "mq5004horse"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0001 Missing Brother"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "Q002 Healing Woman"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0002 Missing Goods"));
		parent.SideQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Missable, PotP_R_WO, PotP_I_Sides, "MQ0005 Dwarven Smith"));
		
		SortPreviewData(parent.SideQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_KaerMorhen";
		
		parent.SideQuests_KaerMorhen.Clear();
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Missable, PotP_R_KM, PotP_I_Sides, "mq4005_sword"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4002_anomaly"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4003_lake"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4004_bastion"));
		parent.SideQuests_KaerMorhen.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary,  PotP_R_KM, PotP_I_Sides, "mq4006_armor"));
		
		SortPreviewData(parent.SideQuests_KaerMorhen, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_SideQuests_NonRegional";
		
		parent.SideQuests_NonRegional.Clear();
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "mq3031_aging_romance"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "Card Game Meta: Gather All"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Missable, PotP_R_NA, PotP_I_Sides, "SQ106 Killbill"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "CG: Old Friends"));
		parent.SideQuests_NonRegional.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary,  PotP_R_NA, PotP_I_Sides, "SQ108 Master Blacksmith"));
		
		SortPreviewData(parent.SideQuests_NonRegional, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_SideQuests_Velen() 
	{
		var group: string = "PotP_TrackingGroup_SideQuests_Velen";
		
		parent.SideQuests_Velen.Clear();
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1001 Dog Trail"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ101 Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1057: The Great Spirit"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Tower"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q106 Keira's bussiness"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1005 Battle Scavengers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1055_nilfgaard_mom"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q103 Ciri's Chamber"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1046_burning_down_the_house"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1012 On God Terms With Gods"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1023_Fake_Papers"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "NML: Fist Fighting"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ107 Pigs"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q109 Wrapup"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "Q108 Forfather's Eve"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1019 A matter of faith"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_17", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Letho"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_18", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "CG : No Man's Land"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_19", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ1003 Trail of Death"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_20", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1010 Last Rite"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_21", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1045 Damsel in distress"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_22", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "mq1015 Lynch"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_23", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q104 Favour For Keira"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_24", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "hr101 : Horse Race: Baron's Men"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_25", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "Q107 Swamps"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_26", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 Cat Stash"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_27", PotP_E_Missable, PotP_R_VE, PotP_I_Sides, "SQ102 Dolores"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_28", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1050_written_in_the_stars"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_30", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "MQ3024 you shall not pass"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_31", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1058 The Village X Massacare"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_32", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "SQ104 Werewolf"));
		parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_33", PotP_E_Primary,  PotP_R_VE, PotP_I_Sides, "mq1013 The Pretender"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_34", PotP_E_Primary, PotP_R_VE, PotP_I_Sides, "mq1060_devils_pit"));
		}

		if (PotP_UsingThreeLittleSisters()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5178
		{ 
			parent.SideQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "threesisters_little_sisters"));
		}		

		SortPreviewData(parent.SideQuests_Velen, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Novigrad() 
	{
		var group: string = "PotP_TrackingGroup_SideQuests_Novigrad";
		
		parent.SideQuests_Novigrad.Clear();
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "MQ1039 Uninvited Guests"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ310 Dangerous Game"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ315 Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "mq3039_crows"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary,  		PotP_R_NO, PotP_I_Sides, "Q310 Retrieving Keira"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ301 Triss"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC1,	PotP_R_NO, PotP_I_Sides, "q602romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3037 Sleeping Vampire"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3005 Shady Deal"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ312 Ves"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "q603painting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ303 Brothel"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q308 Psycho"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1016 Poultry Abduction"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 1"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6005 Enchanter Level 0"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_17", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3036_rosa_romance"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_18", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "NVG: Fist Fighting"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_19", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_20", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Innkeepers"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_21", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "CG: Talar"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_22", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q301 Visiting Dreamer"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_23", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3006 Magic Merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_24", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3002 Spies of Novigrad"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_25", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ306 Maverick"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_26", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 King Beggar's Debt"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_27", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q310 Romantic Disaster"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_28", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3017 Little Red Raiding Hood"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_29", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3027_mymanifest"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_30", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3016_wandering_bards"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_31", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_32", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "Q309 Casablanca"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_33", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1002 Rezydencja"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_34", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "SQ304 Armorsmith"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_35", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3041_showing_presence"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_36", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ3026 Novigrad Horse Racing"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_37", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6001merchant"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_38", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3035_emhyr"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_39", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "SQ302 Philippa"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_40", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6004_broken_rose"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_41", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq3019_herd_instincts"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_42", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "mq1020 Missing Horse"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_43", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1028 Courier"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_44", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q302 War Of Gangs"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_45", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012Noble Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_46", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3012 Warrior Statuette"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_47", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6003_tax_collector"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_48", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "MQ1022 Border Troll"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_49", PotP_E_Missable, 		PotP_R_NO, PotP_I_Sides, "mq3038_wheel_of_fortune"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_50", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Sides, "mq6002_cannibals"));
		parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_51", PotP_E_Primary, 		PotP_R_NO, PotP_I_Sides, "Q309 Novigrad Under Control 2"));
		
		if (PotP_IsUsingNextGen()) 
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_52", PotP_E_Primary_DLC1, PotP_R_VE, PotP_I_Sides, "mq6005 Enchanter Level 2"));
		}

		if (PotP_UsingCiriSoleMemento()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/4585
		{
			parent.SideQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_90", PotP_E_ModAdded, PotP_R_VE, PotP_I_Sides, "solememento_sole_memento"));
		}

		SortPreviewData(parent.SideQuests_Novigrad, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Skellige() {	
		
		var group: string = "PotP_TrackingGroup_SideQuests_Skellige";
		
		parent.SideQuests_Skellige.Clear();
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2009 Immoral Proposition"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Jarl's Horn"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2010 human trap"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2051 Unfinished Business"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2018 : Bandits"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2022 Stupid Side of Courage"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q208 Heroesmead"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2045_chains"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2002 Pirate Scavengers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "Fist Fight Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SKG: Fist Fighting"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "mq2020 Flesh for cash buisness"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2017 : For Fame And Glory"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2049_atheist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2048_msg_in_a_bottle"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "CG: Skellige"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_17", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2012 Bad Place, Bad Time"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_18", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ201 Curse"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_19", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2038_shieldmaiden"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_20", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q206 Berserkers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_21", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2024: Master of the Arena"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_22", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2003 Disturbing rest"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_23", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q203 Him"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_24", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ205 Alchemist"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_25", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2039 Vow of Silence"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_26", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Tavern Brawl"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_27", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2015 Long Time Apart"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_28", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ209 Cave of Dreams"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_29", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2001 Kuilu"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_30", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr201 Horse Race: Ferlund"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_31", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr204 : Horse Race Championship"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_32", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr202 Horse Race: Fejrlesdal"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_33", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "hr203 Horse Race: Kaer Trolde"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_34", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "SQ202 Yen"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_35", PotP_E_Missable, 	PotP_R_SK, PotP_I_Sides, "Q202 Ice Giant"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_36", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2030_nithing"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_37", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2040_trial_of_power"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_38", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2037 Dishonored"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_39", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "MQ2013 Grossbart brothers"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_40", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "SQ210 Impossible Tower"));
		parent.SideQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_41", PotP_E_Primary, 	PotP_R_SK, PotP_I_Sides, "mq2011_liar_and_theif"));

		SortPreviewData(parent.SideQuests_Skellige, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_SideQuests_Toussaint() {	
		
		var group: string = "PotP_TrackingGroup_SideQuests_Toussaint";
		
		parent.SideQuests_Toussaint.Clear();
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7004_bleeding_tree"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7009 Painter"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Missable_DLC2,PotP_R_TO, PotP_I_Sides, "Q702 Water Mill"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "plegmund_poi_05"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "q704_ft_goose"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7007_gargoyles"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7021_left_behind"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_fistfights"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7015_souvenir"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_all_cards"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cg700_tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_17", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "cammerlengo"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_18", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700_th701_metaquest"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_19", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7018_last_one"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_20", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7024_home"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_21", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7020_songs_of_glory"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_22", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7011 Where's My Money"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_23", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ff701_master"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_24", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q702 Faith of Marlene"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_25", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "Q705 Prison Stash"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_26", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "SQ701 tournament"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_27", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "th700 Preacher bones"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_28", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7006_the_paths_of_destiny_p2"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_29", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7001 Rest in peace"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_30", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "mq7023_mutations"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_31", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_a_01"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_32", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "car_a_04"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_33", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "gor_b_02"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_34", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "dun_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_35", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "vin_b_03"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_36", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_initial"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_37", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_consortium"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_38", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_coronata"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_39", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_belgard_secret"));
		parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_40", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Sides, "ww_vermentino"));

		if (PotP_UsingANightToRemember()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/4670
		{
			parent.SideQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_90", PotP_E_ModAdded_DLC2, PotP_R_TO, PotP_I_Sides, "ntr_nighttoremember"));
		}
		
		SortPreviewData(parent.SideQuests_Toussaint, PotP_A_Quest);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_RandomEvents() {	
		
		var group: string = "PotP_TrackingGroup_RandomEvents_Velen";
		
		parent.RandomEvents_Velen.Clear();
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_AtTheMercyOfStrangers_1_NG", 	Vector(641.454102, 533.142456)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_CaravanAttack_NG_1", 			Vector(1311.539551, 404.800537)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "novigrad", "PotP_Event_CaravanAttack_NG_2", 			Vector(207.837814, 75.866135)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_DeadlyCrossing_3_NG", 			Vector(-29.826519, -101.255219)	)); //Troll Bridge
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Event, false, "novigrad", "PotP_Event_DeadlyCrossing_1_NG", 			Vector(794.722107, 266.272644)	));	//Lindenvale
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_DeadlyCrossing_2_NG", 			Vector(1087.826294, -295.390381))); //Dragonslayer's Grotto
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_FaceMeIfYouDare_1_NG", 		Vector(213.855240, -32.358776)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_HarassingATroll_NG", 			Vector(138.532272, 811.463623)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_HighwayRobbery_NG", 			Vector(300.595459, -135.326324)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_HighwaymansCache_NG", 			Vector(519.180176, -212.923065)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_LootersHeatherton_NG", 		Vector(151.509430, 508.062775)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_LootersCodgersQuarry_NG", 		Vector(1221.132690, 831.181274)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_LootersToderas_NG", 			Vector(1720.736694, 67.942719)	));
		parent.RandomEvents_Velen.PushBack(parent.CreateEntry().initEvent(group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Event, true,  "novigrad", "PotP_Event_MansBestFriend_NG", 			Vector(643.049805, 799.665344)	));
		
		SortPreviewData(parent.RandomEvents_Velen, PotP_A_Event);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_Novigrad";
		
		parent.RandomEvents_Novigrad.Clear();
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_AWarmWelcome_NG", 				Vector(1347.046143, 1591.817261)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_AtTheMercyOfStrangers_2_NG", 	Vector(393.423737, 1265.788696)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_DrunkenRabble_NG", 				Vector(543.444885, 1839.808228)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_FaceMeIfYouDare_2_NG", 			Vector(899.003479, 1732.530640)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_FaceMeIfYouDare_3_NG", 			Vector(505.266266, 1915.563843)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_KarmicJustice_NG", 				Vector(862.002502, 1831.773438)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_NeverTrustChildren_NG", 		Vector(765.527771, 1932.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_RacistsOfNovigradFC_NG", 		Vector(858.879944, 1819.517700)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_09", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_RacistsOfNovigradHS_NG", 		Vector(553.651428, 1677.662231)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_10", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_StrangersInTheNight_NG", 		Vector(1370.983887, 1507.835815)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_11", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_StrumpetInDistress_NG", 		Vector(411.762390, 1672.084839)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_12", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_SuspiciousShakedown_NG", 		Vector(739.579529, 1761.638062)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_13", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_TheFlameOfHatred_NG_1", 		Vector(714.057678, 1861.176392)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_19", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_TheFlameOfHatred_NG_2", 		Vector(793.164673, 1868.151978)		));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_14", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_TheMostTruestOfBasilisks_NG", 	Vector(1911.729736, 1141.309082)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_15", PotP_E_Primary, PotP_R_NO, PotP_I_Event, true, 	"novigrad", "PotP_Event_ThePriceOfPassage_NG_1", 		Vector(1678.246338, 1037.727295)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_17", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_ThePriceOfPassage_NG_2", 		Vector(1766.244873, 1038.741089)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_18", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_ThePriceOfPassage_NG_3", 		Vector(1932.989990, 1070.466309)	));
		parent.RandomEvents_Novigrad.PushBack(parent.CreateEntry().initEvent(group + "_16", PotP_E_Primary, PotP_R_NO, PotP_I_Event, false, "novigrad", "PotP_Event_WitchHunterRaids_NG", 			Vector(580.663086, 1569.924316)		));
		
		SortPreviewData(parent.RandomEvents_Novigrad, PotP_A_Event);

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
		
		SortPreviewData(parent.RandomEvents_Skellige, PotP_A_Event);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_RandomEvents_KaerMorhen";
		
		parent.RandomEvents_KaerMorhen.Clear();
		parent.RandomEvents_KaerMorhen.PushBack(parent.CreateEntry().initEvent(group + "_01", PotP_E_Primary, PotP_R_KM, PotP_I_Event, true, "kaer_morhen", "PotP_Event_TrailOfEchoes_NG", Vector(-327.778656, 175.190674)	));
		
		SortPreviewData(parent.RandomEvents_KaerMorhen, PotP_A_Event);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_Contracts() {	

		var group: string = "PotP_TrackingGroup_ContractQuests_WhiteOrchard";
		
		parent.ContQuests_WhiteOrchard.Clear();
		parent.ContQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Conts, "mq0003: Noonwraith"));
		
		SortPreviewData(parent.ContQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Velen";
		
		parent.ContQuests_Velen.Clear();
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Nightwraith"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Arachas"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Czart"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1051_nilfgaard"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mh105: Hunt Wyvern"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Cockatrice"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Fogling"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "mq1058 Lynx Witcher Fake "));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "sq108: Griffon"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Grave Hag"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "NML Hunt: Ekimma"));
		parent.ContQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Conts, "SQ305 Scoiatael"));
		
		SortPreviewData(parent.ContQuests_Velen, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Novigrad";
		
		parent.ContQuests_Novigrad.Clear();
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh305 : Doppler"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh303: Succubus"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh306 : Da'o"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh302 : Leszy"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh307: Wild Hunt Minion"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh301: Gryphon"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh304: Katakan"));
		parent.ContQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_NO, PotP_I_Conts, "mh308 : Noonwratih"));
		
		SortPreviewData(parent.ContQuests_Novigrad, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Skellige";
		
		parent.ContQuests_Skellige.Clear();
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh208 : Forktail"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh210 : Lamia"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh201 : Cave Troll"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh206 : Fiend"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh203: Water Hag"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mq2052 Reversed Monster Hunt"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh202: Nekker Warrior"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "mh207: Wraith"));
		parent.ContQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Conts, "SQ204 Forest Spirit"));
		
		SortPreviewData(parent.ContQuests_Skellige, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ContractQuests_Toussaint";
		
		parent.ContQuests_Toussaint.Clear();
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "SQ703 wine_wars"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7010 Airborne Cattle"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "MH701 tectonic_terror"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7017_talking_horse"));
		parent.ContQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Conts, "mq7002 Stubborn Knight"));
		
		SortPreviewData(parent.ContQuests_Toussaint, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_ScavangerHunts() {	

		var group: string = "PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet";
		
		parent.ScavQuests_Griffin.Clear();
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Set"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1A"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 1B"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 2"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, 	 PotP_R_NA, PotP_I_Scavs, "Gryphon Upgrades 3"));
		parent.ScavQuests_Griffin.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, PotP_R_NA, PotP_I_Scavs, "th701_gryphon_gear"));
		
		SortPreviewData(parent.ScavQuests_Griffin, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_FelineSet";
		
		parent.ScavQuests_Feline.Clear();
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Set"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1a"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 1b"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 2"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Lynx Upgrades 3"));
		parent.ScavQuests_Feline.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_cat_gear"));
		
		SortPreviewData(parent.ScavQuests_Feline, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet";
		
		parent.ScavQuests_Ursine.Clear();
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Set"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1A"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 1B"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 2"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Bear Upgrades 3"));
		parent.ScavQuests_Ursine.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_bear_gear"));
		
		SortPreviewData(parent.ScavQuests_Ursine, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet";
		
		parent.ScavQuests_Wolven.Clear();
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Set"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1A"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 1B"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 2b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Wolf Upgrades 3b"));
		parent.ScavQuests_Wolven.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th701_wolf_gear"));
		
		SortPreviewData(parent.ScavQuests_Wolven, PotP_A_Quest);		

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_ScavengerHuntQuests_OtherSets";
		
		parent.ScavQuests_Others.Clear();
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, 		PotP_R_NA, PotP_I_Scavs, "Viper Set"));
		parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC2, 	PotP_R_NA, PotP_I_Scavs, "th700_red_wolf"));

		if (PotP_IsUsingNextGen()) 
		{
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, 	PotP_R_NA, PotP_I_Scavs, "mq1060_armor_upgrades"));
		}

		if (PotP_UsingDLCArmorQuests()) // Nexus ID: https://www.nexusmods.com/witcher3/mods/3983
		{ 
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "temeriatreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "nilfgaardtreasurehunt"));
			parent.ScavQuests_Others.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_ModAdded, 	PotP_R_NA, PotP_I_Scavs, "skelligetreasurehunt"));
		}
		
		SortPreviewData(parent.ScavQuests_Others, PotP_A_Quest);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_MiscQuests_TreasureHunts() {

		var group: string = "PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard";
		
		parent.HuntQuests_WhiteOrchard.Clear();
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_deserter_stash"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_bandit_treasure"));
		parent.HuntQuests_WhiteOrchard.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_WO, PotP_I_Hunts, "lw_prologue_temerian_treasure"));
		
		SortPreviewData(parent.HuntQuests_WhiteOrchard, PotP_A_Quest);
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Velen";
		
		parent.HuntQuests_Velen.Clear();
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Sunken treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb24"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr12_ferry_station_2"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr41"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr39"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "Elvish Chest"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr40"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de32_campfire_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr7_hidden_pier"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_de11"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_sb2_sunken_ships_note"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_cp33_sunken_treasure"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_tm6"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr34"));
		parent.HuntQuests_Velen.PushBack(parent.CreateEntry().initQuest(group + "_16", PotP_E_Primary, PotP_R_VE, PotP_I_Hunts, "lw_gr_poi_042_ponds"));
		
		SortPreviewData(parent.HuntQuests_Velen, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Novigrad";
		
		parent.HuntQuests_Novigrad.Clear();
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26b"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi08"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, 		PotP_R_NO, PotP_I_Hunts, "lw_cp34_shipwreck_island"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "th1010ofirarmor"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi01"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi10"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi02"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi26"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi05"));
		parent.HuntQuests_Novigrad.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary_DLC1, 	PotP_R_NO, PotP_I_Hunts, "ep1poi04"));
		
		SortPreviewData(parent.HuntQuests_Novigrad, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Skellige";
		
		parent.HuntQuests_Skellige.Clear();
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_005"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk30_mushroom_farms"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_057"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk31"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_056"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk3_sunken_treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_042"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk4"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_skellige_sk48_splintered_ships"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Erleif's Treasure"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk_poi_050"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "lw_sk38"));
		parent.HuntQuests_Skellige.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary, PotP_R_SK, PotP_I_Hunts, "MQ2006 Bergeton's Treasure"));
		
		SortPreviewData(parent.HuntQuests_Skellige, PotP_A_Quest);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_TreasureHuntQuests_Toussaint";
		
		parent.HuntQuests_Toussaint.Clear();
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_01", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_a_01"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_02", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "vin_b_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_03", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_04", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_cor_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_05", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ww_ver_13"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_06", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_bar_a_05"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_07", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_a_11"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_08", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "san_b_02"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_09", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "poi_gor_d_20"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_10", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_08"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_11", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "car_b_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_12", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_c_14"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_13", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "gor_b_04"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_14", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "bar_a_10"));
		parent.HuntQuests_Toussaint.PushBack(parent.CreateEntry().initQuest(group + "_15", PotP_E_Primary_DLC2, PotP_R_TO, PotP_I_Hunts, "ved_a_03"));
		
		SortPreviewData(parent.HuntQuests_Toussaint, PotP_A_Quest);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_SteelSwords() 
	{
		var group: string;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{
			group = "PotP_TrackingGroup_Relics_SteelSwords_W3EE";
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna_crafted')	.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword_crafted')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'PC Caretaker Shovel')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')				.compilevariations(''));

			if (PotP_IsUsingNextGen()) 
			{
				parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')						.compilevariations(''));
			}
		
			SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items);
			return;
		}
		
		group = "PotP_TrackingGroup_Relics_SteelSwords";
		parent.Relic_SteelSwords.Clear();
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Angivare')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator')						.compilevariations('Arbitrator_crafted'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ashrune')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon')					.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie')						.compilevariations('Beannshie_crafted'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 3')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn')						.compilevariations('Blackunicorn_crafted'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')		.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Bloedeaedd')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Karabela')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caroline')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cleaver')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dyaebl')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dancer')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Daystar')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 2')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 1')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Forgottenvransword')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth')					.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwestog')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Harvall')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hjalmar_Short_Steel_Sword')		.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Vynbleidd')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis')								.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')					.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw')							.compilevariations('Longclaw_crafted'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune')								.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Mourner')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')		.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Iron Poker')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_42", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Squire steel sword 3')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_43", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna')		.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_44", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_45", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_46", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gnomish sword 2')					.compilevariations('Gnomish sword 2_crafted'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_47", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_48", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl2 steel sword 3')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_49", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl1 steel sword 3')			.compilevariations('Guard lvl1 steel sword 3 Autogen'));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_50", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_51", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Toussaint steel sword 3')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_52", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum')						.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_53", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hanza steel sword 3')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_54", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')				.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_55", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Abarad')							.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_56", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')			.compilevariations(''));
		parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_57", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Wolf')								.compilevariations(''));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_58", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')					.compilevariations(''));
		}

		SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items);	
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_SilverSwords() 
	{
		var group: string;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{
			group = "PotP_TrackingGroup_Relics_SilverSwords_W3EE";
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe_crafted')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned_crafted')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Adversary Silver Sword')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment_crafted')				.compilevariations(''));
			
			if (PotP_IsUsingNextGen()) 
			{
				parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')					.compilevariations(''));
			}
		
			SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items);
			return;
		}

		group = "PotP_TrackingGroup_Relics_SilverSwords";
		parent.Relic_SilverSwords.Clear();
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Addandeith')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 3R')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anathema')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anth')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Arainne')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bladeofys')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'WitcherSilverWolf')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Breathofthenorth')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 1R')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deargdeith')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deithwen')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 1')				.compilevariations('Serpent Silver Sword 1 Autogen'));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations('Serpent Silver Sword 3'));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvael')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvaelaedd')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy')								.compilevariations('Harpy_crafted'));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Loathen')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Moonblade')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe')						.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator')							.compilevariations('Negotiator_crafted'));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'DLC10_Remorse')						.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned')					.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 2')				.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg')								.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Torzirael')							.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'mq4005 Silver sword 6_crafted')		.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper')								.compilevariations('Weeper_crafted'));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment')						.compilevariations(''));
		parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q505 crafted sword')					.compilevariations(''));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')					.compilevariations(''));
		}
		
		SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_Crossbows() 
	{
		var group: string;
		
		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_Relics_Crossbows_W3EE";
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
			
			SortPreviewData(parent.Relic_Crossbows, PotP_A_Items);
			return;
		}
		
		group = "PotP_TrackingGroup_Relics_Crossbows";
		parent.Relic_Crossbows.Clear();
		parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow 7')			.compilevariations(''));
		parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
		parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
		
		SortPreviewData(parent.Relic_Crossbows, PotP_A_Items);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_Relics_MonsterTrophies()
	{
		var group: string = "PotP_TrackingGroup_Trophies";
		
		parent.Relic_Trophies.Clear();
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh102_arachas_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'sq108_griffin_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh201_cave_troll_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh107_czart_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh101_cockatrice_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q603_sharley_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh305_doppler_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh306_dao_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh210_lamia_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh104_ekimma_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh206_fiend_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh108_fogling_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh208_forktail_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q704_garkain_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q701_cyclops_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh106_gravehag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh301_gryphon_trophy')			.compilevariations('q002_griffin_trophy', 'mq7009_griffin_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7002_spriggan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh304_katakan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q602_pig_contest_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh204_leshy_trophy')				.compilevariations('mh302_leshy_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh202_nekker_warrior_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh103_nightwraith_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq0003_noonwraith_trophy')		.compilevariations('mh308_noonwraith_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh701_sharley_matriarch_trophy')	.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7018_basilisk_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7010_dracolizard_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh303_succubus_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'camm_trophy')						.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7017_zmora_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh203_water_hag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q702_wicht_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_33", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh307_minion_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_34", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh207_wraith_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(group + "_35", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh105_wyvern_trophy')				.compilevariations('mq1051_wyvern_trophy'));
		
		SortPreviewData(parent.Relic_Trophies, PotP_A_Items);
	}	

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ArmorSets() 
	{
		var group: string;
		
		if (PotP_IsUsingNextGen()) 
		{
			group = "PotP_TrackingGroup_GearSets_ForgottenWolven";
			parent.Armor_ForgottenWolven.Clear();
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Netflix Armor')		.compilevariations('Netflix Armor 1', 			'Netflix Armor 2'));
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Netflix Boots')		.compilevariations('Netflix Boots 1', 			'Netflix Boots 2'));
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Netflix Gloves')		.compilevariations('Netflix Gloves 1', 			'Netflix Gloves 2'));
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Netflix Pants')		.compilevariations('Netflix Pants 1', 			'Netflix Pants 2'));
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Netflix steel sword')	.compilevariations('Netflix steel sword 1', 	'Netflix steel sword 2',  'Reinald Netflix steel sword'));
			parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'Netflix silver sword')	.compilevariations('Netflix silver sword 1', 	'Netflix silver sword 2', 'Reinald Netflix silver sword'));
			
			SortPreviewData(parent.Armor_ForgottenWolven, PotP_A_Items);

			//------------------------------------------------------
		
			group = "PotP_TrackingGroup_GearSets_DolBlathanna";
			parent.Armor_DolBlathanna.Clear();
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Dol Blathanna Armor')			 .compilevariations(''));
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Dol Blathanna Boots')			 .compilevariations(''));
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Dol Blathanna Gloves')		 .compilevariations(''));
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Dol Blathanna Pants')			 .compilevariations(''));
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Dol Blathanna longsword')		 .compilevariations(''));
			parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'White Widow of Dol Blathanna') .compilevariations(''));
			
			SortPreviewData(parent.Armor_DolBlathanna, PotP_A_Items);

			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_GearSets_WhiteTiger";
			parent.Armor_WhiteTiger.Clear();
			parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'White Tiger Armor')	 .compilevariations(''));
			parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'White Tiger Boots')	 .compilevariations(''));
			parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'White Tiger Gloves') .compilevariations(''));
			parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'White Tiger Pants')	 .compilevariations(''));
			
			SortPreviewData(parent.Armor_WhiteTiger, PotP_A_Items);			
		}

		group = "PotP_TrackingGroup_GearSets_HenGaidth";
		parent.Armor_HenGaidth.Clear();
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q704_vampire_armor')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q704_vampire_boots')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q704_vampire_gloves') .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q704_vampire_mask')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q704_vampire_pants')	 .compilevariations(''));
		
		SortPreviewData(parent.Armor_HenGaidth, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_NewMoon";
		parent.Armor_NewMoon.Clear();
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Thief Armor')	.compilevariations('Thief Armor No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Thief Boots')	.compilevariations('Thief Boots No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Thief Gloves') .compilevariations('Thief Gloves No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Thief Pants')	.compilevariations('Thief Pants No Medallion'));
		
		SortPreviewData(parent.Armor_NewMoon, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Nilfgaardian";
		parent.Armor_Nilfgaardian.Clear();
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC5 Nilfgaardian Armor')	 .compilevariations('NGP DLC5 Nilfgaardian Armor'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC5 Nilfgaardian Boots')	 .compilevariations('NGP DLC5 Nilfgaardian Boots'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC5 Nilfgaardian Gloves') .compilevariations('NGP DLC5 Nilfgaardian Gloves'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC5 Nilfgaardian Pants')	 .compilevariations('NGP DLC5 Nilfgaardian Pants'));
		
		SortPreviewData(parent.Armor_Nilfgaardian, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Ofieri";
		parent.Armor_Ofieri.Clear();
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Crafted Ofir Armor') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Crafted Ofir Boots') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Crafted Ofir Gloves') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Crafted Ofir Pants') 	.compilevariations(''));
		
		SortPreviewData(parent.Armor_Ofieri, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Temerian";
		parent.Armor_Temerian.Clear();
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC1 Temerian Armor')	 .compilevariations('NGP DLC1 Temerian Armor'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC1 Temerian Boots')	 .compilevariations('NGP DLC1 Temerian Boots'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC1 Temerian Gloves') .compilevariations('NGP DLC1 Temerian Gloves'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC1 Temerian Pants')	 .compilevariations('NGP DLC1 Temerian Pants'));
		
		SortPreviewData(parent.Armor_Temerian, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_TeshamMutna";
		parent.Armor_TeshamMutna.Clear();
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q702_vampire_armor')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q702_vampire_boots')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q702_vampire_gloves')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q702_vampire_mask')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q702_vampire_pants')	.compilevariations(''));
		
		SortPreviewData(parent.Armor_TeshamMutna, PotP_A_Items);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Undvik";
		parent.Armor_Undvik.Clear();
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC14 Skellige Armor')		.compilevariations('NGP DLC14 Skellige Armor', 'q108 Medium armor 10'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC14 Skellige Boots')		.compilevariations('NGP DLC14 Skellige Boots'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC14 Skellige Gloves')		.compilevariations('NGP DLC14 Skellige Gloves'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC14 Skellige Pants')		.compilevariations('NGP DLC14 Skellige Pants'));
		
		SortPreviewData(parent.Armor_Undvik, PotP_A_Items);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ModAdded()
	{
		var group: string;
		
		if (PotP_UsingSezonBurz()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/2818
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_SezonBurz";
			parent.DLC_SezonBurz.Clear();
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Armor, 'Sezon Burz Armor')			.compilevariations('Sezon Burz Armor NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Pants, 'Sezon Burz Pants')			.compilevariations('Sezon Burz Pants NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Glove, 'Sezon Burz Gloves')			.compilevariations('Sezon Burz Gloves NGP', 'Sezon Burz Fingerless Gloves', 'Sezon Burz Fingerless Gloves NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Boots, 'Sezon Burz Boots')			.compilevariations('Sezon Burz Boots NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Silve, 'Sezon Burz Silver Sword')		.compilevariations('Sezon Burz Silver Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Steel, 'Sezon Burz Steel Sword')		.compilevariations('Sezon Burz Steel Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Cross, 'Sezon Burz Crossbow 1')		.compilevariations('Sezon Burz Crossbow 2', 'Sezon Burz Crossbow 3'));
			
			SortPreviewData(parent.DLC_SezonBurz, PotP_A_Items);
		}

		//------------------------------------------------------

		if (PotP_UsingCosWiecej()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5986
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_CosWiecej";
			parent.DLC_CosWiecej.Clear();
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Armor, 'wiecej')				.compilevariations('wiecej ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Glove, 'wiecej gloves')		.compilevariations('wiecej gloves ngp', 'wiecej gloves 2', 'wiecej gloves 2 ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Pants, 'wiecej pants')		.compilevariations('wiecej pants ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Boots, 'wiecej boots')		.compilevariations('wiecej boots ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'wiecej steel')		.compilevariations('wiecej steel ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Silve, 'wiecej silver')		.compilevariations('wiecej silver ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'rune sihil')			.compilevariations('rune sihil ngp', 'rune sihil 2', 'rune sihil 2 ngp'));
			
			SortPreviewData(parent.DLC_CosWiecej, PotP_A_Items);
		}

		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic";
			parent.DLC_Gothic.Clear();
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v1_1')			.compilevariations('kotw_armor_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v1_1')			.compilevariations('kotw_gloves_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v1_1')				.compilevariations('kotw_legs_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v1_1')			.compilevariations('kotw_boots_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v1_1_usable')		.compilevariations(''));
			
			SortPreviewData(parent.DLC_Gothic, PotP_A_Items);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite";
			parent.DLC_Meteorite.Clear();
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v2_1')			.compilevariations('kotw_armor_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v2_1')		.compilevariations('kotw_gloves_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v2_1')			.compilevariations('kotw_legs_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v2_1')			.compilevariations('kotw_boots_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v2_1_usable')	.compilevariations(''));
			
			SortPreviewData(parent.DLC_Meteorite, PotP_A_Items);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium";
			parent.DLC_Dimeritium.Clear();
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v3_1')		.compilevariations('kotw_armor_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v3_1')		.compilevariations('kotw_gloves_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v3_1')			.compilevariations('kotw_legs_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v3_1')		.compilevariations('kotw_boots_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v3_1_usable')	.compilevariations(''));
			
			SortPreviewData(parent.DLC_Dimeritium, PotP_A_Items);
		}
	}	

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ShadesOfIronGearSets()
	{
		var group: string = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker";
		parent.Shades_Berserker.Clear();
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Berserker Armor')	.compilevariations('Shades Berserker Armor 1', 	'Shades Berserker Armor 2'));
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Berserker Boots')	.compilevariations('Shades Berserker Boots 1', 	'Shades Berserker Boots 2'));
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Berserker Gloves')	.compilevariations('Shades Berserker Gloves 1', 'Shades Berserker Gloves 2'));
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Berserker Pants')	.compilevariations('Shades Berserker Pants 1', 	'Shades Berserker Pants 2'));
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Cage')	.compilevariations(''));
		parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Helm')	.compilevariations(''));
			
		SortPreviewData(parent.Shades_Berserker, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck";
		parent.Shades_Bismarck.Clear();
		parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Bismarck Armor')		.compilevariations('Shades Bismarck Armor 1', 	'Shades Bismarck Armor 2'));
		parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Bismarck Boots')		.compilevariations('Shades Bismarck Boots 1', 	'Shades Bismarck Boots 2'));
		parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Bismarck Gloves')	.compilevariations('Shades Bismarck Gloves 1', 	'Shades Bismarck Gloves 2'));
		parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Bismarck Pants')		.compilevariations('Shades Bismarck Pants 1', 	'Shades Bismarck Pants 2'));
		parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Bismarck Helm')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Bismarck, PotP_A_Items);			

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter";
		parent.Shades_BloodHunter.Clear();
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Hunter Armor')	.compilevariations('Shades Hunter Armor 1', 	'Shades Hunter Armor 2'));
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Hunter Boots')	.compilevariations('Shades Hunter Boots 1', 	'Shades Hunter Boots 2'));
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Hunter Gloves')	.compilevariations('Shades Hunter Gloves 1', 	'Shades Hunter Gloves 2'));
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Hunter Pants')	.compilevariations('Shades Hunter Pants 1', 	'Shades Hunter Pants 2'));
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Hat')		.compilevariations(''));
		parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Mask')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_BloodHunter, PotP_A_Items);			

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow";
		parent.Shades_CrowFeathered.Clear();
		parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Crow Armor')	.compilevariations('Shades Crow Armor 1', 	'Shades Crow Armor 2'));
		parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Crow Boots')	.compilevariations('Shades Crow Boots 1', 	'Shades Crow Boots 2'));
		parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Crow Gloves')	.compilevariations('Shades Crow Gloves 1', 	'Shades Crow Gloves 2'));
		parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Crow Pants')	.compilevariations('Shades Crow Pants 1', 	'Shades Crow Pants 2'));
		parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Crow Mask')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_CrowFeathered, PotP_A_Items);	

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight";
		parent.Shades_FallenKnight.Clear();
		parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Fallen Armor')	.compilevariations('Shades Fallen Armor 1', 	'Shades Fallen Armor 2'));
		parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Fallen Boots')	.compilevariations('Shades Fallen Boots 1', 	'Shades Fallen Boots 2'));
		parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Fallen Gloves')	.compilevariations('Shades Fallen Gloves 1', 	'Shades Fallen Gloves 2'));
		parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Fallen Pants')	.compilevariations('Shades Fallen Pants 1', 	'Shades Fallen Pants 2'));
		parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Fallen Helm')	.compilevariations(''));
			
		SortPreviewData(parent.Shades_FallenKnight, PotP_A_Items);			

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam";
		parent.Shades_Faraam.Clear();
		parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Faraam Armor')		.compilevariations('Shades Faraam Armor 1', 	'Shades Faraam Armor 2'));
		parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Faraam Boots')		.compilevariations('Shades Faraam Boots 1', 	'Shades Faraam Boots 2'));
		parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Faraam Gloves')	.compilevariations('Shades Faraam Gloves 1', 	'Shades Faraam Gloves 2'));
		parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Faraam Pants')		.compilevariations('Shades Faraam Pants 1', 	'Shades Faraam Pants 2'));
		parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Faraam Helm')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Faraam, PotP_A_Items);				

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker";
		parent.Shades_Headtaker.Clear();
		parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Headtaker Armor')		.compilevariations('Shades Headtaker Armor 1', 	'Shades Headtaker Armor 2'));
		parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Headtaker Boots')		.compilevariations('Shades Headtaker Boots 1', 	'Shades Headtaker Boots 2'));
		parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Headtaker Gloves')		.compilevariations('Shades Headtaker Gloves 1', 'Shades Headtaker Gloves 2'));
		parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Headtaker Pants')		.compilevariations('Shades Headtaker Pants 1', 	'Shades Headtaker Pants 2'));
		parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Headtaker Mask')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Headtaker, PotP_A_Items);
		
		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri";
		parent.Shades_Hitokiri.Clear();
		parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Viper Armor')		.compilevariations('Shades Viper Armor 1', 	'Shades Viper Armor 2'));
		parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Viper Boots')		.compilevariations('Shades Viper Boots 1', 	'Shades Viper Boots 2'));
		parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Viper Gloves')		.compilevariations('Shades Viper Gloves 1', 'Shades Viper Gloves 2'));
		parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Viper Pants')		.compilevariations('Shades Viper Pants 1', 	'Shades Viper Pants 2'));
		parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hitokiri Mask')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Hitokiri, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara";
		parent.Shades_Kara.Clear();
		parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Kara Armor')		.compilevariations('Shades Kara Armor 1', 	'Shades Kara Armor 2'));
		parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Kara Boots')		.compilevariations('Shades Kara Boots 1', 	'Shades Kara Boots 2'));
		parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Kara Gloves')	.compilevariations('Shades Kara Gloves 1', 	'Shades Kara Gloves 2'));
		parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Kara Pants')		.compilevariations('Shades Kara Pants 1', 	'Shades Kara Pants 2'));
		parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Kara Hat')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Kara, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter";
		parent.Shades_LionHunter.Clear();
		parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Lionhunter Armor')		.compilevariations('Shades Lionhunter Armor 1', 	'Shades Lionhunter Armor 2'));
		parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Lionhunter Boots')		.compilevariations('Shades Lionhunter Boots 1', 	'Shades Lionhunter Boots 2'));
		parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Lionhunter Gloves')	.compilevariations('Shades Lionhunter Gloves 1', 	'Shades Lionhunter Gloves 2'));
		parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Lionhunter Pants')		.compilevariations('Shades Lionhunter Pants 1', 	'Shades Lionhunter Pants 2'));
		parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Lionhunter Hat')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_LionHunter, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin";
		parent.Shades_Assassin.Clear();
		parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Ezio Armor')		.compilevariations('Shades Ezio Armor 1', 	'Shades Ezio Armor 2'));
		parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Ezio Boots')		.compilevariations('Shades Ezio Boots 1', 	'Shades Ezio Boots 2'));
		parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Ezio Gloves')	.compilevariations('Shades Ezio Gloves 1', 	'Shades Ezio Gloves 2'));
		parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Ezio Pants')		.compilevariations('Shades Ezio Pants 1', 	'Shades Ezio Pants 2'));
		parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ezio Hood')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Assassin, PotP_A_Items);		

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter";
		parent.Shades_OldHunter.Clear();
		parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Oldhunter Armor')	.compilevariations('Shades Oldhunter Armor 1', 	'Shades Oldhunter Armor 2'));
		parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Oldhunter Boots')	.compilevariations('Shades Oldhunter Boots 1', 	'Shades Oldhunter Boots 2'));
		parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Oldhunter Gloves')	.compilevariations('Shades Oldhunter Gloves 1', 'Shades Oldhunter Gloves 2'));
		parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Oldhunter Pants')	.compilevariations('Shades Oldhunter Pants 1', 	'Shades Oldhunter Pants 2'));
		parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Oldhunter Cap')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_OldHunter, PotP_A_Items);	

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant";
		parent.Shades_Revenant.Clear();
		parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Revenant Armor')		.compilevariations('Shades Revenant Armor 1', 	'Shades Revenant Armor 2'));
		parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Revenant Boots')		.compilevariations('Shades Revenant Boots 1', 	'Shades Revenant Boots 2'));
		parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Revenant Gloves')	.compilevariations('Shades Revenant Gloves 1', 	'Shades Revenant Gloves 2'));
		parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Revenant Pants')		.compilevariations('Shades Revenant Pants 1', 	'Shades Revenant Pants 2'));
		parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Revenant Hood')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Revenant, PotP_A_Items);	

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker";
		parent.Shades_Stalker.Clear();
		parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Undertaker Armor')	.compilevariations('Shades Undertaker Armor 1', 	'Shades Undertaker Armor 2'));
		parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Undertaker Boots')	.compilevariations('Shades Undertaker Boots 1', 	'Shades Undertaker Boots 2'));
		parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Undertaker Gloves')	.compilevariations('Shades Undertaker Gloves 1', 	'Shades Undertaker Gloves 2'));
		parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Undertaker Pants')	.compilevariations('Shades Undertaker Pants 1', 	'Shades Undertaker Pants 2'));
		parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Undertaker Mask')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Stalker, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng";
		parent.Shades_Taifeng.Clear();
		parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Taifeng Armor')	.compilevariations('Shades Taifeng Armor 1', 	'Shades Taifeng Armor 2'));
		parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Taifeng Boots')	.compilevariations('Shades Taifeng Boots 1', 	'Shades Taifeng Boots 2'));
		parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Taifeng Gloves')	.compilevariations('Shades Taifeng Gloves 1', 	'Shades Taifeng Gloves 2'));
		parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Taifeng Pants')	.compilevariations('Shades Taifeng Pants 1', 	'Shades Taifeng Pants 2'));
		parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ronin Hat')		.compilevariations(''));
			
		SortPreviewData(parent.Shades_Taifeng, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen";
		parent.Shades_Unseen.Clear();
		parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Yahargul Armor')	.compilevariations('Shades Yahargul Armor 1', 	'Shades Yahargul Armor 2'));
		parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Yahargul Boots')	.compilevariations('Shades Yahargul Boots 1', 	'Shades Yahargul Boots 2'));
		parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Yahargul Gloves')	.compilevariations('Shades Yahargul Gloves 1', 	'Shades Yahargul Gloves 2'));
		parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Yahargul Pants')	.compilevariations('Shades Yahargul Pants 1', 	'Shades Yahargul Pants 2'));
		parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Yahargul Helm')	.compilevariations(''));
			
		SortPreviewData(parent.Shades_Unseen, PotP_A_Items);		

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis";
		parent.Shades_Sithis.Clear();
		parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Sithis Armor')	.compilevariations('Shades Sithis Armor 1', 	'Shades Sithis Armor 2'));
		parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Sithis Hood')	.compilevariations(''));
			
		SortPreviewData(parent.Shades_Sithis, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	latent function Initialise_Items_ShadesOfIronSwords() 
	{
		var group: string = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords";
		parent.Shades_SilverSwords.Clear();
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Eagle Sword')			.compilevariations('Shades Silver Eagle Sword 1', 			'Shades Silver Eagle Sword 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ares')				.compilevariations('Shades Silver Ares 1', 					'Shades Silver Ares 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Doomblade')			.compilevariations('Shades Silver Doomblade 1', 			'Shades Silver Doomblade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Beastcutter')			.compilevariations('Shades Silver Beastcutter 1', 			'Shades Silver Beastcutter 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blackdawn')			.compilevariations('Shades Silver Blackdawn 1', 			'Shades Silver Blackdawn 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blooddusk')			.compilevariations('Shades Silver Blooddusk 1', 			'Shades Silver Blooddusk 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodletter')			.compilevariations('Shades Silver Bloodletter 1', 			'Shades Silver Bloodletter 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodshot')			.compilevariations('Shades Silver Bloodshot 1', 			'Shades Silver Bloodshot 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Claymore')			.compilevariations('Shades Silver Claymore 1', 				'Shades Silver Claymore 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kingslayer')			.compilevariations('Shades Silver Kingslayer 1', 			'Shades Silver Kingslayer 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Cursed Khopesh')		.compilevariations('Shades Silver Cursed Khopesh 1',		'Shades Silver Cursed Khopesh 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Dragonbane')			.compilevariations('Shades Silver Dragonbane 1', 			'Shades Silver Dragonbane 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ejderblade')			.compilevariations('Shades Silver Ejderblade 1', 			'Shades Silver Ejderblade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Flameborn')			.compilevariations('Shades Silver Flameborn 1', 			'Shades Silver Flameborn 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Frostmourne')			.compilevariations('Shades Silver Frostmourne 1', 			'Shades Silver Frostmourne 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Gorgonslayer')		.compilevariations('Shades Silver Gorgonslayer 1', 			'Shades Silver Gorgonslayer 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Graveripper')			.compilevariations('Shades Silver Graveripper 1', 			'Shades Silver Graveripper 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Guandao')				.compilevariations('Shades Silver Guandao 1', 				'Shades Silver Guandao 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Crownbreaker')		.compilevariations('Shades Silver Crownbreaker 1', 			'Shades Silver Crownbreaker 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hades Grasp')			.compilevariations('Shades Silver Hades Grasp 1', 			'Shades Silver Hades Grasp 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Haoma')				.compilevariations('Shades Silver Haoma 1', 				'Shades Silver Haoma 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Heavenspire')			.compilevariations('Shades Silver Heavenspire 1', 			'Shades Silver Heavenspire 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hellspire')			.compilevariations('Shades Silver Hellspire 1', 			'Shades Silver Hellspire 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Icarus Tears')		.compilevariations('Shades Silver Icarus Tears 1', 			'Shades Silver Icarus Tears 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ryu Katana')			.compilevariations('Shades Silver Ryu Katana 1', 			'Shades Silver Ryu Katana 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Lion Sword')			.compilevariations('Shades Silver Lion Sword 1', 			'Shades Silver Lion Sword 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oathblade')			.compilevariations('Shades Silver Oathblade 1', 			'Shades Silver Oathblade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oblivion')			.compilevariations('Shades Silver Oblivion 1', 				'Shades Silver Oblivion 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hitokiri Katana')		.compilevariations('Shades Silver Hitokiri Katana 1', 		'Shades Silver Hitokiri Katana 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Pridefall')			.compilevariations('Shades Silver Pridefall 1', 			'Shades Silver Pridefall 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Rakuyo')				.compilevariations('Shades Silver Rakuyo 1', 				'Shades Silver Rakuyo 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Blade')	.compilevariations('Shades Silver Realmdrifter Blade 1', 	'Shades Silver Realmdrifter Blade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Divider').compilevariations('Shades Silver Realmdrifter Divider 1', 	'Shades Silver Realmdrifter Divider 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kukri')				.compilevariations('Shades Silver Kukri 1', 				'Shades Silver Kukri 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sinner')				.compilevariations('Shades Silver Sinner 1', 				'Shades Silver Sinner 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sithis Blade')		.compilevariations('Shades Silver Sithis Blade 1', 			'Shades Silver Sithis Blade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Voidblade')			.compilevariations('Shades Silver Voidblade 1', 			'Shades Silver Voidblade 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Vulcan')				.compilevariations('Shades Silver Vulcan 1', 				'Shades Silver Vulcan 2'));
		parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Knife')				.compilevariations('Shades Silver Knife 1', 				'Shades Silver Knife 2'));
			
		SortPreviewData(parent.Shades_SilverSwords, PotP_A_Items);

		//------------------------------------------------------
			
		group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords";
		parent.Shades_SteelSwords.Clear();
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Eagle Sword')			.compilevariations('Shades Steel Eagle Sword 1', 			'Shades Steel Eagle Sword 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ares')					.compilevariations('Shades Steel Ares 1', 					'Shades Steel Ares 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Doomblade')				.compilevariations('Shades Steel Doomblade 1', 				'Shades Steel Doomblade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Beastcutter')			.compilevariations('Shades Steel Beastcutter 1', 			'Shades Steel Beastcutter 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blackdawn')				.compilevariations('Shades Steel Blackdawn 1', 				'Shades Steel Blackdawn 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blooddusk')				.compilevariations('Shades Steel Blooddusk 1', 				'Shades Steel Blooddusk 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodletter')			.compilevariations('Shades Steel Bloodletter 1', 			'Shades Steel Bloodletter 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodshot')				.compilevariations('Shades Steel Bloodshot 1', 				'Shades Steel Bloodshot 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Claymore')				.compilevariations('Shades Steel Claymore 1', 				'Shades Steel Claymore 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kingslayer')			.compilevariations('Shades Steel Kingslayer 1', 			'Shades Steel Kingslayer 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Cursed Khopesh')		.compilevariations('Shades Steel Cursed Khopesh 1',			'Shades Steel Cursed Khopesh 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Dragonbane')			.compilevariations('Shades Steel Dragonbane 1', 			'Shades Steel Dragonbane 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ejderblade')			.compilevariations('Shades Steel Ejderblade 1', 			'Shades Steel Ejderblade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Flameborn')				.compilevariations('Shades Steel Flameborn 1', 				'Shades Steel Flameborn 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Frostmourne')			.compilevariations('Shades Steel Frostmourne 1', 			'Shades Steel Frostmourne 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Gorgonslayer')			.compilevariations('Shades Steel Gorgonslayer 1', 			'Shades Steel Gorgonslayer 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Graveripper')			.compilevariations('Shades Steel Graveripper 1', 			'Shades Steel Graveripper 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Guandao')				.compilevariations('Shades Steel Guandao 1', 				'Shades Steel Guandao 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Crownbreaker')			.compilevariations('Shades Steel Crownbreaker 1', 			'Shades Steel Crownbreaker 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hades Grasp')			.compilevariations('Shades Steel Hades Grasp 1', 			'Shades Steel Hades Grasp 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Haoma')					.compilevariations('Shades Steel Haoma 1', 					'Shades Steel Haoma 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Heavenspire')			.compilevariations('Shades Steel Heavenspire 1', 			'Shades Steel Heavenspire 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hellspire')				.compilevariations('Shades Steel Hellspire 1', 				'Shades Steel Hellspire 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Icarus Tears')			.compilevariations('Shades Steel Icarus Tears 1', 			'Shades Steel Icarus Tears 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ryu Katana')			.compilevariations('Shades Steel Ryu Katana 1', 			'Shades Steel Ryu Katana 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Lion Sword')			.compilevariations('Shades Steel Lion Sword 1', 			'Shades Steel Lion Sword 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oathblade')				.compilevariations('Shades Steel Oathblade 1', 				'Shades Steel Oathblade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oblivion')				.compilevariations('Shades Steel Oblivion 1', 				'Shades Steel Oblivion 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hitokiri Katana')		.compilevariations('Shades Steel Hitokiri Katana 1', 		'Shades Steel Hitokiri Katana 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Pridefall')				.compilevariations('Shades Steel Pridefall 1', 				'Shades Steel Pridefall 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Rakuyo')				.compilevariations('Shades Steel Rakuyo 1', 				'Shades Steel Rakuyo 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Blade')	.compilevariations('Shades Steel Realmdrifter Blade 1', 	'Shades Steel Realmdrifter Blade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Divider')	.compilevariations('Shades Steel Realmdrifter Divider 1', 	'Shades Steel Realmdrifter Divider 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kukri')					.compilevariations('Shades Steel Kukri 1', 					'Shades Steel Kukri 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sinner')				.compilevariations('Shades Steel Sinner 1', 				'Shades Steel Sinner 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sithis Blade')			.compilevariations('Shades Steel Sithis Blade 1', 			'Shades Steel Sithis Blade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Voidblade')				.compilevariations('Shades Steel Voidblade 1', 				'Shades Steel Voidblade 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Vulcan')				.compilevariations('Shades Steel Vulcan 1', 				'Shades Steel Vulcan 2'));
		parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Knife')					.compilevariations('Shades Steel Knife 1', 					'Shades Steel Knife 2'));
			
		SortPreviewData(parent.Shades_SteelSwords, PotP_A_Items);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_BanditCamps() 
	{
		var group: string = "PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard";
		
		parent.BanditCamps_WhiteOrchard.Clear();
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_camp'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire2')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire3')); 
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_road'));     
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandit_campfire'));  
		parent.BanditCamps_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_WO, PotP_I_Camps, PotP_E_Primary, 'bandits_sanctuary'));
		
		SortPreviewData(parent.BanditCamps_WhiteOrchard, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Skellige";
		
		parent.BanditCamps_Skellige.Clear();
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk10_mp_giantfoot_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk16_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk28_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk36_mp'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk111_mp_skellige'));
		parent.BanditCamps_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_SK, PotP_I_Camps, PotP_E_Primary, 'sk86_mp_skl'));
		
		SortPreviewData(parent.BanditCamps_Skellige, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint";
		
		parent.BanditCamps_Toussaint.Clear();
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_17_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_09_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_07_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_car_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_d_18_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_b_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_07_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_13_mp_ban'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_08_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_gor_a_09_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_ved_a_06_mp'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_bar_a_12_mp_b'));
		parent.BanditCamps_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_TO, PotP_I_Camps, PotP_E_Primary, 'poi_vin_b_06_mp'));
		
		SortPreviewData(parent.BanditCamps_Toussaint, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad";
		
		parent.BanditCamps_Novigrad.Clear();
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gf42'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'nml_mp_hs16'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi17_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'gf203_mp_nml'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi16_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi23_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi09_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi_ofir_camp_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi11_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi12_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi13_mp'));
		parent.BanditCamps_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_NO, PotP_I_Camps, PotP_E_Primary, 'ep1_poi14_mp'));
		
		SortPreviewData(parent.BanditCamps_Novigrad, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_BanditCamp_Velen";
		
		parent.BanditCamps_Velen.Clear();
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cb18'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_bm2'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de101'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de102'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_de25'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_gr31'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'pit_camp_nml_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'mp2_nml_mappin'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_cp37'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb23'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb30'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb20'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb12'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb5'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb7_camp_mp'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'sb5b_mp_nml_yet'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb7'));
		parent.BanditCamps_Velen.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_VE, PotP_I_Camps, PotP_E_Primary, 'nml_mp_sb18'));
		
		SortPreviewData(parent.BanditCamps_Velen, PotP_A_World);
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_MonsterDens()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterDens_Velen";
		
		parent.MonsterDens_Velen.Clear();
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gr38'));
		parent.MonsterDens_Velen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_VE, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de24'));
		
		SortPreviewData(parent.MonsterDens_Velen, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad";
		
		parent.MonsterDens_Novigrad.Clear();
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_gf2'));
		parent.MonsterDens_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_NO, PotP_I_MDens, PotP_E_Primary, 'nml_mp_de30'));
		
		SortPreviewData(parent.MonsterDens_Novigrad, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Skellige";
		
		parent.MonsterDens_Skellige.Clear();
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk12_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk25_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk60_mp'));
		parent.MonsterDens_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'sk86_mp'));
		
		SortPreviewData(parent.MonsterDens_Skellige, PotP_A_World);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint";
		
		parent.MonsterDens_Toussaint.Clear();
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_05_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_ved_a_04_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_dun_a_04_cave_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_gor_b_11_mp'));
		parent.MonsterDens_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_SK, PotP_I_MDens, PotP_E_Primary, 'poi_bar_b_14_mp'));
		
		SortPreviewData(parent.MonsterDens_Toussaint, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_MonsterNests()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard";
		
		parent.MonsterNests_WhiteOrchard.Clear();
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_hengestone_ghoulnest_pin'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_monster_nest_ghoul5'));
		parent.MonsterNests_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_WO, PotP_I_Nests, PotP_E_Primary, 'lw_ghouls_nest01'));
		
		SortPreviewData(parent.MonsterNests_WhiteOrchard, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Velen";
		
		parent.MonsterNests_Velen.Clear();
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr36_nekkers_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr16_pc_nest_rotfiend'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_gr28_harpynest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_mp4_rotfiend_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_hs1_ursten_nest_boss'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr18_monster_nest_ghoul_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'gr35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp34_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp35_ghouls_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'nml_cp5_nest_mp'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'de8_nekker_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_1'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_4'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'lw_de_poi_032_nest_2'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_01'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'mh105_wyvern_nest_02'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'cp21_drowner_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_20", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'bm7_drowners_nest'));
		parent.MonsterNests_Velen.PushBack(parent.CreateEntry().initWorld(group + "_21", PotP_R_VE, PotP_I_Nests, PotP_E_Primary, 'hs13_rotfiend_nest'));		
		
		SortPreviewData(parent.MonsterNests_Velen, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad";
		
		parent.MonsterNests_Novigrad.Clear();
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_34_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'lw_nest_ep1_poi_31_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi_19_mp'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi32_nest'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest01'));
		parent.MonsterNests_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_NO, PotP_I_Nests, PotP_E_Primary, 'ep1_poi37_nest02'));	
		
		SortPreviewData(parent.MonsterNests_Novigrad, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Skellige";
		
		parent.MonsterNests_Skellige.Clear();
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk15_drowner_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk14_nest_sirens'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk74_harpy_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'sk75_siren_nest'));
		parent.MonsterNests_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_SK, PotP_I_Nests, PotP_E_Primary, 'lw_sk_poi_107_nest'));
		
		SortPreviewData(parent.MonsterNests_Skellige, PotP_A_World);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint";
		
		parent.MonsterNests_Toussaint.Clear();
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_01'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'sq703_scolopendros_nest_02'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_gor_b_13_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_b_05_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_dun_a_04_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_san_a_03_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_car_b_09_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'lw_ww_poi_bel_8_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_b_07_mp'));
		parent.MonsterNests_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_TO, PotP_I_Nests, PotP_E_Primary, 'poi_bar_a_13_nest'));
		
		SortPreviewData(parent.MonsterNests_Toussaint, PotP_A_World);		
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_PlacesOfPower() 
	{
		var group: string = "PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard";
		
		parent.PlacesOfPower_WhiteOrchard.Clear();
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_ignii_prologue_01'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_axii_prologue_04'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_aard_prologue_02'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_quen_prologue_03'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'pop_quen2_prlg'));
		parent.PlacesOfPower_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_WO, PotP_I_Place, PotP_E_Primary, 'lw_yrden_prologue_05'));
		
		SortPreviewData(parent.PlacesOfPower_WhiteOrchard, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen";
		
		parent.PlacesOfPower_Velen.Clear();
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_ignii2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_aard'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'lw_ancient_castle_pop'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_quen2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'pop_yrden2_nml_mp'));
		parent.PlacesOfPower_Velen.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_VE, PotP_I_Place, PotP_E_Primary, 'nml_pop_yrden'));
		
		SortPreviewData(parent.PlacesOfPower_Velen, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad";
		
		parent.PlacesOfPower_Novigrad.Clear();
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_axii'));
		parent.PlacesOfPower_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_NO, PotP_I_Place, PotP_E_Primary, 'nml_pop_ignii'));
		
		SortPreviewData(parent.PlacesOfPower_Novigrad, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige";
		
		parent.PlacesOfPower_Skellige.Clear();
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_ignii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_mp_igniii_skellige'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_axii2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_axii'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'ard_skellig_pop_aard'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_SK, PotP_I_Place, PotP_E_Missable, 'skl_pop_quen2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_quen_skellige_mp'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'skl_pop_yrden2_new'));
		parent.PlacesOfPower_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_SK, PotP_I_Place, PotP_E_Primary, 	'pop_yrden_mp_skellige'));
		
		SortPreviewData(parent.PlacesOfPower_Skellige, PotP_A_World);		

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen";
		
		parent.PlacesOfPower_KaerMorhen.Clear();
		parent.PlacesOfPower_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_KM, PotP_I_Place, PotP_E_Primary, 'km_mp_pop_igniii'));
		
		SortPreviewData(parent.PlacesOfPower_KaerMorhen, PotP_A_World);	

		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint";
		
		parent.PlacesOfPower_Toussaint.Clear();
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_igni_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_axii_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_aard_0001'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_quen_0002'));
		parent.PlacesOfPower_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_TO, PotP_I_Place, PotP_E_Primary, 	'bob_place_of_power_yrden_0002'));
		
		SortPreviewData(parent.PlacesOfPower_Toussaint, PotP_A_World);	
		
		//------------------------------------------------------

		group = "PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral";
		
		parent.PlacesOfPower_TheSpiral.Clear();
		parent.PlacesOfPower_TheSpiral.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_TS, PotP_I_Place, PotP_E_Missable, 	'aard_gasforest'));
		
		SortPreviewData(parent.PlacesOfPower_TheSpiral, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	latent function Initialise_WorldMap_Signposts_1() 
	{
		var group: string = "PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen";
		
		parent.Signposts_KaerMorhen.Clear();
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_eye'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'morhen_mine_dam'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'kaer_morhen_entrance'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'lake_house'));
		parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_KM, PotP_I_Signs, PotP_E_Primary, 'km_outpost_ruins'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{ 
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'chort_cave'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'circle_of_elements'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_courtyard'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'kaer_morhen_valley'));
			parent.Signposts_KaerMorhen.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_KM, PotP_I_Signs, PotP_E_ModAdded, 'trials_cave'));
		}

		SortPreviewData(parent.Signposts_KaerMorhen, PotP_A_World);	
		
		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Novigrad";
		
		parent.Signposts_Novigrad.Clear();
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'demolished_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'retting_ponds'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_arnskrone_castle'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_marsh_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_wedding_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'smugglers_den'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_lighthouse_last_hope'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'rocky_pass'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'goose_cunt_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noonwraith_tower'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_dragon_valley_outpost'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_isle_round_square'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_forest_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'philippa_ruins'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'eternal_fire_chapel'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_road_to_olgiers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_20", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_southeast_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_21", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_south_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_22", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_grainfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_23", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ruin_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_24", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_herbalist'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_25", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'triss_house'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_26", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'noblemans_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_27", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hunters_hut'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_28", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'midget_forgers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_29", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_kilkerin'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_30", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'grassy_knoll_lighthouse'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_31", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dwarven_woodchucks'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_32", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'lucjans_windmill'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_33", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'plantation_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_34", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'vacant_estate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_35", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_piers'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_36", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_east'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_37", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_2'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_38", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_harbor'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_39", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_shouth_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_40", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyards'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_41", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'seven_cats_inn'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_42", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'novigrad_east_gate_1'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_43", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'temple_bridge_south'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_44", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'roches_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_45", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'nov_main_gate'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_46", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_ofir_camp'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_47", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ursten'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_48", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'dawn_estate_entrance'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_49", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_hilltop'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_50", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_von_everecs_mansion'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_51", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'oxenfurt_west'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_52", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'cropfields'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_53", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'widow_cave'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_54", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'gustfields_vinyard_farmstead'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_55", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'Slone_village'));
		parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_56", PotP_R_NO, PotP_I_Signs, PotP_E_Primary, 'ep1_zutzer_castle'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_88", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'barrengarth'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_89", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'crippled_kate'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_90", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'farcorners'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_91", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_gildorf'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_92", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_harborside'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_93", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'hattori_workshop'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_94", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bridge'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_95", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_academy'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_96", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'passiflora'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_97", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'bathhouse'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_98", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_silverton'));
			parent.Signposts_Novigrad.PushBack(parent.CreateEntry().initWorld(group + "_99", PotP_R_NO, PotP_I_Signs, PotP_E_ModAdded, 'novigrad_bits'));
		}
		
		SortPreviewData(parent.Signposts_Novigrad, PotP_A_World);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_Signposts_2()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_Signposts_Skellige";
		
		parent.Signposts_Skellige.Clear();
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'abandoned_lumber_mill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'elven_vault'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arinbjorn'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rocky_bay'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'blandare_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ravens_home_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'kaer_trolde_bridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_blacksmith'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'stolen_road'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'distillery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ice_giant_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'druid_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'northern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'southern_torch'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fayrlund'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'halgrims_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'herbarium'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fyresdal'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_20", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holy_oak'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_21", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'giants_foot'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_22", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'arsehole_cave'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_23", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_vantage_point'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_24", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_25", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'holmstein_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_26", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_arena_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_27", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'huindarsfjal_destroyed_farmstead'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_28", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'prison_island'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_29", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'fort_gelen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_30", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lugos_keep'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_31", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'craite_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_32", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'larvik'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_33", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofotten'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_34", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lofoten_cemetery'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_35", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'lurthen'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_36", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_shore_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_37", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'miners_camp'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_38", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_ruins'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_39", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ancient_perimeter'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_40", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'rannvaig'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_41", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'redgill'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_42", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ragnar_village'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_43", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_roast_kipper_tavern'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_44", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'sheperd_huts'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_45", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'spikeroog_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_46", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'q210_avallach_lab'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_47", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'the_ridge'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_48", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'faroe_harbor_2'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_49", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'an_skellig_harbor'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_50", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'undvik_village_3'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_51", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'whaleyard'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_52", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'wild_shores'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_53", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'ridgetop'));
		parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_54", PotP_R_SK, PotP_I_Signs, PotP_E_Primary, 'skellige_tomb_3'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_90", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'ard_hugtand'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_91", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'castle_tuirseach'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_92", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_dhu'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_93", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_nyssen'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_94", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'kaer_trolde_village'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_95", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'melusine_cave'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_96", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'snidhall_isle'));
			parent.Signposts_Skellige.PushBack(parent.CreateEntry().initWorld(group + "_97", PotP_R_SK, PotP_I_Signs, PotP_E_ModAdded, 'hemdall_shrine'));
		}
		
		SortPreviewData(parent.Signposts_Skellige, PotP_A_World);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard";
		
		parent.Signposts_WhiteOrchard.Clear();
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'well_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Broken_bridge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'bridge_gate'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Crossroads'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'River_crossing'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Windmill'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'Nilfgaard_camp'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'ransacked_village'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woodcutters_lodge'));
		parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_WO, PotP_I_Signs, PotP_E_Primary, 'woesong_bridge'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_WhiteOrchard.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_WO, PotP_I_Signs, PotP_E_ModAdded, 'king_desmond_bridge'));
		}
		
		SortPreviewData(parent.Signposts_WhiteOrchard, PotP_A_World);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_WorldMap_Signposts_3()
	{
		var group: string = "PotP_TrackingGroup_WorldMap_Signposts_Toussaint";
		
		parent.Signposts_Toussaint.Clear();
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ardaiso_quarry_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'swamps_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lake_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_palace_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'belgard_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'castel_ravello_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'casteldaccia_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'longhollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_north_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'coronata_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'corvo_bianco_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'watermill_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmill_west_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'northern_dun_tynne_crossing_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'dun_tynne_vineyards_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'flovive_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'abandoned_castle_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_20", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_21", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'fox_hollow_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_22", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'francollarts_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_23", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'gelenser_farmstead_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_24", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'harbour_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_25", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'ronneville_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_26", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'temple_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_27", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'old_cemetery_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_28", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'beauclair_east_gate_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_29", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'mont_crane_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_30", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'upper_city_harbor_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_31", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'palace_gardens_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_32", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'vermentino_vineyard_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_33", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'feet_of_lebioda_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_34", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'sawmill_village_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_35", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'lower_city_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_36", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'windmills_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_37", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'elven_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_38", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'termes_ruins_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_39", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tesham_mutna_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_40", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'cockatrice_inn_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_41", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'main_square_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_42", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'village_by_swamp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_43", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'tournament_meadows_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_44", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'prison_island_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_45", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'merchants_camp_ft'));
		parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_46", PotP_R_TO, PotP_I_Signs, PotP_E_Primary, 'trastamara_mansion_ft'));

		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_90", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'abandoned_storehouse'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_91", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'bastoy_prison_ruins'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_92", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'doren_alma_estate'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_93", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lac_celavy'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_94", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'lafargue_workshop'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_95", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'belles'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_96", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'vermentino_vineyard'));
			parent.Signposts_Toussaint.PushBack(parent.CreateEntry().initWorld(group + "_97", PotP_R_TO, PotP_I_Signs, PotP_E_ModAdded, 'villa_vedette'));
		}
		
		SortPreviewData(parent.Signposts_Toussaint, PotP_A_World);	

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_WorldMap_Signposts_Velen";
		
		parent.Signposts_Velen.Clear();
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_01", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cp_abandoned_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_02", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'incredibly_big_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_03", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_slaver_camp'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_04", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'benek_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_05", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'snots_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_06", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'boatmakers_hut'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_07", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'halver_isle'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_08", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'burned_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_09", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_brickmakers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_10", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'glinsk_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_11", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'shipwreck_shore'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_12", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'stray_kings_quarry'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_13", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'massacred_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_14", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'road_to_baldenfort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_15", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_yard'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_16", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'baldenfort_bastion'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_17", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'plague_pit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_18", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'downwarren'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_19", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'griffin_dungeon_exit'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_20", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mire_deserted_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_21", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'roadside_chapel'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_22", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bayors_ferry_station'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_23", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sb_forest_house'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_24", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mudwell'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_25", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'popiels_tower'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_26", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'Dungeon 5'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_27", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'nml_hangman_tree'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_28", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'hangmans_ave'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_29", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'wagon_top'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_30", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'heatherton_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_31", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fort_mar'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_32", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'fortfified_farmstead'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_33", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'crossroads_inn'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_34", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'seaside_shack'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_35", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'swamp_edge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_36", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'midcopse'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_37", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'reef_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_38", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'lanka_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_39", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'marauders_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_40", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'mouth_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_41", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'poppystone'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_42", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'novigrad_garrison'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_43", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'willows_grove'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_44", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'rudnik'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_45", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'descent_hunting_lodge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_46", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'doomsday_worshippers'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_47", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'bald_mountain'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_48", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'cb_swamp_ruins'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_49", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'freckle_hill'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_50", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'ladies_of_the_wood'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_51", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'toderas_village'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_52", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'old_bridge'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_53", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'haunted_estate'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_54", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'debris_fort'));
		parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_55", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'sacred_circle'));

		if (PotP_IsUsingNextGen()) 
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_56", PotP_R_VE, PotP_I_Signs, PotP_E_Primary, 'barons_castle'));
		}
		
		if (PotP_UsingDLCFastTravel()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/6850
		{
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_90", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'crookback_bog'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_92", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'honorton'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_93", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'mowshurst'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_94", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'oxenfurt_bridge'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_95", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'pellar_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_96", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'witch_hut'));
			parent.Signposts_Velen.PushBack(parent.CreateEntry().initWorld(group + "_97", PotP_R_VE, PotP_I_Signs, PotP_E_ModAdded, 'nilfgaardian_camp'));
		}
		
		SortPreviewData(parent.Signposts_Velen, PotP_A_World);	
	}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Monsters() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Monsters";
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,PotP_I_Monst, 'gwint_card_eredin_gold')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas')				.compilevariations('gwint_card_arachas2', 'gwint_card_arachas3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Monst, 'gwint_card_botchling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Monst, 'gwint_card_earth_elemental')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Monst, 'gwint_card_endrega')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fogling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations('gwint_card_ghoul2', 'gwint_card_ghoul3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_Monst, 'gwint_card_griffin')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, PotP_I_Monst, 'gwint_card_garkain')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, PotP_I_Monst, 'gwint_card_katakan')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, PotP_I_Monst, 'gwint_card_werewolf')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wyvern')					.compilevariations(''));
		
		SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent);		
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Monsters_Redux() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Monsters_Redux";
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,PotP_I_Monst, 'gwint_card_eredin_gold')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Monst, 'gwint_card_caranthir')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Monst, 'gwint_card_emiel')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Monst, 'gwint_card_striga')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Monst, 'gwint_card_avallach')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Monst, 'gwint_card_moon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul3')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Monst, 'gwint_card_cow')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Monst, 'gwint_card_dagon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Monst, 'gwint_card_dettlaff')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Monst, 'gwint_card_endrega')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Monst, 'gwint_card_earth_elemental')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fogling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_Monst, 'gwint_card_katakan')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, PotP_I_Monst, 'gwint_card_griffin')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, PotP_I_Monst, 'gwint_card_iris')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ghoul2')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_drakkar')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_41", PotP_E_Primary, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_42", PotP_E_Primary, PotP_I_Monst, 'gwint_card_nithral')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_43", PotP_E_Primary, PotP_I_Monst, 'gwint_card_mrmirror')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_44", PotP_E_Primary, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_45", PotP_E_Primary, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_46", PotP_E_Primary, PotP_I_Monst, 'gwint_card_savolla')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_47", PotP_E_Primary, PotP_I_Monst, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_48", PotP_E_Primary, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_49", PotP_E_Primary, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_50", PotP_E_Primary, PotP_I_Monst, 'gwint_card_alp')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_51", PotP_E_Primary, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_52", PotP_E_Primary, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_53", PotP_E_Primary, PotP_I_Monst, 'gwint_card_garkain')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_54", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas2')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_55", PotP_E_Primary, PotP_I_Monst, 'gwint_card_mrmirror_foglet')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_56", PotP_E_Primary, PotP_I_Monst, 'gwint_card_white')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_57", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_hound')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_58", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_navigator')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_59", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_rider')			.compilevariations('gwint_card_wildhunt_rider2', 'gwint_card_wildhunt_rider3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_60", PotP_E_Primary, PotP_I_Monst, 'gwint_card_wildhunt_warrior')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_61", PotP_E_Primary, PotP_I_Monst, 'gwint_card_arachas3')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_62", PotP_E_Primary, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(group + "_63", PotP_E_Primary, PotP_I_Monst, 'gwint_card_centipede')				.compilevariations(''));
		
		SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent);			
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Neutral() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NeutralCards";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_ciri')				.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_geralt')				.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_avallach')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_yennefer')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_horn')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_dummy')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_scorch')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_cow')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Missable,PotP_I_Neutr, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_emiel')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_mrmirror')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_mrmirror_foglet')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_vesemir')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_villen')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_zoltan')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_skellige_storm')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Neutral_Redux() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NeutralCards_Redux";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_azar_javed')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_geralt')			.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_ciri')			.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_dummy')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_horn')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_professor')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_vesemir')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Neutr, 'gwint_card_yennefer')		.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent);				
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Nilfgaard() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_silver')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_emhyr_gold')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_letho')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_menno')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_moorvran')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_tibor')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_albrich')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_assire')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer')		.compilevariations('gwint_card_black_archer2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cahir')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cynthia')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support')	.compilevariations('gwint_card_archer_support2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_fringilla')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_heavy_zerri')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade')	.compilevariations('gwint_card_impera_brigade2', 'gwint_card_impera_brigade3', 'gwint_card_impera_brigade4'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_morteisen')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa')			.compilevariations('gwint_card_nausicaa2', 'gwint_card_nausicaa3'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_puttkammer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rainfarn')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_renuald')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rotten')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_shilard')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_combat_engineer')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_siege_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_stefan')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_sweers')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vanhemar')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vattier')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vreemde')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary')	.compilevariations('gwint_card_young_emissary2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_zerri')				.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Nilfgaard_Redux() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_silver')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_emhyr_gold')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_moorvran')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_henrietta')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_letho')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade1')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_albrich')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_siege_support')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_artorius')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_assire')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade3')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cahir')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_renuald')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_catriona')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_cynthia')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa3')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa2')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Missable,PotP_I_Nilfg, 'gwint_card_fringilla')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_heavy_zerri')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_joachim')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade4')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_menno')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_milton')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_nausicaa')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_palmerin')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_morteisen')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_puttkammer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rainfarn')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_archer_support2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_rotten')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_impera_brigade2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_shilard')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_combat_engineer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_stefan')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_41", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_sweers')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_42", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_syanna')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_43", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_tibor')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_44", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vanhemar')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_45", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vattier')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_46", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vicovaro')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_47", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_black_archer2')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_48", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vivienne')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_49", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_vreemde')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_50", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_young_emissary')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(group + "_51", PotP_E_Primary, PotP_I_Nilfg, 'gwint_card_zerri')					.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_NorthernRealms() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NorthernRealms";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,PotP_I_North, 'gwint_card_foltest_gold')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Missable,PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_North, 'gwint_card_philippa')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_North, 'gwint_card_catapult')				.compilevariations('gwint_card_catapult2'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_North, 'gwint_card_crinfrid')				.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_North, 'gwint_card_dijkstra')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_NorthernRealms_Redux() 
	{
		var group: string = "PotP_TrackingGroup_GwentCards_NorthernRealms_Redux";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, 	PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,	PotP_I_North, 'gwint_card_foltest_gold')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, 	PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Missable,	PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, 	PotP_I_North, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, 	PotP_I_North, 'gwint_card_philippa')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, 	PotP_I_North, 'gwint_card_anseis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, 	PotP_I_North, 'gwint_card_beggar')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, 	PotP_I_North, 'gwint_card_bloody_baron')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, 	PotP_I_North, 'gwint_card_blue_stripes1')		.compilevariations('gwint_card_blue_stripes2', 'gwint_card_blue_stripes3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, 	PotP_I_North, 'gwint_card_boris')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, 	PotP_I_North, 'gwint_card_botchling')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, 	PotP_I_North, 'gwint_card_catapult2')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, 	PotP_I_North, 'gwint_card_carlo')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, 	PotP_I_North, 'gwint_card_catapult')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, 	PotP_I_North, 'gwint_card_cleric_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, 	PotP_I_North, 'gwint_card_crinfrid')			.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, 	PotP_I_North, 'gwint_card_crownsplitter')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, 	PotP_I_North, 'gwint_card_cutup')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Missable,	PotP_I_North, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, 	PotP_I_North, 'gwint_card_dijkstra')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, 	PotP_I_North, 'gwint_card_igor')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, 	PotP_I_North, 'gwint_card_jacques')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, 	PotP_I_North, 'gwint_card_francis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, 	PotP_I_North, 'gwint_card_knight_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, 	PotP_I_North, 'gwint_card_lebioda')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary, 	PotP_I_North, 'gwint_card_hailstorm')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary, 	PotP_I_North, 'gwint_card_nathaniel')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, 	PotP_I_North, 'gwint_card_peach')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_41", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_42", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_43", PotP_E_Primary, 	PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_44", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_45", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_46", PotP_E_Primary, 	PotP_I_North, 'gwint_card_wyvern')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_47", PotP_E_Primary, 	PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_48", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_49", PotP_E_Primary, 	PotP_I_North, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_50", PotP_E_Primary, 	PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_51", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_52", PotP_E_Primary, 	PotP_I_North, 'gwint_card_vincent')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_53", PotP_E_Primary, 	PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_54", PotP_E_Primary, 	PotP_I_North, 'gwint_card_whoreson')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_55", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_56", PotP_E_Primary, 	PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(group + "_57", PotP_E_Primary, 	PotP_I_North, 'gwint_card_zoltan')				.compilevariations(''));
		
		SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Scoiatael()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Scoiatael";
		
		parent.Gwent_Scoiatael.Clear();
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, 	PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations('gwint_card_dol_infantry2', 'gwint_card_dol_infantry3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations('gwint_card_elf_skirmisher2', 'gwint_card_elf_skirmisher3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations('gwint_card_havekar_nurse2', 'gwint_card_havekar_nurse3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations('gwint_card_havekar_support2', 'gwint_card_havekar_support3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations('gwint_card_mahakam2', 'gwint_card_mahakam3', 'gwint_card_mahakam4', 'gwint_card_mahakam5'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations('gwint_card_vrihedd_brigade2'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Scoiatael_Redux()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Scoiatael_Redux";
		
		parent.Gwent_Scoiatael.Clear();	
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, 	PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Missable,	PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Missable, 	PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_morenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_aglais')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_braenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam5')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_grovekeeper')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam3')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam4')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_fauve')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_scorch')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_dol_infantry3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Missable, 	PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary,	PotP_I_Scoia, 'gwint_card_havekar_support3')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_nature')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_mahakam2')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_41", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_42", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_43", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_44", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_treant_boar')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_45", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_treant_mantis')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_46", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_havekar_support2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_47", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_villen')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_48", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_49", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_50", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_water')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(group + "_51", PotP_E_Primary, 	PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent);	
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Skellige()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Skellige";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_bronze')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Primary, PotP_I_Skell, 'gwint_card_cerys')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Skell, 'gwint_card_ermion')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Skell, 'gwint_card_draig')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Skell, 'gwint_card_cock')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Skell, 'gwint_card_olaf')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		
		SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent);
	}

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------

	latent function Initialise_GwentCards_Skellige_Redux()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Skellige_Redux";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_01", PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_bronze')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_02", PotP_E_Primary, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_03", PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_silver')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_04", PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_gold')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_05", PotP_E_Primary, PotP_I_Skell, 'gwint_card_king_bran_platinium')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_06", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_07", PotP_E_Primary, PotP_I_Skell, 'gwint_card_cock')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_08", PotP_E_Primary, PotP_I_Skell, 'gwint_card_tyr')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_09", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_an_craite_marauder')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_10", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_11", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_an_craite_whaler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_12", PotP_E_Primary, PotP_I_Skell, 'gwint_card_artis')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_13", PotP_E_Primary, PotP_I_Skell, 'gwint_card_athak')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_14", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_15", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_16", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_17", PotP_E_Primary, PotP_I_Skell, 'gwint_card_boatbuilders')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_18", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_19", PotP_E_Primary, PotP_I_Skell, 'gwint_card_dreams')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_20", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_captain')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_21", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_22", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_dimun_smuggler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_23", PotP_E_Primary, PotP_I_Skell, 'gwint_card_djenge_frett')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_24", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_25", PotP_E_Primary, PotP_I_Skell, 'gwint_card_draig')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_26", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_27", PotP_E_Primary, PotP_I_Skell, 'gwint_card_ermion')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_28", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_29", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_30", PotP_E_Primary, PotP_I_Skell, 'gwint_card_cerys')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_31", PotP_E_Primary, PotP_I_Skell, 'gwint_card_jutta')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_32", PotP_E_Primary, PotP_I_Skell, 'gwint_card_knut')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_33", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_34", PotP_E_Primary, PotP_I_Skell, 'gwint_card_coral')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_35", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_36", PotP_E_Primary, PotP_I_Skell, 'gwint_card_werewolf')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_37", PotP_E_Primary, PotP_I_Skell, 'gwint_card_olaf')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_38", PotP_E_Primary, PotP_I_Skell, 'gwint_card_freya')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_39", PotP_E_Primary, PotP_I_Skell, 'gwint_card_ragh_nar_roog')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_40", PotP_E_Primary, PotP_I_Skell, 'gwint_card_skellige_storm')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_41", PotP_E_Primary, PotP_I_Skell, 'gwint_card_skjall')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_42", PotP_E_Primary, PotP_I_Skell, 'gwint_card_sukrus')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_43", PotP_E_Primary, PotP_I_Skell, 'gwint_card_svalblod')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_44", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_45", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_46", PotP_E_Primary, PotP_I_Skell, 'gwint_card_clan_tuirseach_skirmisher')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_47", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_48", PotP_E_Primary, PotP_I_Skell, 'gwint_card_vabjorn')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_49", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_50", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_51", PotP_E_Primary, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(group + "_52", PotP_E_Primary, PotP_I_Skell, 'gwint_card_yoana')						.compilevariations(''));
		
		SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent);
	}
}