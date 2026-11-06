#include <windows.h>
#include <xinput.h>
#include <atomic>
#include <cmath>
#include <initializer_list>
#include "log.h"
#include "pad.h"
#include "settings.h"

namespace
{
	using XInputGetState_t = DWORD(WINAPI*)(DWORD, XINPUT_STATE*);
	XInputGetState_t g_getState;
	bool g_tried = false;
	PadState g_state;
	int g_user = 0;
	ULONGLONG g_nextScan = 0;
#ifdef POTP_OVERLAY_TEST
	bool g_injected = false;
	unsigned g_injectedButtons = 0;
#endif

	// The game's stream arrives on its tick and is read on the thread that presents. A press that's
	// over between two frames is still seen, through the latch.
	std::atomic<bool> g_streamOn{ false };
	std::atomic<unsigned> g_streamHeld{ 0 }, g_streamLatch{ 0 };
	std::atomic<float> g_streamLX{ 0.f }, g_streamLY{ 0.f }, g_streamRX{ 0.f }, g_streamRY{ 0.f };
	std::atomic<int> g_detectedStyle{ kPadXbox };
	std::atomic<bool> g_streamSeen{ false };

	unsigned ButtonFor(int key)
	{
		switch (key)
		{
		case 0x88: return kPadA;
		case 0x89: return kPadB;
		case 0x8A: return kPadX;
		case 0x8B: return kPadY;
		case 0x8C: return kPadStart;
		case 0x8D: return kPadBack;
		case 0x8E: return kPadUp;
		case 0x8F: return kPadDown;
		case 0x90: return kPadLeft;
		case 0x91: return kPadRight;
		case 0x92: return kPadL3;
		case 0x93: return kPadR3;
		case 0x94: return kPadLB;
		case 0x95: return kPadRB;
		case 0xFF: return kPadStart;   // Options on a PlayStation pad
		case 0x100: return kPadBack;   // its touchpad: the game maps nothing to Create
		default: return 0;
		}
	}

	float Stick(int value)
	{
		const float v = static_cast<float>(value) / 32767.f;
		const float deadzone = 0.24f;
		if (std::fabs(v) < deadzone)
			return 0.f;
		return (v > 0 ? v - deadzone : v + deadzone) / (1.f - deadzone);
	}
}

const PadState& PadPoll()
{
	g_state.previous = g_state.buttons;
#ifdef POTP_OVERLAY_TEST
	if (g_injected)
	{
		g_state.buttons = g_injectedButtons;
		return g_state;
	}
#endif

	if (g_streamOn)
	{
		g_state.connected = g_streamSeen;
		g_state.buttons = g_streamHeld | g_streamLatch.exchange(0);
		g_state.leftX = g_streamLX;
		g_state.leftY = g_streamLY;
		g_state.rightX = g_streamRX;
		g_state.rightY = g_streamRY;
		return g_state;
	}

	if (!g_tried)
	{
		g_tried = true;
		// Our own copy: the import in witcher3.exe is the one that gets emptied while the window is open
		for (const wchar_t* name : { L"xinput1_4.dll", L"xinput1_3.dll", L"xinput9_1_0.dll" })
		{
			if (HMODULE dll = LoadLibraryW(name))
			{
				g_getState = reinterpret_cast<XInputGetState_t>(GetProcAddress(dll, "XInputGetState"));
				if (g_getState)
					break;
			}
		}
		Log("controller reading: %s", g_getState ? "available" : "no XInput found");
	}
	if (!g_getState)
		return g_state;

	// An empty slot is slow to ask, so only look for a controller now and then
	XINPUT_STATE s{};
	bool ok = false;
	if (g_state.connected)
	{
		ok = g_getState(g_user, &s) == ERROR_SUCCESS;
	}
	else if (GetTickCount64() >= g_nextScan)
	{
		g_nextScan = GetTickCount64() + 2000;
		for (int user = 0; user < 4 && !ok; ++user)
			if (g_getState(user, &s) == ERROR_SUCCESS)
			{
				ok = true;
				g_user = user;
				Log("controller found in slot %d", user);
			}
	}

	if (!ok)
	{
		if (g_state.connected)
			Log("controller gone");
		g_state.connected = false;
		g_state.buttons = 0;
		g_state.leftX = g_state.leftY = g_state.rightX = g_state.rightY = 0.f;
		return g_state;
	}

	g_state.connected = true;
	g_state.buttons = s.Gamepad.wButtons;
	if (s.Gamepad.bLeftTrigger > 100)
		g_state.buttons |= kPadLT;
	if (s.Gamepad.bRightTrigger > 100)
		g_state.buttons |= kPadRT;
	g_state.leftX = Stick(s.Gamepad.sThumbLX);
	g_state.leftY = Stick(s.Gamepad.sThumbLY);
	g_state.rightX = Stick(s.Gamepad.sThumbRX);
	g_state.rightY = Stick(s.Gamepad.sThumbRY);
	return g_state;
}

#ifdef POTP_OVERLAY_TEST
void PadInjectForTest(int buttons, int leftX, int leftY, int rightY)
{
	g_injected = true;
	g_state.connected = true;
	g_injectedButtons = static_cast<unsigned>(buttons);
	g_state.leftX = Stick(leftX);
	g_state.leftY = Stick(leftY);
	g_state.rightY = Stick(rightY);
}
#endif

void PadStreamEnable()
{
	g_streamOn = true;
}

bool PadStreamEvent(int key, int action, float data)
{
	constexpr int kPress = 1, kRelease = 2, kAxis = 3;
	if (!((key >= 0x88 && key <= 0x9B) || key == 0xFF || key == 0x100))
		return false;
	if (!g_streamSeen.exchange(true))
		Log("controller seen in the game's input stream");

	if (action == kAxis)
	{
		switch (key)
		{
		case 0x96:   // the triggers only ever arrive as a value
		case 0x97:
		{
			const unsigned bit = key == 0x96 ? kPadLT : kPadRT;
			if (data > 0.4f)
			{
				g_streamHeld |= bit;
				g_streamLatch |= bit;
			}
			else
			{
				g_streamHeld &= ~bit;
			}
			break;
		}
		case 0x98: g_streamLX = data; break;
		case 0x99: g_streamLY = data; break;
		case 0x9A: g_streamRX = data; break;
		case 0x9B: g_streamRY = data; break;
		default: break;
		}
		return false;
	}

	const unsigned bit = ButtonFor(key);
	if (action == kPress)
	{
		g_streamHeld |= bit;
		g_streamLatch |= bit;
	}
	else if (action == kRelease)
	{
		g_streamHeld &= ~bit;
	}
	return false;
}

void PadStreamStyle(int padStyle)
{
	if (g_detectedStyle.exchange(padStyle) != padStyle)
		Log("controller type from the game: %s", padStyle == kPadPlayStation ? "PlayStation" : "Xbox");
}

int PadDetectedStyle()
{
	return g_detectedStyle;
}
