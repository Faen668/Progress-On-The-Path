//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsUsingNextGen() : bool 
{
	return !StrStartsWith(theGame.GetApplicationVersion(), "v 3");
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP(out master: CProgressOnThePath, optional caller: string): bool 
{
	PotP_Logger("GetPotP Called by [" + caller + "]");
	master = (CProgressOnThePath)SUTB_getModByTag('CProgressOnThePath_BootStrapper');
	
	if (master)
	{
		return true;
	}
	return false;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_QuestGoblin(optional caller: string): CProgressOnThePath_QuestGoblin 
{
	var master: CProgressOnThePath;
	
	if (!GetPotP(master, caller)) 
	{ 
		return NULL; 
	}
	
	return master.PotP_QuestGoblin;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Mappins(): CProgressOnThePath_MapPins 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_PinManager;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Storage(): CProgressOnThePath_Storage 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_PersistentStorage;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function GetPotP_Notifications(): CProgressOnThePath_Notifications 
{
	var master: CProgressOnThePath;
	GetPotP(master);
	
	return master.PotP_Notifications;
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_IsPlayerBusy(): bool 
{
	if (PotP_PlayerIsMeditating()) 
	{
		return false;
	}
	
	return thePlayer.IsInNonGameplayCutscene()
		|| theGame.IsLoadingScreenVideoPlaying()
		|| thePlayer.IsInGameplayScene()
		|| (!thePlayer.IsActionAllowed(EIAB_DrawWeapon) && theGame.GetCommonMapManager().GetCurrentArea() != AN_Wyzima)
		|| thePlayer.IsCiri()
		|| theGame.IsDialogOrCutscenePlaying()
		|| theGame.IsCurrentlyPlayingNonGameplayScene()
		|| theGame.IsFading()
		|| theGame.IsBlackscreen()
		|| thePlayer.IsInFistFightMiniGame()
		|| thePlayer.IsInCombat()
		|| !thePlayer.IsAlive();
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_PlayerIsMeditating() : bool 
{
	return thePlayer.GetCurrentStateName() == 'Meditation' || thePlayer.GetCurrentStateName() == 'W3EEMeditation';
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_SortPreviewData(out pData: array<PotP_PreviewEntry>, type: PotP_Preview_Array_Type, master: CProgressOnThePath) 
{
	var data: array<PotP_PreviewEntry>;
	var temp: array<string>;
	var Idx, Edx, Rdx: int;
	
	data = pData;

	for ( Idx = 0; Idx < pData.Size(); Idx += 1 ) 
	{
		temp.PushBack(pData[Idx].localname);
	}
	
	ArraySortStrings(temp);
	pData.Clear();
	
	for ( Idx = 0; Idx < temp.Size(); Idx += 1 ) 
	{
		for ( Edx = 0; Edx < data.Size(); Edx += 1 ) 
		{
			if (temp[Idx] == data[Edx].localname) 
			{
				data[Edx].arrayType  	= type;
					
				pData.PushBack( data[Edx] );
				
				switch ( type )
				{
				case PotP_A_Quest:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pQuestStorage.CreateUniqueIdentifier();
					if ( data[Edx].is_missable ) 
					{
						master.PotP_PersistentStorage.pQuestStorage.AddToMissableArray( data[Edx] );
					}
					master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests.PushBack( data[Edx] );
					master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests_Lookup.PushBack( data[Edx].entryname );
					break;
					
				case PotP_A_Event:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pEventStorage.CreateUniqueIdentifier();
					master.PotP_PersistentStorage.pEventStorage.MasterList_Events.PushBack( data[Edx] );
					break;
					
				case PotP_A_World:
					
					data[Edx].identifier = master.PotP_PersistentStorage.pWorldStorage.CreateUniqueIdentifier();
					master.PotP_PersistentStorage.pWorldStorage.MasterList_World.PushBack( data[Edx] );
					break;
					
				case PotP_A_Items:
				case PotP_A_Gwent:	
					
					data[Edx].identifier = master.PotP_PersistentStorage.pItemsStorage.CreateUniqueIdentifier();
					for ( Rdx = 0; Rdx < data[Edx].variations.Size(); Rdx += 1 )
					{
						master.PotP_PersistentStorage.pItemsStorage.SupportedItemsList.PushBack( data[Edx].variations[Rdx] );
						master.PotP_PersistentStorage.pItemsStorage.SupportedItemsList_Entity.PushBack( data[Edx] );
					}
					master.PotP_PersistentStorage.pItemsStorage.MasterList_Items.PushBack( data[Edx] );
					break;
				}
			}
		}
	}
}

//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_ChangeQuestStatus(identifier: string, optional value: pStatus)
{
	var master: CProgressOnThePath;	
	var EntList: array<PotP_PreviewEntry>;
	var IdeList: array<string>;
	var Idx: int;

	if (!GetPotP(master, "PotP_ChangeQuesyStatus")) 
		return;

	EntList = master.PotP_PersistentStorage.pArrayStorage.TotalEntList;	
	IdeList = master.PotP_PersistentStorage.pArrayStorage.TotalIdeList;
	
	Idx = IdeList.FindFirst(identifier);
	
	if (Idx == -1) 
		return;
	
	switch (value) 
	{
	case completed:	
		master.PotP_EntityHelper.SetCompleted(EntList[Idx], true);
		break;
		
	case ignored:
		master.PotP_EntityHelper.SetIgnored(EntList[Idx], true);
		break;
		
	default:
		master.PotP_EntityHelper.SetAvailable(EntList[Idx], true);
		break;
	}
}
	
//---------------------------------------------------
//-- Functions --------------------------------------
//---------------------------------------------------

function PotP_Logger(message: string, optional ShowInGUI: bool, optional filename: name) 
{	
	/*Comment The Line Out On Release Version */ if ( StrContains(message, "Entered state") ) { return; }
	
	if (filename == '') 
	{
		filename = 'PotP';
	}
	
	LogChannel(filename, message);
  
	if (ShowInGUI)
	{
		GetWitcherPlayer().DisplayHudMessage(NameToString(filename) + ": " + message);
	}
}

