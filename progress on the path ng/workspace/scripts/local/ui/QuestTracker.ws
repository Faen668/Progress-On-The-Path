//---------------------------------------------------
//-- Quest Tracker ----------------------------------
//---------------------------------------------------
// PotP's missable notes for the tracked quest: how many missable quests a coming point of no return would close off,
// and whether the quest itself can be missed. They're shown one of two ways, as the tracker style setting says:
//   0  the overlay's panel under the HUD's quest list (PotPOverlay_Tracker), drawn and styled by the overlay
//   1  lines added to the last objective's text, which the HUD shows in its own font and without the colours

@addField(CR4Game)
var potp_tracker_note : string;

@addField(CR4Game)
var potp_tracker_remaining : int;

@addField(CR4Game)
var potp_tracker_panel : string;	// the panel's lines for the quest tracked now, made as its objectives are sent

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
	var game : CR4Game = theGame;

	game.potp_tracker_panel = PotP_GetTrackerPanel(m_systemQuest);
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
	var game : CR4Game = theGame;

	if (m_systemQuest && m_systemObjectives.Size() > 0)
	{
		SendObjectives();
	}
	else
	{
		game.potp_tracker_panel = "";
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

function PotP_TrackerPanelOn() : bool
{
	return PotP_TrackerNotesOn() && PotP_SettingInt('ProgressOnThePath_MiscNotification_TrackerStyle') == 0;
}

//---------------------------------------------------

// What a point of no return ahead of the tracked quest would close off, and the line saying the quest itself can be
// missed, or "" for none
function PotP_TrackerMissables(journal_quest: CJournalQuest, out outstanding: array<CPotP_Entry>) : string
{
	var tracked		: CPotP_Entry;
	var groups		: array<CPotP_Section>;
	var group_open	: array<CPotP_Entry>;
	var text		: string;
	var Idx			: int;
	var Jdx			: int;

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
			group_open = groups[Idx].GetOutstanding();
			for (Jdx = 0; Jdx < group_open.Size(); Jdx += 1)
			{
				if (!outstanding.Contains(group_open[Jdx]))
				{
					outstanding.PushBack(group_open[Jdx]);
				}
			}
		}
	}

	if (tracked.is_missable && tracked.missable_group && !tracked.IsDone() && tracked.status != PotP_S_Missed)
	{
		text = GetLocStringByKeyExt(tracked.missable_group.header);
		if (tracked.missable_tip != "")
		{
			text = GetLocStringByKeyExt(tracked.missable_tip);
		}
		return StrReplace(PotP_LocOrDefault("potp_tracker_missable", "Missable: [TEXT]"), "[TEXT]", text);
	}
	return "";
}

//---------------------------------------------------

// The notes as lines added to the objective's text: tracker style 1
function PotP_GetTrackerNote(journal_quest: CJournalQuest) : string
{
	var outstanding	: array<CPotP_Entry>;
	var missable	: string;
	var note		: string;
	var text		: string;

	if (!PotP_TrackerNotesOn() || PotP_TrackerPanelOn())
	{
		return "";
	}

	missable = PotP_TrackerMissables(journal_quest, outstanding);
	if (outstanding.Size() > 0)
	{
		text = PotP_LocOrDefault("potp_tracker_cutoff", "Point of no return ahead - missable quests still open: [COUNT]");
		note += "<br/><font color='#C8566B'>" + StrReplace(text, "[COUNT]", IntToString(outstanding.Size())) + "</font>";
	}
	if (missable != "")
	{
		note += "<br/><font color='#D79D3A'>" + missable + "</font>";
	}

	// The HUD ignores the colours, so a blank line sets the note apart instead.
	if (note != "")
	{
		note = "<br/>" + note;
	}
	return note;
}

//---------------------------------------------------

// The notes for the overlay's panel: tracker style 0. M|the missable line, then L|state|title|uuid for each quest the
// point of no return would close off (state 2: under way, 0: not started). The overlay hides the names of those not
// started, as its spoiler settings say.
function PotP_GetTrackerPanel(journal_quest: CJournalQuest) : string
{
	var outstanding	: array<CPotP_Entry>;
	var missable	: string;
	var panel		: string;
	var progress	: string;
	var Idx			: int;

	if (!PotP_TrackerPanelOn() || !journal_quest)
	{
		return "";
	}

	missable = PotP_TrackerMissables(journal_quest, outstanding);
	if (outstanding.Size() == 0 && missable == "")
	{
		return "";
	}

	panel = "M|" + PotPOverlay_Clean(missable);
	for (Idx = 0; Idx < outstanding.Size(); Idx += 1)
	{
		progress = "0";
		if (outstanding[Idx].status == PotP_S_InProgress)
		{
			progress = "2";
		}
		panel += "\nL|" + progress + "|" + PotPOverlay_Clean(outstanding[Idx].title) + "|" + outstanding[Idx].uuid;
	}
	return panel;
}

