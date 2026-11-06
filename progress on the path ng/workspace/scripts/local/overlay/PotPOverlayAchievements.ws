// What the game itself knows about achievements, for the overlay's Achievements tab. The game asks whichever store it's
// running on, so this works on all of them. It has no dates: the overlay gets those from the store, where it can.
//   L|language                     the game's text language
//   A|name|unlocked|value|target   an achievement (value -1: this save keeps no count of it)

// This save's count towards it, from the same stats the game's own checks use
@addMethod(W3GamerProfile)
function PotPOverlay_Progress(achievement: EAchievement, out value: int, out target: int) : bool
{
	var Idx		: int;
	var Other	: int;

	for (Idx = 0; Idx < statistics.Size(); Idx += 1)
	{
		for (Other = 0; Other < statistics[Idx].registeredAchievements.Size(); Other += 1)
		{
			if (statistics[Idx].registeredAchievements[Other].type == achievement)
			{
				value = GetStatValue(statistics[Idx].statType);
				target = (int)statistics[Idx].registeredAchievements[Other].requiredValue;
				return true;
			}
		}
	}
	return false;
}

// The ones the game counts in its own way (CheckLearningTheRopes, CheckTrialOfGrasses, Debug_PrintAchievements)
function PotPOverlay_SpecialProgress(achievement: EAchievement, out value: int, out target: int) : bool
{
	var witcher	: W3PlayerWitcher;
	var points	: array<SAvailableFastTravelMapPin>;

	switch (achievement)
	{
	case EA_LearningTheRopes:
		value = FactsQuerySum("ach_counter") + FactsQuerySum("ach_attack") + FactsQuerySum("ach_sign") + FactsQuerySum("ach_bomb");
		target = 4;
		return true;

	case EA_TrialOfGrasses:
		witcher = GetWitcherPlayer();
		if (!witcher)
		{
			return false;
		}
		value = 0;
		if (witcher.IsAnyItemEquippedOnSlot(EES_SkillMutagen1)) { value += 1; }
		if (witcher.IsAnyItemEquippedOnSlot(EES_SkillMutagen2)) { value += 1; }
		if (witcher.IsAnyItemEquippedOnSlot(EES_SkillMutagen3)) { value += 1; }
		if (witcher.IsAnyItemEquippedOnSlot(EES_SkillMutagen4)) { value += 1; }
		target = 4;
		return true;

	case EA_Explorer:
		points = theGame.GetCommonMapManager().GetFastTravelPoints(true, false, false, true, true);
		value = points.Size();
		target = 100;
		return true;
	}
	return false;
}

function PotPOverlay_Achievements() : string
{
	var profile		: W3GamerProfile = theGame.GetGamerProfile();
	var audio		: string;
	var subtitles	: string;
	var result		: string;
	var unlocked	: bool;
	var achievement	: EAchievement;
	var title		: name;
	var value		: int;
	var target		: int;
	var Idx			: int;

	theGame.GetGameLanguageName(audio, subtitles);
	result = "L|" + subtitles;
	for (Idx = (int)EA_FoundYennefer; Idx <= (int)EA_Goliath; Idx += 1)
	{
		achievement = Idx;
		title = AchievementEnumToName(achievement);
		if (!IsNameValid(title))
		{
			continue;
		}
		unlocked = theGame.IsAchievementUnlocked(title);
		value = -1;
		target = 0;
		// A count only means something on a loaded save, and only until it's unlocked
		if (!unlocked && thePlayer && profile)
		{
			if (!profile.PotPOverlay_Progress(achievement, value, target))
			{
				if (!PotPOverlay_SpecialProgress(achievement, value, target))
				{
					value = -1;
					target = 0;
				}
			}
		}
		result += "\n" + "A|" + NameToString(title) + "|" + IntToString((int)unlocked) + "|" + IntToString(value) + "|" + IntToString(target);
	}
	return result;
}
