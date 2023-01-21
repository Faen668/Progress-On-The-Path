//
// Progress on the Path - TW3 Progress Tracker
// Script by K1ngTr4cker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_QuestGoblin
{	
	public var filename: name;
		default filename = 'PotP Quest Goblin';
		
	public var last_addition_time: float;	
	public var quest_array: array<CJournalQuest>;
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath)
	{
		this.master = PotP_BaseClass;
	}
	
	//---------------------------------------------------
	
	public function _OnQuestUpdate(journalQuest : CJournalQuest) 
	{
		this.quest_array.PushBack(journalQuest);
		this.last_addition_time = theGame.GetEngineTimeAsSeconds();
		
		if (!this.IsInState('QuestUpdated')) 
		{
			this.GotoState('QuestUpdated');
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_QuestGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		parent.quest_array.Clear();
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state QuestUpdated in CProgressOnThePath_QuestGoblin
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [QuestUpdated]", , parent.filename);
	
		this._QuestUpdated_ProcessQuest();
	}

//---------------------------------------------------

	entry function _QuestUpdated_ProcessQuest() 
	{
		var current_time: float = theGame.GetEngineTimeAsSeconds();
		var sleep_time: int = (int) PotP_GetGeneralValue('ProgressOnThePath_BGProcessing_Qust');
		
		while ((current_time - parent.last_addition_time < sleep_time) || PotP_IsPlayerBusy()) 
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			SleepOneFrame();
		}
		this._QuestUpdated_BuildAndSend();
	}

//---------------------------------------------------
	
	latent function _QuestUpdated_BuildAndSend() 
	{
		var QstManager: CWitcherJournalManager = theGame.GetJournalManager();
		var i, x, status: int;
		
		var pData_E: array<PotP_PreviewEntry> = parent.master.PotP_ArrayManager.MasterList_Quests;
		var pData_L: array<string> = parent.master.PotP_ArrayManager.MasterList_Quests_Lookup;
		
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}

		for ( i = 0; i < parent.quest_array.Size(); i += 1 ) 
		{
			status = QstManager.GetEntryStatus(parent.quest_array[i]);

			x = pData_L.FindFirst(parent.quest_array[i].baseName);
			if (x == -1)
			{	
				parent.quest_array.Erase(i);
				continue;
			}
			
			if (parent.master.PotP_PersistentStorage.UpdateQuestEntry(pData_E[x], status))
			{
				parent.master.PotP_Notifications.UpdatePlayerFromQuest(pData_E[x].localname, status, pData_E[x].is_dlc1, pData_E[x].is_dlc2);
				parent.quest_array.Erase(i);
			}				
		}
	
		while (PotP_IsPlayerBusy()) 
		{
			SleepOneFrame();
		}
		
		parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		parent.GotoState('Idle');		
	}
}