// Calls WitcherScript from the DLL. Addresses and layouts were worked out from witcher3.exe itself.
// They hold for one exact build, so the PE timestamp and the hooked bytes are checked first: on any
// other build the bridge stays off and the rest of the overlay carries on.
#include <windows.h>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <mutex>
#include <vector>
#include "achievements.h"
#include "customach.h"
#include "itemmodel.h"
#include "kills.h"
#include "log.h"
#include "overlay.h"
#include "scan.h"
#include "pad.h"
#include "settings.h"
#include "text.h"

namespace
{
	// CInputDeviceManagerWin32
	constexpr size_t kManagerLastDevice = 0x49C;   // a CName: which device last sent anything
	constexpr size_t kManagerResetRequest = 0x4A0; // set, and each device lets go of what's held on the next Update

	constexpr size_t kScriptingReady = 0x174;
	constexpr size_t kFunctionFlags = 0x18;
	constexpr size_t kFunctionCodeSize = 0x90;
	constexpr uint32_t kFuncNative = 0x1;
	constexpr uint32_t kFuncLatent = 0x40;

	// Whole instructions, none of them RIP-relative: a 14-byte jump plus a NOP replaces them.
	constexpr size_t kHookLength = 15;
	const uint8_t kExpectedPrologue[kHookLength] = { 0x48, 0x89, 0x5C, 0x24, 0x08, 0x48, 0x89, 0x6C, 0x24, 0x10, 0x48, 0x89, 0x74, 0x24, 0x18 };

#pragma pack(push, 4)
	struct EngineString
	{
		char* data;
		uint32_t size;   // counts the terminating NUL
	};
#pragma pack(pop)
	static_assert(sizeof(EngineString) == 12);

	using GetRTTI_t = void*(__fastcall*)();
	using GetNames_t = void*(__fastcall*)();
	using AddName_t = uint32_t(__fastcall*)(void*, const char*);
	using FindGlobalFunction_t = void*(__fastcall*)(void*, const uint32_t*);
	using CallDirect_t = bool(__fastcall*)(void*, void*, void*, void*);
	using CallGlobalExec_t = bool(__fastcall*)(void*, const EngineString*);
	using Free_t = void(__fastcall*)(void*);
	using ScriptTick_t = void(__fastcall*)(void*, float);

	struct InputEvent   // stride 0x14
	{
		int32_t key;
		int32_t action;   // 1 press, 2 release, 3 axis
		float data;
		int32_t x, y;
	};
	static_assert(sizeof(InputEvent) == 0x14);
#pragma pack(push, 4)
	struct InputEvents
	{
		InputEvent* data;
		uint32_t size;
	};
#pragma pack(pop)
	using InputUpdate_t = void(__fastcall*)(void*, InputEvents*);
	InputUpdate_t oInputUpdate;
	const uint32_t* g_namePs4Pad;
	const uint32_t* g_namePs5Pad;
	const uint32_t* g_nameXPad;

	GetRTTI_t GetRTTI;
	GetNames_t GetNames;
	AddName_t AddName;
	FindGlobalFunction_t FindGlobalFunction;
	CallDirect_t CallDirect;
	CallGlobalExec_t CallGlobalExec;
	Free_t EngineFree;
	ScriptTick_t oScriptTick;
	void** g_scriptingPtr;

	std::atomic<bool> g_bridgeOk{ false };
	std::atomic<bool> g_wantRefresh{ false };
	std::atomic<bool> g_wantAchievements{ false };
	std::atomic<bool> g_wantKills{ false };
	std::atomic<bool> g_wantWardrobeItems{ false };
	std::atomic<int> g_wantPause{ -1 };   // -1 nothing, 0 unpause, 1 pause
	std::atomic<bool> g_crashed{ false };
	std::atomic<unsigned long long> g_ticks{ 0 };

	std::mutex g_stateMutex;
	std::shared_ptr<const Model> g_model;
	std::string g_message = Tx(T_waiting_for_game);
	struct PendingExec { std::string command; bool readAgain; };
	std::vector<PendingExec> g_pendingExec;
	std::vector<std::string> g_pendingSounds;   // the sound events still to play, under the same lock
	std::atomic<bool> g_wantSettingsClosed{ false };
	std::atomic<bool> g_wantOpen{ false };
	std::atomic<bool> g_openFromPad{ false };
	std::atomic<int> g_radialKeyEvents{ 0 };   // 1 went down, 2 came up
	constexpr int kPadYKey = 0x8B;             // Y or triangle in the game's input stream
	bool g_reading = false;

