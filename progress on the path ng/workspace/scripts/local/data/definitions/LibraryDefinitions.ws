//---------------------------------------------------
//-- Library Definitions ----------------------------
//---------------------------------------------------
// Made by overlay/tools/gen_library.py from the game's item definitions. Don't edit by hand.
// A book or a note is read when the game says so: its BookReadState_ fact (CInventoryComponent.IsBookReadByName).
// Each shelf ends with what mods add to it (CPotP_Catalog.AddModBooks). Notes (AddNote) aren't counted in progress.

function PotP_DefineLibrary(catalog: CPotP_Catalog)
{
	PotP_DefineLibrary_1(catalog);
	PotP_DefineLibrary_2(catalog);
	PotP_DefineLibrary_3(catalog);
	PotP_DefineLibrary_4(catalog);
	PotP_DefineLibrary_5(catalog);
	PotP_DefineLibrary_6(catalog);
	PotP_DefineLibrary_7(catalog);
	PotP_DefineLibrary_8(catalog);
	PotP_DefineLibrary_9(catalog);
	PotP_DefineLibrary_10(catalog);
	PotP_DefineLibrary_11(catalog);
	PotP_DefineLibrary_12(catalog);
	PotP_DefineLibrary_13(catalog);
	PotP_DefineLibrary_14(catalog);
	PotP_DefineLibrary_15(catalog);
	PotP_DefineLibrary_16(catalog);
	PotP_DefineLibrary_17(catalog);
	PotP_DefineLibrary_18(catalog);
	PotP_DefineLibrary_19(catalog);
	PotP_DefineLibrary_20(catalog);
	PotP_DefineLibrary_21(catalog);
	PotP_DefineLibrary_22(catalog);
}

// REDkit's parser runs out of memory on one very long function
function PotP_DefineLibrary_1(catalog: CPotP_Catalog)
{
	catalog.BeginLibrarySection("potp_ov_library_lore");
	catalog.AddBook("book_of_arachases", PotP_E_Primary, 'Book of Arachases');
	catalog.AddBook("gear_improvement", PotP_E_Primary, 'Gear improvement');
	catalog.AddBook("glossary_temerian_dynasty", PotP_E_Primary, 'Glossary Temerian Dynasty');
	catalog.AddBook("jacob_of_varazze_chronicles", PotP_E_Primary, 'Jacob of Varazze Chronicles');
	catalog.AddBook("journey_into_the_mind", PotP_E_Primary, 'Journey into the mind');
	catalog.AddBook("necronomicon", PotP_E_Primary, 'Necronomicon');
	catalog.AddBook("norther_kingdoms_arms_and_tactics", PotP_E_Primary, 'Norther Kingdoms arms and tactics');
	catalog.AddBook("orders_from_shilard", PotP_E_Primary, 'Orders from Shilard');
	catalog.AddBook("poems_of_gonzal_de_verceo", PotP_E_Primary, 'Poems of Gonzal de Verceo');
	catalog.AddBook("skelige_arms_and_tactics", PotP_E_Primary, 'Skelige arms and tactics');
	catalog.AddBook("item_book_lore_royal_chronicle_1", PotP_E_Primary_DLC2, 'item_book_lore_royal_chronicle_1');
	catalog.AddBook("item_book_lore_royal_chronicle_2", PotP_E_Primary_DLC2, 'item_book_lore_royal_chronicle_2');
	catalog.AddBook("lore_about_the_fourth_witch", PotP_E_Primary, 'lore_about_the_fourth_witch');
	catalog.AddBook("lore_aleksanders_notes", PotP_E_Primary, 'lore_aleksanders_notes');
	catalog.AddBook("lore_an_seidhe_and_aen_elle", PotP_E_Primary, 'lore_an_seidhe_and_aen_elle');
	catalog.AddBook("lore_basics_of_magic", PotP_E_Primary, 'lore_basics_of_magic');
	catalog.AddBook("lore_basilisk_hunts", PotP_E_Primary_DLC2, 'lore_basilisk_hunts');
	catalog.AddBook("lore_bells_of_beauclair", PotP_E_Primary, 'lore_bells_of_beauclair');
	catalog.AddBook("lore_biography_beledals_grandfather", PotP_E_Primary_DLC2, 'lore_biography_beledals_grandfather');
	catalog.AddBook("lore_brother_adalbert_bestiary", PotP_E_Primary, 'lore_brother_adalbert_bestiary');
	catalog.AddBook("lore_caed_myrkvid_guide", PotP_E_Primary_DLC2, 'lore_caed_myrkvid_guide');
	catalog.AddBook("lore_cirilla_of_cintra", PotP_E_Primary, 'lore_cirilla_of_cintra');
	catalog.AddBook("lore_conjunction_of_spheres", PotP_E_Primary, 'lore_conjunction_of_spheres');
	catalog.AddBook("lore_cult_of_freyia", PotP_E_Primary, 'lore_cult_of_freyia');
	catalog.AddBook("lore_cult_of_hemdall", PotP_E_Primary, 'lore_cult_of_hemdall');
	catalog.AddBook("lore_druids", PotP_E_Primary, 'lore_druids');
	catalog.AddBook("lore_dun_tynne_legend", PotP_E_Primary_DLC2, 'lore_dun_tynne_legend');
	catalog.AddBook("lore_elder_blood", PotP_E_Primary, 'lore_elder_blood');
	catalog.AddBook("lore_elven_legends", PotP_E_Primary, 'lore_elven_legends');
	catalog.AddBook("lore_elven_ruins", PotP_E_Primary, 'lore_elven_ruins');
	catalog.AddBook("lore_elven_sages", PotP_E_Primary, 'lore_elven_sages');
	catalog.AddBook("lore_fall_of_wyzima", PotP_E_Primary, 'lore_fall_of_wyzima');
	catalog.AddBook("lore_faramond_book", PotP_E_Primary_DLC2, 'lore_faramond_book');
	catalog.AddBook("lore_fate_of_temeria", PotP_E_Primary, 'lore_fate_of_temeria');
	catalog.AddBook("lore_goetia", PotP_E_Primary, 'lore_goetia');
	catalog.AddBook("lore_gwent_history", PotP_E_Primary_DLC2, 'lore_gwent_history');
	catalog.AddBook("lore_hydromancy", PotP_E_Primary, 'lore_hydromancy');
	catalog.AddBook("lore_imperial_edict_i", PotP_E_Primary, 'lore_imperial_edict_i');
	catalog.AddBook("lore_imperial_edict_ii", PotP_E_Primary, 'lore_imperial_edict_ii');
}

function PotP_DefineLibrary_2(catalog: CPotP_Catalog)
{
	catalog.AddBook("lore_inteligence_report_about_ciri", PotP_E_Primary, 'lore_inteligence_report_about_ciri');
	catalog.AddBook("lore_journals_from_urskar_1", PotP_E_Primary, 'lore_journals_from_urskar_1');
	catalog.AddBook("lore_journals_from_urskar_2", PotP_E_Primary, 'lore_journals_from_urskar_2');
	catalog.AddBook("lore_journals_from_urskar_3", PotP_E_Primary, 'lore_journals_from_urskar_3');
	catalog.AddBook("lore_journals_from_urskar_4", PotP_E_Primary, 'lore_journals_from_urskar_4');
	catalog.AddBook("lore_journals_from_urskar_5", PotP_E_Primary, 'lore_journals_from_urskar_5');
	catalog.AddBook("lore_journals_from_urskar_6", PotP_E_Primary, 'lore_journals_from_urskar_6');
	catalog.AddBook("lore_journals_from_urskar_7", PotP_E_Primary, 'lore_journals_from_urskar_7');
	catalog.AddBook("lore_knights_errant", PotP_E_Primary_DLC2, 'lore_knights_errant');
	catalog.AddBook("lore_kovir", PotP_E_Primary, 'lore_kovir');
	catalog.AddBook("lore_last_wish", PotP_E_Primary, 'lore_last_wish');
	catalog.AddBook("lore_lodge_of_sorceresses", PotP_E_Primary, 'lore_lodge_of_sorceresses');
	catalog.AddBook("lore_monstrum", PotP_E_Primary, 'lore_monstrum');
	catalog.AddBook("lore_naglfar_demonic_drakkar", PotP_E_Primary, 'lore_naglfar_demonic_drakkar');
	catalog.AddBook("lore_necromancy", PotP_E_Primary, 'lore_necromancy');
	catalog.AddBook("lore_nilfgaardian_empire", PotP_E_Primary, 'lore_nilfgaardian_empire');
	catalog.AddBook("lore_nilfgaardian_history_book", PotP_E_Primary, 'lore_nilfgaardian_history_book');
	catalog.AddBook("lore_nilfgaardian_royal_dynasty", PotP_E_Primary, 'lore_nilfgaardian_royal_dynasty');
	catalog.AddBook("lore_nilfgaardian_transport_orders", PotP_E_Primary, 'lore_nilfgaardian_transport_orders');
	catalog.AddBook("lore_non_humans", PotP_E_Primary, 'lore_non_humans');
	catalog.AddBook("lore_novigrad", PotP_E_Primary, 'lore_novigrad');
	catalog.AddBook("lore_oneiromancy", PotP_E_Primary, 'lore_oneiromancy');
	catalog.AddBook("lore_oxenfurt", PotP_E_Primary, 'lore_oxenfurt');
	catalog.AddBook("lore_polymorphism", PotP_E_Primary, 'lore_polymorphism');
	catalog.AddBook("lore_popiels_journal", PotP_E_Primary, 'lore_popiels_journal');
	catalog.AddBook("lore_principles_of_eternal_fire", PotP_E_Primary, 'lore_principles_of_eternal_fire');
	catalog.AddBook("lore_prophecy_of_ithlinne", PotP_E_Primary, 'lore_prophecy_of_ithlinne');
	catalog.AddBook("lore_radovid_propaganda_pamphlet", PotP_E_Primary, 'lore_radovid_propaganda_pamphlet');
	catalog.AddBook("lore_radovids_rise_to_power", PotP_E_Primary, 'lore_radovids_rise_to_power');
	catalog.AddBook("lore_ragnarok", PotP_E_Primary, 'lore_ragnarok');
	catalog.AddBook("lore_redania", PotP_E_Primary, 'lore_redania');
	catalog.AddBook("lore_redanian_secret_service", PotP_E_Primary, 'lore_redanian_secret_service');
	catalog.AddBook("lore_sands_of_zerrikania", PotP_E_Primary, 'lore_sands_of_zerrikania');
	catalog.AddBook("lore_skellige_heroes_broddr", PotP_E_Primary, 'lore_skellige_heroes_broddr');
	catalog.AddBook("lore_skellige_heroes_grymmdjarr", PotP_E_Primary, 'lore_skellige_heroes_grymmdjarr');
	catalog.AddBook("lore_skellige_heroes_modolf", PotP_E_Primary, 'lore_skellige_heroes_modolf');
	catalog.AddBook("lore_skellige_heroes_otkell", PotP_E_Primary, 'lore_skellige_heroes_otkell');
	catalog.AddBook("lore_skellige_heroes_sove", PotP_E_Primary, 'lore_skellige_heroes_sove');
	catalog.AddBook("lore_skellige_heroes_tyr", PotP_E_Primary, 'lore_skellige_heroes_tyr');
	catalog.AddBook("lore_skellige_island", PotP_E_Primary, 'lore_skellige_island');
}

function PotP_DefineLibrary_3(catalog: CPotP_Catalog)
{
	catalog.AddBook("lore_study_on_white_cold", PotP_E_Primary, 'lore_study_on_white_cold');
	catalog.AddBook("lore_summit_of_loc_muinne", PotP_E_Primary, 'lore_summit_of_loc_muinne');
	catalog.AddBook("lore_the_great_four", PotP_E_Primary, 'lore_the_great_four');
	catalog.AddBook("lore_theory_of_spheres", PotP_E_Primary, 'lore_theory_of_spheres');
	catalog.AddBook("lore_third_war_with_nilfgaard", PotP_E_Primary, 'lore_third_war_with_nilfgaard');
	catalog.AddBook("lore_toussaint_civil_war", PotP_E_Primary_DLC2, 'lore_toussaint_civil_war');
	catalog.AddBook("lore_toussaint_ecology", PotP_E_Primary_DLC2, 'lore_toussaint_ecology');
	catalog.AddBook("lore_toussaint_nobles", PotP_E_Primary_DLC2, 'lore_toussaint_nobles');
	catalog.AddBook("lore_tyromancy", PotP_E_Primary, 'lore_tyromancy');
	catalog.AddBook("lore_unfinished_war_annals", PotP_E_Primary, 'lore_unfinished_war_annals');
	catalog.AddBook("lore_velen", PotP_E_Primary, 'lore_velen');
	catalog.AddBook("lore_vineyards_guide_part_i", PotP_E_Primary_DLC2, 'lore_vineyards_guide_part_i');
	catalog.AddBook("lore_vineyards_guide_part_ii", PotP_E_Primary_DLC2, 'lore_vineyards_guide_part_ii');
	catalog.AddBook("lore_war_between_astrals", PotP_E_Primary, 'lore_war_between_astrals');
	catalog.AddBook("lore_wars_with_nilfgaard", PotP_E_Primary, 'lore_wars_with_nilfgaard');
	catalog.AddBook("lore_wild_hunt", PotP_E_Primary, 'lore_wild_hunt');
	catalog.AddBook("lore_witch_hunters", PotP_E_Primary, 'lore_witch_hunters');
	catalog.AddBook("lore_witcher_signs", PotP_E_Primary, 'lore_witcher_signs');
	catalog.AddBook("lore_witchers", PotP_E_Primary, 'lore_witchers');
	catalog.AddBook("lore_yennefer_journals", PotP_E_Primary, 'lore_yennefer_journals');
	catalog.AddModBooks(0);
	catalog.EndSection();
	catalog.BeginLibrarySection("potp_ov_library_tomes");
	catalog.AddBook("armor_maintenance", PotP_E_Primary, 'Armor maintenance');
	catalog.AddBook("beasts_vol_1", PotP_E_Primary, 'Beasts vol 1');
	catalog.AddBook("beasts_vol_2", PotP_E_Primary, 'Beasts vol 2');
	catalog.AddBook("boat_vol_1", PotP_E_Primary, 'Boat vol 1');
	catalog.AddBook("boat_vol_2", PotP_E_Primary, 'Boat vol 2');
	catalog.AddBook("cursed_monsters_vol_1", PotP_E_Primary, 'Cursed Monsters vol 1');
	catalog.AddBook("cursed_monsters_vol_2", PotP_E_Primary, 'Cursed Monsters vol 2');
	catalog.AddBook("draconides_vol_1", PotP_E_Primary, 'Draconides vol 1');
	catalog.AddBook("draconides_vol_2", PotP_E_Primary, 'Draconides vol 2');
	catalog.AddBook("horse_vol_1", PotP_E_Primary, 'Horse vol 1');
	catalog.AddBook("horse_vol_2", PotP_E_Primary, 'Horse vol 2');
	catalog.AddBook("hybrid_monsters_vol_1", PotP_E_Primary, 'Hybrid Monsters vol 1');
	catalog.AddBook("hybrid_monsters_vol_2", PotP_E_Primary, 'Hybrid Monsters vol 2');
	catalog.AddBook("insectoids_vol_1", PotP_E_Primary, 'Insectoids vol 1');
	catalog.AddBook("insectoids_vol_2", PotP_E_Primary, 'Insectoids vol 2');
	catalog.AddBook("magical_monsters_vol_1", PotP_E_Primary, 'Magical Monsters vol 1');
	catalog.AddBook("magical_monsters_vol_2", PotP_E_Primary, 'Magical Monsters vol 2');
}

