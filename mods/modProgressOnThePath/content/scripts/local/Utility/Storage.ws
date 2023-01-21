//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
class CProgressOnThePath_Storage
{
	public var fileName: name;
		default fileName = 'PotP Storage';
	
	public var master: CProgressOnThePath;
 	
	var MasterList_Completed_V: array<name>;
	var MasterList_InProgres_V: array<name>;
	var MasterList_IsIgnored_V: array<name>;
	var MasterList_Collected_V: array<name>;
	var MasterList_EventList_V: array<name>;
	
	//---------------------------------------------------

	public function init(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Storage
	{
		this.master = PotP_BaseClass;
		return this;
	}
	
	//---------------------------------------------------
	
	public function IsCompleted(entry_data: PotP_PreviewEntry) : bool
	{
		return this.MasterList_Completed_V.FindFirst(entry_data.uuid) != -1;
	}
	
	//---------------------------------------------------
	
	public function IsIgnored(entry_data: PotP_PreviewEntry) : bool
	{
		return this.MasterList_IsIgnored_V.FindFirst(entry_data.uuid) != -1;
	}
	
	//---------------------------------------------------
	
	public function IsInProgress(entry_data: PotP_PreviewEntry) : bool
	{
		return this.MasterList_InProgres_V.FindFirst(entry_data.uuid) != -1;
	}
	
	//---------------------------------------------------
	
	public function IsCollected(entry_data: PotP_PreviewEntry) : bool
	{
		return this.MasterList_Collected_V.FindFirst(entry_data.uuid) != -1;
	}

	//---------------------------------------------------
	
	public function IsCompletedOrIgnored(entry_data: PotP_PreviewEntry) : bool
	{
		return this.MasterList_Completed_V.FindFirst(entry_data.uuid) != -1
			|| this.MasterList_IsIgnored_V.FindFirst(entry_data.uuid) != -1;
			
	}	
	
	//---------------------------------------------------
	
	public function RemoveIgnored(entry_data: PotP_PreviewEntry) : void
	{
		var Idx: int = MasterList_IsIgnored_V.FindFirst(entry_data.uuid);
		
		if (Idx != -1)
		{ 
			MasterList_IsIgnored_V.EraseFast(Idx);
		}
	}
	
	//---------------------------------------------------
	
	public function RemoveCompleted(entry_data: PotP_PreviewEntry, optional collected: bool) : void
	{
		var Idx: int = MasterList_Completed_V.FindFirst(entry_data.uuid);
		var x: int = MasterList_Collected_V.FindFirst(entry_data.uuid);
	
		if (Idx != -1)
		{
			MasterList_Completed_V.EraseFast(Idx);
			PotP_Logger("Removed - " + entry_data.localname + " from persistent storage list 'Completed'", false);
		}

		if (collected && x != -1)
		{
			MasterList_Collected_V.EraseFast(x);
			PotP_Logger("Removed - " + entry_data.localname + " from persistent storage list 'Collected'", false);
		}
	}
	
	//---------------------------------------------------
	
	public function RemoveInProgress(entry_data: PotP_PreviewEntry) : void
	{
		var Idx: int = MasterList_InProgres_V.FindFirst(entry_data.uuid);
		
		if (Idx != -1)
		{ 
			MasterList_InProgres_V.EraseFast(Idx);
		}
	}
	
	//---------------------------------------------------
	
	public function SetCompleted(entry_data: PotP_PreviewEntry, optional is_collected: bool, optional is_event: bool) : void
	{
		
		if (!IsCompleted(entry_data)) 
		{
			MasterList_Completed_V.PushBack(entry_data.uuid);
			PotP_Logger("Added - " + entry_data.localname + " to persistent storage list 'Completed'", , this.fileName);
		}

		if (is_collected && !IsCollected(entry_data)) 
		{
			MasterList_Collected_V.PushBack(entry_data.uuid);
			PotP_Logger("Added - " + entry_data.localname + " to persistent storage list 'Collected'", , this.fileName);
		}

		if (is_event) 
		{
			MasterList_EventList_V.PushBack(entry_data.uuid);
			this.master.PotP_PinManager.RemovePin(entry_data);
		}		
		
		this.RemoveInProgress(entry_data);
		this.RemoveIgnored(entry_data);
	}		

	//---------------------------------------------------
	
	public function SetInProgress(entry_data: PotP_PreviewEntry) : void
	{
		if (!IsInProgress(entry_data)) 
		{
			MasterList_InProgres_V.PushBack(entry_data.uuid);
			PotP_Logger("Added - " + entry_data.localname + " to persistent storage list 'In Progress'", , this.fileName);
		}
			
		this.RemoveCompleted(entry_data);
		this.RemoveIgnored(entry_data);
	}

	//---------------------------------------------------
	
	public function SetIgnored(entry_data: PotP_PreviewEntry, optional remove_pin: bool) : void
	{
		if (!IsIgnored(entry_data)) 
		{
			this.MasterList_IsIgnored_V.PushBack(entry_data.uuid);
			PotP_Logger("Added - " + entry_data.localname + " to persistent storage list 'Ignored'", , this.fileName);
		}

		if (remove_pin) 
		{
			this.master.PotP_PinManager.RemovePin(entry_data);
		}
			
		this.RemoveInProgress(entry_data);
		this.RemoveCompleted(entry_data);
	}

	//---------------------------------------------------
	
	public function SetAvailable(entry_data: PotP_PreviewEntry, optional collected: bool, optional add_pin: bool) : void
	{
		RemoveCompleted(entry_data, collected);
		RemoveIgnored(entry_data);

		if (add_pin) 
		{
			this.master.PotP_PinManager.GotoState('Updating');
		}
	}
	
	//---------------------------------------------------
	
	public function UpdateQuestEntry(entry_data: PotP_PreviewEntry, status: int) : bool 
	{	
		switch (status) 
		{	
		case JS_Success:
		case JS_Failed:
			if (!IsCompleted(entry_data)) { SetCompleted(entry_data); return true; }
			return false;

		case JS_Active:		
			if (!IsInProgress(entry_data)) { SetInProgress(entry_data); return true; }
			return false;
					
		default: 
			return false;
		}
	}
}

//---------------------------------------------------
//-- Settings Access Functions ----------------------
//---------------------------------------------------

function PotP_GetGeneralValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_GeneralSettings', variable);
}

