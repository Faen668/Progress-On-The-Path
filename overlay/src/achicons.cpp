// PotP's own achievement icons as lines, and a pack's own pictures through WIC (Windows Imaging Component, part of
// Windows, so nothing new is shipped for it).
#include <windows.h>
#include <wincodec.h>
#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdlib>
#include <map>
#include <mutex>
#include "achicons.h"
#include "gameicons.h"

namespace
{
	struct Builtin { const char* name; const char* path; };
	const Builtin kIcons[] = {
#define X(name, path) { name, path },
#include "achievement_icons.inc"
#undef X
	};

	// SVG path data to lines: M L H V C S Q T A Z, absolute and relative. Curves and arcs become short straight pieces.
	class PathReader
	{
	public:
		explicit PathReader(const char* d) : p(d) {}

		std::vector<IconLine> Read()
		{
			char command = 0;
			for (;;)
			{
				Skip();
				if (!*p)
					break;
				if (isalpha(static_cast<unsigned char>(*p)))
					command = *p++;
				else if (!command)
					break;   // numbers with nothing to go with
				Step(command);
				if (command == 'M')
					command = 'L';
				else if (command == 'm')
					command = 'l';
			}
			Finish(false);
			return std::move(lines);
		}

	private:
		const char* p;
		std::vector<IconLine> lines;
		IconLine now;
		float x = 0, y = 0, startX = 0, startY = 0, controlX = 0, controlY = 0;
		bool haveControl = false;

		void Skip()
		{
			while (*p && (isspace(static_cast<unsigned char>(*p)) || *p == ','))
				++p;
		}

		float Number()
		{
			Skip();
			char* end = nullptr;
			const float v = strtof(p, &end);
			p = end == p ? p + (*p ? 1 : 0) : end;
			return v;
		}

		void Add(float ax, float ay)
		{
			now.points.push_back(ax);
			now.points.push_back(ay);
		}

		void Finish(bool closed)
		{
			if (now.points.size() >= 4)
			{
				now.closed = closed;
				lines.push_back(std::move(now));
			}
			now = IconLine{};
		}

		void Cubic(float x1, float y1, float x2, float y2, float x3, float y3)
		{
			for (int k = 1; k <= 12; ++k)
			{
				const float u = k / 12.f, a = (1 - u) * (1 - u) * (1 - u), b = 3 * (1 - u) * (1 - u) * u, c = 3 * (1 - u) * u * u, e = u * u * u;
				Add(a * x + b * x1 + c * x2 + e * x3, a * y + b * y1 + c * y2 + e * y3);
			}
			x = x3;
			y = y3;
		}

		void Quadratic(float x1, float y1, float x2, float y2)
		{
			for (int k = 1; k <= 10; ++k)
			{
				const float u = k / 10.f;
				Add((1 - u) * (1 - u) * x + 2 * (1 - u) * u * x1 + u * u * x2, (1 - u) * (1 - u) * y + 2 * (1 - u) * u * y1 + u * u * y2);
			}
			x = x2;
			y = y2;
		}

		// SVG's endpoint arc, through its centre (the SVG specification's F.6.5)
		void Arc(float rx, float ry, float turn, bool large, bool sweep, float x2, float y2)
		{
			if (rx == 0 || ry == 0)
			{
				Add(x = x2, y = y2);
				return;
			}
			const float kPi = 3.14159265f;
			const float cp = cosf(turn * kPi / 180), sp = sinf(turn * kPi / 180);
			const float dx = (x - x2) / 2, dy = (y - y2) / 2;
			const float x1p = cp * dx + sp * dy, y1p = -sp * dx + cp * dy;
			rx = fabsf(rx);
			ry = fabsf(ry);
			const float lambda = x1p * x1p / (rx * rx) + y1p * y1p / (ry * ry);
			if (lambda > 1)
			{
				rx *= sqrtf(lambda);
				ry *= sqrtf(lambda);
			}
			const float num = rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p;
			const float den = rx * rx * y1p * y1p + ry * ry * x1p * x1p;
			const float co = sqrtf(den > 0 ? fmaxf(0.f, num / den) : 0.f) * (large == sweep ? -1.f : 1.f);
			const float cxp = co * rx * y1p / ry, cyp = -co * ry * x1p / rx;
			const float cx = cp * cxp - sp * cyp + (x + x2) / 2, cy = sp * cxp + cp * cyp + (y + y2) / 2;
			const auto angle = [](float ux, float uy, float vx, float vy) { return atan2f(ux * vy - uy * vx, ux * vx + uy * vy); };
			const float t1 = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry);
			float dt = angle((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry);
			if (!sweep && dt > 0)
				dt -= 2 * kPi;
			else if (sweep && dt < 0)
				dt += 2 * kPi;
			const int steps = std::max(4, static_cast<int>(fabsf(dt) / (kPi / 16)));
			for (int i = 1; i <= steps; ++i)
			{
				const float t = t1 + dt * i / steps, ex = rx * cosf(t), ey = ry * sinf(t);
				Add(cp * ex - sp * ey + cx, sp * ex + cp * ey + cy);
			}
			x = x2;
			y = y2;
		}

