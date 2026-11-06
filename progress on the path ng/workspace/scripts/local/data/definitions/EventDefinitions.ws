//---------------------------------------------------
//-- Event Definitions ------------------------------
//---------------------------------------------------

function PotP_DefineEvents(catalog: CPotP_Catalog)
{
	PotP_DefineEvents_01(catalog);
	PotP_DefineEvents_02(catalog);
	PotP_DefineEvents_03(catalog);
	PotP_DefineEvents_04(catalog);
}

//---------------------------------------------------

function PotP_DefineEvents_01(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_Event_1", PotP_A_Event, "PotP_TrackingGroup_RandomEvents_Velen");
	//-- At the Mercy of Strangers -------------------------
	catalog.AddEvent("_01", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_1_NG", Vector(641.454102, 533.142456));
	catalog.AddEventFacts("mq1036_deserter_helped", "mq1036_deserter_ignored", "mq1036_quest_done");
	// Quest blocks in mq1036_at_the_mercy_of_strangers
	catalog.AddEventDoneBlock("4b435b43-30c2-40d8-9eae-08df8d1b7df9", "Help");   // InteractionDialog
	catalog.AddEventDoneBlock("4f6a4f44-3e1a-40f4-bd24-ebb2b16f1232", "None");   // PauseCondition "Outside mq1036_encounter_01_big_tr"

	//-- Caravan Attack ------------------------------------
	catalog.AddEvent("_02", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_CaravanAttack_NG_1", Vector(1311.539551, 404.800537));
	catalog.AddEventFacts("mq1011_everyone_dead", "mq1011_merchants_helped", "mq1011_merchants_ignored", "mq1011_quest_done");
	// Quest blocks in mq1011_caravan_attack
	catalog.AddEventDoneBlock("d57df9c6-3484-4d7e-a9de-41fa2c893afd", "True");    // Condition "At least one merchant alive"
	catalog.AddEventDoneBlock("d57df9c6-3484-4d7e-a9de-41fa2c893afd", "False");   // Condition "At least one merchant alive"
	catalog.AddEventDoneBlock("1eede45f-daf7-4882-80c4-19cfd17a0c57", "None");    // PauseCondition "Outside mq1011_big_tr"

	//-- The Grateful Merchant -----------------------------
	catalog.AddEvent("_14", PotP_E_Primary, PotP_R_VE, false, "no_mans_land", "PotP_Event_CaravanAttack_NG_2", Vector(207.837814, 75.866135));
	catalog.AddEventFacts("mq1011_everyone_dead", "mq1011_merchants_ignored", "mq1011_anselm_met", "mq1011_quest_done");
	// Quest blocks in mq1011_caravan_attack
	catalog.AddEventDoneBlock("c9f30df5-f8b5-4342-b870-f32e0c77d0c0", "Loop");                                             // InteractionDialog
	catalog.AddEventUnlockBlock("a06bba23-5b85-4a87-8730-44928b1128f8", "Out", "ProgressOnThePath_Location_CrowsPerch");   // StoryPhaseSetter // Spawn merchant in the village
	catalog.AddEventDoneBlock("d57df9c6-3484-4d7e-a9de-41fa2c893afd", "True");                                             // Condition "At least one merchant alive"
	catalog.AddEventDoneBlock("1eede45f-daf7-4882-80c4-19cfd17a0c57", "None");                                             // PauseCondition "Outside mq1011_big_tr"

	//-- The Troll Bridge Crossing -------------------------
	catalog.AddEvent("_03", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_DeadlyCrossing_3_NG", Vector(-29.826519, -101.255219));
	catalog.AddEventFacts("mq1037_3_bandits_killed", "mq1037_lower_bridge", "mq1037_3_bandits_axii", "mq1037_3_bandits_pay", "mq1037_3_quest_done");
	// Quest blocks in mq1037_deadly_crossing
	catalog.AddEventDoneBlock("8e9b189d-5855-4c9c-849e-bd92228c62d9", "pay");   // Scene
	catalog.AddEventDoneBlock("41262a5b-5c56-4ab4-bd1f-c9c7fe20516c", "Out");   // Script "Script [SetCreaturesGroupState]"

	//-- The Crossing of Lindenvale ------------------------
	catalog.AddEvent("_04", PotP_E_Primary, PotP_R_VE, false, "no_mans_land", "PotP_Event_DeadlyCrossing_1_NG", Vector(794.722107, 266.272644));
	catalog.AddEventFacts("mq1037_1_bought_sword", "mq1037_1_ignored", "mq1037_1_no_deal", "mq1037_1_no_deal_and_killed", "mq1037_1_scavengers_killed", "mq1037_1_quest_done");
	// Quest blocks in mq1037_deadly_crossing
	catalog.AddEventDoneBlock("fe28418c-a02f-4257-adcf-a989a547f042", "buy");                                          // InteractionDialog
	catalog.AddEventDoneBlock("fe28418c-a02f-4257-adcf-a989a547f042", "don't buy");                                    // InteractionDialog
	catalog.AddEventUnlockBlock("c1e69731-bb8c-4650-9e39-8ef37ae40d5a", "None", "ProgressOnThePath_Location_Velen");   // PauseCondition "Wait for 2 days"
	catalog.AddEventDoneBlock("9ed3d89e-b2e1-4954-836d-b8178bfa33f0", "Out");                                          // LayersHider

	//-- A Most Deadly Crossing ----------------------------
	catalog.AddEvent("_05", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_DeadlyCrossing_2_NG", Vector(1087.826294, -295.390381));
	catalog.AddEventFacts("mq1037_2_bandits_ignored", "mq1037_2_bandits_killed", "mq1037_2_quest_done");
	// Quest blocks in mq1037_deadly_crossing
	catalog.AddEventDoneBlock("eab1e223-94a8-4bdb-bb98-153910f7ed6d", "Out");   // Script "Script [SetCreaturesGroupState]"

	//-- Face Me if You Dare! ------------------------------
	catalog.AddEvent("_06", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_FaceMeIfYouDare_1_NG", Vector(213.855240, -32.358776));
	catalog.AddEventFacts("mq1033_1st_encounter_done", "mq1033_quest_done");
	// Quest blocks in mq1033_face_me_if_you_dare
	catalog.AddEventDoneBlock("19bca412-af37-4fbd-b740-e810734a7093", "Out");   // Reward "Reward [mq1033_1_encounter_1]"

	//-- Harassing a Troll ---------------------------------
	catalog.AddEvent("_07", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_HarassingATroll_NG", Vector(138.532272, 811.463623));
	catalog.AddEventFacts("mq1006_helped", "mq1006_completed", "mq1006_quest_done");
	// Quest blocks in mq1006_harassing_the_troll
	catalog.AddEventDoneBlock("d4ab8e63-90e3-46a3-8ab5-850382da293a", "Out");   // Reward "Reward [mq1006_1_elf_stew]"
	catalog.AddEventDoneBlock("6c445bd9-9f00-49a9-8afd-79a8df027711", "Out");   // Reward "Reward [mq1006_1_cheap_item]"
	catalog.AddEventDoneBlock("687825eb-19d9-4759-831e-088ac39bb5fe", "Out");   // Reward "Reward [mq1006_1_medium_item]"

	//-- Highway Robbery -----------------------------------
	catalog.AddEvent("_08", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_HighwayRobbery_NG", Vector(300.595459, -135.326324));
	catalog.AddEventFacts("mq1044_bandits_killed", "mq1044_quest_done");
	// Quest blocks in mq1044_highway_robbery
	catalog.AddEventDoneBlock("446c30e5-5055-4ded-a3b6-7c55c0eb14d7", "Out");   // And

	//-- Highwayman's Cache --------------------------------
	catalog.AddEvent("_09", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_HighwaymansCache_NG", Vector(519.180176, -212.923065));
	catalog.AddEventFacts("mq1043_bandits_killed", "mq1043_completed", "mq1043_peaceful", "mq1043_quest_done");
	// Quest blocks in mq1043_highway_mens_cache
	catalog.AddEventDoneBlock("5271c7e9-60a1-46c6-abe5-19c72da33730", "peace");   // Scene
	catalog.AddEventDoneBlock("e7e2d7d4-f58e-45c0-a7b4-bf2119d2afe7", "None");    // PauseCondition

	//-- Heatherton Looters --------------------------------
	catalog.AddEvent("_10", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_LootersHeatherton_NG", Vector(151.509430, 508.062775));
	catalog.AddEventFacts("mq1014_looters_1_ignored", "mq1014_looters_1_killed", "mq1014_1_quest_done");
	// Quest blocks in mq1014_looters
	catalog.AddEventDoneBlock("14ef9fe4-0dd2-471a-ac1d-be735e98e4fe", "Out");        // Reward "Reward [mq1014_enc01_finished]"
	catalog.AddEventDoneBlock("ebe3e8ca-b3df-4842-9986-926ec78226eb", "Out");        // LayersHider // Hide encounter
	catalog.AddEventDoneBlock("1ecb9b14-1416-4f5d-9872-13f879bba316", "Out_Calm");   // Phase "Looters - Angry"

	//-- Codgers' Quarry Looters ---------------------------
	catalog.AddEvent("_11", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_LootersCodgersQuarry_NG", Vector(1221.132690, 831.181274));
	catalog.AddEventFacts("mq1014_looters_3_ghouls_killed", "mq1014_looters_3_ignored", "mq1014_looters_3_killed", "mq1014_3_quest_done");
	// Quest blocks in mq1014_looters
	catalog.AddEventDoneBlock("8246168d-3999-4e13-b4e8-b1c7cd588642", "None");   // PauseCondition "mq1014_ghoul killed x4"
	catalog.AddEventDoneBlock("1c9be2c8-2de7-4f1d-925b-c7925b5ab841", "Out");    // StoryPhaseSetter "BIA" // BIA - Despawn looters, spawn monsters
	catalog.AddEventDoneBlock("255781ec-5366-48e1-b74c-48268e2ee304", "Out");    // LayersHider "Hide encounter layers"
	catalog.AddEventDoneBlock("49a30edc-f8c6-4631-8755-02cc34d2561a", "Out");    // Phase "Fight"

	//-- Toderas Looters -----------------------------------
	catalog.AddEvent("_12", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_LootersToderas_NG", Vector(1720.736694, 67.942719));
	catalog.AddEventFacts("mq1014_enc_02_geralt_killed_bandits", "mq1014_looters_2_ignored", "mq1014_looters_2_killed", "mq1014_2_quest_done");
	// Quest blocks in mq1014_looters
	catalog.AddEventDoneBlock("f26d543a-bb40-4027-b117-7193caa1e89e", "None");   // PauseCondition "1s"
	catalog.AddEventDoneBlock("24127b5f-eba8-4a28-b803-31a4d01aedad", "Out");    // Reward "Reward [mq1014_enc02_finished]"

	//-- Man's Best Friend ---------------------------------
	catalog.AddEvent("_13", PotP_E_Primary, PotP_R_VE, true, "no_mans_land", "PotP_Event_MansBestFriend_NG", Vector(643.049805, 799.665344));
	catalog.AddEventFacts("mq1038_give_item", "mq1038_ignored", "mq1038_no_item", "mq1038_quest_done");
	// Quest blocks in mq1038_mens_best_friend
	catalog.AddEventDoneBlock("be22f386-b385-4611-9c8a-71fe532688ed", "NoItem");     // Scene "Children gameplay"
	catalog.AddEventDoneBlock("be22f386-b385-4611-9c8a-71fe532688ed", "GiveItem");   // Scene "Children gameplay"
	catalog.AddEventDoneBlock("a397982b-7a74-44dc-b763-7ad97156f1fb", "Out");        // Script "Script [EnableDynamicMappin]"
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineEvents_02(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_Event_2", PotP_A_Event, "PotP_TrackingGroup_RandomEvents_Novigrad");
	//-- A Warm Welcome ------------------------------------
	catalog.AddEvent("_01", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_AWarmWelcome_NG", Vector(1347.046143, 1591.817261));
	catalog.AddEventFacts("mq1026_guards_killed", "mq1026_refugees_axii", "mq1026_refugees_ignored", "mq1026_refugees_pay", "mq1026_quest_done");
	// Quest blocks in mq1026_warm_welcome
	catalog.AddEventDoneBlock("7579ad82-1b51-41e0-97db-da1c7aa26fd3", "Out");                 // Reward "Reward [mq1024_1_encounter_finished]"
	catalog.AddEventDoneBlock("6c6c84a2-4a55-467b-a0ab-8a4c9557fad5", "Not_Liberate");        // Scene
	catalog.AddEventDoneBlock("6c6c84a2-4a55-467b-a0ab-8a4c9557fad5", "Bribe_Liberate");      // Scene
	catalog.AddEventDoneBlock("6c6c84a2-4a55-467b-a0ab-8a4c9557fad5", "Convince_Liberate");   // Scene

	//-- At the Mercy of Strangers -------------------------
	catalog.AddEvent("_02", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_AtTheMercyOfStrangers_2_NG", Vector(393.423737, 1265.788696));
	catalog.AddEventFacts("mq1036_deserter_killed", "mq1036_deserter_reward", "mq1036_quest_done");
	// Quest blocks in mq1036_at_the_mercy_of_strangers
	catalog.AddEventDoneBlock("3dc10e27-dec1-4e47-87b0-8ab808dfb1ed", "Out");                                         // Reward "Reward [mq1036_bandits_killed]"
	catalog.AddEventDoneBlock("4161d330-fa3b-46b6-9c32-7f9c3e29975a", "Out");                                         // Reward "Reward [mq1036_bandits_reward]"
	catalog.AddEventUnlockBlock("dd32f383-41da-4563-a763-049fe82478a3", "Out", "ProgressOnThePath_Location_Velen");   // LayersHider // Show camp

	//-- Drunken Rabble ------------------------------------
	catalog.AddEvent("_03", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_DrunkenRabble_NG", Vector(543.444885, 1839.808228));
	catalog.AddEventFacts("mq1007_drunks_axii", "mq1007_drunks_pay", "mq1007_fistfight_lost", "mq1007_fistfight_omitted", "mq1007_fistfight_won", "mq1007_quest_done");
	// Quest blocks in mq1007_drunken_rabble
	catalog.AddEventDoneBlock("aafa8a8e-c7b9-4e77-b8b1-4d311dad8f56", "None");      // PauseCondition "Player left outter encounter area"
	catalog.AddEventDoneBlock("1892ffab-a4ba-4c51-887f-db4e082811a9", "Success");   // GraphMinigame // fist fight
	catalog.AddEventDoneBlock("1892ffab-a4ba-4c51-887f-db4e082811a9", "Failure");   // GraphMinigame // fist fight
	catalog.AddEventDoneBlock("a4ee6146-6665-41d1-a336-0754f1e8abcc", "Out");       // Checkpoint
	catalog.AddEventDoneBlock("59267aaf-e087-4d63-b8ce-03023710c2a1", "Out");       // Checkpoint

	//-- The Defender of Maid Bilberry ---------------------
	catalog.AddEvent("_04", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_2_NG", Vector(899.003479, 1732.530640));
	catalog.AddEventFacts("mq1033_2nd_encounter_done", "mq1033_quest_done");
	// Quest blocks in mq1033_face_me_if_you_dare
	catalog.AddEventDoneBlock("a14d9231-8ca2-4e11-9c6a-53e5e8398bfa", "Out");                                            // Reward "Reward [mq1033_2_encounter_2]"
	catalog.AddEventUnlockBlock("cdebd867-071b-43a9-bfb3-b53b53128cd3", "Out", "ProgressOnThePath_Location_Novigrad");   // StoryPhaseSetter // Spawn swordsman at second location

	//-- Unlearned Lessons ---------------------------------
	catalog.AddEvent("_05", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_FaceMeIfYouDare_3_NG", Vector(505.266266, 1915.563843));
	catalog.AddEventFacts("mq1033_ronvid_axii", "mq1033_ronvid_killed", "mq1033_quest_done");
	// Quest blocks in mq1033_face_me_if_you_dare
	catalog.AddEventDoneBlock("47b8c464-d573-4ef5-8ac3-68d7b110d0b7", "Out");                                            // And
	catalog.AddEventDoneBlock("ab8ee051-5fee-4dc6-871d-bb2b4dbb57ad", "Out");                                            // StoryPhaseSetter
	catalog.AddEventUnlockBlock("27c2c0e8-3328-4307-b9df-988fab348ab9", "Out", "ProgressOnThePath_Location_Novigrad");   // StoryPhaseSetter // Spawn swordsman at third location

	//-- Karmic Justice ------------------------------------
	catalog.AddEvent("_06", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_KarmicJustice_NG", Vector(862.002502, 1831.773438), 21, 4); //Night only, 21:00 - 04:00
	catalog.AddEventFacts("mq1035_elves_killed_merchant_alive", "mq1035_elves_killed_merchant_dead", "mq1035_merchant_ignored", "mq1035_quest_done");
	// Quest blocks in mq1035_karmic_justice
	catalog.AddEventDoneBlock("7e521823-a1bf-4416-a7ac-2b00802baf4c", "None");    // PauseCondition "mq1035_merchant"
	catalog.AddEventDoneBlock("ecf91264-73d6-4a22-8aa4-b08a01935ea4", "Out");     // [ChangeNPCStateQuest]" ChangeNPCStateQuest(npcTag=mq1035_merchant, npc
	catalog.AddEventDoneBlock("18627fd7-b234-467a-a2e8-68f885622724", "True");    // Condition "actor_mq1035_merchant_was_killed == 0"
	catalog.AddEventDoneBlock("18627fd7-b234-467a-a2e8-68f885622724", "False");   // Condition "actor_mq1035_merchant_was_killed == 0"

	//-- Never Trust Children ------------------------------
	catalog.AddEvent("_07", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_NeverTrustChildren_NG", Vector(765.527771, 1932.638062));
	catalog.AddEventFacts("mq3001_bandits_killed", "mq3001_ignored", "mq3001_quest_done");
	// Quest blocks in mq3001_never_trust_a_child
	catalog.AddEventDoneBlock("63c481df-0195-440e-9b21-9b03598357a4", "Out");   // Script "Script [SetCreaturesGroupState]"
	catalog.AddEventDoneBlock("13c619de-d409-4370-ad05-eefaa31907c0", "Out");   // Phase "Hostile"

	//-- Dye Pit Racists -----------------------------------
	catalog.AddEvent("_08", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_RacistsOfNovigradFC_NG", Vector(858.879944, 1819.517700));
	catalog.AddEventFacts("mq3007_1_elves_ignored", "mq3007_1_racists_killed", "mq3007_1_quest_done");
	// Quest blocks in mq3007_racists_in_favela
	catalog.AddEventUnlockBlock("5966e2bf-43ab-43f7-aaf7-60367cb52b3a", "End", "ProgressOnThePath_Location_Novigrad");      // InteractionDialog
	catalog.AddEventUnlockBlock("5dc47beb-1415-4185-85c6-a2d96be040e5", "Output", "ProgressOnThePath_Location_Novigrad");   // Scene "Omittion aftermath"
	catalog.AddEventDoneBlock("6b44f517-e297-4fc0-9d3e-df8d24610404", "Out");                                               // And
	catalog.AddEventDoneBlock("fa28f827-1fe5-4f89-beb3-65733e51d6eb", "Output_ignore");                                     // Scene
	catalog.AddEventDoneBlock("1e30873a-6c89-4928-b224-dd5f5655a6e9", "Out");                                               // Phase "Despawn"

	//-- The Racists of Novigrad ---------------------------
	catalog.AddEvent("_09", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_RacistsOfNovigradHS_NG", Vector(553.651428, 1677.662231));
	catalog.AddEventFacts("mq3007_2_elf_helped", "mq3007_2_elf_ignored", "mq3007_2_quest_done");
	catalog.AddEventFacts("mq3007_enc_02_done");   // vanilla: set after the event ends, so they work without Brothers In Arms
	// Quest blocks in mq3007_racists_in_favela
	catalog.AddEventDoneBlock("5966e2bf-43ab-43f7-aaf7-60367cb52b3a", "End");      // InteractionDialog
	catalog.AddEventDoneBlock("5dc47beb-1415-4185-85c6-a2d96be040e5", "Output");   // Scene "Omittion aftermath"

	//-- Strangers in the Night ----------------------------
	catalog.AddEvent("_10", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_StrangersInTheNight_NG", Vector(1370.983887, 1507.835815));
	catalog.AddEventFacts("mq1041_fight_all", "mq1041_fight_redanian", "mq1041_fight_soldier", "mq1041_ignored", "mq1041_peaceful_end", "mq1041_walkaway", "mq1041_quest_done");
	// Quest blocks in mq1041_strangers_in_the_night
	catalog.AddEventDoneBlock("cc6f2925-52be-4f8f-a706-edbff3238907", "FightAll");        // InteractionDialog
	catalog.AddEventDoneBlock("cc6f2925-52be-4f8f-a706-edbff3238907", "FightSoldier");    // InteractionDialog
	catalog.AddEventDoneBlock("cc6f2925-52be-4f8f-a706-edbff3238907", "FightRedanian");   // InteractionDialog
	catalog.AddEventDoneBlock("cc6f2925-52be-4f8f-a706-edbff3238907", "PeacefulEnd");     // InteractionDialog
	catalog.AddEventDoneBlock("cc6f2925-52be-4f8f-a706-edbff3238907", "Walkaway");        // InteractionDialog
	catalog.AddEventDoneBlock("f8c09db9-fcc9-45ea-9676-0a51c5d965dd", "None");            // PauseCondition "mq1041_camp_big_tr"

	//-- Strumpet in Distress ------------------------------
	catalog.AddEvent("_11", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_StrumpetInDistress_NG", Vector(411.762390, 1672.084839));
	catalog.AddEventFacts("mq3008_prostitute_angry", "mq3008_prostitute_ignored", "mq3008_prostitute_regular", "mq3008_quest_done");
	// Quest blocks in mq3008_prostitute_in_distress
	catalog.AddEventDoneBlock("f0d56469-3578-4c55-8b83-a55aad4f7c94", "Regular");   // InteractionDialog
	catalog.AddEventDoneBlock("f0d56469-3578-4c55-8b83-a55aad4f7c94", "Angry");     // InteractionDialog
	catalog.AddEventDoneBlock("f0d56469-3578-4c55-8b83-a55aad4f7c94", "Omitted");   // InteractionDialog
	catalog.AddEventDoneBlock("4d59d5dc-afdc-495a-98c1-a8493fa5286d", "None");      // PauseCondition "Not in mq3008_enc_02_big_tr"

	//-- Suspicious Shakedown ------------------------------
	catalog.AddEvent("_12", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_SuspiciousShakedown_NG", Vector(739.579529, 1761.638062));
	catalog.AddEventFacts("mq3004_bandits_axii", "mq3004_bandits_killed", "mq3004_merchant_ignored", "mq3004_merchant_left", "mq3004_quest_done");
	catalog.AddEventFacts("mq3004_block_shop", "mq3004_merchant_saved");   // vanilla: set after the event ends, so they work without Brothers In Arms
	// Quest blocks in mq3004_money_from_merchant
	catalog.AddEventDoneBlock("948bb274-8879-4712-bdb4-50ecd699b3c4", "Out");                                            // And
	catalog.AddEventDoneBlock("d891d355-9e2f-498a-84f1-9ce21e6870e1", "Out");                                            // [EnableShopkeeper]" EnableShopkeeper(tag=novigrad_citizen_district_sho
	catalog.AddEventDoneBlock("cc233d88-e773-4499-a029-9e5a75c027f4", "None");                                           // PauseCondition "Wait 1 sec"
	catalog.AddEventDoneBlock("5dd50aa4-b311-4f36-849b-f733bde15376", "BlockShop");                                      // InteractionDialog
	catalog.AddEventDoneBlock("5dd50aa4-b311-4f36-849b-f733bde15376", "Axii");                                           // InteractionDialog
	catalog.AddEventUnlockBlock("07cc1d4f-a1b1-40c9-accb-86f79ec06f7c", "Out", "ProgressOnThePath_Location_Novigrad");   // LayersHider // Show quest layers

	//-- The Flame of Hatred -------------------------------
	catalog.AddEvent("_13", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_TheFlameOfHatred_NG_1", Vector(714.057678, 1861.176392));
	catalog.AddEventFacts("mq3023_crowd_anger", "mq3023_priest_defend", "mq3023_priest_ignore", "mq3023_priest_threaten", "mq3023_quest_done");
	// Quest blocks in mq3023_flame_of_hatred
	catalog.AddEventDoneBlock("9d69f066-d211-403d-bc6a-8ffb3cc4447b", "Output Ignore");     // InteractionDialog // Geralts interaction with preacher
	catalog.AddEventDoneBlock("9d69f066-d211-403d-bc6a-8ffb3cc4447b", "Output Threaten");   // InteractionDialog // Geralts interaction with preacher
	catalog.AddEventDoneBlock("9d69f066-d211-403d-bc6a-8ffb3cc4447b", "Output defend");     // InteractionDialog // Geralts interaction with preacher

	//-- The Ambush ----------------------------------------
	catalog.AddEvent("_19", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_TheFlameOfHatred_NG_2", Vector(793.164673, 1868.151978));
	catalog.AddEventFacts("mq3023_guards_killed_no_weapons", "mq3023_guards_killed_weapons", "mq3023_priest_ignore", "mq3023_quest_done");
	// Quest blocks in mq3023_flame_of_hatred
	catalog.AddEventDoneBlock("1f83a97f-be31-482a-9a62-eafc6a196312", "True");                                            // Condition "mq3023_no_weapons exists?"
	catalog.AddEventDoneBlock("1f83a97f-be31-482a-9a62-eafc6a196312", "False");                                           // Condition "mq3023_no_weapons exists?"
	catalog.AddEventUnlockBlock("99c6f8ae-a544-407c-bd66-d6ec6d54b259", "True", "ProgressOnThePath_Location_Novigrad");   // Condition "crowd_anger > 0?"
	catalog.AddEventDoneBlock("9d69f066-d211-403d-bc6a-8ffb3cc4447b", "Output Ignore");                                   // InteractionDialog // Geralts interaction with preacher

	//-- The Most Truest of Basilisks ----------------------
	catalog.AddEvent("_14", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_TheMostTruestOfBasilisks_NG", Vector(1911.729736, 1141.309082));
	catalog.AddEventFacts("mq3015_encounter_ignored", "mq3015_wyvern_captive", "mq3015_wyvern_killed", "mq3015_quest_done");
	// Quest blocks in bugfixing_phase
	catalog.AddEventDoneBlock("882a8ee3-7157-4bc2-b664-d20e2ab29dd2", "wyvern_captive");   // InteractionDialog
	catalog.AddEventDoneBlock("ea723516-0867-4e7f-86bf-dc81d330d874", "None");             // PauseCondition "actor_mq3015_wyvern_was_killed >= 1"

	//-- The Price of Passage ------------------------------
	catalog.AddEvent("_15", PotP_E_Primary, PotP_R_NO, true, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_1", Vector(1678.246338, 1037.727295));
	catalog.AddEventFacts("mq3040_1st_payment", "mq3040_1st_refused", "mq3040_quest_done");
	// Quest blocks in mq3040_price_of_passage
	catalog.AddEventDoneBlock("4ae4d59d-a172-4175-a982-342cd5072449", "FirstPayment");   // Scene
	catalog.AddEventDoneBlock("4ae4d59d-a172-4175-a982-342cd5072449", "GoToFinal");      // Scene

	//-- Another Price of Passage --------------------------
	catalog.AddEvent("_17", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_2", Vector(1766.244873, 1038.741089));
	catalog.AddEventFacts("mq3040_1st_refused", "mq3040_2nd_payment", "mq3040_2nd_refused", "mq3040_quest_done");
	// Quest blocks in mq3040_price_of_passage
	catalog.AddEventDoneBlock("d429fa50-6e4f-4913-a8c6-5dece312561e", "GoToFinal");                                      // Scene
	catalog.AddEventDoneBlock("d429fa50-6e4f-4913-a8c6-5dece312561e", "SecondPayment");                                  // Scene
	catalog.AddEventUnlockBlock("f7fd60d5-0f9a-46af-be66-2c4cd2af40ad", "Out", "ProgressOnThePath_Location_Oxenfurt");   // StoryPhaseSetter // Respawn soldiers
	catalog.AddEventDoneBlock("4ae4d59d-a172-4175-a982-342cd5072449", "GoToFinal");                                      // Scene

	//-- The Final Price of Passage ------------------------
	catalog.AddEvent("_18", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_ThePriceOfPassage_NG_3", Vector(1932.989990, 1070.466309));
	catalog.AddEventFacts("mq3040_2nd_payment", "mq3040_final_axii", "mq3040_final_fistfight_lost", "mq3040_final_fistfight_won", "mq3040_final_guards_killed", "mq3040_final_payment", "mq3040_quest_done");
	// Quest blocks in mq3040_price_of_passage
	catalog.AddEventUnlockBlock("8ae30a41-628a-4d22-8840-63e2b4606bcb", "Out", "ProgressOnThePath_Location_Oxenfurt");   // StoryPhaseSetter // Respawn soldiers
	catalog.AddEventDoneBlock("0762afb5-a3ad-436f-b4f0-bc08b903cd72", "Axii");                                           // Scene
	catalog.AddEventDoneBlock("0762afb5-a3ad-436f-b4f0-bc08b903cd72", "End");                                            // Scene
	catalog.AddEventDoneBlock("ae35d316-71be-4bb3-913c-f15d4b37f895", "Out");                                            // And
	catalog.AddEventDoneBlock("c95a127e-8873-4c65-a1da-d8cd05ec499e", "Out");                                            // And
	catalog.AddEventDoneBlock("27184ae7-1611-4e13-9769-6f0b07af3d62", "Out");                                            // Phase
	catalog.AddEventDoneBlock("d429fa50-6e4f-4913-a8c6-5dece312561e", "SecondPayment");                                  // Scene

	//-- Witch Hunter Raids --------------------------------
	catalog.AddEvent("_16", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_WitchHunterRaids_NG", Vector(580.663086, 1569.924316));
	catalog.AddEventFacts("mq3009_fail", "mq3009_no_fight", "mq3009_wh_killed", "mq3009_quest_done");
	// Quest blocks in mq3009_witch_hunter_raids
	catalog.AddEventDoneBlock("e09a99ef-11b9-44dd-afb3-88c2de023c1d", "Out");                                            // Phase "Conditions on fail"
	catalog.AddEventUnlockBlock("66674e44-e4eb-4fe7-af3e-155b361d80c4", "Out", "ProgressOnThePath_Location_Novigrad");   // LayersHider // bring in all relevant
	catalog.AddEventDoneBlock("bddd21cf-d919-47b6-8e0f-d3e83cece58e", "Out");                                            // And
	catalog.AddEventDoneBlock("42a7d441-011f-4c34-827d-bb1309a9bdc2", "out no fight");                                   // Scene
	// Part of the witch hunters' hold on the city (q309_witch_hunters_control), once you've met him in sq301 and it's over.
	// Our copy of the phase unlocks it, completes it and misses it. The facts cover saves already past those points.
	// W3QE's quest for him is tracked as well, in QuestDefinitions.

	//-- The Mage at the Stake -----------------------------
	catalog.AddEvent("_20", PotP_E_Primary, PotP_R_NO, false, "no_mans_land", "PotP_Event_MageAtTheStake_NG", Vector(658.567261, 1663.454590));
	catalog.AddEventFacts("q309_ungrtf_mage_to_triss");
	// Quest blocks in q309_witch_hunters_control
	catalog.AddEventMissedBlock("ef16c5d1-a2b2-4ce4-8739-7c0c85afa7be", "Left");                                         // Phase "Fight wh"
	catalog.AddEventMissedBlock("274b8ea4-03d6-44d6-9266-f7d822ab3691", "Left");                                         // Phase "Leaving or coming closer"
	catalog.AddEventMissedBlock("62fde624-be12-4a6b-9894-ba027b5d8871", "None");                                         // PauseCondition "q402_escort_completed" // q402_escort_completed
	catalog.AddEventDoneBlock("78080a80-061c-4aa8-98e9-d4a0c70cae68", "Out");                                            // Phase "Until mage free"
	catalog.AddEventUnlockBlock("87921c3c-f4d4-46d5-83be-742145e4a226", "Out", "ProgressOnThePath_Location_Novigrad");   // Phase "Spawn"
	catalog.AddEventUnlockFacts("sq301_met_ungrt_mage", "sq301_completed");
	catalog.AddMissedUnless("sq301_completed", "sq301_met_ungrt_mage");
	catalog.AddAlsoMissedFact(PotP_Fact_EventMissed("PotP_Event_MageAtTheStake_NG"));
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineEvents_03(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_Event_3", PotP_A_Event, "PotP_TrackingGroup_RandomEvents_Skellige");
	//-- Call of the Wild ----------------------------------
	catalog.AddEvent("_01", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_CallOfTheWild_NG", Vector(-526.447571, -340.631042), 21, 5); //Night only, the werewolf spawns 21:00 - 05:00
	catalog.AddEventFacts("mq2052_quest_done");
	catalog.AddEventJournal('dlcevents_mq2052_call_of_the_wild');
	catalog.AddEventKill("werewolf_lvl3__lycan", 'encounter_aard_skellig_02');   // the lycan in Ard Skellig's encounter: in place of PotP's change to its encounter.w2l

	//-- Farting Trolls ------------------------------------
	catalog.AddEvent("_02", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_FartingTrolls_NG", Vector(-283.890625, -769.414673));
	catalog.AddEventFacts("mq2050_trolls_killed", "mq2050_quest_done");
	// Quest blocks in mq2050_farting_trolls
	catalog.AddEventDoneBlock("1b29cecc-414c-4621-967b-36d5d6169796", "None");   // PauseCondition "actor_mq2050_blogger_trolls_was_killed >= 3"

	//-- Siren's Call --------------------------------------
	catalog.AddEvent("_03", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_SirensCall_NG", Vector(-409.181061, -202.543701));
	catalog.AddEventFacts("mq2021_shepherd_dead", "mq2021_shepherd_saved", "mq2021_quest_done");
	// Quest blocks in mq2021_sirens_call
	catalog.AddEventDoneBlock("b5d37bf8-9f71-4427-bb1a-170ecc95eee4", "Output");   // Scene "Dialog with the shepherd"
	catalog.AddEventDoneBlock("8f723e2a-6a34-4282-983a-d0d0122748ff", "None");     // PauseCondition "Shepherd killed"

	//-- Sweet Bait ----------------------------------------
	catalog.AddEvent("_04", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_SweetBait_NG", Vector(-443.542175, -307.774261));
	catalog.AddEventFacts("mq2016_bandits_killed", "mq2016_ignored", "mq2016_quest_done");
	// Quest blocks in mq2016_sweet_bait
	catalog.AddEventDoneBlock("3c67cbb8-a3ad-4a62-a026-e07e4cb3b9b0", "None");   // PauseCondition "Player away from ambush site"

	//-- The Four Faces of Hemdall -------------------------
	catalog.AddEvent("_05", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_TheFourFacesOfHemdall_NG", Vector(2011.217651, -1851.521729));
	catalog.AddEventFacts("mq2034_pirates_killed", "mq2034_pirates_paid", "mq2034_quest_done");
	catalog.AddEventFacts("mq2034_aft_pirates");   // vanilla: set after the event ends, so they work without Brothers In Arms
	// Quest blocks in mq2034_fourth_tide
	catalog.AddEventDoneBlock("c09eb485-28cc-475d-9698-6aae9f327251", "Out");   // Phase "Fight"
	catalog.AddEventDoneBlock("4ee0549a-46d4-47d5-abf4-6bca8f5b8624", "Out");   // Phase "Payed"

	//-- Woe is Me -----------------------------------------
	catalog.AddEvent("_06", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_WoeIsMe_NG", Vector(552.972961, -411.028778));
	catalog.AddEventFacts("mq2019_killed", "mq2019_killed_no_talk", "mq2019_quest_done");
	catalog.AddEventFacts("mq2019_done");   // vanilla: set after the event ends, so they work without Brothers In Arms
	// Quest blocks in mq2019_lamenting_man
	catalog.AddEventDoneBlock("5da63078-35c2-44ee-908e-1ddfc4ef36c0", "Out");   // Phase "Simple Attack"
	catalog.AddEventDoneBlock("a9f92c6f-35f4-439c-b461-0c6ef26487f4", "Out");   // Phase "Coordinated Attack"

	//-- Yustianna Disturbed -------------------------------
	catalog.AddEvent("_07", PotP_E_Primary, PotP_R_SK, true, "skellige", "PotP_Event_YustiannaDisturbed_NG", Vector(677.762207, 635.591064));
	catalog.AddEventFacts("mq2003_3_bandits_fight", "mq2003_3_bandits_axii", "mq2003_3_bandits_killed", "mq2003_3_bandits_pay", "mq2003_3_quest_done");
	// Quest blocks in mq2003_skellige_tombs
	catalog.AddEventDoneBlock("7fd2d3c5-4369-4354-9010-a655d2493dbd", "Out");         // [SetGroupAttitudeQuest]" SetGroupAttitudeQuest(srcGroup=mq2003_bandits
	catalog.AddEventDoneBlock("db5073e8-4e91-458a-8a87-751d7d62fb96", "extorsion");   // Scene // Dialog with bandits
	catalog.EndSection();
}

//---------------------------------------------------

function PotP_DefineEvents_04(catalog: CPotP_Catalog)
{
	catalog.BeginSection(PotP_Book_Quest, "PotP_Preview_Event_4", PotP_A_Event, "PotP_TrackingGroup_RandomEvents_KaerMorhen");
	//-- Trail of Echoes -----------------------------------
	catalog.AddEvent("_01", PotP_E_Primary, PotP_R_KM, true, "kaer_morhen", "PotP_Event_TrailOfEchoes_NG", Vector(-327.778656, 175.190674));
	catalog.AddEventFacts("mq4001_end_quest", "mq4001_quest_done");
	// Quest blocks in mq4001_trail
	catalog.AddEventDoneBlock("2708e7e3-1e5c-41f6-b67b-9934c76976fd", "Out");   // Reward "Reward [mq4001_01_completed]"
	catalog.EndSection();
}
