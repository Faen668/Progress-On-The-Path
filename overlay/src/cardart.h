#pragma once
#include <string>
#include <vector>
#include "gameicons.h"

// What the game's own Gwent menu puts on a card: its banners, power discs, icons and parchment. They're read from
// the menu's resource wherever the game would find it (a mod, a DLC, then the game), so a mod that changes them
// changes them here too. Nothing is copied or shipped.
enum CardClip { kClipBanner, kClipPower, kClipType, kClipEffect, kClipParchment, kClipShield, kClipCount };

struct CardPiece
{
	int atlas = 0;
	float u0 = 0.f, v0 = 0.f, u1 = 1.f, v1 = 1.f;
	float x[4] = {}, y[4] = {};   // on the card: its top left is 0, 0 and it's 309 x 584, as the game has it
};

void BuildCardArt(const std::wstring& game);   // on the loading thread
bool CardArtReady();
const std::vector<CardPiece>* CardArtFrame(CardClip clip, const std::string& label);   // null if it has no such frame
const GameTexture* CardArtAtlas(int atlas);
bool UnpackLz4(const uint8_t* in, size_t size, uint8_t* out, size_t room);   // a raw block
bool UpscaleCardArt(const GameTexture& source, GameTexture& out);   // twice the size, sharpened: false if it can't