function PotP_DefineLibrary_4(catalog: CPotP_Catalog)
{
	catalog.AddBook("necrophage_vol_1", PotP_E_Primary, 'Necrophage vol 1');
	catalog.AddBook("necrophage_vol_2", PotP_E_Primary, 'Necrophage vol 2');
	catalog.AddBook("nilfgard_arms_and_tactics", PotP_E_Primary, 'Nilfgard arms and tactics');
	catalog.AddBook("ogres_vol_1", PotP_E_Primary, 'Ogres vol 1');
	catalog.AddBook("ogres_vol_2", PotP_E_Primary, 'Ogres vol 2');
	catalog.AddBook("relict_monsters_vol_1", PotP_E_Primary, 'Relict Monsters vol 1');
	catalog.AddBook("relict_monsters_vol_2", PotP_E_Primary, 'Relict Monsters vol 2');
	catalog.AddBook("specters_vol_1", PotP_E_Primary, 'Specters vol 1');
	catalog.AddBook("specters_vol_2", PotP_E_Primary, 'Specters vol 2');
	catalog.AddBook("theatre_glossary_vol_1", PotP_E_Primary, 'Theatre Glossary vol 1');
	catalog.AddBook("theatre_glossary_vol_2", PotP_E_Primary, 'Theatre Glossary vol 2');
	catalog.AddBook("vampires_vol_1", PotP_E_Primary, 'Vampires vol 1');
	catalog.AddBook("vampires_vol_2", PotP_E_Primary, 'Vampires vol 2');
	catalog.AddBook("weapon_maintenance", PotP_E_Primary, 'Weapon maintenance');
	catalog.AddBook("wild_hunt", PotP_E_Primary, 'Wild Hunt');
	catalog.AddBook("bestiary_alp_book", PotP_E_Primary_DLC2, 'bestiary_alp_book');
	catalog.AddBook("bestiary_archespore_book", PotP_E_Primary_DLC2, 'bestiary_archespore_book');
	catalog.AddBook("bestiary_barghest_book", PotP_E_Primary_DLC2, 'bestiary_barghest_book');
	catalog.AddBook("bestiary_bruxa_book", PotP_E_Primary_DLC2, 'bestiary_bruxa_book');
	catalog.AddBook("bestiary_dracolizard_book", PotP_E_Primary_DLC2, 'bestiary_dracolizard_book');
	catalog.AddBook("bestiary_fleder_book", PotP_E_Primary_DLC2, 'bestiary_fleder_book');
	catalog.AddBook("bestiary_garkain_book", PotP_E_Primary_DLC2, 'bestiary_garkain_book');
	catalog.AddBook("bestiary_kikimore_book", PotP_E_Primary_DLC2, 'bestiary_kikimore_book');
	catalog.AddBook("bestiary_panther_book", PotP_E_Primary_DLC2, 'bestiary_panther_book');
	catalog.AddBook("bestiary_protofleder_book", PotP_E_Primary_DLC2, 'bestiary_protofleder_book');
	catalog.AddBook("bestiary_scolopendromorph_book", PotP_E_Primary_DLC2, 'bestiary_scolopendromorph_book');
	catalog.AddBook("bestiary_sharley_book", PotP_E_Primary_DLC2, 'bestiary_sharley_book');
	catalog.AddBook("bestiary_spriggan_book", PotP_E_Primary_DLC2, 'bestiary_spriggan_book');
	catalog.AddBook("bestiary_wight_book", PotP_E_Primary_DLC2, 'bestiary_wight_book');
	catalog.AddModBooks(1);
	catalog.EndSection();
	catalog.BeginLibrarySection("potp_ov_library_journals");
	catalog.AddNote("fightclub_book", PotP_E_Primary_DLC2, 'fightclub_book');
	catalog.AddNote("q703_history_of_pomino", PotP_E_Primary_DLC2, 'q703_history_of_pomino');
	catalog.AddNote("sq703_accountance_book", PotP_E_Primary_DLC2, 'sq703_accountance_book');
	catalog.AddNote("poi_car_a_06_note", PotP_E_Primary_DLC2, 'poi_car_a_06_note');
	catalog.AddNote("th701_wolf_witcher_note", PotP_E_Primary_DLC2, 'th701_wolf_witcher_note');
	catalog.AddNote("mq1002_aeramas_journal", PotP_E_Primary, 'mq1002_aeramas_journal');
	catalog.AddNote("poi_gor_d_06_note02", PotP_E_Primary_DLC2, 'poi_gor_d_06_note02');
	catalog.AddNote("mh306_mages_journal", PotP_E_Primary, 'mh306_mages_journal');
}

function PotP_DefineLibrary_5(catalog: CPotP_Catalog)
{
	catalog.AddNote("q311_lost_diary3", PotP_E_Primary, 'q311_lost_diary3');
	catalog.AddNote("poi_ved_a_01_note", PotP_E_Primary_DLC2, 'poi_ved_a_01_note');
	catalog.AddNote("poi_gor_a_08_note", PotP_E_Primary_DLC2, 'poi_gor_a_08_note');
	catalog.AddNote("poi_ww_vermentino_note_camp", PotP_E_Primary_DLC2, 'poi_ww_vermentino_note_camp');
	catalog.AddNote("q304_dandelion_ballad", PotP_E_Primary, 'q304_dandelion_ballad');
	catalog.AddNote("poi_san_b_06_note", PotP_E_Primary_DLC2, 'poi_san_b_06_note');
	catalog.AddNote("q604_genie_book", PotP_E_Primary_DLC1, 'q604_genie_book');
	catalog.AddNote("q604_demon_book", PotP_E_Primary_DLC1, 'q604_demon_book');
	catalog.AddNote("poi_dun_b_03_note", PotP_E_Primary_DLC2, 'poi_dun_b_03_note');
	catalog.AddNote("lw_prologue_temerian_treasure_note", PotP_E_Primary, 'lw_prologue_temerian_treasure_note');
	catalog.AddNote("th1003_journal_lynx_part5", PotP_E_Primary, 'th1003_journal_lynx_part5');
	catalog.AddNote("mq2048_ships_logbook", PotP_E_Primary, 'mq2048_ships_logbook');
	catalog.AddNote("lw_sk3_ship_note", PotP_E_Primary, 'lw_sk3_ship_note');
	catalog.AddNote("q703_one_handed_adalard", PotP_E_Primary_DLC2, 'q703_one_handed_adalard');
	catalog.AddNote("mq2049_book_5", PotP_E_Primary, 'mq2049_book_5');
	catalog.AddNote("th701_bear_notes", PotP_E_Primary_DLC2, 'th701_bear_notes');
	catalog.AddNote("poi_gor_c_03_note", PotP_E_Primary_DLC2, 'poi_gor_c_03_note');
	catalog.AddNote("q311_lost_diary2", PotP_E_Primary, 'q311_lost_diary2');
	catalog.AddNote("poi_gor_b_04_note", PotP_E_Primary_DLC2, 'poi_gor_b_04_note');
	catalog.AddNote("ep1_poi_26_note2", PotP_E_Primary_DLC1, 'ep1_poi_26_note2');
	catalog.AddNote("ep1_poi_26_note", PotP_E_Primary_DLC1, 'ep1_poi_26_note');
	catalog.AddNote("th1005_journal_gryphon_part6", PotP_E_Primary, 'th1005_journal_gryphon_part6');
	catalog.AddNote("q704_mages_notebook", PotP_E_Primary_DLC2, 'q704_mages_notebook');
	catalog.AddNote("ep1_poi_24_note", PotP_E_Primary_DLC1, 'ep1_poi_24_note');
	catalog.AddNote("poi_ved_a_03b_note", PotP_E_Primary_DLC2, 'poi_ved_a_03b_note');
	catalog.AddNote("q304_dandelion_diary", PotP_E_Primary, 'q304_dandelion_diary');
	catalog.AddNote("sq205_brewmasters_log", PotP_E_Primary, 'sq205_brewmasters_log');
	catalog.AddNote("th1005_journal_gryphon_part5", PotP_E_Primary, 'th1005_journal_gryphon_part5');
	catalog.AddNote("sq102_dolores_diary", PotP_E_Primary, 'sq102_dolores_diary');
	catalog.AddNote("poi_gor_a_10_note_b", PotP_E_Primary_DLC2, 'poi_gor_a_10_note_b');
	catalog.AddNote("sq202_book_1", PotP_E_Primary, 'sq202_book_1');
	catalog.AddNote("poi_bar_a_02_note", PotP_E_Primary_DLC2, 'poi_bar_a_02_note');
	catalog.AddNote("q311_lost_diary1", PotP_E_Primary, 'q311_lost_diary1');
	catalog.AddNote("poi_san_a_01_note", PotP_E_Primary_DLC2, 'poi_san_a_01_note');
	catalog.AddNote("q602_dynasties", PotP_E_Primary_DLC1, 'q602_dynasties');
	catalog.AddNote("lw_sb13_note", PotP_E_Primary, 'lw_sb13_note');
	catalog.AddNote("lw_sk25_blood_countess_note", PotP_E_Primary, 'lw_sk25_blood_countess_note');
	catalog.AddNote("q602_basics_of_medicine", PotP_E_Primary_DLC1, 'q602_basics_of_medicine');
	catalog.AddNote("q605_black_magic_book", PotP_E_Primary_DLC1, 'q605_black_magic_book');
	catalog.AddNote("poi_bar_b_05_note", PotP_E_Primary_DLC2, 'poi_bar_b_05_note');
}

