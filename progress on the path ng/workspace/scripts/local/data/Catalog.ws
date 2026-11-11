//---------------------------------------------------
//-- Catalog ----------------------------------------
//---------------------------------------------------

statemachine class CPotP_Catalog
{
	default autoState = 'Idle';

	var master				: CPotP_Main;
	var sections			: array<CPotP_Section>;
	var entries				: array<CPotP_Entry>;
	var world_entries		: array<CPotP_Entry>;
	var event_entries		: array<CPotP_Entry>;
	var is_ready			: bool;

	var identifiers			: array<string>;
	var uuids				: array<string>;
	var quest_keys			: array<string>;
	var quest_refs			: array<CPotP_Entry>;
	var event_keys			: array<string>;
	var item_keys			: array<name>;
	var item_refs			: array<CPotP_Entry>;
	var missable_sections	: array<CPotP_Section>;
	var missable_entries	: array<CPotP_Entry>;
	var missable_uuids		: array<string>;
	var missable_groups		: array<CPotP_Section>;
	var missable_tips		: array<string>;
	var quest_blocks		: array<SPotP_QuestBlock>;   // vanilla blocks that move events on, heard through Native Quest Hook
	var event_kills			: array<SPotP_EventKill>;    // deaths that finish events, for events without quest blocks
	var events_near			: array<CPotP_Entry>;      // events begun by coming near their pin (AddEventOpenedNear)
	var library_shelf		: int;              // the Library shelf being defined, from 0 (PotP_LibraryShelf's numbers)
	var library_readables	: array<name>;      // every readable item the game has, read once a build for AddModBooks

	var current_section		: CPotP_Section;
	var pending				: array<CPotP_Entry>;
	var next_quest_id		: int;
	var next_event_id		: int;
	var next_world_id		: int;
	var next_items_id		: int;

	//---------------------------------------------------

	public function Initialise(main: CPotP_Main)
	{
		master = main;
	}

	//---------------------------------------------------

	public function Rebuild()
	{
		is_ready = false;
		GotoState('Idle');
		GotoState('Building');
	}

	//---------------------------------------------------

	public function Reset()
	{
		sections.Clear();
		entries.Clear();
		world_entries.Clear();
		event_entries.Clear();
		identifiers.Clear();
		uuids.Clear();
		quest_keys.Clear();
		quest_refs.Clear();
		event_keys.Clear();
		item_keys.Clear();
		item_refs.Clear();
		missable_sections.Clear();
		missable_entries.Clear();
		missable_uuids.Clear();
		missable_groups.Clear();
		missable_tips.Clear();
		quest_blocks.Clear();
		event_kills.Clear();
		events_near.Clear();
		library_readables.Clear();
		library_shelf = -1;
		pending.Clear();
		current_section = NULL;

		next_quest_id = 1000;
		next_event_id = 1000;
		next_world_id = 1000;
		next_items_id = 1000;
	}

	//---------------------------------------------------
	//-- Definition API ---------------------------------
	//---------------------------------------------------

	public function BeginSection(book_value: EPotP_Book, header_key: string, category_value: PotP_Preview_Array_Type, group_prefix: string)
	{
		current_section = (new CPotP_Section in this).Init(book_value, header_key, category_value, group_prefix);
		pending.Clear();
	}

	//---------------------------------------------------

	public function MarkSectionNeedsSkellige()
	{
		current_section.needs_skellige = true;
	}

	//---------------------------------------------------

	public function NewEntry(suffix: string, category_value: PotP_Preview_Array_Type, type_value: PotP_Preview_Entry_Type, region_value: PotP_Preview_Region, filter_value: int, sub_filter_value: int) : CPotP_Entry
	{
		var entry_uuid	: string = current_section.group + suffix;
		var tracked		: CPotP_Entry = (new CPotP_Entry in this).Init(entry_uuid, category_value, type_value, region_value, filter_value, sub_filter_value);

		tracked.title = GetLocStringByKeyExt("option_" + entry_uuid);
		pending.PushBack(tracked);
		return tracked;
	}

	//---------------------------------------------------

	// title_id: the quest's title in the game's own strings (its journal entry's title). Without one, as a mod's quests
	// have, the title the overlay found in the quest's journal, or until then its base name.
	public function AddQuest(suffix: string, type_value: PotP_Preview_Entry_Type, region_value: PotP_Preview_Region, filter_value: PotP_Preview_Quest_Filter, journal_name: string, optional title_id: int)
	{
		var tracked : CPotP_Entry = NewEntry(suffix, PotP_A_Quest, type_value, region_value, filter_value, 0);
		tracked.entry_name = journal_name;
		if (title_id <= 0)
		{
			title_id = PotP_QuestTitleId(journal_name);
		}
		if (title_id > 0)
		{
			tracked.title = GetLocStringById(title_id);
		}
		else if (StrLen(tracked.title) == 0 || StrBeginsWith(tracked.title, "#"))
		{
			tracked.title = journal_name;
		}
	}

	// The quest's journal name in another version of its mod. Whichever of the two the installed journals have is the one
	// tracked, as the overlay's table of journals says; with neither in it, the first stays.
	public function AddQuestAltJournal(journal_name: string)
	{
		var tracked	: CPotP_Entry = pending[pending.Size() - 1];
		var id		: int;

		tracked.alt_entry_name = journal_name;
		if (PotP_QuestTitleId(tracked.entry_name) > 0)
		{
			return;
		}
		id = PotP_QuestTitleId(journal_name);
		if (id > 0)
		{
			PotP_Log(tracked.entry_name + " is " + journal_name + " in the installed version of its mod", 'Catalog');
			tracked.entry_name = journal_name;
			tracked.title = GetLocStringById(id);
		}
	}

	//---------------------------------------------------

	public function AddEvent(suffix: string, type_value: PotP_Preview_Entry_Type, region_value: PotP_Preview_Region, unlocked: bool, pin_region: string, fact_name: string, pin_position: Vector, optional from_hour: int, optional to_hour: int)
	{
		var tracked : CPotP_Entry = NewEntry(suffix, PotP_A_Event, type_value, region_value, PotP_I_Event, 0);
		tracked.entry_name		= fact_name;
		tracked.map_region		= pin_region;
		tracked.position		= pin_position;
		tracked.starts_unlocked	= unlocked;
		tracked.from_hour		= from_hour;
		tracked.to_hour			= to_hour;
	}

	//---------------------------------------------------

	// The vanilla quest blocks that move the event added just before on, heard through Native Quest Hook.
	// guid is the block's, as W3 Mod Workbench shows it. output is the one that counts, "None" for an unnamed one.

	// The event added just before is done when a creature dies inside an encounter's own area, as the game draws it.
	// creature: part of the creature's template name, such as "werewolf_lvl3__lycan". encounter: the encounter's tag.

	public function AddEventKill(creature: string, encounter: name)
	{
		var kill : SPotP_EventKill;

		kill.creature = StrLower(creature);
		kill.encounter = encounter;
		kill.tracked = pending[pending.Size() - 1];
		event_kills.PushBack(kill);
	}

	//---------------------------------------------------

	public function AddEventDoneBlock(guid: string, output: string)
	{
		AddQuestBlock(PotP_QB_Done, guid, output, "");
	}

	// location: the place the notification names, a string key
	public function AddEventUnlockBlock(guid: string, output: string, location: string)
	{
		AddQuestBlock(PotP_QB_Unlock, guid, output, location);
	}

	public function AddEventMissedBlock(guid: string, output: string)
	{
		AddQuestBlock(PotP_QB_Missed, guid, output, "");
	}

	// For an entry built elsewhere, as the relic weapons are, rather than the one added just before
	public function AddMissedBlockFor(tracked: CPotP_Entry, guid: string, output: string)
	{
		AddQuestBlockFor(tracked, PotP_QB_Missed, guid, output, "");
	}

	private function AddQuestBlock(kind: EPotP_QuestBlockKind, guid: string, output: string, location: string)
	{
		AddQuestBlockFor(pending[pending.Size() - 1], kind, guid, output, location);
	}

	private function AddQuestBlockFor(tracked: CPotP_Entry, kind: EPotP_QuestBlockKind, guid: string, output: string, location: string)
	{
		var block : SPotP_QuestBlock;

		block.guid = StrLower(guid);
		block.output = output;
		block.kind = kind;
		block.location = location;
		block.tracked = tracked;
		quest_blocks.PushBack(block);
	}

	// What came of the event added just before: its paragraph (a BIA string id, potp_outcome_<id> in en.csv), told once
	// this vanilla block finishes through this output. requires: only if that paragraph came first, as when the same
	// block ends a fight whatever led to it. Traced from where Brothers In Arms' own phases set the fact for each.
	public function AddEventOutcome(guid: string, output: string, paragraph: int, optional requires: int)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];
		var block : SPotP_QuestBlock;

		block.guid = StrLower(guid);
		block.output = output;
		block.kind = PotP_QB_Outcome;
		block.paragraph = paragraph;
		block.requires = requires;
		block.tracked = tracked;
		quest_blocks.PushBack(block);
		if (!tracked.lore_outcomes.Contains(paragraph))
		{
			tracked.lore_outcomes.PushBack(paragraph);
		}
	}

	// Paying or the Axii Sign, where a scene ends through the same output either way: told apart by whether he has
	// fewer crowns than when the scene started (its pay choice takes them)
	public function AddEventOutcomePaid(guid: string, output: string, paid: int, unpaid: int)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];
		var block : SPotP_QuestBlock;

		block.guid = StrLower(guid);
		block.output = output;
		block.kind = PotP_QB_OutcomePaid;
		block.paragraph = paid;
		block.unpaid = unpaid;
		block.tracked = tracked;
		quest_blocks.PushBack(block);
		tracked.lore_outcomes.PushBack(paid);
		tracked.lore_outcomes.PushBack(unpaid);
	}

	// The vanilla block that shows Geralt has come upon the event added just before, as BIA's "met" facts are set:
	// its opening shows from then on. Events stay not started until they're done, so this is what begins their story.
	public function AddEventOpened(guid: string, output: string)
	{
		var block : SPotP_QuestBlock;

		block.guid = StrLower(guid);
		block.output = output;
		block.kind = PotP_QB_Opened;
		block.tracked = pending[pending.Size() - 1];
		quest_blocks.PushBack(block);
	}

	// For an event with no quest block to tell he's come upon it, as Call of the Wild's encounter has none: begun
	// once he's within this many metres of its pin, in its region, in its hours
	public function AddEventOpenedNear(radius: float)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.opened_radius = radius;
		events_near.PushBack(tracked);
	}

	// What came of an event that's done by a kill, not a quest block: told once it counts as done
	public function AddEventDoneOutcome(paragraph: int)
	{
		pending[pending.Size() - 1].lore_done = paragraph;
	}

	//---------------------------------------------------

	// The event added just before: its title in Brothers In Arms' Events (mersey's, its own journal quests for the
	// random events). With that installed its journal tells the story, choices and all; without it, PotP's own copy of
	// the opening, potp_lore_<uuid> in en.csv, given with mersey's permission.
	public function AddEventLore(title_id: int)
	{
		pending[pending.Size() - 1].lore_title = title_id;
	}

	//---------------------------------------------------

	public function AddEventFacts(optional fact_1: string, optional fact_2: string, optional fact_3: string, optional fact_4: string, optional fact_5: string, optional fact_6: string, optional fact_7: string, optional fact_8: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.AddFallbackFact(fact_1);
		tracked.AddFallbackFact(fact_2);
		tracked.AddFallbackFact(fact_3);
		tracked.AddFallbackFact(fact_4);
		tracked.AddFallbackFact(fact_5);
		tracked.AddFallbackFact(fact_6);
		tracked.AddFallbackFact(fact_7);
		tracked.AddFallbackFact(fact_8);
	}

	//---------------------------------------------------
	// Applies to the quest added just before, for quests the game removes from the journal
	// so that no status is left to read. done_fact is set when the quest is finished,
	// missed_fact when the game takes it away unfinished.

	public function AddQuestFacts(done_fact: string, optional missed_fact: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.AddFallbackFact(done_fact);
		tracked.missed_fact = missed_fact;
	}

	//---------------------------------------------------
	// Applies to the entry added just before: after_fact marks the moment the game decided, and unless_fact is set if it
	// decided the player's way.

	public function AddMissedUnless(after_fact: string, unless_fact: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.missed_fact = after_fact;
		tracked.missed_unless = unless_fact;
	}

	//---------------------------------------------------

	// Another fact that says the entry added just before is missed, for an item lost more than one way: after_fact set,
	// unless unless_fact is too
	public function AddMissedFact(after_fact: string, optional unless_fact: string)
	{
		AddMissedFactFor(pending[pending.Size() - 1], after_fact, unless_fact);
	}

	public function AddMissedFactFor(tracked: CPotP_Entry, after_fact: string, optional unless_fact: string)
	{
		tracked.more_missed_after.PushBack(after_fact);
		tracked.more_missed_unless.PushBack(unless_fact);
	}

	//---------------------------------------------------

	public function AddAlsoMissedFact(fact_name: string)
	{
		pending[pending.Size() - 1].also_missed_fact = fact_name;
	}

	//---------------------------------------------------

	public function AddOutcomeFacts(fact_1: string, optional fact_2: string, optional fact_3: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.outcome_facts.PushBack(fact_1);
		if (fact_2 != "") { tracked.outcome_facts.PushBack(fact_2); }
		if (fact_3 != "") { tracked.outcome_facts.PushBack(fact_3); }
	}

	//---------------------------------------------------
	// Applies to the event added just before: it's open once all of these facts of the game's are set.

	public function AddEventUnlockFacts(fact_1: string, optional fact_2: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.unlock_facts.PushBack(fact_1);
		if (fact_2 != "")
		{
			tracked.unlock_facts.PushBack(fact_2);
		}
	}

	//---------------------------------------------------
	// For an event with no usable fact: a journal quest another mod completes for it.

	public function AddEventJournal(journal_tag: name)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.fallback_journal = journal_tag;
	}

	//---------------------------------------------------

	public function AddWorld(suffix: string, region_value: PotP_Preview_Region, filter_value: PotP_Preview_World_Filter, type_value: PotP_Preview_Entry_Type, pin: name)
	{
		var tracked : CPotP_Entry = NewEntry(suffix, PotP_A_World, type_value, region_value, filter_value, 0);
		tracked.pin_name = pin;
		// With no name of our own, the pin's name on the game's map, as signposts have
		if (StrLen(tracked.title) == 0 || StrBeginsWith(tracked.title, "#"))
		{
			tracked.title = PotP_CleanTitle(PotP_LocOrDefault(StrLower("map_location_" + NameToString(pin)), NameToString(pin)));
		}
	}

	//---------------------------------------------------

	// The place added just before has a second name for its pin: counted under either, and the pin finder
	// treats both as tracked. As text, for names a script can't write, such as the engine's MISSING_NAME_ ones:
	// it's found among the map's pins, and does nothing if no pin has it.
	// Why the last entry can be missed (a string key for the overlay's callout), and the facts that say it has been: one the
	// game sets, and PotP's own for the quest blocks that miss it as they happen (AddEventMissedBlock)
	public function SetMissableReason(tip_key: string, optional missed_fact: string)
	{
		SetMissableReasonFor(pending[pending.Size() - 1], tip_key, missed_fact);
	}

	public function SetMissableReasonFor(tracked: CPotP_Entry, tip_key: string, optional missed_fact: string)
	{
		tracked.missable_tip = tip_key;
		if (missed_fact != "")
		{
			tracked.missed_fact = missed_fact;
		}
		tracked.also_missed_fact = "PotP_Missed_" + tracked.uuid;
	}

	//---------------------------------------------------

	public function AddWorldAltPin(pin_text: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.alt_pin_name = PotP_FindPinName(pin_text);
		PotP_Log(tracked.pin_name + " can also be " + pin_text + ": " + (tracked.alt_pin_name != '') + " on this map", 'Catalog');
	}

	//---------------------------------------------------

	public function AddItem(suffix: string, type_value: PotP_Preview_Entry_Type, filter_value: PotP_Preview_Items_Filter, sub_filter_value: PotP_Preview_Items_Underlying_Filter, base_item: name, optional variation_1: name, optional variation_2: name, optional variation_3: name, optional variation_4: name) : CPotP_Entry
	{
		var tracked	: CPotP_Entry = NewEntry(suffix, PotP_A_Items, type_value, PotP_R_NA, filter_value, sub_filter_value);
		var game	: string;

		// With no title of our own, the item's name in the game's own strings
		if (StrLen(tracked.title) == 0 || StrBeginsWith(tracked.title, "#"))
		{
			game = PotP_CleanTitle(GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(base_item)));
			if (StrLen(game) == 0 || StrBeginsWith(game, "#"))
			{
				// A mod that gives the item no name: its name in the item definitions, at least
				game = NameToString(base_item);
			}
			tracked.title = game;
		}

		tracked.SetItem(base_item);
		tracked.AddVariation(variation_1);
		tracked.AddVariation(variation_2);
		tracked.AddVariation(variation_3);
		tracked.AddVariation(variation_4);
		return tracked;
	}

	//---------------------------------------------------

	public function AddPrepared(tracked: CPotP_Entry)
	{
		pending.PushBack(tracked);
	}

	//---------------------------------------------------

	// The Library's: header_key is the section's name, one of the overlay's strings
	public function BeginLibrarySection(header_key: string)
	{
		BeginSection(PotP_Book_Library, header_key, PotP_A_Library, "PotP_Library_");
		library_shelf += 1;
	}

	//---------------------------------------------------

	// A book, by its item: read when the game says so (StatusResolver), named as the game names it
	public function AddBook(suffix: string, type_value: PotP_Preview_Entry_Type, book: name) : CPotP_Entry
	{
		var tracked	: CPotP_Entry = NewEntry(suffix, PotP_A_Library, type_value, PotP_R_NA, 0, 0);
		var title	: string;

		title = PotP_CleanTitle(GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(book)));
		if (StrLen(title) == 0 || StrBeginsWith(title, "#"))
		{
			title = NameToString(book);
		}
		tracked.title = title;
		tracked.item_name = book;
		tracked.shelf = library_shelf;
		return tracked;
	}

	//---------------------------------------------------

	// A note: a journal, a letter, a notice or any other sheet with something to read. As a book; not tracked unless its
	// shelf is turned on in Tracked Contents, as many belong to one side of a quest, or are gone once it's over.
	public function AddNote(suffix: string, type_value: PotP_Preview_Entry_Type, note: name) : CPotP_Entry
	{
		var tracked : CPotP_Entry = AddBook(suffix, type_value, note);

		tracked.is_note = true;
		tracked.is_journal = library_shelf == 2;
		return tracked;
	}

	//---------------------------------------------------

	// What a mod adds, on the shelf it belongs to (PotP_LibraryShelf: 0 Lore Books, 1 Monster Tomes, then the notes'),
	// into the section being defined: every readable item the game has that the Library doesn't list yet and
	// LibraryShelf puts there. Called before the section ends, so they're sorted in with the game's own.
	public function AddModBooks(shelf: int)
	{
		var defs	: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		var listed	: array<name>;
		var Idx		: int;

		if (library_readables.Size() == 0)
		{
			library_readables = defs.GetItemsWithTag('ReadableItem');
		}
		for (Idx = 0; Idx < pending.Size(); Idx += 1)
		{
			listed.PushBack(pending[Idx].item_name);
		}
		for (Idx = 0; Idx < entries.Size(); Idx += 1)
		{
			if (entries[Idx].category == PotP_A_Library)
			{
				listed.PushBack(entries[Idx].item_name);
			}
		}

		for (Idx = 0; Idx < library_readables.Size(); Idx += 1)
		{
			if (listed.Contains(library_readables[Idx]) || PotP_LibraryShelf(defs, library_readables[Idx]) != shelf)
			{
				continue;
			}
			listed.PushBack(library_readables[Idx]);
			if (shelf >= 2)
			{
				AddNote(PotP_SanitizeUuid(StrLower(NameToString(library_readables[Idx]))), PotP_E_ModAdded, library_readables[Idx]);
			}
			else
			{
				AddBook(PotP_SanitizeUuid(StrLower(NameToString(library_readables[Idx]))), PotP_E_ModAdded, library_readables[Idx]);
			}
		}
	}

	//---------------------------------------------------

	public function BeginBestiarySection(name_id: int)
	{
		BeginSection(PotP_Book_Bestiary, "", PotP_A_Bestiary, "PotP_Bestiary_");
		current_section.header_id = name_id;
	}

	//---------------------------------------------------

	public function AddBestiary(suffix: string, type_value: PotP_Preview_Entry_Type, name_id: int, image: string, texts: string) : CPotP_Entry
	{
		var tracked	: CPotP_Entry = NewEntry(suffix, PotP_A_Bestiary, type_value, PotP_R_NA, 0, 0);
		var left	: string;
		var part	: string;

		tracked.title = GetLocStringById(name_id);
		tracked.creature_name_id = name_id;
		tracked.creature_image = image;

		left = texts;
		while (left != "")
		{
			part = left;
			if (StrFindFirst(left, ",") >= 0)
			{
				part = StrBeforeFirst(left, ",");
				left = StrAfterFirst(left, ",");
			}
			else
			{
				left = "";
			}
			tracked.creature_texts.PushBack(StringToInt(part));
		}
		return tracked;
	}

	//---------------------------------------------------

	public function BeginMissableGroup(header_key: string, kind_value: EPotP_MissableKind, optional cutoff_uuid: string, optional trigger_value: EPotP_CutoffTrigger)
	{
		var missable : CPotP_Section = (new CPotP_Section in this).InitMissable(header_key, kind_value, cutoff_uuid, trigger_value);

		sections.PushBack(missable);
		missable_sections.PushBack(missable);
	}

	//---------------------------------------------------

	public function AddMissable(uuid_value: string, optional tip_key: string)
	{
		missable_uuids.PushBack(uuid_value);
		missable_groups.PushBack(missable_sections[missable_sections.Size() - 1]);
		missable_tips.PushBack(tip_key);
	}

	//---------------------------------------------------

	public function ResolveMissableCutoffs()
	{
		var Idx : int;

		for (Idx = 0; Idx < missable_sections.Size(); Idx += 1)
		{
			if (missable_sections[Idx].cutoff_uuid == "")
			{
				continue;
			}

			missable_sections[Idx].cutoff = FindByUuid(missable_sections[Idx].cutoff_uuid);
			if (!missable_sections[Idx].cutoff)
			{
				PotP_Log("Missable group cutoff not found: " + missable_sections[Idx].cutoff_uuid, 'Catalog');
			}
		}
	}

	//---------------------------------------------------

	public function EndSection()
	{
		var sorted		: array<CPotP_Entry>;
		var Idx, Jdx	: int;

		for (Idx = 0; Idx < pending.Size(); Idx += 1)
		{
			Jdx = sorted.Size();
			while (Jdx > 0)
			{
				if (StrCmp(sorted[Jdx - 1].title, pending[Idx].title) <= 0)
				{
					break;
				}
				Jdx -= 1;
			}
			sorted.Insert(Jdx, pending[Idx]);
		}

		for (Idx = 0; Idx < sorted.Size(); Idx += 1)
		{
			Register(sorted[Idx]);
			current_section.entries.PushBack(sorted[Idx]);
		}

		sections.PushBack(current_section);
		pending.Clear();
		current_section = NULL;
	}

	//---------------------------------------------------

	private function Register(tracked: CPotP_Entry)
	{
		var Idx : int;

		tracked.identifier = NextIdentifier(tracked.category);
		entries.PushBack(tracked);
		identifiers.PushBack(tracked.identifier);
		uuids.PushBack(tracked.uuid);

		switch (tracked.category)
		{
		case PotP_A_Quest:
			quest_keys.PushBack(tracked.entry_name);
			quest_refs.PushBack(tracked);
			AddToMissableGroup(tracked);
			break;

		case PotP_A_Event:
			AddToMissableGroup(tracked);
			event_keys.PushBack(tracked.entry_name);
			event_entries.PushBack(tracked);
			break;

		case PotP_A_World:
			world_entries.PushBack(tracked);
			break;

		case PotP_A_Items:
		case PotP_A_Gwent:
			for (Idx = 0; Idx < tracked.variations.Size(); Idx += 1)
			{
				item_keys.PushBack(tracked.variations[Idx]);
				item_refs.PushBack(tracked);
			}
			break;
		}
	}

	//---------------------------------------------------

	private function AddToMissableGroup(tracked: CPotP_Entry)
	{
		var Idx : int = missable_uuids.FindFirst(tracked.uuid);

		if (Idx == -1)
		{
			if (tracked.is_missable)
			{
				PotP_Log("Missable quest without a missable group: " + tracked.uuid, 'Catalog');
			}
			return;
		}

		tracked.is_missable		= true;
		tracked.missable_group	= missable_groups[Idx];
		tracked.missable_tip	= missable_tips[Idx];
		missable_groups[Idx].entries.PushBack(tracked);
		missable_entries.PushBack(tracked);
	}

	//---------------------------------------------------

	private function NextIdentifier(category_value: PotP_Preview_Array_Type) : string
	{
		switch (category_value)
		{
		case PotP_A_Quest:
			next_quest_id += 1;
			return "QX" + IntToString(next_quest_id);

		case PotP_A_Event:
			next_event_id += 1;
			return "EX" + IntToString(next_event_id);

		case PotP_A_World:
			next_world_id += 1;
			return "WX" + IntToString(next_world_id);

		default:
			next_items_id += 1;
			return "IX" + IntToString(next_items_id);
		}
	}

	//---------------------------------------------------
	//-- Lookups ----------------------------------------
	//---------------------------------------------------

	public function FindQuest(journal_name: string) : CPotP_Entry
	{
		var Idx : int = quest_keys.FindFirst(journal_name);

		if (Idx == -1)
		{
			return NULL;
		}
		return quest_refs[Idx];
	}

	//---------------------------------------------------

	public function FindEvent(fact_name: string) : CPotP_Entry
	{
		var Idx : int = event_keys.FindFirst(fact_name);

		if (Idx == -1)
		{
			return NULL;
		}
		return event_entries[Idx];
	}

	//---------------------------------------------------

	public function FindItem(item: name) : CPotP_Entry
	{
		var Idx : int = item_keys.FindFirst(item);

		if (Idx == -1)
		{
			return NULL;
		}
		return item_refs[Idx];
	}

	//---------------------------------------------------

	public function IsItemRegistered(item: name) : bool
	{
		return item_keys.Contains(item);
	}

	//---------------------------------------------------

	public function FindByIdentifier(identifier_value: string) : CPotP_Entry
	{
		var Idx : int = identifiers.FindFirst(identifier_value);

		if (Idx == -1)
		{
			return NULL;
		}
		return entries[Idx];
	}

	//---------------------------------------------------

	public function FindByUuid(uuid_value: string) : CPotP_Entry
	{
		var Idx : int = uuids.FindFirst(uuid_value);

		if (Idx == -1)
		{
			return NULL;
		}
		return entries[Idx];
	}

	//---------------------------------------------------

	// Each entry told whether its kind is tracked (Settings.ws, Tracked Contents): once the catalog's built, and again
	// when a toggle changes
	public function ApplyTracking()
	{
		var Idx : int;

		for (Idx = 0; Idx < entries.Size(); Idx += 1)
		{
			entries[Idx].untracked = !PotP_IsTracked(entries[Idx]);
		}
	}

	//---------------------------------------------------

	public function CountProgress(out total_count: int, out done_count: int)
	{
		var gwent			: CR4GwintManager = theGame.GetGwintManager();
		var has_cards		: bool = gwent.HasLootedCard();
		var has_skellige	: bool = gwent.IsDeckUnlocked(GwintFaction_Skellige);
		var Idx				: int;

		total_count = 0;
		done_count = 0;

		for (Idx = 0; Idx < entries.Size(); Idx += 1)
		{
			if (entries[Idx].category == PotP_A_Gwent)
			{
				if (!has_cards || (entries[Idx].sub_filter == PotP_I_Skell && !has_skellige))
				{
					continue;
				}
			}
			// A kind turned off in Tracked Contents isn't counted (the Library's are off unless they're turned on)
			if (entries[Idx].untracked)
			{
				continue;
			}

			total_count += 1;
			if (entries[Idx].IsDone())
			{
				done_count += 1;
			}
		}
	}

	//---------------------------------------------------
	// DO NOT FUCKING TOUCH THIS - THIS TOOK ME WAY TOO LONG TO FIGURE OUT.
	// Changes whenever tracked content is swapped (mods installed or removed) even
	// when the entry count happens to stay the same. Order inside a section is not
	// stable between sessions (the game returns item and card tables unordered), so
	// only each section's position is weighted, never an entry's.
	// Facts hold 16-bit signed values, so the result must stay below 32767.

	public function GetChecksum() : int
	{
		var section_sum	: int;
		var checksum	: int;
		var Sdx, Idx	: int;

		for (Sdx = 0; Sdx < sections.Size(); Sdx += 1)
		{
			if (sections[Sdx].book == PotP_Book_Missable)
			{
				continue;
			}

			section_sum = 0;
			for (Idx = 0; Idx < sections[Sdx].entries.Size(); Idx += 1)
			{
				section_sum += StrLen(sections[Sdx].entries[Idx].uuid);
			}
			checksum = (checksum + section_sum * (Sdx % 97 + 1)) % 30000;
		}
		return checksum;
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CPotP_Catalog
{
}

//---------------------------------------------------

state Building in CPotP_Catalog
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.Build();
	}

	//---------------------------------------------------

	entry function Build()
	{
		var dynamic_items : CPotP_DynamicItems = new CPotP_DynamicItems in parent;
		var dynamic_pins : CPotP_DynamicPins = new CPotP_DynamicPins in parent;

		parent.Reset();

		PotP_DefineMissables(parent);
		PotP_DefineEvents(parent);
		PotP_DefineQuests(parent);
		parent.ResolveMissableCutoffs();
		SleepOneFrame();

		PotP_DefineWorld(parent);
		SleepOneFrame();

		// Signposts are registered above; the unnamed pins are named after them.
		dynamic_pins.Build(parent, 'Contraband', "PotP_Cache_", "PotP_Preview_Cache_", PotP_I_Cache);
		dynamic_pins.Build(parent, 'SpoilsOfWar', "PotP_Spoils_", "PotP_Preview_Spoils_", PotP_I_Spoil);
		SleepOneFrame();

		// Many of these also belong to a treasure hunt quest. They are tracked anyway,
		// so the list matches what the map shows.
		dynamic_pins.Build(parent, 'TreasureHuntMappin', "PotP_Hidden_", "PotP_Preview_Hidden_", PotP_I_Hiddn);
		SleepOneFrame();

		PotP_DefineItems(parent);
		SleepOneFrame();

		// Static sets are registered first so dynamic scans skip items they already own.
		dynamic_items.BuildTagged(parent, 'Trophy', "PotP_Trophy_", "PotP_Preview_Troph_1", PotP_I_Troph, PotP_U_Troph);
		SleepOneFrame();
		dynamic_items.BuildTagged(parent, 'crossbow', "PotP_Crossbow_", "PotP_Preview_Relic_3", PotP_I_Relic, PotP_U_Cross);
		SleepOneFrame();
		dynamic_items.BuildTagged(parent, 'PlayerSteelWeapon', "PotP_Steel_", "PotP_Preview_Relic_2", PotP_I_Relic, PotP_U_Steel);
		SleepOneFrame();
		dynamic_items.BuildTagged(parent, 'PlayerSilverWeapon', "PotP_Silver_", "PotP_Preview_Relic_1", PotP_I_Relic, PotP_U_Silve);
		SleepOneFrame();
		dynamic_items.BuildGwent(parent);
		SleepOneFrame();

		// Last, so the sections before it keep their places in the checksum
		PotP_DefineBestiary(parent);
		SleepOneFrame();
		PotP_DefineLibrary(parent);

		parent.ApplyTracking();
		parent.is_ready = true;
		PotP_Log("Catalog built: " + IntToString(parent.entries.Size()) + " entries in " + IntToString(parent.sections.Size()) + " sections", 'Catalog');

		// Leaving the state ends this function, so hand over first.
		parent.master.OnCatalogReady();
		parent.GotoState('Idle');
	}
}
