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

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}

	//---------------------------------------------------
	
	public function InitialiseBuilder() {
		builder = new SU_MapPinsBuilder in thePlayer;
	}

	//---------------------------------------------------
	
	public function Build() {
		builder.build();
	}

	//---------------------------------------------------
	
	public function RefreshPin(entry_data: PotP_PreviewEntry) {
		
		if (!this.ShouldDisplayPin(entry_data)) {
			return;
		}
		
		builder.tag_prefix("PotP_")
		.pin()
			.tag				(entry_data.uuid)
			.label				(GetLocStringByKeyExt("ProgressOnThePath_Default_MapPin_Name"))
			.description		(this.GetPinDesc(entry_data.description))
			.type				(this.GetPinType())
			.filtered_type		("QuestVermentino")
			.radius				(this.GetPinSize())
			.position			(entry_data.position)
			.region 			(entry_data.region_string)
			.is_quest			(false)
			.appears_on_minimap	(this.GetPinMini())
			.pointed_by_arrow	(this.GetPinPointed())
			.highlighted		(this.GetHighlighted())
		.add();
		PotP_Logger("Progress On The Path: Added Map Pin: " + entry_data.uuid, , this.fileName);
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
	
	public function GetPinMini() : bool {
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ShowMiniMap');
	}

	//---------------------------------------------------
	
	public function GetPinPointed() : bool {
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ShowMiniMap')
			&& (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ArrowPointers');
	}

	//---------------------------------------------------
	
	public function GetHighlighted() : bool {
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ShowMiniMap')
			&& (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_ArrowPointers')
			&& (bool) PotP_GetGeneralValue('ProgressOnThePath_EventMapPins_HighlightedPointers');
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
	
	//---------------------------------------------------
	
	public function RemovePin(entry_data: PotP_PreviewEntry) {

		SU_removeCustomPinByTag("PotP_" + entry_data.uuid);
		PotP_Logger("Progress On The Path: Removed Map Pin: " + entry_data.localname, , this.fileName);
	}
	
	//---------------------------------------------------
	
	public function ShouldDisplayPin(entry_data: PotP_PreviewEntry) : bool {
		
		if (this.master.PotP_PersistentStorage.IsCompletedOrIgnored(entry_data)) {
			return false;
		}

		switch (entry_data.entryname) {

		   /*
		   * Deadly Crossing (Lindenvale)
		   * This Event will trigger after the nilfgaardian soldiers are dead #75
		   */			
			case "PotP_Event_DeadlyCrossing_1_NG":
				return FactsQuerySum("PotP_Event_DeadlyCrossing_1_NG_Available") > 0;
			
		   /*
		   * Racists of Novigrad (Farcorners)
		   * This Event will trigger after 'Racists of Novigrad (Harborside) is completed.
		   */	
			case "PotP_Event_RacistsOfNovigradFC_NG":
				return FactsQuerySum("PotP_Event_RacistsOfNovigradHS_NG") > 0;

		   /*
		   * Karmic Justice
		   * This Event will trigger after 'Racists of Novigrad (Harborside) is completed.
		   */	
			case "PotP_Event_KarmicJustice_NG":
				return FactsQuerySum("PotP_Event_RacistsOfNovigradHS_NG") > 0;

		   /*
		   * Suspicious Shakedown
		   * This Event will trigger after meeting the King of Beggars during 'Pyres of Novigrad'.
		   */					
			case "PotP_Event_SuspiciousShakedown_NG":
				return FactsQuerySum("q301_met_kob") > 0;

		   /*
		   * Withhunter Raids
		   * This Event will trigger after meeting the King of Beggars during 'Pyres of Novigrad'.
		   */
			case "PotP_Event_WitchHunterRaids_NG":
				return FactsQuerySum("q301_met_kob") > 0;

		   /*
		   * At the Mercy of Strangers (Follow up if rescued)
		   * This Event will trigger after rescuing John and entering the area over the pontar.
		   */
			case "PotP_Event_AtTheMercyOfStrangers_2_NG":
				return FactsQuerySum("PotP_Event_AtTheMercyOfStrangers_2_NG_Available") > 0;

		   /*
		   * The Flame of Hatred (Ambush)
		   * This Event will trigger after either insulting or threatening the priest, wait 2 days to trigger.
		   */				
			case "PotP_Event_TheFlameOfHatred_NG_2":
				return FactsQuerySum("PotP_Event_TheFlameOfHatred_NG_2_Available") > 0;

		   /*
		   * The Price of Passage 2
		   * This Event will trigger after paying and not refusing the guards during phase 1.
		   */
			case "PotP_Event_ThePriceOfPassage_NG_2":
				return FactsQuerySum("PotP_Event_ThePriceOfPassage_NG_2_Available") > 0;

		   /*
		   * The Price of Passage 3
		   * This Event will trigger after refusing to pay the guards during phase 1 or phase 2.
		   */
			case "PotP_Event_ThePriceOfPassage_NG_3":
				return FactsQuerySum("PotP_Event_ThePriceOfPassage_NG_3_Available") > 0;

		   /*
		   * Caravan Attack 2 (Follow up in Crow's Perch)
		   * This Event will trigger after 1 week of helping the merchants ward off the bandits.
		   */
			case "PotP_Event_CaravanAttack_NG_2":
				return FactsQuerySum("PotP_Event_CaravanAttack_NG_2_Available") > 0;

		   /*
		   * Face me if you Dare 2!
		   * This Event will trigger after 2 days of defeating Ronvid for the first time.
		   */
			case "PotP_Event_FaceMeIfYouDare_2_NG":
				return FactsQuerySum("PotP_Event_FaceMeIfYouDare_2_NG_Available") > 0;

		   /*
		   * Face me if you Dare 3!
		   * This Event will trigger after 2 days of defeating Ronvid for the second time.
		   */
			case "PotP_Event_FaceMeIfYouDare_3_NG":
				return FactsQuerySum("PotP_Event_FaceMeIfYouDare_3_NG_Available") > 0;

		   /*
		   * No Triggers
		   * Most Events will trigger automatically with no conditions set.
		   */				
			default:
				return true;
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
	
	latent function Waiting_MonitorForChanges() {
		
		var _GetPinShow: bool 		= parent.GetPinShow();
		var _GetPinDesc: string		= parent.GetPinDesc("_");
		var _GetPinSize: int		= parent.GetPinSize();
		var _GetPinType: string		= parent.GetPinType();
		
		var _GetPinMini: bool 		= parent.GetPinMini();
		var _GetPinPointed: bool 	= parent.GetPinPointed();
		var _GetHighlighted: bool	= parent.GetHighlighted();

		while (true) {
		
			if (_GetPinShow == parent.GetPinShow()
			&& _GetPinDesc == parent.GetPinDesc("_")
			&& _GetPinSize == parent.GetPinSize()
			&& _GetPinType == parent.GetPinType()
			&& _GetPinMini == parent.GetPinMini()
			&& _GetPinPointed == parent.GetPinPointed()
			&& _GetHighlighted == parent.GetHighlighted()) 
			{
				Sleep(5);
			}
			else
			{
				while (PotP_IsPlayerBusy()) {
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
		
		for (Idx = 0; Idx < parent.master.PotP_ArrayManager.MasterList_Events.Size(); Idx += 1)  {
			parent.RefreshPin(parent.master.PotP_ArrayManager.MasterList_Events[Idx]);
		}
		
		parent.Build();
		parent.GotoState('Waiting');
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_pos() 
{
	GetWitcherPlayer().DisplayHudMessage(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));
	LogChannel('PotP Position', VecToString(thePlayer.GetWorldPosition()));
}