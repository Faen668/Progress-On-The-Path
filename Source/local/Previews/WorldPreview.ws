//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_WorldPreview
{
	public var fileName: name;
		default fileName = 'PotP World Preview';	

	private var areaFilter: int;
	private var typeFilter: int;
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_WorldPreview
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
		typeFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_WType');
		areaFilter = (int) PotP_GetPreviewValue('ProgressOnThePath_Preview_WArea');
		return GetLocStringByKeyExt("preset_value_QT_Option_WType_" + typeFilter) + " | " + GetLocStringByKeyExt("preset_value_QT_Option_WArea_" + areaFilter);
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
		build("PotP_Preview_Camps_1", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_WhiteOrchard);
		build("PotP_Preview_Camps_2", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Velen);
		build("PotP_Preview_Camps_3", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Novigrad);
		build("PotP_Preview_Camps_4", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Skellige);
		build("PotP_Preview_Camps_5", master.PotP_PersistentStorage.pWorldStorage.BanditCamps_Toussaint);
		
		build("PotP_Preview_DensM_1", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Velen);
		build("PotP_Preview_DensM_2", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Novigrad);
		build("PotP_Preview_DensM_3", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Skellige);
		build("PotP_Preview_DensM_4", master.PotP_PersistentStorage.pWorldStorage.MonsterDens_Toussaint);
		
		build("PotP_Preview_NestM_1", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_WhiteOrchard);
		build("PotP_Preview_NestM_2", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Velen);
		build("PotP_Preview_NestM_3", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Novigrad);
		build("PotP_Preview_NestM_4", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Skellige);
		build("PotP_Preview_NestM_5", master.PotP_PersistentStorage.pWorldStorage.MonsterNests_Toussaint);
		
		build("PotP_Preview_Place_1", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_WhiteOrchard);
		build("PotP_Preview_Place_2", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Velen);
		build("PotP_Preview_Place_3", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Novigrad);
		build("PotP_Preview_Place_4", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Skellige);
		build("PotP_Preview_Place_5", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_KaerMorhen);
		build("PotP_Preview_Place_6", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_Toussaint);
		build("PotP_Preview_Place_7", master.PotP_PersistentStorage.pWorldStorage.PlacesOfPower_TheSpiral);
		
		build("PotP_Preview_SignP_1", master.PotP_PersistentStorage.pWorldStorage.Signposts_WhiteOrchard);
		build("PotP_Preview_SignP_2", master.PotP_PersistentStorage.pWorldStorage.Signposts_Velen);	
		build("PotP_Preview_SignP_3", master.PotP_PersistentStorage.pWorldStorage.Signposts_Novigrad);
		build("PotP_Preview_SignP_4", master.PotP_PersistentStorage.pWorldStorage.Signposts_Skellige);
		build("PotP_Preview_SignP_5", master.PotP_PersistentStorage.pWorldStorage.Signposts_KaerMorhen);
		build("PotP_Preview_SignP_6", master.PotP_PersistentStorage.pWorldStorage.Signposts_Toussaint);
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

