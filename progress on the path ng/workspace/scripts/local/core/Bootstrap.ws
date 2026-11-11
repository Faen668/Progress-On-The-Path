//---------------------------------------------------
//-- Bootstrap --------------------------------------
//---------------------------------------------------

@addField(CR4Player)
var potp_main : CPotP_Main;

//---------------------------------------------------

@wrapMethod(CR4Player) function OnSpawned(spawnData: SEntitySpawnData)
{
	wrappedMethod(spawnData);

	if (!potp_main)
	{
		potp_main = new CPotP_Main in this;
	}
	potp_main.Start();

	// The reward swords, kept at Geralt's level (rewards/RewardSwords.ws)
	PotP_ScaleRewardSwords();
}

//---------------------------------------------------

@wrapMethod(CR4ScriptedHud) function OnQuestUpdate(journalQuest: CJournalQuest, isQuestUpdate: bool)
{
	var main : CPotP_Main = PotP_Get();

	if (main)
	{
		if (main.catalog.is_ready)
		{
			main.tracker.QueueQuest(journalQuest);
		}
	}

	wrappedMethod(journalQuest, isQuestUpdate);
}

//---------------------------------------------------

@wrapMethod(CR4JournalQuestMenu) function GetDescription(currentQuest: CJournalQuest) : string
{
	return wrappedMethod(currentQuest) + PotP_GetJournalNote(currentQuest);
}

//---------------------------------------------------

@wrapMethod(CR4JournalQuestMenu) function generateFlashObjectForQuest(targetQuest: CJournalQuest, optional initSelection: bool) : CScriptedFlashObject
{
	var quest_data	: CScriptedFlashObject;
	var tag			: string;

	quest_data = wrappedMethod(targetQuest, initSelection);
	tag = PotP_GetJournalTag(targetQuest);

	if (tag != "")
	{
		quest_data.SetMemberFlashString("label", tag + " " + quest_data.GetMemberFlashString("label"));
	}
	return quest_data;
}

//---------------------------------------------------

function PotP_GetJournalEntry(journal_quest: CJournalQuest) : CPotP_Entry
{
	var main : CPotP_Main = PotP_Get();

	if (!main || !journal_quest)
	{
		return NULL;
	}
	if (!main.catalog.is_ready)
	{
		return NULL;
	}
	return main.catalog.FindQuest(journal_quest.baseName);
}

//---------------------------------------------------

function PotP_GetCutoffGroups(tracked: CPotP_Entry) : array<CPotP_Section>
{
	var groups	: array<CPotP_Section> = PotP_Get().catalog.missable_sections;
	var found	: array<CPotP_Section>;
	var Idx		: int;

	for (Idx = 0; Idx < groups.Size(); Idx += 1)
	{
		if (groups[Idx].cutoff == tracked)
		{
			found.PushBack(groups[Idx]);
		}
	}
	return found;
}

//---------------------------------------------------

function PotP_GetJournalTag(journal_quest: CJournalQuest) : string
{
	var tracked		: CPotP_Entry = PotP_GetJournalEntry(journal_quest);
	var cutoff_tag	: string;
	var missable_tag	: string;

	if (!tracked)
	{
		return "";
	}

	cutoff_tag = PotP_GetCutoffTag(tracked);
	missable_tag = PotP_GetMissableTag(tracked);

	if (cutoff_tag != "" && missable_tag != "")
	{
		return cutoff_tag + " " + missable_tag;
	}
	return cutoff_tag + missable_tag;
}

//---------------------------------------------------

function PotP_GetCutoffTag(tracked: CPotP_Entry) : string
{
	var groups		: array<CPotP_Section>;
	var outstanding	: array<CPotP_Entry>;
	var Idx			: int;
	var i			: int;

	groups = PotP_GetCutoffGroups(tracked);
	for (Idx = 0; Idx < groups.Size(); Idx += 1)
	{
		if (!groups[Idx].IsCutoffApproaching())
		{
			continue;
		}

		outstanding = groups[Idx].GetOutstanding();
		for (i = 0; i < outstanding.Size(); i += 1)
		{
			if (PotP_UseNativeJournalAdvice(outstanding[i]))
			{
				return GetLocStringByKeyExt("potp_missable_listtag_cutoff");
			}
		}
	}
	return "";
}

