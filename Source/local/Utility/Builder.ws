//---------------------------------------------------
//-- Builder Result ---------------------------------
//---------------------------------------------------

struct PotP_Builder_Result 
{
  var message: string;
  var total_count: float;
  var completed_count: float;
}

//---------------------------------------------------
//-- Builder ----------------------------------------
//---------------------------------------------------

class ProgressOnThepath_StringBuilder
{
	private var data		: array<PotP_PreviewEntry>;
	private var n_entryList	: array<PotP_PreviewEntry>;
	private var m_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;

	private var showMissed: bool;
		default showMissed = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;
		
	private var master: CProgressOnThePath;
	private var entity_helper: CProgressOnThePath_PreviewEntryHelper;
		
	//---------------------------------------------------
	
	public function init(master: CProgressOnThePath) : ProgressOnThepath_StringBuilder 
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function setFilters(areaFilter: int, typeFilter: int) : ProgressOnThepath_StringBuilder 
	{
		// Sets the area and type filter based on user settings.
		this.areaFilter = areaFilter;
		this.typeFilter = typeFilter;
		return this;
	}
	
	//---------------------------------------------------
	
	public function addHeader(header: string) : ProgressOnThepath_StringBuilder 
	{
		// Adds the localised header that should be used for this build.
		this.header = GetLocStringByKeyExt(header);
		
		return this;
	}

	//---------------------------------------------------
	
	public function addDataSet(data: array<PotP_PreviewEntry>) : ProgressOnThepath_StringBuilder 
	{
		// Adds the data array the builder will process.
		this.data = data;
		
		return this;
	}

	//---------------------------------------------------
	
	private function addEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		n_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addMissableEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		m_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	private function FormatHeaderIcon(data: PotP_PreviewEntry, header: string) : string
	{
		return StrReplace(header, "[ICON_PATH]", "<img src='img://" + entity_helper.GetIconPath(data) + "' height='20' width='20' vspace='-5' />&nbsp;");
	}
	
	//---------------------------------------------------
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, m_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		this.showMissed    = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Miss');
		
		// Traverse and separate normal and missable entries from the data array.
		for (Idx = 0; Idx < this.data.Size(); Idx += 1)
		{
			if (this.data[Idx].is_missable) {
				this.addMissableEntry(this.data[Idx]);
				continue;
			}
			this.addEntry(this.data[Idx]);
		}
		
		// Traverse normal entries array (potentially empty)
		for ( Idx = 0; Idx < n_entryList.Size(); Idx += 1 )
		{
			entry_line = this.GetString(n_entryList[Idx]);
			
			if (entry_line != "")
			{
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(n_entryList[Idx], header);
					n_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Traverse missable entries array (potentially empty)
		for ( Idx = 0; Idx < m_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(m_entryList[Idx]);
			
			if (entry_line != "")
			{
				
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(m_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!m_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Missable");
					m_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) !entity_helper.IsPlayable(this.data[Idx]);
		}
		
		// Return message and counts as a result.
		return PotP_Builder_Result
		(
			// Dynamically replace a hard coded tag in the message header with a string containing the current counts.
			StrReplace(messagebody, "[COUNTS]", "(" + (int) FloatToString(completed_count) + " / " + FloatToString(total_count) + ")"),
			total_count, 
			completed_count
		);
	}

	//---------------------------------------------------
	
	private function GetString(entry_data: PotP_PreviewEntry) : string 
	{
		var localName: 		string = entity_helper.getID(entry_data) + entry_data.localname;
		var isCompleted: 	bool = entity_helper.IsCompleted(entry_data);
		var isIgnored: 		bool = entity_helper.IsIgnored(entry_data);
		var isInProgress: 	bool = entity_helper.IsInProgress(entry_data);
		var isMissed:		bool = entity_helper.IsMissed(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored) || (isMissed && !showMissed))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0)
		{
			if (entry_data.arrayType == PotP_A_Items)
			{
				if (entry_data.sub_filter != this.typeFilter)
				{
					return "";
				}		
			}
			else
			{
				if (entry_data.filter != this.typeFilter)
				{
					return "";
				}				
			}
		}

		// Apply line height modifications for a list style effect.
		entry_line = "  - " + localName;
		
		// Increase line height and add colour for missable quests.
		if (entry_data.is_missable)
		{
			entry_line = "<font color='#D79D3A'>       - </font>" + localName;
		}	
		
		// Apply a coloured 'Mod Added' tag to any entries that are not part of the official game.
		if (entry_data.is_modadded) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_MA");
		}		
		
		// Apply a coloured 'In Progress' tag to any active quests that are not yet completed.
		if (isInProgress) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IP");
		}
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_CO");
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IG");
		}

		// Apply a coloured 'Missed' tag to any missed entries.
		if (isMissed && showMissed) 
		{
			entry_line = "<font color='#8a0707'>" + entry_line + GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_NC") + "</font>";
		}
		
		// Return the formatted string back to the builder.
		return entry_line;
	}
}

//---------------------------------------------------
//-- Builder ----------------------------------------
//---------------------------------------------------

class ProgressOnThepath_GwentCardBuilder
{
	private var data		: array<PotP_PreviewEntry>;
	private var u_entryList	: array<PotP_PreviewEntry>;
	private var h_entryList	: array<PotP_PreviewEntry>;
	private var l_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;

