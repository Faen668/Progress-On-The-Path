// While the menu is open the game must not see input. It reads keyboard and mouse through raw
// input, the controller through XInput and the cursor directly, so those imports are redirected
// in witcher3.exe's import table; the controller is stopped at the game's input stream (engine.cpp). Raw input also carries the keys that open it and, when the game turns
// off the normal window messages (RIDEV_NOLEGACY), the mouse buttons for ImGui.
#include <windows.h>
#include <imgui.h>
#include <imgui_impl_win32.h>
#include <atomic>
#include "log.h"
#include "overlay.h"
#include "settings.h"

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND, UINT, WPARAM, LPARAM);

namespace
{
	std::atomic<bool> g_open{ false };
	std::atomic<bool> g_noLegacyMouse{ false };
	WNDPROC g_originalProc = nullptr;
	bool g_windowUnicode = false;
	DWORD g_windowThread = 0;
	RECT g_gameClip{};
	bool g_gameClipSet = false;

	using GetRawInputData_t = UINT(WINAPI*)(HRAWINPUT, UINT, LPVOID, PUINT, UINT);
	using RegisterRawInputDevices_t = BOOL(WINAPI*)(PCRAWINPUTDEVICE, UINT, UINT);
	using GetAsyncKeyState_t = SHORT(WINAPI*)(int);
	using SetCursorPos_t = BOOL(WINAPI*)(int, int);
	using ClipCursor_t = BOOL(WINAPI*)(const RECT*);

	GetRawInputData_t oGetRawInputData;
	RegisterRawInputDevices_t oRegisterRawInputDevices;
	GetAsyncKeyState_t oGetAsyncKeyState;
	SetCursorPos_t oSetCursorPos;
	ClipCursor_t oClipCursor;

	ULONGLONG g_lastKeyTime = 0;
	bool g_pausedByUs = false;

	// With Num Lock off, Numpad 5 arrives as Clear
	bool IsUpdateKey(unsigned vk)
	{
		const unsigned key = GetSettings().updateKey;
		return vk == key || (key == VK_NUMPAD5 && vk == VK_CLEAR);
	}

	void Toggle()
	{
		// The same press can arrive twice, as raw input and as a window message.
		const ULONGLONG now = GetTickCount64();
		if (now - g_lastKeyTime < 200)
			return;
		g_lastKeyTime = now;
		if (g_open)
			SetMenuOpen(false);
		else
			RequestMenuOpen();
	}

	void FeedImGuiMouse(const RAWMOUSE& mouse)
	{
		if (!g_noLegacyMouse || !ImGui::GetCurrentContext())
			return;
		std::lock_guard lock(ImGuiMutex());
		ImGuiIO& io = ImGui::GetIO();
		const USHORT b = mouse.usButtonFlags;
		if (b & RI_MOUSE_LEFT_BUTTON_DOWN) io.AddMouseButtonEvent(0, true);
		if (b & RI_MOUSE_LEFT_BUTTON_UP) io.AddMouseButtonEvent(0, false);
		if (b & RI_MOUSE_RIGHT_BUTTON_DOWN) io.AddMouseButtonEvent(1, true);
		if (b & RI_MOUSE_RIGHT_BUTTON_UP) io.AddMouseButtonEvent(1, false);
		if (b & RI_MOUSE_WHEEL) io.AddMouseWheelEvent(0.f, static_cast<float>(static_cast<SHORT>(mouse.usButtonData)) / WHEEL_DELTA);
	}

