// A third prompt on the radial menu that opens PotP's window. It wraps the game's own classes instead of
// replacing them, so it needs no Script Merger. The radial's own SWF is left alone: its input feedback panel has a public
// appendButton, the same one the game calls for Meditation and Return to game.
//
// The overlay watches for the key and calls these with no arguments, on its tick:
//   PotPOverlay_RadialHello        about once a second, so the prompt only shows when the overlay is loaded
//   PotPOverlay_RadialIsOpen       when the key goes down: 1 when the radial can hand over to the window
//   PotPOverlay_RadialTake         when that same key comes up: closes the radial, 1 when it did

@addField(CR4Player)
var potp_overlay_radial_hello : float;

// The radial's own button ids are small numbers; a far larger one can't replace them.
function PotPOverlay_RadialButtonId() : int
{
	return 7301;
}

// red.core.constants.KeyCode.P, the same number the overlay sees as the virtual key
function PotPOverlay_RadialKeyboardKey() : int
{
	return 80;
}

// NavigationCode.GAMEPAD_Y. The panel draws the pad's own icon for it: Y on Xbox, triangle on PlayStation.
function PotPOverlay_RadialPadButton() : string
{
	return "gamepad_Y";
}

function PotPOverlay_RadialLabel() : string
{
	var label : string = GetLocStringByKeyExt("potp_ov_mod_name");

	if (label == "" || label == "#")
	{
		return "Progress on the Path";
	}
	return label;
}

function PotPOverlay_RadialModule() : CR4HudModuleRadialMenu
{
	var hud : CR4ScriptedHud;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if (!hud)
	{
		return NULL;
	}
	return (CR4HudModuleRadialMenu)hud.GetHudModule("RadialMenuModule");
}

//---------------------------------------------------
//-- The prompt -------------------------------------
//---------------------------------------------------

@addMethod(CR4HudModuleRadialMenu)
function PotPOverlay_AddPrompt()
{
	var panel	: CScriptedFlashSprite;
	var append	: CScriptedFlashFunction;

	// The radial hides its whole panel for Ciri, and appending a button would show it again
	if (m_IsPlayerCiri)
	{
		return;
	}
	if (theGame.GetEngineTimeAsSeconds() - thePlayer.potp_overlay_radial_hello > 5)
	{
		return;
	}

	panel = GetModuleFlash().GetChildFlashSprite("mcInputFeedback");
	if (!panel)
	{
		return;
	}
	append = panel.GetMemberFlashFunction("appendButton");
	if (!append)
	{
		return;
	}

	// Asked again each time the radial opens, as the language can change. The panel replaces a button with the same id.
	append.InvokeSelfFiveArgs(FlashArgInt(PotPOverlay_RadialButtonId()), FlashArgString(PotPOverlay_RadialPadButton()), FlashArgInt(PotPOverlay_RadialKeyboardKey()), FlashArgString(PotPOverlay_RadialLabel()), FlashArgBool(true));
}

@wrapMethod(CR4HudModuleRadialMenu)
function ShowRadialMenu()
{
	var was_shown : bool = m_shown;

	if (!was_shown)
	{
		DisableRadialMenuInput(false);
	}

	wrappedMethod();

	if (!was_shown && m_shown)
	{
		this.PotPOverlay_AddPrompt();
	}
}

//---------------------------------------------------
//-- Called by the overlay --------------------------
//---------------------------------------------------

function PotPOverlay_RadialHello() : int
{
	var player : CR4Player;

	if (!thePlayer)
	{
		return 0;
	}
	player = thePlayer;
	player.potp_overlay_radial_hello = theGame.GetEngineTimeAsSeconds();
	return 1;
}

function PotPOverlay_RadialIsOpen() : int
{
	var module : CR4HudModuleRadialMenu;

	if (!thePlayer || thePlayer.IsCiri())
	{
		return 0;
	}
	// A potion or oil picker opened from the radial is on top of it and has the input
	if (GetWitcherPlayer().GetRadialPopupShown())
	{
		return 0;
	}
	module = PotPOverlay_RadialModule();
	if (!module || !module.IsRadialMenuOpened())
	{
		return 0;
	}
	return 1;
}

// Closes it the way Escape does: nothing is equipped, whichever sign was under the pointer.
// Tab or L1 is still held at this point. Its release would count as choosing the highlighted slot if the
// radial's Flash were still listening, so its input is switched off first; ShowRadialMenu switches it back on.
function PotPOverlay_RadialTake() : int
{
	var module : CR4HudModuleRadialMenu;

	if (PotPOverlay_RadialIsOpen() == 0)
	{
		return 0;
	}
	module = PotPOverlay_RadialModule();
	module.DisableRadialMenuInput(true);
	module.HideRadialMenu();
	return 1;
}
