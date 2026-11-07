//---------------------------------------------------
//-- Status Resolver --------------------------------
//---------------------------------------------------

class CPotP_StatusResolver
{
	var map_manager			: CCommonMapManager;
	var gwent				: CR4GwintManager;
	var player_inventory	: CInventoryComponent;
	var stash_inventory		: CInventoryComponent;
	var horse_manager		: W3HorseManager;
	var leader_collection	: array<CName>;
	var known_creature_ids	: array<int>;
	var known_creatures		: array<CJournalCreature>;

	//---------------------------------------------------

	public function BeginPass()
	{
		map_manager			= theGame.GetCommonMapManager();
		gwent				= theGame.GetGwintManager();
		player_inventory	= thePlayer.GetInventory();
		horse_manager		= GetWitcherPlayer().GetHorseManager();
		stash_inventory		= horse_manager.GetInventoryComponent();
		leader_collection	= gwent.GetPlayerLeaderCollection();
		ReadKnownCreatures();
	}

	//---------------------------------------------------

	// As the game's own bestiary lists them: entries the journal has active
	private function ReadKnownCreatures()
	{
		var journal		: CWitcherJournalManager = theGame.GetJournalManager();
		var found		: array<CJournalBase>;
		var creature	: CJournalCreature;
		var Idx			: int;

		known_creature_ids.Clear();
		known_creatures.Clear();
		journal.GetActivatedOfType('CJournalCreature', found);
		for (Idx = 0; Idx < found.Size(); Idx += 1)
		{
			creature = (CJournalCreature)found[Idx];
			if (creature && journal.GetEntryStatus(creature) == JS_Active)
			{
				known_creature_ids.PushBack(creature.GetNameStringId());
				known_creatures.PushBack(creature);
			}
		}
	}

	//---------------------------------------------------

	// The entry the journal has for a tracked creature: its own, else one of the same creature's others
	public function KnownCreatureOf(tracked: CPotP_Entry) : CJournalCreature
	{
		var creature	: CJournalCreature = KnownCreature(tracked.creature_name_id);
		var Idx			: int;

		for (Idx = 0; !creature && Idx < tracked.creature_alt_ids.Size(); Idx += 1)
		{
			creature = KnownCreature(tracked.creature_alt_ids[Idx]);
		}
		return creature;
	}

	//---------------------------------------------------

	public function KnownCreature(name_id: int) : CJournalCreature
	{
		var Idx : int = known_creature_ids.FindFirst(name_id);

		if (Idx == -1)
		{
			return NULL;
		}
		return known_creatures[Idx];
	}

	//---------------------------------------------------

	public function Evaluate(tracked: CPotP_Entry) : EPotP_Status
	{
		return ApplyOverride(tracked, GetGameStatus(tracked));
	}

	//---------------------------------------------------

	public function EvaluateQuest(tracked: CPotP_Entry, journal_status: EJournalStatus) : EPotP_Status
	{
		return ApplyOverride(tracked, QuestGameStatus(tracked, journal_status));
	}

	//---------------------------------------------------

	public function QuestGameStatus(tracked: CPotP_Entry, journal_status: EJournalStatus) : EPotP_Status
	{
		var game_status : EPotP_Status = FromJournal(journal_status);

		// The game can remove a quest from the journal altogether, finished or not, which
		// leaves no journal status to read. Facts set by the quest itself fill the gap.
		if (game_status != PotP_S_Completed && HasFallbackFact(tracked))
		{
			game_status = PotP_S_Completed;
		}
		else if (game_status == PotP_S_Available && IsMissedByFacts(tracked))
		{
			game_status = PotP_S_Missed;
		}

		if (game_status == PotP_S_Completed && tracked.outcome_facts.Size() > 0 && !HasOutcomeFact(tracked))
		{
			game_status = PotP_S_Missed;
		}

		if (tracked.is_missable)
		{
			game_status = FromMissable(tracked, journal_status, game_status);
		}
		return game_status;
	}

	//---------------------------------------------------

	private function IsMissedByFacts(tracked: CPotP_Entry) : bool
	{
		var Idx : int;

		if (tracked.also_missed_fact != "" && FactsQuerySum(tracked.also_missed_fact) > 0)
		{
			return true;
		}
		for (Idx = 0; Idx < tracked.more_missed_after.Size(); Idx += 1)
		{
			if (FactsQuerySum(tracked.more_missed_after[Idx]) > 0
				&& (tracked.more_missed_unless[Idx] == "" || FactsQuerySum(tracked.more_missed_unless[Idx]) == 0))
			{
				return true;
			}
		}
		return tracked.missed_fact != "" && FactsQuerySum(tracked.missed_fact) > 0
			&& (tracked.missed_unless == "" || FactsQuerySum(tracked.missed_unless) == 0);
	}

