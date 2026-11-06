#include "kills.h"

#include <atomic>
#include <mutex>

namespace
{
	std::mutex g_mutex;
	std::shared_ptr<const KillList> g_list;

	std::vector<std::string> Split(const std::string& text, char by)
	{
		std::vector<std::string> out;
		size_t from = 0;
		for (;;)
		{
			const size_t at = text.find(by, from);
			out.push_back(text.substr(from, at == std::string::npos ? std::string::npos : at - from));
			if (at == std::string::npos)
				return out;
			from = at + 1;
		}
	}

	int Int(const std::string& text)
	{
		return atoi(text.c_str());
	}
}

void KillsTick(const std::string& fromScript, bool answered)
{
	if (!answered || fromScript.empty())
		return;
	auto list = std::make_shared<KillList>();
	// The scripts' \\n reaches here as a backslash and an n
	size_t from = 0;
	while (from <= fromScript.size())
	{
		size_t at = fromScript.find("\\n", from);
		const std::string line = fromScript.substr(from, at == std::string::npos ? std::string::npos : at - from);
		from = at == std::string::npos ? fromScript.size() + 1 : at + 2;
		const std::vector<std::string> f = Split(line, '|');
		if (f.size() < 10 || f[0] != "K")
			continue;
		KillRow row;
		row.pool = Int(f[1]);
		row.category = Int(f[2]);
		row.region = Int(f[3]);
		row.random = Int(f[4]);
		row.count = Int(f[5]);
		row.why = Int(f[6]);
		row.title = f[7];
		row.name = f[8];
		row.how = f[9];
		list->rows.push_back(std::move(row));
	}
	std::lock_guard lock(g_mutex);
	g_list = std::move(list);
}

std::shared_ptr<const KillList> GetKills()
{
	std::lock_guard lock(g_mutex);
	return g_list;
}
