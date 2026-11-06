//---------------------------------------------------
//-- Inventory Listener -----------------------------
//---------------------------------------------------

class CPotP_InventoryListener extends IInventoryScriptedListener
{
	var master		: CPotP_Main;
	var inventory	: CInventoryComponent;

	//---------------------------------------------------

	public function Attach(main: CPotP_Main)
	{
		master = main;
		inventory = thePlayer.GetInventory();
		inventory.AddListener(this);
	}

	//---------------------------------------------------

	event OnInventoryScriptedEvent(eventType: EInventoryEventType, itemId: SItemUniqueId, quantity: int, fromAssociatedInventory: bool)
	{
		var item : name;

		if (eventType != IET_ItemAdded || !master.catalog.is_ready)
		{
			return true;
		}

		item = inventory.GetItemName(itemId);
		if (master.catalog.IsItemRegistered(item))
		{
			master.tracker.QueueItem(item);
		}
		return true;
	}
}

//---------------------------------------------------
//-- World Watcher ----------------------------------
//---------------------------------------------------

statemachine class CPotP_WorldWatcher
{
	default autoState = 'Idle';

	var master			: CPotP_Main;
	var was_meditating	: bool;
	var last_area		: name;

	var check_interval	: int;
		default check_interval = 2;

	//---------------------------------------------------

	public function Start(main: CPotP_Main)
	{
		master = main;
		last_area = '';
		GotoState('Idle');
		GotoState('Watching');
	}

	//---------------------------------------------------

	public function CheckPins() : bool
	{
		var catalog		: CPotP_Catalog = master.catalog;
		var tracker		: CPotP_Tracker = master.tracker;
		var area		: name = theGame.GetCommonMapManager().GetCurrentArea();
		var check_all	: bool;
		var tracked		: CPotP_Entry;
		var changed		: bool;
		var Idx			: int;

		if (area != last_area)
		{
			check_all = true;
			last_area = area;
		}

		tracker.resolver.BeginPass();

		for (Idx = 0; Idx < catalog.world_entries.Size(); Idx += 1)
		{
			tracked = catalog.world_entries[Idx];

			if (tracked.IsDone())
			{
				continue;
			}
			if (!check_all && !IsInArea(tracked.region, area))
			{
				continue;
			}

			if (tracker.Apply(tracked, tracker.resolver.Evaluate(tracked), PotP_Src_Background))
			{
				changed = true;
			}
		}
		return changed;
	}

	//---------------------------------------------------

	private function IsInArea(region_value: PotP_Preview_Region, area: name) : bool
	{
		switch (area)
		{
		case 'AN_NMLandNovigrad':
		case 'AN_Velen':
			return region_value == PotP_R_VE || region_value == PotP_R_NO;

		case 'AN_Skellige_ArdSkellig':
			return region_value == PotP_R_SK;

		case 'AN_Kaer_Morhen':
			return region_value == PotP_R_KM;

		case 'AN_Prologue_Village':
		case 'AN_Prologue_Village_Winter':
			return region_value == PotP_R_WO;

		case 'AN_Bob':
		case 'AN_Dlc_Bob':
			return region_value == PotP_R_TO;

		case 'AN_Wyzima':
			return region_value == PotP_R_VI;

		case 'AN_Spiral':
			return region_value == PotP_R_TS;

		default:
			return true;
		}
	}
}

//---------------------------------------------------

state Idle in CPotP_WorldWatcher
{
}

//---------------------------------------------------

state Watching in CPotP_WorldWatcher
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.Watch();
	}

	//---------------------------------------------------

	entry function Watch()
	{
		var meditating	: bool;
		var tick		: int;

		while (true)
		{
			Sleep(1);
			tick += 1;

			meditating = PotP_PlayerIsMeditating();
			if (meditating && !parent.was_meditating)
			{
				parent.master.OnMeditationStarted();
			}
			parent.was_meditating = meditating;

			if (tick % parent.check_interval != 0 || !parent.master.catalog.is_ready || !parent.master.tracker.IsInState('Idle') || PotP_IsPlayerBusy() || PotP_IsMenuOpen())
			{
				continue;
			}

			if (parent.CheckPins())
			{
				parent.master.notifications.FlushBackground();
			}
		}
	}
}