		void Step(char command)
		{
			const bool rel = islower(static_cast<unsigned char>(command)) != 0;
			const float ox = rel ? x : 0, oy = rel ? y : 0;
			switch (toupper(static_cast<unsigned char>(command)))
			{
			case 'M':
			{
				Finish(false);
				x = ox + Number();
				y = oy + Number();
				startX = x;
				startY = y;
				Add(x, y);
				haveControl = false;
				break;
			}
			case 'L': { x = ox + Number(); y = oy + Number(); Add(x, y); haveControl = false; break; }
			case 'H': { x = ox + Number(); Add(x, y); haveControl = false; break; }
			case 'V': { y = oy + Number(); Add(x, y); haveControl = false; break; }
			case 'C':
			case 'S':
			{
				float x1, y1;
				if (toupper(static_cast<unsigned char>(command)) == 'C')
				{
					x1 = ox + Number();
					y1 = oy + Number();
				}
				else
				{
					x1 = haveControl ? 2 * x - controlX : x;
					y1 = haveControl ? 2 * y - controlY : y;
				}
				const float x2 = ox + Number(), y2 = oy + Number(), x3 = ox + Number(), y3 = oy + Number();
				controlX = x2;
				controlY = y2;
				haveControl = true;
				Cubic(x1, y1, x2, y2, x3, y3);
				break;
			}
			case 'Q':
			case 'T':
			{
				float x1, y1;
				if (toupper(static_cast<unsigned char>(command)) == 'Q')
				{
					x1 = ox + Number();
					y1 = oy + Number();
				}
				else
				{
					x1 = haveControl ? 2 * x - controlX : x;
					y1 = haveControl ? 2 * y - controlY : y;
				}
				const float x2 = ox + Number(), y2 = oy + Number();
				controlX = x1;
				controlY = y1;
				haveControl = true;
				Quadratic(x1, y1, x2, y2);
				break;
			}
			case 'A':
			{
				const float rx = Number(), ry = Number(), turn = Number();
				const bool large = Number() != 0, sweep = Number() != 0;
				const float x2 = ox + Number(), y2 = oy + Number();
				Arc(rx, ry, turn, large, sweep, x2, y2);
				haveControl = false;
				break;
			}
			case 'Z':
			{
				Finish(true);
				x = startX;
				y = startY;
				Add(x, y);
				haveControl = false;
				break;
			}
			default:
				Number();   // a command this doesn't know: step past its numbers one at a time
				break;
			}
		}
	};
}

const std::vector<IconLine>* BuiltinAchievementIcon(const std::string& name)
{
	static std::mutex mutex;
	static std::map<std::string, std::vector<IconLine>> made;
	std::lock_guard lock(mutex);
	const auto found = made.find(name);
	if (found != made.end())
		return &found->second;
	for (const Builtin& icon : kIcons)
		if (name == icon.name)
			return &(made[name] = PathReader(icon.path).Read());
	return nullptr;
}

bool ReadPictureFile(const std::wstring& path, unsigned largestSide, GameTexture& out)
{
	const HRESULT init = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
	bool ok = false;
	IWICImagingFactory* factory = nullptr;
	IWICBitmapDecoder* decoder = nullptr;
	IWICBitmapFrameDecode* frame = nullptr;
	IWICBitmapScaler* scaler = nullptr;
	IWICFormatConverter* converter = nullptr;
	do
	{
		if (FAILED(CoCreateInstance(CLSID_WICImagingFactory, nullptr, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&factory))))
			break;
		if (FAILED(factory->CreateDecoderFromFilename(path.c_str(), nullptr, GENERIC_READ, WICDecodeMetadataCacheOnDemand, &decoder)))
			break;
		if (FAILED(decoder->GetFrame(0, &frame)))
			break;
		UINT width = 0, height = 0;
		frame->GetSize(&width, &height);
		if (width == 0 || height == 0 || width > 4096 || height > 4096)
			break;
		IWICBitmapSource* source = frame;
		if (width > largestSide || height > largestSide)
		{
			const double fit = static_cast<double>(largestSide) / std::max(width, height);
			const UINT w = std::max(1u, static_cast<UINT>(width * fit)), h = std::max(1u, static_cast<UINT>(height * fit));
			if (FAILED(factory->CreateBitmapScaler(&scaler)) || FAILED(scaler->Initialize(frame, w, h, WICBitmapInterpolationModeFant)))
				break;
			source = scaler;
			width = w;
			height = h;
		}
		if (FAILED(factory->CreateFormatConverter(&converter))
			|| FAILED(converter->Initialize(source, GUID_WICPixelFormat32bppRGBA, WICBitmapDitherTypeNone, nullptr, 0, WICBitmapPaletteTypeCustom)))
			break;
		out = GameTexture{};
		out.dxgiFormat = 28;   // RGBA8
		out.width = width;
		out.height = height;
		out.rowBytes = width * 4;
		out.rows = height;
		out.pixels.resize(static_cast<size_t>(out.rowBytes) * height);
		ok = SUCCEEDED(converter->CopyPixels(nullptr, out.rowBytes, static_cast<UINT>(out.pixels.size()), out.pixels.data()));
	} while (false);
	if (converter) converter->Release();
	if (scaler) scaler->Release();
	if (frame) frame->Release();
	if (decoder) decoder->Release();
	if (factory) factory->Release();
	if (SUCCEEDED(init))
		CoUninitialize();
	return ok;
}
