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

	public function AddQuest(suffix: string, type_value: PotP_Preview_Entry_Type, region_value: PotP_Preview_Region, filter_value: PotP_Preview_Quest_Filter, journal_name: string)
	{
		var tracked : CPotP_Entry = NewEntry(suffix, PotP_A_Quest, type_value, region_value, filter_value, 0);
		tracked.entry_name = journal_name;
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

	private function AddQuestBlock(kind: EPotP_QuestBlockKind, guid: string, output: string, location: string)
	{
		var block : SPotP_QuestBlock;

		block.guid = StrLower(guid);
		block.output = output;
		block.kind = kind;
		block.location = location;
		block.tracked = pending[pending.Size() - 1];
		quest_blocks.PushBack(block);
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
	}

	//---------------------------------------------------

	// The place added just before has a second name for its pin: counted under either, and the pin finder
	// treats both as tracked. As text, for names a script can't write, such as the engine's MISSING_NAME_ ones:
	// it's found among the map's pins, and does nothing if no pin has it.
	public function AddWorldAltPin(pin_text: string)
	{
		var tracked : CPotP_Entry = pending[pending.Size() - 1];

		tracked.alt_pin_name = PotP_FindPinName(pin_text);
		PotP_Log(tracked.pin_name + " can also be " + pin_text + ": " + (tracked.alt_pin_name != '') + " on this map", 'Catalog');
	}

	//---------------------------------------------------

	public function AddItem(suffix: string, type_value: PotP_Preview_Entry_Type, filter_value: PotP_Preview_Items_Filter, sub_filter_value: PotP_Preview_Items_Underlying_Filter, base_item: name, optional variation_1: name, optional variation_2: name, optional variation_3: name, optional variation_4: name)
	{
		var tracked : CPotP_Entry = NewEntry(suffix, PotP_A_Items, type_value, PotP_R_NA, filter_value, sub_filter_value);

		tracked.SetItem(base_item);
		tracked.AddVariation(variation_1);
		tracked.AddVariation(variation_2);
		tracked.AddVariation(variation_3);
		tracked.AddVariation(variation_4);
	}

	//---------------------------------------------------

	public function AddPrepared(tracked: CPotP_Entry)
	{
		pending.PushBack(tracked);
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

		parent.is_ready = true;
		PotP_Log("Catalog built: " + IntToString(parent.entries.Size()) + " entries in " + IntToString(parent.sections.Size()) + " sections", 'Catalog');

		// Leaving the state ends this function, so hand over first.
		parent.master.OnCatalogReady();
		parent.GotoState('Idle');
	}
}
