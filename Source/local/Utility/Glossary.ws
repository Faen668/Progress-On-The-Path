//---------------------------------------------------
//-- Preview Books ----------------------------------
//---------------------------------------------------

class CProgressOnTheBath_QuestPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_QuestPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Quest_Name");
		this.icon_path = "icons/PotP/qp.png";
		this.sort_index = 30005;
		SU_addGlossaryEntry(this);
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

class CProgressOnTheBath_WorldPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_WorldPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_World_Name");
		this.icon_path = "icons/PotP/map.png";
		this.sort_index = 30004;
		SU_addGlossaryEntry(this);
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

class CProgressOnTheBath_ItemsPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_ItemsPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Items_Name");
		this.icon_path = "icons/PotP/collect.png";
		this.sort_index = 30003;
		SU_addGlossaryEntry(this);
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

class CProgressOnTheBath_GwentPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_GwentPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Gwent_Name");
		this.icon_path = "icons/PotP/gwint_north.png";
		this.sort_index = 30002;
		SU_addGlossaryEntry(this);
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

class CProgressOnTheBath_MissaPreviewBook extends SU_GlossaryEntry 
{
	default entry_unique_id = 'CProgressOnThePath_MissaPreviewBook';

	public var master: CProgressOnThePath;
	
	function addBook(master: CProgressOnThePath): void
	{	
		this.master = master;
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_previews");
		this.drop_down_tag = 'ProgressOnThePath_Previews';
		this.title = GetLocStringByKeyExt("PotP_PreviewBook_Missa_Name");
		this.icon_path = "icons/PotP/qp_miss.png";
		this.sort_index = 30001;
		SU_addGlossaryEntry(this);
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

class ProgressOnTheBath_TutorialBook1 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook1';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook1_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30016;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook1_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook2 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook2';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook2_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30015;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook2_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook3 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook3';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook3_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30014;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook3_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook4 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook4';
 
	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook4_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30013;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook4_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook5 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook5';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook5_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30012;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook5_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook6 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook6';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook6_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30011;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook6_Desc");
	}
}

//---------------------------------------------------
//-- Tutorial Books ---------------------------------
//---------------------------------------------------

class ProgressOnTheBath_TutorialBook7 extends SU_GlossaryEntry 
{
	default entry_unique_id = 'ProgressOnThePath_TutorialBook7';

	function addBook(): void
	{
		this.drop_down_label = GetLocStringByKeyExt("panel_glossary_potp_tutorial");
		this.drop_down_tag = 'ProgressOnThePath_Tutorials';
		this.title = GetLocStringByKeyExt("ProgressOnThePath_TutorialBook7_Name");
		this.icon_path = "icons/PotP/qp_alt.png";
		this.sort_index = 30010;
		SU_addGlossaryEntry(this);
	}
	
	function getDescription(): string {
		return GetLocStringByKeyExt("ProgressOnThePath_TutorialBook7_Desc");
	}
}

