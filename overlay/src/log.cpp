#include <windows.h>
#include <cstdarg>
#include <cstdio>
#include <share.h>
#include <mutex>
#include "log.h"

static FILE* g_file;
static std::mutex g_mutex;

void LogInit(void* module)
{
	wchar_t path[MAX_PATH];
	GetModuleFileNameW(static_cast<HMODULE>(module), path, MAX_PATH);
	wchar_t* slash = wcsrchr(path, L'\\');
	if (slash)
		wcscpy_s(slash + 1, MAX_PATH - (slash + 1 - path), L"potp_overlay.log");
	// The last session's log is kept beside it: after a crash, the next launch would otherwise write over it
	wchar_t previous[MAX_PATH];
	wcscpy_s(previous, path);
	if (wchar_t* dot = wcsrchr(previous, L'.'))
		wcscpy_s(dot, MAX_PATH - (dot - previous), L".prev.log");
	MoveFileExW(path, previous, MOVEFILE_REPLACE_EXISTING);
	g_file = _wfsopen(path, L"w", _SH_DENYWR);   // readable while the game runs
}

void Log(const char* fmt, ...)
{
	std::lock_guard lock(g_mutex);
	if (!g_file)
		return;
	SYSTEMTIME t;
	GetLocalTime(&t);
	fprintf(g_file, "%02d:%02d:%02d.%03d [%5lu] ", t.wHour, t.wMinute, t.wSecond, t.wMilliseconds, GetCurrentThreadId());
	va_list args;
	va_start(args, fmt);
	vfprintf(g_file, fmt, args);
	va_end(args);
	fputc('\n', g_file);
	fflush(g_file);
}
