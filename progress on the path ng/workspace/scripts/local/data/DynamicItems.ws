//---------------------------------------------------
//-- Dynamic Items ----------------------------------
//---------------------------------------------------

class CPotP_DynamicItems
{
	var relic_quality : int;
		default relic_quality = 4;

	//---------------------------------------------------

	public function BuildTagged(catalog: CPotP_Catalog, item_tag: name, uuid_prefix: string, header_key: string, filter_value: PotP_Preview_Items_Filter, sub_filter_value: PotP_Preview_Items_Underlying_Filter)
	{
		var defs			: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		var candidates		: array<name>;
		var seen			: array<name>;
		var group_titles	: array<string>;
		var group_entries	: array<CPotP_Entry>;
		var tracked			: CPotP_Entry;
		var item			: name;
		var title, group	: string;
		var Idx, Gdx		: int;

		candidates = defs.GetItemsWithTag(item_tag);
		catalog.BeginSection(PotP_Book_Items, header_key, PotP_A_Items, uuid_prefix);

		for (Idx = 0; Idx < candidates.Size(); Idx += 1)
		{
			item = candidates[Idx];

			if (seen.Contains(item))
			{
				continue;
			}
			seen.PushBack(item);

			if (!IsRelic(defs, item) || catalog.IsItemRegistered(item))
			{
				continue;
			}

			title = PotP_CleanTitle(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(item)));
			if (title == "")
			{
				title = NameToString(item);
			}

			// Items that are one prize, whichever the game gives, share an entry under a name of their own
			group = SharedGroup(item);
			if (group != "")
			{
				title = PotP_LocOrDefault("PotP_RelicTitle_" + group, title);
			}
			else
			{
				group = title;
			}

			Gdx = group_titles.FindFirst(group);
			if (Gdx != -1)
			{
				group_entries[Gdx].AddVariation(item);
				continue;
			}

			if (group != title)
			{
				tracked = (new CPotP_Entry in catalog).Init(uuid_prefix + group, PotP_A_Items, PotP_E_Primary, PotP_R_NA, filter_value, sub_filter_value);
			}
			else
			{
				tracked = (new CPotP_Entry in catalog).Init(uuid_prefix + PotP_SanitizeUuid(title), PotP_A_Items, PotP_E_Primary, PotP_R_NA, filter_value, sub_filter_value);
			}
			tracked.title = title;
			tracked.SetItem(item);

			group_titles.PushBack(group);
			group_entries.PushBack(tracked);
			catalog.AddPrepared(tracked);
		}

		// After the loop, so an item that came in as a variation is found too
		for (Idx = 0; Idx < group_entries.Size(); Idx += 1)
		{
			SetRelicMissable(catalog, group_entries[Idx]);
		}

