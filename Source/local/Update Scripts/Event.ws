//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Event_Updater
{
	var filename: name;
		default filename = 'PotP Event Script';
	
	public var master: CProgressOnThePath;
	public var entity: PotP_PreviewEntry;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Event_Updater
	{
		this.master = master;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('UpdateAll');
	}
	
	//---------------------------------------------------
	
	public function UpdateEvent(entity: PotP_PreviewEntry) : void
	{
		this.entity = entity;
		this.GotoState('Idle');
		this.GotoState('UpdateOne');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state UpdateAll in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [UpdateAll]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.UpdateAll_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function UpdateAll_Main() 
	{
		var master: CProgressOnThePath = parent.master;
		var pData_E: array<PotP_PreviewEntry> = master.PotP_ArrayManager.MasterList_Events;
		var Idx: int;
		
		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{				
			if (pData_E[Idx].IsPlayable() && FactsQuerySum(pData_E[Idx].entryname) > 0) 
			{
				pData_E[Idx].SetCompleted();
				pData_E[Idx].AddToNotificationQueue();
			}
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state UpdateOne in CProgressOnThePath_Event_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [UpdateOne]", , parent.filename);
		
		this.UpdateOne_Entry();
	}

//---------------------------------------------------

	entry function UpdateOne_Entry() 
	{
		this.UpdateOne_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function UpdateOne_Main() 
	{
		var master: CProgressOnThePath = parent.master;
		
		FactsSet(parent.entity.entryname, 1);
		
		parent.entity.SetCompleted();
		parent.entity.AddToBackgroundQueue(2);

		while (PotP_IsPlayerBusy())
		{
			SleepOneFrame();
		}

		master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

quest function PotP_CompleteEvent(fact_name: name, optional fact_name_string: string)
{
	var filename		: name = 'PotP_CompleteEvent';
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;
	
	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(NameToString(fact_name), 1);
		PotP_Logger("Setting Event Fact - " + fact_name, , filename);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_ArrayManager.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// If a match is found, send the entity to the event update class.	
		if (pEvent_List[Idx].entryname == NameToString(fact_name) && pEvent_List[Idx].IsPlayable())
		{
			master.PotP_UpdaterClass.PotP_Event.UpdateEvent(pEvent_List[Idx]);
		}		
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

function PotP_CompleteEventByString(fact_name: string)
{
	var filename		: name = 'PotP_CompleteEventByString';
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;
	
	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(fact_name, 1);
		PotP_Logger("Setting Event Fact - " + fact_name, , filename);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_ArrayManager.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// If a match is found, send the entity to the event update class.	
		if (pEvent_List[Idx].entryname == fact_name && pEvent_List[Idx].IsPlayable())
		{
			master.PotP_UpdaterClass.PotP_Event.UpdateEvent(pEvent_List[Idx]);
		}	
	}
}

//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

quest function PotP_UnlockEvent(UUID: string, Location: string, Fact: string)
{
	var filename		: name = 'PotP_UnlockEvent';
	var PopupMessage	: string = GetLocStringByKeyExt("PotP_NewEventMessage1");
	var pEvent_List		: array<PotP_PreviewEntry>;
	var master			: CProgressOnThePath;
	var Idx				: int = 0;

	// If PotP is not yet initialised, add a fact for the listener to pick up later.
	if (!GetPotP(master, filename))
	{
		FactsSet(Fact + "_unlocked", 1);
		return;
	}
	
	//Assign pEvent_List to the master list of available Events.
	pEvent_List = master.PotP_ArrayManager.MasterList_Events;
	
	//Travserse the available events and find a match for the fact name in the entity.
	for (Idx = 0; Idx < pEvent_List.Size(); Idx += 1)
	{
		// Try to assign the name and location of the unlocked event.
		if (pEvent_List[Idx].uuid == UUID)
		{
			// If the event is already unlocked, return.
			if (pEvent_List[Idx].IsEventUnlocked())
			{
				return;
			}
			
			//Unlock the event.
			pEvent_List[Idx].UnlockEvent();
			
			//Reset Map Pins to show unlocked event on the world map.
			master.PotP_PinManager.GotoState('Updating');
			
			if ( (bool) PotP_GetNotificationValue('ProgressOnThePath_MiscNotification_Event') )
			{
				//Replace the popup message tags with the event name and location.
				PopupMessage = StrReplace(PopupMessage, "[EVENTNAME]", pEvent_List[Idx].localname);
				PopupMessage = StrReplace(PopupMessage, "[EVENTLOCATION]", GetLocStringByKeyExt(Location));
				
				//Add the message to the notification queue for display.
				
				master.PotP_PopupManager.Showpopup(GetLocStringByKeyExt("panel_QT_Name"), PopupMessage, pEvent_List[Idx].entryname, "Hint", false);
			}
		}
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------