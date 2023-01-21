//
// Progress on the Path - TW3 Progress Tracker
//
//---------------------------------------------------
//-- Preview Entry  ---------------------------------
//---------------------------------------------------

struct PotP_Preview_Gwent_Details {
	
	var location: PotP_Preview_Region;
	var requires: PotP_Preview_CardInfo;
}

enum PotP_Preview_CardInfo {
	
	PotP_G_NoIdea = 0, //Unknown
	PotP_G_Bought = 1, //Bought
	PotP_G_Looted = 2, //looted
	PotP_G_Reward = 3, //Quest Reward
	PotP_G_Dualed = 4, //Unique Dual
}

enum PotP_Preview_Region {
	
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

enum PotP_Preview_Array_Type {
	
	PotP_A_Quest = 0, // Quest
	PotP_A_World = 1, // World
	PotP_A_Items = 2, // Items
	PotP_A_Event = 3, // Event
	PotP_A_Gwent = 4  // Gwent
}

enum PotP_Preview_Entry_Type {
	
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

enum PotP_Preview_Items_Filter {
	
	PotP_I_Armor  	 = 1,
	PotP_I_Boots  	 = 2,
	PotP_I_Pants  	 = 3,
	PotP_I_Glove  	 = 4,
	PotP_I_Head  	 = 5,
	PotP_I_Steel  	 = 6,
	PotP_I_Silve  	 = 7,
	PotP_I_Cross	 = 8,
	PotP_I_Troph	 = 9,
}

enum PotP_Preview_World_Filter {

	PotP_I_Camps	 = 1,
	PotP_I_MDens	 = 2,
	PotP_I_Nests	 = 3,
	PotP_I_Place	 = 4,
	PotP_I_Signs	 = 5,
}

enum PotP_Preview_Quest_Filter {

	PotP_I_Event	 = 1,
	PotP_I_Mains	 = 2,
	PotP_I_Sides	 = 3,
	PotP_I_Conts	 = 4,
	PotP_I_Scavs	 = 5,
	PotP_I_Hunts	 = 6,
}

enum PotP_Preview_Gwent_Filter {

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
	
	//Gwent Only Variables
	var card_details	:PotP_Preview_Gwent_Details;
	var is_loot			:bool;
	var is_reward		:bool;
	var is_dual			:bool;
	var is_bought		:bool;

	//World Only Variables
	var pin_name		:name;
	
	//Event Only Variables
	var region_string	: string;
	var position		: Vector;
	var description		: string;
	
	//Quest Only Variables
	var is_dlc1 		:bool;
	var is_dlc2 		:bool;
	
	// Global Variables
	var type			:PotP_Preview_Entry_Type;
	var arrayType		:PotP_Preview_Array_Type;
	var filter			:int;
	var entryname		:string;
	var localname		:string;
	var group			:name;
	var uuid			:name;
	var identifier		:string;
	var region			:PotP_Preview_Region;
	var is_missable		:bool;
	var is_modadded		:bool;
	
	//Preview Tags
	var T_InProgress 	:string;
	var T_Completed		:string;
	var T_Ignored		:string;
	var T_ModAdded		:string;
	
	var T_Bought		:string;
	var T_Looted		:string;
	var T_Reward		:String;
	var T_Dualed		:String;
		
	default T_InProgress = "<font size='17' color='#C8566B'> (In Progress)</font>";
	default T_Completed  = "<font size='17' color='#2ba84a'> (Completed)</font>";
	default T_Ignored 	 = "<font size='17' color='#ff686b'> (Ignored)</font>";
	default T_ModAdded 	 = "<font size='17' color='#26CAD6'> (Mod Added)</font>";

	default T_Bought = "<font size='17' color='#C8566B'> (Bought From Vendor)</font>";
	default T_Looted = "<font size='17' color='#2ba84a'> (Lootable)</font>";
	default T_Reward = "<font size='17' color='#ff686b'> (Quest Reward)</font>";
	default T_Dualed = "<font size='17' color='#26CAD6'> (Won in dual)</font>";
	
	// init function called when creating the instance of this quest.
	function initQuest(group: name, uuid: name, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, entryname: string): PotP_PreviewEntry 
	{
		this.type 		= type;
		this.entryname 	= entryname;
		this.group 		= group;
		this.uuid 		= uuid;
		this.region 	= region;
		this.filter	    = filter;
		
		this.localname = GetLocStringByKeyExt("option_" + NameToString(uuid));
		this.SetType();

		return this;
	}
	
	// init function called when creating the instance of this Random Event.
	function initEvent(group: name, uuid: name, type: PotP_Preview_Entry_Type, region: PotP_Preview_Region, filter: PotP_Preview_Quest_Filter, pin_region: string, factname: string, pin_position: Vector): PotP_PreviewEntry 
	{
		this.type		= type;
		this.entryname 	= factname;
		this.group 		= group;
		this.uuid 		= uuid;
		this.region 	= region;
		this.filter	    = filter;
		
		this.region_string 	= pin_region;
		this.description 	= GetLocStringByKeyExt(factname + "_Description");
		this.position 		= pin_position;
		
		this.localname = GetLocStringByKeyExt("option_" + NameToString(uuid));
		this.SetType();
		
		return this;
	}

	// init function called when creating the instance of this World Map pin.
	function initWorld(group: name, uuid: name, region: PotP_Preview_Region, filter: PotP_Preview_World_Filter, type: PotP_Preview_Entry_Type, pin: name): PotP_PreviewEntry 
	{
		this.type 		= type;
		this.pin_name 	= pin;
		this.group 		= group;
		this.uuid 		= uuid;
		this.region 	= region;
		this.filter	    = filter;
		
		this.localname  = GetLocStringByKeyExt("option_" + NameToString(uuid));
		this.SetType();
		
		return this;
	}

