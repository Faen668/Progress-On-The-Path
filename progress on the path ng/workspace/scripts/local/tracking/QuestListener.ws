//---------------------------------------------------
//-- Quest Listener ---------------------------------
//---------------------------------------------------
// PotP hears the game's own quest blocks through Native Quest Hook, instead of adding script blocks to quest files.
// Each event names the vanilla blocks that move it on in EventDefinitions.ws, with AddEventDoneBlock,
// AddEventUnlockBlock and AddEventMissedBlock. The GUIDs are vanilla's, so they work with Brothers In Arms and without.

enum EPotP_QuestBlockKind
{
	PotP_QB_Done	= 1,
	PotP_QB_Unlock	= 2,
	PotP_QB_Missed	= 3,
	PotP_QB_Outcome	= 4,
	PotP_QB_OutcomePaid	= 5,
	PotP_QB_Opened	= 6,
}

struct SPotP_QuestBlock
{
	var guid		: string;
	var output		: string;   // the output that counts, "None" for an unnamed one, such as a pause block's
	var kind		: EPotP_QuestBlockKind;
	var location	: string;   // for an unlock: the place the notification names
	var tracked		: CPotP_Entry;
	var paragraph	: int;      // for an outcome: what came of the event, a BIA string id
	var requires	: int;      // and the paragraph that has to have come first, or 0
	var unpaid		: int;      // for a paid outcome: the paragraph when he didn't pay
}

struct SPotP_EventKill
{
	var creature	: string;   // part of the template name, lower case
	var encounter	: name;     // the encounter whose area it must die in
	var tracked		: CPotP_Entry;
}

//---------------------------------------------------

class CPotP_QuestListener extends CNQH_Listener
{
	private var catalog : CPotP_Catalog;
	private var crowns_guids	: array<string>;	// scenes with a paid outcome that have started, and his crowns then
	private var crowns_then		: array<int>;

	public function Init(source: CPotP_Catalog) : CPotP_QuestListener
	{
		var Idx : int;

		catalog = source;
		watched.Clear();
		for (Idx = 0; Idx < catalog.quest_blocks.Size(); Idx += 1)
		{
			if (!watched.Contains(catalog.quest_blocks[Idx].guid))
			{
				watched.PushBack(catalog.quest_blocks[Idx].guid);
			}
		}
		PotP_Log("Watching " + watched.Size() + " quest blocks for " + catalog.quest_blocks.Size() + " event changes", 'QuestHook');
		return this;
	}

	public function OnBlockActivated(guid : string)
	{
		var Idx : int;
		var Jdx : int;

		for (Idx = 0; Idx < catalog.quest_blocks.Size(); Idx += 1)
		{
			if (catalog.quest_blocks[Idx].kind == PotP_QB_OutcomePaid && catalog.quest_blocks[Idx].guid == guid && GetWitcherPlayer())
			{
				Jdx = crowns_guids.FindFirst(guid);
				if (Jdx < 0)
				{
					crowns_guids.PushBack(guid);
					crowns_then.PushBack(GetWitcherPlayer().GetMoney());
				}
				else
				{
					crowns_then[Jdx] = GetWitcherPlayer().GetMoney();
				}
				return;
			}
		}
	}

	// Paid, or not: only if the scene was seen starting, or there's nothing to compare
	private function HearPaid(block: SPotP_QuestBlock)
	{
		var Idx : int = crowns_guids.FindFirst(block.guid);

		if (Idx < 0 || !GetWitcherPlayer())
		{
			return;
		}
		if (GetWitcherPlayer().GetMoney() < crowns_then[Idx])
		{
			PotP_KeepOutcome(block.paragraph, block.tracked);
		}
		else
		{
			PotP_KeepOutcome(block.unpaid, block.tracked);
		}
		crowns_guids.Erase(Idx);
		crowns_then.Erase(Idx);
	}