	//---------------------------------------------------

	private function HasOutcomeFact(tracked: CPotP_Entry) : bool
	{
		var Idx : int;

		for (Idx = 0; Idx < tracked.outcome_facts.Size(); Idx += 1)
		{
			if (FactsQuerySum(tracked.outcome_facts[Idx]) > 0)
			{
				return true;
			}
		}
		return false;
	}

	//---------------------------------------------------

	private function FromMissable(tracked: CPotP_Entry, journal_status: EJournalStatus, game_status: EPotP_Status) : EPotP_Status
	{
		if (journal_status == JS_Failed)
		{
			return PotP_S_Missed;
		}

		if (game_status == PotP_S_Available && tracked.missable_group)
		{
			if (tracked.missable_group.IsCutoffPassed())
			{
				return PotP_S_Missed;
			}
		}
		return game_status;
	}

	//---------------------------------------------------

	public function FromJournal(journal_status: EJournalStatus) : EPotP_Status
	{
		switch (journal_status)
		{
		case JS_Success:
		case JS_Failed:
			return PotP_S_Completed;

		case JS_Active:
			return PotP_S_InProgress;

		default:
			return PotP_S_Available;
		}
	}

	//---------------------------------------------------

	public function ApplyOverride(tracked: CPotP_Entry, game_status: EPotP_Status) : EPotP_Status
	{
		var fact_name : string = PotP_Fact_Override(tracked.uuid);

		switch (FactsQuerySum(fact_name))
		{
		case 1:
			return PotP_S_Ignored;

		case 2:
			return PotP_S_Completed;

		case 3:
			if (game_status == PotP_S_Completed)
			{
				FactsRemove(fact_name);
				return PotP_S_Completed;
			}
			return PotP_S_Missed;

		default:
			return game_status;
		}
	}

	//---------------------------------------------------

	public function GetGameStatus(tracked: CPotP_Entry) : EPotP_Status
	{
		var game_status : EPotP_Status;

		switch (tracked.category)
		{
		case PotP_A_Event:
			game_status = Done(IsEventDone(tracked));
			if (game_status == PotP_S_Available && IsMissedByFacts(tracked))
			{
				return PotP_S_Missed;
			}
			if (tracked.is_missable)
			{
				return FromMissable(tracked, JS_Inactive, game_status);
			}
			return game_status;

		case PotP_A_World:
			// A place the game can close for good, as the Spiral's: missed by its facts until it's cleared
			game_status = Done(IsPinCleared(tracked));
			if (game_status == PotP_S_Available && IsMissedByFacts(tracked))
			{
				return PotP_S_Missed;
			}
			return game_status;

		case PotP_A_Items:
			// An item the game can take away for good, as Tiegr: missed by its facts until it's had
			game_status = Done(IsItemCollected(tracked));
			if (game_status == PotP_S_Available && IsMissedByFacts(tracked))
			{
				return PotP_S_Missed;
			}
			return game_status;

		case PotP_A_Gwent:
			// A card a choice or a closing game can lose, as the Passiflora leaders: missed by its facts until it's had
			game_status = Done(IsCardCollected(tracked));
			if (game_status == PotP_S_Available && IsMissedByFacts(tracked))
			{
				return PotP_S_Missed;
			}
			return game_status;

		case PotP_A_Bestiary:
			return Done(KnownCreatureOf(tracked));

		default:
			// Quests come from the journal; see EvaluateQuest.
			return tracked.status;
		}
	}

	//---------------------------------------------------

	private function Done(is_done: bool) : EPotP_Status
	{
		if (is_done)
		{
			return PotP_S_Completed;
		}
		return PotP_S_Available;
	}

	//---------------------------------------------------

	private function IsEventDone(tracked: CPotP_Entry) : bool
	{
		var journal_entry	: CJournalBase;
		var journal_status	: EJournalStatus;
		var Idx				: int;

		if (FactsQuerySum(tracked.entry_name) > 0 || HasFallbackFact(tracked))
		{
			return true;
		}

		if (tracked.fallback_journal != '')
		{
			journal_entry = theGame.GetJournalManager().GetEntryByTag(tracked.fallback_journal);
			if (journal_entry)
			{
				journal_status = theGame.GetJournalManager().GetEntryStatus(journal_entry);
				return journal_status == JS_Success || journal_status == JS_Failed;
			}
		}
		return false;
	}