function PotP_DefineLibrary_6(catalog: CPotP_Catalog)
{
	catalog.AddNote("q701_godfryd_book", PotP_E_Primary_DLC2, 'q701_godfryd_book');
	catalog.AddNote("sq210_gog_book", PotP_E_Primary, 'sq210_gog_book');
	catalog.AddNote("q101_hendrik_notes", PotP_E_Primary, 'q101_hendrik_notes');
	catalog.AddNote("mq2003_bandit_journal", PotP_E_Primary, 'mq2003_bandit_journal');
	catalog.AddNote("q701_goliath_book", PotP_E_Primary_DLC2, 'q701_goliath_book');
	catalog.AddNote("sq102_huberts_diary", PotP_E_Primary, 'sq102_huberts_diary');
	catalog.AddNote("ep1_poi_03_note", PotP_E_Primary_DLC1, 'ep1_poi_03_note');
	catalog.AddNote("q302_casino_register", PotP_E_Primary, 'q302_casino_register');
	catalog.AddNote("th1001_journal_viper_part1", PotP_E_Primary, 'th1001_journal_viper_part1');
	catalog.AddNote("th1003_journal_lynx_part6", PotP_E_Primary, 'th1003_journal_lynx_part6');
	catalog.AddNote("th701_wolf_journal", PotP_E_Primary_DLC2, 'th701_wolf_journal');
	catalog.AddNote("mq2048_guide_notes", PotP_E_Primary, 'mq2048_guide_notes');
	catalog.AddNote("q704_ft_syanna_journal", PotP_E_Primary_DLC2, 'q704_ft_syanna_journal');
	catalog.AddNote("poi_bar_a_01_note", PotP_E_Primary_DLC2, 'poi_bar_a_01_note');
	catalog.AddNote("poi_vin_b_05_note", PotP_E_Primary_DLC2, 'poi_vin_b_05_note');
	catalog.AddNote("mh306_tenant_journal", PotP_E_Primary, 'mh306_tenant_journal');
	catalog.AddNote("th1009_journal_wolf_part1a", PotP_E_Primary, 'th1009_journal_wolf_part1a');
	catalog.AddNote("poi_car_b_08_note02", PotP_E_Primary_DLC2, 'poi_car_b_08_note02');
	catalog.AddNote("mq2001_journal_2a", PotP_E_Primary, 'mq2001_journal_2a');
	catalog.AddNote("mq2001_journal_2b", PotP_E_Primary, 'mq2001_journal_2b');
	catalog.AddNote("poi_gor_c_14_note", PotP_E_Primary_DLC2, 'poi_gor_c_14_note');
	catalog.AddNote("poi_bar_b_06_note", PotP_E_Primary_DLC2, 'poi_bar_b_06_note');
	catalog.AddNote("th1003_journal_cat_lady", PotP_E_Primary, 'th1003_journal_cat_lady');
	catalog.AddNote("th701_bear_contract", PotP_E_Primary_DLC2, 'th701_bear_contract');
	catalog.AddNote("ep1_poi_08_note_a", PotP_E_Primary_DLC1, 'ep1_poi_08_note_a');
	catalog.AddNote("th1003_journal_lynx_part4", PotP_E_Primary, 'th1003_journal_lynx_part4');
	catalog.AddNote("poi_san_a_03_note", PotP_E_Primary_DLC2, 'poi_san_a_03_note');
	catalog.AddNote("sq304_ledger_book", PotP_E_Primary, 'sq304_ledger_book');
	catalog.AddNote("sq310_ledger_book", PotP_E_Primary, 'sq310_ledger_book');
	catalog.AddNote("lw_gr_poi_042_letter", PotP_E_Primary, 'lw_gr_poi_042_letter');
	catalog.AddNote("th1001_journal_viper_part2", PotP_E_Primary, 'th1001_journal_viper_part2');
	catalog.AddNote("th701_cat_witcher_notes", PotP_E_Primary_DLC2, 'th701_cat_witcher_notes');
	catalog.AddNote("mq7004_note_01", PotP_E_Primary_DLC2, 'mq7004_note_01');
	catalog.AddNote("th700_prison_note1", PotP_E_Primary_DLC2, 'th700_prison_note1');
	catalog.AddNote("poi_gor_d_05_note", PotP_E_Primary_DLC2, 'poi_gor_d_05_note');
	catalog.AddNote("th1003_journal_lynx_part3", PotP_E_Primary, 'th1003_journal_lynx_part3');
	catalog.AddNote("poi_bar_a_05_note_b", PotP_E_Primary_DLC2, 'poi_bar_a_05_note_b');
	catalog.AddNote("th700_lake_journal", PotP_E_Primary_DLC2, 'th700_lake_journal');
	catalog.AddNote("th700_chapel_journal", PotP_E_Primary_DLC2, 'th700_chapel_journal');
	catalog.AddNote("th700_crypt_journal", PotP_E_Primary_DLC2, 'th700_crypt_journal');
}

function PotP_DefineLibrary_7(catalog: CPotP_Catalog)
{
	catalog.AddNote("th701_gryphon_moreau_journal", PotP_E_Primary_DLC2, 'th701_gryphon_moreau_journal');
	catalog.AddNote("mq3027_fluff_book_1", PotP_E_Primary, 'mq3027_fluff_book_1');
	catalog.AddNote("sq201_ship_manifesto", PotP_E_Primary, 'sq201_ship_manifesto');
	catalog.AddNote("mq3027_my_manifest", PotP_E_Primary, 'mq3027_my_manifest');
	catalog.AddNote("sq701_my_manifest", PotP_E_Primary_DLC2, 'sq701_my_manifest');
	catalog.AddNote("sq202_book_2", PotP_E_Primary, 'sq202_book_2');
	catalog.AddNote("ep1_poi_02_note", PotP_E_Primary_DLC1, 'ep1_poi_02_note');
	catalog.AddNote("q505_nilf_diary_lost2", PotP_E_Primary, 'q505_nilf_diary_lost2');
	catalog.AddNote("q505_nilf_diary_lost1", PotP_E_Primary, 'q505_nilf_diary_lost1');
	catalog.AddNote("q505_nilf_diary_won1", PotP_E_Primary, 'q505_nilf_diary_won1');
	catalog.AddNote("q701_rydygier_book", PotP_E_Primary_DLC2, 'q701_rydygier_book');
	catalog.AddNote("poi_bar_a_01_a_note", PotP_E_Primary_DLC2, 'poi_bar_a_01_a_note');
	catalog.AddNote("q101_candle_instruction", PotP_E_Primary, 'q101_candle_instruction');
	catalog.AddNote("lw_sk_poi_056_note", PotP_E_Primary, 'lw_sk_poi_056_note');
	catalog.AddNote("mq7001_gwent_poems", PotP_E_Primary_DLC2, 'mq7001_gwent_poems');
	catalog.AddNote("q704_ft_little_mermaid", PotP_E_Primary_DLC2, 'q704_ft_little_mermaid');
	catalog.AddNote("q703_killing_vampires", PotP_E_Primary_DLC2, 'q703_killing_vampires');
	catalog.AddNote("mq7004_note_03", PotP_E_Primary_DLC2, 'mq7004_note_03');
	catalog.AddNote("mq1060_armor_osmund_note", PotP_E_Primary, 'mq1060_armor_osmund_note');
	catalog.AddNote("ep1_poi_01_note_02", PotP_E_Primary_DLC1, 'ep1_poi_01_note_02');
	catalog.AddNote("poi_gor_a_10_note", PotP_E_Primary_DLC2, 'poi_gor_a_10_note');
	catalog.AddNote("ep1_poi_14_note_a", PotP_E_Primary_DLC1, 'ep1_poi_14_note_a');
	catalog.AddNote("th1003_journal_lynx_part2", PotP_E_Primary, 'th1003_journal_lynx_part2');
	catalog.AddNote("th700_prison_journal", PotP_E_Primary_DLC2, 'th700_prison_journal');
	catalog.AddNote("mq7023_journal_laura", PotP_E_Primary_DLC2, 'mq7023_journal_laura');
	catalog.AddNote("poi_car_a_05b_note", PotP_E_Primary_DLC2, 'poi_car_a_05b_note');
	catalog.AddNote("q605_scholar_journal", PotP_E_Primary_DLC1, 'q605_scholar_journal');
	catalog.AddNote("th1003_journal_lynx_part1", PotP_E_Primary, 'th1003_journal_lynx_part1');
	catalog.AddNote("mq2049_book_2", PotP_E_Primary, 'mq2049_book_2');
	catalog.AddNote("q311_aen_elle_notes", PotP_E_Primary, 'q311_aen_elle_notes');
	catalog.AddNote("th1003_journal_lynx_part7", PotP_E_Primary, 'th1003_journal_lynx_part7');
	catalog.AddNote("ep1_poi_02b_note", PotP_E_Primary_DLC1, 'ep1_poi_02b_note');
	catalog.AddNote("lw_prologue_temerian_loot_manifest", PotP_E_Primary, 'lw_prologue_temerian_loot_manifest');
	catalog.AddNote("poi_ved_a_03_note", PotP_E_Primary_DLC2, 'poi_ved_a_03_note');
	catalog.AddNote("poi_dun_b_08_note", PotP_E_Primary_DLC2, 'poi_dun_b_08_note');
	catalog.AddNote("poi_car_a_11_note", PotP_E_Primary_DLC2, 'poi_car_a_11_note');
	catalog.AddNote("poi_ved_a_02_note", PotP_E_Primary_DLC2, 'poi_ved_a_02_note');
	catalog.AddNote("poi_bar_b_14_note", PotP_E_Primary_DLC2, 'poi_bar_b_14_note');
	catalog.AddNote("q702_wight_diary", PotP_E_Primary_DLC2, 'q702_wight_diary');
	catalog.AddNote("mq1014_old_mine_journal", PotP_E_Primary, 'mq1014_old_mine_journal');
}

function PotP_DefineLibrary_8(catalog: CPotP_Catalog)
{
	catalog.AddNote("mq7004_storybook", PotP_E_Primary_DLC2, 'mq7004_storybook');
	catalog.AddNote("q210_avallach_lover_notes", PotP_E_Primary, 'q210_avallach_lover_notes');
	catalog.AddNote("q201_wild_hunt_book", PotP_E_Primary, 'q201_wild_hunt_book');
	catalog.AddNote("lw_temerian_soldiers_journal", PotP_E_Primary, 'lw_temerian_soldiers_journal');
	catalog.AddNote("mq2049_book_4", PotP_E_Primary, 'mq2049_book_4');
	catalog.AddNote("mq2049_book_3", PotP_E_Primary, 'mq2049_book_3');
	catalog.AddNote("balaste_book", PotP_E_Primary_DLC2, 'balaste_book');
	catalog.AddNote("th700_vault_journal", PotP_E_Primary_DLC2, 'th700_vault_journal');
	catalog.AddNote("q701_corvo_bianco_book", PotP_E_Primary_DLC2, 'q701_corvo_bianco_book');
	catalog.AddNote("q703_history_of_est_est", PotP_E_Primary_DLC2, 'q703_history_of_est_est');
	catalog.AddNote("q105_book_about_witches", PotP_E_Primary, 'q105_book_about_witches');
	catalog.AddNote("mq7011_bank_book_filler_01", PotP_E_Primary_DLC2, 'mq7011_bank_book_filler_01');
	catalog.AddNote("mq3027_fluff_book_3", PotP_E_Primary, 'mq3027_fluff_book_3');
	catalog.AddNote("q103_curse_book", PotP_E_Primary, 'q103_curse_book');
	catalog.AddNote("mq7011_procedures_book", PotP_E_Primary_DLC2, 'mq7011_procedures_book');
	catalog.AddNote("mq7023_fluff_book_scolopendromorphs", PotP_E_Primary_DLC2, 'mq7023_fluff_book_scolopendromorphs');
	catalog.AddNote("q604_worn_book", PotP_E_Primary_DLC1, 'q604_worn_book');
	catalog.AddNote("ep1_poi_07_note", PotP_E_Primary_DLC1, 'ep1_poi_07_note');
	catalog.AddNote("mq3027_fluff_book_4", PotP_E_Primary, 'mq3027_fluff_book_4');
	catalog.AddNote("q403_treaty", PotP_E_Primary, 'q403_treaty');
	catalog.AddNote("mq1002_aeramas_journal_2", PotP_E_Primary, 'mq1002_aeramas_journal_2');
	catalog.AddNote("q106_alexander_notes_01", PotP_E_Primary, 'q106_alexander_notes_01');
	catalog.AddNote("q106_alexander_notes_02", PotP_E_Primary, 'q106_alexander_notes_02');
	catalog.AddNote("mq2001_journal_1a", PotP_E_Primary, 'mq2001_journal_1a');
	catalog.AddNote("mq2001_journal_1b", PotP_E_Primary, 'mq2001_journal_1b');
	catalog.AddNote("mq2001_journal_1c", PotP_E_Primary, 'mq2001_journal_1c');
	catalog.AddNote("poi_ww_bel_09_note", PotP_E_Primary_DLC2, 'poi_ww_bel_09_note');
	catalog.AddNote("ep1_poi_12_note", PotP_E_Primary_DLC1, 'ep1_poi_12_note');
	catalog.AddNote("mq2049_book_1", PotP_E_Primary, 'mq2049_book_1');
	catalog.AddNote("mq3027_fluff_book_2", PotP_E_Primary, 'mq3027_fluff_book_2');
	catalog.AddNote("q001_academic_book", PotP_E_Primary, 'q001_academic_book');
	catalog.AddNote("poi_ved_a_08_b_note", PotP_E_Primary_DLC2, 'poi_ved_a_08_b_note');
	catalog.AddNote("poi_ved_a_08_note", PotP_E_Primary_DLC2, 'poi_ved_a_08_note');
	catalog.AddNote("th1009_journal_wolf_part2a", PotP_E_Primary, 'th1009_journal_wolf_part2a');
	catalog.AddNote("th1005_journal_gryphon_part2", PotP_E_Primary, 'th1005_journal_gryphon_part2');
	catalog.AddNote("mq7023_fluff_book_mutations", PotP_E_Primary_DLC2, 'mq7023_fluff_book_mutations');
	catalog.AddNote("mq0003_girls_diary", PotP_E_Primary, 'mq0003_girls_diary');
	catalog.AddNote("q201_yen_journal_1", PotP_E_Primary, 'q201_yen_journal_1');
	catalog.AddNote("q401_yen_journal_2", PotP_E_Primary, 'q401_yen_journal_2');
	catalog.AddModBooks(2);
}

