//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------		

statemachine class CProgressOnThePath_QuestGoblin
{	
	public var filename: name;
		default filename = 'PotP Quest Goblin';

	public var quest_entity_array: array<PotP_PreviewEntry>;
	public var quest_lookup_array: array<string>;

	public var manager: CWitcherJournalManager;
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var last_addition_time: float;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		this.storage = master.PotP_PersistentStorage;
		
		this.quest_entity_array = master.PotP_ArrayManager.MasterList_Quests;
		this.quest_lookup_array = master.PotP_ArrayManager.MasterList_Quests_Lookup;
		this.manager = theGame.GetJournalManager();
	}
	
	//---------------------------------------------------
	
	public function _OnQuestUpdate(journalQuest : CJournalQuest) 
	{
		if (this.IsInState('Disabled')) 
		{ 
			return;
		}

		if ( quest_lookup_array.Contains(journalQuest.baseName) )
		{
			this.storage.MasterList_QuestGoblin.PushBack(journalQuest);
			this.last_addition_time = theGame.GetEngineTimeAsSeconds();
			
			if (!this.IsInState('QuestUpdated')) 
			{ 
				this.GotoState('QuestUpdated'); 
			}
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Disabled in CProgressOnThePath_QuestGoblin 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Disabled]", , parent.filename);
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

		if (parent.storage.MasterList_QuestGoblin.Size() > 0)
		{
			parent.GotoState('QuestUpdated');
		}
		else
		{
			parent.master.PotP_Notifications.NotifyPlayerFromBackgroundProcess();
		}
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
	
		this._QuestUpdated_Entry();
	}

//---------------------------------------------------

	entry function _QuestUpdated_Entry() 
	{	
		var current_time, sleep_time: float;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		current_time = theGame.GetEngineTimeAsSeconds();
		sleep_time = 3;
		
		while (current_time - parent.last_addition_time < sleep_time)
		{
			current_time = theGame.GetEngineTimeAsSeconds();
			Sleep(1);
		}

		this.ProcessQuest();
		parent.storage.MasterList_QuestGoblin.Erase(0);
		parent.GotoState('Idle');
	}

//---------------------------------------------------
	
	latent function ProcessQuest() 
	{	
		var Idx: int = parent.quest_lookup_array.FindFirst(parent.storage.MasterList_QuestGoblin[0].baseName);
		var status: int = parent.manager.GetEntryStatus(parent.storage.MasterList_QuestGoblin[0]);

		if (Idx != -1 && parent.quest_entity_array[Idx].UpdateQuestEntry(status))
		{			
			parent.quest_entity_array[Idx].AddToBackgroundQueue(status);
		}
			
		SleepOneFrame();		
	}
}

