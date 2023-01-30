//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_QuestPreview
{
	public var fileName: name;
		default fileName = 'PotP Quest Preview';	

	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_QuestPreview
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
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_QType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_QArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_QType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_QArea_" + areaFilter);
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
		build("PotP_Preview_Event_1", master.PotP_ArrayManager.RandomEvents_Velen);
		build("PotP_Preview_Event_2", master.PotP_ArrayManager.RandomEvents_Novigrad);
		build("PotP_Preview_Event_3", master.PotP_ArrayManager.RandomEvents_Skellige);
		build("PotP_Preview_Event_4", master.PotP_ArrayManager.RandomEvents_KaerMorhen);
		
		build("PotP_Preview_MainQ_1", master.PotP_ArrayManager.MainQuests_Prologue);
		build("PotP_Preview_MainQ_2", master.PotP_ArrayManager.MainQuests_Act1_Velen);
		build("PotP_Preview_MainQ_3", master.PotP_ArrayManager.MainQuests_Act1_Novigrad);
		build("PotP_Preview_MainQ_4", master.PotP_ArrayManager.MainQuests_Act1_Skellige);
		build("PotP_Preview_MainQ_5", master.PotP_ArrayManager.MainQuests_Act2);
		build("PotP_Preview_MainQ_6", master.PotP_ArrayManager.MainQuests_Act3);
		build("PotP_Preview_MainQ_7", master.PotP_ArrayManager.MainQuests_DLC1);
		build("PotP_Preview_MainQ_8", master.PotP_ArrayManager.MainQuests_DLC2);
		build("PotP_Preview_MainQ_9", master.PotP_ArrayManager.MainQuests_Vizima);		
		
		build("PotP_Preview_SideQ_1", master.PotP_ArrayManager.SideQuests_WhiteOrchard);
		build("PotP_Preview_SideQ_2", master.PotP_ArrayManager.SideQuests_Velen);
		build("PotP_Preview_SideQ_3", master.PotP_ArrayManager.SideQuests_Novigrad);
		build("PotP_Preview_SideQ_4", master.PotP_ArrayManager.SideQuests_Skellige);
		build("PotP_Preview_SideQ_5", master.PotP_ArrayManager.SideQuests_KaerMorhen);
		build("PotP_Preview_SideQ_6", master.PotP_ArrayManager.SideQuests_Toussaint);
		build("PotP_Preview_SideQ_7", master.PotP_ArrayManager.SideQuests_NonRegional);	
		
		build("PotP_Preview_ContQ_1", master.PotP_ArrayManager.ContQuests_WhiteOrchard);
		build("PotP_Preview_ContQ_2", master.PotP_ArrayManager.ContQuests_Velen);
		build("PotP_Preview_ContQ_3", master.PotP_ArrayManager.ContQuests_Novigrad);
		build("PotP_Preview_ContQ_4", master.PotP_ArrayManager.ContQuests_Skellige);
		build("PotP_Preview_ContQ_5", master.PotP_ArrayManager.ContQuests_Toussaint);	
		
		build("PotP_Preview_ScavQ_1", master.PotP_ArrayManager.ScavQuests_Griffin);
		build("PotP_Preview_ScavQ_2", master.PotP_ArrayManager.ScavQuests_Feline);
		build("PotP_Preview_ScavQ_3", master.PotP_ArrayManager.ScavQuests_Ursine);
		build("PotP_Preview_ScavQ_4", master.PotP_ArrayManager.ScavQuests_Wolven);
		build("PotP_Preview_ScavQ_5", master.PotP_ArrayManager.ScavQuests_Others);		
		
		build("PotP_Preview_TreaQ_1", master.PotP_ArrayManager.HuntQuests_WhiteOrchard);
		build("PotP_Preview_TreaQ_2", master.PotP_ArrayManager.HuntQuests_Velen);
		build("PotP_Preview_TreaQ_3", master.PotP_ArrayManager.HuntQuests_Novigrad);
		build("PotP_Preview_TreaQ_4", master.PotP_ArrayManager.HuntQuests_Skellige);
		build("PotP_Preview_TreaQ_5", master.PotP_ArrayManager.HuntQuests_Toussaint);
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
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