	UINT WINAPI hkGetRawInputData(HRAWINPUT h, UINT cmd, LPVOID data, PUINT size, UINT header)
	{
		const UINT result = oGetRawInputData(h, cmd, data, size, header);
		if (!data || cmd != RID_INPUT || result == static_cast<UINT>(-1))
			return result;

		auto* raw = static_cast<RAWINPUT*>(data);
		if (raw->header.dwType == RIM_TYPEKEYBOARD)
		{
			const RAWKEYBOARD& key = raw->data.keyboard;
			const bool down = !(key.Flags & RI_KEY_BREAK);
			// Watched, not taken: the game has no use for it in the radial menu
			static bool radialHeld = false;
			if (key.VKey == GetSettings().radialKey)
			{
				if (down && !g_open && !radialHeld)
					RadialKeyDown(false);
				else if (!down && radialHeld)
					RadialKeyUp();
				radialHeld = down;
			}
			if (down && UiCaptureKey(key.VKey))
			{
				g_lastKeyTime = GetTickCount64();   // the same press also arrives as a window message
				raw->header.dwType = 0xFF;
			}
			else if (down && key.VKey == GetSettings().openKey)
			{
				Toggle();
				raw->header.dwType = 0xFF;
			}
			else if (!g_open && IsUpdateKey(key.VKey))
			{
				// Taken as the open key is. The script allows one update every 5 seconds, and a press can also arrive as a window message
				static bool updateHeld = false;
				if (down && !updateHeld)
					RequestExec("potpoverlay_updatekey()", false);
				updateHeld = down;
				if (down)
					raw->header.dwType = 0xFF;
			}
			else if (g_open && down)
			{
				if (key.VKey == VK_ESCAPE && !UiBackOut())
					SetMenuOpen(false);
				raw->header.dwType = 0xFF;   // a type the game doesn't know, so it reads nothing
			}
			// Releases still go through, or a key held when the menu opened would stay stuck down.
		}
		else if (raw->header.dwType == RIM_TYPEMOUSE && g_open)
		{
			RAWMOUSE& mouse = raw->data.mouse;
			FeedImGuiMouse(mouse);
			mouse.lLastX = 0;
			mouse.lLastY = 0;
			mouse.usButtonFlags &= RI_MOUSE_LEFT_BUTTON_UP | RI_MOUSE_RIGHT_BUTTON_UP | RI_MOUSE_MIDDLE_BUTTON_UP | RI_MOUSE_BUTTON_4_UP | RI_MOUSE_BUTTON_5_UP;
		}
		return result;
	}

	BOOL WINAPI hkRegisterRawInputDevices(PCRAWINPUTDEVICE devices, UINT count, UINT size)
	{
		for (UINT i = 0; i < count; ++i)
		{
			Log("raw input device: page 0x%x usage 0x%x flags 0x%x target %p", devices[i].usUsagePage, devices[i].usUsage, devices[i].dwFlags, devices[i].hwndTarget);
			if (devices[i].usUsagePage == 1 && devices[i].usUsage == 2)
				g_noLegacyMouse = (devices[i].dwFlags & RIDEV_NOLEGACY) != 0;
		}
		return oRegisterRawInputDevices(devices, count, size);
	}

	SHORT WINAPI hkGetAsyncKeyState(int key)
	{
		return g_open ? 0 : oGetAsyncKeyState(key);
	}

	BOOL WINAPI hkSetCursorPos(int x, int y)
	{
		return g_open ? TRUE : oSetCursorPos(x, y);
	}

	BOOL WINAPI hkClipCursor(const RECT* rect)
	{
		g_gameClipSet = rect != nullptr;
		if (rect)
			g_gameClip = *rect;
		return g_open ? TRUE : oClipCursor(rect);
	}

	LRESULT CALLBACK WndProc(HWND window, UINT msg, WPARAM w, LPARAM l)
	{
		if (msg == WM_KEYDOWN && !(l & (1 << 30)))
		{
			if (UiCaptureKey(static_cast<unsigned>(w)))
			{
				g_lastKeyTime = GetTickCount64();
				return 0;
			}
			if (w == GetSettings().openKey)
			{
				Toggle();
				return 0;
			}
			if (!g_open && IsUpdateKey(static_cast<unsigned>(w)))
			{
				RequestExec("potpoverlay_updatekey()", false);
				return 0;
			}
		}
		if (g_open)
		{
			if (ImGui::GetCurrentContext())
			{
				std::lock_guard lock(ImGuiMutex());
				ImGui_ImplWin32_WndProcHandler(window, msg, w, l);
			}
			switch (msg)
			{
			// WM_INPUT carries on to the game: hkGetRawInputData has already emptied it.
			case WM_MOUSEMOVE: case WM_LBUTTONDOWN: case WM_LBUTTONUP: case WM_LBUTTONDBLCLK:
			case WM_RBUTTONDOWN: case WM_RBUTTONUP: case WM_RBUTTONDBLCLK:
			case WM_MBUTTONDOWN: case WM_MBUTTONUP: case WM_MBUTTONDBLCLK:
			case WM_MOUSEWHEEL: case WM_MOUSEHWHEEL: case WM_XBUTTONDOWN: case WM_XBUTTONUP:
			case WM_KEYDOWN: case WM_SYSKEYDOWN: case WM_CHAR:
				return 0;
			default:
				break;
			}
		}
		return g_windowUnicode ? CallWindowProcW(g_originalProc, window, msg, w, l) : CallWindowProcA(g_originalProc, window, msg, w, l);
	}

