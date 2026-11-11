//---------------------------------------------------
//-- Section ----------------------------------------
//---------------------------------------------------

class CPotP_Section
{
	var book			: EPotP_Book;
	var header			: string;
	var header_id		: int;		// a bestiary category's name, which the game keeps by number
	var category		: PotP_Preview_Array_Type;
	var group			: string;
	var needs_skellige	: bool;
	var entries			: array<CPotP_Entry>;

	// Missable groups
	var missable_kind	: EPotP_MissableKind;
	var cutoff_uuid		: string;
	var cutoff_trigger	: EPotP_CutoffTrigger;
	var cutoff			: CPotP_Entry;

	//---------------------------------------------------

	public function Init(book_value: EPotP_Book, header_key: string, category_value: PotP_Preview_Array_Type, group_prefix: string) : CPotP_Section
	{
		book		= book_value;
		header		= header_key;
		category	= category_value;
		group		= group_prefix;
		return this;
	}

	//---------------------------------------------------

	public function InitMissable(header_key: string, kind_value: EPotP_MissableKind, cutoff_value: string, trigger_value: EPotP_CutoffTrigger) : CPotP_Section
	{
		Init(PotP_Book_Missable, header_key, PotP_A_Quest, "");
		missable_kind	= kind_value;
		cutoff_uuid		= cutoff_value;
		cutoff_trigger	= trigger_value;
		return this;
	}

	//---------------------------------------------------

	public function IsVisible() : bool
	{
		var gwent : CR4GwintManager;

		if (category != PotP_A_Gwent)
		{
			return true;
		}

		gwent = theGame.GetGwintManager();
		if (!gwent.HasLootedCard())
		{
			return false;
		}
		return !needs_skellige || gwent.IsDeckUnlocked(GwintFaction_Skellige);
	}

	//---------------------------------------------------
	//-- Missable groups --------------------------------
	//---------------------------------------------------

	public function IsCutoffPassed() : bool
	{
		if (!cutoff)
		{
			return false;
		}

		switch (cutoff_trigger)
		{
		case PotP_T_Started:
			return cutoff.status == PotP_S_InProgress || cutoff.status == PotP_S_Completed;

		case PotP_T_Completed:
			return cutoff.status == PotP_S_Completed;

		case PotP_T_Ended:
			return cutoff.status == PotP_S_Completed || cutoff.status == PotP_S_Missed;

		default:
			return false;
		}
	}

	//---------------------------------------------------

	public function IsCutoffApproaching() : bool
	{
		if (!cutoff)
		{
			return false;
		}
		return (cutoff_trigger == PotP_T_Completed || cutoff_trigger == PotP_T_Ended) && cutoff.status == PotP_S_InProgress;
	}

	//---------------------------------------------------

	public function GetOutstanding() : array<CPotP_Entry>
	{
		var outstanding	: array<CPotP_Entry>;
		var Idx			: int;

		for (Idx = 0; Idx < entries.Size(); Idx += 1)
		{
			if (!entries[Idx].IsDone() && entries[Idx].status != PotP_S_Missed && !entries[Idx].untracked)
			{
				outstanding.PushBack(entries[Idx]);
			}
		}
		return outstanding;
	}
}
