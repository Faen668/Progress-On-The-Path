//
// Progress on the Path - TW3 Progress Tracker
// Script by K1ngTr4cker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_WorldGoblin
{
	public var filename: name; 
		default filename = 'PotP World Goblin';
	
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

state Disabled in CProgressOnThePath_WorldGoblin 
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

state Idle in CProgressOnThePath_WorldGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);

		this.Idle_Entry();
	}

//---------------------------------------------------

	entry function Idle_Entry() {

		Sleep( 5 );

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

state Checking in CProgressOnThePath_WorldGoblin 
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
		var MapManager: CCommonMapManager = theGame.GetCommonMapManager();		
		var pData_E: array<PotP_PreviewEntry> = parent.master.PotP_ArrayManager.MasterList_World;		
		var Idx: int;

		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{
			if (this.IsMapPinEligible(pData_E[Idx], MapManager)) {
				pData_E[Idx].SetCompleted();
				pData_E[Idx].AddToBackgroundQueue();
			}
		}
		
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	private function IsMapPinEligible(entry_data: PotP_PreviewEntry, MapManager: CCommonMapManager) : bool {
		
		if (!entry_data.IsPlayable())
		{
			return false;
		}

		if (entry_data.pin_name == 'ep1_poi09_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi09_mp_bugfix');
		}

		if (entry_data.pin_name == 'ep1_poi23_mp') {
			return MapManager.IsEntityMapPinDisabled(entry_data.pin_name) || MapManager.IsEntityMapPinDisabled('ep1_poi23_mp_bugfix');
		}
		
		if (entry_data.filter == PotP_I_Signs) {
			return MapManager.IsEntityMapPinDiscovered(entry_data.pin_name);
		}
		
		return MapManager.IsEntityMapPinDisabled(entry_data.pin_name);
	}
}