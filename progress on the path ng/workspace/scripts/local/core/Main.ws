//---------------------------------------------------
//-- Progress on the Path ---------------------------
//---------------------------------------------------

statemachine class CPotP_Main
{
	default autoState = 'Running';

	var catalog				: CPotP_Catalog;
	var tracker				: CPotP_Tracker;
	var notifications		: CPotP_Notifications;
	var popup				: CPotP_Popup;
	var map_pins			: CPotP_MapPins;
	var world_watcher		: CPotP_WorldWatcher;
	var inventory_listener	: CPotP_InventoryListener;

	var version_text		: string;
		default version_text = "7.0.0.9";

	var version_number		: int;
		default version_number = 7009;

	var is_started			: bool;
	var baseline_pending	: bool;
	var version_changed		: bool;
	var last_update_time	: float;
	var pin_settings		: string;

	//---------------------------------------------------

	public function Start()
	{
		if (is_started)
		{
			return;
		}
		is_started = true;

		catalog			= new CPotP_Catalog in this;
		tracker			= new CPotP_Tracker in this;
		notifications	= new CPotP_Notifications in this;
		popup			= new CPotP_Popup in this;
		map_pins		= new CPotP_MapPins in this;
		world_watcher	= new CPotP_WorldWatcher in this;

		catalog.Initialise(this);
		tracker.Initialise(this);
		notifications.Initialise(this);
		map_pins.Initialise(this);

		GotoState('Waiting');
	}

	//---------------------------------------------------

	public function Startup()
	{
		PotP_Log("Starting " + version_text, 'PotP Main');

		CheckVersion();
		catalog.Rebuild();
	}

	//---------------------------------------------------

	public function OnCatalogReady()
	{
		PotP_RegisterQuestListener(catalog);
		baseline_pending = true;
		tracker.RequestFull(PotP_Src_Silent);
	}

	//---------------------------------------------------

	public function OnFullPassDone(source: EPotP_UpdateSource)
	{
		if (!baseline_pending)
		{
			return;
		}
		baseline_pending = false;

		pin_settings = GetPinSettings();
		map_pins.Refresh();

		if (!inventory_listener)
		{
			inventory_listener = new CPotP_InventoryListener in this;
			inventory_listener.Attach(this);
		}
		world_watcher.Start(this);

		CheckContentChanges();
		ShowStartupMessages();
	}

	//---------------------------------------------------
	//-- Versioning -------------------------------------
	//---------------------------------------------------

	private function CheckVersion()
	{
		if (FactsQuerySum(PotP_Fact_Initialised()) != 1)
		{
			FactsSet(PotP_Fact_Initialised(), 1);
			FactsSet(PotP_Fact_Version(), version_number);
			return;
		}

		if (FactsQuerySum(PotP_Fact_Version()) < version_number)
		{
			FactsSet(PotP_Fact_Version(), version_number);
			version_changed = true;
		}
	}

	//---------------------------------------------------

	private function ShowStartupMessages()
	{
		popup.ShowHerald("install", "", "", "PotP_InstallMessage", true);

		if (version_changed && PotP_SettingFlag('ProgressOnThePath_ShowUpdateNotifications'))
		{
			popup.ShowHerald("update", version_text, "", "", false, 5);
		}
		version_changed = false;
	}

	//---------------------------------------------------
	// Tells the player when installed content changed since the last session.
	// Silent on first run and on our own updates, where the change is expected.

	private function CheckContentChanges()
	{
		var count			: int;
		var checksum		: int;
		var stored_count	: int;
		var stored_checksum	: int;
		var has_count		: bool;
		var has_checksum	: bool;
		var message			: string;

		// Out parameters must be filled in statements, not in var initialisers.
		count			= catalog.entries.Size();
		checksum		= catalog.GetChecksum();
		has_count		= PotP_FactGetStored("PotP_Catalog_Count", stored_count);
		has_checksum	= PotP_FactGetStored("PotP_Catalog_Checksum4", stored_checksum);

		PotP_Log("Content check: count " + IntToString(stored_count) + " -> " + IntToString(count)
			+ ", checksum " + IntToString(stored_checksum) + " -> " + IntToString(checksum), 'PotP Main');

		PotP_FactSetStored("PotP_Catalog_Count", count);
		PotP_FactSetStored("PotP_Catalog_Checksum4", checksum);

		if (!has_count || !has_checksum || version_changed)
		{
			return;
		}
		if (count == stored_count && checksum == stored_checksum)
		{
			return;
		}

		if (count > stored_count)
		{
			message = StrReplace(PotP_LocOrDefault("PotP_NewContentAdded", "[COUNT] new entries are now tracked."), "[COUNT]", IntToString(count - stored_count));
		}
		else if (count < stored_count)
		{
			message = StrReplace(PotP_LocOrDefault("PotP_NewContentRemoved", "[COUNT] entries are no longer tracked."), "[COUNT]", IntToString(stored_count - count));
		}

		popup.ShowHerald("content", "", message, "", false);
	}

	//---------------------------------------------------
	//-- Input ------------------------------------------
	//---------------------------------------------------

	// The overlay's Full Update key. It works where the player has control, not in menus or scenes.
	public function OnUpdateKey()
	{
		var now		: float = theGame.GetEngineTimeAsSeconds();
		var context	: name = theInput.GetContext();

		if (!catalog.is_ready || !PotP_SettingFlag('ProgressOnThePath_EnableHotKey'))
		{
			return;
		}

		if (context != 'Exploration' && context != 'Horse' && context != 'Swimming' && context != 'Boat'
			&& context != 'BoatPassenger' && context != 'Combat' && context != 'Diving')
		{
			return;
		}

		if (now - last_update_time > 5)
		{
			last_update_time = now;
			RequestFullUpdate(false);
		}
	}

	//---------------------------------------------------

	//---------------------------------------------------
	//-- Updates ----------------------------------------
	//---------------------------------------------------

	public function RequestFullUpdate(from_meditation: bool)
	{
		var delay : float;

		if (!catalog.is_ready)
		{
			return;
		}

		if (from_meditation)
		{
			delay = 0.16;
		}

		tracker.RequestFull(PotP_Src_Full, delay);
	}

	//---------------------------------------------------

	public function OnMeditationStarted()
	{
		if (PotP_SettingFlag('ProgressOnThePath_MeditationUpdate'))
		{
			RequestFullUpdate(true);
		}
	}

	//---------------------------------------------------
	//-- Settings ---------------------------------------
	//---------------------------------------------------

	public function OnSettingsClosed()
	{
		var current_pins : string;

		if (PotP_SettingFlag('ProgressOnThePath_ResetForNGPlus'))
		{
			PotP_SetSetting('ProgressOnThePath_ResetForNGPlus', "false");
			ResetForNewGamePlus();
			return;
		}

		if (!catalog.is_ready)
		{
			return;
		}

		current_pins = GetPinSettings();
		if (current_pins != pin_settings)
		{
			pin_settings = current_pins;
			map_pins.Refresh();
		}

		// Picks up a change to the quest tracker notes setting.
		PotP_RefreshQuestTracker();
	}

	//---------------------------------------------------

	private function GetPinSettings() : string
	{
		return PotP_GetSetting('ProgressOnThePath_EventMapPins_ShowMapPins') + "|"
			+ PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinDescription') + "|"
			+ PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinRadius') + "|"
			+ PotP_GetSetting('ProgressOnThePath_EventMapPins_MapPinType');
	}

	//---------------------------------------------------

	public function ResetForNewGamePlus()
	{
		var tracked		: CPotP_Entry;
		var Idx, Vdx	: int;

		for (Idx = 0; Idx < catalog.entries.Size(); Idx += 1)
		{
			tracked = catalog.entries[Idx];
			PotP_FactClear(PotP_Fact_Override(tracked.uuid));

			if (tracked.category == PotP_A_Event)
			{
				PotP_FactClear(tracked.entry_name);
				PotP_FactClear(PotP_Fact_EventUnlocked(tracked.entry_name));
			}
			else if (tracked.category == PotP_A_Items)
			{
				for (Vdx = 0; Vdx < tracked.variations.Size(); Vdx += 1)
				{
					PotP_FactClear(PotP_Fact_Collected(tracked.variations[Vdx]));
				}
			}
		}

		catalog.Rebuild();
		popup.ShowHerald("ngplus", "", GetLocStringByKeyExt("PotP_NewGamePlusMessage"), "", false);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Waiting in CPotP_Main
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.WaitForGame();
	}

	//---------------------------------------------------

	entry function WaitForGame()
	{
		while (!FactsDoesExist("q001_nightmare_ended") || PotP_IsInSceneOrFight())
		{
			Sleep(2);
		}

		parent.Startup();
		parent.GotoState('Running');
	}
}

//---------------------------------------------------

state Running in CPotP_Main
{
}
