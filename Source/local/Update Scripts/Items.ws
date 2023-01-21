//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Relic_Updater {

	var filename: name;
		default filename = 'PotP Items Script';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Relic_Updater
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
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Relic_Updater 
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

state Updating in CProgressOnThePath_Relic_Updater 
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
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		var pData_E: array<PotP_PreviewEntry> 	= parent.master.PotP_ArrayManager.MasterList_Items;
		var dup_arr: array< name >;
		var Idx: int;
		
		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{
			PotP_GetAllVariations(pData_E[Idx].item_name, pData_E[Idx].group, dup_arr);
			
			if (pData_E[Idx].arrayType == PotP_A_Gwent)
			{
				if (!GwentManager.HasLootedCard() || (pData_E[Idx].filter == PotP_I_Skell && !GwentManager.IsDeckUnlocked(GwintFaction_Skellige)))
				{
					continue;
				}
				
				if (this.IsCardCollected(dup_arr, pData_E[Idx]) && !parent.master.PotP_PersistentStorage.IsCompletedOrIgnored(pData_E[Idx]))
				{
					parent.master.PotP_PersistentStorage.SetCompleted(pData_E[Idx]);
					parent.master.PotP_Notifications.UpdateItemCounter(1, pData_E[Idx].group);
				}
				continue;
			}
			
			if (this.IsItemCollected(dup_arr, pData_E[Idx]) && !parent.master.PotP_PersistentStorage.IsCompletedOrIgnored(pData_E[Idx]))
			{
				parent.master.PotP_PersistentStorage.SetCompleted(pData_E[Idx], true);
				parent.master.PotP_Notifications.UpdateItemCounter(1, pData_E[Idx].group);
			}
		}
	}

//---------------------------------------------------

	private function IsItemCollected(VariationsArray: array< name >, pData_E: PotP_PreviewEntry) : bool 
	{
		var PInventory: CInventoryComponent = thePlayer.GetInventory();
		var SInventory: CInventoryComponent = GetWitcherPlayer().GetHorseManager().GetInventoryComponent();
		var Idx, min, max: int;
		
		for (Idx = 0; Idx < VariationsArray.Size(); Idx += 1) 
		{
			PInventory.GetItemQualityFromName(VariationsArray[Idx], min, max);

			if (min >= 4 && (parent.master.PotP_PersistentStorage.IsCollected(pData_E) || PInventory.HasItem(VariationsArray[Idx]) || SInventory.HasItem(VariationsArray[Idx]) || GetWitcherPlayer().GetHorseManager().IsItemEquippedByName(VariationsArray[Idx])))
			{ 
				return true;
			}
		}
		return false;
	}

//---------------------------------------------------

	private function IsCardCollected(VariationsArray: array< name >, pData_E: PotP_PreviewEntry) : bool {
		
		var Idx: int;

		if ( pData_E.item_name == 'BASEDECK' || thePlayer.GetInventory().HasItem(pData_E.item_name) )
		{ 
			return true; 
		}
		
		for ( Idx = 0; Idx < VariationsArray.Size(); Idx += 1 )
		{
			if ( thePlayer.GetInventory().HasItem(VariationsArray[Idx]) ) 
			{
				return true;
			} 
		}
		return false;
	}
}		

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------