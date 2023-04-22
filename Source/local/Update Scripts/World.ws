//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_World_Updater extends CEntity
{
	var filename: name;
		default filename = 'PotP World Script';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_World_Updater
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
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_World_Updater 
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

state Updating in CProgressOnThePath_World_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.Updating_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function Updating_Main() 
	{	
		var MapManager	: CCommonMapManager = theGame.GetCommonMapManager();
		var pData_E		: array<PotP_PreviewEntry> = parent.master.PotP_PersistentStorage.pWorldStorage.MasterList_World;
		var Idx			: int;

		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 ) {

			if (this.IsMapPinEligible(pData_E[Idx], MapManager)) {
				pData_E[Idx].SetCompleted(pData_E[Idx]);
				pData_E[Idx].AddToNotificationQueue();
			}
		}	
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