//---------------------------------------------------

function PotP_GetMissableTag(tracked: CPotP_Entry) : string
{
	if (!PotP_UseNativeJournalAdvice(tracked))
	{
		return "";
	}

	if (!tracked.is_missable || !tracked.missable_group)
	{
		return "";
	}

	if (tracked.status == PotP_S_Missed)
	{
		return GetLocStringByKeyExt("potp_missable_listtag_missed");
	}
	if (tracked.IsDone())
	{
		return "";
	}
	if (tracked.missable_group.IsCutoffApproaching())
	{
		return GetLocStringByKeyExt("potp_missable_listtag_now");
	}
	return GetLocStringByKeyExt("potp_missable_listtag_open");
}

//---------------------------------------------------

function PotP_GetJournalNote(journal_quest: CJournalQuest) : string
{
	var tracked	: CPotP_Entry = PotP_GetJournalEntry(journal_quest);
	var groups	: array<CPotP_Section>;
	var note	: string;
	var Idx		: int;

	if (!tracked)
	{
		return "";
	}

	if (tracked.is_missable && tracked.missable_group)
	{
		note += PotP_JournalMissableNote(tracked);
	}

	groups = PotP_GetCutoffGroups(tracked);
	for (Idx = 0; Idx < groups.Size(); Idx += 1)
	{
		note += PotP_JournalCutoffNote(groups[Idx]);
	}
	return note;
}

//---------------------------------------------------

function PotP_JournalLine(label_key: string, text_value: string) : string
{
	return "<font color='#AAAAAA'>" + GetLocStringByKeyExt(label_key) + "</font> " + text_value + "<br>";
}

//---------------------------------------------------

function PotP_JournalMissableNote(tracked: CPotP_Entry) : string
{
	var group	: CPotP_Section;
	var kind	: string;
	var note	: string;

	if (!PotP_UseNativeJournalAdvice(tracked))
	{
		return "";
	}

	group = tracked.missable_group;
	kind = IntToString((int)group.missable_kind);

	note = "<br><font color='#D79D3A'>" + StrReplace(GetLocStringByKeyExt("potp_missable_journal_title"), "[KIND]", GetLocStringByKeyExt("potp_ov_part_" + kind)) + "</font><br>";
	note += PotP_JournalLine("potp_journal_label_" + kind, GetLocStringByKeyExt(group.header));

	if (tracked.status == PotP_S_Missed)
	{
		return note + PotP_JournalLine("potp_journal_label_status", "<font color='#C8566B'>" + GetLocStringByKeyExt("potp_missable_journal_missed") + "</font>");
	}

	if (tracked.IsDone())
	{
		return note + PotP_JournalLine("potp_journal_label_status", "<font color='#2ba84a'>" + GetLocStringByKeyExt("potp_missable_journal_done") + "</font>");
	}

	if (group.IsCutoffApproaching())
	{
		note += PotP_JournalLine("potp_journal_label_status", "<font color='#C8566B'>" + GetLocStringByKeyExt("potp_missable_journal_now") + "</font>");
	}
	else
	{
		note += PotP_JournalLine("potp_journal_label_status", "<font color='#D79D3A'>" + GetLocStringByKeyExt("potp_missable_journal_open") + "</font>");
	}

	if (tracked.missable_tip != "")
	{
		note += PotP_JournalLine("potp_journal_label_tip", GetLocStringByKeyExt(tracked.missable_tip));
	}
	return note;
}

//---------------------------------------------------

