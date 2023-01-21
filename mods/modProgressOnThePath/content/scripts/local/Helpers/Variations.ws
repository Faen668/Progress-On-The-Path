
//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetAllVariations(e_Identifier : name, e_GroupIdentifier: name, out entries : array< name >) : void {

	entries.Clear();
	
	if (e_GroupIdentifier == 'Goblin') {
		PotP_GetGwentCardVariations(e_Identifier, entries);
		PotP_GetShadeIronVariations(e_Identifier, entries);
		PotP_GetSezonBurzVariations(e_Identifier, entries);
		PotP_GetCosWiecejVariations(e_Identifier, entries);
		PotP_GetW3EEReduxVariations(e_Identifier, entries);
		PotP_GetBaseGamesVariations(e_Identifier, entries);
		PotP_GetArmorSetsVariations(e_Identifier, entries);
		if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
	}
	else
	{
		if (StrContains(NameToString(e_GroupIdentifier), "GwentCards")) {
			PotP_GetGwentCardVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}
		
		if (StrContains(NameToString(e_GroupIdentifier), "ShadesOfIron")) {
			PotP_GetShadeIronVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}

		if (StrContains(NameToString(e_GroupIdentifier), "SezonBurz")) {
			PotP_GetSezonBurzVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}

		if (StrContains(NameToString(e_GroupIdentifier), "CosWiecej")) {
			PotP_GetCosWiecejVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}

		if (StrContains(NameToString(e_GroupIdentifier), "GearSets_W3EE")) {
			PotP_GetW3EEReduxVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}

		if (StrContains(NameToString(e_GroupIdentifier), "Relics")) {
			PotP_GetBaseGamesVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}

		if (StrContains(NameToString(e_GroupIdentifier), "Trophies")) {
			PotP_GetBaseGamesVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}
		
		if (StrContains(NameToString(e_GroupIdentifier), "GearSets")) {
			PotP_GetArmorSetsVariations(e_Identifier, entries);
			if (entries.Size() < 1) { entries.PushBack(e_Identifier); }
		}	

		if (entries.Size() < 1) {
			entries.PushBack(e_Identifier);
		}	
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetBaseGamesVariations(e_Identifier : name, out entries : array< name >) : void {
	
	switch (e_Identifier) {

		//--------------------------------------------------- Steel Swords
		
		case 'Arbitrator':
		case 'Arbitrator_crafted':
			entries.PushBack('Arbitrator');
			entries.PushBack('Arbitrator_crafted');
			return;
			
		case 'Beannshie':
		case 'Beannshie_crafted':
			entries.PushBack('Beannshie');
			entries.PushBack('Beannshie_crafted');
			return;
			
		case 'Blackunicorn':
		case 'Blackunicorn_crafted':
			entries.PushBack('Blackunicorn');
			entries.PushBack('Blackunicorn_crafted');
			return;
			
		case 'Novigraadan sword 4':
		case 'sq304 Novigraadan sword 4':
			entries.PushBack('Novigraadan sword 4');
			entries.PushBack('sq304 Novigraadan sword 4');
			return;
			
		case 'Longclaw':
		case 'Longclaw_crafted':
			entries.PushBack('Longclaw');
			entries.PushBack('Longclaw_crafted');
			return;

		case 'Gnomish sword 2':
		case 'Gnomish sword 2_crafted':
			entries.PushBack('Gnomish sword 2');
			entries.PushBack('Gnomish sword 2_crafted');
			return;

		case 'Guard lvl1 steel sword 3':
		case 'Guard lvl1 steel sword 3 Autogen':
			entries.PushBack('Guard lvl1 steel sword 3');
			entries.PushBack('Guard lvl1 steel sword 3 Autogen');
			return;

		//--------------------------------------------------- Silver Swords

		case 'Serpent Silver Sword 1':
		case 'Serpent Silver Sword 1 Autogen':
			entries.PushBack('Serpent Silver Sword 1');
			entries.PushBack('Serpent Silver Sword 1 Autogen');
			return;

		case 'Unique silver sword':
		case 'Serpent Silver Sword 3':
			entries.PushBack('Unique silver sword');
			entries.PushBack('Serpent Silver Sword 3');
			return;

		case 'Harpy':
		case 'Harpy_crafted':
			entries.PushBack('Harpy');
			entries.PushBack('Harpy_crafted');
			return;

		case 'Negotiator':
		case 'Negotiator_crafted':
			entries.PushBack('Negotiator');
			entries.PushBack('Negotiator_crafted');
			return;

		case 'Weeper':
		case 'Weeper_crafted':
			entries.PushBack('Weeper');
			entries.PushBack('Weeper_crafted');
			return;
			
		//--------------------------------------------------- Monster Trophies

		case 'mh301_gryphon_trophy':
		case 'q002_griffin_trophy':
		case 'mq7009_griffin_trophy':
			entries.PushBack('mh301_gryphon_trophy');
			entries.PushBack('q002_griffin_trophy');
			entries.PushBack('mq7009_griffin_trophy');
			return;

		case 'mh204_leshy_trophy':
		case 'mh302_leshy_trophy':
			entries.PushBack('mh204_leshy_trophy');
			entries.PushBack('mh302_leshy_trophy');
			return;
			
		case 'mq0003_noonwraith_trophy':
		case 'mh308_noonwraith_trophy':
			entries.PushBack('mq0003_noonwraith_trophy');
			entries.PushBack('mh308_noonwraith_trophy');
			return;

		case 'mh105_wyvern_trophy':
		case 'mq1051_wyvern_trophy':
			entries.PushBack('mh105_wyvern_trophy');
			entries.PushBack('mq1051_wyvern_trophy');
			return;
			
		default:
			return;
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetArmorSetsVariations(e_Identifier : name, out entries : array< name >) : void {
	
	switch (e_Identifier) {
	
	// New Moon
	
	case 'Thief Armor':
	case 'Thief Armor No Medallion':
		entries.PushBack('Thief Armor');
		entries.PushBack('Thief Armor No Medallion');
		return;

	case 'Thief Boots':
	case 'Thief Boots No Medallion':
		entries.PushBack('Thief Boots');
		entries.PushBack('Thief Boots No Medallion');
		return;
		
	case 'Thief Gloves':
	case 'Thief Gloves No Medallion':
		entries.PushBack('Thief Gloves');
		entries.PushBack('Thief Gloves No Medallion');
		return;

	case 'Thief Pants':
	case 'Thief Pants No Medallion':
		entries.PushBack('Thief Pants');
		entries.PushBack('Thief Pants No Medallion');
		return;
	
	// Nilfgaardian
	
	case 'DLC5 Nilfgaardian Armor':
	case 'NGP DLC5 Nilfgaardian Armor':
		entries.PushBack('DLC5 Nilfgaardian Armor');
		entries.PushBack('NGP DLC5 Nilfgaardian Armor');
		return;

	case 'DLC5 Nilfgaardian Boots':
	case 'NGP DLC5 Nilfgaardian Boots':
		entries.PushBack('DLC5 Nilfgaardian Boots');
		entries.PushBack('NGP DLC5 Nilfgaardian Boots');
		return;
		
	case 'DLC5 Nilfgaardian Gloves':
	case 'NGP DLC5 Nilfgaardian Gloves':
		entries.PushBack('DLC5 Nilfgaardian Gloves');
		entries.PushBack('NGP DLC5 Nilfgaardian Gloves');
		return;

	case 'DLC5 Nilfgaardian Pants':
	case 'NGP DLC5 Nilfgaardian Pants':
		entries.PushBack('DLC5 Nilfgaardian Pants');
		entries.PushBack('NGP DLC5 Nilfgaardian Pants');
		return;

	// Temerian
	
	case 'DLC1 Temerian Armor':
	case 'NGP DLC1 Temerian Armor':
		entries.PushBack('DLC1 Temerian Armor');
		entries.PushBack('NGP DLC1 Temerian Armor');
		return;

	case 'DLC1 Temerian Boots':
	case 'NGP DLC1 Temerian Boots':
		entries.PushBack('DLC1 Temerian Boots');
		entries.PushBack('NGP DLC1 Temerian Boots');
		return;
		
	case 'DLC1 Temerian Gloves':
	case 'NGP DLC1 Temerian Gloves':
		entries.PushBack('DLC1 Temerian Gloves');
		entries.PushBack('NGP DLC1 Temerian Gloves');
		return;

	case 'DLC1 Temerian Pants':
	case 'NGP DLC1 Temerian Pants':
		entries.PushBack('DLC1 Temerian Pants');
		entries.PushBack('NGP DLC1 Temerian Pants');
		return;

	// Undvik
	
	case 'DLC14 Skellige Armor':
	case 'NGP DLC14 Skellige Armor':
	case 'q108 Medium armor 10':
		entries.PushBack('DLC14 Skellige Armor');
		entries.PushBack('NGP DLC14 Skellige Armor');
		entries.PushBack('q108 Medium armor 10');
		return;

	case 'DLC14 Skellige Boots':
	case 'NGP DLC14 Skellige Boots':
		entries.PushBack('DLC14 Skellige Boots');
		entries.PushBack('NGP DLC14 Skellige Boots');
		return;
		
	case 'DLC14 Skellige Gloves':
	case 'NGP DLC14 Skellige Gloves':
		entries.PushBack('DLC14 Skellige Gloves');
		entries.PushBack('NGP DLC14 Skellige Gloves');
		return;

	case 'DLC14 Skellige Pants':
	case 'NGP DLC14 Skellige Pants':
		entries.PushBack('DLC14 Skellige Pants');
		entries.PushBack('NGP DLC14 Skellige Pants');
		return;

	// Forgotten Wolven
	
	case 'Netflix Armor':
	case 'Netflix Armor 1':
	case 'Netflix Armor 2':
		entries.PushBack('Netflix Armor');
		entries.PushBack('Netflix Armor 1');
		entries.PushBack('Netflix Armor 2');
		return;

	case 'Netflix Boots':
	case 'Netflix Boots 1':
	case 'Netflix Boots 2':
		entries.PushBack('Netflix Boots');
		entries.PushBack('Netflix Boots 1');
		entries.PushBack('Netflix Boots 2');
		return;
		
	case 'Netflix Gloves':
	case 'Netflix Gloves 1':
	case 'Netflix Gloves 2':
		entries.PushBack('Netflix Gloves');
		entries.PushBack('Netflix Gloves 1');
		entries.PushBack('Netflix Gloves 2');
		return;

	case 'Netflix Pants':
	case 'Netflix Pants 1':
	case 'Netflix Pants 2':
		entries.PushBack('Netflix Pants');
		entries.PushBack('Netflix Pants 1');
		entries.PushBack('Netflix Pants 2');
		return;

	case 'Netflix steel sword':
	case 'Netflix steel sword 1':
	case 'Netflix steel sword 2':
	case 'Reinald Netflix steel sword':
		entries.PushBack('Netflix steel sword');
		entries.PushBack('Netflix steel sword 1');
		entries.PushBack('Netflix steel sword 2');
		entries.PushBack('Reinald Netflix steel sword');
		return;

	case 'Netflix silver sword':
	case 'Netflix silver sword 1':
	case 'Netflix silver sword 2':
	case 'Reinald Netflix silver sword':
		entries.PushBack('Netflix silver sword');
		entries.PushBack('Netflix silver sword 1');
		entries.PushBack('Netflix silver sword 2');
		entries.PushBack('Reinald Netflix silver sword');
		return;
		
	default:
		return;
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetCosWiecejVariations(e_Identifier : name, out entries : array< name >) : void {
	
	switch (e_Identifier) {
	
	case 'wiecej':
	case 'wiecej ngp':
		entries.PushBack('wiecej');
		entries.PushBack('wiecej ngp');
		return;

	case 'wiecej gloves':
	case 'wiecej gloves 2':
	case 'wiecej gloves ngp':
	case 'wiecej gloves 2 ngp':
		entries.PushBack('wiecej gloves');
		entries.PushBack('wiecej gloves 2');
		entries.PushBack('wiecej gloves ngp');
		entries.PushBack('wiecej gloves 2 ngp');
		return;

	case 'wiecej pants':
	case 'wiecej pants ngp':
		entries.PushBack('wiecej pants');
		entries.PushBack('wiecej pants ngp');
		return;

	case 'wiecej boots':
	case 'wiecej boots ngp':
		entries.PushBack('wiecej boots');
		entries.PushBack('wiecej boots ngp');
		return;

	case 'wiecej steel':
	case 'wiecej steel ngp':
		entries.PushBack('wiecej steel');
		entries.PushBack('wiecej steel ngp');
		return;
		
	case 'wiecej silver':
	case 'wiecej silver ngp':
		entries.PushBack('wiecej silver');
		entries.PushBack('wiecej silver ngp');
		return;
	
	case 'rune sihil':
	case 'rune sihil 2':
	case 'rune sihil ngp':
	case 'rune sihil 2 ngp':
		entries.PushBack('rune sihil');
		entries.PushBack('rune sihil 2');
		entries.PushBack('rune sihil ngp');
		entries.PushBack('rune sihil 2 ngp');
		return;

	default:
		return;
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetSezonBurzVariations(e_Identifier : name, out entries : array< name >) : void {

	switch (e_Identifier) {
	
	case 'Sezon Burz Armor':
	case 'Sezon Burz Armor NGP':
		entries.PushBack('Sezon Burz Armor');
		entries.PushBack('Sezon Burz Armor NGP');
		return;

	case 'Sezon Burz Pants':
	case 'Sezon Burz Pants NGP':
		entries.PushBack('Sezon Burz Pants');
		entries.PushBack('Sezon Burz Pants NGP');
		return;
		
	case 'Sezon Burz Boots':
	case 'Sezon Burz Boots NGP':
		entries.PushBack('Sezon Burz Boots');
		entries.PushBack('Sezon Burz Boots NGP');
		return;

	case 'Sezon Burz Gloves':
	case 'Sezon Burz Gloves NGP':
	case 'Sezon Burz Fingerless Gloves':
	case 'Sezon Burz Fingerless Gloves NGP':
		entries.PushBack('Sezon Burz Gloves');
		entries.PushBack('Sezon Burz Gloves NGP');
		entries.PushBack('Sezon Burz Fingerless Gloves');
		entries.PushBack('Sezon Burz Fingerless Gloves NGP');
		return;
		
	case 'Sezon Burz Steel Sword':
	case 'Sezon Burz Steel Sword NGP':
		entries.PushBack('Sezon Burz Steel Sword');
		entries.PushBack('Sezon Burz Steel Sword NGP');
		return;

	case 'Sezon Burz Silver Sword':
	case 'Sezon Burz Silver Sword NGP':
		entries.PushBack('Sezon Burz Silver Sword');
		entries.PushBack('Sezon Burz Silver Sword NGP');
		return;

	case 'Sezon Burz Crossbow 1':
	case 'Sezon Burz Crossbow 2':
	case 'Sezon Burz Crossbow 3':
		entries.PushBack('Sezon Burz Crossbow 1');
		entries.PushBack('Sezon Burz Crossbow 2');
		entries.PushBack('Sezon Burz Crossbow 3');
		return;
		
	default:
		return;
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetW3EEReduxVariations(e_Identifier : name, out entries : array< name >) : void {

	switch (e_Identifier) {
	
	// Gothic
	
	case 'kotw_armor_v1_1':
	case 'kotw_armor_v1_2':
		entries.PushBack('kotw_armor_v1_1');
		entries.PushBack('kotw_armor_v1_2');
		return;

	case 'kotw_legs_v1_1':
	case 'kotw_legs_v1_2':
		entries.PushBack('kotw_legs_v1_1');
		entries.PushBack('kotw_legs_v1_2');
		return;
		
	case 'kotw_boots_v1_1':
	case 'kotw_boots_v1_2':
		entries.PushBack('kotw_boots_v1_1');
		entries.PushBack('kotw_boots_v1_2');
		return;

	case 'kotw_gloves_v1_1':
	case 'kotw_gloves_v1_2':
		entries.PushBack('kotw_gloves_v1_1');
		entries.PushBack('kotw_gloves_v1_2');
		return;

	// Meteorite
	
	case 'kotw_armor_v2_1':
	case 'kotw_armor_v2_2':
		entries.PushBack('kotw_armor_v2_1');
		entries.PushBack('kotw_armor_v2_2');
		return;

	case 'kotw_legs_v2_1':
	case 'kotw_legs_v2_2':
		entries.PushBack('kotw_legs_v2_1');
		entries.PushBack('kotw_legs_v2_2');
		return;
		
	case 'kotw_boots_v2_1':
	case 'kotw_boots_v2_2':
		entries.PushBack('kotw_boots_v2_1');
		entries.PushBack('kotw_boots_v2_2');
		return;

	case 'kotw_gloves_v2_1':
	case 'kotw_gloves_v2_2':
		entries.PushBack('kotw_gloves_v2_1');
		entries.PushBack('kotw_gloves_v2_2');
		return;

	// Dimeritium
	
	case 'kotw_armor_v3_1':
	case 'kotw_armor_v3_2':
		entries.PushBack('kotw_armor_v3_1');
		entries.PushBack('kotw_armor_v3_2');
		return;

	case 'kotw_legs_v3_1':
	case 'kotw_legs_v3_2':
		entries.PushBack('kotw_legs_v3_1');
		entries.PushBack('kotw_legs_v3_2');
		return;
		
	case 'kotw_boots_v3_1':
	case 'kotw_boots_v3_2':
		entries.PushBack('kotw_boots_v3_1');
		entries.PushBack('kotw_boots_v3_2');
		return;

	case 'kotw_gloves_v3_1':
	case 'kotw_gloves_v3_2':
		entries.PushBack('kotw_gloves_v3_1');
		entries.PushBack('kotw_gloves_v3_2');
		return;
		
	default:
		return;
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetGwentCardVariations(e_Identifier : name, out entries : array< name > ) : void {
	
	var redux: bool = PotP_UsingGwentRedux();
	
	switch (e_Identifier) {
		
		case 'gwint_card_arachas':
		case 'gwint_card_arachas2':
		case 'gwint_card_arachas3':
			if (!redux) {
				entries.PushBack('gwint_card_arachas');
				entries.PushBack('gwint_card_arachas2');
				entries.PushBack('gwint_card_arachas3');
			}
			return;

		case 'gwint_card_ghoul':
		case 'gwint_card_ghoul2':
		case 'gwint_card_ghoul3':
			if (!redux) {
				entries.PushBack('gwint_card_ghoul');
				entries.PushBack('gwint_card_ghoul2');
				entries.PushBack('gwint_card_ghoul3');
			}
			return;

		case 'gwint_card_nekker':
		case 'gwint_card_nekker2':
		case 'gwint_card_nekker3':
			if (redux) {
				entries.PushBack('gwint_card_nekker');
				entries.PushBack('gwint_card_nekker2');
				entries.PushBack('gwint_card_nekker3');
			}
			return;

		case 'gwint_card_dol_dwarf':
		case 'gwint_card_dol_dwarf2':
		case 'gwint_card_dol_dwarf3':
			if (redux || !redux) {
				entries.PushBack('gwint_card_dol_dwarf');
				entries.PushBack('gwint_card_dol_dwarf2');
				entries.PushBack('gwint_card_dol_dwarf3');
			}
			return;

		case 'gwint_card_wildhunt_rider':
		case 'gwint_card_wildhunt_rider2':
		case 'gwint_card_wildhunt_rider3':
			if (redux) {
				entries.PushBack('gwint_card_wildhunt_rider');
				entries.PushBack('gwint_card_wildhunt_rider2');
				entries.PushBack('gwint_card_wildhunt_rider3');
			}
			return;

		case 'gwint_card_black_archer':
		case 'gwint_card_black_archer2':
			if (!redux) {
				entries.PushBack('gwint_card_black_archer');
				entries.PushBack('gwint_card_black_archer2');
			}
			return;

		case 'gwint_card_archer_support':
		case 'gwint_card_archer_support2':
			if (!redux) {
				entries.PushBack('gwint_card_archer_support');
				entries.PushBack('gwint_card_archer_support2');
			}
			return;
		
		case 'gwint_card_impera_brigade':
		case 'gwint_card_impera_brigade2':
		case 'gwint_card_impera_brigade3':
		case 'gwint_card_impera_brigade4':
			if (!redux) {
				entries.PushBack('gwint_card_impera_brigade');
				entries.PushBack('gwint_card_impera_brigade2');
				entries.PushBack('gwint_card_impera_brigade3');
				entries.PushBack('gwint_card_impera_brigade4');
			}
			return;

		case 'gwint_card_nausicaa':
		case 'gwint_card_nausicaa2':
		case 'gwint_card_nausicaa3':
			if (!redux) {
				entries.PushBack('gwint_card_nausicaa');
				entries.PushBack('gwint_card_nausicaa2');
				entries.PushBack('gwint_card_nausicaa3');
			}
			return;
			
		case 'gwint_card_young_emissary':
		case 'gwint_card_young_emissary2':
			if (!redux) {
				entries.PushBack('gwint_card_young_emissary');
				entries.PushBack('gwint_card_young_emissary2');
			}
			return;

		case 'gwint_card_catapult':
		case 'gwint_card_catapult2':
			if (!redux) {
				entries.PushBack('gwint_card_catapult');
				entries.PushBack('gwint_card_catapult2');
			}
			return;
		
		case 'gwint_card_crinfrid':
		case 'gwint_card_crinfrid2':
		case 'gwint_card_crinfrid3':
			if (!redux || redux) {
				entries.PushBack('gwint_card_crinfrid');
				entries.PushBack('gwint_card_crinfrid2');
				entries.PushBack('gwint_card_crinfrid3');
			}
			return;

		case 'gwint_card_blue_stripes1':
		case 'gwint_card_blue_stripes2':
		case 'gwint_card_blue_stripes3':
			if (redux) {
				entries.PushBack('gwint_card_blue_stripes1');
				entries.PushBack('gwint_card_blue_stripes2');
				entries.PushBack('gwint_card_blue_stripes3');
			}
			return;

		case 'gwint_card_dol_infantry':
		case 'gwint_card_dol_infantry2':
		case 'gwint_card_dol_infantry3':
			if (!redux) {
				entries.PushBack('gwint_card_dol_infantry');
				entries.PushBack('gwint_card_dol_infantry2');
				entries.PushBack('gwint_card_dol_infantry3');
			}
			return;

		case 'gwint_card_elf_skirmisher':
		case 'gwint_card_elf_skirmisher2':
		case 'gwint_card_elf_skirmisher3':
			if (!redux) {
				entries.PushBack('gwint_card_elf_skirmisher');
				entries.PushBack('gwint_card_elf_skirmisher2');
				entries.PushBack('gwint_card_elf_skirmisher3');
			}
			return;
			
		case 'gwint_card_havekar_nurse':
		case 'gwint_card_havekar_nurse2':
		case 'gwint_card_havekar_nurse3':
			if (!redux) {
				entries.PushBack('gwint_card_havekar_nurse');
				entries.PushBack('gwint_card_havekar_nurse2');
				entries.PushBack('gwint_card_havekar_nurse3');
			}
			return;

		case 'gwint_card_havekar_support':
		case 'gwint_card_havekar_support2':
		case 'gwint_card_havekar_support3':
			if (!redux) {
				entries.PushBack('gwint_card_havekar_support');
				entries.PushBack('gwint_card_havekar_support2');
				entries.PushBack('gwint_card_havekar_support3');
			}
			return;

		case 'gwint_card_mahakam':
		case 'gwint_card_mahakam2':
		case 'gwint_card_mahakam3':
		case 'gwint_card_mahakam4':
		case 'gwint_card_mahakam5':
			if (!redux) {
				entries.PushBack('gwint_card_mahakam');
				entries.PushBack('gwint_card_mahakam2');
				entries.PushBack('gwint_card_mahakam3');
				entries.PushBack('gwint_card_mahakam4');
				entries.PushBack('gwint_card_mahakam5');
			}
			return;

		case 'gwint_card_vrihedd_brigade':
		case 'gwint_card_vrihedd_brigade2':
			if (!redux) {
				entries.PushBack('gwint_card_vrihedd_brigade');
				entries.PushBack('gwint_card_vrihedd_brigade2');
			}
			return;
			
		default:
			return;
	}
}