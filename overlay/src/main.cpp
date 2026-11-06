// An ImGui menu inside The Witcher 3, loaded by Ultimate ASI Loader as PotpOverlay.asi.
#include <windows.h>
#include "achievements.h"
#include "customach.h"
#include "log.h"
#include "cardart.h"
#include "gameicons.h"
#include "itemmodel.h"
#include "overlay.h"
#include "kills.h"
#include "pad.h"
#include "settings.h"

#ifdef POTP_OVERLAY_TEST
// For the off-screen test program, which has no keyboard focus to press Home with.
extern "C" void PotpOverlay_TestSetMenuOpen(int open)
{
	SetMenuOpen(open != 0);
}

extern "C" void PotpOverlay_TestPublish(const char* const* chunks, int count)
{
	PublishForTest(chunks, count);
}

extern "C" void PotpOverlay_TestPad(int buttons, int leftX, int leftY, int rightY)
{
	PadInjectForTest(buttons, leftX, leftY, rightY);
}

void UiTestCardTurn(float degrees);
void UiTestModel(const char* path);

extern "C" void PotpOverlay_TestModel(const char* path)
{
	UiTestModel(path);
}

extern "C" void PotpOverlay_TestCardTurn(float degrees)
{
	UiTestCardTurn(degrees);
}

extern "C" void PotpOverlay_TestPopup(const char* text)
{
	UiPushPopup(text);
}

extern "C" void PotpOverlay_TestStance(int stance)
{
	UiTestStance(stance);
}

extern "C" void PotpOverlay_TestBook(int book)
{
	UiTestBook(book);
}

extern "C" void PotpOverlay_TestPlacement()
{
	UiTestPlacement();
}

extern "C" void PotpOverlay_TestAchievements(const char* text)
{
	AchievementsTestAnswer(text);
}

extern "C" void PotpOverlay_TestKills(const char* text)
{
	KillsTick(text, true);
}

extern "C" void PotpOverlay_TestKillPage(int page)
{
	UiTestKillPage(page);
}
#endif

static DWORD WINAPI StartThread(void*)
{
	Log("start thread running");
	LoadSettings();
	// The icons' tables, without holding anything else up. bin\\x64_dx12\\this.asi -> the game's folder.
	CreateThread(nullptr, 0, [](void*) -> DWORD
	{
		wchar_t folder[MAX_PATH] = L"";
#ifdef POTP_OVERLAY_TEST
		if (GetEnvironmentVariableW(L"POTP_OVERLAY_GAME", folder, MAX_PATH) == 0)
#endif
		{
			HMODULE self = nullptr;
			GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, reinterpret_cast<LPCWSTR>(&StartThread), &self);
			GetModuleFileNameW(self, folder, MAX_PATH);
			for (int up = 0; up < 3; ++up)
				if (wchar_t* slash = wcsrchr(folder, L'\\'))
					*slash = 0;
		}
		BuildGameIconIndex(folder);
		BuildCardArt(folder);
		LoadAchievementPack(folder);
		LoadCustomAchievementPacks(folder);
		BuildModelIndex(folder);
		return 0;
	}, nullptr, 0, nullptr);
	InstallInputHooks();
	InstallEngineBridge();
	if (!InstallD3D12Hooks())
		Log("D3D12 hooks FAILED: no overlay this session");
	return 0;
}

BOOL WINAPI DllMain(HINSTANCE module, DWORD reason, LPVOID)
{
	if (reason == DLL_PROCESS_ATTACH)
	{
		DisableThreadLibraryCalls(module);
		LogInit(module);
		Log("loaded");
		// Nothing heavy under the loader lock: the thread starts once that lock is released.
		if (HANDLE thread = CreateThread(nullptr, 0, StartThread, nullptr, 0, nullptr))
			CloseHandle(thread);
	}
	return TRUE;
}
