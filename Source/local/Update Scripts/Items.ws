//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Relic_Updater {

	var filename: name;
		default filename = 'PotP Items Script';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Relic_Updater
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
		var Idx: int;
		
		for ( Idx = 0; Idx < pData_E.Size(); Idx += 1 )
		{			
			if (pData_E[Idx].arrayType == PotP_A_Gwent)
			{
				if (!GwentManager.HasLootedCard() || (pData_E[Idx].filter == PotP_I_Skell && !GwentManager.IsDeckUnlocked(GwintFaction_Skellige)))
				{
					continue;
				}
				
				if (this.IsCardCollected(pData_E[Idx]) && pData_E[Idx].IsPlayable())
				{
					pData_E[Idx].SetCompleted();
					pData_E[Idx].AddToNotificationQueue();
				}
				continue;
			}
			
			if (this.IsItemCollected(pData_E[Idx]) && pData_E[Idx].IsPlayable())
			{
				pData_E[Idx].SetCompleted();
				pData_E[Idx].AddToNotificationQueue();
			}
		}
	}

//---------------------------------------------------

	private function IsItemCollected(pData_E: PotP_PreviewEntry) : bool 
	{
		var PInventory: CInventoryComponent = thePlayer.GetInventory();
		var SInventory: CInventoryComponent = GetWitcherPlayer().GetHorseManager().GetInventoryComponent();
		var Idx, min, max: int;
		
		for (Idx = 0; Idx < pData_E.variations.Size(); Idx += 1) 
		{
			PInventory.GetItemQualityFromName(pData_E.variations[Idx], min, max);

			if (min >= 4 && (pData_E.IsCollected() || PInventory.HasItem(pData_E.variations[Idx]) || SInventory.HasItem(pData_E.variations[Idx]) || GetWitcherPlayer().GetHorseManager().IsItemEquippedByName(pData_E.variations[Idx])))
			{ 
				return true;
			}
		}
		return false;
	}

//---------------------------------------------------

	private function IsCardCollected(pData_E: PotP_PreviewEntry) : bool {
		
		var Idx: int;

		if ( pData_E.item_name == 'BASEDECK' || thePlayer.GetInventory().HasItem(pData_E.item_name) )
		{ 
			return true; 
		}
		
		for ( Idx = 0; Idx < pData_E.variations.Size(); Idx += 1 )
		{
			if ( thePlayer.GetInventory().HasItem(pData_E.variations[Idx]) ) 
			{
				return true;
			} 
		}
		return false;
	}
}		

