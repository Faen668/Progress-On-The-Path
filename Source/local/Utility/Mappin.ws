//---------------------------------------------------
//-- Main Mod Class ---------------------------------
//---------------------------------------------------

class CProgressOnThePath_RemoveAllMapPins extends SU_PredicateInterfaceRemovePin 
{
	function predicate(pin: SU_MapPin): bool {
		return StrStartsWith(pin.tag, "PotP_");
	}
}

statemachine class CProgressOnThePath_MapPins extends SU_MapPin {

	public var fileName: name;
		default fileName = 'PotP Map Pin Manager';

	public var master: CProgressOnThePath;
	public var builder: SU_MapPinsBuilder;

	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
	}

	//---------------------------------------------------
	
	public function InitialiseBuilder() 
	{
		builder = new SU_MapPinsBuilder in thePlayer;
	}

	//---------------------------------------------------
	
	public function Build() 
	{
		builder.build();
	}
	
	//---------------------------------------------------
	
	public function RefreshPin(entry_data: PotP_PreviewEntry)
	{
		if (!entry_data.IsEventUnlocked() || !entry_data.IsPlayable())
		{
			return;
		}
		
		builder.tag_prefix("PotP_")
		.pin()
			.tag				(entry_data.uuid)
			.label				(GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Name"))
			.description		(this.GetPinDesc(entry_data.GetEventDescription()))
			.type				(this.GetPinType())
			.filtered_type		("QuestVermentino")
			.radius				(this.GetPinSize())
			.position			(entry_data.position)
			.region 			(entry_data.region_string)
			.is_quest			(false)
			.appears_on_minimap	(false)
			.pointed_by_arrow	(false)
			.highlighted		(false)
		.add();
	}

	//---------------------------------------------------
	
	public function GetPinType() : string {
		
		switch ( (int) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinType') ) {

			case 0:
				return "QuestAvailable";
				
			case 1:
				return "QuestAvailableHoS";
			
			case 2:
				return "QuestAvailableBaW";

			case 3:
				return "StoryQuest";
				
			case 4:
				return "NotDiscoveredPOI";
				
			default:
				return "QuestAvailableHoS";
		}
	}

	//---------------------------------------------------
	
	public function GetPinShow() : bool {
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ShowMapPins');
	}
	
	//---------------------------------------------------
	
	public function GetPinSize() : int {
		return (int) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinRadius');
	}
	
	//---------------------------------------------------
	
	public function GetPinDesc(description: string) : string {
	
		switch ( (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_MapPinDescription') )
		{
			case true:
				return description;
				
			default: 
				return GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Description");
		}
	}
}

//---------------------------------------------------
//-- Disabled State ---------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.fileName);
	}
}

//---------------------------------------------------
//-- Idle State -------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.fileName);
		
		this.Idle_Main();
	}

//---------------------------------------------------

	entry function Idle_Main() 
	{			
		while (PotP_IsPlayerBusy())
		{
			Sleep(3);
		}
		parent.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- Waiting State ----------------------------------
//---------------------------------------------------

state Waiting in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Waiting]", , parent.fileName);
		
		this.Waiting_Main();
	}

//---------------------------------------------------

	entry function Waiting_Main() 
	{	
		this.Waiting_MonitorForChanges();
	}
	
	latent function Waiting_MonitorForChanges() 
	{
		
		var _GetPinShow: bool 		= parent.GetPinShow();
		var _GetPinDesc: string		= parent.GetPinDesc("_");
		var _GetPinSize: int		= parent.GetPinSize();
		var _GetPinType: string		= parent.GetPinType();

		while( true ) 
		{
			if ( _GetPinShow == parent.GetPinShow() && _GetPinDesc == parent.GetPinDesc("_") && _GetPinSize == parent.GetPinSize() && _GetPinType == parent.GetPinType() )
			{
				Sleep(5);
			}
			else
			{
				while( PotP_IsPlayerBusy() ) 
				{
					SleepOneFrame();
				}
				parent.GotoState('Updating');
				break;
			}
		}
	}
}

//---------------------------------------------------
//-- Tracker Update State ---------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_MapPins 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.fileName);
		this.Updating_MapPins_Main();
	}	

	//---------------------------------------------------

	entry function Updating_MapPins_Main() { 
		
		var predicate: CProgressOnThePath_RemoveAllMapPins;
		var Idx: int;

		if (!parent.GetPinShow()) {
			predicate = new CProgressOnThePath_RemoveAllMapPins in thePlayer;
			SU_removeCustomPinByPredicate(predicate);
			parent.GotoState('Waiting');
			return;
		}
		
		parent.InitialiseBuilder();
		
		for (Idx = 0; Idx < parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(); Idx += 1)  {
			parent.RefreshPin(parent.master.PotP_PersistentStorage.pEventStorage.MasterList_Events[Idx]);
		}
		
		parent.Build();	
		parent.GotoState('Waiting');
	}
}

