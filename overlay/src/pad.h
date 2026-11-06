#pragma once

// The window's read of the controller. It comes from the game's own input stream, so it works with
// everything the game supports; XInput is only the fallback when that stream isn't available.
enum PadButtons : unsigned
{
	kPadUp = 0x0001, kPadDown = 0x0002, kPadLeft = 0x0004, kPadRight = 0x0008,
	kPadStart = 0x0010, kPadBack = 0x0020, kPadL3 = 0x0040, kPadR3 = 0x0080,
	kPadLB = 0x0100, kPadRB = 0x0200,
	kPadA = 0x1000, kPadB = 0x2000, kPadX = 0x4000, kPadY = 0x8000,
	kPadLT = 0x10000, kPadRT = 0x20000,   // triggers, as buttons
};

struct PadState
{
	bool connected = false;
	unsigned buttons = 0, previous = 0;
	float leftX = 0.f, leftY = 0.f, rightX = 0.f, rightY = 0.f;   // -1 to 1, up is positive
	bool Pressed(unsigned mask) const { return (buttons & mask) != 0 && (previous & mask) == 0; }
	bool Moved() const { return buttons != previous || leftX != 0.f || leftY != 0.f || rightX != 0.f || rightY != 0.f; }
};

const PadState& PadPoll();   // once a frame
#ifdef POTP_OVERLAY_TEST
void PadInjectForTest(int buttons, int leftX, int leftY, int rightY);
#endif

// From the game's input hook, on its tick
void PadStreamEnable();
bool PadStreamEvent(int key, int action, float data);   // true when the game shouldn't get this one
void PadStreamStyle(int padStyle);   // a PadStyle from settings.h
int PadDetectedStyle();
