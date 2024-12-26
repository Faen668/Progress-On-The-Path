//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_MeditationListener {

	public var filename: name; 
	default filename = 'PotP Meditation Listener';
	
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

state Disabled in CProgressOnThePath_MeditationListener 
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

state Idle in CProgressOnThePath_MeditationListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		this.Idle_Entry();
	}

//---------------------------------------------------

	entry function Idle_Entry() 
	{        
		while (!PotP_PlayerIsMeditating()) 
		{
			SleepOneFrame();
		}
		
		parent.GotoState('Update');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Update in CProgressOnThePath_MeditationListener 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Update]", , parent.filename);
		
		this.Update_Entry();
	}

//---------------------------------------------------

	entry function Update_Entry() 
	{		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_MeditationUpdate') )
		{
			parent.master.PotP_UpdaterClass.StartUpdate(true);
		}
		
        while (PotP_PlayerIsMeditating()) 
		{
			SleepOneFrame();
		}
		parent.GotoState('Idle');
	}
}