	private var showMissed: bool;
		default showMissed = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;

	private var filterString: string;
		default filterString = "";
		
	private var master: CProgressOnThePath;
	private var entity_helper: CProgressOnThePath_PreviewEntryHelper;
		
	//---------------------------------------------------
	
	public function init(master: CProgressOnThePath) : ProgressOnThepath_GwentCardBuilder 
	{
		this.master = master;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function setFilters(areaFilter: int, typeFilter: int) : ProgressOnThepath_GwentCardBuilder 
	{
		// Sets the area and type filter based on user settings.
		this.areaFilter = areaFilter;
		this.typeFilter = typeFilter;
		return this;
	}
	
	//---------------------------------------------------
	
	public function addHeader(header: string) : ProgressOnThepath_GwentCardBuilder 
	{
		// Adds the localised header that should be used for this build.
		this.header = GetLocStringByKeyExt(header);
		
		return this;
	}

	//---------------------------------------------------
	
	public function addDataSet(data: array<PotP_PreviewEntry>) : ProgressOnThepath_GwentCardBuilder 
	{
		// Adds the data array the builder will process.
		this.data = data;
		
		return this;
	}

	//---------------------------------------------------
	
	private function addUnitEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		u_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addHeroEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		h_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	private function addLeaderEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		l_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function FormatHeaderIcon(data: PotP_PreviewEntry, header: string) : string
	{
		return StrReplace(header, "[ICON_PATH]", "<img src='img://" + entity_helper.GetIconPath(data) + "' height='20' width='20' vspace='-5' />&nbsp;");
	}
	
	//---------------------------------------------------
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, u_headerAdded, h_headerAdded, l_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		
		// Traverse and separate normal and missable entries from the data array.
		for (Idx = 0; Idx < this.data.Size(); Idx += 1)
		{
			if (this.data[Idx].card_type == PotP_G_Lead) {
				this.addLeaderEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].card_type == PotP_G_Hero) {
				this.addHeroEntry(this.data[Idx]);
				continue;
			}
			
			this.addUnitEntry(this.data[Idx]);
		}
		
		// Traverse Leader entries array (potentially empty)
		for ( Idx = 0; Idx < l_entryList.Size(); Idx += 1 )
		{
			entry_line = this.GetString(l_entryList[Idx]);
			
			if (entry_line != "")
			{
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(l_entryList[Idx], header);
					n_headerAdded = true;
				}

				if (!l_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Lead");
					l_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse Hero entries array (potentially empty)
		for ( Idx = 0; Idx < h_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(h_entryList[Idx]);
			
			if (entry_line != "")
			{				
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(h_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!h_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Hero");
					h_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse Unit entries array (potentially empty)	
		for ( Idx = 0; Idx < u_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(u_entryList[Idx]);
			
			if (entry_line != "")
			{
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += this.FormatHeaderIcon(u_entryList[Idx], header);
					n_headerAdded = true;
				}
				
				if (!u_headerAdded)
				{
					messagebody += GetLocStringByKeyExt("ProgressOnThePath_Builderheader_Unit");
					u_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) !entity_helper.IsPlayable(this.data[Idx]);
		}
		
		// Return message and counts as a result.
		return PotP_Builder_Result
		(
			// Dynamically replace a hard coded tag in the message header with a string containing the current counts.
			StrReplace(messagebody, "[COUNTS]", "(" + (int) FloatToString(completed_count) + " / " + FloatToString(total_count) + ")"),
			total_count, 
			completed_count
		);
	}

	//---------------------------------------------------
	
	private function GetString(entry_data: PotP_PreviewEntry) : string 
	{
		var localName: 		string = entity_helper.getID(entry_data) + entry_data.localname;
		var isCompleted: 	bool = entity_helper.IsCompleted(entry_data);
		var isIgnored: 		bool = entity_helper.IsIgnored(entry_data);
		var isMissed:		bool = entity_helper.IsMissed(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored) || (isMissed && !showMissed))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0 && entry_data.sub_filter != this.typeFilter)
		{
			return "";
		}	
		
		entry_line = "<font size='25'>       - " + localName + "</font>";

		// Apply a coloured 'Missable' tag to valid gwent cards.
		if (entry_data.is_missable) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_MI");
		}
		
		if ( (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_GExtra') ) 
		{
			// Apply a coloured 'Bought From Vendor' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Bought)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_BO");
			}	

			// Apply a coloured 'Lootable' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Looted)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_LO");
			}	

			// Apply a coloured 'Quest Reward' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Reward)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_QR");
			}	

			// Apply a coloured 'Won in Dual' tag to valid gwent cards.
			if (entry_data.card_origin == PotP_G_Dualed)
			{
				entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_WO");
			}
		}
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_CO");
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_IG");
		}

		// Apply a coloured 'Missed' tag to any missed entries.
		if (isMissed && showMissed) 
		{
			entry_line = "<font color='#8a0707'>" + entry_line + GetLocStringByKeyExt("ProgressOnThePath_PreviewTag_NC") + "</font>";
		}
		
		// Return the formatted string back to the builder.
		return entry_line;
	}
}

