//---------------------------------------------------
//-- Console Commands -------------------------------
//---------------------------------------------------

function PotP_ConsoleMain() : CPotP_Main
{
	var main : CPotP_Main = PotP_Get();

	if (!main)
	{
		GetWitcherPlayer().DisplayHudMessage("PotP: not started yet");
		return NULL;
	}
	if (!main.catalog.is_ready)
	{
		GetWitcherPlayer().DisplayHudMessage("PotP: still building, try again in a moment");
		return NULL;
	}
	return main;
}

//---------------------------------------------------

exec function ptc(identifier: string, optional value: pStatus)
{
	PotP_ConsoleChangeStatus(identifier, value);
}

exec function pt_changestatus(identifier: string, optional value: pStatus)
{
	PotP_ConsoleChangeStatus(identifier, value);
}

function PotP_ConsoleChangeStatus(identifier: string, value: pStatus)
{
	var main	: CPotP_Main = PotP_ConsoleMain();
	var tracked	: CPotP_Entry;

	if (!main)
	{
		return;
	}

	tracked = main.catalog.FindByIdentifier(identifier);
	if (!tracked)
	{
		GetWitcherPlayer().DisplayHudMessage("PotP: no entry with identifier " + identifier);
		return;
	}
	main.tracker.SetManualStatus(tracked, (int)value);
}

//---------------------------------------------------

exec function pt_update()
{
	var main : CPotP_Main = PotP_ConsoleMain();

	if (main)
	{
		main.RequestFullUpdate(false);
	}
}

//---------------------------------------------------

exec function pt_reload()
{
	var main : CPotP_Main = PotP_ConsoleMain();

	if (main)
	{
		main.catalog.Rebuild();
		GetWitcherPlayer().DisplayHudMessage("PotP: rebuilding tracking");
	}
}

//---------------------------------------------------

exec function pt_ng()
{
	var main : CPotP_Main = PotP_ConsoleMain();

	if (main)
	{
		main.ResetForNewGamePlus();
	}
}

//---------------------------------------------------

exec function pt_reset()
{
	var main	: CPotP_Main = PotP_ConsoleMain();
	var Idx		: int;

	if (!main)
	{
		return;
	}

	for (Idx = 0; Idx < main.catalog.entries.Size(); Idx += 1)
	{
		PotP_FactClear(PotP_Fact_Override(main.catalog.entries[Idx].uuid));
	}

	main.tracker.RequestFull(PotP_Src_Silent);
	GetWitcherPlayer().DisplayHudMessage("PotP: manual overrides cleared");
}

//---------------------------------------------------

exec function pt_version()
{
	var main : CPotP_Main = PotP_Get();

	if (main)
	{
		GetWitcherPlayer().DisplayHudMessage("Progress on the Path " + main.version_text + " (save: " + IntToString(FactsQuerySum(PotP_Fact_Version())) + ")");
	}
}

//---------------------------------------------------

exec function pt_state()
{
	var main : CPotP_Main = PotP_Get();

	if (main)
	{
		GetWitcherPlayer().DisplayHudMessage("PotP: main=" + NameToString(main.GetCurrentStateName())
			+ " catalog=" + NameToString(main.catalog.GetCurrentStateName())
			+ " tracker=" + NameToString(main.tracker.GetCurrentStateName()));
	}
}

//---------------------------------------------------

exec function pt_sizes()
{
	var main						: CPotP_Main = PotP_ConsoleMain();
	var total_count, done_count		: int;

	if (!main)
	{
		return;
	}

	main.catalog.CountProgress(total_count, done_count);
	GetWitcherPlayer().DisplayHudMessage("PotP: " + IntToString(main.catalog.entries.Size()) + " entries, "
		+ IntToString(main.catalog.sections.Size()) + " sections, "
		+ IntToString(done_count) + " / " + IntToString(total_count) + " done");
}

//---------------------------------------------------

exec function pt_checkfact(fact_name: string)
{
	if (FactsDoesExist(fact_name))
	{
		GetWitcherPlayer().DisplayHudMessage("PotP fact [" + fact_name + "] = " + IntToString(FactsQuerySum(fact_name)));
	}
	else
	{
		GetWitcherPlayer().DisplayHudMessage("PotP fact [" + fact_name + "] does not exist");
	}
}

//---------------------------------------------------
//-- Travel -----------------------------------------
//---------------------------------------------------

exec function pt_pos()
{
	GetWitcherPlayer().DisplayHudMessage(theGame.GetCommonMapManager().GetCurrentArea());
	PotP_Log(VecToString(thePlayer.GetWorldPosition()), 'PotP Position');
}

exec function pt_spiral()
{
	theGame.ScheduleWorldChangeToMapPin("levels\the_spiral\spiral.w2w", '');
	theGame.RequestAutoSave("fast travel", true);
}

exec function pt_forest()
{
	if (theGame.GetCommonMapManager().GetCurrentArea() == 'AN_Spiral')
	{
		thePlayer.Teleport(Vector(-671.004, -2248.409, 81.81971, 1));
	}
}

//---------------------------------------------------
//-- Trying the banners -----------------------------
//---------------------------------------------------
// Each goes the way the real one does, so it waits until the player's free. Close the console to see it.

function PotP_ConsoleHerald(what: string, optional first: string, optional second: string)
{
	var main : CPotP_Main = PotP_ConsoleMain();

	if (!main)
	{
		return;
	}
	switch (what)
	{
	case "event":
		if (StrLen(first) == 0)
		{
			first = "The Crossing of Lindenvale";
		}
		if (StrLen(second) == 0)
		{
			second = "Velen";
		}
		main.popup.ShowHerald("event", first, second, "", false);
		break;
	case "update":
		main.popup.ShowHerald("update", main.version_text, "", "", false);
		break;
	case "ngplus":
		main.popup.ShowHerald("ngplus", "", GetLocStringByKeyExt("PotP_NewGamePlusMessage"), "", false);
		break;
	case "content":
		main.popup.ShowHerald("content", "", StrReplace(PotP_LocOrDefault("PotP_NewContentAdded", "[COUNT] new entries are now tracked."), "[COUNT]", "12"), "", false);
		break;
	default:
		main.popup.ShowHerald(what, "", "", "", false);
		break;
	}
}

exec function pt_herald_event(optional event_name: string, optional place: string)
{
	PotP_ConsoleHerald("event", event_name, place);
}

exec function pt_herald_update()
{
	PotP_ConsoleHerald("update");
}

exec function pt_herald_install()
{
	PotP_ConsoleHerald("install");
}

exec function pt_herald_ngplus()
{
	PotP_ConsoleHerald("ngplus");
}

exec function pt_herald_content()
{
	PotP_ConsoleHerald("content");
}

// All of them, one after another
exec function pt_herald_all()
{
	PotP_ConsoleHerald("event");
	PotP_ConsoleHerald("update");
	PotP_ConsoleHerald("install");
	PotP_ConsoleHerald("ngplus");
	PotP_ConsoleHerald("content");
}
