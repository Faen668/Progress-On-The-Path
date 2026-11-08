#pragma once
#include <windows.h>
#include <memory>
#include <mutex>
#include <string>
#include <string_view>
#include "model.h"

// main.cpp
// The game's own folder (the one with bin, content and mods), from witcher3.exe: the .asi can be loaded from
// bin\x64_dx12 or from a loader's plugins or scripts folder under it, so where it sits says nothing.
std::wstring GameFolder();
// A file built into the .asi (resources.h has their ids): its bytes, which live as long as the .asi. Empty if
// it isn't there.
std::string_view EmbeddedFile(int id);

// d3d12_hook.cpp
bool InstallD3D12Hooks();
// ImGui's input queue is filled on one thread and read on the one that presents. Recursive because
// ImGui's message handler calls SetCapture, and Windows answers with a message on the same thread.
std::recursive_mutex& ImGuiMutex();
// A picture from the game's files, on the graphics card for ImGui to draw. Called while drawing. False if it can't be.
bool UploadIconTexture(const struct GameTexture& source, unsigned long long& texture);
bool MakeIconView(struct ID3D12Resource* image, int dxgiFormat, unsigned long long& view);   // a slot for a picture made elsewhere
// Many textures at once, for a model. Preparing fills their upload memory and can be done on any thread. Submitting sends
// every copy in one go from the drawing thread, with no waiting; they can be drawn straight away. A view of 0: no slot left.
struct PreparedTexture;
std::shared_ptr<PreparedTexture> PrepareIconTexture(const struct GameTexture& source);
void SubmitIconTextures(const std::vector<std::shared_ptr<PreparedTexture>>& textures, std::vector<unsigned long long>& views);
// For what was drawn in frames still on the card: let go of once they're done, with no waiting
void RetireIconTexture(unsigned long long texture);
void RetireResource(struct ID3D12Resource* resource);
void ReleaseIconTexture(unsigned long long texture);   // waits for the card to finish with it: don't draw it this frame

// input_hook.cpp
void InstallInputHooks();
unsigned long InputWindowThread();   // the game window's thread, 0 before the hook is in: it has the player's keyboard layout
void AttachWindow(HWND window);   // subclass the window the swapchain presents to
bool MenuOpen();
void SetMenuOpen(bool open);

// ui.cpp
void UiLoadFonts(float scale);   // before the renderer starts
void DrawUi();                   // between ImGui::NewFrame and ImGui::Render
float UiWantedFontScale();       // what the fonts should be baked at for the panel's present size
bool UiBackOut();                // true when Esc only left a control, rather than closing the window
void UiSetMouseScale(float x, float y);   // window pixels to back buffer pixels
bool UiCaptureKey(unsigned vk);  // true when a settings row was waiting for a key and took this one
void UiPushPopup(const std::string& text);   // one of PotP's notifications, as its script sends them
bool UiWarningUp();              // a warning is on screen, and the game has to stay paused for it
void UiSetPopupHold(bool hold);  // the game's own notification is up, or there's nothing to show one over
void UiSetTracker(const std::string& text);   // the tracker panel's place and lines, as PotPOverlay_Tracker sends them, or "" for none
#ifdef POTP_OVERLAY_TEST
void UiTestStance(int stance);    // the off-screen test's way to a stance
void UiTestBook(int book);        // the off-screen test's way to a tab
void UiTestKillPage(int page);
void UiTestPlacement();          // the off-screen test's way into placing it
#endif
void UiOpenedByPad();            // the controller opened it: its prompts show from the start

// engine.cpp: everything that talks to the game's scripts. All safe to call from any thread.
void InstallEngineBridge();
struct BridgeState
{
	std::shared_ptr<const Model> model;   // the last complete list, null until there is one
	std::string message;                  // why there's nothing to show, when there isn't
	bool reading = false;                 // a newer list is on its way
};
BridgeState GetBridgeState();
void RequestRefresh();
void RequestPause(bool pause);
void RequestSetStatus(const std::string& uuid, int manual);   // manual: 0 automatic, 1 ignored, 2 completed, 3 missed
void RequestExec(const std::string& command, bool readAgain);   // runs a script exec function on the game's tick
void RequestMenuSound(const char* event);   // one of the game's own sound events, such as gui_global_highlight, on the game's tick
void RequestSettingsClosed();
void RequestAchievements();           // has the game's tick read them again
void RequestKills();                  // and the kill list
void RequestWardrobeItems();          // and every piece of armour
void RequestMenuOpen();               // closes the radial menu first if it's up, or its slot gets equipped
void RadialKeyDown(bool fromPad);     // the key that opens the window from the radial menu
void RadialKeyUp();
#ifdef POTP_OVERLAY_TEST
void PublishForTest(const char* const* chunks, int count);   // the off-screen test's stand-in for the script
#endif
