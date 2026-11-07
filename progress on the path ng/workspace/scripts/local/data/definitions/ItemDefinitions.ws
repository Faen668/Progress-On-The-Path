//---------------------------------------------------
//-- Item Definitions -------------------------------
//---------------------------------------------------

function PotP_DefineItems(catalog: CPotP_Catalog)
{
	PotP_DefineItems_01(catalog);
	PotP_DefineItems_02(catalog);
	PotP_DefineItems_03(catalog);
	PotP_DefineItems_04(catalog);
	PotP_DefineItems_05(catalog);
	PotP_DefineItems_06(catalog);
	PotP_DefineItems_07(catalog);
	PotP_DefineItems_08(catalog);
	PotP_DefineItems_09(catalog);
	PotP_DefineItems_10(catalog);
	PotP_DefineItems_35(catalog);
	PotP_DefineItems_36(catalog);
	PotP_DefineItems_37(catalog);
	PotP_DefineItems_38(catalog);
	PotP_DefineItems_39(catalog);
	PotP_DefineItems_40(catalog);
	PotP_DefineItems_41(catalog);
	PotP_DefineItems_42(catalog);
	PotP_DefineItems_11(catalog);
	PotP_DefineItems_12(catalog);
	PotP_DefineItems_13(catalog);
	PotP_DefineItems_14(catalog);
	PotP_DefineItems_15(catalog);
	PotP_DefineItems_16(catalog);
	PotP_DefineItems_17(catalog);
	PotP_DefineItems_18(catalog);
	PotP_DefineItems_19(catalog);
	PotP_DefineItems_20(catalog);
	PotP_DefineItems_21(catalog);
	PotP_DefineItems_22(catalog);
	PotP_DefineItems_23(catalog);
	PotP_DefineItems_24(catalog);
	PotP_DefineItems_25(catalog);
	PotP_DefineItems_26(catalog);
	PotP_DefineItems_27(catalog);
	PotP_DefineItems_28(catalog);
	PotP_DefineItems_29(catalog);
	PotP_DefineItems_30(catalog);
	PotP_DefineItems_31(catalog);
	PotP_DefineItems_32(catalog);
	PotP_DefineItems_33(catalog);
	PotP_DefineItems_34(catalog);
}

//---------------------------------------------------

