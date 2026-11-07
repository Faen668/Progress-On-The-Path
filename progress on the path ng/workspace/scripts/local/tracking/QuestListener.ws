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
}

struct SPotP_QuestBlock
{
	var guid		: string;
	var output		: string;   // the output that counts, "None" for an unnamed one, such as a pause block's
	var kind		: EPotP_QuestBlockKind;
	var location	: string;   // for an unlock: the place the notification names
	var tracked		: CPotP_Entry;
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
