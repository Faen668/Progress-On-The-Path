//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_GetShadeIronVariations(e_Identifier : name, out entries : array< name >) : void {
	
	PotP_Get_SOI_ArmorVariations(e_Identifier, entries);
	PotP_Get_SOI_SilverVariations(e_Identifier, entries);
	PotP_Get_SOI_SteelVariations(e_Identifier, entries);
}

function PotP_Get_SOI_ArmorVariations(e_Identifier : name, out entries : array< name >) : void {

	switch (e_Identifier) {
		
	//---// Berserker's Set

	case 'Shades Berserker Armor':
	case 'Shades Berserker Armor 1':
	case 'Shades Berserker Armor 2':
		entries.PushBack('Shades Berserker Armor');
		entries.PushBack('Shades Berserker Armor 1');
		entries.PushBack('Shades Berserker Armor 2');
		return;

	case 'Shades Berserker Gloves':
	case 'Shades Berserker Gloves 1':
	case 'Shades Berserker Gloves 2':
		entries.PushBack('Shades Berserker Gloves');
		entries.PushBack('Shades Berserker Gloves 1');
		entries.PushBack('Shades Berserker Gloves 2');
		return;
		
	case 'Shades Berserker Boots':
	case 'Shades Berserker Boots 1':
	case 'Shades Berserker Boots 2':
		entries.PushBack('Shades Berserker Boots');
		entries.PushBack('Shades Berserker Boots 1');
		entries.PushBack('Shades Berserker Boots 2');
		return;

	case 'Shades Berserker Pants':
	case 'Shades Berserker Pants 1':
	case 'Shades Berserker Pants 2':
		entries.PushBack('Shades Berserker Pants');
		entries.PushBack('Shades Berserker Pants 1');
		entries.PushBack('Shades Berserker Pants 2');
		return;

	//---// Bismarck Set

	case 'Shades Bismarck Armor':
	case 'Shades Bismarck Armor 1':
	case 'Shades Bismarck Armor 2':
		entries.PushBack('Shades Bismarck Armor');
		entries.PushBack('Shades Bismarck Armor 1');
		entries.PushBack('Shades Bismarck Armor 2');
		return;

	case 'Shades Bismarck Gloves':
	case 'Shades Bismarck Gloves 1':
	case 'Shades Bismarck Gloves 2':
		entries.PushBack('Shades Bismarck Gloves');
		entries.PushBack('Shades Bismarck Gloves 1');
		entries.PushBack('Shades Bismarck Gloves 2');
		return;
		
	case 'Shades Bismarck Boots':
	case 'Shades Bismarck Boots 1':
	case 'Shades Bismarck Boots 2':
		entries.PushBack('Shades Bismarck Boots');
		entries.PushBack('Shades Bismarck Boots 1');
		entries.PushBack('Shades Bismarck Boots 2');
		return;

	case 'Shades Bismarck Pants':
	case 'Shades Bismarck Pants 1':
	case 'Shades Bismarck Pants 2':
		entries.PushBack('Shades Bismarck Pants');
		entries.PushBack('Shades Bismarck Pants 1');
		entries.PushBack('Shades Bismarck Pants 2');
		return;
		
	//---// Blood Hunter's Set
	
	case 'Shades Hunter Boots':
	case 'Shades Hunter Boots 1':
	case 'Shades Hunter Boots 2':
		entries.PushBack('Shades Hunter Boots');
		entries.PushBack('Shades Hunter Boots 1');
		entries.PushBack('Shades Hunter Boots 2');
		return;

	case 'Shades Hunter Armor':
	case 'Shades Hunter Armor 1':
	case 'Shades Hunter Armor 2':
		entries.PushBack('Shades Hunter Armor');
		entries.PushBack('Shades Hunter Armor 1');
		entries.PushBack('Shades Hunter Armor 2');
		return;

	case 'Shades Hunter Gloves':
	case 'Shades Hunter Gloves 1':
	case 'Shades Hunter Gloves 2':
		entries.PushBack('Shades Hunter Gloves');
		entries.PushBack('Shades Hunter Gloves 1');
		entries.PushBack('Shades Hunter Gloves 2');
		return;

	case 'Shades Hunter Pants':
	case 'Shades Hunter Pants 1':
	case 'Shades Hunter Pants 2':
		entries.PushBack('Shades Hunter Pants');
		entries.PushBack('Shades Hunter Pants 1');
		entries.PushBack('Shades Hunter Pants 2');
		return;

	//---// Crow-feathered Hunter Set

	case 'Shades Crow Armor':
	case 'Shades Crow Armor 1':
	case 'Shades Crow Armor 2':
		entries.PushBack('Shades Crow Armor');
		entries.PushBack('Shades Crow Armor 1');
		entries.PushBack('Shades Crow Armor 2');
		return;

	case 'Shades Crow Gloves':
	case 'Shades Crow Gloves 1':
	case 'Shades Crow Gloves 2':
		entries.PushBack('Shades Crow Gloves');
		entries.PushBack('Shades Crow Gloves 1');
		entries.PushBack('Shades Crow Gloves 2');
		return;
		
	case 'Shades Crow Boots':
	case 'Shades Crow Boots 1':
	case 'Shades Crow Boots 2':
		entries.PushBack('Shades Crow Boots');
		entries.PushBack('Shades Crow Boots 1');
		entries.PushBack('Shades Crow Boots 2');
		return;

	case 'Shades Crow Pants':
	case 'Shades Crow Pants 1':
	case 'Shades Crow Pants 2':
		entries.PushBack('Shades Crow Pants');
		entries.PushBack('Shades Crow Pants 1');
		entries.PushBack('Shades Crow Pants 2');
		return;

	//---// Fallen Knight Set

	case 'Shades Fallen Armor':
	case 'Shades Fallen Armor 1':
	case 'Shades Fallen Armor 2':
		entries.PushBack('Shades Fallen Armor');
		entries.PushBack('Shades Fallen Armor 1');
		entries.PushBack('Shades Fallen Armor 2');
		return;

	case 'Shades Fallen Gloves':
	case 'Shades Fallen Gloves 1':
	case 'Shades Fallen Gloves 2':
		entries.PushBack('Shades Fallen Gloves');
		entries.PushBack('Shades Fallen Gloves 1');
		entries.PushBack('Shades Fallen Gloves 2');
		return;
		
	case 'Shades Fallen Boots':
	case 'Shades Fallen Boots 1':
	case 'Shades Fallen Boots 2':
		entries.PushBack('Shades Fallen Boots');
		entries.PushBack('Shades Fallen Boots 1');
		entries.PushBack('Shades Fallen Boots 2');
		return;

	case 'Shades Fallen Pants':
	case 'Shades Fallen Pants 1':
	case 'Shades Fallen Pants 2':
		entries.PushBack('Shades Fallen Pants');
		entries.PushBack('Shades Fallen Pants 1');
		entries.PushBack('Shades Fallen Pants 2');
		return;

	//---// Faraam Warlord Set

	case 'Shades Faraam Armor':
	case 'Shades Faraam Armor 1':
	case 'Shades Faraam Armor 2':
		entries.PushBack('Shades Faraam Armor');
		entries.PushBack('Shades Faraam Armor 1');
		entries.PushBack('Shades Faraam Armor 2');
		return;

	case 'Shades Faraam Gloves':
	case 'Shades Faraam Gloves 1':
	case 'Shades Faraam Gloves 2':
		entries.PushBack('Shades Faraam Gloves');
		entries.PushBack('Shades Faraam Gloves 1');
		entries.PushBack('Shades Faraam Gloves 2');
		return;
		
	case 'Shades Faraam Boots':
	case 'Shades Faraam Boots 1':
	case 'Shades Faraam Boots 2':
		entries.PushBack('Shades Faraam Boots');
		entries.PushBack('Shades Faraam Boots 1');
		entries.PushBack('Shades Faraam Boots 2');
		return;

	case 'Shades Faraam Pants':
	case 'Shades Faraam Pants 1':
	case 'Shades Faraam Pants 2':
		entries.PushBack('Shades Faraam Pants');
		entries.PushBack('Shades Faraam Pants 1');
		entries.PushBack('Shades Faraam Pants 2');
		return;

	//---// Headtaker Set

	case 'Shades Headtaker Armor':
	case 'Shades Headtaker Armor 1':
	case 'Shades Headtaker Armor 2':
		entries.PushBack('Shades Headtaker Armor');
		entries.PushBack('Shades Headtaker Armor 1');
		entries.PushBack('Shades Headtaker Armor 2');
		return;

	case 'Shades Headtaker Gloves':
	case 'Shades Headtaker Gloves 1':
	case 'Shades Headtaker Gloves 2':
		entries.PushBack('Shades Headtaker Gloves');
		entries.PushBack('Shades Headtaker Gloves 1');
		entries.PushBack('Shades Headtaker Gloves 2');
		return;
		
	case 'Shades Headtaker Boots':
	case 'Shades Headtaker Boots 1':
	case 'Shades Headtaker Boots 2':
		entries.PushBack('Shades Headtaker Boots');
		entries.PushBack('Shades Headtaker Boots 1');
		entries.PushBack('Shades Headtaker Boots 2');
		return;

	case 'Shades Headtaker Pants':
	case 'Shades Headtaker Pants 1':
	case 'Shades Headtaker Pants 2':
		entries.PushBack('Shades Headtaker Pants');
		entries.PushBack('Shades Headtaker Pants 1');
		entries.PushBack('Shades Headtaker Pants 2');
		return;

	//---// Hitokiri Set

	case 'Shades Viper Armor':
	case 'Shades Viper Armor 1':
	case 'Shades Viper Armor 2':
		entries.PushBack('Shades Viper Armor');
		entries.PushBack('Shades Viper Armor 1');
		entries.PushBack('Shades Viper Armor 2');
		return;

	case 'Shades Viper Gloves':
	case 'Shades Viper Gloves 1':
	case 'Shades Viper Gloves 2':
		entries.PushBack('Shades Viper Gloves');
		entries.PushBack('Shades Viper Gloves 1');
		entries.PushBack('Shades Viper Gloves 2');
		return;
		
	case 'Shades Viper Boots':
	case 'Shades Viper Boots 1':
	case 'Shades Viper Boots 2':
		entries.PushBack('Shades Viper Boots');
		entries.PushBack('Shades Viper Boots 1');
		entries.PushBack('Shades Viper Boots 2');
		return;

	case 'Shades Viper Pants':
	case 'Shades Viper Pants 1':
	case 'Shades Viper Pants 2':
		entries.PushBack('Shades Viper Pants');
		entries.PushBack('Shades Viper Pants 1');
		entries.PushBack('Shades Viper Pants 2');
		return;

	//---// Kara Vampire Set

	case 'Shades Kara Armor':
	case 'Shades Kara Armor 1':
	case 'Shades Kara Armor 2':
		entries.PushBack('Shades Kara Armor');
		entries.PushBack('Shades Kara Armor 1');
		entries.PushBack('Shades Kara Armor 2');
		return;

	case 'Shades Kara Gloves':
	case 'Shades Kara Gloves 1':
	case 'Shades Kara Gloves 2':
		entries.PushBack('Shades Kara Gloves');
		entries.PushBack('Shades Kara Gloves 1');
		entries.PushBack('Shades Kara Gloves 2');
		return;
		
	case 'Shades Kara Boots':
	case 'Shades Kara Boots 1':
	case 'Shades Kara Boots 2':
		entries.PushBack('Shades Kara Boots');
		entries.PushBack('Shades Kara Boots 1');
		entries.PushBack('Shades Kara Boots 2');
		return;

	case 'Shades Kara Pants':
	case 'Shades Kara Pants 1':
	case 'Shades Kara Pants 2':
		entries.PushBack('Shades Kara Pants');
		entries.PushBack('Shades Kara Pants 1');
		entries.PushBack('Shades Kara Pants 2');
		return;

	//---// Lionhunter Set

	case 'Shades Lionhunter Armor':
	case 'Shades Lionhunter Armor 1':
	case 'Shades Lionhunter Armor 2':
		entries.PushBack('Shades Lionhunter Armor');
		entries.PushBack('Shades Lionhunter Armor 1');
		entries.PushBack('Shades Lionhunter Armor 2');
		return;

	case 'Shades Lionhunter Gloves':
	case 'Shades Lionhunter Gloves 1':
	case 'Shades Lionhunter Gloves 2':
		entries.PushBack('Shades Lionhunter Gloves');
		entries.PushBack('Shades Lionhunter Gloves 1');
		entries.PushBack('Shades Lionhunter Gloves 2');
		return;
		
	case 'Shades Lionhunter Boots':
	case 'Shades Lionhunter Boots 1':
	case 'Shades Lionhunter Boots 2':
		entries.PushBack('Shades Lionhunter Boots');
		entries.PushBack('Shades Lionhunter Boots 1');
		entries.PushBack('Shades Lionhunter Boots 2');
		return;

	case 'Shades Lionhunter Pants':
	case 'Shades Lionhunter Pants 1':
	case 'Shades Lionhunter Pants 2':
		entries.PushBack('Shades Lionhunter Pants');
		entries.PushBack('Shades Lionhunter Pants 1');
		entries.PushBack('Shades Lionhunter Pants 2');
		return;

	//---// Master Assassin's Set

	case 'Shades Ezio Armor':
	case 'Shades Ezio Armor 1':
	case 'Shades Ezio Armor 2':
		entries.PushBack('Shades Ezio Armor');
		entries.PushBack('Shades Ezio Armor 1');
		entries.PushBack('Shades Ezio Armor 2');
		return;

	case 'Shades Ezio Gloves':
	case 'Shades Ezio Gloves 1':
	case 'Shades Ezio Gloves 2':
		entries.PushBack('Shades Ezio Gloves');
		entries.PushBack('Shades Ezio Gloves 1');
		entries.PushBack('Shades Ezio Gloves 2');
		return;
		
	case 'Shades Ezio Boots':
	case 'Shades Ezio Boots 1':
	case 'Shades Ezio Boots 2':
		entries.PushBack('Shades Ezio Boots');
		entries.PushBack('Shades Ezio Boots 1');
		entries.PushBack('Shades Ezio Boots 2');
		return;

	case 'Shades Ezio Pants':
	case 'Shades Ezio Pants 1':
	case 'Shades Ezio Pants 2':
		entries.PushBack('Shades Ezio Pants');
		entries.PushBack('Shades Ezio Pants 1');
		entries.PushBack('Shades Ezio Pants 2');
		return;

	//---// Old Hunter's Set

	case 'Shades Oldhunter Armor':
	case 'Shades Oldhunter Armor 1':
	case 'Shades Oldhunter Armor 2':
		entries.PushBack('Shades Oldhunter Armor');
		entries.PushBack('Shades Oldhunter Armor 1');
		entries.PushBack('Shades Oldhunter Armor 2');
		return;

	case 'Shades Oldhunter Gloves':
	case 'Shades Oldhunter Gloves 1':
	case 'Shades Oldhunter Gloves 2':
		entries.PushBack('Shades Oldhunter Gloves');
		entries.PushBack('Shades Oldhunter Gloves 1');
		entries.PushBack('Shades Oldhunter Gloves 2');
		return;
		
	case 'Shades Oldhunter Boots':
	case 'Shades Oldhunter Boots 1':
	case 'Shades Oldhunter Boots 2':
		entries.PushBack('Shades Oldhunter Boots');
		entries.PushBack('Shades Oldhunter Boots 1');
		entries.PushBack('Shades Oldhunter Boots 2');
		return;

	case 'Shades Oldhunter Pants':
	case 'Shades Oldhunter Pants 1':
	case 'Shades Oldhunter Pants 2':
		entries.PushBack('Shades Oldhunter Pants');
		entries.PushBack('Shades Oldhunter Pants 1');
		entries.PushBack('Shades Oldhunter Pants 2');
		return;

	//---// Revenant Set

	case 'Shades Revenant Armor':
	case 'Shades Revenant Armor 1':
	case 'Shades Revenant Armor 2':
		entries.PushBack('Shades Revenant Armor');
		entries.PushBack('Shades Revenant Armor 1');
		entries.PushBack('Shades Revenant Armor 2');
		return;

	case 'Shades Revenant Gloves':
	case 'Shades Revenant Gloves 1':
	case 'Shades Revenant Gloves 2':
		entries.PushBack('Shades Revenant Gloves');
		entries.PushBack('Shades Revenant Gloves 1');
		entries.PushBack('Shades Revenant Gloves 2');
		return;
		
	case 'Shades Revenant Boots':
	case 'Shades Revenant Boots 1':
	case 'Shades Revenant Boots 2':
		entries.PushBack('Shades Revenant Boots');
		entries.PushBack('Shades Revenant Boots 1');
		entries.PushBack('Shades Revenant Boots 2');
		return;

	case 'Shades Revenant Pants':
	case 'Shades Revenant Pants 1':
	case 'Shades Revenant Pants 2':
		entries.PushBack('Shades Revenant Pants');
		entries.PushBack('Shades Revenant Pants 1');
		entries.PushBack('Shades Revenant Pants 2');
		return;

	//---// Stalker's Set

	case 'Shades Undertaker Armor':
	case 'Shades Undertaker Armor 1':
	case 'Shades Undertaker Armor 2':
		entries.PushBack('Shades Undertaker Armor');
		entries.PushBack('Shades Undertaker Armor 1');
		entries.PushBack('Shades Undertaker Armor 2');
		return;

	case 'Shades Undertaker Gloves':
	case 'Shades Undertaker Gloves 1':
	case 'Shades Undertaker Gloves 2':
		entries.PushBack('Shades Undertaker Gloves');
		entries.PushBack('Shades Undertaker Gloves 1');
		entries.PushBack('Shades Undertaker Gloves 2');
		return;
		
	case 'Shades Undertaker Boots':
	case 'Shades Undertaker Boots 1':
	case 'Shades Undertaker Boots 2':
		entries.PushBack('Shades Undertaker Boots');
		entries.PushBack('Shades Undertaker Boots 1');
		entries.PushBack('Shades Undertaker Boots 2');
		return;

	case 'Shades Undertaker Pants':
	case 'Shades Undertaker Pants 1':
	case 'Shades Undertaker Pants 2':
		entries.PushBack('Shades Undertaker Pants');
		entries.PushBack('Shades Undertaker Pants 1');
		entries.PushBack('Shades Undertaker Pants 2');
		return;

	//---// Taifeng Set

	case 'Shades Taifeng Armor':
	case 'Shades Taifeng Armor 1':
	case 'Shades Taifeng Armor 2':
		entries.PushBack('Shades Taifeng Armor');
		entries.PushBack('Shades Taifeng Armor 1');
		entries.PushBack('Shades Taifeng Armor 2');
		return;

	case 'Shades Taifeng Gloves':
	case 'Shades Taifeng Gloves 1':
	case 'Shades Taifeng Gloves 2':
		entries.PushBack('Shades Taifeng Gloves');
		entries.PushBack('Shades Taifeng Gloves 1');
		entries.PushBack('Shades Taifeng Gloves 2');
		return;
		
	case 'Shades Taifeng Boots':
	case 'Shades Taifeng Boots 1':
	case 'Shades Taifeng Boots 2':
		entries.PushBack('Shades Taifeng Boots');
		entries.PushBack('Shades Taifeng Boots 1');
		entries.PushBack('Shades Taifeng Boots 2');
		return;

	case 'Shades Taifeng Pants':
	case 'Shades Taifeng Pants 1':
	case 'Shades Taifeng Pants 2':
		entries.PushBack('Shades Taifeng Pants');
		entries.PushBack('Shades Taifeng Pants 1');
		entries.PushBack('Shades Taifeng Pants 2');
		return;

	//---// Unseen Hunter's Set

	case 'Shades Yahargul Armor':
	case 'Shades Yahargul Armor 1':
	case 'Shades Yahargul Armor 2':
		entries.PushBack('Shades Yahargul Armor');
		entries.PushBack('Shades Yahargul Armor 1');
		entries.PushBack('Shades Yahargul Armor 2');
		return;

	case 'Shades Yahargul Gloves':
	case 'Shades Yahargul Gloves 1':
	case 'Shades Yahargul Gloves 2':
		entries.PushBack('Shades Yahargul Gloves');
		entries.PushBack('Shades Yahargul Gloves 1');
		entries.PushBack('Shades Yahargul Gloves 2');
		return;
		
	case 'Shades Yahargul Boots':
	case 'Shades Yahargul Boots 1':
	case 'Shades Yahargul Boots 2':
		entries.PushBack('Shades Yahargul Boots');
		entries.PushBack('Shades Yahargul Boots 1');
		entries.PushBack('Shades Yahargul Boots 2');
		return;

	case 'Shades Yahargul Pants':
	case 'Shades Yahargul Pants 1':
	case 'Shades Yahargul Pants 2':
		entries.PushBack('Shades Yahargul Pants');
		entries.PushBack('Shades Yahargul Pants 1');
		entries.PushBack('Shades Yahargul Pants 2');
		return;
		
	//---// Sithis Pieces
	
	case 'Shades Sithis Armor':
	case 'Shades Sithis Armor 1':
	case 'Shades Sithis Armor 2':
		entries.PushBack('Shades Sithis Armor');
		entries.PushBack('Shades Sithis Armor 1');
		entries.PushBack('Shades Sithis Armor 2');
		return;
		
	default:
		return;
	}
}