	public function OnBlockFinished(guid : string, output : name)
	{
		var block	: SPotP_QuestBlock;
		var fired	: string = NameToString(output);
		var Idx		: int;

		if (fired == "")
		{
			fired = "None";
		}

		for (Idx = 0; Idx < catalog.quest_blocks.Size(); Idx += 1)
		{
			block = catalog.quest_blocks[Idx];
			if (block.guid != guid || block.output != fired)
			{
				continue;
			}
			if (block.kind == PotP_QB_Outcome)
			{
				PotP_HearEventOutcome(block, guid, fired);
				continue;
			}
			if (block.kind == PotP_QB_OutcomePaid)
			{
				HearPaid(block);
				continue;
			}
			if (block.kind == PotP_QB_Opened)
			{
				if (!FactsDoesExist(PotP_OpenedFact(block.tracked)))
				{
					FactsAdd(PotP_OpenedFact(block.tracked), 1);
					PotP_Log("Opened " + block.tracked.entry_name, 'QuestHook');
				}
				continue;
			}

			PotP_Log("Block " + guid + " fired " + fired + ": " + block.kind + " for " + block.tracked.entry_name, 'QuestHook');
			switch (block.kind)
			{
			case PotP_QB_Done:
				PotP_DoCompleteEvent(block.tracked.entry_name);
				break;
			case PotP_QB_Unlock:
				PotP_DoUnlockEvent(block.tracked.uuid, block.location, block.tracked.entry_name);
				break;
			case PotP_QB_Missed:
				// An item's or a place's, such as Tiegr's or the Spiral's: its own fact. An item's looked at again now, a place's
				// by the pin check.
				if (block.tracked.category == PotP_A_Items || block.tracked.category == PotP_A_Gwent || block.tracked.category == PotP_A_World)
				{
					if (block.tracked.also_missed_fact != "")
					{
						FactsSet(block.tracked.also_missed_fact, 1);
					}
					if (block.tracked.category == PotP_A_Items || block.tracked.category == PotP_A_Gwent)
					{
						PotP_Get().tracker.QueueItem(block.tracked.item_name);
					}
				}
				else
				{
					PotP_DoMissEvent(block.tracked.entry_name);
				}
				break;
			}
		}
	}
}

//---------------------------------------------------

// An event's outcome heard: its paragraph kept for this save. Where one block ends the event however it came about, the
// paragraph whose earlier one was told wins over the one that needs none.
function PotP_HearEventOutcome(heard: SPotP_QuestBlock, guid: string, fired: string)
{
	var blocks		: array<SPotP_QuestBlock> = PotP_Get().catalog.quest_blocks;
	var chosen		: int;
	var Idx			: int;

	chosen = heard.paragraph;
	for (Idx = 0; Idx < blocks.Size(); Idx += 1)
	{
		if (blocks[Idx].kind != PotP_QB_Outcome || blocks[Idx].guid != guid || blocks[Idx].output != fired || blocks[Idx].tracked != heard.tracked)
		{
			continue;
		}
		if (blocks[Idx].requires > 0 && FactsDoesExist(PotP_OutcomeFact(blocks[Idx].requires)))
		{
			chosen = blocks[Idx].paragraph;
			break;
		}
		if (blocks[Idx].requires == 0)
		{
			chosen = blocks[Idx].paragraph;
		}
	}
	// Each block sharing this one is heard in turn: only the chosen one keeps its paragraph
	if (heard.paragraph != chosen)
	{
		return;
	}
	PotP_KeepOutcome(chosen, heard.tracked);
}

function PotP_KeepOutcome(paragraph: int, tracked: CPotP_Entry)
{
	if (!FactsDoesExist(PotP_OutcomeFact(paragraph)))
	{
		FactsAdd(PotP_OutcomeFact(paragraph), 1);
		PotP_Log("Outcome " + paragraph + " for " + tracked.entry_name, 'QuestHook');
	}
}

function PotP_OpenedFact(tracked: CPotP_Entry) : string
{
	return "potp_opened_" + tracked.uuid;
}

function PotP_OutcomeFact(paragraph: int) : string
{
	return "potp_outcome_" + paragraph;
}

//---------------------------------------------------

// From PotP's death hook. Rare, so a few lookups are fine: only events with an AddEventKill are checked.
function PotP_CheckEventKills(npc: CNewNPC)
{
	var main		: CPotP_Main = PotP_Get();
	var kill		: SPotP_EventKill;
	var encounter	: CEncounter;
	var area		: CTriggerAreaComponent;
	var described	: string;
	var Idx			: int;

	if (!main || !main.catalog.is_ready || !npc)
	{
		return;
	}

	for (Idx = 0; Idx < main.catalog.event_kills.Size(); Idx += 1)
	{
		kill = main.catalog.event_kills[Idx];
		encounter = (CEncounter)theGame.GetEntityByTag(kill.encounter);
		area = encounter ? encounter.GetEncounterArea() : NULL;
		if (!area || !area.TestEntityOverlap(npc))
		{
			continue;
		}

		// GetReadableName is its template's path, such as characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent.
		// Any death counts, not only the player's, as the encounter's own death monitor did.
		described = StrLower(npc.GetReadableName());
		if (StrFindFirst(described, kill.creature) >= 0)
		{
			PotP_Log(described + " died in " + kill.encounter + ", which finishes " + kill.tracked.entry_name, 'QuestHook');
			PotP_DoCompleteEvent(kill.tracked.entry_name);
		}
	}
}

//---------------------------------------------------

function PotP_RegisterQuestListener(catalog: CPotP_Catalog)
{
	NQH_Register('ProgressOnThePath', (new CPotP_QuestListener in catalog).Init(catalog));
}
