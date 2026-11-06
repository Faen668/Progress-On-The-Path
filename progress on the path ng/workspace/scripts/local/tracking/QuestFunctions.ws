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

// The game has moved on and the event can't be done any more. A finished one stays finished.
quest function PotP_MissEvent(fact_name: name)
{
	PotP_DoMissEvent(NameToString(fact_name));
}

function PotP_DoMissEvent(fact_name: string)
{
	var main	: CPotP_Main = PotP_Get();
	var tracked	: CPotP_Entry;

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