	// Only touched on the game's tick
	std::unique_ptr<Model> g_building;
	LARGE_INTEGER g_readStart;
	double g_readScriptMs = 0;
	int g_readCalls = 0;

	void SetMessage(const std::string& text)
	{
		std::lock_guard lock(g_stateMutex);
		g_message = text;
	}

	void* FindScriptFunction(const char* name)
	{
		// Looked up each time: a script recompile can replace the functions.
		const uint32_t id = AddName(GetNames(), name);
		void* fn = id ? FindGlobalFunction(GetRTTI(), &id) : nullptr;
		if (!fn)
			return nullptr;
		const auto* bytes = static_cast<const uint8_t*>(fn);
		const uint32_t flags = *reinterpret_cast<const uint32_t*>(bytes + kFunctionFlags);
		const uint32_t codeSize = *reinterpret_cast<const uint32_t*>(bytes + kFunctionCodeSize);
		if ((flags & (kFuncNative | kFuncLatent)) || codeSize == 0)
		{
			Log("%s can't be called: flags 0x%x code size %u", name, flags, codeSize);
			return nullptr;
		}
		return fn;
	}

	// No C++ objects with destructors in here, so __try can be used.
	bool GuardedCall(void* fn, void* result)
	{
		__try
		{
			return CallDirect(fn, nullptr, nullptr, result);
		}
		__except (EXCEPTION_EXECUTE_HANDLER)
		{
			Log("script call crashed: exception 0x%08lx. Bridge switched off.", GetExceptionCode());
			g_crashed = true;
			return false;
		}
	}

	bool GuardedExec(const EngineString* command)
	{
		__try
		{
			return CallGlobalExec(nullptr, command);
		}
		__except (EXCEPTION_EXECUTE_HANDLER)
		{
			Log("exec call crashed: exception 0x%08lx. Bridge switched off.", GetExceptionCode());
			g_crashed = true;
			return false;
		}
	}

	bool CallVoid(const char* name)
	{
		void* fn = FindScriptFunction(name);
		if (!fn)
			return false;
		const bool ok = GuardedCall(fn, nullptr);
		Log("called %s: %d", name, ok);
		return ok;
	}

	int CallInt(const char* name)
	{
		void* fn = FindScriptFunction(name);
		if (!fn)
			return 0;
		int32_t value = 0;
		return GuardedCall(fn, &value) ? value : 0;
	}

	void OpenWindow()
	{
		if (g_openFromPad.exchange(false))
			UiOpenedByPad();
		SetMenuOpen(true);
	}

	// Handing over from the radial menu. Tab or L1 is still held, and opening the window lets go of whatever's
	// held, which would equip the highlighted slot. So the script closes the menu first, and the window opens
	// once the HUD has heard. The script says itself whether the menu can hand over.
	void RadialTick()
	{
		static ULONGLONG nextHello = 0;
		static bool armed = false;
		static int openAfterTicks = 0;

		const ULONGLONG now = GetTickCount64();
		if (now >= nextHello)
		{
			nextHello = now + 1000;
			CallInt("PotPOverlay_RadialHello");   // the prompt only shows while this DLL is here
		}

		// Down before up, so a tap inside one tick still counts. Only a press made inside the radial menu does.
		const int keys = g_radialKeyEvents.exchange(0);
		if (keys & 1)
			armed = !MenuOpen() && CallInt("PotPOverlay_RadialIsOpen") == 1;
		if ((keys & 2) && armed)
		{
			armed = false;
			if (CallInt("PotPOverlay_RadialTake") == 1)
				openAfterTicks = 2;
		}

		if (g_wantOpen.exchange(false) && !MenuOpen())
		{
			if (CallInt("PotPOverlay_RadialTake") == 1)
				openAfterTicks = 2;
			else
				OpenWindow();
		}

		if (openAfterTicks > 0 && --openAfterTicks == 0)
			OpenWindow();
	}

