//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_EventListener
{
	
	public var filename: name; 
		default filename = 'PotP Event Listener';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);

		this.Idle_Main();
	}

//---------------------------------------------------

	entry function Idle_Main() { 
		
		Sleep(FactsQuerySum("ProgressOnThePath_BGProcessing_Qust"));
		
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.GotoState('Checking');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Checking in CProgressOnThePath_EventListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Checking]", , parent.filename);
		
		this.Checking_Main();
	}

//---------------------------------------------------

	entry function Checking_Main()
	{	
		var events_array	: array<PotP_PreviewEntry>;
		var i: int;
		
		events_array = parent.master.PotP_ArrayManager.MasterList_Events;
		
		for ( i = 0; i < events_array.Size(); i += 1 ) 
		{
			if (FactsQuerySum(events_array[i].entryname) > 0) 
			{
				if (parent.master.PotP_PersistentStorage.IsCompletedOrIgnored(events_array[i])) 
				{
					continue;
				}
				parent.master.PotP_PersistentStorage.SetCompleted(events_array[i], , true);
				parent.master.PotP_Notifications.UpdatePlayerFromQuest(events_array[i].localname, 2, false, false);
				PotP_Logger("Completed Random Event [" + events_array[i].entryname + "] -- " + events_array[i].localname, , parent.filename);
			}
		}
		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		parent.GotoState('Idle');
	}
}