//---------------------------------------------------
//-- Missable Definitions --------------------------
//---------------------------------------------------

function PotP_DefineMissables(catalog: CPotP_Catalog)
{
	PotP_DefineMissables_Cutoffs(catalog);
	PotP_DefineMissables_Expansions(catalog);
	PotP_DefineMissables_Choices(catalog);
	PotP_DefineMissables_Failable(catalog);
}

//---------------------------------------------------
//-- Points of no return: base game -----------------
//---------------------------------------------------

function PotP_DefineMissables_Cutoffs(catalog: CPotP_Catalog)
{
	// Leaving White Orchard for Vizima.
	catalog.BeginMissableGroup("PotP_Preview_Missable_01", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Prologue_02", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_01");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_03");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_04");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_05");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_06");

	// Ordering between two main quests; no single quest marks the cutoff.
	catalog.BeginMissableGroup("PotP_Preview_Missable_13", PotP_M_Cutoff);
	catalog.AddMissable("PotP_TrackingGroup_MainQuests_SkelligeAct1_07");

	catalog.BeginMissableGroup("PotP_Preview_Missable_19", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_NovigradAct1_04", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_44");

	catalog.BeginMissableGroup("PotP_Preview_Missable_04", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_NovigradAct1_06", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_09");

	// Only while the witch hunters hold the city: mq3009 ends with q309_completed or q309_failed.
	catalog.BeginMissableGroup("PotP_Preview_Missable_31", PotP_M_Cutoff, "PotP_TrackingGroup_SideQuests_Novigrad_32", PotP_T_Ended);
	catalog.AddMissable("PotP_TrackingGroup_RandomEvents_Novigrad_16");

	catalog.BeginMissableGroup("PotP_Preview_Missable_02", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Act2_01", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_34");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_NonRegional_03");

	catalog.BeginMissableGroup("PotP_Preview_Missable_03", PotP_M_Cutoff, "PotP_TrackingGroup_SideQuests_Velen_02", PotP_T_Started);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_22");

	catalog.BeginMissableGroup("PotP_Preview_Missable_05", PotP_M_Cutoff, "PotP_TrackingGroup_SideQuests_NonRegional_03", PotP_T_Started);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_12");

	// The Ice Giant is fought part way through 'The Lord of Undvik'.
	catalog.BeginMissableGroup("PotP_Preview_Missable_07", PotP_M_Cutoff, "PotP_TrackingGroup_SideQuests_Skellige_35", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_26");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_28");

	catalog.BeginMissableGroup("PotP_Preview_Missable_10", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Act2_11", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_02", "potp_missable_tip_dangerous_game");
	// The stake goes with q402_escort_completed: the event, or W3QE's quest in its place.
	catalog.AddMissable("PotP_TrackingGroup_RandomEvents_Novigrad_20", "potp_missable_tip_mage_at_stake");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_94", "potp_missable_tip_mage_at_stake");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_03");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_02");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_06");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_04");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_10");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_05");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_KaerMorhen_01");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_12");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_13");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_08");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_17");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_14");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_17");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_20");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_32");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_39");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_25");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_27");

	// The Lodge meeting is part way through 'Final Preparations'.
	catalog.BeginMissableGroup("PotP_Preview_Missable_09", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Act3_02", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_45");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_46");

	catalog.BeginMissableGroup("PotP_Preview_Missable_08", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Act3_07", PotP_T_Started);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_07");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_23");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_35");

	catalog.BeginMissableGroup("PotP_Preview_Missable_06", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_Act3_12", PotP_T_Started);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_38");
	catalog.AddMissable("PotP_TrackingGroup_ContractQuests_WhiteOrchard_01");
}

//---------------------------------------------------
//-- Points of no return: expansions ----------------
//---------------------------------------------------

