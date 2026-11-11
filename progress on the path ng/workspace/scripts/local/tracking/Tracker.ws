//---------------------------------------------------
//-- Tracker ----------------------------------------
//---------------------------------------------------

statemachine class CPotP_Tracker
{
	var last_creature_count	: int;
	default last_creature_count = -1;

	default autoState = 'Idle';

	var master				: CPotP_Main;
	var resolver			: CPotP_StatusResolver;

	var full_source			: EPotP_UpdateSource;
	var full_delay			: float;
	var full_requested		: bool;

	var queued_quests		: array<CJournalQuest>;
	var queued_items		: array<name>;
	var queued_events		: array<CPotP_Entry>;
	var last_queue_time		: float;
	var newly_missed		: array<CPotP_Entry>;

	var chunk_size			: int;
		default chunk_size = 150;

	var queue_settle_time	: float;
		default queue_settle_time = 3.0;

	//---------------------------------------------------

	public function Initialise(main: CPotP_Main)
	{
		master = main;
		resolver = new CPotP_StatusResolver in this;
		GotoState('Idle');
	}

	//---------------------------------------------------
	//-- Requests ---------------------------------------
	//---------------------------------------------------

	public function RequestFull(source: EPotP_UpdateSource, optional delay: float)
	{
		full_source = source;
		full_delay = delay;
		full_requested = true;

		ClearQueue();
		GotoState('Idle');
		GotoState('FullPass');
	}

	//---------------------------------------------------

	public function QueueQuest(journal_quest: CJournalQuest)
	{
		if (!master.catalog.FindQuest(journal_quest.baseName))
		{
			return;
		}
		if (!queued_quests.Contains(journal_quest))
		{
			queued_quests.PushBack(journal_quest);
		}
		Touch();
	}

	//---------------------------------------------------

	public function QueueItem(item: name)
	{
		if (!queued_items.Contains(item))
		{
			queued_items.PushBack(item);
		}
		Touch();
	}

	//---------------------------------------------------

	public function QueueEvent(tracked: CPotP_Entry)
	{
		if (!queued_events.Contains(tracked))
		{
			queued_events.PushBack(tracked);
		}
		Touch();
	}

	//---------------------------------------------------

	private function Touch()
	{
		last_queue_time = theGame.GetEngineTimeAsSeconds();

		if (IsInState('Idle'))
		{
			GotoState('Processing');
		}
	}

	//---------------------------------------------------

	public function HasQueue() : bool
	{
		return queued_quests.Size() > 0 || queued_items.Size() > 0 || queued_events.Size() > 0;
	}

	//---------------------------------------------------

	public function ClearQueue()
	{
		queued_quests.Clear();
		queued_items.Clear();
		queued_events.Clear();
	}

	//---------------------------------------------------
	//-- Status changes ---------------------------------
	//---------------------------------------------------

	public function Apply(tracked: CPotP_Entry, new_status: EPotP_Status, source: EPotP_UpdateSource) : bool
	{
		var old_status : EPotP_Status = tracked.status;

		if (old_status == new_status)
		{
			return false;
		}

		tracked.status = new_status;

		if (tracked.category == PotP_A_Event)
		{
			if (tracked.IsDone())
			{
				master.map_pins.RemovePin(tracked);
			}
			else if (source != PotP_Src_Silent)
			{
				master.map_pins.Refresh();
			}
		}

		// A kind turned off in Tracked Contents is kept up to date, but nothing's said of it
		if (tracked.untracked)
		{
			return true;
		}

		switch (source)
		{
		case PotP_Src_Full:
			if (new_status == PotP_S_Completed)
			{
				master.notifications.AddToSummary(tracked);
			}
			break;

		case PotP_Src_Background:
			if (new_status == PotP_S_Completed || (new_status == PotP_S_InProgress && tracked.category == PotP_A_Quest))
			{
				master.notifications.AddToBackground(tracked);
			}
			else if (new_status == PotP_S_Missed && tracked.is_missable)
			{
				newly_missed.PushBack(tracked);
			}
			break;
		}
		return true;
	}

	//---------------------------------------------------
	//-- Missable quests --------------------------------
	//---------------------------------------------------

	public function RefreshMissables(source: EPotP_UpdateSource)
	{
		var journal		: CWitcherJournalManager = theGame.GetJournalManager();
		var missables	: array<CPotP_Entry> = master.catalog.missable_entries;
		var quests		: array<CJournalBase>;
		var statuses	: array<EJournalStatus>;
		var Idx, Mdx	: int;

		statuses.Resize(missables.Size());
		for (Idx = 0; Idx < statuses.Size(); Idx += 1)
		{
			statuses[Idx] = JS_Inactive;
		}

		journal.GetActivatedOfType('CJournalQuest', quests);
		for (Idx = 0; Idx < quests.Size(); Idx += 1)
		{
			for (Mdx = 0; Mdx < missables.Size(); Mdx += 1)
			{
				if (missables[Mdx].entry_name == quests[Idx].baseName)
				{
					statuses[Mdx] = journal.GetEntryStatus(quests[Idx]);
					break;
				}
			}
		}

		for (Idx = 0; Idx < missables.Size(); Idx += 1)
		{
			if (missables[Idx].category == PotP_A_Quest)
			{
				Apply(missables[Idx], resolver.EvaluateQuest(missables[Idx], statuses[Idx]), source);
			}
			else
			{
				Apply(missables[Idx], resolver.Evaluate(missables[Idx]), source);
			}
		}

		CheckMissableWarnings();
	}

	//---------------------------------------------------

	public function FlushMissed()
	{
		if (newly_missed.Size() > 0 && PotP_MissableNotificationsOn())
		{
			master.notifications.ShowMissed(newly_missed);
		}
		newly_missed.Clear();
	}

	//---------------------------------------------------

	public function CheckMissableWarnings()
	{
		var groups		: array<CPotP_Section> = master.catalog.missable_sections;
		var outstanding	: array<CPotP_Entry>;
		var Idx			: int;

		if (!PotP_MissableNotificationsOn())
		{
			return;
		}

		for (Idx = 0; Idx < groups.Size(); Idx += 1)
		{
			if (!groups[Idx].IsCutoffApproaching())
			{
				continue;
			}

			outstanding = groups[Idx].GetOutstanding();
			if (outstanding.Size() > 0)
			{
				master.notifications.ShowMissableWarning(groups[Idx], outstanding);
			}
		}
	}

	//---------------------------------------------------

	public function SetManualStatus(tracked: CPotP_Entry, value: int, optional silent: bool)
	{
		var fact_name : string = PotP_Fact_Override(tracked.uuid);

		if (value == 0)
		{
			PotP_FactClear(fact_name);
		}
		else
		{
			FactsSet(fact_name, value);
		}

		resolver.BeginPass();
		if (tracked.category == PotP_A_Quest)
		{
			Apply(tracked, resolver.EvaluateQuest(tracked, GetJournalStatus(tracked)), PotP_Src_Silent);
		}
		else
		{
			Apply(tracked, resolver.Evaluate(tracked), PotP_Src_Silent);
		}

		if (tracked.category == PotP_A_Event)
		{
			master.map_pins.Refresh();
		}

		if (!silent && PotP_SettingFlag('ProgressOnThePath_MiscNotification_Enter'))
		{
			master.notifications.ShowSingleUpdate(tracked, value);
		}
	}

	//---------------------------------------------------

	// Whether the game itself counts it as done, whatever has been set by hand. Missed can't stick on an entry that is.
	// The game adds to the bestiary without saying so, from fights and quests alike, so this looks for a change in how
	// many it has. Silent, as the game shows its own message.
	public function CheckBestiary()
	{
		var catalog	: CPotP_Catalog = master.catalog;
		var count	: int = theGame.GetJournalManager().GetNumberOfActivatedOfType('CJournalCreature');
		var Idx		: int;

		resolver.BeginPass();
		if (count == last_creature_count)
		{
			return;
		}
		last_creature_count = count;

		for (Idx = 0; Idx < catalog.entries.Size(); Idx += 1)
		{
			if (catalog.entries[Idx].category == PotP_A_Bestiary)
			{
				Apply(catalog.entries[Idx], resolver.Evaluate(catalog.entries[Idx]), PotP_Src_Silent);
			}
		}
	}

	//---------------------------------------------------

	// Books are read in the inventory, the glossary or as they're picked up, with nothing PotP hears, so the Library
	// asks the game again each time the window opens. Silent, as the game says so itself.
	public function CheckLibrary()
	{
		var catalog	: CPotP_Catalog = master.catalog;
		var Idx		: int;

		for (Idx = 0; Idx < catalog.entries.Size(); Idx += 1)
		{
			if (catalog.entries[Idx].category == PotP_A_Library)
			{
				Apply(catalog.entries[Idx], resolver.Evaluate(catalog.entries[Idx]), PotP_Src_Silent);
			}
		}
	}

	//---------------------------------------------------

	public function IsDoneByGame(tracked: CPotP_Entry) : bool
	{
		resolver.BeginPass();
		if (tracked.category == PotP_A_Quest)
		{
			return resolver.QuestGameStatus(tracked, GetJournalStatus(tracked)) == PotP_S_Completed;
		}
		return resolver.GetGameStatus(tracked) == PotP_S_Completed;
	}

	//---------------------------------------------------

	public function GetJournalStatus(tracked: CPotP_Entry) : EJournalStatus
	{
		var journal		: CWitcherJournalManager = theGame.GetJournalManager();
		var quests		: array<CJournalBase>;
		var Idx			: int;

		journal.GetActivatedOfType('CJournalQuest', quests);
		for (Idx = 0; Idx < quests.Size(); Idx += 1)
		{
			if (quests[Idx].baseName == tracked.entry_name)
			{
				return journal.GetEntryStatus(quests[Idx]);
			}
		}
		return JS_Inactive;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CPotP_Tracker
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);

		if (parent.HasQueue())
		{
			parent.GotoState('Processing');
		}
	}
}

