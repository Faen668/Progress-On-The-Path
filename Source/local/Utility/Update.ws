//---------------------------------------------------
//-- Updater Class ----------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_UpdaterClass
{
	public var filename: name; 
		default filename = 'PotP Update';
		
	public var SleepBeforeMeditation: float;
		default SleepBeforeMeditation = 0;

	public var PotP_Quest: CProgressOnThePath_Quest_Updater;
	public var PotP_Event: CProgressOnThePath_Event_Updater;
	public var PotP_World: CProgressOnThePath_World_Updater;	
	public var PotP_Items: CProgressOnThePath_Relic_Updater;
	
	public var master: CProgressOnThePath;
	
//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) 
	{
		this.master = PotP_BaseClass;
		
		this.PotP_Quest = (new CProgressOnThePath_Quest_Updater in this).initialise(PotP_BaseClass);
		this.PotP_Event = (new CProgressOnThePath_Event_Updater in this).initialise(PotP_BaseClass);
		this.PotP_World = (new CProgressOnThePath_World_Updater in this).initialise(PotP_BaseClass);
		this.PotP_Items = (new CProgressOnThePath_Relic_Updater in this).initialise(PotP_BaseClass);
	}
	
//---------------------------------------------------

	public function StartUpdate(optional delay: bool) 
	{
		SleepBeforeMeditation = this.ValidateSleepTime(PotP_UsingW3EE(), PotP_UsingFriendlyMeditation(), delay);
		this.GotoState('Updating');
	}

	//---------------------------------------------------
	
	private function ValidateSleepTime(W3EE: bool, FM: bool, Delay: bool) : float 
	{
		if (Delay) 
		{ 
			return 0.16f; 
		} 
		
		if ((W3EE || FM) && PotP_PlayerIsMeditating()) 
		{
			return 2.75f;
		} 
		return 0;
	}
}

//---------------------------------------------------
//-- Tracker Idle State -----------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_UpdaterClass 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}
	
//---------------------------------------------------
//-- Tracker Update State ---------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_UpdaterClass 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		this.Updating_Main();
	}	

//---------------------------------------------------

	entry function Updating_Main() 
	{
		Sleep(parent.SleepBeforeMeditation);
		
		while (PotP_IsPlayerBusy())
		{
			SleepOneFrame();
		}
		
		parent.master.PotP_Notifications.ResetTrackerUpdateArray();
		
		parent.PotP_Quest.Update();
		parent.PotP_Event.Update();
		parent.PotP_World.Update();
		parent.PotP_Items.Update();
		
		parent.master.PotP_Notifications.DisplayNotification();
		parent.GotoState('Idle');
	}
}