function PotP_JournalCutoffNote(group: CPotP_Section) : string
{
	var note		: string;
	var lines		: string;
	var ent			: CPotP_Entry;
	var Idx			: int;
	var has_native	: bool;

	for (Idx = 0; Idx < group.entries.Size(); Idx += 1)
	{
		ent = group.entries[Idx];

		if (!PotP_UseNativeJournalAdvice(ent))
		{
			continue;
		}
		has_native = true;

		if (ent.IsDone())
		{
			continue;
		}

		if (ent.status == PotP_S_Missed)
		{
			lines += "<font color='#888888'> - " + ent.title + PotP_JournalRegion(ent) + " - " + GetLocStringByKeyExt("potp_journal_state_4") + "</font><br>";
		}
		else
		{
			lines += "<font color='#D79D3A'> - </font>" + ent.title + PotP_JournalRegion(ent) + "<font color='#AAAAAA'> - " + GetLocStringByKeyExt("potp_journal_state_" + IntToString((int)ent.status)) + "</font><br>";
		}
	}

	if (!has_native)
	{
		return "";
	}

	note = "<br><font color='#C8566B'>" + GetLocStringByKeyExt("potp_journal_cutoff_title") + "</font><br>";
	note += "<font color='#9D75BF'>" + GetLocStringByKeyExt(group.header) + "</font><br>";

	if (lines == "")
	{
		return note + "<font color='#2ba84a'>" + GetLocStringByKeyExt("potp_journal_cutoff_alldone") + "</font><br>";
	}
	return note + GetLocStringByKeyExt("potp_journal_cutoff_list") + "<br>" + lines;
}

//---------------------------------------------------

function PotP_JournalRegion(tracked: CPotP_Entry) : string
{
	if (tracked.region == PotP_R_NA || tracked.region == PotP_R_TS)
	{
		return "";
	}
	return " (" + GetLocStringByKeyExt("potp_ov_area_" + IntToString((int)tracked.region)) + ")";
}

//---------------------------------------------------

function PotP_GetCollectabilityTag(item: name) : string
{
	var main	: CPotP_Main = PotP_Get();
	var tracked	: CPotP_Entry;

	if (!main || !PotP_SettingFlag('ProgressOnThePath_ShowCollectabilityTooltips'))
	{
		return "";
	}
	if (!main.catalog.is_ready)
	{
		return "";
	}

	tracked = main.catalog.FindItem(item);
	if (!tracked || tracked.untracked)
	{
		return "";
	}

	if (tracked.status == PotP_S_Completed)
	{
		return GetLocStringByKeyExt("PotP_Tooltip_Collected");
	}
	return GetLocStringByKeyExt("PotP_Tooltip_Needed");
}

//---------------------------------------------------

@addField(CR4Game)
var potp_craft_labelling : bool;

@addField(CR4Game)
var potp_craft_titles : array<string>;

@addField(CR4Game)
var potp_craft_labels : array<string>;

@addMethod(CR4Game)
public function PotP_ClearCraftLabels()
{
	potp_craft_labelling = false;
	potp_craft_titles.Clear();
	potp_craft_labels.Clear();
}

@addMethod(CR4Game)
public function PotP_AddCraftLabel(title: string, label: string)
{
	if (!potp_craft_titles.Contains(title))
	{
		potp_craft_titles.PushBack(title);
		potp_craft_labels.PushBack(label);
		potp_craft_labelling = true;
	}
}

//---------------------------------------------------

@wrapMethod(CR4CraftingMenu) function PopulateData()
{
	PotP_PrepareCraftingLabels();

	wrappedMethod();

	theGame.PotP_ClearCraftLabels();
}

//---------------------------------------------------

@wrapMethod(CScriptedFlashObject) function SetMemberFlashString(memberName: string, value: string)
{
	var label	: string;
	var Idx		: int;

	label = value;
	if (theGame.potp_craft_labelling && memberName == "label")
	{
		Idx = theGame.potp_craft_titles.FindFirst(value);
		if (Idx != -1)
		{
			label = theGame.potp_craft_labels[Idx];
		}
	}

	// Counts down through the tracked quest's objectives; see QuestTracker.ws.
	if (theGame.potp_tracker_remaining > 0 && memberName == "name")
	{
		label += theGame.PotP_TakeTrackerNote();
	}

	wrappedMethod(memberName, label);
}

//---------------------------------------------------