	bool CallString(const char* name, std::string& out)
	{
		void* fn = FindScriptFunction(name);
		if (!fn)
			return false;
		EngineString text{};
		LARGE_INTEGER a, b, f;
		QueryPerformanceCounter(&a);
		const bool ok = GuardedCall(fn, &text);
		QueryPerformanceCounter(&b);
		QueryPerformanceFrequency(&f);
		g_readScriptMs += static_cast<double>(b.QuadPart - a.QuadPart) * 1000.0 / static_cast<double>(f.QuadPart);
		++g_readCalls;
		if (g_crashed)
			return false;
		out.clear();
		if (text.data && text.size > 1)
			out.assign(text.data, text.size - 1);
		if (text.data)
			EngineFree(text.data);
		return ok;
	}

	void FinishReading(std::string message)
	{
		std::lock_guard lock(g_stateMutex);
		g_reading = false;
		g_message = std::move(message);
	}

	void BeginReading()
	{
		g_readScriptMs = 0;
		g_readCalls = 0;
		QueryPerformanceCounter(&g_readStart);
		std::string text;
		if (!CallString("PotPOverlay_ExportBegin", text))
		{
			FinishReading(g_crashed ? Tx(T_script_failed) : Tx(T_no_scripts));
			return;
		}
		auto model = std::make_unique<Model>();
		if (!ParseChunk(*model, text))
		{
			{
				// Nothing to show: no save loaded, say. Forget any old list, it may be another save's.
				std::lock_guard lock(g_stateMutex);
				g_model.reset();
			}
			FinishReading(model->message);
			return;
		}
		g_building = std::move(model);
		std::lock_guard lock(g_stateMutex);
		g_reading = true;
	}

	void ReadNextSection()
	{
		std::string text;
		if (!CallString("PotPOverlay_ExportNext", text))
		{
			g_building.reset();
			FinishReading(g_crashed ? Tx(T_script_failed) : Tx(T_reading_stopped));
			return;
		}
		if (!text.empty())
		{
			ParseChunk(*g_building, text);
			return;
		}

		LARGE_INTEGER end, frequency;
		QueryPerformanceCounter(&end);
		QueryPerformanceFrequency(&frequency);
		size_t entries = 0;
		for (const Section& s : g_building->sections)
			entries += s.entries.size();
		Log("read %zu sections, %zu entries in %d calls: %.1f ms in script, %.0f ms start to finish", g_building->sections.size(), entries, g_readCalls, g_readScriptMs,
			static_cast<double>(end.QuadPart - g_readStart.QuadPart) * 1000.0 / static_cast<double>(frequency.QuadPart));

		std::shared_ptr<const Model> done(g_building.release());
		std::lock_guard lock(g_stateMutex);
		g_model = std::move(done);
		g_reading = false;
		g_message.clear();
	}

	void RunExec(std::string line, bool quiet = false)
	{
		// Unquoted: the console's parser takes the text between the brackets as the arguments
		EngineString command{ line.data(), static_cast<uint32_t>(line.size() + 1) };
		const bool ok = GuardedExec(&command);
		if (!quiet || !ok)
			Log("%s: %d", line.c_str(), ok);
	}

	// The window's menu sounds, played by the scripts as the game's menus play theirs. Scripts from before
	// potpoverlay_sound can't: the first that fails turns them off for the rest of the session.
	void SoundTick()
	{
		static bool works = true;
		std::vector<std::string> sounds;
		{
			std::lock_guard lock(g_stateMutex);
			sounds.swap(g_pendingSounds);
		}
		for (const std::string& event : sounds)
		{
			if (!works)
				break;
			std::string line = "potpoverlay_sound(" + event + ")";
			EngineString command{ line.data(), static_cast<uint32_t>(line.size() + 1) };
			if (!GuardedExec(&command))
			{
				works = false;
				Log("menu sounds: the scripts have no potpoverlay_sound, so the window is silent");
			}
		}
	}

	// PotP's notifications, a few times a second, and whether they have to wait
	void NotificationTick()
	{
		static ULONGLONG next = 0;
		const ULONGLONG now = GetTickCount64();
		if (now < next)
			return;
		next = now + 250;
		UiSetPopupHold(CallInt("PotPOverlay_PopupHold") == 1);
		std::string message;
		if (CallString("PotPOverlay_NextMessage", message) && !message.empty())
			UiPushPopup(message);
	}

