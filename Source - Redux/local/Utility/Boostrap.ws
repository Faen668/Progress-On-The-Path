//---------------------------------------------------
//-- Bootstrapper Wrapper ---------------------------
//---------------------------------------------------

@addField( CR4Player )
public saved var PotP: CProgressOnThePath;

@wrapMethod( CR4Player ) function OnSpawned( spawnData : SEntitySpawnData )
{
	wrappedMethod( spawnData );
	
	if (!PotP)
	{
		PotP_Logger("Creating new PotP Instance...", , 'PotP Bootstrapper');
		PotP = (new CProgressOnThePath in this);
	}
	else
	{
		PotP_Logger("Loading existing PotP Instance...", , 'PotP Bootstrapper');
	}
	
	PotP.start();
}

//---------------------------------------------------
//---------------------------------------------------
//---------------------------------------------------

@wrapMethod( CR4CommonIngameMenu ) function OnClosingMenu()
{
	wrappedMethod();
	thePlayer.PotP.EvaluateOptionsOnMenuClose();
}

//---------------------------------------------------
//-- GUI Tooltip Wrapper ----------------------------
//---------------------------------------------------

@wrapMethod( W3TooltipComponent ) function GetBaseItemData( item : SItemUniqueId, itemInvComponent : CInventoryComponent, optional isShopItem : bool, optional compareWithItem : SItemUniqueId, optional compareItemInv : CInventoryComponent ) : CScriptedFlashObject
{
	var ttData: CScriptedFlashObject;
	var itemName: name;
	var itemLabel: string;
	var itemCategory: name;
	var itemRarity: string;
	var itemQuality: int;
	
	itemName = itemInvComponent.GetItemName(item);		
	itemLabel = GetLocStringByKeyExt(itemInvComponent.GetItemLocalizedNameByUniqueID(item));
	itemCategory = itemInvComponent.GetItemCategory(item);
	itemQuality = itemInvComponent.GetItemQuality(item);
		
	switch(itemQuality)
	{
		case 1:
			itemRarity = "<font color='#a2a2a2'>";
			break;
		case 2:
			itemRarity = "<font color='#2b7bff'>";
			break;
		case 3:
			itemRarity = "<font color='#e1d401'>";
			break;
		case 4:
			itemRarity = "<font color='#ca610c'>";
			break;
		case 5:
			itemRarity = "<font color='#01b701'>";
			break;
	}
	
	ttData = wrappedMethod( item, itemInvComponent, isShopItem, compareWithItem, compareItemInv );
	if ( isShopItem && (itemInvComponent.IsItemAnyArmor(item) || itemInvComponent.IsItemWeapon(item) || itemCategory == 'gwint' || itemCategory == 'trophy') ) 
	{ 
		ttData.SetMemberFlashString("ItemName", itemRarity + PotP_GetCollectedString(this, itemName, itemLabel, item, itemInvComponent) + "</font>");
	}
	
	return ttData;
}