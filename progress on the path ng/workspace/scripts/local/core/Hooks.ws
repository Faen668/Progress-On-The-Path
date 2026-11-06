//---------------------------------------------------
//-- Hooks ------------------------------------------
//---------------------------------------------------
// For other mods to wrap with @wrapMethod. Each does what PotP does by itself, so nothing changes unless one is wrapped.
// Names and signatures here are kept stable. These run each time the overlay reads the list, so keep a wrap quick.

// Whether PotP adds its own journal tags and notes for this entry. False when another mod writes its own for it.
function PotP_UseNativeJournalAdvice(tracked: CPotP_Entry) : bool
{
	return true;
}

// The note under an entry in the Missable tab, and in its details: the text itself, worked out however you like.
// <br> starts a new line. The row hides it once the entry is done or missed.
function PotP_GetMissableTip(tracked: CPotP_Entry) : string
{
	if (tracked.missable_tip != "")
	{
		return GetLocStringByKeyExt(tracked.missable_tip);
	}
	return "";
}

// A group's heading in the list: the text itself.
function PotP_GetMissableHeader(section: CPotP_Section) : string
{
	if (section.header_id > 0)
	{
		return GetLocStringById(section.header_id);
	}
	return GetLocStringByKeyExt(section.header);
}

// Whether an entry is listed in the Missable tab. False leaves it out of the tab and its counts, for now: it's asked each time.
// It stays in the mod's totals and on its other tabs.
function PotP_ShowInMissableTab(tracked: CPotP_Entry) : bool
{
	return true;
}

// The status the Missable tab shows for an entry, if it should differ from what's been recorded.
function PotP_GetMissableStatus(tracked: CPotP_Entry) : EPotP_Status
{
	return tracked.status;
}