@addMethod(CR4CraftingMenu)
private function PotP_PrepareCraftingLabels()
{
	var schematic	: SCraftingSchematic;
	var title		: string;
	var tagged		: string;
	var Idx			: int;

	theGame.PotP_ClearCraftLabels();

	for (Idx = 0; Idx < m_schematicList.Size(); Idx += 1)
	{
		if (!m_craftingManager.GetSchematic(m_schematicList[Idx], schematic))
		{
			continue;
		}

		title = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(schematic.craftedItemName));
		tagged = AddCollectabilityString(title, schematic.craftedItemName, m_definitionsManager.GetItemCategory(schematic.craftedItemName), m_definitionsManager);

		if (tagged != title)
		{
			theGame.PotP_AddCraftLabel(title, tagged);
		}
	}
}

//---------------------------------------------------

@wrapMethod(CR4CraftingMenu) function UpdateDescription(tag: name)
{
	var schematic	: SCraftingSchematic;
	var title		: string;
	var tagged		: string;

	wrappedMethod(tag);

	if (!m_craftingManager.GetSchematic(tag, schematic))
	{
		return;
	}

	title = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(schematic.craftedItemName));
	tagged = AddCollectabilityString(title, schematic.craftedItemName, m_definitionsManager.GetItemCategory(schematic.craftedItemName), m_definitionsManager);

	if (tagged != title)
	{
		m_flashValueStorage.SetFlashString(DATA_BINDING_NAME_DESCRIPTION + ".title", tagged);
	}
}

//---------------------------------------------------

@addMethod(CR4CraftingMenu)
private function AddCollectabilityString(title: string, craftedItemName: name, cookableType: name, m_definitionsManager: CDefinitionsManagerAccessor) : string
{
	var min_quality, max_quality : int;

	if (!m_definitionsManager.IsItemAnyArmor(craftedItemName) && !m_definitionsManager.IsItemWeapon(craftedItemName) && cookableType != 'gwint' && cookableType != 'trophy')
	{
		return title;
	}

	thePlayer.inv.GetItemQualityFromName(craftedItemName, min_quality, max_quality);
	if (min_quality < 4)
	{
		return title;
	}
	return title + PotP_GetCollectabilityTag(craftedItemName);
}

//---------------------------------------------------

@wrapMethod(W3TooltipComponent) function GetBaseItemData(item: SItemUniqueId, itemInvComponent: CInventoryComponent, optional isShopItem: bool, optional compareWithItem: SItemUniqueId, optional compareItemInv: CInventoryComponent) : CScriptedFlashObject
{
	var tooltip_data	: CScriptedFlashObject;
	var item_category	: name;
	var item_quality	: int;
	var rarity_colour	: string;
	var label			: string;
	var horse_gear		: bool;

	tooltip_data = wrappedMethod(item, itemInvComponent, isShopItem, compareWithItem, compareItemInv);

	if (!isShopItem)
	{
		return tooltip_data;
	}

	item_category = itemInvComponent.GetItemCategory(item);
	horse_gear = (item_category == 'horse_saddle' || item_category == 'horse_bag' || item_category == 'horse_blinder');
	if (!horse_gear && !itemInvComponent.IsItemAnyArmor(item) && !itemInvComponent.IsItemWeapon(item) && item_category != 'gwint' && item_category != 'trophy')
	{
		return tooltip_data;
	}

	item_quality = itemInvComponent.GetItemQuality(item);
	label = GetLocStringByKeyExt(itemInvComponent.GetItemLocalizedNameByUniqueID(item));

	switch (item_quality)
	{
	case 1:		rarity_colour = "<font color='#a2a2a2'>"; break;
	case 2:		rarity_colour = "<font color='#2b7bff'>"; break;
	case 3:		rarity_colour = "<font color='#e1d401'>"; break;
	case 4:		rarity_colour = "<font color='#ca610c'>"; break;
	default:	rarity_colour = "<font color='#01b701'>"; break;
	}

	// PotP tracks every named piece of horse gear, whatever its quality
	if (item_quality >= 4 || horse_gear)
	{
		label += PotP_GetCollectabilityTag(itemInvComponent.GetItemName(item));
	}

	tooltip_data.SetMemberFlashString("ItemName", rarity_colour + label + "</font>");
	return tooltip_data;
}
