//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Quest_Updater
{
	public var filename: name;
	default filename = 'PotP Quest Script';
	
	public var master: CProgressOnThePath;
	public var storage: CProgressOnThePath_Storage;
	public var entity_helper: CProgressOnThePath_PreviewEntryHelper;
	
	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath) : CProgressOnThePath_Quest_Updater
	{
		this.master = master;
		this.storage = master.PotP_PersistentStorage;
		this.entity_helper = master.PotP_EntityHelper;
		return this;
	}

	//---------------------------------------------------
	
	public function GetStateName(): string 
	{ 
		return NameToString(filename); 
	}

	//---------------------------------------------------
	
	public function Update() : void
	{
		this.GotoState('Idle');
		this.GotoState('Updating');
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_Quest_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Updating in CProgressOnThePath_Quest_Updater 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Updating]", , parent.filename);
		
		this.Updating_Entry();
	}

//---------------------------------------------------

	entry function Updating_Entry() 
	{
		this.Updating_Main();
		parent.GotoState('Idle');
	}

//---------------------------------------------------

	latent function Updating_Main() 
	{
		var QstManager: CWitcherJournalManager = theGame.GetJournalManager();	
		var ent_arr: array<CJournalBase>;
		
		var quest_entity_array: array<PotP_PreviewEntry> 	= parent.master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests;
		var quest_lookup_array: array<string> 				= parent.master.PotP_PersistentStorage.pQuestStorage.MasterList_Quests_Lookup;
		
		var Idx, Edx, status: int;
		
		QstManager.GetActivatedOfType('CJournalQuest', ent_arr );

		for ( Idx = 0; Idx < ent_arr.Size(); Idx += 1 ) 
		{
			status = QstManager.GetEntryStatus(ent_arr[Idx]);
			
			Edx = quest_lookup_array.FindFirst(ent_arr[Idx].baseName);
			if (Edx == -1)
			{	
				PotP_Logger("Unsupported Quest Found - " + ent_arr[Idx].baseName, , parent.filename);
				continue;
			}
			
			if (parent.entity_helper.UpdateQuestEntry(quest_entity_array[Edx], status) && (status == JS_Success || status == JS_Failed))
			{
				parent.entity_helper.AddToNotificationQueue(quest_entity_array[Edx]);
			}				
		}
	}
}



