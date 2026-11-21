//---------------------------------------------------
//-- Quest Functions --------------------------------
//---------------------------------------------------

quest function PotP_CompleteEvent(fact_name: name)
{
	PotP_DoCompleteEvent(NameToString(fact_name));
}

// From a quest block, or from the quest listener
function PotP_DoCompleteEvent(fact_name: string)
{
	var main	: CPotP_Main = PotP_Get();
	var tracked	: CPotP_Entry;

	FactsSet(fact_name, 1);

	if (!main)
	{
		return;
	}
	if (!main.catalog.is_ready)
	{
		return;
	}

	tracked = main.catalog.FindEvent(fact_name);
	if (tracked)
	{
		main.tracker.QueueEvent(tracked);
	}
}

//---------------------------------------------------

// Geralt came upon the event and walked by without getting involved, or the game has moved on and it can't happen any
// more. A done one stays done.
quest function PotP_MissEvent(fact_name: name)
{
	PotP_DoMissEvent(NameToString(fact_name));
}

function PotP_DoMissEvent(fact_name: string)
{
	var main	: CPotP_Main = PotP_Get();
	var tracked	: CPotP_Entry;

	if (FactsQuerySum(fact_name) > 0)
	{
		return;
	}
	FactsSet(PotP_Fact_EventMissed(fact_name), 1);

	if (!main)
	{
		return;
	}
	if (!main.catalog.is_ready)
	{
		return;
	}

	tracked = main.catalog.FindEvent(fact_name);
	if (tracked)
	{
		main.tracker.QueueEvent(tracked);
	}
}

//---------------------------------------------------

quest function PotP_UnlockEvent(UUID: string, Location: string, Fact: string)
{
	PotP_DoUnlockEvent(UUID, Location, Fact);
}

function PotP_DoUnlockEvent(UUID: string, Location: string, Fact: string)
{
	var main		: CPotP_Main = PotP_Get();
	var tracked		: CPotP_Entry;

	if (FactsQuerySum(PotP_Fact_EventUnlocked(Fact)) > 0)
	{
		return;
	}
	FactsSet(PotP_Fact_EventUnlocked(Fact), 1);

	if (!main)
	{
		return;
	}
	if (!main.catalog.is_ready)
	{
		return;
	}

	tracked = main.catalog.FindByUuid(UUID);
	if (!tracked)
	{
		return;
	}

	main.map_pins.Refresh();

	if (PotP_SettingFlag('ProgressOnThePath_MiscNotification_Event'))
	{
		main.popup.ShowHerald("event", tracked.title, GetLocStringByKeyExt(Location), tracked.entry_name, false, 5);
	}
}

//---------------------------------------------------

function PotP_IsEventUnlocked(tracked: CPotP_Entry) : bool
{
	var Idx : int;

	if (tracked.starts_unlocked || FactsQuerySum(PotP_Fact_EventUnlocked(tracked.entry_name)) > 0)
	{
		return true;
	}
	for (Idx = 0; Idx < tracked.unlock_facts.Size(); Idx += 1)
	{
		if (FactsQuerySum(tracked.unlock_facts[Idx]) == 0)
		{
			return false;
		}
	}
	return tracked.unlock_facts.Size() > 0;
}

//---------------------------------------------------

function PotP_Fact_EventRecordImported() : string
{
	return "PotP_EventRecord_Imported";
}

// Once per save: events played before PotP heard them, read from what Brothers In Arms recorded, and from its Events'
// journal. Got involved is done, walked by is missed, and an event only known to be over is done. Older PotP counted a
// walk-by as done; where BIA's facts show it was one, it becomes missed. After this only PotP's own facts count, so
// whether BIA is installed changes nothing.
function PotP_ImportEventRecord(catalog: CPotP_Catalog)
{
	var tracked		: CPotP_Entry;
	var journal		: CWitcherJournalManager = theGame.GetJournalManager();
	var journal_entry	: CJournalBase;
	var status		: EJournalStatus;
	var involved	: bool;
	var ignored		: bool;
	var over		: bool;
	var done		: int = 0;
	var missed		: int = 0;
	var Idx			: int;

	if (FactsQuerySum(PotP_Fact_EventRecordImported()) > 0)
	{
		return;
	}

	for (Idx = 0; Idx < catalog.event_entries.Size(); Idx += 1)
	{
		tracked = catalog.event_entries[Idx];
		involved = PotP_AnyFactSet(tracked.import_involved);
		ignored = PotP_AnyFactSet(tracked.import_ignored);
		over = PotP_AnyFactSet(tracked.import_over);

		if (tracked.fallback_journal != '')
		{
			journal_entry = journal.GetEntryByTag(tracked.fallback_journal);
			if (journal_entry)
			{
				status = journal.GetEntryStatus(journal_entry);
				involved = involved || status == JS_Success || status == JS_Failed;
			}
		}

		if (involved || (over && !ignored))
		{
			if (FactsQuerySum(tracked.entry_name) == 0)
			{
				FactsSet(tracked.entry_name, 1);
				done += 1;
			}
		}
		else if (ignored && FactsQuerySum(PotP_Fact_EventMissed(tracked.entry_name)) == 0)
		{
			FactsRemove(tracked.entry_name);
			FactsSet(PotP_Fact_EventMissed(tracked.entry_name), 1);
			missed += 1;
		}
	}

	FactsSet(PotP_Fact_EventRecordImported(), 1);
	PotP_Log("Events imported from Brothers In Arms' facts: " + IntToString(done) + " done, " + IntToString(missed) + " missed", 'Catalog');
}

//---------------------------------------------------

function PotP_AnyFactSet(facts: array<string>) : bool
{
	var Idx : int;

	for (Idx = 0; Idx < facts.Size(); Idx += 1)
	{
		if (FactsQuerySum(facts[Idx]) > 0)
		{
			return true;
		}
	}
	return false;
}
