//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_Quest_Updater
{
	public var filename: name;
		default filename = 'PotP Quest Script';
	
	public var master: CProgressOnThePath;
	
	//---------------------------------------------------

	public function initialise(PotP_BaseClass: CProgressOnThePath) : CProgressOnThePath_Quest_Updater
	{
		this.master = PotP_BaseClass;
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
		var pData_E: array<PotP_PreviewEntry> 	= parent.master.PotP_ArrayManager.MasterList_Quests;
		var pData_L: array<string> 				= parent.master.PotP_ArrayManager.MasterList_Quests_Lookup;
		var i, x, status: int;
		
		QstManager.GetActivatedOfType('CJournalQuest', ent_arr );

		for ( i = 0; i < ent_arr.Size(); i += 1 ) 
		{
			status = QstManager.GetEntryStatus(ent_arr[i]);
			
			x = pData_L.FindFirst(ent_arr[i].baseName);
			if (x == -1)
			{	
				PotP_Logger("Unsupported Quest Found - " + ent_arr[i].baseName, , parent.filename);
				continue;
			}
			
			if (pData_E[x].UpdateQuestEntry(status))
			{
				if (status == JS_Success || status == JS_Failed)
				{
					pData_E[x].AddToNotificationQueue();
				}
			}				
		}
	}
}

