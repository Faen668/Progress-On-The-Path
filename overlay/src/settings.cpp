#include <windows.h>
#include <shlobj.h>
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <string>
#include "log.h"
#include "settings.h"

namespace
{
	Settings g_settings;

	std::string IniPath()
	{
		HMODULE self = nullptr;
		GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, reinterpret_cast<LPCSTR>(&GetSettings), &self);
		char path[MAX_PATH] = "";
		GetModuleFileNameA(self, path, MAX_PATH);
		std::string s = path;
		return s.substr(0, s.find_last_of('\\') + 1) + "potp_overlay.ini";
	}

	float ReadFloat(const std::string& ini, const char* key, float fallback, float low, float high)
	{
		char text[32];
		char def[32];
		snprintf(def, sizeof(def), "%g", fallback);
		GetPrivateProfileStringA("Overlay", key, def, text, sizeof(text), ini.c_str());
		return std::clamp(static_cast<float>(atof(text)), low, high);
	}

	int ReadInt(const std::string& ini, const char* key, int fallback)
	{
		return static_cast<int>(GetPrivateProfileIntA("Overlay", key, fallback, ini.c_str()));
	}

	void WriteFloat(const std::string& ini, const char* key, float value)
	{
		char text[32];
		snprintf(text, sizeof(text), "%g", value);
		WritePrivateProfileStringA("Overlay", key, text, ini.c_str());
	}

	void WriteInt(const std::string& ini, const char* key, int value)
	{
		char text[32];
		snprintf(text, sizeof(text), "%d", value);
		WritePrivateProfileStringA("Overlay", key, text, ini.c_str());
	}
}

Settings& GetSettings()
{
	return g_settings;
}

void LoadSettings()
{
	const std::string ini = IniPath();
	const Settings d;
	Settings& s = g_settings;
	s.scale = ReadFloat(ini, "Scale", d.scale, 0.5f, 2.f);
	s.widthPercent = ReadFloat(ini, "WidthPercent", d.widthPercent, 40.f, 100.f);
	s.heightPercent = ReadFloat(ini, "HeightPercent", d.heightPercent, 40.f, 100.f);
	s.opacity = ReadFloat(ini, "Opacity", d.opacity, 0.5f, 1.f);
	s.dim = ReadFloat(ini, "DimGame", d.dim, 0.f, 0.9f);
	s.posX = ReadFloat(ini, "PositionX", d.posX, -1.f, 1.f);
	s.posY = ReadFloat(ini, "PositionY", d.posY, -1.f, 1.f);
	s.pauseGame = ReadInt(ini, "PauseGame", d.pauseGame) != 0;
	s.openOnLastBook = ReadInt(ini, "OpenOnLastBook", d.openOnLastBook) != 0;
	s.autoRotate = ReadInt(ini, "AutoRotate", d.autoRotate) != 0;
	s.clothSim = ReadInt(ini, "ClothSim", d.clothSim) != 0;
	s.liveBestiary = ReadInt(ini, "LiveBestiary", d.liveBestiary) != 0;
	s.liveBook = ReadInt(ini, "LiveBook", d.liveBook) != 0;
	s.menuSounds = ReadInt(ini, "MenuSounds", d.menuSounds) != 0;
	s.tourOffered = ReadInt(ini, "TourOffered", d.tourOffered) != 0;
	s.hideCompleted = ReadInt(ini, "HideCompleted", d.hideCompleted) != 0;
	s.hideIgnored = ReadInt(ini, "HideIgnored", d.hideIgnored) != 0;
	s.hideMissable = ReadInt(ini, "HideMissable", d.hideMissable) != 0;
	s.revealUndiscovered = ReadInt(ini, "RevealUndiscovered", d.revealUndiscovered) != 0;
	s.revealHiddenAchievements = ReadInt(ini, "RevealHiddenAchievements", d.revealHiddenAchievements) != 0;
	s.revealUncollected = ReadInt(ini, "RevealUncollected", d.revealUncollected) != 0;
	s.revealUnstarted = ReadInt(ini, "RevealUnstarted", d.revealUnstarted) != 0;
	{
		static char revealed[32768];
		revealed[0] = 0;
		GetPrivateProfileStringA("Overlay", "RevealedMissables", "", revealed, sizeof(revealed), ini.c_str());
		s.revealedMissables = revealed;
	}
	s.radialKey = ReadInt(ini, "RadialKey", d.radialKey);
	s.popupX = static_cast<float>(ReadInt(ini, "PopupX", static_cast<int>(d.popupX * 1000.f))) / 1000.f;
	s.popupY = static_cast<float>(ReadInt(ini, "PopupY", static_cast<int>(d.popupY * 1000.f))) / 1000.f;
	s.openKey = static_cast<unsigned>(ReadInt(ini, "OpenKey", static_cast<int>(d.openKey)));
	// Not a real key, or Home, the old default: the game toggles its HUD with that
	if (s.openKey == 0 || s.openKey >= 0xFF || s.openKey == VK_HOME)
		s.openKey = d.openKey;
	s.updateKey = static_cast<unsigned>(ReadInt(ini, "UpdateKey", static_cast<int>(d.updateKey)));
	if (s.updateKey == 0 || s.updateKey >= 0xFF || s.updateKey == VK_HOME)
		s.updateKey = d.updateKey;
	s.lastBook = ReadInt(ini, "LastBook", d.lastBook);
	s.wardrobeAnimation = ReadInt(ini, "WardrobeAnimation", d.wardrobeAnimation);
	s.wardrobeShowUntracked = ReadInt(ini, "WardrobeShowUntracked", d.wardrobeShowUntracked ? 1 : 0) != 0;
	s.showScabbard = ReadInt(ini, "ShowScabbard", d.showScabbard ? 1 : 0) != 0;
	{
		char pins[4096] = "";
		GetPrivateProfileStringA("Overlay", "WardrobePins", "", pins, sizeof(pins), ini.c_str());
		s.wardrobePins = pins;
		static char outfits[32768];
		outfits[0] = 0;
		GetPrivateProfileStringA("Overlay", "WardrobeOutfits", "", outfits, sizeof(outfits), ini.c_str());
		s.wardrobeOutfits = outfits;
	}
	s.promptMode = std::clamp(ReadInt(ini, "Prompts", d.promptMode), 0, 2);
	s.padStyle = std::clamp(ReadInt(ini, "PadStyle", d.padStyle), 0, 4);
	s.hdrMatchGame = ReadInt(ini, "HdrMatchGame", d.hdrMatchGame) != 0;
	s.hdrBrightness = ReadFloat(ini, "HdrBrightness", d.hdrBrightness, 80.f, 1000.f);
	Log("settings read from %s: scale %.2f, %.0f%% x %.0f%%", ini.c_str(), s.scale, s.widthPercent, s.heightPercent);
}

