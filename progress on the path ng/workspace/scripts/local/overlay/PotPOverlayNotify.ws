// PotP's notification goes where the game's own does, so it waits for the game's to finish. Every one of the game's
// goes through CR4OverlayPopup.ShowNotification, so this keeps its own count of how long they'll last, as the queue
// inside the Flash can't be read. The Flash's own flag says the same when it can be read.

@addField(CR4OverlayPopup)
var potp_busy_until : float;

@wrapMethod(CR4OverlayPopup)
function ShowNotification(messageText : string, optional duration : float, optional queue : bool) : void
{
	var now		: float = theGame.GetEngineTimeAsSeconds();
	var seconds	: float = 4.5;   // the Flash's default of 4000 ms, and its fade

	if (duration > 0)
	{
		seconds = duration / 1000.0 + 0.5;
	}
	if (queue && potp_busy_until > now)
	{
		potp_busy_until += seconds;
	}
	else
	{
		potp_busy_until = now + seconds;
	}
	wrappedMethod(messageText, duration, queue);
}

@wrapMethod(CR4OverlayPopup)
function HideNotification() : void
{
	potp_busy_until = 0;
	wrappedMethod();
}

@wrapMethod(CR4OverlayPopup)
function ClearNotificationsQueue() : void
{
	potp_busy_until = 0;
	wrappedMethod();
}

@addMethod(CR4OverlayPopup)
function PotPOverlay_NotificationUp() : bool
{
	var module : CScriptedFlashSprite;

	if (theGame.GetEngineTimeAsSeconds() < potp_busy_until)
	{
		return true;
	}
	module = m_flashModule.GetChildFlashSprite("notificationModule");
	return module && module.GetMemberFlashBool("_shown");
}

// 1 while PotP's has to wait: the game's notification is up, or there's nothing to show it over
function PotPOverlay_PopupHold() : int
{
	var overlay : CR4OverlayPopup;

	overlay = (CR4OverlayPopup)theGame.GetGuiManager().GetPopup('OverlayPopup');
	if (!thePlayer || theGame.IsLoadingScreenVideoPlaying() || thePlayer.IsInNonGameplayCutscene())
	{
		return 1;
	}
	if (overlay && overlay.PotPOverlay_NotificationUp())
	{
		return 1;
	}
	return 0;
}

// The next of PotP's notifications for the overlay to draw, or an empty string
function PotPOverlay_NextMessage() : string
{
	var main : CPotP_Main;

	if (!thePlayer)
	{
		return "";
	}
	main = PotP_Get();
	if (!main)
	{
		return "";
	}
	return main.notifications.TakeOverlayMessage();
}