	//---------------------------------------------------

	private function HasFallbackFact(tracked: CPotP_Entry) : bool
	{
		var Idx : int;

		for (Idx = 0; Idx < tracked.fallback_facts.Size(); Idx += 1)
		{
			if (FactsQuerySum(tracked.fallback_facts[Idx]) > 0)
			{
				return true;
			}
		}
		return false;
	}

	//---------------------------------------------------

	private function IsPinCleared(tracked: CPotP_Entry) : bool
	{
		if (tracked.pin_name == 'ep1_poi09_mp')
		{
			return map_manager.IsEntityMapPinDisabled('ep1_poi09_mp') || map_manager.IsEntityMapPinDisabled('ep1_poi09_mp_bugfix');
		}

		if (tracked.pin_name == 'ep1_poi23_mp')
		{
			return map_manager.IsEntityMapPinDisabled('ep1_poi23_mp') || map_manager.IsEntityMapPinDisabled('ep1_poi23_mp_bugfix');
		}

		// One chest, shown as a bandit camp until the area is cleared, then as a guarded
		// treasure (the _post pin). Looting it disables only the pin shown at the time.
		switch (tracked.pin_name)
		{
		case 'poi_gor_d_17_mp':
			return map_manager.IsEntityMapPinDisabled('poi_gor_d_17_mp') || map_manager.IsEntityMapPinDisabled('poi_gor_d_17_mp_post');
		case 'poi_gor_d_18_mp':
			return map_manager.IsEntityMapPinDisabled('poi_gor_d_18_mp') || map_manager.IsEntityMapPinDisabled('poi_gor_d_18_mp_post');
		case 'poi_ved_a_07_mp':
			return map_manager.IsEntityMapPinDisabled('poi_ved_a_07_mp') || map_manager.IsEntityMapPinDisabled('poi_ved_a_07_mp_post');
		case 'poi_ved_a_08_mp':
			return map_manager.IsEntityMapPinDisabled('poi_ved_a_08_mp') || map_manager.IsEntityMapPinDisabled('poi_ved_a_08_mp_post');
		}

		if (tracked.filter == PotP_I_Signs || tracked.filter == PotP_I_Stash)
		{
			return map_manager.IsEntityMapPinDiscovered(tracked.pin_name)
				|| (tracked.alt_pin_name != '' && map_manager.IsEntityMapPinDiscovered(tracked.alt_pin_name));
		}

		return map_manager.IsEntityMapPinDisabled(tracked.pin_name)
			|| (tracked.alt_pin_name != '' && map_manager.IsEntityMapPinDisabled(tracked.alt_pin_name));
	}

	//---------------------------------------------------

	private function IsItemCollected(tracked: CPotP_Entry) : bool
	{
		var min_quality, max_quality	: int;
		var variation					: name;
		var Idx							: int;

		for (Idx = 0; Idx < tracked.variations.Size(); Idx += 1)
		{
			if (FactsQuerySum(PotP_Fact_Collected(tracked.variations[Idx])) > 0)
			{
				return true;
			}
		}

		for (Idx = 0; Idx < tracked.variations.Size(); Idx += 1)
		{
			variation = tracked.variations[Idx];
			player_inventory.GetItemQualityFromName(variation, min_quality, max_quality);

			if (min_quality < 4)
			{
				continue;
			}

			if (player_inventory.HasItem(variation) || stash_inventory.HasItem(variation) || horse_manager.IsItemEquippedByName(variation))
			{
				FactsSet(PotP_Fact_Collected(tracked.item_name), 1);
				return true;
			}
		}
		return false;
	}

	//---------------------------------------------------

	private function IsCardCollected(tracked: CPotP_Entry) : bool
	{
		var card_name	: name;
		var Idx			: int;

		for (Idx = 0; Idx < tracked.variations.Size(); Idx += 1)
		{
			if (player_inventory.HasItem(tracked.variations[Idx]))
			{
				return true;
			}

			card_name = tracked.card_names[Idx];
			if (card_name != '' && (gwent.HasCardInCollection(card_name) || leader_collection.Contains(card_name)))
			{
				return true;
			}
		}
		return false;
	}
}