//---------------------------------------------------
//-- The overlay's panel ----------------------------
//---------------------------------------------------
// The overlay asks for this ten times a second while its window is shut: where the HUD's quest list ends and the
// panel's lines, or "" when there's nothing to show or the list isn't on screen. The first line is
//   Q|centre x|top|width|opacity
// in the HUD's 1920x1080 stage. The names are from REDkit's HudModuleQuests.as and HudQuestContainer.as: the module
// keeps five objective slots whether they're used or not, so its own height never changes, but after every update it
// puts mcArrowDown.y at the bottom of the last objective showing, whether the arrow shows or not. The list is laid out
// a frame after the objectives are sent, which is why this is read here and not as they're sent.

function PotPOverlay_Tracker() : string
{
	var hud			: CR4ScriptedHud;
	var module		: CR4HudModuleQuests;
	var sprite		: CScriptedFlashSprite;
	var container	: CScriptedFlashSprite;
	var arrow		: CScriptedFlashSprite;
	var item		: CScriptedFlashSprite;
	var field		: CScriptedFlashObject;
	var module_scale	: float;
	var list_scale	: float;
	var opacity		: float;
	var bottom		: float;
	var left		: float;
	var width		: float;

	if (!thePlayer || theGame.potp_tracker_panel == "")
	{
		return "";
	}
	// The black screens of loading and fast travel too, as the HUD's own modules check for
	if (theGame.IsBlackscreen() || theGame.IsFading() || theGame.IsLoadingScreenVideoPlaying() || theGame.IsDialogOrCutscenePlaying() || thePlayer.IsInNonGameplayCutscene() || theGame.GetGuiManager().IsAnyMenu())
	{
		return "";
	}

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (!hud || !hud.IsHudVisibilityAllowedByUser())
	{
		return "";
	}
	module = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
	if (!module || !module.GetEnabled())
	{
		return "";
	}
	sprite = module.GetModuleFlash();
	if (!sprite || !sprite.GetMemberFlashBool("visible"))
	{
		return "";
	}
	container = sprite.GetChildFlashSprite("mcSystemQuestContainer");
	if (!container)
	{
		return "";
	}
	arrow = container.GetChildFlashSprite("mcArrowDown");
	item = container.GetChildFlashSprite("mcQuestObjectiveListItem1");
	if (!arrow || !item)
	{
		return "";
	}
	field = item.GetMemberFlashObject("tfObjective");
	if (!field)
	{
		return "";
	}

	opacity = sprite.GetMemberFlashNumber("alpha") * container.GetMemberFlashNumber("alpha");
	if (opacity <= 0.01)
	{
		return "";
	}

	module_scale = PotP_TrackerScale(sprite.GetMemberFlashNumber("scaleY"));
	list_scale = PotP_TrackerScale(container.GetMemberFlashNumber("scaleY"));

	// The bottom of the last objective, below the arrow when it shows that there are more
	bottom = arrow.GetMemberFlashNumber("y") + 3;
	if (arrow.GetMemberFlashBool("visible"))
	{
		bottom += arrow.GetMemberFlashNumber("height");
	}
	bottom = sprite.GetMemberFlashNumber("y") + (container.GetMemberFlashNumber("y") + bottom * list_scale) * module_scale;

	// The objectives' text box, which the HUD centres them in
	left = item.GetMemberFlashNumber("x") + field.GetMemberFlashNumber("x");
	width = field.GetMemberFlashNumber("width");
	left = sprite.GetMemberFlashNumber("x") + (container.GetMemberFlashNumber("x") + (left + width * 0.5) * list_scale) * module_scale;
	width = width * list_scale * module_scale;

	return "Q|" + FloatToString(left) + "|" + FloatToString(bottom) + "|" + FloatToString(width) + "|" + FloatToString(opacity)
		+ "\n" + theGame.potp_tracker_panel;
}

function PotP_TrackerScale(value: float) : float
{
	if (value <= 0.01)
	{
		return 1.0;
	}
	return value;
}