function PotP_Get_SOI_SilverVariations(e_Identifier : name, out entries : array< name >) : void {

	switch (e_Identifier) {

	//---// Silver Swords

	case 'Shades Silver Eagle Sword':
	case 'Shades Silver Eagle Sword 1':
	case 'Shades Silver Eagle Sword 2':
		entries.PushBack('Shades Silver Eagle Sword');
		entries.PushBack('Shades Silver Eagle Sword 1');
		entries.PushBack('Shades Silver Eagle Sword 2');
		return;

	case 'Shades Silver Ares':
	case 'Shades Silver Ares 1':
	case 'Shades Silver Ares 2':
		entries.PushBack('Shades Silver Ares');
		entries.PushBack('Shades Silver Ares 1');
		entries.PushBack('Shades Silver Ares 2');
		return;

	case 'Shades Silver Doomblade':
	case 'Shades Silver Doomblade 1':
	case 'Shades Silver Doomblade 2':
		entries.PushBack('Shades Silver Doomblade');
		entries.PushBack('Shades Silver Doomblade 1');
		entries.PushBack('Shades Silver Doomblade 2');
		return;
		
	case 'Shades Silver Beastcutter':
	case 'Shades Silver Beastcutter 1':
	case 'Shades Silver Beastcutter 2':
		entries.PushBack('Shades Silver Beastcutter');
		entries.PushBack('Shades Silver Beastcutter 1');
		entries.PushBack('Shades Silver Beastcutter 2');
		return;

	case 'Shades Silver Blackdawn':
	case 'Shades Silver Blackdawn 1':
	case 'Shades Silver Blackdawn 2':
		entries.PushBack('Shades Silver Blackdawn');
		entries.PushBack('Shades Silver Blackdawn 1');
		entries.PushBack('Shades Silver Blackdawn 2');
		return;

	case 'Shades Silver Blooddusk':
	case 'Shades Silver Blooddusk 1':
	case 'Shades Silver Blooddusk 2':
		entries.PushBack('Shades Silver Blooddusk');
		entries.PushBack('Shades Silver Blooddusk 1');
		entries.PushBack('Shades Silver Blooddusk 2');
		return;

	case 'Shades Silver Bloodletter':
	case 'Shades Silver Bloodletter 1':
	case 'Shades Silver Bloodletter 2':
		entries.PushBack('Shades Silver Bloodletter');
		entries.PushBack('Shades Silver Bloodletter 1');
		entries.PushBack('Shades Silver Bloodletter 2');
		return;

	case 'Shades Silver Bloodshot':
	case 'Shades Silver Bloodshot 1':
	case 'Shades Silver Bloodshot 2':
		entries.PushBack('Shades Silver Bloodshot');
		entries.PushBack('Shades Silver Bloodshot 1');
		entries.PushBack('Shades Silver Bloodshot 2');
		return;

	case 'Shades Silver Claymore':
	case 'Shades Silver Claymore 1':
	case 'Shades Silver Claymore 2':
		entries.PushBack('Shades Silver Claymore');
		entries.PushBack('Shades Silver Claymore 1');
		entries.PushBack('Shades Silver Claymore 2');
		return;

	case 'Shades Silver Kingslayer':
	case 'Shades Silver Kingslayer 1':
	case 'Shades Silver Kingslayer 2':
		entries.PushBack('Shades Silver Kingslayer');
		entries.PushBack('Shades Silver Kingslayer 1');
		entries.PushBack('Shades Silver Kingslayer 2');
		return;

	case 'Shades Silver Cursed Khopesh':
	case 'Shades Silver Cursed Khopesh 1':
	case 'Shades Silver Cursed Khopesh 2':
		entries.PushBack('Shades Silver Cursed Khopesh');
		entries.PushBack('Shades Silver Cursed Khopesh 1');
		entries.PushBack('Shades Silver Cursed Khopesh 2');
		return;

	case 'Shades Silver Dragonbane':
	case 'Shades Silver Dragonbane 1':
	case 'Shades Silver Dragonbane 2':
		entries.PushBack('Shades Silver Dragonbane');
		entries.PushBack('Shades Silver Dragonbane 1');
		entries.PushBack('Shades Silver Dragonbane 2');
		return;

	case 'Shades Silver Ejderblade':
	case 'Shades Silver Ejderblade 1':
	case 'Shades Silver Ejderblade 2':
		entries.PushBack('Shades Silver Ejderblade');
		entries.PushBack('Shades Silver Ejderblade 1');
		entries.PushBack('Shades Silver Ejderblade 2');
		return;

	case 'Shades Silver Flameborn':
	case 'Shades Silver Flameborn 1':
	case 'Shades Silver Flameborn 2':
		entries.PushBack('Shades Silver Flameborn');
		entries.PushBack('Shades Silver Flameborn 1');
		entries.PushBack('Shades Silver Flameborn 2');
		return;

	case 'Shades Silver Frostmourne':
	case 'Shades Silver Frostmourne 1':
	case 'Shades Silver Frostmourne 2':
		entries.PushBack('Shades Silver Frostmourne');
		entries.PushBack('Shades Silver Frostmourne 1');
		entries.PushBack('Shades Silver Frostmourne 2');
		return;

	case 'Shades Silver Gorgonslayer':
	case 'Shades Silver Gorgonslayer 1':
	case 'Shades Silver Gorgonslayer 2':
		entries.PushBack('Shades Silver Gorgonslayer');
		entries.PushBack('Shades Silver Gorgonslayer 1');
		entries.PushBack('Shades Silver Gorgonslayer 2');
		return;

	case 'Shades Silver Graveripper':
	case 'Shades Silver Graveripper 1':
	case 'Shades Silver Graveripper 2':
		entries.PushBack('Shades Silver Graveripper');
		entries.PushBack('Shades Silver Graveripper 1');
		entries.PushBack('Shades Silver Graveripper 2');
		return;

	case 'Shades Silver Guandao':
	case 'Shades Silver Guandao 1':
	case 'Shades Silver Guandao 2':
		entries.PushBack('Shades Silver Guandao');
		entries.PushBack('Shades Silver Guandao 1');
		entries.PushBack('Shades Silver Guandao 2');
		return;

	case 'Shades Silver Crownbreaker':
	case 'Shades Silver Crownbreaker 1':
	case 'Shades Silver Crownbreaker 2':
		entries.PushBack('Shades Silver Crownbreaker');
		entries.PushBack('Shades Silver Crownbreaker 1');
		entries.PushBack('Shades Silver Crownbreaker 2');
		return;

	case 'Shades Silver Hades Grasp':
	case 'Shades Silver Hades Grasp 1':
	case 'Shades Silver Hades Grasp 2':
		entries.PushBack('Shades Silver Hades Grasp');
		entries.PushBack('Shades Silver Hades Grasp 1');
		entries.PushBack('Shades Silver Hades Grasp 2');
		return;

	case 'Shades Silver Haoma':
	case 'Shades Silver Haoma 1':
	case 'Shades Silver Haoma 2':
		entries.PushBack('Shades Silver Haoma');
		entries.PushBack('Shades Silver Haoma 1');
		entries.PushBack('Shades Silver Haoma 2');
		return;

	case 'Shades Silver Heavenspire':
	case 'Shades Silver Heavenspire 1':
	case 'Shades Silver Heavenspire 2':
		entries.PushBack('Shades Silver Heavenspire');
		entries.PushBack('Shades Silver Heavenspire 1');
		entries.PushBack('Shades Silver Heavenspire 2');
		return;

	case 'Shades Silver Hellspire':
	case 'Shades Silver Hellspire 1':
	case 'Shades Silver Hellspire 2':
		entries.PushBack('Shades Silver Hellspire');
		entries.PushBack('Shades Silver Hellspire 1');
		entries.PushBack('Shades Silver Hellspire 2');
		return;

	case 'Shades Silver Icarus Tears':
	case 'Shades Silver Icarus Tears 1':
	case 'Shades Silver Icarus Tears 2':
		entries.PushBack('Shades Silver Icarus Tears');
		entries.PushBack('Shades Silver Icarus Tears 1');
		entries.PushBack('Shades Silver Icarus Tears 2');
		return;

	case 'Shades Silver Ryu Katana':
	case 'Shades Silver Ryu Katana 1':
	case 'Shades Silver Ryu Katana 2':
		entries.PushBack('Shades Silver Ryu Katana');
		entries.PushBack('Shades Silver Ryu Katana 1');
		entries.PushBack('Shades Silver Ryu Katana 2');
		return;

	case 'Shades Silver Lion Sword':
	case 'Shades Silver Lion Sword 1':
	case 'Shades Silver Lion Sword 2':
		entries.PushBack('Shades Silver Lion Sword');
		entries.PushBack('Shades Silver Lion Sword 1');
		entries.PushBack('Shades Silver Lion Sword 2');
		return;

	case 'Shades Silver Oathblade':
	case 'Shades Silver Oathblade 1':
	case 'Shades Silver Oathblade 2':
		entries.PushBack('Shades Silver Oathblade');
		entries.PushBack('Shades Silver Oathblade 1');
		entries.PushBack('Shades Silver Oathblade 2');
		return;

	case 'Shades Silver Oblivion':
	case 'Shades Silver Oblivion 1':
	case 'Shades Silver Oblivion 2':
		entries.PushBack('Shades Silver Oblivion');
		entries.PushBack('Shades Silver Oblivion 1');
		entries.PushBack('Shades Silver Oblivion 2');
		return;

	case 'Shades Silver Hitokiri Katana':
	case 'Shades Silver Hitokiri Katana 1':
	case 'Shades Silver Hitokiri Katana 2':
		entries.PushBack('Shades Silver Hitokiri Katana');
		entries.PushBack('Shades Silver Hitokiri Katana 1');
		entries.PushBack('Shades Silver Hitokiri Katana 2');
		return;

	case 'Shades Silver Pridefall':
	case 'Shades Silver Pridefall 1':
	case 'Shades Silver Pridefall 2':
		entries.PushBack('Shades Silver Pridefall');
		entries.PushBack('Shades Silver Pridefall 1');
		entries.PushBack('Shades Silver Pridefall 2');
		return;

	case 'Shades Silver Rakuyo':
	case 'Shades Silver Rakuyo 1':
	case 'Shades Silver Rakuyo 2':
		entries.PushBack('Shades Silver Rakuyo');
		entries.PushBack('Shades Silver Rakuyo 1');
		entries.PushBack('Shades Silver Rakuyo 2');
		return;

	case 'Shades Silver Realmdrifter Blade':
	case 'Shades Silver Realmdrifter Blade 1':
	case 'Shades Silver Realmdrifter Blade 2':
		entries.PushBack('Shades Silver Realmdrifter Blade');
		entries.PushBack('Shades Silver Realmdrifter Blade 1');
		entries.PushBack('Shades Silver Realmdrifter Blade 2');
		return;

	case 'Shades Silver Realmdrifter Divider':
	case 'Shades Silver Realmdrifter Divider 1':
	case 'Shades Silver Realmdrifter Divider 2':
		entries.PushBack('Shades Silver Realmdrifter Divider');
		entries.PushBack('Shades Silver Realmdrifter Divider 1');
		entries.PushBack('Shades Silver Realmdrifter Divider 2');
		return;

	case 'Shades Silver Kukri':
	case 'Shades Silver Kukri 1':
	case 'Shades Silver Kukri 2':
		entries.PushBack('Shades Silver Kukri');
		entries.PushBack('Shades Silver Kukri 1');
		entries.PushBack('Shades Silver Kukri 2');
		return;

	case 'Shades Silver Sinner':
	case 'Shades Silver Sinner 1':
	case 'Shades Silver Sinner 2':
		entries.PushBack('Shades Silver Sinner');
		entries.PushBack('Shades Silver Sinner 1');
		entries.PushBack('Shades Silver Sinner 2');
		return;

	case 'Shades Silver Sithis Blade':
	case 'Shades Silver Sithis Blade 1':
	case 'Shades Silver Sithis Blade 2':
		entries.PushBack('Shades Silver Sithis Blade');
		entries.PushBack('Shades Silver Sithis Blade 1');
		entries.PushBack('Shades Silver Sithis Blade 2');
		return;

	case 'Shades Silver Voidblade':
	case 'Shades Silver Voidblade 1':
	case 'Shades Silver Voidblade 2':
		entries.PushBack('Shades Silver Voidblade');
		entries.PushBack('Shades Silver Voidblade 1');
		entries.PushBack('Shades Silver Voidblade 2');
		return;

	case 'Shades Silver Vulcan':
	case 'Shades Silver Vulcan 1':
	case 'Shades Silver Vulcan 2':
		entries.PushBack('Shades Silver Vulcan');
		entries.PushBack('Shades Silver Vulcan 1');
		entries.PushBack('Shades Silver Vulcan 2');
		return;

	case 'Shades Silver Knife':
	case 'Shades Silver Knife 1':
	case 'Shades Silver Knife 2':
		entries.PushBack('Shades Silver Knife');
		entries.PushBack('Shades Silver Knife 1');
		entries.PushBack('Shades Silver Knife 2');
		return;
		
	default:
		return;
	}
}

