//---------------------------------------------------
//-- Hud Wrap ---------------------------------------
//---------------------------------------------------

@wrapMethod( CR4ScriptedHud ) function OnQuestUpdate( journalQuest : CJournalQuest, isQuestUpdate : bool )
{
	var goblin: CProgressOnThePath_QuestGoblin = GetPotP_QuestGoblin();
	
	if (goblin) {
		goblin._OnQuestUpdate(journalQuest);
	}
	
	wrappedMethod(journalQuest, isQuestUpdate);
}