//---------------------------------------------------

state FullPass in CPotP_Tracker
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.Run();
	}

	//---------------------------------------------------

	entry function Run()
	{
		var source		: EPotP_UpdateSource = parent.full_source;
		var catalog		: CPotP_Catalog = parent.master.catalog;
		var processed	: int;
		var Idx			: int;

		parent.full_requested = false;

		if (parent.full_delay > 0)
		{
			Sleep(parent.full_delay);
		}

		while (PotP_IsInSceneOrFight())
		{
			Sleep(0.5);
		}

		parent.resolver.BeginPass();
		parent.master.notifications.ResetSummary();

		this.EvaluateQuests(source);
		SleepOneFrame();

		for (Idx = 0; Idx < catalog.entries.Size(); Idx += 1)
		{
			if (catalog.entries[Idx].category == PotP_A_Quest)
			{
				continue;
			}

			parent.Apply(catalog.entries[Idx], parent.resolver.Evaluate(catalog.entries[Idx]), source);

			processed += 1;
			if (processed % parent.chunk_size == 0)
			{
				SleepOneFrame();
			}
		}

		if (source == PotP_Src_Full)
		{
			parent.master.notifications.ShowSummary();
		}

		parent.master.OnFullPassDone(source);
		PotP_RefreshQuestTracker();
		parent.GotoState('Idle');
	}

	//---------------------------------------------------

	latent function EvaluateQuests(source: EPotP_UpdateSource)
	{
		var journal		: CWitcherJournalManager = theGame.GetJournalManager();
		var catalog		: CPotP_Catalog = parent.master.catalog;
		var quests		: array<CJournalBase>;
		var statuses	: array<EJournalStatus>;
		var Idx, Edx	: int;

		statuses.Resize(catalog.quest_refs.Size());
		for (Idx = 0; Idx < statuses.Size(); Idx += 1)
		{
			statuses[Idx] = JS_Inactive;
		}

		journal.GetActivatedOfType('CJournalQuest', quests);
		for (Idx = 0; Idx < quests.Size(); Idx += 1)
		{
			Edx = catalog.quest_keys.FindFirst(quests[Idx].baseName);
			if (Edx != -1)
			{
				statuses[Edx] = journal.GetEntryStatus(quests[Idx]);
			}
		}

		for (Idx = 0; Idx < catalog.quest_refs.Size(); Idx += 1)
		{
			parent.Apply(catalog.quest_refs[Idx], parent.resolver.EvaluateQuest(catalog.quest_refs[Idx], statuses[Idx]), source);
		}

		parent.RefreshMissables(source);
	}
}

