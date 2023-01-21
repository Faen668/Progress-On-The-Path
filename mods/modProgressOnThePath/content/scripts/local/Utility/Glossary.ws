//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_QuestPreviewBook extends SU_GlossaryEntry {
	default entry_unique_id = 'CProgressOnTheBath_QuestPreviewBook';

	public var master: CProgressOnThePath;

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_QuestPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_QuestPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_QuestPreview.GetBookDescription();
		var countstring		: string = master.PotP_QuestPreview.GetTotalCountsForPreview();
		
		if (master.PotP_QuestPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_WorldPreviewBook extends SU_GlossaryEntry {
	default entry_unique_id = 'CProgressOnTheBath_WorldPreviewBook';

	public var master: CProgressOnThePath;

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_WorldPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_WorldPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_WorldPreview.GetBookDescription();
		var countstring		: string = master.PotP_WorldPreview.GetTotalCountsForPreview();
		
		if (master.PotP_WorldPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_ItemsPreviewBook extends SU_GlossaryEntry {
	default entry_unique_id = 'CProgressOnTheBath_ItemsPreviewBook';

	public var master: CProgressOnThePath;

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_ItemsPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_ItemsPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_ItemsPreview.GetBookDescription();
		var countstring		: string = master.PotP_ItemsPreview.GetTotalCountsForPreview();
		
		if (master.PotP_ItemsPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_GwentPreviewBook extends SU_GlossaryEntry {
	default entry_unique_id = 'CProgressOnTheBath_GwentPreviewBook';

	public var master: CProgressOnThePath;

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
	
	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_GwentPreviewMessage_T") + "<br/>";
		var activefilters	: string = master.PotP_GwentPreview.GetActiveFilters() + "</p><br/>";
		var description		: string = master.PotP_GwentPreview.GetBookDescription();
		var countstring		: string = master.PotP_GwentPreview.GetTotalCountsForPreview();
		
		if (master.PotP_GwentPreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}
		
		if (description == "")
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterError") + "</p>";
		}

		return StrReplace((messagetitle + activefilters + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_MissaPreviewBook extends SU_GlossaryEntry {
	default entry_unique_id = 'CProgressOnTheBath_MissaPreviewBook';

	public var master: CProgressOnThePath;

	public function initialise(PotP_BaseClass: CProgressOnThePath) {
		this.master = PotP_BaseClass;
	}

	function getDescription(): string 
	{
		var messagetitle	: string = "<p align=\"center\">" + GetLocStringByKeyExt("PotP_MissablePreviewMessage_T") + "</p><br/>";
		var description		: string = master.PotP_MissablePreview.GetBookDescription();
		var countstring		: string = master.PotP_MissablePreview.GetTotalCountsForPreview();
		
		if (master.PotP_MissablePreview.IsCompleted())
		{
			description = "<p align=\"center\">" + GetLocStringByKeyExt("ProgressOnThePath_FilterComplete") + "</p>";
		}

		return StrReplace((messagetitle + description), "REPLACECOUNT", countstring);
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook1 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook1';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook1_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook2 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook2';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook2_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook3 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook3';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook3_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook4 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook4';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook4_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook5 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook5';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook5_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook6 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook6';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook6_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook7 extends SU_GlossaryEntry {
	default entry_unique_id = 'ProgressOnTheBath_TutorialBook7';
  
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnTheBath_TutorialBook7_Desc");
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------