void SaveSettings()
{
	const std::string ini = IniPath();
	const Settings& s = g_settings;
	WriteFloat(ini, "Scale", s.scale);
	WriteFloat(ini, "WidthPercent", s.widthPercent);
	WriteFloat(ini, "HeightPercent", s.heightPercent);
	WriteFloat(ini, "Opacity", s.opacity);
	WriteFloat(ini, "DimGame", s.dim);
	WriteFloat(ini, "PositionX", s.posX);
	WriteFloat(ini, "PositionY", s.posY);
	WriteInt(ini, "PauseGame", s.pauseGame);
	WriteInt(ini, "OpenOnLastBook", s.openOnLastBook);
	WriteInt(ini, "AutoRotate", s.autoRotate);
	WriteInt(ini, "ClothSim", s.clothSim);
	WriteInt(ini, "LiveBestiary", s.liveBestiary);
	WriteInt(ini, "LiveBook", s.liveBook);
	WriteInt(ini, "MenuSounds", s.menuSounds);
	WriteInt(ini, "TourOffered", s.tourOffered);
	WriteInt(ini, "HideCompleted", s.hideCompleted);
	WriteInt(ini, "HideIgnored", s.hideIgnored);
	WriteInt(ini, "HideMissable", s.hideMissable);
	WriteInt(ini, "RevealUndiscovered", s.revealUndiscovered);
	WriteInt(ini, "RevealHiddenAchievements", s.revealHiddenAchievements);
	WriteInt(ini, "RevealUncollected", s.revealUncollected);
	WriteInt(ini, "RevealUnstarted", s.revealUnstarted);
	WritePrivateProfileStringA("Overlay", "RevealedMissables", s.revealedMissables.c_str(), ini.c_str());
	WriteInt(ini, "RadialKey", s.radialKey);
	WriteInt(ini, "PopupX", static_cast<int>(s.popupX * 1000.f));
	WriteInt(ini, "PopupY", static_cast<int>(s.popupY * 1000.f));
	WriteInt(ini, "OpenKey", static_cast<int>(s.openKey));
	WriteInt(ini, "UpdateKey", static_cast<int>(s.updateKey));
	WriteInt(ini, "LastBook", s.lastBook);
	WriteInt(ini, "WardrobeAnimation", s.wardrobeAnimation);
	WriteInt(ini, "WardrobeShowUntracked", s.wardrobeShowUntracked ? 1 : 0);
	WriteInt(ini, "ShowScabbard", s.showScabbard ? 1 : 0);
	WritePrivateProfileStringA("Overlay", "WardrobePins", s.wardrobePins.c_str(), ini.c_str());
	WritePrivateProfileStringA("Overlay", "WardrobeOutfits", s.wardrobeOutfits.c_str(), ini.c_str());
	WriteInt(ini, "Prompts", s.promptMode);
	WriteInt(ini, "PadStyle", s.padStyle);
	WriteInt(ini, "HdrMatchGame", s.hdrMatchGame);
	WriteFloat(ini, "HdrBrightness", s.hdrBrightness);
}

namespace
{
	std::wstring DocumentsFile(const wchar_t* name)
	{
		PWSTR documents = nullptr;
		if (FAILED(SHGetKnownFolderPath(FOLDERID_Documents, 0, nullptr, &documents)))
			return {};
		std::wstring path = std::wstring(documents) + L"\\The Witcher 3\\" + name;
		CoTaskMemFree(documents);
		return path;
	}

