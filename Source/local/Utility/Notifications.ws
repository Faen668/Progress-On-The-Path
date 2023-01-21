//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

class CProgressOnThePath_Notifications
{
	private var BackGroundProcessingArray_Count: int;
	private var BackGroundProcessingArray_Name: array<string>;
	private var BackGroundProcessingArray_Icon: array<string>;

	private var BackGroundQuestArray_Name: array<string>;
	private var BackGroundQuestArray_Icon: array<string>;
	private var BackGroundQuestArray_Count: int;
	
	private var BackGroundItemArray_Name: array<string>;
	private var BackGroundItemArray_Icon: array<string>;
	private var BackGroundItemArray_Count: int;

	private var BackGroundWorldMapArray_Name: array<string>;
	private var BackGroundWorldMapArray_Icon: array<string>;
	private var BackGroundWorldMapArray_Count: int;
	
	private var TrackerUpdateArray_Count: int;
	private var TrackerUpdateArray_Name: array<string>;
	private var TrackerUpdateArray_Icon: array<string>;
	private var TrackerUpdateArray_Ints: array<int>;

	private var QuestUpdateArray_Name: array<string>;
	private var QuestUpdateArray_Icon: array<string>;
	private var QuestUpdateArray_Ints: array<int>;

	private var ItemUpdateArray_Name: array<string>;
	private var ItemUpdateArray_Icon: array<string>;
	private var ItemUpdateArray_Ints: array<int>;

	private var WorldMapUpdateArray_Name: array<string>;
	private var WorldMapUpdateArray_Icon: array<string>;
	private var WorldMapUpdateArray_Ints: array<int>;
	
	private var fontsize: int;
		default fontsize = 18;

	private var iconPath_MoDen: string;
		default iconPath_MoDen = "icons/PotP/tracked_monsterden_dark.png";

	private var iconPath_MoNes: string;
		default iconPath_MoNes = "icons/PotP/tracked_monsternest_dark.png";

	private var iconPath_RSign: string;
		default iconPath_RSign = "icons/PotP/tracked_roadsign_dark.png";
		
	private var iconPath_Place: string;
		default iconPath_Place = "icons/PotP/tracked_placeofpower_dark.png";

	private var iconPath_Camps: string;
		default iconPath_Camps = "icons/PotP/tracked_banditcamp_dark.png";

	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Notifications
	{
		this.master = PotP_BaseClass;
		return this;
	}
	
	//---------------------------------------------------
	