	// Where the HUD's quest list ends and the tracker panel's lines, ten times a second while the window's shut.
	// Scripts from before the panel have no PotPOverlay_Tracker, and so no panel.
	void TrackerTick()
	{
		static ULONGLONG next = 0;
		const ULONGLONG now = GetTickCount64();
		if (now < next)
			return;
		next = now + 100;
		std::string text;
		if (MenuOpen() || !CallString("PotPOverlay_Tracker", text))
			text.clear();
		UiSetTracker(text);
	}

	// The window can open before there's anything to show, as a save is loading or the mod is still building its
	// list. That work runs on game time, so the game stays unpaused until the list exists, and it's asked for again
	// until then, so the window fills in by itself.
	void WaitingTick()
	{
		static bool pauseWanted = false, paused = false;
		static ULONGLONG nextAsk = 0;

		const int want = g_wantPause.exchange(-1);
		if (want >= 0)
			pauseWanted = want == 1;

		bool hasList, reading;
		{
			std::lock_guard lock(g_stateMutex);
			hasList = g_model != nullptr;
			reading = g_reading;
		}
		const bool shouldPause = (pauseWanted && hasList) || UiWarningUp();
		if (shouldPause != paused)
		{
			paused = shouldPause;
			CallVoid(paused ? "PotPOverlay_Pause" : "PotPOverlay_Unpause");
		}

		const ULONGLONG now = GetTickCount64();
		if (MenuOpen() && !hasList && !reading && !g_building && now >= nextAsk)
		{
			nextAsk = now + 500;
			g_wantRefresh = true;
		}
	}

	// The mod's settings: the saved values into the scripts' map as they start, and saved again whenever the map's version
	// moves, which it does for a change from the Settings page or from a script
	void ModSettingsTick(bool scriptsStarted)
	{
		static bool sent = false;
		static int seenVersion = 0;
		static ULONGLONG nextLook = 0;
		if (scriptsStarted)
		{
			sent = false;
			seenVersion = 0;
		}
		if (!sent)
		{
			if (!FindScriptFunction("PotP_SettingsWanted"))
				return;   // scripts older than this overlay
			sent = true;
			const auto values = LoadModSettings();
			for (const auto& [id, value] : values)
				RunExec("potp_setting(" + id + ", " + ExecText(value) + ")", true);
			RunExec("potp_settings_end(" + std::to_string(values.size()) + ")");
			return;
		}
		const ULONGLONG now = GetTickCount64();
		if (now < nextLook)
			return;
		nextLook = now + 250;
		const int version = CallInt("PotP_SettingsVersion");
		if (version == seenVersion)
			return;
		seenVersion = version;
		std::string lines;
		if (CallString("PotP_SettingsValues", lines) && !lines.empty())
		{
			SaveModSettings(lines);
			Log("mod settings saved (version %d)", version);
		}
	}

	// Every quest's title id, from the journals, into the scripts' map: once each time the scripts start, a little a tick.
	// It lives on theGame, so it lasts through every save loaded after.
	void QuestTitlesTick(bool scriptsStarted)
	{
		static std::vector<std::string> queue;
		static size_t at = 0;
		static bool sent = false;
		if (scriptsStarted)
			sent = false;
		if (!sent)
		{
			const auto* titles = QuestTitles();
			if (!titles || !FindScriptFunction("PotP_QuestTitlesWanted"))
				return;   // not read yet, or scripts older than this overlay
			sent = true;
			queue.clear();
			at = 0;
			queue.push_back("potp_questtitles_begin(" + std::to_string(titles->size()) + ")");
			for (const auto& [baseName, id] : *titles)
				queue.push_back("potp_questtitle(" + ExecText(baseName) + ", " + std::to_string(id) + ")");
			queue.push_back("potp_questtitles_end(" + std::to_string(titles->size()) + ")");
		}
		for (int lines = 0; lines < 100 && at < queue.size(); ++lines)
			RunExec(queue[at++], true);
		if (at == queue.size() && !queue.empty())
		{
			Log("quest titles: %zu sent to the scripts", queue.size() - 2);
			std::lock_guard lock(g_stateMutex);
			if (g_model)
				g_wantRefresh = true;   // a list read before they came: read it again with its quests' titles
			queue.clear();
			queue.shrink_to_fit();
			at = 0;
		}
	}