function PotP_DefineItems_01(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_1", PotP_A_Items, "PotP_TrackingGroup_GearSets_DolBlathanna");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Dol Blathanna Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Dol Blathanna Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Dol Blathanna Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Dol Blathanna Pants');
	catalog.AddItem("_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Dol Blathanna longsword');
	catalog.AddItem("_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'White Widow of Dol Blathanna');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_02(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_2", PotP_A_Items, "PotP_TrackingGroup_GearSets_ForgottenWolven");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Netflix Armor', 'Netflix Armor 1', 'Netflix Armor 2');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Netflix Boots', 'Netflix Boots 1', 'Netflix Boots 2');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Netflix Gloves', 'Netflix Gloves 1', 'Netflix Gloves 2');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Netflix Pants', 'Netflix Pants 1', 'Netflix Pants 2');
	catalog.AddItem("_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Netflix steel sword', 'Netflix steel sword 1', 'Netflix steel sword 2', 'Reinald Netflix steel sword');
	catalog.AddItem("_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'Netflix silver sword', 'Netflix silver sword 1', 'Netflix silver sword 2', 'Reinald Netflix silver sword');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_03(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	// In three chests in the Unseen Elder's cave (q704_gravity_cave\loot.w2l), only on that route of 'The Night of Long Fangs'
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_3", PotP_A_Items, "PotP_TrackingGroup_GearSets_HenGaidth");
	tracked = catalog.AddItem("_01", PotP_E_Missable, PotP_I_Gears, PotP_U_Armor, 'q704_vampire_armor');
	PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_HenGaidthArmour");
	tracked = catalog.AddItem("_02", PotP_E_Missable, PotP_I_Gears, PotP_U_Boots, 'q704_vampire_boots');
	PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_HenGaidthArmour");
	tracked = catalog.AddItem("_03", PotP_E_Missable, PotP_I_Gears, PotP_U_Glove, 'q704_vampire_gloves');
	PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_HenGaidthArmour");
	tracked = catalog.AddItem("_04", PotP_E_Missable, PotP_I_Gears, PotP_U_Head, 'q704_vampire_mask');
	PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_HenGaidthArmour");
	tracked = catalog.AddItem("_05", PotP_E_Missable, PotP_I_Gears, PotP_U_Pants, 'q704_vampire_pants');
	PotP_SetCaveMissable(catalog, tracked, "PotP_MissableTip_HenGaidthArmour");
	catalog.EndSection();
}

//---------------------------------------------------
// Something in the Unseen Elder's cave: missed by choosing Syanna instead, or by leaving the cave without it, when it's
// sealed. The Syanna choice is Regis's question in q704_06_regis_info_inject (Monster Hunt); the Damien route reaches the
// fairy tale without it. q704_fairy_tale_started is set on both Syanna routes and never on the cave's.

function PotP_SetCaveMissable(catalog: CPotP_Catalog, tracked: CPotP_Entry, tip_key: string)
{
	catalog.SetMissableReasonFor(tracked, tip_key, "q704_fairy_tale_started");
	catalog.AddMissedFactFor(tracked, "q704_gravity_cave_done");
	// Quest blocks in q704_03_monster_hunt, q704_02_fairy_tale and q704_04_vampire_cave (bob)
	catalog.AddMissedBlockFor(tracked, "476251b9-80da-490b-ac93-7dec2b8b2645", "SyannaShortcut");   // SceneBlock, Regis: find Syanna
	catalog.AddMissedBlockFor(tracked, "e640b3c2-6ac1-472f-bfd6-dad788cdb2be", "SyannaShortcut");   // the same, by its other input
	catalog.AddMissedBlockFor(tracked, "6654101a-5344-4970-abbd-3a23378d3826", "Out");              // FactsDBChanging "q704_fairy_tale_started +1"
	catalog.AddMissedBlockFor(tracked, "5dfcecbd-f858-4f9d-a14d-9afe4da34698", "End");              // SceneBlock, the Unseen Elder: the cave is sealed after
	catalog.AddMissedBlockFor(tracked, "5dfcecbd-f858-4f9d-a14d-9afe4da34698", "Shortcut");
}

//---------------------------------------------------

function PotP_DefineItems_04(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_4", PotP_A_Items, "PotP_TrackingGroup_GearSets_NewMoon");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Thief Armor', 'Thief Armor No Medallion');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Thief Boots', 'Thief Boots No Medallion');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Thief Gloves', 'Thief Gloves No Medallion');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Thief Pants', 'Thief Pants No Medallion');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_05(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_5", PotP_A_Items, "PotP_TrackingGroup_GearSets_Nilfgaardian");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC5 Nilfgaardian Armor', 'NGP DLC5 Nilfgaardian Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC5 Nilfgaardian Boots', 'NGP DLC5 Nilfgaardian Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC5 Nilfgaardian Gloves', 'NGP DLC5 Nilfgaardian Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC5 Nilfgaardian Pants', 'NGP DLC5 Nilfgaardian Pants');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_06(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_6", PotP_A_Items, "PotP_TrackingGroup_GearSets_Ofieri");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Crafted Ofir Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Crafted Ofir Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Crafted Ofir Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Crafted Ofir Pants');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_07(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_7", PotP_A_Items, "PotP_TrackingGroup_GearSets_Temerian");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC1 Temerian Armor', 'NGP DLC1 Temerian Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC1 Temerian Boots', 'NGP DLC1 Temerian Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC1 Temerian Gloves', 'NGP DLC1 Temerian Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC1 Temerian Pants', 'NGP DLC1 Temerian Pants');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_08(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_8", PotP_A_Items, "PotP_TrackingGroup_GearSets_TeshamMutna");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'q702_vampire_armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'q702_vampire_boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'q702_vampire_gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Head, 'q702_vampire_mask');
	catalog.AddItem("_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'q702_vampire_pants');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_09(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_9", PotP_A_Items, "PotP_TrackingGroup_GearSets_Undvik");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'DLC14 Skellige Armor', 'NGP DLC14 Skellige Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'DLC14 Skellige Boots', 'NGP DLC14 Skellige Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'DLC14 Skellige Gloves', 'NGP DLC14 Skellige Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'DLC14 Skellige Pants', 'NGP DLC14 Skellige Pants');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_10(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_A", PotP_A_Items, "PotP_TrackingGroup_GearSets_WhiteTiger");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'White Tiger Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'White Tiger Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'White Tiger Gloves');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'White Tiger Pants');
	// The Vixen swords are this set's, though their names don't say so
	catalog.AddItem("_05", PotP_E_Primary, PotP_I_Gears, PotP_U_Steel, 'Steel Vixen');
	catalog.AddItem("_06", PotP_E_Primary, PotP_I_Gears, PotP_U_Silve, 'Silver Vixen');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_35(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_1", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Feline");
	tracked = catalog.AddItem("_01", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Lynx Armor');
	tracked.SetUpgrade("armor", 0, 5);
	tracked = catalog.AddItem("_02", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Lynx Armor 1');
	tracked.SetUpgrade("armor", 1, 5);
	tracked = catalog.AddItem("_03", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Lynx Armor 2');
	tracked.SetUpgrade("armor", 2, 5);
	tracked = catalog.AddItem("_04", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Lynx Armor 3');
	tracked.SetUpgrade("armor", 3, 5);
	tracked = catalog.AddItem("_05", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Armor, 'Lynx Armor 4');
	tracked.SetUpgrade("armor", 4, 5);
	tracked = catalog.AddItem("_06", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Lynx Boots 1');
	tracked.SetUpgrade("boots", 0, 5);
	tracked = catalog.AddItem("_07", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Lynx Boots 2');
	tracked.SetUpgrade("boots", 1, 5);
	tracked = catalog.AddItem("_08", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Lynx Boots 3');
	tracked.SetUpgrade("boots", 2, 5);
	tracked = catalog.AddItem("_09", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Lynx Boots 4');
	tracked.SetUpgrade("boots", 3, 5);
	tracked = catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Boots, 'Lynx Boots 5');
	tracked.SetUpgrade("boots", 4, 5);
	tracked = catalog.AddItem("_11", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Lynx Gloves 1');
	tracked.SetUpgrade("gloves", 0, 5);
	tracked = catalog.AddItem("_12", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Lynx Gloves 2');
	tracked.SetUpgrade("gloves", 1, 5);
	tracked = catalog.AddItem("_13", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Lynx Gloves 3');
	tracked.SetUpgrade("gloves", 2, 5);
	tracked = catalog.AddItem("_14", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Lynx Gloves 4');
	tracked.SetUpgrade("gloves", 3, 5);
	tracked = catalog.AddItem("_15", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Glove, 'Lynx Gloves 5');
	tracked.SetUpgrade("gloves", 4, 5);
	tracked = catalog.AddItem("_16", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Lynx Pants 1');
	tracked.SetUpgrade("pants", 0, 5);
	tracked = catalog.AddItem("_17", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Lynx Pants 2');
	tracked.SetUpgrade("pants", 1, 5);
	tracked = catalog.AddItem("_18", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Lynx Pants 3');
	tracked.SetUpgrade("pants", 2, 5);
	tracked = catalog.AddItem("_19", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Lynx Pants 4');
	tracked.SetUpgrade("pants", 3, 5);
	tracked = catalog.AddItem("_20", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Pants, 'Lynx Pants 5');
	tracked.SetUpgrade("pants", 4, 5);
	tracked = catalog.AddItem("_21", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Lynx School steel sword');
	tracked.SetUpgrade("steel", 0, 5);
	tracked = catalog.AddItem("_22", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Lynx School steel sword 1');
	tracked.SetUpgrade("steel", 1, 5);
	tracked = catalog.AddItem("_23", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Lynx School steel sword 2');
	tracked.SetUpgrade("steel", 2, 5);
	tracked = catalog.AddItem("_24", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Lynx School steel sword 3');
	tracked.SetUpgrade("steel", 3, 5);
	tracked = catalog.AddItem("_25", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Steel, 'Lynx School steel sword 4');
	tracked.SetUpgrade("steel", 4, 5);
	tracked = catalog.AddItem("_26", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Lynx School silver sword');
	tracked.SetUpgrade("silver", 0, 5);
	tracked = catalog.AddItem("_27", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Lynx School silver sword 1');
	tracked.SetUpgrade("silver", 1, 5);
	tracked = catalog.AddItem("_28", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Lynx School silver sword 2');
	tracked.SetUpgrade("silver", 2, 5);
	tracked = catalog.AddItem("_29", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Lynx School silver sword 3');
	tracked.SetUpgrade("silver", 3, 5);
	tracked = catalog.AddItem("_30", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Silve, 'Lynx School silver sword 4');
	tracked.SetUpgrade("silver", 4, 5);
	catalog.AddItem("_31", PotP_E_Primary, PotP_I_Witch, PotP_U_Cross, 'Lynx School Crossbow');
	// Gaetan's sword, from the stash in 'Where the Cat and Wolf Play...'. Missed if he's killed, or if bandits loot the stash
	// first: the quest's own fact for the one, and its blocks for both as they happen.
	tracked = catalog.AddItem("_32", PotP_E_Missable, PotP_I_Witch, PotP_U_Steel, 'mq1058_cat_school_sword');
	tracked.missable_tip = "PotP_MissableTip_Tiegr";
	tracked.missed_fact = "mq1058_lynx_witcher_killed";
	tracked.also_missed_fact = "PotP_ItemMissed_Tiegr";
	// Quest blocks in mq1058_lynx_witcher (dlc15)
	catalog.AddEventMissedBlock("8dca1782-16d3-4553-ad39-372a8f357ed8", "Out");   // FactsDBChanging "mq1058_lynx_witcher_killed +1"
	catalog.AddEventMissedBlock("43d2a813-7666-4878-86d8-5cb62ab7ce4e", "Out");   // LayersHider "Show looted hideout", in "Secret Stash Looted"
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_36(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_2", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Griffin");
	tracked = catalog.AddItem("_01", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Gryphon Armor');
	tracked.SetUpgrade("armor", 0, 5);
	tracked = catalog.AddItem("_02", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Gryphon Armor 1');
	tracked.SetUpgrade("armor", 1, 5);
	tracked = catalog.AddItem("_03", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Gryphon Armor 2');
	tracked.SetUpgrade("armor", 2, 5);
	tracked = catalog.AddItem("_04", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Gryphon Armor 3');
	tracked.SetUpgrade("armor", 3, 5);
	tracked = catalog.AddItem("_05", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Armor, 'Gryphon Armor 4');
	tracked.SetUpgrade("armor", 4, 5);
	tracked = catalog.AddItem("_06", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Gryphon Boots 1');
	tracked.SetUpgrade("boots", 0, 5);
	tracked = catalog.AddItem("_07", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Gryphon Boots 2');
	tracked.SetUpgrade("boots", 1, 5);
	tracked = catalog.AddItem("_08", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Gryphon Boots 3');
	tracked.SetUpgrade("boots", 2, 5);
	tracked = catalog.AddItem("_09", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Gryphon Boots 4');
	tracked.SetUpgrade("boots", 3, 5);
	tracked = catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Boots, 'Gryphon Boots 5');
	tracked.SetUpgrade("boots", 4, 5);
	tracked = catalog.AddItem("_11", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Gryphon Gloves 1');
	tracked.SetUpgrade("gloves", 0, 5);
	tracked = catalog.AddItem("_12", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Gryphon Gloves 2');
	tracked.SetUpgrade("gloves", 1, 5);
	tracked = catalog.AddItem("_13", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Gryphon Gloves 3');
	tracked.SetUpgrade("gloves", 2, 5);
	tracked = catalog.AddItem("_14", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Gryphon Gloves 4');
	tracked.SetUpgrade("gloves", 3, 5);
	tracked = catalog.AddItem("_15", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Glove, 'Gryphon Gloves 5');
	tracked.SetUpgrade("gloves", 4, 5);
	tracked = catalog.AddItem("_16", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Gryphon Pants 1');
	tracked.SetUpgrade("pants", 0, 5);
	tracked = catalog.AddItem("_17", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Gryphon Pants 2');
	tracked.SetUpgrade("pants", 1, 5);
	tracked = catalog.AddItem("_18", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Gryphon Pants 3');
	tracked.SetUpgrade("pants", 2, 5);
	tracked = catalog.AddItem("_19", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Gryphon Pants 4');
	tracked.SetUpgrade("pants", 3, 5);
	tracked = catalog.AddItem("_20", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Pants, 'Gryphon Pants 5');
	tracked.SetUpgrade("pants", 4, 5);
	tracked = catalog.AddItem("_21", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Gryphon School steel sword');
	tracked.SetUpgrade("steel", 0, 5);
	tracked = catalog.AddItem("_22", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Gryphon School steel sword 1');
	tracked.SetUpgrade("steel", 1, 5);
	tracked = catalog.AddItem("_23", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Gryphon School steel sword 2');
	tracked.SetUpgrade("steel", 2, 5);
	tracked = catalog.AddItem("_24", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Gryphon School steel sword 3');
	tracked.SetUpgrade("steel", 3, 5);
	tracked = catalog.AddItem("_25", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Steel, 'Gryphon School steel sword 4');
	tracked.SetUpgrade("steel", 4, 5);
	tracked = catalog.AddItem("_26", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Gryphon School silver sword');
	tracked.SetUpgrade("silver", 0, 5);
	tracked = catalog.AddItem("_27", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Gryphon School silver sword 1');
	tracked.SetUpgrade("silver", 1, 5);
	tracked = catalog.AddItem("_28", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Gryphon School silver sword 2');
	tracked.SetUpgrade("silver", 2, 5);
	tracked = catalog.AddItem("_29", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Gryphon School silver sword 3');
	tracked.SetUpgrade("silver", 3, 5);
	tracked = catalog.AddItem("_30", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Silve, 'Gryphon School silver sword 4');
	tracked.SetUpgrade("silver", 4, 5);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_37(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_3", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Ursine");
	tracked = catalog.AddItem("_01", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Bear Armor');
	tracked.SetUpgrade("armor", 0, 5);
	tracked = catalog.AddItem("_02", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Bear Armor 1');
	tracked.SetUpgrade("armor", 1, 5);
	tracked = catalog.AddItem("_03", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Bear Armor 2');
	tracked.SetUpgrade("armor", 2, 5);
	tracked = catalog.AddItem("_04", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Bear Armor 3');
	tracked.SetUpgrade("armor", 3, 5);
	tracked = catalog.AddItem("_05", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Armor, 'Bear Armor 4');
	tracked.SetUpgrade("armor", 4, 5);
	tracked = catalog.AddItem("_06", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Bear Boots 1');
	tracked.SetUpgrade("boots", 0, 5);
	tracked = catalog.AddItem("_07", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Bear Boots 2');
	tracked.SetUpgrade("boots", 1, 5);
	tracked = catalog.AddItem("_08", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Bear Boots 3');
	tracked.SetUpgrade("boots", 2, 5);
	tracked = catalog.AddItem("_09", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Bear Boots 4');
	tracked.SetUpgrade("boots", 3, 5);
	tracked = catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Boots, 'Bear Boots 5');
	tracked.SetUpgrade("boots", 4, 5);
	tracked = catalog.AddItem("_11", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Bear Gloves 1');
	tracked.SetUpgrade("gloves", 0, 5);
	tracked = catalog.AddItem("_12", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Bear Gloves 2');
	tracked.SetUpgrade("gloves", 1, 5);
	tracked = catalog.AddItem("_13", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Bear Gloves 3');
	tracked.SetUpgrade("gloves", 2, 5);
	tracked = catalog.AddItem("_14", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Bear Gloves 4');
	tracked.SetUpgrade("gloves", 3, 5);
	tracked = catalog.AddItem("_15", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Glove, 'Bear Gloves 5');
	tracked.SetUpgrade("gloves", 4, 5);
	tracked = catalog.AddItem("_16", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Bear Pants 1');
	tracked.SetUpgrade("pants", 0, 5);
	tracked = catalog.AddItem("_17", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Bear Pants 2');
	tracked.SetUpgrade("pants", 1, 5);
	tracked = catalog.AddItem("_18", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Bear Pants 3');
	tracked.SetUpgrade("pants", 2, 5);
	tracked = catalog.AddItem("_19", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Bear Pants 4');
	tracked.SetUpgrade("pants", 3, 5);
	tracked = catalog.AddItem("_20", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Pants, 'Bear Pants 5');
	tracked.SetUpgrade("pants", 4, 5);
	tracked = catalog.AddItem("_21", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Bear School steel sword');
	tracked.SetUpgrade("steel", 0, 5);
	tracked = catalog.AddItem("_22", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Bear School steel sword 1');
	tracked.SetUpgrade("steel", 1, 5);
	tracked = catalog.AddItem("_23", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Bear School steel sword 2');
	tracked.SetUpgrade("steel", 2, 5);
	tracked = catalog.AddItem("_24", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Bear School steel sword 3');
	tracked.SetUpgrade("steel", 3, 5);
	tracked = catalog.AddItem("_25", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Steel, 'Bear School steel sword 4');
	tracked.SetUpgrade("steel", 4, 5);
	tracked = catalog.AddItem("_26", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Bear School silver sword');
	tracked.SetUpgrade("silver", 0, 5);
	tracked = catalog.AddItem("_27", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Bear School silver sword 1');
	tracked.SetUpgrade("silver", 1, 5);
	tracked = catalog.AddItem("_28", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Bear School silver sword 2');
	tracked.SetUpgrade("silver", 2, 5);
	tracked = catalog.AddItem("_29", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Bear School silver sword 3');
	tracked.SetUpgrade("silver", 3, 5);
	tracked = catalog.AddItem("_30", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Silve, 'Bear School silver sword 4');
	tracked.SetUpgrade("silver", 4, 5);
	catalog.AddItem("_31", PotP_E_Primary, PotP_I_Witch, PotP_U_Cross, 'Bear School Crossbow');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_38(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_4", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Wolven");
	tracked = catalog.AddItem("_01", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Wolf Armor', 'NGP Wolf Armor');
	tracked.SetUpgrade("armor", 0, 5);
	tracked = catalog.AddItem("_02", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Wolf Armor 1', 'NGP Wolf Armor 1');
	tracked.SetUpgrade("armor", 1, 5);
	tracked = catalog.AddItem("_03", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Wolf Armor 2', 'NGP Wolf Armor 2');
	tracked.SetUpgrade("armor", 2, 5);
	tracked = catalog.AddItem("_04", PotP_E_Primary, PotP_I_Witch, PotP_U_Armor, 'Wolf Armor 3', 'NGP Wolf Armor 3');
	tracked.SetUpgrade("armor", 3, 5);
	tracked = catalog.AddItem("_05", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Armor, 'Wolf Armor 4');
	tracked.SetUpgrade("armor", 4, 5);
	tracked = catalog.AddItem("_06", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Wolf Boots 1', 'NGP Wolf Boots 1');
	tracked.SetUpgrade("boots", 0, 5);
	tracked = catalog.AddItem("_07", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Wolf Boots 2', 'NGP Wolf Boots 2');
	tracked.SetUpgrade("boots", 1, 5);
	tracked = catalog.AddItem("_08", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Wolf Boots 3', 'NGP Wolf Boots 3');
	tracked.SetUpgrade("boots", 2, 5);
	tracked = catalog.AddItem("_09", PotP_E_Primary, PotP_I_Witch, PotP_U_Boots, 'Wolf Boots 4', 'NGP Wolf Boots 4');
	tracked.SetUpgrade("boots", 3, 5);
	tracked = catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Boots, 'Wolf Boots 5');
	tracked.SetUpgrade("boots", 4, 5);
	tracked = catalog.AddItem("_11", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Wolf Gloves 1', 'NGP Wolf Gloves 1');
	tracked.SetUpgrade("gloves", 0, 5);
	tracked = catalog.AddItem("_12", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Wolf Gloves 2', 'NGP Wolf Gloves 2');
	tracked.SetUpgrade("gloves", 1, 5);
	tracked = catalog.AddItem("_13", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Wolf Gloves 3', 'NGP Wolf Gloves 3');
	tracked.SetUpgrade("gloves", 2, 5);
	tracked = catalog.AddItem("_14", PotP_E_Primary, PotP_I_Witch, PotP_U_Glove, 'Wolf Gloves 4', 'NGP Wolf Gloves 4');
	tracked.SetUpgrade("gloves", 3, 5);
	tracked = catalog.AddItem("_15", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Glove, 'Wolf Gloves 5');
	tracked.SetUpgrade("gloves", 4, 5);
	tracked = catalog.AddItem("_16", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Wolf Pants 1', 'NGP Wolf Pants 1');
	tracked.SetUpgrade("pants", 0, 5);
	tracked = catalog.AddItem("_17", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Wolf Pants 2', 'NGP Wolf Pants 2');
	tracked.SetUpgrade("pants", 1, 5);
	tracked = catalog.AddItem("_18", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Wolf Pants 3', 'NGP Wolf Pants 3');
	tracked.SetUpgrade("pants", 2, 5);
	tracked = catalog.AddItem("_19", PotP_E_Primary, PotP_I_Witch, PotP_U_Pants, 'Wolf Pants 4', 'NGP Wolf Pants 4');
	tracked.SetUpgrade("pants", 3, 5);
	tracked = catalog.AddItem("_20", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Pants, 'Wolf Pants 5');
	tracked.SetUpgrade("pants", 4, 5);
	tracked = catalog.AddItem("_21", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Wolf School steel sword', 'NGP Wolf School steel sword');
	tracked.SetUpgrade("steel", 0, 5);
	tracked = catalog.AddItem("_22", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Wolf School steel sword 1', 'NGP Wolf School steel sword 1');
	tracked.SetUpgrade("steel", 1, 5);
	tracked = catalog.AddItem("_23", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Wolf School steel sword 2', 'NGP Wolf School steel sword 2');
	tracked.SetUpgrade("steel", 2, 5);
	tracked = catalog.AddItem("_24", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Wolf School steel sword 3', 'NGP Wolf School steel sword 3');
	tracked.SetUpgrade("steel", 3, 5);
	tracked = catalog.AddItem("_25", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Steel, 'Wolf School steel sword 4');
	tracked.SetUpgrade("steel", 4, 5);
	tracked = catalog.AddItem("_26", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Wolf School silver sword', 'NGP Wolf School silver sword');
	tracked.SetUpgrade("silver", 0, 5);
	tracked = catalog.AddItem("_27", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Wolf School silver sword 1', 'NGP Wolf School silver sword 1');
	tracked.SetUpgrade("silver", 1, 5);
	tracked = catalog.AddItem("_28", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Wolf School silver sword 2', 'NGP Wolf School silver sword 2');
	tracked.SetUpgrade("silver", 2, 5);
	tracked = catalog.AddItem("_29", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Wolf School silver sword 3', 'NGP Wolf School silver sword 3');
	tracked.SetUpgrade("silver", 3, 5);
	tracked = catalog.AddItem("_30", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Silve, 'Wolf School silver sword 4');
	tracked.SetUpgrade("silver", 4, 5);
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_39(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_5", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Manticore");
	catalog.AddItem("_01", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Armor, 'Red Wolf Armor 1', 'Red Wolf Armor 2');
	catalog.AddItem("_02", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Boots, 'Red Wolf Boots 1', 'Red Wolf Boots 2');
	catalog.AddItem("_03", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Glove, 'Red Wolf Gloves 1', 'Red Wolf Gloves 2');
	catalog.AddItem("_04", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Pants, 'Red Wolf Pants 1', 'Red Wolf Pants 2');
	catalog.AddItem("_05", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Steel, 'Red Wolf School steel sword 1', 'Red Wolf School steel sword 2');
	catalog.AddItem("_06", PotP_E_Primary_DLC2, PotP_I_Witch, PotP_U_Silve, 'Red Wolf School silver sword 1', 'Red Wolf School silver sword 2');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_40(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Witch_6", PotP_A_Items, "PotP_TrackingGroup_WitcherGear_Viper");
	catalog.AddItem("_01", PotP_E_Primary_DLC1, PotP_I_Witch, PotP_U_Armor, 'EP1 Witcher Armor');
	catalog.AddItem("_02", PotP_E_Primary_DLC1, PotP_I_Witch, PotP_U_Boots, 'EP1 Witcher Boots');
	catalog.AddItem("_03", PotP_E_Primary_DLC1, PotP_I_Witch, PotP_U_Glove, 'EP1 Witcher Gloves');
	catalog.AddItem("_04", PotP_E_Primary_DLC1, PotP_I_Witch, PotP_U_Pants, 'EP1 Witcher Pants');
	catalog.AddItem("_05", PotP_E_Primary, PotP_I_Witch, PotP_U_Steel, 'Viper School steel sword');
	catalog.AddItem("_06", PotP_E_Primary, PotP_I_Witch, PotP_U_Silve, 'Viper School silver sword');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_41(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_GearS_B", PotP_A_Items, "PotP_TrackingGroup_GearSets_ScarletCrest");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Gears, PotP_U_Armor, 'Scarlet Crest Armor');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Gears, PotP_U_Boots, 'Scarlet Crest Boots');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Gears, PotP_U_Glove, 'Scarlet Crest Gauntlets');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Gears, PotP_U_Pants, 'Scarlet Crest Trousers');
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineItems_42(catalog: CPotP_Catalog)
{
	var tracked : CPotP_Entry;

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Horse_1", PotP_A_Items, "PotP_TrackingGroup_HorseGear_Blinders");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC1 Temerian HorseBlinders');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC5 Nilfgaardian HorseBlinders');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC14 Skellige HorseBlinders');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'Fire Horse Blinders');
	catalog.AddItem("_05", PotP_E_Primary_DLC1, PotP_I_Horse, PotP_U_Horse, 'Ofir Horse Blinders');
	catalog.AddItem("_06", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders');
	catalog.AddItem("_07", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders 2');
	catalog.AddItem("_08", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders 3');
	catalog.AddItem("_09", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders 4');
	catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders 5');
	catalog.AddItem("_11", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horse blinders 6');
	catalog.EndSection();

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Horse_2", PotP_A_Items, "PotP_TrackingGroup_HorseGear_Saddles");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC1 Temerian HorseSaddle');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC5 Nilfgaardian HorseSaddle');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC14 Skellige HorseSaddle');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'Fire Horse Saddle');
	catalog.AddItem("_05", PotP_E_Primary_DLC1, PotP_I_Horse, PotP_U_Horse, 'Horse Saddle 5');
	catalog.AddItem("_06", PotP_E_Primary_DLC1, PotP_I_Horse, PotP_U_Horse, 'Horse Saddle 6');
	// O'Dimm's reward if he takes Olgierd: reward q605_mirror_finale_demon_horse, in the temple meeting's peace branch
	catalog.AddItem("_07", PotP_E_Missable_DLC1, PotP_I_Horse, PotP_U_Horse, 'Devil Saddle');
	catalog.SetMissableReason("PotP_MissableTip_DevilSaddle", "q605_mirror_won");
	// Quest blocks in q605_finale (ep1)
	catalog.AddEventMissedBlock("e8d4f1ab-789a-4fcf-9013-e499654c2891", "q605_mirror_game");   // SceneBlock, the temple meeting: O'Dimm's game
	catalog.AddItem("_08", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle');
	catalog.AddItem("_09", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle 2');
	catalog.AddItem("_10", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle 3');
	catalog.AddItem("_11", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle 4');
	catalog.AddItem("_12", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle 5');
	catalog.AddItem("_13", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint saddle 6');
	// The tourney's prize for winning the horse race in sq701: Geralt's or Ravix's, by the name he registered under, so one entry.
	// Missed by losing the race (no retry), or the tournament failing when 'The Night of Long Fangs' starts.
	catalog.AddItem("_14", PotP_E_Missable_DLC2, PotP_I_Horse, PotP_U_Horse, 'Tourney Geralt Saddle', 'Tourney Ravix Saddle');
	catalog.SetMissableReason("PotP_MissableTip_TourneySaddle");
	catalog.AddMissedFact("sq701_vivienne_speach", "sq701_race_won");   // the party after the race, not won
	catalog.AddMissedFact("q704_done", "sq701_race_won");               // the tournament failed before it
	// Quest blocks in sq701_tournament (bob)
	catalog.AddEventMissedBlock("ce630d48-887d-4f44-aa28-517dcfbc0643", "Out");   // PhaseBlock "Cleanup", after a lost race
	catalog.AddEventMissedBlock("0d31fd1b-da32-4ff8-8a0d-019963117003", "Out");   // CutControl, the tournament fails (it's had already if won)
	catalog.EndSection();

	catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Horse_3", PotP_A_Items, "PotP_TrackingGroup_HorseGear_Saddlebags");
	catalog.AddItem("_01", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC1 Temerian HorseBag');
	catalog.AddItem("_02", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC5 Nilfgaardian HorseBag');
	catalog.AddItem("_03", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'DLC14 Skellige HorseBag');
	catalog.AddItem("_04", PotP_E_Primary, PotP_I_Horse, PotP_U_Horse, 'Fire Horse Saddlebags');
	catalog.AddItem("_05", PotP_E_Primary_DLC1, PotP_I_Horse, PotP_U_Horse, 'Ofir Horse Bag');
	catalog.AddItem("_06", PotP_E_Primary_DLC2, PotP_I_Horse, PotP_U_Horse, 'Toussaint horsebag');
	catalog.EndSection();
}


//---------------------------------------------------

function PotP_DefineItems_11(catalog: CPotP_Catalog)
{
	if (PotP_UsingCosWiecej())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_DLCC_1", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_CosWiecej");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Armor, 'wiecej', 'wiecej ngp');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Glove, 'wiecej gloves', 'wiecej gloves ngp', 'wiecej gloves 2', 'wiecej gloves 2 ngp');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Pants, 'wiecej pants', 'wiecej pants ngp');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Boots, 'wiecej boots', 'wiecej boots ngp');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'wiecej steel', 'wiecej steel ngp');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Silve, 'wiecej silver', 'wiecej silver ngp');
		catalog.AddItem("_07", PotP_E_ModAdded, PotP_I_Wiecej, PotP_U_Steel, 'rune sihil', 'rune sihil ngp', 'rune sihil 2', 'rune sihil 2 ngp');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_12(catalog: CPotP_Catalog)
{
	if (PotP_UsingW3EE())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_DLCC_5", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_W3EE_Dimeritium");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v3_1', 'kotw_armor_v3_2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v3_1', 'kotw_gloves_v3_2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v3_1', 'kotw_legs_v3_2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v3_1', 'kotw_boots_v3_2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head, 'kotw_helm_v3_1_usable');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_13(catalog: CPotP_Catalog)
{
	if (PotP_UsingW3EE())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_DLCC_3", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_W3EE_Gothic");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v1_1', 'kotw_armor_v1_2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v1_1', 'kotw_gloves_v1_2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v1_1', 'kotw_legs_v1_2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v1_1', 'kotw_boots_v1_2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head, 'kotw_helm_v1_1_usable');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_14(catalog: CPotP_Catalog)
{
	if (PotP_UsingW3EE())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_DLCC_4", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_W3EE_Meteorite");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Armor, 'kotw_armor_v2_1', 'kotw_armor_v2_2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Glove, 'kotw_gloves_v2_1', 'kotw_gloves_v2_2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Pants, 'kotw_legs_v2_1', 'kotw_legs_v2_2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Boots, 'kotw_boots_v2_1', 'kotw_boots_v2_2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_W3eer, PotP_U_Head, 'kotw_helm_v2_1_usable');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_15(catalog: CPotP_Catalog)
{
	if (PotP_UsingSezonBurz())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_DLCC_2", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_SezonBurz");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Armor, 'Sezon Burz Armor', 'Sezon Burz Armor NGP');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Pants, 'Sezon Burz Pants', 'Sezon Burz Pants NGP');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Glove, 'Sezon Burz Gloves', 'Sezon Burz Gloves NGP', 'Sezon Burz Fingerless Gloves', 'Sezon Burz Fingerless Gloves NGP');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Boots, 'Sezon Burz Boots', 'Sezon Burz Boots NGP');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Silve, 'Sezon Burz Silver Sword', 'Sezon Burz Silver Sword NGP');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Steel, 'Sezon Burz Steel Sword', 'Sezon Burz Steel Sword NGP');
		catalog.AddItem("_07", PotP_E_ModAdded, PotP_I_Sezon, PotP_U_Cross, 'Sezon Burz Crossbow 1', 'Sezon Burz Crossbow 2', 'Sezon Burz Crossbow 3');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_16(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_01", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Berserker");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Berserker Armor', 'Shades Berserker Armor 1', 'Shades Berserker Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Berserker Boots', 'Shades Berserker Boots 1', 'Shades Berserker Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Berserker Gloves', 'Shades Berserker Gloves 1', 'Shades Berserker Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Berserker Pants', 'Shades Berserker Pants 1', 'Shades Berserker Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Berserker Cage');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Berserker Helm');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_17(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_02", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Bismarck");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Bismarck Armor', 'Shades Bismarck Armor 1', 'Shades Bismarck Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Bismarck Boots', 'Shades Bismarck Boots 1', 'Shades Bismarck Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Bismarck Gloves', 'Shades Bismarck Gloves 1', 'Shades Bismarck Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Bismarck Pants', 'Shades Bismarck Pants 1', 'Shades Bismarck Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Bismarck Helm');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_18(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_03", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_BloodHunter");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Hunter Armor', 'Shades Hunter Armor 1', 'Shades Hunter Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Hunter Boots', 'Shades Hunter Boots 1', 'Shades Hunter Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Hunter Gloves', 'Shades Hunter Gloves 1', 'Shades Hunter Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Hunter Pants', 'Shades Hunter Pants 1', 'Shades Hunter Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Hunter Hat');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Hunter Mask');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_19(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_04", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Crow");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Crow Armor', 'Shades Crow Armor 1', 'Shades Crow Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Crow Boots', 'Shades Crow Boots 1', 'Shades Crow Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Crow Gloves', 'Shades Crow Gloves 1', 'Shades Crow Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Crow Pants', 'Shades Crow Pants 1', 'Shades Crow Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Crow Mask');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_20(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_05", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_FallenKnight");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Fallen Armor', 'Shades Fallen Armor 1', 'Shades Fallen Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Fallen Boots', 'Shades Fallen Boots 1', 'Shades Fallen Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Fallen Gloves', 'Shades Fallen Gloves 1', 'Shades Fallen Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Fallen Pants', 'Shades Fallen Pants 1', 'Shades Fallen Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Fallen Helm');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_21(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_06", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Faraam");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Faraam Armor', 'Shades Faraam Armor 1', 'Shades Faraam Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Faraam Boots', 'Shades Faraam Boots 1', 'Shades Faraam Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Faraam Gloves', 'Shades Faraam Gloves 1', 'Shades Faraam Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Faraam Pants', 'Shades Faraam Pants 1', 'Shades Faraam Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Faraam Helm');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_22(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_07", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_HeadTaker");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Headtaker Armor', 'Shades Headtaker Armor 1', 'Shades Headtaker Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Headtaker Boots', 'Shades Headtaker Boots 1', 'Shades Headtaker Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Headtaker Gloves', 'Shades Headtaker Gloves 1', 'Shades Headtaker Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Headtaker Pants', 'Shades Headtaker Pants 1', 'Shades Headtaker Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Headtaker Mask');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_23(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_08", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Hitokiri");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Viper Armor', 'Shades Viper Armor 1', 'Shades Viper Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Viper Boots', 'Shades Viper Boots 1', 'Shades Viper Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Viper Gloves', 'Shades Viper Gloves 1', 'Shades Viper Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Viper Pants', 'Shades Viper Pants 1', 'Shades Viper Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Hitokiri Mask');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_24(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_09", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Kara");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Kara Armor', 'Shades Kara Armor 1', 'Shades Kara Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Kara Boots', 'Shades Kara Boots 1', 'Shades Kara Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Kara Gloves', 'Shades Kara Gloves 1', 'Shades Kara Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Kara Pants', 'Shades Kara Pants 1', 'Shades Kara Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Kara Hat');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_25(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_10", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_LionHunter");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Lionhunter Armor', 'Shades Lionhunter Armor 1', 'Shades Lionhunter Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Lionhunter Boots', 'Shades Lionhunter Boots 1', 'Shades Lionhunter Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Lionhunter Gloves', 'Shades Lionhunter Gloves 1', 'Shades Lionhunter Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Lionhunter Pants', 'Shades Lionhunter Pants 1', 'Shades Lionhunter Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Lionhunter Hat');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_26(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_11", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Assassin");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Ezio Armor', 'Shades Ezio Armor 1', 'Shades Ezio Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Ezio Boots', 'Shades Ezio Boots 1', 'Shades Ezio Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Ezio Gloves', 'Shades Ezio Gloves 1', 'Shades Ezio Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Ezio Pants', 'Shades Ezio Pants 1', 'Shades Ezio Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Ezio Hood');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_27(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_12", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_OldHunter");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Oldhunter Armor', 'Shades Oldhunter Armor 1', 'Shades Oldhunter Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Oldhunter Boots', 'Shades Oldhunter Boots 1', 'Shades Oldhunter Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Oldhunter Gloves', 'Shades Oldhunter Gloves 1', 'Shades Oldhunter Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Oldhunter Pants', 'Shades Oldhunter Pants 1', 'Shades Oldhunter Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Oldhunter Cap');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_28(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_13", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Revenant");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Revenant Armor', 'Shades Revenant Armor 1', 'Shades Revenant Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Revenant Boots', 'Shades Revenant Boots 1', 'Shades Revenant Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Revenant Gloves', 'Shades Revenant Gloves 1', 'Shades Revenant Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Revenant Pants', 'Shades Revenant Pants 1', 'Shades Revenant Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Revenant Hood');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_29(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_14", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Stalker");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Undertaker Armor', 'Shades Undertaker Armor 1', 'Shades Undertaker Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Undertaker Boots', 'Shades Undertaker Boots 1', 'Shades Undertaker Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Undertaker Gloves', 'Shades Undertaker Gloves 1', 'Shades Undertaker Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Undertaker Pants', 'Shades Undertaker Pants 1', 'Shades Undertaker Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Undertaker Mask');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_30(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_15", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Taifeng");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Taifeng Armor', 'Shades Taifeng Armor 1', 'Shades Taifeng Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Taifeng Boots', 'Shades Taifeng Boots 1', 'Shades Taifeng Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Taifeng Gloves', 'Shades Taifeng Gloves 1', 'Shades Taifeng Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Taifeng Pants', 'Shades Taifeng Pants 1', 'Shades Taifeng Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Ronin Hat');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_31(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_16", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Unseen");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Yahargul Armor', 'Shades Yahargul Armor 1', 'Shades Yahargul Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Boots, 'Shades Yahargul Boots', 'Shades Yahargul Boots 1', 'Shades Yahargul Boots 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Glove, 'Shades Yahargul Gloves', 'Shades Yahargul Gloves 1', 'Shades Yahargul Gloves 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Pants, 'Shades Yahargul Pants', 'Shades Yahargul Pants 1', 'Shades Yahargul Pants 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Yahargul Helm');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_32(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_17", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_Sithis");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Armor, 'Shades Sithis Armor', 'Shades Sithis Armor 1', 'Shades Sithis Armor 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Head, 'Shades Sithis Hood');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_33(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_18", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SilverSwords");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Eagle Sword', 'Shades Silver Eagle Sword 1', 'Shades Silver Eagle Sword 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ares', 'Shades Silver Ares 1', 'Shades Silver Ares 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Doomblade', 'Shades Silver Doomblade 1', 'Shades Silver Doomblade 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Beastcutter', 'Shades Silver Beastcutter 1', 'Shades Silver Beastcutter 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blackdawn', 'Shades Silver Blackdawn 1', 'Shades Silver Blackdawn 2');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Blooddusk', 'Shades Silver Blooddusk 1', 'Shades Silver Blooddusk 2');
		catalog.AddItem("_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodletter', 'Shades Silver Bloodletter 1', 'Shades Silver Bloodletter 2');
		catalog.AddItem("_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Bloodshot', 'Shades Silver Bloodshot 1', 'Shades Silver Bloodshot 2');
		catalog.AddItem("_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Claymore', 'Shades Silver Claymore 1', 'Shades Silver Claymore 2');
		catalog.AddItem("_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kingslayer', 'Shades Silver Kingslayer 1', 'Shades Silver Kingslayer 2');
		catalog.AddItem("_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Cursed Khopesh', 'Shades Silver Cursed Khopesh 1', 'Shades Silver Cursed Khopesh 2');
		catalog.AddItem("_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Dragonbane', 'Shades Silver Dragonbane 1', 'Shades Silver Dragonbane 2');
		catalog.AddItem("_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ejderblade', 'Shades Silver Ejderblade 1', 'Shades Silver Ejderblade 2');
		catalog.AddItem("_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Flameborn', 'Shades Silver Flameborn 1', 'Shades Silver Flameborn 2');
		catalog.AddItem("_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Frostmourne', 'Shades Silver Frostmourne 1', 'Shades Silver Frostmourne 2');
		catalog.AddItem("_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Gorgonslayer', 'Shades Silver Gorgonslayer 1', 'Shades Silver Gorgonslayer 2');
		catalog.AddItem("_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Graveripper', 'Shades Silver Graveripper 1', 'Shades Silver Graveripper 2');
		catalog.AddItem("_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Guandao', 'Shades Silver Guandao 1', 'Shades Silver Guandao 2');
		catalog.AddItem("_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Crownbreaker', 'Shades Silver Crownbreaker 1', 'Shades Silver Crownbreaker 2');
		catalog.AddItem("_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hades Grasp', 'Shades Silver Hades Grasp 1', 'Shades Silver Hades Grasp 2');
		catalog.AddItem("_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Haoma', 'Shades Silver Haoma 1', 'Shades Silver Haoma 2');
		catalog.AddItem("_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Heavenspire', 'Shades Silver Heavenspire 1', 'Shades Silver Heavenspire 2');
		catalog.AddItem("_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hellspire', 'Shades Silver Hellspire 1', 'Shades Silver Hellspire 2');
		catalog.AddItem("_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Icarus Tears', 'Shades Silver Icarus Tears 1', 'Shades Silver Icarus Tears 2');
		catalog.AddItem("_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Ryu Katana', 'Shades Silver Ryu Katana 1', 'Shades Silver Ryu Katana 2');
		catalog.AddItem("_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Lion Sword', 'Shades Silver Lion Sword 1', 'Shades Silver Lion Sword 2');
		catalog.AddItem("_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oathblade', 'Shades Silver Oathblade 1', 'Shades Silver Oathblade 2');
		catalog.AddItem("_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Oblivion', 'Shades Silver Oblivion 1', 'Shades Silver Oblivion 2');
		catalog.AddItem("_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Hitokiri Katana', 'Shades Silver Hitokiri Katana 1', 'Shades Silver Hitokiri Katana 2');
		catalog.AddItem("_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Pridefall', 'Shades Silver Pridefall 1', 'Shades Silver Pridefall 2');
		catalog.AddItem("_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Rakuyo', 'Shades Silver Rakuyo 1', 'Shades Silver Rakuyo 2');
		catalog.AddItem("_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Blade', 'Shades Silver Realmdrifter Blade 1', 'Shades Silver Realmdrifter Blade 2');
		catalog.AddItem("_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Realmdrifter Divider', 'Shades Silver Realmdrifter Divider 1', 'Shades Silver Realmdrifter Divider 2');
		catalog.AddItem("_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Kukri', 'Shades Silver Kukri 1', 'Shades Silver Kukri 2');
		catalog.AddItem("_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sinner', 'Shades Silver Sinner 1', 'Shades Silver Sinner 2');
		catalog.AddItem("_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Sithis Blade', 'Shades Silver Sithis Blade 1', 'Shades Silver Sithis Blade 2');
		catalog.AddItem("_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Voidblade', 'Shades Silver Voidblade 1', 'Shades Silver Voidblade 2');
		catalog.AddItem("_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Vulcan', 'Shades Silver Vulcan 1', 'Shades Silver Vulcan 2');
		catalog.AddItem("_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Silve, 'Shades Silver Knife', 'Shades Silver Knife 1', 'Shades Silver Knife 2');
		catalog.EndSection();
	}
}

//---------------------------------------------------

function PotP_DefineItems_34(catalog: CPotP_Catalog)
{
	if (PotP_UsingShadesOfIron())
	{
		catalog.BeginSection(PotP_Book_Items, "PotP_Preview_Shad_19", PotP_A_Items, "PotP_TrackingGroup_AdditionalItemContent_ShadesOfIron_SteelSwords");
		catalog.AddItem("_01", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Eagle Sword', 'Shades Steel Eagle Sword 1', 'Shades Steel Eagle Sword 2');
		catalog.AddItem("_02", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ares', 'Shades Steel Ares 1', 'Shades Steel Ares 2');
		catalog.AddItem("_03", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Doomblade', 'Shades Steel Doomblade 1', 'Shades Steel Doomblade 2');
		catalog.AddItem("_04", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Beastcutter', 'Shades Steel Beastcutter 1', 'Shades Steel Beastcutter 2');
		catalog.AddItem("_05", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blackdawn', 'Shades Steel Blackdawn 1', 'Shades Steel Blackdawn 2');
		catalog.AddItem("_06", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Blooddusk', 'Shades Steel Blooddusk 1', 'Shades Steel Blooddusk 2');
		catalog.AddItem("_07", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodletter', 'Shades Steel Bloodletter 1', 'Shades Steel Bloodletter 2');
		catalog.AddItem("_08", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Bloodshot', 'Shades Steel Bloodshot 1', 'Shades Steel Bloodshot 2');
		catalog.AddItem("_09", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Claymore', 'Shades Steel Claymore 1', 'Shades Steel Claymore 2');
		catalog.AddItem("_10", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kingslayer', 'Shades Steel Kingslayer 1', 'Shades Steel Kingslayer 2');
		catalog.AddItem("_11", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Cursed Khopesh', 'Shades Steel Cursed Khopesh 1', 'Shades Steel Cursed Khopesh 2');
		catalog.AddItem("_12", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Dragonbane', 'Shades Steel Dragonbane 1', 'Shades Steel Dragonbane 2');
		catalog.AddItem("_13", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ejderblade', 'Shades Steel Ejderblade 1', 'Shades Steel Ejderblade 2');
		catalog.AddItem("_14", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Flameborn', 'Shades Steel Flameborn 1', 'Shades Steel Flameborn 2');
		catalog.AddItem("_15", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Frostmourne', 'Shades Steel Frostmourne 1', 'Shades Steel Frostmourne 2');
		catalog.AddItem("_16", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Gorgonslayer', 'Shades Steel Gorgonslayer 1', 'Shades Steel Gorgonslayer 2');
		catalog.AddItem("_17", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Graveripper', 'Shades Steel Graveripper 1', 'Shades Steel Graveripper 2');
		catalog.AddItem("_18", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Guandao', 'Shades Steel Guandao 1', 'Shades Steel Guandao 2');
		catalog.AddItem("_19", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Crownbreaker', 'Shades Steel Crownbreaker 1', 'Shades Steel Crownbreaker 2');
		catalog.AddItem("_20", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hades Grasp', 'Shades Steel Hades Grasp 1', 'Shades Steel Hades Grasp 2');
		catalog.AddItem("_21", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Haoma', 'Shades Steel Haoma 1', 'Shades Steel Haoma 2');
		catalog.AddItem("_22", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Heavenspire', 'Shades Steel Heavenspire 1', 'Shades Steel Heavenspire 2');
		catalog.AddItem("_23", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hellspire', 'Shades Steel Hellspire 1', 'Shades Steel Hellspire 2');
		catalog.AddItem("_24", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Icarus Tears', 'Shades Steel Icarus Tears 1', 'Shades Steel Icarus Tears 2');
		catalog.AddItem("_25", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Ryu Katana', 'Shades Steel Ryu Katana 1', 'Shades Steel Ryu Katana 2');
		catalog.AddItem("_26", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Lion Sword', 'Shades Steel Lion Sword 1', 'Shades Steel Lion Sword 2');
		catalog.AddItem("_27", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oathblade', 'Shades Steel Oathblade 1', 'Shades Steel Oathblade 2');
		catalog.AddItem("_28", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Oblivion', 'Shades Steel Oblivion 1', 'Shades Steel Oblivion 2');
		catalog.AddItem("_29", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Hitokiri Katana', 'Shades Steel Hitokiri Katana 1', 'Shades Steel Hitokiri Katana 2');
		catalog.AddItem("_30", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Pridefall', 'Shades Steel Pridefall 1', 'Shades Steel Pridefall 2');
		catalog.AddItem("_31", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Rakuyo', 'Shades Steel Rakuyo 1', 'Shades Steel Rakuyo 2');
		catalog.AddItem("_32", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Blade', 'Shades Steel Realmdrifter Blade 1', 'Shades Steel Realmdrifter Blade 2');
		catalog.AddItem("_33", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Realmdrifter Divider', 'Shades Steel Realmdrifter Divider 1', 'Shades Steel Realmdrifter Divider 2');
		catalog.AddItem("_34", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Kukri', 'Shades Steel Kukri 1', 'Shades Steel Kukri 2');
		catalog.AddItem("_35", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sinner', 'Shades Steel Sinner 1', 'Shades Steel Sinner 2');
		catalog.AddItem("_36", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Sithis Blade', 'Shades Steel Sithis Blade 1', 'Shades Steel Sithis Blade 2');
		catalog.AddItem("_37", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Voidblade', 'Shades Steel Voidblade 1', 'Shades Steel Voidblade 2');
		catalog.AddItem("_38", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Vulcan', 'Shades Steel Vulcan 1', 'Shades Steel Vulcan 2');
		catalog.AddItem("_39", PotP_E_ModAdded, PotP_I_Shade, PotP_U_Steel, 'Shades Steel Knife', 'Shades Steel Knife 1', 'Shades Steel Knife 2');
		catalog.EndSection();
	}
}
