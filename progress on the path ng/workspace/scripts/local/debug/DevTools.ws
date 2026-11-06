//---------------------------------------------------
//-- Developer Tools --------------------------------
//---------------------------------------------------

function PotP_DevCollectItems(item_tag: name, quality: int) : array<name>
{
	var inventory					: CInventoryComponent = thePlayer.GetInventory();
	var candidates					: array<name> = theGame.GetDefinitionsManager().GetItemsWithTag(item_tag);
	var result						: array<name>;
	var min_quality, max_quality	: int;
	var Idx							: int;

	for (Idx = 0; Idx < candidates.Size(); Idx += 1)
	{
		if (result.Contains(candidates[Idx]))
		{
			continue;
		}

		inventory.GetItemQualityFromName(candidates[Idx], min_quality, max_quality);
		if (quality == 999 || min_quality == quality)
		{
			result.PushBack(candidates[Idx]);
		}
	}
	return result;
}

//---------------------------------------------------

function PotP_DevLogItem(channel: name, index: int, item: name)
{
	var main						: CPotP_Main = PotP_Get();
	var min_quality, max_quality	: int;
	var tracked						: string = "n/a";

	thePlayer.GetInventory().GetItemQualityFromName(item, min_quality, max_quality);

	if (main)
	{
		if (main.catalog.is_ready)
		{
			tracked = "false";
			if (main.catalog.IsItemRegistered(item))
			{
				tracked = "true";
			}
		}
	}

	LogChannel(channel, "[" + IntToString(index) + "] " + NameToString(item)
		+ " | " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(item))
		+ " | quality " + IntToString(min_quality)
		+ " | tracked " + tracked);
}

//---------------------------------------------------

exec function pt_additems(item_tag: name, quality: int, optional quantity: int, optional log_entries: bool, optional remove_after: bool)
{
	var inventory	: CInventoryComponent = thePlayer.GetInventory();
	var items		: array<name> = PotP_DevCollectItems(item_tag, quality);
	var Idx			: int;

	if (quantity < 1)
	{
		quantity = 1;
	}

	for (Idx = 0; Idx < items.Size(); Idx += 1)
	{
		inventory.AddAnItem(items[Idx], quantity);

		if (log_entries)
		{
			PotP_DevLogItem('PotP Items', Idx, items[Idx]);
		}
		if (remove_after)
		{
			inventory.RemoveItemByName(items[Idx], quantity);
		}
	}
}

//---------------------------------------------------

exec function pt_logitems(item_tag: name, quality: int)
{
	var items	: array<name> = PotP_DevCollectItems(item_tag, quality);
	var Idx		: int;

	for (Idx = 0; Idx < items.Size(); Idx += 1)
	{
		PotP_DevLogItem('PotP Items', Idx, items[Idx]);
	}
}

//---------------------------------------------------

exec function pt_additemsbyname(search_text: string, quality: int, optional quantity: int, optional remove_after: bool, optional section: name)
{
	var inventory	: CInventoryComponent = thePlayer.GetInventory();
	var defs		: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var candidates	: array<name>;
	var tags		: array<name>;
	var Idx, Tdx	: int;

	if (quantity < 1)
	{
		quantity = 1;
	}

	if (section == 'Armor' || section == 'All' || section == '')	{ tags.PushBack('Armor'); }
	if (section == 'Weapon' || section == 'All' || section == '')	{ tags.PushBack('Weapon'); }
	if (section == 'Crossbow' || section == 'All' || section == '')	{ tags.PushBack('crossbow'); }

	for (Tdx = 0; Tdx < tags.Size(); Tdx += 1)
	{
		candidates = PotP_DevCollectItems(tags[Tdx], quality);

		for (Idx = 0; Idx < candidates.Size(); Idx += 1)
		{
			if (!StrContains(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(candidates[Idx])), search_text))
			{
				continue;
			}

			inventory.AddAnItem(candidates[Idx], quantity);
			PotP_DevLogItem('PotP Items', Idx, candidates[Idx]);

			if (remove_after)
			{
				inventory.RemoveItemByName(candidates[Idx], quantity);
			}
		}
	}
}

//---------------------------------------------------

