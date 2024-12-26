//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_pos() 
{
	GetWitcherPlayer().DisplayHudMessage(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));
	LogChannel('PotP Position', VecToString(thePlayer.GetWorldPosition()));
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_spiral()
{
	theGame.ScheduleWorldChangeToMapPin( "levels\the_spiral\spiral.w2w", '' );
	theGame.RequestAutoSave( "fast travel", true );
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_forest() 
{
	if(theGame.GetCommonMapManager().GetCurrentArea() == 7) {
		thePlayer.Teleport(Vector(-671.004,-2248.409,81.81971,1));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_reload() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_reload'))
	{
		master.PotP_PersistentStorage.PotP_LoadStorageCollection(PotP_Reset_All, true);
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_ng() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_ng'))
	{
		master.reset_for_ng_plus();
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------
//pt_LogPins('BanditCamp')
exec function pt_LogPins(PinType: name) {

	var MapPins: array<SEntityMapPinInfo> = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());
	var Idx: int;	
	
	for (Idx = 0; Idx < MapPins.Size(); Idx += 1) {
	  
		if ( MapPins[Idx].entityType != PinType ) {
			continue;
		}
		
		LogChannel('Progress on the Path Map Pin', Idx + ": baseName = " + MapPins[Idx].entityName + " | LocaName = " + GetLocStringByKeyExt("Map_Location_"+NameToString(MapPins[Idx].entityName)));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_update()
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_update'))
	{
		master.PotP_UpdaterClass.StartUpdate();
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_state() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_state'))
	{
		PotP_Logger("Got master from GetPotP()", false, 'pt_state');
		GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Current State = " + NameToString(master.GetCurrentStateName()));
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_reset() 
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_reset'))
	{
		master.PotP_PersistentStorage.MasterList_Completed_V.Clear();
		master.PotP_PersistentStorage.MasterList_IsIgnored_V.Clear();
		master.PotP_PersistentStorage.MasterList_InProgres_V.Clear();
		GetWitcherPlayer().DisplayHudMessage("Progress on the Path: Reset Completed");
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_testtest() 
{
	var master: CProgressOnThePath;
	var storage: CProgressOnThePath_Storage;
	
	var I, Q, W: PotP_PreviewEntry;	
	var Edx, x, y, z: int;
	
	if (GetPotP(master, 'pt_testtest'))
	{
		storage = master.PotP_PersistentStorage;
		
		x = storage.pItemsStorage.MasterList_Items.Size();
		y = storage.pQuestStorage.MasterList_Quests.Size();
		z = storage.pWorldStorage.MasterList_World.Size();
		
		Edx = Min(x, y);	
		Edx = Min(Edx, z);
		Edx = RandRange(Edx, 0);
		
		I = storage.pItemsStorage.MasterList_Items[Edx];
		Q = storage.pQuestStorage.MasterList_Quests[Edx];
		W = storage.pWorldStorage.MasterList_World[Edx];
		
		master.PotP_EntityHelper.AddToBackgroundQueue(I);
		master.PotP_EntityHelper.AddToBackgroundQueue(Q, 2);
		master.PotP_EntityHelper.AddToBackgroundQueue(W);
			
		master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
	}
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_checkfact(s: string) {
	
	var exist: bool = FactsDoesExist(s);
	var value: int = FactsQuerySum(s);
	
	if (exist) { GetWitcherPlayer().DisplayHudMessage("PotP Fact: [" + s + "] exists with a value of - [" + value + "]"); }
	else { GetWitcherPlayer().DisplayHudMessage("PotP Fact: [" + s + "] does not exist"); }
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_version() {
	
	var exist: bool = FactsDoesExist("ProgressOnThePath_CurrentModVersion");
	var value: int = FactsQuerySum("ProgressOnThePath_CurrentModVersion");
	
	if (exist) { GetWitcherPlayer().DisplayHudMessage("PotP Version = " + value); }
	else { GetWitcherPlayer().DisplayHudMessage("PotP: Versioning Error"); }
}

//---------------------------------------------------
//-- Exec Functions ---------------------------------
//---------------------------------------------------

exec function pt_sizes()
{
	var master: CProgressOnThePath;
	
	if (GetPotP(master, 'pt_sizes'))
	{
		PotP_Logger("Got master from GetPotP()", false, 'pt_sizes');
		master.PotP_Notifications._ShowListSizes();
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_complete()
{
	var master: CProgressOnThePath;
	var Idx: int;
	
	if (GetPotP(master, 'pt_complete'))
	{
		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pEventStorage.MasterList_Events.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pEventStorage.MasterList_Events[Idx]);
		}
		
		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests[Idx]);
		}

		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pWorldStorage.MasterList_World.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pWorldStorage.MasterList_World[Idx]);
		}

		for ( Idx = 0; Idx < master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.Size(); Idx += 1 ) {
			master.PotP_EntityHelper.SetCompleted(master.PotP_PersistentStorage.pItemsStorage.MasterList_Items[Idx]);
		}	
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddSteelSwords(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('PlayerSteelWeapon');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddSilverSwords(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('PlayerSilverWeapon');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);

			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddCrossbows(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {

			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);

			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddTrophies(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('Trophy');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddQuestItems(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('Quest');
	var dup_arr: array< name >;
	var Idx, min, max: int;
		
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1) {
		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			
			if (dup_arr.FindFirst(ent_arr[Idx]) != -1) {
				continue;
			}
				
			PInventory.AddAnItem(ent_arr[Idx], Quantity);
			dup_arr.PushBack(ent_arr[Idx]);
			
			if (LogEntries) {
				LogChannel('PotP Console Items', "["+ Idx +"] BaseName = " + ent_arr[Idx]);
				LogChannel('PotP Console Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ent_arr[Idx])));
				LogChannel('PotP Console Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('PotP Console Items', " ");	
			}

			if (RemoveAfter) {
				PInventory.RemoveItemByName(ent_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_LogGwentCards(only_variations: bool)
{
	var master: CProgressOnThePath;
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag('GwintCard');
	
	var CardArray: array<name>;
	var CardNames: array<string>;
	var CardBases: array< array< name > >;
	var CardName: string;
	var CardBase: name;
	var Idx, Edx: int;
	
	if (!GetPotP(master, 'pt_LogGwentCards'))
	{
		return;
	}	
	
	master.PotP_ItemsGoblin.GotoState('Disabled');
	
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1)
	{
		CardArray.Clear();
		
		PInventory.AddAnItem(ent_arr[Idx], 1);
		
		CardBase = ent_arr[Idx];
		CardName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(CardBase));
		
		if (CardNames.Contains(CardName))
		{
			Edx = CardNames.FindFirst(CardName);
			CardBases[Edx].PushBack(CardBase);
		}
		else
		{
			CardArray.PushBack(CardBase);
			CardNames.PushBack(CardName);
			CardBases.PushBack(CardArray);
		}	
	}
	
	for (Idx = 0; Idx < CardNames.Size(); Idx += 1)
	{
		if (only_variations && CardBases[Idx].Size() == 1)
		{
			continue;
		}
		
		LogChannel('PotP Gwent Card Logger', "["+ Idx +"] Local Name = " + CardNames[Idx]);
		LogChannel('PotP Gwent Card Logger', "["+ Idx +"] Variations = " + CardBases[Idx].Size());
		
		for (Edx = 0; Edx < CardBases[Idx].Size(); Edx += 1)
		{
			LogChannel('PotP Gwent Card Logger', "Variation ["+ Edx +"] = " + CardBases[Idx][Edx]);
		}
		
		LogChannel('PotP Gwent Card Logger', " ");
	}

	master.PotP_ItemsGoblin.GotoState('Idle');
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

//pt_AddItemsByName(Forgotten Wolven, true, 999, 1, false, 'All') {

exec function pt_AddItemsByName(itemName: string, LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool, optional section: name) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	
	var a_arr, w_arr, c_arr: array< name >;
	var dup_arr, fin_arr: array< name >;
	var Idx, min, max: int;
	var localName: string;
	
	if (section == 'Armor' || section == 'All') {
		
		a_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Armor');
		
		for (Idx = 0; Idx < a_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(a_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(a_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(a_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(a_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(a_arr[Idx]);
				}
			}
		}
	}
	
	if (section == 'Weapon' || section == 'All') {
		
		w_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Weapon');
		
		for (Idx = 0; Idx < w_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(w_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(w_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(w_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(w_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(w_arr[Idx]);
				}
			}
		}
	}

	if (section == 'Crossbow' || section == 'All') {
		
		c_arr = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
		
		for (Idx = 0; Idx < c_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(c_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(c_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(c_arr[Idx]);
				localName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(c_arr[Idx]));
				if (StrContains(localName, itemName)) {
					fin_arr.PushBack(c_arr[Idx]);
				}
			}
		}
	}
	
	for (Idx = 0; Idx < fin_arr.Size(); Idx += 1) {
		PInventory.AddAnItem(fin_arr[Idx], Quantity);
		PInventory.GetItemQualityFromName(fin_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			if (LogEntries) {
				LogChannel('Console Added Items', "["+ Idx +"] BaseName = " + fin_arr[Idx]);
				LogChannel('Console Added Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(fin_arr[Idx])));
				LogChannel('Console Added Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('Console Added Items', " ");	
			}	

			if (RemoveAfter) {
				PInventory.RemoveItemByName(fin_arr[Idx], Quantity);
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_AddItemsByQuality(LogEntries: bool, quality: int, optional Quantity: int, optional RemoveAfter: bool, optional section: name) {
	
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	
	var a_arr, w_arr, c_arr: array< name >;
	var dup_arr, fin_arr: array< name >;
	var Idx, min, max: int;
	var localName: string;
	
	if (section == 'Armor' || section == 'All') {
		
		a_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Armor');
		
		for (Idx = 0; Idx < a_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(a_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(a_arr[Idx]) != -1) {
					continue;
				}
				dup_arr.PushBack(a_arr[Idx]);
				fin_arr.PushBack(a_arr[Idx]);
			}
		}
	}
	
	if (section == 'Weapon' || section == 'All') {
		
		w_arr = theGame.GetDefinitionsManager().GetItemsWithTag('Weapon');
		
		for (Idx = 0; Idx < w_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(w_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(w_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(w_arr[Idx]);
				fin_arr.PushBack(w_arr[Idx]);
			}
		}
	}

	if (section == 'Crossbow' || section == 'All') {
		
		c_arr = theGame.GetDefinitionsManager().GetItemsWithTag('crossbow');
		
		for (Idx = 0; Idx < c_arr.Size(); Idx += 1) {
			PInventory.GetItemQualityFromName(c_arr[Idx], min, max);
			if (min == quality || quality == 999) {
				
				if (dup_arr.FindFirst(c_arr[Idx]) != -1) {
					continue;
				}
					
				dup_arr.PushBack(c_arr[Idx]);
				fin_arr.PushBack(c_arr[Idx]);
			}
		}
	}
	
	for (Idx = 0; Idx < fin_arr.Size(); Idx += 1) {
		PInventory.AddAnItem(fin_arr[Idx], Quantity);
		PInventory.GetItemQualityFromName(fin_arr[Idx], min, max);
		if (min == quality || quality == 999) {
			if (LogEntries) {
				LogChannel('Console Added Items', "["+ Idx +"] BaseName = " + fin_arr[Idx]);
				LogChannel('Console Added Items', "["+ Idx +"] LocaName = " + GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(fin_arr[Idx])));
				LogChannel('Console Added Items', "["+ Idx +"] iQuality = " + min);
				LogChannel('Console Added Items', " ");	
			}	

			if (RemoveAfter) {
				PInventory.RemoveItemByName(fin_arr[Idx], Quantity);
			}
		}
	}
}

exec function pt_dlc()
{
	var dlcManager : CDLCManager;
	var dlcNames : array<name>;
	var Idx : int;

	dlcManager = theGame.GetDLCManager();
	dlcManager.GetDLCs(dlcNames);
			
	for (Idx = 0; Idx < dlcNames.Size(); Idx += 1)
	{
		if (dlcManager.IsDLCAvailable(dlcNames[Idx]))
		{
			PotP_Logger(NameToString(dlcNames[Idx]), false);
		}
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

exec function pt_variation(type: name, only_variations: bool)
{
	/*Allowed Types
	 *pt_variation('PlayerSilverWeapon', true)
	 *pt_variation('PlayerSteelWeapon', true)
	 *pt_variation('Trophy', true)
	 */
	 
	var master: CProgressOnThePath;
	var PInventory: CInventoryComponent = thePlayer.GetInventory();
	var ent_arr: array< name > = theGame.GetDefinitionsManager().GetItemsWithTag(type);
	
	var ItemArray: array<name>;
	var ItemNames: array<string>;
	var ItemBases: array< array< name > >;
	var ItemName: string;
	var ItemBase: name;
	var Idx, Edx, min, max: int;
	
	if (!GetPotP(master, 'pt_LogGwentCards'))
	{
		return;
	}	
	
	master.PotP_ItemsGoblin.GotoState('Disabled');
	
	for (Idx = 0; Idx < ent_arr.Size(); Idx += 1)
	{
		ItemArray.Clear();

		PInventory.GetItemQualityFromName(ent_arr[Idx], min, max);
		if (min == 4) 
		{	
			PInventory.AddAnItem(ent_arr[Idx], 1);
			
			ItemBase = ent_arr[Idx];
			ItemName = GetLocStringByKeyExt(theGame.GetDefinitionsManager().GetItemLocalisationKeyName(ItemBase));
			
			if (ItemNames.Contains(ItemName))
			{
				Edx = ItemNames.FindFirst(ItemName);
				ItemBases[Edx].PushBack(ItemBase);
			}
			else
			{
				ItemArray.PushBack(ItemBase);
				ItemNames.PushBack(ItemName);
				ItemBases.PushBack(ItemArray);
			}	
		}
	}
	
	for (Idx = 0; Idx < ItemNames.Size(); Idx += 1)
	{
		if (only_variations && ItemBases[Idx].Size() == 1)
		{
			continue;
		}
		
		LogChannel('PotP Variation Logger', "["+ Idx +"] Local Name = " + ItemNames[Idx]);
		LogChannel('PotP Variation Logger', "["+ Idx +"] Variations = " + ItemBases[Idx].Size());
		
		for (Edx = 0; Edx < ItemBases[Idx].Size(); Edx += 1)
		{
			LogChannel('PotP Variation Logger', "Variation ["+ Edx +"] = " + ItemBases[Idx][Edx]);
		}
		
		LogChannel('PotP Variation Logger', " ");
	}

	master.PotP_ItemsGoblin.GotoState('Idle');
}

