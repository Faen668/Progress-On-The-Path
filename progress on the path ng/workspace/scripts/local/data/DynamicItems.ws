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
		var title			: string;
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

			if (GetItemQuality(defs, item) != relic_quality || catalog.IsItemRegistered(item))
			{
				continue;
			}

			title = PotP_CleanTitle(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(item)));
			if (title == "")
			{
				title = NameToString(item);
			}

			Gdx = group_titles.FindFirst(title);
			if (Gdx != -1)
			{
				group_entries[Gdx].AddVariation(item);
				continue;
			}

			tracked = (new CPotP_Entry in catalog).Init(uuid_prefix + PotP_SanitizeUuid(title), PotP_A_Items, PotP_E_Primary, PotP_R_NA, filter_value, sub_filter_value);
			tracked.title = title;
			tracked.SetItem(item);

			group_titles.PushBack(title);
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

	private function GetMissableCards(out cards: array<name>)
	{
		cards.PushBack('gwint_card_eredin_gold');
		cards.PushBack('gwint_card_emhyr_gold');
		cards.PushBack('gwint_card_foltest_gold');
		cards.PushBack('gwint_card_francesca_gold');
		cards.PushBack('gwint_card_natalis');
		cards.PushBack('gwint_card_dandelion');
		cards.PushBack('gwint_card_iorveth');
		cards.PushBack('gwint_card_isengrim');
		cards.PushBack('gwint_card_fringilla');
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