	void __fastcall hkScriptTick(void* ignored, float dt)
	{
		const auto ticks = ++g_ticks;
		if (ticks == 1 || ticks % 6000 == 0)
			Log("script tick #%llu dt %.4f", ticks, dt);

		void* scripting = *g_scriptingPtr;
		const bool ready = scripting && *(static_cast<uint8_t*>(scripting) + kScriptingReady) != 0;
		static bool wasReady;
		const bool startedNow = ready && !wasReady;
		if (ready != wasReady)
		{
			wasReady = ready;
			Log("scripts ready: %d", ready);
			if (!ready)
				g_building.reset();   // a recompile: whatever was being read is gone
		}

		if (ready && !g_crashed)
		{
			RadialTick();
			NotificationTick();
			TrackerTick();

			WaitingTick();

			std::vector<PendingExec> commands;
			{
				std::lock_guard lock(g_stateMutex);
				commands.swap(g_pendingExec);
			}
			for (const PendingExec& c : commands)
			{
				RunExec(c.command);
				if (c.readAgain)
					g_wantRefresh = true;
			}
			SoundTick();
			if (g_wantSettingsClosed.exchange(false))
				CallVoid("PotPOverlay_SettingsClosed");

			if (g_wantAchievements.exchange(false))
			{
				std::string text;
				const bool answered = CallString("PotPOverlay_Achievements", text);
				AchievementsTick(text, answered);
			}

			if (g_wantKills.exchange(false))
			{
				std::string text;
				const bool answered = CallString("PotPOverlay_Kills", text);
				KillsTick(text, answered);
			}

			// Mods' own achievements: their lists go over a line at a time, so those lines stay out of the log
			static const CustomAchievementCalls customCalls{
				[](const std::string& line) { RunExec(line, true); },
				[](const char* name, std::string& out) { return CallString(name, out); } };
			CustomAchievementsTick(customCalls);

			ModSettingsTick(startedNow);
			QuestTitlesTick(startedNow);

			if (g_wantWardrobeItems.exchange(false))
			{
				std::string text;
				if (CallString("PotPOverlay_WardrobeItems", text) && !text.empty())
					UiPushPopup(text);
			}

			if (g_wantRefresh.exchange(false))
				BeginReading();
			else if (g_building)
			{
				// As much as fits in a small slice of this tick, so reading takes a few frames and none of them stutter
				LARGE_INTEGER start, now, frequency;
				QueryPerformanceFrequency(&frequency);
				QueryPerformanceCounter(&start);
				const LONGLONG budget = frequency.QuadPart * 3 / 1000;
				do
				{
					ReadNextSection();
					QueryPerformanceCounter(&now);
				} while (g_building && now.QuadPart - start.QuadPart < budget);
			}
		}
		else if (g_wantOpen.exchange(false))
		{
			OpenWindow();   // no scripts to ask
		}
		oScriptTick(ignored, dt);
	}

	// Every device's input for this tick passes through here, and the game's menus read the same list
	// further on. So the window gets every controller the game supports, and while it's open the game
	// gets nothing, whichever device it came from.
	void __fastcall hkInputUpdate(void* manager, InputEvents* events)
	{
		static bool logged = false;
		if (!logged)
		{
			logged = true;
			Log("input stream: first update");
		}

		static bool wasBlocking = false;
		const bool blocking = MenuOpen();
		const bool blockStarts = blocking && !wasBlocking;
		wasBlocking = blocking;

		// Have the devices let go of whatever's held, or a key held as the window opens stays down
		if (blockStarts)
			InterlockedExchange(reinterpret_cast<volatile LONG*>(static_cast<uint8_t*>(manager) + kManagerResetRequest), 1);

		oInputUpdate(manager, events);
		if (!events)
			return;

		// Which controller: the device that last sent something, when it's a pad
		const uint32_t last = *reinterpret_cast<const uint32_t*>(static_cast<const uint8_t*>(manager) + kManagerLastDevice);
		if (last != 0)
		{
			if (last == *g_namePs4Pad || last == *g_namePs5Pad)
				PadStreamStyle(kPadPlayStation);
			else if (last == *g_nameXPad)
				PadStreamStyle(kPadXbox);
		}

		uint32_t passed = 0;
		for (uint32_t i = 0; i < events->size; ++i)
		{
			const InputEvent e = events->data[i];
			if (e.key == kPadYKey && !blocking)
			{
				if (e.action == 1)
					RadialKeyDown(true);
				else if (e.action == 2)
					RadialKeyUp();
			}
			if (!PadStreamEvent(e.key, e.action, e.data))
				events->data[passed++] = e;
		}
		events->size = passed;

		if (blockStarts)
		{
			// Only the releases get through, so nothing stays held. A pad can press again in the same update.
			uint32_t kept = 0;
			for (uint32_t i = 0; i < events->size; ++i)
			{
				const InputEvent& e = events->data[i];
				if (e.action == 2 || (e.action == 3 && e.data == 0.f))
					events->data[kept++] = e;
			}
			events->size = kept;
		}
		else if (blocking)
		{
			events->size = 0;   // as the engine empties it itself
		}
	}

