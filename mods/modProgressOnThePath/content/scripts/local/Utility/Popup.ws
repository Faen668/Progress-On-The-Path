//
// Progress on the Path - TW3 Progress Tracker
// Script Version: 1.0.0 by K1ngTr4cker
//
//---------------------------------------------------
//-- Class ------------------------------------------
//---------------------------------------------------

statemachine class CProgressOnThePath_TutorialPopup extends CEntity {	
	
	public var MessageID: string;
		default MessageID = "";
		
	public var MessageTitle: string;
		default MessageTitle = "";
		
	public var Messagebody: string;
		default Messagebody = "";

	public var TutorialPopUp: bool;
		default TutorialPopUp = false;

	public var TutorialHint: bool;
		default TutorialHint = false;
		
	public function Showpopup(M: string, B: string, U: string, optional force: bool, optional isTutorialMessage: bool, optional isTutorialHint: bool) {
	
		MessageTitle = M;
		Messagebody = B;
		MessageID = U;
		
		TutorialPopUp = isTutorialMessage;
		TutorialHint = isTutorialHint;

		if (FactsQuerySum(MessageID) == 0 || force) {
			this.GotoState('PT_Waiting');
			this.GotoState('PT_Running');
		}
	}
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state PT_Waiting in CProgressOnThePath_TutorialPopup {
}

//---------------------------------------------------
//-- States -----------------------------------------
//---------------------------------------------------

state PT_Running in CProgressOnThePath_TutorialPopup {
		
	event OnEnterState(previous_state_name: name) {
		this._Entry();
	}

//---------------------------------------------------

	entry function _Entry() {
		
		while (PotP_IsPlayerBusy()) {
			Sleep(5);
		}
		
		FactsSet(parent.MessageID, 1);
		
		if (parent.TutorialPopUp) {
			this._OpenTutorial();
			return;
		}

		if (parent.TutorialHint) {
			this._OpenTutorialHint();
			return;
		}
		
		this._Open();
	}

//---------------------------------------------------

	latent function _Open() {

		var popup_data: PotP_PopupData;

		popup_data = new PotP_PopupData in thePlayer;

		popup_data.SetMessageTitle( parent.MessageTitle );
		popup_data.SetMessageText( parent.Messagebody );

		popup_data.PauseGame = true;
		
		if (PotP_UsingVladimirUI()) {
			popup_data.ScreenPosX = 400.0 / 1920.0;
		}
		
		theGame.RequestMenu('PopupMenu', popup_data);
	}

//---------------------------------------------------

	latent function _OpenTutorial() {

		var tut: W3TutorialPopupData = new W3TutorialPopupData in thePlayer;
		tut.managerRef = theGame.GetTutorialSystem();
		
		tut.messageTitle = parent.MessageTitle;
		tut.messageText = parent.Messagebody;
		
		tut.enableGlossoryLink = false;
		tut.autosize = true;
		tut.blockInput = true;
		tut.pauseGame = true;
		tut.fullscreen = true;	
		tut.canBeShownInMenus = true;
		tut.enableAcceptButton = true;
		
		theGame.GetTutorialSystem().ShowTutorialHint(tut);
	}

//---------------------------------------------------

	latent function _OpenTutorialHint() {

		var m_tutorialHintDataObj: W3TutorialPopupData = new W3TutorialPopupData in thePlayer;

		m_tutorialHintDataObj.managerRef = theGame.GetTutorialSystem();
		m_tutorialHintDataObj.messageTitle = parent.MessageTitle;
		m_tutorialHintDataObj.messageText = "<p align=\"center\">" + parent.Messagebody + "</p>";
		m_tutorialHintDataObj.enableGlossoryLink = false;		
		m_tutorialHintDataObj.autosize = true;
		m_tutorialHintDataObj.blockInput = false;
		m_tutorialHintDataObj.pauseGame = false;
		m_tutorialHintDataObj.fullscreen = false;
		m_tutorialHintDataObj.canBeShownInMenus = true;
		m_tutorialHintDataObj.imagePath = "icons/PotP/wolf.png";
		
		m_tutorialHintDataObj.posX = 0.f;
		m_tutorialHintDataObj.posY = 0.40f;
		m_tutorialHintDataObj.duration = 5 * 1000;
		
		theGame.GetTutorialSystem().ShowTutorialHint(m_tutorialHintDataObj);
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