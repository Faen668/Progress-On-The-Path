//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_GwentPreview
{
	public var fileName: name;
		default fileName = 'PotP Gwent Preview';	
	
	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_GwentPreview
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
		return this.CanAccess() && this.completed_count == this.total_count;
	}	

	//---------------------------------------------------
	
	public function CanAccess() : bool 
	{
		return theGame.GetGwintManager().HasLootedCard();
	}	
	
	//---------------------------------------------------
	
	public function GetActiveFilters() : string 
	{
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_GType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_GArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_GType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_GArea_" + areaFilter);
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
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		
		if (!GwentManager.HasLootedCard()) 
		{
			return "";
		}
		
		build("PotP_Preview_Gwent_1", master.PotP_PersistentStorage.pItemsStorage.Gwent_MonstersDeck);
		build("PotP_Preview_Gwent_2", master.PotP_PersistentStorage.pItemsStorage.Gwent_NeutralDeck);
		build("PotP_Preview_Gwent_3", master.PotP_PersistentStorage.pItemsStorage.Gwent_NilfgaardDeck);
		build("PotP_Preview_Gwent_4", master.PotP_PersistentStorage.pItemsStorage.Gwent_NorthernRealms);
		build("PotP_Preview_Gwent_5", master.PotP_PersistentStorage.pItemsStorage.Gwent_Scoiatael);
		
		if (GwentManager.IsDeckUnlocked(GwintFaction_Skellige))
		{
			build("PotP_Preview_Gwent_6", master.PotP_PersistentStorage.pItemsStorage.Gwent_Skellige);
		}
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_GwentCardBuilder in thePlayer)
			.init()
			.setFilters(this.areaFilter, this.typeFilter)
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