	bool InstallInputHook(uint8_t* base, const GameAddresses& addresses)
	{
		void** slot = reinterpret_cast<void**>(base + addresses.inputUpdateSlot);
		if (*slot != base + addresses.inputUpdate)
			return Log("input stream: the vtable slot holds %p, expected %p", *slot, base + addresses.inputUpdate), false;
		// Only what picks the controller's icons: Automatic falls back to XInput's answer without them
		static const uint32_t kNone = 0xFFFFFFFF;
		g_namePs4Pad = addresses.namePs4Pad ? reinterpret_cast<const uint32_t*>(base + addresses.namePs4Pad) : &kNone;
		g_namePs5Pad = addresses.namePs5Pad ? reinterpret_cast<const uint32_t*>(base + addresses.namePs5Pad) : &kNone;
		g_nameXPad = addresses.nameXPad ? reinterpret_cast<const uint32_t*>(base + addresses.nameXPad) : &kNone;
		oInputUpdate = reinterpret_cast<InputUpdate_t>(*slot);
		DWORD old;
		if (!VirtualProtect(slot, sizeof(void*), PAGE_READWRITE, &old))
			return Log("input stream: can't write to the vtable"), false;
		InterlockedExchangePointer(slot, reinterpret_cast<void*>(&hkInputUpdate));
		VirtualProtect(slot, sizeof(void*), old, &old);
		PadStreamEnable();
		Log("input stream hooked");
		return true;
	}

