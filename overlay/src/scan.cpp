#include "scan.h"
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <map>
#include <vector>

namespace
{
	enum Kind
	{
		kFunction,             // the pattern is the function's own opening
		kCall,                 // a call to it, from a function known to call this one
		kGlobal,               // code using it: the address is read from the instruction
		kCheck,                // only has to be there: it holds a struct offset we rely on
		kInsideInputUpdate,    // the same, inside one function
		kMostUsedLookup,       // many sites: what the most of them call, by a long way
	};

	struct PatternDef { const char* name; Kind kind; const char* bytes; int at; int end; };

	const PatternDef kPatterns[] = {
#include "patterns.inc"
	};

	constexpr DWORD kKnownTimestamp = 0x6ADFBD7A;
	const GameAddresses kKnown = {
		0x031F8D0, 0x031D510, 0x26B7A90, 0x26CB380, 0x26FBD80, 0x270C1D0, 0x0BCB6F0,
		0x270CF60, 0x5A7BA70,
		0x1E66B90, 0x3824480,
		0x5C05BB0, 0x5C05BB4, 0x5C05BB8,
	};

	constexpr int kFewestCallers = 1000;
	constexpr int kLeadOverNext = 10;

	struct Section { const uint8_t* data = nullptr; size_t size = 0; uintptr_t rva = 0; };

	struct Compiled
	{
		std::vector<uint8_t> bytes;
		std::vector<uint8_t> known;
		size_t anchor = 0;      // the byte that's looked for first: the rarest there is in the code
	};

	Compiled Compile(const char* text, const size_t* frequency)
	{
		Compiled c;
		for (const char* p = text; *p;)
		{
			while (*p == ' ')
				++p;
			if (!*p)
				break;
			if (p[0] == '?')
			{
				c.bytes.push_back(0);
				c.known.push_back(0);
			}
			else
			{
				unsigned value = 0;
				sscanf_s(p, "%2x", &value);
				c.bytes.push_back(static_cast<uint8_t>(value));
				c.known.push_back(1);
			}
			p += 2;
		}
		size_t best = SIZE_MAX;
		for (size_t i = 0; i < c.bytes.size(); ++i)
			if (c.known[i] && frequency[c.bytes[i]] < best)
			{
				best = frequency[c.bytes[i]];
				c.anchor = i;
			}
		return c;
	}

	// Every place in [data, data + size) it matches, as offsets
	std::vector<size_t> Find(const Compiled& c, const uint8_t* data, size_t size, size_t limit)
	{
		std::vector<size_t> found;
		const size_t length = c.bytes.size();
		if (length == 0 || size < length)
			return found;
		const uint8_t want = c.bytes[c.anchor];
		const uint8_t* cursor = data + c.anchor;
		const uint8_t* const last = data + size - length + c.anchor;
		while (cursor <= last)
		{
			cursor = static_cast<const uint8_t*>(memchr(cursor, want, static_cast<size_t>(last - cursor) + 1));
			if (!cursor)
				break;
			const uint8_t* start = cursor - c.anchor;
			bool same = true;
			for (size_t i = 0; i < length; ++i)
				if (c.known[i] && start[i] != c.bytes[i])
				{
					same = false;
					break;
				}
			if (same)
			{
				found.push_back(static_cast<size_t>(start - data));
				if (found.size() >= limit)
					break;
			}
			++cursor;
		}
		return found;
	}

	int32_t Rel32(const uint8_t* p)
	{
		int32_t value;
		memcpy(&value, p, sizeof(value));
		return value;
	}

	bool GetSections(const uint8_t* image, Section& text, Section& rdata)
	{
		const auto* dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(image);
		const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS*>(image + dos->e_lfanew);
		const IMAGE_SECTION_HEADER* s = IMAGE_FIRST_SECTION(nt);
		for (int i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++s)
		{
			char name[9] = {};
			memcpy(name, s->Name, 8);
			Section* to = strcmp(name, ".text") == 0 ? &text : strcmp(name, ".rdata") == 0 ? &rdata : nullptr;
			if (to)
			{
				to->data = image + s->VirtualAddress;
				to->size = s->Misc.VirtualSize;
				to->rva = s->VirtualAddress;
			}
		}
		return text.data && rdata.data;
	}
}

const GameAddresses* KnownBuild(DWORD timestamp)
{
	return timestamp == kKnownTimestamp ? &kKnown : nullptr;
}

