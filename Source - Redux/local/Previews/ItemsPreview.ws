//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_ItemsPreview
{
	public var fileName: name;
		default fileName = 'PotP Items Preview';	

	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_ItemsPreview
	{
		this.master = master;
		return this;
	}
	
	//---------------------------------------------------
	
	public function GetTotalCountsForPreview() : string 
	{
		return "(" + (int) this.completed_count + " / " + (int) this.total_count + ") - " + FloatToStringPrec(((this.completed_count / this.total_count) * 100), 2) + "%";
	}

	//---------------------------------------------------
	
	public function IsCompleted() : bool 
	{
		return this.completed_count == this.total_count;
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_IType');
		return GetLocStringByKeyExt("preset_value_QT_Option_IType_" + typeFilter);
	}	
	
	//---------------------------------------------------
	
	public function GetBookDescription() : string
	{
		this.message = "";
		this.total_count = 0;
		this.completed_count = 0;
		return this.generate();
	}
	
	//---------------------------------------------------
	
	private function generate(): string 
	{
		build("PotP_Preview_GearS_1", master.PotP_PersistentStorage.pItemsStorage.Armor_DolBlathanna);
		build("PotP_Preview_GearS_2", master.PotP_PersistentStorage.pItemsStorage.Armor_ForgottenWolven);
		build("PotP_Preview_GearS_3", master.PotP_PersistentStorage.pItemsStorage.Armor_HenGaidth);
		build("PotP_Preview_GearS_4", master.PotP_PersistentStorage.pItemsStorage.Armor_NewMoon);
		build("PotP_Preview_GearS_5", master.PotP_PersistentStorage.pItemsStorage.Armor_Nilfgaardian);
		build("PotP_Preview_GearS_6", master.PotP_PersistentStorage.pItemsStorage.Armor_Ofieri);	
		build("PotP_Preview_GearS_7", master.PotP_PersistentStorage.pItemsStorage.Armor_Temerian);
		build("PotP_Preview_GearS_8", master.PotP_PersistentStorage.pItemsStorage.Armor_TeshamMutna);
		build("PotP_Preview_GearS_9", master.PotP_PersistentStorage.pItemsStorage.Armor_Undvik);
		build("PotP_Preview_GearS_A", master.PotP_PersistentStorage.pItemsStorage.Armor_WhiteTiger);

		build("PotP_Preview_DLCC_1",  master.PotP_PersistentStorage.pItemsStorage.DLC_CosWiecej);
		build("PotP_Preview_DLCC_5",  master.PotP_PersistentStorage.pItemsStorage.DLC_Dimeritium);
		build("PotP_Preview_DLCC_3",  master.PotP_PersistentStorage.pItemsStorage.DLC_Gothic);
		build("PotP_Preview_DLCC_4",  master.PotP_PersistentStorage.pItemsStorage.DLC_Meteorite);
		build("PotP_Preview_DLCC_2",  master.PotP_PersistentStorage.pItemsStorage.DLC_SezonBurz);

		build("PotP_Preview_Shad_01", master.PotP_PersistentStorage.pItemsStorage.Shades_Berserker);
		build("PotP_Preview_Shad_02", master.PotP_PersistentStorage.pItemsStorage.Shades_Bismarck);
		build("PotP_Preview_Shad_03", master.PotP_PersistentStorage.pItemsStorage.Shades_BloodHunter);
		build("PotP_Preview_Shad_04", master.PotP_PersistentStorage.pItemsStorage.Shades_CrowFeathered);
		build("PotP_Preview_Shad_05", master.PotP_PersistentStorage.pItemsStorage.Shades_FallenKnight);
		build("PotP_Preview_Shad_06", master.PotP_PersistentStorage.pItemsStorage.Shades_Faraam);
		build("PotP_Preview_Shad_07", master.PotP_PersistentStorage.pItemsStorage.Shades_Headtaker);
		build("PotP_Preview_Shad_08", master.PotP_PersistentStorage.pItemsStorage.Shades_Hitokiri);
		build("PotP_Preview_Shad_09", master.PotP_PersistentStorage.pItemsStorage.Shades_Kara);
		build("PotP_Preview_Shad_10", master.PotP_PersistentStorage.pItemsStorage.Shades_LionHunter);
		build("PotP_Preview_Shad_11", master.PotP_PersistentStorage.pItemsStorage.Shades_Assassin);
		build("PotP_Preview_Shad_12", master.PotP_PersistentStorage.pItemsStorage.Shades_OldHunter);
		build("PotP_Preview_Shad_13", master.PotP_PersistentStorage.pItemsStorage.Shades_Revenant);
		build("PotP_Preview_Shad_14", master.PotP_PersistentStorage.pItemsStorage.Shades_Stalker);
		build("PotP_Preview_Shad_15", master.PotP_PersistentStorage.pItemsStorage.Shades_Taifeng);
		build("PotP_Preview_Shad_16", master.PotP_PersistentStorage.pItemsStorage.Shades_Unseen);
		build("PotP_Preview_Shad_17", master.PotP_PersistentStorage.pItemsStorage.Shades_Sithis);
		build("PotP_Preview_Shad_18", master.PotP_PersistentStorage.pItemsStorage.Shades_SilverSwords);
		build("PotP_Preview_Shad_19", master.PotP_PersistentStorage.pItemsStorage.Shades_SteelSwords);

		build("PotP_Preview_Troph_1", master.PotP_PersistentStorage.pItemsStorage.Relic_Trophies);
		build("PotP_Preview_Relic_3", master.PotP_PersistentStorage.pItemsStorage.Relic_Crossbows);
		build("PotP_Preview_Relic_2", master.PotP_PersistentStorage.pItemsStorage.Relic_SteelSwords);
		build("PotP_Preview_Relic_1", master.PotP_PersistentStorage.pItemsStorage.Relic_SilverSwords);
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(0, this.typeFilter)
			.addHeader(Header)
			.addDataSet(pData)
		.build());
	}

	//---------------------------------------------------

	private function consumebuilder(result: PotP_Builder_Result)
	{
		this.message 		    += result.message;
		this.total_count 		+= result.total_count;
		this.completed_count 	+= result.completed_count;
	}
}

