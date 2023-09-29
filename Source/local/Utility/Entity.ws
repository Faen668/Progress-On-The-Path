//---------------------------------------------------
//-- Preview Entry  ---------------------------------
//---------------------------------------------------

enum PotP_Preview_CardOrigin
{
	PotP_G_NoIdea = 0, //Unknown
	PotP_G_Bought = 1, //Bought
	PotP_G_Looted = 2, //looted
	PotP_G_Reward = 3, //Quest Reward
	PotP_G_Dualed = 4, //Unique Dual
}

enum PotP_Preview_CardType
{
	PotP_G_None = 0, //Undefined
	PotP_G_Lead = 1, //Leader
	PotP_G_Hero = 2, //Hero
	PotP_G_Unit = 3, //Unit
}

enum PotP_Preview_Region 
{
	PotP_R_NA = 0, //All
	PotP_R_WO = 1, //White Orchard
	PotP_R_VE = 2, //Velen
	PotP_R_NO = 3, //Novigrad
	PotP_R_SK = 4, //Skellige
	PotP_R_TO = 5, //Toussaint
	PotP_R_KM = 6, //Kaer Morhen
	PotP_R_VI = 7, //Vizima
	PotP_R_TS = 8  //The Spiral
}

enum PotP_Preview_Array_Type 
{
	PotP_A_Quest = 0, // Quest
	PotP_A_World = 1, // World
	PotP_A_Items = 2, // Items
	PotP_A_Event = 3, // Event
	PotP_A_Gwent = 4  // Gwent
}

enum PotP_Preview_Entry_Type 
{
	PotP_E_Primary  	 = 0, // Normal Entry
	PotP_E_Primary_DLC1  = 1, // Normal Entry (HOS)
	PotP_E_Primary_DLC2  = 2, // Normal Entry (BAW)
	
	PotP_E_Missable 	 = 3, // Missable Entry
	PotP_E_Missable_DLC1 = 4, // Missable Entry (HOS)
	PotP_E_Missable_DLC2 = 5, // Missable Entry (BAW)
	
	PotP_E_ModAdded		 = 6, // Mod Added Entry
	PotP_E_ModAdded_DLC1 = 7, // Mod Added Entry (HOS)
	PotP_E_ModAdded_DLC2 = 8  // Mod Added Entry (BAW)
}

enum PotP_Preview_Items_Filter
{
	PotP_I_Relic  	 = 1,
	PotP_I_Gears  	 = 2,
	PotP_I_Troph  	 = 3,
	PotP_I_Gwent     = 4,
	PotP_I_Sezon	 = 5,
	PotP_I_Shade	 = 6,
	PotP_I_W3eer	 = 7,
	PotP_I_Wiecej	 = 8,
};

enum PotP_Preview_Items_Underlying_Filter
{
	PotP_U_Armor  	 = 1,
	PotP_U_Boots  	 = 2,
	PotP_U_Pants  	 = 3,
	PotP_U_Glove  	 = 4,
	PotP_U_Head  	 = 5,
	PotP_U_Steel  	 = 6,
	PotP_U_Silve  	 = 7,
	PotP_U_Cross	 = 8,
	PotP_U_Troph	 = 9,
}

enum PotP_Preview_World_Filter
{
	PotP_I_Camps	 = 1,
	PotP_I_MDens	 = 2,
	PotP_I_Nests	 = 3,
	PotP_I_Place	 = 4,
	PotP_I_Signs	 = 5,
	PotP_I_Sites	 = 6,
	PotP_I_Guard	 = 7,
	PotP_I_Distr	 = 8,
	PotP_I_Knigh	 = 9,
	PotP_I_Infes	 = 10,
	PotP_I_Hanse	 = 11,
}

enum PotP_Preview_Quest_Filter
{
	PotP_I_Event	 = 1,
	PotP_I_Mains	 = 2,
	PotP_I_Sides	 = 3,
	PotP_I_Conts	 = 4,
	PotP_I_Scavs	 = 5,
	PotP_I_Hunts	 = 6,
}

enum PotP_Preview_Gwent_Underlying_Filter
{
	PotP_I_Monst	 = 1,
	PotP_I_Nilfg	 = 2,
	PotP_I_North	 = 3,
	PotP_I_Conts	 = 4,
	PotP_I_Scoia	 = 5,
	PotP_I_Skell	 = 6,
	PotP_I_Neutr	 = 7,
}
	
class PotP_PreviewEntry
{
	//Items Only Variables
	var item_name		: name;
	var variations		: array<name>;
	
