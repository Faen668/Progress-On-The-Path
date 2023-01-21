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
	public var EventIdentifier: name;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Event_Updater
	{
		this.master = PotP_BaseClass;
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
	
	public function UpdateEvent(EventIdentifier: name) : void
	{
		this.EventIdentifier = EventIdentifier;
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
			if (master.PotP_PersistentStorage.IsCompletedOrIgnored(pData_E[Idx])) {
				continue;
			}
			
			if (FactsQuerySum(pData_E[Idx].entryname) > 0) 
			{
				master.PotP_PersistentStorage.SetCompleted(pData_E[Idx], , true);
				master.PotP_Notifications.UpdateQuestCounter(1, pData_E[Idx].group, false, false);
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
		var pEvent: PotP_PreviewEntry;
		
		var Idx: int  = master.PotP_ArrayManager.TotalVarList.FindFirst(parent.EventIdentifier);

		if (Idx != -1)
		{
			pEvent = master.PotP_ArrayManager.TotalEntList[Idx];
			master.PotP_PersistentStorage.SetCompleted(pEvent, , true);		
			master.PotP_Notifications.UpdatePlayerFromQuest(pEvent.localname, 2, false, false);
			
			PotP_Logger("Completed Event " + pEvent.localname, , parent.filename);
			
			while (PotP_IsPlayerBusy())
			{
				SleepOneFrame();
			}
			master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		}
	}
}

quest function PotP_CompleteEvent( EventIdentifier : name, IsCompleted: bool )
{
	var master: CProgressOnThePath;
	
	if (!GetPotP(master, 'PotP_CompleteEvent') || !IsCompleted) {
		return;
	}
	
	master.PotP_UpdaterClass.PotP_Event.UpdateEvent(EventIdentifier);
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------