function PotP_Get_SOI_SteelVariations(e_Identifier : name, out entries : array< name >) : void {

	switch (e_Identifier) {

	//---// Steel Swords

	case 'Shades Steel Eagle Sword':
	case 'Shades Steel Eagle Sword 1':
	case 'Shades Steel Eagle Sword 2':
		entries.PushBack('Shades Steel Eagle Sword');
		entries.PushBack('Shades Steel Eagle Sword 1');
		entries.PushBack('Shades Steel Eagle Sword 2');
		return;

	case 'Shades Steel Ares':
	case 'Shades Steel Ares 1':
	case 'Shades Steel Ares 2':
		entries.PushBack('Shades Steel Ares');
		entries.PushBack('Shades Steel Ares 1');
		entries.PushBack('Shades Steel Ares 2');
		return;

	case 'Shades Steel Doomblade':
	case 'Shades Steel Doomblade 1':
	case 'Shades Steel Doomblade 2':
		entries.PushBack('Shades Steel Doomblade');
		entries.PushBack('Shades Steel Doomblade 1');
		entries.PushBack('Shades Steel Doomblade 2');
		return;
		
	case 'Shades Steel Beastcutter':
	case 'Shades Steel Beastcutter 1':
	case 'Shades Steel Beastcutter 2':
		entries.PushBack('Shades Steel Beastcutter');
		entries.PushBack('Shades Steel Beastcutter 1');
		entries.PushBack('Shades Steel Beastcutter 2');
		return;

	case 'Shades Steel Blackdawn':
	case 'Shades Steel Blackdawn 1':
	case 'Shades Steel Blackdawn 2':
		entries.PushBack('Shades Steel Blackdawn');
		entries.PushBack('Shades Steel Blackdawn 1');
		entries.PushBack('Shades Steel Blackdawn 2');
		return;

	case 'Shades Steel Blooddusk':
	case 'Shades Steel Blooddusk 1':
	case 'Shades Steel Blooddusk 2':
		entries.PushBack('Shades Steel Blooddusk');
		entries.PushBack('Shades Steel Blooddusk 1');
		entries.PushBack('Shades Steel Blooddusk 2');
		return;

	case 'Shades Steel Bloodletter':
	case 'Shades Steel Bloodletter 1':
	case 'Shades Steel Bloodletter 2':
		entries.PushBack('Shades Steel Bloodletter');
		entries.PushBack('Shades Steel Bloodletter 1');
		entries.PushBack('Shades Steel Bloodletter 2');
		return;

	case 'Shades Steel Bloodshot':
	case 'Shades Steel Bloodshot 1':
	case 'Shades Steel Bloodshot 2':
		entries.PushBack('Shades Steel Bloodshot');
		entries.PushBack('Shades Steel Bloodshot 1');
		entries.PushBack('Shades Steel Bloodshot 2');
		return;

	case 'Shades Steel Claymore':
	case 'Shades Steel Claymore 1':
	case 'Shades Steel Claymore 2':
		entries.PushBack('Shades Steel Claymore');
		entries.PushBack('Shades Steel Claymore 1');
		entries.PushBack('Shades Steel Claymore 2');
		return;

	case 'Shades Steel Kingslayer':
	case 'Shades Steel Kingslayer 1':
	case 'Shades Steel Kingslayer 2':
		entries.PushBack('Shades Steel Kingslayer');
		entries.PushBack('Shades Steel Kingslayer 1');
		entries.PushBack('Shades Steel Kingslayer 2');
		return;

	case 'Shades Steel Cursed Khopesh':
	case 'Shades Steel Cursed Khopesh 1':
	case 'Shades Steel Cursed Khopesh 2':
		entries.PushBack('Shades Steel Cursed Khopesh');
		entries.PushBack('Shades Steel Cursed Khopesh 1');
		entries.PushBack('Shades Steel Cursed Khopesh 2');
		return;

	case 'Shades Steel Dragonbane':
	case 'Shades Steel Dragonbane 1':
	case 'Shades Steel Dragonbane 2':
		entries.PushBack('Shades Steel Dragonbane');
		entries.PushBack('Shades Steel Dragonbane 1');
		entries.PushBack('Shades Steel Dragonbane 2');
		return;

	case 'Shades Steel Ejderblade':
	case 'Shades Steel Ejderblade 1':
	case 'Shades Steel Ejderblade 2':
		entries.PushBack('Shades Steel Ejderblade');
		entries.PushBack('Shades Steel Ejderblade 1');
		entries.PushBack('Shades Steel Ejderblade 2');
		return;

	case 'Shades Steel Flameborn':
	case 'Shades Steel Flameborn 1':
	case 'Shades Steel Flameborn 2':
		entries.PushBack('Shades Steel Flameborn');
		entries.PushBack('Shades Steel Flameborn 1');
		entries.PushBack('Shades Steel Flameborn 2');
		return;

	case 'Shades Steel Frostmourne':
	case 'Shades Steel Frostmourne 1':
	case 'Shades Steel Frostmourne 2':
		entries.PushBack('Shades Steel Frostmourne');
		entries.PushBack('Shades Steel Frostmourne 1');
		entries.PushBack('Shades Steel Frostmourne 2');
		return;

	case 'Shades Steel Gorgonslayer':
	case 'Shades Steel Gorgonslayer 1':
	case 'Shades Steel Gorgonslayer 2':
		entries.PushBack('Shades Steel Gorgonslayer');
		entries.PushBack('Shades Steel Gorgonslayer 1');
		entries.PushBack('Shades Steel Gorgonslayer 2');
		return;

	case 'Shades Steel Graveripper':
	case 'Shades Steel Graveripper 1':
	case 'Shades Steel Graveripper 2':
		entries.PushBack('Shades Steel Graveripper');
		entries.PushBack('Shades Steel Graveripper 1');
		entries.PushBack('Shades Steel Graveripper 2');
		return;

	case 'Shades Steel Guandao':
	case 'Shades Steel Guandao 1':
	case 'Shades Steel Guandao 2':
		entries.PushBack('Shades Steel Guandao');
		entries.PushBack('Shades Steel Guandao 1');
		entries.PushBack('Shades Steel Guandao 2');
		return;

	case 'Shades Steel Crownbreaker':
	case 'Shades Steel Crownbreaker 1':
	case 'Shades Steel Crownbreaker 2':
		entries.PushBack('Shades Steel Crownbreaker');
		entries.PushBack('Shades Steel Crownbreaker 1');
		entries.PushBack('Shades Steel Crownbreaker 2');
		return;

	case 'Shades Steel Hades Grasp':
	case 'Shades Steel Hades Grasp 1':
	case 'Shades Steel Hades Grasp 2':
		entries.PushBack('Shades Steel Hades Grasp');
		entries.PushBack('Shades Steel Hades Grasp 1');
		entries.PushBack('Shades Steel Hades Grasp 2');
		return;

	case 'Shades Steel Haoma':
	case 'Shades Steel Haoma 1':
	case 'Shades Steel Haoma 2':
		entries.PushBack('Shades Steel Haoma');
		entries.PushBack('Shades Steel Haoma 1');
		entries.PushBack('Shades Steel Haoma 2');
		return;

	case 'Shades Steel Heavenspire':
	case 'Shades Steel Heavenspire 1':
	case 'Shades Steel Heavenspire 2':
		entries.PushBack('Shades Steel Heavenspire');
		entries.PushBack('Shades Steel Heavenspire 1');
		entries.PushBack('Shades Steel Heavenspire 2');
		return;

	case 'Shades Steel Hellspire':
	case 'Shades Steel Hellspire 1':
	case 'Shades Steel Hellspire 2':
		entries.PushBack('Shades Steel Hellspire');
		entries.PushBack('Shades Steel Hellspire 1');
		entries.PushBack('Shades Steel Hellspire 2');
		return;

	case 'Shades Steel Icarus Tears':
	case 'Shades Steel Icarus Tears 1':
	case 'Shades Steel Icarus Tears 2':
		entries.PushBack('Shades Steel Icarus Tears');
		entries.PushBack('Shades Steel Icarus Tears 1');
		entries.PushBack('Shades Steel Icarus Tears 2');
		return;

	case 'Shades Steel Ryu Katana':
	case 'Shades Steel Ryu Katana 1':
	case 'Shades Steel Ryu Katana 2':
		entries.PushBack('Shades Steel Ryu Katana');
		entries.PushBack('Shades Steel Ryu Katana 1');
		entries.PushBack('Shades Steel Ryu Katana 2');
		return;

	case 'Shades Steel Lion Sword':
	case 'Shades Steel Lion Sword 1':
	case 'Shades Steel Lion Sword 2':
		entries.PushBack('Shades Steel Lion Sword');
		entries.PushBack('Shades Steel Lion Sword 1');
		entries.PushBack('Shades Steel Lion Sword 2');
		return;

	case 'Shades Steel Oathblade':
	case 'Shades Steel Oathblade 1':
	case 'Shades Steel Oathblade 2':
		entries.PushBack('Shades Steel Oathblade');
		entries.PushBack('Shades Steel Oathblade 1');
		entries.PushBack('Shades Steel Oathblade 2');
		return;

	case 'Shades Steel Oblivion':
	case 'Shades Steel Oblivion 1':
	case 'Shades Steel Oblivion 2':
		entries.PushBack('Shades Steel Oblivion');
		entries.PushBack('Shades Steel Oblivion 1');
		entries.PushBack('Shades Steel Oblivion 2');
		return;

	case 'Shades Steel Hitokiri Katana':
	case 'Shades Steel Hitokiri Katana 1':
	case 'Shades Steel Hitokiri Katana 2':
		entries.PushBack('Shades Steel Hitokiri Katana');
		entries.PushBack('Shades Steel Hitokiri Katana 1');
		entries.PushBack('Shades Steel Hitokiri Katana 2');
		return;

	case 'Shades Steel Pridefall':
	case 'Shades Steel Pridefall 1':
	case 'Shades Steel Pridefall 2':
		entries.PushBack('Shades Steel Pridefall');
		entries.PushBack('Shades Steel Pridefall 1');
		entries.PushBack('Shades Steel Pridefall 2');
		return;

	case 'Shades Steel Rakuyo':
	case 'Shades Steel Rakuyo 1':
	case 'Shades Steel Rakuyo 2':
		entries.PushBack('Shades Steel Rakuyo');
		entries.PushBack('Shades Steel Rakuyo 1');
		entries.PushBack('Shades Steel Rakuyo 2');
		return;

	case 'Shades Steel Realmdrifter Blade':
	case 'Shades Steel Realmdrifter Blade 1':
	case 'Shades Steel Realmdrifter Blade 2':
		entries.PushBack('Shades Steel Realmdrifter Blade');
		entries.PushBack('Shades Steel Realmdrifter Blade 1');
		entries.PushBack('Shades Steel Realmdrifter Blade 2');
		return;

	case 'Shades Steel Realmdrifter Divider':
	case 'Shades Steel Realmdrifter Divider 1':
	case 'Shades Steel Realmdrifter Divider 2':
		entries.PushBack('Shades Steel Realmdrifter Divider');
		entries.PushBack('Shades Steel Realmdrifter Divider 1');
		entries.PushBack('Shades Steel Realmdrifter Divider 2');
		return;

	case 'Shades Steel Kukri':
	case 'Shades Steel Kukri 1':
	case 'Shades Steel Kukri 2':
		entries.PushBack('Shades Steel Kukri');
		entries.PushBack('Shades Steel Kukri 1');
		entries.PushBack('Shades Steel Kukri 2');
		return;

	case 'Shades Steel Sinner':
	case 'Shades Steel Sinner 1':
	case 'Shades Steel Sinner 2':
		entries.PushBack('Shades Steel Sinner');
		entries.PushBack('Shades Steel Sinner 1');
		entries.PushBack('Shades Steel Sinner 2');
		return;

	case 'Shades Steel Sithis Blade':
	case 'Shades Steel Sithis Blade 1':
	case 'Shades Steel Sithis Blade 2':
		entries.PushBack('Shades Steel Sithis Blade');
		entries.PushBack('Shades Steel Sithis Blade 1');
		entries.PushBack('Shades Steel Sithis Blade 2');
		return;

	case 'Shades Steel Voidblade':
	case 'Shades Steel Voidblade 1':
	case 'Shades Steel Voidblade 2':
		entries.PushBack('Shades Steel Voidblade');
		entries.PushBack('Shades Steel Voidblade 1');
		entries.PushBack('Shades Steel Voidblade 2');
		return;

	case 'Shades Steel Vulcan':
	case 'Shades Steel Vulcan 1':
	case 'Shades Steel Vulcan 2':
		entries.PushBack('Shades Steel Vulcan');
		entries.PushBack('Shades Steel Vulcan 1');
		entries.PushBack('Shades Steel Vulcan 2');
		return;

	case 'Shades Steel Knife':
	case 'Shades Steel Knife 1':
	case 'Shades Steel Knife 2':
		entries.PushBack('Shades Steel Knife');
		entries.PushBack('Shades Steel Knife 1');
		entries.PushBack('Shades Steel Knife 2');
		return;
		
	default:
		return;
	}
}