function PotP_DefineLibrary_9(catalog: CPotP_Catalog)
{
	catalog.EndSection();
	catalog.BeginLibrarySection("potp_ov_library_letters");
	catalog.AddNote("q705_note_from_sasha1", PotP_E_Primary_DLC2, 'q705_note_from_sasha1');
	catalog.AddNote("q705_note_from_sasha2", PotP_E_Primary_DLC2, 'q705_note_from_sasha2');
	catalog.AddNote("mq3017_reds_diary", PotP_E_Primary, 'mq3017_reds_diary');
	catalog.AddNote("mq3026_horse_racing_leaflet", PotP_E_Primary, 'mq3026_horse_racing_leaflet');
	catalog.AddNote("sq701_anseis_note", PotP_E_Primary_DLC2, 'sq701_anseis_note');
	catalog.AddNote("q601_fluff_sculpture_note", PotP_E_Primary_DLC1, 'q601_fluff_sculpture_note');
	catalog.AddNote("th701_elven_journal", PotP_E_Primary_DLC2, 'th701_elven_journal');
	catalog.AddNote("th1005_journal_gryphon_part3", PotP_E_Primary, 'th1005_journal_gryphon_part3');
	catalog.AddNote("poi_vin_b_06_b", PotP_E_Primary_DLC2, 'poi_vin_b_06_b');
	catalog.AddNote("poi_vin_b_06_note", PotP_E_Primary_DLC2, 'poi_vin_b_06_note');
	catalog.AddNote("lw_gr15_ghouls_note", PotP_E_Primary, 'lw_gr15_ghouls_note');
	catalog.AddNote("ep1_poi_04_note", PotP_E_Primary_DLC1, 'ep1_poi_04_note');
	catalog.AddNote("lw_sb24_note", PotP_E_Primary, 'lw_sb24_note');
	catalog.AddNote("lw_sk86_guards_note", PotP_E_Primary, 'lw_sk86_guards_note');
	catalog.AddNote("q309_note_from_varese", PotP_E_Primary, 'q309_note_from_varese');
	catalog.AddNote("th1010_boots_note", PotP_E_Primary_DLC1, 'th1010_boots_note');
	catalog.AddNote("lw_prologue_fallen_soldier_letter01", PotP_E_Primary, 'lw_prologue_fallen_soldier_letter01');
	catalog.AddNote("q702_marlena_letter", PotP_E_Primary_DLC2, 'q702_marlena_letter');
	catalog.AddNote("lw_sk16_village_note", PotP_E_Primary, 'lw_sk16_village_note');
	catalog.AddNote("ep1_poi_05_02_note", PotP_E_Primary_DLC1, 'ep1_poi_05_02_note');
	catalog.AddNote("poi_ww_cor_03_note", PotP_E_Primary_DLC2, 'poi_ww_cor_03_note');
	catalog.AddNote("q310_explorer_note", PotP_E_Primary, 'q310_explorer_note');
	catalog.AddNote("sq205_brewing_instructions", PotP_E_Primary, 'sq205_brewing_instructions');
	catalog.AddNote("ep1_poi_23_note_b", PotP_E_Primary_DLC1, 'ep1_poi_23_note_b');
	catalog.AddNote("q201_mousesack_letter", PotP_E_Primary, 'q201_mousesack_letter');
	catalog.AddNote("q309_glejt_from_dijkstra", PotP_E_Primary, 'q309_glejt_from_dijkstra');
	catalog.AddNote("mq1060_third_letter", PotP_E_Primary, 'mq1060_third_letter');
	catalog.AddNote("mq1060_first_letter", PotP_E_Primary, 'mq1060_first_letter');
	catalog.AddNote("mq1060_witcher_discarded_note2", PotP_E_Primary, 'mq1060_witcher_discarded_note2');
	catalog.AddNote("poi_ww_belgard_secret_plot_failsafe_note", PotP_E_Primary_DLC2, 'poi_ww_belgard_secret_plot_failsafe_note');
	catalog.AddNote("th701_coward_journal", PotP_E_Primary_DLC2, 'th701_coward_journal');
	catalog.AddNote("sq701_guillaume_note", PotP_E_Primary_DLC2, 'sq701_guillaume_note');
	catalog.AddNote("lw_sk25_bandits_note", PotP_E_Primary, 'lw_sk25_bandits_note');
	catalog.AddNote("q603_roberts_letter", PotP_E_Primary_DLC1, 'q603_roberts_letter');
	catalog.AddNote("gp_prologue_bandit_note02", PotP_E_Primary, 'gp_prologue_bandit_note02');
	catalog.AddNote("q701_gardens_invitation", PotP_E_Primary_DLC2, 'q701_gardens_invitation');
	catalog.AddNote("mq7024_alchemy_lab_note", PotP_E_Primary_DLC2, 'mq7024_alchemy_lab_note');
	catalog.AddNote("mq1060_letter_from_bob", PotP_E_Primary, 'mq1060_letter_from_bob');
}

function PotP_DefineLibrary_10(catalog: CPotP_Catalog)
{
	catalog.AddNote("lw_cp39_captains_log", PotP_E_Primary, 'lw_cp39_captains_log');
	catalog.AddNote("lw_de32_treasure_note", PotP_E_Primary, 'lw_de32_treasure_note');
	catalog.AddNote("lw_gr34_note", PotP_E_Primary, 'lw_gr34_note');
	catalog.AddNote("lw_sb14_fisherman_letter", PotP_E_Primary, 'lw_sb14_fisherman_letter');
	catalog.AddNote("lw_sk_poi_005_treasure_note", PotP_E_Primary, 'lw_sk_poi_005_treasure_note');
	catalog.AddNote("mq7023_letter_yen", PotP_E_Primary_DLC2, 'mq7023_letter_yen');
	catalog.AddNote("q309_key_letters", PotP_E_Primary, 'q309_key_letters');
	catalog.AddNote("poi_ww_bel_05_note", PotP_E_Primary_DLC2, 'poi_ww_bel_05_note');
	catalog.AddNote("ngu_gear_letter_ck", PotP_E_Primary, 'ngu_gear_letter_ck');
	catalog.AddNote("ngu_gear_letter_db", PotP_E_Primary, 'ngu_gear_letter_db');
	catalog.AddNote("mh103_girls_journal", PotP_E_Primary, 'mh103_girls_journal');
	catalog.AddNote("q308_vegelbud_invite", PotP_E_Primary, 'q308_vegelbud_invite');
	catalog.AddNote("q308_last_invite", PotP_E_Primary, 'q308_last_invite');
	catalog.AddNote("q308_priscilla_invite", PotP_E_Primary, 'q308_priscilla_invite');
	catalog.AddNote("mq3027_letter", PotP_E_Primary, 'mq3027_letter');
	catalog.AddNote("mq2037_dimun_directions", PotP_E_Primary, 'mq2037_dimun_directions');
	catalog.AddNote("poi_ww_ver_12_note", PotP_E_Primary_DLC2, 'poi_ww_ver_12_note');
	catalog.AddNote("q304_letter_3", PotP_E_Primary, 'q304_letter_3');
	catalog.AddNote("sq306_sacha_letter", PotP_E_Primary, 'sq306_sacha_letter');
	catalog.AddNote("cg700_letter_monniers_brother", PotP_E_Primary_DLC2, 'cg700_letter_monniers_brother');
	catalog.AddNote("q704_ft_letter_from_dandelion", PotP_E_Primary_DLC2, 'q704_ft_letter_from_dandelion');
	catalog.AddNote("q303_dudus_briefing", PotP_E_Primary, 'q303_dudus_briefing');
	catalog.AddNote("mq7020_letter_to_jl", PotP_E_Primary_DLC2, 'mq7020_letter_to_jl');
	catalog.AddNote("q304_letter_2", PotP_E_Primary, 'q304_letter_2');
	catalog.AddNote("mq7002_love_letter_02", PotP_E_Primary_DLC2, 'mq7002_love_letter_02');
	catalog.AddNote("q308_psycho_farewell", PotP_E_Primary, 'q308_psycho_farewell');
	catalog.AddNote("mq7002_love_letter_01", PotP_E_Primary_DLC2, 'mq7002_love_letter_01');
	catalog.AddNote("mq7020_duvall_poem", PotP_E_Primary_DLC2, 'mq7020_duvall_poem');
	catalog.AddNote("q106_note_from_keira", PotP_E_Primary, 'q106_note_from_keira');
	catalog.AddNote("q603_auction_house_fluff_note_03", PotP_E_Primary_DLC1, 'q603_auction_house_fluff_note_03');
	catalog.AddNote("mq1015_hang_man_note", PotP_E_Primary, 'mq1015_hang_man_note');
	catalog.AddNote("q704_caretakers_letter", PotP_E_Primary_DLC2, 'q704_caretakers_letter');
	catalog.AddNote("q705_regis_reward_letter", PotP_E_Primary_DLC2, 'q705_regis_reward_letter');
	catalog.AddNote("mq1036_refugee_letter", PotP_E_Primary, 'mq1036_refugee_letter');
	catalog.AddNote("mq7023_letter_triss", PotP_E_Primary_DLC2, 'mq7023_letter_triss');
	catalog.AddNote("mq7023_letter_neutral", PotP_E_Primary_DLC2, 'mq7023_letter_neutral');
	catalog.AddNote("q210_letter_for_emhyr", PotP_E_Primary, 'q210_letter_for_emhyr');
	catalog.AddNote("mq2010_lumbermill_journal_3", PotP_E_Primary, 'mq2010_lumbermill_journal_3');
	catalog.AddNote("q304_letter_1", PotP_E_Primary, 'q304_letter_1');
	catalog.AddNote("sq701_fan_02_note", PotP_E_Primary_DLC2, 'sq701_fan_02_note');
}

function PotP_DefineLibrary_11(catalog: CPotP_Catalog)
{
	catalog.AddNote("poi_dun_b_08_note_b", PotP_E_Primary_DLC2, 'poi_dun_b_08_note_b');
	catalog.AddNote("sq701_fan_03_note", PotP_E_Primary_DLC2, 'sq701_fan_03_note');
	catalog.AddNote("lw_sb14_pirate_note", PotP_E_Primary, 'lw_sb14_pirate_note');
	catalog.AddNote("q601_ofir_letter", PotP_E_Primary_DLC1, 'q601_ofir_letter');
	catalog.AddNote("lw_sk86_old_mans_note", PotP_E_Primary, 'lw_sk86_old_mans_note');
	catalog.AddNote("cg700_letter_purist", PotP_E_Primary_DLC2, 'cg700_letter_purist');
	catalog.AddNote("ep1_poi_02c_note", PotP_E_Primary_DLC1, 'ep1_poi_02c_note');
	catalog.AddNote("sq703_hunter_letter", PotP_E_Primary_DLC2, 'sq703_hunter_letter');
	catalog.AddNote("mq4002_note", PotP_E_Primary, 'mq4002_note');
	catalog.AddNote("sq703_wife_letter", PotP_E_Primary_DLC2, 'sq703_wife_letter');
	catalog.AddNote("th1009_sorry_note", PotP_E_Primary, 'th1009_sorry_note');
	catalog.AddNote("sq701_horm_emhyr_dead_note", PotP_E_Primary_DLC2, 'sq701_horm_emhyr_dead_note');
	catalog.AddNote("q103_safe_conduct", PotP_E_Primary, 'q103_safe_conduct');
	catalog.AddNote("poi_ww_vermentino_note_stash", PotP_E_Primary_DLC2, 'poi_ww_vermentino_note_stash');
	catalog.AddNote("sq701_fan_01_note", PotP_E_Primary_DLC2, 'sq701_fan_01_note');
	catalog.AddNote("q705_ah_letter", PotP_E_Primary_DLC2, 'q705_ah_letter');
	catalog.AddNote("mq2048_waxed_letters", PotP_E_Primary, 'mq2048_waxed_letters');
	catalog.AddNote("q104_aleksander_letter", PotP_E_Primary, 'q104_aleksander_letter');
	catalog.AddNote("q206_arnvalds_letter", PotP_E_Primary, 'q206_arnvalds_letter');
	catalog.AddNote("th701_cat_journal", PotP_E_Primary_DLC2, 'th701_cat_journal');
	catalog.AddNote("q303_contact_note", PotP_E_Primary, 'q303_contact_note');
	catalog.AddNote("poi_ww_coronata_note_camp", PotP_E_Primary_DLC2, 'poi_ww_coronata_note_camp');
	catalog.AddNote("q304_priscilla_letter", PotP_E_Primary, 'q304_priscilla_letter');
	catalog.AddNote("sq701_donimir_note", PotP_E_Primary_DLC2, 'sq701_donimir_note');
	catalog.AddNote("mq1058_cat_note", PotP_E_Primary, 'mq1058_cat_note');
	catalog.AddNote("poi_ww_bel_06_note", PotP_E_Primary_DLC2, 'poi_ww_bel_06_note');
	catalog.AddNote("sq701_horm_note", PotP_E_Primary_DLC2, 'sq701_horm_note');
	catalog.AddNote("th1007_journal_bear_part4", PotP_E_Primary, 'th1007_journal_bear_part4');
	catalog.AddNote("poi_gor_b_11_note", PotP_E_Primary_DLC2, 'poi_gor_b_11_note');
	catalog.AddNote("q602_letter_to_olgierd", PotP_E_Primary_DLC1, 'q602_letter_to_olgierd');
	catalog.AddNote("sq701_palmerin_note", PotP_E_Primary_DLC2, 'sq701_palmerin_note');
	catalog.AddNote("poi_san_b_02_note", PotP_E_Primary_DLC2, 'poi_san_b_02_note');
	catalog.AddNote("sq302_philippa_letter", PotP_E_Primary, 'sq302_philippa_letter');
	catalog.AddNote("sq701_rainfarn_note", PotP_E_Primary_DLC2, 'sq701_rainfarn_note');
	catalog.AddNote("sq701_tailles_note", PotP_E_Primary_DLC2, 'sq701_tailles_note');
	catalog.AddNote("q103_letter_from_graden_1", PotP_E_Primary, 'q103_letter_from_graden_1');
	catalog.AddNote("mq2012_letter", PotP_E_Primary, 'mq2012_letter');
	catalog.AddNote("q002_yenn_notes_about_ciri", PotP_E_Primary, 'q002_yenn_notes_about_ciri');
	catalog.AddNote("poi_san_b_05_note", PotP_E_Primary_DLC2, 'poi_san_b_05_note');
	catalog.AddNote("poi_ww_ver_10_note", PotP_E_Primary_DLC2, 'poi_ww_ver_10_note');
}