	public function UpdateQuestCounter(value: int, groupID: name, HOS: bool, BAW: bool) 
	{	
		switch( groupID )
		{
		//Main Quests
		case 'PotP_TrackingGroup_MainQuests_Prologue':
		case 'PotP_TrackingGroup_MainQuests_Vizima':
		case 'PotP_TrackingGroup_MainQuests_VelenAct1':
		case 'PotP_TrackingGroup_MainQuests_NovigradAct1':
		case 'PotP_TrackingGroup_MainQuests_SkelligeAct1':
		case 'PotP_TrackingGroup_MainQuests_Act2':
		case 'PotP_TrackingGroup_MainQuests_Act3':
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai1"), value, "icons/PotP/tracked_gold.png");
			break;				
		
		case 'PotP_TrackingGroup_MainQuests_HeartsOfStone':
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai2"), value, "icons/PotP/tracked_blue.png");
			break;		
			
		case 'PotP_TrackingGroup_MainQuests_BloodAndWine':
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Mai3"), value, "icons/PotP/tracked_red.png");
			break;		
		
		//Side Quests
		case 'PotP_TrackingGroup_SideQuests_WhiteOrchard':
		case 'PotP_TrackingGroup_SideQuests_Velen':
		case 'PotP_TrackingGroup_SideQuests_Skellige':
		case 'PotP_TrackingGroup_SideQuests_KaerMorhen':
		case 'PotP_TrackingGroup_SideQuests_Toussaint':
		case 'PotP_TrackingGroup_SideQuests_NonRegional':
		case 'PotP_TrackingGroup_SideQuests_Novigrad':
			if (HOS) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid2"), value, "icons/PotP/tracked_blue.png"); break; }
			if (BAW) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid3"), value, "icons/PotP/tracked_red.png"); break; }
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Sid1"), value, "icons/PotP/tracked_gold.png");
			break;	
		
		//Contract Quests
		case 'PotP_TrackingGroup_ContractQuests_WhiteOrchard':
		case 'PotP_TrackingGroup_ContractQuests_Velen':
		case 'PotP_TrackingGroup_ContractQuests_Novigrad':
		case 'PotP_TrackingGroup_ContractQuests_Skellige':
		case 'PotP_TrackingGroup_ContractQuests_Toussaint':
			if (HOS) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con2"), value, "icons/PotP/tracked_blue.png"); break; }
			if (BAW) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con3"), value, "icons/PotP/tracked_red.png"); break; }
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Con1"), value, "icons/PotP/tracked_gold.png");
			break;
			
		//Scavenger Hunt Quests
		case 'PotP_TrackingGroup_ScavengerHuntQuests_GriffinSet':
		case 'PotP_TrackingGroup_ScavengerHuntQuests_FelineSet':
		case 'PotP_TrackingGroup_ScavengerHuntQuests_UrsineSet':
		case 'PotP_TrackingGroup_ScavengerHuntQuests_WolvenSet':
		case 'PotP_TrackingGroup_ScavengerHuntQuests_OtherSets':	
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Scav"), value, "icons/PotP/tracked_gold.png");
			break;	

		//Treasure Hunt Quests
		case 'PotP_TrackingGroup_TreasureHuntQuests_WhiteOrchard':
		case 'PotP_TrackingGroup_TreasureHuntQuests_Velen':
		case 'PotP_TrackingGroup_TreasureHuntQuests_Skellige':
		case 'PotP_TrackingGroup_TreasureHuntQuests_Toussaint':
		case 'PotP_TrackingGroup_TreasureHuntQuests_Novigrad':
			if (HOS) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre2"), value, "icons/PotP/tracked_blue.png"); break; }
			if (BAW) { AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre3"), value, "icons/PotP/tracked_red.png"); break; }
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Quest_Tre1"), value, "icons/PotP/tracked_gold.png");
			break;							

		//Random Events
		case 'PotP_TrackingGroup_RandomEvents_Velen':
		case 'PotP_TrackingGroup_RandomEvents_Novigrad':
		case 'PotP_TrackingGroup_RandomEvents_Skellige':
		case 'PotP_TrackingGroup_RandomEvents_KaerMorhen':
			AddToQuestUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Event"), value, "icons/PotP/tracked_gold.png");
			break;				
		
		default:
			break;	
		}
	}
			
	//---------------------------------------------------
	
	public function UpdateMiscCounter(value: int, groupID: name)
	{
		switch( groupID )
		{
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint':
			AddToWorldMapUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Camps"), value, iconPath_Camps);
			break;
			
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Velen':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint':
			AddToWorldMapUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_MoDen"), value, iconPath_MoDen);
			break;	

		case 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint':
			AddToWorldMapUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_MoNes"), value, iconPath_MoNes);
			break;

		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint':
			AddToWorldMapUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Place"), value, iconPath_Place);
			break;

		case 'PotP_TrackingGroup_WorldMap_Signposts_Velen':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Skellige':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint':
			AddToWorldMapUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_SignP"), value, iconPath_RSign);
			break;

		default:
			break;
		}
	}

	//---------------------------------------------------
	
	public function UpdateItemCounter(value: int, groupID: name) 
	{
		switch( groupID ) 
		{
		case 'PotP_TrackingGroup_Trophies':
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Troph"), value, "icons/inventory/quests/trophy_gryphon_64x64.png");
			break;
			
		case 'PotP_TrackingGroup_Relics_Crossbows':
		case 'PotP_TrackingGroup_Relics_Crossbows_W3EE':				
		case 'PotP_TrackingGroup_Relics_SilverSwords':
		case 'PotP_TrackingGroup_Relics_SilverSwords_W3EE':
		case 'PotP_TrackingGroup_Relics_SteelSwords':
		case 'PotP_TrackingGroup_Relics_SteelSwords_W3EE':
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Relic"), value, "icons/inventory/weapons/silver_unique_aerondight_64x128.png");
			break;
			
		case 'PotP_TrackingGroup_GwentCards_Monsters':
		case 'PotP_TrackingGroup_GwentCards_Monsters_Redux':
		case 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire':
		case 'PotP_TrackingGroup_GwentCards_NilfgaardianEmpire_Redux':
		case 'PotP_TrackingGroup_GwentCards_NorthernRealms':
		case 'PotP_TrackingGroup_GwentCards_NorthernRealms_Redux':
		case 'PotP_TrackingGroup_GwentCards_Scoiatael':
		case 'PotP_TrackingGroup_GwentCards_Scoiatael_Redux':
		case 'PotP_TrackingGroup_GwentCards_Skellige':
		case 'PotP_TrackingGroup_GwentCards_Skellige_Redux':
		case 'PotP_TrackingGroup_GwentCards_NeutralCards':
		case 'PotP_TrackingGroup_GwentCards_NeutralCards_Redux':
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_Gwent"), value, "icons/inventory/gwint/ico_gwent_hero_neutral.png");
			break;
			
		default:
			UpdateDLCCounter(1, groupID);
		}
	}

	//---------------------------------------------------
	
	public function UpdateGearSetCounter(value: int, groupID: name) 
	{
		AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_GearSet"), value, "icons/inventory/armors/lynx_armor_3_64x128.png");
	}

	//---------------------------------------------------
	
	public function UpdateDLCCounter(value: int, groupID: name) 
	{
		var iconpath: string = "icons/inventory/armors/lynx_armor_3_64x128.png";
		
		if (StrContains(NameToString(groupID), "ShadesOfIron")) 
		{
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_ShadesOfIron"), value, iconpath);
			return;
		}

		if (StrContains(NameToString(groupID), "CosWiecej")) 
		{
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_CosWiecej"), value, iconpath);
			return;
		}

		if (StrContains(NameToString(groupID), "SezonBurz")) 
		{
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_SezonBurz"), value, iconpath);
			return;
		}

		if (StrContains(NameToString(groupID), "W3EE")) 
		{
			AddToItemUpdateArray(GetLocStringByKeyExt("PotP_NotificationLine_W3EE"), value, iconpath);
			return;
		}
	}
	
	//---------------------------------------------------

	public function UpdatePlayerFromPickUp(uniqueID : SItemUniqueId, localname: string) 
	{	
		this.AddToBackGroundArray_Item(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), uniqueID, localname);
	}
	