	bool InstallTickHook(uint8_t* target)
	{
		if (memcmp(target, kExpectedPrologue, kHookLength) != 0)
			return Log("tick function bytes aren't what's expected"), false;

		auto* trampoline = static_cast<uint8_t*>(VirtualAlloc(nullptr, 64, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
		if (!trampoline)
			return Log("no memory for the trampoline"), false;

		const auto writeJump = [](uint8_t* at, const void* to)
		{
			const uint8_t jump[6] = { 0xFF, 0x25, 0, 0, 0, 0 };   // jmp [rip+0]
			memcpy(at, jump, sizeof(jump));
			memcpy(at + sizeof(jump), &to, sizeof(to));
		};

		memcpy(trampoline, target, kHookLength);
		writeJump(trampoline + kHookLength, target + kHookLength);
		FlushInstructionCache(GetCurrentProcess(), trampoline, 64);
		oScriptTick = reinterpret_cast<ScriptTick_t>(trampoline);

		DWORD old;
		if (!VirtualProtect(target, kHookLength, PAGE_EXECUTE_READWRITE, &old))
			return Log("can't write to the tick function"), false;
		writeJump(target, reinterpret_cast<const void*>(&hkScriptTick));
		target[14] = 0x90;
		VirtualProtect(target, kHookLength, old, &old);
		FlushInstructionCache(GetCurrentProcess(), target, kHookLength);
		return true;
	}
}

void InstallEngineBridge()
{
	auto* base = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
	auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
	auto* nt = reinterpret_cast<IMAGE_NT_HEADERS*>(base + dos->e_lfanew);
	// A tested build uses its table. The scan still runs, so the log shows whether the patterns hold up on it.
	const DWORD timestamp = nt->FileHeader.TimeDateStamp;
	const GameAddresses* known = KnownBuild(timestamp);
	GameAddresses scanned;
	std::string problem;
	LARGE_INTEGER scanStart, scanEnd, scanFrequency;
	QueryPerformanceFrequency(&scanFrequency);
	QueryPerformanceCounter(&scanStart);
	const bool scanOk = ScanForAddresses(base, scanned, problem);
	QueryPerformanceCounter(&scanEnd);
	const double scanMs = static_cast<double>(scanEnd.QuadPart - scanStart.QuadPart) * 1000.0 / static_cast<double>(scanFrequency.QuadPart);
	if (scanOk)
		Log("exe timestamp 0x%08lx: scan found everything in %.0f ms", timestamp, scanMs);
	else
		Log("exe timestamp 0x%08lx: scan failed in %.0f ms: %s", timestamp, scanMs, problem.c_str());

	GameAddresses addresses;
	if (known)
	{
		addresses = *known;
		Log("tested build. Scan %s the table", !scanOk ? "couldn't be compared with" : scanned == *known ? "matches" : "DIFFERS FROM");
		if (scanOk && !(scanned == *known))
			Log("scan: %s", DescribeAddresses(scanned).c_str());
	}
	else if (scanOk)
	{
		addresses = scanned;
		Log("not a tested build: using what the scan found: %s", DescribeAddresses(scanned).c_str());
	}
	else
	{
		Log("not a tested build, and the scan failed: bridge off");
		SetMessage(Tx(T_wrong_build));
		return;
	}

	GetRTTI = reinterpret_cast<GetRTTI_t>(base + addresses.getRtti);
	GetNames = reinterpret_cast<GetNames_t>(base + addresses.getNames);
	AddName = reinterpret_cast<AddName_t>(base + addresses.addName);
	FindGlobalFunction = reinterpret_cast<FindGlobalFunction_t>(base + addresses.findGlobalFunction);
	CallDirect = reinterpret_cast<CallDirect_t>(base + addresses.callDirect);
	CallGlobalExec = reinterpret_cast<CallGlobalExec_t>(base + addresses.callGlobalExec);
	EngineFree = reinterpret_cast<Free_t>(base + addresses.free);
	g_scriptingPtr = reinterpret_cast<void**>(base + addresses.scriptingPtr);

	if (!InstallTickHook(base + addresses.scriptTick))
	{
		SetMessage(Tx(T_no_tick));
		return;
	}
	g_bridgeOk = true;
	Log("bridge in: script tick hooked");
	InstallInputHook(base, addresses);
}

BridgeState GetBridgeState()
{
	std::lock_guard lock(g_stateMutex);
	return { g_model, g_message, g_reading };
}

void RequestRefresh()
{
	g_wantRefresh = true;
}

void RequestPause(bool pause)
{
	g_wantPause = pause ? 1 : 0;
}

void RequestSetStatus(const std::string& uuid, int manual)
{
	RequestExec("potpoverlay_setstatus(" + uuid + ", " + std::to_string(manual) + ")", true);
}

void RequestExec(const std::string& command, bool readAgain)
{
	std::lock_guard lock(g_stateMutex);
	g_pendingExec.push_back({ command, readAgain });
}

void RequestMenuSound(const char* event)
{
	if (!g_bridgeOk || g_crashed)
		return;
	std::lock_guard lock(g_stateMutex);
	if (g_pendingSounds.size() < 8)   // a few at most between two ticks, however fast the frames come
		g_pendingSounds.push_back(event);
}

void RequestAchievements()
{
	g_wantAchievements = true;
}

void RequestKills()
{
	g_wantKills = true;
}

void RequestWardrobeItems()
{
	g_wantWardrobeItems = true;
}

void RequestSettingsClosed()
{
	g_wantSettingsClosed = true;
}

void RequestMenuOpen()
{
	g_openFromPad = false;
	if (g_bridgeOk && !g_crashed)
		g_wantOpen = true;
	else
		OpenWindow();   // no game tick is coming to do it
}

void RadialKeyDown(bool fromPad)
{
	g_openFromPad = fromPad;
	g_radialKeyEvents |= 1;
}

void RadialKeyUp()
{
	g_radialKeyEvents |= 2;
}

#ifdef POTP_OVERLAY_TEST
void PublishForTest(const char* const* chunks, int count)
{
	auto model = std::make_shared<Model>();
	for (int i = 0; i < count; ++i)
		ParseChunk(*model, chunks[i]);
	std::lock_guard lock(g_stateMutex);
	g_model = model;
	g_message.clear();
}
#endif
