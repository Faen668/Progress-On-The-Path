
function SU_getStorage(): SU_Storage {
	SUST_Logger("SU_getStorage()");

	return SU_getStorageFromInput(thePlayer.GetInputHandler());
}

function SU_getStorageFromInput(player_input: CPlayerInput): SU_Storage {
	SUST_Logger("SU_getStorageFromInput()");

	if (!player_input.SU_storage) {
		SUST_Logger("SU_getStorageFromInput(), no storage, instantiating");

		player_input.SU_storage = new SU_Storage in player_input;
	}

	return player_input.SU_storage;
}

function SUST_Logger(message: string, optional informGUI: bool) {
	LogChannel('SUST', message);
	
	if (informGUI) {
		theGame.GetGuiManager().ShowNotification("SUST: " + message, 5, true);
	}
}
