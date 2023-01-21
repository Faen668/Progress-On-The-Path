
class SU_MapPin {
  /**
   * This isn't used by the code but only for you to easily identify your pins.
   */
   var tag: String;

  /**
   * when set to true the map pin will appear under the 'Quests' label
   * on the world map filter pane.
   */
   var is_quest: bool;
   default is_quest = false;
   
  /**
   * represents the position of the pin, only X and Y values matter as the map
   * is in 2D.
   */
  var position: Vector;

  /**
   * the description that is displayed when the player hovers the cursor over 
   * the pin on the map.
   */
  var description: String;

  /**
   * the name of the pin that is displayed when the player hovers the cursor
   * over the pin on the map.
   */
  var label: String;

  /**
   * The type of the pin, it changes the icon of the pin.
   * A full list of available pins can be found at the bottom of this script.
   */
  var type: String;
  default type = "MonsterQuest";

  /**
   * The filtered type of the pin, this is the filter that the map pin will 
   * fall under, it is best to try use something nothing else is like "QuestReturn".
   * Using a common type will group your pins together with them.
   */
  var filtered_type: String;
  default filtered_type = "QuestReturn";
  
  /**
   * The radius of the quest on the map, it controls the radius of the yellow,
   * low opacity circle around the marker.
   */
  var radius: float;

  /**
   * Controls in which region it will display the pin, the player has to be in
   * the region for the marker to appear.
   * - prolog_village || prolog_village_winter
   * - no_mans_land || novigrad
   * - skellige
   * - kaer_morhen
   * - bob
   */
  var region: String;

////////////////////////////////////////////////////////////////////////////////
//                               Mini Map Options                             //
////////////////////////////////////////////////////////////////////////////////
  
  /**
   * Controls whether or not this mappin should appear on the player's minimap.
   */
  var appears_on_minimap: bool;
  default appears_on_minimap = false;

  /**
   * Controls whether or not this mappin should have arrow pointers
   * on the mini map border.
   */  
  var pointed_by_arrow: bool;
  default pointed_by_arrow = true;

  /**
   * Controls whether or not this mappin's pointers should be highlighted
   * on the mini map border.
   */   
  var highlighted: bool;
  default highlighted = true;

  function init(
    _tag: String,
    _position: Vector,
    _description: String,
    _label: String,
    _type: String,
    _filtered_type: string,
    _radius: float,
    _region: String,
    _appears_on_minimap: bool,
	_pointed_by_arrow: bool,
	_highlighted: bool,
    _is_quest: bool
  ): SU_MapPin {
    this.tag = _tag;
    this.position = _position;
    this.description = _description;
    this.label = _label;
    this.type = _type;
    this.filtered_type = _filtered_type;
    this.radius = _radius;
    this.region = _region;
    this.appears_on_minimap = _appears_on_minimap;
	this.pointed_by_arrow = _pointed_by_arrow;
	this.highlighted = _highlighted;
    this.is_quest = _is_quest;

    return this;
  }
}


/*
"RoadSign"
"Harbor"
"NoticeBoardFull"
"NoticeBoard"
"PlayerStash"
"PlayerStashDiscoverable"
"Horse"
"StoryQuest"
"ChapterQuest"
"SideQuest"
"MonsterQuest"
"TreasureQuest"
"QuestReturn"
"HorseRace"
"NonQuestHorseRace"
"BoatRace"
"QuestBelgard"
"QuestCoronata"
"QuestVermentino"
"QuestAvailable"
"QuestAvailableHoS"
"QuestAvailableBaW"
"Entrance"
"NotDiscoveredPOI"
"NotDiscoveredPOI_1"
"NotDiscoveredPOI_2"
"NotDiscoveredPOI_3"
"MonsterNest"
"MonsterNest_1"
"MonsterNest_2"
"MonsterNest_3"
"MonsterNestDisabled"
"TreasureHuntMappin"
"TreasureHuntMappin_1"
"TreasureHuntMappin_2"
"TreasureHuntMappin_3"
"TreasureHuntMappinDisabled"
"SpoilsOfWar"
"SpoilsOfWar_1"
"SpoilsOfWar_2"
"SpoilsOfWar_3"
"SpoilsOfWarDisabled"
"BanditCamp"
"BanditCamp_1"
"BanditCamp_2"
"BanditCamp_3"
"BanditCampDisabled"
"BanditCampfire"
"BanditCampfire_1"
"BanditCampfire_2"
"BanditCampfire_3"
"BanditCampfireDisabled"
"BossAndTreasure"
"BossAndTreasure_1"
"BossAndTreasure_2"
"BossAndTreasure_3"
"BossAndTreasureDisabled"
"Contraband"
"Contraband_1"
"Contraband_2"
"Contraband_3"
"ContrabandDisabled"
"ContrabandShip"
"ContrabandShip_1"
"ContrabandShip_2"
"ContrabandShip_3"
"ContrabandShipDisabled"
"RescuingTown"
"RescuingTown_1"
"RescuingTown_2"
"RescuingTown_3"
"RescuingTownDisabled"
"DungeonCrawl"
"DungeonCrawl_1"
"DungeonCrawl_2"
"DungeonCrawl_3"
"DungeonCrawlDisabled"
"Hideout"
"HideoutDisabled"
"InfestedVineyard"
"InfestedVineyard_1"
"InfestedVineyard_2"
"InfestedVineyard_3"
"InfestedVineyardDisabled"
"Plegmund"
"WineContract"
"KnightErrant"
"SignalingStake"
"Boat"
"Shopkeeper"
"Archmaster"
"Blacksmith"
"Armorer"
"Hairdresser"
"Alchemic"
"Herbalist"
"Innkeeper"
"Enchanter"
"Prostitute"
"Hairdresser"
"Torch"
"WineMerchant"
"DyeMerchant"
"Cammerlengo"
"PlaceOfPower"
"PlaceOfPower_1"
"PlaceOfPower_2"
"PlaceOfPower_3"
"PlaceOfPowerDisabled"
"Whetstone"
"GrindStone"
"ArmorRepairTable"
"AlchemyTable"
"MutagenDismantle"
"Bookshelf"
*/