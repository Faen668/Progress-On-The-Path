//
// Progress on the Path - TW3 Progress Tracker
// Script Version: 1.0.0 by K1ngTr4cker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

struct PotP_PlayerNotification
{
	var message_uuid	: string;
	var message_title	: string;
	var message_body	: string;
	
	var is_unique		: bool;
}

statemachine class CProgressOnThePath_TutorialPopup
{	
	public var filename: name;
		default filename = 'PotP Popup Manager';
	
	public var master: CProgressOnThePath;

	//---------------------------------------------------

	public function initialise(master: CProgressOnThePath)
	{
		this.master = master;
		
		//Display Pending Messages in persistent storage.
		if (master.PotP_PersistentStorage.MasterList_Pl_Messages.Size() > 0)
		{
			this.GotoState('ShowMessage');
		}
	}
	
	//---------------------------------------------------
		
	public function Showpopup(title: string, body: string, uuid: string, type: string, is_unique: bool) 
	{		
		if (type == "PopUp")
		{
			this.DisplayUserMessage(PotP_PlayerNotification(uuid, title, body, is_unique));
			return;
		}
		
		if (!is_unique && uuid == "")
		{
			uuid = "PotP_GenericMessageID";
		}
		
		master.PotP_PersistentStorage.MasterList_Pl_Messages.PushBack(PotP_PlayerNotification(uuid, title, body, is_unique));
		if (!this.IsInState('ShowMessage')) 
		{ 
			this.GotoState('ShowMessage'); 
		}
	}

//---------------------------------------------------

	private function DisplayUserMessage(message: PotP_PlayerNotification) {

		var popup_data: PotP_PopupData = new PotP_PopupData in thePlayer;

		popup_data.SetMessageTitle( message.message_title );
		popup_data.SetMessageText( message.message_body );
		popup_data.PauseGame = true;
		
		if (PotP_UsingVladimirUI()) 
		{
			popup_data.ScreenPosX = 400.0 / 1920.0;
		}
		
		theGame.RequestMenu('PopupMenu', popup_data);
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state Idle in CProgressOnThePath_TutorialPopup 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [Idle]", , parent.filename);
		
		if (parent.master.PotP_PersistentStorage.MasterList_Pl_Messages.Size() > 0)
		{
			parent.GotoState('ShowMessage');
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state ShowMessage in CProgressOnThePath_TutorialPopup 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		PotP_Logger("Entered state [ShowMessage]", , parent.filename);
		
		this.ShowMessage_Entry();
	}
	
//---------------------------------------------------

	entry function ShowMessage_Entry()
	{
		var message: PotP_PlayerNotification;

		while (PotP_IsPlayerBusy()) 
		{
			PotP_Logger("Waiting For Player Busy Check...", , parent.filename);
			Sleep(5);
		}
		
		message = parent.master.PotP_PersistentStorage.MasterList_Pl_Messages[0];
		
		this.DisplayUserMessage(message);

		if (message.is_unique)
		{
			FactsSet(message.message_uuid, 1);
		}
			
		parent.master.PotP_PersistentStorage.MasterList_Pl_Messages.Erase(0);
		parent.GotoState('Idle');
	}
	
//---------------------------------------------------

	latent function DisplayUserMessage(message: PotP_PlayerNotification) {

		var m_tutorialHintDataObj: W3TutorialPopupData = new W3TutorialPopupData in thePlayer;

		m_tutorialHintDataObj.managerRef = theGame.GetTutorialSystem();
		m_tutorialHintDataObj.messageTitle = message.message_title;
		m_tutorialHintDataObj.messageText = "<p align=\"center\">" + message.message_body + "</p>";
		m_tutorialHintDataObj.enableGlossoryLink = false;		
		m_tutorialHintDataObj.autosize = true;
		m_tutorialHintDataObj.blockInput = false;
		m_tutorialHintDataObj.pauseGame = false;
		m_tutorialHintDataObj.fullscreen = false;
		m_tutorialHintDataObj.canBeShownInMenus = true;
		m_tutorialHintDataObj.imagePath = "icons/PotP/wolf.png";
		
		m_tutorialHintDataObj.posX = 0.f;
		m_tutorialHintDataObj.posY = 0.40f;
		
		m_tutorialHintDataObj.duration = ( (float) PotP_GetNotificationValue('ProgressOnThePath_GloballNotification_Time') * 1000 );
		if (message.is_unique)
		{
			m_tutorialHintDataObj.duration = (10 * 1000);
		}
		
		theGame.GetTutorialSystem().ShowTutorialHint(m_tutorialHintDataObj);
		Sleep(m_tutorialHintDataObj.duration);
	}
}
	
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------
	
class PotP_PopupData extends BookPopupFeedback {

	public function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject {
		var objResult : CScriptedFlashObject;
		objResult = super.GetGFxData(parentFlashValueStorage);
		objResult.SetMemberFlashString("iconPath", "img://icons/inventory/scrolls/scroll2.dds");
		return objResult;
	}

	public function SetupOverlayRef(target : CR4MenuPopup) : void {
		super.SetupOverlayRef(target);
		PopupRef.GetMenuFlash().GetChildFlashSprite("background").SetAlpha(100.0);
	}
}

//---------------------------------------------------
//-- End Of Code ------------------------------------
//---------------------------------------------------