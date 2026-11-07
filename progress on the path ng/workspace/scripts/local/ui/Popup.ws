//---------------------------------------------------
//-- Popups -----------------------------------------
//---------------------------------------------------
// One-off messages, drawn by the overlay. A message sits in the notification's place for a while, and a warning
// pauses the game until it's accepted. They're held back until the player is free.
//   P|kind|seconds|size|colour|title|body   kind: 1 a message, 2 a warning; size and colour: the notification settings.
//   The body keeps its <br/> and <font color> tags.
// The special ones, an event unlocked or the mod updated, get the overlay's banner:
//   H|what|seconds|headline|below   what: event, update, install, ngplus, content
// A missable warning comes ready made for the overlay (Notifications.ShowMissableWarning): W|..., with no title.

struct PotP_PopupMessage
{
	var uuid		: string;
	var title		: string;
	var body		: string;
	var is_unique	: bool;
	var delay		: float;
	var is_warning	: bool;
	var herald		: string;
}

//---------------------------------------------------

statemachine class CPotP_Popup
{
	default autoState = 'Idle';

	var queue : array<PotP_PopupMessage>;

	//---------------------------------------------------

	public function Show(title: string, body: string, uuid: string, is_unique: bool, optional delay: float, optional is_warning: bool)
	{
		if (is_unique && FactsDoesExist(uuid))
		{
			return;
		}

		queue.PushBack(PotP_PopupMessage(uuid, title, body, is_unique, delay, is_warning, ""));

		if (!IsInState('Showing'))
		{
			GotoState('Showing');
		}
	}

	//---------------------------------------------------

	public function ShowHerald(what: string, headline: string, below: string, uuid: string, is_unique: bool, optional delay: float)
	{
		if (is_unique && FactsDoesExist(uuid))
		{
			return;
		}

		queue.PushBack(PotP_PopupMessage(uuid, headline, below, is_unique, delay, false, what));

		if (!IsInState('Showing'))
		{
			GotoState('Showing');
		}
	}

	//---------------------------------------------------

	public function ShowWarning(title: string, body: string, uuid: string)
	{
		Show(title, body, uuid, true, 0, true);
	}
}

//---------------------------------------------------

state Idle in CPotP_Popup
{
}

//---------------------------------------------------

state Showing in CPotP_Popup
{
	event OnEnterState(previous_state_name: name)
	{
		super.OnEnterState(previous_state_name);
		this.ShowQueued();
	}

	//---------------------------------------------------

	entry function ShowQueued()
	{
		var message		: PotP_PopupMessage;
		var main		: CPotP_Main;
		var seconds		: string;
		var kind		: string;

		while (parent.queue.Size() > 0)
		{
			while (PotP_IsPlayerBusy())
			{
				Sleep(2);
			}

			message = parent.queue[0];
			parent.queue.Erase(0);

			if (message.is_unique && FactsDoesExist(message.uuid))
			{
				continue;
			}

			if (message.delay > 0)
			{
				Sleep(message.delay);
			}

			if (message.is_unique)
			{
				FactsSet(message.uuid, 1);
			}

			kind = "1";
			seconds = PotP_GetSetting('ProgressOnThePath_GlobalNotification_Time');
			if (message.is_warning)
			{
				kind = "2";
			}
			else if (message.is_unique)
			{
				seconds = "10";
			}

			main = PotP_Get();
			if (main && message.is_warning && message.title == "" && StrBeginsWith(message.body, "W|"))
			{
				main.notifications.QueueForOverlay(message.body);
			}
			else if (main && StrLen(message.herald) > 0)
			{
				main.notifications.QueueForOverlay("H|" + message.herald + "|10|" + PotPOverlay_Clean(message.title) + "|" + PotPOverlay_Clean(message.body));
			}
			else if (main)
			{
				main.notifications.QueueForOverlay("P|" + kind + "|" + seconds + "|" + PotP_GetSetting('ProgressOnThePath_GlobalNotification_Size') + "|" + PotP_GetSetting('ProgressOnThePath_GlobalNotification_Font') + "|" + StrReplace(message.title, "|", "/") + "|" + StrReplace(message.body, "|", "/"));
			}
		}

		parent.GotoState('Idle');
	}
}