		catalog.EndSection();
	}

	//---------------------------------------------------
	// A relic: quality 4. Some the game never gives: Eredin's sword and Ciri's two only a mod such as The Essential Weapon
	// Rework makes rewards (and Ciri's are quality 5 with it), and Bleidd was cut, its reward q403_03_new_gear never given.
	// Hav'caaren's one reward is Eredin's death, which that mod gives his own sword for instead.
	// They're listed only when a reward of the game's gives them, or once Geralt has had one (the console, another mod),
	// which the inventory listener remembers (PotP_HiddenRelicHad).

	private function IsRelic(defs: CDefinitionsManagerAccessor, item: name) : bool
	{
		var rewards	: array<name>;
		var quality	: int = GetItemQuality(defs, item);

		if (!PotP_IsHiddenRelic(item))
		{
			return quality == relic_quality;
		}
		switch (item)
		{
		case 'Eredin Sword':
		case 'Havcaaren':
			// Hav'caaren's only source is Eredin's death too; The Essential Weapon Rework gives his sword in its place
			rewards.PushBack('q501_eredin_killed');
			break;
		case 'Swallow Sword':
		case 'q505 crafted sword':
			rewards.PushBack('q503_2_ding_dong_witch_is_dead');
			rewards.PushBack('q505_1_meet_emhyr');
			rewards.PushBack('q505_2_killed_monster');
			break;
		}
		return (quality == relic_quality || quality == relic_quality + 1) && (AnyRewardGives(rewards, item) || PotP_HiddenRelicHad(item));
	}

	private function AnyRewardGives(rewards: array<name>, item: name) : bool
	{
		var given		: SReward;
		var Idx, Jdx	: int;

		for (Idx = 0; Idx < rewards.Size(); Idx += 1)
		{
			if (!theGame.GetReward(rewards[Idx], given))
			{
				continue;
			}
			for (Jdx = 0; Jdx < given.items.Size(); Jdx += 1)
			{
				if (given.items[Jdx].item == item)
				{
					return true;
				}
			}
		}
		return false;
	}

	// The tourney's sword (with The Essential Weapon Rework, a relic): Gregoire gives Geralt's or Ravix's, by the name he
	// registered under in sq701 (sq701_18_gregoire), so one entry with both
	private function SharedGroup(item: name) : string
	{
		if (item == 'sq701 Geralt of Rivia sword' || item == 'sq701 Ravix of Fourhorn sword')
		{
			return "TourneySword";
		}
		return "";
	}

	//---------------------------------------------------
	// The relics a choice can lose for good, each checked in the quest files: its reward, the choice that skips it,
	// the fact the game sets for old saves, and the vanilla blocks that miss it as it happens.

	private function SetRelicMissable(catalog: CPotP_Catalog, tracked: CPotP_Entry)
	{
		if (tracked.variations.Contains('Olgierd Sabre'))
		{
			// Iris: reward q605_olgierd_finale_reward, only after O'Dimm's game. No fact on the peace path.
			MakeMissable(catalog, tracked, "PotP_MissableTip_Iris", "");
			// Quest blocks in q605_finale (ep1)
			catalog.AddMissedBlockFor(tracked, "e8d4f1ab-789a-4fcf-9013-e499654c2891", "q605_mirror_peace");   // SceneBlock, the temple meeting: O'Dimm takes Olgierd
		}
		else if (tracked.variations.Contains('Crossbow q206'))
		{
			// Death From Above: reward q206_06_crachs_final_reward, only after a side is taken
			MakeMissable(catalog, tracked, "PotP_MissableTip_DeathFromAbove", "q206_no_for_investigation");
			// Quest blocks in q206_berserkers
			catalog.AddMissedBlockFor(tracked, "3e6b280f-88a1-4153-8936-29c0816508aa", "True");   // Condition "q206_no_for_investigation"
		}
		else if (tracked.variations.Contains('Hjalmar_Short_Steel_Sword'))
		{
			// Hjalmar's sword: reward q206_01_won_fistfight, on the fistfight scene's WonOut only. No fact when it's lost.
			MakeMissable(catalog, tracked, "PotP_MissableTip_HjalmarSword", "");
			// Quest blocks in q206_berserkers
			catalog.AddMissedBlockFor(tracked, "39a967f5-24d7-4484-82c4-d9e93bbca228", "Gave Sword");       // SceneBlock, after losing the fistfight
			catalog.AddMissedBlockFor(tracked, "39a967f5-24d7-4484-82c4-d9e93bbca228", "Paid for Sword");
			catalog.AddMissedBlockFor(tracked, "60b383af-01c1-4d58-9fff-8d5d9fe19097", "False");            // Condition: Hjalmar's challenge not taken
		}
		else if (tracked.variations.Contains('Roseofaelirenn'))
		{
			// Rose of Shaerrawed: reward q403_new_gear, the council's armory choice. The choice is inside the council scene,
			// so its fact only.
			MakeMissable(catalog, tracked, "PotP_MissableTip_RoseOfShaerrawed", "q403_fix_wall");
		}
		else if (tracked.variations.Contains('q402 Skellige sword 3'))
		{
			// Winter's Blade: reward q402_1_optional_crach_sword, when Geralt asks Crach for help in q402. Its only source.
			MakeMissable(catalog, tracked, "PotP_MissableTip_WintersBlade", "q402_escort_completed");
			// Quest blocks in q402_ciri
			catalog.AddMissedBlockFor(tracked, "7c784b02-5eea-4373-bcc4-9f89574a27e7", "Out");   // FactsDBChanging "q402_escort_completed", leaving for the Isle of Mists
		}
		else if (tracked.variations.Contains('q704 vampire steel sword'))
		{
			// The Hen Gaidth sword: in a chest just inside the Unseen Elder's cave (q704_gravity_cave\loot.w2l), before the
			// cave's kill trigger, so on the Syanna route too with Orianna's key (q704_05_return_to_diva, then
			// q704_orianas_part_done). Missed by the fairy tale starting without it (Orianna is gone then), or the cave sealed.
			MakeMissable(catalog, tracked, "PotP_MissableTip_HenGaidthSword", "");
			catalog.AddMissedFactFor(tracked, "q704_fairy_tale_started", "q704_orianas_part_done");
			catalog.AddMissedFactFor(tracked, "q704_gravity_cave_done");
			// Quest blocks in q704_04_vampire_cave (bob)
			catalog.AddMissedBlockFor(tracked, "5dfcecbd-f858-4f9d-a14d-9afe4da34698", "End");        // SceneBlock, the Unseen Elder: the cave is sealed after
			catalog.AddMissedBlockFor(tracked, "5dfcecbd-f858-4f9d-a14d-9afe4da34698", "Shortcut");
		}
		else if (tracked.variations.Contains('q704 vampire silver sword'))
		{
			// Cantata: beside a dead mage deep in the Unseen Elder's cave (q704_gravity_caveFocus_clues\q704_mage_explorer.w2l)
			MakeMissable(catalog, tracked, "PotP_MissableTip_Cantata", "");
			PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_Cantata");
		}
		else if (tracked.variations.Contains('Unique steel sword'))
		{
			// Vitis: by a dead knight in the Land of a Thousand Fables (fairy_tale\monsters\knight_loot\loot.w2l), only on the
			// Syanna route, and there's no way back in once it's left
			MakeMissable(catalog, tracked, "PotP_MissableTip_Vitis", "q704_fairy_tale_done");
			catalog.AddMissedFactFor(tracked, "q704_gravity_cave_done");
			// Quest blocks in q704_02_fairy_tale and q704_03_monster_hunt (bob)
			catalog.AddMissedBlockFor(tracked, "595c5a7b-6d66-4bf5-b87c-321f553ff838", "Out");               // LayersHider "background, hide ft": the land is gone
			catalog.AddMissedBlockFor(tracked, "476251b9-80da-490b-ac93-7dec2b8b2645", "OriginalBoat");      // SceneBlock, Regis: the Unseen Elder
			catalog.AddMissedBlockFor(tracked, "476251b9-80da-490b-ac93-7dec2b8b2645", "OriginalGameplay");
			catalog.AddMissedBlockFor(tracked, "e640b3c2-6ac1-472f-bfd6-dad788cdb2be", "OriginalBoat");      // the same, by its other input
			catalog.AddMissedBlockFor(tracked, "e640b3c2-6ac1-472f-bfd6-dad788cdb2be", "OriginalGameplay");
		}
		else if (tracked.variations.Contains('sq701 Geralt of Rivia sword') || tracked.variations.Contains('sq701 Ravix of Fourhorn sword'))
		{
			// The tourney sword (a relic with The Essential Weapon Rework): Gregoire's, at the ceremony after the arena's
			// final fight (sq701_18_gregoire), which can't be lost. Missed only if the tournament fails first, when 'The
			// Night of Long Fangs' starts.
			MakeMissable(catalog, tracked, "PotP_MissableTip_TourneySword", "");
			catalog.AddMissedFactFor(tracked, "q704_done", "sq701_won_tournament");
			// Quest blocks in sq701_tournament (bob)
			catalog.AddMissedBlockFor(tracked, "0d31fd1b-da32-4ff8-8a0d-019963117003", "Out");   // CutControl, the tournament fails
		}
		else if (tracked.variations.Contains('Unique silver sword'))
		{
			// Gesheft, the relic: in the giant's bonfire in the Land of a Thousand Fables (fairy_tale\giantFireBonfire.w2l),
			// its only place, so lost as Vitis is. The crafted Gesheft (Serpent Silver Sword 3) is another item.
			MakeMissable(catalog, tracked, "PotP_MissableTip_Gesheft", "q704_fairy_tale_done");
			catalog.AddMissedFactFor(tracked, "q704_gravity_cave_done");
			// Quest blocks in q704_02_fairy_tale and q704_03_monster_hunt (bob)
			catalog.AddMissedBlockFor(tracked, "595c5a7b-6d66-4bf5-b87c-321f553ff838", "Out");               // LayersHider "background, hide ft": the land is gone
			catalog.AddMissedBlockFor(tracked, "476251b9-80da-490b-ac93-7dec2b8b2645", "OriginalBoat");      // SceneBlock, Regis: the Unseen Elder
			catalog.AddMissedBlockFor(tracked, "476251b9-80da-490b-ac93-7dec2b8b2645", "OriginalGameplay");
			catalog.AddMissedBlockFor(tracked, "e640b3c2-6ac1-472f-bfd6-dad788cdb2be", "OriginalBoat");      // the same, by its other input
			catalog.AddMissedBlockFor(tracked, "e640b3c2-6ac1-472f-bfd6-dad788cdb2be", "OriginalGameplay");
		}
		else if (tracked.variations.Contains('Mourner'))
		{
			// Mourner: reward mq1037_enc_01_sword, the scavenger at the Midcotts bridge sells it (or it's on him if he's
			// attacked). Turn him down and leave, and after six hours everyone there is despawned. No chest rolls it.
			MakeMissable(catalog, tracked, "PotP_MissableTip_Mourner", "");
			// Quest blocks in mq1037_deadly_crossing
			catalog.AddMissedBlockFor(tracked, "062ba391-543b-42a1-b320-9fd5aa4fe4c4", "Out");   // StoryPhaseSetter "despawn everyone"
		}
		else if (tracked.variations.Contains('Ofir Crossbow R'))
		{
			// The Ofieri crossbow: in a chest in the Borsodi vault (ep1 locations\q603\loot.w2l), reached only during the
			// heist; the auction house is locked and the tunnel walled up after it.
			MakeMissable(catalog, tracked, "PotP_MissableTip_OfieriCrossbow", "q603_done");
			// Quest blocks in q603_bank (ep1)
			catalog.AddMissedBlockFor(tracked, "d4bd54d1-e507-48bb-accd-9a04ebfed6ff", "Out");   // FactsDBChanging "q603_done +1"
		}
		else if (tracked.variations.Contains('Gwent steel sword 1'))
		{
			// Blave: reward cg700_wager_sword, for wagering the silver sword before the Gwent tournament's first match and
			// winning that match. Missed once the tournament starts without the wager, or the wagered match is lost.
			MakeMissable(catalog, tracked, "PotP_MissableTip_Blave", "");
			catalog.AddMissedFactFor(tracked, "cg700_tournament_started", "cg700_wager_sword");
			catalog.AddMissedFactFor(tracked, "cg700_geralt_lost_sword");
			// Quest blocks in cg700_card_game (bob)
			catalog.AddMissedBlockFor(tracked, "fdd813a4-c7e0-4d66-812c-2839f84d1d8a", "Failure");   // GraphMinigame, the first match lost
		}
	}

	//---------------------------------------------------

	private function MakeMissable(catalog: CPotP_Catalog, tracked: CPotP_Entry, tip_key: string, missed_fact: string)
	{
		tracked.entry_type = PotP_E_Missable;
		tracked.is_missable = true;
		catalog.SetMissableReasonFor(tracked, tip_key, missed_fact);
	}

	//---------------------------------------------------

	private function GetItemQuality(defs: CDefinitionsManagerAccessor, item: name) : int
	{
		var min_value, max_value : SAbilityAttributeValue;

		defs.GetItemAttributeValueNoRandom(item, true, 'quality', min_value, max_value);
		return RoundMath(CalculateAttributeValue(min_value));
	}

	//---------------------------------------------------
	//-- Gwent ------------------------------------------
	//---------------------------------------------------

	public function BuildGwent(catalog: CPotP_Catalog)
	{
		var gwent			: CR4GwintManager = theGame.GetGwintManager();
		var card_defs		: array<SCardDefinition>;
		var leader_defs		: array<SCardDefinition>;
		var all_defs		: array<SCardDefinition>;
		var leader_names	: array<name>;
		var origin_cards	: array<name>;
		var origin_areas	: array<string>;
		var missable_cards	: array<name>;
		var group_keys		: array<string>;
		var group_entries	: array<CPotP_Entry>;
		var owned_items		: array<name>;
		var owned_keys		: array<string>;
		var card_def		: SCardDefinition;
		var tracked			: CPotP_Entry;
		var item			: name;
		var title, key		: string;
		var type_value		: PotP_Preview_Entry_Type;
		var Idx, Gdx		: int;

		if (!gwent)
		{
			return;
		}

		card_defs = gwent.GetCardDefs();
		leader_defs = gwent.GetLeaderDefs();

		for (Idx = 0; Idx < leader_defs.Size(); Idx += 1)
		{
			leader_names.PushBack(leader_defs[Idx].cardName);
			all_defs.PushBack(leader_defs[Idx]);
		}
		for (Idx = 0; Idx < card_defs.Size(); Idx += 1)
		{
			all_defs.PushBack(card_defs[Idx]);
		}

		LoadCardOrigins(origin_cards, origin_areas);
		GetMissableCards(missable_cards);

		for (Idx = 0; Idx < all_defs.Size(); Idx += 1)
		{
			card_def = all_defs[Idx];
			item = card_def.itemName;

			if (item == '')
			{
				if (!leader_names.Contains(card_def.cardName))
				{
					continue;
				}
				item = card_def.cardName;
			}

			title = PotP_CleanTitle(GetLocStringByKeyExt(card_def.title));
			if (title == "")
			{
				title = NameToString(card_def.cardName);
			}

			key = IntToString((int)card_def.faction) + "|" + title;

			// An item that already belongs to another group must not be merged twice.
			Gdx = owned_items.FindFirst(item);
			if (Gdx == -1)
			{
				owned_items.PushBack(item);
				owned_keys.PushBack(key);
			}
			else if (owned_keys[Gdx] != key)
			{
				continue;
			}

			Gdx = group_keys.FindFirst(key);
			if (Gdx != -1)
			{
				group_entries[Gdx].AddCardVariation(item, card_def.cardName);
				continue;
			}

			type_value = PotP_E_Primary;
			if (missable_cards.Contains(item))
			{
				type_value = PotP_E_Missable;
			}

			tracked = (new CPotP_Entry in catalog).Init("PotP_Gwent_" + PotP_SanitizeUuid(NameToString(item)), PotP_A_Gwent, type_value, GetCardRegion(item, origin_cards, origin_areas), PotP_I_Gwent, GetFactionFilter(card_def.faction));
			tracked.title = title;
			tracked.item_name = item;
			tracked.AddCardVariation(item, card_def.cardName);

			if (leader_names.Contains(card_def.cardName))
			{
				tracked.card_type = PotP_G_Lead;
			}
			else if ((card_def.typeFlags & GwintType_Hero) == GwintType_Hero)
			{
				tracked.card_type = PotP_G_Hero;
			}
			else
			{
				tracked.card_type = PotP_G_Unit;
			}

			group_keys.PushBack(key);
			group_entries.PushBack(tracked);
		}

		// The card tables come back in a different order between sessions, so which
		// copy of a card is met first is not stable. Naming the entry after it would
		// change its uuid, and with it the content checksum and any manual status.
		for (Idx = 0; Idx < group_entries.Size(); Idx += 1)
		{
			item = GetCanonicalItem(group_entries[Idx]);
			group_entries[Idx].item_name = item;
			group_entries[Idx].uuid = "PotP_Gwent_" + PotP_SanitizeUuid(NameToString(item));
			if (group_entries[Idx].is_missable)
			{
				SetCardMissable(catalog, group_entries[Idx]);
			}
		}

		AddFactionSection(catalog, group_entries, PotP_I_Monst, "PotP_Preview_Gwent_1");
		AddFactionSection(catalog, group_entries, PotP_I_Neutr, "PotP_Preview_Gwent_2");
		AddFactionSection(catalog, group_entries, PotP_I_Nilfg, "PotP_Preview_Gwent_3");
		AddFactionSection(catalog, group_entries, PotP_I_North, "PotP_Preview_Gwent_4");
		AddFactionSection(catalog, group_entries, PotP_I_Scoia, "PotP_Preview_Gwent_5");
		AddFactionSection(catalog, group_entries, PotP_I_Skell, "PotP_Preview_Gwent_6");
	}

	//---------------------------------------------------

	private function GetCanonicalItem(tracked: CPotP_Entry) : name
	{
		var canonical	: name = tracked.variations[0];
		var Idx			: int;

		for (Idx = 1; Idx < tracked.variations.Size(); Idx += 1)
		{
			if (StrCmp(NameToString(tracked.variations[Idx]), NameToString(canonical)) < 0)
			{
				canonical = tracked.variations[Idx];
			}
		}
		return canonical;
	}

	//---------------------------------------------------

	private function AddFactionSection(catalog: CPotP_Catalog, group_entries: array<CPotP_Entry>, faction_filter: PotP_Preview_Gwent_Underlying_Filter, header_key: string)
	{
		var Idx : int;

		catalog.BeginSection(PotP_Book_Gwent, header_key, PotP_A_Gwent, "PotP_Gwent_");
		if (faction_filter == PotP_I_Skell)
		{
			catalog.MarkSectionNeedsSkellige();
		}

		for (Idx = 0; Idx < group_entries.Size(); Idx += 1)
		{
			if (group_entries[Idx].sub_filter == faction_filter)
			{
				catalog.AddPrepared(group_entries[Idx]);
			}
		}
		catalog.EndSection();
	}

	//---------------------------------------------------

	private function GetFactionFilter(faction: eGwintFaction) : PotP_Preview_Gwent_Underlying_Filter
	{
		switch (faction)
		{
		case GwintFaction_NoMansLand:		return PotP_I_Monst;
		case GwintFaction_Nilfgaard:		return PotP_I_Nilfg;
		case GwintFaction_NothernKingdom:	return PotP_I_North;
		case GwintFaction_Scoiatael:		return PotP_I_Scoia;
		case GwintFaction_Skellige:			return PotP_I_Skell;
		default:							return PotP_I_Neutr;
		}
	}

	//---------------------------------------------------

	// The cards a choice or a closing game can lose for good, each checked in the quest files (research doc, Gwent pass).
	// Not missable after all, though guides say so: Fringilla, Isengrim and Natalis ('The Great Escape' puts any missing on
	// the witch hunter officer), Iorveth ('Shock Therapy' can't fail), Dijkstra, Esterad, Draug, Triss, Emhyr silver and
	// the others with a fallback (a locker, a stash, a failsafe merchant).
	private function GetMissableCards(out cards: array<name>)
	{
		cards.PushBack('gwint_card_eredin_gold');
		cards.PushBack('gwint_card_emhyr_gold');
		cards.PushBack('gwint_card_foltest_gold');
		cards.PushBack('gwint_card_francesca_gold');
		cards.PushBack('gwint_card_geralt');
		cards.PushBack('gwint_card_milva');
		cards.PushBack('gwint_card_dandelion');
		cards.PushBack('gwint_card_nekker');
		// Without Blood and Wine its other source (Margot's stash in 'Rest in Peace') isn't there
		if (!theGame.GetDLCManager().IsEP2Available())
		{
			cards.PushBack('gwint_card_bruxa');
		}
	}

	//---------------------------------------------------
	// Why each can be missed, and the facts and vanilla blocks that say it has been

	private function SetCardMissable(catalog: CPotP_Catalog, tracked: CPotP_Entry)
	{
		switch (tracked.item_name)
		{
		case 'gwint_card_foltest_gold':
			// The Passiflora tournament in 'High Stakes' (sq306_maverick): single elimination, played once
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Foltest", "");
			catalog.AddMissedFactFor(tracked, "sq306_completed", "sq306_defeated_bernard");
			SetPassifloraBlocks(catalog, tracked, 1);
			break;
		case 'gwint_card_emhyr_gold':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Emhyr", "");
			catalog.AddMissedFactFor(tracked, "sq306_completed", "sq306_defeated_sacha");
			SetPassifloraBlocks(catalog, tracked, 2);
			break;
		case 'gwint_card_francesca_gold':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Francesca", "");
			catalog.AddMissedFactFor(tracked, "sq306_completed", "sq306_defeated_finneas");
			SetPassifloraBlocks(catalog, tracked, 3);
			break;
		case 'gwint_card_eredin_gold':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Eredin", "");
			catalog.AddMissedFactFor(tracked, "sq306_completed", "sq306_defeated_tybalt");
			SetPassifloraBlocks(catalog, tracked, 4);
			break;
		case 'gwint_card_geralt':
			// Thaler plays only once 'A Deadly Plot' (sq315) is done, and it fails at the Isle of Mists. His death later
			// leaves the card in a locker (cg100_talar_card_locker).
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Geralt", "");
			catalog.AddMissedFactFor(tracked, "q402_escort_completed", "sq315_fdb_quest_complete");
			// Quest blocks in sq315_talar
			catalog.AddMissedBlockFor(tracked, "043764b7-716f-43f0-81f7-789d8cc91e68", "Out");   // Journal: 'A Deadly Plot' failed
			break;
		case 'gwint_card_milva':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Milva", "");
			SetMasqueradeMissed(catalog, tracked);
			break;
		case 'gwint_card_bruxa':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Bruxa", "");
			SetMasqueradeMissed(catalog, tracked);
			break;
		case 'gwint_card_dandelion':
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Dandelion", "");
			SetMasqueradeMissed(catalog, tracked);
			break;
		case 'gwint_card_nekker':
			// Only in Hammond's inventory ('Following the Thread', sq106_killbill): despawned when the quest fails at
			// q401_gotten_uma, or once you leave after killing him
			catalog.SetMissableReasonFor(tracked, "PotP_MissableTip_Card_Nekker", "");
			catalog.AddMissedFactFor(tracked, "q401_gotten_uma", "sq106_hammond_slayed");
			// Quest blocks in sq106_killbill
			catalog.AddMissedBlockFor(tracked, "7a03ecd6-43f4-4baf-a941-9a4481baa1af", "Out");   // StoryPhaseSetter "despawn all", the quest failed
			catalog.AddMissedBlockFor(tracked, "fbfd4c1f-1022-486b-ae4b-925d3ae4e697", "Out");   // StoryPhaseSetter, Hammond despawned after the kill
			break;
		}
	}

	// The masquerade in 'A Matter of Life and Death' (sq301_dawn_estate): one card master, three games in turn, which end
	// at the fountain scene, on leaving the party, or with the quest failing before it
	private function SetMasqueradeMissed(catalog: CPotP_Catalog, tracked: CPotP_Entry)
	{
		catalog.AddMissedFactFor(tracked, "sq301_scenes_stop");
		catalog.AddMissedFactFor(tracked, "sq301_failed");
		catalog.AddMissedBlockFor(tracked, "09a0ab3d-9aeb-4e75-9749-737c30fefc4a", "Out");   // FactsDBChanging "sq301_scenes_stop"
		catalog.AddMissedBlockFor(tracked, "7c3e7d12-bc70-457d-925a-29e62666e354", "Out");   // FactsDBChanging "sq301_failed", left the party
		catalog.AddMissedBlockFor(tracked, "2dff0e4a-0966-4101-8be2-6ded58b0cefb", "Out");   // FactsDBChanging "sq301_failed", before it (sq301_triss)
	}

	// The Passiflora rounds (sq306_maverick): a loss in this round or any before it, or leaving Passiflora, ends the run
	private function SetPassifloraBlocks(catalog: CPotP_Catalog, tracked: CPotP_Entry, round: int)
	{
		catalog.AddMissedBlockFor(tracked, "409ea758-1258-482f-83fc-0f8b9c49b3e5", "Fail");       // PhaseBlock "Leaving Passiflora"
		catalog.AddMissedBlockFor(tracked, "105c9022-5836-40c0-99c8-fdd5ae2fefe6", "Lose");       // Scene, lost to Bernard
		if (round >= 2)
		{
			catalog.AddMissedBlockFor(tracked, "feba4ab5-6301-41d5-9c64-2c7a1c16aa9e", "GiveUp");   // Scene, lost to Sacha
			catalog.AddMissedBlockFor(tracked, "feba4ab5-6301-41d5-9c64-2c7a1c16aa9e", "SitOut");
		}
		if (round >= 3)
		{
			catalog.AddMissedBlockFor(tracked, "95f37e06-fec5-4694-9939-a02521188a6b", "GiveUp");   // Scene, lost to Finneas
			catalog.AddMissedBlockFor(tracked, "95f37e06-fec5-4694-9939-a02521188a6b", "SitOut");
			catalog.AddMissedBlockFor(tracked, "95f37e06-fec5-4694-9939-a02521188a6b", "Lost_to_Finneas_out");
		}
		if (round >= 4)
		{
			catalog.AddMissedBlockFor(tracked, "a5835f55-6dca-484e-a7e9-45baa14d3569", "Failure");  // GraphMinigame, lost to Tybalt
			catalog.AddMissedBlockFor(tracked, "97b223c6-30fe-4988-88eb-c2a26d6223c7", "Lose");     // InteractionDialog, lost to Tybalt
		}
	}

	//---------------------------------------------------

	private function LoadCardOrigins(out cards: array<name>, out areas: array<string>)
	{
		var sources	: C2dArray;
		var Idx		: int;

		if (theGame.IsFinalBuild())
		{
			sources = LoadCSV("gameplay\globals\card_sources.csv");
		}
		else
		{
			sources = LoadCSV("qa\card_sources.csv");
		}

		if (!sources)
		{
			return;
		}

		for (Idx = 0; Idx < sources.GetNumRows(); Idx += 1)
		{
			cards.PushBack(sources.GetValueAsName("CardName", Idx));
			areas.PushBack(sources.GetValue("OriginArea", Idx));
		}
	}

	//---------------------------------------------------

	private function GetCardRegion(item: name, cards: array<name>, areas: array<string>) : PotP_Preview_Region
	{
		var Idx : int = cards.FindFirst(item);

		if (Idx == -1)
		{
			return PotP_R_NA;
		}

		switch (areas[Idx])
		{
		case "NML":			return PotP_R_VE;
		case "Novigrad":	return PotP_R_NO;
		case "Skellige":	return PotP_R_SK;
		case "Prologue":	return PotP_R_WO;
		case "KaerMorhen":	return PotP_R_KM;
		case "Vizima":		return PotP_R_VI;
		default:			return PotP_R_NA;
		}
	}
}

//---------------------------------------------------
// The relics the game never gives (CPotP_DynamicItems.IsRelic), and whether Geralt has had one

function PotP_IsHiddenRelic(item: name) : bool
{
	return item == 'Eredin Sword' || item == 'Havcaaren' || item == 'Swallow Sword' || item == 'q505 crafted sword' || item == 'WitcherSilverWolf';
}

function PotP_HiddenRelicFact(item: name) : string
{
	return "PotP_HadRelic_" + StrReplaceAll(NameToString(item), " ", "_");
}

function PotP_HiddenRelicHad(item: name) : bool
{
	return FactsQuerySum(PotP_HiddenRelicFact(item)) > 0 || thePlayer.GetInventory().HasItem(item);
}
