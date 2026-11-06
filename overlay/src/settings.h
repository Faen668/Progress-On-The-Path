#pragma once
#include <string>
#include <utility>
#include <vector>

enum PromptMode { kPromptsAuto = 0, kPromptsKeyboard = 1, kPromptsController = 2 };
enum PadStyle { kPadAuto = 0, kPadXbox = 1, kPadPlayStation = 2, kPadSwitch = 3, kPadSteamDeck = 4 };

// Kept in potp_overlay.ini beside the DLL
struct Settings
{
	float scale = 1.f;             // 0.5 to 2: everything in the panel
	float widthPercent = 98.f;     // of the screen, 40 to 100
	float heightPercent = 90.f;
	float opacity = 0.9f;          // the panel's ground, 0.5 to 1
	float dim = 0.7f;              // the game behind it, 0 to 0.9
	float posX = 0.f, posY = 0.f;  // dragged this far from the centre, as parts of the screen
	bool pauseGame = false;
	bool openOnLastBook = true;
	bool clothSim = true;         // cloth on the models moves
	bool autoRotate = false;      // models in the Bestiary and Items turn slowly by themselves
	bool liveBestiary = true;     // the Bestiary shows each creature's model in an idle, not its painting
	bool tourOffered = false;     // the guided tour has been offered once
	bool hideCompleted = false;
	bool hideIgnored = false;
	bool hideMissable = false;
	bool revealUndiscovered = false;   // show bestiary entries before they're in the game's bestiary
	bool revealHiddenAchievements = false;   // show the stores' secret ones before they're unlocked
	unsigned openKey = 0x72;       // F3
	unsigned updateKey = 0x65;     // Numpad 5: runs a full update
	float popupX = 0.f, popupY = 1.f;   // where the notification sits, 0 to 1 across the room there is: bottom left, as the game's
	int radialKey = 0x50;   // the key that opens the window from the radial menu: P
	int lastBook = 0;
	int promptMode = kPromptsAuto;
	int padStyle = kPadAuto;       // Automatic follows the controller the game says is in use
	std::string wardrobePins;      // the wardrobe's pinned pieces: category~template~title, split by |
	std::string wardrobeOutfits;   // saved outfits: name^kind~template~title^kind~template~title, split by |
	int wardrobeAnimation = 0;
	bool wardrobeShowUntracked = true;   // the wardrobe lists armour the mod doesn't track as well
	bool hdrMatchGame = true;     // with HDR on, white is the game's Paper White
	float hdrBrightness = 200.f;  // nits, when not matching the game
};

Settings& GetSettings();
void LoadSettings();
void SaveSettings();

// The mod's own settings (Settings.ws defines them), kept in potp_overlay.ini's [ModSettings] as id=value.
// The first time, the values the game kept for the old settings menu in dx12user.settings.
std::vector<std::pair<std::string, std::string>> LoadModSettings();
void SaveModSettings(const std::string& lines);   // id=value lines, as PotP_SettingsValues gives them

// The game's own HDR Paper White and the TV's peak, in nits, from dx12user.settings (read again when it changes).
// False if it can't be read.
bool GameHdrLevels(float& paperWhite, float& peak);