bool ScanForAddresses(const uint8_t* image, GameAddresses& out, std::string& problem)
{
	Section text, rdata;
	if (!GetSections(image, text, rdata))
	{
		problem = "the exe has no .text or .rdata";
		return false;
	}

	size_t frequency[256] = {};
	for (size_t i = 0; i < text.size; i += 7)   // a sample is plenty to know which bytes are rare
		++frequency[text.data[i]];

	std::map<std::string, uintptr_t> found;
	std::string missing;
	const auto fail = [&](const char* name, const char* why)
	{
		missing += missing.empty() ? "" : ", ";
		missing += std::string(name) + " (" + why + ")";
	};
	const auto isOptional = [](const char* name) { return strncmp(name, "NamePs", 6) == 0 || strcmp(name, "NameXPad") == 0; };

	// In the table's order, so what a later pattern needs is already known
	for (const PatternDef& def : kPatterns)
	{
		const Compiled c = Compile(def.bytes, frequency);
		if (def.kind == kInsideInputUpdate)
			continue;
		if (def.kind == kMostUsedLookup)
			continue;
		const std::vector<size_t> hits = Find(c, text.data, text.size, 2);
		if (hits.size() != 1)
		{
			if (!isOptional(def.name))
				fail(def.name, hits.empty() ? "no match" : "more than one match");
			continue;
		}
		const uint8_t* at = text.data + hits[0];
		if (def.kind == kFunction)
			found[def.name] = text.rva + hits[0];
		else if (def.kind == kCall)
		{
			const uintptr_t target = text.rva + hits[0] + def.at + 4 + Rel32(at + def.at);
			// One of 24 copies, each for its own memory pool, so what it's reached through has to look right too
			static const uint8_t kFreeOpening[7] = { 0x48, 0x83, 0xEC, 0x38, 0x4C, 0x8B, 0xC9 };
			const bool inText = target >= text.rva && target + sizeof(kFreeOpening) <= text.rva + text.size;
			if (!inText || memcmp(text.data + (target - text.rva), kFreeOpening, sizeof(kFreeOpening)) != 0)
				fail(def.name, "the call goes somewhere else");
			else
				found[def.name] = target;
		}
		else if (def.kind == kGlobal)
			found[def.name] = text.rva + hits[0] + def.end + Rel32(at + def.at);
	}

	for (const PatternDef& def : kPatterns)
	{
		const Compiled c = Compile(def.bytes, frequency);
		if (def.kind == kInsideInputUpdate)
		{
			const auto update = found.find("InputUpdate");
			if (update != found.end() && Find(c, text.data + (update->second - text.rva), 512, 1).empty())
				fail(def.name, "not in the function");
		}
		else if (def.kind == kMostUsedLookup)
		{
			const auto rtti = found.find("GetRTTI");
			if (rtti == found.end())
				continue;
			std::map<uintptr_t, int> votes;
			for (size_t hit : Find(c, text.data, text.size, SIZE_MAX))
				++votes[text.rva + hit + 5 + Rel32(text.data + hit + def.at)];
			votes.erase(rtti->second);
			int best = 0, next = 0;
			uintptr_t winner = 0;
			for (const auto& [address, count] : votes)
			{
				if (count > best)
				{
					next = best;
					best = count;
					winner = address;
				}
				else if (count > next)
				{
					next = count;
				}
			}
			// The same getter opening as the type table's, so it can't be something else that happens to be called a lot
			static const uint8_t kGetterOpening[7] = { 0x48, 0x83, 0xEC, 0x28, 0x48, 0x8B, 0x05 };
			const bool shaped = winner >= text.rva && winner + sizeof(kGetterOpening) <= text.rva + text.size && memcmp(text.data + (winner - text.rva), kGetterOpening, sizeof(kGetterOpening)) == 0;
			if (best < kFewestCallers || best < next * kLeadOverNext || !shaped)
				fail(def.name, "no clear winner among its callers");
			else
				found[def.name] = winner;
		}
	}

	// The input manager's vtable holds the only pointer to its update function
	const auto update = found.find("InputUpdate");
	uintptr_t slot = 0;
	if (update != found.end())
	{
		const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS*>(image + reinterpret_cast<const IMAGE_DOS_HEADER*>(image)->e_lfanew);
		// A loaded exe's pointers are relocated, and a file's are against its preferred base
		const uint64_t bases[2] = { reinterpret_cast<uint64_t>(image), nt->OptionalHeader.ImageBase };
		int slots = 0;
		for (uint64_t base : bases)
		{
			const uint64_t want = base + update->second;
			for (size_t i = 0; i + 8 <= rdata.size; i += 8)
				if (memcmp(rdata.data + i, &want, 8) == 0)
				{
					slot = rdata.rva + i;
					++slots;
				}
			if (slots > 0)
				break;
		}
		if (slots != 1)
			fail("InputUpdateSlot", slots == 0 ? "no pointer to it" : "more than one pointer to it");
	}

	if (!missing.empty())
	{
		problem = missing;
		return false;
	}

	const auto get = [&](const char* name) { const auto i = found.find(name); return i == found.end() ? uintptr_t(0) : i->second; };
	out.getRtti = get("GetRTTI");
	out.getNames = get("GetNames");
	out.addName = get("AddName");
	out.findGlobalFunction = get("FindGlobalFunction");
	out.callDirect = get("CallDirect");
	out.callGlobalExec = get("CallGlobalExec");
	out.free = get("Free");
	out.scriptTick = get("ScriptTick");
	out.scriptingPtr = get("ScriptingPtr");
	out.inputUpdate = get("InputUpdate");
	out.inputUpdateSlot = slot;
	out.namePs4Pad = get("NamePs4Pad");
	out.namePs5Pad = get("NamePs5Pad");
	out.nameXPad = get("NameXPad");
	return true;
}

std::string DescribeAddresses(const GameAddresses& a)
{
	char text[512];
	snprintf(text, sizeof(text),
		"GetRTTI %zx, GetNames %zx, AddName %zx, FindGlobalFunction %zx, CallDirect %zx, CallGlobalExec %zx, Free %zx, ScriptTick %zx, ScriptingPtr %zx, InputUpdate %zx, slot %zx, ps4pad %zx, ps5pad %zx, xpad %zx",
		a.getRtti, a.getNames, a.addName, a.findGlobalFunction, a.callDirect, a.callGlobalExec, a.free, a.scriptTick, a.scriptingPtr, a.inputUpdate, a.inputUpdateSlot, a.namePs4Pad, a.namePs5Pad, a.nameXPad);
	return text;
}