	//---------------------------------------------------
	
	public function UpdatePlayerFromQuest(QuestName: string, QuestStatus: int, HOS: bool, BAW: bool) 
	{	
		if (HOS) 
		{ 
			AddToBackGroundArray_Quest(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), QuestName, QuestStatus, "icons/PotP/tracked_blue.png"); 
			return; 
		}
		if (BAW) 
		{
			AddToBackGroundArray_Quest(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), QuestName, QuestStatus, "icons/PotP/tracked_red.png"); 
			return;
		}
		
		this.AddToBackGroundArray_Quest(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), QuestName, QuestStatus, "icons/PotP/tracked_gold.png");
	}

	//---------------------------------------------------
	
	public function UpdatePlayerFromWorldMap(groupID: name, PinName: string) 
	{	
		switch( groupID ) 
		{
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Velen':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Skellige':
		case 'PotP_TrackingGroup_WorldMap_BanditCamp_Toussaint':
			this.AddToBackGroundArray_WorldMap(GetLocStringByKeyExt("PotP_NotificationLine_BanditC"), PinName, iconPath_Camps);
			break;	
			
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Velen':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Skellige':
		case 'PotP_TrackingGroup_WorldMap_MonsterDens_Toussaint':
			this.AddToBackGroundArray_WorldMap(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), PinName, iconPath_MoDen);
			break;	

		case 'PotP_TrackingGroup_WorldMap_MonsterNests_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Velen':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Skellige':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_MonsterNests_Toussaint':
			this.AddToBackGroundArray_WorldMap(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), PinName, iconPath_MoNes);
			break;

		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Velen':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Skellige':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_KaerMorhen':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_Toussaint':
		case 'PotP_TrackingGroup_WorldMap_PlacesOfPower_TheSpiral':
			this.AddToBackGroundArray_WorldMap(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), PinName, iconPath_Place);
			break;

		case 'PotP_TrackingGroup_WorldMap_Signposts_Velen':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Novigrad':
		case 'PotP_TrackingGroup_WorldMap_Signposts_WhiteOrchard':
		case 'PotP_TrackingGroup_WorldMap_Signposts_KaerMorhen':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Skellige':
		case 'PotP_TrackingGroup_WorldMap_Signposts_Toussaint':
			this.AddToBackGroundArray_WorldMap(GetLocStringByKeyExt("PotP_NotificationLine_Updated"), PinName, iconPath_RSign);
			break;

		default:
			break;
		}
	}
	
	//---------------------------------------------------
	
	public function ResetTrackerUpdateArray() 
	{
		TrackerUpdateArray_Name.Clear();
		TrackerUpdateArray_Ints.Clear();
		TrackerUpdateArray_Icon.Clear();

		QuestUpdateArray_Name.Clear();
		QuestUpdateArray_Ints.Clear();
		QuestUpdateArray_Icon.Clear();

		ItemUpdateArray_Name.Clear();
		ItemUpdateArray_Ints.Clear();
		ItemUpdateArray_Icon.Clear();
		
		WorldMapUpdateArray_Name.Clear();
		WorldMapUpdateArray_Ints.Clear();
		WorldMapUpdateArray_Icon.Clear();
		
		TrackerUpdateArray_Count = 0;
	}

	//---------------------------------------------------
	
	public function ResetBackGroundProcessingArray()
	{
		BackGroundProcessingArray_Name.Clear();
		BackGroundProcessingArray_Icon.Clear();
		BackGroundProcessingArray_Count = 0;

		BackGroundQuestArray_Name.Clear();
		BackGroundQuestArray_Icon.Clear();
		BackGroundQuestArray_Count = 0;
		
		BackGroundItemArray_Name.Clear();
		BackGroundItemArray_Icon.Clear();
		BackGroundItemArray_Count = 0;
		
		BackGroundWorldMapArray_Name.Clear();
		BackGroundWorldMapArray_Icon.Clear();
		BackGroundWorldMapArray_Count = 0;
	}
	
	//---------------------------------------------------

	private function GetNotificationFontSize() : int 
	{
		return FactsQuerySum("ProgressOnThePath_Notification_Size");
	}

	//---------------------------------------------------

	private function SetNotificationFontSize() 
	{
		theGame.GetInGameConfigWrapper().SetVarValue('ProgressOnThePath_NotificationSettings', 'ProgressOnThePath_NotificationSize', fontsize);
		FactsSet("ProgressOnThePath_Notification_Size", fontsize);
	}

	//---------------------------------------------------
	
	private function GetNotificationTime() : float
	{
		return (float) PotP_GetGeneralValue('ProgressOnThePath_Notification_Time') * 1000.0;
	}
	
	//---------------------------------------------------

	private function GetNotificationColour() : string
	{
		switch ( (int) PotP_GetGeneralValue('ProgressOnThePath_Notification_Font') ) {
		
			case 1:
				return "<font color='#233067'>";
			
			case 2:
				return "<font color='#630F0F'>";

			case 3:
				return "<font color='#084A23'>";

			case 4:
				return "<font color='#431C53'>";
				
			default:
				return "<font color='#000000'>";
		}
	}
	
	//---------------------------------------------------
	
	private function GetNotificationHeader() : string 
	{
		return GetNotificationColour() + GetLocStringByKeyExt("PotP_NotificationHeader") + " " + GetTotalPercentage() + "<br/>" + "</font>";
	}	

	//---------------------------------------------------
	
	private function GetTotalPercentage() : string 
	{
		var cur: float = this.GetCurrentCount();
		var tot: float = this.GetTotalCount();
		
		return GetNotificationColour() + GetLocStringByKeyExt("PotP_Completed") + " (" +(int) cur + " / " + (int) tot + ") - " + " " + FloatToStringPrec(((cur / tot) * 100), 2) + "%" + "</font>";
	}

	//---------------------------------------------------

	private function GetCurrentCount() : float 
	{
		return (this.master.PotP_PersistentStorage.MasterList_Completed_V.Size() + this.master.PotP_PersistentStorage.MasterList_IsIgnored_V.Size());
	}

	//---------------------------------------------------

	private function GetTotalCount() : float 
	{
		var GwentManager: CR4GwintManager = theGame.GetGwintManager();
		var i, CardsFound: int;

		if (GwentManager.HasLootedCard())
		{
			if (GwentManager.IsDeckUnlocked(GwintFaction_Skellige))
			{
				return this.master.PotP_ArrayManager.TotalEntList.Size();
			}
			else
			{
				for (i = 0; i < this.master.PotP_ArrayManager.TotalEntList.Size(); i += 1)
				{
					if (StrContains(NameToString(this.master.PotP_ArrayManager.TotalVarList[i]), "PotP_TrackingGroup_GwentCards_Skellige")) 
					{
						CardsFound += 1;
					}
				}
				return (this.master.PotP_ArrayManager.TotalEntList.Size() - CardsFound);			
			}
		}
		else
		{
			for (i = 0; i < this.master.PotP_ArrayManager.TotalEntList.Size(); i += 1)
			{
				if (this.master.PotP_ArrayManager.TotalEntList[i].arrayType == PotP_A_Gwent)
				{
					CardsFound += 1;
				}
			}
			return (this.master.PotP_ArrayManager.TotalEntList.Size() - CardsFound);	
		}
	}
	
	//---------------------------------------------------
	
	public function _ShowListSizes() 
	{
		var Notification : string = "";
		
		if ( GetNotificationFontSize() < 14 ) 
		{
			SetNotificationFontSize();
		}
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Completed List - " + this.master.PotP_PersistentStorage.MasterList_Completed_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "InProgres List - " + this.master.PotP_PersistentStorage.MasterList_InProgres_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "IsIgnored List - " + this.master.PotP_PersistentStorage.MasterList_IsIgnored_V.Size() + "</font>" + "<br/>";
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + "Collected List - " + this.master.PotP_PersistentStorage.MasterList_Collected_V.Size() + "</font>" + "<br/>";
		
		theGame.GetGuiManager().ShowNotification(Notification, GetNotificationTime(), true);
	}
	
	//---------------------------------------------------

	private function FormatItemIcon(s: string) : string 
	{
		return "<img src='img://" + s + "' height='" + GetNotificationFontSize() + "' width='" + GetNotificationFontSize() + "' vspace='-5' />&nbsp;";
	}

	//---------------------------------------------------
	
	private function AddToQuestUpdateArray(loc: string, value: int, iconPath: string)
	{
		var InsertedString: string = loc;
		var InsertedIndexP: int = QuestUpdateArray_Name.FindFirst(InsertedString);
		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Qust') ) 
		{
			if (InsertedIndexP == -1)
			{
				QuestUpdateArray_Name.PushBack(InsertedString);
				QuestUpdateArray_Ints.PushBack(value);
				QuestUpdateArray_Icon.PushBack(iconPath);
				TrackerUpdateArray_Count += 1;
				LogChannel('PotP Notification Script', "Inserted - " + InsertedString + " Into the quest array");
			}
			else 
			{
				QuestUpdateArray_Ints[InsertedIndexP] += value;
				LogChannel('PotP Notification Script', "Increased Count for - " + InsertedString + " to " + QuestUpdateArray_Ints[InsertedIndexP]);
			}
		}
	}

	//---------------------------------------------------
	
	private function AddToWorldMapUpdateArray(loc: string, value: int, iconPath: string) 
	{		
		var InsertedString: string = loc;
		var InsertedIndexP: int = WorldMapUpdateArray_Name.FindFirst(InsertedString);
		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_WMap') ) 
		{
			if (InsertedIndexP == -1) 
			{
				WorldMapUpdateArray_Name.PushBack(InsertedString);
				WorldMapUpdateArray_Ints.PushBack(value);
				WorldMapUpdateArray_Icon.PushBack(iconPath);
				TrackerUpdateArray_Count += 1;
				LogChannel('PotP Notification Script', "Inserted - " + InsertedString + " Into the world map array");
			}
			else 
			{
				WorldMapUpdateArray_Ints[InsertedIndexP] += value;
				LogChannel('PotP Notification Script', "Increased Count for - " + InsertedString + " to " + WorldMapUpdateArray_Ints[InsertedIndexP]);
			}
		}
	}

	//---------------------------------------------------
	
	private function AddToItemUpdateArray(loc: string, value: int, iconPath: string) 
	{
		var InsertedString: string = loc;
		var InsertedIndexP: int = ItemUpdateArray_Name.FindFirst(InsertedString);
		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Item') ) 
		{
			if (InsertedIndexP == -1) 
			{
				ItemUpdateArray_Name.PushBack(InsertedString);
				ItemUpdateArray_Ints.PushBack(value);
				ItemUpdateArray_Icon.PushBack(iconPath);
				TrackerUpdateArray_Count += 1;
			}
			else 
			{
				ItemUpdateArray_Ints[InsertedIndexP] += value;
			}
		}
	}

	//---------------------------------------------------
	
	private function AddToBackGroundArray_Item(loc: string, uuid: SItemUniqueId, localname: string)
	{
		var InsertedString: string = loc + localname;
		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Item') ) 
		{
			if (BackGroundItemArray_Name.FindFirst(InsertedString) == -1 ) 
			{
				BackGroundProcessingArray_Count += 1;
				
				if (BackGroundProcessingArray_Count > 20) 
				{
					return;
				}
				
				BackGroundItemArray_Name.PushBack(InsertedString);
				BackGroundItemArray_Icon.PushBack(thePlayer.GetInventory().GetItemIconPathByUniqueID(uuid));
			}
		}
	}

	//---------------------------------------------------
	
	private function AddToBackGroundArray_WorldMap(loc: string, PinName: string, iconPath: string) 
	{
		var InsertedString: string = StrReplace(loc + PinName, "(*)", "");

		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_WMap') ) 
		{
			if (BackGroundWorldMapArray_Name.FindFirst(InsertedString) == -1 ) 
			{
				BackGroundProcessingArray_Count += 1;
				
				if (BackGroundProcessingArray_Count > 20) 
				{
					return;
				}
				
				BackGroundWorldMapArray_Name.PushBack(InsertedString);
				BackGroundWorldMapArray_Icon.PushBack(iconPath);
			}
		}
	}
	
	//---------------------------------------------------
	
	private function AddToBackGroundArray_Quest(loc: string, QuestName: string, QuestStatus: int, iconPath: string) 
	{
		var InsertedString: string = loc;
		
		if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Qust') ) 
		{
			switch (QuestStatus)
			{
			case JS_Success:
			case JS_Failed:
				InsertedString += StrReplace(GetLocStringByKeyExt("PotP_NotificationLine_QuestUpdated"), "(QUESTNAME)", QuestName + GetLocStringByKeyExt("PotP_QUESTCOMPLETE"));
				break;
				
			case JS_Active:
				InsertedString += StrReplace(GetLocStringByKeyExt("PotP_NotificationLine_QuestUpdated"), "(QUESTNAME)", QuestName + GetLocStringByKeyExt("PotP_QUESTINPROGRESS"));
				break;

			default:
				return;
			}
				
			if (BackGroundQuestArray_Name.FindFirst(InsertedString) == -1 ) 
			{
				BackGroundProcessingArray_Count += 1;
				
				if (BackGroundProcessingArray_Count > 20) 
				{
					return;
				}
				
				BackGroundQuestArray_Name.PushBack(InsertedString);
				BackGroundQuestArray_Icon.PushBack(iconPath);
				LogChannel('PotP Notification Script', "Inserted - " + InsertedString + " into the background quest array");
			}
		}
	}
	
	//---------------------------------------------------
	
	private function SortArrays(N: array<string>, I: array<string>, X: array<int>) 
	{
		var tmpN: array <string> = N;
		var tmpI: array <string> = I;
		var tmpX: array <int> = X;
		var i, f: int;
		
		if (tmpN.Size() == -1) 
		{ 
			return; 
		}
		
		ArraySortStrings(N);
		
		for (i = 0; i < N.Size(); i += 1)
		{ 
			f = tmpN.FindFirst(N[i]); 
			I[i] = tmpI[f]; 
			X[i] = tmpX[f]; 
		}
		
		for (i = 0; i < N.Size(); i += 1) 
		{
			TrackerUpdateArray_Name.PushBack(N[i]);
			TrackerUpdateArray_Icon.PushBack(I[i]);
			TrackerUpdateArray_Ints.PushBack(X[i]);
		}
	}

	//---------------------------------------------------
	
	private function SortBackgroundArrays() 
	{
		var temp_QuestNameArray, temp_ItemsNameArray, temp_WorldMapNameArray: array <string>;
		var temp_QuestIconArray, temp_ItemsIconArray, temp_WorldMapIconArray: array <string>;
		var i, f: int;
		
		temp_QuestNameArray = BackGroundQuestArray_Name;
		temp_QuestIconArray = BackGroundQuestArray_Icon;

		temp_ItemsNameArray = BackGroundItemArray_Name;
		temp_ItemsIconArray = BackGroundItemArray_Icon;

		temp_WorldMapNameArray = BackGroundWorldMapArray_Name;
		temp_WorldMapIconArray = BackGroundWorldMapArray_Icon;
		
		if (temp_QuestNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundQuestArray_Name);
			
			for (i = 0; i < BackGroundQuestArray_Name.Size(); i += 1) 
			{ 
				f = temp_QuestNameArray.FindFirst(BackGroundQuestArray_Name[i]); 
				BackGroundQuestArray_Icon[i] = temp_QuestIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundQuestArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundQuestArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundQuestArray_Icon[i]);
			}
		}

		if (temp_ItemsNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundItemArray_Name);
			
			for (i = 0; i < BackGroundItemArray_Name.Size(); i += 1) 
			{ 
				f = temp_ItemsNameArray.FindFirst(BackGroundItemArray_Name[i]); 
				BackGroundItemArray_Icon[i] = temp_ItemsIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundItemArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundItemArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundItemArray_Icon[i]);
			}
		}

		if (temp_WorldMapNameArray.Size() > 0) 
		{ 
			ArraySortStrings(BackGroundWorldMapArray_Name);
			
			for (i = 0; i < BackGroundWorldMapArray_Name.Size(); i += 1) 
			{ 
				f = temp_WorldMapNameArray.FindFirst(BackGroundWorldMapArray_Name[i]); 
				BackGroundWorldMapArray_Icon[i] = temp_WorldMapIconArray[f]; 
			}
			
			for (i = 0; i < BackGroundWorldMapArray_Name.Size(); i += 1) 
			{
				BackGroundProcessingArray_Name.PushBack(BackGroundWorldMapArray_Name[i]);
				BackGroundProcessingArray_Icon.PushBack(BackGroundWorldMapArray_Icon[i]);
			}
		}
	}
	
	//---------------------------------------------------
	
	private function FormatNotification() : string 
	{
		var Notification : string = "";
		var i: int = 0;

		SortArrays(QuestUpdateArray_Name, QuestUpdateArray_Icon, QuestUpdateArray_Ints);
		SortArrays(WorldMapUpdateArray_Name, WorldMapUpdateArray_Icon, WorldMapUpdateArray_Ints);
		SortArrays(ItemUpdateArray_Name, ItemUpdateArray_Icon, ItemUpdateArray_Ints);
		
		if ( GetNotificationFontSize() < 14 ) 
		{
			SetNotificationFontSize();
		}
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
		
		if (this.TrackerUpdateArray_Count == 0) 
		{
			if ( (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Null') ) 
			{
				Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + GetLocStringByKeyExt("PotP_NullMessage") + "<br/>" + "</font>"; 
				return Notification;
			}
			return "";
		}
		
		for (i = 0; i < TrackerUpdateArray_Name.Size(); i += 1) 
		{
			if (TrackerUpdateArray_Ints[i] > 0) 
			{
				Notification += FormatItemIcon(TrackerUpdateArray_Icon[i]) + FormatLine(TrackerUpdateArray_Ints[i], TrackerUpdateArray_Name[i]);
			}
		}		
		return Notification;
	}
		
	//---------------------------------------------------
	
	private function FormatMessage_BackGroundProcessingArray() : string 
	{
		var over_limit		: string = StrReplace(GetLocStringByKeyExt("ProgressOnThePath_MoreEntries"), "[COUNTS]", (BackGroundProcessingArray_Count - BackGroundProcessingArray_Name.Size()));
		var Notification 	: string = "";
		var i, f			: int = 0;

		SortBackgroundArrays();

		if (GetNotificationFontSize() < 14 ) 
		{
			SetNotificationFontSize();
		}
		
		Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationHeader() + "</font>";
			
		for (i = 0; i < BackGroundProcessingArray_Name.Size(); i += 1) 
		{
			Notification += FormatItemIcon(BackGroundProcessingArray_Icon[i]) + FormatLine_BackGroundProcessingArray(BackGroundProcessingArray_Name[i]);
		}
		
		if (BackGroundProcessingArray_Count > BackGroundProcessingArray_Name.Size()) 
		{
			Notification += "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + over_limit + "</font>";
		}
		
		return Notification;
	}

	//---------------------------------------------------
	
	private function FormatLine_BackGroundProcessingArray(str: string) : string 
	{
		return "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + str + "<br/>" + "</font>";
	}
	
	//---------------------------------------------------
	
	private function FormatLine(counter: int, str: string) : string 
	{
		var returnStr: string = "<font size='" + GetNotificationFontSize() + "'>" + GetNotificationColour() + GetLocStringByKeyExt("PotP_NotificationLine_Updated") + (string) counter + str + "<br/>" + "</font>";
		
		if (StrContains(returnStr, "(DYNAMC_REPLACE_TROPHY)")) 
		{
			if (counter == 1) 
			{
				return StrReplace(returnStr, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER2"));
			}
			else
			{
				return StrReplace(returnStr, "(DYNAMC_REPLACE_TROPHY)", GetLocStringByKeyExt("PotP_TROPHY_REPLACER1"));
			}
		}
	
		if (counter == 1)
		{
			return StrReplace(returnStr, "(DYNAMC_REPLACE)", "");
		}
		
		return StrReplace(returnStr, "(DYNAMC_REPLACE)", GetLocStringByKeyExt("PotP_PLURAL_REPLACER"));
	}
	
	//---------------------------------------------------	

	public function DisplayNotification() 
	{
		if (this.NotificationsEnabled()) 
		{
			theGame.GetGuiManager().ShowNotification(FormatNotification(), GetNotificationTime(), true);
		}
		this.ResetTrackerUpdateArray();
	}

	//---------------------------------------------------	

	public function NotifyPlayerFromBackgroundProcess() 
	{
		if (this.NotificationsEnabled() && this.BackGroundProcessingArray_Count > 0) 
		{
			theGame.GetGuiManager().ShowNotification(FormatMessage_BackGroundProcessingArray(), GetNotificationTime(), true);
		}
		this.ResetBackGroundProcessingArray();
	}	

	//---------------------------------------------------	

	private function NotificationsEnabled() : bool 
	{
		return (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Qust') 
			|| (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_Item') 
			|| (bool) PotP_GetGeneralValue('ProgressOnThePath_Notification_WMap');
	}	
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------