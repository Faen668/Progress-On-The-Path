//---------------------------------------------------
//-- Library Definitions ----------------------------
//---------------------------------------------------
// Made by overlay/tools/gen_library.py from the game's item definitions. Don't edit by hand.
// A book is read when the game says so: its BookReadState_ fact (CInventoryComponent.IsBookReadByName).
// Each shelf ends with the books mods add to it (CPotP_Catalog.AddModBooks).

function PotP_DefineLibrary(catalog: CPotP_Catalog)
{
	PotP_DefineLibrary_1(catalog);
	PotP_DefineLibrary_2(catalog);
	PotP_DefineLibrary_3(catalog);
	PotP_DefineLibrary_4(catalog);
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
}

// A readable item's shelf: 0 Lore Books, 1 Monster Tomes, -1 not a book (a note, a letter, a diagram, a formula).
// The rules gen_library.py lists the game's books by, for the books mods add (CPotP_Catalog.AddModBooks). bookLore,
// bookBestiary and glossaryNoDesc are the tags Witcher Lore Collection gives its books and its glossary entries.
function PotP_LibraryShelf(defs: CDefinitionsManagerAccessor, item: name) : int
{
	var text : string = NameToString(item);

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
	return -1;
}
