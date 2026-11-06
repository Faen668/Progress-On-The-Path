#include "model.h"
#include "text.h"
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cstring>

namespace
{
	// The game's strings carry Flash markup and placeholders for its own menus
	std::string Clean(const std::string& in)
	{
		std::string out;
		out.reserve(in.size());
		for (size_t i = 0; i < in.size(); ++i)
		{
			const char c = in[i];
			if (c == '<')
			{
				const size_t end = in.find('>', i);
				if (end == std::string::npos)
					break;
				if (in.compare(i, 3, "<br") == 0 && !out.empty() && out.back() != ' ')
					out += ' ';
				i = end;
			}
			else if (c == '[')
			{
				const size_t end = in.find(']', i);
				if (end == std::string::npos)
					break;
				i = end;
			}
			else
			{
				out += c;
			}
		}
		const size_t a = out.find_first_not_of(" \t");
		if (a == std::string::npos)
			return {};
		const size_t b = out.find_last_not_of(" \t");
		return out.substr(a, b - a + 1);
	}

	std::vector<std::string> Split(const std::string& line)
	{
		std::vector<std::string> fields;
		size_t start = 0;
		for (;;)
		{
			const size_t bar = line.find('|', start);
			if (bar == std::string::npos)
			{
				fields.push_back(line.substr(start));
				return fields;
			}
			fields.push_back(line.substr(start, bar - start));
			start = bar + 1;
		}
	}

	int Int(const std::string& s) { return std::atoi(s.c_str()); }
}

std::string CleanGameText(const std::string& in)
{
	return Clean(in);
}