function PotP_DefineLibrary_12(catalog: CPotP_Catalog)
{
	catalog.AddNote("poi_ved_a_07_note", PotP_E_Primary_DLC2, 'poi_ved_a_07_note');
	catalog.AddNote("ep1_poi_08_note_b", PotP_E_Primary_DLC1, 'ep1_poi_08_note_b');
	catalog.AddNote("mh207_lighthouse_keeper_letter", PotP_E_Primary, 'mh207_lighthouse_keeper_letter');
	catalog.AddNote("q103_about_eve", PotP_E_Primary, 'q103_about_eve');
	catalog.AddNote("q206_arits_letter", PotP_E_Primary, 'q206_arits_letter');
	catalog.AddNote("poi_gor_d_06_note05", PotP_E_Primary_DLC2, 'poi_gor_d_06_note05');
	catalog.AddNote("q702_toy_store_letter", PotP_E_Primary_DLC2, 'q702_toy_store_letter');
	catalog.AddNote("ngu_gear_intro_letter", PotP_E_Primary, 'ngu_gear_intro_letter');
	catalog.AddNote("th1010_armor_note", PotP_E_Primary_DLC1, 'th1010_armor_note');
	catalog.AddNote("th1010_pants_note", PotP_E_Primary_DLC1, 'th1010_pants_note');
	catalog.AddNote("poi_gor_d_06_note", PotP_E_Primary_DLC2, 'poi_gor_d_06_note');
	catalog.AddNote("ep1_poi_05_note", PotP_E_Primary_DLC1, 'ep1_poi_05_note');
	catalog.AddNote("sq106_manuscript", PotP_E_Primary, 'sq106_manuscript');
	catalog.AddNote("q702_victims_names", PotP_E_Primary_DLC2, 'q702_victims_names');
	catalog.AddNote("ep1_poi_32_note", PotP_E_Primary_DLC1, 'ep1_poi_32_note');
	catalog.AddNote("q103_love_letter", PotP_E_Primary, 'q103_love_letter');
	catalog.AddNote("q304_rosa_lover_letter", PotP_E_Primary, 'q304_rosa_lover_letter');
	catalog.AddNote("q603_olgierds_letters", PotP_E_Primary_DLC1, 'q603_olgierds_letters');
	catalog.AddNote("q702_love_letter", PotP_E_Primary_DLC2, 'q702_love_letter');
	catalog.AddNote("q703_napkin_love_letter", PotP_E_Primary_DLC2, 'q703_napkin_love_letter');
	catalog.AddNote("poi_car_b_09_note", PotP_E_Primary_DLC2, 'poi_car_b_09_note');
	catalog.AddNote("poi_ved_a_04_note", PotP_E_Primary_DLC2, 'poi_ved_a_04_note');
	catalog.AddNote("mq2018_lugos_note", PotP_E_Primary, 'mq2018_lugos_note');
	catalog.AddNote("mq2010_lumbermill_journal_2", PotP_E_Primary, 'mq2010_lumbermill_journal_2');
	catalog.AddNote("lw_sk57_treasure_note", PotP_E_Primary, 'lw_sk57_treasure_note');
	catalog.AddNote("mq3026_varese_invitation", PotP_E_Primary, 'mq3026_varese_invitation');
	catalog.AddNote("q308_coroner_msg", PotP_E_Primary, 'q308_coroner_msg');
	catalog.AddNote("q302_igor_note", PotP_E_Primary, 'q302_igor_note');
	catalog.AddNote("sq101_shipment_list", PotP_E_Primary, 'sq101_shipment_list');
	catalog.AddNote("q103_letter_from_graden_2", PotP_E_Primary, 'q103_letter_from_graden_2');
	catalog.AddNote("q302_roche_letter", PotP_E_Primary, 'q302_roche_letter');
	catalog.AddNote("poi_san_b_04_note", PotP_E_Primary_DLC2, 'poi_san_b_04_note');
	catalog.AddNote("q702_tesham_mutna_cell_letter", PotP_E_Primary_DLC2, 'q702_tesham_mutna_cell_letter');
	catalog.AddNote("lw_de_wett_note", PotP_E_Primary, 'lw_de_wett_note');
	catalog.AddNote("mq4003_letter", PotP_E_Primary, 'mq4003_letter');
	catalog.AddNote("poi_car_a_05_note", PotP_E_Primary_DLC2, 'poi_car_a_05_note');
	catalog.AddNote("lw_sk31_note", PotP_E_Primary, 'lw_sk31_note');
	catalog.AddNote("q309_mssg_from_triss", PotP_E_Primary, 'q309_mssg_from_triss');
	catalog.AddNote("ep1_poi_26_note3", PotP_E_Primary_DLC1, 'ep1_poi_26_note3');
	catalog.AddNote("q703_letter_of_refusal", PotP_E_Primary_DLC2, 'q703_letter_of_refusal');
}

function PotP_DefineLibrary_13(catalog: CPotP_Catalog)
{
	catalog.AddNote("mq1060_second_letter", PotP_E_Primary, 'mq1060_second_letter');
	catalog.AddNote("lw_sk32_note", PotP_E_Primary, 'lw_sk32_note');
	catalog.AddNote("mh305_doppler_letter", PotP_E_Primary, 'mh305_doppler_letter');
	catalog.AddNote("sq701_horm_emhyr_victory_note", PotP_E_Primary_DLC2, 'sq701_horm_emhyr_victory_note');
	catalog.AddNote("lw_tm5_villager_note", PotP_E_Primary, 'lw_tm5_villager_note');
	catalog.AddNote("poi_temerian_treasure_note", PotP_E_Primary, 'poi_temerian_treasure_note');
	catalog.AddNote("q603_hoff_letter", PotP_E_Primary_DLC1, 'q603_hoff_letter');
	catalog.AddNote("poi_car_b_10_note", PotP_E_Primary_DLC2, 'poi_car_b_10_note');
	catalog.AddNote("q601_girls_letter", PotP_E_Primary_DLC1, 'q601_girls_letter');
	catalog.AddNote("q702_marlena_father_letter", PotP_E_Primary_DLC2, 'q702_marlena_father_letter');
	catalog.AddNote("q702_blackmail_letter", PotP_E_Primary_DLC2, 'q702_blackmail_letter');
	catalog.AddNote("th1007_journal_bear_part1", PotP_E_Primary, 'th1007_journal_bear_part1');
	catalog.AddNote("mq1060_witcher_discarded_note1", PotP_E_Primary, 'mq1060_witcher_discarded_note1');
	catalog.AddNote("sq701_registration_note", PotP_E_Primary_DLC2, 'sq701_registration_note');
	catalog.AddNote("lw_cp13_refugee_note", PotP_E_Primary, 'lw_cp13_refugee_note');
	catalog.AddNote("lw_gr12_ferry_man_note", PotP_E_Primary, 'lw_gr12_ferry_man_note');
	catalog.AddNote("lw_gr13_slaver_note", PotP_E_Primary, 'lw_gr13_slaver_note');
	catalog.AddNote("lw_gr29_bandit_note", PotP_E_Primary, 'lw_gr29_bandit_note');
	catalog.AddNote("lw_gr40_note", PotP_E_Primary, 'lw_gr40_note');
	catalog.AddNote("lw_sb2_base_camp_note", PotP_E_Primary, 'lw_sb2_base_camp_note');
	catalog.AddNote("lw_sb3_giggler_note_pirates", PotP_E_Primary, 'lw_sb3_giggler_note_pirates');
	catalog.AddNote("lw_sb3_giggler_note_workers", PotP_E_Primary, 'lw_sb3_giggler_note_workers');
	catalog.AddNote("lw_sk4_note", PotP_E_Primary, 'lw_sk4_note');
	catalog.AddNote("lw_tm15_treasure_hunter_note", PotP_E_Primary, 'lw_tm15_treasure_hunter_note');
	catalog.AddNote("mq1055_letters", PotP_E_Primary, 'mq1055_letters');
	catalog.AddNote("poi_gor_b_12_note", PotP_E_Primary_DLC2, 'poi_gor_b_12_note');
	catalog.AddNote("mq7018_workers_letter_basilisk_dead", PotP_E_Primary_DLC2, 'mq7018_workers_letter_basilisk_dead');
	catalog.AddNote("mq7018_workers_letter_basilisk_alive", PotP_E_Primary_DLC2, 'mq7018_workers_letter_basilisk_alive');
	catalog.AddNote("sq701_vivienne_note", PotP_E_Primary_DLC2, 'sq701_vivienne_note');
	catalog.AddNote("q602_letter_from_witold", PotP_E_Primary_DLC1, 'q602_letter_from_witold');
	catalog.AddNote("mq6004_supplier_note", PotP_E_Primary_DLC1, 'mq6004_supplier_note');
	catalog.AddNote("lw_cp33_treasure_note", PotP_E_Primary, 'lw_cp33_treasure_note');
	catalog.AddNote("q602_wedding_invitation", PotP_E_Primary_DLC1, 'q602_wedding_invitation');
	catalog.AddNote("poi_gor_d_18_note", PotP_E_Primary_DLC2, 'poi_gor_d_18_note');
	catalog.AddNote("q302_whoreson_letter_to_radowid", PotP_E_Primary, 'q302_whoreson_letter_to_radowid');
	catalog.AddNote("ep1_poi_10_note", PotP_E_Primary_DLC1, 'ep1_poi_10_note');
	catalog.AddNote("q001_letter_from_yenn", PotP_E_Primary, 'q001_letter_from_yenn');
	catalog.AddModBooks(3);
	catalog.EndSection();
	catalog.BeginLibrarySection("potp_ov_library_notices");
}

function PotP_DefineLibrary_14(catalog: CPotP_Catalog)
{
	catalog.AddNote("mq6005_notice", PotP_E_Primary_DLC1, 'mq6005_notice');
	catalog.AddNote("mq7020_hairdresser_leaflet", PotP_E_Primary_DLC2, 'mq7020_hairdresser_leaflet');
	catalog.AddNote("mq1002_3012_notice", PotP_E_Primary, 'mq1002_3012_notice');
	catalog.AddNote("wine_wars_belgard_notice", PotP_E_Primary_DLC2, 'wine_wars_belgard_notice');
	catalog.AddNote("br202_notice", PotP_E_Primary, 'br202_notice');
	catalog.AddNote("br201_notice", PotP_E_Primary, 'br201_notice');
	catalog.AddNote("br301_notice", PotP_E_Primary, 'br301_notice');
	catalog.AddNote("br302_notice", PotP_E_Primary, 'br302_notice');
	catalog.AddNote("mq7021_left_behind_contract", PotP_E_Primary_DLC2, 'mq7021_left_behind_contract');
	catalog.AddNote("mq1043_notice", PotP_E_Primary, 'mq1043_notice');
	catalog.AddNote("mq1006_notice", PotP_E_Primary, 'mq1006_notice');
	catalog.AddNote("mq1022_notice", PotP_E_Primary, 'mq1022_notice');
	catalog.AddNote("q301_notice_haunted_house", PotP_E_Primary, 'q301_notice_haunted_house');
	catalog.AddNote("q702_fly", PotP_E_Primary_DLC2, 'q702_fly');
	catalog.AddNote("mq0001_contract", PotP_E_Primary, 'mq0001_contract');
	catalog.AddNote("mq1050_notice", PotP_E_Primary, 'mq1050_notice');
	catalog.AddNote("item_name_mq3031_notice", PotP_E_Primary, 'item_name_mq3031_notice');
	catalog.AddNote("mh303_contract", PotP_E_Primary, 'mh303_contract');
	catalog.AddNote("mq7018_contract", PotP_E_Primary_DLC2, 'mq7018_contract');
	catalog.AddNote("mh107_contract", PotP_E_Primary, 'mh107_contract');
	catalog.AddNote("mq6002_contract", PotP_E_Primary_DLC1, 'mq6002_contract');
	catalog.AddNote("mh301_contract", PotP_E_Primary, 'mh301_contract');
	catalog.AddNote("mq0003_contract", PotP_E_Primary, 'mq0003_contract');
	catalog.AddNote("mh302_contract", PotP_E_Primary, 'mh302_contract');
	catalog.AddNote("th701_contract", PotP_E_Primary_DLC2, 'th701_contract');
	catalog.AddNote("mh306_contract", PotP_E_Primary, 'mh306_contract');
	catalog.AddNote("mh305_contract", PotP_E_Primary, 'mh305_contract');
	catalog.AddNote("mh103_contract", PotP_E_Primary, 'mh103_contract');
	catalog.AddNote("q704_ft_goose_contract", PotP_E_Primary_DLC2, 'q704_ft_goose_contract');
	catalog.AddNote("mh201_contract", PotP_E_Primary, 'mh201_contract');
	catalog.AddNote("mh104_contract", PotP_E_Primary, 'mh104_contract');
	catalog.AddNote("mh206_contract", PotP_E_Primary, 'mh206_contract');
	catalog.AddNote("mh108_contract", PotP_E_Primary, 'mh108_contract');
	catalog.AddNote("mh304_contract", PotP_E_Primary, 'mh304_contract');
	catalog.AddNote("sq106_name_ekimma_contract", PotP_E_Primary, 'sq106_name_ekimma_contract');
	catalog.AddNote("mh106_contract", PotP_E_Primary, 'mh106_contract');
	catalog.AddNote("q601_contract", PotP_E_Primary_DLC1, 'q601_contract');
	catalog.AddNote("mh202_contract", PotP_E_Primary, 'mh202_contract');
	catalog.AddNote("item_name_sq201_werewolf_contract", PotP_E_Primary, 'item_name_sq201_werewolf_contract');
	catalog.AddNote("mh203_contract", PotP_E_Primary, 'mh203_contract');
}

