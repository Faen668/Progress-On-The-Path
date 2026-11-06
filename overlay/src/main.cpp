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

static DWORD WINAPI StartThread(void*);

std::wstring GameFolder()
{
	static const std::wstring found = []
	{
		const auto isGame = [](const std::wstring& at)
		{
			const DWORD content = GetFileAttributesW((at + L"\\content").c_str());
			const DWORD bin = GetFileAttributesW((at + L"\\bin").c_str());
			return content != INVALID_FILE_ATTRIBUTES && (content & FILE_ATTRIBUTE_DIRECTORY) && bin != INVALID_FILE_ATTRIBUTES && (bin & FILE_ATTRIBUTE_DIRECTORY);
		};
		// Up from a file until a folder holding both content and bin
		const auto upFrom = [&](const wchar_t* file) -> std::wstring
		{
			std::wstring at = file;
			for (size_t slash = at.find_last_of(L'\\'); slash != std::wstring::npos; slash = at.find_last_of(L'\\'))
			{
				at.resize(slash);
				if (isGame(at))
					return at;
			}
			return {};
		};
		wchar_t path[MAX_PATH] = L"";
		GetModuleFileNameW(nullptr, path, MAX_PATH);   // witcher3.exe, in bin\x64_dx12
		std::wstring folder = upFrom(path);
		if (folder.empty())
		{
			HMODULE self = nullptr;
			GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, reinterpret_cast<LPCWSTR>(&StartThread), &self);
			GetModuleFileNameW(self, path, MAX_PATH);
			folder = upFrom(path);
		}
		const std::string narrow(folder.begin(), folder.end());
		Log("the game's folder: %s", folder.empty() ? "not found" : narrow.c_str());
		return folder;
	}();
	return found;
}

std::wstring ModFolder()
{
	static const std::wstring found = []
	{
		const std::wstring mods = GameFolder() + L"\\mods\\";
		const auto isPotP = [&](const std::wstring& name)
		{
			return GetFileAttributesW((mods + name + L"\\achievements.dat").c_str()) != INVALID_FILE_ATTRIBUTES
				&& GetFileAttributesW((mods + name + L"\\fonts\\Cinzel.ttf").c_str()) != INVALID_FILE_ATTRIBUTES;
		};
		std::wstring name = isPotP(L"modProgressOnThePathNG") ? L"modProgressOnThePathNG" : L"";
		if (name.empty())
		{
			WIN32_FIND_DATAW item;
			const HANDLE find = FindFirstFileW((mods + L"*").c_str(), &item);
			if (find != INVALID_HANDLE_VALUE)
			{
				do
				{
					if ((item.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && item.cFileName[0] != L'.' && isPotP(item.cFileName))
					{
						name = item.cFileName;
						break;
					}
				} while (FindNextFileW(find, &item));
				FindClose(find);
			}
		}
		const std::string narrow(name.begin(), name.end());
		Log("PotP's mod folder: %s", name.empty() ? "not found" : narrow.c_str());
		return name.empty() ? std::wstring() : mods + name;
	}();
	return found;
}

static DWORD WINAPI StartThread(void*)
{
	Log("start thread running");
	LoadSettings();
	// The icons' tables, without holding anything else up
	CreateThread(nullptr, 0, [](void*) -> DWORD
	{
		wchar_t folder[MAX_PATH] = L"";
#ifdef POTP_OVERLAY_TEST
		if (GetEnvironmentVariableW(L"POTP_OVERLAY_GAME", folder, MAX_PATH) == 0)
#endif
			wcsncpy_s(folder, GameFolder().c_str(), _TRUNCATE);
		BuildGameIconIndex(folder);
		BuildCardArt(folder);
		BuildMapPins(folder);
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
