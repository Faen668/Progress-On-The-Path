#include "text.h"

#include <atomic>
#include <cstring>

namespace
{
	const char* const kKeys[T_Count] = {
#define X(id, english) #id,
#include "text_table.inc"
#undef X
	};

	// Set on the game's thread and read on the render thread. An old string is left where it is, as a frame could be
	// drawing it, which costs nothing unless the language changes while the game runs.
	std::atomic<const char*> g_text[T_Count] = {
#define X(id, english) english,
#include "text_table.inc"
#undef X
	};

	void Replace(std::string& text, const char* token, const std::string& with)
	{
		const size_t length = strlen(token);
		for (size_t at = text.find(token); at != std::string::npos; at = text.find(token, at + with.size()))
			text.replace(at, length, with);
	}
}

const char* Tx(TextId id)
{
	return g_text[id].load(std::memory_order_acquire);
}

std::string TxFill(TextId id, const std::string& first, const std::string& second)
{
	std::string text = Tx(id);
	Replace(text, "[1]", first);
	Replace(text, "[2]", second);
	return text;
}

void TextPut(const std::string& key, const std::string& value)
{
	if (value.empty())
		return;
	for (int i = 0; i < T_Count; ++i)
	{
		if (key != kKeys[i])
			continue;
		if (value != g_text[i].load(std::memory_order_relaxed))
			g_text[i].store(_strdup(value.c_str()), std::memory_order_release);
		return;
	}
}
