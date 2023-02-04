//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_ItemsGoblin extends IInventoryScriptedListener
{
	public var filename: name; 
		default filename = 'PotP Item Goblin';
	
	public var ent_list: array<PotP_PreviewEntry>;
	public var itm_list: array<name>;

	public var player_inv: CInventoryComponent;
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var last_addition_time: float;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
		this.storage = master.PotP_PersistentStorage;
		
		this.itm_list = master.PotP_ArrayManager.SupportedItemsList;
		this.ent_list = master.PotP_ArrayManager.SupportedItemsList_Entity;
		this.player_inv = thePlayer.inv;
		
		player_inv.AddListener(this);
	}
	
	//---------------------------------------------------
	
	event OnInventoryScriptedEvent( eventType : EInventoryEventType, itemId : SItemUniqueId, quantity : int, fromAssociatedInventory : bool ) 
	{
		if (eventType != IET_ItemAdded) 
		{
			return true;
		}
		
		if (this.IsInState('Disabled')) 
		{ 
			return true;
		}
			
		if ( itm_list.Contains(player_inv.GetItemName(itemId)) )
		{
			this.storage.MasterList_ItemsGoblin.PushBack(itemId);
			this.last_addition_time = theGame.GetEngineTimeAsSeconds();
			
			if (!this.IsInState('ItemAdded')) 
			{ 
				this.GotoState('ItemAdded'); 
			}
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_ItemsGoblin 
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

state Idle in CProgressOnThePath_ItemsGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		if (parent.storage.MasterList_ItemsGoblin.Size() > 0)
		{
			parent.GotoState('ItemAdded');
		}
		else
		{
			parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		}
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

	entry function ItemAdded_Entry()
	{	
		var current_time, sleep_time: float;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		current_time = theGame.GetEngineTimeAsSeconds();
		sleep_time = 3;
		
		while (current_time - parent.last_addition_time < sleep_time)
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			Sleep(1);
		}
		
		this.ProcessItem();
		parent.storage.MasterList_ItemsGoblin.Erase(0);
		parent.GotoState('Idle');
	}

//---------------------------------------------------
	
	latent function ProcessItem()
	{
		var Idx, Edx, min, max: int;
		var item_name: name;
		var entry_data: PotP_PreviewEntry;

		item_name = parent.player_inv.GetItemName(parent.storage.MasterList_ItemsGoblin[0]);
			
		Edx = parent.itm_list.FindFirst(item_name);
		if (Edx == -1)
		{
			return;
		}
		
		entry_data = parent.ent_list[Edx];
		
		parent.player_inv.GetItemQualityFromName(item_name, min, max);
		if ( entry_data.IsPlayable() && (min >= 4 || parent.player_inv.ItemHasTag(parent.storage.MasterList_ItemsGoblin[0], 'GwintCard') ) ) 
		{
			entry_data.AddToBackgroundQueue();
			entry_data.SetCompleted();
		}
		
		SleepOneFrame();
	}
}

