//---------------------------------------------------
//-- Quest Titles -----------------------------------
//---------------------------------------------------
// Every quest the game's journals have, the game's own, its DLC's and every installed mod's, by its base name, with its
// title's string id. The overlay reads the journals and sends them here as the scripts start. The map lives on theGame,
// so it lasts through every save loaded after. Quests the definitions give no title id to look theirs up here.

class CPotP_QuestTitles
{
	public var names	: array<string>;   // base names, lowered
	public var ids		: array<int>;
	public var complete	: bool;
}

@addField(CR4Game)
var potp_quest_titles : CPotP_QuestTitles;

//---------------------------------------------------

// The overlay looks for this before it sends anything, so older scripts don't get exec lines they don't know
function PotP_QuestTitlesWanted() : bool
{
	return true;
}

// 0 when the overlay hasn't sent the titles, or no journal has this quest
function PotP_QuestTitleId(base_name: string) : int
{
	var store	: CPotP_QuestTitles = theGame.potp_quest_titles;
	var Idx		: int;

	if (!store || !store.complete)
	{
		return 0;
	}
	Idx = store.names.FindFirst(StrLower(base_name));
	if (Idx < 0)
	{
		return 0;
	}
	return store.ids[Idx];
}

//---------------------------------------------------

exec function potp_questtitles_begin(count: int)
{
	var game	: CR4Game = theGame;

	game.potp_quest_titles = new CPotP_QuestTitles in theGame;
}

exec function potp_questtitle(base_name: string, id: int)
{
	var store : CPotP_QuestTitles = theGame.potp_quest_titles;

	if (store && !store.complete)
	{
		store.names.PushBack(StrLower(PotPAch_Decode(base_name)));
		store.ids.PushBack(id);
	}
}

exec function potp_questtitles_end(count: int)
{
	var store	: CPotP_QuestTitles = theGame.potp_quest_titles;
	var main	: CPotP_Main;
	var Idx		: int;
	var id		: int;

	if (!store)
	{
		return;
	}
	store.complete = store.names.Size() == count;
	PotP_Log("Quest titles from the journals: " + IntToString(store.names.Size()) + " of " + IntToString(count), 'Catalog');
	if (!store.complete || !thePlayer)
	{
		return;
	}

	// A list built before the titles came: the quests still showing their base name get theirs now
	main = PotP_Get();
	if (!main || !main.catalog)
	{
		return;
	}
	for (Idx = 0; Idx < main.catalog.quest_refs.Size(); Idx += 1)
	{
		if (main.catalog.quest_refs[Idx].title == main.catalog.quest_refs[Idx].entry_name)
		{
			id = PotP_QuestTitleId(main.catalog.quest_refs[Idx].entry_name);
			if (id <= 0 && main.catalog.quest_refs[Idx].alt_entry_name != "")
			{
				// The other version of its mod is the one installed: track it by that name
				id = PotP_QuestTitleId(main.catalog.quest_refs[Idx].alt_entry_name);
				if (id > 0)
				{
					main.catalog.quest_refs[Idx].entry_name = main.catalog.quest_refs[Idx].alt_entry_name;
					main.catalog.quest_keys[Idx] = main.catalog.quest_refs[Idx].alt_entry_name;
				}
			}
			if (id > 0)
			{
				main.catalog.quest_refs[Idx].title = GetLocStringById(id);
			}
		}
	}
}
