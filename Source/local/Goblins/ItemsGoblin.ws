//
// Progress on the Path - TW3 Progress Tracker
// Script by K1ngTr4cker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_ItemsGoblin extends IInventoryScriptedListener
{
	public var filename: name; 
		default filename = 'PotP Item Goblin';
	
	public var last_addition_time: float;
	public var itm_array: array<SItemUniqueId>;
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
		thePlayer.inv.AddListener(this);
	}
	
	event OnInventoryScriptedEvent( eventType : EInventoryEventType, itemId : SItemUniqueId, quantity : int, fromAssociatedInventory : bool ) 
	{
		if (eventType != IET_ItemAdded) 
		{
			return true;
		}
		
		PotP_Logger("Recieved " + quantity + " " +  thePlayer.inv.GetItemName(itemId), , this.filename);
		
		this.itm_array.PushBack(itemId);
		this.last_addition_time = theGame.GetEngineTimeAsSeconds();
		this.GotoState('Idle');
		this.GotoState('ItemAdded');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_ItemsGoblin 
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

state ItemAdded in CProgressOnThePath_ItemsGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [ItemAdded]", , parent.filename);
	
		this.ItemAdded_Entry();
	}

//---------------------------------------------------

	entry function ItemAdded_Entry() {
		
		var current_time: float = theGame.GetEngineTimeAsSeconds();
		var sleep_time: int = (int) PotP_GetGeneralValue('ProgressOnThePath_BGProcessing_Item');
		
		while ((current_time - parent.last_addition_time < sleep_time) || PotP_IsPlayerBusy()) 
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			SleepOneFrame();
		}
		
		this.ItemAdded_Main();
	}

//---------------------------------------------------
	
	latent function ItemAdded_Main() {
		
		var PInventory: CInventoryComponent = thePlayer.GetInventory();
		var VariationsArray: array< name >;
		var Idx: int;
		
		while (PotP_IsPlayerBusy()) {
			SleepOneFrame();
		}
		
		for ( Idx = 0; Idx < parent.itm_array.Size(); Idx += 1 ) 
		{
			PotP_GetAllVariations(PInventory.GetItemName(parent.itm_array[Idx]), 'Goblin', VariationsArray);	
			this.ProcessVariationsArray(VariationsArray, parent.itm_array[Idx], Idx, PInventory.ItemHasTag(parent.itm_array[Idx], theGame.params.GWINT_CARD_ACHIEVEMENT_TAG), PInventory);
		}

		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}

		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	private function ProcessVariationsArray(VariationsArray: array<name>, BaseItem: SItemUniqueId, pIndex: int, IsGwentCard: bool, PInventory: CInventoryComponent) 
	{
		var Idx, x, min, max: int;
		
		for (Idx = 0; Idx < VariationsArray.Size(); Idx += 1) 
		{
			PInventory.GetItemQualityFromName(VariationsArray[Idx], min, max);
			
			if (min > 3 || IsGwentCard) 
			{
				x = parent.master.PotP_ArrayManager.MasterList_Items_Lookup.FindFirst(VariationsArray[Idx]);
				if (x != -1) 
				{ 
					this._ProcessItem(BaseItem, IsGwentCard, parent.master.PotP_ArrayManager.MasterList_Items[x]); 
				}
				parent.itm_array.Erase( pIndex );
			}
			parent.itm_array.Erase( pIndex );
		}
	}

//---------------------------------------------------
	
	private function _ProcessItem(BaseItem: SItemUniqueId, IsGwentCard: bool, entry_data: PotP_PreviewEntry) {	

		var localizedName: string = GetLocStringByKeyExt(thePlayer.GetInventory().GetItemLocalizedNameByUniqueID(BaseItem));
		
		if (parent.master.PotP_PersistentStorage.IsCollected(entry_data))
		{
			return;
		}
		
		parent.master.PotP_Notifications.UpdatePlayerFromPickUp(BaseItem, localizedName);
		parent.master.PotP_PersistentStorage.SetCompleted(entry_data, true);
	}
}