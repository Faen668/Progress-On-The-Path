//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_MissablePreview
{
	public var fileName: name;
		default fileName = 'PotP Gwent Preview';	
	
	public var message: string;
	public var total_count: float;
	public var completed_count: float; 
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_MissablePreview
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
		var start: float = theGame.GetLocalTimeAsMilliseconds();
		
		build("PotP_Preview_Missable_00", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_InstantFails);
		build("PotP_Preview_Missable_01", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q001);
		build("PotP_Preview_Missable_13", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Ugly);
		build("PotP_Preview_Missable_02", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q401);
		build("PotP_Preview_Missable_03", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_SQ101);
		build("PotP_Preview_Missable_14", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Keira);
		build("PotP_Preview_Missable_12", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q301);
		build("PotP_Preview_Missable_04", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q303);
		build("PotP_Preview_Missable_05", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_SQ106);
		build("PotP_Preview_Missable_06", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q501);
		build("PotP_Preview_Missable_15", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Tango);
		build("PotP_Preview_Missable_07", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q206);
		build("PotP_Preview_Missable_16", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_SQ209);
		build("PotP_Preview_Missable_08", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q210);
		build("PotP_Preview_Missable_09", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q112);
		build("PotP_Preview_Missable_10", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q403);
		build("PotP_Preview_Missable_11", master.PotP_PersistentStorage.pQuestStorage.MissableQuests_Q702);
		
		PotP_Logger("Missable Preview Took " + (theGame.GetLocalTimeAsMilliseconds() - start) + " Milliseconds To Generate");
		return this.message;
	}
	
	//---------------------------------------------------
	
	private function build(Header: string, pData: array<PotP_PreviewEntry>) 
	{	
		this.consumebuilder((new ProgressOnThepath_StringBuilder in thePlayer)
			.init(master)
			.setFilters(0, 0)
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

