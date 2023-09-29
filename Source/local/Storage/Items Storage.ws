//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
statemachine class CProgressOnThePath_ItemsStorage
{		
	var master 						:CProgressOnThePath;
	
	var MasterList_Items			:array<PotP_PreviewEntry>;
	
	var Relic_Trophies				: array<PotP_PreviewEntry>;
	var Relic_Crossbows				: array<PotP_PreviewEntry>;
	var Relic_SteelSwords			: array<PotP_PreviewEntry>;
	var Relic_SilverSwords			: array<PotP_PreviewEntry>;	
	
	var Armor_DolBlathanna			: array<PotP_PreviewEntry>;	
	var Armor_ForgottenWolven		: array<PotP_PreviewEntry>;	
	var Armor_HenGaidth				: array<PotP_PreviewEntry>;	
	var Armor_NewMoon				: array<PotP_PreviewEntry>;	
	var Armor_Nilfgaardian			: array<PotP_PreviewEntry>;	
	var Armor_Ofieri				: array<PotP_PreviewEntry>;	
	var Armor_Temerian				: array<PotP_PreviewEntry>;	
	var Armor_TeshamMutna			: array<PotP_PreviewEntry>;	
	var Armor_Undvik				: array<PotP_PreviewEntry>;	
	var Armor_WhiteTiger			: array<PotP_PreviewEntry>;	
	
	var DLC_CosWiecej				: array<PotP_PreviewEntry>;	
	var DLC_Dimeritium				: array<PotP_PreviewEntry>;	
	var DLC_Gothic					: array<PotP_PreviewEntry>;	
	var DLC_Meteorite				: array<PotP_PreviewEntry>;	
	var DLC_SezonBurz				: array<PotP_PreviewEntry>;	
	
	var Shades_Assassin				: array<PotP_PreviewEntry>;	
	var Shades_Berserker			: array<PotP_PreviewEntry>;	
	var Shades_Bismarck				: array<PotP_PreviewEntry>;	
	var Shades_BloodHunter			: array<PotP_PreviewEntry>;	
	var Shades_CrowFeathered		: array<PotP_PreviewEntry>;	
	var Shades_FallenKnight			: array<PotP_PreviewEntry>;	
	var Shades_Faraam				: array<PotP_PreviewEntry>;	
	var Shades_Headtaker			: array<PotP_PreviewEntry>;	
	var Shades_Hitokiri				: array<PotP_PreviewEntry>;	
	var Shades_Kara					: array<PotP_PreviewEntry>;	
	var Shades_LionHunter			: array<PotP_PreviewEntry>;	
	var Shades_OldHunter			: array<PotP_PreviewEntry>;	
	var Shades_Revenant				: array<PotP_PreviewEntry>;	
	var Shades_SilverSwords			: array<PotP_PreviewEntry>;	
	var Shades_Sithis				: array<PotP_PreviewEntry>;	
	var Shades_Stalker				: array<PotP_PreviewEntry>;	
	var Shades_SteelSwords			: array<PotP_PreviewEntry>;	
	var Shades_Taifeng				: array<PotP_PreviewEntry>;	
	var Shades_Unseen				: array<PotP_PreviewEntry>;

	var Gwent_MonstersDeck			: array<PotP_PreviewEntry>;
	var Gwent_NeutralDeck			: array<PotP_PreviewEntry>;
	var Gwent_NilfgaardDeck			: array<PotP_PreviewEntry>;
	var Gwent_NorthernRealms		: array<PotP_PreviewEntry>;
	var Gwent_Scoiatael				: array<PotP_PreviewEntry>;
	var Gwent_Skellige				: array<PotP_PreviewEntry>;	

	var SupportedItemsList			: array<name>;
	var SupportedItemsList_Entity	: array<PotP_PreviewEntry>;
	
	var UUIDINT: int;
	default UUIDINT = 1000;
	
	var fileName: name;
	default fileName = 'PotP Items Storage';

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
		return "IX" + IntToString(UUIDINT);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------
	
state Idle in CProgressOnThePath_ItemsStorage 
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
	
state Build in CProgressOnThePath_ItemsStorage 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Build]", , parent.fileName);
		
		this.Build();
	}	
	
	//-----------------------------------------------
	
	entry function Build()
	{
		var Idx, Edx : int;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		parent.MasterList_Items.Clear();
		
		this.BuildVanilla();	
		this.BuildModAdded();
		
		if (PotP_UsingGwentRedux()) {
			this.BuildGwentReduxCards();
		}
		else {
			this.BuildGwentCards();
		}		

		for ( Idx = 0; Idx < parent.MasterList_Items.Size(); Idx += 1 ) 
		{
			Edx = master.PotP_PersistentStorage.pArrayStorage.TotalVarList.FindFirst(parent.MasterList_Items[Idx].uuid);
			
			if (Edx != -1)
			{
				master.PotP_PersistentStorage.pArrayStorage.TotalEntList[Edx] = parent.MasterList_Items[Idx];
				master.PotP_PersistentStorage.pArrayStorage.TotalVarList[Edx] = parent.MasterList_Items[Idx].uuid;
				master.PotP_PersistentStorage.pArrayStorage.TotalIdeList[Edx] = parent.MasterList_Items[Idx].identifier;
				continue;
			}

			master.PotP_PersistentStorage.pArrayStorage.TotalEntList.PushBack(parent.MasterList_Items[Idx]);
			master.PotP_PersistentStorage.pArrayStorage.TotalVarList.PushBack(parent.MasterList_Items[Idx].uuid);
			master.PotP_PersistentStorage.pArrayStorage.TotalIdeList.PushBack(parent.MasterList_Items[Idx].identifier);			
		}
		
		parent.GotoState('Idle');
	}
	
	//-----------------------------------------------
	
	latent function BuildVanilla()
	{	
		var group	: string;
		var master: CProgressOnThePath;
		GetPotP(master);
		
		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_Relics_SteelSwords_W3EE";
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth_crafted')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna_crafted')	.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune_crafted')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword_crafted')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'PC Caretaker Shovel')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara_crafted')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum_crafted')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')							.compilevariations(''));
		
			PotP_SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items, master);

			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_SilverSwords_W3EE";
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe_crafted')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator_crafted')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned_crafted')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Adversary Silver Sword')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper_crafted')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment_crafted')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')						.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items, master);

			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_Crossbows_W3EE";
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.Relic_Crossbows, PotP_A_Items, master);
		}
		else
		{		
			group = "PotP_TrackingGroup_Relics_SteelSwords";
			parent.Relic_SteelSwords.Clear();
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Angivare')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Arbitrator')						.compilevariations('Arbitrator_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ardaenye')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ashrune')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Barbersurgeon')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Beannshie')						.compilevariations('Beannshie_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Blackunicorn')						.compilevariations('Blackunicorn_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'sq304 Novigraadan sword 4')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwent steel sword 1')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Bloedeaedd')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caerme')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Karabela')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Caroline')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cleaver')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dyaebl')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Dancer')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Daystar')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Deireadh')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Devine')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 2')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Serpent Steel Sword 1')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Forgottenvransword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gloryofthenorth')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwestog')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gwyhyr')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Harvall')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Headtaker')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q704 vampire steel sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hjalmar_Short_Steel_Sword')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Vynbleidd')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Inis')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Olgierd Sabre')					.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Longclaw')							.compilevariations('Longclaw_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Lune')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Mourner')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ofir Sabre 1')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Ofir Steel Sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Crafted Burning Rose Sword')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Iron Poker')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Princessxenthiasword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Squire steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Robustswordofdolblathanna')		.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q702 vampire steel sword')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Cheesecutter')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Gnomish sword 2')					.compilevariations('Gnomish sword 2_crafted'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Torlara')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl2 steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Guard lvl1 steel sword 3')			.compilevariations('Guard lvl1 steel sword 3 Autogen'));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Knights steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Toussaint steel sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Ultimatum')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_53", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Hanza steel sword 3')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_54", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Unique steel sword')				.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_55", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Abarad')							.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_56", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'q402 Skellige sword 3')			.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_57", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Wolf')								.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_58", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Steel Vixen')						.compilevariations(''));
			parent.Relic_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_59", PotP_E_Primary, PotP_I_Relic, PotP_U_Steel, 'Top Notch Steel')					.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SteelSwords, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_Relics_SilverSwords";
			parent.Relic_SilverSwords.Clear();
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Addandeith')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight EP2')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 3R')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anathema')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Anth')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Arainne')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Azurewrath')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bladeofys')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'WitcherSilverWolf')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Bloodsword')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Breathofthenorth')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q704 vampire silver sword')			.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 2')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP2 Silver sword 1R')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deargdeith')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Deithwen')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Fate')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 1')				.compilevariations('Serpent Silver Sword 1 Autogen'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Unique silver sword')					.compilevariations('Serpent Silver Sword 3'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvael')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Gynvaelaedd')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Harpy')								.compilevariations('Harpy_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Havcaaren')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Loathen')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Aerondight')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Moonblade')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Naevdeseidhe')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Negotiator')							.compilevariations('Negotiator_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'DLC10_Remorse')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Reachofthedamned')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Roseofaelirenn')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'EP1 Crafted Witcher Silver Sword')	.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Serpent Silver Sword 2')				.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Virgin')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Tlareg')								.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Torzirael')							.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'mq4005 Silver sword 6_crafted')		.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Weeper')								.compilevariations('Weeper_crafted'));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Zerrikanterment')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'q505 crafted sword')					.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Silver Vixen')						.compilevariations(''));
			parent.Relic_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Relic, PotP_U_Silve, 'Top Notch Silver')					.compilevariations(''));

			PotP_SortPreviewData(parent.Relic_SilverSwords, PotP_A_Items, master);	

			//------------------------------------------------------
		
			group = "PotP_TrackingGroup_Relics_Crossbows";
			parent.Relic_Crossbows.Clear();
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow 7')			.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Crossbow q206')		.compilevariations(''));
			parent.Relic_Crossbows.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Relic, PotP_U_Cross, 'Ofir Crossbow R')	.compilevariations(''));
		
			PotP_SortPreviewData(parent.Relic_Crossbows, PotP_A_Items, master);
		}

		group = "PotP_TrackingGroup_Trophies";
		
		parent.Relic_Trophies.Clear();
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh102_arachas_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'sq108_griffin_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh201_cave_troll_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh107_czart_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh101_cockatrice_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q603_sharley_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh305_doppler_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh306_dao_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh210_lamia_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh104_ekimma_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh206_fiend_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh108_fogling_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh208_forktail_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q704_garkain_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q701_cyclops_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh106_gravehag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh301_gryphon_trophy')			.compilevariations('q002_griffin_trophy', 'mq7009_griffin_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7002_spriggan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh304_katakan_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q602_pig_contest_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh204_leshy_trophy')				.compilevariations('mh302_leshy_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh202_nekker_warrior_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh103_nightwraith_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq0003_noonwraith_trophy')		.compilevariations('mh308_noonwraith_trophy'));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh701_sharley_matriarch_trophy')	.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7018_basilisk_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7010_dracolizard_trophy')		.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh303_succubus_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'camm_trophy')						.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mq7017_zmora_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh203_water_hag_trophy')			.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'q702_wicht_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh307_minion_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh207_wraith_trophy')				.compilevariations(''));
		parent.Relic_Trophies.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Troph, PotP_U_Troph, 'mh105_wyvern_trophy')				.compilevariations('mq1051_wyvern_trophy'));
		
		PotP_SortPreviewData(parent.Relic_Trophies, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_ForgottenWolven";
		parent.Armor_ForgottenWolven.Clear();
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Netflix Armor')		.compilevariations('Netflix Armor 1', 			'Netflix Armor 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Netflix Boots')		.compilevariations('Netflix Boots 1', 			'Netflix Boots 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Netflix Gloves')		.compilevariations('Netflix Gloves 1', 			'Netflix Gloves 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Netflix Pants')		.compilevariations('Netflix Pants 1', 			'Netflix Pants 2'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Netflix steel sword')	.compilevariations('Netflix steel sword 1', 	'Netflix steel sword 2',  'Reinald Netflix steel sword'));
		parent.Armor_ForgottenWolven.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'Netflix silver sword')	.compilevariations('Netflix silver sword 1', 	'Netflix silver sword 2', 'Reinald Netflix silver sword'));
		
		PotP_SortPreviewData(parent.Armor_ForgottenWolven, PotP_A_Items, master);

		//------------------------------------------------------
	
		group = "PotP_TrackingGroup_GearSets_DolBlathanna";
		parent.Armor_DolBlathanna.Clear();
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Dol Blathanna Armor')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Dol Blathanna Boots')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Dol Blathanna Gloves')		 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Dol Blathanna Pants')			 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Dol Blathanna longsword')		 .compilevariations(''));
		parent.Armor_DolBlathanna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'White Widow of Dol Blathanna') .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_DolBlathanna, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_WhiteTiger";
		parent.Armor_WhiteTiger.Clear();
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'White Tiger Armor')	 .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'White Tiger Boots')	 .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'White Tiger Gloves') .compilevariations(''));
		parent.Armor_WhiteTiger.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'White Tiger Pants')	 .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_WhiteTiger, PotP_A_Items, master);			

		//------------------------------------------------------

		group = "PotP_TrackingGroup_GearSets_HenGaidth";
		parent.Armor_HenGaidth.Clear();
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q704_vampire_armor')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q704_vampire_boots')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q704_vampire_gloves') .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q704_vampire_mask')	 .compilevariations(''));
		parent.Armor_HenGaidth.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q704_vampire_pants')	 .compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_HenGaidth, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_NewMoon";
		parent.Armor_NewMoon.Clear();
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Thief Armor')	.compilevariations('Thief Armor No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Thief Boots')	.compilevariations('Thief Boots No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Thief Gloves') .compilevariations('Thief Gloves No Medallion'));
		parent.Armor_NewMoon.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Thief Pants')	.compilevariations('Thief Pants No Medallion'));
		
		PotP_SortPreviewData(parent.Armor_NewMoon, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Nilfgaardian";
		parent.Armor_Nilfgaardian.Clear();
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC5 Nilfgaardian Armor')	 .compilevariations('NGP DLC5 Nilfgaardian Armor'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC5 Nilfgaardian Boots')	 .compilevariations('NGP DLC5 Nilfgaardian Boots'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC5 Nilfgaardian Gloves') .compilevariations('NGP DLC5 Nilfgaardian Gloves'));
		parent.Armor_Nilfgaardian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC5 Nilfgaardian Pants')	 .compilevariations('NGP DLC5 Nilfgaardian Pants'));
		
		PotP_SortPreviewData(parent.Armor_Nilfgaardian, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Ofieri";
		parent.Armor_Ofieri.Clear();
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Crafted Ofir Armor') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Crafted Ofir Boots') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Crafted Ofir Gloves') 	.compilevariations(''));
		parent.Armor_Ofieri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Crafted Ofir Pants') 	.compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_Ofieri, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Temerian";
		parent.Armor_Temerian.Clear();
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC1 Temerian Armor')	 .compilevariations('NGP DLC1 Temerian Armor'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC1 Temerian Boots')	 .compilevariations('NGP DLC1 Temerian Boots'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC1 Temerian Gloves') .compilevariations('NGP DLC1 Temerian Gloves'));
		parent.Armor_Temerian.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC1 Temerian Pants')	 .compilevariations('NGP DLC1 Temerian Pants'));
		
		PotP_SortPreviewData(parent.Armor_Temerian, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_TeshamMutna";
		parent.Armor_TeshamMutna.Clear();
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q702_vampire_armor')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q702_vampire_boots')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q702_vampire_gloves')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head,  'q702_vampire_mask')	.compilevariations(''));
		parent.Armor_TeshamMutna.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q702_vampire_pants')	.compilevariations(''));
		
		PotP_SortPreviewData(parent.Armor_TeshamMutna, PotP_A_Items, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GearSets_Undvik";
		parent.Armor_Undvik.Clear();
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC14 Skellige Armor')		.compilevariations('NGP DLC14 Skellige Armor'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC14 Skellige Boots')		.compilevariations('NGP DLC14 Skellige Boots'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC14 Skellige Gloves')		.compilevariations('NGP DLC14 Skellige Gloves'));
		parent.Armor_Undvik.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC14 Skellige Pants')		.compilevariations('NGP DLC14 Skellige Pants'));
		
		PotP_SortPreviewData(parent.Armor_Undvik, PotP_A_Items, master);
	}

	latent function BuildModAdded()
	{
		var group	: string;
		var master : CProgressOnThePath;
		GetPotP(master);	
		
		if (PotP_UsingSezonBurz()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/2818
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_SezonBurz";
			parent.DLC_SezonBurz.Clear();
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Armor, 'Sezon Burz Armor')			.compilevariations('Sezon Burz Armor NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Pants, 'Sezon Burz Pants')			.compilevariations('Sezon Burz Pants NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Glove, 'Sezon Burz Gloves')			.compilevariations('Sezon Burz Gloves NGP', 'Sezon Burz Fingerless Gloves', 'Sezon Burz Fingerless Gloves NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Boots, 'Sezon Burz Boots')			.compilevariations('Sezon Burz Boots NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Silve, 'Sezon Burz Silver Sword')		.compilevariations('Sezon Burz Silver Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Steel, 'Sezon Burz Steel Sword')		.compilevariations('Sezon Burz Steel Sword NGP'));
			parent.DLC_SezonBurz.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Cross, 'Sezon Burz Crossbow 1')		.compilevariations('Sezon Burz Crossbow 2', 'Sezon Burz Crossbow 3'));
			
			PotP_SortPreviewData(parent.DLC_SezonBurz, PotP_A_Items, master);
		}

		//------------------------------------------------------

		if (PotP_UsingCosWiecej()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5986
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_CosWiecej";
			parent.DLC_CosWiecej.Clear();
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Armor, 'wiecej')				.compilevariations('wiecej ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Glove, 'wiecej gloves')		.compilevariations('wiecej gloves ngp', 'wiecej gloves 2', 'wiecej gloves 2 ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Pants, 'wiecej pants')		.compilevariations('wiecej pants ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Boots, 'wiecej boots')		.compilevariations('wiecej boots ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'wiecej steel')		.compilevariations('wiecej steel ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Silve, 'wiecej silver')		.compilevariations('wiecej silver ngp'));
			parent.DLC_CosWiecej.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'rune sihil')			.compilevariations('rune sihil ngp', 'rune sihil 2', 'rune sihil 2 ngp'));
			
			PotP_SortPreviewData(parent.DLC_CosWiecej, PotP_A_Items, master);
		}

		//------------------------------------------------------

		if (PotP_UsingW3EE()) //Nexus ID: https://www.nexusmods.com/witcher3/mods/5802
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic";
			parent.DLC_Gothic.Clear();
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v1_1')			.compilevariations('kotw_armor_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v1_1')			.compilevariations('kotw_gloves_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v1_1')				.compilevariations('kotw_legs_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v1_1')			.compilevariations('kotw_boots_v1_2'));
			parent.DLC_Gothic.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v1_1_usable')		.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Gothic, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite";
			parent.DLC_Meteorite.Clear();
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v2_1')			.compilevariations('kotw_armor_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v2_1')		.compilevariations('kotw_gloves_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v2_1')			.compilevariations('kotw_legs_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v2_1')			.compilevariations('kotw_boots_v2_2'));
			parent.DLC_Meteorite.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v2_1_usable')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Meteorite, PotP_A_Items, master);
			
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium";
			parent.DLC_Dimeritium.Clear();
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v3_1')		.compilevariations('kotw_armor_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v3_1')		.compilevariations('kotw_gloves_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v3_1')			.compilevariations('kotw_legs_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v3_1')		.compilevariations('kotw_boots_v3_2'));
			parent.DLC_Dimeritium.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head,  'kotw_helm_v3_1_usable')	.compilevariations(''));
			
			PotP_SortPreviewData(parent.DLC_Dimeritium, PotP_A_Items, master);
		}

		if (PotP_UsingShadesOfIron()) //Github ID: https://github.com/Amasiuncula/Shades-of-Iron
		{ 
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker";
			parent.Shades_Berserker.Clear();
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Berserker Armor')	.compilevariations('Shades Berserker Armor 1', 	'Shades Berserker Armor 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Berserker Boots')	.compilevariations('Shades Berserker Boots 1', 	'Shades Berserker Boots 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Berserker Gloves')	.compilevariations('Shades Berserker Gloves 1', 'Shades Berserker Gloves 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Berserker Pants')	.compilevariations('Shades Berserker Pants 1', 	'Shades Berserker Pants 2'));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Cage')	.compilevariations(''));
			parent.Shades_Berserker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Berserker Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Berserker, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck";
			parent.Shades_Bismarck.Clear();
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Bismarck Armor')		.compilevariations('Shades Bismarck Armor 1', 	'Shades Bismarck Armor 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Bismarck Boots')		.compilevariations('Shades Bismarck Boots 1', 	'Shades Bismarck Boots 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Bismarck Gloves')	.compilevariations('Shades Bismarck Gloves 1', 	'Shades Bismarck Gloves 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Bismarck Pants')		.compilevariations('Shades Bismarck Pants 1', 	'Shades Bismarck Pants 2'));
			parent.Shades_Bismarck.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Bismarck Helm')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Bismarck, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter";
			parent.Shades_BloodHunter.Clear();
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Hunter Armor')	.compilevariations('Shades Hunter Armor 1', 	'Shades Hunter Armor 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Hunter Boots')	.compilevariations('Shades Hunter Boots 1', 	'Shades Hunter Boots 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Hunter Gloves')	.compilevariations('Shades Hunter Gloves 1', 	'Shades Hunter Gloves 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Hunter Pants')	.compilevariations('Shades Hunter Pants 1', 	'Shades Hunter Pants 2'));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Hat')		.compilevariations(''));
			parent.Shades_BloodHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hunter Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_BloodHunter, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow";
			parent.Shades_CrowFeathered.Clear();
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Crow Armor')	.compilevariations('Shades Crow Armor 1', 	'Shades Crow Armor 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Crow Boots')	.compilevariations('Shades Crow Boots 1', 	'Shades Crow Boots 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Crow Gloves')	.compilevariations('Shades Crow Gloves 1', 	'Shades Crow Gloves 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Crow Pants')	.compilevariations('Shades Crow Pants 1', 	'Shades Crow Pants 2'));
			parent.Shades_CrowFeathered.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Crow Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_CrowFeathered, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight";
			parent.Shades_FallenKnight.Clear();
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Fallen Armor')	.compilevariations('Shades Fallen Armor 1', 	'Shades Fallen Armor 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Fallen Boots')	.compilevariations('Shades Fallen Boots 1', 	'Shades Fallen Boots 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Fallen Gloves')	.compilevariations('Shades Fallen Gloves 1', 	'Shades Fallen Gloves 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Fallen Pants')	.compilevariations('Shades Fallen Pants 1', 	'Shades Fallen Pants 2'));
			parent.Shades_FallenKnight.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Fallen Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_FallenKnight, PotP_A_Items, master);			
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam";
			parent.Shades_Faraam.Clear();
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Faraam Armor')		.compilevariations('Shades Faraam Armor 1', 	'Shades Faraam Armor 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Faraam Boots')		.compilevariations('Shades Faraam Boots 1', 	'Shades Faraam Boots 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Faraam Gloves')	.compilevariations('Shades Faraam Gloves 1', 	'Shades Faraam Gloves 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Faraam Pants')		.compilevariations('Shades Faraam Pants 1', 	'Shades Faraam Pants 2'));
			parent.Shades_Faraam.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Faraam Helm')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Faraam, PotP_A_Items, master);				
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker";
			parent.Shades_Headtaker.Clear();
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Headtaker Armor')		.compilevariations('Shades Headtaker Armor 1', 	'Shades Headtaker Armor 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Headtaker Boots')		.compilevariations('Shades Headtaker Boots 1', 	'Shades Headtaker Boots 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Headtaker Gloves')		.compilevariations('Shades Headtaker Gloves 1', 'Shades Headtaker Gloves 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Headtaker Pants')		.compilevariations('Shades Headtaker Pants 1', 	'Shades Headtaker Pants 2'));
			parent.Shades_Headtaker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Headtaker Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Headtaker, PotP_A_Items, master);
			
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri";
			parent.Shades_Hitokiri.Clear();
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Viper Armor')		.compilevariations('Shades Viper Armor 1', 	'Shades Viper Armor 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Viper Boots')		.compilevariations('Shades Viper Boots 1', 	'Shades Viper Boots 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Viper Gloves')		.compilevariations('Shades Viper Gloves 1', 'Shades Viper Gloves 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Viper Pants')		.compilevariations('Shades Viper Pants 1', 	'Shades Viper Pants 2'));
			parent.Shades_Hitokiri.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Hitokiri Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Hitokiri, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara";
			parent.Shades_Kara.Clear();
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Kara Armor')		.compilevariations('Shades Kara Armor 1', 	'Shades Kara Armor 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Kara Boots')		.compilevariations('Shades Kara Boots 1', 	'Shades Kara Boots 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Kara Gloves')	.compilevariations('Shades Kara Gloves 1', 	'Shades Kara Gloves 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Kara Pants')		.compilevariations('Shades Kara Pants 1', 	'Shades Kara Pants 2'));
			parent.Shades_Kara.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Kara Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Kara, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter";
			parent.Shades_LionHunter.Clear();
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Lionhunter Armor')		.compilevariations('Shades Lionhunter Armor 1', 	'Shades Lionhunter Armor 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Lionhunter Boots')		.compilevariations('Shades Lionhunter Boots 1', 	'Shades Lionhunter Boots 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Lionhunter Gloves')	.compilevariations('Shades Lionhunter Gloves 1', 	'Shades Lionhunter Gloves 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Lionhunter Pants')		.compilevariations('Shades Lionhunter Pants 1', 	'Shades Lionhunter Pants 2'));
			parent.Shades_LionHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Lionhunter Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_LionHunter, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin";
			parent.Shades_Assassin.Clear();
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Ezio Armor')		.compilevariations('Shades Ezio Armor 1', 	'Shades Ezio Armor 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Ezio Boots')		.compilevariations('Shades Ezio Boots 1', 	'Shades Ezio Boots 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Ezio Gloves')	.compilevariations('Shades Ezio Gloves 1', 	'Shades Ezio Gloves 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Ezio Pants')		.compilevariations('Shades Ezio Pants 1', 	'Shades Ezio Pants 2'));
			parent.Shades_Assassin.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ezio Hood')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Assassin, PotP_A_Items, master);		
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter";
			parent.Shades_OldHunter.Clear();
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Oldhunter Armor')	.compilevariations('Shades Oldhunter Armor 1', 	'Shades Oldhunter Armor 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Oldhunter Boots')	.compilevariations('Shades Oldhunter Boots 1', 	'Shades Oldhunter Boots 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Oldhunter Gloves')	.compilevariations('Shades Oldhunter Gloves 1', 'Shades Oldhunter Gloves 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Oldhunter Pants')	.compilevariations('Shades Oldhunter Pants 1', 	'Shades Oldhunter Pants 2'));
			parent.Shades_OldHunter.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Oldhunter Cap')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_OldHunter, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant";
			parent.Shades_Revenant.Clear();
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Revenant Armor')		.compilevariations('Shades Revenant Armor 1', 	'Shades Revenant Armor 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Revenant Boots')		.compilevariations('Shades Revenant Boots 1', 	'Shades Revenant Boots 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Revenant Gloves')	.compilevariations('Shades Revenant Gloves 1', 	'Shades Revenant Gloves 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Revenant Pants')		.compilevariations('Shades Revenant Pants 1', 	'Shades Revenant Pants 2'));
			parent.Shades_Revenant.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Revenant Hood')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Revenant, PotP_A_Items, master);	
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker";
			parent.Shades_Stalker.Clear();
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Undertaker Armor')	.compilevariations('Shades Undertaker Armor 1', 	'Shades Undertaker Armor 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Undertaker Boots')	.compilevariations('Shades Undertaker Boots 1', 	'Shades Undertaker Boots 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Undertaker Gloves')	.compilevariations('Shades Undertaker Gloves 1', 	'Shades Undertaker Gloves 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Undertaker Pants')	.compilevariations('Shades Undertaker Pants 1', 	'Shades Undertaker Pants 2'));
			parent.Shades_Stalker.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Undertaker Mask')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Stalker, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng";
			parent.Shades_Taifeng.Clear();
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Taifeng Armor')	.compilevariations('Shades Taifeng Armor 1', 	'Shades Taifeng Armor 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Taifeng Boots')	.compilevariations('Shades Taifeng Boots 1', 	'Shades Taifeng Boots 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Taifeng Gloves')	.compilevariations('Shades Taifeng Gloves 1', 	'Shades Taifeng Gloves 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Taifeng Pants')	.compilevariations('Shades Taifeng Pants 1', 	'Shades Taifeng Pants 2'));
			parent.Shades_Taifeng.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Ronin Hat')		.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Taifeng, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen";
			parent.Shades_Unseen.Clear();
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Yahargul Armor')	.compilevariations('Shades Yahargul Armor 1', 	'Shades Yahargul Armor 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Yahargul Boots')	.compilevariations('Shades Yahargul Boots 1', 	'Shades Yahargul Boots 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Yahargul Gloves')	.compilevariations('Shades Yahargul Gloves 1', 	'Shades Yahargul Gloves 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Yahargul Pants')	.compilevariations('Shades Yahargul Pants 1', 	'Shades Yahargul Pants 2'));
			parent.Shades_Unseen.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head,  'Shades Yahargul Helm')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Unseen, PotP_A_Items, master);		
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis";
			parent.Shades_Sithis.Clear();
			parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Sithis Armor')	.compilevariations('Shades Sithis Armor 1', 	'Shades Sithis Armor 2'));
			parent.Shades_Sithis.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Sithis Hood')	.compilevariations(''));
				
			PotP_SortPreviewData(parent.Shades_Sithis, PotP_A_Items, master);	
	
			//------------------------------------------------------
			
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords";
			parent.Shades_SilverSwords.Clear();
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Eagle Sword')			.compilevariations('Shades Silver Eagle Sword 1', 			'Shades Silver Eagle Sword 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ares')				.compilevariations('Shades Silver Ares 1', 					'Shades Silver Ares 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Doomblade')			.compilevariations('Shades Silver Doomblade 1', 			'Shades Silver Doomblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Beastcutter')			.compilevariations('Shades Silver Beastcutter 1', 			'Shades Silver Beastcutter 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blackdawn')			.compilevariations('Shades Silver Blackdawn 1', 			'Shades Silver Blackdawn 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blooddusk')			.compilevariations('Shades Silver Blooddusk 1', 			'Shades Silver Blooddusk 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodletter')			.compilevariations('Shades Silver Bloodletter 1', 			'Shades Silver Bloodletter 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodshot')			.compilevariations('Shades Silver Bloodshot 1', 			'Shades Silver Bloodshot 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Claymore')			.compilevariations('Shades Silver Claymore 1', 				'Shades Silver Claymore 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kingslayer')			.compilevariations('Shades Silver Kingslayer 1', 			'Shades Silver Kingslayer 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Cursed Khopesh')		.compilevariations('Shades Silver Cursed Khopesh 1',		'Shades Silver Cursed Khopesh 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Dragonbane')			.compilevariations('Shades Silver Dragonbane 1', 			'Shades Silver Dragonbane 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ejderblade')			.compilevariations('Shades Silver Ejderblade 1', 			'Shades Silver Ejderblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Flameborn')			.compilevariations('Shades Silver Flameborn 1', 			'Shades Silver Flameborn 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Frostmourne')			.compilevariations('Shades Silver Frostmourne 1', 			'Shades Silver Frostmourne 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Gorgonslayer')		.compilevariations('Shades Silver Gorgonslayer 1', 			'Shades Silver Gorgonslayer 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Graveripper')			.compilevariations('Shades Silver Graveripper 1', 			'Shades Silver Graveripper 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Guandao')				.compilevariations('Shades Silver Guandao 1', 				'Shades Silver Guandao 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Crownbreaker')		.compilevariations('Shades Silver Crownbreaker 1', 			'Shades Silver Crownbreaker 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hades Grasp')			.compilevariations('Shades Silver Hades Grasp 1', 			'Shades Silver Hades Grasp 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Haoma')				.compilevariations('Shades Silver Haoma 1', 				'Shades Silver Haoma 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Heavenspire')			.compilevariations('Shades Silver Heavenspire 1', 			'Shades Silver Heavenspire 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hellspire')			.compilevariations('Shades Silver Hellspire 1', 			'Shades Silver Hellspire 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Icarus Tears')		.compilevariations('Shades Silver Icarus Tears 1', 			'Shades Silver Icarus Tears 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ryu Katana')			.compilevariations('Shades Silver Ryu Katana 1', 			'Shades Silver Ryu Katana 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Lion Sword')			.compilevariations('Shades Silver Lion Sword 1', 			'Shades Silver Lion Sword 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oathblade')			.compilevariations('Shades Silver Oathblade 1', 			'Shades Silver Oathblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oblivion')			.compilevariations('Shades Silver Oblivion 1', 				'Shades Silver Oblivion 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hitokiri Katana')		.compilevariations('Shades Silver Hitokiri Katana 1', 		'Shades Silver Hitokiri Katana 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Pridefall')			.compilevariations('Shades Silver Pridefall 1', 			'Shades Silver Pridefall 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Rakuyo')				.compilevariations('Shades Silver Rakuyo 1', 				'Shades Silver Rakuyo 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Blade')	.compilevariations('Shades Silver Realmdrifter Blade 1', 	'Shades Silver Realmdrifter Blade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Divider').compilevariations('Shades Silver Realmdrifter Divider 1', 	'Shades Silver Realmdrifter Divider 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kukri')				.compilevariations('Shades Silver Kukri 1', 				'Shades Silver Kukri 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sinner')				.compilevariations('Shades Silver Sinner 1', 				'Shades Silver Sinner 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sithis Blade')		.compilevariations('Shades Silver Sithis Blade 1', 			'Shades Silver Sithis Blade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Voidblade')			.compilevariations('Shades Silver Voidblade 1', 			'Shades Silver Voidblade 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Vulcan')				.compilevariations('Shades Silver Vulcan 1', 				'Shades Silver Vulcan 2'));
			parent.Shades_SilverSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Knife')				.compilevariations('Shades Silver Knife 1', 				'Shades Silver Knife 2'));
				
			PotP_SortPreviewData(parent.Shades_SilverSwords, PotP_A_Items, master);
	
			//------------------------------------------------------
				
			group = "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords";
			parent.Shades_SteelSwords.Clear();
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Eagle Sword')			.compilevariations('Shades Steel Eagle Sword 1', 			'Shades Steel Eagle Sword 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ares')					.compilevariations('Shades Steel Ares 1', 					'Shades Steel Ares 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Doomblade')				.compilevariations('Shades Steel Doomblade 1', 				'Shades Steel Doomblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Beastcutter')			.compilevariations('Shades Steel Beastcutter 1', 			'Shades Steel Beastcutter 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blackdawn')				.compilevariations('Shades Steel Blackdawn 1', 				'Shades Steel Blackdawn 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blooddusk')				.compilevariations('Shades Steel Blooddusk 1', 				'Shades Steel Blooddusk 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodletter')			.compilevariations('Shades Steel Bloodletter 1', 			'Shades Steel Bloodletter 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodshot')				.compilevariations('Shades Steel Bloodshot 1', 				'Shades Steel Bloodshot 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Claymore')				.compilevariations('Shades Steel Claymore 1', 				'Shades Steel Claymore 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kingslayer')			.compilevariations('Shades Steel Kingslayer 1', 			'Shades Steel Kingslayer 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Cursed Khopesh')		.compilevariations('Shades Steel Cursed Khopesh 1',			'Shades Steel Cursed Khopesh 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Dragonbane')			.compilevariations('Shades Steel Dragonbane 1', 			'Shades Steel Dragonbane 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ejderblade')			.compilevariations('Shades Steel Ejderblade 1', 			'Shades Steel Ejderblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Flameborn')				.compilevariations('Shades Steel Flameborn 1', 				'Shades Steel Flameborn 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Frostmourne')			.compilevariations('Shades Steel Frostmourne 1', 			'Shades Steel Frostmourne 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Gorgonslayer')			.compilevariations('Shades Steel Gorgonslayer 1', 			'Shades Steel Gorgonslayer 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Graveripper')			.compilevariations('Shades Steel Graveripper 1', 			'Shades Steel Graveripper 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Guandao')				.compilevariations('Shades Steel Guandao 1', 				'Shades Steel Guandao 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Crownbreaker')			.compilevariations('Shades Steel Crownbreaker 1', 			'Shades Steel Crownbreaker 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hades Grasp')			.compilevariations('Shades Steel Hades Grasp 1', 			'Shades Steel Hades Grasp 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Haoma')					.compilevariations('Shades Steel Haoma 1', 					'Shades Steel Haoma 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Heavenspire')			.compilevariations('Shades Steel Heavenspire 1', 			'Shades Steel Heavenspire 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hellspire')				.compilevariations('Shades Steel Hellspire 1', 				'Shades Steel Hellspire 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Icarus Tears')			.compilevariations('Shades Steel Icarus Tears 1', 			'Shades Steel Icarus Tears 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ryu Katana')			.compilevariations('Shades Steel Ryu Katana 1', 			'Shades Steel Ryu Katana 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Lion Sword')			.compilevariations('Shades Steel Lion Sword 1', 			'Shades Steel Lion Sword 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oathblade')				.compilevariations('Shades Steel Oathblade 1', 				'Shades Steel Oathblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oblivion')				.compilevariations('Shades Steel Oblivion 1', 				'Shades Steel Oblivion 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hitokiri Katana')		.compilevariations('Shades Steel Hitokiri Katana 1', 		'Shades Steel Hitokiri Katana 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Pridefall')				.compilevariations('Shades Steel Pridefall 1', 				'Shades Steel Pridefall 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Rakuyo')				.compilevariations('Shades Steel Rakuyo 1', 				'Shades Steel Rakuyo 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Blade')	.compilevariations('Shades Steel Realmdrifter Blade 1', 	'Shades Steel Realmdrifter Blade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Divider')	.compilevariations('Shades Steel Realmdrifter Divider 1', 	'Shades Steel Realmdrifter Divider 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kukri')					.compilevariations('Shades Steel Kukri 1', 					'Shades Steel Kukri 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sinner')				.compilevariations('Shades Steel Sinner 1', 				'Shades Steel Sinner 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sithis Blade')			.compilevariations('Shades Steel Sithis Blade 1', 			'Shades Steel Sithis Blade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Voidblade')				.compilevariations('Shades Steel Voidblade 1', 				'Shades Steel Voidblade 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Vulcan')				.compilevariations('Shades Steel Vulcan 1', 				'Shades Steel Vulcan 2'));
			parent.Shades_SteelSwords.PushBack(parent.CreateEntry().initItems(master.PotP_EntityHelper, group + "_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Knife')					.compilevariations('Shades Steel Knife 1', 					'Shades Steel Knife 2'));
				
			PotP_SortPreviewData(parent.Shades_SteelSwords, PotP_A_Items, master);
		}
	}

	latent function BuildGwentReduxCards()
	{
		var group: string = "PotP_TrackingGroup_GwentCards_Monsters_Redux";
		var master : CProgressOnThePath;
		GetPotP(master);	
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_gold')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_caranthir')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_emiel')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_striga')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_avallach')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_moon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul3')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cow')						.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dagon')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dettlaff')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_endrega')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_earth_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fogling')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_katakan')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_griffin')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_iris')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul2')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_drakkar')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nithral')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_mrmirror')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_savolla')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_alp')						.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_53", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_garkain')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_54", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas2')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_55", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_mrmirror_foglet')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_56", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_white')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_57", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_hound')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_58", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_navigator')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_59", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_rider')			.compilevariations('gwint_card_wildhunt_rider2', 'gwint_card_wildhunt_rider3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_60", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wildhunt_warrior')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_61", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas3')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_62", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_63", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Monst, 'gwint_card_centipede')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent, master);

		//------------------------------------------------------

		group = "PotP_TrackingGroup_GwentCards_NeutralCards_Redux";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_azar_javed')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_geralt')			.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_ciri')				.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dummy')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_horn')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_professor')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_vesemir')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary,  PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_yennefer')			.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_silver')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_gold')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_moorvran')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_henrietta')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_letho')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade1')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_albrich')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_siege_support')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_artorius')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_assire')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade3')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cahir')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_renuald')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_catriona')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cynthia')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa3')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa2')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_fringilla')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_heavy_zerri')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_joachim')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade4')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_menno')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_milton')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_palmerin')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_morteisen')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_puttkammer')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rainfarn')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rotten')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade2')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_shilard')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_combat_engineer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_stefan')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_sweers')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_syanna')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_tibor')					.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vanhemar')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vattier')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vicovaro')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer2')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vivienne')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vreemde')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_zerri')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_NorthernRealms_Redux";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_gold')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_philippa')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_anseis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_beggar')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_bloody_baron')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_blue_stripes1')		.compilevariations('gwint_card_blue_stripes2', 'gwint_card_blue_stripes3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_boris')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_botchling')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult2')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_carlo')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_cleric_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_crinfrid')			.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_crownsplitter')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_cutup')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Missable,	PotP_I_Gwent, PotP_I_North, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_dijkstra')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_igor')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_jacques')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_francis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_knight_rose')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_lebioda')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_hailstorm')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_nathaniel')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_peach')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_wyvern')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_vincent')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_53", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_54", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_whoreson')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_55", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_56", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_57", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_North, 'gwint_card_zoltan')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_Scoiatael_Redux";
		
		parent.Gwent_Scoiatael.Clear();	
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Missable, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_morenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_aglais')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_braenn')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam5')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_grovekeeper')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam3')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam4')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_fauve')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_scorch')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry3')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse2')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Missable, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support3')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_nature')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam2')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_treant_boar')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_treant_mantis')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support2')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_villen')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_water')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent, master);

		//------------------------------------------------------
		
		group = "PotP_TrackingGroup_GwentCards_Skellige_Redux";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_bronze')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_silver')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_gold')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_platinium')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cock')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_tyr')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_an_craite_marauder')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_an_craite_whaler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_artis')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_athak')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_boatbuilders')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_dreams')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_captain')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_smuggler')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_djenge_frett')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_draig')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ermion')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cerys')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_jutta')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_knut')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_coral')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_werewolf')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_olaf')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_freya')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ragh_nar_roog')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_skellige_storm')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_41", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_skjall')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_42", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_sukrus')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_43", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_svalblod')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_44", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_45", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_46", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_tuirseach_skirmisher')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_47", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_48", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_vabjorn')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_49", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_50", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_51", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')								.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_52", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_yoana')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent, master);
	}
	
	latent function BuildGwentCards()
	{
		var master: CProgressOnThePath;
		var group	: string = "PotP_TrackingGroup_GwentCards_Monsters";
		GetPotP(master);
		
		parent.Gwent_MonstersDeck.Clear();
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_bronze')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_silver')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_gold')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_eredin_platinium')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_draug')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_imlerith')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_kayran')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_leshen')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas')				.compilevariations('gwint_card_arachas2', 'gwint_card_arachas3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_arachas_behemoth')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_botchling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_celaeno_harpy')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_cockatrice')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_brewess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_weavess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_crone_whispess')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_earth_elemental')		.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_endrega')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fiend')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fire_elemental')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fogling')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_forktail')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_frightener')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_gargoyle')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ghoul')					.compilevariations('gwint_card_ghoul2', 'gwint_card_ghoul3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_grave_hag')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_griffin')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_harpy')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ice_giant')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_nekker')					.compilevariations('gwint_card_nekker2', 'gwint_card_nekker3'));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_plague_maiden')			.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_toad')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_bruxa')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_35", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_ekkima')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_36", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_fleder')					.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_37", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_garkain')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_38", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_katakan')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_39", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_werewolf')				.compilevariations(''));
		parent.Gwent_MonstersDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_40", PotP_E_Primary, PotP_I_Gwent, PotP_I_Monst, 'gwint_card_wyvern')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_MonstersDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NeutralCards";
		
		parent.Gwent_NeutralDeck.Clear();
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_ciri')				.compilevariations('gwint_card_gog_ciri'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_geralt')				.compilevariations('gwint_card_gog_geralt'));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_avallach')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_triss')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_yennefer')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_horn')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dummy')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_scorch')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_cow')					.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Missable,PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_dandelion')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_emiel')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_mrmirror')			.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_mrmirror_foglet')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_olgierd')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_vesemir')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_villen')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_zoltan')				.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'gwint_card_skellige_storm')		.compilevariations(''));
		parent.Gwent_NeutralDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Neutr, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NeutralDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NilfgaardianEmpire";
		
		parent.Gwent_NilfgaardDeck.Clear();
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'BASEDECK', PotP_G_Lead)		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_bronze')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_silver')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_gold')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_emhyr_platinium')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_letho')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_menno')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_moorvran')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_tibor')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_albrich')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_assire')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_black_archer')		.compilevariations('gwint_card_black_archer2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cahir')				.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_cynthia')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_archer_support')	.compilevariations('gwint_card_archer_support2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Missable,PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_fringilla')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_heavy_zerri')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_impera_brigade')	.compilevariations('gwint_card_impera_brigade2', 'gwint_card_impera_brigade3', 'gwint_card_impera_brigade4'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_morteisen')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_nausicaa')			.compilevariations('gwint_card_nausicaa2', 'gwint_card_nausicaa3'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_puttkammer')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rainfarn')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_renuald')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_rotten')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_shilard')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_combat_engineer')	.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_siege_support')		.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_stefan')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_sweers')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vanhemar')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_31", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vattier')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_32", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_vreemde')			.compilevariations(''));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_33", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_young_emissary')	.compilevariations('gwint_card_young_emissary2'));
		parent.Gwent_NilfgaardDeck.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_34", PotP_E_Primary, PotP_I_Gwent, PotP_I_Nilfg, 'gwint_card_zerri')				.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NilfgaardDeck, PotP_A_Gwent, master);	

		group = "PotP_TrackingGroup_GwentCards_NorthernRealms";
		
		parent.Gwent_NorthernRealms.Clear();
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_bronze')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_silver')		.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_gold')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_foltest_platinium')	.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_esterad')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Missable,PotP_I_Gwent, PotP_I_North, 'gwint_card_natalis')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_philippa')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_vernon')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_catapult')				.compilevariations('gwint_card_catapult2'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_crinfrid')				.compilevariations('gwint_card_crinfrid2', 'gwint_card_crinfrid3'));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_siege_tower')			.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_dijkstra')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'gwint_card_thaler')				.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_29", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_NorthernRealms.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_30", PotP_E_Primary, PotP_I_Gwent, PotP_I_North, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_NorthernRealms, PotP_A_Gwent, master);		

		group = "PotP_TrackingGroup_GwentCards_Scoiatael";
		
		parent.Gwent_Scoiatael.Clear();
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'BASEDECK', PotP_G_Lead)				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_bronze')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_silver')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_gold')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_francesca_platinium')		.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_eithne')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_iorveth')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Missable,	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_isengrim')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_saskia')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_barclay')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ciaran')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dennis')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_archer')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_infantry')			.compilevariations('gwint_card_dol_infantry2', 'gwint_card_dol_infantry3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_dol_dwarf')				.compilevariations('gwint_card_dol_dwarf2', 'gwint_card_dol_dwarf3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_elf_skirmisher')			.compilevariations('gwint_card_elf_skirmisher2', 'gwint_card_elf_skirmisher3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_filavandrel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_nurse')			.compilevariations('gwint_card_havekar_nurse2', 'gwint_card_havekar_nurse3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_havekar_support')			.compilevariations('gwint_card_havekar_support2', 'gwint_card_havekar_support3'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_ida')						.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_mahakam')					.compilevariations('gwint_card_mahakam2', 'gwint_card_mahakam3', 'gwint_card_mahakam4', 'gwint_card_mahakam5'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_milva')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_riordain')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_schirru')					.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_toruviel')				.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_cadet')			.compilevariations(''));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_27", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_vrihedd_brigade')			.compilevariations('gwint_card_vrihedd_brigade2'));
		parent.Gwent_Scoiatael.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_28", PotP_E_Primary, 	PotP_I_Gwent, PotP_I_Scoia, 'gwint_card_yaevinn')					.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Scoiatael, PotP_A_Gwent, master);

		group = "PotP_TrackingGroup_GwentCards_Skellige";
		
		parent.Gwent_Skellige.Clear();
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_01", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK', PotP_G_Lead)			.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_02", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_king_bran_bronze')		.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_03", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_04", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cerys')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_05", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_ermion')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_06", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_07", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_08", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_09", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_10", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_11", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_clan_dimun_pirate')	.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_12", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_13", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_14", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_15", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_16", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_17", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_draig')				.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_18", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_19", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_cock')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_20", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_21", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_22", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'gwint_card_olaf')					.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_23", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_24", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_25", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		parent.Gwent_Skellige.PushBack(parent.CreateEntry().initGwent(master.PotP_EntityHelper, group + "_26", PotP_E_Primary, PotP_I_Gwent, PotP_I_Skell, 'BASEDECK')						.compilevariations(''));
		
		PotP_SortPreviewData(parent.Gwent_Skellige, PotP_A_Gwent, master);
	}
}