function PotP_DefineMissables_Expansions(catalog: CPotP_Catalog)
{
	// Hearts of Stone: the auction is part way through 'Open Sesame!'.
	catalog.BeginMissableGroup("PotP_Preview_Missable_20", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_HeartsOfStone_03", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_11", "potp_missable_tip_avid_collector");
	catalog.AddMissable("PotP_TrackingGroup_TreasureHuntQuests_Novigrad_01", "potp_missable_tip_dark_legacy");

	catalog.BeginMissableGroup("PotP_Preview_Missable_21", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_HeartsOfStone_02", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_07", "potp_missable_tip_midnight_clear");

	// W3QE: Olgierd leaves when 'Scenes From a Marriage' starts, and Shani's Gwent dialogue stops
	// at her house, straight after the Alchemy Inn meeting in 'Whatsoever a Man Soweth'.
	if (PotP_UsingW3QE_Hearts())
	{
		catalog.BeginMissableGroup("PotP_Preview_Missable_30", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_HeartsOfStone_08", PotP_T_Completed);
		catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_91", "potp_missable_tip_playing_hearts");
	}

	// Blood and Wine
	catalog.BeginMissableGroup("PotP_Preview_Missable_11", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_BloodAndWine_05", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_03");

	// Captain de la Tour is met part way through 'Capture the Castle'.
	catalog.BeginMissableGroup("PotP_Preview_Missable_22", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_BloodAndWine_08", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_26", "potp_missable_tip_warble");

	catalog.BeginMissableGroup("PotP_Preview_Missable_23", PotP_M_Cutoff, "PotP_TrackingGroup_MainQuests_BloodAndWine_10", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_10", "potp_missable_tip_duck");
}

//---------------------------------------------------
//-- Choices and endings ----------------------------
//---------------------------------------------------

function PotP_DefineMissables_Choices(catalog: CPotP_Catalog)
{
	catalog.BeginMissableGroup("PotP_Preview_Missable_18", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_26");

	catalog.BeginMissableGroup("PotP_Preview_Missable_12", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_22");

	catalog.BeginMissableGroup("PotP_Preview_Missable_15", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_27");

	catalog.BeginMissableGroup("PotP_Preview_Missable_16", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Skellige_04");

	catalog.BeginMissableGroup("PotP_Preview_Missable_28", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_21");

	catalog.BeginMissableGroup("PotP_Preview_Missable_14", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_05");

	catalog.BeginMissableGroup("PotP_Preview_Missable_27", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_MainQuests_Act2_07", "potp_missable_tip_bia_velen");
	catalog.AddMissable("PotP_TrackingGroup_MainQuests_Act2_09", "potp_missable_tip_bia_skellige");

	catalog.BeginMissableGroup("PotP_Preview_Missable_24", PotP_M_Choice, "PotP_TrackingGroup_MainQuests_Act3_14", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_WhiteOrchard_02");

	catalog.BeginMissableGroup("PotP_Preview_Missable_17", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_37");

	catalog.BeginMissableGroup("PotP_Preview_Missable_25", PotP_M_Choice);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_24");

	// 'Burlap is the New Stripe' only happens if Syanna dies.
	catalog.BeginMissableGroup("PotP_Preview_Missable_26", PotP_M_Choice, "PotP_TrackingGroup_MainQuests_BloodAndWine_15", PotP_T_Completed);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Toussaint_25");
}

//---------------------------------------------------
//-- Easy to fail -----------------------------------
//---------------------------------------------------

function PotP_DefineMissables_Failable(catalog: CPotP_Catalog)
{
	catalog.BeginMissableGroup("PotP_Preview_Missable_00", PotP_M_Failable);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_01");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_01");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_23");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_49");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_19", "potp_missable_tip_hazardous_goods");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_NonRegional_01", "potp_missable_tip_black_pearl");

	catalog.BeginMissableGroup("PotP_Preview_Missable_29", PotP_M_Failable);
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Novigrad_25", "potp_missable_tip_high_stakes");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_NonRegional_02", "potp_missable_tip_collect");
	catalog.AddMissable("PotP_TrackingGroup_SideQuests_Velen_11", "potp_missable_tip_fake_papers");
}
