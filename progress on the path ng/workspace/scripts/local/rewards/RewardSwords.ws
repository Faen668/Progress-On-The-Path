//---------------------------------------------------
//-- Reward swords ----------------------------------
//---------------------------------------------------
// Pathfinder (steel) and Navigator (silver), PotP's own reward swords (dlc\potp). They're relics built the way the
// game builds its relics: Autogen, their damage made of the game's own per-level autogen abilities. PotP keeps them at
// Geralt's level, up or down, by adding or taking away one level's worth at a time (autogen_fixed_steel_dmg, 8 slashing;
// autogen_fixed_silver_dmg, 10 silver) until the game reckons the sword at his level. It does this when they're given,
// after each load and on each level up, in his inventory and his stash. No other item is touched.

function PotP_RewardSwordNames() : array<name>
{
	var names : array<name>;

	names.PushBack('PotP Pathfinder');
	names.PushBack('PotP Navigator');
	return names;
}

//---------------------------------------------------

function PotP_ScaleRewardSword(inv: CInventoryComponent, item: SItemUniqueId, level: int)
{
	var per_level, base : name;
	var other_base : name;
	var steps : int;

	switch (inv.GetItemCategory(item))
	{
		case 'steelsword':
			per_level = 'autogen_fixed_steel_dmg';
			base = 'autogen_fixed_steel_base';
			other_base = 'autogen_steel_base';
			break;
		case 'silversword':
			per_level = 'autogen_fixed_silver_dmg';
			base = 'autogen_fixed_silver_base';
			other_base = 'autogen_silver_base';
			break;
		default:
			return;
	}

	// Its base damage, if the game hasn't given it one yet (then the game won't give it another)
	if (!inv.ItemHasAbility(item, base) && !inv.ItemHasAbility(item, other_base))
	{
		inv.AddItemCraftedAbility(item, base);
	}

	while (inv.GetItemLevel(item) < level && steps < 200)
	{
		inv.AddItemCraftedAbility(item, per_level, true);
		steps += 1;
	}
	while (inv.GetItemLevel(item) > level && inv.ItemHasAbility(item, per_level) && steps < 400)
	{
		inv.RemoveItemCraftedAbility(item, per_level);
		steps += 1;
	}

	PotP_GrowRewardSword(inv, item, level);
}

//---------------------------------------------------

// The perks grow with the level as the damage does: one growth ability per level above 1, to level 50. With The
// Essential Weapon Rework the larger growth, to stand with its Grandmaster swords; the other kind is cleared, so adding
// or removing that mod puts them right on the next load.
function PotP_GrowRewardSword(inv: CInventoryComponent, item: SItemUniqueId, level: int)
{
	var grow, other, swap : name;
	var wanted, Idx : int;

	if (inv.GetItemName(item) == 'PotP Pathfinder')
	{
		grow = 'PotP_Pathfinder_Growth';
		other = 'PotP_Pathfinder_Growth_EWR';
	}
	else if (inv.GetItemName(item) == 'PotP Navigator')
	{
		grow = 'PotP_Navigator_Growth';
		other = 'PotP_Navigator_Growth_EWR';
	}
	else
	{
		return;
	}
	if (PotP_UsingEssentialWeaponRework())
	{
		swap = grow;
		grow = other;
		other = swap;
	}

	for (Idx = 0; Idx < 200 && inv.ItemHasAbility(item, other); Idx += 1)
	{
		inv.RemoveItemCraftedAbility(item, other);
	}
	for (Idx = 0; Idx < 200 && inv.ItemHasAbility(item, grow); Idx += 1)
	{
		inv.RemoveItemCraftedAbility(item, grow);
	}
	wanted = Min(level, 50) - 1;
	for (Idx = 0; Idx < wanted; Idx += 1)
	{
		inv.AddItemCraftedAbility(item, grow, true);
	}
}

//---------------------------------------------------