exec function pt_logvariations(item_tag: name, only_variations: bool)
{
	var defs		: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
	var items		: array<name> = PotP_DevCollectItems(item_tag, 4);
	var titles		: array<string>;
	var members		: array<string>;
	var counts		: array<int>;
	var title		: string;
	var Idx, Gdx	: int;

	for (Idx = 0; Idx < items.Size(); Idx += 1)
	{
		title = PotP_CleanTitle(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(items[Idx])));
		Gdx = titles.FindFirst(title);

		if (Gdx == -1)
		{
			titles.PushBack(title);
			members.PushBack(NameToString(items[Idx]));
			counts.PushBack(1);
		}
		else
		{
			members[Gdx] += ", " + NameToString(items[Idx]);
			counts[Gdx] += 1;
		}
	}

	for (Idx = 0; Idx < titles.Size(); Idx += 1)
	{
		if (!only_variations || counts[Idx] > 1)
		{
			LogChannel('PotP Variations', titles[Idx] + " (" + IntToString(counts[Idx]) + "): " + members[Idx]);
		}
	}
}

//---------------------------------------------------

exec function pt_loggwentcards(only_variations: bool)
{
	var gwent		: CR4GwintManager = theGame.GetGwintManager();
	var cards		: array<SCardDefinition> = gwent.GetCardDefs();
	var titles		: array<string>;
	var members		: array<string>;
	var counts		: array<int>;
	var title		: string;
	var Idx, Gdx	: int;

	for (Idx = 0; Idx < cards.Size(); Idx += 1)
	{
		title = IntToString((int)cards[Idx].faction) + "|" + PotP_CleanTitle(GetLocStringByKeyExt(cards[Idx].title));
		Gdx = titles.FindFirst(title);

		if (Gdx == -1)
		{
			titles.PushBack(title);
			members.PushBack(NameToString(cards[Idx].itemName));
			counts.PushBack(1);
		}
		else
		{
			members[Gdx] += ", " + NameToString(cards[Idx].itemName);
			counts[Gdx] += 1;
		}
	}

	for (Idx = 0; Idx < titles.Size(); Idx += 1)
	{
		if (!only_variations || counts[Idx] > 1)
		{
			LogChannel('PotP Gwent', titles[Idx] + " (" + IntToString(counts[Idx]) + "): " + members[Idx]);
		}
	}
}

//---------------------------------------------------

exec function pt_logpins(pin_type: name)
{
	var pins	: array<SEntityMapPinInfo> = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());
	var Idx		: int;

	for (Idx = 0; Idx < pins.Size(); Idx += 1)
	{
		if (pins[Idx].entityType == pin_type)
		{
			LogChannel('PotP Pins', IntToString(Idx) + ": " + NameToString(pins[Idx].entityName)
				+ " | " + GetLocStringByKeyExt("Map_Location_" + NameToString(pins[Idx].entityName)));
		}
	}
}

//---------------------------------------------------

exec function pt_loginstancepins(pin_type: name)
{
	var pins	: array<SCommonMapPinInstance> = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetDepotPath());
	var Idx		: int;

	for (Idx = 0; Idx < pins.Size(); Idx += 1)
	{
		if (pins[Idx].type == pin_type)
		{
			LogChannel('PotP Pins', IntToString(Idx) + ": id " + IntToString(pins[Idx].id) + " | tag " + NameToString(pins[Idx].tag));
		}
	}
}

//---------------------------------------------------

exec function pt_dlc()
{
	var manager	: CDLCManager = theGame.GetDLCManager();
	var dlcs	: array<name>;
	var Idx		: int;

	manager.GetDLCs(dlcs);
	for (Idx = 0; Idx < dlcs.Size(); Idx += 1)
	{
		if (manager.IsDLCAvailable(dlcs[Idx]))
		{
			LogChannel('PotP DLC', NameToString(dlcs[Idx]));
		}
	}
}

//---------------------------------------------------
//-- Notifications ----------------------------------
//---------------------------------------------------

exec function pt_notify(optional count: int, optional as_summary: bool)
{
	var main		: CPotP_Main = PotP_ConsoleMain();
	var entries		: array<CPotP_Entry>;
	var tracked		: CPotP_Entry;
	var wanted		: int;
	var attempts	: int;
	var Idx			: int;

	if (!main)
	{
		return;
	}

	if (count <= 0)
	{
		count = 6;
	}

	entries = main.catalog.entries;
	if (as_summary)
	{
		main.notifications.ResetSummary();
	}

	for (Idx = 0; Idx < count; Idx += 1)
	{
		wanted = Idx % 5;
		tracked = entries[RandRange(entries.Size())];

		for (attempts = 0; attempts < 200 && (int)tracked.category != wanted; attempts += 1)
		{
			tracked = entries[RandRange(entries.Size())];
		}

		if (as_summary)
		{
			main.notifications.AddToSummary(tracked);
		}
		else
		{
			main.notifications.AddToBackground(tracked);
		}
	}

	if (as_summary)
	{
		main.notifications.ShowSummary();
	}
	else
	{
		main.notifications.FlushBackground();
	}
}
