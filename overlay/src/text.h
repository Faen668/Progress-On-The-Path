#pragma once
#include <string>

// The overlay's own text. It's all written in source/strings/en.csv with the rest of the mod's, and the scripts pass it
// over in the player's language with each reading. Until they have, or for a string they don't have, it's the English.
enum TextId
{
#define X(id, english) T_##id,
#include "text_table.inc"
#undef X
	T_Count
};

// The pointer stays good for as long as the game runs, but it's only the right text at the time: tables that live
// longer than a frame keep the TextId, not this.
const char* Tx(TextId id);

// The text with [1] and [2] filled in. A translation can put them in any order, or leave one out.
std::string TxFill(TextId id, const std::string& first, const std::string& second = std::string());

// One string from the scripts, by the name after potp_ov_
void TextPut(const std::string& key, const std::string& value);
