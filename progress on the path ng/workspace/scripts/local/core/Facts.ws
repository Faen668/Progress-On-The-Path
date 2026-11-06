//---------------------------------------------------
//-- Facts ------------------------------------------
//---------------------------------------------------

function PotP_Fact_Override(uuid: string) : string
{
	return "potp_ov_" + uuid;
}

function PotP_Fact_Collected(item: name) : string
{
	return NameToString(item) + "_collected";
}

function PotP_Fact_EventUnlocked(fact_name: string) : string
{
	return fact_name + "_unlocked";
}

function PotP_Fact_EventMissed(fact_name: string) : string
{
	return fact_name + "_Missed";
}

//---------------------------------------------------

function PotP_Fact_Version() : string
{
	return "ProgressOnThePath_CurrentModVersion";
}

function PotP_Fact_Initialised() : string
{
	return "PotP_Initialised";
}

//---------------------------------------------------
// Facts cannot reliably hold 0, so stored values are offset by one. Values are
// 16-bit signed in the save: keep them between -32767 and 32766.

function PotP_FactGetStored(fact_name: string, out stored_value: int) : bool
{
	if (!FactsDoesExist(fact_name))
	{
		return false;
	}
	stored_value = FactsQuerySum(fact_name) - 1;
	return true;
}

function PotP_FactSetStored(fact_name: string, stored_value: int)
{
	FactsSet(fact_name, stored_value + 1);
}

//---------------------------------------------------

function PotP_FactClear(fact_name: string)
{
	if (FactsDoesExist(fact_name))
	{
		FactsRemove(fact_name);
	}
}