	// Redirects one import of the main exe.
	template <class T>
	bool PatchImport(const char* dll, const char* name, T hook, T& original)
	{
		auto* base = reinterpret_cast<BYTE*>(GetModuleHandleW(nullptr));
		auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
		auto* nt = reinterpret_cast<IMAGE_NT_HEADERS*>(base + dos->e_lfanew);
		const auto& dir = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
		if (!dir.VirtualAddress)
			return false;
		for (auto* imp = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(base + dir.VirtualAddress); imp->Name; ++imp)
		{
			if (_stricmp(reinterpret_cast<char*>(base + imp->Name), dll) != 0 || !imp->OriginalFirstThunk)
				continue;
			auto* names = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imp->OriginalFirstThunk);
			auto* slots = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imp->FirstThunk);
			for (; names->u1.AddressOfData; ++names, ++slots)
			{
				if (IMAGE_SNAP_BY_ORDINAL(names->u1.Ordinal))
					continue;
				auto* byName = reinterpret_cast<IMAGE_IMPORT_BY_NAME*>(base + names->u1.AddressOfData);
				if (strcmp(byName->Name, name) != 0)
					continue;
				DWORD old;
				VirtualProtect(&slots->u1.Function, sizeof(void*), PAGE_READWRITE, &old);
				original = reinterpret_cast<T>(slots->u1.Function);
				slots->u1.Function = reinterpret_cast<ULONG_PTR>(hook);
				VirtualProtect(&slots->u1.Function, sizeof(void*), old, &old);
				return true;
			}
		}
		return false;
	}
}

unsigned long InputWindowThread()
{
	return g_windowThread;
}

void InstallInputHooks()
{
	const bool a = PatchImport("USER32.dll", "GetRawInputData", hkGetRawInputData, oGetRawInputData);
	const bool b = PatchImport("USER32.dll", "RegisterRawInputDevices", hkRegisterRawInputDevices, oRegisterRawInputDevices);
	const bool d = PatchImport("USER32.dll", "GetAsyncKeyState", hkGetAsyncKeyState, oGetAsyncKeyState);
	const bool e = PatchImport("USER32.dll", "SetCursorPos", hkSetCursorPos, oSetCursorPos);
	const bool f = PatchImport("USER32.dll", "ClipCursor", hkClipCursor, oClipCursor);
	Log("input imports: raw %d register %d asynckey %d setcursor %d clip %d", a, b, d, e, f);
}

void AttachWindow(HWND window)
{
	if (g_originalProc)
		return;
	// The window keeps its own kind (the game makes an ANSI one): the wrong kind would change its text messages.
	g_windowUnicode = IsWindowUnicode(window) != FALSE;
	g_windowThread = GetWindowThreadProcessId(window, nullptr);
	const auto proc = reinterpret_cast<LONG_PTR>(WndProc);
	g_originalProc = reinterpret_cast<WNDPROC>(g_windowUnicode ? SetWindowLongPtrW(window, GWLP_WNDPROC, proc) : SetWindowLongPtrA(window, GWLP_WNDPROC, proc));
	Log("window %p subclassed, unicode %d", window, g_windowUnicode);
}

bool MenuOpen()
{
	return g_open;
}

void SetMenuOpen(bool open)
{
	if (g_open == open)
		return;
	g_open = open;
	Log("menu %s", open ? "opened" : "closed");
	if (oClipCursor)
		oClipCursor(open || !g_gameClipSet ? nullptr : &g_gameClip);
	if (open && GetSettings().pauseGame)
	{
		RequestPause(true);
		g_pausedByUs = true;
	}
	else if (!open && g_pausedByUs)
	{
		RequestPause(false);
		g_pausedByUs = false;
	}
	if (open)
		RequestRefresh();
	else
		SaveSettings();
}