//---------------------------------------------------

state Processing in CPotP_Tracker
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.Run();
	}

	//---------------------------------------------------

	entry function Run()
	{
		while (theGame.GetEngineTimeAsSeconds() - parent.last_queue_time < parent.queue_settle_time || PotP_IsPlayerBusy() || PotP_IsMenuOpen())
		{
			Sleep(1);
		}

		this.ProcessQueue();
		parent.master.notifications.FlushBackground();
		parent.FlushMissed();
		PotP_RefreshQuestTracker();
		parent.GotoState('Idle');
	}

	//---------------------------------------------------

	latent function ProcessQueue()
	{
		var journal		: CWitcherJournalManager = theGame.GetJournalManager();
		var catalog		: CPotP_Catalog = parent.master.catalog;
		var quests		: array<CJournalQuest> = parent.queued_quests;
		var items		: array<name> = parent.queued_items;
		var events		: array<CPotP_Entry> = parent.queued_events;
		var tracked		: CPotP_Entry;
		var Idx			: int;

		parent.ClearQueue();
		parent.resolver.BeginPass();

		for (Idx = 0; Idx < quests.Size(); Idx += 1)
		{
			tracked = catalog.FindQuest(quests[Idx].baseName);
			if (tracked)
			{
				parent.Apply(tracked, parent.resolver.EvaluateQuest(tracked, journal.GetEntryStatus(quests[Idx])), PotP_Src_Background);
			}
		}

		if (quests.Size() > 0)
		{
			parent.RefreshMissables(PotP_Src_Background);
		}

		for (Idx = 0; Idx < items.Size(); Idx += 1)
		{
			tracked = catalog.FindItem(items[Idx]);
			if (tracked)
			{
				parent.Apply(tracked, parent.resolver.Evaluate(tracked), PotP_Src_Background);
			}
		}

		for (Idx = 0; Idx < events.Size(); Idx += 1)
		{
			parent.Apply(events[Idx], parent.resolver.Evaluate(events[Idx]), PotP_Src_Background);
		}
	}
}