function PotP_DefineLibrary_15(catalog: CPotP_Catalog)
{
	catalog.AddNote("mq7010_quarry_contract", PotP_E_Primary_DLC2, 'mq7010_quarry_contract');
	catalog.AddNote("mh210_contract", PotP_E_Primary, 'mh210_contract');
	catalog.AddNote("mq7001_notice", PotP_E_Primary_DLC2, 'mq7001_notice');
	catalog.AddNote("mh101_contract", PotP_E_Primary, 'mh101_contract');
	catalog.AddNote("mq2001_notice_board_holmstein", PotP_E_Primary, 'mq2001_notice_board_holmstein');
	catalog.AddNote("mq2001_notice_board_kaer_trolde", PotP_E_Primary, 'mq2001_notice_board_kaer_trolde');
	catalog.AddNote("mh307_contract", PotP_E_Primary, 'mh307_contract');
	catalog.AddNote("mh701_contract", PotP_E_Primary_DLC2, 'mh701_contract');
	catalog.AddNote("mh207_contract", PotP_E_Primary, 'mh207_contract');
	catalog.AddNote("mh308_contract", PotP_E_Primary, 'mh308_contract');
	catalog.AddNote("sq305_notice", PotP_E_Primary, 'sq305_notice');
	catalog.AddNote("sq204_forest_spirit_contract", PotP_E_Primary, 'sq204_forest_spirit_contract');
	catalog.AddNote("mq1058_contract", PotP_E_Primary, 'mq1058_contract');
	catalog.AddNote("mq7018_guild_contract_letter", PotP_E_Primary_DLC2, 'mq7018_guild_contract_letter');
	catalog.AddNote("poi_bar_b_04_note", PotP_E_Primary_DLC2, 'poi_bar_b_04_note');
	catalog.AddNote("q702_toy_store_closing_order", PotP_E_Primary_DLC2, 'q702_toy_store_closing_order');
	catalog.AddNote("ff100_notice", PotP_E_Primary, 'ff100_notice');
	catalog.AddNote("ff200_notice", PotP_E_Primary, 'ff200_notice');
	catalog.AddNote("ff300_notice", PotP_E_Primary, 'ff300_notice');
	catalog.AddNote("ff701_notice", PotP_E_Primary_DLC2, 'ff701_notice');
	catalog.AddNote("q701_wine_flier_03", PotP_E_Primary_DLC2, 'q701_wine_flier_03');
	catalog.AddNote("q701_wine_flier_01", PotP_E_Primary_DLC2, 'q701_wine_flier_01');
	catalog.AddNote("q701_wine_flier_02", PotP_E_Primary_DLC2, 'q701_wine_flier_02');
	catalog.AddNote("sq108_griffon_contract", PotP_E_Primary, 'sq108_griffon_contract');
	catalog.AddNote("cg_notice_mousesack", PotP_E_Primary, 'cg_notice_mousesack');
	catalog.AddNote("cg_notice_baron", PotP_E_Primary, 'cg_notice_baron');
	catalog.AddNote("cg_notice_stjepan", PotP_E_Primary, 'cg_notice_stjepan');
	catalog.AddNote("cg_notice_vivaldi", PotP_E_Primary, 'cg_notice_vivaldi');
	catalog.AddNote("cg_notice_sq306_maverick", PotP_E_Primary, 'cg_notice_sq306_maverick');
	catalog.AddNote("hr101_notice", PotP_E_Primary, 'hr101_notice');
	catalog.AddNote("q604_paper_shred1", PotP_E_Primary_DLC1, 'q604_paper_shred1');
	catalog.AddNote("mh301_merc_contract", PotP_E_Primary, 'mh301_merc_contract');
	catalog.AddNote("sq104_werewolf", PotP_E_Primary, 'sq104_werewolf');
	catalog.AddNote("mh102_contract", PotP_E_Primary, 'mh102_contract');
	catalog.AddNote("sq102_contract", PotP_E_Primary, 'sq102_contract');
	catalog.AddNote("q601_fluff_note_three", PotP_E_Primary_DLC1, 'q601_fluff_note_three');
	catalog.AddNote("mq7004_notice", PotP_E_Primary_DLC2, 'mq7004_notice');
	catalog.AddNote("mq2030_nithing", PotP_E_Primary, 'mq2030_nithing');
	catalog.AddNote("poi_bandit_camp_3_note", PotP_E_Primary, 'poi_bandit_camp_3_note');
	catalog.AddNote("item_name_mq1051_contract", PotP_E_Primary, 'item_name_mq1051_contract');
}

function PotP_DefineLibrary_16(catalog: CPotP_Catalog)
{
	catalog.AddNote("item_name_sq210_notice", PotP_E_Primary, 'item_name_sq210_notice');
	catalog.AddNote("mq1011_notice", PotP_E_Primary, 'mq1011_notice');
	catalog.AddNote("hr200_notice", PotP_E_Primary, 'hr200_notice');
	catalog.AddNote("mq1016_notice", PotP_E_Primary, 'mq1016_notice');
	catalog.AddNote("mq7006_notice", PotP_E_Primary_DLC2, 'mq7006_notice');
	catalog.AddNote("cg700_tournament", PotP_E_Primary_DLC2, 'cg700_tournament');
	catalog.AddNote("mq7023_contract", PotP_E_Primary_DLC2, 'mq7023_contract');
	catalog.AddNote("q601_fluff_note_two", PotP_E_Primary_DLC1, 'q601_fluff_note_two');
	catalog.AddNote("mq7015_contract", PotP_E_Primary_DLC2, 'mq7015_contract');
	catalog.AddNote("sq703_contract", PotP_E_Primary_DLC2, 'sq703_contract');
	catalog.AddNote("q601_fluff_note_one", PotP_E_Primary_DLC1, 'q601_fluff_note_one');
	catalog.AddNote("mq2052_contract", PotP_E_Primary, 'mq2052_contract');
	catalog.AddNote("mq1013_notice", PotP_E_Primary, 'mq1013_notice');
	catalog.AddModBooks(4);
	catalog.EndSection();
	catalog.BeginLibrarySection("potp_ov_library_notes");
	catalog.AddNote("q305_script_comedy_title1", PotP_E_Primary, 'q305_script_comedy_title1');
	catalog.AddNote("q305_script_drama_title1", PotP_E_Primary, 'q305_script_drama_title1');
	catalog.AddNote("q701_fisherman_poetry", PotP_E_Primary_DLC2, 'q701_fisherman_poetry');
	catalog.AddNote("q702_knight_oath", PotP_E_Primary_DLC2, 'q702_knight_oath');
	catalog.AddNote("lw_sk38_treasure_note", PotP_E_Primary, 'lw_sk38_treasure_note');
	catalog.AddNote("q103_tamara_prayer", PotP_E_Primary, 'q103_tamara_prayer');
	catalog.AddNote("th1003_map_lynx_upgrade1a", PotP_E_Primary, 'th1003_map_lynx_upgrade1a');
	catalog.AddNote("th1003_map_lynx_upgrade3", PotP_E_Primary, 'th1003_map_lynx_upgrade3');
	catalog.AddNote("th1003_map_lynx_upgrade1b", PotP_E_Primary, 'th1003_map_lynx_upgrade1b');
	catalog.AddNote("th1003_map_lynx_upgrade2", PotP_E_Primary, 'th1003_map_lynx_upgrade2');
	catalog.AddNote("th1005_journal_gryphon_part4", PotP_E_Primary, 'th1005_journal_gryphon_part4');
	catalog.AddNote("q104_avallach_poetry", PotP_E_Primary, 'q104_avallach_poetry');
	catalog.AddNote("lw_gf2_white_note", PotP_E_Primary, 'lw_gf2_white_note');
	catalog.AddNote("q109_popiels_formula", PotP_E_Primary, 'q109_popiels_formula');
	catalog.AddNote("gp_prologue_bandit_note01", PotP_E_Primary, 'gp_prologue_bandit_note01');
	catalog.AddNote("q701_nml_notice", PotP_E_Primary_DLC2, 'q701_nml_notice');
	catalog.AddNote("ep1_poi_30_note", PotP_E_Primary_DLC1, 'ep1_poi_30_note');
	catalog.AddNote("th1010_schematic_armor", PotP_E_Primary_DLC1, 'th1010_schematic_armor');
	catalog.AddNote("th1007_journal_bear_part5", PotP_E_Primary, 'th1007_journal_bear_part5');
	catalog.AddNote("th1007_journal_bear_part6", PotP_E_Primary, 'th1007_journal_bear_part6');
	catalog.AddNote("q302_crafter_notes", PotP_E_Primary, 'q302_crafter_notes');
	catalog.AddNote("lw_cb17_bandits_note", PotP_E_Primary, 'lw_cb17_bandits_note');
	catalog.AddNote("lw_cp13_bandit_note", PotP_E_Primary, 'lw_cp13_bandit_note');
	catalog.AddNote("lw_hs2_bandit_note", PotP_E_Primary, 'lw_hs2_bandit_note');
}

function PotP_DefineLibrary_17(catalog: CPotP_Catalog)
{
	catalog.AddNote("q702_cage_breeding_humans", PotP_E_Primary_DLC2, 'q702_cage_breeding_humans');
	catalog.AddNote("mq4005_note_1", PotP_E_Primary, 'mq4005_note_1');
	catalog.AddNote("q110_bill_of_exchange", PotP_E_Primary, 'q110_bill_of_exchange');
	catalog.AddNote("q702_regis_biography", PotP_E_Primary_DLC2, 'q702_regis_biography');
	catalog.AddNote("lw_tm_underwater_dungeon_note", PotP_E_Primary, 'lw_tm_underwater_dungeon_note');
	catalog.AddNote("lw_gr39_note", PotP_E_Primary, 'lw_gr39_note');
	catalog.AddNote("mq7010_still_note", PotP_E_Primary_DLC2, 'mq7010_still_note');
	catalog.AddNote("th1010_schematic_boots", PotP_E_Primary_DLC1, 'th1010_schematic_boots');
	catalog.AddNote("mq0004_burnt_papers", PotP_E_Primary, 'mq0004_burnt_papers');
	catalog.AddNote("camm_poi_bar_a_12", PotP_E_Primary_DLC2, 'camm_poi_bar_a_12');
	catalog.AddNote("camm_poi_gor_a_09", PotP_E_Primary_DLC2, 'camm_poi_gor_a_09');
	catalog.AddNote("camm_poi_gor_d_07", PotP_E_Primary_DLC2, 'camm_poi_gor_d_07');
	catalog.AddNote("camm_poi_bar_b_04", PotP_E_Primary_DLC2, 'camm_poi_bar_b_04');
	catalog.AddNote("camm_poi_gor_b_12", PotP_E_Primary_DLC2, 'camm_poi_gor_b_12');
	catalog.AddNote("camm_poi_gor_c_03", PotP_E_Primary_DLC2, 'camm_poi_gor_c_03');
	catalog.AddNote("camm_poi_gor_d_06", PotP_E_Primary_DLC2, 'camm_poi_gor_d_06');
	catalog.AddNote("camm_poi_bar_a_03", PotP_E_Primary_DLC2, 'camm_poi_bar_a_03');
	catalog.AddNote("camm_poi_car_b_03", PotP_E_Primary_DLC2, 'camm_poi_car_b_03');
	catalog.AddNote("camm_poi_ved_a_05", PotP_E_Primary_DLC2, 'camm_poi_ved_a_05');
	catalog.AddNote("camm_poi_ved_a_02", PotP_E_Primary_DLC2, 'camm_poi_ved_a_02');
	catalog.AddNote("camm_poi_ved_a_01", PotP_E_Primary_DLC2, 'camm_poi_ved_a_01');
	catalog.AddNote("camm_poi_bar_a_02", PotP_E_Primary_DLC2, 'camm_poi_bar_a_02');
	catalog.AddNote("camm_poi_bar_a_01", PotP_E_Primary_DLC2, 'camm_poi_bar_a_01');
	catalog.AddNote("th701_gryphon_moreau_letter", PotP_E_Primary_DLC2, 'th701_gryphon_moreau_letter');
	catalog.AddNote("q210_avallach_notes_02", PotP_E_Primary, 'q210_avallach_notes_02');
	catalog.AddNote("q302_zdenek_contract", PotP_E_Primary, 'q302_zdenek_contract');
	catalog.AddNote("q702_vampire_set_note", PotP_E_Primary_DLC2, 'q702_vampire_set_note');
	catalog.AddNote("th1007_journal_bear_part7", PotP_E_Primary, 'th1007_journal_bear_part7');
	catalog.AddNote("mq7011_bank_flier_02", PotP_E_Primary_DLC2, 'mq7011_bank_flier_02');
	catalog.AddNote("q701_unicorn_item", PotP_E_Primary_DLC2, 'q701_unicorn_item');
	catalog.AddNote("poi_gor_d_17_note", PotP_E_Primary_DLC2, 'poi_gor_d_17_note');
	catalog.AddNote("q308_sermon_1", PotP_E_Primary, 'q308_sermon_1');
	catalog.AddNote("q308_sermon_2", PotP_E_Primary, 'q308_sermon_2');
	catalog.AddNote("q308_sermon_3", PotP_E_Primary, 'q308_sermon_3');
	catalog.AddNote("q308_sermon_4", PotP_E_Primary, 'q308_sermon_4');
	catalog.AddNote("q308_sermon_5", PotP_E_Primary, 'q308_sermon_5');
	catalog.AddNote("th700_lake_fluff_note2", PotP_E_Primary_DLC2, 'th700_lake_fluff_note2');
	catalog.AddNote("th700_prison_note3", PotP_E_Primary_DLC2, 'th700_prison_note3');
	catalog.AddNote("ep1_poi_26_note_b", PotP_E_Primary_DLC1, 'ep1_poi_26_note_b');
	catalog.AddNote("poi_car_a_11_c_note", PotP_E_Primary_DLC2, 'poi_car_a_11_c_note');
}

