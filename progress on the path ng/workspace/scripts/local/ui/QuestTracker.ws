//---------------------------------------------------
//-- Quest Tracker ----------------------------------
//---------------------------------------------------

@addField(CR4Game)
var potp_tracker_note : string;

@addField(CR4Game)
var potp_tracker_remaining : int;

//---------------------------------------------------

@addMethod(CR4Game)
public function PotP_SetTrackerNote(note: string, objective_count: int)
{
	potp_tracker_note = note;
	potp_tracker_remaining = 0;

	if (note != "")
	{
		potp_tracker_remaining = objective_count;
	}
}

//---------------------------------------------------

@addMethod(CR4Game)
public function PotP_TakeTrackerNote() : string
{
	potp_tracker_remaining -= 1;

	if (potp_tracker_remaining == 0)
	{
		return potp_tracker_note;
	}
	return "";
}

//---------------------------------------------------

@wrapMethod(CR4HudModuleQuests) function SendObjectives()
{
	theGame.PotP_SetTrackerNote(PotP_GetTrackerNote(m_systemQuest), m_systemObjectives.Size());

	wrappedMethod();

	theGame.PotP_SetTrackerNote("", 0);
}

//---------------------------------------------------

@wrapMethod(CR4HudModuleQuests) function SendObjectiveCounter(objective: CJournalQuestObjective)
{
	var note	: string;
	var index	: int;

	wrappedMethod(objective);

	index = GetObjectiveIndex(objective);
	if (objective.GetCount() <= 0 || index < 0 || index != m_systemObjectives.Size() - 1)
	{
		return;
	}

	note = PotP_GetTrackerNote(m_systemQuest);
	if (note != "")
	{
		m_fxUpdateObjectiveCounterSFF.InvokeSelfTwoArgs(FlashArgInt(index), FlashArgString(GetLocStringById(objective.GetTitleStringId()) + GetQuestObjectiveCounterText(objective) + note));
	}
}

//---------------------------------------------------

@addMethod(CR4HudModuleQuests)
public function PotP_RefreshNote()
{
	if (m_systemQuest && m_systemObjectives.Size() > 0)
	{
		SendObjectives();
	}
}

//---------------------------------------------------

function PotP_RefreshQuestTracker()
{
	var hud		: CR4ScriptedHud;
	var module	: CR4HudModuleQuests;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (!hud)
	{
		return;
	}

	module = (CR4HudModuleQuests) hud.GetHudModule("QuestsModule");
	if (module)
	{
		module.PotP_RefreshNote();
	}
}

//---------------------------------------------------

function PotP_GetTrackerNote(journal_quest: CJournalQuest) : string
{
	var tracked		: CPotP_Entry;
	var groups		: array<CPotP_Section>;
	var outstanding	: array<CPotP_Entry>;
	var note		: string;
	var text		: string;
	var open_count	: int;
	var Idx			: int;

	if (!PotP_TrackerNotesOn())
	{
		return "";
	}

	tracked = PotP_GetJournalEntry(journal_quest);
	if (!tracked)
	{
		return "";
	}

	groups = PotP_GetCutoffGroups(tracked);
	for (Idx = 0; Idx < groups.Size(); Idx += 1)
	{
		if (groups[Idx].IsCutoffApproaching())
		{
			outstanding = groups[Idx].GetOutstanding();
			open_count += outstanding.Size();
		}
	}

	if (open_count > 0)
	{
		text = PotP_LocOrDefault("potp_tracker_cutoff", "Point of no return ahead - missable quests still open: [COUNT]");
		note += "<br/><font color='#C8566B'>" + StrReplace(text, "[COUNT]", IntToString(open_count)) + "</font>";
	}

	if (tracked.is_missable && tracked.missable_group && !tracked.IsDone() && tracked.status != PotP_S_Missed)
	{
		text = GetLocStringByKeyExt(tracked.missable_group.header);
		if (tracked.missable_tip != "")
		{
			text = GetLocStringByKeyExt(tracked.missable_tip);
		}
		note += "<br/><font color='#D79D3A'>" + StrReplace(PotP_LocOrDefault("potp_tracker_missable", "Missable: [TEXT]"), "[TEXT]", text) + "</font>";
	}

	// The HUD ignores the colours, so a blank line sets the note apart instead.
	if (note != "")
	{
		note = "<br/>" + note;
	}
	return note;
}