function PotP_GetPreviewValue(variable: name) : string
{
	return theGame.GetInGameConfigWrapper().GetVarValue('ProgressOnThePath_PreviewSettings', variable);
}

//---------------------------------------------------
//-- Console Functions For Quest Update -------------
//---------------------------------------------------

enum pStatus
{
	completed = 2,
	ignored = 1,
}

exec function pt_changestatus(identifier: string, optional value: pStatus) 
{
	var master: CProgressOnThePath;
	var is_collectable: bool;
	var is_random_event: bool;
	
	var EntList: array<PotP_PreviewEntry>;
	var IdeList: array<string>;
	var VarList: array<name>;
	var Idx: int;

	if (!GetPotP(master, "Storage")) { return; }

	EntList = master.PotP_ArrayManager.TotalEntList;
	VarList = master.PotP_ArrayManager.TotalVarList;	
	IdeList = master.PotP_ArrayManager.TotalIdeList;
	Idx = IdeList.FindFirst(identifier);
	
	if (Idx == -1) { return; }
	
	is_collectable 	= master.PotP_ArrayManager.MasterList_Items_Lookup.FindFirst(VarList[Idx]) != -1;
	is_random_event = master.PotP_ArrayManager.MasterList_Events_Lookup.FindFirst(VarList[Idx]) != -1;
	
	
	switch (value) 
	{
	case completed:	
		if (is_random_event)
		{
			PotP_CompleteEvent(EntList[Idx].uuid, true);
			break;
		}
		
		master.PotP_PersistentStorage.SetCompleted(EntList[Idx], is_collectable, is_random_event);
		break;
		
	case ignored:
		if (is_random_event)
		{
			PotP_CompleteEvent(EntList[Idx].uuid, true);
			break;
		}
		
		master.PotP_PersistentStorage.SetIgnored(EntList[Idx], is_random_event);
		break;
		
	default:
		master.PotP_PersistentStorage.SetAvailable(EntList[Idx], is_collectable, is_random_event);
		break;
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------