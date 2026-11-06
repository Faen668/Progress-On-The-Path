// The Journal window: a panel over the paused game, in the style of the game's own menus. Drawn
// entirely with ImGui's draw list, in its own space that is scaled and placed at the end, with the
// fonts baked at their final size so the text stays sharp. Procedural surfaces are worked out once.
#include <windows.h>
#include <imgui.h>
#include <imgui_internal.h>
#include <algorithm>
#include <mutex>
#include <memory>
#include <deque>
#include <atomic>
#include <cfloat>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <initializer_list>
#include <map>
#include <set>
#include <string>
#include <vector>
#include "achicons.h"
#include "achievements.h"
#include "customach.h"
#include "log.h"
#include "cardart.h"
#include "gameicons.h"
#include "modelview.h"
#include "overlay.h"
#include "pad.h"
#include <thread>
#include <ctime>
#include "itemmodel.h"
#include "kills.h"
#include "settings.h"
#include "text.h"

namespace
{
	constexpr float kPi = 3.14159265f;
	constexpr float kRefW = 2560.f, kRefH = 1440.f;   // the screen size at which scale 1 draws one to one
	constexpr float kMinW = 1400.f, kMinH = 820.f;    // the panel's own space never gets smaller than this
	constexpr int kTabAchievements = kBookCount;
	constexpr int kTabKills = kBookCount + 1;
	constexpr int kTabSettings = kBookCount + 2;
	constexpr int kTabCount = kBookCount + 3;

	float kW = 1960.f, kH = 1180.f;   // the panel, in its own space, this frame
	float kBottom = 1068.f;           // where the columns end
	constexpr float kTop = 250.f;     // where they start
	float g_k = 1.f;                  // the panel's own space to back buffer pixels

	ImU32 Rgb(int r, int g, int b, int a = 255) { return IM_COL32(r, g, b, a); }

	ImU32 Alpha(ImU32 c, float a)
	{
		const int v = static_cast<int>(((c >> IM_COL32_A_SHIFT) & 0xFF) * std::clamp(a, 0.f, 1.f));
		return (c & ~IM_COL32_A_MASK) | (static_cast<ImU32>(v) << IM_COL32_A_SHIFT);
	}

	ImU32 Mix(ImU32 a, ImU32 b, float t)
	{
		t = std::clamp(t, 0.f, 1.f);
		const auto ch = [&](int s)
		{
			const float x = static_cast<float>((a >> s) & 0xFF), y = static_cast<float>((b >> s) & 0xFF);
			return static_cast<ImU32>(x + (y - x) * t) << s;
		};
		return ch(IM_COL32_R_SHIFT) | ch(IM_COL32_G_SHIFT) | ch(IM_COL32_B_SHIFT) | ch(IM_COL32_A_SHIFT);
	}

	// A colour setting's value as 0xRRGGBB: hex, or one of the five numbered colours the setting offered before it had a picker
	int ColourValue(const std::string& value)
	{
		static const int kOld[5] = { 0xE8E6E3, 0x9DB4FF, 0xFF8A80, 0x7EDC9A, 0xC9A0E8 };
		if (value.size() == 1 && value[0] >= '0' && value[0] <= '4')
			return kOld[value[0] - '0'];
		const char* s = value.c_str() + (value.rfind('#', 0) == 0 ? 1 : 0);
		char* end = nullptr;
		const long rgb = strtol(s, &end, 16);
		return end != s && *end == 0 && rgb >= 0 && rgb <= 0xFFFFFF ? static_cast<int>(rgb) : kOld[1];
	}

	std::string ColourHex(int rgb)
	{
		char text[8];
		snprintf(text, sizeof(text), "%06X", rgb & 0xFFFFFF);
		return text;
	}

	ImU32 RgbOf(int rgb, int a = 255) { return Rgb((rgb >> 16) & 255, (rgb >> 8) & 255, rgb & 255, a); }

	float Hash(int x, int y)
	{
		unsigned h = static_cast<unsigned>(x) * 374761393u + static_cast<unsigned>(y) * 668265263u;
		h = (h ^ (h >> 13)) * 1274126177u;
		return static_cast<float>((h ^ (h >> 16)) & 0xFFFFFF) / 16777216.f;
	}

	float Noise(float x, float y)
	{
		const int xi = static_cast<int>(std::floor(x)), yi = static_cast<int>(std::floor(y));
		float fx = x - xi, fy = y - yi;
		fx = fx * fx * (3 - 2 * fx);
		fy = fy * fy * (3 - 2 * fy);
		const float a = Hash(xi, yi), b = Hash(xi + 1, yi), c = Hash(xi, yi + 1), d = Hash(xi + 1, yi + 1);
		return a + (b - a) * fx + (c - a) * fy + (a - b - c + d) * fx * fy;
	}

	float Fbm(float x, float y, int octaves = 4)
	{
		float sum = 0, amp = 0.5f, norm = 0;
		for (int i = 0; i < octaves; ++i)
		{
			sum += Noise(x, y) * amp;
			norm += amp;
			x = x * 2.03f + 17.3f;
			y = y * 2.03f + 9.1f;
			amp *= 0.5f;
		}
		return sum / norm;
	}

	// Fonts: one bake per size. Cinzel for headings, EB Garamond for reading, Alegreya Sans for small print.
	enum Face { kSans, kSerif, kTitle };
	std::map<std::pair<int, int>, ImFont*> g_fonts;

	ImFont* FontOf(Face face, int size)
	{
		auto it = g_fonts.find({ face, size });
		return it != g_fonts.end() ? it->second : ImGui::GetFont();
	}

	ImVec2 Measure(Face face, int size, const char* s, const char* end = nullptr)
	{
		return FontOf(face, size)->CalcTextSizeA(static_cast<float>(size), FLT_MAX, 0.f, s, end);
	}

	float WrappedHeight(Face face, int size, const char* s, float wrap)
	{
		return FontOf(face, size)->CalcTextSizeA(static_cast<float>(size), FLT_MAX, wrap, s).y;
	}

	ImDrawList* dl;

	void Text(Face face, int size, float x, float y, ImU32 col, const char* s, float wrap = 0.f)
	{
		dl->AddText(FontOf(face, size), static_cast<float>(size), ImVec2(x, y), col, s, nullptr, wrap);
	}

	void TextRight(Face face, int size, float x, float y, ImU32 col, const char* s)
	{
		Text(face, size, x - Measure(face, size, s).x, y, col, s);
	}

	void TextCentre(Face face, int size, float x, float y, ImU32 col, const char* s)
	{
		Text(face, size, x - Measure(face, size, s).x * 0.5f, y, col, s);
	}

	// The middle of what a piece of text actually draws, measured from the font's own pixels, as
	// Completionist's button prompts do: a font's metrics leave capitals sitting off centre.
	std::map<std::string, ImVec2> g_ink;

	ImVec2 InkCentre(Face face, int size, const char* s)
	{
		const std::string key = std::to_string(face) + ":" + std::to_string(size) + ":" + s;
		auto found = g_ink.find(key);
		if (found != g_ink.end())
			return found->second;

		ImFont* font = FontOf(face, size);
		const ImFontAtlas* atlas = font->ContainerAtlas;
		const float scale = static_cast<float>(size) / font->FontSize;
		float minX = FLT_MAX, minY = FLT_MAX, maxX = -FLT_MAX, maxY = -FLT_MAX;
		float pen = 0.f;
		const int width = atlas->TexWidth, height = atlas->TexHeight;
		const bool pixels = width > 0 && height > 0 && (atlas->TexPixelsAlpha8 || atlas->TexPixelsRGBA32);
		for (const char* p = s; *p; ++p)
		{
			const ImFontGlyph* glyph = font->FindGlyph(static_cast<ImWchar>(static_cast<unsigned char>(*p)));
			if (!glyph)
				continue;
			if (glyph->Visible)
			{
				float x0 = glyph->X0, y0 = glyph->Y0, x1 = glyph->X1, y1 = glyph->Y1;
				if (pixels)
				{
					const int left = static_cast<int>(std::lround(glyph->U0 * width)), right = static_cast<int>(std::lround(glyph->U1 * width));
					const int top = static_cast<int>(std::lround(glyph->V0 * height)), bottom = static_cast<int>(std::lround(glyph->V1 * height));
					int inkL = right, inkT = bottom, inkR = left - 1, inkB = top - 1;
					for (int y = top; y < bottom; ++y)
						for (int x = left; x < right; ++x)
						{
							const size_t at = static_cast<size_t>(y) * width + x;
							const unsigned a = atlas->TexPixelsAlpha8 ? atlas->TexPixelsAlpha8[at] : (atlas->TexPixelsRGBA32[at] >> IM_COL32_A_SHIFT) & 0xFF;
							if (a >= 128)
							{
								inkL = std::min(inkL, x);
								inkR = std::max(inkR, x);
								inkT = std::min(inkT, y);
								inkB = std::max(inkB, y);
							}
						}
					if (inkR >= inkL && right > left && bottom > top)
					{
						const float sx = (glyph->X1 - glyph->X0) / (right - left), sy = (glyph->Y1 - glyph->Y0) / (bottom - top);
						x0 = glyph->X0 + (inkL - left) * sx;
						x1 = glyph->X0 + (inkR + 1 - left) * sx;
						y0 = glyph->Y0 + (inkT - top) * sy;
						y1 = glyph->Y0 + (inkB + 1 - top) * sy;
					}
				}
				minX = std::min(minX, pen + x0 * scale);
				maxX = std::max(maxX, pen + x1 * scale);
				minY = std::min(minY, y0 * scale);
				maxY = std::max(maxY, y1 * scale);
			}
			pen += glyph->AdvanceX * scale;
		}
		const ImVec2 middle = minX <= maxX ? ImVec2((minX + maxX) * 0.5f, (minY + maxY) * 0.5f) : ImVec2(pen * 0.5f, size * 0.5f);
		g_ink[key] = middle;
		return middle;
	}

	// Text with the middle of its ink on this point
	void TextOnPoint(Face face, int size, ImVec2 point, ImU32 col, const char* s)
	{
		const ImVec2 ink = InkCentre(face, size, s);
		Text(face, size, point.x - ink.x, point.y - ink.y, col, s);
	}

	// One line, cut short with dots when it won't fit
	void TextFit(Face face, int size, float x, float y, ImU32 col, const std::string& s, float width)
	{
		if (Measure(face, size, s.c_str()).x <= width)
		{
			Text(face, size, x, y, col, s.c_str());
			return;
		}
		const float dots = Measure(face, size, "...").x;
		size_t n = s.size();
		while (n > 0 && Measure(face, size, s.c_str(), s.c_str() + n).x + dots > width)
			--n;
		while (n > 0 && (static_cast<unsigned char>(s[n]) & 0xC0) == 0x80)   // not in the middle of a UTF-8 letter
			--n;
		const std::string cut = s.substr(0, n) + "...";
		Text(face, size, x, y, col, cut.c_str());
	}

	std::string Upper(const std::string& s)
	{
		std::string out = s;
		for (char& c : out)
			if (c >= 'a' && c <= 'z')
				c = static_cast<char>(c - 'a' + 'A');
		return out;
	}

	// A surface worked out once: colours per grid point, drawn as a mesh. The function gets a position in the rectangle.
	struct Surface
	{
		int nx = 0, ny = 0;
		std::vector<ImU32> colours;
	};
	std::map<int, Surface> g_surfaces;

	template <class F>
	void Field(int id, ImVec2 a, ImVec2 b, float cell, F colourAt)
	{
		Surface& s = g_surfaces[id];
		if (s.colours.empty())
		{
			s.nx = std::max(1, static_cast<int>((b.x - a.x) / cell));
			s.ny = std::max(1, static_cast<int>((b.y - a.y) / cell));
			s.colours.resize(static_cast<size_t>(s.nx + 1) * (s.ny + 1));
			for (int j = 0; j <= s.ny; ++j)
				for (int i = 0; i <= s.nx; ++i)
					s.colours[j * (s.nx + 1) + i] = colourAt((b.x - a.x) * i / s.nx, (b.y - a.y) * j / s.ny);
		}
		const float dx = (b.x - a.x) / s.nx, dy = (b.y - a.y) / s.ny;
		for (int j = 0; j < s.ny; ++j)
		{
			const ImU32* up = &s.colours[j * (s.nx + 1)];
			const ImU32* down = up + s.nx + 1;
			for (int i = 0; i < s.nx; ++i)
			{
				if (((up[i] | up[i + 1] | down[i] | down[i + 1]) & IM_COL32_A_MASK) == 0)
					continue;
				const float x0 = a.x + i * dx, y0 = a.y + j * dy;
				dl->AddRectFilledMultiColor(ImVec2(x0, y0), ImVec2(x0 + dx, y0 + dy), up[i], up[i + 1], down[i + 1], down[i]);
			}
		}
	}

	void FadeLineH(float x0, float x1, float y, ImU32 col, float thick = 1.f)
	{
		const float mid = (x0 + x1) * 0.5f;
		const ImU32 clear = Alpha(col, 0.f);
		dl->AddRectFilledMultiColor(ImVec2(x0, y), ImVec2(mid, y + thick), clear, col, col, clear);
		dl->AddRectFilledMultiColor(ImVec2(mid, y), ImVec2(x1, y + thick), col, clear, clear, col);
	}

	void Diamond(ImVec2 c, float r, ImU32 col, bool filled = true, float thick = 1.5f)
	{
		const ImVec2 p[4] = { {c.x, c.y - r}, {c.x + r, c.y}, {c.x, c.y + r}, {c.x - r, c.y} };
		if (filled)
			dl->AddConvexPolyFilled(p, 4, col);
		else
			dl->AddPolyline(p, 4, col, ImDrawFlags_Closed, thick);
	}

	void Tick(ImVec2 c, float s, ImU32 col, float thick)
	{
		const ImVec2 p[3] = { {c.x - s, c.y}, {c.x - s * 0.25f, c.y + s * 0.8f}, {c.x + s * 1.1f, c.y - s * 0.95f} };
		dl->AddPolyline(p, 3, col, ImDrawFlags_None, thick);
	}

	void Cross(ImVec2 c, float s, ImU32 col, float thick)
	{
		dl->AddLine(ImVec2(c.x - s, c.y - s), ImVec2(c.x + s, c.y + s), col, thick);
		dl->AddLine(ImVec2(c.x - s, c.y + s), ImVec2(c.x + s, c.y - s), col, thick);
	}

	// A soft ellipse: strongest in the middle, fading smoothly to nothing
	void SoftGlowOval(ImVec2 c, float rx, float ry, ImU32 col)
	{
		constexpr int kSegments = 28;
		constexpr int kRings = 5;
		const ImVec2 uv = ImGui::GetFontTexUvWhitePixel();
		dl->PrimReserve(kSegments * 3 + kSegments * (kRings - 1) * 6, 1 + kSegments * kRings);
		const ImDrawIdx base = static_cast<ImDrawIdx>(dl->_VtxCurrentIdx);
		dl->PrimWriteVtx(c, uv, col);
		for (int ring = 1; ring <= kRings; ++ring)
		{
			const float t = static_cast<float>(ring) / kRings;
			// A smooth fall-off, with no edge where it ends
			const float fall = (1.f - t) * (1.f - t) * (1.f + 2.f * t);
			const ImU32 ringCol = Alpha(col, fall);
			for (int i = 0; i < kSegments; ++i)
			{
				const float a = 2.f * kPi * i / kSegments;
				dl->PrimWriteVtx(ImVec2(c.x + std::cos(a) * rx * t, c.y + std::sin(a) * ry * t), uv, ringCol);
			}
		}
		const auto ringVertex = [&](int ring, int i) { return static_cast<ImDrawIdx>(base + 1 + (ring - 1) * kSegments + (i % kSegments)); };
		for (int i = 0; i < kSegments; ++i)
		{
			dl->PrimWriteIdx(base);
			dl->PrimWriteIdx(ringVertex(1, i));
			dl->PrimWriteIdx(ringVertex(1, i + 1));
		}
		for (int ring = 1; ring < kRings; ++ring)
			for (int i = 0; i < kSegments; ++i)
			{
				dl->PrimWriteIdx(ringVertex(ring, i));
				dl->PrimWriteIdx(ringVertex(ring + 1, i));
				dl->PrimWriteIdx(ringVertex(ring + 1, i + 1));
				dl->PrimWriteIdx(ringVertex(ring, i));
				dl->PrimWriteIdx(ringVertex(ring + 1, i + 1));
				dl->PrimWriteIdx(ringVertex(ring, i + 1));
			}
	}

	void SoftGlow(ImVec2 c, float r, ImU32 col)
	{
		SoftGlowOval(c, r, r, col);
	}

	// The five signs, one per book, and a cog for the settings: simple line drawings
	void Sign(int which, ImVec2 c, float r, ImU32 col, float t)
	{
		// Each shape's top and bottom, as parts of its radius: centred on those, and sized to one height
		static const float kShapeTop[9] = { -0.5f, -1.f, -1.05f, -1.f, -0.866f, -1.f, -1.f, -1.f, -1.f };
		static const float kShapeBottom[9] = { 1.f, 0.5f, 0.85f, 0.81f, 0.866f, 1.f, 1.f, 1.f, 1.f };
		const int shape = std::clamp(which, 0, 8);
		const float fit = 2.f / (kShapeBottom[shape] - kShapeTop[shape]);
		r *= std::min(fit, 1.2f);
		c.y -= (kShapeTop[shape] + kShapeBottom[shape]) * 0.5f * r;
		const auto at = [&](float deg, float rad)
		{
			const float a = deg * kPi / 180.f;
			return ImVec2(c.x + std::cos(a) * rad * r, c.y + std::sin(a) * rad * r);
		};
		const auto line = [&](ImVec2 a, ImVec2 b) { dl->AddLine(a, b, col, t); };
		switch (which)
		{
		case 0: // Aard
		{
			const ImVec2 p[3] = { at(90, 1), at(210, 1), at(330, 1) };
			dl->AddPolyline(p, 3, col, ImDrawFlags_Closed, t);
			line(at(150, 0.42f), at(30, 0.42f));
			line(at(270, 0.5f), at(90, 0.15f));
			break;
		}
		case 1: // Igni
		{
			const ImVec2 p[3] = { at(270, 1), at(30, 1), at(150, 1) };
			dl->AddPolyline(p, 3, col, ImDrawFlags_Closed, t);
			const ImVec2 q[3] = { at(90, 0.5f), at(320, 0.3f), at(220, 0.3f) };
			dl->AddPolyline(q, 3, col, ImDrawFlags_Closed, t);
			line(at(270, 1), at(270, 0.3f));
			break;
		}
		case 2: // Yrden
		{
			dl->AddCircle(c, r * 0.72f, col, 32, t);
			for (int i = 0; i < 5; ++i)
			{
				const float a = 270.f + i * 72.f;
				line(at(a, 0.72f), at(a, 1.05f));
			}
			const ImVec2 q[3] = { at(270, 0.4f), at(30, 0.4f), at(150, 0.4f) };
			dl->AddPolyline(q, 3, col, ImDrawFlags_Closed, t);
			break;
		}
		case 3: // Quen
		{
			const ImVec2 p[5] = { at(270, 1), at(342, 1), at(54, 1), at(126, 1), at(198, 1) };
			dl->AddPolyline(p, 5, col, ImDrawFlags_Closed, t);
			line(at(90, 0.8f), c);
			line(c, at(330, 0.62f));
			line(c, at(210, 0.62f));
			break;
		}
		case 4: // Axii
		{
			const ImVec2 p[3] = { at(240, 1), at(300, 1), c };
			dl->AddPolyline(p, 3, col, ImDrawFlags_Closed, t);
			const ImVec2 q[3] = { at(60, 1), at(120, 1), c };
			dl->AddPolyline(q, 3, col, ImDrawFlags_Closed, t);
			line(at(180, 0.85f), at(0, 0.85f));
			break;
		}
		case 8: // Two crossed swords
		{
			for (int side = -1; side <= 1; side += 2)
			{
				const float s = static_cast<float>(side);
				const ImVec2 tip(c.x + s * r * 0.86f, c.y - r * 0.92f), hilt(c.x - s * r * 0.62f, c.y + r * 0.62f), pommel(c.x - s * r * 0.86f, c.y + r * 0.92f);
				dl->AddLine(tip, hilt, col, t);
				dl->AddLine(hilt, pommel, col, t);
				dl->AddLine(ImVec2(hilt.x - r * 0.24f, hilt.y - s * r * 0.24f), ImVec2(hilt.x + r * 0.24f, hilt.y + s * r * 0.24f), col, t);
			}
			break;
		}
		case 7: // Claw marks across a circle
		{
			dl->AddCircle(c, r, col, 40, t);
			for (int i = -1; i <= 1; ++i)
			{
				const float dx = i * 0.38f;
				const ImVec2 top(c.x + r * (dx + 0.28f), c.y - r * 0.68f), bottom(c.x + r * (dx - 0.28f), c.y + r * 0.68f);
				const ImVec2 bend(c.x + r * (dx + 0.12f), c.y + r * 0.1f);
				dl->AddBezierQuadratic(top, bend, bottom, col, t);
			}
			break;
		}
		case 6: // A medal on its ribbon
		{
			const ImVec2 m(c.x, c.y + r * 0.34f);
			dl->AddCircle(m, r * 0.66f, col, 32, t);
			ImVec2 star[10];
			for (int i = 0; i < 10; ++i)
			{
				const float a = (270.f + i * 36.f) * kPi / 180.f;
				const float rad = r * (i % 2 == 0 ? 0.42f : 0.17f);
				star[i] = ImVec2(m.x + std::cos(a) * rad, m.y + std::sin(a) * rad);
			}
			dl->AddPolyline(star, 10, col, ImDrawFlags_Closed, t);
			line(ImVec2(c.x - r * 0.62f, c.y - r), ImVec2(c.x - r * 0.2f, c.y - r * 0.26f));
			line(ImVec2(c.x + r * 0.62f, c.y - r), ImVec2(c.x + r * 0.2f, c.y - r * 0.26f));
			line(ImVec2(c.x - r * 0.62f, c.y - r), ImVec2(c.x + r * 0.62f, c.y - r));
			break;
		}
		default: // A cog
		{
			dl->AddCircle(c, r * 0.68f, col, 32, t);
			dl->AddCircle(c, r * 0.26f, col, 18, t);
			for (int i = 0; i < 8; ++i)
			{
				const float a = i * 45.f;
				line(at(a - 7, 0.68f), at(a - 5, 1.f));
				line(at(a - 5, 1.f), at(a + 5, 1.f));
				line(at(a + 5, 1.f), at(a + 7, 0.68f));
			}
			break;
		}
		}
	}

	// Palette: the game's menus
	const ImU32 kGold = Rgb(171, 137, 82), kGoldDim = Rgb(92, 72, 44), kGoldHi = Rgb(232, 204, 146);
	const ImU32 kText = Rgb(228, 220, 204), kDim = Rgb(150, 142, 126), kHead = Rgb(232, 220, 194);
	const ImU32 kDoneText = Rgb(142, 154, 124), kGreen = Rgb(128, 196, 100), kAmber = Rgb(232, 178, 70), kRed = Rgb(226, 70, 44), kOrange = Rgb(226, 150, 60);
	const ImU32 kInk = Rgb(34, 24, 10);

	struct BookInfo { TextId caps; TextId name; int sign; };
	const BookInfo kBooks[kTabCount] = {
		{ T_tab_quests_caps, T_tab_quests, 3 },
		{ T_tab_world_caps, T_tab_world, 2 },
		{ T_tab_items_caps, T_tab_items, 1 },
		{ T_tab_gwent_caps, T_tab_gwent, 4 },
		{ T_tab_missable_caps, T_tab_missable, 0 },
		{ T_tab_bestiary_caps, T_tab_bestiary, 7 },
		{ T_tab_achievements_caps, T_tab_achievements, 6 },
		{ T_tab_kills_caps, T_tab_kills, 8 },
		{ T_tab_settings_caps, T_tab_settings, 5 },
	};
	const TextId kKinds[3] = { T_part_0, T_part_1, T_part_2 };
	void BookSign(int book, ImVec2 c, float r, ImU32 col, float t, bool shadow = true);   // the book's sign, as a shaded picture
	struct BookArt;
	const BookArt* BookPicture(int book);   // null where there's no picture of it, or not yet

	// Window state
	struct Row { int section; int entry; float y, h; int part = -1; };   // part: this header starts a part of the Missable tab   // entry -1: the section's header

	int g_book = 0;
	ULONGLONG g_achievementsNextAsk = 0;   // when the Achievements tab next reads them
	ULONGLONG g_killsNextAsk = 0;
	int g_region = 0;   // 0 all
	float g_scroll = 0.f, g_scrollShown = 0.f;
	std::string g_selected[kTabCount];
	std::map<std::string, bool> g_open;    // section header -> open, per book
	std::string g_focusHeader;
	bool g_freeScrolled = false;   // the list was moved by the right stick or mouse, not by the selection
	bool g_followSelection = false;
	// The entry a step of the guided tour shows: selected, its section opened, and shown even if the game hasn't got it yet.
	// What was selected before comes back when the step ends.
	std::string g_tourEntry, g_tourEntryWas;
	int g_tourEntryBook = -1;
	bool g_tourEntrySet = false;
	bool g_wasOpen = false;
	bool g_dragging = false;
	std::vector<Row> g_rows;
	float g_openT = 0.f;      // 0 to 1 as the panel appears
	float g_barT = 0.f;       // 0 to 1 as the bars of the page fill
	float g_wholeBarT = 0.f;  // the same for the whole path's bar, which only fills as the window opens
	float g_tabShown = 0.f;   // the gold tab, sliding to the book that's open
	float g_dt = 0.016f;
	int g_surfaceW = 0, g_surfaceH = 0, g_surfaceOpacity = 0;
	bool g_saveSoon = false;
	double g_saveAt = 0.0;

	// Settings page
	int g_setFocus = 0;
	bool g_capture = false;      // waiting for a key to bind
	bool g_captureUpdate = false;   // the full update key, not the one that opens the window
	double g_captureUntil = 0.0;
	bool g_setEditing = false;   // inside a slider or choice: left and right change it
	// A colour setting's picker, open over its page (g_setEditing is on while it is, so Back closes it).
	// The colour only goes to the mod on Done; Back leaves it as it was.
	struct ColourPicker
	{
		bool open = false;
		int var = -1;                 // the setting, in its page's vars
		int original = 0, current = 0, fallback = -1;   // 0xRRGGBB; fallback -1: no default to go back to
		float hue = 0.f;              // kept apart from the colour, so greys and black don't lose it
		int focus = 0;                // 0-19 the swatches, 20-22 the bars, 23 Done, 24 Default
		int drag = -1;                // the bar being dragged with the mouse
	};
	ColourPicker g_picker;
	int g_setPage = 0;           // 0 the window's own settings, then each page of the mod's
	std::vector<ModPage> g_pages;   // an editable copy of the game's values
	const Model* g_pagesFrom = nullptr;
	bool g_modDirty = false;     // a mod setting changed: the mod is told when the window closes
	bool g_placing = false;      // moving the notification: the window steps aside
	int g_tour = -2;             // the guided tour: -2 not up, -1 being offered, else the step
	bool g_tourOpenedWardrobe = false;
	bool g_wardReveal = false;    // bring the selected row into view
	float g_wardOutfitTop = 0.f;  // where the wardrobe's saved outfits start
	bool g_tourAsked = false;    // Settings asks for it, once this frame's drawing is done
	float g_placeFromX = 0.f, g_placeFromY = 1.f;
	bool g_statusOpen = false;   // the Change Status panel is up, and has the input
	bool g_visibilityOpen = false;   // that input is the Change Visibility panel's instead
	int g_visibilityFocus = 0;
	bool g_modalBlock = false;   // nothing behind that panel reacts to the mouse
	int g_statusFocus = 0;
	float g_statusT = 0.f;       // 0 to 1 as it appears
	int g_modFocus = 0;
	float g_modScroll = 0.f, g_modScrollShown = 0.f;
	bool g_modFreeScrolled = false;   // the page was moved by the right stick or mouse, not by the selection
	bool g_backConsumed = false; // this frame's Circle/B has been used to leave a control
	int g_dragSlider = -1;
	float g_pendingScale = -1.f;
	double g_scaleCommitAt = 0.0;

	// Input, gathered once a frame
	PadState g_pad;
	bool g_padMode = false;       // the controller was the last thing touched: the cursor hides until the mouse moves
	bool g_padPrompts = false;    // which prompts to draw
	ImVec2 g_mouse;
	ImVec2 g_mouseScale(1.f, 1.f);
	bool g_clicked = false;
	float g_wheel = 0.f;
	bool g_navUp = false, g_navDown = false, g_navLeft = false, g_navRight = false, g_navPageUp = false, g_navPageDown = false, g_navAccept = false;

	void DrawCursor();
	bool g_wardrobeOpen = false;   // the wardrobe's panel is up in place of the Items tab

	void MarkDirty()
	{
		g_saveSoon = true;
		g_saveAt = ImGui::GetTime() + 0.8;
	}

	bool Hover(ImVec2 a, ImVec2 b)
	{
		return !g_padMode && !g_modalBlock && g_mouse.x >= a.x && g_mouse.x < b.x && g_mouse.y >= a.y && g_mouse.y < b.y;
	}

	bool Clicked(ImVec2 a, ImVec2 b)
	{
		return g_clicked && Hover(a, b);
	}

	// One setting of the mod's: the scripts' settings map is told at once (and saved from there), the mod when the window closes
	void SendValue(const ModPage& page, const ModVar& v)
	{
		RequestExec("potpoverlay_setvar(" + page.id + ", " + v.id + ", " + v.value + ")", false);
		g_modDirty = true;
	}

	// A fresh model brings the game's values
	void SyncPages(const Model* model)
	{
		if (model != g_pagesFrom)
		{
			g_pagesFrom = model;
			g_pages = model ? model->pages : std::vector<ModPage>{};
		}
	}

	void SetBook(int book)
	{
		book = (book + kTabCount) % kTabCount;
		if (book == g_book)
			return;
		g_book = book;
		g_achievementsNextAsk = 0;
		g_killsNextAsk = 0;
		g_region = 0;
		g_scroll = g_scrollShown = 0;
		g_followSelection = true;
		g_focusHeader.clear();
		g_barT = 0.f;
		g_capture = false;
		g_setEditing = false;
		g_freeScrolled = false;
		GetSettings().lastBook = book;
		MarkDirty();
	}

	int PadStyleNow()
	{
		const int style = GetSettings().padStyle;
		return style == kPadAuto ? PadDetectedStyle() : style;
	}

	// ------------------------------------------------------------------------------------------
	// Prompts: keycaps like the game's own, and Completionist's controller buttons
	// ------------------------------------------------------------------------------------------

	float KeyCap(float x, float y, float h, const char* label, bool draw, bool hot = false)
	{
		const float w = std::max(h, Measure(kSans, 24, label).x + 22.f);
		if (draw)
		{
			const ImVec2 a(x, y), b(x + w, y + h);
			dl->AddRectFilled(ImVec2(a.x + 1, a.y + 3), ImVec2(b.x + 1, b.y + 3), Rgb(0, 0, 0, 130), 7.f);
			dl->AddRectFilledMultiColor(a, b, Rgb(34, 31, 27, 240), Rgb(34, 31, 27, 240), Rgb(18, 16, 14, 240), Rgb(18, 16, 14, 240));
			dl->AddRect(a, b, hot ? kGoldHi : Rgb(92, 86, 74), 7.f, 0, 1.8f);
			dl->AddRect(ImVec2(a.x + 3, a.y + 3), ImVec2(b.x - 3, b.y - 3), Rgb(255, 255, 255, 18), 5.f, 0, 1.f);
			TextOnPoint(kSans, 24, ImVec2(x + w * 0.5f, y + h * 0.5f), Rgb(226, 220, 206), label);
		}
		return w;
	}

	const char* PadName(unsigned b, int style)
	{
		struct Names { const char* start, * back, * ls, * rs, * lb, * rb, * lt, * rt, * a, * bb, * x, * y; };
		static const Names xbox{ "Menu", "View", "LS", "RS", "LB", "RB", "LT", "RT", "A", "B", "X", "Y" };
		static const Names ps{ "Options", "Touchpad", "L3", "R3", "L1", "R1", "L2", "R2", "", "", "", "" };
		static const Names sw{ "+", "-", "LS", "RS", "L", "R", "ZL", "ZR", "B", "A", "Y", "X" };
		static const Names deck{ "Menu", "View", "L3", "R3", "L1", "R1", "L2", "R2", "A", "B", "X", "Y" };
		const Names& n = style == kPadPlayStation ? ps : style == kPadSwitch ? sw : style == kPadSteamDeck ? deck : xbox;
		switch (b)
		{
		case kPadStart: return n.start;
		case kPadBack: return n.back;
		case kPadL3: return n.ls;
		case kPadR3: return n.rs;
		case kPadLB: return n.lb;
		case kPadRB: return n.rb;
		case kPadLT: return n.lt;
		case kPadRT: return n.rt;
		case kPadA: return n.a;
		case kPadB: return n.bb;
		case kPadX: return n.x;
		case kPadY: return n.y;
		case kPadUp: return Tx(T_dir_up);
		case kPadDown: return Tx(T_dir_down);
		case kPadLeft: return Tx(T_dir_left);
		case kPadRight: return Tx(T_dir_right);
		default: return "?";
		}
	}

	bool IsFace(unsigned b) { return b == kPadA || b == kPadB || b == kPadX || b == kPadY; }

	// Width of the button; drawn when asked
	float PadGlyph(float x, float y, float h, unsigned b, bool draw, int style)
	{
		// A stick to move: a round cap with its side's letter and an arrow out each way
		if (b == kPadLStick || b == kPadRStick)
		{
			if (draw)
			{
				const ImVec2 c(x + h * 0.5f, y + h * 0.5f);
				const float r = h * 0.5f - 1.f;
				dl->AddCircleFilled(ImVec2(c.x, c.y + 2.f), r, Rgb(0, 0, 0, 130), 36);
				dl->AddCircleFilled(c, r, Rgb(26, 24, 21, 240), 36);
				dl->AddCircle(c, r - 0.5f, Rgb(186, 178, 160), 36, 2.2f);
				dl->AddCircle(c, r * 0.5f, Rgb(120, 114, 100), 24, 1.6f);
				const ImU32 arrow = Rgb(238, 232, 218);
				const float tip = r * 0.86f, base = r * 0.66f, half = r * 0.14f;
				dl->AddTriangleFilled(ImVec2(c.x, c.y - tip), ImVec2(c.x - half, c.y - base), ImVec2(c.x + half, c.y - base), arrow);
				dl->AddTriangleFilled(ImVec2(c.x, c.y + tip), ImVec2(c.x + half, c.y + base), ImVec2(c.x - half, c.y + base), arrow);
				dl->AddTriangleFilled(ImVec2(c.x - tip, c.y), ImVec2(c.x - base, c.y + half), ImVec2(c.x - base, c.y - half), arrow);
				dl->AddTriangleFilled(ImVec2(c.x + tip, c.y), ImVec2(c.x + base, c.y - half), ImVec2(c.x + base, c.y + half), arrow);
				TextOnPoint(kSans, 18, c, arrow, b == kPadLStick ? "L" : "R");
			}
			return h;
		}
		const bool dpad = b == kPadUp || b == kPadDown || b == kPadLeft || b == kPadRight;
		if (dpad)
		{
			if (draw)
			{
				// An arrow on a button, matching the bumpers beside it
				const ImVec2 p0(x, y), p1(x + h, y + h), c(x + h * 0.5f, y + h * 0.5f);
				const float round = h * 0.34f, t = h * 0.2f;
				dl->AddRectFilledMultiColor(p0, p1, Rgb(40, 37, 32, 235), Rgb(40, 37, 32, 235), Rgb(20, 18, 15, 235), Rgb(20, 18, 15, 235));
				dl->AddRect(p0, p1, Rgb(14, 12, 10), round, 0, 4.f);
				dl->AddRect(p0, p1, Rgb(186, 178, 160), round, 0, 2.f);
				const ImU32 arrow = Rgb(238, 232, 218);
				if (b == kPadLeft)
					dl->AddTriangleFilled(ImVec2(c.x - t, c.y), ImVec2(c.x + t * 0.7f, c.y + t), ImVec2(c.x + t * 0.7f, c.y - t), arrow);
				else if (b == kPadRight)
					dl->AddTriangleFilled(ImVec2(c.x + t, c.y), ImVec2(c.x - t * 0.7f, c.y - t), ImVec2(c.x - t * 0.7f, c.y + t), arrow);
				else if (b == kPadUp)
					dl->AddTriangleFilled(ImVec2(c.x, c.y - t), ImVec2(c.x + t, c.y + t * 0.7f), ImVec2(c.x - t, c.y + t * 0.7f), arrow);
				else
					dl->AddTriangleFilled(ImVec2(c.x, c.y + t), ImVec2(c.x - t, c.y - t * 0.7f), ImVec2(c.x + t, c.y - t * 0.7f), arrow);
			}
			return h;
		}

		if (!IsFace(b))
		{
			const char* name = PadName(b, style);
			const float w = std::max(h * 1.3f, Measure(kSans, 22, name).x + 24.f);
			if (draw)
			{
				const ImVec2 a(x, y), c(x + w, y + h);
				const float round = h * 0.34f;
				dl->AddRectFilledMultiColor(a, c, Rgb(40, 37, 32, 235), Rgb(40, 37, 32, 235), Rgb(20, 18, 15, 235), Rgb(20, 18, 15, 235));
				dl->AddRect(a, c, Rgb(14, 12, 10), round, 0, 4.f);
				dl->AddRect(a, c, Rgb(186, 178, 160), round, 0, 2.f);
				const ImVec2 middle(x + w * 0.5f, y + h * 0.5f);
				if (name[0] == '+' || name[0] == '-')
				{
					// Switch's plus and minus, drawn so they sit in the middle
					const float len = h * 0.2f;
					dl->AddLine(ImVec2(middle.x - len, middle.y), ImVec2(middle.x + len, middle.y), Rgb(240, 234, 220), 2.4f);
					if (name[0] == '+')
						dl->AddLine(ImVec2(middle.x, middle.y - len), ImVec2(middle.x, middle.y + len), Rgb(240, 234, 220), 2.4f);
				}
				else
				{
					TextOnPoint(kSans, 22, middle, Rgb(238, 232, 218), name);
				}
			}
			return w;
		}

		if (!draw)
			return h;
		const ImVec2 c(x + h * 0.5f, y + h * 0.5f);
		const float r = h * 0.5f - 1.f;
		// The colours each pad's face buttons really have: Xbox's letters, PlayStation's symbols, plain for the rest
		ImU32 tint = Rgb(232, 226, 212);
		if (style == kPadXbox)
			tint = b == kPadA ? Rgb(126, 208, 92) : b == kPadB ? Rgb(236, 92, 76) : b == kPadX ? Rgb(96, 150, 240) : Rgb(244, 202, 76);
		else if (style == kPadPlayStation)
			tint = b == kPadA ? Rgb(120, 150, 230) : b == kPadB ? Rgb(226, 90, 86) : b == kPadX ? Rgb(210, 120, 180) : Rgb(100, 196, 170);
		dl->AddCircleFilled(ImVec2(c.x, c.y + 2.f), r, Rgb(0, 0, 0, 130), 36);
		dl->AddCircleFilled(c, r, Rgb(26, 24, 21, 240), 36);
		dl->AddCircle(c, r - 0.5f, style == kPadPlayStation ? tint : Mix(tint, Rgb(120, 114, 100), 0.45f), 36, 2.2f);
		if (style != kPadPlayStation)
		{
			// Letters drawn as shapes, as PlayStation's symbols are, so they sit exactly in the middle
			const float e = r * 0.5f;
			const float t = 2.6f;
			const char letter = PadName(b, style)[0];
			switch (letter)
			{
			case 'A':
			{
				const ImVec2 p[3] = { {c.x - e * 0.82f, c.y + e}, {c.x, c.y - e}, {c.x + e * 0.82f, c.y + e} };
				dl->AddPolyline(p, 3, tint, ImDrawFlags_None, t);
				dl->AddLine(ImVec2(c.x - e * 0.5f, c.y + e * 0.28f), ImVec2(c.x + e * 0.5f, c.y + e * 0.28f), tint, t);
				break;
			}
			case 'B':
			{
				const float left = c.x - e * 0.62f, bowl = c.x + e * 0.12f, radius = e * 0.5f;
				dl->AddLine(ImVec2(left, c.y - e), ImVec2(left, c.y + e), tint, t);
				for (int part = 0; part < 2; ++part)
				{
					const float top = c.y - e + part * e;
					dl->PathClear();
					dl->PathLineTo(ImVec2(left, top));
					dl->PathArcTo(ImVec2(bowl, top + radius), radius, -kPi * 0.5f, kPi * 0.5f, 12);
					dl->PathLineTo(ImVec2(left, top + e));
					dl->PathStroke(tint, ImDrawFlags_None, t);
				}
				break;
			}
			case 'X':
				dl->AddLine(ImVec2(c.x - e * 0.76f, c.y - e), ImVec2(c.x + e * 0.76f, c.y + e), tint, t);
				dl->AddLine(ImVec2(c.x - e * 0.76f, c.y + e), ImVec2(c.x + e * 0.76f, c.y - e), tint, t);
				break;
			default:   // Y
				dl->AddLine(ImVec2(c.x - e * 0.76f, c.y - e), ImVec2(c.x, c.y + e * 0.05f), tint, t);
				dl->AddLine(ImVec2(c.x + e * 0.76f, c.y - e), ImVec2(c.x, c.y + e * 0.05f), tint, t);
				dl->AddLine(ImVec2(c.x, c.y + e * 0.05f), ImVec2(c.x, c.y + e), tint, t);
				break;
			}
			return h;
		}
		const float s = r * 0.48f;
		switch (b)
		{
		case kPadA:
			dl->AddLine(ImVec2(c.x - s, c.y - s), ImVec2(c.x + s, c.y + s), tint, 2.2f);
			dl->AddLine(ImVec2(c.x - s, c.y + s), ImVec2(c.x + s, c.y - s), tint, 2.2f);
			break;
		case kPadB:
			dl->AddCircle(c, s * 1.05f, tint, 20, 2.2f);
			break;
		case kPadX:
			dl->AddRect(ImVec2(c.x - s * 0.9f, c.y - s * 0.9f), ImVec2(c.x + s * 0.9f, c.y + s * 0.9f), tint, 0.f, 0, 2.2f);
			break;
		default:
			dl->AddTriangle(ImVec2(c.x, c.y - s * 1.05f), ImVec2(c.x + s * 1.05f, c.y + s * 0.75f), ImVec2(c.x - s * 1.05f, c.y + s * 0.75f), tint, 2.2f);
			break;
		}
		return h;
	}

	// The buttons in a mask, in a sensible order
	std::vector<unsigned> MaskButtons(unsigned mask)
	{
		static const unsigned order[] = { kPadLStick, kPadRStick, kPadLB, kPadRB, kPadLT, kPadRT, kPadL3, kPadR3, kPadBack, kPadStart, kPadA, kPadB, kPadX, kPadY, kPadUp, kPadDown, kPadLeft, kPadRight };
		std::vector<unsigned> out;
		for (unsigned b : order)
			if (mask & b)
				out.push_back(b);
		return out;
	}

	// ------------------------------------------------------------------------------------------
	// Letter keys go by where they sit on the keyboard, as the game's own layouts do.
	// The key in Q's place is A on AZERTY, and that's the name the prompts show.
	// ------------------------------------------------------------------------------------------
	enum PlaceKey { kKeyQ, kKeyE, kKeyR, kKeyT, kKeyA, kKeyS, kKeyD, kKeyF, kKeyG, kKeyH, kKeyZ, kKeyX, kKeyC, kKeyCount };
	constexpr UINT kKeyScans[kKeyCount] = { 0x10, 0x12, 0x13, 0x14, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x23, 0x2C, 0x2D, 0x2E };
	constexpr const char* kKeyUs[kKeyCount] = { "Q", "E", "R", "T", "A", "S", "D", "F", "G", "H", "Z", "X", "C" };
	ImGuiKey g_keyImGui[kKeyCount] = { ImGuiKey_Q, ImGuiKey_E, ImGuiKey_R, ImGuiKey_T, ImGuiKey_A, ImGuiKey_S, ImGuiKey_D, ImGuiKey_F, ImGuiKey_G, ImGuiKey_H, ImGuiKey_Z, ImGuiKey_X, ImGuiKey_C };
	std::string g_keyLabels[kKeyCount] = { "Q", "E", "R", "T", "A", "S", "D", "F", "G", "H", "Z", "X", "C" };
	std::string g_keyTabs = "Q / E", g_keyPages = "A / D";
	HKL g_keyLayout = nullptr;

	ImGuiKey VkToImGuiKey(UINT vk)
	{
		if (vk >= 'A' && vk <= 'Z')
			return static_cast<ImGuiKey>(ImGuiKey_A + (vk - 'A'));
		if (vk >= '0' && vk <= '9')
			return static_cast<ImGuiKey>(ImGuiKey_0 + (vk - '0'));
		switch (vk)
		{
		case VK_OEM_1: return ImGuiKey_Semicolon;
		case VK_OEM_PLUS: return ImGuiKey_Equal;
		case VK_OEM_COMMA: return ImGuiKey_Comma;
		case VK_OEM_MINUS: return ImGuiKey_Minus;
		case VK_OEM_PERIOD: return ImGuiKey_Period;
		case VK_OEM_2: return ImGuiKey_Slash;
		case VK_OEM_3: return ImGuiKey_GraveAccent;
		case VK_OEM_4: return ImGuiKey_LeftBracket;
		case VK_OEM_5: return ImGuiKey_Backslash;
		case VK_OEM_6: return ImGuiKey_RightBracket;
		case VK_OEM_7: return ImGuiKey_Apostrophe;
		default: return ImGuiKey_None;
		}
	}

	std::string KeyLabelFor(UINT vk, HKL layout)
	{
		// A Latin letter where the key has one: keyboards in other alphabets print those too, and the font may not have theirs
		if (vk >= 'A' && vk <= 'Z')
		{
			const UINT ch = MapVirtualKeyExW(vk, MAPVK_VK_TO_CHAR, layout) & 0x7FFFFFFF;
			if (ch == 0 || ch >= 0x80)
				return std::string(1, static_cast<char>(vk));
		}
		const wchar_t wide[2] = { static_cast<wchar_t>(towupper(static_cast<wint_t>(MapVirtualKeyExW(vk, MAPVK_VK_TO_CHAR, layout) & 0x7FFFFFFF))), 0 };
		char utf8[8] = "";
		WideCharToMultiByte(CP_UTF8, 0, wide, -1, utf8, sizeof(utf8), nullptr, nullptr);
		return utf8;
	}

	void RefreshKeys()
	{
		const DWORD thread = InputWindowThread();
		const HKL layout = GetKeyboardLayout(thread);
		if (layout == g_keyLayout)
			return;
		g_keyLayout = layout;
		for (int i = 0; i < kKeyCount; ++i)
		{
			UINT vk = MapVirtualKeyExW(kKeyScans[i], MAPVK_VSC_TO_VK, layout);
#ifdef POTP_OVERLAY_TEST
			// POTP_TEST_AZERTY: this PC's layout has no French keys to test with
			if (getenv("POTP_TEST_AZERTY") && getenv("POTP_TEST_AZERTY")[0] == 0x31)
				vk = vk == 'Q' ? 'A' : vk == 'A' ? 'Q' : vk == 'Z' ? 'W' : vk;
#endif
			const ImGuiKey key = VkToImGuiKey(vk);
			const std::string label = key == ImGuiKey_None ? std::string() : KeyLabelFor(vk, layout);
			g_keyImGui[i] = key != ImGuiKey_None ? key : VkToImGuiKey(kKeyUs[i][0]);
			g_keyLabels[i] = label.empty() ? kKeyUs[i] : label;
		}
		g_keyTabs = g_keyLabels[kKeyQ] + " / " + g_keyLabels[kKeyE];
		g_keyPages = g_keyLabels[kKeyA] + " / " + g_keyLabels[kKeyD];
	}

	bool KeyHit(PlaceKey key)
	{
		return ImGui::IsKeyPressed(g_keyImGui[key], false);
	}

	bool KeyHeld(PlaceKey key)
	{
		return ImGui::IsKeyDown(g_keyImGui[key]);
	}

	const char* KeyLabel(PlaceKey key)
	{
		return g_keyLabels[key].c_str();
	}

	// A button's name for a sentence. PlayStation's face buttons are shapes, drawn in the prompts.
	std::string PadWord(unsigned button)
	{
		const int style = PadStyleNow();
		if (style == kPadPlayStation)
		{
			switch (button)
			{
			case kPadA: return Tx(T_pad_cross);
			case kPadB: return Tx(T_pad_circle);
			case kPadX: return Tx(T_pad_square);
			case kPadY: return Tx(T_pad_triangle);
			default: break;
			}
		}
		return PadName(button, style);
	}

	// Text naming controls: each [name] becomes the key or button for what's in use
	std::string TxKeys(TextId id)
	{
		struct Control { const char* token; PlaceKey key; unsigned button; const char* fixed; };
		const Control controls[] = {
			{ "[prev]", kKeyQ, kPadLB, nullptr },
			{ "[next]", kKeyE, kPadRB, nullptr },
			{ "[left]", kKeyA, kPadLT, nullptr },
			{ "[right]", kKeyD, kPadRT, nullptr },
			{ "[toggle]", kKeyC, kPadY, nullptr },
			{ "[status]", kKeyF, kPadX, nullptr },
			{ "[vis]", kKeyH, kPadStart, nullptr },
			{ "[zoom]", kKeyZ, kPadR3, nullptr },
			{ "[wardrobe]", kKeyG, kPadL3, nullptr },
			{ "[save]", kKeyS, kPadX, nullptr },
			{ "[clear]", kKeyX, kPadY, nullptr },
			{ "[accept]", kKeyCount, kPadA, Tx(T_key_enter) },
			{ "[back]", kKeyCount, kPadB, Tx(T_key_esc) },
		};
		std::string text = Tx(id);
		for (const Control& c : controls)
		{
			const std::string name = g_padPrompts ? PadWord(c.button) : c.fixed ? c.fixed : g_keyLabels[c.key];
			const std::string token = c.token;
			for (size_t at = text.find(token); at != std::string::npos; at = text.find(token, at + name.size()))
				text.replace(at, token.size(), name);
		}
		return text;
	}

	std::string KeyName(unsigned vk)
	{
		switch (vk)
		{
		case VK_HOME: return Tx(T_key_home);
		case VK_END: return Tx(T_key_end);
		case VK_INSERT: return Tx(T_key_insert);
		case VK_DELETE: return Tx(T_key_delete);
		case VK_PRIOR: return Tx(T_key_page_up);
		case VK_NEXT: return Tx(T_key_page_down);
		case VK_LEFT: return Tx(T_dir_left);
		case VK_RIGHT: return Tx(T_dir_right);
		case VK_UP: return Tx(T_dir_up);
		case VK_DOWN: return Tx(T_dir_down);
		case VK_PAUSE: return Tx(T_key_pause);
		case VK_SNAPSHOT: return Tx(T_key_print_screen);
		case VK_NUMLOCK: return Tx(T_key_num_lock);
		case VK_DIVIDE: return "Num /";
		case VK_RCONTROL: return Tx(T_key_right_ctrl);
		case VK_RMENU: return Tx(T_key_right_alt);
		case VK_LWIN: return Tx(T_key_left_win);
		case VK_RWIN: return Tx(T_key_right_win);
		case VK_APPS: return Tx(T_key_menu);
		default: break;
		}
		if (vk >= VK_F1 && vk <= VK_F24)
			return "F" + std::to_string(vk - VK_F1 + 1);
		char name[64] = "";
		const UINT scan = MapVirtualKeyA(vk, MAPVK_VK_TO_VSC);
		if (scan != 0 && GetKeyNameTextA(static_cast<LONG>(scan) << 16, name, sizeof(name)) > 0)
			return name;
		snprintf(name, sizeof(name), "%s", TxFill(T_key_number, std::to_string(vk)).c_str());
		return name;
	}

	// ------------------------------------------------------------------------------------------
	// Lists
	// ------------------------------------------------------------------------------------------

	bool SectionOpen(const Section& s, int index, int firstVisible)
	{
		const std::string key = std::to_string(s.book) + s.header;
		auto it = g_open.find(key);
		return it != g_open.end() ? it->second : index == firstVisible;
	}

	void SetSectionOpen(const Section& s, bool open)
	{
		g_open[std::to_string(s.book) + s.header] = open;
	}

	bool EntryShown(const Entry& e)
	{
		const Settings& st = GetSettings();
		if (st.hideCompleted && e.status == kCompleted)
			return false;
		if (st.hideIgnored && e.status == kIgnored)
			return false;
		// The Missable tab is nothing else, so there they stay
		if (st.hideMissable && (e.flags & kFlagMissable) && g_book != kBookMissable)
			return false;
		return g_region == 0 || e.region == g_region;
	}

	// A section's done and total, counting only the chosen region's entries, as its list shows them
	struct DoneOf { int done = 0, total = 0; bool All() const { return done == total; } };

	DoneOf RegionCount(const Section& s)
	{
		DoneOf c;
		for (const Entry& e : s.entries)
			if (g_region == 0 || e.region == g_region)
			{
				++c.total;
				c.done += e.Done() ? 1 : 0;
			}
		return c;
	}

	struct Counts { int done = 0, total = 0, progress = 0, open = 0, ignored = 0, missed = 0; };

	void Add(Counts& c, const Entry& e)
	{
		++c.total;
		switch (e.status)
		{
		case kCompleted: ++c.done; break;
		case kIgnored: ++c.done; ++c.ignored; break;
		case kInProgress: ++c.progress; break;
		case kMissed: ++c.missed; break;
		default: ++c.open; break;
		}
	}

	Counts BookCounts(const Model& m, int book)
	{
		Counts c;
		for (const Section& s : m.sections)
			if (s.book == book)
				for (const Entry& e : s.entries)
					Add(c, e);
		return c;
	}

	// Colour for a section's stripe: the game's quest log colours its kinds
	ImU32 StripeFor(const Section& s)
	{
		if (s.book == kBookMissable)
			return s.state == 1 ? kRed : s.kind == 0 ? kOrange : s.kind == 1 ? Rgb(150, 110, 190) : Rgb(190, 90, 90);
		if (s.book == kBookQuest && !s.entries.empty())
		{
			switch (s.entries[0].filter)
			{
			case 2: return Rgb(214, 124, 30);   // main
			case 3: return Rgb(126, 124, 40);   // secondary
			case 4: return Rgb(34, 140, 52);    // contracts
			case 5: return Rgb(60, 120, 170);   // scavenger hunts
			case 6: return Rgb(110, 90, 170);   // treasure hunts
			default: return Rgb(150, 110, 60);
			}
		}
		if (s.book == kBookWorld) return Rgb(70, 120, 110);
		if (s.book == kBookGwent) return Rgb(70, 96, 150);
		return Rgb(150, 116, 50);
	}

	void Marker(const Entry& e, ImVec2 m)
	{
		switch (e.status)
		{
		case kCompleted:
			Tick(m, 14, kGreen, 3.5f);
			break;
		case kIgnored:
			Tick(m, 14, Rgb(150, 150, 130), 3.f);
			break;
		case kInProgress:
			SoftGlow(m, 24, Alpha(kAmber, 0.3f));
			dl->AddCircle(m, 14, kAmber, 24, 2.5f);
			dl->AddCircleFilled(m, 6, kAmber);
			break;
		case kMissed:
			Cross(m, 11, Rgb(190, 70, 56), 3.5f);
			break;
		default:
			Diamond(m, 11, Rgb(130, 122, 106), false, 2.f);
			break;
		}
	}

	// On a list's right, as a Gwent card's badge is: this can still be missed. The Missable tab holds nothing else, so it
	// goes without.
	bool ShowsMissableBadge(const Entry& e)
	{
		return g_book != kBookMissable && (e.flags & kFlagMissable) && !e.Done() && e.status != kMissed;
	}

	void MissableBadge(ImVec2 m)
	{
		const ImVec2 w[3] = { {m.x, m.y - 12}, {m.x + 12, m.y + 10}, {m.x - 12, m.y + 10} };
		dl->AddConvexPolyFilled(w, 3, Rgb(196, 82, 58));
		TextOnPoint(kSans, 22, ImVec2(m.x, m.y + 2.f), Rgb(20, 8, 4), "!");
	}

	// Items and cards are collected rather than started
	const char* NotStartedText()
	{
		return g_book == kBookBestiary ? Tx(T_status_undiscovered) : g_book == kBookItems || g_book == kBookGwent ? Tx(T_status_not_collected) : Tx(T_status_not_started);
	}

	void CardListMark(const Entry& e, ImVec2 centre);
	const char* SectionShield(const Section& s);
	void CardShield(const char* label, ImVec2 centre, float box, ImU32 tint);
	constexpr const char* kNeutralSun = "#sun";
	void CardSun(ImVec2 centre, float radius, ImU32 col);
	constexpr float kShieldRoom = 52.f;   // a Gwent or World Map group's header: its shield or map pin before its name
	bool HeaderHasMark(const Section& s) { return s.book == kBookGwent || s.book == kBookWorld; }
	unsigned long long MapPinTexture(const std::string& label);
	unsigned long long MapPinWhiteTexture(const std::string& label);
	unsigned long long CardPortraitTexture(const std::string& picture);
	unsigned long long ItemTileTexture(const std::string& iconPath);

	const char* StatusText(const Entry& e)
	{
		switch (e.status)
		{
		case kCompleted: return g_book == kBookBestiary ? Tx(T_status_discovered) : Tx(T_status_completed);
		case kIgnored: return Tx(T_status_ignored);
		case kInProgress: return Tx(T_status_in_progress);
		case kMissed: return Tx(T_status_missed);
		default: return NotStartedText();
		}
	}

	ImU32 StatusColour(const Entry& e)
	{
		switch (e.status)
		{
		case kCompleted: return kGreen;
		case kIgnored: return Rgb(170, 170, 150);
		case kInProgress: return kAmber;
		case kMissed: return Rgb(226, 100, 80);
		default: return kText;
		}
	}

	// A bar that fills as the page opens, with a bright end
	void GoldBar(ImVec2 a, ImVec2 b, float f, float shown)
	{
		dl->AddRectFilled(a, b, Rgb(14, 12, 9));
		dl->AddRect(ImVec2(a.x - 1, a.y - 1), ImVec2(b.x + 1, b.y + 1), Rgb(70, 58, 38, 170));
		f = std::min(f, 1.f) * shown;
		if (f > 0.f)
		{
			const float end = a.x + (b.x - a.x) * f;
			dl->AddRectFilledMultiColor(a, ImVec2(end, b.y), Rgb(126, 84, 30), Rgb(236, 196, 116), Rgb(236, 196, 116), Rgb(126, 84, 30));
			// The last of the fill brightens gradually, and a low glow runs along the bar past its end
			const float h = b.y - a.y;
			const float brightFrom = std::max(a.x, end - h * 2.5f);
			dl->AddRectFilledMultiColor(ImVec2(brightFrom, a.y), ImVec2(end, b.y), Rgb(255, 236, 190, 0), Rgb(255, 236, 190, 190), Rgb(255, 236, 190, 190), Rgb(255, 236, 190, 0));
			SoftGlowOval(ImVec2(end, (a.y + b.y) * 0.5f), std::max(26.f, h * 3.2f), h * 1.5f, Rgb(244, 210, 140, 70));
		}
	}

	float Fraction(int done, int total)
	{
		return total > 0 ? static_cast<float>(done) / static_cast<float>(total) : 0.f;
	}

	// A column's panel: a dark inset with a lit top edge
	void InsetPanel(ImVec2 a, ImVec2 b)
	{
		dl->AddRectFilledMultiColor(a, b, Rgb(0, 0, 0, 150), Rgb(0, 0, 0, 150), Rgb(0, 0, 0, 90), Rgb(0, 0, 0, 90));
		dl->AddRect(a, b, kGoldDim, 0.f, 0, 1.5f);
		dl->AddRect(ImVec2(a.x + 4, a.y + 4), ImVec2(b.x - 4, b.y - 4), Alpha(kGoldDim, 0.35f), 0.f, 0, 1.f);
		FadeLineH(a.x, b.x, a.y, kGoldHi, 1.5f);
		const float s = 10.f;
		for (const ImVec2& c : { a, ImVec2(b.x, a.y), ImVec2(a.x, b.y), b })
			Diamond(c, s * 0.45f, kGold);
	}

	void PanelHeading(ImVec2 a, float right, const char* text)
	{
		Text(kTitle, 28, a.x + 30, a.y + 22, kHead, text);
		FadeLineH(a.x + 20, right - 20, a.y + 66, kGold);
	}

	void DrawBackground()
	{
		const Settings& st = GetSettings();
		// A soft shadow on the game around the panel
		const float sh = 60.f;
		const ImU32 dark = Rgb(0, 0, 0, 190), clear = Rgb(0, 0, 0, 0);
		dl->AddRectFilledMultiColor(ImVec2(0, -sh), ImVec2(kW, 0), clear, clear, dark, dark);
		dl->AddRectFilledMultiColor(ImVec2(0, kH), ImVec2(kW, kH + sh), dark, dark, clear, clear);
		dl->AddRectFilledMultiColor(ImVec2(-sh, 0), ImVec2(0, kH), clear, dark, dark, clear);
		dl->AddRectFilledMultiColor(ImVec2(kW, 0), ImVec2(kW + sh, kH), dark, clear, clear, dark);

		// Worn dark leather with smoke through it, darker to the edges
		const int alpha = static_cast<int>(st.opacity * 255.f);
		const float w = kW, h = kH;
		Field(1, ImVec2(0, 0), ImVec2(kW, kH), 14.f, [=](float x, float y)
		{
			const float big = Fbm(x * 0.0035f + 3.f, y * 0.0035f, 4);
			const float grain = Fbm(x * 0.07f, y * 0.07f, 2);
			const float u = x / w - 0.5f, v = y / h - 0.45f;
			const float vignette = std::clamp(1.1f - (u * u + v * v) * 1.5f, 0.35f, 1.f);
			const float value = (9.f + big * 26.f + (grain - 0.5f) * 7.f) * vignette;
			return Rgb(static_cast<int>(value), static_cast<int>(value * 0.91f), static_cast<int>(value * 0.80f), alpha);
		});
		// The ghost of a sheet of the journal's paper, as behind the game's quest log
		const ImVec2 p0(kW * 0.30f, kH * 0.36f), p1(kW * 0.92f, kH * 0.99f);
		const float pw = p1.x - p0.x, ph = p1.y - p0.y;
		Field(2, p0, p1, 14.f, [=](float x, float y)
		{
			const float u = x / pw, v = y / ph;
			const float edge = std::min({ u * 1.6f, (1.f - u) * 1.6f, v * 1.8f, (1.f - v) * 3.f }) + (Fbm(x * 0.01f, y * 0.01f) - 0.5f) * 0.5f - 0.1f;
			const float a = std::clamp(edge * 2.f, 0.f, 1.f) * 34.f * (0.6f + Fbm(x * 0.02f + 5.f, y * 0.02f, 3) * 0.8f);
			const int g = 110 + static_cast<int>(Fbm(x * 0.04f, y * 0.04f, 3) * 50.f);
			return Rgb(g, g - 10, g - 28, static_cast<int>(a));
		});

		// Fine scuffs
		unsigned seed = 1234u;
		const auto next = [&]
		{
			seed ^= seed << 13;
			seed ^= seed >> 17;
			seed ^= seed << 5;
			return static_cast<float>(seed & 0xFFFFFF) / 16777216.f;
		};
		for (int i = 0; i < 26; ++i)
		{
			const ImVec2 at(next() * kW, next() * kH);
			const float angle = next() * kPi;
			const float length = 16.f + next() * 70.f;
			dl->AddLine(at, ImVec2(at.x + std::cos(angle) * length, at.y + std::sin(angle) * length * 0.3f), Rgb(170, 150, 120, 10 + static_cast<int>(next() * 12.f)), 1.f);
		}
	}

	void DrawFrame()
	{
		// A tooled frame: dark outside edge, gold, a lit inner line
		dl->AddRect(ImVec2(-1, -1), ImVec2(kW + 1, kH + 1), Rgb(0, 0, 0, 220), 0.f, 0, 2.f);
		dl->AddRect(ImVec2(0, 0), ImVec2(kW, kH), kGold, 0.f, 0, 3.f);
		dl->AddRect(ImVec2(6, 6), ImVec2(kW - 6, kH - 6), Alpha(kGold, 0.35f), 0.f, 0, 1.f);
		FadeLineH(0, kW, 0, kGoldHi, 2.f);
		FadeLineH(0, kW, kH - 2, kGoldHi, 2.f);

		// Corners: a bracket, a set stone
		const float l = 74.f;
		const struct { ImVec2 c; float dx, dy; } corners[4] = { {{0, 0}, 1, 1}, {{kW, 0}, -1, 1}, {{0, kH}, 1, -1}, {{kW, kH}, -1, -1} };
		for (const auto& k : corners)
		{
			const ImVec2 c = k.c;
			const ImVec2 inner(c.x + k.dx * 12.f, c.y + k.dy * 12.f);
			dl->AddLine(inner, ImVec2(inner.x + k.dx * l, inner.y), kGold, 2.f);
			dl->AddLine(inner, ImVec2(inner.x, inner.y + k.dy * l), kGold, 2.f);
			Diamond(ImVec2(inner.x + k.dx * l, inner.y), 4.f, kGoldHi);
			Diamond(ImVec2(inner.x, inner.y + k.dy * l), 4.f, kGoldHi);
			Diamond(c, 14, Rgb(14, 12, 8));
			Diamond(c, 14, kGoldHi, false, 2.f);
			Diamond(c, 5, kGoldHi);
		}
	}

	void DrawTopBar(const Model* m)
	{
		const float barH = 148.f;
		dl->AddRectFilledMultiColor(ImVec2(0, 0), ImVec2(kW, barH), Rgb(0, 0, 0, 240), Rgb(0, 0, 0, 240), Rgb(0, 0, 0, 190), Rgb(0, 0, 0, 190));
		FadeLineH(0, kW, barH, kGold, 1.5f);
		Diamond(ImVec2(kW * 0.5f, barH), 6, kGoldHi);

		// The whole path: the book's title, the sum, a bar
		const int percent = m && m->total > 0 ? 100 * m->done / m->total : 0;
		char pct[16];
		snprintf(pct, sizeof(pct), "%d", percent);
		Text(kTitle, 20, 40, 22, kGold, Tx(T_title_caps));
		const float pw = Measure(kSerif, 72, pct).x;
		Text(kSerif, 72, 40, 42, Rgb(232, 158, 100), pct);
		Text(kTitle, 28, 46 + pw, 76, Rgb(232, 158, 100), "%");
		const ImVec2 xa(172, 94), xb(486, 114);
		GoldBar(xa, xb, m ? Fraction(m->done, m->total) : 0.f, g_wholeBarT);
		if (m)
		{
			char c[64];
			snprintf(c, sizeof(c), "%s", TxFill(T_x_of_y, std::to_string(m->done), std::to_string(m->total)).c_str());
			TextRight(kSerif, 28, xb.x, 58, Rgb(226, 216, 196), c);
		}

		const float room = kW - 556.f - 70.f - 100.f;
		const float tabW = std::min(140.f, room / kTabCount);
		const float tabX0 = std::max((kW - tabW * kTabCount) * 0.5f, 556.f);
		for (int dir = 0; dir < 2; ++dir)
		{
			const float tx = dir == 0 ? tabX0 - 44 : tabX0 + tabW * kTabCount + 44;
			const float sgn = dir == 0 ? 1.f : -1.f;
			const ImVec2 t[3] = { {tx, 62}, {tx + 22 * sgn, 48}, {tx + 22 * sgn, 76} };
			const ImVec2 ha(std::min(tx, tx + 22 * sgn) - 12, 36), hb(std::max(tx, tx + 22 * sgn) + 12, 88);
			dl->AddConvexPolyFilled(t, 3, Hover(ha, hb) ? kGoldHi : Rgb(120, 112, 98));
			if (Clicked(ha, hb))
				SetBook(g_book + (dir == 0 ? -1 : 1));
		}

		// The gold tab slides to the book that's open
		g_tabShown += (static_cast<float>(g_book) - g_tabShown) * std::min(1.f, g_dt * 16.f);
		if (std::fabs(g_tabShown - g_book) < 0.002f)
			g_tabShown = static_cast<float>(g_book);
		{
			const float x = tabX0 + tabW * g_tabShown;
			const ImVec2 a(x + 2, 5), b(x + tabW - 2, barH - 12);
			Field(10 + static_cast<int>(tabW), a, b, 7.f, [=](float px, float py)
			{
				const float t = py / (b.y - a.y);
				const float n = Fbm(px * 0.05f, py * 0.05f, 3);
				return Mix(Mix(Rgb(112, 86, 46), Rgb(172, 142, 88), n), Mix(Rgb(176, 146, 92), Rgb(236, 210, 154), n), t);
			});
			dl->AddRect(a, b, Rgb(60, 44, 22), 0.f, 0, 2.f);
			dl->AddRect(ImVec2(a.x + 3, a.y + 3), ImVec2(b.x - 3, b.y - 3), Rgb(255, 240, 200, 70), 0.f, 0, 1.f);
			const ImVec2 notch[3] = { {x + tabW * 0.5f - 12, b.y}, {x + tabW * 0.5f + 12, b.y}, {x + tabW * 0.5f, b.y + 10} };
			dl->AddConvexPolyFilled(notch, 3, Rgb(226, 198, 142));
		}
		for (int i = 0; i < kTabCount; ++i)
		{
			const float x = tabX0 + tabW * i;
			const bool on = i == g_book;
			const ImVec2 a(x + 2, 5), b(x + tabW - 2, barH - 12);
			if (!on && Hover(a, b))
				dl->AddRectFilled(a, b, Rgb(226, 196, 134, 24));
			BookSign(i, ImVec2(x + tabW * 0.5f, 50), BookPicture(i) ? 34.f : 28.f, on ? Rgb(52, 38, 18) : Rgb(214, 196, 158), on ? 3.f : 2.4f, !on);
			const bool fits = Measure(kTitle, 20, Tx(kBooks[i].caps)).x <= tabW - 8;
			const Face face = fits ? kTitle : kSans;
			const int size = fits ? 20 : Measure(kSans, 22, Tx(kBooks[i].caps)).x <= tabW - 8 ? 22 : 18;
			const float capMiddle = InkCentre(face, size, "H").y;
			const float inkX = InkCentre(face, size, Tx(kBooks[i].caps)).x;
			Text(face, size, x + tabW * 0.5f - inkX, 106.f - capMiddle, on ? kInk : Rgb(186, 176, 156), Tx(kBooks[i].caps));
			if (Clicked(a, b))
				SetBook(i);
		}

		const ImVec2 ca(kW - 84, 34), cb(kW - 34, 84);
		const bool closeHover = Hover(ca, cb);
		dl->AddRect(ca, cb, closeHover ? kGoldHi : Rgb(96, 90, 80), 0.f, 0, 1.5f);
		Cross(ImVec2((ca.x + cb.x) * 0.5f, (ca.y + cb.y) * 0.5f), 10, closeHover ? kGoldHi : Rgb(190, 182, 168), 2.5f);
		if (Clicked(ca, cb))
			SetMenuOpen(false);

		// The rest of the bar moves the panel
		if (g_clicked && Hover(ImVec2(0, 0), ImVec2(kW, barH)) && !Hover(ImVec2(tabX0 - 60, 0), ImVec2(tabX0 + tabW * kTabCount + 60, barH)) && !Hover(ca, cb))
			g_dragging = true;
	}

	void DrawRegionRow(const Model& m)
	{
		// Only the regions this book has anything in
		bool has[kRegionCount] = {};
		for (const Section& s : m.sections)
			if (s.book == g_book)
				for (const Entry& e : s.entries)
					if (e.region > 0 && e.region < kRegionCount)
						has[e.region] = true;
		std::vector<int> regions;
		regions.push_back(0);
		for (int i = 1; i < kRegionCount; ++i)
			if (has[i] && !m.regions[i].empty())
				regions.push_back(i);
		if (regions.size() <= 1)
		{
			g_region = 0;
			TextCentre(kTitle, 32, kW * 0.5f, 174, kHead, Upper(Tx(kBooks[g_book].name)).c_str());
			FadeLineH(kW * 0.3f, kW * 0.7f, 222, kGold);
			return;
		}

		// The triggers and A and D step through them
		int at = 0;
		for (size_t i = 0; i < regions.size(); ++i)
			if (regions[i] == g_region)
				at = static_cast<int>(i);
		int step = 0;
		if (!g_statusOpen && (g_pad.Pressed(kPadLT) || KeyHit(kKeyA)))
			step = -1;
		if (!g_statusOpen && (g_pad.Pressed(kPadRT) || KeyHit(kKeyD)))
			step = 1;
		if (step != 0)
		{
			g_region = regions[(at + step + regions.size()) % regions.size()];
			g_scroll = 0;
			g_followSelection = true;
			g_barT = 0.f;
		}

		const float rw = std::min(220.f, (kW - 72.f) / regions.size());
		const float rx0 = kW * 0.5f - rw * regions.size() * 0.5f;
		for (size_t i = 0; i < regions.size(); ++i)
		{
			const int region = regions[i];
			const ImVec2 a(rx0 + rw * i + 5, 168), b(rx0 + rw * (i + 1) - 5, 226);
			const bool on = g_region == region;
			if (on)
			{
				Field(100 + static_cast<int>(rw), a, b, 7.f, [=](float px, float py)
				{
					return Mix(Rgb(150, 118, 68), Rgb(232, 204, 148), Fbm(px * 0.03f, py * 0.09f, 3));
				});
				dl->AddRect(a, b, Rgb(60, 44, 22), 0.f, 0, 2.f);
			}
			else
			{
				dl->AddRectFilled(a, b, Hover(a, b) ? Rgb(50, 40, 24, 220) : Rgb(0, 0, 0, 170));
				dl->AddRect(a, b, kGoldDim, 0.f, 0, 1.5f);
			}
			const std::string name = region == 0 ? Tx(T_all_caps) : Upper(m.regions[region]);
			const float room = b.x - a.x - 14;
			const int size = Measure(kTitle, 22, name.c_str()).x <= room ? 22 : 20;
			const float tw = std::min(Measure(kTitle, size, name.c_str()).x, room);
			TextFit(kTitle, size, (a.x + b.x) * 0.5f - tw * 0.5f, (a.y + b.y) * 0.5f - InkCentre(kTitle, size, "H").y, on ? kInk : Rgb(198, 188, 166), name, room);
			if (Clicked(a, b) && !on)
			{
				g_region = region;
				g_scroll = 0;
				g_followSelection = true;
				g_barT = 0.f;
			}
		}
	}


	// ------------------------------------------------------------------------------------------
	// Kills: a tally of its own, two pages of it, none of it in the mod's totals
	// ------------------------------------------------------------------------------------------

	int g_killPage = 0;          // 0 unique, 1 monsters and men
	int g_killRowOn[2] = {};
	float g_killScroll[2] = {};
	bool g_killByName = false;
	int g_killKind = -1;         // the generic page's filter: a category, or -1 for all

	const TextId kKillCategories[15] = { T_kill_cat_0, T_kill_cat_1, T_kill_cat_2, T_kill_cat_3, T_kill_cat_4, T_kill_cat_5, T_kill_cat_6, T_kill_cat_7,
		T_kill_cat_8, T_kill_cat_9, T_kill_cat_10, T_kill_cat_11, T_kill_cat_12, T_kill_cat_13, T_kill_cat_14 };

	const char* KillCategory(int category)
	{
		return Tx(kKillCategories[std::clamp(category, 0, 14)]);
	}

	std::string KillName(const KillRow& row)
	{
		return !row.name.empty() && row.name[0] != '?' ? row.name : Tx(T_kill_unnamed);
	}

	// The tale of the last kill. Which line it is was chosen when it happened, so it stays the same each time it's read.
	std::string KillLine(const KillRow& row, const Model* m)
	{
		static const TextId kMonster[] = { T_kill_line_m_1, T_kill_line_m_2, T_kill_line_m_3, T_kill_line_m_4, T_kill_line_m_5, T_kill_line_m_6, T_kill_line_m_7, T_kill_line_m_8, T_kill_line_m_9, T_kill_line_m_10, T_kill_line_m_11, T_kill_line_m_12, T_kill_line_m_13, T_kill_line_m_14, T_kill_line_m_15, T_kill_line_m_16, T_kill_line_m_17, T_kill_line_m_18, T_kill_line_m_19, T_kill_line_m_20, T_kill_line_m_21, T_kill_line_m_22, T_kill_line_m_23, T_kill_line_m_24, T_kill_line_m_25, T_kill_line_m_26, T_kill_line_m_27, T_kill_line_m_28, T_kill_line_m_29, T_kill_line_m_30 };
		static const TextId kPerson[] = { T_kill_line_h_1, T_kill_line_h_2, T_kill_line_h_3, T_kill_line_h_4, T_kill_line_h_5, T_kill_line_h_6, T_kill_line_h_7, T_kill_line_h_8, T_kill_line_h_9, T_kill_line_h_10, T_kill_line_h_11, T_kill_line_h_12, T_kill_line_h_13, T_kill_line_h_14, T_kill_line_h_15, T_kill_line_h_16, T_kill_line_h_17, T_kill_line_h_18, T_kill_line_h_19, T_kill_line_h_20, T_kill_line_h_21, T_kill_line_h_22, T_kill_line_h_23, T_kill_line_h_24, T_kill_line_h_25, T_kill_line_h_26, T_kill_line_h_27, T_kill_line_h_28, T_kill_line_h_29, T_kill_line_h_30 };
		static const TextId kNamed[] = { T_kill_line_u_1, T_kill_line_u_2, T_kill_line_u_3, T_kill_line_u_4, T_kill_line_u_5, T_kill_line_u_6, T_kill_line_u_7, T_kill_line_u_8, T_kill_line_u_9, T_kill_line_u_10, T_kill_line_u_11, T_kill_line_u_12, T_kill_line_u_13, T_kill_line_u_14, T_kill_line_u_15, T_kill_line_u_16, T_kill_line_u_17, T_kill_line_u_18, T_kill_line_u_19, T_kill_line_u_20, T_kill_line_u_21, T_kill_line_u_22, T_kill_line_u_23, T_kill_line_u_24, T_kill_line_u_25, T_kill_line_u_26, T_kill_line_u_27, T_kill_line_u_28, T_kill_line_u_29, T_kill_line_u_30 };
		static const TextId kContract[] = { T_kill_line_c_1, T_kill_line_c_2, T_kill_line_c_3, T_kill_line_c_4, T_kill_line_c_5, T_kill_line_c_6, T_kill_line_c_7, T_kill_line_c_8, T_kill_line_c_9, T_kill_line_c_10, T_kill_line_c_11, T_kill_line_c_12, T_kill_line_c_13, T_kill_line_c_14, T_kill_line_c_15, T_kill_line_c_16, T_kill_line_c_17, T_kill_line_c_18, T_kill_line_c_19, T_kill_line_c_20, T_kill_line_c_21, T_kill_line_c_22, T_kill_line_c_23, T_kill_line_c_24, T_kill_line_c_25, T_kill_line_c_26, T_kill_line_c_27, T_kill_line_c_28, T_kill_line_c_29, T_kill_line_c_30 };
		const TextId* lines = kMonster;
		int count = (int)std::size(kMonster);
		if (row.pool == kKillPerson) { lines = kPerson; count = (int)std::size(kPerson); }
		if (row.pool == kKillNamed) { lines = kNamed; count = (int)std::size(kNamed); }
		if (row.pool == kKillContract) { lines = kContract; count = (int)std::size(kContract); }
		const std::string place = m && row.region > 0 && row.region < kRegionCount && !m->regions[row.region].empty()
			? m->regions[row.region] : std::string(Tx(T_kill_place_unknown));
		return TxFill(lines[std::abs(row.random) % count], KillName(row), place);
	}

	std::string KillHow(const KillRow& row)
	{
		if (row.how.empty())
			return "";
		if (row.how[0] != '#')
			return TxFill(T_kill_how_with, row.how);
		static const struct { const char* code; TextId text; bool sign; } kHows[] = {
			{ "#burning", T_kill_how_burning, false }, { "#bleeding", T_kill_how_bleeding, false }, { "#poison", T_kill_how_poison, false },
			{ "#charmed", T_kill_how_charmed, false }, { "#fists", T_kill_how_fists, false }, { "#crossbow", T_kill_how_crossbow, false },
			{ "#aard", T_kill_sign_aard, true }, { "#yrden", T_kill_sign_yrden, true }, { "#igni", T_kill_sign_igni, true },
			{ "#quen", T_kill_sign_quen, true }, { "#axii", T_kill_sign_axii, true } };
		for (const auto& h : kHows)
			if (row.how == h.code)
				return h.sign ? TxFill(T_kill_how_with, Tx(h.text)) : std::string(Tx(h.text));
		return "";
	}

	std::string KillWhy(const KillRow& row)
	{
		if (!row.Unique())
			return KillCategory(row.category);
		if (row.why > 0 && !row.title.empty())
			return row.title;
		return Tx(row.why == -1 ? T_kill_why_boss : row.why == -2 ? T_kill_why_contract : T_kill_why_named);
	}

	void DrawKillPageButton(int page, const char* label, ImVec2 a, ImVec2 b)
	{
		const bool on = g_killPage == page;
		if (on)
		{
			Field(100 + static_cast<int>(b.x - a.x), a, b, 7.f, [=](float px, float py)
			{
				return Mix(Rgb(150, 118, 68), Rgb(232, 204, 148), Fbm(px * 0.03f, py * 0.09f, 3));
			});
			dl->AddRect(a, b, Rgb(60, 44, 22), 0.f, 0, 2.f);
		}
		else
		{
			dl->AddRectFilled(a, b, Hover(a, b) ? Rgb(50, 40, 24, 220) : Rgb(0, 0, 0, 170));
			dl->AddRect(a, b, kGoldDim, 0.f, 0, 1.5f);
		}
		const float tw = Measure(kTitle, 22, label).x;
		Text(kTitle, 22, (a.x + b.x) * 0.5f - tw * 0.5f, (a.y + b.y) * 0.5f - InkCentre(kTitle, 22, "H").y, on ? kInk : Rgb(186, 176, 156), label);
		if (Clicked(a, b) && !on)
		{
			g_killPage = page;
			g_barT = 0.f;
		}
	}

	void DrawKillsTab(const Model* m)
	{
		const ULONGLONG ticksNow = GetTickCount64();
		if (ticksNow >= g_killsNextAsk)
		{
			g_killsNextAsk = ticksNow + 5000;
			RequestKills();
		}

		// The triggers and A and D change the page, as they do a region on the other tabs
		if (g_pad.Pressed(kPadLT) || g_pad.Pressed(kPadRT) || KeyHit(kKeyA) || KeyHit(kKeyD))
			g_killPage = 1 - g_killPage;
		const float bw = 330.f, bx = kW * 0.5f - bw;
		DrawKillPageButton(0, Tx(T_kill_page_unique), ImVec2(bx + 5, 168), ImVec2(bx + bw - 5, 226));
		DrawKillPageButton(1, Tx(T_kill_page_generic), ImVec2(bx + bw + 5, 168), ImVec2(bx + bw * 2 - 5, 226));

		const std::shared_ptr<const KillList> list = GetKills();
		if (!list)
		{
			TextCentre(kSerif, 34, kW * 0.5f, kH * 0.5f, kHead, Tx(T_kill_reading));
			return;
		}

		// This page's rows, the most slain or by name
		std::vector<const KillRow*> rows;
		int allKills = 0, top = 0, pageKinds = 0;
		bool kindHas[15] = {};
		for (const KillRow& row : list->rows)
		{
			allKills += row.count;
			if (row.Unique() != (g_killPage == 0))
				continue;
			kindHas[std::clamp(row.category, 0, 14)] = true;
			++pageKinds;
			top = std::max(top, row.count);
			if (g_killPage == 1 && g_killKind >= 0 && row.category != g_killKind)
				continue;
			rows.push_back(&row);
		}
		std::stable_sort(rows.begin(), rows.end(), [](const KillRow* a, const KillRow* b)
		{
			return g_killByName ? a->name < b->name : a->count > b->count;
		});

		if (KeyHit(kKeyS) || g_pad.Pressed(kPadX))
			g_killByName = !g_killByName;
		if (g_killPage == 1 && (KeyHit(kKeyF) || g_pad.Pressed(kPadY)))
		{
			int next = g_killKind;
			for (int i = 0; i < 16; ++i)
			{
				next = next >= 14 ? -1 : next + 1;
				if (next < 0 || kindHas[next])
					break;
			}
			g_killKind = next;
			g_killRowOn[1] = 0;
		}

		// The table
		const float x0 = 90.f, x1 = kW - 90.f;
		const bool generic = g_killPage == 1;
		const float nameW = generic ? 340.f : 440.f, shareW = generic ? 190.f : 0.f, slainW = 110.f, gap = 26.f;
		const float lastX = x0 + 18 + nameW + gap;
		const float slainR = x1 - 18;
		const float shareX = slainR - slainW - gap - shareW;
		const float lastW = (generic ? shareX - gap : slainR - slainW - gap) - lastX;
		const float headY = kTop - 4;
		Text(kTitle, 20, x0 + 18, headY, kGold, Tx(T_kill_col_name));
		Text(kTitle, 20, lastX, headY, kGold, Tx(T_kill_col_last));
		if (generic)
			Text(kTitle, 20, shareX, headY, kGold, Tx(T_kill_col_share));
		TextRight(kTitle, 20, slainR, headY, kGold, Tx(T_kill_col_slain));
		const float rowH = 80.f;
		const float listTop = headY + 40;
		// Whole rows only, with the summary below them
		const float listBottom = listTop + std::max(1.f, std::floor((kBottom - 44 - listTop) / rowH)) * rowH;
		FadeLineH(x0, x1, listTop - 2, kGold);

		const int rowCount = static_cast<int>(rows.size());
		if (rowCount == 0)
		{
			const float my = (listTop + listBottom) * 0.5f;
			TextCentre(kSerif, 34, kW * 0.5f, my - 40, kHead, Tx(generic && g_killKind >= 0 ? T_kill_none_kind : generic ? T_kill_none_generic : T_kill_none_unique));
			TextCentre(kSans, 24, kW * 0.5f, my + 8, kDim, Tx(T_kill_none_note));
		}
		else
		{
			int& on = g_killRowOn[g_killPage];
			const int step = g_navDown ? 1 : g_navUp ? -1 : g_navPageDown ? 8 : g_navPageUp ? -8 : 0;
			float& scroll = g_killScroll[g_killPage];
			on = std::clamp(on + step, 0, rowCount - 1);
			const float room = listBottom - listTop;
			const float most = std::max(0.f, rowCount * rowH - room);
			if (step)
			{
				scroll = std::min(scroll, on * rowH);
				scroll = std::max(scroll, (on + 1) * rowH - room);
			}
			if (Hover(ImVec2(x0, listTop), ImVec2(x1, listBottom)))
				scroll -= g_wheel * rowH;
			scroll = std::clamp(scroll, 0.f, most);

			dl->PushClipRect(ImVec2(x0 - 4, listTop), ImVec2(x1 + 4, listBottom), true);
			for (int i = 0; i < rowCount; ++i)
			{
				const float y = listTop + i * rowH - scroll;
				if (y + rowH < listTop || y > listBottom)
					continue;
				const KillRow& row = *rows[i];
				const ImVec2 a(x0, y), b(x1, y + rowH);
				const bool sel = i == on;
				if (sel)
				{
					dl->AddRectFilledMultiColor(a, b, Rgb(146, 104, 28, 255), Rgb(34, 22, 6, 190), Rgb(34, 22, 6, 190), Rgb(112, 78, 22, 255));
					dl->AddRect(a, b, Rgb(244, 236, 216), 0.f, 0, 2.f);
				}
				else if (Hover(a, b))
				{
					dl->AddRectFilledMultiColor(a, b, Rgb(226, 196, 134, 40), Rgb(226, 196, 134, 0), Rgb(226, 196, 134, 0), Rgb(226, 196, 134, 40));
				}
				else
				{
					FadeLineH(a.x + 20, b.x - 20, b.y, Rgb(120, 100, 66, 60));
				}
				if (Clicked(a, b))
					on = i;
				// Each column's line with what's under it, or on its own in the middle of the row when nothing is
				const std::string why = KillWhy(row), how = KillHow(row);
				const auto alone = [&](int size) { return y + (rowH - Measure(kSerif, size, "H").y) * 0.5f; };
				TextFit(kSerif, 30, x0 + 18, why.empty() ? alone(30) : y + 6, Rgb(250, 242, 220), KillName(row), nameW);
				if (!why.empty())
					TextFit(kSans, 22, x0 + 18, y + 44, kGoldHi, why, nameW);
				TextFit(kSerif, 28, lastX, how.empty() ? alone(28) : y + 6, sel ? Rgb(250, 242, 220) : kText, KillLine(row, m), lastW);
				if (!how.empty())
					TextFit(kSerif, 24, lastX, y + 42, sel ? Rgb(214, 200, 170) : kDim, how, lastW);
				if (generic && allKills > 0)
				{
					const ImVec2 ba(shareX, y + rowH * 0.5f - 7), bb(shareX + shareW, y + rowH * 0.5f + 7);
					dl->AddRectFilled(ba, bb, Rgb(0, 0, 0, 170));
					dl->AddRect(ba, bb, kGoldDim);
					const float full = static_cast<float>(row.count) / std::max(top, 1);
					dl->AddRectFilled(ImVec2(ba.x + 1, ba.y + 1), ImVec2(ba.x + 1 + (shareW - 2) * full, bb.y - 1), kGold);
				}
				const std::string count = std::to_string(row.count);
				TextRight(kTitle, 32, slainR, y + 20, kGoldHi, count.c_str());
			}
			dl->PopClipRect();
		}

		// How it stands
		// Two sentences, each with its own word for one and for more
		const TextId kindsText = generic ? (pageKinds == 1 ? T_kill_sum_generic_one : T_kill_sum_generic) : (pageKinds == 1 ? T_kill_sum_unique_one : T_kill_sum_unique);
		const std::string summary = TxFill(kindsText, std::to_string(pageKinds)) + " " + TxFill(allKills == 1 ? T_kill_sum_total_one : T_kill_sum_total, std::to_string(allKills));
		Text(kSerif, 26, x0 + 18, listBottom + 10, kDim, summary.c_str());
		if (generic && g_killKind >= 0)
			TextRight(kSerif, 26, x1 - 18, listBottom + 10, kGoldHi, KillCategory(g_killKind));
	}

	// ------------------------------------------------------------------------------------------
	// Achievements: drawn by the same list as the other tabs, from a list of its own that isn't in the mod's totals
	// ------------------------------------------------------------------------------------------

	std::shared_ptr<const AchievementList> g_achievementsFrom;
	std::shared_ptr<const CustomAchievementList> g_customFrom;   // mods' own, after the game's
	bool g_achievementsReveal = false;
	Model g_achievementsModel;
	std::map<std::string, const Achievement*> g_achievementFor;

	bool AchievementMasked(const Achievement& a)
	{
		return a.hidden && !a.unlocked && !GetSettings().revealHiddenAchievements;
	}

	std::string AchievementDate(long long when)
	{
		static const TextId kMonths[12] = { T_month_1, T_month_2, T_month_3, T_month_4, T_month_5, T_month_6, T_month_7, T_month_8, T_month_9, T_month_10, T_month_11, T_month_12 };
		const time_t t = static_cast<time_t>(when);
		tm local{};
		if (localtime_s(&local, &t) != 0)
			return "";
		char text[32];
		snprintf(text, sizeof(text), "%d %s %d", local.tm_mday, Tx(kMonths[local.tm_mon]), local.tm_year + 1900);
		return text;
	}

	std::string AchievementStatus(const Achievement& a)
	{
		if (!a.unlocked)
			return Tx(T_status_locked);
		if (a.when == 0)
			return Tx(T_status_unlocked);
		return TxFill(a.whenFirstSeen ? T_first_seen_on : T_unlocked_on, AchievementDate(a.when));
	}

	// Remade only when there's a new reading, or the secret ones have been shown or hidden
	const Model* AchievementsModel()
	{
		std::shared_ptr<const AchievementList> list = GetAchievements();
		std::shared_ptr<const CustomAchievementList> custom = GetCustomAchievements();
		if (!list && (!custom || custom->sections.empty()))
			return nullptr;
		const bool reveal = GetSettings().revealHiddenAchievements;
		if (list == g_achievementsFrom && custom == g_customFrom && reveal == g_achievementsReveal)
			return &g_achievementsModel;
		g_achievementsFrom = list;
		g_customFrom = custom;
		g_achievementsReveal = reveal;
		g_achievementFor.clear();
		g_achievementsModel = Model{};
		// The game's three groups, then a section for each of the mods' packs and groups
		struct Group { std::string header; const std::vector<Achievement>* items; int group; };
		std::vector<Group> groups;
		const char* const kGroups[3] = { Tx(T_group_w3), Tx(T_group_hos), Tx(T_group_baw) };
		if (list)
			for (int group = 0; group < 3; ++group)
				groups.push_back({ kGroups[group], &list->items, group });
		if (custom)
			for (const CustomAchievementSection& cs : custom->sections)
				groups.push_back({ cs.header, &cs.items, -1 });
		for (const Group& g : groups)
		{
			Section section;
			section.book = kTabAchievements;
			section.header = g.header;
			for (const Achievement& a : *g.items)
			{
				if (g.group >= 0 && a.group != g.group)
					continue;
				g_achievementFor[a.script] = &a;
				Entry entry;
				entry.uuid = a.script;
				entry.status = a.unlocked ? kCompleted : kAvailable;
				const bool masked = AchievementMasked(a);
				entry.title = masked ? Tx(T_hidden_achievement) : a.title;
				if (a.unlocked)
					entry.tip = AchievementStatus(a);
				else if (a.target > 0)
					entry.tip = TxFill(T_x_of_y_on_save, std::to_string(std::min(a.value, a.target)), std::to_string(a.target));
				else
					entry.tip = masked ? Tx(T_unlock_to_see) : a.description;
				section.entries.push_back(std::move(entry));
			}
			if (!section.entries.empty())
				g_achievementsModel.sections.push_back(std::move(section));
		}
		return &g_achievementsModel;
	}

	void AchievementPicture(const std::string& icon, ImVec2 at, float size, bool locked, ImU32 colour);

	// The medal in place of a picture that would give a hidden one away
	void AchievementIcon(const Entry& e, ImVec2 at, float size)
	{
		static unsigned long long texture = 0;
		static bool tried = false;
		const AchievementIconSheet sheet = GetAchievementIcons();
		if (!texture && !tried && sheet.pixels)
		{
			tried = true;
			if (!UploadIconTexture(*sheet.pixels, texture))
				texture = 0;
		}
		const auto found = g_achievementFor.find(e.uuid);
		const Achievement* a = found != g_achievementFor.end() ? found->second : nullptr;
		const ImVec2 to(at.x + size, at.y + size);
		dl->AddRectFilled(at, to, Rgb(14, 12, 9));
		if (a && a->custom)
		{
			// A mod's: the medal in its ring's colour once it's unlocked. Until then it's in the red of the game's own
			// locked pictures on Steam: near black at the edges, a dark maroon glow in the middle, the figure a muted rose.
			const ImU32 kRings[4] = { kGold, Rgb(196, 202, 210), Rgb(198, 132, 84), kGoldDim };
			const ImVec2 c(at.x + size * 0.5f, at.y + size * 0.5f);
			if (!a->unlocked)
			{
				dl->AddRectFilled(at, to, Rgb(22, 8, 13));
				for (int ring = 0; ring < 6; ++ring)   // stacked, so the middle is the brightest
					dl->AddCircleFilled(c, size * (0.5f - ring * 0.07f), Rgb(70, 22, 34, 46), 40);
			}
			// A hidden one keeps its picture back too
			if (AchievementMasked(*a))
				BookSign(kTabAchievements, c, size * 0.3f, Rgb(128, 66, 74), std::max(1.5f, size * 0.03f), false);
			else
				AchievementPicture(a->picture, at, size, !a->unlocked, a->unlocked ? kRings[std::clamp(a->ring, 0, 3)] : Rgb(128, 66, 74));
		}
		else if (!a || !texture || AchievementMasked(*a))
		{
			BookSign(kTabAchievements, ImVec2(at.x + size * 0.5f, at.y + size * 0.5f), size * 0.3f, kGoldDim, std::max(1.5f, size * 0.03f), false);
		}
		else
		{
			const float width = static_cast<float>(sheet.columns * sheet.cell), height = static_cast<float>(sheet.rows * sheet.cell * 2);
			const int column = a->icon % sheet.columns, row = a->icon / sheet.columns + (a->unlocked ? 0 : sheet.rows);
			const float cell = static_cast<float>(sheet.cell);
			dl->AddImage(static_cast<ImTextureID>(texture), at, to, ImVec2(column * cell / width, row * cell / height), ImVec2((column + 1) * cell / width, (row + 1) * cell / height));
		}
		dl->AddRect(at, to, a && a->unlocked ? kGold : Rgb(70, 58, 38), 0.f, 0, 1.5f);
	}

	struct Columns { float l0, l1, m0, m1, r0, r1; };

	Columns GetColumns()
	{
		const float margin = 36.f, gap = 40.f;
		const float each = (kW - margin * 2 - gap * 2) / 3.f;
		return { margin, margin + each - 12.f, margin + each + gap, margin + each * 2 + gap, margin + each * 2 + gap * 2, kW - margin };
	}

	// ------------------------------------------------------------------------------------------
	// Bestiary: the same list as the other tabs, with the game's own pictures
	// ------------------------------------------------------------------------------------------

	const Entry* g_creatureShown = nullptr;
	std::string g_creatureScrolled;
	float g_creatureScroll = 0.f;

	bool CreatureMasked(const Entry& e)
	{
		return !e.gameDone && !GetSettings().revealUndiscovered && e.uuid != g_tourEntry;
	}

	void DrawFitted(unsigned long long texture, float w, float h, ImVec2 a, ImVec2 b)
	{
		const float fit = std::min((b.x - a.x) / std::max(w, 1.f), (b.y - a.y) / std::max(h, 1.f));
		const ImVec2 c((a.x + b.x) * 0.5f, (a.y + b.y) * 0.5f);
		dl->AddImage(static_cast<ImTextureID>(texture), ImVec2(c.x - w * fit * 0.5f, c.y - h * fit * 0.5f), ImVec2(c.x + w * fit * 0.5f, c.y + h * fit * 0.5f));
	}

	void CreatureIcon(const Entry& e, ImVec2 at, float size);

	// Builds the visible rows, finds what's selected, and handles the list's input and drawing
	const Section* g_headerFocus = nullptr;   // a section's own row has the focus, rather than one of its entries
	bool g_revealHeader = false;              // a section was just opened: bring what's in it into view

	const Entry* DrawList(const Model& m, const Section** selectedSection)
	{
		g_headerFocus = nullptr;
		// The tour's entry, once: selected, with its section open
		if (!g_tourEntry.empty() && !g_tourEntrySet && g_book == g_tourEntryBook)
			for (const Section& s : m.sections)
				for (const Entry& e : s.entries)
					if (s.book == g_book && e.uuid == g_tourEntry && !g_tourEntrySet)
					{
						SetSectionOpen(s, true);
						g_tourEntryWas = g_selected[g_book];
						g_selected[g_book] = g_tourEntry;
						g_followSelection = true;
						g_tourEntrySet = true;
					}
		const Columns c = GetColumns();
		const ImVec2 la(c.l0, kTop), lb(c.l1, kBottom);
		const float viewH = lb.y - la.y;

		// Nothing is cut short: a row is as tall as its text
		const float rowW = lb.x - la.x - 8.f;
		const auto headerRoom = [&](const Section& s, float countW)
		{
			return lb.x - la.x - 34.f - countW - 90.f - (s.state == 1 ? 40.f : 0.f) - (HeaderHasMark(s) ? kShieldRoom : 0.f);
		};
		const auto sectionCount = [](const Section& s)
		{
			const DoneOf c = RegionCount(s);
			return std::to_string(c.done) + " / " + std::to_string(c.total);
		};
		const auto headerH = [&](const Section& s)
		{
			const float room = headerRoom(s, Measure(kSans, 24, sectionCount(s).c_str()).x);
			float h = std::max(62.f, WrappedHeight(kSerif, 32, s.header.c_str(), room) + 20.f);
			if (s.book == kBookMissable && s.state != 0)
				h += 30.f;
			return h;
		};
		struct RowText { std::string title, sub; float titleH = 0.f, tipH = 0.f, h = 72.f; bool tip = false; };
		const auto rowText = [&](const Entry& e)
		{
			RowText t;
			t.title = g_book == kBookBestiary && CreatureMasked(e) ? std::string(Tx(T_undiscovered_creature)) : e.title.empty() ? e.uuid : e.title;
			t.sub = g_book == kTabAchievements ? e.tip : e.region > 0 && e.region < kRegionCount ? m.regions[e.region] : g_book == kBookGwent ? m.regions[0] : "";
			if (e.flags & kFlagModAdded)
				t.sub += (t.sub.empty() ? std::string() : std::string("  -  ")) + Tx(T_added_by_mod);
			const float room = rowW - 110.f - (g_book == kBookGwent ? 58.f : 0.f) - (ShowsMissableBadge(e) ? 44.f : 0.f);
			t.titleH = WrappedHeight(kSerif, 32, t.title.c_str(), room);
			t.tip = g_book == kBookMissable && !e.tip.empty() && !e.Done() && e.status != kMissed;
			float h = 3.f + t.titleH + (t.sub.empty() ? 0.f : 30.f);
			if (t.tip)
			{
				t.tipH = WrappedHeight(kSans, 22, e.tip.c_str(), rowW - 110.f);
				h += t.tipH + 8.f;
			}
			t.h = std::max(72.f, h);
			return t;
		};

		g_rows.clear();
		int firstVisible = -1;
		float y = 0;

		// The Missable tab, as the book had it: anything happening now at the top, then its three parts in story order
		struct Urgent { int section; float y, h; std::string line, names; };
		std::vector<Urgent> urgent;
		const float bannerW = lb.x - la.x - 56.f;
		std::vector<int> order;
		for (int si = 0; si < static_cast<int>(m.sections.size()); ++si)
			if (m.sections[si].book == g_book)
				order.push_back(si);
		if (g_book == kBookMissable)
		{
			std::stable_sort(order.begin(), order.end(), [&](int x, int z) { return m.sections[x].kind < m.sections[z].kind; });
			for (int si : order)
			{
				const Section& s = m.sections[si];
				if (s.state != 1)
					continue;
				std::string names;
				for (const Entry& e : s.entries)
					if (!e.Done() && e.status != kMissed && EntryShown(e))
						names += (names.empty() ? "" : ", ") + (e.title.empty() ? e.uuid : e.title);
				if (names.empty())
					continue;
				Urgent u{ si, y, 0.f, s.cutoff.empty() ? s.header : TxFill(T_urgent_quest, s.cutoff), TxFill(T_still_open, names) };
				u.h = 34.f + WrappedHeight(kTitle, 22, u.line.c_str(), bannerW) + (s.cutoff.empty() ? 0.f : WrappedHeight(kSerif, 28, s.header.c_str(), bannerW) + 6.f) + WrappedHeight(kSerif, 28, u.names.c_str(), bannerW) + 6.f;
				y += u.h + 10.f;
				urgent.push_back(std::move(u));
			}
		}
		if (g_book == kBookMissable)
		{
			for (int si : order)
			{
				for (const Entry& e : m.sections[si].entries)
					if (EntryShown(e) && !e.Done() && e.status != kMissed)
					{
						firstVisible = si;
						break;
					}
				if (firstVisible >= 0)
					break;
			}
		}
		int lastPart = -1;
		for (int si : order)
		{
			const Section& s = m.sections[si];
			bool any = false;
			for (const Entry& e : s.entries)
				if (EntryShown(e))
				{
					any = true;
					break;
				}
			if (!any)
				continue;
			if (firstVisible < 0)
				firstVisible = si;
			int part = -1;
			if (g_book == kBookMissable && s.kind != lastPart)
			{
				lastPart = s.kind;
				part = s.kind;
				y += g_rows.empty() && urgent.empty() ? 50.f : 62.f;
			}
			const float rowH = headerH(s);
			g_rows.push_back({ si, -1, y, rowH, part });
			y += rowH + 6.f;
			if (SectionOpen(s, si, firstVisible))
			{
				for (int ei = 0; ei < static_cast<int>(s.entries.size()); ++ei)
				{
					if (!EntryShown(s.entries[ei]))
						continue;
					const float entryH = rowText(s.entries[ei]).h;
					g_rows.push_back({ si, ei, y, entryH });
					y += entryH + 2.f;
				}
				y += 6.f;
			}
		}
		const float contentH = y;

		if (g_rows.empty())
		{
			TextCentre(kSerif, 32, (la.x + lb.x) * 0.5f, la.y + 80, kDim, g_region > 0 ? Tx(T_nothing_in_region) : GetSettings().hideCompleted || GetSettings().hideIgnored || GetSettings().hideMissable ? Tx(T_nothing_showing) : Tx(T_nothing_yet));
			return nullptr;
		}

		// What's selected, by name so it survives a fresh list
		std::string& selected = g_selected[g_book];
		int selectedRow = -1;
		for (int i = 0; i < static_cast<int>(g_rows.size()); ++i)
			if (g_rows[i].entry >= 0 && m.sections[g_rows[i].section].entries[g_rows[i].entry].uuid == selected)
			{
				selectedRow = i;
				break;
			}
		if (selectedRow < 0)
		{
			for (int i = 0; i < static_cast<int>(g_rows.size()); ++i)
				if (g_rows[i].entry >= 0)
				{
					selectedRow = i;
					selected = m.sections[g_rows[i].section].entries[g_rows[i].entry].uuid;
					g_followSelection = true;
					break;
				}
		}

		// Keys and the controller walk the rows, headers included
		int focus = selectedRow < 0 ? 0 : selectedRow;
		for (int i = 0; i < static_cast<int>(g_rows.size()); ++i)
			if (g_rows[i].entry < 0 && !g_focusHeader.empty() && g_focusHeader == std::to_string(g_book) + m.sections[g_rows[i].section].header)
				focus = i;
		int move = 0;
		if (g_navDown)
			move = 1;
		if (g_navUp)
			move = -1;
		if (g_navPageDown)
			move = 8;
		if (g_navPageUp)
			move = -8;
		if (move != 0)
		{
			bool landed = false;
			if (g_freeScrolled)
			{
				// The selection was left behind off screen: start again from the first entry in view
				const Row& at = g_rows[focus];
				if (at.y < g_scroll || at.y + at.h > g_scroll + viewH)
				{
					int firstRow = -1, firstEntry = -1;
					for (int i = 0; i < static_cast<int>(g_rows.size()); ++i)
					{
						const Row& r = g_rows[i];
						if (r.y < g_scroll || r.y + r.h > g_scroll + viewH)
							continue;
						if (firstRow < 0)
							firstRow = i;
						if (r.entry >= 0)
						{
							firstEntry = i;
							break;
						}
					}
					const int chosen = firstEntry >= 0 ? firstEntry : firstRow;
					if (chosen >= 0)
					{
						focus = chosen;
						landed = true;
					}
				}
				g_freeScrolled = false;
			}
			if (!landed)
				focus = std::clamp(focus + move, 0, static_cast<int>(g_rows.size()) - 1);
			if (g_rows[focus].entry >= 0)
			{
				selected = m.sections[g_rows[focus].section].entries[g_rows[focus].entry].uuid;
				selectedRow = focus;
				g_focusHeader.clear();
			}
			else
			{
				g_focusHeader = std::to_string(g_book) + m.sections[g_rows[focus].section].header;
			}
			g_followSelection = true;
		}
		// Triangle, or C, opens and closes the section you're in, as the game's journal does
		if (!g_statusOpen && !g_capture && (g_pad.Pressed(kPadY) || KeyHit(kKeyC)))
		{
			const Section& s = m.sections[g_rows[focus].section];
			const bool open = SectionOpen(s, g_rows[focus].section, firstVisible);
			SetSectionOpen(s, !open);
			g_focusHeader = std::to_string(g_book) + s.header;
			g_followSelection = true;
			g_revealHeader = true;
		}
		// Enter or A on a header opens and closes it. Left and Right scroll the details, Triangle or C still toggles from any row
		if (g_navAccept && g_rows[focus].entry < 0)
		{
			const Section& s = m.sections[g_rows[focus].section];
			SetSectionOpen(s, !SectionOpen(s, g_rows[focus].section, firstVisible));
			g_revealHeader = true;
		}

		if (Hover(la, lb) && g_wheel != 0.f)
		{
			g_scroll -= g_wheel * 148.f;
			g_freeScrolled = true;
		}
		if (g_pad.rightY != 0.f)
		{
			g_scroll -= g_pad.rightY * g_dt * 1300.f;
			g_freeScrolled = true;
		}
		if (g_revealHeader)
		{
			g_revealHeader = false;
			const Row& head = g_rows[focus];
			if (head.entry < 0)
			{
				float end = head.y + head.h;
				for (const Row& other : g_rows)
					if (other.section == head.section)
						end = std::max(end, other.y + other.h);
				if (end > g_scroll + viewH - 8.f)
					g_scroll = std::min(head.y - (head.part >= 0 ? 62.f : 8.f), end - viewH + 8.f);
			}
		}
		if (g_followSelection)
		{
			const Row& r = g_rows[focus];
			if (r.y < g_scroll + 8)
				g_scroll = r.y - 8;
			if (r.y + r.h > g_scroll + viewH - 8)
				g_scroll = r.y + r.h - viewH + 8;
			g_followSelection = false;
		}
		g_scroll = std::clamp(g_scroll, 0.f, std::max(0.f, contentH - viewH));
		g_scrollShown += (g_scroll - g_scrollShown) * std::min(1.f, g_dt * 18.f);
		if (std::fabs(g_scroll - g_scrollShown) < 0.5f)
			g_scrollShown = g_scroll;

		if (!g_focusHeader.empty() && g_rows[focus].entry < 0)
			g_headerFocus = &m.sections[g_rows[focus].section];
		dl->PushClipRect(la, ImVec2(lb.x + 30, lb.y), false);
		for (const Urgent& u : urgent)
		{
			const float uy = la.y + u.y - g_scrollShown;
			if (uy + u.h < la.y || uy > lb.y)
				continue;
			const Section& s = m.sections[u.section];
			const ImVec2 a(la.x, uy), b(lb.x, uy + u.h);
			const bool hot = Hover(a, b) && Hover(la, lb);
			dl->AddRectFilledMultiColor(a, b, Rgb(98, 22, 10, 225), Rgb(46, 10, 6, 205), Rgb(46, 10, 6, 205), Rgb(98, 22, 10, 225));
			dl->AddRectFilled(a, ImVec2(a.x + 9, b.y), kRed);
			dl->AddRect(a, b, hot ? Rgb(246, 170, 136) : Rgb(170, 62, 40), 0.f, 0, hot ? 2.f : 1.f);
			float ty = uy + 12.f;
			Text(kTitle, 22, a.x + 28, ty, Rgb(246, 170, 136), u.line.c_str(), bannerW);
			ty += WrappedHeight(kTitle, 22, u.line.c_str(), bannerW) + 6.f;
			if (!s.cutoff.empty())
			{
				Text(kSerif, 28, a.x + 28, ty, Rgb(234, 220, 202), s.header.c_str(), bannerW);
				ty += WrappedHeight(kSerif, 28, s.header.c_str(), bannerW) + 6.f;
			}
			Text(kSerif, 28, a.x + 28, ty, Rgb(226, 196, 170), u.names.c_str(), bannerW);
			if (Clicked(a, b) && Hover(la, lb))
			{
				SetSectionOpen(s, true);
				g_focusHeader = std::to_string(g_book) + s.header;
				g_followSelection = true;
			}
		}
		for (int i = 0; i < static_cast<int>(g_rows.size()); ++i)
		{
			const Row& r = g_rows[i];
			const float ry = la.y + r.y - g_scrollShown;
			if (ry + r.h < la.y || ry - 62.f > lb.y)
				continue;
			const Section& s = m.sections[r.section];
			if (r.part >= 0)
			{
				const std::string partName = Upper(Tx(kKinds[std::clamp(r.part, 0, 2)]));
				Text(kTitle, 24, la.x + 6, ry - 46.f, kHead, partName.c_str());
				FadeLineH(la.x, lb.x, ry - 12.f, kGold);
			}
			if (r.entry < 0)
			{
				const bool open = SectionOpen(s, r.section, firstVisible);
				const ImVec2 a(la.x, ry), b(lb.x, ry + r.h);
				const bool hover = Hover(a, b) && Hover(la, lb);
				const bool focused = i == focus && !g_focusHeader.empty();
				const ImU32 top = open ? Rgb(10, 9, 7, 240) : hover ? Rgb(58, 50, 34, 230) : Rgb(38, 34, 25, 215);
				const ImU32 low = open ? Rgb(2, 2, 2, 240) : hover ? Rgb(40, 34, 22, 230) : Rgb(20, 18, 13, 215);
				dl->AddRectFilledMultiColor(a, b, top, top, low, low);
				const ImU32 stripe = StripeFor(s);
				dl->AddRectFilledMultiColor(a, ImVec2(a.x + 9, b.y), Mix(stripe, Rgb(255, 255, 255), 0.25f), Mix(stripe, Rgb(255, 255, 255), 0.25f), stripe, stripe);
				dl->AddRect(a, b, focused ? Rgb(238, 232, 214) : Rgb(78, 66, 44), 0.f, 0, focused ? 2.f : 1.f);
				const DoneOf counted = RegionCount(s);
				char count[24];
				snprintf(count, sizeof(count), "%d / %d", counted.done, counted.total);
				const float countW = Measure(kSans, 24, count).x;
				const float room = headerRoom(s, countW);
				if (s.state == 1)
				{
					const ImVec2 w0(b.x - countW - 104, a.y + 31);
					const ImVec2 w[3] = { {w0.x, w0.y - 15}, {w0.x + 15, w0.y + 12}, {w0.x - 15, w0.y + 12} };
					dl->AddConvexPolyFilled(w, 3, kRed);
				}
				float textX = a.x + 30;
				if (s.book == kBookWorld)
				{
					if (const unsigned long long pin = s.pin.empty() ? 0 : MapPinTexture(s.pin))
					{
						const float half = 21.f;
						const ImVec2 c(textX + 20.f, a.y + 31.f);
						dl->AddImage(static_cast<ImTextureID>(pin), ImVec2(c.x - half, c.y - half), ImVec2(c.x + half, c.y + half), ImVec2(0, 0), ImVec2(1, 1), IM_COL32(255, 255, 255, open || hover ? 255 : 225));
					}
					textX += kShieldRoom;
				}
				if (s.book == kBookGwent)
				{
					const ImU32 shieldTint = IM_COL32(255, 255, 255, open || hover ? 245 : 215);
					if (const char* shield = SectionShield(s))
					{
						if (shield == kNeutralSun)
							CardSun(ImVec2(textX + 20.f, a.y + 31.f), 19.f, shieldTint);
						else
							CardShield(shield, ImVec2(textX + 20.f, a.y + 31.f), 40.f, shieldTint);
					}
					textX += kShieldRoom;   // the names line up whether or not there's a shield
				}
				Text(kSerif, 32, textX, a.y + 10, open ? Rgb(240, 230, 208) : Rgb(204, 192, 160), s.header.c_str(), room);
				if (s.book == kBookMissable && s.state != 0)
					Text(kTitle, 20, a.x + 30, b.y - 34.f, s.state == 1 ? Rgb(246, 136, 100) : kDim, s.state == 1 ? Tx(T_happening_now) : Tx(T_passed));
				TextRight(kSans, 24, b.x - 70, a.y + 17, counted.All() ? kGreen : kDim, count);
				const float tx = b.x - 38, ty = a.y + 31;
				const ImVec2 t[3] = { {tx - 11, ty + (open ? 6.f : -6.f)}, {tx + 11, ty + (open ? 6.f : -6.f)}, {tx, ty + (open ? -8.f : 8.f)} };
				dl->AddConvexPolyFilled(t, 3, open ? kGoldHi : Rgb(150, 136, 104));
				if (Clicked(a, b) && Hover(la, lb))
				{
					SetSectionOpen(s, !open);
					g_focusHeader = std::to_string(g_book) + s.header;
					g_revealHeader = true;
				}
			}
			else
			{
				const Entry& e = s.entries[r.entry];
				const bool sel = i == selectedRow && g_focusHeader.empty();
				const ImVec2 a(la.x + 8, ry), b(lb.x, ry + r.h);
				const bool hover = Hover(a, b) && Hover(la, lb);
				if (sel)
				{
					dl->AddRectFilledMultiColor(a, b, Rgb(146, 104, 28, 255), Rgb(34, 22, 6, 190), Rgb(34, 22, 6, 190), Rgb(112, 78, 20, 255));
					dl->AddRect(a, b, Rgb(244, 236, 216), 0.f, 0, 2.f);
					dl->AddRect(ImVec2(a.x + 4, a.y + 4), ImVec2(b.x - 4, b.y - 4), Rgb(244, 236, 216, 80), 0.f, 0, 1.f);
				}
				else if (hover)
				{
					dl->AddRectFilledMultiColor(a, b, Rgb(226, 196, 134, 40), Rgb(226, 196, 134, 0), Rgb(226, 196, 134, 0), Rgb(226, 196, 134, 40));
				}
				else
				{
					FadeLineH(a.x + 20, b.x - 20, b.y + 1, Rgb(120, 100, 66, 60));
				}
				if (g_book == kTabAchievements)
					AchievementIcon(e, ImVec2(a.x + 14, a.y + 6), 60.f);
				else if (g_book == kBookBestiary)
					CreatureIcon(e, ImVec2(a.x + 14, a.y + 6), 60.f);
				else
					Marker(e, ImVec2(a.x + 44, a.y + 36));
				const RowText t = rowText(e);
				const ImU32 titleCol = e.Done() ? kDoneText : e.status == kMissed ? Rgb(180, 116, 100) : sel ? Rgb(255, 248, 230) : kText;
				const float textRoom = b.x - a.x - 110.f - (g_book == kBookGwent ? 58.f : 0.f) - (ShowsMissableBadge(e) ? 44.f : 0.f);
				const float titleY = a.y + (t.sub.empty() && !t.tip ? 16.f : 3.f);
				Text(kSerif, 32, a.x + 90, titleY, titleCol, t.title.c_str(), textRoom);
				CardListMark(e, ImVec2(b.x - 40, a.y + 36));
				if (ShowsMissableBadge(e))
					MissableBadge(ImVec2(e.picture.empty() ? b.x - 40.f : b.x - 88.f, a.y + 36.f));
				float textY = titleY + t.titleH;
				if (!t.sub.empty())
				{
					TextFit(kSans, 22, a.x + 90, textY, sel ? Rgb(214, 200, 170) : Rgb(142, 134, 118), t.sub, b.x - a.x - 110);
					textY += 30.f;
				}
				if (t.tip)
					Text(kSans, 22, a.x + 90, textY, sel ? Rgb(244, 226, 190) : Rgb(208, 178, 128), e.tip.c_str(), b.x - a.x - 110);
				if (Clicked(a, b) && Hover(la, lb))
				{
					selected = e.uuid;
					selectedRow = i;
					g_focusHeader.clear();
				}
			}
		}
		dl->PopClipRect();

		// Scroll bar, draggable
		if (contentH > viewH)
		{
			const ImVec2 ta(lb.x + 12, la.y), tb(lb.x + 20, lb.y);
			dl->AddRectFilled(ta, tb, Rgb(24, 20, 14, 220));
			dl->AddRect(ta, tb, Rgb(70, 58, 38));
			const float thumbH = std::max(60.f, viewH * viewH / contentH);
			const float thumbY = la.y + (viewH - thumbH) * (g_scrollShown / (contentH - viewH));
			const bool barHover = Hover(ImVec2(ta.x - 6, la.y), ImVec2(tb.x + 6, lb.y));
			dl->AddRectFilledMultiColor(ImVec2(ta.x, thumbY), ImVec2(tb.x, thumbY + thumbH), barHover ? kGoldHi : kGold, barHover ? kGoldHi : kGold, kGoldDim, kGoldDim);
			static bool dragging = false;
			if (g_clicked && barHover)
				dragging = true;
			if (!ImGui::IsMouseDown(0))
				dragging = false;
			if (dragging)
			{
				g_scroll = std::clamp((g_mouse.y - la.y - thumbH * 0.5f) / (viewH - thumbH), 0.f, 1.f) * (contentH - viewH);
				g_freeScrolled = true;
			}
		}

		if (selectedRow >= 0 && g_rows[selectedRow].entry >= 0)
		{
			*selectedSection = &m.sections[g_rows[selectedRow].section];
			return &(*selectedSection)->entries[g_rows[selectedRow].entry];
		}
		return nullptr;
	}

	struct LoadedIcon { unsigned long long texture = 0; float w = 0.f, h = 0.f; };

	// By the path the game's own menus use for it, from the game's own files
	const LoadedIcon* GameIcon(const std::string& path, uint32_t largestSide = 128)
	{
		static std::map<std::string, LoadedIcon> icons;
		const auto found = icons.find(path);
		if (found != icons.end())
			return found->second.texture ? &found->second : nullptr;
		if (!GameIconIndexReady())
			return nullptr;
		LoadedIcon icon;   // remembered either way, so a missing one isn't looked for every frame
		GameTexture pixels;
		if (ReadGameIcon(path, largestSide, pixels) && UploadIconTexture(pixels, icon.texture))
		{
			icon.w = static_cast<float>(pixels.width);
			icon.h = static_cast<float>(pixels.height);
		}
		const LoadedIcon& kept = icons[path] = icon;
		return kept.texture ? &kept : nullptr;
	}

	// ------------------------------------------------------------------------------------------
	// The books' signs as pictures: the game's own menu icons where it has one (their shapes, in book_icons.inc),
	// and drawn here in the same manner where it hasn't. Each is a shape, given light and shade as if pressed into metal,
	// so it can be drawn in any colour, with a shadow, from the tab bar's size up to the faint one behind a page.
	// ------------------------------------------------------------------------------------------

	struct BookArt { unsigned long long texture = 0; float w = 1.f, h = 1.f; };

	// A shape drawn here, as the game's are: solid, with its details cut out. x and y from -1 to 1, y down.
	float DrawnShape(int book, float x, float y)
	{
		const auto box = [](float px, float py, float hw, float hh) { return std::fabs(px) <= hw && std::fabs(py) <= hh; };
		if (book == kBookMissable)
		{
			// An hourglass: its caps, the posts at its sides, the glass's outline and the sand run into its lower half
			if (box(x, y + 0.86f, 0.62f, 0.08f) || box(x, y - 0.86f, 0.62f, 0.08f))
				return 1.f;
			if (box(x + 0.5f, y, 0.045f, 0.8f) || box(x - 0.5f, y, 0.045f, 0.8f))
				return 1.f;
			const float ay = std::fabs(y);
			if (ay > 0.78f)
				return 0.f;
			const float half = 0.06f + 0.3f * std::pow(ay / 0.78f, 0.85f);   // the glass's half width at this height
			const float ax = std::fabs(x);
			if (ax <= half && ax >= half - 0.07f)
				return 1.f;   // its wall
			if (ax < half - 0.07f && y > 0.32f)
				return 1.f;   // the sand that's fallen
			if (ax < half - 0.07f && y < -0.5f && y > -0.72f)
				return 1.f;   // what's left above
			if (ax < 0.022f && y > -0.05f && y < 0.32f)
				return 1.f;   // the trickle between
			return 0.f;
		}
		// A cog: a toothed wheel with a hub, and a ring cut between them
		const float r = std::sqrt(x * x + y * y), angle = std::atan2(y, x);
		constexpr int kTeeth = 8;
		const float step = 6.2831853f / kTeeth;
		const float within = std::fabs(std::remainder(angle + step * 0.5f, step));   // 0 at a tooth's middle
		const bool tooth = r < 0.96f && within * r < 0.17f;
		if (!(r < 0.72f || tooth))
			return 0.f;
		if (r < 0.26f)
			return 0.f;   // its axle
		if (r > 0.44f && r < 0.53f)
			return 0.f;   // the cut between hub and rim
		return 1.f;
	}

	// The light on a shape, from its alpha: lit from the top left as a raised, rounded surface, darker at its far edges
	GameTexture ShadedShape(const std::vector<float>& alpha, uint32_t size)
	{
		// Soften it a little first, so its rim slopes and catches the light
		std::vector<float> soft(alpha.size());
		const int blur = std::max(2, static_cast<int>(size / 48));
		for (uint32_t y = 0; y < size; ++y)
			for (uint32_t x = 0; x < size; ++x)
			{
				float sum = 0.f;
				int n = 0;
				for (int dy = -blur; dy <= blur; ++dy)
					for (int dx = -blur; dx <= blur; ++dx)
					{
						const int sx = static_cast<int>(x) + dx, sy = static_cast<int>(y) + dy;
						if (sx >= 0 && sy >= 0 && sx < static_cast<int>(size) && sy < static_cast<int>(size))
							sum += alpha[static_cast<size_t>(sy) * size + sx];
						++n;
					}
				soft[static_cast<size_t>(y) * size + x] = sum / n;
			}
		GameTexture out;
		out.dxgiFormat = 28;   // RGBA8
		out.width = out.height = size;
		out.rowBytes = size * 4;
		out.rows = size;
		out.pixels.resize(static_cast<size_t>(size) * size * 4);
		const float lx = -0.55f, ly = -0.7f, lz = 0.45f;   // toward the light: left, up, out of the screen
		for (uint32_t y = 0; y < size; ++y)
			for (uint32_t x = 0; x < size; ++x)
			{
				const auto at = [&](int px, int py) { px = std::clamp(px, 0, static_cast<int>(size) - 1); py = std::clamp(py, 0, static_cast<int>(size) - 1); return soft[static_cast<size_t>(py) * size + px]; };
				const float gx = at(x + 1, y) - at(x - 1, y), gy = at(x, y + 1) - at(x, y - 1);
				float nx = -gx * 3.f, ny = -gy * 3.f, nz = 1.f;
				const float len = std::sqrt(nx * nx + ny * ny + nz * nz);
				nx /= len; ny /= len; nz /= len;
				const float light = nx * lx + ny * ly + nz * lz;
				const float down = static_cast<float>(y) / size;   // a little darker toward its foot
				const float shade = std::clamp(0.55f + 0.62f * light - 0.12f * down, 0.f, 1.f);
				uint8_t* p = out.pixels.data() + (static_cast<size_t>(y) * size + x) * 4;
				p[0] = p[1] = p[2] = static_cast<uint8_t>(shade * 255.f + 0.5f);
				p[3] = static_cast<uint8_t>(std::clamp(alpha[static_cast<size_t>(y) * size + x], 0.f, 1.f) * 255.f + 0.5f);
			}
		// Its smaller levels, so it's smooth however small it's drawn
		const GameTexture* from = &out;
		std::vector<GameTexture> mips;
		for (uint32_t s = size / 2; s >= 8; s /= 2)
		{
			GameTexture m;
			m.dxgiFormat = 28;
			m.width = m.height = s;
			m.rowBytes = s * 4;
			m.rows = s;
			m.pixels.resize(static_cast<size_t>(s) * s * 4);
			for (uint32_t y = 0; y < s; ++y)
				for (uint32_t x = 0; x < s; ++x)
					for (int c = 0; c < 4; ++c)
					{
						const auto px = [&](uint32_t fx, uint32_t fy) { return from->pixels[(static_cast<size_t>(fy) * from->width + fx) * 4 + c]; };
						m.pixels[(static_cast<size_t>(y) * s + x) * 4 + c] = static_cast<uint8_t>((px(x * 2, y * 2) + px(x * 2 + 1, y * 2) + px(x * 2, y * 2 + 1) + px(x * 2 + 1, y * 2 + 1) + 2) / 4);
					}
			mips.push_back(std::move(m));
			from = &mips.back();
		}
		out.lowerMips = std::move(mips);
		return out;
	}

	const BookArt* BookPicture(int book)
	{
		static BookArt art[kTabCount];
		static bool tried[kTabCount] = {};
		if (book < 0 || book >= kTabCount)
			return nullptr;
		if (tried[book])
			return art[book].texture ? &art[book] : nullptr;
		// The game's own, shipped as their shapes (book_icons.inc)
		struct Shipped { int book; uint32_t w, h; const uint8_t* alpha; };
#define BOOK_ICON(b, width, height, ...) { b, width, height, [] { static const uint8_t data[] = __VA_ARGS__; return data; }() },
		static const Shipped kShipped[] = {
#include "book_icons.inc"
		};
#undef BOOK_ICON
		constexpr uint32_t kSize = 256;
		std::vector<float> shape(static_cast<size_t>(kSize) * kSize, 0.f);
		bool have = false;
		float aspect = 1.f;
		for (const Shipped& g : kShipped)
		{
			if (g.book != book)
				continue;
			const uint32_t w = g.w, h = g.h;
			const uint8_t* alpha = g.alpha;
			// Fitted into the square with a margin for the light's slope. A shape this small enlarged plainly comes out in
			// steps, so it's resampled smoothly (Catmull-Rom) and then its edge drawn in again: the contour it had, crisp
			const float fit = (kSize - 24) / static_cast<float>(std::max(w, h));
			const float ox = (kSize - w * fit) * 0.5f, oy = (kSize - h * fit) * 0.5f;
			aspect = static_cast<float>(w) / h;
			const auto a = [&](int px, int py)
			{
				if (px < 0 || py < 0 || px >= static_cast<int>(w) || py >= static_cast<int>(h))
					return 0.f;
				return alpha[static_cast<size_t>(py) * w + px] / 255.f;
			};
			const auto cubic = [](float t, float p0, float p1, float p2, float p3)
			{
				return p1 + 0.5f * t * (p2 - p0 + t * (2 * p0 - 5 * p1 + 4 * p2 - p3 + t * (3 * (p1 - p2) + p3 - p0)));
			};
			const float edge = std::clamp(0.9f / fit * 1.6f, 0.06f, 0.3f);   // about a pixel of the result either side of the contour
			for (uint32_t y = 0; y < kSize; ++y)
				for (uint32_t x = 0; x < kSize; ++x)
				{
					const float sx = (x + 0.5f - ox) / fit - 0.5f, sy = (y + 0.5f - oy) / fit - 0.5f;
					if (sx < -1.5f || sy < -1.5f || sx > w + 0.5f || sy > h + 0.5f)
						continue;
					const int ix = static_cast<int>(std::floor(sx)), iy = static_cast<int>(std::floor(sy));
					const float fx = sx - ix, fy = sy - iy;
					float rows[4];
					for (int k = -1; k <= 2; ++k)
						rows[k + 1] = cubic(fx, a(ix - 1, iy + k), a(ix, iy + k), a(ix + 1, iy + k), a(ix + 2, iy + k));
					const float value = cubic(fy, rows[0], rows[1], rows[2], rows[3]);
					const float t = std::clamp((value - (0.5f - edge)) / (2.f * edge), 0.f, 1.f);
					shape[static_cast<size_t>(y) * kSize + x] = t * t * (3.f - 2.f * t);
				}
			have = true;
			break;
		}
		if (!have && (book == kBookMissable || book == kTabSettings))
		{
			// Drawn here, four samples a pixel for smooth edges
			for (uint32_t y = 0; y < kSize; ++y)
				for (uint32_t x = 0; x < kSize; ++x)
				{
					float sum = 0.f;
					for (int s = 0; s < 4; ++s)
					{
						const float px = (x + 0.25f + 0.5f * (s & 1)) / kSize * 2.f - 1.f, py = (y + 0.25f + 0.5f * (s >> 1)) / kSize * 2.f - 1.f;
						sum += DrawnShape(book, px * 1.1f, py * 1.1f);
					}
					shape[static_cast<size_t>(y) * kSize + x] = sum * 0.25f;
				}
			have = true;
		}
		tried[book] = true;
		if (!have)
			return nullptr;
		const GameTexture shaded = ShadedShape(shape, kSize);
		if (!UploadIconTexture(shaded, art[book].texture))
			return nullptr;
		art[book].w = aspect >= 1.f ? 1.f : aspect;
		art[book].h = aspect >= 1.f ? 1.f / aspect : 1.f;
		return &art[book];
	}

	// A book's sign: its picture, with a shadow under it, else the line drawing it had before
	void BookSign(int book, ImVec2 c, float r, ImU32 col, float t, bool shadow)
	{
		const BookArt* art = BookPicture(book);
		if (!art)
		{
			Sign(kBooks[book].sign, c, r, col, t);
			return;
		}
		const float half = r * 1.18f;   // the picture's square has a margin round the shape
		const ImVec2 a(c.x - half, c.y - half), b(c.x + half, c.y + half);
		const int alpha = static_cast<int>((col >> IM_COL32_A_SHIFT) & 0xFF);
		if (shadow)
		{
			const float off = std::max(1.5f, r * 0.06f);
			dl->AddImage(static_cast<ImTextureID>(art->texture), ImVec2(a.x + off, a.y + off * 1.4f), ImVec2(b.x + off, b.y + off * 1.4f), ImVec2(0, 0), ImVec2(1, 1), IM_COL32(0, 0, 0, alpha * 3 / 4));
		}
		dl->AddImage(static_cast<ImTextureID>(art->texture), a, b, ImVec2(0, 0), ImVec2(1, 1), col);
	}

	// A picture a mod's pack brought with it, by its full path
	const LoadedIcon* PackPicture(const std::string& path)
	{
		static std::map<std::string, LoadedIcon> pictures;
		const auto found = pictures.find(path);
		if (found != pictures.end())
			return found->second.texture ? &found->second : nullptr;
		LoadedIcon icon;   // remembered either way, so a broken one isn't read every frame
		GameTexture pixels;
		const int size = MultiByteToWideChar(CP_UTF8, 0, path.c_str(), -1, nullptr, 0);
		std::wstring wide(static_cast<size_t>(size > 0 ? size - 1 : 0), L'\0');
		if (size > 1)
			MultiByteToWideChar(CP_UTF8, 0, path.c_str(), -1, wide.data(), size);
		if (ReadPictureFile(wide, 256, pixels) && UploadIconTexture(pixels, icon.texture))
		{
			icon.w = static_cast<float>(pixels.width);
			icon.h = static_cast<float>(pixels.height);
		}
		const LoadedIcon& kept = pictures[path] = icon;
		return kept.texture ? &kept : nullptr;
	}

	// A mod's achievement's picture in a size by size box: one of PotP's own icons drawn as lines in colour, or a
	// picture from the game or the pack, darkened to the locked red while it's locked. The trophy if it can't be had.
	void AchievementPicture(const std::string& icon, ImVec2 at, float size, bool locked, ImU32 colour)
	{
		const LoadedIcon* picture = nullptr;
		if (icon.rfind("game:", 0) == 0)
			picture = GameIcon(icon.substr(5), 256);
		else if (icon.rfind("file:", 0) == 0)
			picture = PackPicture(icon.substr(5));
		if (picture)
		{
			const float fit = size / std::max(picture->w, picture->h), w = picture->w * fit, h = picture->h * fit;
			const ImVec2 a(at.x + (size - w) * 0.5f, at.y + (size - h) * 0.5f);
			dl->AddImage(static_cast<ImTextureID>(picture->texture), a, ImVec2(a.x + w, a.y + h), ImVec2(0, 0), ImVec2(1, 1),
				locked ? Rgb(150, 86, 94, 200) : Rgb(255, 255, 255));
			return;
		}
		const std::vector<IconLine>* lines = BuiltinAchievementIcon(icon.rfind("builtin:", 0) == 0 ? icon.substr(8) : std::string());
		if (!lines)
			lines = BuiltinAchievementIcon("trophy");
		if (!lines)
			return;
		const float scale = size * 0.62f / 24.f;
		const ImVec2 origin(at.x + size * 0.5f - 12.f * scale, at.y + size * 0.5f - 12.f * scale);
		const float thick = std::max(1.5f, size * 0.035f);
		std::vector<ImVec2> points;
		for (const IconLine& line : *lines)
		{
			points.clear();
			for (size_t i = 0; i + 1 < line.points.size(); i += 2)
				points.emplace_back(origin.x + line.points[i] * scale, origin.y + line.points[i + 1] * scale);
			dl->AddPolyline(points.data(), static_cast<int>(points.size()), colour, line.closed ? ImDrawFlags_Closed : ImDrawFlags_None, thick);
		}
	}

	// A Gwent card as a thing you can turn over, built as the game's menu builds it (CardSlot.as) from the same
	// pictures: everything is placed on the card in the menu's own units and carried through the same turn.
	constexpr float kCardW = 308.f, kCardH = 584.f, kCardArtH = 444.f, kCardMaxTurn = 65.f;

	float g_cardTurn = 0.f;
#ifdef POTP_OVERLAY_TEST
	float g_cardTestTurn = FLT_MAX;
	float TurnToShow(float yaw) { return g_cardTestTurn != FLT_MAX ? g_cardTestTurn : yaw; }
#else
	float TurnToShow(float yaw) { return yaw; }
#endif
	std::string g_cardShown;
	bool g_cardDragging = false;
	bool g_cardZoom = false;   // the Change Status panel's way of taking the input, for the enlarged card instead
	float g_cardZoomT = 0.f, g_cardZoomYaw = 0.f, g_cardZoomPitch = 0.f;
	int g_cardZoomFrame = 0;   // the frame it opened on
	float g_modelZoom = 1.f;   // the enlarged model's: how much closer than framed whole
	// The enlarged model's own turn and place, so turning or moving it leaves the one in the panel as it was
	float g_zoomYaw = 0.f, g_zoomPitch = 0.f, g_zoomPanX = 0.f, g_zoomPanY = 0.f;
	// Enlarging and going back are held, not pressed: a thumb slipping on the stick shouldn't do either
	constexpr float kEnlargeHold = 0.4f;
	float g_enlargeHeld = 0.f;      // how long R3 or the enlarge key has been down, toward kEnlargeHold
	bool g_enlargeSpent = false;    // it's done what it was held for: let go before it does it again
	int g_enlargeFrame = -1;
	bool g_enlargeFired = false;

	// True on the frame the hold is long enough. Asked any number of times a frame, it counts once.
	bool EnlargeHeld()
	{
		if (ImGui::GetFrameCount() != g_enlargeFrame)
		{
			g_enlargeFrame = ImGui::GetFrameCount();
			g_enlargeFired = false;
			const bool down = (g_pad.buttons & kPadR3) != 0 || (!g_capture && KeyHeld(kKeyZ));
			if (!down)
			{
				g_enlargeHeld = 0.f;
				g_enlargeSpent = false;
			}
			else if (!g_enlargeSpent)
			{
				g_enlargeHeld += g_dt;
				if (g_enlargeHeld >= kEnlargeHold)
				{
					g_enlargeFired = g_enlargeSpent = true;
					g_enlargeHeld = 0.f;
				}
			}
		}
		return g_enlargeFired;
	}

	// How far the hold has got, 0 to 1, for the bar under its prompt
	float EnlargeProgress()
	{
		return g_enlargeSpent ? 0.f : std::clamp(g_enlargeHeld / kEnlargeHold, 0.f, 1.f);
	}

	enum HintAction { kActPrev, kActNext, kActMark, kActZoom, kActWardrobe, kActWardPrev, kActWardNext, kActWardWear, kActWardPin, kActWardSave, kActWardClear, kActWardStance, kActWardUntracked, kActWardEnlarge, kActWardSearch, kActAutoTurn, kActHide, kActRefresh, kActClose, kActNone };

	struct Hint { unsigned pad; const char* key; std::string text; HintAction action; bool held = false; };   // held: done by holding it, with a bar filling under it


	// The bake nearest above the size it will show at, so large words stay sharp
	ImFont* CardFont(Face face, float shown)
	{
		ImFont* best = nullptr;
		int bestSize = 0;
		for (const auto& [key, font] : g_fonts)
		{
			if (key.first != face)
				continue;
			const bool fits = key.second >= shown, bestFits = bestSize >= shown;
			if (!best || (fits && (!bestFits || key.second < bestSize)) || (!fits && !bestFits && key.second > bestSize))
			{
				best = font;
				bestSize = key.second;
			}
		}
		return best ? best : FontOf(face, 32);
	}

	struct CardView
	{
		ImVec2 centre;
		float scale, sinY, cosY, sinX, cosX, eye;

		ImVec2 At(float px, float py, float lift = 0.f) const
		{
			const float x = (px - kCardW * 0.5f) * scale, y = (py - kCardH * 0.5f) * scale, z = -lift * scale;
			const float x1 = x * cosY + z * sinY, z1 = -x * sinY + z * cosY;
			const float y2 = y * cosX - z1 * sinX, z2 = y * sinX + z1 * cosX;
			const float f = eye / (eye + z2);
			return ImVec2(centre.x + x1 * f, centre.y + y2 * f);
		}
	};

	bool CardHas(const Entry& e, int effect)
	{
		return std::find(e.effects.begin(), e.effects.end(), effect) != e.effects.end();
	}

	// Which frame of the menu's clips a card shows, by the game's own rules (CardTemplate.as)
	const char* CardPlacementFrame(const Entry& e)
	{
		if (!(e.cardType & 8))
			return "None";
		if ((e.cardType & 3) == 3) return "RangedMelee";
		if (e.cardType & 1) return "Melee";
		if (e.cardType & 2) return "Ranged";
		if (e.cardType & 4) return "Siege";
		return "None";
	}

	const char* CardTypeFrame(const Entry& e)
	{
		if (e.cardType & 64)
			return CardHas(e, 41) ? "mushroom" : "horn";
		if (e.cardType & 16)
		{
			if (CardHas(e, 30) || CardHas(e, 9)) return "clearsky";
			if (CardHas(e, 23)) return "frost";
			if (CardHas(e, 24)) return CardHas(e, 25) ? "storm" : "fog";
			if (CardHas(e, 25)) return "rain";
		}
		else if (e.cardType & 32)
		{
			if (CardHas(e, 26)) return "dummy";
		}
		else if (e.cardType & 2048)
		{
			if (CardHas(e, 29)) return "scorch";
		}
		else if (e.cardType & 128)
		{
			return "Hero";
		}
		return CardPlacementFrame(e);
	}

	const char* CardEffectFrame(const Entry& e)
	{
		if (!(e.cardType & 8))
			return "None";
		if (CardHas(e, 31)) return "summonClones";
		if (CardHas(e, 33)) return "nurse";
		if (CardHas(e, 34)) return "spy";
		if (CardHas(e, 35)) return "stMorale";
		if (CardHas(e, 32)) return "impNeighbours";
		if (CardHas(e, 27)) return "horn";
		if (CardHas(e, 29)) return "scorch";
		if (CardHas(e, 41)) return "mushroom";
		if (CardHas(e, 7) || CardHas(e, 39) || CardHas(e, 21)) return "spe_scorch";
		if (CardHas(e, 42)) return "morph";
		if (CardHas(e, 40)) return "suicide_summon";
		if ((e.cardType & 3) == 3) return "agile";
		return "None";
	}

	const char* CardFactionFrame(int faction)
	{
		switch (faction)
		{
		case 0: return "Nilfgaard";   // a neutral card takes the current deck's, and the menu starts on this one
		case 1: return "NoMansLand";
		case 2: return "Nilfgaard";
		case 3: return "NorthKingdom";
		case 4: return "Scoiatael";
		case 5: return "Skellige";
		default: return "None";
		}
	}

	unsigned long long CardAtlasTexture(int atlas)
	{
		static std::map<int, unsigned long long> uploaded;
		const auto found = uploaded.find(atlas);
		if (found != uploaded.end())
			return found->second;
		unsigned long long texture = 0;
		GameTexture withMips;
		if (CardArtAtlasWithMips(atlas, withMips))
		{
			if (!UploadIconTexture(withMips, texture))
				texture = 0;
		}
		else if (const GameTexture* pixels = CardArtAtlas(atlas))
		{
			if (!UploadIconTexture(*pixels, texture))
				texture = 0;
		}
		uploaded[atlas] = texture;
		return texture;
	}

	void CardClipFrame(const CardView& v, CardClip clip, const std::string& label, ImU32 tint)
	{
		const std::vector<CardPiece>* pieces = CardArtFrame(clip, label);
		if (!pieces)
			return;
		for (const CardPiece& p : *pieces)
		{
			const unsigned long long texture = CardAtlasTexture(p.atlas);
			if (!texture)
				continue;
			// A thin line's hard edges step and crawl as the card moves, so it fades out over a pixel each side
			if (fabsf(p.y[3] - p.y[0]) < 12.f && fabsf(p.x[1] - p.x[0]) > 100.f)
			{
				constexpr int kSteps = 16;
				const float margin = 1.f / std::max(v.scale, 0.01f);
				const float rowY[4] = { -margin, 0.f, 1.f, -margin };
				const ImU32 clear = tint & ~IM_COL32_A_MASK;
				dl->PushTextureID(static_cast<ImTextureID>(texture));
				dl->PrimReserve(kSteps * 3 * 6, (kSteps + 1) * 4);
				const unsigned base = dl->_VtxCurrentIdx;
				for (int i = 0; i <= kSteps; ++i)
				{
					const float s = static_cast<float>(i) / kSteps;
					const float topX = p.x[0] + (p.x[1] - p.x[0]) * s, topY = p.y[0] + (p.y[1] - p.y[0]) * s;
					const float lowX = p.x[3] + (p.x[2] - p.x[3]) * s, lowY = p.y[3] + (p.y[2] - p.y[3]) * s;
					const float u = p.u0 + (p.u1 - p.u0) * s;
					dl->PrimWriteVtx(v.At(topX, topY + rowY[0]), ImVec2(u, p.v0), clear);
					dl->PrimWriteVtx(v.At(topX, topY), ImVec2(u, p.v0), tint);
					dl->PrimWriteVtx(v.At(lowX, lowY), ImVec2(u, p.v1), tint);
					dl->PrimWriteVtx(v.At(lowX, lowY + margin), ImVec2(u, p.v1), clear);
				}
				for (int i = 0; i < kSteps; ++i)
					for (int row = 0; row < 3; ++row)
					{
						const unsigned a = base + i * 4 + row, b = a + 4, c = a + 1, d = b + 1;
						for (const unsigned index : { a, b, d, a, d, c })
							dl->PrimWriteIdx(static_cast<ImDrawIdx>(index));
					}
				dl->PopTextureID();
				continue;
			}
			// In strips, so the long ones foreshorten properly
			const float long0 = fabsf(p.y[3] - p.y[0]) + fabsf(p.x[3] - p.x[0]);
			const int steps = std::clamp(static_cast<int>(long0 / 50.f) + 1, 1, 12);
			for (int i = 0; i < steps; ++i)
			{
				const float t0 = static_cast<float>(i) / steps, t1 = static_cast<float>(i + 1) / steps;
				const auto along = [&](int from, int to, float t) { return v.At(p.x[from] + (p.x[to] - p.x[from]) * t, p.y[from] + (p.y[to] - p.y[from]) * t); };
				dl->AddImageQuad(static_cast<ImTextureID>(texture), along(0, 3, t0), along(1, 2, t0), along(1, 2, t1), along(0, 3, t1),
					ImVec2(p.u0, p.v0 + (p.v1 - p.v0) * t0), ImVec2(p.u1, p.v0 + (p.v1 - p.v0) * t0), ImVec2(p.u1, p.v0 + (p.v1 - p.v0) * t1), ImVec2(p.u0, p.v0 + (p.v1 - p.v0) * t1), tint);
			}
		}
	}

	// The picture on a grid of its own, so it foreshortens properly, with a soft sheen that moves as it turns
	void CardSurface(const CardView& v, unsigned long long texture, float light, float sheenAt)
	{
		constexpr int kCols = 12, kRows = 16;
		dl->PushTextureID(static_cast<ImTextureID>(texture));
		dl->PrimReserve(kCols * kRows * 6, (kCols + 1) * (kRows + 1));
		const unsigned base = dl->_VtxCurrentIdx;
		for (int row = 0; row <= kRows; ++row)
			for (int column = 0; column <= kCols; ++column)
			{
				const float s = static_cast<float>(column) / kCols, t = static_cast<float>(row) / kRows;
				const float across = fabsf(s + t * 0.3f - sheenAt);
				const float shade = std::min(1.f, light + std::max(0.f, 0.22f - across * 0.7f));
				const int c = static_cast<int>(shade * 255.f);
				dl->PrimWriteVtx(v.At(s * kCardW, t * kCardArtH), ImVec2(s, t), IM_COL32(c, c, c, 255));
			}
		for (int row = 0; row < kRows; ++row)
			for (int column = 0; column < kCols; ++column)
			{
				const unsigned a = base + row * (kCols + 1) + column, b = a + 1, c = a + kCols + 1, d = c + 1;
				for (const unsigned index : { a, b, d, a, d, c })
					dl->PrimWriteIdx(static_cast<ImDrawIdx>(index));
			}
		dl->PopTextureID();
	}

	// The card's outline, for its edge
	void CardOutlinePoint(int corner, int step, float& x, float& y)
	{
		// As measured from the pictures: the art's top corners and the parchment's rounder bottom ones
		constexpr float kTopEdge = 15.f, kBottomEdge = 17.5f;
		const float radius[4] = { kTopEdge, kBottomEdge, kBottomEdge, kTopEdge };
		const float cx[4] = { kCardW - kTopEdge, kCardW - kBottomEdge, kBottomEdge, kTopEdge };
		const float cy[4] = { kTopEdge, kCardH - kBottomEdge, kCardH - kBottomEdge, kTopEdge };
		const float a = (corner - 1) * kPi * 0.5f + step / 5.f * kPi * 0.5f;
		x = cx[corner] + cos(a) * radius[corner];
		y = cy[corner] + sin(a) * radius[corner];
	}

	void CardOutline(const CardView& v, float lift, std::vector<ImVec2>& out)
	{
		out.clear();
		for (int corner = 0; corner < 4; ++corner)
			for (int step = 0; step <= 5; ++step)
			{
				float x, y;
				CardOutlinePoint(corner, step, x, y);
				out.push_back(v.At(x, y, lift));
			}
	}

	void CardWords(const CardView& v, ImFont* font, float size, float centreX, float y, ImU32 col, const char* s, const char* end)
	{
		const float k = size / font->FontSize;
		float x = centreX - font->CalcTextSizeA(size, FLT_MAX, 0.f, s, end).x * 0.5f;
		const ImTextureID atlas = font->ContainerAtlas->TexID;
		for (const char* p = s; p < end && *p;)
		{
			unsigned int c = 0;
			const int used = ImTextCharFromUtf8(&c, p, end);
			if (used <= 0)
				break;
			p += used;
			const ImFontGlyph* g = font->FindGlyph(static_cast<ImWchar>(c));
			if (!g)
				continue;
			if (g->Visible)
				dl->AddImageQuad(atlas, v.At(x + g->X0 * k, y + g->Y0 * k), v.At(x + g->X1 * k, y + g->Y0 * k), v.At(x + g->X1 * k, y + g->Y1 * k), v.At(x + g->X0 * k, y + g->Y1 * k), ImVec2(g->U0, g->V0), ImVec2(g->U1, g->V0), ImVec2(g->U1, g->V1), ImVec2(g->U0, g->V1), col);
			x += g->AdvanceX * k;
		}
	}

	// Wrapped within the card, smaller until it fits, as long descriptions need
	void CardParagraph(const CardView& v, Face face, float size, float smallest, float centreX, float top, float height, float width, ImU32 col, const std::string& s)
	{
		ImFont* font = CardFont(face, size * v.scale);
		const auto lines = [&](float at, std::vector<std::pair<const char*, const char*>>* out)
		{
			int count = 0;
			const char* p = s.c_str();
			const char* end = p + s.size();
			while (p < end)
			{
				const char* cut = font->CalcWordWrapPositionA(at / font->FontSize, p, end, width);
				if (cut == p)
					++cut;
				if (out)
					out->emplace_back(p, cut);
				++count;
				p = cut;
				while (p < end && (*p == ' ' || *p == '\n'))
					++p;
			}
			return count;
		};
		while (size > smallest && lines(size, nullptr) * size * 1.08f > height)
			size -= 1.f;
		std::vector<std::pair<const char*, const char*>> rows;
		lines(size, &rows);
		float y = top + std::max(0.f, (height - rows.size() * size * 1.08f) * 0.5f);
		for (const auto& [from, to] : rows)
		{
			const char* last = to;
			while (last > from && (last[-1] == ' ' || last[-1] == '\n'))
				--last;
			CardWords(v, font, size, centreX, y, col, from, last);
			y += size * 1.08f;
		}
	}

	void CardFront(const CardView& v, const Entry& e, float light)
	{
		const int c = static_cast<int>(light * 255.f);
		const ImU32 tint = IM_COL32(c, c, c, 255);

		// The back of the frame, as the game's depths have it: parchment, banner, ability, row, then power
		const bool hero = (e.cardType & 128) != 0;
		const std::string type = CardTypeFrame(e);
		const bool leader = e.power < 0;
		const std::vector<CardPiece>* parchment = CardArtFrame(kClipParchment, hero ? "Hero" : "Default");
		if (parchment)
			CardClipFrame(v, kClipParchment, hero ? "Hero" : "Default", tint);
		else
			dl->AddQuadFilled(v.At(0, 440), v.At(kCardW, 440), v.At(kCardW, kCardH), v.At(0, kCardH), Rgb(226, 214, 186));

		// A soft line round it, as a picture's own edge turns jagged at an angle and crawls as the card moves
		static std::vector<ImVec2> rim;
		CardOutline(v, 0.f, rim);
		dl->AddPolyline(rim.data(), static_cast<int>(rim.size()), Rgb(52, 40, 26), ImDrawFlags_Closed, 2.f);

		const std::string name = e.title.empty() ? e.uuid : e.title;
		// Beside the banner, which comes down over the parchment
		const float textX = leader ? kCardW * 0.5f : 194.f, textW = leader ? kCardW - 40.f : 208.f;
		CardParagraph(v, kSerif, 34.f, 16.f, textX, 450.f, 40.f, textW, Rgb(38, 26, 14), name);
		if (!e.description.empty())
			CardParagraph(v, kSerif, 25.f, 12.f, textX, 492.f, 86.f, textW, Rgb(62, 48, 32), e.description);

		if (!leader)
			CardClipFrame(v, kClipBanner, CardFactionFrame(e.faction), tint);
		CardClipFrame(v, kClipEffect, CardEffectFrame(e), tint);
		CardClipFrame(v, kClipType, leader ? "None" : CardPlacementFrame(e), tint);
		if (!leader)
		{
			CardClipFrame(v, kClipPower, CardArtFrame(kClipPower, type) ? type : "Default", tint);
			if (e.cardType & 8)
			{
				const std::string power = std::to_string(e.power);
				ImFont* font = CardFont(kTitle, 46.f * v.scale);
				CardWords(v, font, 46.f, 44.5f, 20.f, hero ? Rgb(255, 255, 255) : Rgb(0, 0, 0), power.c_str(), power.c_str() + power.size());
			}
		}
	}

	// A Gwent group's faction, as most of its cards have it; null when the game has no shield for it
	const char* SectionShield(const Section& s)
	{
		if (s.book != kBookGwent || s.entries.empty())
			return nullptr;
		int counts[6] = {};
		for (const Entry& e : s.entries)
			if (e.neutral)
				++counts[0];
			else if (e.faction >= 0 && e.faction < 6)
				++counts[e.faction];
		const int faction = static_cast<int>(std::max_element(counts, counts + 6) - counts);
		if (faction != 0)
			return CardArtFrame(kClipShield, CardFactionFrame(faction)) ? CardFactionFrame(faction) : nullptr;
		// The deck list has no shield for neutral cards (its "Neutral" is the Northern Realms' picture): they have the hero's sun
		return CardArtFrame(kClipPower, "Hero") ? kNeutralSun : nullptr;
	}

	// The sun from a hero card's corner, cut out round without the leaves that run along the card's edges
	void CardSun(ImVec2 centre, float radius, ImU32 col)
	{
		const std::vector<CardPiece>* pieces = CardArtFrame(kClipPower, "Hero");
		if (!pieces || pieces->size() != 1)
			return;
		const CardPiece& p = pieces->front();
		const unsigned long long texture = CardAtlasTexture(p.atlas);
		if (!texture)
			return;
		constexpr float kSunX = 0.322f, kSunY = 0.318f, kSunRadius = 0.30f;   // of the picture, measured from it
		constexpr int kPoints = 32;
		const float kRadius = radius;
		dl->PushTextureID(static_cast<ImTextureID>(texture));
		dl->PrimReserve(kPoints * 3, kPoints + 1);
		const unsigned base = dl->_VtxCurrentIdx;
		const auto uv = [&](float s, float t) { return ImVec2(p.u0 + (p.u1 - p.u0) * s, p.v0 + (p.v1 - p.v0) * t); };
		dl->PrimWriteVtx(centre, uv(kSunX, kSunY), col);
		for (int i = 0; i < kPoints; ++i)
		{
			const float a = i * 2.f * kPi / kPoints;
			dl->PrimWriteVtx(ImVec2(centre.x + cos(a) * kRadius, centre.y + sin(a) * kRadius), uv(kSunX + cos(a) * kSunRadius, kSunY + sin(a) * kSunRadius), col);
		}
		for (int i = 0; i < kPoints; ++i)
		{
			dl->PrimWriteIdx(static_cast<ImDrawIdx>(base));
			dl->PrimWriteIdx(static_cast<ImDrawIdx>(base + 1 + i));
			dl->PrimWriteIdx(static_cast<ImDrawIdx>(base + 1 + (i + 1) % kPoints));
		}
		dl->PopTextureID();
	}

	// A world map pin, as the map menu draws it: uploaded the first time it's asked for
	unsigned long long MapPinTexture(const std::string& label)
	{
		static std::map<std::string, unsigned long long> uploaded;
		const auto found = uploaded.find(label);
		if (found != uploaded.end())
			return found->second;
		const GameTexture* picture = MapPinPicture(label);
		if (!picture)
			return 0;   // not drawn yet: asked again next frame
		unsigned long long texture = 0;
		if (!UploadIconTexture(*picture, texture))
			texture = 0;
		uploaded[label] = texture;
		return texture;
	}

	// An item's icon for a slot, its empty edges cut away and a long weapon turned corner to corner: made the first time
	// it's asked for
	unsigned long long ItemTileTexture(const std::string& iconPath)
	{
		static std::map<std::string, unsigned long long> made;
		const auto found = made.find(iconPath);
		if (found != made.end())
			return found->second;
		if (!GameIconIndexReady())
			return 0;   // asked again next frame
		unsigned long long texture = 0;
		GameTexture icon, tile;
		if (ReadGameIcon(iconPath, 256, icon))
		{
			const bool weapon = iconPath.find("/weapons/") != std::string::npos;
			if (MakeItemTile(icon, weapon, 128, tile) && !UploadIconTexture(tile, texture))
				texture = 0;
		}
		made[iconPath] = texture;   // remembered either way, so a missing one isn't looked for every frame
		return texture;
	}

	// A square portrait from a Gwent card's art, for a line about the card: made the first time it's asked for
	unsigned long long CardPortraitTexture(const std::string& picture)
	{
		static std::map<std::string, unsigned long long> made;
		const auto found = made.find(picture);
		if (found != made.end())
			return found->second;
		if (!GameIconIndexReady())
			return 0;   // asked again next frame
		unsigned long long texture = 0;
		GameTexture art, portrait;
		if (ReadGameIcon("icons/gwint/" + picture + ".png", 2048, art) && MakeCardPortrait(art, 128, portrait))
			if (!UploadIconTexture(portrait, texture))
				texture = 0;
		made[picture] = texture;   // remembered either way, so a missing one isn't looked for every frame
		return texture;
	}

	// A world map pin in white, for a mark drawn over a pin in its colour
	unsigned long long MapPinWhiteTexture(const std::string& label)
	{
		static std::map<std::string, unsigned long long> uploaded;
		const auto found = uploaded.find(label);
		if (found != uploaded.end())
			return found->second;
		const GameTexture* picture = MapPinWhite(label);
		if (!picture)
			return 0;
		unsigned long long texture = 0;
		if (!UploadIconTexture(*picture, texture))
			texture = 0;
		uploaded[label] = texture;
		return texture;
	}

	// One of the deck list's faction shields, fitted into a square
	void CardShield(const char* label, ImVec2 centre, float box, ImU32 tint)
	{
		const std::vector<CardPiece>* pieces = CardArtFrame(kClipShield, label);
		if (!pieces || pieces->empty())
			return;
		float minX = FLT_MAX, minY = FLT_MAX, maxX = -FLT_MAX, maxY = -FLT_MAX;
		for (const CardPiece& p : *pieces)
			for (int i = 0; i < 4; ++i)
			{
				minX = std::min(minX, p.x[i]);
				maxX = std::max(maxX, p.x[i]);
				minY = std::min(minY, p.y[i]);
				maxY = std::max(maxY, p.y[i]);
			}
		const float fit = box / std::max(std::max(maxX - minX, maxY - minY), 1.f);
		const float midX = (minX + maxX) * 0.5f, midY = (minY + maxY) * 0.5f;
		for (const CardPiece& p : *pieces)
			if (const unsigned long long texture = CardAtlasTexture(p.atlas))
			{
				const auto at = [&](int i) { return ImVec2(centre.x + (p.x[i] - midX) * fit, centre.y + (p.y[i] - midY) * fit); };
				dl->AddImageQuad(static_cast<ImTextureID>(texture), at(0), at(1), at(2), at(3), ImVec2(p.u0, p.v0), ImVec2(p.u1, p.v0), ImVec2(p.u1, p.v1), ImVec2(p.u0, p.v1), tint);
			}
	}

	// A small mark at the end of a card's row, in the game's own pictures: a leader's faction shield, a hero's
	// sun, a unit's row, a special card's icon
	void CardListMark(const Entry& e, ImVec2 centre)
	{
		if (e.picture.empty())
			return;
		const bool leader = e.power < 0, hero = (e.cardType & 128) != 0, unit = (e.cardType & 8) != 0;
		const CardClip clip = leader ? kClipShield : unit && !hero ? kClipType : kClipPower;
		const std::string label = leader ? CardFactionFrame(e.faction) : hero ? "Hero" : unit ? CardPlacementFrame(e) : CardTypeFrame(e);
		const std::vector<CardPiece>* pieces = CardArtFrame(clip, label);
		if (!pieces)
			pieces = CardArtFrame(clip, "Default");
		if (!pieces || pieces->empty())
			return;
		float minX = FLT_MAX, minY = FLT_MAX, maxX = -FLT_MAX, maxY = -FLT_MAX;
		for (const CardPiece& p : *pieces)
			for (int i = 0; i < 4; ++i)
			{
				minX = std::min(minX, p.x[i]);
				maxX = std::max(maxX, p.x[i]);
				minY = std::min(minY, p.y[i]);
				maxY = std::max(maxY, p.y[i]);
			}
		// A hero's is the sun alone, without the leaves that run along the card's edges
		if (hero && pieces->size() == 1)
		{
			CardSun(centre, 19.f, IM_COL32(255, 255, 255, e.Done() ? 110 : 235));
			return;
		}

		const float box = leader ? 42.f : 34.f;
		const float fit = box / std::max(std::max(maxX - minX, maxY - minY), 1.f);
		const float midX = (minX + maxX) * 0.5f, midY = (minY + maxY) * 0.5f;
		const ImU32 tint = IM_COL32(255, 255, 255, e.Done() ? 110 : leader || hero ? 235 : 150);
		for (const CardPiece& p : *pieces)
			if (const unsigned long long texture = CardAtlasTexture(p.atlas))
			{
				const auto at = [&](int i) { return ImVec2(centre.x + (p.x[i] - midX) * fit, centre.y + (p.y[i] - midY) * fit); };
				dl->AddImageQuad(static_cast<ImTextureID>(texture), at(0), at(1), at(2), at(3), ImVec2(p.u0, p.v0), ImVec2(p.u1, p.v0), ImVec2(p.u1, p.v1), ImVec2(p.u0, p.v1), tint);
			}
	}

	// The card's art, made twice the size with a sharper filter than the plain stretch the window would give it.
	// A limited number are kept on the card, the longest unseen let go first.
	unsigned long long CardArtTexture(const std::string& picture)
	{
		struct Kept { unsigned long long texture; unsigned long long seen; };
		static std::map<std::string, Kept> kept;
		static unsigned long long tick = 0;
		constexpr size_t kMost = 24;
		++tick;
		const auto found = kept.find(picture);
		if (found != kept.end())
		{
			found->second.seen = tick;
			return found->second.texture;
		}
		if (!GameIconIndexReady())
			return 0;
		if (kept.size() >= kMost)
		{
			auto oldest = kept.end();
			for (auto it = kept.begin(); it != kept.end(); ++it)
				if (it->second.texture && (oldest == kept.end() || it->second.seen < oldest->second.seen))
					oldest = it;
			if (oldest != kept.end())
			{
				ReleaseIconTexture(oldest->second.texture);
				kept.erase(oldest);
			}
		}
		Kept made{ 0, tick };
		GameTexture pixels, larger;
		if (ReadGameIcon("icons/gwint/" + picture + ".png", 2048, pixels))
		{
			// A mod's larger art is used as it is
			const GameTexture& use = pixels.height <= 444 && UpscaleCardArt(pixels, larger) ? larger : pixels;
			if (!UploadIconTexture(use, made.texture))
				made.texture = 0;
		}
		kept[picture] = made;   // remembered either way, so a missing one isn't looked for every frame
		return made.texture;
	}

	void DrawCardObject(const Entry& e, ImVec2 centre, float cardH, float yaw, float pitch)
	{
		const float scale = cardH / kCardH;
		const float radY = yaw * kPi / 180.f, radX = pitch * kPi / 180.f;
		const CardView v{ centre, scale, sinf(radY), cosf(radY), sinf(radX), cosf(radX), cardH * 3.4f };

		// On a shadow, and with some thickness to it
		SoftGlow(ImVec2(centre.x, centre.y + cardH * 0.52f), cardH * 0.28f * std::max(0.25f, fabsf(v.cosY)), Rgb(0, 0, 0, 120));
		static std::vector<ImVec2> outline;
		for (int layer = 4; layer >= 1; --layer)
		{
			CardOutline(v, -static_cast<float>(layer), outline);
			dl->AddConvexPolyFilled(outline.data(), static_cast<int>(outline.size()), Rgb(92, 70, 40));
		}

		const float light = 0.66f + 0.34f * fabsf(v.cosY);
		const float sheenAt = 0.65f + v.sinY * 1.3f;
		CardOutline(v, 0.f, outline);
		dl->AddConvexPolyFilled(outline.data(), static_cast<int>(outline.size()), Rgb(16, 13, 10));
		if (const unsigned long long art = CardArtTexture(e.picture))
			CardSurface(v, art, light, sheenAt);
		CardFront(v, e, light);
	}

	void DrawCardPanel(const Entry& e, float x0, float x1, float top, float bottom)
	{
		const float hintH = 34.f;
		const float room = bottom - top - hintH - 12.f;
		const float cardH = std::min(room / 1.1f, 640.f);   // the near edge grows as it turns
		if (cardH < 120.f)
			return;
		const float scale = cardH / kCardH;
		const ImVec2 centre((x0 + x1) * 0.5f, top + 6.f + room * 0.5f);
		const ImVec2 boxA(centre.x - kCardW * scale * 0.5f, centre.y - cardH * 0.5f), boxB(centre.x + kCardW * scale * 0.5f, centre.y + cardH * 0.5f);

		// Comes in from an angle when it changes, and returns to the front when let go. It only ever tilts:
		// the game never shows a card's back, and has no good picture of one.
		if (g_cardShown != e.uuid)
		{
			g_cardShown = e.uuid;
			g_cardTurn = -kCardMaxTurn;
			g_cardDragging = false;
		}
		if (g_clicked && Hover(boxA, boxB))
			g_cardDragging = true;
		if (!ImGui::IsMouseDown(0))
			g_cardDragging = false;
		if (g_cardDragging)
			g_cardTurn += ImGui::GetIO().MouseDelta.x * 0.6f;
		g_cardTurn += g_pad.rightX * g_dt * 240.f;
		g_cardTurn = std::clamp(g_cardTurn, -kCardMaxTurn, kCardMaxTurn);
		if (!g_cardDragging && g_pad.rightX == 0.f)
			g_cardTurn *= exp(-g_dt * 5.f);

		// A slow sway, so it reads as a thing and not a flat picture
		const float now = static_cast<float>(ImGui::GetTime());
		const float swayOn = std::max(0.f, 1.f - fabsf(g_cardTurn) / 30.f);
		float yaw = g_cardTurn + sinf(now * 0.7f) * 13.f * swayOn;
		float pitch = sinf(now * 0.53f) * 4.f * swayOn;
#ifdef POTP_OVERLAY_TEST
		if (g_cardTestTurn != FLT_MAX)
		{
			yaw = g_cardTestTurn;
			pitch = 5.f;
		}
#endif
		DrawCardObject(e, centre, cardH, yaw, pitch);

		const std::string hintText = TxKeys(g_padPrompts ? T_hint_tilt_pad : T_hint_tilt_mouse);
		const char* hint = hintText.c_str();
		TextCentre(kSans, 22, centre.x, top + 6.f + room + 10.f, kDim, hint);
	}

	// An item's model, turning by itself until it's taken hold of
	float g_modelYaw = -14.f, g_modelPitch = 6.f;

	// The enlarged model starts as the panel's is, close up framing and placing reset
	void OpenZoomModel()
	{
		g_modelZoom = 1.f;
		g_zoomYaw = g_modelYaw;
		g_zoomPitch = g_modelPitch;
		g_zoomPanX = g_zoomPanY = 0.f;
	}
	bool g_modelDragging = false;
	std::string g_modelShown;
#ifdef POTP_OVERLAY_TEST
	std::string g_modelTest;   // a template to show whichever item is selected
#endif

	// A creature shown as its own model, with Live Bestiary on: once the game's bestiary has it, as its painting would be
	bool LiveCreature(const Entry& e)
	{
		return g_book == kBookBestiary && GetSettings().liveBestiary && !CreatureMasked(e) && !e.creatureTemplate.empty();
	}

	// Its model is shown, turning or not as Auto-Turn says: an item's, or a creature's with Live Bestiary on
	bool ShowsModel(const Entry& e)
	{
		return (g_book == kBookItems && !e.itemTemplate.empty()) || LiveCreature(e);
	}

	bool CanEnlarge(const Entry& e)
	{
		return (g_book == kBookGwent && !e.picture.empty()) || ((g_book == kBookItems && !e.itemTemplate.empty()) || LiveCreature(e)) && ModelViewState() == kModelReady;
	}

	// The wardrobe's pins: what he keeps on while other things are tried, by kind
	struct PinnedPiece { std::string itemTemplate, title, dye; };
	std::map<std::string, PinnedPiece> g_pins;
	bool g_pinsRead = false;

	// kind~template~title, then ~dye if it has one
	bool ReadPinnedPiece(const std::string& item, std::string& kind, PinnedPiece& piece)
	{
		const size_t a = item.find('~'), b = a == std::string::npos ? a : item.find('~', a + 1);
		if (b == std::string::npos)
			return false;
		const size_t c = item.find('~', b + 1);
		kind = item.substr(0, a);
		piece.itemTemplate = item.substr(a + 1, b - a - 1);
		piece.title = item.substr(b + 1, c == std::string::npos ? std::string::npos : c - b - 1);
		piece.dye = c == std::string::npos ? std::string() : item.substr(c + 1);
		return true;
	}

	std::string SavedPiece(const std::string& kind, const PinnedPiece& piece)
	{
		return kind + "~" + piece.itemTemplate + "~" + piece.title + (piece.dye.empty() ? "" : "~" + piece.dye);
	}

	void ReadPinInto(const std::string& item)
	{
		std::string kind;
		PinnedPiece piece;
		if (ReadPinnedPiece(item, kind, piece))
			g_pins[kind] = std::move(piece);
	}

	void ReadPins()
	{
		if (g_pinsRead)
			return;
		g_pinsRead = true;
		const std::string& saved = GetSettings().wardrobePins;
		for (size_t from = 0; from < saved.size();)
		{
			size_t bar = saved.find('|', from);
			if (bar == std::string::npos)
				bar = saved.size();
			const std::string item = saved.substr(from, bar - from);
			ReadPinInto(item);
			from = bar + 1;
		}
	}

	void SavePins()
	{
		std::string saved;
		for (const auto& [kind, pin] : g_pins)
			saved += (saved.empty() ? "" : "|") + SavedPiece(kind, pin);
		GetSettings().wardrobePins = saved;
		MarkDirty();
	}

	bool IsPinned(const std::string& itemTemplate)
	{
		ReadPins();
		const auto found = g_pins.find(WornCategory(itemTemplate));
		return found != g_pins.end() && found->second.itemTemplate == itemTemplate;
	}

	void TogglePin(const std::string& itemTemplate, const std::string& title, const std::string& dye)
	{
		const std::string kind = WornCategory(itemTemplate);
		if (kind.empty())
			return;
		if (IsPinned(itemTemplate))
			g_pins.erase(kind);
		else
			g_pins[kind] = PinnedPiece{ itemTemplate, title, dye };
		SavePins();
	}

	void StepAnimation(int by)
	{
		Settings& st = GetSettings();
		const int count = AnimationCount();
		st.wardrobeAnimation = (st.wardrobeAnimation + by + count) % count;
		MarkDirty();
	}

	const char* AnimationName(int index)
	{
		const TextId names[] = { T_anim_determined, T_anim_proud, T_anim_aggressive, T_anim_cheerful, T_anim_bored, T_anim_sad, T_anim_exhausted, T_anim_ready };
		return Tx(names[std::clamp(index, 0, static_cast<int>(sizeof(names) / sizeof(names[0])) - 1)]);
	}

	// False when there's no model of it: a creature then shows its painting
	constexpr float kSmokeRoom = 1.7f;   // how much bigger a two-form creature's picture is, for its smoke

	bool DrawModelPanel(const Entry& e, float x0, float x1, float top, float bottom, const std::string& request, bool quietIfMissing = false)
	{
#ifdef POTP_OVERLAY_TEST
		ModelViewRequest(g_modelTest.empty() ? request : g_modelTest);
#else
		ModelViewRequest(request);
#endif
		static bool shownReady = false;   // it's been shown since it was chosen
		if (g_modelShown != e.uuid)
		{
			g_modelShown = e.uuid;
			g_modelYaw = -14.f;   // its front to the viewer, a little to one side so it reads as solid
			g_modelPitch = 6.f;
			g_modelDragging = false;
			shownReady = false;
		}
		const float hintH = 34.f;
		const float room = bottom - top - hintH - 12.f;
		const float side = std::min(room, x1 - x0);
		const ImVec2 centre((x0 + x1) * 0.5f, top + 6.f + room * 0.5f);
		const ImVec2 a(centre.x - side * 0.5f, centre.y - side * 0.5f), b(centre.x + side * 0.5f, centre.y + side * 0.5f);
		const ModelState state = ModelViewState();
		if (state == kModelMissing)
		{
			if (!quietIfMissing)
				TextCentre(kSerif, 28, centre.x, centre.y - 18.f, kDim, Tx(T_no_model));
			return false;
		}
		// It starts turning from facing the viewer once it's there to see, not from wherever it got to while it loaded
		if (state == kModelReady && !shownReady)
		{
			shownReady = true;
			if (!g_modelDragging)
				g_modelYaw = -14.f;
		}
		if (g_clicked && Hover(a, b))
			g_modelDragging = true;
		if (!ImGui::IsMouseDown(0))
			g_modelDragging = false;
		if (!g_cardZoom)
		{
			if (g_modelDragging)
			{
				g_modelYaw += ImGui::GetIO().MouseDelta.x * 0.45f;
				g_modelPitch = std::clamp(g_modelPitch - ImGui::GetIO().MouseDelta.y * 0.3f, -50.f, 50.f);
			}
			else if (g_pad.rightX != 0.f)
			{
				g_modelYaw += g_pad.rightX * g_dt * 130.f;
			}
			else if (shownReady && GetSettings().autoRotate)
			{
				// A steadied step: uneven frames would otherwise show as small jumps
				static float steady = 0.f;
				steady = steady <= 0.f ? g_dt : steady + (std::min(g_dt, steady * 3.f) - steady) * 0.08f;
				g_modelYaw += steady * (g_book == kBookBestiary ? 9.f : 16.f);   // a creature slower, to be looked at
			}
		}
		const float yaw = TurnToShow(g_modelYaw);
		// A creature in two forms is drawn on a bigger picture, the camera as far back again, so it's the same size but its
		// smoke has room to billow past where the square would have cut it; it shows as far as the panel goes
		int formPhase = 0;
		float formSeconds = 0.f;
		const float spill = ModelViewFormClock(formPhase, formSeconds) ? kSmokeRoom : 1.f;
		ModelViewShow(yaw, g_modelPitch, 1.f / spill);
		// Enlarged, it's drawn there alone: this one would show through the dimming behind it, as a dark double
		const unsigned long long picture = ModelViewTexture();
		if (picture && !g_cardZoom)
		{
			const float big = side * spill;
			dl->PushClipRect(ImVec2(x0, top), ImVec2(x1, top + 6.f + room), true);
			const float u = 0.5f / ModelViewAspect();   // the square from the picture's middle
			dl->AddImage(static_cast<ImTextureID>(picture), ImVec2(centre.x - big * 0.5f, centre.y - big * 0.5f), ImVec2(centre.x + big * 0.5f, centre.y + big * 0.5f), ImVec2(0.5f - u, 0.f), ImVec2(0.5f + u, 1.f));
			dl->PopClipRect();
		}
		else if (!picture)
			TextCentre(kSerif, 28, centre.x, centre.y - 18.f, kDim, Tx(T_loading));
		const std::string hintText = TxKeys(g_padPrompts ? T_hint_turn_pad : T_hint_turn_mouse);
		const char* hint = hintText.c_str();
		TextCentre(kSans, 22, centre.x, top + 6.f + room + 10.f, kDim, hint);
		return true;
	}

	void CreatureIcon(const Entry& e, ImVec2 at, float size)
	{
		const ImVec2 to(at.x + size, at.y + size);
		dl->AddRectFilled(at, to, Rgb(14, 12, 9));
		const LoadedIcon* icon = CreatureMasked(e) || e.image.empty() ? nullptr : GameIcon("icons/monsters/" + e.image, 128);
		if (icon)
			DrawFitted(icon->texture, icon->w, icon->h, at, to);
		else
			BookSign(kBookBestiary, ImVec2(at.x + size * 0.5f, at.y + size * 0.5f), size * 0.32f, kGoldDim, std::max(1.5f, size * 0.03f), false);
		dl->AddRect(at, to, e.gameDone ? kGold : Rgb(70, 58, 38), 0.f, 0, 1.5f);
	}

	void DrawCreatureDetail(const Entry& e, const Section* section)
	{
		const Columns col = GetColumns();
		const float mx0 = col.m0, mx1 = col.m1;
		const bool masked = CreatureMasked(e);

		const ImVec2 ca(mx0, kTop), cb(mx1, kTop + 118);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(112, 84, 24, 240), Rgb(40, 28, 8, 235), Rgb(26, 18, 5, 235), Rgb(84, 62, 18, 240));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f), 0.f, 0, 1.f);
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		SoftGlow(ImVec2(ca.x + 58, ca.y + 59), 62, Alpha(kGoldHi, 0.2f));
		BookSign(kBookBestiary, ImVec2(ca.x + 58, ca.y + 59), 34, Rgb(250, 232, 190), 3.f);
		const std::string title = Upper(masked ? Tx(T_undiscovered_creature) : e.title);
		const float titleRoom = cb.x - ca.x - 130;
		const int titleSize = Measure(kTitle, 32, title.c_str()).x <= titleRoom ? 32 : 24;
		TextFit(kTitle, titleSize, ca.x + 112, ca.y + (titleSize == 32 ? 14 : 20), Rgb(250, 242, 220), title, titleRoom);
		std::string sub = section ? section->header : "";
		if ((e.flags >> 2) == 1)
			sub += std::string("  -  ") + Tx(T_group_hos);
		else if ((e.flags >> 2) == 2)
			sub += std::string("  -  ") + Tx(T_group_baw);
		TextFit(kSerif, 28, ca.x + 112, ca.y + 62, Rgb(226, 214, 186), sub, titleRoom);

		float y = kTop + 136;
		Marker(e, ImVec2(mx0 + 28, y + 21));
		Text(kSerif, 34, mx0 + 66, y, StatusColour(e), StatusText(e));
		// A creature in two forms: when it next changes, on the right of its status
		int formPhase = 0;
		float formSeconds = 0.f;
		if (LiveCreature(e) && ModelViewFormClock(formPhase, formSeconds))
		{
			const std::string count = std::to_string(static_cast<int>(std::ceil(formSeconds)));
			const std::string when = formPhase == 0 ? TxFill(T_form_changes_in, count) : formPhase == 1 ? Tx(T_form_changing)
				: formPhase == 2 ? TxFill(T_form_returns_in, count) : Tx(T_form_returning);
			TextRight(kSerif, 28, mx1 - 12, y + 4, formPhase == 1 || formPhase == 3 ? kGoldHi : kDim, when.c_str());
		}
		y += 62;

		const ImVec2 pa(mx0, y), pb(mx1, kBottom);
		if (LiveCreature(e) && DrawModelPanel(e, pa.x, pb.x, pa.y, pb.y, kModelCreature + e.creatureTemplate, true))
			return;
		const LoadedIcon* picture = masked || e.image.empty() ? nullptr : GameIcon("textures/journal/bestiary/" + e.image, 1024);
		if (picture)
		{
			DrawFitted(picture->texture, picture->w, picture->h, pa, pb);
		}
		else
		{
			BookSign(kBookBestiary, ImVec2((pa.x + pb.x) * 0.5f, (pa.y + pb.y) * 0.5f), std::min(pb.x - pa.x, pb.y - pa.y) * 0.3f, Rgb(226, 196, 134, masked ? 50 : 30), 6.f, false);
			if (!masked && !e.image.empty() && !GameIconIndexReady())
				TextCentre(kSerif, 28, (pa.x + pb.x) * 0.5f, (pa.y + pb.y) * 0.5f - 18.f, kDim, Tx(T_loading));
		}
	}

	// What works against it and what the game says of it, moving together when there's more than fits
	void DrawCreatureNotes(const Entry& e, ImVec2 a, ImVec2 b)
	{
		InsetPanel(a, b);
		const float x0 = a.x + 30, x1 = b.x - 30, width = x1 - x0;
		if (CreatureMasked(e))
		{
			PanelHeading(a, b.x, Tx(T_not_in_bestiary));
			Text(kSerif, 28, x0, a.y + 84, kDim, Tx(T_joins_bestiary), width);
			return;
		}

		const float rowH = 84.f, tile = 72.f;
		const float weakH = e.weaknesses.empty() ? 0.f : 56.f + rowH * static_cast<float>((e.weaknesses.size() + 1) / 2) + 22.f;
		const float textH = 56.f + WrappedHeight(kSerif, 28, e.description.c_str(), width);
		const float contentH = weakH + textH;
		const float top = a.y + 22, viewH = b.y - 18 - top;

		if (g_creatureScrolled != e.uuid)
		{
			g_creatureScrolled = e.uuid;
			g_creatureScroll = 0.f;
		}
		if (Hover(a, b) && g_wheel != 0.f)
			g_creatureScroll -= g_wheel * 90.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadRT) != 0 || KeyHeld(kKeyD)))
			g_creatureScroll += g_dt * 520.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadLT) != 0 || KeyHeld(kKeyA)))
			g_creatureScroll -= g_dt * 520.f;
		g_creatureScroll = std::clamp(g_creatureScroll, 0.f, std::max(0.f, contentH - viewH));

		dl->PushClipRect(ImVec2(a.x + 4, top), ImVec2(b.x - 4, top + viewH), true);
		float y = top - g_creatureScroll;
		const auto heading = [&](const char* text)
		{
			Text(kTitle, 24, x0, y, kHead, text);
			FadeLineH(x0, x1, y + 38, kGold);
			y += 56.f;
		};
		if (!e.weaknesses.empty())
		{
			heading(Tx(T_works_against));
			const float columnW = width * 0.5f;
			for (size_t i = 0; i < e.weaknesses.size(); ++i)
			{
				const Entry::Weakness& weak = e.weaknesses[i];
				const float wx = x0 + static_cast<float>(i % 2) * columnW, wy = y + static_cast<float>(i / 2) * rowH;
				const ImVec2 ia(wx, wy), ib(wx + tile, wy + tile);
				dl->AddRectFilled(ia, ib, Rgb(14, 12, 9));
				if (const LoadedIcon* icon = GameIcon(weak.icon, 256))
					DrawFitted(icon->texture, icon->w, icon->h, ImVec2(ia.x + 3, ia.y + 3), ImVec2(ib.x - 3, ib.y - 3));
				dl->AddRect(ia, ib, Rgb(92, 76, 50));
				TextFit(kSerif, 26, wx + tile + 12, wy + tile * 0.5f - 18.f, kText, weak.name, columnW - tile - 22);
			}
			y += rowH * static_cast<float>((e.weaknesses.size() + 1) / 2) + 22.f;
		}
		heading(Tx(T_about_it));
		Text(kSerif, 28, x0, y, kText, e.description.c_str(), width);
		dl->PopClipRect();

		if (contentH > viewH)
		{
			const ImVec2 ta(b.x - 16, top), tb(b.x - 10, top + viewH);
			dl->AddRectFilled(ta, tb, Rgb(24, 20, 14, 220));
			const float thumbH = std::max(40.f, viewH * viewH / contentH);
			const float thumbY = top + (viewH - thumbH) * (g_creatureScroll / (contentH - viewH));
			dl->AddRectFilled(ImVec2(ta.x, thumbY), ImVec2(tb.x, thumbY + thumbH), kGold);
		}
	}

	// A row of prompts, centred, as the window's bottom row draws them: the pad's buttons or the keys, then what they do
	void DrawPromptRow(const std::vector<Hint>& hints, float y)
	{
		const float capH = 42.f, inner = 12.f, gap = 40.f;
		constexpr int textSize = 28;
		const auto glyphs = [&](const Hint& h, float at, bool draw)
		{
			if (!g_padPrompts)
				return h.key ? KeyCap(at, y, capH, h.key, draw) : 0.f;
			float w = 0.f;
			const std::vector<unsigned> buttons = MaskButtons(h.pad);
			for (size_t i = 0; i < buttons.size(); ++i)
				w += PadGlyph(at + w, y, capH, buttons[i], draw, PadStyleNow()) + (i + 1 < buttons.size() ? 6.f : 0.f);
			return w;
		};
		float total = 0.f;
		for (const Hint& h : hints)
			total += glyphs(h, 0.f, false) + inner + Measure(kSerif, textSize, h.text.c_str()).x + gap;
		float x = kW * 0.5f - (total - gap) * 0.5f;
		for (const Hint& h : hints)
		{
			const float gw = glyphs(h, x, true);
			if (h.held && EnlargeProgress() > 0.f)
				dl->AddRectFilled(ImVec2(x, y + capH + 5.f), ImVec2(x + gw * EnlargeProgress(), y + capH + 9.f), Rgb(232, 196, 128));
			Text(kSerif, textSize, x + gw + inner, y + 3, Rgb(232, 196, 128), h.text.c_str());
			x += gw + inner + Measure(kSerif, textSize, h.text.c_str()).x + gap;
		}
	}

	// The card or model large, over the whole screen dimmed, and it stays where it's turned to. A model needs no entry
	// (the wardrobe's is Geralt); a card does. True when it's asked to close.
	bool DrawZoom(const Entry* entry, bool model, bool creature, float stickX, float stickY, float wheel, bool stance = false)
	{
		if (stance && ImGui::GetFrameCount() > g_cardZoomFrame)
		{
			// The d-pad and the arrows: the left stick moves him
			if (g_pad.Pressed(kPadLeft) || ImGui::IsKeyPressed(ImGuiKey_LeftArrow))
				StepAnimation(-1);
			if (g_pad.Pressed(kPadRight) || ImGui::IsKeyPressed(ImGuiKey_RightArrow) || KeyHit(kKeyT))
				StepAnimation(1);
		}
		g_cardZoomT = std::min(1.f, g_cardZoomT + g_dt * 7.f);
		const float ease = 1.f - (1.f - g_cardZoomT) * (1.f - g_cardZoomT);

		dl->PushClipRect(ImVec2(-6000.f, -6000.f), ImVec2(kW + 6000.f, kH + 6000.f), false);
		dl->AddRectFilled(ImVec2(-6000.f, -6000.f), ImVec2(kW + 6000.f, kH + 6000.f), Rgb(0, 0, 0, static_cast<int>(205.f * ease)));
		dl->PopClipRect();

		const ImVec2 centre(kW * 0.5f, (kH - 50.f) * 0.5f);
		if (model)
		{
			if (ImGui::IsMouseDown(0))
			{
				g_zoomYaw += ImGui::GetIO().MouseDelta.x * 0.45f;
				g_zoomPitch -= ImGui::GetIO().MouseDelta.y * 0.3f;
			}
			g_zoomYaw += stickX * g_dt * 130.f;
			g_zoomPitch += stickY * g_dt * 70.f;
			g_zoomPitch = std::clamp(g_zoomPitch, -50.f, 50.f);
			// Closer with the right trigger or the wheel up, further with the left, by the same share each second however close
			float zoomBy = wheel * 0.25f;
			if ((g_pad.buttons & kPadRT) != 0 || KeyHeld(kKeyD))
				zoomBy += g_dt * 1.4f;
			if ((g_pad.buttons & kPadLT) != 0 || KeyHeld(kKeyA))
				zoomBy -= g_dt * 1.4f;
			g_modelZoom = std::clamp(g_modelZoom * expf(zoomBy), 1.f, 5.f);
			// The picture covers the whole screen, so the model can be turned and moved anywhere on it without its edge
			// cutting it short; how close it is comes from the camera alone
			const float framed = (kH - 90.f) * (0.72f + 0.28f * ease);   // the model framed whole, as it opens
			int formPhase = 0;
			float formSeconds = 0.f;
			const float spill = ModelViewFormClock(formPhase, formSeconds) ? kSmokeRoom : 1.f;   // room for its smoke
			const float pictureH = (kH + 60.f) * spill, pictureW = pictureH * ModelViewAspect();
			const float closer = framed * g_modelZoom / pictureH;
			// Moved by the left stick, or the right mouse button held, at the same speed on screen however close
			const float panBy = 2.f / pictureH;   // a move of one is half the picture's height
			if (ImGui::IsMouseDown(1))
			{
				g_zoomPanX += ImGui::GetIO().MouseDelta.x * panBy;
				g_zoomPanY += ImGui::GetIO().MouseDelta.y * panBy;
			}
			const auto dead = [](float v) { return fabsf(v) < 0.15f ? 0.f : v; };
			g_zoomPanX += dead(g_pad.leftX) * g_dt * 700.f * panBy;
			g_zoomPanY -= dead(g_pad.leftY) * g_dt * 700.f * panBy;
			// As far as takes it off any edge, and further the closer it is
			g_zoomPanX = std::clamp(g_zoomPanX, -(ModelViewAspect() + closer), ModelViewAspect() + closer);
			g_zoomPanY = std::clamp(g_zoomPanY, -(1.f + closer), 1.f + closer);
			ModelViewShow(TurnToShow(g_zoomYaw), g_zoomPitch, closer, g_zoomPanX, g_zoomPanY);
			if (const unsigned long long picture = ModelViewTexture())
			{
				dl->PushClipRect(ImVec2(0.f, 0.f), ImVec2(kW, kH), false);
				dl->AddImage(static_cast<ImTextureID>(picture), ImVec2(centre.x - pictureW * 0.5f, centre.y - pictureH * 0.5f), ImVec2(centre.x + pictureW * 0.5f, centre.y + pictureH * 0.5f), ImVec2(0, 0), ImVec2(1, 1), IM_COL32(255, 255, 255, static_cast<int>(255.f * ease)));
				dl->PopClipRect();
			}
		}
		else
		{
			if (ImGui::IsMouseDown(0))
			{
				g_cardZoomYaw += ImGui::GetIO().MouseDelta.x * 0.4f;
				g_cardZoomPitch -= ImGui::GetIO().MouseDelta.y * 0.3f;
			}
			g_cardZoomYaw += stickX * g_dt * 110.f;
			g_cardZoomPitch += stickY * g_dt * 70.f;
			g_cardZoomYaw = std::clamp(g_cardZoomYaw, -kCardMaxTurn, kCardMaxTurn);
			g_cardZoomPitch = std::clamp(g_cardZoomPitch, -40.f, 40.f);
			const float full = (kH - 110.f) / 1.1f;
			const float yaw = TurnToShow(g_cardZoomYaw);
			if (entry)
				DrawCardObject(*entry, centre, full * (0.72f + 0.28f * ease), yaw, g_cardZoomPitch);
		}

		// A creature in two forms: when it next changes, as the panel says it
		int formPhase = 0;
		float formSeconds = 0.f;
		if (creature && ModelViewFormClock(formPhase, formSeconds))
		{
			const std::string count = std::to_string(static_cast<int>(std::ceil(formSeconds)));
			const std::string when = formPhase == 0 ? TxFill(T_form_changes_in, count) : formPhase == 1 ? Tx(T_form_changing)
				: formPhase == 2 ? TxFill(T_form_returns_in, count) : Tx(T_form_returning);
			TextCentre(kSerif, 34, centre.x, 34.f, Alpha(formPhase == 1 || formPhase == 3 ? kGoldHi : kText, ease), when.c_str());
		}

		// Its prompts, as the window's own row has them, over the dimming
		std::vector<Hint> hints;
		if (model)
		{
			hints.push_back({ kPadLStick, Tx(T_key_right_drag), Tx(T_move), kActNone });
			hints.push_back({ kPadRStick, Tx(T_key_drag), Tx(T_zoom_turn), kActNone });
			hints.push_back({ kPadLT | kPadRT, g_keyPages.c_str(), Tx(T_zoom_zoom), kActNone });
			if (stance)
				hints.push_back({ kPadLeft | kPadRight, Tx(T_left_right), TxFill(T_ward_stance_now, AnimationName(GetSettings().wardrobeAnimation)), kActNone });
		}
		else
		{
			hints.push_back({ kPadRStick, Tx(T_key_drag), Tx(T_zoom_tilt), kActNone });
		}
		if (model)
			hints.push_back({ kPadR3, KeyLabel(kKeyZ), Tx(T_hold_to_close), kActNone, true });
		hints.push_back({ model ? kPadB : kPadR3 | kPadB, Tx(T_key_esc), Tx(T_close), kActNone });
		// A dark band under them, so a model filling the screen doesn't drown them out
		const ImU32 clear = Rgb(0, 0, 0, 0), dark = Rgb(0, 0, 0, static_cast<int>(200.f * ease));
		dl->AddRectFilledMultiColor(ImVec2(0.f, kH - 170.f), ImVec2(kW, kH - 100.f), clear, clear, dark, dark);
		dl->AddRectFilled(ImVec2(0.f, kH - 100.f), ImVec2(kW, kH), dark);
		DrawPromptRow(hints, kH - 80.f);

		// Not on the press that opened it
		// A model's goes back on a hold of the enlarge key, as it opened; a card's still on a press
		const bool enlargeKey = model ? EnlargeHeld() : (g_pad.Pressed(kPadR3) || KeyHit(kKeyZ));
		return ImGui::GetFrameCount() > g_cardZoomFrame && (enlargeKey || g_pad.Pressed(kPadB) || ImGui::IsKeyPressed(ImGuiKey_Escape, false));
	}

	void DrawCardZoom(const Entry& e, float stickX, float stickY, float wheel)
	{
		if (DrawZoom(&e, g_book == kBookItems || LiveCreature(e), LiveCreature(e), stickX, stickY, wheel))
		{
			g_statusOpen = false;
			g_cardZoom = false;
		}
	}

	std::string g_detailFor;
	float g_detailScroll = 0.f, g_detailScrollMax = 0.f;

	void DrawDetail(const Model& m, const Entry* e, const Section* section)
	{
		const Columns col = GetColumns();
		const float mx0 = col.m0, mx1 = col.m1;
		const float bottom = kBottom;
		if (!e)
			return;

		// A Gwent card shows the card itself rather than what else is left
		if (g_book == kBookBestiary)
		{
			DrawCreatureDetail(*e, section);
			return;
		}
		const bool showCard = g_book == kBookGwent && !e->picture.empty();
		const bool showModel = g_book == kBookItems && !e->itemTemplate.empty();

		// The book's sign, large and faint behind the page
		if (!showCard && !showModel)
			BookSign(g_book, ImVec2((mx0 + mx1) * 0.5f, bottom - 230), 170, Rgb(226, 196, 134, 30), 7.f, false);

		const std::string title = Upper(e->title.empty() ? e->uuid : e->title);
		const float titleRoom = mx1 - mx0 - 130;
		const int titleSize = Measure(kTitle, 32, title.c_str()).x <= titleRoom ? 32 : 24;
		std::string sub = e->region > 0 && e->region < kRegionCount ? m.regions[e->region] : section->book == kBookGwent && !m.regions[0].empty() ? m.regions[0] : section->header;
		if ((e->flags >> 2) == 1)
			sub += std::string("  -  ") + Tx(T_group_hos);
		else if ((e->flags >> 2) == 2)
			sub += std::string("  -  ") + Tx(T_group_baw);
		const float titleH = WrappedHeight(kTitle, titleSize, title.c_str(), titleRoom);
		const float boxH = std::max(118.f, 30.f + titleH + WrappedHeight(kSerif, 28, sub.c_str(), titleRoom));
		const ImVec2 ca(mx0, kTop), cb(mx1, kTop + boxH);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(112, 84, 24, 240), Rgb(40, 28, 8, 235), Rgb(26, 18, 5, 235), Rgb(84, 62, 18, 240));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f), 0.f, 0, 1.f);
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		SoftGlow(ImVec2(ca.x + 58, ca.y + 59), 62, Alpha(kGoldHi, 0.2f));
		BookSign(g_book, ImVec2(ca.x + 58, ca.y + 59), 34, Rgb(250, 232, 190), 3.f);
		Text(kTitle, titleSize, ca.x + 112, ca.y + 14, Rgb(250, 242, 220), title.c_str(), titleRoom);
		Text(kSerif, 28, ca.x + 112, ca.y + std::max(62.f, 20.f + titleH), Rgb(226, 214, 186), sub.c_str(), titleRoom);

		// Below the box it scrolls when there's more than fits, so nothing is left out
		const bool scrolls = !showCard && !showModel;
		const float viewTop = kTop + boxH + 18.f, viewBottom = bottom - 30.f;
		if (g_detailFor != e->uuid)
		{
			g_detailFor = e->uuid;
			g_detailScroll = 0.f;
		}
		if (scrolls)
		{
			if (Hover(ImVec2(mx0, viewTop), ImVec2(mx1, viewBottom)) && g_wheel != 0.f)
				g_detailScroll -= g_wheel * 90.f;
			if (!g_statusOpen && ((g_pad.buttons & kPadRight) != 0 || ImGui::IsKeyDown(ImGuiKey_RightArrow)))
				g_detailScroll += g_dt * 520.f;
			if (!g_statusOpen && ((g_pad.buttons & kPadLeft) != 0 || ImGui::IsKeyDown(ImGuiKey_LeftArrow)))
				g_detailScroll -= g_dt * 520.f;
			g_detailScroll = std::clamp(g_detailScroll, 0.f, g_detailScrollMax);
			dl->PushClipRect(ImVec2(mx0 - 4, viewTop), ImVec2(mx1 + 4, viewBottom), true);
		}
		float y = viewTop - (scrolls ? g_detailScroll : 0.f);
		Marker(*e, ImVec2(mx0 + 28, y + 21));
		Text(kSerif, 34, mx0 + 66, y, StatusColour(*e), StatusText(*e));
		y += 58;

		// A missable entry: the warning, and what else goes with it
		const Section* group = nullptr;
		for (const Section& s : m.sections)
		{
			if (s.book != kBookMissable)
				continue;
			for (const Entry& other : s.entries)
				if (other.uuid == e->uuid)
				{
					group = &s;
					break;
				}
			if (group)
				break;
		}

		if (group)
		{
			const bool live = !e->Done() && e->status != kMissed;
			const ImU32 bar = !live ? kGoldDim : group->state == 1 ? kRed : kOrange;
			const float boxW = mx1 - mx0 - 56;
			const std::string happening = group->state == 1 && !group->cutoff.empty() ? TxFill(T_urgent_quest, group->cutoff) : std::string();
			const bool showTip = !e->tip.empty() && live;
			const float happeningH = happening.empty() ? 0.f : WrappedHeight(kSerif, 30, happening.c_str(), boxW) + 8.f;
			const float headerH = WrappedHeight(kSerif, 30, group->header.c_str(), boxW);
			const float tipH = showTip ? WrappedHeight(kSerif, 28, e->tip.c_str(), boxW) + 12.f : 0.f;
			const ImVec2 wa(mx0, y), wb(mx1, y + 58 + happeningH + headerH + tipH);
			const bool urgentNow = live && group->state == 1;   // red is kept for what's happening now
			const ImU32 warmA = urgentNow ? Rgb(90, 20, 10, 210) : live ? Rgb(76, 52, 18, 210) : Rgb(34, 30, 24, 190);
			const ImU32 warmB = urgentNow ? Rgb(44, 10, 6, 190) : live ? Rgb(38, 26, 10, 190) : Rgb(24, 22, 18, 190);
			dl->AddRectFilledMultiColor(wa, wb, warmA, warmB, warmB, warmA);
			dl->AddRectFilled(wa, ImVec2(wa.x + 9, wb.y), bar);
			dl->AddRect(wa, wb, urgentNow ? Rgb(170, 62, 40) : live ? Rgb(140, 104, 52) : kGoldDim, 0.f, 0, 1.f);
			const int kind = std::clamp(group->kind, 0, 2);
			std::string head = Upper(Tx(kKinds[kind]));
			if (group->state == 1)
				head += std::string("  -  ") + Tx(T_happening_now);
			else if (group->state == 2)
				head += std::string("  -  ") + Tx(T_passed);
			Text(kTitle, 22, wa.x + 28, wa.y + 13, urgentNow ? Rgb(246, 170, 136) : live ? Rgb(236, 196, 124) : kDim, head.c_str());
			float boxY = wa.y + 46;
			if (!happening.empty())
			{
				Text(kSerif, 30, wa.x + 28, boxY, Rgb(255, 196, 160), happening.c_str(), boxW);
				boxY += happeningH;
			}
			Text(kSerif, 30, wa.x + 28, boxY, Rgb(234, 220, 202), group->header.c_str(), boxW);
			boxY += headerH + 12.f;
			if (showTip)
				Text(kSerif, 28, wa.x + 28, boxY, Rgb(226, 196, 150), e->tip.c_str(), boxW);
			y = wb.y + 26;
		}

		if (showCard)
		{
			g_detailScrollMax = 0.f;
			DrawCardPanel(*e, mx0, mx1, y, bottom - 30);
			return;
		}
		if (showModel)
		{
			g_detailScrollMax = 0.f;
			DrawModelPanel(*e, mx0, mx1, y, bottom - 30, e->itemTemplate);
			return;
		}

		// The other entries that share its fate, or the rest of its section
		const Section* list = group ? group : section;
		Text(kTitle, 24, mx0 + 6, y, kHead, !group ? Tx(T_still_to_do) : group->kind == 0 && !group->cutoff.empty() ? Tx(T_also_closes) : Tx(T_also_in_group));
		FadeLineH(mx0, mx1, y + 38, kGold);
		y += 52;
		// With a region chosen, only that region's; the rest are counted, so a group reaching elsewhere still says so
		int shown = 0, elsewhere = 0;
		for (const Entry& other : list->entries)
		{
			if (other.uuid == e->uuid || other.Done() || other.status == kMissed)
				continue;
			if (g_region != 0 && other.region != g_region)
			{
				++elsewhere;
				continue;
			}
			const bool hasRegion = other.region > 0 && other.region < kRegionCount;
			Marker(other, ImVec2(mx0 + 28, y + (hasRegion ? 26 : 20)));
			const std::string& otherTitle = other.title.empty() ? other.uuid : other.title;
			Text(kSerif, 30, mx0 + 66, y, kText, otherTitle.c_str(), mx1 - mx0 - 76);
			const float otherH = WrappedHeight(kSerif, 30, otherTitle.c_str(), mx1 - mx0 - 76);
			if (hasRegion)
				Text(kSans, 22, mx0 + 66, y + otherH, Rgb(142, 134, 118), m.regions[other.region].c_str());
			y += otherH + (hasRegion ? 35.f : 13.f);
			++shown;
		}
		if (shown == 0)
		{
			Text(kSerif, 30, mx0 + 12, y, kDim, g_region != 0 && elsewhere > 0 ? Tx(T_nothing_in_region) : Tx(T_nothing_outstanding));
			y += 44.f;
		}
		if (elsewhere > 0)
		{
			Text(kSans, 22, mx0 + 12, y, Rgb(142, 134, 118), TxFill(T_more_other_regions, std::to_string(elsewhere)).c_str(), mx1 - mx0 - 24);
			y += 36.f;
		}
		dl->PopClipRect();
		const float contentH = y + g_detailScroll - viewTop, viewH = viewBottom - viewTop;
		g_detailScrollMax = std::max(0.f, contentH - viewH);
		if (g_detailScrollMax > 0.f)
		{
			const float tx = mx1 + 8.f;
			dl->AddRectFilled(ImVec2(tx, viewTop), ImVec2(tx + 5, viewBottom), Rgb(24, 20, 14, 220));
			const float thumbH = std::max(50.f, viewH * viewH / contentH);
			const float thumbY = viewTop + (viewH - thumbH) * (g_detailScroll / g_detailScrollMax);
			dl->AddRectFilled(ImVec2(tx, thumbY), ImVec2(tx + 5, thumbY + thumbH), kGold);
		}
	}

	// A Missable group's own row has the focus: what's in it, rather than whichever entry was last selected elsewhere
	void DrawGroupDetail(const Model& m, const Section& s)
	{
		const Columns col = GetColumns();
		const float mx0 = col.m0, mx1 = col.m1, bottom = kBottom;
		BookSign(g_book, ImVec2((mx0 + mx1) * 0.5f, bottom - 230), 170, Rgb(226, 196, 134, 30), 7.f, false);

		const float room = mx1 - mx0 - 130;
		std::string partLine = Upper(Tx(kKinds[std::clamp(s.kind, 0, 2)]));
		if (s.state == 1)
			partLine += std::string("  -  ") + Tx(T_happening_now);
		else if (s.state == 2)
			partLine += std::string("  -  ") + Tx(T_passed);
		const float headerH = WrappedHeight(kSerif, 32, s.header.c_str(), room);
		const float boxH = std::max(118.f, 58.f + headerH);
		const ImVec2 ca(mx0, kTop), cb(mx1, kTop + boxH);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(112, 84, 24, 240), Rgb(40, 28, 8, 235), Rgb(26, 18, 5, 235), Rgb(84, 62, 18, 240));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f), 0.f, 0, 1.f);
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		BookSign(g_book, ImVec2(ca.x + 58, ca.y + boxH * 0.5f), 34, Rgb(250, 232, 190), 3.f);
		Text(kTitle, 20, ca.x + 112, ca.y + 14, s.state == 1 ? Rgb(246, 170, 136) : Rgb(236, 214, 170), partLine.c_str(), room);
		Text(kSerif, 32, ca.x + 112, ca.y + 44, Rgb(250, 242, 220), s.header.c_str(), room);

		const std::string key = "#" + s.header;
		if (g_detailFor != key)
		{
			g_detailFor = key;
			g_detailScroll = 0.f;
		}
		const float viewTop = kTop + boxH + 18.f, viewBottom = bottom - 30.f;
		if (Hover(ImVec2(mx0, viewTop), ImVec2(mx1, viewBottom)) && g_wheel != 0.f)
			g_detailScroll -= g_wheel * 90.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadRight) != 0 || ImGui::IsKeyDown(ImGuiKey_RightArrow)))
			g_detailScroll += g_dt * 520.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadLeft) != 0 || ImGui::IsKeyDown(ImGuiKey_LeftArrow)))
			g_detailScroll -= g_dt * 520.f;
		g_detailScroll = std::clamp(g_detailScroll, 0.f, g_detailScrollMax);
		dl->PushClipRect(ImVec2(mx0 - 4, viewTop), ImVec2(mx1 + 4, viewBottom), true);
		float y = viewTop - g_detailScroll;

		const DoneOf counted = RegionCount(s);
		Text(kSerif, 34, mx0 + 6, y, counted.All() ? kGreen : kText, TxFill(T_x_of_y, std::to_string(counted.done), std::to_string(counted.total)).c_str());
		y += 58;
		if (s.state == 1 && !s.cutoff.empty())
		{
			const std::string happening = TxFill(T_urgent_quest, s.cutoff);
			const float boxW = mx1 - mx0 - 56;
			const ImVec2 wa(mx0, y), wb(mx1, y + 28 + WrappedHeight(kSerif, 30, happening.c_str(), boxW));
			dl->AddRectFilledMultiColor(wa, wb, Rgb(90, 20, 10, 210), Rgb(44, 10, 6, 190), Rgb(44, 10, 6, 190), Rgb(90, 20, 10, 210));
			dl->AddRectFilled(wa, ImVec2(wa.x + 9, wb.y), kRed);
			dl->AddRect(wa, wb, Rgb(170, 62, 40), 0.f, 0, 1.f);
			Text(kSerif, 30, wa.x + 28, wa.y + 12, Rgb(255, 196, 160), happening.c_str(), boxW);
			y = wb.y + 26;
		}
		Text(kTitle, 24, mx0 + 6, y, kHead, Tx(T_in_this_group));
		FadeLineH(mx0, mx1, y + 38, kGold);
		y += 52;
		const float textW = mx1 - mx0 - 76;
		for (const Entry& e : s.entries)
		{
			if (!EntryShown(e))
				continue;
			const std::string& title = e.title.empty() ? e.uuid : e.title;
			const bool hasRegion = e.region > 0 && e.region < kRegionCount;
			const float titleH = WrappedHeight(kSerif, 30, title.c_str(), textW);
			Marker(e, ImVec2(mx0 + 28, y + (hasRegion ? 26.f : 20.f)));
			Text(kSerif, 30, mx0 + 66, y, e.Done() ? kDoneText : e.status == kMissed ? Rgb(180, 116, 100) : kText, title.c_str(), textW);
			y += titleH;
			if (hasRegion)
			{
				Text(kSans, 22, mx0 + 66, y, Rgb(142, 134, 118), m.regions[e.region].c_str());
				y += 28.f;
			}
			if (!e.tip.empty() && !e.Done() && e.status != kMissed)
			{
				Text(kSans, 22, mx0 + 66, y, Rgb(208, 178, 128), e.tip.c_str(), textW);
				y += WrappedHeight(kSans, 22, e.tip.c_str(), textW) + 4.f;
			}
			y += 10.f;
		}
		dl->PopClipRect();
		const float contentH = y + g_detailScroll - viewTop, viewH = viewBottom - viewTop;
		g_detailScrollMax = std::max(0.f, contentH - viewH);
		if (g_detailScrollMax > 0.f)
		{
			const float tx = mx1 + 8.f;
			dl->AddRectFilled(ImVec2(tx, viewTop), ImVec2(tx + 5, viewBottom), Rgb(24, 20, 14, 220));
			const float thumbH = std::max(50.f, viewH * viewH / contentH);
			const float thumbY = viewTop + (viewH - thumbH) * (g_detailScroll / g_detailScrollMax);
			dl->AddRectFilled(ImVec2(tx, thumbY), ImVec2(tx + 5, thumbY + thumbH), kGold);
		}
	}

	void DrawAchievementDetail(const Entry* e, const Section* section)
	{
		const Columns col = GetColumns();
		const float mx0 = col.m0, mx1 = col.m1;
		if (!e)
			return;
		const auto found = g_achievementFor.find(e->uuid);
		if (found == g_achievementFor.end())
			return;
		const Achievement& a = *found->second;
		const bool masked = AchievementMasked(a);

		BookSign(kTabAchievements, ImVec2((mx0 + mx1) * 0.5f, kBottom - 230), 170, Rgb(226, 196, 134, 30), 7.f, false);

		const ImVec2 ca(mx0, kTop), cb(mx1, kTop + 158);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(112, 84, 24, 240), Rgb(40, 28, 8, 235), Rgb(26, 18, 5, 235), Rgb(84, 62, 18, 240));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f), 0.f, 0, 1.f);
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		AchievementIcon(*e, ImVec2(ca.x + 15, ca.y + 15), 128.f);
		const std::string title = Upper(e->title);
		const float titleX = ca.x + 160, titleRoom = cb.x - titleX - 18;
		const int titleSize = Measure(kTitle, 32, title.c_str()).x <= titleRoom ? 32 : 24;
		TextFit(kTitle, titleSize, titleX, ca.y + (titleSize == 32 ? 34 : 40), Rgb(250, 242, 220), title, titleRoom);
		TextFit(kSerif, 28, titleX, ca.y + 82, Rgb(226, 214, 186), section ? section->header : "", titleRoom);

		float y = kTop + 176;
		TextFit(kSerif, 34, mx0 + 6, y, a.unlocked ? kGreen : kText, AchievementStatus(a), mx1 - mx0 - 12);
		y += 58;
		if (a.unlocked && a.whenFirstSeen)
		{
			const char* const note = Tx(T_store_no_date);
			Text(kSans, 22, mx0 + 6, y - 8, kDim, note, mx1 - mx0 - 12);
			y += WrappedHeight(kSans, 22, note, mx1 - mx0 - 12) + 12;
		}

		Text(kTitle, 24, mx0 + 6, y, kHead, Tx(T_what_it_asks));
		FadeLineH(mx0, mx1, y + 38, kGold);
		y += 52;
		const std::string description = masked ? Tx(T_secret_until_unlocked) : a.description;
		Text(kSerif, 30, mx0 + 6, y, masked ? kDim : kText, description.c_str(), mx1 - mx0 - 12);
		y += WrappedHeight(kSerif, 30, description.c_str(), mx1 - mx0 - 12) + 26;

		// What a mod's achievement gives: kept back on a hidden one, as its description is
		if (a.custom && !a.reward.empty() && !masked)
		{
			Text(kTitle, 24, mx0 + 6, y, kHead, Tx(T_custom_reward_head));
			FadeLineH(mx0, mx1, y + 38, kGold);
			y += 52;
			Text(kSerif, 30, mx0 + 6, y, kText, a.reward.c_str(), mx1 - mx0 - 12);
			y += WrappedHeight(kSerif, 30, a.reward.c_str(), mx1 - mx0 - 12) + 26;
		}

		if (a.target > 0 && !a.unlocked)
		{
			Text(kTitle, 24, mx0 + 6, y, kHead, Tx(T_on_this_save));
			FadeLineH(mx0, mx1, y + 38, kGold);
			y += 52;
			const std::string count = TxFill(T_x_of_y, std::to_string(std::min(a.value, a.target)), std::to_string(a.target));
			Text(kSerif, 30, mx0 + 6, y, kText, count.c_str());
			GoldBar(ImVec2(mx0 + 6, y + 46), ImVec2(mx1 - 6, y + 58), Fraction(std::min(a.value, a.target), a.target), g_barT);
			y += 84;
		}

		if (a.percent >= 0.f)
		{
			Text(kTitle, 24, mx0 + 6, y, kHead, Tx(T_how_rare));
			FadeLineH(mx0, mx1, y + 38, kGold);
			y += 52;
			char share[32];
			snprintf(share, sizeof(share), "%.1f", a.percent);
			const std::string rarity = TxFill(T_rarity, share, g_achievementsFrom ? g_achievementsFrom->storeName : std::string(Tx(T_this_store)));
			Text(kSerif, 30, mx0 + 6, y, kText, rarity.c_str(), mx1 - mx0 - 12);
		}
	}

	// ------------------------------------------------------------------------------------------
	// Items: what the game's tooltips say about one, read from the game when it's selected
	// ------------------------------------------------------------------------------------------

	struct ItemStats
	{
		std::string category, description, rarity, level, weight;
		bool levelTooHigh = false;
		int slots = 0;
		std::vector<std::string> primary, others;
		int setWorn = 0, setPieces = 0;
		struct SetBonus { int pieces; bool active; std::string text; };
		std::vector<SetBonus> setBonuses;
	};
	std::mutex g_itemStatsLock;
	std::map<std::string, ItemStats> g_itemStats;
	std::set<std::string> g_itemStatsAsked;
	const Entry* g_itemShown = nullptr;
	std::string g_itemStatsWanted;
	double g_itemStatsWantedAt = 0.0;

	void ReceiveItemStats(const std::string& text)
	{
		ItemStats stats;
		std::string uuid;
		for (size_t start = 0; start < text.size();)
		{
			size_t end = text.find("\\n", start);
			if (end == std::string::npos)
				end = text.size();
			const std::string line = text.substr(start, end - start);
			start = end + 2;
			std::vector<std::string> f;
			for (size_t from = 0;;)
			{
				const size_t bar = line.find('|', from);
				f.push_back(line.substr(from, bar == std::string::npos ? std::string::npos : bar - from));
				if (bar == std::string::npos)
					break;
				from = bar + 1;
			}
			if (f[0] == "I" && f.size() >= 9)
			{
				uuid = f[1];
				stats.category = CleanGameText(f[2]);
				stats.description = CleanGameText(f[3]);
				stats.rarity = CleanGameText(f[4]);
				stats.level = CleanGameText(f[5]);
				stats.levelTooHigh = f[6] == "1";
				stats.weight = CleanGameText(f[7]);
				stats.slots = atoi(f[8].c_str());
			}
			else if (f[0] == "A" && f.size() >= 3)
			{
				(f[1] == "1" ? stats.primary : stats.others).push_back(CleanGameText(f[2]));
			}
			else if (f[0] == "C" && f.size() >= 3)
			{
				stats.setWorn = atoi(f[1].c_str());
				stats.setPieces = atoi(f[2].c_str());
			}
			else if (f[0] == "S" && f.size() >= 4)
			{
				stats.setBonuses.push_back({ atoi(f[1].c_str()), f[2] == "1", CleanGameText(f[3]) });
			}
		}
		if (uuid.empty())
			return;
		std::lock_guard lock(g_itemStatsLock);
		g_itemStats[uuid] = std::move(stats);
	}

	void DrawItemStats(const Entry& e, ImVec2 ra, ImVec2 rb)
	{
		InsetPanel(ra, rb);
		PanelHeading(ra, rb.x, Tx(T_item_stats));

		// Asked for once it's stayed selected a moment, so going down a list doesn't ask about everything on the way
		ItemStats stats;
		bool have = false;
		{
			std::lock_guard lock(g_itemStatsLock);
			const auto found = g_itemStats.find(e.uuid);
			if (found != g_itemStats.end())
			{
				stats = found->second;
				have = true;
			}
		}
		const double now = ImGui::GetTime();
		if (g_itemStatsWanted != e.uuid)
		{
			g_itemStatsWanted = e.uuid;
			g_itemStatsWantedAt = now;
		}
		if (!have && now - g_itemStatsWantedAt > 0.15 && g_itemStatsAsked.insert(e.uuid).second)
			RequestExec("potpoverlay_itemstats(" + e.uuid + ")", false);
		if (!have)
		{
			Text(kSerif, 28, ra.x + 30, ra.y + 84, kDim, Tx(T_reading));
			return;
		}

		// A set's bonuses can run past the bottom. It scrolls as the other panels do.
		const std::string key = "stats" + e.uuid;
		if (g_detailFor != key)
		{
			g_detailFor = key;
			g_detailScroll = 0.f;
		}
		const float viewTop = ra.y + 66.f, viewBottom = rb.y - 8.f;
		if (Hover(ImVec2(ra.x, viewTop), ImVec2(rb.x, viewBottom)) && g_wheel != 0.f)
			g_detailScroll -= g_wheel * 90.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadRight) != 0 || ImGui::IsKeyDown(ImGuiKey_RightArrow)))
			g_detailScroll += g_dt * 520.f;
		if (!g_statusOpen && ((g_pad.buttons & kPadLeft) != 0 || ImGui::IsKeyDown(ImGuiKey_LeftArrow)))
			g_detailScroll -= g_dt * 520.f;
		g_detailScroll = std::clamp(g_detailScroll, 0.f, g_detailScrollMax);

		const float x = ra.x + 30.f, width = rb.x - ra.x - 60.f;
		float y = ra.y + 78.f - g_detailScroll;
		dl->PushClipRect(ImVec2(ra.x + 4.f, viewTop), ImVec2(rb.x - 4.f, viewBottom), true);
		const auto line = [&](Face face, int size, ImU32 colour, const std::string& text, float after)
		{
			if (text.empty())
				return;
			Text(face, size, x, y, colour, text.c_str(), width);
			y += WrappedHeight(face, size, text.c_str(), width) + after;
		};
		for (const std::string& text : stats.primary)
			line(kSerif, 34, Rgb(250, 242, 220), text, 6.f);
		line(kSans, 24, kGold, stats.category, 8.f);
		line(kSerif, 28, Rgb(232, 196, 128), stats.description, 10.f);
		for (const std::string& text : stats.others)
			line(kSerif, 28, kText, text, 2.f);
		y += 10.f;
		line(kTitle, 20, kGold, stats.rarity, 6.f);
		line(kSerif, 28, kDim, stats.weight, 2.f);
		if (stats.slots > 0)
			line(kSerif, 28, kDim, TxFill(T_item_slots, std::to_string(stats.slots)), 2.f);
		line(kSerif, 28, stats.levelTooHigh ? Rgb(226, 100, 80) : kDim, stats.level, 2.f);
		if (!stats.setBonuses.empty())
		{
			y += 12.f;
			FadeLineH(x, x + width, y, kGoldDim);
			y += 10.f;
			Text(kTitle, 20, x, y + 4.f, kGold, Tx(T_item_set));
			const std::string worn = TxFill(T_item_set_worn, std::to_string(stats.setWorn), std::to_string(stats.setPieces));
			TextRight(kSans, 22, x + width, y + 2.f, kDim, worn.c_str());
			y += 36.f;
			for (const ItemStats::SetBonus& bonus : stats.setBonuses)
			{
				line(kSans, 22, bonus.active ? kGoldHi : kGold, TxFill(T_item_set_pieces, std::to_string(bonus.pieces)), 0.f);
				line(kSerif, 28, bonus.active ? Rgb(250, 242, 220) : kDim, bonus.text, 8.f);
			}
		}
		dl->PopClipRect();
		const float contentH = y + g_detailScroll - viewTop, viewH = viewBottom - viewTop;
		g_detailScrollMax = std::max(0.f, contentH - viewH + 10.f);
		if (g_detailScrollMax > 0.f)
		{
			const float tx = rb.x - 12.f;
			dl->AddRectFilled(ImVec2(tx, viewTop), ImVec2(tx + 5, viewBottom), Rgb(24, 20, 14, 220));
			const float thumbH = std::max(50.f, viewH * viewH / contentH);
			const float thumbY = viewTop + (viewH - thumbH) * (g_detailScroll / g_detailScrollMax);
			dl->AddRectFilled(ImVec2(tx, thumbY), ImVec2(tx + 5, thumbY + thumbH), kGold);
		}
	}

	void DrawSummary(const Model& m)
	{
		const Columns col = GetColumns();
		const float rx = col.r0, rr = col.r1;
		const Counts c = BookCounts(m, g_book);
		const bool achievements = g_book == kTabAchievements;
		int secretLeft = 0, counted = 0;
		if (achievements)
			for (const auto& [script, a] : g_achievementFor)
			{
				secretLeft += a->hidden && !a->unlocked ? 1 : 0;
				counted += a->target > 0 && !a->unlocked ? 1 : 0;
			}

		const ImVec2 na(rx, kTop), nb(rr, kTop + 274);
		InsetPanel(na, nb);
		PanelHeading(na, nb.x, Upper(Tx(kBooks[g_book].name)).c_str());
		char big[32];
		snprintf(big, sizeof(big), "%d%%", c.total > 0 ? 100 * c.done / c.total : 0);
		Text(kSerif, 72, na.x + 30, na.y + 70, Rgb(232, 158, 100), big);
		char of[64];
		snprintf(of, sizeof(of), "%s", TxFill(T_x_of_y, std::to_string(c.done), std::to_string(c.total)).c_str());
		TextRight(kSerif, 32, nb.x - 30, na.y + 106, kText, of);
		GoldBar(ImVec2(na.x + 30, na.y + 160), ImVec2(nb.x - 30, na.y + 174), Fraction(c.done, c.total), g_barT);
		struct Line { const char* name; int count; ImU32 col; };
		const Line bookLines[4] = {
			{ Tx(T_status_in_progress), c.progress, kAmber },
			{ NotStartedText(), c.open, kText },
			{ Tx(T_status_ignored), c.ignored, Rgb(170, 170, 150) },
			{ Tx(T_status_missed), c.missed, Rgb(226, 100, 80) },
		};
		const Line achievementLines[4] = {
			{ Tx(T_status_unlocked), c.done, kGreen },
			{ Tx(T_status_locked), c.total - c.done, kText },
			{ Tx(T_secret_left), secretLeft, Rgb(170, 170, 150) },
			{ Tx(T_with_a_count), counted, kAmber },
		};
		const Line creatureLines[4] = {
			{ Tx(T_status_discovered), c.done - c.ignored, kGreen },
			{ Tx(T_status_undiscovered), c.open, kText },
			{ Tx(T_status_ignored), c.ignored, Rgb(170, 170, 150) },
			{ Tx(T_status_missed), c.missed, Rgb(226, 100, 80) },
		};
		const Line* const lines = achievements ? achievementLines : g_book == kBookBestiary ? creatureLines : bookLines;
		// Two columns, so the regions below all fit
		const float columnGap = 30.f, columnW = (nb.x - na.x - 60.f - columnGap) * 0.5f;
		for (int i = 0; i < 4; ++i)
		{
			const Line& l = lines[i];
			char n[16];
			snprintf(n, sizeof(n), "%d", l.count);
			const float lx = na.x + 30 + (i % 2) * (columnW + columnGap);
			const float ly = na.y + 190 + (i / 2) * 36;
			TextFit(kSerif, 28, lx, ly, l.count > 0 ? l.col : kDim, l.name, columnW - 50);
			TextRight(kSans, 26, lx + columnW, ly + 2, l.count > 0 ? l.col : kDim, n);
		}

		// By region, or by section for the books that have none
		const ImVec2 ra(rx, kTop + 290), rb(rr, kBottom);
		if (g_book == kBookBestiary && g_creatureShown)
		{
			DrawCreatureNotes(*g_creatureShown, ra, rb);
			return;
		}
		if (g_book == kBookItems && g_itemShown)
		{
			DrawItemStats(*g_itemShown, ra, rb);
			return;
		}
		InsetPanel(ra, rb);
		Counts byRegion[kRegionCount];
		int regionsUsed = 0;
		for (const Section& s : m.sections)
			if (s.book == g_book)
				for (const Entry& e : s.entries)
					if (e.region > 0 && e.region < kRegionCount)
					{
						regionsUsed += byRegion[e.region].total == 0 ? 1 : 0;
						Add(byRegion[e.region], e);
					}

		const auto row = [&](const std::string& name, int done, int total, float ry, bool on)
		{
			char count[24];
			snprintf(count, sizeof(count), "%d / %d", done, total);
			const float cw = Measure(kSans, 24, count).x;
			TextFit(kSerif, 28, ra.x + 30, ry - 2, on ? kGoldHi : kText, name, rb.x - ra.x - 80 - cw);
			TextRight(kSans, 24, rb.x - 30, ry + 2, done == total && total > 0 ? kGreen : kDim, count);
			GoldBar(ImVec2(ra.x + 30, ry + 33), ImVec2(rb.x - 30, ry + 41), Fraction(done, total), g_barT);
		};
		float ry = ra.y + 84;
		if (regionsUsed > 1)
		{
			PanelHeading(ra, rb.x, Tx(T_across_continent));
			for (int i = 1; i < kRegionCount; ++i)
			{
				if (byRegion[i].total == 0 || ry + 44 > rb.y)
					continue;
				row(m.regions[i], byRegion[i].done, byRegion[i].total, ry, i == g_region);
				ry += 54;
			}
		}
		else
		{
			PanelHeading(ra, rb.x, Tx(T_by_section));
			for (const Section& s : m.sections)
			{
				if (s.book != g_book || s.entries.empty() || ry + 44 > rb.y)
					continue;
				int done = 0;
				for (const Entry& e : s.entries)
					done += e.Done() ? 1 : 0;
				row(s.header, done, static_cast<int>(s.entries.size()), ry, false);
				ry += 54;
			}
		}

		if (achievements && g_achievementsFrom)
		{
			const AchievementList& list = *g_achievementsFrom;
			std::string note;
			if (list.fromStore)
				note = TxFill(T_read_from, list.storeName);
			else if (list.fromGame)
				note = list.storeName.empty() ? std::string(Tx(T_unlocked_from_game)) : TxFill(T_unlocked_from_game_on, list.storeName);
			else
				note = Tx(T_waiting_for_unlocks);
			// A mod's pack that couldn't be read in full: said here, so its author knows to look at the log
			if (g_customFrom && g_customFrom->problems > 0)
				note += " " + TxFill(T_custom_problems, std::to_string(g_customFrom->problems));
			const float noteW = rb.x - ra.x - 60;
			const float noteH = WrappedHeight(kSans, 22, note.c_str(), noteW);
			if (ry + noteH + 14 <= rb.y)
				Text(kSans, 22, ra.x + 30, rb.y - noteH - 18, kDim, note.c_str(), noteW);
		}
	}

	// ------------------------------------------------------------------------------------------
	// Settings
	// ------------------------------------------------------------------------------------------

	struct RowInfo { const char* name; const char* hint; };

	void DrawSettings()
	{
		Settings& st = GetSettings();
		const float m0 = 60.f, gap = 70.f;
		const float colW = (kW - m0 * 2 - gap) * 0.5f;
		const float x0 = m0, x1 = m0 + colW + gap;
		// As tall as there's room for: each column has 10 rows, the left under three headings. When the window's
		// short the hint below gives up some of its height first, as its text shrinks to fit.
		constexpr float kRows = 10.f, kHeadings = 3.f;
		const float top = 240.f;
		const float hintH = std::clamp(kH - 106.f - 12.f - top - 54.f * kHeadings - 16.f - 44.f * kRows, 64.f, 104.f);
		const float rowH = std::clamp((kH - 106.f - hintH - 12.f - top - 54.f * kHeadings - 16.f) / kRows, 44.f, 62.f);

		const float slideW = colW * 0.40f;
		const char* const kPrompts[3] = { Tx(T_prompts_automatic), Tx(T_prompts_keyboard), Tx(T_controller) };
		const char* const kStyles[5] = { Tx(T_prompts_automatic), "Xbox", "PlayStation", "Switch", "Steam Deck" };

		int count = 0;            // rows so far, for walking them
		std::vector<int> leftColumn, rightColumn;   // each row, in the order it's drawn down its column
		const char* hint = "";
		const auto rowArea = [&](float x, float y, const RowInfo& info, bool& focused)
		{
			const int index = count++;
			(x == x0 ? leftColumn : rightColumn).push_back(index);
			const ImVec2 a(x - 14, y), b(x + colW + 14, y + rowH - 6);
			if (Hover(a, b) && !g_dragging && g_dragSlider < 0 && g_setFocus != index)
			{
				g_setFocus = index;
				g_setEditing = false;
			}
			focused = g_setFocus == index;
			if (focused)
			{
				hint = info.hint;
				const bool inside = g_setEditing;
				dl->AddRectFilledMultiColor(a, b, inside ? Rgb(186, 136, 40, 220) : Rgb(146, 104, 28, 150), inside ? Rgb(70, 48, 12, 150) : Rgb(34, 22, 6, 60), inside ? Rgb(70, 48, 12, 150) : Rgb(34, 22, 6, 60), inside ? Rgb(150, 108, 30, 220) : Rgb(112, 78, 20, 150));
				dl->AddRect(a, b, inside ? Rgb(255, 244, 214) : Rgb(232, 204, 146, 200), 0.f, 0, inside ? 2.5f : 1.5f);
				dl->AddRectFilled(a, ImVec2(a.x + 5, b.y), kGoldHi);
			}
			else
			{
				FadeLineH(a.x, b.x, b.y, Rgb(120, 100, 66, 60));
			}
			Text(kSerif, 32, x + 4, y + 6, focused ? Rgb(255, 248, 230) : kText, info.name);
			return index;
		};

		const auto heading = [&](float x, float& y, const char* text)
		{
			Text(kTitle, 24, x, y + 6, kGold, text);
			FadeLineH(x - 14, x + colW + 14, y + 44, kGold);
			y += 54;
		};

		const auto slider = [&](float x, float& y, const RowInfo& info, float& value, float low, float high, float step, const char* format, float scaleShown)
		{
			bool focused = false;
			const int index = rowArea(x, y, info, focused);
			const float tx1 = x + colW - 92, tx0 = tx1 - slideW;
			const float ty = y + 28;
			const ImVec2 hitA(tx0 - 12, y), hitB(tx1 + 12, y + rowH - 6);
			if (g_clicked && Hover(hitA, hitB))
				g_dragSlider = index;
			bool changed = false;
			if (g_dragSlider == index)
			{
				const float t = std::clamp((g_mouse.x - tx0) / (tx1 - tx0), 0.f, 1.f);
				const float v = low + (high - low) * t;
				const float snapped = std::round(v / step) * step;
				if (snapped != value)
				{
					value = snapped;
					changed = true;
				}
			}
			if (focused && g_navAccept)
				g_setEditing = !g_setEditing;
			else if (focused && g_setEditing && (g_navLeft || g_navRight))
			{
				value = std::clamp(value + (g_navRight ? step : -step), low, high);
				changed = true;
			}
			if (changed)
				MarkDirty();
			const float t = (value - low) / (high - low);
			dl->AddRectFilled(ImVec2(tx0, ty - 4), ImVec2(tx1, ty + 4), Rgb(14, 12, 9));
			dl->AddRect(ImVec2(tx0 - 1, ty - 5), ImVec2(tx1 + 1, ty + 5), Rgb(92, 76, 50));
			dl->AddRectFilledMultiColor(ImVec2(tx0, ty - 4), ImVec2(tx0 + (tx1 - tx0) * t, ty + 4), Rgb(126, 84, 30), Rgb(236, 196, 116), Rgb(236, 196, 116), Rgb(126, 84, 30));
			const ImVec2 knob(tx0 + (tx1 - tx0) * t, ty);
			if (focused && g_setEditing)
				SoftGlow(knob, 30, Alpha(kGoldHi, 0.45f));
			Diamond(knob, 13, Rgb(20, 16, 10));
			Diamond(knob, 13, focused ? Rgb(255, 240, 200) : kGoldHi, false, 2.f);
			Diamond(knob, 5, focused ? Rgb(255, 240, 200) : kGoldHi);
			char text[24];
			snprintf(text, sizeof(text), format, value * scaleShown);
			TextRight(kSans, 26, x + colW, y + 12, focused ? Rgb(255, 248, 230) : kText, text);
		};

		const auto toggle = [&](float x, float& y, const RowInfo& info, bool& value)
		{
			bool focused = false;
			rowArea(x, y, info, focused);
			const ImVec2 a(x - 14, y), b(x + colW + 14, y + rowH - 6);
			if ((focused && g_navAccept) || Clicked(a, b))
			{
				value = !value;
				MarkDirty();
			}
			const ImVec2 m(x + colW - 18, y + 28);
			if (value)
				SoftGlow(m, 26, Alpha(kGoldHi, 0.35f));
			Diamond(m, 15, value ? kGoldHi : Rgb(120, 110, 90), false, 2.2f);
			if (value)
				Diamond(m, 8, kGoldHi);
			TextRight(kSans, 26, x + colW - 46, y + 12, value ? kText : kDim, value ? Tx(T_on) : Tx(T_off));
		};

		const auto choice = [&](float x, float& y, const RowInfo& info, int& value, const char* const* names, int n)
		{
			bool focused = false;
			rowArea(x, y, info, focused);
			const float right = x + colW, left = right - 250.f;
			const ImVec2 la(left, y + 8), lb(left + 34, y + 48), ra(right - 34, y + 8), rb(right, y + 48);
			int step = 0;
			if (focused && g_navAccept)
				g_setEditing = !g_setEditing;
			else if (focused && g_setEditing && g_navLeft)
				step = -1;
			else if (focused && g_setEditing && g_navRight)
				step = 1;
			if (Clicked(la, lb)) step = -1;
			if (Clicked(ra, rb)) step = 1;
			if (step != 0)
			{
				value = (value + step + n) % n;
				MarkDirty();
			}
			const ImVec2 t1[3] = { {left + 6, y + 28}, {left + 24, y + 17}, {left + 24, y + 39} };
			const ImVec2 t2[3] = { {right - 6, y + 28}, {right - 24, y + 17}, {right - 24, y + 39} };
			const bool lit = focused && g_setEditing;
			dl->AddConvexPolyFilled(t1, 3, lit ? Rgb(255, 244, 214) : Hover(la, lb) ? kGoldHi : kGold);
			dl->AddConvexPolyFilled(t2, 3, lit ? Rgb(255, 244, 214) : Hover(ra, rb) ? kGoldHi : kGold);
			TextCentre(kSerif, 30, (left + right) * 0.5f, y + 8, focused ? Rgb(255, 248, 230) : kText, names[value]);
		};

		const auto button = [&](float x, float& y, const RowInfo& info, const char* label)
		{
			bool focused = false;
			rowArea(x, y, info, focused);
			const ImVec2 a(x + colW - 250, y + 6), b(x + colW, y + 50);
			const bool hot = Hover(a, b);
			dl->AddRectFilledMultiColor(a, b, Rgb(70, 54, 24), Rgb(70, 54, 24), Rgb(36, 28, 12), Rgb(36, 28, 12));
			dl->AddRect(a, b, hot || focused ? kGoldHi : kGold, 0.f, 0, 1.5f);
			TextCentre(kSerif, 28, (a.x + b.x) * 0.5f, a.y + 5, hot || focused ? Rgb(255, 248, 230) : kText, label);
			return (focused && g_navAccept) || Clicked(ImVec2(x - 14, y), ImVec2(x + colW + 14, y + rowH - 6));
		};

		// Left: how it looks
		float y = top;
		heading(x0, y, Tx(T_the_window));
		const float scaleBefore = g_pendingScale >= 0.f ? g_pendingScale : st.scale;
		float scaleValue = scaleBefore;
		const int scaleRow = count;
		slider(x0, y, { Tx(T_scale), Tx(T_scale_hint) }, scaleValue, 0.5f, 2.f, 0.05f, "%.0f%%", 100.f);
		y += rowH;
		if (scaleValue != scaleBefore)
		{
			g_pendingScale = scaleValue;
			g_scaleCommitAt = ImGui::GetTime() + 0.5;
		}
		slider(x0, y, { Tx(T_width), Tx(T_width_hint) }, st.widthPercent, 40.f, 100.f, 1.f, "%.0f%%", 1.f);
		y += rowH;
		slider(x0, y, { Tx(T_height), Tx(T_height_hint) }, st.heightPercent, 40.f, 100.f, 1.f, "%.0f%%", 1.f);
		y += rowH;
		slider(x0, y, { Tx(T_opacity), Tx(T_opacity_hint) }, st.opacity, 0.5f, 1.f, 0.01f, "%.0f%%", 100.f);
		y += rowH;
		slider(x0, y, { Tx(T_dim), Tx(T_dim_hint) }, st.dim, 0.f, 0.9f, 0.05f, "%.0f%%", 100.f);
		y += rowH;
		if (button(x0, y, { Tx(T_position), Tx(T_position_hint) }, Tx(T_centre_it)))
		{
			st.posX = st.posY = 0.f;
			MarkDirty();
		}
		y += rowH + 8;

		heading(x0, y, Tx(T_hdr_caps));
		toggle(x0, y, { Tx(T_hdr_match), Tx(T_hdr_match_hint) }, st.hdrMatchGame);
		y += rowH;
		slider(x0, y, { Tx(T_hdr_brightness), Tx(T_hdr_brightness_hint) }, st.hdrBrightness, 80.f, 1000.f, 10.f, Tx(T_nits_format), 1.f);
		y += rowH + 8;

		// Help: the tour, and putting the window back as it came
		heading(x0, y, Tx(T_help_caps));
		if (button(x0, y, { Tx(T_tour_setting), Tx(T_tour_setting_hint) }, Tx(T_tour_setting_button)))
			g_tourAsked = true;
		y += rowH;

		if (button(x0, y, { Tx(T_defaults), Tx(T_defaults_hint) }, Tx(T_reset_all)))
		{
			const int last = st.lastBook;
			st = Settings{};
			st.lastBook = last;
			g_pendingScale = -1.f;
			MarkDirty();
		}


		// Right: the controls
		float ry = top;
		heading(x1, ry, Tx(T_controls));
		const auto keyRow = [&](const RowInfo& info, unsigned key, bool isUpdate)
		{
			bool focused = false;
			rowArea(x1, ry, info, focused);
			if (((focused && g_navAccept) || Clicked(ImVec2(x1 - 14, ry), ImVec2(x1 + colW + 14, ry + rowH - 6))) && !g_capture)
			{
				g_capture = true;
				g_captureUpdate = isUpdate;
				g_captureUntil = ImGui::GetTime() + 8.0;
			}
			if (g_capture && g_captureUpdate == isUpdate)
				TextRight(kSerif, 30, x1 + colW, ry + 8, Rgb(250, 226, 170), Tx(T_press_a_key));
			else
			{
				const std::string name = KeyName(key);
				const float w = KeyCap(0, 0, 42, name.c_str(), false);
				KeyCap(x1 + colW - w, ry + 7, 42, name.c_str(), true, focused);
			}
			ry += rowH;
		};
		keyRow({ Tx(T_open_key), Tx(T_open_key_hint) }, st.openKey, false);
		keyRow({ Tx(T_update_key), Tx(T_update_key_hint) }, st.updateKey, true);
		choice(x1, ry, { Tx(T_button_prompts), Tx(T_button_prompts_hint) }, st.promptMode, kPrompts, 3);
		ry += rowH;
		choice(x1, ry, { Tx(T_controller), Tx(T_controller_hint) }, st.padStyle, kStyles, 5);
		ry += rowH + 8;

		heading(x1, ry, Tx(T_while_open));
		toggle(x1, ry, { Tx(T_pause_game), Tx(T_pause_game_hint) }, st.pauseGame);
		ry += rowH;
		toggle(x1, ry, { Tx(T_last_tab), Tx(T_last_tab_hint) }, st.openOnLastBook);
		ry += rowH;
		toggle(x1, ry, { Tx(T_show_undiscovered), Tx(T_show_undiscovered_hint) }, st.revealUndiscovered);
		ry += rowH;
		toggle(x1, ry, { Tx(T_show_secret), Tx(T_show_secret_hint) }, st.revealHiddenAchievements);
		ry += rowH;
		toggle(x1, ry, { Tx(T_cloth_sim), Tx(T_cloth_sim_hint) }, st.clothSim);
		ry += rowH;
		toggle(x1, ry, { Tx(T_live_bestiary), Tx(T_live_bestiary_hint) }, st.liveBestiary);
		ry += rowH;
		ry += rowH + 8;

		// The scale is applied when it stops changing, as it means baking the fonts again
		if (g_dragSlider == scaleRow && !ImGui::IsMouseDown(0))
			g_scaleCommitAt = ImGui::GetTime();
		if (g_pendingScale >= 0.f && (g_dragSlider != scaleRow || !ImGui::IsMouseDown(0)) && ImGui::GetTime() >= g_scaleCommitAt)
		{
			st.scale = g_pendingScale;
			g_pendingScale = -1.f;
			MarkDirty();
		}
		if (!ImGui::IsMouseDown(0))
			g_dragSlider = -1;

		// Walking the rows, as two columns: up and down stop at the ends, left and right cross over.
		// Inside a control they're the control's own.
		if (!g_setEditing && !leftColumn.empty() && !rightColumn.empty())
		{
			int column = 0, row = 0;
			for (size_t i = 0; i < leftColumn.size(); ++i)
				if (leftColumn[i] == g_setFocus) { column = 0; row = static_cast<int>(i); }
			for (size_t i = 0; i < rightColumn.size(); ++i)
				if (rightColumn[i] == g_setFocus) { column = 1; row = static_cast<int>(i); }
			if (g_navLeft)
				column = 0;
			if (g_navRight)
				column = 1;
			const int rows = static_cast<int>(column == 0 ? leftColumn.size() : rightColumn.size());
			if (g_navDown)
				++row;
			if (g_navUp)
				--row;
			row = std::clamp(row, 0, rows - 1);
			g_setFocus = column == 0 ? leftColumn[row] : rightColumn[row];
		}

		if (g_capture && ImGui::GetTime() > g_captureUntil)
			g_capture = false;

		// What the row does
		const ImVec2 ha(m0 - 14, kH - 106 - hintH), hb(kW - m0 + 14, kH - 106);
		InsetPanel(ha, hb);
		Text(kSerif, 30, ha.x + 26, ha.y + 12, kText, hint, hb.x - ha.x - 52);
	}

	// ------------------------------------------------------------------------------------------
	// Notifications
	// ------------------------------------------------------------------------------------------

	struct PopupLine { int group = 0; bool complete = false, inProgress = false; std::string icon, text; };
	struct PopupMessage
	{
		std::string herald;   // the banner, and what for: event, update, install, ngplus, content, achievement
		std::string icon;     // an achievement's picture, as AchievementPicture takes it
		int ring = 0;         // and its ring: 0 gold, 1 silver, 2 bronze, 3 none
		float seconds = 7.f;
		int fontSize = 18, colour = 0x9DB4FF, done = 0, total = 0, more = 0;
		std::vector<PopupLine> lines;
		// A message or a warning from the scripts, rather than a list of what changed
		int kind = 0;   // 0 what changed, 1 a message, 2 a warning
		std::string title;
		struct Paragraph { std::string text; ImU32 colour = 0; };   // an empty one's a gap
		std::vector<Paragraph> body;
	};

	// The game's markup the messages use: <br/> between paragraphs, and <font color> for a paragraph's colour
	std::vector<PopupMessage::Paragraph> ParseMessageBody(const std::string& text)
	{
		std::vector<PopupMessage::Paragraph> out;
		std::vector<ImU32> colours;
		PopupMessage::Paragraph now;
		const auto finish = [&]()
		{
			out.push_back(std::move(now));
			now = PopupMessage::Paragraph{};
		};
		for (size_t i = 0; i < text.size();)
		{
			if (text[i] != '<')
			{
				if (now.text.empty() && !colours.empty())
					now.colour = colours.back();
				now.text += text[i++];
				continue;
			}
			const size_t close = text.find('>', i);
			if (close == std::string::npos)
				break;
			const std::string tag = text.substr(i + 1, close - i - 1);
			i = close + 1;
			if (tag.rfind("br", 0) == 0)
				finish();
			else if (tag.rfind("/font", 0) == 0)
			{
				if (!colours.empty())
					colours.pop_back();
			}
			else if (tag.rfind("font", 0) == 0)
			{
				const size_t hash = tag.find('#');
				ImU32 colour = colours.empty() ? 0 : colours.back();
				if (hash != std::string::npos && hash + 7 <= tag.size())
				{
					const unsigned long rgb = strtoul(tag.substr(hash + 1, 6).c_str(), nullptr, 16);
					colour = Rgb(static_cast<int>((rgb >> 16) & 255), static_cast<int>((rgb >> 8) & 255), static_cast<int>(rgb & 255));
				}
				colours.push_back(colour);
			}
		}
		finish();
		while (!out.empty() && out.back().text.empty())
			out.pop_back();
		return out;
	}

	std::mutex g_popupMutex;
	std::deque<PopupMessage> g_popupQueue;
	std::atomic<bool> g_popupHold{ false };
	std::deque<PopupMessage> g_warningQueue;
	std::unique_ptr<PopupMessage> g_warning;
	std::atomic<bool> g_warningUp{ false };
	bool g_warningDismissed = false;
	float g_warningScroll = 0.f, g_warningT = 0.f;
	std::unique_ptr<PopupMessage> g_popup;
	float g_popupAlpha = 0.f, g_popupLeft = 0.f;

	PopupMessage ParsePopup(const std::string& text)
	{
		PopupMessage m;
		size_t start = 0;
		while (start < text.size())
		{
			size_t end = text.find("\\n", start);
			if (end == std::string::npos)
				end = text.size();
			const std::string line = text.substr(start, end - start);
			start = end + 2;
			std::vector<std::string> f;
			for (size_t from = 0;;)
			{
				const size_t bar = line.find('|', from);
				f.push_back(line.substr(from, bar == std::string::npos ? std::string::npos : bar - from));
				if (bar == std::string::npos)
					break;
				from = bar + 1;
			}
			// The banner: H|what|seconds|headline|below. The overlay has the words, so it words them.
			if (f[0] == "H" && f.size() >= 5)
			{
				m.kind = 1;
				m.herald = f[1];
				m.seconds = std::max(1.f, static_cast<float>(atof(f[2].c_str())));
				m.title = CleanGameText(f[3]);
				const std::string below = f[4];
				if (m.herald == "event")
					m.body = ParseMessageBody(TxFill(T_herald_event_sub, CleanGameText(below)));
				else if (m.herald == "update")
				{
					m.title = TxFill(T_herald_update_head, m.title);
				}
				else if (m.herald == "install")
				{
					m.title = Tx(T_herald_install_head);
					m.body = ParseMessageBody(Tx(T_herald_install_sub));
				}
				else if (m.herald == "ngplus")
				{
					m.title = Tx(T_herald_ngplus_head);
					m.body = ParseMessageBody(below);
				}
				else if (m.herald == "achievement")
				{
					if (f.size() >= 6)
						m.icon = f[5];
					if (f.size() >= 7)
						m.ring = std::clamp(atoi(f[6].c_str()), 0, 3);
					m.body = ParseMessageBody(below);   // a mod's achievement: its title stays, its description and reward below
				}
				else
				{
					m.title = Tx(T_herald_content_head);
					m.body = ParseMessageBody(below);
				}
			}
			else if (f[0] == "P" && f.size() >= 7)
			{
				m.kind = atoi(f[1].c_str()) == 2 ? 2 : 1;
				if (m.kind == 1)
					m.herald = "note";   // no other kind is sent now, but a plain message still has somewhere to go
				m.seconds = std::max(1.f, static_cast<float>(atof(f[2].c_str())));
				m.fontSize = atoi(f[3].c_str());
				m.colour = ColourValue(f[4]);
				m.title = CleanGameText(f[5]);
				m.body = ParseMessageBody(f[6]);
			}
			else if (f[0] == "N" && f.size() >= 6)
			{
				m.seconds = std::max(1.f, static_cast<float>(atof(f[1].c_str())));
				m.fontSize = atoi(f[2].c_str());
				m.colour = ColourValue(f[3]);
				m.done = atoi(f[4].c_str());
				m.total = atoi(f[5].c_str());
			}
			else if (f[0] == "L" && f.size() >= 5)
			{
				PopupLine l;
				l.group = std::clamp(atoi(f[1].c_str()), 0, 2);
				l.complete = f[2] == "1";
				l.inProgress = f[2] == "2";
				l.icon = f[3];
				l.text = CleanGameText(f[4]);
				m.lines.push_back(std::move(l));
			}
			else if (f[0] == "M" && f.size() >= 2)
			{
				m.more = atoi(f[1].c_str());
			}
		}
		return m;
	}

	// The notification text colour setting, as 0xRRGGBB (see ColourValue)
	ImU32 PopupTextColour(int rgb)
	{
		return RgbOf(rgb);
	}

	// The mark for a line: the icon the mod names, or a drawn one if the game hasn't got it
	void PopupIcon(const std::string& icon, ImVec2 c)
	{
		const float s = 13.f;
		const auto has = [&](const char* part) { return icon.find(part) != std::string::npos; };
		// card:picture, a Gwent card: a square from the top of its art, with rounded corners and a thin gold edge
		if (icon.rfind("card:", 0) == 0)
		{
			if (const unsigned long long portrait = CardPortraitTexture(icon.substr(5)))
			{
				const float half = 15.f;
				const ImVec2 a(c.x - half, c.y - half), b(c.x + half, c.y + half);
				dl->AddImageRounded(static_cast<ImTextureID>(portrait), a, b, ImVec2(0, 0), ImVec2(1, 1), IM_COL32_WHITE, 4.f);
				dl->AddRect(a, b, Rgb(196, 160, 96, 220), 4.f, 0, 1.5f);
				return;
			}
		}
		// pin:Name, one of the world map's pins as the map menu draws it. pin:A%B draws A in B's colour with B in white
		// over its middle: a quest's diamond, coloured for the part of the game it's from, with its exclamation mark.
		if (icon.rfind("pin:", 0) == 0)
		{
			const float half = 17.f;
			const size_t split = icon.find('%', 4);
			const std::string base = icon.substr(4, split == std::string::npos ? std::string::npos : split - 4);
			const unsigned long long pin = MapPinTexture(base);
			if (split == std::string::npos)
			{
				if (pin)
					dl->AddImage(static_cast<ImTextureID>(pin), ImVec2(c.x - half, c.y - half), ImVec2(c.x + half, c.y + half));
				return;
			}
			const std::string mark = icon.substr(split + 1);
			uint8_t rgb[3] = { 255, 255, 255 };
			MapPinColour(mark, rgb);
			if (pin)
				dl->AddImage(static_cast<ImTextureID>(pin), ImVec2(c.x - half, c.y - half), ImVec2(c.x + half, c.y + half), ImVec2(0, 0), ImVec2(1, 1), IM_COL32(rgb[0], rgb[1], rgb[2], 255));
			if (const unsigned long long white = MapPinWhiteTexture(mark))
			{
				const float markHalf = half * 0.6f;   // the mark a little over half the diamond's height
				dl->AddImage(static_cast<ImTextureID>(white), ImVec2(c.x - markHalf, c.y - markHalf), ImVec2(c.x + markHalf, c.y + markHalf));
			}
			return;
		}
		// Anything else is an item's icon: in a slot with a thin gold edge, like a card's portrait
		if (!icon.empty())
			if (const unsigned long long tile = ItemTileTexture(icon))
			{
				const float half = 15.f, inner = 13.f;
				const ImVec2 a(c.x - half, c.y - half), b(c.x + half, c.y + half);
				dl->AddRectFilled(a, b, Rgb(22, 19, 14, 235), 4.f);
				dl->AddImage(static_cast<ImTextureID>(tile), ImVec2(c.x - inner, c.y - inner), ImVec2(c.x + inner, c.y + inner));
				dl->AddRect(a, b, Rgb(196, 160, 96, 220), 4.f, 0, 1.5f);
				return;
			}
		if (!icon.empty())
			if (const LoadedIcon* loaded = GameIcon(icon))
			{
				const float box = 34.f, fit = std::min(box / loaded->w, box / loaded->h);
				const float halfW = loaded->w * fit * 0.5f, halfH = loaded->h * fit * 0.5f;
				dl->AddImage(static_cast<ImTextureID>(loaded->texture), ImVec2(c.x - halfW, c.y - halfH), ImVec2(c.x + halfW, c.y + halfH));
				return;
			}
		if (has("tracked_gold") || has("tracked_blue") || has("tracked_red"))
		{
			const ImU32 col = has("tracked_blue") ? Rgb(96, 150, 230) : has("tracked_red") ? Rgb(226, 88, 76) : Rgb(232, 150, 48);
			dl->AddCircle(c, s, col, 28, 2.5f);
			Diamond(c, s * 0.5f, col);
		}
		else if (has("gwint") || has("gwent"))
		{
			const ImU32 col = Rgb(120, 170, 110);
			dl->AddRectFilled(ImVec2(c.x - s * 0.65f, c.y - s), ImVec2(c.x + s * 0.65f, c.y + s), Alpha(col, 0.28f), 2.f);
			dl->AddRect(ImVec2(c.x - s * 0.65f, c.y - s), ImVec2(c.x + s * 0.65f, c.y + s), col, 2.f, 0, 2.f);
			Diamond(c, s * 0.34f, col);
		}
		else if (has("banditcamp"))
		{
			const ImU32 col = Rgb(206, 76, 52);
			const ImVec2 f[5] = { {c.x, c.y - s}, {c.x + s * 0.6f, c.y + s * 0.1f}, {c.x + s * 0.35f, c.y + s * 0.65f}, {c.x - s * 0.35f, c.y + s * 0.65f}, {c.x - s * 0.6f, c.y + s * 0.1f} };
			dl->AddConvexPolyFilled(f, 5, col);
			dl->AddLine(ImVec2(c.x - s, c.y + s * 0.9f), ImVec2(c.x + s, c.y + s * 0.9f), col, 2.5f);
		}
		else if (has("monsterden") || has("monsternest"))
		{
			const ImU32 col = Rgb(170, 70, 60);
			const ImVec2 t[3] = { {c.x, c.y - s * 0.7f}, {c.x + s, c.y + s * 0.9f}, {c.x - s, c.y + s * 0.9f} };
			dl->AddConvexPolyFilled(t, 3, col);
			const ImVec2 d[3] = { {c.x, c.y}, {c.x + s * 0.32f, c.y + s * 0.9f}, {c.x - s * 0.32f, c.y + s * 0.9f} };
			dl->AddConvexPolyFilled(d, 3, Rgb(20, 14, 10));
		}
		else if (has("tracked_"))
		{
			const ImU32 col = Rgb(196, 100, 60);
			dl->AddRectFilled(ImVec2(c.x - s, c.y - s * 0.3f), ImVec2(c.x + s, c.y + s * 0.8f), col, 2.f);
			dl->AddRectFilled(ImVec2(c.x - s, c.y - s * 0.75f), ImVec2(c.x + s, c.y - s * 0.38f), Alpha(col, 0.7f), 3.f);
		}
		else if (!icon.empty())
		{
			const ImU32 col = Rgb(170, 186, 204);
			dl->AddLine(ImVec2(c.x - s * 0.7f, c.y + s), ImVec2(c.x + s * 0.8f, c.y - s), col, 3.f);
			dl->AddLine(ImVec2(c.x - s * 0.8f, c.y + s * 0.15f), ImVec2(c.x + s * 0.05f, c.y + s * 0.75f), col, 2.5f);
		}
	}

	// Compact, as it sits over the game: the herald's band, at the place the settings give
	constexpr float kPopupHead = 80.f, kPopupRow = 36.f, kPopupGroup = 32.f, kPopupFoot = 16.f;

	struct PopupLayout { float scale, x, y, w, h; int rows; bool headings; };


	float MessageHeight(const PopupMessage& m, float width, int size)
	{
		float h = 0.f;
		for (const PopupMessage::Paragraph& p : m.body)
			h += p.text.empty() ? static_cast<float>(size) * 0.6f : WrappedHeight(kSerif, size, p.text.c_str(), width) + 4.f;
		return h;
	}

	void DrawMessageBody(const PopupMessage& m, float x, float y, float width, int size, ImU32 ink)
	{
		for (const PopupMessage::Paragraph& p : m.body)
		{
			if (p.text.empty())
			{
				y += static_cast<float>(size) * 0.6f;
				continue;
			}
			Text(kSerif, size, x, y, p.colour ? p.colour : ink, p.text.c_str(), width);
			y += WrappedHeight(kSerif, size, p.text.c_str(), width) + 4.f;
		}
	}

	// Its size and place on screen: the settings say where in the room there is, and the font size setting how big
	PopupLayout LayOutPopup(const PopupMessage& m)
	{
		const ImGuiIO& io = ImGui::GetIO();
		const Settings& st = GetSettings();
		PopupLayout l;
		l.scale = g_k * std::clamp(static_cast<float>(m.fontSize) / 18.f, 0.7f, 1.8f);
		const float margin = 28.f * g_k;
		// Headings only earn their room when there's more than one kind of thing to tell apart
		int groups = 0;
		bool seen[3] = {};
		for (const PopupLine& line : m.lines)
			if (!seen[line.group])
			{
				seen[line.group] = true;
				++groups;
			}
		l.headings = groups > 1;
		const float room = (io.DisplaySize.x - margin * 2.f) / l.scale;
		l.w = std::min(room, 780.f);
		const float headings = l.headings ? groups * kPopupGroup : 0.f;
		const int fits = std::max(1, static_cast<int>((std::min(io.DisplaySize.y - margin * 2.f, io.DisplaySize.y * 0.55f) / l.scale - kPopupHead - kPopupFoot - headings - kPopupRow) / kPopupRow));
		l.rows = std::min(fits, static_cast<int>(m.lines.size()));
		const bool extra = m.more > 0 || l.rows < static_cast<int>(m.lines.size());
		l.h = kPopupHead + headings + l.rows * kPopupRow + (extra ? kPopupRow : 0.f) + kPopupFoot;
		l.x = margin + std::clamp(st.popupX, 0.f, 1.f) * std::max(0.f, io.DisplaySize.x - l.w * l.scale - margin * 2.f);
		l.y = margin + std::clamp(st.popupY, 0.f, 1.f) * std::max(0.f, io.DisplaySize.y - l.h * l.scale - margin * 2.f);
		return l;
	}

	void DrawPopup(const PopupMessage& m, const PopupLayout& l, float alpha)
	{
		const int firstVertex = dl->VtxBuffer.Size;
		const int firstCommand = dl->CmdBuffer.Size;
		dl->PushClipRect(ImVec2(-10000, -10000), ImVec2(20000, 20000), false);

		const float w = l.w, h = l.h;

		// The main window's ground: worn dark leather with smoke through it, a little see-through, darker to the edges.
		// A soft shadow lifts it off the world behind, and gold hairlines along the top and foot fade out at the ends.
		// The shadow: thin rings outside it, each a little wider, rounder and fainter, so it falls off evenly all the way round
		constexpr int kRings = 14;
		constexpr float kRing = 2.4f;
		for (int i = 0; i < kRings; ++i)
		{
			const float out = (static_cast<float>(i) + 0.5f) * kRing;
			const float fade = 1.f - static_cast<float>(i) / kRings;
			dl->AddRect(ImVec2(-out, -out), ImVec2(w + out, h + out), Rgb(0, 0, 0, static_cast<int>(70.f * fade * fade)), out, 0, kRing + 0.6f);
		}
		Field(3000000 + static_cast<int>(h) * 4000 + static_cast<int>(w), ImVec2(0, 0), ImVec2(w, h), 12.f, [=](float x, float y)
		{
			const float big = Fbm(x * 0.0035f + 3.f, y * 0.0035f, 4);
			const float grain = Fbm(x * 0.07f, y * 0.07f, 2);
			const float u = x / w - 0.5f, v = y / h - 0.45f;
			const float vignette = std::clamp(1.1f - (u * u + v * v) * 1.5f, 0.45f, 1.f);
			const float value = (9.f + big * 26.f + (grain - 0.5f) * 7.f) * vignette;
			return Rgb(static_cast<int>(value), static_cast<int>(value * 0.91f), static_cast<int>(value * 0.80f), 222);
		});
		FadeLineH(0, w, 0, kGold, 1.6f);
		FadeLineH(0, w, h - 1, Alpha(kGold, 0.7f), 1.2f);

		// The mod's emblem, its name, how far along the whole path is, and a line showing it with what this update added
		const float textX = 70.f;
		dl->AddCircleFilled(ImVec2(36, 36), 23, Rgb(10, 9, 7));
		dl->AddCircle(ImVec2(36, 36), 23, kGold, 40, 1.6f);
		BookSign(kBookQuest, ImVec2(36, 36), 16.f, kGoldHi, 2.f, false);   // the Quests tab's book
		Text(kTitle, 24, textX, 14, kHead, Tx(T_title_caps));
		const int whole = m.total > 0 ? 100 * m.done / m.total : 0;
		const std::string counts = TxFill(T_x_of_y, std::to_string(m.done), std::to_string(m.total)) + "  \xC2\xB7  " + std::to_string(whole) + "%";
		const float countsRight = w - 26.f;
		TextRight(kSans, 24, countsRight, 16, kDim, counts.c_str());
		int gained = 0;
		for (const PopupLine& line : m.lines)
			gained += line.complete ? 1 : 0;
		const ImVec2 ma(textX, 56), mb(countsRight, 59);
		dl->AddRectFilled(ma, mb, Rgb(255, 255, 255, 22));
		if (m.total > 0)
		{
			const float span = mb.x - ma.x;
			const float before = span * static_cast<float>(std::max(0, m.done - gained)) / static_cast<float>(m.total);
			const float after = span * static_cast<float>(m.done) / static_cast<float>(m.total);
			dl->AddRectFilledMultiColor(ma, ImVec2(ma.x + before, mb.y), Rgb(126, 92, 40), kGold, kGold, Rgb(126, 92, 40));
			if (after > before)
			{
				// What this update added: brighter, a few pixels wide at least so a single find still shows
				const float x0 = ma.x + before, x1 = std::max(ma.x + after, x0 + 4.f);
				SoftGlow(ImVec2((x0 + x1) * 0.5f, (ma.y + mb.y) * 0.5f), 12, Alpha(kGoldHi, 0.5f));
				dl->AddRectFilled(ImVec2(x0, ma.y - 1), ImVec2(x1, mb.y + 1), kGoldHi);
			}
		}

		// What changed, under small headings when there's more than one kind
		const char* const kHeads[3] = { Tx(T_tab_quests_caps), Tx(T_items_and_cards_caps), Tx(T_tab_world_caps) };
		const ImU32 ink = PopupTextColour(m.colour);
		const float room = w - textX - 60.f;
		float y = kPopupHead;
		int shown = 0, group = -1;
		for (const PopupLine& line : m.lines)
		{
			if (shown >= l.rows)
				break;
			if (l.headings && line.group != group)
			{
				group = line.group;
				Text(kSans, 20, textX, y + 6, kDim, kHeads[group]);
				y += kPopupGroup;
			}
			if (!line.icon.empty())
				PopupIcon(line.icon, ImVec2(textX + 12, y + 18));
			const float lineX = line.icon.empty() ? textX : textX + 36.f;
			TextFit(kSerif, 28, lineX, y + 1, ink, line.text, room - (lineX - textX));
			// Its state just after its name: a tick for done, an amber ring for under way
			const float after = lineX + std::min(Measure(kSerif, 28, line.text.c_str()).x, room - (lineX - textX)) + 16.f;
			if (line.complete)
				Tick(ImVec2(after + 8, y + 18), 7, kGreen, 2.5f);
			else if (line.inProgress)
			{
				dl->AddCircle(ImVec2(after + 8, y + 18), 7, kAmber, 20, 2.f);
				dl->AddCircleFilled(ImVec2(after + 8, y + 18), 3, kAmber);
			}
			y += kPopupRow;
			++shown;
		}
		const int more = m.more + static_cast<int>(m.lines.size()) - shown;
		if (more > 0)
		{
			const std::string text = TxFill(T_and_more, std::to_string(more));
			Text(kSerif, 26, textX, y + 1, kDim, text.c_str());
		}
		dl->PopClipRect();

		// Everything above is in its own space
		const ImGuiIO& io = ImGui::GetIO();
		for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
		{
			ImDrawVert& v = dl->VtxBuffer[i];
			v.pos.x = l.x + v.pos.x * l.scale;
			v.pos.y = l.y + v.pos.y * l.scale;
			if (alpha < 1.f)
				v.col = Alpha(v.col, alpha);
		}
		for (int i = std::max(0, firstCommand - 1); i < dl->CmdBuffer.Size; ++i)
			dl->CmdBuffer[i].ClipRect = ImVec4(0.f, 0.f, io.DisplaySize.x, io.DisplaySize.y);
	}

	// The banner for the things worth stopping for: at the top of the screen, like the game's own big messages
	void DrawHerald(const PopupMessage& m, float alpha)
	{
		const ImGuiIO& io = ImGui::GetIO();
		const int firstVertex = dl->VtxBuffer.Size;
		const int firstCommand = dl->CmdBuffer.Size;
		dl->PushClipRect(ImVec2(-10000, -10000), ImVec2(20000, 20000), false);

		const float scale = std::max(g_k, 0.72f);
		const float w = std::min(io.DisplaySize.x / scale, 1500.f);
		const float textW = w * 0.74f;
		const ImU32 line = kGoldHi, kicker = kGoldHi, head = Rgb(250, 242, 220), below = kText;

		// The text first, as it says how tall the banner is
		const int headSize = Measure(kTitle, 48, m.title.c_str()).x <= textW ? 48 : 32;
		const float headW = Measure(kTitle, headSize, m.title.c_str()).x;
		const float headTop = 122.f;
		const float bodyTop = headTop + static_cast<float>(headSize) + 14.f;
		const float lineH = WrappedHeight(kSerif, 28, "H", 100000.f);
		const bool achievement = m.herald == "achievement";
		const char* const what = m.herald == "event" ? Tx(T_herald_event) : m.herald == "update" ? Tx(T_herald_update) : achievement ? Tx(T_herald_achievement) : Tx(T_title_caps);

		// Centred, a line at a time
		struct Piece { std::string text; float y, w; };
		std::vector<Piece> pieces;
		float y = bodyTop;
		ImFont* font = FontOf(kSerif, 28);
		for (const PopupMessage::Paragraph& p : m.body)
		{
			if (p.text.empty())
			{
				y += 10.f;
				continue;
			}
			const char* s = p.text.c_str();
			const char* const end = s + p.text.size();
			while (s < end)
			{
				const char* next = font->CalcWordWrapPositionA(28.f / font->FontSize, s, end, textW);
				if (next == s)
					++next;
				std::string piece(s, next);
				while (!piece.empty() && piece.back() == ' ')
					piece.pop_back();
				pieces.push_back({ piece, y, Measure(kSerif, 28, piece.c_str()).x });
				y += lineH;
				s = next;
				while (s < end && (*s == ' ' || *s == '\n'))
					++s;
			}
			y += 4.f;
		}

		const float bandTop = 44.f;
		const float h = y + 24.f;
		const float cx = w * 0.5f;
		const float bw = w, bh = h - bandTop;
		// The main window's ground, worn dark leather with smoke through it, faded out at the sides and edges as before
		Field(3000 + static_cast<int>(bh) * 10 + static_cast<int>(bw) * 100000, ImVec2(0, bandTop), ImVec2(w, h), 14.f, [=](float px, float py)
		{
			const float dx = (px - bw * 0.5f) / (bw * 0.5f), dy = (py - bh * 0.5f) / (bh * 0.5f);
			const float across = std::clamp((1.f - std::fabs(dx)) / 0.3f, 0.f, 1.f);
			const float down = std::clamp((1.f - std::fabs(dy)) / 0.16f, 0.f, 1.f);
			const int a = static_cast<int>(236.f * across * down);
			const float big = Fbm(px * 0.0035f + 3.f, py * 0.0035f, 4);
			const float grain = Fbm(px * 0.07f, py * 0.07f, 2);
			const float value = (9.f + big * 26.f + (grain - 0.5f) * 7.f) * (0.7f + 0.3f * across);
			return Rgb(static_cast<int>(value), static_cast<int>(value * 0.91f), static_cast<int>(value * 0.80f), a);
		});
		FadeLineH(w * 0.14f, w * 0.86f, bandTop, line, 1.5f);
		FadeLineH(w * 0.14f, w * 0.86f, h, line, 1.5f);

		// The medallion, sitting on the top line
		const ImVec2 c(cx, bandTop + 2.f);
		dl->AddCircleFilled(c, 38.f, Rgb(10, 8, 6), 40);
		dl->AddCircle(c, 38.f, line, 40, 2.5f);
		if (achievement && !m.icon.empty())
		{
			// Its own picture, in its ring's colour as in the tab: gold is the banner's own bright gold
			const ImU32 kRingColours[4] = { line, Rgb(196, 202, 210), Rgb(198, 132, 84), kGoldDim };
			AchievementPicture(m.icon, ImVec2(c.x - 27.f, c.y - 27.f), 54.f, false, kRingColours[m.ring]);
		}
		else
		{
			// The tabs' own icons: the cog for the mod's updates, the crown for an achievement with no picture of its own,
			// and the Quests book for events and everything else
			const int book = m.herald == "update" ? kTabSettings : achievement ? kTabAchievements : kBookQuest;
			BookSign(book, c, 26.f, line, 2.5f, false);
		}

		TextCentre(kTitle, 22, cx, 92.f, kicker, what);
		const float headX = cx - std::min(headW, textW) * 0.5f;
		TextFit(kTitle, headSize, headX, headTop, head, m.title, textW);
		for (const Piece& piece : pieces)
			Text(kSerif, 28, cx - piece.w * 0.5f, piece.y, below, piece.text.c_str());

		// It comes down as it fades in
		const float ox = (io.DisplaySize.x - w * scale) * 0.5f;
		const float oy = io.DisplaySize.y * 0.03f - (1.f - alpha) * 26.f * scale;
		for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
		{
			ImDrawVert& v = dl->VtxBuffer[i];
			v.pos.x = ox + v.pos.x * scale;
			v.pos.y = oy + v.pos.y * scale;
			if (alpha < 1.f)
				v.col = Alpha(v.col, alpha);
		}
		for (int i = std::max(0, firstCommand - 1); i < dl->CmdBuffer.Size; ++i)
			dl->CmdBuffer[i].ClipRect = ImVec4(0.f, 0.f, io.DisplaySize.x, io.DisplaySize.y);
	}

	// One at a time. It waits, and its time stops, while the game's own is up or the window's open
	void UpdatePopup()
	{
		if (!g_popup)
		{
			std::lock_guard lock(g_popupMutex);
			if (!g_popupQueue.empty())
			{
				g_popup = std::make_unique<PopupMessage>(std::move(g_popupQueue.front()));
				g_popupQueue.pop_front();
				g_popupLeft = g_popup->seconds;
				g_popupAlpha = 0.f;
			}
		}
		if (!g_popup)
			return;
		const bool hold = g_popupHold || MenuOpen();
		if (hold || g_popupLeft <= 0.f)
		{
			g_popupAlpha = std::max(0.f, g_popupAlpha - g_dt * 3.f);
			if (g_popupAlpha <= 0.f && g_popupLeft <= 0.f)
			{
				g_popup.reset();
				return;
			}
		}
		else
		{
			g_popupAlpha = std::min(1.f, g_popupAlpha + g_dt * 5.f);
			if (g_popupAlpha >= 1.f)
				g_popupLeft -= g_dt;
		}
		if (g_popupAlpha > 0.f && !MenuOpen())
		{
			if (!g_popup->herald.empty())
				DrawHerald(*g_popup, g_popupAlpha);
			else
				DrawPopup(*g_popup, LayOutPopup(*g_popup), g_popupAlpha);
		}
	}

	// Placing it, as Completionist places its notifications: the window steps aside for a sample, which is dragged
	// or moved with the arrows, the d-pad or the left stick
	void DrawPlacement()
	{
		const ImGuiIO& io = ImGui::GetIO();
		Settings& st = GetSettings();
		static const PopupMessage sample = ParsePopup("N|7|18|0|310|1404\\nL|0|1|pin:QuestObjectiveOther%QuestAvailable|Blood on the Battlefield\\nL|0|1|pin:QuestObjectiveOther%QuestAvailable|Iron Maiden\\nL|1|0|icons/inventory/weapons/axe_01_64x128.png|Angivare\\nL|1|0|card:nml_toad|Toad\\nL|2|0|pin:BanditCampfire|Bandit Camp: North of the Sawmill");
		const PopupLayout l = LayOutPopup(sample);
		const ImVec2 mouse(io.MousePos.x * g_mouseScale.x, io.MousePos.y * g_mouseScale.y);
		const ImVec2 a(l.x, l.y), b(l.x + l.w * l.scale, l.y + l.h * l.scale);
		const float roomX = std::max(1.f, io.DisplaySize.x - l.w * l.scale - 56.f * g_k), roomY = std::max(1.f, io.DisplaySize.y - l.h * l.scale - 56.f * g_k);
		const bool over = !g_padMode && mouse.x >= a.x && mouse.x < b.x && mouse.y >= a.y && mouse.y < b.y;
		static bool dragging = false;
		if (!ImGui::IsMouseDown(0))
			dragging = false;
		else if (ImGui::IsMouseClicked(0) && over)
			dragging = true;
		bool moving = false;
		if (dragging)
		{
			st.popupX = std::clamp(st.popupX + io.MouseDelta.x * g_mouseScale.x / roomX, 0.f, 1.f);
			st.popupY = std::clamp(st.popupY + io.MouseDelta.y * g_mouseScale.y / roomY, 0.f, 1.f);
			moving = true;
		}
		const float across = ((ImGui::IsKeyDown(ImGuiKey_RightArrow) || (g_pad.buttons & kPadRight)) ? 1.f : 0.f) - ((ImGui::IsKeyDown(ImGuiKey_LeftArrow) || (g_pad.buttons & kPadLeft)) ? 1.f : 0.f) + g_pad.leftX;
		const float down = ((ImGui::IsKeyDown(ImGuiKey_DownArrow) || (g_pad.buttons & kPadDown)) ? 1.f : 0.f) - ((ImGui::IsKeyDown(ImGuiKey_UpArrow) || (g_pad.buttons & kPadUp)) ? 1.f : 0.f) - g_pad.leftY;
		if (across != 0.f || down != 0.f)
		{
			st.popupX = std::clamp(st.popupX + across * g_dt * 0.5f, 0.f, 1.f);
			st.popupY = std::clamp(st.popupY + down * g_dt * 0.5f, 0.f, 1.f);
			moving = true;
		}

		dl->AddRectFilled(ImVec2(0, 0), io.DisplaySize, Rgb(0, 0, 0, 90));
		const PopupLayout now = LayOutPopup(sample);
		DrawPopup(sample, now, 1.f);
		const float pad = 8.f * g_k;
		dl->AddRect(ImVec2(now.x - pad, now.y - pad), ImVec2(now.x + now.w * now.scale + pad, now.y + now.h * now.scale + pad), over || moving ? kGoldHi : Alpha(kGoldHi, 0.7f), 0.f, 0, 2.f);

		// The instructions, in the half of the screen it isn't in
		const int firstVertex = dl->VtxBuffer.Size;
		const float k = g_k;
		const float cx = io.DisplaySize.x * 0.5f / k;
		const float cy = (now.y + now.h * now.scale * 0.5f < io.DisplaySize.y * 0.5f ? io.DisplaySize.y * 0.68f : io.DisplaySize.y * 0.32f) / k;
		const ImVec2 pa(cx - 400, cy - 110), pb(cx + 400, cy + 110);
		dl->AddRectFilled(pa, pb, Rgb(14, 12, 9, 244));
		dl->AddRect(pa, pb, kGold, 0.f, 0, 2.f);
		FadeLineH(pa.x, pb.x, pa.y, kGoldHi, 2.f);
		TextCentre(kTitle, 24, cx, pa.y + 22, kHead, Tx(T_place_notification));
		TextCentre(kSerif, 30, cx, pa.y + 68, kText, Tx(T_place_drag));
		TextCentre(kSerif, 28, cx, pa.y + 112, kDim, TxKeys(T_place_keep).c_str());
		TextCentre(kSans, 24, cx, pa.y + 162, kDim, Tx(T_place_game_note));
		g_mouse = ImVec2(mouse.x / k, mouse.y / k);
		DrawCursor();
		for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
		{
			ImDrawVert& v = dl->VtxBuffer[i];
			v.pos.x *= k;
			v.pos.y *= k;
		}

		if (ImGui::IsKeyPressed(ImGuiKey_Enter, false) || g_pad.Pressed(kPadA))
		{
			g_placing = false;
			MarkDirty();
		}
		else if (g_pad.Pressed(kPadB))
		{
			g_placing = false;
			st.popupX = g_placeFromX;
			st.popupY = g_placeFromY;
		}
	}

	// ------------------------------------------------------------------------------------------
	// The colour picker (from Completionist-NG's, drawn the window's way)
	// ------------------------------------------------------------------------------------------

	constexpr int kColourSwatches[] = {
		0xFFFFFF, 0xC0C0C0, 0x808080, 0x404040, 0xC6A262, 0xFFD700, 0xEAAB00, 0xFFA500, 0xE37222, 0xBD4F19,
		0xCC3333, 0x990033, 0xB3FF00, 0x9EAB05, 0x13A81C, 0x99FFFF, 0x4398DE, 0x8C6CD0, 0x800080, 0xFF66CC,
	};
	constexpr int kSwatchCount = static_cast<int>(std::size(kColourSwatches));
	constexpr int kSwatchColumns = 10;
	constexpr int kPickerBars = kSwatchCount;          // 20-22: hue, saturation, brightness
	constexpr int kPickerDone = kPickerBars + 3;
	constexpr int kPickerDefault = kPickerDone + 1;

	void Hsv(int rgb, float& h, float& s, float& v)
	{
		ImGui::ColorConvertRGBtoHSV(((rgb >> 16) & 255) / 255.f, ((rgb >> 8) & 255) / 255.f, (rgb & 255) / 255.f, h, s, v);
	}

	int FromHsv(float h, float s, float v)
	{
		float r, g, b;
		ImGui::ColorConvertHSVtoRGB(std::clamp(h, 0.f, 0.9999f), std::clamp(s, 0.f, 1.f), std::clamp(v, 0.f, 1.f), r, g, b);
		const auto ch = [](float x) { return static_cast<int>(std::lround(std::clamp(x, 0.f, 1.f) * 255.f)); };
		return (ch(r) << 16) | (ch(g) << 8) | ch(b);
	}

	// A cut gem of colour: lit along the top, shaded at the foot, ringed in gold when it's the one picked
	void ColourGem(ImVec2 a, ImVec2 b, int rgb, bool picked, bool lit)
	{
		const float h = b.y - a.y;
		if (picked)
			dl->AddRectFilled(ImVec2(a.x - 4, a.y - 4), ImVec2(b.x + 4, b.y + 4), Alpha(kGoldHi, 0.28f), 4.f);
		dl->AddRectFilled(a, b, RgbOf(rgb), 3.f);
		dl->AddRectFilled(a, ImVec2(b.x, a.y + h * 0.42f), Rgb(255, 255, 255, 34), 3.f, ImDrawFlags_RoundCornersTop);
		dl->AddRectFilled(ImVec2(a.x, b.y - h * 0.28f), b, Rgb(0, 0, 0, 44), 3.f, ImDrawFlags_RoundCornersBottom);
		dl->AddRect(a, b, picked || lit ? kGoldHi : Rgb(92, 76, 50), 3.f, 0, picked ? 2.2f : 1.2f);
	}

	void OpenColourPicker(const ModVar& v, int index)
	{
		g_picker = ColourPicker{};
		g_picker.open = true;
		g_picker.var = index;
		g_picker.original = g_picker.current = ColourValue(v.value);
		g_picker.fallback = v.fallback.empty() ? -1 : ColourValue(v.fallback);
		float s, b;
		Hsv(g_picker.current, g_picker.hue, s, b);
		const int* found = std::find(std::begin(kColourSwatches), std::end(kColourSwatches), g_picker.current);
		g_picker.focus = found != std::end(kColourSwatches) ? static_cast<int>(found - std::begin(kColourSwatches)) : kPickerBars;
		g_setEditing = true;
	}

	// Over the page, between its top and bottom. click and accept are this frame's, held back from the page under it.
	void DrawColourPicker(ModPage& page, float x0, float x1, float top, float bottom, bool click, bool accept)
	{
		ColourPicker& p = g_picker;
		ModVar& v = page.vars[p.var];

		// The page under it, dimmed
		dl->AddRectFilled(ImVec2(x0 - 14, top), ImVec2(x1 + 14, bottom), Rgb(6, 5, 4, 170));
		const float w = std::min(980.f, x1 - x0), h = 560.f;
		const ImVec2 a((x0 + x1 - w) * 0.5f, std::max(top, (top + bottom - h) * 0.5f)), b(a.x + w, a.y + h);
		dl->AddRectFilledMultiColor(a, b, Rgb(26, 22, 16, 250), Rgb(26, 22, 16, 250), Rgb(14, 12, 9, 250), Rgb(14, 12, 9, 250));
		dl->AddRect(a, b, kGold, 0.f, 0, 1.5f);
		dl->AddRect(ImVec2(a.x + 6, a.y + 6), ImVec2(b.x - 6, b.y - 6), Rgb(92, 72, 44, 120));
		const float pad = 40.f, inner = w - pad * 2;
		float y = a.y + 26;
		const std::string title = Upper(v.label);
		TextCentre(kTitle, 26, (a.x + b.x) * 0.5f, y, kGoldHi, title.c_str());
		y += 44;
		FadeLineH(a.x + pad, b.x - pad, y, kGold);
		y += 16;

		// Steering: the swatches as a grid, then the bars, then Done and Default
		if (g_navLeft || g_navRight || g_navUp || g_navDown)
		{
			int& f = p.focus;
			if (f < kSwatchCount)
			{
				const int row = f / kSwatchColumns, column = f % kSwatchColumns;
				if (g_navLeft && column > 0) --f;
				else if (g_navRight && column + 1 < kSwatchColumns) ++f;
				else if (g_navUp && row > 0) f -= kSwatchColumns;
				else if (g_navDown) f = (row + 1) * kSwatchColumns < kSwatchCount ? f + kSwatchColumns : kPickerBars;
			}
			else if (f < kPickerDone)
			{
				if (g_navUp) f = f == kPickerBars ? kSwatchCount - kSwatchColumns : f - 1;
				else if (g_navDown) ++f;
			}
			else if (g_navUp) f = kPickerDone - 1;
			else if (g_navLeft && f == kPickerDone && p.fallback >= 0) f = kPickerDefault;
			else if (g_navRight && f == kPickerDefault) f = kPickerDone;
		}
		const auto pick = [&](int rgb)
		{
			p.current = rgb;
			float s, bright;
			Hsv(rgb, p.hue, s, bright);
		};

		// The swatches
		Text(kSans, 22, a.x + pad, y, kDim, Upper(Tx(T_colour_swatches)).c_str());
		y += 32;
		const float gap = 12.f, cell = (inner - gap * (kSwatchColumns - 1)) / kSwatchColumns, cellH = std::round(cell * 0.62f);
		for (int i = 0; i < kSwatchCount; ++i)
		{
			const ImVec2 sa(a.x + pad + (i % kSwatchColumns) * (cell + gap), y + (i / kSwatchColumns) * (cellH + gap)), sb(sa.x + cell, sa.y + cellH);
			const bool here = p.focus == i;
			if ((click && Hover(sa, sb)) || (here && accept))
				pick(kColourSwatches[i]);
			ColourGem(sa, sb, kColourSwatches[i], kColourSwatches[i] == p.current, here || Hover(sa, sb));
			if (here)
				dl->AddRect(ImVec2(sa.x - 6, sa.y - 6), ImVec2(sb.x + 6, sb.y + 6), Rgb(255, 248, 230), 4.f, 0, 2.f);
		}
		y += 2 * cellH + gap + 24;

		// Your own: hue, saturation and brightness, each its own bar
		Text(kSans, 22, a.x + pad, y, kDim, Upper(Tx(T_colour_custom)).c_str());
		y += 30;
		float hue = p.hue, sat, bright, ignored;
		Hsv(p.current, ignored, sat, bright);
		const TextId names[3] = { T_colour_hue, T_colour_saturation, T_colour_brightness };
		float* values[3] = { &hue, &sat, &bright };
		bool barMoved = false;
		for (int k = 0; k < 3; ++k)
		{
			const bool here = p.focus == kPickerBars + k;
			const float lx0 = a.x + pad, lx1 = b.x - pad;
			const float by = y + 30;
			const ImVec2 ba(lx0 + 10, by), bb(lx1 - 10, by + 12);
			const ImVec2 hitA(lx0, y), hitB(lx1, by + 24);
			if (click && Hover(hitA, hitB))
				p.drag = k;
			if (p.drag == k && ImGui::IsMouseDown(0))
			{
				*values[k] = std::clamp((g_mouse.x - ba.x) / (bb.x - ba.x), 0.f, 1.f);
				barMoved = true;
			}
			if (here && (g_navLeft || g_navRight))
			{
				*values[k] = std::clamp(*values[k] + (g_navRight ? 0.02f : -0.02f), 0.f, 1.f);
				barMoved = true;
			}
			const bool lit = here || p.drag == k || Hover(hitA, hitB);
			Text(kSans, 22, lx0 + 10, y, lit ? kGoldHi : kText, Tx(names[k]));
			const std::string amount = std::to_string(static_cast<int>(std::lround(*values[k] * (k == 0 ? 360.f : 100.f)))) + (k == 0 ? "\xC2\xB0" : "%");
			TextRight(kSans, 22, lx1 - 10, y, kDim, amount.c_str());
			constexpr int kSegments = 24;
			for (int i = 0; i < kSegments; ++i)
			{
				const float t0 = static_cast<float>(i) / kSegments, t1 = static_cast<float>(i + 1) / kSegments;
				const auto at = [&](float t) { return RgbOf(k == 0 ? FromHsv(t, 1.f, 1.f) : k == 1 ? FromHsv(hue, t, bright) : FromHsv(hue, sat, t)); };
				const ImU32 c0 = at(t0), c1 = at(t1);
				dl->AddRectFilledMultiColor(ImVec2(ba.x + (bb.x - ba.x) * t0, ba.y), ImVec2(ba.x + (bb.x - ba.x) * t1, bb.y), c0, c1, c1, c0);
			}
			dl->AddRect(ImVec2(ba.x - 1, ba.y - 1), ImVec2(bb.x + 1, bb.y + 1), lit ? kGoldHi : Rgb(92, 76, 50), 0.f, 0, lit ? 1.6f : 1.f);
			const ImVec2 knob(ba.x + (bb.x - ba.x) * *values[k], (ba.y + bb.y) * 0.5f);
			if (lit)
				SoftGlow(knob, 24, Alpha(kGoldHi, 0.4f));
			Diamond(knob, 11, Rgb(20, 16, 10));
			Diamond(knob, 11, here ? Rgb(255, 248, 230) : kGoldHi, false, 2.f);
			Diamond(knob, 5, RgbOf(k == 0 ? FromHsv(hue, 1.f, 1.f) : FromHsv(hue, sat, bright)));
			y += 64;
		}
		if (!ImGui::IsMouseDown(0))
			p.drag = -1;
		if (barMoved)
		{
			p.hue = hue;
			p.current = FromHsv(hue, sat, bright);
		}

		// Before and after, then Default and Done
		y += 8;
		const float chipY = y, chipH = 34.f;
		float cx = a.x + pad;
		const auto chip = [&](TextId label, int rgb)
		{
			Text(kSans, 22, cx, chipY + 4, kDim, Tx(label));
			cx += Measure(kSans, 22, Tx(label)).x + 14;
			ColourGem(ImVec2(cx, chipY), ImVec2(cx + 70, chipY + chipH), rgb, false, false);
			cx += 70 + 28;
		};
		chip(T_colour_current, p.original);
		chip(T_colour_new, p.current);
		Text(kSans, 22, cx, chipY + 4, kText, ("#" + ColourHex(p.current)).c_str());

		const auto button = [&](float bx1, const char* label, bool here)
		{
			const ImVec2 ba(bx1 - 200, chipY - 4), bb(bx1, chipY + 40);
			const bool hot = Hover(ba, bb);
			dl->AddRectFilledMultiColor(ba, bb, Rgb(70, 54, 24), Rgb(70, 54, 24), Rgb(36, 28, 12), Rgb(36, 28, 12));
			dl->AddRect(ba, bb, hot || here ? kGoldHi : kGold, 0.f, 0, here ? 2.f : 1.5f);
			TextCentre(kSerif, 28, (ba.x + bb.x) * 0.5f, ba.y + 4, hot || here ? Rgb(255, 248, 230) : kText, label);
			return (click && hot) || (here && accept);
		};
		const bool done = button(b.x - pad, Tx(T_done), p.focus == kPickerDone);
		if (p.fallback >= 0 && button(b.x - pad - 220, Tx(T_colour_default), p.focus == kPickerDefault))
			pick(p.fallback);
		if (done)
		{
			v.value = ColourHex(p.current);
			SendValue(page, v);
			p.open = false;
			g_setEditing = false;
		}
	}

	// A page of the mod's menu, built from what the game's config says it holds
	void DrawModPage(ModPage& page)
	{
		const float x0 = 60.f, x1 = kW - 60.f;
		const float top = 240.f, bottom = kH - 106.f - 104.f - 14.f;
		const float viewH = bottom - top;
		const float rowH = 56.f, headH = 58.f;
		const float controlW = std::min(620.f, (x1 - x0) * 0.42f);

		struct ModRow { int kind; int index; float y; const char* head; };   // kind 0 heading, 1 setting, 2 preset, 3 reset, 4 the page's introduction
		std::vector<ModRow> rows;
		float y = 0;
		const float introH = page.intro.empty() ? 0.f : WrappedHeight(kSans, 26, page.intro.c_str(), x1 - x0 - 8);
		if (!page.intro.empty())
		{
			rows.push_back({ 4, 0, y, nullptr });
			y += introH + 16.f;
		}
		const auto addHeading = [&](const char* text)
		{
			if (!rows.empty())
				y += 10.f;
			rows.push_back({ 0, 0, y, text });
			y += headH;
		};
		// 5: placing the notification
		if (page.id == "ProgressOnThePath_NotificationSettings")
		{
			rows.push_back({ 5, 0, y, nullptr });
			y += rowH;
		}
		if (!page.presets.empty())
		{
			addHeading(Tx(T_presets_caps));
			for (int i = 0; i < static_cast<int>(page.presets.size()); ++i)
			{
				rows.push_back({ 2, i, y, nullptr });
				y += rowH;
			}
		}
		std::string lastHead = "\x01";
		std::vector<std::string> upperHeads;
		upperHeads.reserve(page.vars.size() + 1);
		for (int i = 0; i < static_cast<int>(page.vars.size()); ++i)
		{
			const ModVar& v = page.vars[i];
			if (v.head != lastHead || v.startsGroup)
			{
				if (v.head != lastHead && !v.head.empty())
				{
					upperHeads.push_back(Upper(v.head));
					addHeading(upperHeads.back().c_str());
				}
				else if (v.startsGroup && i > 0)
				{
					y += 22.f;
				}
				lastHead = v.head;
			}
			rows.push_back({ 1, i, y, nullptr });
			y += rowH;
		}
		addHeading(Tx(T_reset_caps));
		rows.push_back({ 3, 0, y, nullptr });
		y += rowH;
		const float contentH = y;

		std::vector<int> focusable;
		for (int i = 0; i < static_cast<int>(rows.size()); ++i)
			if (rows[i].kind != 0 && rows[i].kind != 4)
				focusable.push_back(i);
		g_modFocus = std::clamp(g_modFocus, 0, static_cast<int>(focusable.size()) - 1);

		// Up and down stop at the ends. Inside a control, left and right are the control's.
		bool moved = false;
		if (!g_setEditing)
		{
			const int step = g_navDown ? 1 : g_navUp ? -1 : g_navPageDown ? 8 : g_navPageUp ? -8 : 0;
			if (step != 0)
			{
				bool landed = false;
				if (g_modFreeScrolled)
				{
					// The selection was left behind off screen: start again from the first row in view
					const ModRow& at = rows[focusable[g_modFocus]];
					if (at.y < g_modScroll || at.y + rowH > g_modScroll + viewH)
						for (int i = 0; i < static_cast<int>(focusable.size()); ++i)
						{
							const ModRow& r = rows[focusable[i]];
							if (r.y >= g_modScroll && r.y + rowH <= g_modScroll + viewH)
							{
								g_modFocus = i;
								landed = true;
								break;
							}
						}
					g_modFreeScrolled = false;
				}
				if (!landed)
					g_modFocus = std::clamp(g_modFocus + step, 0, static_cast<int>(focusable.size()) - 1);
				moved = true;
			}
		}

		const ImVec2 la(x0 - 14, top), lb(x1 + 14, bottom);
		// While a colour picker's open the page under it takes nothing: this frame's click and accept are the picker's.
		// Back closes it by leaving the control, and the colour stays as it was.
		if (g_picker.open && (!g_setEditing || g_picker.var < 0 || g_picker.var >= static_cast<int>(page.vars.size())))
			g_picker.open = false;
		const bool pickerUp = g_picker.open;
		const bool pickerClick = g_clicked, pickerAccept = g_navAccept;
		if (pickerUp)
			g_clicked = g_navAccept = false;
		if (Hover(la, lb) && g_wheel != 0.f && !pickerUp)
		{
			g_modScroll -= g_wheel * 148.f;
			g_modFreeScrolled = true;
		}
		if (g_pad.rightY != 0.f && !pickerUp)
		{
			g_modScroll -= g_pad.rightY * g_dt * 1300.f;
			g_modFreeScrolled = true;
		}
		if (moved)
		{
			// Keep the row in view, with its heading when it's the first under one
			const int at = focusable[g_modFocus];
			const float rowTop = g_modFocus == 0 ? 0.f : at > 0 && rows[at - 1].kind == 0 ? rows[at - 1].y : rows[at].y;
			if (rowTop < g_modScroll)
				g_modScroll = rowTop;
			if (rows[at].y + rowH > g_modScroll + viewH)
				g_modScroll = rows[at].y + rowH - viewH;
		}
		g_modScroll = std::clamp(g_modScroll, 0.f, std::max(0.f, contentH - viewH));
		g_modScrollShown += (g_modScroll - g_modScrollShown) * std::min(1.f, g_dt * 18.f);
		if (std::fabs(g_modScroll - g_modScrollShown) < 0.5f)
			g_modScrollShown = g_modScroll;

		std::string hint;
		bool warn = false;
		dl->PushClipRect(la, lb, false);
		for (int i = 0; i < static_cast<int>(rows.size()); ++i)
		{
			const ModRow& r = rows[i];
			const float ry = top + r.y - g_modScrollShown;
			if (ry + std::max(rowH, introH) < top || ry > bottom)
				continue;
			if (r.kind == 4)
			{
				Text(kSans, 26, x0 + 4, ry, kDim, page.intro.c_str(), x1 - x0 - 8);
				continue;
			}
			if (r.kind == 0)
			{
				Text(kTitle, 24, x0, ry + 8, kGold, r.head);
				FadeLineH(x0 - 14, x1 + 14, ry + 48, kGold);
				continue;
			}

			const int thisFocus = static_cast<int>(std::find(focusable.begin(), focusable.end(), i) - focusable.begin());
			const ImVec2 a(x0 - 14, ry), b(x1 + 14, ry + rowH - 6);
			const bool inList = Hover(la, lb) && !pickerUp;
			if (Hover(a, b) && inList && g_dragSlider < 0 && g_modFocus != thisFocus)
			{
				g_modFocus = thisFocus;
				g_setEditing = false;
			}
			const bool focused = g_modFocus == thisFocus;
			const bool inside = focused && g_setEditing;
			if (focused)
			{
				dl->AddRectFilledMultiColor(a, b, inside ? Rgb(186, 136, 40, 220) : Rgb(146, 104, 28, 150), inside ? Rgb(70, 48, 12, 150) : Rgb(34, 22, 6, 60), inside ? Rgb(70, 48, 12, 150) : Rgb(34, 22, 6, 60), inside ? Rgb(150, 108, 30, 220) : Rgb(112, 78, 20, 150));
				dl->AddRect(a, b, inside ? Rgb(255, 244, 214) : Rgb(232, 204, 146, 200), 0.f, 0, inside ? 2.5f : 1.5f);
				dl->AddRectFilled(a, ImVec2(a.x + 5, b.y), kGoldHi);
			}
			else
			{
				FadeLineH(a.x, b.x, b.y, Rgb(120, 100, 66, 60));
			}
			const ImU32 nameCol = focused ? Rgb(255, 248, 230) : kText;
			const float nameRoom = x1 - x0 - controlW - 30;
			const float my = ry + 25;

			if (r.kind == 1)
			{
				ModVar& v = page.vars[r.index];
				const bool danger = v.id.find("Reset") != std::string::npos;
				TextFit(kSerif, 32, x0 + 4, ry + 6, danger ? Rgb(236, 130, 100) : nameCol, v.label, nameRoom);
				// The full update's key, as the prompts along the bottom show keys: what this one turns on
				if (v.id == "ProgressOnThePath_EnableHotKey")
				{
					const float after = x0 + 4 + std::min(Measure(kSerif, 32, v.label.c_str()).x, nameRoom) + 16.f;
					const std::string key = KeyName(GetSettings().updateKey);
					// Level with the name's capitals, not the row's middle, which sits lower than the letters
					const float level = ry + 6 + InkCentre(kSerif, 32, "H").y;
					KeyCap(after, level - 20.f, 40.f, key.c_str(), true, false);
				}
				if (focused)
				{
					warn = danger;
					hint = danger ? Tx(T_ng_reset_hint) : v.hint;
				}
				if (v.type == kVarToggle)
				{
					const bool on = v.value == "true";
					if ((focused && g_navAccept) || (Clicked(a, b) && inList))
					{
						v.value = on ? "false" : "true";
						SendValue(page, v);
					}
					const bool nowOn = v.value == "true";
					const ImVec2 m(x1 - 18, my);
					if (nowOn)
						SoftGlow(m, 26, Alpha(kGoldHi, 0.35f));
					Diamond(m, 15, nowOn ? kGoldHi : Rgb(120, 110, 90), false, 2.2f);
					if (nowOn)
						Diamond(m, 8, kGoldHi);
					TextRight(kSans, 26, x1 - 46, ry + 9, nowOn ? kText : kDim, nowOn ? Tx(T_on) : Tx(T_off));
				}
				else if (v.type == kVarSlider)
				{
					float value = static_cast<float>(atof(v.value.c_str()));
					const float tx1 = x1 - 92, tx0 = tx1 - (controlW - 100);
					const ImVec2 hitA(tx0 - 12, ry), hitB(tx1 + 12, ry + rowH - 6);
					const int dragId = 1000 + r.index;
					if (g_clicked && Hover(hitA, hitB) && inList)
						g_dragSlider = dragId;
					float next = value;
					bool sliderMoved = false;
					if (g_dragSlider == dragId && v.fixedRange)
					{
						next = v.low + (v.high - v.low) * std::clamp((g_mouse.x - tx0) / (tx1 - tx0), 0.f, 1.f);
						sliderMoved = true;
					}
					else if (focused && g_navAccept && v.fixedRange)
					{
						g_setEditing = !g_setEditing;
					}
					else if (inside && (g_navLeft || g_navRight))
					{
						next = value + (g_navRight ? v.step : -v.step);
						sliderMoved = true;
					}
					if (sliderMoved)
						next = std::clamp(v.low + std::round((next - v.low) / v.step) * v.step, v.low, v.high);
					if (sliderMoved && next != value)
					{
						value = next;
						char text[32];
						if (value == std::floor(value))
							snprintf(text, sizeof(text), "%d", static_cast<int>(value));
						else
							snprintf(text, sizeof(text), "%g", value);
						v.value = text;
						SendValue(page, v);
					}
					const float t = v.high > v.low ? std::clamp((value - v.low) / (v.high - v.low), 0.f, 1.f) : 0.f;
					dl->AddRectFilled(ImVec2(tx0, my - 4), ImVec2(tx1, my + 4), Rgb(14, 12, 9));
					dl->AddRect(ImVec2(tx0 - 1, my - 5), ImVec2(tx1 + 1, my + 5), Rgb(92, 76, 50));
					dl->AddRectFilledMultiColor(ImVec2(tx0, my - 4), ImVec2(tx0 + (tx1 - tx0) * t, my + 4), Rgb(126, 84, 30), Rgb(236, 196, 116), Rgb(236, 196, 116), Rgb(126, 84, 30));
					const ImVec2 knob(tx0 + (tx1 - tx0) * t, my);
					if (inside)
						SoftGlow(knob, 30, Alpha(kGoldHi, 0.45f));
					Diamond(knob, 13, Rgb(20, 16, 10));
					Diamond(knob, 13, focused ? Rgb(255, 240, 200) : kGoldHi, false, 2.f);
					Diamond(knob, 5, focused ? Rgb(255, 240, 200) : kGoldHi);
					TextRight(kSans, 26, x1, ry + 9, nameCol, v.value.c_str());
				}
				else if (v.type == kVarColour)
				{
					// Its colour and hex on the right; choosing it opens the picker
					if (!pickerUp && ((focused && g_navAccept) || (Clicked(a, b) && inList)))
						OpenColourPicker(v, r.index);
					const int rgb = ColourValue(v.value);
					const float level = ry + 6 + InkCentre(kSerif, 30, "H").y;
					const ImVec2 sa(x1 - 74, level - 14), sb(x1 - 4, level + 14);
					ColourGem(sa, sb, rgb, false, focused);
					const std::string hex = "#" + ColourHex(rgb);
					TextRight(kSans, 26, sa.x - 16, ry + 9, nameCol, hex.c_str());
				}
				else
				{
					const int n = static_cast<int>(v.options.size());
					const int current = n > 0 ? std::clamp(atoi(v.value.c_str()), 0, n - 1) : 0;
					const float left = x1 - controlW, right = x1;
					const ImVec2 aL(left, ry + 6), aLb(left + 34, ry + 46), aR(right - 34, ry + 6), aRb(right, ry + 46);
					int step = 0;
					if (focused && g_navAccept)
						g_setEditing = !g_setEditing;
					else if (inside && g_navLeft)
						step = -1;
					else if (inside && g_navRight)
						step = 1;
					if (Clicked(aL, aLb)) step = -1;
					if (Clicked(aR, aRb)) step = 1;
					if (step != 0 && n > 0)
					{
						v.value = std::to_string((current + step + n) % n);
						SendValue(page, v);
					}
					const ImVec2 t1[3] = { {left + 6, my}, {left + 24, my - 11}, {left + 24, my + 11} };
					const ImVec2 t2[3] = { {right - 6, my}, {right - 24, my - 11}, {right - 24, my + 11} };
					dl->AddConvexPolyFilled(t1, 3, inside ? Rgb(255, 244, 214) : Hover(aL, aLb) ? kGoldHi : kGold);
					dl->AddConvexPolyFilled(t2, 3, inside ? Rgb(255, 244, 214) : Hover(aR, aRb) ? kGoldHi : kGold);
					if (n > 0)
					{
						const int shown = std::clamp(atoi(v.value.c_str()), 0, n - 1);
						const std::string& name = v.options[shown];
						const float room = controlW - 80;
						const float width = std::min(Measure(kSerif, 30, name.c_str()).x, room);
						TextFit(kSerif, 30, (left + right) * 0.5f - width * 0.5f, ry + 6, nameCol, name, room);
					}
				}
			}
			else
			{
				const bool preset = r.kind == 2;
				const bool placeIt = r.kind == 5;
				const std::string name = placeIt ? Tx(T_position) : preset ? page.presets[r.index] : Tx(T_this_page);
				Text(kSerif, 32, x0 + 4, ry + 6, nameCol, name.c_str());
				const char* label = placeIt ? Tx(T_place_it) : preset ? Tx(T_apply) : Tx(T_reset_it);
				const ImVec2 ba(x1 - 250, ry + 5), bb(x1, ry + 47);
				const bool hot = Hover(ba, bb) && inList;
				dl->AddRectFilledMultiColor(ba, bb, Rgb(70, 54, 24), Rgb(70, 54, 24), Rgb(36, 28, 12), Rgb(36, 28, 12));
				dl->AddRect(ba, bb, hot || focused ? kGoldHi : kGold, 0.f, 0, 1.5f);
				TextCentre(kSerif, 28, (ba.x + bb.x) * 0.5f, ba.y + 4, hot || focused ? Rgb(255, 248, 230) : kText, label);
				if (focused)
					hint = placeIt ? Tx(T_notification_position_hint) : preset ? (page.presetHint.empty() ? TxFill(T_preset_hint, name) : page.presetHint) : Tx(T_reset_page_hint);
				if ((focused && g_navAccept) || (Clicked(a, b) && inList))
				{
					if (placeIt)
					{
						const Settings& placing = GetSettings();
						g_placing = true;
						g_placeFromX = placing.popupX;
						g_placeFromY = placing.popupY;
						continue;
					}
					RequestExec(preset ? "potpoverlay_preset(" + page.id + ", " + std::to_string(r.index) + ")" : "potpoverlay_resetgroup(" + page.id + ")", true);
					g_modDirty = true;
				}
			}
		}
		dl->PopClipRect();
		if (!ImGui::IsMouseDown(0))
			g_dragSlider = -1;

		if (contentH > viewH)
		{
			const ImVec2 ta(x1 + 22, top), tb(x1 + 30, bottom);
			dl->AddRectFilled(ta, tb, Rgb(24, 20, 14, 220));
			dl->AddRect(ta, tb, Rgb(70, 58, 38));
			const float thumbH = std::max(60.f, viewH * viewH / contentH);
			const float thumbY = top + (viewH - thumbH) * (g_modScrollShown / (contentH - viewH));
			dl->AddRectFilledMultiColor(ImVec2(ta.x, thumbY), ImVec2(tb.x, thumbY + thumbH), kGold, kGold, kGoldDim, kGoldDim);
		}

		const ImVec2 ha(x0 - 14, kH - 106 - 104), hb(x1 + 14, kH - 106);
		InsetPanel(ha, hb);
		// The mod's own hints differ in length and language: the size they fit the panel at
		const float hintRoom = hb.x - ha.x - 52;
		int hintSize = 30;
		while (hintSize > 20 && WrappedHeight(kSerif, hintSize, hint.c_str(), hintRoom) > hb.y - ha.y - 16)
			hintSize -= 2;
		const float hintH = WrappedHeight(kSerif, hintSize, hint.c_str(), hintRoom);
		Text(kSerif, hintSize, ha.x + 26, ha.y + (hb.y - ha.y - hintH) * 0.5f, warn ? Rgb(246, 170, 136) : kText, hint.c_str(), hintRoom);

		if (pickerUp && g_picker.open)
			DrawColourPicker(page, x0, x1, top, bottom, pickerClick, pickerAccept);
		g_clicked = pickerClick;
		g_navAccept = pickerAccept;
	}

	// The Settings tab: a row of pages, the window's own first and then the mod's
	void DrawSettingsTab()
	{
		const int pageCount = 1 + static_cast<int>(g_pages.size());
		g_setPage = std::clamp(g_setPage, 0, pageCount - 1);

		// Circle/B, or Esc, leaves a control. It only closes the window from outside one.
		if (g_setEditing && g_pad.Pressed(kPadB))
		{
			g_setEditing = false;
			g_backConsumed = true;
		}

		const auto goTo = [&](int page)
		{
			if (page == g_setPage)
				return;
			g_setPage = page;
			g_setEditing = false;
			g_modFocus = 0;
			g_modScroll = g_modScrollShown = 0.f;
		};
		if (!g_setEditing && !g_capture)
		{
			if (g_pad.Pressed(kPadLT) || KeyHit(kKeyA))
				goTo((g_setPage + pageCount - 1) % pageCount);
			if (g_pad.Pressed(kPadRT) || KeyHit(kKeyD))
				goTo((g_setPage + 1) % pageCount);
		}

		const float rw = std::min(260.f, (kW - 72.f) / pageCount);
		const float rx0 = kW * 0.5f - rw * pageCount * 0.5f;
		for (int i = 0; i < pageCount; ++i)
		{
			const ImVec2 a(rx0 + rw * i + 5, 168), b(rx0 + rw * (i + 1) - 5, 226);
			const bool on = g_setPage == i;
			if (on)
			{
				Field(300 + static_cast<int>(rw), a, b, 7.f, [=](float px, float py)
				{
					return Mix(Rgb(150, 118, 68), Rgb(232, 204, 148), Fbm(px * 0.03f, py * 0.09f, 3));
				});
				dl->AddRect(a, b, Rgb(60, 44, 22), 0.f, 0, 2.f);
			}
			else
			{
				dl->AddRectFilled(a, b, Hover(a, b) ? Rgb(50, 40, 24, 220) : Rgb(0, 0, 0, 170));
				dl->AddRect(a, b, kGoldDim, 0.f, 0, 1.5f);
			}
			const std::string name = i == 0 ? Tx(T_the_window) : Upper(g_pages[i - 1].title);
			const float room = b.x - a.x - 14;
			const int size = Measure(kTitle, 22, name.c_str()).x <= room ? 22 : 20;
			const float tw = std::min(Measure(kTitle, size, name.c_str()).x, room);
			TextFit(kTitle, size, (a.x + b.x) * 0.5f - tw * 0.5f, (a.y + b.y) * 0.5f - InkCentre(kTitle, size, "H").y, on ? kInk : Rgb(198, 188, 166), name, room);
			if (Clicked(a, b))
				goTo(i);
		}

		if (g_setPage == 0)
			DrawSettings();
		else
			DrawModPage(g_pages[g_setPage - 1]);
	}

	// ------------------------------------------------------------------------------------------
	// Prompts along the bottom
	// ------------------------------------------------------------------------------------------

	struct StatusChoice { int manual; const char* name; const char* hint; ImU32 colour; };

	const StatusChoice* StatusChoices()
	{
		static StatusChoice choices[4];
		choices[0] = { 0, Tx(T_prompts_automatic), Tx(T_status_auto_hint), kGoldHi };
		choices[1] = { 2, Tx(T_status_completed), Tx(T_status_completed_hint), kGreen };
		choices[2] = { 1, Tx(T_status_ignored), Tx(T_status_ignored_hint), Rgb(176, 176, 156) };
		choices[3] = { 3, Tx(T_status_missed), Tx(T_status_missed_hint), Rgb(226, 100, 80) };
		return choices;
	}
	constexpr int kStatusChoiceCount = 4;

	// What can be set on it. Missed doesn't stick on what the game counts as done, and Completed would change
	// nothing, so neither is offered there, unless it's what was set.
	int VisibleStatuses(const Entry& e, const StatusChoice* out[kStatusChoiceCount])
	{
		int count = 0;
		for (int i = 0; i < kStatusChoiceCount; ++i)
		{
			const StatusChoice& c = StatusChoices()[i];
			if ((c.manual == 2 || c.manual == 3) && e.gameDone && e.manual != c.manual)
				continue;
			out[count++] = &c;
		}
		return count;
	}

	// A set stone holding the status's mark: the same marks as the list, and a circling arrow for automatic
	void StatusMedallion(const StatusChoice& c, ImVec2 m, bool lit)
	{
		if (lit)
			SoftGlow(m, 50, Alpha(c.colour, 0.34f));
		Diamond(m, 32, Rgb(12, 10, 7));
		Diamond(m, 32, lit ? c.colour : Mix(c.colour, Rgb(30, 26, 18), 0.45f), false, 2.f);
		Diamond(m, 26, Alpha(c.colour, lit ? 0.45f : 0.18f), false, 1.f);
		if (c.manual == 0)
		{
			const float r = 12.f, end = 4.5f;
			dl->PathArcTo(m, r, -0.5f, end, 24);
			dl->PathStroke(c.colour, ImDrawFlags_None, 3.f);
			const ImVec2 tip(m.x + std::cos(end) * r, m.y + std::sin(end) * r);
			const ImVec2 along(-std::sin(end), std::cos(end)), out(std::cos(end), std::sin(end));
			const ImVec2 head[3] = {
				{ tip.x + along.x * 9.f, tip.y + along.y * 9.f },
				{ tip.x + out.x * 7.f, tip.y + out.y * 7.f },
				{ tip.x - out.x * 7.f, tip.y - out.y * 7.f },
			};
			dl->AddConvexPolyFilled(head, 3, c.colour);
			return;
		}
		Entry mark;
		mark.status = c.manual == 2 ? kCompleted : c.manual == 1 ? kIgnored : kMissed;
		Marker(mark, m);
	}

	// The ground a panel stands on: the window falling back behind it, worn leather, and its tooled frame in small
	void ModalFrame(ImVec2 a, ImVec2 b, int seed, bool dimWindow = true)
	{
		const float w = b.x - a.x, h = b.y - a.y;
		// The window falls back, with a shadow around the panel
		if (dimWindow)
			dl->AddRectFilled(ImVec2(0, 0), ImVec2(kW, kH), Rgb(0, 0, 0, 170));
		const float sh = 46.f;
		const ImU32 dark = Rgb(0, 0, 0, 200), clear = Rgb(0, 0, 0, 0);
		dl->AddRectFilledMultiColor(ImVec2(a.x, a.y - sh), ImVec2(b.x, a.y), clear, clear, dark, dark);
		dl->AddRectFilledMultiColor(ImVec2(a.x, b.y), ImVec2(b.x, b.y + sh), dark, dark, clear, clear);
		dl->AddRectFilledMultiColor(ImVec2(a.x - sh, a.y), ImVec2(a.x, b.y), clear, dark, dark, clear);
		dl->AddRectFilledMultiColor(ImVec2(b.x, a.y), ImVec2(b.x + sh, b.y), dark, clear, clear, dark);

		// Worn leather, as the window is, and its tooled frame in small
		Field(seed, a, b, 10.f, [=](float x, float y)
		{
			const float big = Fbm(x * 0.006f + 7.f, y * 0.006f, 4);
			const float grain = Fbm(x * 0.09f, y * 0.09f, 2);
			const float edge = std::clamp(std::min(std::min(x, w - x), std::min(y, h - y)) / 150.f, 0.f, 1.f);
			const float light = (0.55f + big * 0.7f + grain * 0.18f) * (0.62f + 0.38f * edge);
			return Rgb(static_cast<int>(40 * light), static_cast<int>(32 * light), static_cast<int>(22 * light), 255);
		});
		dl->AddRect(a, b, kGold, 0.f, 0, 2.5f);
		dl->AddRect(ImVec2(a.x + 6, a.y + 6), ImVec2(b.x - 6, b.y - 6), Alpha(kGold, 0.35f));
		FadeLineH(a.x, b.x, a.y, kGoldHi, 2.f);
		FadeLineH(a.x, b.x, b.y, kGoldHi, 2.f);
		const struct { ImVec2 c; float dx, dy; } corners[4] = { {a, 1, 1}, {{b.x, a.y}, -1, 1}, {{a.x, b.y}, 1, -1}, {b, -1, -1} };
		for (const auto& k : corners)
		{
			const ImVec2 inner(k.c.x + k.dx * 11.f, k.c.y + k.dy * 11.f);
			dl->AddLine(inner, ImVec2(inner.x + k.dx * 46.f, inner.y), kGold, 1.5f);
			dl->AddLine(inner, ImVec2(inner.x, inner.y + k.dy * 46.f), kGold, 1.5f);
			Diamond(ImVec2(inner.x + k.dx * 46.f, inner.y), 3.f, kGoldHi);
			Diamond(ImVec2(inner.x, inner.y + k.dy * 46.f), 3.f, kGoldHi);
			Diamond(k.c, 11, Rgb(14, 12, 8));
			Diamond(k.c, 11, kGoldHi, false, 2.f);
			Diamond(k.c, 4, kGoldHi);
		}
	}

	// What the lists leave out, as Change Status sets a status: it stays open while you choose
	void DrawVisibilityPanel(bool takesInput)
	{
		Settings& st = GetSettings();
		struct Row { const char* name; const char* hint; ImU32 colour; bool* hidden; int mark; };
		const Row rows[] = {
			{ Tx(T_missable), Tx(T_missable_hint), Rgb(226, 100, 80), &st.hideMissable, 3 },
			{ Tx(T_status_completed), Tx(T_completed_hint), kGreen, &st.hideCompleted, 2 },
			{ Tx(T_status_ignored), Tx(T_ignored_hint), Rgb(176, 176, 156), &st.hideIgnored, 1 },
		};
		constexpr int kRows = 3;
		const int firstVertex = dl->VtxBuffer.Size;
		g_statusT = takesInput ? std::min(1.f, g_statusT + g_dt * 8.f) : 0.f;

		const float w = 1060.f, headH = 110.f, rowH = 88.f, pad = 26.f;
		const float h = pad + headH + 16.f + rowH * kRows + pad;
		const ImVec2 a(kW * 0.5f - w * 0.5f, kH * 0.5f - h * 0.5f), b(a.x + w, a.y + h);
		ModalFrame(a, b, 907);

		const ImVec2 ca(a.x + pad, a.y + pad), cb(b.x - pad, a.y + pad + headH);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(96, 68, 22, 235), Rgb(40, 28, 8, 235), Rgb(26, 18, 6, 235), Rgb(70, 48, 14, 235));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f));
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		Text(kTitle, 30, ca.x + 28, ca.y + 16, Rgb(250, 242, 220), Tx(T_change_visibility_caps));
		Text(kSerif, 28, ca.x + 28, ca.y + 58, Rgb(226, 214, 186), Tx(T_visibility_note));

		if (takesInput)
		{
			if (g_navDown && g_visibilityFocus + 1 < kRows)
				++g_visibilityFocus;
			if (g_navUp && g_visibilityFocus > 0)
				--g_visibilityFocus;
		}
		g_visibilityFocus = std::clamp(g_visibilityFocus, 0, kRows - 1);
		int toggled = -1;
		const float x0 = a.x + pad, x1 = b.x - pad;
		for (int i = 0; i < kRows; ++i)
		{
			const Row& r = rows[i];
			const float ry = cb.y + 16.f + rowH * i;
			const ImVec2 ra(x0, ry), rb(x1, ry + rowH - 8);
			if (takesInput && Hover(ra, rb))
				g_visibilityFocus = i;
			const bool focused = g_visibilityFocus == i, shown = !*r.hidden;
			if (focused)
			{
				const ImU32 left = Mix(Rgb(120, 86, 24), r.colour, 0.28f);
				dl->AddRectFilledMultiColor(ra, rb, Alpha(left, 0.9f), Rgb(34, 22, 6, 70), Rgb(34, 22, 6, 70), Alpha(left, 0.7f));
				dl->AddRect(ra, rb, Rgb(240, 226, 190), 0.f, 0, 2.f);
				dl->AddRect(ImVec2(ra.x + 4, ra.y + 4), ImVec2(rb.x - 4, rb.y - 4), Rgb(244, 236, 216, 60));
			}
			else
			{
				dl->AddRectFilled(ra, rb, Rgb(0, 0, 0, 96));
				dl->AddRect(ra, rb, Rgb(92, 76, 50, 150));
			}
			dl->AddRectFilled(ra, ImVec2(ra.x + 6, rb.y), focused ? r.colour : Alpha(r.colour, 0.5f));
			const StatusChoice medal{ r.mark, r.name, r.hint, r.colour };
			StatusMedallion(medal, ImVec2(ra.x + 58, (ra.y + rb.y) * 0.5f), focused && shown);
			Text(kSerif, 34, ra.x + 112, ry + 5, !shown ? kDim : focused ? Rgb(255, 248, 230) : kText, r.name);
			TextFit(kSans, 24, ra.x + 112, ry + 44, focused ? Rgb(226, 214, 186) : Rgb(150, 142, 124), r.hint, rb.x - ra.x - 300.f);
			const char* tag = shown ? Tx(T_shown_caps) : Tx(T_hidden_caps);
			const float tagW = Measure(kTitle, 20, tag).x + 36.f;
			const ImVec2 ta(rb.x - tagW - 22, ry + 22), tb(rb.x - 22, ry + 58);
			dl->AddRectFilled(ta, tb, Rgb(0, 0, 0, 150));
			dl->AddRect(ta, tb, shown ? kGold : Rgb(120, 110, 96), 0.f, 0, 1.5f);
			Diamond(ImVec2(ta.x, (ta.y + tb.y) * 0.5f), 4.f, shown ? kGoldHi : Rgb(120, 110, 96));
			Diamond(ImVec2(tb.x, (ta.y + tb.y) * 0.5f), 4.f, shown ? kGoldHi : Rgb(120, 110, 96));
			TextOnPoint(kTitle, 20, ImVec2((ta.x + tb.x) * 0.5f, (ta.y + tb.y) * 0.5f), shown ? kGoldHi : kDim, tag);
			if (takesInput && Clicked(ra, rb))
				toggled = i;
		}
		if (takesInput && g_navAccept)
			toggled = g_visibilityFocus;
		if (toggled >= 0)
		{
			*rows[toggled].hidden = !*rows[toggled].hidden;
			g_followSelection = true;
			MarkDirty();
		}
		// Not on the press that opened it
		else if (takesInput && ImGui::GetFrameCount() > g_cardZoomFrame && (g_pad.Pressed(kPadB) || g_pad.Pressed(kPadStart) || KeyHit(kKeyH) || ImGui::IsKeyPressed(ImGuiKey_Escape, false) || (g_clicked && !Hover(a, b))))
		{
			g_statusOpen = false;
			g_visibilityOpen = false;
		}

		// It rises into place as it fades in
		if (g_statusT < 1.f)
		{
			const float ease = 1.f - (1.f - g_statusT) * (1.f - g_statusT);
			for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
			{
				ImDrawVert& v = dl->VtxBuffer[i];
				v.pos.y += (1.f - ease) * 22.f;
				v.col = Alpha(v.col, ease);
			}
		}
	}

	// A warning the player has to see: on its own over the paused game, with the window itself not opened behind it
	void DrawWarning()
	{
		const ImGuiIO& io = ImGui::GetIO();
		const float k = g_k;
		const PopupMessage& m = *g_warning;
		g_mouse = ImVec2(io.MousePos.x * g_mouseScale.x / k, io.MousePos.y * g_mouseScale.y / k);
		g_warningT += g_dt;
		const float appear = std::min(1.f, g_warningT * 7.f);
		dl->AddRectFilled(ImVec2(0, 0), io.DisplaySize, Rgb(0, 0, 0, static_cast<int>(160.f * appear)));

		dl->PushClipRect(ImVec2(-10000, -10000), ImVec2(20000, 20000), false);
		const int firstVertex = dl->VtxBuffer.Size;
		const int firstCommand = dl->CmdBuffer.Size - 1;
		const float screenW = io.DisplaySize.x / k, screenH = io.DisplaySize.y / k;
		const float w = std::min(1180.f, screenW - 80.f), side = 56.f, headH = 118.f, footH = 92.f;
		const float textW = w - side * 2.f;
		const float contentH = MessageHeight(m, textW, 30);
		const float viewH = std::min(contentH, screenH - 80.f - headH - footH);
		const float h = headH + viewH + footH;
		const ImVec2 a((screenW - w) * 0.5f, (screenH - h) * 0.5f), b(a.x + w, a.y + h);
		ModalFrame(a, b, 7000 + static_cast<int>(h), false);

		const ImVec2 mark(a.x + 66, a.y + 58);
		const ImVec2 tri[3] = { {mark.x, mark.y - 24}, {mark.x + 25, mark.y + 20}, {mark.x - 25, mark.y + 20} };
		dl->AddConvexPolyFilled(tri, 3, kRed);
		TextCentre(kSans, 26, mark.x, mark.y - 12, Rgb(255, 240, 220), "!");
		Text(kTitle, 30, a.x + 112, a.y + 32, Rgb(250, 242, 220), Upper(m.title).c_str(), w - 150.f);
		FadeLineH(a.x + 14, b.x - 14, a.y + 100, kGold);

		// A long list scrolls
		const float scrollMax = std::max(0.f, contentH - viewH);
		if (g_navDown) g_warningScroll += 90.f;
		if (g_navUp) g_warningScroll -= 90.f;
		g_warningScroll -= g_wheel * 90.f;
		g_warningScroll -= g_pad.rightY * g_dt * 1000.f;
		g_warningScroll = std::clamp(g_warningScroll, 0.f, scrollMax);
		const float viewTop = a.y + headH;
		dl->PushClipRect(ImVec2(a.x + side - 4, viewTop), ImVec2(b.x - side + 4, viewTop + viewH), true);
		DrawMessageBody(m, a.x + side, viewTop - g_warningScroll, textW, 30, kText);
		dl->PopClipRect();
		if (scrollMax > 0.f)
		{
			const float tx = b.x - side + 16.f;
			dl->AddRectFilled(ImVec2(tx, viewTop), ImVec2(tx + 5, viewTop + viewH), Rgb(24, 20, 14, 220));
			const float thumbH = std::max(50.f, viewH * viewH / contentH);
			const float thumbY = viewTop + (viewH - thumbH) * (g_warningScroll / scrollMax);
			dl->AddRectFilled(ImVec2(tx, thumbY), ImVec2(tx + 5, thumbY + thumbH), kGold);
		}

		// The one way on
		const float capH = 42.f, footY = b.y - footH + 26.f;
		const char* const label = Tx(T_understood);
		const float labelW = Measure(kSerif, 30, label).x;
		const char* const keyName = Tx(T_key_enter);
		const float capW = g_padPrompts ? PadGlyph(0.f, footY, capH, kPadA, false, PadStyleNow()) : KeyCap(0.f, footY, capH, keyName, false, false);
		const float startX = (a.x + b.x - capW - 12.f - labelW) * 0.5f;
		const ImVec2 ha(startX, footY), hb(startX + capW + 12.f + labelW, footY + capH);
		const bool hot = g_mouse.x >= ha.x && g_mouse.x < hb.x && g_mouse.y >= ha.y && g_mouse.y < hb.y;
		if (g_padPrompts)
			PadGlyph(startX, footY, capH, kPadA, true, PadStyleNow());
		else
			KeyCap(startX, footY, capH, keyName, true, hot);
		Text(kSerif, 30, startX + capW + 12.f, footY + 2, hot ? Rgb(255, 232, 180) : Rgb(232, 196, 128), label);
		DrawCursor();
		dl->PopClipRect();

		for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
		{
			ImDrawVert& v = dl->VtxBuffer[i];
			v.pos.x *= k;
			v.pos.y *= k;
			if (appear < 1.f)
				v.col = Alpha(v.col, appear);
		}
		for (int i = std::max(0, firstCommand); i < dl->CmdBuffer.Size; ++i)
		{
			ImVec4& clip = dl->CmdBuffer[i].ClipRect;
			if (clip.x < 0.f)
				clip = ImVec4(0.f, 0.f, io.DisplaySize.x, io.DisplaySize.y);
			else
				clip = ImVec4(clip.x * k, clip.y * k, clip.z * k, clip.w * k);
		}

		// Not straight away, so a button already being pressed doesn't skip it unread
		const bool accepted = g_warningDismissed || ImGui::IsKeyPressed(ImGuiKey_Enter, false) || ImGui::IsKeyPressed(ImGuiKey_Space, false) || g_pad.Pressed(kPadA) || g_pad.Pressed(kPadB) || (hot && g_clicked);
		g_warningDismissed = false;
		if (accepted && g_warningT > 0.5f)
		{
			g_warning.reset();
			g_warningUp = false;
			SetMenuOpen(false);
		}
	}

	// With the window open and a mod replacing our quest files: says so, once a launch, and leads to the page about it
	// ------------------------------------------------------------------------------------------
	// Text with its controls in it as [name]: each drawn as the prompts along the bottom draw them, a key's cap or the
	// controller's button, for whichever is in use, wrapped with the words round it
	// ------------------------------------------------------------------------------------------

	struct PromptControl { const char* name; int key; unsigned pad; TextId fixed; };
	const PromptControl kPromptControls[] = {
		{ "prev", kKeyQ, kPadLB, T_Count }, { "next", kKeyE, kPadRB, T_Count }, { "left", kKeyA, kPadLT, T_Count }, { "right", kKeyD, kPadRT, T_Count },
		{ "toggle", kKeyC, kPadY, T_Count }, { "status", kKeyF, kPadX, T_Count }, { "vis", kKeyH, kPadStart, T_Count }, { "zoom", kKeyZ, kPadR3, T_Count },
		{ "wardrobe", kKeyG, kPadL3, T_Count }, { "save", kKeyS, kPadX, T_Count }, { "clear", kKeyX, kPadY, T_Count }, { "refresh", kKeyR, kPadBack, T_Count },
		{ "autoturn", kKeyT, kPadA, T_Count }, { "kind", kKeyF, kPadY, T_Count },
		{ "accept", kKeyCount, kPadA, T_key_enter }, { "back", kKeyCount, kPadB, T_key_esc }, { "updown", kKeyCount, kPadUp | kPadDown, T_up_down },
	};

	// Its height; drawn only when draw is set
	float PromptText(Face face, int size, float x, float y, float width, ImU32 col, const std::string& text, bool draw)
	{
		const float capH = std::round(size * 1.3f);
		const float fontH = WrappedHeight(face, size, "H", 100000.f);
		const float lineH = std::max(fontH, capH + 8.f);
		const float space = Measure(face, size, " ").x;
		// A word is its pieces: text, and controls by their place in the table
		struct Piece { std::string text; int control = -1; float w = 0.f; };
		const auto controlWidth = [&](int c, float at, float top, bool now)
		{
			const PromptControl& pc = kPromptControls[c];
			if (!g_padPrompts)
			{
				const std::string label = pc.key < kKeyCount ? g_keyLabels[pc.key] : std::string(Tx(pc.fixed));
				return KeyCap(at, top, capH, label.c_str(), now, false);
			}
			float w = 0.f;
			const std::vector<unsigned> buttons = MaskButtons(pc.pad);
			for (size_t i = 0; i < buttons.size(); ++i)
				w += PadGlyph(at + w, top, capH, buttons[i], now, PadStyleNow()) + (i + 1 < buttons.size() ? 4.f : 0.f);
			return w;
		};
		float cx = 0.f, cy = 0.f;
		size_t at = 0;
		while (at <= text.size())
		{
			// The next word, to a space or the end; a line break starts a new line
			size_t end = at;
			while (end < text.size() && text[end] != ' ' && text[end] != '\n')
				++end;
			const std::string word = text.substr(at, end - at);
			std::vector<Piece> pieces;
			for (size_t i = 0; i < word.size();)
			{
				const size_t open = word.find('[', i), close = open == std::string::npos ? open : word.find(']', open);
				int found = -1;
				if (close != std::string::npos)
					for (int c = 0; c < static_cast<int>(sizeof(kPromptControls) / sizeof(kPromptControls[0])); ++c)
						if (word.compare(open + 1, close - open - 1, kPromptControls[c].name) == 0)
							found = c;
				if (found < 0)
				{
					pieces.push_back({ word.substr(i), -1 });
					break;
				}
				if (open > i)
					pieces.push_back({ word.substr(i, open - i), -1 });
				pieces.push_back({ std::string(), found });
				i = close + 1;
			}
			float wordW = 0.f;
			for (Piece& piece : pieces)
			{
				piece.w = piece.control >= 0 ? controlWidth(piece.control, 0.f, 0.f, false) + 4.f : Measure(face, size, piece.text.c_str()).x;
				wordW += piece.w;
			}
			if (cx > 0.f && cx + wordW > width)
			{
				cx = 0.f;
				cy += lineH;
			}
			for (const Piece& piece : pieces)
			{
				if (draw)
				{
					if (piece.control >= 0)
						controlWidth(piece.control, x + cx + 2.f, y + cy + (lineH - capH) * 0.5f, true);
					else
						Text(face, size, x + cx, y + cy + (lineH - fontH) * 0.5f, col, piece.text.c_str());
				}
				cx += piece.w;
			}
			cx += space;
			if (end < text.size() && text[end] == '\n')
			{
				cx = 0.f;
				cy += lineH;
			}
			at = end + 1;
		}
		return cy + lineH;
	}

	// ------------------------------------------------------------------------------------------
	// The guided tour: offered once, then the same tabs a step at a time, with what's being talked about lit up
	// ------------------------------------------------------------------------------------------

	enum TourSpot { kTourNone, kTourProgress, kTourTabs, kTourRegions, kTourList, kTourDetail, kTourHints, kTourTable, kTourWardList, kTourWardView, kTourWardDyes, kTourWardCards, kTourWardOutfits, kTourPanel };
	enum TourOpen { kTourOpenNothing, kTourOpenStatus, kTourOpenVisibility, kTourOpenEnlarged };
	// page: on Settings, which of its pages; open: a panel the step opens over the screen, as using it would
	// entry: an entry to show, by its id, revealed even if the game hasn't got it yet
	struct TourStep { int book; TourSpot spot; TextId title, body; bool wardrobe = false; int page = -1; TourOpen open = kTourOpenNothing; const char* entry = nullptr; };
	const TourStep kTourSteps[] = {
		{ kBookQuest, kTourProgress, T_tour_progress, T_tour_progress_body },
		{ kBookQuest, kTourTabs, T_tour_tabs, T_tour_tabs_body },
		{ kBookQuest, kTourRegions, T_tour_regions, T_tour_regions_body },
		{ kBookQuest, kTourList, T_tour_list, T_tour_list_body },
		{ kBookQuest, kTourDetail, T_tour_detail, T_tour_detail_body },
		{ kBookQuest, kTourPanel, T_tour_status, T_tour_status_body, false, -1, kTourOpenStatus },
		{ kBookQuest, kTourPanel, T_tour_visibility, T_tour_visibility_body, false, -1, kTourOpenVisibility },
		{ kBookQuest, kTourHints, T_tour_hints, T_tour_hints_body },
		{ kBookWorld, kTourList, T_tour_world, T_tour_world_body },
		{ kBookMissable, kTourList, T_tour_missable, T_tour_missable_body },
		{ kBookItems, kTourDetail, T_tour_items, T_tour_items_body },
		{ kBookItems, kTourPanel, T_tour_enlarge, T_tour_enlarge_body, false, -1, kTourOpenEnlarged },
		{ kBookItems, kTourHints, T_tour_wardrobe, T_tour_wardrobe_body },
		{ kBookItems, kTourWardList, T_tour_ward_list, T_tour_ward_list_body, true },
		{ kBookItems, kTourWardView, T_tour_ward_view, T_tour_ward_view_body, true },
		{ kBookItems, kTourWardDyes, T_tour_ward_dyes, T_tour_ward_dyes_body, true },
		{ kBookItems, kTourWardCards, T_tour_ward_cards, T_tour_ward_cards_body, true },
		{ kBookItems, kTourWardOutfits, T_tour_ward_outfits, T_tour_ward_outfits_body, true },
		{ kBookGwent, kTourDetail, T_tour_gwent, T_tour_gwent_body },
		// The wolf: the first creature most players meet, so it's what the page looks like for them
		{ kBookBestiary, kTourDetail, T_tour_bestiary, T_tour_bestiary_body, false, -1, kTourOpenNothing, "PotP_Bestiary_wolf" },
		{ kTabAchievements, kTourList, T_tour_achievements, T_tour_achievements_body },
		{ kTabKills, kTourTable, T_tour_kills, T_tour_kills_body },
		{ kTabSettings, kTourTable, T_tour_settings, T_tour_settings_body, false, 0 },
		{ kTabSettings, kTourTable, T_tour_settings_general, T_tour_settings_general_body, false, 1 },
		{ kTabSettings, kTourTable, T_tour_settings_notify, T_tour_settings_notify_body, false, 2 },
		{ kTabSettings, kTourNone, T_tour_done, T_tour_done_body },
	};
	constexpr int kTourStepCount = static_cast<int>(sizeof(kTourSteps) / sizeof(kTourSteps[0]));

	int g_tourFromBook = 0;
	bool g_tourClicked = false;
	int g_tourAction = 0;   // -1 back, 1 on, 2 out

	void TourGoTo(int step)
	{
		if (step >= kTourStepCount)
			step = -2;
		// The last step's entry goes back to being what it is, and the selection to what it was
		if (g_tourEntrySet && g_tourEntryBook >= 0 && g_selected[g_tourEntryBook] == g_tourEntry)
			g_selected[g_tourEntryBook] = g_tourEntryWas;
		const char* entry = step >= 0 ? kTourSteps[step].entry : nullptr;
		g_tourEntry = entry ? entry : "";
		g_tourEntryBook = entry ? kTourSteps[step].book : -1;
		g_tourEntrySet = false;
		if (step == -2)
		{
			SetBook(g_tourFromBook);
			g_tour = -2;
			return;
		}
		g_tour = step;
		if (step >= 0)
		{
			SetBook(kTourSteps[step].book);
			g_region = 0;
			if (kTourSteps[step].page >= 0)
			{
				g_setPage = kTourSteps[step].page;
				g_setEditing = false;
			}
		}
	}

	void StartTour()
	{
		g_tourFromBook = g_book;
		TourGoTo(0);
	}

	// While it's up the tour has the input, and everything behind it sees none
	void TourTakeInput()
	{
		g_tourClicked = g_clicked;
		g_tourAction = 0;
		if (g_navRight || g_navAccept || g_pad.Pressed(kPadRB) || KeyHit(kKeyE))
			g_tourAction = 1;
		else if (g_navLeft || g_pad.Pressed(kPadLB) || KeyHit(kKeyQ))
			g_tourAction = -1;
		else if (g_pad.Pressed(kPadB) || ImGui::IsKeyPressed(ImGuiKey_Escape, false))
			g_tourAction = 2;
		g_navUp = g_navDown = g_navLeft = g_navRight = g_navPageUp = g_navPageDown = g_navAccept = false;
		g_clicked = false;
		g_wheel = 0.f;
		g_pad = PadState{};
		for (int key = ImGuiKey_NamedKey_BEGIN; key < ImGuiKey_NamedKey_END; ++key)
		{
			// A key held across a step stays up until it's pressed again, so one press is one step
			ImGuiKeyData* data = ImGui::GetKeyData(static_cast<ImGuiKey>(key));
			data->Down = false;
			data->DownDuration = data->DownDurationPrev = -1.f;
		}
	}

	bool TourButton(ImVec2 a, ImVec2 b, const char* label, bool main)
	{
		const bool over = Hover(a, b);
		if (main)
		{
			Field(500 + static_cast<int>(b.x - a.x), a, b, 7.f, [=](float px, float py)
			{
				return Mix(Rgb(150, 118, 68), Rgb(232, 204, 148), Fbm(px * 0.03f, py * 0.09f, 3));
			});
			dl->AddRect(a, b, over ? Rgb(255, 244, 214) : Rgb(60, 44, 22), 0.f, 0, 2.f);
		}
		else
		{
			dl->AddRectFilled(a, b, over ? Rgb(50, 40, 24, 240) : Rgb(0, 0, 0, 200));
			dl->AddRect(a, b, over ? kGoldHi : kGoldDim, 0.f, 0, 1.5f);
		}
		const float tw = Measure(kTitle, 22, label).x;
		Text(kTitle, 22, (a.x + b.x) * 0.5f - tw * 0.5f, (a.y + b.y) * 0.5f - InkCentre(kTitle, 22, "H").y, main ? kInk : Rgb(198, 188, 164), label);
		return g_tourClicked && over;
	}

	void TourSpotRect(TourSpot spot, ImVec2& a, ImVec2& b)
	{
		const Columns col = GetColumns();
		// As the wardrobe lays itself out
		const float wardX0 = 60.f, wardX1 = std::clamp(kW * 0.38f, 560.f, 700.f) + wardX0, wardV0 = wardX1 + 34.f, wardV1 = kW - 60.f;
		const float wardTop = 108.f, wardBottom = kH - 112.f;
		switch (spot)
		{
		case kTourWardList: a = ImVec2(wardX0 - 8, wardTop - 6); b = ImVec2(wardX1 + 8, g_wardOutfitTop - 4); break;
		case kTourWardOutfits: a = ImVec2(wardX0 - 8, g_wardOutfitTop - 4); b = ImVec2(wardX1 + 8, wardBottom + 6); break;
		case kTourWardCards: a = ImVec2(wardV0 - 6, wardTop - 6); b = ImVec2(wardV1 + 6, wardTop + 70); break;
		case kTourWardView: a = ImVec2(wardV0 - 6, wardTop + 72); b = ImVec2(wardV1 + 6, wardBottom + 6); break;
		case kTourWardDyes: a = ImVec2(wardV1 - 170, wardTop + 72); b = ImVec2(wardV1 + 6, wardBottom - 70); break;
		case kTourProgress: a = ImVec2(20, 10); b = ImVec2(506, 140); break;
		case kTourTabs: a = ImVec2(520, 4); b = ImVec2(kW - 76, 142); break;
		case kTourRegions: a = ImVec2(36, 160); b = ImVec2(kW - 36, 234); break;
		case kTourList: a = ImVec2(col.l0 - 8, kTop - 8); b = ImVec2(col.l1 + 8, kBottom + 8); break;
		case kTourDetail: a = ImVec2(col.m0 - 8, kTop - 8); b = ImVec2(col.m1 + 8, kBottom + 8); break;
		case kTourHints: a = ImVec2(60, kH - 96); b = ImVec2(kW - 60, kH - 26); break;
		case kTourTable: a = ImVec2(36, 160); b = ImVec2(kW - 36, kBottom + 8); break;
		case kTourPanel: a = b = ImVec2(0, 0); break;   // a panel's open: it's what's shown
		default: a = b = ImVec2(0, 0); break;
		}
	}

	void DrawTourCard(float x, float y, float w, float h)
	{
		dl->AddRectFilled(ImVec2(x, y), ImVec2(x + w, y + h), Rgb(14, 12, 8, 250));
		dl->AddRect(ImVec2(x, y), ImVec2(x + w, y + h), kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(x + 5, y + 5), ImVec2(x + w - 5, y + h - 5), Alpha(kGold, 0.3f));
		FadeLineH(x, x + w, y, kGoldHi, 2.f);
		FadeLineH(x, x + w, y + h, kGoldHi, 2.f);
	}

	void DrawTour()
	{
		const float cardW = 780.f, textW = cardW - 64.f;
		if (g_tour == -1)
		{
			dl->AddRectFilled(ImVec2(0, 0), ImVec2(kW, kH), Rgb(0, 0, 0, 190));
			const float bodyH = WrappedHeight(kSerif, 30, Tx(T_tour_offer_body), textW);
			const float cardH = 110.f + bodyH + 100.f;
			const float x = (kW - cardW) * 0.5f, y = (kH - cardH) * 0.5f;
			DrawTourCard(x, y, cardW, cardH);
			TextCentre(kTitle, 32, kW * 0.5f, y + 34.f, kHead, Tx(T_tour_offer_title));
			FadeLineH(x + 60, x + cardW - 60, y + 84.f, kGold);
			Text(kSerif, 30, x + 32, y + 100.f, kText, Tx(T_tour_offer_body), textW);
			const float by = y + cardH - 76.f;
			const bool yes = TourButton(ImVec2(x + cardW * 0.5f + 10, by), ImVec2(x + cardW - 32, by + 54), Tx(T_tour_offer_yes), true);
			const bool no = TourButton(ImVec2(x + 32, by), ImVec2(x + cardW * 0.5f - 10, by + 54), Tx(T_tour_offer_no), false);
			if (yes || g_tourAction == 1)
				StartTour();
			else if (no || g_tourAction == 2 || g_tourAction == -1)
				g_tour = -2;
			return;
		}

		const TourStep& step = kTourSteps[g_tour];
		ImVec2 a, b;
		TourSpotRect(step.spot, a, b);
		const ImU32 dim = Rgb(0, 0, 0, 185);
		if (step.spot == kTourNone)
			dl->AddRectFilled(ImVec2(0, 0), ImVec2(kW, kH), dim);
		else if (step.spot != kTourPanel)
		{
			dl->AddRectFilled(ImVec2(0, 0), ImVec2(kW, a.y), dim);
			dl->AddRectFilled(ImVec2(0, b.y), ImVec2(kW, kH), dim);
			dl->AddRectFilled(ImVec2(0, a.y), ImVec2(a.x, b.y), dim);
			dl->AddRectFilled(ImVec2(b.x, a.y), ImVec2(kW, b.y), dim);
			dl->AddRect(a, b, kGoldHi, 0.f, 0, 2.5f);
		}

		const std::string bodyText = Tx(step.body);
		const float bodyH = PromptText(kSerif, 30, 0.f, 0.f, textW, kText, bodyText, false);
		const float cardH = 96.f + bodyH + 96.f;
		float x = (kW - cardW) * 0.5f, y = (kH - cardH) * 0.5f;
		const float spotH = b.y - a.y, spotW = b.x - a.x;
		if (step.spot == kTourPanel)
		{
			// Below the panel that's open, over the prompts it leaves
			y = kH - cardH - 18.f;
		}
		else if (step.spot != kTourNone)
		{
			if (spotH > kH * 0.4f && spotW < kW * 0.6f)
			{
				// A column: beside it
				x = kW - b.x > cardW + 40.f ? b.x + 30.f : a.x - cardW - 30.f;
				y = (a.y + b.y - cardH) * 0.5f;
			}
			else if (spotH > kH * 0.4f)
			{
				// Most of the window: over the lower part of it
				y = kBottom - cardH - 40.f;
			}
			else if (b.y + cardH + 30.f < kH)
				y = b.y + 30.f;
			else
				y = a.y - cardH - 30.f;
		}
		x = std::clamp(x, 30.f, kW - cardW - 30.f);
		y = std::clamp(y, 30.f, kH - cardH - 30.f);
		DrawTourCard(x, y, cardW, cardH);
		Text(kTitle, 28, x + 32, y + 26.f, kHead, Tx(step.title));
		const std::string counted = TxFill(T_tour_step, std::to_string(g_tour + 1), std::to_string(kTourStepCount));
		TextRight(kSans, 22, x + cardW - 32, y + 32.f, kDim, counted.c_str());
		FadeLineH(x + 24, x + cardW - 24, y + 74.f, kGold);
		PromptText(kSerif, 30, x + 32, y + 86.f, textW, kText, bodyText, true);
		const float by = y + cardH - 72.f, bw = 170.f;
		const bool last = g_tour + 1 >= kTourStepCount;
		const bool skip = !last && TourButton(ImVec2(x + 32, by), ImVec2(x + 32 + bw, by + 50), Tx(T_tour_skip), false);
		const bool back = g_tour > 0 && TourButton(ImVec2(x + cardW - 32 - bw * 2 - 14, by), ImVec2(x + cardW - 32 - bw - 14, by + 50), Tx(T_tour_back), false);
		const bool next = TourButton(ImVec2(x + cardW - 32 - bw, by), ImVec2(x + cardW - 32, by + 50), Tx(last ? T_tour_finish : T_tour_next), true);
		if (next || g_tourAction == 1)
			TourGoTo(g_tour + 1);
		else if ((back || g_tourAction == -1) && g_tour > 0)
			TourGoTo(g_tour - 1);
		else if (skip || g_tourAction == 2)
			TourGoTo(-2);
	}

	void OfferTour(const Model* model)
	{
#ifdef POTP_OVERLAY_TEST
		if (!getenv("POTP_TOUR_OFFER"))
			return;   // only the test that's about it wants it in the way
#endif
		Settings& st = GetSettings();
		if (st.tourOffered || g_tour != -2 || !model || g_warning || g_warningUp || g_placing || g_wardrobeOpen)
			return;
		st.tourOffered = true;
		MarkDirty();
		g_tour = -1;
	}

	// Sets an entry's status by hand. The rest of the window is left alone until it closes.
	void DrawStatusPanel(const Entry& e, bool takesInput)
	{
		const StatusChoice* choices[kStatusChoiceCount];
		const int choiceCount = VisibleStatuses(e, choices);
		g_statusFocus = std::clamp(g_statusFocus, 0, choiceCount - 1);
		const int firstVertex = dl->VtxBuffer.Size;
		g_statusT = takesInput ? std::min(1.f, g_statusT + g_dt * 8.f) : 0.f;

		const float w = 1060.f, headH = 150.f, rowH = 88.f, pad = 26.f;
		const float h = pad + headH + 16.f + rowH * choiceCount + pad;
		const ImVec2 a(kW * 0.5f - w * 0.5f, kH * 0.5f - h * 0.5f), b(a.x + w, a.y + h);

		ModalFrame(a, b, 900 + choiceCount);

		// The entry, as the detail panel heads it, with where it stands now
		const ImVec2 ca(a.x + pad, a.y + pad), cb(b.x - pad, a.y + pad + headH);
		dl->AddRectFilledMultiColor(ca, cb, Rgb(96, 68, 22, 235), Rgb(40, 28, 8, 235), Rgb(26, 18, 6, 235), Rgb(70, 48, 14, 235));
		dl->AddRect(ca, cb, kGold, 0.f, 0, 2.f);
		dl->AddRect(ImVec2(ca.x + 4, ca.y + 4), ImVec2(cb.x - 4, cb.y - 4), Alpha(kGoldHi, 0.3f));
		FadeLineH(ca.x, cb.x, ca.y, Rgb(255, 240, 200), 1.5f);
		const ImVec2 signAt(ca.x + 78, (ca.y + cb.y) * 0.5f);
		SoftGlow(signAt, 76, Alpha(kGoldHi, 0.22f));
		BookSign(g_book, signAt, 42, Rgb(250, 232, 190), 3.f);
		const float tx = ca.x + 150, room = cb.x - tx - 24;
		Text(kTitle, 22, tx, ca.y + 14, kGold, Tx(T_change_status_caps));
		const std::string title = Upper(e.title.empty() ? e.uuid : e.title);
		const int titleSize = Measure(kTitle, 32, title.c_str()).x <= room ? 32 : 24;
		TextFit(kTitle, titleSize, tx, ca.y + (titleSize == 32 ? 46 : 52), Rgb(250, 242, 220), title, room);
		Marker(e, ImVec2(tx + 16, ca.y + 116));
		Text(kSerif, 30, tx + 46, ca.y + 98, StatusColour(e), StatusText(e));

		// The choices
		if (takesInput)
		{
			if (g_navDown && g_statusFocus + 1 < choiceCount)
				++g_statusFocus;
			if (g_navUp && g_statusFocus > 0)
				--g_statusFocus;
		}
		int chosen = -1;
		const float x0 = a.x + pad, x1 = b.x - pad;
		for (int i = 0; i < choiceCount; ++i)
		{
			const StatusChoice& c = *choices[i];
			const float ry = cb.y + 16.f + rowH * i;
			const ImVec2 ra(x0, ry), rb(x1, ry + rowH - 8);
			if (takesInput && Hover(ra, rb))
				g_statusFocus = i;
			const bool focused = g_statusFocus == i;
			const bool current = e.manual == c.manual;
			if (focused)
			{
				const ImU32 left = Mix(Rgb(120, 86, 24), c.colour, 0.28f);
				dl->AddRectFilledMultiColor(ra, rb, Alpha(left, 0.9f), Rgb(34, 22, 6, 70), Rgb(34, 22, 6, 70), Alpha(left, 0.7f));
				dl->AddRect(ra, rb, Rgb(240, 226, 190), 0.f, 0, 2.f);
				dl->AddRect(ImVec2(ra.x + 4, ra.y + 4), ImVec2(rb.x - 4, rb.y - 4), Rgb(244, 236, 216, 60));
			}
			else
			{
				dl->AddRectFilled(ra, rb, Rgb(0, 0, 0, 96));
				dl->AddRect(ra, rb, Rgb(92, 76, 50, 150));
			}
			dl->AddRectFilled(ra, ImVec2(ra.x + 6, rb.y), focused ? c.colour : Alpha(c.colour, 0.5f));
			StatusMedallion(c, ImVec2(ra.x + 58, (ra.y + rb.y) * 0.5f), focused);
			Text(kSerif, 34, ra.x + 112, ry + 5, focused ? Rgb(255, 248, 230) : kText, c.name);
			Text(kSans, 24, ra.x + 112, ry + 44, focused ? Rgb(226, 214, 186) : Rgb(150, 142, 124), c.hint);
			if (current)
			{
				const char* tag = Tx(T_current_caps);
				const float tagW = Measure(kTitle, 20, tag).x + 36.f;
				const ImVec2 ta(rb.x - tagW - 22, ry + 22), tb(rb.x - 22, ry + 58);
				dl->AddRectFilled(ta, tb, Rgb(0, 0, 0, 150));
				dl->AddRect(ta, tb, kGold, 0.f, 0, 1.5f);
				Diamond(ImVec2(ta.x, (ta.y + tb.y) * 0.5f), 4.f, kGoldHi);
				Diamond(ImVec2(tb.x, (ta.y + tb.y) * 0.5f), 4.f, kGoldHi);
				TextOnPoint(kTitle, 20, ImVec2((ta.x + tb.x) * 0.5f, (ta.y + tb.y) * 0.5f), kGoldHi, tag);
			}
			if (takesInput && Clicked(ra, rb))
				chosen = i;
		}
		if (takesInput && g_navAccept)
			chosen = g_statusFocus;

		if (chosen >= 0)
		{
			if (choices[chosen]->manual != e.manual)
				RequestSetStatus(e.uuid, choices[chosen]->manual);
			g_statusOpen = false;
		}
		else if (takesInput && (g_pad.Pressed(kPadB) || ImGui::IsKeyPressed(ImGuiKey_Escape, false) || (g_clicked && !Hover(a, b))))
		{
			g_statusOpen = false;
		}

		// It rises into place as it fades in
		if (g_statusT < 1.f)
		{
			const float ease = 1.f - (1.f - g_statusT) * (1.f - g_statusT);
			for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
			{
				ImDrawVert& v = dl->VtxBuffer[i];
				v.pos.y += (1.f - ease) * 22.f;
				v.col = Alpha(v.col, ease);
			}
		}
	}

	// ------------------------------------------------------------------------------------------
	// The wardrobe: a panel of its own, opened from the Items tab
	// ------------------------------------------------------------------------------------------

	constexpr int kWardKinds = 8;
	const char* const kWardKind[kWardKinds] = { "armor", "pants", "boots", "gloves", "steelsword", "silversword", "crossbow", "mask" };

	const char* WardKindName(int kind)
	{
		const TextId names[kWardKinds] = { T_ward_armour, T_ward_trousers, T_ward_boots, T_ward_gloves, T_ward_steel, T_ward_silver, T_ward_crossbow, T_ward_masks };
		return Tx(names[kind]);
	}

	struct WardItem { std::string itemTemplate, title; bool done = false; bool tracked = true; };
	// Every piece of armour, as the game lists it, for what the mod doesn't track
	struct WardExtra { std::string kind, itemTemplate, title; };
	std::mutex g_wardExtrasLock;
	std::vector<WardExtra> g_wardExtras;
	std::atomic<bool> g_wardExtrasFresh{ false };

	// Its file's name, however its path was written
	std::string WardStem(const std::string& itemTemplate)
	{
		std::string stem = itemTemplate.substr(0, itemTemplate.find('#'));
		for (char& c : stem)
			c = c == '\\' ? '/' : static_cast<char>(tolower(static_cast<unsigned char>(c)));
		const size_t slash = stem.rfind('/');
		if (slash != std::string::npos)
			stem.erase(0, slash + 1);
		if (stem.size() > 6 && stem.compare(stem.size() - 6, 6, ".w2ent") == 0)
			stem.resize(stem.size() - 6);
		return stem;
	}
	std::vector<WardItem> g_wardLists[kWardKinds];
	const Model* g_wardListsOf = nullptr;
	int g_wardKind = 0, g_wardRows[kWardKinds] = {};
	float g_wardScroll = 0.f, g_wardZoom = 1.f;
	bool g_wardDragging = false, g_wardOnOutfit = false, g_wardOnPinned = false, g_wardOnWorn = false;
	bool g_wardCanDye = false;   // the piece being looked at takes dyes
	enum WardClick { kWardClickNone, kWardClickWear, kWardClickPin, kWardClickSave, kWardClickClear, kWardClickStance, kWardClickUntracked, kWardClickEnlarge, kWardClickSearch };
	WardClick g_wardClick = kWardClickNone;
	// What he has on here, by kind: what's pinned when it opens, then what's put on and taken off. He starts with
	// nothing else, not his real gear.
	std::map<std::string, PinnedPiece> g_wardWorn;
	bool g_wardEnlarged = false;   // he's shown large over the whole screen
	bool g_wardSearch = false;     // the search panel's over it

	struct Outfit { std::string name; std::map<std::string, PinnedPiece> pieces; };
	std::vector<Outfit> g_outfits;
	bool g_outfitsRead = false;

	void ReadOutfits()
	{
		if (g_outfitsRead)
			return;
		g_outfitsRead = true;
		const std::string& saved = GetSettings().wardrobeOutfits;
		for (size_t from = 0; from < saved.size();)
		{
			size_t bar = saved.find('|', from);
			if (bar == std::string::npos)
				bar = saved.size();
			const std::string text = saved.substr(from, bar - from);
			from = bar + 1;
			size_t at = text.find('^');
			Outfit outfit;
			outfit.name = text.substr(0, at);
			while (at != std::string::npos)
			{
				const size_t next = text.find('^', at + 1);
				const std::string item = text.substr(at + 1, next == std::string::npos ? std::string::npos : next - at - 1);
				std::string kind;
				PinnedPiece piece;
				if (ReadPinnedPiece(item, kind, piece))
					outfit.pieces[kind] = std::move(piece);
				at = next;
			}
			g_outfits.push_back(std::move(outfit));
		}
	}

	void SaveOutfits()
	{
		std::string saved;
		for (const Outfit& outfit : g_outfits)
		{
			saved += (saved.empty() ? "" : "|") + outfit.name;
			for (const auto& [kind, piece] : outfit.pieces)
				saved += "^" + SavedPiece(kind, piece);
		}
		GetSettings().wardrobeOutfits = saved;
		MarkDirty();
	}

	void BuildWardLists(const Model& m)
	{
		if (g_wardListsOf == &m && !g_wardExtrasFresh)
			return;
		if (!ModelIndexReady())
			return;   // asked again next frame
		g_wardExtrasFresh = false;
		g_wardListsOf = &m;
		std::set<std::string> seen, seenStems;
		for (auto& list : g_wardLists)
			list.clear();
		for (const Section& section : m.sections)
			for (const Entry& e : section.entries)
			{
				if (e.itemTemplate.empty())
					continue;
				const std::string kind = WornCategory(e.itemTemplate);
				for (int k = 0; k < kWardKinds; ++k)
					if (kind == kWardKind[k] && seen.insert(e.itemTemplate).second)
					{
						g_wardLists[k].push_back(WardItem{ e.itemTemplate, e.title, e.Done() });
						seenStems.insert(WardStem(e.itemTemplate));
					}
			}
		// Then what the mod doesn't track, by name: the school sets are among it, and they're what take dyes. Left out
		// when the wardrobe's set to hide them.
		if (GetSettings().wardrobeShowUntracked)
		{
			std::lock_guard lock(g_wardExtrasLock);
			for (int k = 0; k < kWardKinds; ++k)
			{
				const size_t from = g_wardLists[k].size();
				std::set<std::string> seenTitles;
				for (const WardItem& item : g_wardLists[k])
					seenTitles.insert(item.title);
				const bool byTitle = std::string(kWardKind[k]) == "mask";   // many of the masquerade's masks share a name
				for (const WardExtra& extra : g_wardExtras)
					if (WornCategory(extra.itemTemplate) == kWardKind[k] && extra.kind == kWardKind[k] && (!byTitle || seenTitles.insert(extra.title).second)
						&& seenStems.insert(WardStem(extra.itemTemplate)).second)
						g_wardLists[k].push_back(WardItem{ extra.itemTemplate, extra.title, false, false });
				std::sort(g_wardLists[k].begin() + static_cast<ptrdiff_t>(from), g_wardLists[k].end(), [](const WardItem& a, const WardItem& b) { return a.title < b.title; });
			}
		}
		// Last in each list: that kind off him
		for (int k = 0; k < kWardKinds; ++k)
			g_wardLists[k].push_back(WardItem{ std::string(kWornNothing) + kWardKind[k], Tx(T_ward_nothing), true });
	}

	void OpenWardrobe(const Model& m, const Entry* e)
	{
		ReadPins();
		ReadOutfits();
		RequestWardrobeItems();
		g_wardrobeOpen = true;
		g_wardListsOf = nullptr;
		BuildWardLists(m);
		g_wardZoom = 1.f;
		g_wardScroll = 0.f;
		g_modelYaw = 0.f;
		g_modelPitch = 4.f;
		g_wardClick = kWardClickNone;
		g_wardWorn = g_pins;
		g_wardEnlarged = false;
		// On what was selected, if he can wear it
		if (e)
			for (int k = 0; k < kWardKinds; ++k)
				for (int i = 0; i < static_cast<int>(g_wardLists[k].size()); ++i)
					if (g_wardLists[k][i].itemTemplate == e->itemTemplate)
					{
						g_wardKind = k;
						g_wardRows[k] = i;
					}
	}

	void CloseWardrobe()
	{
		g_wardrobeOpen = false;
		g_modelShown.clear();   // the Items tab starts its item afresh
	}

	void DrawHints(const Entry* e, const BridgeState& state)
	{
		if (g_wardrobeOpen && (g_wardEnlarged || g_wardSearch))
			return;   // the enlarged view and the search have their own rows, and their own ways out
		const Settings& st = GetSettings();
		const float hy = kH - 80;
		FadeLineH(80, kW - 80, hy - 20, kGoldDim);

		const bool settingsPage = g_book == kTabSettings;
		const std::string closeKey = KeyName(st.openKey);
		const bool canMark = !settingsPage && g_book != kTabAchievements && g_book != kTabKills && e && !g_statusOpen;
		std::vector<Hint> hints;
		if (g_wardrobeOpen)
		{
			hints.push_back({ kPadLB | kPadRB, g_keyTabs.c_str(), Tx(T_ward_category), kActNone });
			hints.push_back({ kPadUp | kPadDown, Tx(T_up_down), Tx(T_move), kActNone });
			hints.push_back({ kPadA, Tx(T_key_enter), Tx(g_wardOnOutfit ? T_ward_wear : g_wardOnWorn ? T_ward_take_off : T_ward_wear), kActWardWear });
			hints.push_back({ kPadRT, KeyLabel(kKeyF), Tx(g_wardOnPinned ? T_model_unpin : T_model_pin), kActWardPin });
			if (g_wardCanDye)
				hints.push_back({ kPadLT, g_keyPages.c_str(), Tx(T_ward_dye), kActNone });
			hints.push_back({ kPadX, KeyLabel(kKeyS), Tx(T_ward_save), kActWardSave });
			hints.push_back({ kPadY, KeyLabel(kKeyC), Tx(g_wardOnOutfit ? T_ward_delete : T_ward_clear), kActWardClear });
			hints.push_back({ kPadStart, KeyLabel(kKeyH), Tx(GetSettings().wardrobeShowUntracked ? T_ward_hide_untracked : T_ward_show_untracked), kActWardUntracked });
			hints.push_back({ kPadBack, KeyLabel(kKeyR), Tx(T_ward_search), kActWardSearch });
			hints.push_back({ kPadR3, KeyLabel(kKeyZ), Tx(T_hold_to_enlarge), kActWardEnlarge, true });
			hints.push_back({ kPadLeft | kPadRight, KeyLabel(kKeyT), Tx(T_ward_stance), kActWardStance });
			hints.push_back({ kPadB, Tx(T_key_esc), Tx(T_ward_back), kActClose });
		}
		else if (g_statusOpen && g_visibilityOpen)
		{
			hints.push_back({ kPadUp | kPadDown, Tx(T_up_down), Tx(T_move), kActNone });
			hints.push_back({ kPadA, Tx(T_key_enter), Tx(T_show_hide), kActNone });
			hints.push_back({ kPadB, Tx(T_key_esc), Tx(T_done), kActNone });
		}
		else if (g_statusOpen && g_cardZoom)
		{
			// The enlarged card has its own line
		}
		else if (g_statusOpen)
		{
			hints.push_back({ kPadUp | kPadDown, Tx(T_up_down), Tx(T_move), kActNone });
			hints.push_back({ kPadA, Tx(T_key_enter), Tx(T_apply), kActNone });
			hints.push_back({ kPadB, Tx(T_key_esc), Tx(T_cancel), kActNone });
		}
		else if (g_padPrompts)
		{
			hints.push_back({ kPadLB | kPadRB, nullptr, Tx(T_change_tab), kActNone });
		}
		else
		{
			hints.push_back({ 0, KeyLabel(kKeyQ), Tx(T_previous), kActPrev });
			hints.push_back({ 0, KeyLabel(kKeyE), Tx(T_next), kActNext });
		}
		if (g_statusOpen || g_wardrobeOpen)
		{
		}
		else if (settingsPage)
		{
			if (!g_setEditing)
				hints.push_back({ kPadLT | kPadRT, g_keyPages.c_str(), Tx(T_page), kActNone });
			if (g_picker.open)
			{
				hints.push_back({ kPadUp | kPadDown | kPadLeft | kPadRight, Tx(T_key_arrows), Tx(T_move), kActNone });
				hints.push_back({ kPadA, Tx(T_key_enter), Tx(T_choose), kActNone });
				hints.push_back({ kPadB, Tx(T_key_esc), Tx(T_cancel), kActNone });
			}
			else if (g_setEditing)
			{
				hints.push_back({ kPadLeft | kPadRight, Tx(T_left_right), Tx(T_change), kActNone });
				hints.push_back({ kPadA | kPadB, Tx(T_key_enter), Tx(T_done), kActNone });
			}
			else
			{
				hints.push_back({ kPadA, Tx(T_key_enter), Tx(T_choose), kActNone });
			}
		}
		else if (g_book == kTabKills)
		{
			hints.push_back({ kPadLT | kPadRT, g_keyPages.c_str(), Tx(T_kill_page), kActNone });
			hints.push_back({ kPadUp | kPadDown, Tx(T_up_down), Tx(T_move), kActNone });
			hints.push_back({ kPadX, KeyLabel(kKeyS), Tx(g_killByName ? T_kill_sort_name : T_kill_sort_count), kActNone });
			if (g_killPage == 1)
				hints.push_back({ kPadY, KeyLabel(kKeyF), g_killKind >= 0 ? KillCategory(g_killKind) : Tx(T_kill_kind_all), kActNone });
		}
		else
		{
			if (g_book == kBookBestiary)
				hints.push_back({ kPadLT | kPadRT, g_keyPages.c_str(), Tx(T_scroll_text), kActNone });
			else if (g_padPrompts && g_book != kTabAchievements)
				hints.push_back({ kPadLT | kPadRT, nullptr, Tx(T_region), kActNone });
			if (canMark)
				hints.push_back({ kPadX, KeyLabel(kKeyF), Tx(T_change_status), kActMark });
			if (canMark && CanEnlarge(*e))
				hints.push_back({ kPadR3, KeyLabel(kKeyZ), Tx(T_hold_to_enlarge), kActZoom, true });
			if (canMark && ShowsModel(*e))
				hints.push_back({ kPadA, KeyLabel(kKeyT), Tx(GetSettings().autoRotate ? T_auto_turn_on : T_auto_turn_off), kActAutoTurn });
			if (g_book == kBookItems && state.model)
				hints.push_back({ kPadL3, KeyLabel(kKeyG), Tx(T_ward_open), kActWardrobe });
			if (g_book != kBookBestiary && g_detailScrollMax > 0.f)
				hints.push_back({ kPadLeft | kPadRight, Tx(T_left_right), Tx(T_scroll_details), kActNone });
			hints.push_back({ kPadY, KeyLabel(kKeyC), Tx(T_expand_collapse), kActNone });
			hints.push_back({ kPadStart, KeyLabel(kKeyH), Tx(T_change_visibility), kActHide });
			hints.push_back({ kPadBack, KeyLabel(kKeyR), Tx(T_refresh), kActRefresh });
		}
		if (!(settingsPage && g_setEditing) && !g_statusOpen && !g_wardrobeOpen)
			hints.push_back({ kPadB, closeKey.c_str(), Tx(T_close), kActClose });

		const float capH = 42.f, inner = 12.f;
		float gap = 44.f;
		int textSize = 30;
		const auto glyphsWidth = [&](const Hint& h)
		{
			if (!g_padPrompts)
				return KeyCap(0, 0, capH, h.key ? h.key : "", false);
			float w = 0;
			const std::vector<unsigned> buttons = MaskButtons(h.pad);
			for (size_t i = 0; i < buttons.size(); ++i)
				w += PadGlyph(0, 0, capH, buttons[i], false, PadStyleNow()) + (i + 1 < buttons.size() ? 6.f : 0.f);
			return w;
		};
		// As many as there are fit across: closer together first, then smaller, as on Items with a model to turn
		float total = 0;
		for (int fit = 0; fit < 8; ++fit)
		{
			total = 0;
			for (const Hint& h : hints)
				total += glyphsWidth(h) + inner + Measure(kSerif, textSize, h.text.c_str()).x + gap;
			if (total - gap <= kW - 96.f)
				break;
			if (gap > 26.f)
				gap -= 9.f;
			else if (textSize > 24)
				textSize -= 2;
		}
		float x = kW * 0.5f - (total - gap) * 0.5f;

		bool wardrobe = false;
		bool prev = false, next = false, mark = false, zoom = false, autoTurn = false, hide = false, refresh = false, close = false;
		for (const Hint& h : hints)
		{
			const float gw = glyphsWidth(h);
			const float tw = Measure(kSerif, textSize, h.text.c_str()).x;
			const ImVec2 a(x, hy), b(x + gw + inner + tw, hy + capH);
			const bool hot = Hover(a, b) && h.action != kActNone;
			if (!g_padPrompts)
				KeyCap(x, hy, capH, h.key ? h.key : "", true, hot);
			else
			{
				float gx = x;
				for (unsigned btn : MaskButtons(h.pad))
					gx += PadGlyph(gx, hy, capH, btn, true, PadStyleNow()) + 6.f;
			}
			if (h.held && EnlargeProgress() > 0.f)
				dl->AddRectFilled(ImVec2(x, hy + capH + 5.f), ImVec2(x + gw * EnlargeProgress(), hy + capH + 9.f), Rgb(232, 196, 128));
			Text(kSerif, textSize, x + gw + inner, hy + 2 + (30 - textSize) * 0.5f, hot ? Rgb(255, 232, 180) : Rgb(232, 196, 128), h.text.c_str());
			if (Clicked(a, b))
				switch (h.action)
				{
				case kActPrev: prev = true; break;
				case kActNext: next = true; break;
				case kActMark: mark = true; break;
				case kActZoom: zoom = true; break;
				case kActAutoTurn: autoTurn = true; break;
				case kActWardrobe: wardrobe = true; break;
				case kActWardWear: g_wardClick = kWardClickWear; break;
				case kActWardPin: g_wardClick = kWardClickPin; break;
				case kActWardUntracked: g_wardClick = kWardClickUntracked; break;
				case kActWardEnlarge: g_wardClick = kWardClickEnlarge; break;
				case kActWardSearch: g_wardClick = kWardClickSearch; break;
				case kActWardSave: g_wardClick = kWardClickSave; break;
				case kActWardClear: g_wardClick = kWardClickClear; break;
				case kActWardStance: g_wardClick = kWardClickStance; break;
				case kActHide: hide = true; break;
				case kActRefresh: refresh = true; break;
				case kActClose: close = true; break;
				default: break;
				}
			x = b.x + gap;
		}

		if (!g_statusOpen && !g_capture)
		{
			if (!g_wardrobeOpen)
			{
				prev = prev || KeyHit(kKeyQ) || g_pad.Pressed(kPadLB);
				next = next || KeyHit(kKeyE) || g_pad.Pressed(kPadRB);
			}
			if (!settingsPage && !g_wardrobeOpen)
			{
				mark = mark || (canMark && (KeyHit(kKeyF) || g_pad.Pressed(kPadX)));
				zoom = (EnlargeHeld() && canMark && e && CanEnlarge(*e)) || zoom;
				wardrobe = wardrobe || (g_book == kBookItems && state.model && (KeyHit(kKeyG) || g_pad.Pressed(kPadL3)));
				// A on an entry: a header's A opens and closes it
				autoTurn = autoTurn || (canMark && ShowsModel(*e) && (KeyHit(kKeyT) || g_pad.Pressed(kPadA)));
				hide = hide || KeyHit(kKeyH) || g_pad.Pressed(kPadStart);
				refresh = refresh || KeyHit(kKeyR) || g_pad.Pressed(kPadBack);
			}
			close = close || (g_pad.Pressed(kPadB) && !g_backConsumed);
		}
		g_backConsumed = false;
		if (autoTurn)
		{
			GetSettings().autoRotate = !GetSettings().autoRotate;
			MarkDirty();
		}
		if (wardrobe && state.model)
			OpenWardrobe(*state.model, e);
		if (prev)
			SetBook(g_book - 1);
		if (next)
			SetBook(g_book + 1);
		if (zoom && e)
		{
			g_statusOpen = true;
			g_visibilityOpen = false;
			g_cardZoom = true;
			g_cardZoomT = 0.f;
			g_cardZoomFrame = ImGui::GetFrameCount();
			g_cardZoomYaw = g_cardZoomPitch = 0.f;
			OpenZoomModel();
		}
		if (mark && e)
		{
			g_statusOpen = true;
			g_visibilityOpen = false;
			g_cardZoom = false;
			g_statusFocus = 0;
			const StatusChoice* choices[kStatusChoiceCount];
			const int choiceCount = VisibleStatuses(*e, choices);
			for (int i = 0; i < choiceCount; ++i)
				if (choices[i]->manual == e->manual)
					g_statusFocus = i;
		}
		if (hide)
		{
			g_statusOpen = true;
			g_visibilityOpen = true;
			g_cardZoom = false;
			g_visibilityFocus = 0;
			g_cardZoomFrame = ImGui::GetFrameCount();
		}
		if (refresh)
			g_achievementsNextAsk = 0;
		if (refresh)
			RequestRefresh();
		if (close && g_wardrobeOpen)
			CloseWardrobe();
		else if (close)
			SetMenuOpen(false);

		if (state.reading)
			TextRight(kSerif, 28, kW - 40, hy + 4, kDim, Tx(T_reading));
	}

	// The dye each piece is being tried in. Nothing here: what it's pinned in, or what it really has on it.
	std::map<std::string, std::string> g_wardDyes;

	struct DyeLook { const char* name; ImU32 colour; };
	const DyeLook kDyeLooks[] = {
		{ "dye_default", 0 }, { "dye_black", IM_COL32(26, 26, 30, 255) }, { "dye_gray", IM_COL32(120, 120, 124, 255) }, { "dye_white", IM_COL32(232, 230, 222, 255) },
		{ "dye_brown", IM_COL32(100, 66, 40, 255) }, { "dye_red", IM_COL32(164, 40, 40, 255) }, { "dye_orange", IM_COL32(206, 114, 40, 255) }, { "dye_yellow", IM_COL32(218, 186, 66, 255) },
		{ "dye_green", IM_COL32(62, 116, 60, 255) }, { "dye_turquoise", IM_COL32(48, 152, 152, 255) }, { "dye_blue", IM_COL32(52, 84, 156, 255) }, { "dye_purple", IM_COL32(112, 70, 154, 255) },
		{ "dye_pink", IM_COL32(214, 122, 164, 255) } };

	std::string TemplateOnly(const std::string& piece)
	{
		return piece.substr(0, piece.find('#'));
	}

	std::string DyeName(const Model& m, const std::string& dye)
	{
		if (dye.empty() || dye == "dye_default")
			return Tx(T_ward_dye_default);
		const auto named = m.dyeNames.find(dye);
		if (named != m.dyeNames.end() && !named->second.empty())
			return named->second;
		std::string plain = dye.rfind("dye_", 0) == 0 ? dye.substr(4) : dye;
		if (!plain.empty())
			plain[0] = static_cast<char>(toupper(static_cast<unsigned char>(plain[0])));
		return plain;
	}

	// What a piece is in now: tried on here, else pinned, else what it really has on it
	std::string DyeOf(const Model& m, const std::string& itemTemplate)
	{
		const auto trying = g_wardDyes.find(itemTemplate);
		if (trying != g_wardDyes.end())
			return trying->second;
		const auto pin = g_pins.find(WornCategory(itemTemplate));
		if (pin != g_pins.end() && pin->second.itemTemplate == itemTemplate)
			return pin->second.dye;
		for (const std::string& piece : m.gear)
			if (_stricmp(TemplateOnly(piece).c_str(), itemTemplate.c_str()) == 0 && piece.size() > itemTemplate.size())
				return piece.substr(itemTemplate.size() + 1);
		return {};
	}

	void SetDye(const std::string& itemTemplate, const std::string& dye)
	{
		g_wardDyes[itemTemplate] = dye;
		const auto pin = g_pins.find(WornCategory(itemTemplate));
		if (pin != g_pins.end() && pin->second.itemTemplate == itemTemplate)
		{
			pin->second.dye = dye;
			SavePins();
		}
	}

	std::string Dyed(const std::string& itemTemplate, const std::string& dye)
	{
		return dye.empty() ? itemTemplate : itemTemplate + "#" + dye;
	}


	// ---- the wardrobe's search: every kind's pieces by name, in a panel over it

	struct WardHit { int kind, index; };
	std::string g_wardQuery;
	int g_wardSearchRow = 0;
	float g_wardSearchScroll = 0.f;
	int g_wardSearchFrame = 0;        // the frame it opened on: not the press that opened it

	void OpenWardSearch()
	{
		g_wardSearch = true;
		g_wardQuery.clear();
		g_wardSearchRow = 0;
		g_wardSearchScroll = 0.f;
		g_wardSearchFrame = ImGui::GetFrameCount();
		ImGui::GetIO().InputQueueCharacters.resize(0);
	}

	// Lower case, for matching: plain letters only, the rest as they are
	std::string WardFold(const std::string& s)
	{
		std::string out = s;
		for (char& c : out)
			if (c >= 'A' && c <= 'Z')
				c = static_cast<char>(c - 'A' + 'a');
		return out;
	}

	std::vector<WardHit> WardSearchHits()
	{
		std::vector<WardHit> hits;
		const std::string query = WardFold(g_wardQuery);
		if (query.find_first_not_of(' ') == std::string::npos)
			return hits;
		for (int k = 0; k < kWardKinds; ++k)
			for (int i = 0; i < static_cast<int>(g_wardLists[k].size()); ++i)
			{
				const WardItem& item = g_wardLists[k][i];
				if (item.itemTemplate.rfind(kWornNothing, 0) == 0)
					continue;
				if (WardFold(item.title).find(query) != std::string::npos)
					hits.push_back({ k, i });
			}
		std::stable_sort(hits.begin(), hits.end(), [&](const WardHit& a, const WardHit& b)
		{
			// Names that start with it first
			const bool sa = WardFold(g_wardLists[a.kind][a.index].title).rfind(query, 0) == 0;
			const bool sb = WardFold(g_wardLists[b.kind][b.index].title).rfind(query, 0) == 0;
			return sa && !sb;
		});
		return hits;
	}

	// The panel, over the wardrobe. Put on or take off, pin, or go to the piece in its own list.
	void DrawWardSearch(const Model& m)
	{
		const bool fresh = ImGui::GetFrameCount() <= g_wardSearchFrame;
		const bool pad = g_padPrompts;
		std::vector<WardHit> hits = WardSearchHits();
		const int count = static_cast<int>(hits.size());

		// Typing, from the keyboard
		if (!fresh)
		{
			for (ImWchar c : ImGui::GetIO().InputQueueCharacters)
				if (c >= 32 && c != 127 && g_wardQuery.size() < 40)
				{
					char utf8[5] = {};
					ImTextCharToUtf8(utf8, c);
					g_wardQuery += utf8;
				}
			if (ImGui::IsKeyPressed(ImGuiKey_Backspace) && !g_wardQuery.empty())
			{
				// a whole character, however many bytes it is
				size_t cut = g_wardQuery.size() - 1;
				while (cut > 0 && (static_cast<unsigned char>(g_wardQuery[cut]) & 0xC0) == 0x80)
					--cut;
				g_wardQuery.erase(cut);
			}
		}
		ImGui::GetIO().InputQueueCharacters.resize(0);

		hits = WardSearchHits();
		g_wardSearchRow = std::clamp(g_wardSearchRow, 0, std::max(0, static_cast<int>(hits.size()) - 1));

		// The results: up and down. Typing is on the keyboard; a controller works the results.
		const bool onResults = true;
		if (onResults && !fresh)
		{
			if (g_navDown) g_wardSearchRow = std::min(g_wardSearchRow + 1, std::max(0, static_cast<int>(hits.size()) - 1));
			if (g_navUp) g_wardSearchRow = std::max(g_wardSearchRow - 1, 0);
		}
		const WardHit* hit = hits.empty() ? nullptr : &hits[g_wardSearchRow];
		const auto wornHere = [&](const WardHit& h)
		{
			const auto worn = g_wardWorn.find(kWardKind[h.kind]);
			return worn != g_wardWorn.end() && worn->second.itemTemplate == g_wardLists[h.kind][h.index].itemTemplate;
		};
		bool wear = false, pinIt = false, jump = false, close = false;
		if (!fresh)
		{
			if (pad)
			{
				wear = onResults && g_pad.Pressed(kPadA);
				pinIt = onResults && g_pad.Pressed(kPadRT);
				jump = onResults && g_pad.Pressed(kPadX);
				close = g_pad.Pressed(kPadB);
			}
			else
			{
				wear = ImGui::IsKeyPressed(ImGuiKey_Enter, false);
				pinIt = ImGui::IsKeyPressed(ImGuiKey_Tab, false);
				jump = ImGui::IsKeyPressed(ImGuiKey_RightArrow, false);
			}
			close = close || ImGui::IsKeyPressed(ImGuiKey_Escape, false);
		}

		// The panel
		dl->AddRectFilled(ImVec2(0.f, 0.f), ImVec2(kW, kH), Rgb(0, 0, 0, 150));
		// Only the box to type in, then as tall as its results need, up to ten before they scroll. Its top stays put.
		constexpr float kRowH = 52.f;
		constexpr int kMostRows = 10;
		const int shownRows = std::min(static_cast<int>(hits.size()), kMostRows);
		const bool noneFound = hits.empty() && !g_wardQuery.empty();
		const float w = 1040.f, h = 172.f + (shownRows > 0 ? shownRows * kRowH + 30.f : noneFound ? 80.f : 0.f);
		const float top = (kH - 90.f) * 0.5f - (172.f + kMostRows * kRowH + 30.f) * 0.5f;
		const ImVec2 a(kW * 0.5f - w * 0.5f, top), b(a.x + w, a.y + h);
		dl->AddRectFilledMultiColor(a, b, Rgb(26, 23, 18, 250), Rgb(26, 23, 18, 250), Rgb(12, 11, 9, 250), Rgb(12, 11, 9, 250));
		dl->AddRect(a, b, kGold, 0.f, 0, 1.5f);
		Text(kTitle, 28, a.x + 30.f, a.y + 24.f, kGoldHi, Tx(T_ward_search_title));
		FadeLineH(a.x + 20.f, b.x - 20.f, a.y + 72.f, kGoldDim);

		// What's typed, with a caret
		const ImVec2 qa(a.x + 30.f, a.y + 92.f), qb(b.x - 30.f, a.y + 152.f);
		dl->AddRectFilled(qa, qb, Rgb(0, 0, 0, 160));
		dl->AddRect(qa, qb, kGoldHi, 0.f, 0, 1.5f);
		const bool empty = g_wardQuery.empty();
		Text(kSerif, 32, qa.x + 16.f, qa.y + 10.f, empty ? kDim : kText, empty ? Tx(T_ward_search_hint) : g_wardQuery.c_str());
		if (!empty && fmodf(static_cast<float>(ImGui::GetTime()), 1.f) < 0.55f)
		{
			const float cx = qa.x + 18.f + Measure(kSerif, 32, g_wardQuery.c_str()).x;
			dl->AddLine(ImVec2(cx, qa.y + 12.f), ImVec2(cx, qb.y - 12.f), kText, 2.f);
		}

		const float listTop = qb.y + 18.f;

		// The results
		const float rowH = kRowH, viewH = std::max(0.f, b.y - 30.f - listTop);
		const ImVec2 la(a.x + 30.f, listTop), lb(b.x - 30.f, listTop + viewH);
		if (hits.empty())
		{
			if (!empty)
				TextCentre(kSerif, 30, (la.x + lb.x) * 0.5f, listTop + 20.f, kDim, Tx(T_ward_search_none));
		}
		else
		{
			if (g_wardSearchRow * rowH < g_wardSearchScroll)
				g_wardSearchScroll = g_wardSearchRow * rowH;
			if ((g_wardSearchRow + 1) * rowH > g_wardSearchScroll + viewH)
				g_wardSearchScroll = (g_wardSearchRow + 1) * rowH - viewH;
			if (Hover(la, lb) && g_wheel != 0.f)
				g_wardSearchScroll -= g_wheel * 148.f;
			g_wardSearchScroll = std::clamp(g_wardSearchScroll, 0.f, std::max(0.f, hits.size() * rowH - viewH));
			dl->PushClipRect(la, lb, true);
			for (int i = 0; i < static_cast<int>(hits.size()); ++i)
			{
				const float y = listTop + i * rowH - g_wardSearchScroll;
				if (y + rowH < listTop || y > lb.y)
					continue;
				const WardHit& r = hits[i];
				const WardItem& item = g_wardLists[r.kind][r.index];
				const ImVec2 ra(la.x, y), rb(lb.x, y + rowH - 2.f);
				const bool sel = i == g_wardSearchRow && onResults;
				if (sel)
				{
					dl->AddRectFilledMultiColor(ra, rb, Rgb(146, 104, 28, 220), Rgb(34, 22, 6, 90), Rgb(34, 22, 6, 90), Rgb(146, 104, 28, 220));
					dl->AddRect(ra, rb, Rgb(255, 244, 214), 0.f, 0, 1.5f);
				}
				else
					FadeLineH(ra.x, rb.x, rb.y, Rgb(120, 100, 66, 60));
				const bool pinned = IsPinned(item.itemTemplate), on = wornHere(r);
				const char* tag = pinned ? Tx(T_model_pinned) : on ? Tx(T_ward_wearing) : "";
				// Room for the longest word it could have, so the slot's column stays put
				const float kindW = 170.f, tagW = std::max(Measure(kSans, 22, Tx(T_model_pinned)).x, Measure(kSans, 22, Tx(T_ward_wearing)).x) + 24.f;
				TextFit(kSerif, 30, ra.x + 14.f, y + 8.f, sel ? Rgb(255, 248, 230) : kText, item.title, rb.x - ra.x - kindW - tagW - 30.f);
				TextFit(kSans, 22, rb.x - kindW - tagW, y + 15.f, kGold, WardKindName(r.kind), kindW - 10.f);
				TextRight(kSans, 22, rb.x - 12.f, y + 15.f, pinned ? kGoldHi : kGreen, tag);
				if (Clicked(ra, rb) && Hover(la, lb))
				{
					if (i == g_wardSearchRow)
						wear = true;
					g_wardSearchRow = i;
					hit = &hits[i];
				}
			}
			dl->PopClipRect();
		}

		// What it does
		if (hit)
		{
			const WardItem& item = g_wardLists[hit->kind][hit->index];
			const std::string kind = kWardKind[hit->kind];
			if (wear)
			{
				if (wornHere(*hit))
					g_wardWorn.erase(kind);
				else
					g_wardWorn[kind] = PinnedPiece{ item.itemTemplate, item.title, DyeOf(m, item.itemTemplate) };
			}
			if (pinIt)
			{
				TogglePin(item.itemTemplate, item.title, DyeOf(m, item.itemTemplate));
				if (IsPinned(item.itemTemplate))
					g_wardWorn[kind] = PinnedPiece{ item.itemTemplate, item.title, DyeOf(m, item.itemTemplate) };
			}
			if (jump)
			{
				g_wardKind = hit->kind;
				g_wardRows[hit->kind] = hit->index;
				g_wardReveal = true;
				close = true;
			}
		}

		// Its prompts, at the foot of the screen
		std::vector<Hint> prompts;
		const bool wearing = hit && wornHere(*hit), pinnedHit = hit && IsPinned(g_wardLists[hit->kind][hit->index].itemTemplate);
		prompts.push_back({ kPadUp | kPadDown, Tx(T_up_down), Tx(T_move), kActNone });
		if (hit)
		{
			prompts.push_back({ kPadA, Tx(T_key_enter), Tx(wearing ? T_ward_take_off : T_ward_wear), kActNone });
			prompts.push_back({ kPadRT, Tx(T_key_tab), Tx(pinnedHit ? T_model_unpin : T_model_pin), kActNone });
			prompts.push_back({ kPadX, Tx(T_key_right), Tx(T_ward_jump), kActNone });
		}
		prompts.push_back({ kPadB, Tx(T_key_esc), Tx(T_close), kActNone });
		dl->AddRectFilled(ImVec2(0.f, kH - 100.f), ImVec2(kW, kH), Rgb(0, 0, 0, 200));
		DrawPromptRow(prompts, kH - 80.f);

		if (close)
		{
			g_wardSearch = false;
			g_backConsumed = true;   // the wardrobe's own B, later this frame, would close it too
		}
	}

	void DrawWardrobe(const Model& m)
	{
		BuildWardLists(m);
		Settings& st = GetSettings();
		std::vector<WardItem>& list = g_wardLists[g_wardKind];
		const int itemCount = static_cast<int>(list.size()), outfitCount = static_cast<int>(g_outfits.size());
		const int rowCount = itemCount + outfitCount;
		int& row = g_wardRows[g_wardKind];

		// Keys: none while he's enlarged, which has its own
		const WardClick click = g_wardClick;
		g_wardClick = kWardClickNone;
		const bool enlarged = g_wardEnlarged;
		const bool searching = g_wardSearch;
		const bool keys = !g_capture && !enlarged && !searching;
		if (keys)
		{
			int kindStep = 0;
			if (KeyHit(kKeyQ) || g_pad.Pressed(kPadLB))
				kindStep = -1;
			if (KeyHit(kKeyE) || g_pad.Pressed(kPadRB))
				kindStep = 1;
			if (kindStep)
			{
				g_wardKind = (g_wardKind + kindStep + kWardKinds) % kWardKinds;
				g_wardScroll = 0.f;
				return;   // next frame, with that kind's list
			}
			if (g_navLeft)
				StepAnimation(-1);
			if (g_navRight || click == kWardClickStance || KeyHit(kKeyT))
				StepAnimation(1);
		}
		const int step = enlarged || searching ? 0 : g_navDown ? 1 : g_navUp ? -1 : g_navPageDown ? 8 : g_navPageUp ? -8 : 0;
		if (step && rowCount > 0)
			row = std::clamp(row + step, 0, rowCount - 1);
		row = std::clamp(row, 0, std::max(0, rowCount - 1));
		const bool onItem = row < itemCount;
		const bool onOutfit = !onItem && row - itemCount < outfitCount;
		g_wardOnOutfit = onOutfit;
		g_wardOnPinned = onItem && IsPinned(list[row].itemTemplate);
		const auto wearing = [&](const WardItem& item)
		{
			const auto worn = g_wardWorn.find(kWardKind[g_wardKind]);
			return worn != g_wardWorn.end() && worn->second.itemTemplate == item.itemTemplate;
		};
		g_wardOnWorn = onItem && wearing(list[row]);

		const auto saveOutfit = [&]
		{
			Outfit outfit;
			outfit.pieces = g_wardWorn;
			if (outfit.pieces.empty())
				return;
			int number = 1;
			for (bool taken = true; taken; )
			{
				outfit.name = TxFill(T_ward_outfit_name, std::to_string(number));
				taken = std::any_of(g_outfits.begin(), g_outfits.end(), [&](const Outfit& o) { return o.name == outfit.name; });
				if (taken)
					++number;
			}
			g_outfits.push_back(std::move(outfit));
			SaveOutfits();
		};
		// Put on or take off what's selected; a saved outfit is put on whole
		const auto accept = [&]
		{
			if (onItem)
			{
				const WardItem& item = list[row];
				const std::string kind = kWardKind[g_wardKind];
				if (wearing(item) || item.itemTemplate.rfind(kWornNothing, 0) == 0)
					g_wardWorn.erase(kind);
				else
					g_wardWorn[kind] = PinnedPiece{ item.itemTemplate, item.title, DyeOf(m, item.itemTemplate) };
			}
			else if (onOutfit)
			{
				g_wardWorn = g_outfits[row - itemCount].pieces;
				for (const auto& [kind, piece] : g_wardWorn)
					g_wardDyes[piece.itemTemplate] = piece.dye;
			}
		};
		// Pin or unpin it: a pinned piece is what he shows on the Items tab, and it's put on here too
		const auto pin = [&]
		{
			if (onItem)
			{
				const WardItem& item = list[row];
				TogglePin(item.itemTemplate, item.title, DyeOf(m, item.itemTemplate));
				if (item.itemTemplate.rfind(kWornNothing, 0) == 0)
					g_wardWorn.erase(kWardKind[g_wardKind]);   // pinned bare: that slot stays empty
				else if (IsPinned(item.itemTemplate))
					g_wardWorn[kWardKind[g_wardKind]] = PinnedPiece{ item.itemTemplate, item.title, DyeOf(m, item.itemTemplate) };
			}
			else if (onOutfit)
			{
				g_pins = g_outfits[row - itemCount].pieces;
				g_wardWorn = g_pins;
				for (const auto& [kind, piece] : g_pins)
					g_wardDyes[piece.itemTemplate] = piece.dye;
				SavePins();
			}
		};
		if ((keys && g_navAccept) || (keys && KeyHit(kKeyX)) || click == kWardClickWear)
			accept();
		if ((keys && (KeyHit(kKeyF) || g_pad.Pressed(kPadRT))) || click == kWardClickPin)
			pin();
		if ((keys && (KeyHit(kKeyS) || g_pad.Pressed(kPadX))) || click == kWardClickSave)
			saveOutfit();
		if ((keys && (KeyHit(kKeyC) || g_pad.Pressed(kPadY))) || click == kWardClickClear)
		{
			if (onOutfit)
			{
				g_outfits.erase(g_outfits.begin() + (row - itemCount));
				SaveOutfits();
				return;
			}
			// Everything off and nothing pinned: back to how he starts
			g_wardWorn.clear();
			g_pins.clear();
			SavePins();
		}
		if ((keys && (KeyHit(kKeyH) || g_pad.Pressed(kPadStart))) || click == kWardClickUntracked)
		{
			st.wardrobeShowUntracked = !st.wardrobeShowUntracked;
			MarkDirty();
			g_wardListsOf = nullptr;   // the lists again, next frame
			return;
		}
		if ((keys && (KeyHit(kKeyR) || g_pad.Pressed(kPadBack))) || click == kWardClickSearch)
			OpenWardSearch();
		if ((EnlargeHeld() && keys) || click == kWardClickEnlarge)
		{
			g_wardEnlarged = true;
			g_cardZoomT = 0.f;
			g_cardZoomFrame = ImGui::GetFrameCount();
			OpenZoomModel();
		}

		// A and D or the triggers try the piece being looked at in the next dye. Only armour that has them, and that's known once it's loaded.
		std::vector<std::string> dyeLooks;
		std::string dyeNow;
		if (onItem)
		{
			dyeLooks = ItemDyeLooks(list[row].itemTemplate);
			dyeNow = DyeOf(m, list[row].itemTemplate);
		}
		g_wardCanDye = !dyeLooks.empty();
		// In the order of the swatches
		std::vector<const DyeLook*> dyeOrder;
		for (const DyeLook& look : kDyeLooks)
			if (std::find(dyeLooks.begin(), dyeLooks.end(), look.name) != dyeLooks.end())
				dyeOrder.push_back(&look);
		if (!dyeOrder.empty() && keys)
		{
			// A and D either way; the left trigger round, as the right one pins
			int dyeStep = 0;
			if (KeyHit(kKeyA))
				dyeStep = -1;
			if (KeyHit(kKeyD) || g_pad.Pressed(kPadLT))
				dyeStep = 1;
			if (dyeStep)
			{
				int at = 0;
				for (size_t i = 0; i < dyeOrder.size(); ++i)
					if (dyeNow == dyeOrder[i]->name)
						at = static_cast<int>(i);
				const int count = static_cast<int>(dyeOrder.size());
				dyeNow = dyeOrder[(at + dyeStep + count) % count]->name;
				SetDye(list[row].itemTemplate, dyeNow);
				const auto worn = g_wardWorn.find(kWardKind[g_wardKind]);
				if (worn != g_wardWorn.end() && worn->second.itemTemplate == list[row].itemTemplate)
					worn->second.dye = dyeNow;
			}
		}

		// What he's asked to wear: nothing in every slot, then what he has on here. Moving through the list changes nothing.
		std::string request;
		const auto wear = [&](const std::string& piece) { request += (request.empty() ? "" : "|") + piece; };
		for (int k = 0; k < kWardKinds; ++k)
			wear(std::string(kWornNothing) + kWardKind[k]);
		for (const auto& [kind, piece] : g_wardWorn)
			wear(Dyed(piece.itemTemplate, piece.dye));
		ModelViewAnimation(st.wardrobeAnimation);
#ifdef POTP_OVERLAY_TEST
		ModelViewRequest(!g_modelTest.empty() ? g_modelTest : kModelOnGeralt + request);
#else
		ModelViewRequest(kModelOnGeralt + request);
#endif

		// The head
		const float x0 = 60.f, x1 = std::clamp(kW * 0.38f, 560.f, 700.f) + x0, vx0 = x1 + 34.f, vx1 = kW - 60.f;
		Text(kTitle, 30, x0, 36.f, kGoldHi, Tx(T_ward_title));
		TextRight(kSans, 22, vx1, 44.f, kDim, Tx(T_ward_note));
		FadeLineH(40.f, kW - 40.f, 92.f, kGold);
		const float top = 108.f, bottom = kH - 112.f;

		// The kinds
		const float tabW = (x1 - x0) / kWardKinds;
		for (int k = 0; k < kWardKinds; ++k)
		{
			const ImVec2 a(x0 + tabW * k + 2.f, top), b(x0 + tabW * (k + 1) - 2.f, top + 52.f);
			const bool on = k == g_wardKind;
			if (on)
			{
				Field(300 + static_cast<int>(tabW), a, b, 7.f, [=](float px, float py)
				{
					return Mix(Rgb(150, 118, 68), Rgb(232, 204, 148), Fbm(px * 0.03f, py * 0.09f, 3));
				});
				dl->AddRect(a, b, Rgb(60, 44, 22), 0.f, 0, 2.f);
			}
			else
			{
				dl->AddRectFilled(a, b, Hover(a, b) ? Rgb(50, 40, 24, 220) : Rgb(0, 0, 0, 170));
				dl->AddRect(a, b, kGoldDim, 0.f, 0, 1.5f);
			}
			const char* name = WardKindName(k);
			const float room = b.x - a.x - 8.f;
			const int size = Measure(kTitle, 20, name).x <= room ? 20 : 18;
			const float w = std::min(Measure(kTitle, size, name).x, room);
			TextFit(kTitle, size, (a.x + b.x) * 0.5f - w * 0.5f, (a.y + b.y) * 0.5f - InkCentre(kTitle, size, "H").y, on ? kInk : Rgb(198, 188, 166), name, room);
			if (Clicked(a, b) && !on && !enlarged)
			{
				g_wardKind = k;
				g_wardScroll = 0.f;
				return;
			}
		}

		// Saved outfits, under the list
		const float outfitRowH = 42.f, outfitHeadH = 50.f;
		const float listTop = top + 64.f;
		const int roomFor = std::max(2, static_cast<int>((bottom - listTop) * 0.34f / outfitRowH));
		const int shown = std::min(std::max(1, outfitCount), roomFor);
		const float panelTop = bottom - outfitHeadH - shown * outfitRowH;
		g_wardOutfitTop = panelTop;
		const ImVec2 pa(x0, panelTop), pb(x1, bottom);
		dl->AddRectFilled(pa, pb, Rgb(0, 0, 0, 120));
		dl->AddRect(pa, pb, kGoldDim, 0.f, 0, 1.5f);
		Text(kTitle, 20, x0 + 14.f, panelTop + 13.f, kGold, Tx(T_ward_outfits));
		{
			const char* label = Tx(T_ward_save);
			const float w = Measure(kSans, 22, label).x;
			const ImVec2 sa(x1 - w - 22.f, panelTop + 6.f), sb(x1 - 6.f, panelTop + outfitHeadH - 6.f);
			Text(kSans, 22, sa.x + 8.f, panelTop + 13.f, Hover(sa, sb) ? kGoldHi : Rgb(232, 196, 128), label);
			if (Clicked(sa, sb) && !enlarged)
				saveOutfit();
		}
		FadeLineH(x0, x1, panelTop + outfitHeadH, kGoldDim);
		if (outfitCount == 0)
		{
			Text(kSerif, 28, x0 + 14.f, panelTop + outfitHeadH + 4.f, kDim, Tx(T_ward_no_outfits));
		}
		else
		{
			const int cursor = onOutfit ? row - itemCount : 0;
			const int first = std::clamp(cursor - shown / 2, 0, std::max(0, outfitCount - shown));
			for (int i = first; i < std::min(outfitCount, first + shown); ++i)
			{
				const float y = panelTop + outfitHeadH + (i - first) * outfitRowH;
				const ImVec2 a(x0 + 1.f, y), b(x1 - 1.f, y + outfitRowH);
				const bool sel = onOutfit && i == row - itemCount;
				if (sel)
				{
					dl->AddRectFilledMultiColor(a, b, Rgb(146, 104, 28, 190), Rgb(34, 22, 6, 90), Rgb(34, 22, 6, 90), Rgb(146, 104, 28, 190));
					dl->AddRect(a, b, Rgb(232, 204, 146, 220), 0.f, 0, 1.5f);
				}
				Text(kSerif, 28, x0 + 14.f, y + 4.f, sel ? Rgb(255, 248, 230) : kText, g_outfits[i].name.c_str());
				std::string names;
				for (const auto& [kind, piece] : g_outfits[i].pieces)
					names += (names.empty() ? "" : ", ") + piece.title;
				const float nameW = Measure(kSerif, 28, g_outfits[i].name.c_str()).x + 30.f;
				TextFit(kSans, 22, x0 + 14.f + nameW, y + 9.f, kDim, names, x1 - x0 - nameW - 34.f);
				if (Clicked(a, b) && !enlarged)
				{
					if (sel)
						accept();
					row = itemCount + i;
				}
			}
		}

		// The list
		const float rowH = 54.f, viewH = std::max(rowH, panelTop - 10.f - listTop);
		const ImVec2 la(x0, listTop), lb(x1 - 16.f, listTop + viewH);
		const float contentH = itemCount * rowH;
		if (Hover(la, lb) && g_wheel != 0.f)
			g_wardScroll -= g_wheel * 148.f;
		if ((step || g_wardReveal) && onItem)
		{
			g_wardReveal = false;
			if (row * rowH < g_wardScroll)
				g_wardScroll = row * rowH;
			if ((row + 1) * rowH > g_wardScroll + viewH)
				g_wardScroll = (row + 1) * rowH - viewH;
		}
		g_wardScroll = std::clamp(g_wardScroll, 0.f, std::max(0.f, contentH - viewH));
		if (itemCount == 0)
			TextCentre(kSerif, 30, (la.x + lb.x) * 0.5f, listTop + 30.f, kDim, Tx(T_ward_empty));
		dl->PushClipRect(la, lb, true);
		for (int i = 0; i < itemCount; ++i)
		{
			const float y = listTop + i * rowH - g_wardScroll;
			if (y + rowH < listTop || y > listTop + viewH)
				continue;
			const WardItem& item = list[i];
			const ImVec2 a(x0, y), b(lb.x, y + rowH - 2.f);
			const bool sel = onItem && i == row, pinned = IsPinned(item.itemTemplate);
			if (sel)
			{
				dl->AddRectFilledMultiColor(a, b, Rgb(146, 104, 28, 220), Rgb(34, 22, 6, 90), Rgb(34, 22, 6, 90), Rgb(146, 104, 28, 220));
				dl->AddRect(a, b, Rgb(255, 244, 214), 0.f, 0, 1.5f);
			}
			else
			{
				FadeLineH(a.x, b.x, b.y, Rgb(120, 100, 66, 60));
			}
			const bool nothing = item.itemTemplate.rfind(kWornNothing, 0) == 0;
			const bool on = wearing(item);
			const char* tag = pinned ? Tx(T_model_pinned) : on ? Tx(T_ward_wearing) : nothing ? "" : !item.tracked ? Tx(T_ward_not_tracked) : item.done ? Tx(T_ward_collected) : Tx(T_ward_not_collected);
			const float tagW = Measure(kSans, 22, tag).x + 18.f;
			TextFit(kSerif, 30, x0 + 14.f, y + 8.f, sel ? Rgb(255, 248, 230) : kText, item.title, b.x - a.x - tagW - 26.f);
			TextRight(kSans, 22, b.x - 12.f, y + 15.f, pinned ? kGoldHi : on ? kGreen : kDim, tag);
			if (Clicked(a, b) && Hover(la, lb) && !enlarged)
			{
				if (sel)
					accept();
				row = i;
			}
		}
		dl->PopClipRect();
		if (contentH > viewH)
		{
			const ImVec2 ta(x1 - 8.f, listTop), tb(x1, listTop + viewH);
			dl->AddRectFilled(ta, tb, Rgb(24, 20, 14, 220));
			const float thumbH = std::max(50.f, viewH * viewH / contentH);
			const float thumbY = listTop + (viewH - thumbH) * (g_wardScroll / (contentH - viewH));
			dl->AddRectFilled(ImVec2(ta.x, thumbY), ImVec2(tb.x, thumbY + thumbH), kGold);
		}

		// What he has on, across the top of him
		const float cardGap = 6.f, cardH = 64.f, cardW = (vx1 - vx0 - cardGap * (kWardKinds - 1)) / kWardKinds;
		for (int k = 0; k < kWardKinds; ++k)
		{
			const ImVec2 a(vx0 + (cardW + cardGap) * k, top), b(a.x + cardW, top + cardH);
			const auto worn = g_wardWorn.find(kWardKind[k]);
			const std::string name = worn != g_wardWorn.end() ? worn->second.title : Tx(T_ward_nothing);
			const bool held = g_pins.count(kWardKind[k]) != 0;
			dl->AddRectFilled(a, b, Rgb(0, 0, 0, 120));
			dl->AddRect(a, b, held ? kGoldHi : kGoldDim, 0.f, 0, 1.5f);
			TextFit(kSans, 22, a.x + 8.f, a.y + 4.f, held ? kGoldHi : kGold, WardKindName(k), cardW - 14.f);
			TextFit(kSans, 22, a.x + 8.f, a.y + 32.f, kText, name, cardW - 14.f);
		}

		// Him
		const float footH = 74.f;
		const ImVec2 va(vx0, top + cardH + 6.f), vb(vx1, bottom - footH);
		if (g_clicked && Hover(va, vb) && !enlarged)
			g_wardDragging = true;
		if (!ImGui::IsMouseDown(0))
			g_wardDragging = false;
		if (g_wardDragging)
		{
			g_modelYaw += ImGui::GetIO().MouseDelta.x * 0.45f;
			g_modelPitch = std::clamp(g_modelPitch - ImGui::GetIO().MouseDelta.y * 0.3f, -50.f, 50.f);
		}
		if (g_pad.rightX != 0.f && !enlarged)
			g_modelYaw += g_pad.rightX * g_dt * 130.f;
		if (Hover(va, vb) && g_wheel != 0.f && !enlarged)
			g_wardZoom += g_wheel * 0.12f;
		if (g_pad.rightY != 0.f && !enlarged)
			g_wardZoom -= g_pad.rightY * g_dt * 1.1f;
		g_wardZoom = std::clamp(g_wardZoom, 1.f, 2.4f);
		if (!enlarged)
			ModelViewShow(TurnToShow(g_modelYaw), g_modelPitch);
		const ImVec2 centre((va.x + vb.x) * 0.5f, (va.y + vb.y) * 0.5f);
		const float side = std::min(vb.x - va.x, vb.y - va.y) * g_wardZoom;
		// Zooming goes in toward his head and chest, not his belt
		const float lift = (g_wardZoom - 1.f) * side * 0.16f;
		if (ModelViewState() == kModelMissing)
			TextCentre(kSerif, 28, centre.x, centre.y - 18.f, kDim, Tx(T_no_model));
		else if (const unsigned long long picture = enlarged ? 0 : ModelViewTexture())
		{
			dl->PushClipRect(va, vb, true);
			const float u = 0.5f / ModelViewAspect();   // the square from the picture's middle
			dl->AddImage(static_cast<ImTextureID>(picture), ImVec2(centre.x - side * 0.5f, centre.y - side * 0.5f + lift), ImVec2(centre.x + side * 0.5f, centre.y + side * 0.5f + lift), ImVec2(0.5f - u, 0.f), ImVec2(0.5f + u, 1.f));
			dl->PopClipRect();
		}
		else if (!enlarged)
			TextCentre(kSerif, 28, centre.x, centre.y - 18.f, kDim, Tx(T_loading));
		// The dyes, down the side of him. A click tries one on.
		if (!dyeOrder.empty())
		{
			const float dot = 30.f, pitch = 42.f;
			const float dotX = vb.x - dot * 0.5f - 14.f;
			const float columnH = pitch * dyeOrder.size();
			const float dotY0 = (va.y + vb.y) * 0.5f - columnH * 0.5f + pitch * 0.5f;
			const std::string label = DyeName(m, dyeNow);
			TextRight(kTitle, 20, vb.x - 8.f, dotY0 - 82.f, kGold, Upper(Tx(T_ward_dye)).c_str());
			TextRight(kSerif, 28, vb.x - 8.f, dotY0 - 58.f, kGoldHi, label.c_str());
			for (size_t i = 0; i < dyeOrder.size(); ++i)
			{
				const ImVec2 c(dotX, dotY0 + pitch * i);
				const bool on = dyeNow == dyeOrder[i]->name || (dyeNow.empty() && i == 0);
				const ImVec2 a(c.x - dot * 0.5f, c.y - dot * 0.5f), b(c.x + dot * 0.5f, c.y + dot * 0.5f);
				if (dyeOrder[i]->colour)
					dl->AddCircleFilled(c, dot * 0.5f, dyeOrder[i]->colour, 24);
				else
				{
					// Undyed: an empty ring with a line through it
					dl->AddLine(ImVec2(c.x - dot * 0.35f, c.y + dot * 0.35f), ImVec2(c.x + dot * 0.35f, c.y - dot * 0.35f), kGold, 2.f);
				}
				dl->AddCircle(c, dot * 0.5f, on ? Rgb(255, 244, 214) : Hover(a, b) ? kGoldHi : kGoldDim, 24, on ? 3.f : 1.5f);
				if (Clicked(a, b) && !enlarged)
				{
					g_wardDragging = false;
					SetDye(list[row].itemTemplate, dyeOrder[i]->name);
					const auto worn = g_wardWorn.find(kWardKind[g_wardKind]);
					if (worn != g_wardWorn.end() && worn->second.itemTemplate == list[row].itemTemplate)
						worn->second.dye = dyeOrder[i]->name;
				}
			}
		}
		TextCentre(kSerif, 30, centre.x, vb.y + 4.f, kGoldHi, AnimationName(st.wardrobeAnimation));
		TextCentre(kSans, 22, centre.x, vb.y + 42.f, kDim, g_padPrompts ? Tx(T_ward_hint_pad) : Tx(T_ward_hint_mouse));
		if (searching)
			DrawWardSearch(m);
	}

	void DrawCursor()
	{
		if (g_padMode)
			return;
		const ImVec2 p = g_mouse;
		const ImVec2 shape[4] = { p, {p.x + 6, p.y + 30}, {p.x + 13, p.y + 20}, {p.x + 25, p.y + 19} };
		const ImVec2 shadow[4] = { {p.x + 2, p.y + 3}, {p.x + 8, p.y + 33}, {p.x + 15, p.y + 23}, {p.x + 27, p.y + 22} };
		dl->PathClear();
		for (const ImVec2& v : shadow)
			dl->PathLineTo(v);
		dl->PathFillConcave(Rgb(0, 0, 0, 150));
		dl->PathClear();
		for (const ImVec2& v : shape)
			dl->PathLineTo(v);
		dl->PathFillConcave(Rgb(232, 208, 156));
		dl->AddPolyline(shape, 4, Rgb(70, 50, 24), ImDrawFlags_Closed, 1.5f);
	}

	// Keys, the mouse and the controller, into one set of moves
	void GatherInput()
	{
		ImGuiIO& io = ImGui::GetIO();
		g_clicked = ImGui::IsMouseClicked(0);
		g_wheel = io.MouseWheel;

		// Which prompts to show follows the last thing touched
		const Settings& st = GetSettings();
		if (g_pad.connected && g_pad.Moved())
			g_padMode = true;
		bool keyOrMouse = io.MouseDelta.x != 0.f || io.MouseDelta.y != 0.f || g_clicked || g_wheel != 0.f;
		for (int key = ImGuiKey_NamedKey_BEGIN; key < ImGuiKey_GamepadStart && !keyOrMouse; ++key)
			keyOrMouse = ImGui::IsKeyPressed(static_cast<ImGuiKey>(key), false);
		if (keyOrMouse)
			g_padMode = false;
		g_padPrompts = st.promptMode == kPromptsController || (st.promptMode == kPromptsAuto && g_padMode);
		RefreshKeys();

		// The pad and the left stick repeat like a held key
		static double next[4] = { 0, 0, 0, 0 };
		static bool held[4] = { false, false, false, false };
		const double now = ImGui::GetTime();
		const bool active[4] = {
			(g_pad.buttons & kPadUp) != 0 || g_pad.leftY > 0.55f,
			(g_pad.buttons & kPadDown) != 0 || g_pad.leftY < -0.55f,
			(g_pad.buttons & kPadLeft) != 0 || g_pad.leftX < -0.55f,
			(g_pad.buttons & kPadRight) != 0 || g_pad.leftX > 0.55f,
		};
		bool fired[4] = {};
		for (int i = 0; i < 4; ++i)
		{
			if (active[i])
			{
				if (!held[i])
				{
					fired[i] = true;
					next[i] = now + 0.32;
				}
				else if (now >= next[i])
				{
					fired[i] = true;
					next[i] = now + 0.075;
				}
			}
			held[i] = active[i];
		}
		g_navUp = !g_capture && (fired[0] || ImGui::IsKeyPressed(ImGuiKey_UpArrow));
		g_navDown = !g_capture && (fired[1] || ImGui::IsKeyPressed(ImGuiKey_DownArrow));
		g_navLeft = !g_capture && (fired[2] || ImGui::IsKeyPressed(ImGuiKey_LeftArrow));
		g_navRight = !g_capture && (fired[3] || ImGui::IsKeyPressed(ImGuiKey_RightArrow));
		g_navPageUp = !g_capture && (ImGui::IsKeyPressed(ImGuiKey_PageUp));
		g_navPageDown = !g_capture && (ImGui::IsKeyPressed(ImGuiKey_PageDown));
		g_navAccept = !g_capture && (ImGui::IsKeyPressed(ImGuiKey_Enter, false) || g_pad.Pressed(kPadA));
	}
}

bool UiCaptureKey(unsigned vk)
{
	if (!g_capture)
		return false;
	// Windows sends a fake key, code 255, ahead of some real ones: wait for the real one
	if (vk == 0 || vk >= 0xFF)
		return true;
	// With Num Lock off, Numpad 5 arrives as Clear
	if (vk == VK_CLEAR)
		vk = VK_NUMPAD5;
	// The game toggles its HUD with Home, and one key can't do both jobs: keep waiting for another
	if (vk == VK_HOME || vk == (g_captureUpdate ? GetSettings().openKey : GetSettings().updateKey))
		return true;
	g_capture = false;
	if (vk != VK_ESCAPE)
	{
		(g_captureUpdate ? GetSettings().updateKey : GetSettings().openKey) = vk;
		g_saveSoon = true;
		g_saveAt = 0.0;
	}
	return true;
}

void UiPushPopup(const std::string& text)
{
	// Every piece of armour: WARD, then A|kind|template|title
	if (text.rfind("WARD", 0) == 0)
	{
		std::vector<WardExtra> extras;
		for (size_t start = 0; start < text.size();)
		{
			size_t end = text.find("\\n", start);
			if (end == std::string::npos)
				end = text.size();
			const std::string line = text.substr(start, end - start);
			start = end + 2;
			std::vector<std::string> f;
			for (size_t from = 0;;)
			{
				const size_t bar = line.find('|', from);
				f.push_back(line.substr(from, bar == std::string::npos ? std::string::npos : bar - from));
				if (bar == std::string::npos)
					break;
				from = bar + 1;
			}
			if (f[0] == "A" && f.size() >= 4 && !f[2].empty())
			{
				std::string title = CleanGameText(f[3]);
				if (f.size() >= 5 && f[4] == "lowered")
					title = TxFill(T_ward_lowered, title);   // a hood mod's hood down: the same name as up
				extras.push_back(WardExtra{ f[1], f[2], title });
			}
		}
		std::lock_guard lock(g_wardExtrasLock);
		g_wardExtras = std::move(extras);
		g_wardExtrasFresh = true;
		return;
	}
	// I|...: an item's stats that were asked for
	if (text.rfind("I|", 0) == 0)
	{
		ReceiveItemStats(text);
		return;
	}
	PopupMessage message = ParsePopup(text);
	std::lock_guard lock(g_popupMutex);
	if (message.kind == 2)
		g_warningQueue.push_back(std::move(message));
	else
		g_popupQueue.push_back(std::move(message));
}

bool UiWarningUp()
{
	return g_warningUp;
}

void UiSetPopupHold(bool hold)
{
	g_popupHold = hold;
}

#ifdef POTP_OVERLAY_TEST
void UiTestStance(int stance)
{
	GetSettings().wardrobeAnimation = stance;
}

void UiTestKillPage(int page)
{
	g_killPage = page;
}

void UiTestBook(int book)
{
	g_book = book;
}

void UiTestPlacement()
{
	g_placeFromX = GetSettings().popupX;
	g_placeFromY = GetSettings().popupY;
	g_placing = true;
}
#endif

void UiOpenedByPad()
{
	if (GetSettings().promptMode == kPromptsAuto)
		g_padMode = true;
}

void UiSetMouseScale(float x, float y)
{
	g_mouseScale = ImVec2(x, y);
}

float UiWantedFontScale()
{
	return std::max(0.25f, g_k);
}

bool UiBackOut()
{
	if (g_warning)
	{
		g_warningDismissed = true;
		return true;
	}
	if (g_placing)
	{
		g_placing = false;
		GetSettings().popupX = g_placeFromX;
		GetSettings().popupY = g_placeFromY;
		return true;
	}
	if (g_statusOpen)
	{
		g_statusOpen = false;
		return true;
	}
	if (g_wardrobeOpen && g_wardEnlarged)
	{
		g_wardEnlarged = false;
		return true;
	}
	if (g_wardrobeOpen && g_wardSearch)
	{
		g_wardSearch = false;
		return true;
	}
	if (g_wardrobeOpen)
	{
		CloseWardrobe();
		return true;
	}
	if (!g_setEditing)
		return false;
	g_setEditing = false;
	return true;
}

void UiLoadFonts(float scale)
{
	// PotP's fonts, in its mod folder whatever it's called. The test program sets its own folder.
	char folder[MAX_PATH * 3] = "";
#ifdef POTP_OVERLAY_TEST
	wchar_t overrideFolder[MAX_PATH];
	if (GetEnvironmentVariableW(L"POTP_OVERLAY_FONTS", overrideFolder, MAX_PATH) > 0)
	{
		WideCharToMultiByte(CP_UTF8, 0, overrideFolder, -1, folder, sizeof(folder), nullptr, nullptr);
	}
	else
#endif
	{
		const std::wstring path = ModFolder() + L"\\fonts";
		WideCharToMultiByte(CP_UTF8, 0, path.c_str(), -1, folder, sizeof(folder), nullptr, nullptr);
	}

	ImGuiIO& io = ImGui::GetIO();
	io.Fonts->TexDesiredWidth = 4096;
	g_fonts.clear();
	g_ink.clear();
	static ImVector<ImWchar> ranges;
	if (ranges.empty())
	{
		ImFontGlyphRangesBuilder builder;
		builder.AddRanges(io.Fonts->GetGlyphRangesDefault());
		builder.AddRanges(io.Fonts->GetGlyphRangesCyrillic());
		static const ImWchar latinExtended[] = { 0x0100, 0x017F, 0x2013, 0x2026, 0 };
		builder.AddRanges(latinExtended);
		builder.BuildRanges(&ranges);
	}

	const std::string garamond = std::string(folder) + "\\EBGaramond.ttf";
	const auto load = [&](Face face, const char* file, std::initializer_list<int> sizes, float weight, bool mergeGaramond)
	{
		const std::string path = std::string(folder) + "\\" + file;
		const bool exists = GetFileAttributesA(path.c_str()) != INVALID_FILE_ATTRIBUTES;
		for (int size : sizes)
		{
			ImFont* font = nullptr;
			const float pixels = std::max(6.f, static_cast<float>(size) * scale);
			if (exists)
			{
				ImFontConfig config;
				config.OversampleH = 2;
				config.OversampleV = 1;
				config.RasterizerMultiply = weight;
				font = io.Fonts->AddFontFromFileTTF(path.c_str(), pixels, &config, ranges.Data);
				// Cinzel has no Cyrillic: the letters it lacks come from Garamond
				if (font && mergeGaramond)
				{
					ImFontConfig merge;
					merge.MergeMode = true;
					merge.OversampleH = 2;
					merge.OversampleV = 1;
					merge.RasterizerMultiply = weight;
					io.Fonts->AddFontFromFileTTF(garamond.c_str(), pixels, &merge, ranges.Data);
				}
			}
			if (!font)
			{
				Log("font %s not found, using the built-in one", path.c_str());
				font = io.Fonts->AddFontDefault();
			}
			g_fonts[{ face, size }] = font;
		}
	};
	load(kSans, "AlegreyaSans-Regular.ttf", { 22, 24, 26 }, 1.1f, false);
	load(kSerif, "EBGaramond.ttf", { 28, 30, 32, 34, 48, 64, 72 }, 1.3f, false);
	load(kTitle, "Cinzel.ttf", { 20, 22, 24, 28, 32, 48, 64 }, 1.15f, true);
}

// The tour's wardrobe steps have it open. It's shut again after them, if it was the tour that opened it.
// The panel a step shows: the status panel or what shows over the entry the list has, or the enlarged model
static void TourSyncPanels()
{
	static int opened = kTourOpenNothing;
	const int want = g_tour >= 0 ? kTourSteps[g_tour].open : kTourOpenNothing;
	if (opened != kTourOpenNothing && want != opened)
	{
		g_statusOpen = g_visibilityOpen = g_cardZoom = false;
		opened = kTourOpenNothing;
	}
	if (want == kTourOpenStatus && g_itemShown && !(g_statusOpen && !g_visibilityOpen && !g_cardZoom))
	{
		g_statusOpen = true;
		g_visibilityOpen = g_cardZoom = false;
		opened = want;
	}
	else if (want == kTourOpenVisibility && !(g_statusOpen && g_visibilityOpen))
	{
		g_statusOpen = g_visibilityOpen = true;
		g_cardZoom = false;
		opened = want;
	}
	else if (want == kTourOpenEnlarged && !g_cardZoom && g_itemShown && CanEnlarge(*g_itemShown))
	{
		// As soon as the model's there to enlarge
		g_statusOpen = g_cardZoom = true;
		g_visibilityOpen = false;
		g_cardZoomT = 0.f;
		g_cardZoomFrame = ImGui::GetFrameCount();
		g_cardZoomYaw = g_cardZoomPitch = 0.f;
		OpenZoomModel();
		opened = want;
	}
}

static void TourSyncWardrobe(const Model* model)
{
	const bool want = g_tour >= 0 && kTourSteps[g_tour].wardrobe && model;
	if (want && !g_wardrobeOpen)
	{
		OpenWardrobe(*model, nullptr);
		g_tourOpenedWardrobe = true;
	}
	else if (!want && g_tourOpenedWardrobe)
	{
		g_tourOpenedWardrobe = false;
		if (g_wardrobeOpen)
			CloseWardrobe();
	}

	// The dyes step needs a piece that takes them, so it goes to one: the school sets all do. Then back to where it was.
	static bool onDyes = false;
	static int fromKind = 0, fromRow = 0;
	const bool dyes = want && kTourSteps[g_tour].spot == kTourWardDyes;
	if (dyes && !onDyes)
	{
		BuildWardLists(*model);
		fromKind = g_wardKind;
		fromRow = g_wardRows[0];
		const std::vector<WardItem>& armour = g_wardLists[0];
		for (const char* school : { "bear", "gryphon", "lynx", "wolf" })
		{
			const auto found = std::find_if(armour.begin(), armour.end(), [&](const WardItem& item) { return WardStem(item.itemTemplate).find(school) != std::string::npos; });
			if (found != armour.end())
			{
				g_wardKind = 0;
				g_wardRows[0] = static_cast<int>(found - armour.begin());
				g_wardReveal = true;
				break;
			}
		}
	}
	else if (!dyes && onDyes)
	{
		g_wardKind = fromKind;
		g_wardRows[0] = fromRow;
		g_wardReveal = true;
	}
	onDyes = dyes;
}

void DrawUi()
{
	ImGuiIO& io = ImGui::GetIO();
	Settings& st = GetSettings();
	g_dt = std::min(io.DeltaTime, 0.1f);

	// The panel's size and scale, whether it's open or not, so the fonts are right when it opens
	const float base = std::min(io.DisplaySize.x / kRefW, io.DisplaySize.y / kRefH);
	if (base <= 0.f)
		return;
	const float panelW = io.DisplaySize.x * st.widthPercent / 100.f, panelH = io.DisplaySize.y * st.heightPercent / 100.f;
	float k = st.scale * base;
	k = std::min({ k, panelW / kMinW, panelH / kMinH });
	g_k = k;
	kW = panelW / k;
	kH = panelH / k;
	kBottom = kH - 112.f;

	// Read even while it's shut, so nothing pressed before it opened counts as a press in it
	g_pad = PadPoll();

	// The right stick does one thing at a time: whichever way it's pushed first, until it's let go, so a
	// slightly diagonal push doesn't tilt a card while scrolling, or scroll while tilting a card
	{
		static int stickAxis = 0;   // 0 neither yet, 1 across, 2 up and down
		const float across = fabsf(g_pad.rightX), upDown = fabsf(g_pad.rightY);
		if (across < 0.15f && upDown < 0.15f)
			stickAxis = 0;
		else if (stickAxis == 0 && std::max(across, upDown) >= 0.25f)
			stickAxis = across > upDown ? 1 : 2;
		if (stickAxis != 1)
			g_pad.rightX = 0.f;
		if (stickAxis != 2)
			g_pad.rightY = 0.f;
	}
	const double now = ImGui::GetTime();
	if (g_saveSoon && now >= g_saveAt)
	{
		g_saveSoon = false;
		SaveSettings();
	}

	// A warning waits its turn behind the window, the game's own notification and anything that's keeping the player busy
	if (!g_warning && !g_placing && !g_popupHold && !MenuOpen())
	{
		std::lock_guard lock(g_popupMutex);
		if (!g_warningQueue.empty())
		{
			g_warning = std::make_unique<PopupMessage>(std::move(g_warningQueue.front()));
			g_warningQueue.pop_front();
			g_warningScroll = 0.f;
			g_warningT = 0.f;
			g_warningDismissed = false;
			g_warningUp = true;
			SetMenuOpen(true);
		}
	}

	const bool open = MenuOpen();
	if (!open)
	{
		if (g_warning)   // the open key shut it
		{
			g_warning.reset();
			g_warningUp = false;
		}
		if (g_modDirty)
		{
			g_modDirty = false;
			RequestSettingsClosed();
		}
		g_statusOpen = false;
		if (g_wardrobeOpen)
			CloseWardrobe();
		g_wasOpen = false;
		g_openT = 0.f;
		g_dragging = false;
		g_capture = false;
		g_setEditing = false;
		g_freeScrolled = false;
		if (g_placing)
		{
			g_placing = false;
			st.popupX = g_placeFromX;
			st.popupY = g_placeFromY;
		}
		dl = ImGui::GetBackgroundDrawList();
		UpdatePopup();
		return;
	}
	if (!g_wasOpen)
	{
		g_wasOpen = true;
		{
			// What he has on may have changed, and with it what his sets give
			std::lock_guard statsLock(g_itemStatsLock);
			g_itemStats.clear();
			g_itemStatsAsked.clear();
		}
		g_openT = 0.f;
		g_barT = 0.f;
		g_wholeBarT = 0.f;
		const int book = st.openOnLastBook ? std::clamp(st.lastBook, 0, kTabCount - 1) : 0;
		g_book = book;
		g_tabShown = static_cast<float>(book);
		g_followSelection = true;
	}
	g_openT = std::min(1.f, g_openT + g_dt * 7.f);
	if (g_barT < 1.f)
		g_barT = std::min(1.f, g_barT + g_dt * 2.6f);
	if (g_wholeBarT < 1.f)
		g_wholeBarT = std::min(1.f, g_wholeBarT + g_dt * 2.6f);

	// Surfaces are worked out for one size and opacity
	const int surfaceW = static_cast<int>(kW), surfaceH = static_cast<int>(kH), surfaceOpacity = static_cast<int>(st.opacity * 100.f);
	if (surfaceW != g_surfaceW || surfaceH != g_surfaceH || surfaceOpacity != g_surfaceOpacity)
	{
		g_surfaces.clear();
		g_surfaceW = surfaceW;
		g_surfaceH = surfaceH;
		g_surfaceOpacity = surfaceOpacity;
	}

	// Dragging by the top bar, always keeping a good part of the panel on screen
	if (g_dragging)
	{
		if (ImGui::IsMouseDown(0))
		{
			st.posX += io.MouseDelta.x * g_mouseScale.x / io.DisplaySize.x;
			st.posY += io.MouseDelta.y * g_mouseScale.y / io.DisplaySize.y;
			MarkDirty();
		}
		else
		{
			g_dragging = false;
		}
	}
	const float roomX = (io.DisplaySize.x + panelW) * 0.5f - 200.f * k, roomY = (io.DisplaySize.y + panelH) * 0.5f - 100.f * k;
	const float offsetX = std::clamp(st.posX * io.DisplaySize.x, -roomX, roomX);
	const float offsetY = std::clamp(st.posY * io.DisplaySize.y, -(io.DisplaySize.y - panelH) * 0.5f, std::max(roomY, 0.f));
	st.posX = offsetX / io.DisplaySize.x;
	st.posY = offsetY / io.DisplaySize.y;
	const float ease = 1.f - (1.f - g_openT) * (1.f - g_openT);
	const float ox = (io.DisplaySize.x - panelW) * 0.5f + offsetX;
	const float oy = (io.DisplaySize.y - panelH) * 0.5f + offsetY + (1.f - ease) * 26.f * k;

	g_mouse = ImVec2((io.MousePos.x * g_mouseScale.x - ox) / k, (io.MousePos.y * g_mouseScale.y - oy) / k);
	GatherInput();

	// Everything goes in in the panel's own space, then this frame's vertices and clip rectangles are scaled and placed
	dl = ImGui::GetBackgroundDrawList();
	UpdatePopup();   // keeps its timer right; it isn't drawn while the window's open
	if (g_warning)
	{
		DrawWarning();
		return;
	}
	if (g_placing)
	{
		DrawPlacement();
		return;
	}
	dl->AddRectFilled(ImVec2(0, 0), io.DisplaySize, Rgb(0, 0, 0, static_cast<int>(255.f * st.dim * ease)));   // the game, dimmed but still there
	dl->PushClipRect(ImVec2(-10000, -10000), ImVec2(20000, 20000), false);
	const int firstVertex = dl->VtxBuffer.Size;
	const int firstCommand = dl->CmdBuffer.Size - 1;

	const BridgeState state = GetBridgeState();
	const Model* model = state.model.get();
	SyncPages(model);

	// While the Change Status panel is up it has the input, and everything behind it sees none
	OfferTour(model);
	if (g_tour != -2)
		TourTakeInput();
	TourSyncWardrobe(model);
	TourSyncPanels();
	const bool statusTakesInput = g_statusOpen;
	const bool navUp = g_navUp, navDown = g_navDown, navAccept = g_navAccept, clicked = g_clicked;
	const float stickX = g_pad.rightX, stickY = g_pad.rightY, wheel = g_wheel;
	if (statusTakesInput)
	{
		g_navUp = g_navDown = g_navLeft = g_navRight = g_navPageUp = g_navPageDown = g_navAccept = false;
		g_clicked = false;
		g_wheel = 0.f;
		g_pad.rightX = g_pad.rightY = 0.f;
		g_modalBlock = true;
	}

	DrawBackground();
	if (g_wardrobeOpen && (!model || g_book != kBookItems))
		CloseWardrobe();
	if (!g_wardrobeOpen)
		DrawTopBar(model);

	const Entry* selected = nullptr;
	if (g_wardrobeOpen)
	{
		DrawWardrobe(*model);
	}
	else if (g_book == kTabSettings)
	{
		DrawSettingsTab();
	}
	else if (g_book == kTabKills)
	{
		DrawKillsTab(model);
	}
	else if (g_book == kTabAchievements)
	{
		// Read when it's come to, and now and then while it's up. It needs no save, as the store's list is the account's.
		const ULONGLONG ticksNow = GetTickCount64();
		if (ticksNow >= g_achievementsNextAsk)
		{
			g_achievementsNextAsk = ticksNow + 30000;
			RequestAchievements();
		}
		if (const Model* achievements = AchievementsModel())
		{
			DrawRegionRow(*achievements);
			const Section* section = nullptr;
			selected = DrawList(*achievements, &section);
			DrawAchievementDetail(selected, section);
			DrawSummary(*achievements);
		}
		else
		{
			TextCentre(kSerif, 34, kW * 0.5f, kH * 0.5f, kHead, Tx(T_no_pack));
		}
	}
	else if (model)
	{
		DrawRegionRow(*model);
		const Section* section = nullptr;
		selected = DrawList(*model, &section);
		g_creatureShown = selected;
		g_itemShown = selected;
		// The creatures either side of it in the list, read ahead while it's shown
		if (selected && g_book == kBookBestiary && GetSettings().liveBestiary)
		{
			std::vector<std::string> around;
			for (size_t i = 0; i < g_rows.size(); ++i)
			{
				const Row& row = g_rows[i];
				if (row.entry < 0 || model->sections[row.section].entries[row.entry].uuid != selected->uuid)
					continue;
				for (int step = 1; step <= 2; ++step)
					for (const int at : { static_cast<int>(i) + step, static_cast<int>(i) - step })
						if (at >= 0 && at < static_cast<int>(g_rows.size()) && g_rows[at].entry >= 0)
						{
							const Entry& other = model->sections[g_rows[at].section].entries[g_rows[at].entry];
							if (LiveCreature(other))
								around.push_back(kModelCreature + other.creatureTemplate);
						}
				break;
			}
			ModelViewPrefetch(around);
		}
		if (g_headerFocus && g_book == kBookMissable)
		{
			DrawGroupDetail(*model, *g_headerFocus);
			selected = nullptr;   // nothing to change the status of
		}
		else if (selected)
			DrawDetail(*model, selected, section);
		DrawSummary(*model);
	}
	else
	{
		const char* message = state.message.empty() ? Tx(T_reading_progress) : state.message.c_str();
		SoftGlow(ImVec2(kW * 0.5f, kH * 0.42f), 150, Alpha(kGold, 0.18f));
		BookSign(g_book, ImVec2(kW * 0.5f, kH * 0.42f), 60, Rgb(250, 232, 190), 4.f);
		TextCentre(kSerif, 34, kW * 0.5f, kH * 0.5f, kHead, message);
		FadeLineH(kW * 0.3f, kW * 0.7f, kH * 0.5f + 60, kGold);
	}
	DrawHints(selected, state);
	g_modalBlock = false;
	if (g_statusOpen && !selected && !g_visibilityOpen)
		g_statusOpen = false;
	if (g_statusOpen && g_visibilityOpen)
	{
		g_navUp = navUp;
		g_navDown = navDown;
		g_navAccept = navAccept;
		g_clicked = clicked;
		DrawVisibilityPanel(statusTakesInput);
	}
	else if (g_statusOpen && !g_cardZoom)
	{
		g_navUp = navUp;
		g_navDown = navDown;
		g_navAccept = navAccept;
		g_clicked = clicked;
		DrawStatusPanel(*selected, statusTakesInput);
	}
	DrawFrame();
	if (g_wardrobeOpen && g_wardEnlarged && DrawZoom(nullptr, true, false, stickX, stickY, wheel, true))
		g_wardEnlarged = false;
	if (g_statusOpen && g_cardZoom)
	{
		if (selected && CanEnlarge(*selected))
			DrawCardZoom(*selected, stickX, stickY, wheel);
		else
			g_statusOpen = g_cardZoom = false;
	}
	if (g_tour != -2)
		DrawTour();
	if (g_tourAsked)
	{
		g_tourAsked = false;
		if (g_tour == -2)
			StartTour();
	}
	DrawCursor();

	dl->PopClipRect();
	for (int i = firstVertex; i < dl->VtxBuffer.Size; ++i)
	{
		ImDrawVert& v = dl->VtxBuffer[i];
		v.pos.x = ox + v.pos.x * k;
		v.pos.y = oy + v.pos.y * k;
		if (ease < 1.f)
			v.col = Alpha(v.col, ease);
	}
	for (int i = std::max(0, firstCommand); i < dl->CmdBuffer.Size; ++i)
	{
		ImDrawCmd& c = dl->CmdBuffer[i];
		c.ClipRect.x = std::max(0.f, ox + c.ClipRect.x * k);
		c.ClipRect.y = std::max(0.f, oy + c.ClipRect.y * k);
		c.ClipRect.z = std::min(io.DisplaySize.x, ox + c.ClipRect.z * k);
		c.ClipRect.w = std::min(io.DisplaySize.y, oy + c.ClipRect.w * k);
	}
}

#ifdef POTP_OVERLAY_TEST
void UiTestModel(const char* path)
{
	g_modelTest = path;
}
#endif

#ifdef POTP_OVERLAY_TEST
void UiTestCardTurn(float degrees)
{
	g_cardTestTurn = degrees;
}
#endif
