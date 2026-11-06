//---------------------------------------------------
//-- Tracked Entry ----------------------------------
//---------------------------------------------------

class CPotP_Entry
{
	var uuid			: string;
	var identifier		: string;
	var title			: string;
	var category		: PotP_Preview_Array_Type;
	var entry_type		: PotP_Preview_Entry_Type;
	var region			: PotP_Preview_Region;
	var filter			: int;
	var sub_filter		: int;
	var status			: EPotP_Status;

	var is_missable		: bool;
	var is_modadded		: bool;
	var dlc_index		: int;

	var missable_group	: CPotP_Section;
	var missable_tip	: string;

	var entry_name		: string;

	var map_region		: string;
	var position		: Vector;
	var starts_unlocked	: bool;

	var from_hour		: int;
	var to_hour			: int;

	var fallback_facts	: array<string>;
	var fallback_journal	: name;

	var missed_fact		: string;
	var missed_unless	: string;		// not missed after all if this fact is set
	var also_missed_fact	: string;	// missed if this is set, whatever else
	var outcome_facts	: array<string>;	// a journal quest that completes either way: only one of these makes it done
	var unlock_facts	: array<string>;	// an event that opens when all of these are set

	var pin_name		: name;
	var alt_pin_name	: name;		// the same pin under another name, such as before or after a mod renames it

	var item_name		: name;
	var variations		: array<name>;
	var card_names		: array<name>;
	var card_type		: PotP_Preview_CardType;

	var creature_name_id	: int;		// tells a bestiary entry apart: the game's name for it
	var creature_alt_ids	: array<int>;	// the same creature's other entries, by their names (a DLC's own), found as it
	var creature_image		: string;
	var creature_template	: string;	// its model, for the Live Bestiary: an npc template's path, with / between folders
	var creature_items		: array<name>;
	var creature_texts		: array<int>;

	//---------------------------------------------------

	public function Init(entry_uuid: string, entry_category: PotP_Preview_Array_Type, type_value: PotP_Preview_Entry_Type, entry_region: PotP_Preview_Region, filter_value: int, sub_filter_value: int) : CPotP_Entry
	{
		var type_int : int = (int)type_value;

		uuid		= entry_uuid;
		category	= entry_category;
		entry_type	= type_value;
		region		= entry_region;
		filter		= filter_value;
		sub_filter	= sub_filter_value;
		status		= PotP_S_Available;

		dlc_index	= type_int % 3;
		is_missable	= (type_int / 3) == 1;
		is_modadded	= (type_int / 3) == 2;
		return this;
	}

	//---------------------------------------------------

	public function SetItem(base_item: name) : CPotP_Entry
	{
		item_name = base_item;
		variations.Clear();
		variations.PushBack(base_item);
		return this;
	}

	//---------------------------------------------------

	public function AddVariation(variation: name)
	{
		if (variation != '' && !variations.Contains(variation))
		{
			variations.PushBack(variation);
		}
	}

	//---------------------------------------------------

	public function AddCardVariation(variation: name, card_name: name)
	{
		variations.PushBack(variation);
		card_names.PushBack(card_name);
	}

	//---------------------------------------------------

	public function AddFallbackFact(fact_name: string)
	{
		if (fact_name != "" && !fallback_facts.Contains(fact_name))
		{
			fallback_facts.PushBack(fact_name);
		}
	}

	//---------------------------------------------------

	public function IsDone() : bool
	{
		return status == PotP_S_Completed || status == PotP_S_Ignored;
	}

	//---------------------------------------------------
}