	//Gwent Only Variables
	var card_type		: PotP_Preview_CardType;
	var card_origin		: PotP_Preview_CardOrigin;

	//World Only Variables
	var pin_name		: name;
	
	//Event Only Variables
	var region_string	: string;
	var position		: Vector;
	
	//Quest Only Variables
	var is_dlc1 		: bool;
	var is_dlc2 		: bool;
	
	// Global Variables
	var fileName		: name;
	var type			: PotP_Preview_Entry_Type;
	var arrayType		: PotP_Preview_Array_Type;
	var filter			: int;
	var sub_filter		: int;
	var entryname		: string;
	var localname		: string;
	var uuid			: string;
	var identifier		: string;
	var region			: PotP_Preview_Region;
	var is_missable		: bool;
	var is_modadded		: bool;
	
	default fileName = 'PotP Entity';
	
	// init function called when creating the instance of this quest.
	function initQuest(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, entryname: string): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.entryname 		= entryname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);

		return this;
	}
	
	// init function called when creating the instance of this Random Event.
	function initEvent(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, initially_unlocked: bool, pin_region: string, factname: string, pin_position: Vector): PotP_PreviewEntry 
	{	
		this.type			= type;
		this.entryname 		= factname;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);
		
		this.region_string 	= pin_region;
		this.position 		= pin_position;
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (initially_unlocked) { entity_helper.UnlockEvent(this); }
		
		return this;
	}

	// init function called when creating the instance of this World Map pin.
	function initWorld(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, region: PotP_Preview_Region, filter: PotP_Preview_World_Filter, type: PotP_Preview_Entry_Type, pin: name): PotP_PreviewEntry 
	{	
		this.type 			= type;
		this.pin_name 		= pin;
		this.uuid 			= uuid;
		this.region 		= region;
		this.filter	    	= filter;
		entity_helper.SetType(this);	
			
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		return this;
	}

	// init function called when creating the instance of this Item.
	function initItems(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, sub_filter: PotP_Preview_Items_Underlying_Filter, item_name: name): PotP_PreviewEntry 
	{
		this.type 			= type;
		this.item_name 	 	= item_name;
		this.uuid 			= uuid;
		this.filter	    	= filter;
		this.sub_filter    	= sub_filter;
		entity_helper.SetType(this);

		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		if (entity_helper.IsItemCollected(this))
		{
			entity_helper.SetCompleted(this);
		}

		return this;
	}

	// init function called when creating the instance of this Gwent Card.
	function initGwent(entity_helper: CProgressOnThePath_PreviewEntryHelper, uuid: string, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, sub_filter: PotP_Preview_Gwent_Underlying_Filter, item_name: name, optional card_type: PotP_Preview_CardType): PotP_PreviewEntry 
	{	
		this.type 		 	= type;
		this.item_name 	 	= item_name;
		this.uuid 		 	= uuid;
		this.filter	     	= filter;
		this.sub_filter    	= sub_filter;
		entity_helper.SetType(this);
		
		entity_helper.SetCardOrigin(this);
		entity_helper.SetCardType(this, card_type);
		
		this.localname 		= GetLocStringByKeyExt("option_" + uuid);
		
		//PotP_Logger(localname + " is a " + this.card_type + " card that can be " + this.card_origin, , 'PotP Preview Entry');
		return this;
	}
	
	//---------------------------------------------------
	
	function compilevariations(optional var1: name, optional var2: name, optional var3: name, optional var4: name) : PotP_PreviewEntry
	{
		this.variations.Clear();
		this.variations.PushBack(this.item_name);
		
		if (var1 != '') { this.addvariation(var1); }
		if (var2 != '') { this.addvariation(var2); }
		if (var3 != '') { this.addvariation(var3); }
		if (var4 != '') { this.addvariation(var4); }
		
		return this;
	}
	
	//---------------------------------------------------
	
	function addvariation(variation_name: name) : void
	{
		this.variations.PushBack(variation_name);
		//PotP_Logger("Variation [" + variation_name + "] Assigned to Base Item " + this.item_name,, this.fileName);
	}
}

//---------------------------------------------------
//-- Console Functions For Quest Update -------------
//---------------------------------------------------

enum pStatus
{
	completed = 2,
	ignored = 1,
}

exec function ptc(identifier: string, optional value: pStatus) 
{
	PotP_ChangeQuestStatus( identifier, value );
}

exec function pt_changestatus(identifier: string, optional value: pStatus) 
{
	PotP_ChangeQuestStatus( identifier, value );
}