function PotP_ScaleRewardSwordsIn(inv: CInventoryComponent, level: int)
{
	var names : array<name> = PotP_RewardSwordNames();
	var items : array<SItemUniqueId>;
	var i, k : int;

	if (!inv)
	{
		return;
	}
	for (i = 0; i < names.Size(); i += 1)
	{
		items = inv.GetItemsByName(names[i]);
		for (k = 0; k < items.Size(); k += 1)
		{
			PotP_ScaleRewardSword(inv, items[k], level);
		}
		// A sword had before its diagram came with it: its diagram too, quietly
		if (items.Size() > 0)
		{
			PotP_LearnRewardSwordSchematic(names[i], true);
		}
	}
}

//---------------------------------------------------
// Each sword's crafting diagram (dlc\potp's items XML, under crafting_schematics). It isn't an item he's given: it's
// learnt with the sword, as reading a diagram would teach it, so a lost, sold or broken down sword can be made again.
// It can't be named as the sword is, as the game takes anything named as a known diagram out of his inventory.

function PotP_RewardSwordSchematic(sword: name) : name
{
	switch (sword)
	{
		case 'PotP Pathfinder':
			return 'PotP Pathfinder schematic';
		case 'PotP Navigator':
			return 'PotP Navigator schematic';
	}
	return '';
}

// Silent: no "new diagram" notice, for the diagrams of swords given before there were any
function PotP_LearnRewardSwordSchematic(sword: name, silent: bool)
{
	var witcher : W3PlayerWitcher = GetWitcherPlayer();
	var schematic : name = PotP_RewardSwordSchematic(sword);
	var learnt : bool;
	var recipe : SCraftingSchematic;

	if (witcher && schematic != '')
	{
		learnt = witcher.AddCraftingSchematic(schematic, silent, true);
		recipe = getCraftingSchematicFromName(schematic);
		// The recipe comes from dlc\potp's items XML: none there (it makes nothing), and the crafting menu shows nothing
		PotP_Log(schematic + (learnt ? " learnt" : " already known") + ", which makes '" + recipe.craftedItemName + "'", 'RewardSwords');
	}
}

// A sword made from its diagram comes in at Geralt's level, as a given one does
@wrapMethod(W3CraftingManager) function Craft(schemName: name, out item: SItemUniqueId) : ECraftingException
{
	var result : ECraftingException;

	result = wrappedMethod(schemName, item);
	if (result == ECE_NoException && (schemName == 'PotP Pathfinder schematic' || schemName == 'PotP Navigator schematic'))
	{
		PotP_ScaleRewardSwords();
	}
	return result;
}

//---------------------------------------------------

function PotP_ScaleRewardSwords()
{
	var witcher : W3PlayerWitcher = GetWitcherPlayer();
	var level : int;

	if (!witcher)
	{
		return;
	}
	level = witcher.GetLevel();
	PotP_ScaleRewardSwordsIn(witcher.GetInventory(), level);
	if (witcher.GetHorseManager())
	{
		PotP_ScaleRewardSwordsIn(witcher.GetHorseManager().GetInventoryComponent(), level);
	}
}

//---------------------------------------------------

// Gives both swords, once per save (or again with force, for testing), at Geralt's level. True if given.
function PotP_GiveRewardSwords(optional force: bool) : bool
{
	var witcher : W3PlayerWitcher = GetWitcherPlayer();
	var names : array<name> = PotP_RewardSwordNames();
	var i : int;

	if (!witcher || (!force && FactsDoesExist("potp_reward_swords_given")))
	{
		return false;
	}
	for (i = 0; i < names.Size(); i += 1)
	{
		witcher.GetInventory().AddAnItem(names[i], 1);
		PotP_LearnRewardSwordSchematic(names[i], false);
	}
	PotP_ScaleRewardSwords();
	FactsAdd("potp_reward_swords_given", 1);
	PotP_Log("Reward swords given at level " + witcher.GetLevel());
	return true;
}

//---------------------------------------------------

@wrapMethod(W3LevelManager) function GainLevel(show: bool) : bool
{
	var gained : bool;

	gained = wrappedMethod(show);
	if (gained)
	{
		PotP_ScaleRewardSwords();
	}
	return gained;
}
