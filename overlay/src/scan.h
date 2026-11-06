#pragma once
#include <windows.h>
#include <cstdint>
#include <string>

// Where the overlay's game code and data are, as offsets into witcher3.exe
struct GameAddresses
{
	uintptr_t getRtti = 0, getNames = 0, addName = 0, findGlobalFunction = 0, callDirect = 0, callGlobalExec = 0, free = 0;
	uintptr_t scriptTick = 0, scriptingPtr = 0;
	uintptr_t inputUpdate = 0, inputUpdateSlot = 0;
	uintptr_t namePs4Pad = 0, namePs5Pad = 0, nameXPad = 0;
	bool operator==(const GameAddresses&) const = default;
};

// The addresses for a build that's been tested, or nullptr
const GameAddresses* KnownBuild(DWORD timestamp);

// Finds them by pattern in an image laid out as it is in memory. False, with what's wrong, if anything required
// doesn't match exactly once. Nothing found is trusted until all of it has been. The controller names are optional.
bool ScanForAddresses(const uint8_t* image, GameAddresses& out, std::string& problem);

// A line per address, for the log and the test tool
std::string DescribeAddresses(const GameAddresses& a);