bool ParseChunk(Model& model, const std::string& text)
{
	size_t start = 0;
	bool gapPending = false;
	while (start < text.size())
	{
		// WitcherScript strings have no escapes: its line break is a backslash and an n
		size_t end = text.find("\\n", start);
		if (end == std::string::npos)
			end = text.size();
		const std::string line = text.substr(start, end - start);
		start = end + 2;
		if (line.size() < 2)
			continue;

		const std::vector<std::string> f = Split(line);
		switch (line[0])
		{
		case 'G':
			if (f.size() >= 3)
			{
				ModPage page;
				page.id = f[1];
				page.title = Clean(f[2]);
				if (f.size() >= 5)
				{
					page.intro = Clean(f[3]);
					page.presetHint = Clean(f[4]);
				}
				model.pages.push_back(std::move(page));
				gapPending = true;
			}
			break;
		case 'P':
			if (f.size() >= 2 && !model.pages.empty())
				model.pages.back().presets.push_back(Clean(f[1]));
			break;
		case 'B':
			gapPending = true;
			break;
		case 'V':
			if (f.size() >= 5 && !model.pages.empty())
			{
				ModVar v;
				v.id = f[1];
				v.value = f[4];
				if (f.size() >= 6)
					v.hint = Clean(f[5]);
				if (f.size() >= 7)
					v.fallback = f[6];
				const std::string& type = f[2];
				if (type == "COLOUR")
				{
					v.type = kVarColour;
				}
				else if (type.rfind("SLIDER", 0) == 0)
				{
					v.type = kVarSlider;
					float low = 0.f, high = 1.f, steps = 1.f;
					if (sscanf_s(type.c_str(), "SLIDER;%f;%f;%f", &low, &high, &steps) >= 2)
					{
						v.low = low;
						v.high = high;
						v.step = steps > 0.f ? (high - low) / steps : 1.f;
					}
					else
					{
						v.fixedRange = false;
					}
				}
				else if (type.rfind("OPTIONS", 0) == 0)
				{
					v.type = kVarOptions;
				}
				// Menu names read "Group  :  Setting": the group becomes a heading
				const std::string name = Clean(f[3]);
				const size_t colon = name.find(':');
				if (colon != std::string::npos)
				{
					v.head = Clean(name.substr(0, colon));
					v.label = Clean(name.substr(colon + 1));
				}
				else
				{
					v.label = name;
				}
				v.startsGroup = gapPending;
				gapPending = false;
				model.pages.back().vars.push_back(std::move(v));
			}
			break;
		case 'O':
			if (f.size() >= 2 && !model.pages.empty() && !model.pages.back().vars.empty())
				model.pages.back().vars.back().options.push_back(Clean(f[1]));
			break;
		case 'N':
			model.message = f.size() > 1 ? f[1] : "";
			return false;
		case 'Y':
			if (f.size() >= 3)
				model.dyeNames[f[1]] = Clean(f[2]);
			break;
		case 'W':
			model.gear.clear();
			for (size_t i = 1; i < f.size(); ++i)
				if (!f[i].empty())
					model.gear.push_back(f[i]);
			break;
		case 'H':
			if (f.size() >= 4)
			{
				model.version = f[1];
				model.done = Int(f[2]);
				model.total = Int(f[3]);
			}
			break;
		case 'T':
			if (f.size() >= 3)
				TextPut(f[1], f[2]);
			break;
		case 'R':
			if (f.size() >= 3)
			{
				const int i = Int(f[1]);
				if (i >= 0 && i < kRegionCount)
					model.regions[i] = Clean(f[2]);
				if (i == 0)
				{
					// The old book's tag: " (Random)"
					std::string& tag = model.regions[0];
					const size_t from = tag.find_first_not_of(" (");
					const size_t to = tag.find_last_not_of(" )");
					tag = from == std::string::npos ? std::string() : tag.substr(from, to - from + 1);
				}
			}
			break;
		case 'S':
			if (f.size() >= 5)
			{
				Section s;
				s.book = Int(f[1]);
				s.kind = Int(f[2]);
				s.state = Int(f[3]);
				s.header = Clean(f[4]);
				if (f.size() >= 6)
					s.cutoff = Clean(f[5]);
				model.sections.push_back(std::move(s));
			}
			break;
		case 'E':
			if (f.size() >= 8 && !model.sections.empty())
			{
				Entry e;
				e.uuid = f[1];
				e.status = Int(f[2]);
				e.region = Int(f[3]);
				e.filter = Int(f[4]);
				e.flags = Int(f[5]);
				e.title = Clean(f[6]);
				{
					std::string tip = f[7];
					for (const char* const mark : { "<br/>", "<br />", "<br>" })
						for (size_t at = tip.find(mark); at != std::string::npos; at = tip.find(mark, at + 1))
							tip.replace(at, strlen(mark), "\n");
					e.tip = Clean(tip);
				}
				if (f.size() >= 9)
					e.manual = Int(f[8]);
				if (f.size() >= 10)
					e.gameDone = Int(f[9]) != 0;
				if (f.size() >= 17)
					e.itemTemplate = f[16];
				if (f.size() >= 15)
				{
					e.picture = f[10];
					e.power = Int(f[11]);
					e.faction = Int(f[12]);
					e.cardType = Int(f[13]);
					e.description = Clean(f[14]);
					if (f.size() >= 16)
						for (size_t at = 0; at < f[15].size();)
						{
							size_t comma = f[15].find(',', at);
							if (comma == std::string::npos)
								comma = f[15].size();
							e.effects.push_back(Int(f[15].substr(at, comma - at)));
							at = comma + 1;
						}
				}
				if (f.size() >= 18)
				{
					e.image = f[17];
					// Its line breaks, which Clean would turn into spaces, as the game's bestiary lays it out
					std::string text = f[14];
					for (const char* const mark : { "<br/>", "<br />", "<br>", "^^" })
						for (size_t at; (at = text.find(mark)) != std::string::npos;)
							text.replace(at, strlen(mark), "\x01");
					text = Clean(text);
					for (char& c : text)
						if (c == '\x01')
							c = '\n';
					while (!text.empty() && (text.back() == '\n' || text.back() == ' '))
						text.pop_back();
					e.description = std::move(text);
				}
				if (f.size() >= 19)
					for (size_t at = 0; at < f[18].size();)
					{
						size_t semi = f[18].find(';', at);
						if (semi == std::string::npos)
							semi = f[18].size();
						const std::string one = f[18].substr(at, semi - at);
						const size_t tilde = one.find('~');
						if (tilde != std::string::npos)
							e.weaknesses.push_back({ Clean(one.substr(0, tilde)), one.substr(tilde + 1) });
						at = semi + 1;
					}
				// Its model's template, for the Live Bestiary, kept with / as a path's \ could read as a line break
				if (f.size() >= 20)
				{
					e.creatureTemplate = f[19];
					std::replace(e.creatureTemplate.begin(), e.creatureTemplate.end(), '/', '\\');
				}
				model.sections.back().entries.push_back(std::move(e));
			}
			break;
		default:
			break;
		}
	}
	// A deck reads Leader, Hero, Unit, then anything else, keeping the script's order within each
	if (!model.sections.empty() && model.sections.back().book == kBookGwent)
	{
		const auto rank = [](const Entry& e)
		{
			if (e.picture.empty()) return 4;
			if (e.power < 0) return 0;
			if (e.cardType & 128) return 1;
			return e.cardType & 8 ? 2 : 3;
		};
		auto& entries = model.sections.back().entries;
		std::stable_sort(entries.begin(), entries.end(), [&](const Entry& a, const Entry& b) { return rank(a) < rank(b); });
	}
	return true;
}
