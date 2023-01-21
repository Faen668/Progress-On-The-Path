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
	private var storage		: CProgressOnThePath_Storage;
	private var data		: array<PotP_PreviewEntry>;
	private var n_entryList	: array<PotP_PreviewEntry>;
	private var m_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;
		
	//---------------------------------------------------
	
	public function init(PotP_PersistentStorage: CProgressOnThePath_Storage) : ProgressOnThepath_StringBuilder 
	{
		// Initialises the storage variable and builder.
		this.storage = PotP_PersistentStorage;
		
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
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, m_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		
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
					messagebody += header;
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
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!m_headerAdded)
				{
					messagebody += "<font color='#D79D3A'>  - Missable:</font><br/>";
					m_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) this.storage.IsCompletedOrIgnored(this.data[Idx]);
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
		var localName: 		string = entry_data.getID() + entry_data.localname;
		var isCompleted: 	bool = storage.IsCompleted(entry_data);
		var isIgnored: 		bool = storage.IsIgnored(entry_data);
		var isInProgress: 	bool = storage.IsInProgress(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0 && entry_data.filter != this.typeFilter)
		{
			return "";
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
			entry_line += entry_data.T_ModAdded;
		}		
		
		// Apply a coloured 'In Progress' tag to any active quests that are not yet completed.
		if (isInProgress) 
		{
			entry_line += entry_data.T_InProgress;
		}
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += entry_data.T_Completed;
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += entry_data.T_Ignored;
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
	private var storage		: CProgressOnThePath_Storage;
	private var data		: array<PotP_PreviewEntry>;
	
	private var n_entryList	: array<PotP_PreviewEntry>;
	private var m_entryList	: array<PotP_PreviewEntry>;
	
	private var b_entryList	: array<PotP_PreviewEntry>;
	private var l_entryList	: array<PotP_PreviewEntry>;
	private var d_entryList	: array<PotP_PreviewEntry>;
	private var q_entryList	: array<PotP_PreviewEntry>;
		
	private var header: string;
		default header = "";
		
	private var showCompleted: bool;
		default showCompleted = false;
		
	private var showIgnored: bool;
		default showIgnored = false;
		
	private var areaFilter: int;
		default areaFilter = 0;

	private var typeFilter: int;
		default typeFilter = 0;

	private var filterString: string;
		default filterString = "";
		
	//---------------------------------------------------
	
	public function init(PotP_PersistentStorage: CProgressOnThePath_Storage) : ProgressOnThepath_GwentCardBuilder 
	{
		// Initialises the storage variable and builder.
		this.storage = PotP_PersistentStorage;
		
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
	
	private function addEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		n_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addMissableEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'normal' entries.
		m_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	private function addboughtEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		b_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addlootedEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		l_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function addrewardEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		q_entryList.PushBack(_quest);
	}

	//---------------------------------------------------
	
	private function adddualedEntry(_quest: PotP_PreviewEntry) : void
	{
		// Used internally to hold 'missable' entries.
		d_entryList.PushBack(_quest);
	}
	
	//---------------------------------------------------
	
	public function build() : PotP_Builder_Result
	{
		var messagebody, entry_line: string = "";		
		var n_headerAdded, m_headerAdded, r_headerAdded: bool = false;
		var q_headerAdded, b_headerAdded, l_headerAdded, d_headerAdded: bool = false;
		var completed_count, total_count: float;
		var Idx: int;

		// Determine if we should be showing completed / ignore entries based on user settings.
		this.showCompleted = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Comp');
		this.showIgnored   = (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Igno');
		
		// Traverse and separate normal and missable entries from the data array.
		for (Idx = 0; Idx < this.data.Size(); Idx += 1)
		{
			if (this.data[Idx].is_missable) {
				this.addMissableEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].is_bought) {
				this.addboughtEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].is_loot) {
				this.addlootedEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].is_reward) {
				this.addrewardEntry(this.data[Idx]);
				continue;
			}

			if (this.data[Idx].is_dual) {
				this.adddualedEntry(this.data[Idx]);
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
					messagebody += header;
					n_headerAdded = true;
				}

				if (!r_headerAdded)
				{
					messagebody += "<font color='#aecbeb'>  - Won From Random NPC's:</font><br/>";
					r_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse missable entries array (potentially empty)
		for ( Idx = 0; Idx < q_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(q_entryList[Idx]);
			
			if (entry_line != "")
			{				
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!q_headerAdded)
				{
					messagebody += "<font color='#aecbeb'>  - Quest Reward:</font><br/>";
					q_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}

		// Traverse missable entries array (potentially empty)	
		for ( Idx = 0; Idx < d_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(d_entryList[Idx]);
			
			if (entry_line != "")
			{
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!d_headerAdded)
				{
					messagebody += "<font color='#aecbeb'>  - Won From Unique Dual:</font><br/>";
					d_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Traverse missable entries array (potentially empty)
		for ( Idx = 0; Idx < b_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(b_entryList[Idx]);
			
			if (entry_line != "")
			{
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!b_headerAdded)
				{
					messagebody += "<font color='#aecbeb'>  - Bought From Vendor:</font><br/>";
					b_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Traverse missable entries array (potentially empty)	
		for ( Idx = 0; Idx < l_entryList.Size(); Idx += 1 ) 
		{
			entry_line = this.GetString(l_entryList[Idx]);
			
			if (entry_line != "")
			{
				// Attempt to add main header if normal array is empty.
				if (!n_headerAdded)
				{
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!l_headerAdded)
				{
					messagebody += "<font color='#aecbeb'>  - Lootable:</font><br/>";
					l_headerAdded = true;
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
					messagebody += header;
					n_headerAdded = true;
				}
				
				if (!m_headerAdded)
				{
					messagebody += "<font color='#D79D3A'>  - Missable:</font><br/>";
					m_headerAdded = true;
				}
				messagebody += entry_line + "<br/>";
			}
		}
		
		// Calculate Totals (Process even if disabled to increment the totals in parent).
		total_count = this.data.Size();
		
		for ( Idx = 0; Idx < this.data.Size(); Idx += 1 ) {
			completed_count += (int) this.storage.IsCompletedOrIgnored(this.data[Idx]);
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
		var localName: 		string = entry_data.getID() + entry_data.localname;
		var isCompleted: 	bool = storage.IsCompleted(entry_data);
		var isIgnored: 		bool = storage.IsIgnored(entry_data);
		var isInProgress: 	bool = storage.IsInProgress(entry_data);
		var entry_line:		string;
		
		// Return empty string as this entry is either completed or ignored and the options to show are diabled.
		if ((isCompleted && !showCompleted) || (isIgnored && !showIgnored))
		{
			return "";
		}
		
		// Return empty string as an area filter is enabled and this entry does not match the area.
		if (this.areaFilter > 0 && entry_data.region != this.areaFilter)
		{
			return "";
		}		

		// Return empty string as a type filter is enabled and this entry does not match that type.
		if (this.typeFilter > 0 && entry_data.filter != this.typeFilter)
		{
			return "";
		}	
		
		entry_line = "<font size='25'>       - " + localName + "</font>";
		
		// Increase line height and add colour for missable quests.
		if (entry_data.is_missable)
		{
			entry_line = "<font color='#D79D3A' size='25'>       - </font>" + "<font size='25'>" + localName + "</font>";
		}
	
		// Apply a coloured 'Bought From Vendor' tag to valid gwent cards.
		if (entry_data.is_missable && entry_data.is_bought) 
		{
			entry_line += entry_data.T_Bought;
		}	

		// Apply a coloured 'Lootable' tag to valid gwent cards.
		if (entry_data.is_missable && entry_data.is_loot) 
		{
			entry_line += entry_data.T_Looted;
		}	

		// Apply a coloured 'Quest Reward' tag to valid gwent cards.
		if (entry_data.is_missable && entry_data.is_reward) 
		{
			entry_line += entry_data.T_Reward;
		}	

		// Apply a coloured 'Won in Dual' tag to valid gwent cards.
		if (entry_data.is_missable && entry_data.is_dual) 
		{
			entry_line += entry_data.T_Dualed;
		}	
		
		// Apply a coloured 'Completed' tag to any completed entries.
		if (isCompleted && showCompleted) 
		{
			entry_line += entry_data.T_Completed;
		}
		
		// Apply a coloured 'Ignored' tag to any ignored entries.
		if (isIgnored && showIgnored) 
		{
			entry_line += entry_data.T_Ignored;
		}
		
		// Return the formatted string back to the builder.
		return entry_line;
	}
}