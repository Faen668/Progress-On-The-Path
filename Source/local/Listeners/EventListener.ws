//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_EventListener
{
	
	public var filename: name; 
		default filename = 'PotP Event Listener';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
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
		
		Sleep(5);
		
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
		
		events_array = parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events;
		
		for ( i = 0; i < events_array.Size(); i += 1 ) 
		{
			if (FactsQuerySum(events_array[i].entryname) > 0) 
			{
				if (!events_array[i].IsPlayable()) 
				{
					continue;
				}
				
				PotP_CompleteEventByString(events_array[i].entryname);
			}
		}
		parent.GotoState('Idle');
	}
}