function PotP_DefineLibrary_18(catalog: CPotP_Catalog)
{
	catalog.AddNote("q701_crayfish_soup_recipe", PotP_E_Primary_DLC2, 'q701_crayfish_soup_recipe');
	catalog.AddNote("q701_1st_victim_files", PotP_E_Primary_DLC2, 'q701_1st_victim_files');
	catalog.AddNote("lw_bm6_merchant_note", PotP_E_Primary, 'lw_bm6_merchant_note');
	catalog.AddNote("lw_de11_note", PotP_E_Primary, 'lw_de11_note');
	catalog.AddNote("lw_gr41_note", PotP_E_Primary, 'lw_gr41_note');
	catalog.AddNote("gp_prologue_cultist_note01", PotP_E_Primary, 'gp_prologue_cultist_note01');
	catalog.AddNote("gp_prologue_cultist_note02", PotP_E_Primary, 'gp_prologue_cultist_note02');
	catalog.AddNote("th1009_map_wolf_upgrade2", PotP_E_Primary, 'th1009_map_wolf_upgrade2');
	catalog.AddNote("q701_3rd_victim_files", PotP_E_Primary_DLC2, 'q701_3rd_victim_files');
	catalog.AddNote("q701_corvo_bianco_deed", PotP_E_Primary_DLC2, 'q701_corvo_bianco_deed');
	catalog.AddNote("q304_ambasador_letter", PotP_E_Primary, 'q304_ambasador_letter');
	catalog.AddNote("q301_drawing_crib", PotP_E_Primary, 'q301_drawing_crib');
	catalog.AddNote("q301_drawing_oven", PotP_E_Primary, 'q301_drawing_oven');
	catalog.AddNote("mq1001_locker_diary", PotP_E_Primary, 'mq1001_locker_diary');
	catalog.AddNote("ep1_poi_01_note", PotP_E_Primary_DLC1, 'ep1_poi_01_note');
	catalog.AddNote("th1005_map_gryphon_upgrade1a", PotP_E_Primary, 'th1005_map_gryphon_upgrade1a');
	catalog.AddNote("th1005_map_gryphon_upgrade3", PotP_E_Primary, 'th1005_map_gryphon_upgrade3');
	catalog.AddNote("th1005_map_gryphon_upgrade1b", PotP_E_Primary, 'th1005_map_gryphon_upgrade1b');
	catalog.AddNote("th1005_map_gryphon_upgrade2", PotP_E_Primary, 'th1005_map_gryphon_upgrade2');
	catalog.AddNote("ep1_poi_16_note", PotP_E_Primary_DLC1, 'ep1_poi_16_note');
	catalog.AddNote("poi_bar_a_12_note", PotP_E_Primary_DLC2, 'poi_bar_a_12_note');
	catalog.AddNote("ep1_poi_13_note", PotP_E_Primary_DLC1, 'ep1_poi_13_note');
	catalog.AddNote("mq1060_priest_notes", PotP_E_Primary, 'mq1060_priest_notes');
	catalog.AddNote("q104_cure_recipe", PotP_E_Primary, 'q104_cure_recipe');
	catalog.AddNote("q703_piece_of_scenario", PotP_E_Primary_DLC2, 'q703_piece_of_scenario');
	catalog.AddNote("th1010_schematic_gloves", PotP_E_Primary_DLC1, 'th1010_schematic_gloves');
	catalog.AddNote("poi_bar_a_08_note", PotP_E_Primary_DLC2, 'poi_bar_a_08_note');
	catalog.AddNote("mq7020_hairdresser_recipe", PotP_E_Primary_DLC2, 'mq7020_hairdresser_recipe');
	catalog.AddNote("th701_cat_notes", PotP_E_Primary_DLC2, 'th701_cat_notes');
	catalog.AddNote("q701_pate_recipe", PotP_E_Primary_DLC2, 'q701_pate_recipe');
	catalog.AddNote("th1009_map_wolf_upgrade2b", PotP_E_Primary, 'th1009_map_wolf_upgrade2b');
	catalog.AddNote("th1009_journal_wolf_part3a", PotP_E_Primary, 'th1009_journal_wolf_part3a');
	catalog.AddNote("lw_cp14_bandit_note", PotP_E_Primary, 'lw_cp14_bandit_note');
	catalog.AddNote("lw_tm12_bandit_note", PotP_E_Primary, 'lw_tm12_bandit_note');
	catalog.AddNote("poi_car_a_11_b_note", PotP_E_Primary_DLC2, 'poi_car_a_11_b_note');
	catalog.AddNote("q702_breeding_humans", PotP_E_Primary_DLC2, 'q702_breeding_humans');
	catalog.AddNote("th1007_map_bear_upgrade1a", PotP_E_Primary, 'th1007_map_bear_upgrade1a');
	catalog.AddNote("th1007_map_bear_upgrade3", PotP_E_Primary, 'th1007_map_bear_upgrade3');
	catalog.AddNote("th1007_map_bear_upgrade1b", PotP_E_Primary, 'th1007_map_bear_upgrade1b');
	catalog.AddNote("th1007_map_bear_upgrade2", PotP_E_Primary, 'th1007_map_bear_upgrade2');
}

function PotP_DefineLibrary_19(catalog: CPotP_Catalog)
{
	catalog.AddNote("cg700_letter_merchants", PotP_E_Primary_DLC2, 'cg700_letter_merchants');
	catalog.AddNote("q302_dijkstras_notes", PotP_E_Primary, 'q302_dijkstras_notes');
	catalog.AddNote("th1007_journal_bear_part2", PotP_E_Primary, 'th1007_journal_bear_part2');
	catalog.AddNote("lw_sk30_villager_note", PotP_E_Primary, 'lw_sk30_villager_note');
	catalog.AddNote("th700_lake_fluff_note1", PotP_E_Primary_DLC2, 'th700_lake_fluff_note1');
	catalog.AddNote("poi_ww_bel_08_note", PotP_E_Primary_DLC2, 'poi_ww_bel_08_note');
	catalog.AddNote("poi_ww_cor_02_note", PotP_E_Primary_DLC2, 'poi_ww_cor_02_note');
	catalog.AddNote("q310_journal_notes_2", PotP_E_Primary, 'q310_journal_notes_2');
	catalog.AddNote("q302_rico_thugs_notes", PotP_E_Primary, 'q302_rico_thugs_notes');
	catalog.AddNote("q603_auction_house_fluff_note_01", PotP_E_Primary_DLC1, 'q603_auction_house_fluff_note_01');
	catalog.AddNote("q602_wedding_expenses_list", PotP_E_Primary_DLC1, 'q602_wedding_expenses_list');
	catalog.AddNote("q602_wedding_guests_list", PotP_E_Primary_DLC1, 'q602_wedding_guests_list');
	catalog.AddNote("ep1_poi_35_note", PotP_E_Primary_DLC1, 'ep1_poi_35_note');
	catalog.AddNote("sq102_loose_papers", PotP_E_Primary, 'sq102_loose_papers');
	catalog.AddNote("ep1_poi_20_note", PotP_E_Primary_DLC1, 'ep1_poi_20_note');
	catalog.AddNote("q704_mages_notes_01", PotP_E_Primary_DLC2, 'q704_mages_notes_01');
	catalog.AddNote("q704_mages_notes_02", PotP_E_Primary_DLC2, 'q704_mages_notes_02');
	catalog.AddNote("lw_tm6_note", PotP_E_Primary, 'lw_tm6_note');
	catalog.AddNote("ep1_poi_23_note_a", PotP_E_Primary_DLC1, 'ep1_poi_23_note_a');
	catalog.AddNote("q303_marked_bible", PotP_E_Primary, 'q303_marked_bible');
	catalog.AddNote("q702_leaflet", PotP_E_Primary_DLC2, 'q702_leaflet');
	catalog.AddNote("mq4006_book", PotP_E_Primary, 'mq4006_book');
	catalog.AddNote("q308_anneke_invite", PotP_E_Primary, 'q308_anneke_invite');
	catalog.AddNote("q702_regis_sentences", PotP_E_Primary_DLC2, 'q702_regis_sentences');
	catalog.AddNote("mq2006_map_1", PotP_E_Primary, 'mq2006_map_1');
	catalog.AddNote("mq2006_map_2", PotP_E_Primary, 'mq2006_map_2');
	catalog.AddNote("lw_sk41_prison_island_note", PotP_E_Primary, 'lw_sk41_prison_island_note');
	catalog.AddNote("q303_note_for_ciri", PotP_E_Primary, 'q303_note_for_ciri');
	catalog.AddNote("sq104_notes", PotP_E_Primary, 'sq104_notes');
	catalog.AddNote("th1003_journal_lynx_part8", PotP_E_Primary, 'th1003_journal_lynx_part8');
	catalog.AddNote("q308_nathanel_sermon_1", PotP_E_Primary, 'q308_nathanel_sermon_1');
	catalog.AddNote("q105_marabella_receptions", PotP_E_Primary, 'q105_marabella_receptions');
	catalog.AddNote("q103_nilfgaardian_demand", PotP_E_Primary, 'q103_nilfgaardian_demand');
	catalog.AddNote("lw_gr7_soldiers_note", PotP_E_Primary, 'lw_gr7_soldiers_note');
	catalog.AddNote("lw_sk42_treasure_note", PotP_E_Primary, 'lw_sk42_treasure_note');
	catalog.AddNote("q601_girls_letter_two", PotP_E_Primary_DLC1, 'q601_girls_letter_two');
	catalog.AddNote("mq1060_about_riot_notes", PotP_E_Primary, 'mq1060_about_riot_notes');
	catalog.AddNote("mq3002_hidden_messages_note_01", PotP_E_Primary, 'mq3002_hidden_messages_note_01');
	catalog.AddNote("mq3002_hidden_messages_note_02", PotP_E_Primary, 'mq3002_hidden_messages_note_02');
	catalog.AddNote("mq3002_hidden_messages_note_03", PotP_E_Primary, 'mq3002_hidden_messages_note_03');
}

function PotP_DefineLibrary_20(catalog: CPotP_Catalog)
{
	catalog.AddNote("th700_lake_fluff_note3", PotP_E_Primary_DLC2, 'th700_lake_fluff_note3');
	catalog.AddNote("poi_bar_a_05_note", PotP_E_Primary_DLC2, 'poi_bar_a_05_note');
	catalog.AddNote("poi_bar_a_01_b_note", PotP_E_Primary_DLC2, 'poi_bar_a_01_b_note');
	catalog.AddNote("q705_prison_stash_note", PotP_E_Primary_DLC2, 'q705_prison_stash_note');
	catalog.AddNote("ep1_poi_25_note", PotP_E_Primary_DLC1, 'ep1_poi_25_note');
	catalog.AddNote("th700_prison_note2", PotP_E_Primary_DLC2, 'th700_prison_note2');
	catalog.AddNote("mq2015_kurisus_note", PotP_E_Primary, 'mq2015_kurisus_note');
	catalog.AddNote("th1009_map_wolf_upgrade3b", PotP_E_Primary, 'th1009_map_wolf_upgrade3b');
	catalog.AddNote("th701_gryphon_jerome_letter", PotP_E_Primary_DLC2, 'th701_gryphon_jerome_letter');
	catalog.AddNote("th1009_journal_wolf_part4", PotP_E_Primary, 'th1009_journal_wolf_part4');
	catalog.AddNote("q705_note_ab_syanna", PotP_E_Primary_DLC2, 'q705_note_ab_syanna');
	catalog.AddNote("ep1_poi_12_note_b", PotP_E_Primary_DLC1, 'ep1_poi_12_note_b');
	catalog.AddNote("lw_gr15_bandits_note", PotP_E_Primary, 'lw_gr15_bandits_note');
	catalog.AddNote("poi_vin_b_04_note", PotP_E_Primary_DLC2, 'poi_vin_b_04_note');
	catalog.AddNote("ep1_poi_04_note_b", PotP_E_Primary_DLC1, 'ep1_poi_04_note_b');
	catalog.AddNote("poi_gor_d_07_note", PotP_E_Primary_DLC2, 'poi_gor_d_07_note');
	catalog.AddNote("ep1_poi_14_note_b", PotP_E_Primary_DLC1, 'ep1_poi_14_note_b');
	catalog.AddNote("q702_mill_order", PotP_E_Primary_DLC2, 'q702_mill_order');
	catalog.AddNote("poi_ved_a_05_note", PotP_E_Primary_DLC2, 'poi_ved_a_05_note');
	catalog.AddNote("poi_car_b_08_note", PotP_E_Primary_DLC2, 'poi_car_b_08_note');
	catalog.AddNote("sq106_hammond_whereabouts", PotP_E_Primary, 'sq106_hammond_whereabouts');
	catalog.AddNote("poi_car_b_10_note_02", PotP_E_Primary_DLC2, 'poi_car_b_10_note_02');
	catalog.AddNote("poi_gor_d_17_note_b", PotP_E_Primary_DLC2, 'poi_gor_d_17_note_b');
	catalog.AddNote("poi_gor_d_06_note04", PotP_E_Primary_DLC2, 'poi_gor_d_06_note04');
	catalog.AddNote("poi_gor_a_09_note", PotP_E_Primary_DLC2, 'poi_gor_a_09_note');
	catalog.AddNote("poi_ww_coronata_note_stash", PotP_E_Primary_DLC2, 'poi_ww_coronata_note_stash');
	catalog.AddNote("poi_bar_a_10_note", PotP_E_Primary_DLC2, 'poi_bar_a_10_note');
	catalog.AddNote("poi_bar_a_11_note", PotP_E_Primary_DLC2, 'poi_bar_a_11_note');
	catalog.AddNote("mq6004_broken_rose_orders", PotP_E_Primary_DLC1, 'mq6004_broken_rose_orders');
	catalog.AddNote("poi_bar_a_03_note", PotP_E_Primary_DLC2, 'poi_bar_a_03_note');
	catalog.AddNote("lw_sb18_camps_note", PotP_E_Primary, 'lw_sb18_camps_note');
	catalog.AddNote("lw_sb12_pirate_note", PotP_E_Primary, 'lw_sb12_pirate_note');
	catalog.AddNote("lw_sb2_sunken_ships_note", PotP_E_Primary, 'lw_sb2_sunken_ships_note');
	catalog.AddNote("lw_sb3_camps_note", PotP_E_Primary, 'lw_sb3_camps_note');
	catalog.AddNote("noon_shadow_loot_note", PotP_E_Primary, 'noon_shadow_loot_note');
	catalog.AddNote("q602_shani_prescription", PotP_E_Primary_DLC1, 'q602_shani_prescription');
	catalog.AddNote("q702_bootblack_prices", PotP_E_Primary_DLC2, 'q702_bootblack_prices');
	catalog.AddNote("q702_comissariat", PotP_E_Primary_DLC2, 'q702_comissariat');
	catalog.AddNote("mq1051_orders_note", PotP_E_Primary, 'mq1051_orders_note');
	catalog.AddNote("ep1_poi_11_note", PotP_E_Primary_DLC1, 'ep1_poi_11_note');
}