	// A section's key=value lines, as GetPrivateProfileSection gives them
	std::vector<std::pair<std::string, std::string>> ReadSection(const std::wstring& file, const wchar_t* section)
	{
		std::vector<std::pair<std::string, std::string>> out;
		std::vector<wchar_t> text(32768);
		const DWORD got = GetPrivateProfileSectionW(section, text.data(), static_cast<DWORD>(text.size()), file.c_str());
		for (const wchar_t* at = text.data(); at < text.data() + got && *at; at += wcslen(at) + 1)
		{
			const std::wstring line = at;
			const size_t equals = line.find(L'=');
			if (equals == std::wstring::npos || equals == 0)
				continue;
			const auto narrow = [](const std::wstring& w) { return std::string(w.begin(), w.end()); };
			out.emplace_back(narrow(line.substr(0, equals)), narrow(line.substr(equals + 1)));
		}
		return out;
	}
}

namespace
{
	// The scripts end their lines with a backslash and an n, as a script string has no other way to
	std::string RealLines(std::string text)
	{
		for (size_t at = text.find("\\n"); at != std::string::npos; at = text.find("\\n", at + 1))
			text.replace(at, 2, "\n");
		return text;
	}
}

std::vector<std::pair<std::string, std::string>> LoadModSettings()
{
	const std::string ini = IniPath();
	const std::wstring wide(ini.begin(), ini.end());
	auto values = ReadSection(wide, L"ModSettings");
	if (!values.empty())
	{
		// Saved by an earlier build as one line: each id=value again
		std::vector<std::pair<std::string, std::string>> split;
		for (const auto& [id, value] : values)
		{
			const std::string lines = RealLines(id + "=" + value);
			size_t start = 0;
			while (start < lines.size())
			{
				size_t end = lines.find('\n', start);
				if (end == std::string::npos)
					end = lines.size();
				const size_t equals = lines.find('=', start);
				if (equals != std::string::npos && equals > start && equals < end)
					split.emplace_back(lines.substr(start, equals - start), lines.substr(equals + 1, end - equals - 1));
				start = end + 1;
			}
		}
		return split;
	}

	// The first time: the values the game kept for the old menu, so nobody loses theirs
	const std::wstring game = DocumentsFile(L"dx12user.settings");
	for (const wchar_t* group : { L"ProgressOnThePath_GeneralSettings", L"ProgressOnThePath_NotificationSettings" })
		for (auto& value : ReadSection(game, group))
			values.push_back(std::move(value));
	if (!values.empty())
	{
		std::string text;
		for (const auto& [id, value] : values)
			text += id + "=" + value + "\n";
		SaveModSettings(text);
	}
	Log("mod settings: %zu taken from the game's dx12user.settings", values.size());
	return values;
}

void SaveModSettings(const std::string& given)
{
	const std::string lines = RealLines(given);
	// GetPrivateProfileSection's form: each key=value ends in a NUL, and the whole in a second one
	std::string section;
	size_t start = 0;
	while (start < lines.size())
	{
		size_t end = lines.find('\n', start);
		if (end == std::string::npos)
			end = lines.size();
		if (end > start && lines.find('=', start) < end)
		{
			section.append(lines, start, end - start);
			section.push_back('\0');
		}
		start = end + 1;
	}
	section.push_back('\0');
	WritePrivateProfileSectionA("ModSettings", section.c_str(), IniPath().c_str());
}

bool GameHdrLevels(float& paperWhite, float& peak)
{
	static std::wstring path;
	static FILETIME seen{};
	static ULONGLONG checked = 0;
	static float paper = 0.f, top = 0.f;
	if (path.empty())
	{
		PWSTR documents = nullptr;
		if (FAILED(SHGetKnownFolderPath(FOLDERID_Documents, 0, nullptr, &documents)))
			return false;
		path = std::wstring(documents) + L"\\The Witcher 3\\dx12user.settings";
		CoTaskMemFree(documents);
	}
	// Looked at once a second at most: the game writes it when its options are left
	const ULONGLONG now = GetTickCount64();
	if (now - checked >= 1000)
	{
		checked = now;
		WIN32_FILE_ATTRIBUTE_DATA info{};
		if (GetFileAttributesExW(path.c_str(), GetFileExInfoStandard, &info) && CompareFileTime(&info.ftLastWriteTime, &seen) != 0)
		{
			seen = info.ftLastWriteTime;
			wchar_t text[32];
			GetPrivateProfileStringW(L"Visuals", L"HdrPaperWhite", L"0", text, 32, path.c_str());
			paper = static_cast<float>(_wtof(text));
			GetPrivateProfileStringW(L"Visuals", L"MaxTVBrightness", L"0", text, 32, path.c_str());
			top = static_cast<float>(_wtof(text));
			Log("the game's HDR: paper white %.0f nits, TV peak %.0f nits", paper, top);
		}
	}
	if (paper <= 0.f)
		return false;
	paperWhite = paper;
	peak = top;
	return true;
}