	// init function called when creating the instance of this Item.
	function initItems(group: name, uuid: name, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Items_Filter, item_name: name): PotP_PreviewEntry 
	{
		this.type 		= type;
		this.item_name 	= item_name;
		this.filter	    = filter;
		this.group 		= group;
		this.uuid 		= uuid;
		
		this.localname  = GetLocStringByKeyExt("option_" + NameToString(uuid));
		this.SetType();
		
		return this;
	}

	// init function called when creating the instance of this Gwent Card.
	function initGwent(group: name, uuid: name, type: PotP_Preview_Entry_Type, filter: PotP_Preview_Gwent_Filter, item_name: name): PotP_PreviewEntry 
	{
		this.type 		  = type;
		this.item_name 	  = item_name;
		this.filter	      = filter;
		this.group 		  = group;
		this.uuid 		  = uuid;
		
		this.card_details 	= this.GetCardSource(item_name);
		this.is_bought 		= this.card_details.requires == PotP_G_Bought;
		this.is_loot 		= this.card_details.requires == PotP_G_Looted;
		this.is_dual 		= this.card_details.requires == PotP_G_Dualed;
		this.is_reward 		= this.card_details.requires == PotP_G_Reward;
		this.region			= this.card_details.location;
		
		this.localname  = GetLocStringByKeyExt("option_" + NameToString(uuid));
		this.SetType();
		
		//PotP_Logger(localname + " can be " + card_details.requires + " in " + card_details.location, , 'PotP Preview Entry');
		return this;
	}
	
	// Sets the entry type.
	function SetType() : void
	{
		switch (this.type)
		{
		case PotP_E_Missable:
			this.is_missable = true;
			break;

		case PotP_E_Missable_DLC1:
			this.is_missable = true;
			this.is_dlc1 = true;
			break;
			
		case PotP_E_Missable_DLC2:
			this.is_missable = true;
			this.is_dlc2 = true;
			break;

		case PotP_E_ModAdded:
			this.is_modadded = true;
			break;		

		case PotP_E_ModAdded_DLC1:
			this.is_modadded = true;
			this.is_dlc1 = true;
			break;		

		case PotP_E_ModAdded_DLC2:
			this.is_modadded = true;
			this.is_dlc2 = true;
			break;		
	
		case PotP_E_Primary_DLC1:
			this.is_dlc1 = true;
			break;	

		case PotP_E_Primary_DLC2:
			this.is_dlc2 = true;
			break;	
		
		default:
			this.is_missable = false;
			this.is_modadded = false;
			this.is_dlc1 = false;
			this.is_dlc2 = false;
			break;
		}	
	}

	// returns the debug identifier for this entry (if globally enabled).
	function getID() : string 
	{
		if ( (bool) PotP_GetPreviewValue('ProgressOnThePath_Preview_Iden') ) 
		{
			return "[" + this.identifier + "] - ";
		}
		return "";
	}
	
	// returns where this gwent card can be found in the world.
	function GetCardSource( missingCard : name ) : PotP_Preview_Gwent_Details
	{
		var redux : bool = PotP_UsingGwentRedux();
		var sourceCSV : C2dArray;
		var sourceLocation: PotP_Preview_Region;
		var sourceRequires: PotP_Preview_CardInfo;
		var Idx: int;
		
		sourceCSV = LoadCSV("qa\card_sources.csv");
		
		if (redux)
		{
			sourceCSV = LoadCSV("gameplay\globals\card_sources.csv");
		}

		for ( Idx = 0 ; Idx < sourceCSV.GetNumRows() ; Idx += 1 )
		{
			if (sourceCSV.GetValueAsName("CardName", Idx) == missingCard)
			{
				if (redux) {
					sourceRequires = this.GetSourceRequirements(sourceCSV.GetValue("Details", Idx));
				}
				else {
					sourceRequires = this.GetSourceRequirements(sourceCSV.GetValue("Source", Idx));
				}
				
				sourceLocation = this.GetsourceCardLocation(sourceCSV.GetValue("OriginArea", Idx));
				return PotP_Preview_Gwent_Details(sourceLocation, sourceRequires);
			}
		}
		return PotP_Preview_Gwent_Details(PotP_R_NA, PotP_G_NoIdea);
	}

	function GetSourceRequirements(info: string) : PotP_Preview_CardInfo
	{
		switch(info) 
		{
		case "Quest":
		case "gwint_source_quest":
			return PotP_G_Reward;
		
		case "Won":
		case "gwint_source_duel":
			return PotP_G_Dualed;
		
		case "Loot":
		case "gwint_source_loot":
			return PotP_G_Looted;
		
		case "Bought":
		case "gwint_source_shop":
			return PotP_G_Bought;				
	
		default:
			return PotP_G_Dualed;
		}
	}

	function GetsourceCardLocation(info: string) : PotP_Preview_Region
	{
		switch (info)
		{
		case "NML":
			return PotP_R_VE;

		case "Novigrad":
			return PotP_R_NO;

		case "Skellige":
			return PotP_R_SK;
			
		case "Prologue":
			return PotP_R_WO;

		case "Vizima":
			return PotP_R_VI;
			
		case "KaerMorhen":
			return PotP_R_KM;

		case "Toussaint":
			return PotP_R_TS;

		case "Random":
			return PotP_R_NA;
			
		default:
			return PotP_R_NA;
		}
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------