function PotP_DefineLibrary_21(catalog: CPotP_Catalog)
{
	catalog.AddNote("poi_gor_d_19_note", PotP_E_Primary_DLC2, 'poi_gor_d_19_note');
	catalog.AddNote("q701_2nd_victim_files", PotP_E_Primary_DLC2, 'q701_2nd_victim_files');
	catalog.AddNote("lw_sb5_giggler_leader_note", PotP_E_Primary, 'lw_sb5_giggler_leader_note');
	catalog.AddNote("poi_car_a_11_a_note", PotP_E_Primary_DLC2, 'poi_car_a_11_a_note');
	catalog.AddNote("q104_eye_ink_recipe", PotP_E_Primary, 'q104_eye_ink_recipe');
	catalog.AddNote("poi_bar_a_13_note", PotP_E_Primary_DLC2, 'poi_bar_a_13_note');
	catalog.AddNote("ep1_poi_17_note", PotP_E_Primary_DLC1, 'ep1_poi_17_note');
	catalog.AddNote("q601_redanian_orders", PotP_E_Primary_DLC1, 'q601_redanian_orders');
	catalog.AddNote("q702_regeneration_elixir", PotP_E_Primary_DLC2, 'q702_regeneration_elixir');
	catalog.AddNote("mq1060_note_ab_plague_victims", PotP_E_Primary, 'mq1060_note_ab_plague_victims');
	catalog.AddNote("q210_avallach_notes_01", PotP_E_Primary, 'q210_avallach_notes_01');
	catalog.AddNote("mq7004_note_02", PotP_E_Primary_DLC2, 'mq7004_note_02');
	catalog.AddNote("q302_roche_report", PotP_E_Primary, 'q302_roche_report');
	catalog.AddNote("q603_auction_house_fluff_note_02", PotP_E_Primary_DLC1, 'q603_auction_house_fluff_note_02');
	catalog.AddNote("cg300_roches_list", PotP_E_Primary, 'cg300_roches_list');
	catalog.AddNote("q104_avallach_notes", PotP_E_Primary, 'q104_avallach_notes');
	catalog.AddNote("poi_gor_b_13_note", PotP_E_Primary_DLC2, 'poi_gor_b_13_note');
	catalog.AddNote("mq2010_lumbermill_journal_1", PotP_E_Primary, 'mq2010_lumbermill_journal_1');
	catalog.AddNote("lw_hs2_scoiatael_note", PotP_E_Primary, 'lw_hs2_scoiatael_note');
	catalog.AddNote("gp_prologue_bandit_note03", PotP_E_Primary, 'gp_prologue_bandit_note03');
	catalog.AddNote("sq303_robbery_speech", PotP_E_Primary, 'sq303_robbery_speech');
	catalog.AddNote("poi_gor_d_06_note03", PotP_E_Primary_DLC2, 'poi_gor_d_06_note03');
	catalog.AddNote("th1009_map_wolf_upgrade1b", PotP_E_Primary, 'th1009_map_wolf_upgrade1b');
	catalog.AddNote("poi_car_a_07_note", PotP_E_Primary_DLC2, 'poi_car_a_07_note');
	catalog.AddNote("lw_sb13_smugglers_note", PotP_E_Primary, 'lw_sb13_smugglers_note');
	catalog.AddNote("lw_cp14_child_note", PotP_E_Primary, 'lw_cp14_child_note');
	catalog.AddNote("q602_wedding_songs_list", PotP_E_Primary_DLC1, 'q602_wedding_songs_list');
	catalog.AddNote("poi_bar_a_09_note", PotP_E_Primary_DLC2, 'poi_bar_a_09_note');
	catalog.AddNote("q702_spoon_key_message", PotP_E_Primary_DLC2, 'q702_spoon_key_message');
	catalog.AddNote("poi_telescope_note", PotP_E_Primary, 'poi_telescope_note');
	catalog.AddNote("poi_ved_a_06_note", PotP_E_Primary_DLC2, 'poi_ved_a_06_note');
	catalog.AddNote("poi_ww_belgard_secret_plot_proper_note", PotP_E_Primary_DLC2, 'poi_ww_belgard_secret_plot_proper_note');
	catalog.AddNote("mh701_wine_list", PotP_E_Primary_DLC2, 'mh701_wine_list');
	catalog.AddNote("lw_sb20_chest_note", PotP_E_Primary, 'lw_sb20_chest_note');
	catalog.AddNote("q701_duchess_summons", PotP_E_Primary_DLC2, 'q701_duchess_summons');
	catalog.AddNote("mq6003_tax_bill", PotP_E_Primary_DLC1, 'mq6003_tax_bill');
	catalog.AddNote("poi_bar_a_10b_note", PotP_E_Primary_DLC2, 'poi_bar_a_10b_note');
	catalog.AddNote("mq7011_bank_flier_01", PotP_E_Primary_DLC2, 'mq7011_bank_flier_01');
	catalog.AddNote("mq6003_certificate_of_citizenship", PotP_E_Primary_DLC1, 'mq6003_certificate_of_citizenship');
	catalog.AddNote("th1007_journal_bear_part3", PotP_E_Primary, 'th1007_journal_bear_part3');
}

function PotP_DefineLibrary_22(catalog: CPotP_Catalog)
{
	catalog.AddNote("q201_criminal", PotP_E_Primary, 'q201_criminal');
	catalog.AddNote("q305_script_comedy_title2", PotP_E_Primary, 'q305_script_comedy_title2');
	catalog.AddNote("q305_script_drama_title2", PotP_E_Primary, 'q305_script_drama_title2');
	catalog.AddNote("mq7017_pinastri_note", PotP_E_Primary_DLC2, 'mq7017_pinastri_note');
	catalog.AddNote("an_skellige_map", PotP_E_Primary, 'an_skellige_map');
	catalog.AddNote("ard_skellige_map", PotP_E_Primary, 'ard_skellige_map');
	catalog.AddNote("faroe_map", PotP_E_Primary, 'faroe_map');
	catalog.AddNote("hindarsfjal_map", PotP_E_Primary, 'hindarsfjal_map');
	catalog.AddNote("spikeroog_map", PotP_E_Primary, 'spikeroog_map');
	catalog.AddNote("undvik_map", PotP_E_Primary, 'undvik_map');
	catalog.AddNote("q201_poisoned_source", PotP_E_Primary, 'q201_poisoned_source');
	catalog.AddNote("cg100_barons_notes", PotP_E_Primary, 'cg100_barons_notes');
	catalog.AddNote("mq1033_fight_diary", PotP_E_Primary, 'mq1033_fight_diary');
	catalog.AddNote("lw_sk_poi_050_note", PotP_E_Primary, 'lw_sk_poi_050_note');
	catalog.AddNote("lw_mp4_merchant_note", PotP_E_Primary, 'lw_mp4_merchant_note');
	catalog.AddNote("q702_vampire_transcript", PotP_E_Primary_DLC2, 'q702_vampire_transcript');
	catalog.AddNote("mq1023_fake_papers", PotP_E_Primary, 'mq1023_fake_papers');
	catalog.AddNote("q310_journal_notes_1", PotP_E_Primary, 'q310_journal_notes_1');
	catalog.AddNote("q311_lost_diary4", PotP_E_Primary, 'q311_lost_diary4');
	catalog.AddNote("sk48_splintered_ships_note", PotP_E_Primary, 'sk48_splintered_ships_note');
	catalog.AddNote("mq4001_book", PotP_E_Primary, 'mq4001_book');
	catalog.AddNote("th1010_schematic_pants", PotP_E_Primary_DLC1, 'th1010_schematic_pants');
	catalog.AddNote("mh701_work_schedule", PotP_E_Primary_DLC2, 'mh701_work_schedule');
	catalog.AddNote("poi_vin_b_05_note02", PotP_E_Primary_DLC2, 'poi_vin_b_05_note02');
	catalog.AddNote("mq1060_armor_vesemir_note", PotP_E_Primary, 'mq1060_armor_vesemir_note');
	catalog.AddNote("th701_bear_journal", PotP_E_Primary_DLC2, 'th701_bear_journal');
	catalog.AddNote("q309_key_orders", PotP_E_Primary, 'q309_key_orders');
	catalog.AddNote("th1009_map_wolf_upgrade1a", PotP_E_Primary, 'th1009_map_wolf_upgrade1a');
	catalog.AddNote("lw_cp36_note", PotP_E_Primary, 'lw_cp36_note');
	catalog.AddNote("q309_witch_hunters_orders", PotP_E_Primary, 'q309_witch_hunters_orders');
	catalog.AddNote("th1005_journal_gryphon_part1", PotP_E_Primary, 'th1005_journal_gryphon_part1');
	catalog.AddNote("flotsam_experiment", PotP_E_Primary, 'flotsam_experiment');
	catalog.AddNote("q702_monster_curses", PotP_E_Primary_DLC2, 'q702_monster_curses');
	catalog.AddNote("poi_gor_b_04_note_b", PotP_E_Primary_DLC2, 'poi_gor_b_04_note_b');
	catalog.AddNote("th1009_map_wolf_upgrade3", PotP_E_Primary, 'th1009_map_wolf_upgrade3');
	catalog.AddNote("poi_dun_a_04_note", PotP_E_Primary_DLC2, 'poi_dun_a_04_note');
	catalog.AddModBooks(5);
	catalog.EndSection();
}

// A readable item's shelf: 0 Lore Books, 1 Monster Tomes, 2 Journals and Diaries, 3 Letters, 4 Notices and Contracts,
// 5 Notes and Documents, -1 not for the Library (a diagram, a formula, a painting, a readable with no text).
// The rules gen_library.py lists the game's own by, for what mods add (CPotP_Catalog.AddModBooks). bookLore,
// bookBestiary and glossaryNoDesc are the tags Witcher Lore Collection gives its books and its glossary entries.
// From 2 on they're notes, by the item's icon, as no tag tells a journal from a letter.
function PotP_LibraryShelf(defs: CDefinitionsManagerAccessor, item: name) : int
{
	var text		: string = NameToString(item);
	var category	: name;
	var icon		: string;

	if (defs.ItemHasTag(item, 'glossaryNoDesc'))
	{
		return -1;
	}
	if (defs.ItemHasTag(item, 'bookBestiary'))
	{
		return 1;
	}
	if (defs.ItemHasTag(item, 'bookLore') || StrBeginsWith(StrLower(text), "lore_") || StrBeginsWith(StrLower(text), "item_book_lore_"))
	{
		return 0;
	}
	switch (item)
	{
	case 'Necronomicon':
	case 'Book of Arachases':
	case 'Glossary Temerian Dynasty':
	case 'Journey into the mind':
	case 'Orders from Shilard':
	case 'Jacob of Varazze Chronicles':
	case 'Poems of Gonzal de Verceo':
	case 'Norther Kingdoms arms and tactics':
	case 'Skelige arms and tactics':
	case 'Gear improvement':
		return 0;
	}
	if (defs.ItemHasTag(item, 'PerkBook') || (StrBeginsWith(text, "bestiary_") && StrRight(text, 5) == "_book"))
	{
		return 1;
	}

	category = defs.GetItemCategory(item);
	if (category == 'crafting_schematic' || category == 'alchemy_recipe' || category == 'cooking_recipe' || defs.ItemHasTag(item, 'Painting'))
	{
		return -1;
	}
	if (StrLen(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(item) + "_text")) < 2)
	{
		return -1;
	}
	if (defs.ItemHasTag(item, 'NoticeBoardNote'))
	{
		return 4;
	}
	icon = StrLower(defs.GetItemIconPath(item));
	if (StrFindFirst(icon, "book") >= 0 || StrFindFirst(icon, "diary") >= 0 || StrFindFirst(icon, "journal") >= 0 || StrFindFirst(icon, "_log") >= 0)
	{
		return 2;
	}
	if (StrFindFirst(icon, "letter") >= 0)
	{
		return 3;
	}
	return 5;
}
