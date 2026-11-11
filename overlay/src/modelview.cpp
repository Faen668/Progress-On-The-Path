#include "modelview.h"
#include <windows.h>
#include <psapi.h>
#include <d3d12.h>
#include <d3dcompiler.h>
#include <algorithm>
#include <iterator>
#include <list>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstring>
#include <map>
#include <memory>
#include <mutex>
#include <set>
#include <thread>
#include <vector>
#include "gameicons.h"
#include <exception>
#include "book.h"
#include "itemmodel.h"
#include "log.h"
#include "overlay.h"
#include "settings.h"

namespace
{
	// The screen's shape, so the enlarged view can fill the screen; the panel and the wardrobe show the square from its
	// middle, which is what the model is framed to
	constexpr UINT kHeight = 1408, kWidth = 2504;
	constexpr DXGI_FORMAT kColour = DXGI_FORMAT_R8G8B8A8_UNORM, kDepth = DXGI_FORMAT_D32_FLOAT;
	constexpr UINT kSamples = 4;

	// Lit from the viewer's side, so the item turns under the light. The material as the game's pbr_std has it:
	// roughness in the normal map's alpha, the normal's z worked out. (Workbench: Rendering/Shaders/psW3Mesh.hlsl)
	const char kShader[] = R"(
cbuffer View : register(b0)
{
	row_major float4x4 world;
	float4 projection;   // x, y scale; z, w depth
	float4 eyeAndMask;   // y: how far a two-form creature has turned into its second, z: how far back the eye is, w: alpha tested
	float4 pose;         // where this frame and the next start in the bones' table, and how far between them
	float4 fromPose;     // the same in the stance it's fading from; w: how far it's come, 1 is all the new one
	float4 sheet;        // the Library's book (book.cpp): x how far the leaf has turned, 0-1, below 0 none; y, z the right and left
	float4 sheet2;       // blocks' thickness as parts of the made one; w the page's width. sheet2: cos, sin of its tilt, the
	                     // left block made over the right, where the pages start from the spine
	float4 shut;         // the book shutting: x how far, 0 open to 1 shut; y how far it moves over as it shuts, to stay in
	                     // the middle; z the spine's length now; w how far its pages have flattened
};
struct BoneRows { float4 x, y, z; };
StructuredBuffer<BoneRows> boneTable : register(t6);
StructuredBuffer<BoneRows> fromTable : register(t7);
StructuredBuffer<float4> clothParticles : register(t8);   // each particle's place, then its normal
cbuffer Material : register(b1)
{
	float4 spec;         // scale, base, roughness at least, roughness at most
	float4 specColour;   // linear; w: how much of the tint mask's ambient occlusion
	float4 variance;     // the colour it's drawn toward, and how far
	float4 flags;        // x has a tint mask, y has a specular map, z skin, w colour shifted
	float4 red0, red1, red2, blue0, blue1, blue2;   // the colour shifts' matrices, as rows
	float4 detail;       // first tile x, y; power; albedo power
	float4 detail2;      // second tile x, y; mode: 1 one map by the mask's blue, 2 two maps, 3 one map everywhere
	float4 options;      // x KeepGray, y BlendColors, z darkened by the vertex colour (the hair graphs), w its specular map scaled
	float4 ghost;        // w: a spectre, 1 a barghest, 2 Hym, as their own materials draw them
	float4 forms;        // x: one form of a two-form creature, y: which, 0 the first, 1 the second
};
Texture2D diffuseMap : register(t0);
Texture2D normalMap : register(t1);
Texture2D tintMap : register(t2);
Texture2D specularMap : register(t3);
Texture2D detail1Map : register(t4);
Texture2D detail2Map : register(t5);
SamplerState surface : register(s0);

struct In { float3 p : POSITION; float3 n : NORMAL; float4 t : TANGENT; float2 uv : TEXCOORD; float4 colour : COLOR; uint4 bones : BLENDINDICES; float4 weights : BLENDWEIGHT; uint3 clothAt : CLOTHINDEX; float3 clothBary : CLOTHBARY; float3 shutP : SHUTPLACE; float3 shutN : SHUTNORMAL; float3 shutT : SHUTTANGENT; float fold : SHUTFOLD; };
struct Out { float4 h : SV_Position; float3 p : POSITION; float3 n : NORMAL; float3 t : TANGENT; float3 b : BINORMAL; float2 uv : TEXCOORD0; float4 colour : COLOR; float3 bound : TEXCOORD1; };

// The Library's book: its page blocks thinned or thickened to say how far through it is, and the leaf being turned, a sheet
// bent round the spine with its outer edge lagging, so it curls. Made tilted, as everything of the book is: untilted to
// work on (flat, the spine along y, the pages up), then tilted back. Role: 1 the left block, 2 the right, 3 the leaf's front,
// 4 its back. Below 0 the leaf isn't there, and folds away to nothing.
// Shutting (shut.x above 0), as a book's case does (book.mesh's PBK3, export_book.py): the back half stays; the spine
// bends up from its joint with the back board, an arc turning from flat to half round as it lengthens to the half
// round's length; the front half rides on its end, turned as far. The halves' pages flatten onto their boards as it goes.
static const float kJointX = 0.030f, kBoardT = 0.0055f;   // the back board's joint, on its outside (build_book.py)
static const float kMidZ = 0.026f;                         // half the pages' height, shut: the spine's middle
static const float kBackIn = 0.0055f, kBackR = 0.026f;     // the pages' backs: in from the spine's outside (its shell and a
                                                           // hair), and their round about its middle, shut (export_book.py)

// A direction turned th over toward the back half, as the front half goes: (-1, 0) up through (0, 1) to (1, 0)
float3 Turned(float3 v, float th)
{
	const float c = cos(th), s = sin(th);
	return float3(v.x * c + v.z * s, v.y, -v.x * s + v.z * c);
}

// The spine's outside, a distance along it from the back board's joint, as it is with the book that far shut: an arc of
// that length turning th in all. phi: how far it's turned there.
float3 SpineAt(float along, float total, float th, out float phi)
{
	phi = th * along / max(total, 1e-5f);
	float x, z;
	if (th < 1e-3f)
	{
		x = -along;
		z = 0.5f * along * phi;
	}
	else
	{
		const float r = total / th, h = sin(phi * 0.5f);
		x = -r * sin(phi);
		z = 2.0f * r * h * h;
	}
	return float3(kJointX + x, 0, -kBoardT + z);
}

// The journal folding shut (book.h's JournalFold, which this is the same as; build_journal.py makes it open and flat):
// a point on leather that bends twice, so far along it from where the first bend begins, so far in from its outside, the
// two bends turning th between them with flat of that length between. Along it and up from it; a: how far it's turned.
static const float kJXS = 0.0105124f, kJWO = 0.1278124f, kJBend = 0.0047124f, kJSpineFlat = 0.0116f, kJFlapFlat = 0.0134f;
// The thong's way round the journal shut (build_journal.py's THONG_...): the spine's wall, the fore-edge's, the top, where
// its end is tucked, and its thickness
static const float kJThongWall = 0.0075124f, kJThongFore = 0.1308124f, kJThongTop = 0.0194f, kJThongX0 = 0.0758124f, kJThongT = 0.0011f;
static const float kJThongY = -0.00425f;   // the first turn's middle, up the journal
static const float kJBendR = 0.003f, kJThick = 0.0176f, kJRest = 0.002f;   // a bend's radius, the journal shut cover to cover, what the pages rest on

float2 BendTwice(float d, float inward, float th, float flat, bool rigid, out float a)
{
	const float h = th * 0.5f, b = kJBend;
	const bool straight = h < 1e-4f;
	const float r = straight ? 0.0f : b / h;
	const float2 e1 = straight ? float2(b, 0.5f * b * h) : r * float2(sin(h), 1.0f - cos(h));
	const float2 e2 = e1 + float2(cos(h), sin(h)) * flat;
	const float2 e3 = straight ? e2 + float2(b, 0) : e2 + r * float2(sin(th) - sin(h), cos(h) - cos(th));
	float2 at;
	if (rigid || d >= 2.0f * b + flat)
	{
		a = th;
		at = e3 + float2(cos(th), sin(th)) * (d - 2.0f * b - flat);
	}
	else if (d <= 0)
	{
		a = 0;
		at = float2(d, 0);
	}
	else if (d < b)
	{
		a = h * d / b;
		at = straight ? float2(d, 0.5f * d * a) : r * float2(sin(a), 1.0f - cos(a));
	}
	else if (d < b + flat)
	{
		a = h;
		at = e1 + float2(cos(h), sin(h)) * (d - b);
	}
	else
	{
		a = h + h * (d - b - flat) / b;
		at = straight ? e2 + float2(d - b - flat, 0) : e2 + r * float2(sin(a) - sin(h), cos(h) - cos(a));
	}
	return at + float2(-sin(a), cos(a)) * inward;
}

)" R"(
// The thong's way round the journal shut, from where it's tucked: across the front to the spine's wall, down it, along
// the underside, up the fore-edge, and across the front again. The journal's surface so far round, and which way is out.
float2 ThongOn(float d, out float2 outward)
{
	const float across = kJThongX0 - kJThongWall, up = kJThongTop, width = kJThongFore - kJThongWall;
	if (d < across)
	{
		outward = float2(0, 1);
		return float2(kJThongX0 - d, up);
	}
	if (d < across + up)
	{
		outward = float2(-1, 0);
		return float2(kJThongWall, up - (d - across));
	}
	if (d < across + up + width)
	{
		outward = float2(0, -1);
		return float2(kJThongWall + (d - across - up), 0);
	}
	if (d < across + 2.0f * up + width)
	{
		outward = float2(1, 0);
		return float2(kJThongFore, d - across - up - width);
	}
	outward = float2(0, 1);
	return float2(kJThongFore - (d - across - 2.0f * up - width), up);
}

// A journal's vertex, the journal shut.x shut: the front cover over on the spine first, the flap round the fore-edge
// after, the pages flattening onto their covers. piece: export_journal.py's (1 round the spine, 2 the right pages, 3 the
// left, 4 the flap, 6 the thong, 7 only there shut).
void JournalPart(uint piece, float3 sp, inout float3 p, inout float3 n, inout float3 t)
{
	const float pi = 3.14159265f;
	const float spine = pi * smoothstep(0.0f, 0.55f, shut.x), flap = pi * smoothstep(0.38f, 0.82f, shut.x), flat = smoothstep(0.0f, 0.5f, shut.x);
	float a = 0;
	if (piece == 6)
	{
		// The thong, made where it lies wound twice round the journal shut: wound on last, from where it's tucked. What
		// isn't wound on yet (sp.x, how far along the winding a vertex is, past how far it's got) is drawn back to where
		// the winding has got to, as far out from the journal as it was: so the strap ends square there, at its own
		// width and thickness, and what's wholly to come is nothing at all. Its tuck (sp.x of 1) is there once it's wound.
		const float wound = smoothstep(0.8f, 1.0f, shut.x);
		const float round = 2.0f * ((kJThongFore - kJThongWall) + kJThongTop);
		if (sp.x >= 0.999f)
		{
			if (wound < 0.9999f)
				p = 0;
		}
		else if (sp.x > wound * 0.97f)
		{
			float2 outward, toward;
			const float2 was = ThongOn(fmod(sp.x / 0.97f * 2.0f * round, round), outward);
			float proud = dot(p.xz - was, outward);
			// The second turn, while the first is still going on: nothing at all, not even its end's face beside the first's
			if (sp.x > 0.486f && wound < 0.5f)
			{
				proud = 0;
				p.y = kJThongY;
			}
			const float2 now = ThongOn(fmod(wound * 2.0f * round, round), toward);
			p.x = now.x + toward.x * proud;
			p.z = now.y + toward.y * proud;
		}
	}
	else if (piece == 7)
	{
		// What lies between the pages (the marker, the slip): there once the cover's nearly down on them
		if (shut.x < 0.45f)
			p = 0;
	}
	else if (piece == 1)
	{
		if (kJXS - p.x > 0)
		{
			const float2 at = BendTwice(kJXS - p.x, p.z, spine, kJSpineFlat, false, a);
			p = float3(kJXS - at.x, p.y, at.y);
			n = Turned(n, a);
			t = Turned(t, a);
		}
	}
	else if (piece == 2 || piece == 3)
	{
		// The pages. Each half's flatten onto its cover and go with it: the right stay, the left are carried over. But
		// their backs are sewn into the spine, both halves' along its flat: near its back a page goes with the spine as
		// it bends, so the halves never part down the gutter. How high a page lies in the journal shut says where up the
		// spine's flat its back is sewn; out from there it runs its own half's way.
		const float fromBack = abs(p.x), open = p.z;
		const float lies = piece == 2 ? sp.z : kJThick - sp.z;
		float2 own;
		float2 way;
		if (piece == 2)
		{
			own = float2(lerp(p.x, sp.x, flat), lerp(p.z, sp.z, flat));
			way = float2(1, 0);
		}
		else
		{
			const float2 q = lerp(float2(-kJXS - p.x, p.z), sp.xz, flat);
			const float2 at = BendTwice(2.0f * kJBend + kJSpineFlat + q.x, q.y, spine, kJSpineFlat, true, a);
			own = float2(kJXS - at.x, at.y);
			way = float2(-cos(spine), sin(spine));
			n = Turned(n, a);
			t = Turned(t, a);
		}
		float sewnTurn;
		const float2 on = BendTwice(kJBend + clamp(lies - kJBendR, 0.0f, kJSpineFlat), lerp(open, kJRest, flat), spine, kJSpineFlat, false, sewnTurn);
		const float2 sewn = float2(kJXS - on.x, on.y) + way * fromBack;
		const float w = smoothstep(0.035f, 0.0f, fromBack) * smoothstep(0.0f, 0.15f, shut.x);
		p.x = lerp(own.x, sewn.x, w);
		p.z = lerp(own.y, sewn.y, w);
	}
	else if (piece == 4)
	{
		if (p.x - kJWO > 0)
		{
			const float2 at = BendTwice(p.x - kJWO, p.z, flap, kJFlapFlat, false, a);
			p = float3(kJWO + at.x, p.y, at.y);
			n = Turned(n, -a);
			t = Turned(t, -a);
		}
	}
}

)" R"(
void BookPart(uint role, float base, float3 sp, float3 sn, float3 st, float fold, inout float3 p, inout float3 n, inout float3 t)
{
	const float c = sheet2.x, s = sheet2.y;
	p = float3(p.x, p.y * c + p.z * s, -p.y * s + p.z * c);
	n = float3(n.x, n.y * c + n.z * s, -n.y * s + n.z * c);
	t = float3(t.x, t.y * c + t.z * s, -t.y * s + t.z * c);
	// A height is from the stack's own underside under it (base: down in the binding, arched off the board beside it,
	// on the board towards the fore-edge). Only what's above that grows or shrinks, and less so near the spine, where the
	// two sides meet in a V that has to stay where it is.
	const float board = base, above = p.z - base, toV = smoothstep(0.0f, 0.035f, abs(p.x));
	const float leftBy = lerp(1, sheet.z, toV), rightBy = lerp(1, sheet.y, toV);
	if (role == 1)
		p.z = base + (above > 0 ? above * leftBy : above);
	else if (role == 2)
		p.z = base + (above > 0 ? above * rightBy : above);
	else if (role != 3 && role != 4)
	{
	}
	else if (sheet.x < 0 || shut.x > 0)
		p = 0;
	else
	{
		const float pi = 3.14159265f, lag = 0.35f;
		const float r = p.x;
		const float a = saturate(sheet.x * (1 + lag) - lag * saturate((r - sheet2.w) / sheet.w));
		const float th = a * pi;
		// From the right block's top to the left's, a hair above either, as it goes over
		const float h = board + (above > 0 ? lerp(above * rightBy, above * sheet2.z * leftBy, a) : above) + 0.0006f;
		const float thr = a > 0 && a < 1 ? -pi * lag / sheet.w : 0;
		const float3 along = normalize(float3(cos(th) - r * sin(th) * thr, 0, sin(th) + r * cos(th) * thr));
		p = float3(r * cos(th), p.y, h + r * sin(th));
		n = float3(-along.z, 0, along.x);
		t = along;
		if (role == 4)
		{
			n = -n;
			t = -t;
		}
		p += n * 0.0003f;
	}
	// A journal (a spine length below 0) folds its own way; what's only there while it's shut (role 6) is hidden till then
	if (shut.z < 0 && role != 3 && role != 4)
	{
		if (shut.x > 0 || role == 6)
			JournalPart((uint)round(fold), sp, p, n, t);
	}
	else if (shut.x > 0 && role != 3 && role != 4)
	{
		const float th = shut.x * 3.14159265f, spineLength = shut.z, m = shut.w;
		const uint piece = (uint)round(fold);
		if (piece == 2)
		{
			// Bent with the spine: so far along it, so far out from its outside, its open sag let go as it rounds
			float phi;
			const float3 on = SpineAt(sp.x * spineLength, spineLength, th, phi);
			const float outward = sp.y - sp.z * m;
			p = float3(on.x, p.y, on.z) + Turned(float3(0, 0, -1), phi) * outward;
			n = Turned(n, phi);
			t = Turned(t, phi);
		}
		else
		{
			// A half: its pages flattening onto its board, as thick as they are now
			float3 q = sp;
			if (role == 1)
				q.z *= sheet.z;
			else if (role == 2)
				q.z *= sheet.y;
			p = lerp(p, q, m);
			const float3 nm = lerp(n, sn, m), tm = lerp(t, st, m);
			n = dot(nm, nm) > 1e-8f ? normalize(nm) : sn;
			t = dot(tm, tm) > 1e-8f ? normalize(tm) : st;
			if (piece == 1)
			{
				// The front half on the spine's end, turned as far as it has
				float phi;
				const float3 end = SpineAt(spineLength, spineLength, th, phi);
				const float3 from = Turned(float3(p.x + kJointX, 0, p.z + kBoardT), th);
				p = float3(end.x + from.x, p.y, end.z + from.z);
				n = Turned(n, th);
				t = Turned(t, th);
			}
			if (role == 1 || role == 2)
			{
				// The pages' backs are glued into the spine, both halves' along the one round (kBackR about the spine's
				// middle shut, export_book.py's BACK_R): near its back, a page goes round with the spine as it bends, so
				// the halves' backs never part, and the gutter dips into the spine as a real book's does. How high up the
				// shut book a page lies says where along the spine its back is glued; out from there, its own half's way.
				const float zs = role == 2 ? q.z : 2.0f * kMidZ - q.z;
				const float glue = acos(clamp((kMidZ - zs) / kBackR, -1.0f, 1.0f));   // round the spine, shut
				const float fromBack = max(0.0f, abs(q.x) - (kJointX - kBackR * sin(glue)));
				float phi;
				const float3 on = SpineAt(glue / 3.14159265f * spineLength, spineLength, th, phi);
				const float3 inward = -Turned(float3(0, 0, -1), phi);
				const float3 way = role == 2 ? float3(1, 0, 0) : Turned(float3(-1, 0, 0), th);
				const float3 glued = float3(on.x, 0, on.z) + inward * kBackIn + way * fromBack;
				const float w = smoothstep(0.05f, 0.0f, fromBack) * smoothstep(0.0f, 0.45f, shut.x);
				p.x = lerp(p.x, glued.x, w);
				p.z = lerp(p.z, glued.z, w);
			}
		}
		p.x -= shut.y * shut.x;
	}
	p = float3(p.x, p.y * c - p.z * s, p.y * s + p.z * c);
	n = float3(n.x, n.y * c - n.z * s, n.y * s + n.z * c);
	t = float3(t.x, t.y * c - t.z * s, t.y * s + t.z * c);
}

)" R"(
Out VS(In i)
{
	Out o;
	const uint role = (uint)round(i.colour.a * 255);
	if (sheet.w > 0 && ((role >= 1 && role <= 6) || shut.x > 0))
	{
		float3 bookTangent = i.t.xyz;
		BookPart(role, i.colour.r * 0.03f, i.shutP, i.shutN, i.shutT, i.fold, i.p, i.n, bookTangent);
		i.t.xyz = bookTangent;
	}
	// The bones' rows at this moment, blended by the vertex's weights
	float4 rx = 0, ry = 0, rz = 0;
	for (uint k = 0; k < 4; ++k)
	{
		if (i.weights[k] <= 0)
			continue;
		const BoneRows a = boneTable[(uint)pose.x + i.bones[k]], b = boneTable[(uint)pose.y + i.bones[k]];
		float4 nx = lerp(a.x, b.x, pose.z), ny = lerp(a.y, b.y, pose.z), nz = lerp(a.z, b.z, pose.z);
		if (fromPose.w < 1)
		{
			const BoneRows c = fromTable[(uint)fromPose.x + i.bones[k]], d = fromTable[(uint)fromPose.y + i.bones[k]];
			nx = lerp(lerp(c.x, d.x, fromPose.z), nx, fromPose.w);
			ny = lerp(lerp(c.y, d.y, fromPose.z), ny, fromPose.w);
			nz = lerp(lerp(c.z, d.z, fromPose.z), nz, fromPose.w);
		}
		rx += nx * i.weights[k];
		ry += ny * i.weights[k];
		rz += nz * i.weights[k];
	}
	const float4 at = float4(i.p, 1);
	float3 placed = float3(dot(rx, at), dot(ry, at), dot(rz, at));
	float3 normal = normalize(float3(dot(rx.xyz, i.n), dot(ry.xyz, i.n), dot(rz.xyz, i.n)));
	const float3 tangent = normalize(float3(dot(rx.xyz, i.t.xyz), dot(ry.xyz, i.t.xyz), dot(rz.xyz, i.t.xyz)));
	// Cloth goes where the simulation has put the particles that carry it: on their triangle, so far along their normal
	if (eyeAndMask.x > 0 && i.clothAt.x != 0xFFFFFFFF)
	{
		const float third = 1 - i.clothBary.x - i.clothBary.y;
		const float3 onTriangle = clothParticles[i.clothAt.x * 2].xyz * i.clothBary.x + clothParticles[i.clothAt.y * 2].xyz * i.clothBary.y + clothParticles[i.clothAt.z * 2].xyz * third;
		const float3 clothNormal = clothParticles[i.clothAt.x * 2 + 1].xyz * i.clothBary.x + clothParticles[i.clothAt.y * 2 + 1].xyz * i.clothBary.y + clothParticles[i.clothAt.z * 2 + 1].xyz * third;
		placed = onTriangle + clothNormal * i.clothBary.z;
		if (dot(clothNormal, clothNormal) > 1e-6)
			normal = normalize(clothNormal);
	}
	o.p = mul(float4(placed, 1), world).xyz;
	o.n = mul(float4(normal, 0), world).xyz;
	o.t = mul(float4(tangent, 0), world).xyz;
	o.b = cross(o.n, o.t) * i.t.w;
	const float z = o.p.z + eyeAndMask.z;
	o.h = float4(o.p.x * projection.x, o.p.y * projection.y, z * projection.z + projection.w, z);
	o.uv = i.uv;
	o.colour = i.colour;
	o.bound = i.p;   // where it was bound: the dissolve's noise stays on the body as it moves
	return o;
}

float3 ToLinear(float3 c) { return pow(max(c, 0), 2.2f); }

// The graphs' customColoring
float3 CustomColoring(float3 albedo)
{
	const float a = (albedo.x + albedo.y + albedo.z) * 0.3333f;
	const float inverseOffset = 0.5f * (variance.w - 1.0f);
	const float blend = lerp(a, 1.0f - a, saturate(inverseOffset));
	return lerp(albedo, saturate(1.5f * albedo * variance.rgb), saturate(blend * abs(inverseOffset)));
}

float3 ThroughRows(float3 c, float4 r0, float4 r1, float4 r2) { return c.x * r0.xyz + c.y * r1.xyz + c.z * r2.xyz; }

// The ShiftColorRB block, on a colour as it's stored: how red and how blue it is picks the matrix, the tint mask's green says how far
float3 ShiftColour(float3 c, float mask)
{
	float3 shifted;
	if (options.y > 0)
	{
		const float sum = c.x + c.z;
		const float redShare = sum > 0 ? saturate((c.x / sum - 0.3f) / 0.7f) : 0;
		const float blueShare = sum > 0 ? saturate((c.z / sum - 0.3f) / 0.7f) : 0;
		const float toBlue = redShare + blueShare > 0 ? blueShare / (redShare + blueShare) : 0;
		shifted = lerp(ThroughRows(c, red0, red1, red2), ThroughRows(c, blue0, blue1, blue2), toBlue);
	}
	else
		shifted = c.x >= c.z ? ThroughRows(c, red0, red1, red2) : ThroughRows(c, blue0, blue1, blue2);
	float amount = mask;
	if (options.x > 0)
	{
		const float most = max(c.x, max(c.y, c.z)), least = min(c.x, min(c.y, c.z));
		const float saturation = most > 0 ? (most - least) / most : 0;
		amount *= saturate((saturation - 0.1f) / 0.2f);
	}
	return saturate(lerp(c, shifted, amount));
}

// A detail map's normal: x and y as stored, z worked out, as some keep only x and y
float3 UnpackDetail(float4 c)
{
	const float2 xy = c.xy * 2 - 1;
	return float3(xy, sqrt(saturate(1 - dot(xy, xy))));
}

// The graphs' detail blend: the detail normal laid on the surface's, as much as amount says
float3 BlendDetail(float3 first, float3 d, float amount)
{
	float3 r;
	r.x = first.x * d.z + amount * d.x * first.z;
	r.y = first.y * d.z + amount * d.y * first.z;
	r.z = first.z * d.z;
	return normalize(r);
}

float D(float nh, float a) { const float d = nh * nh * (a * a - 1) + 1; return a * a / (3.14159f * d * d); }
float V(float nv, float nl, float a) { const float k = a * 0.5f; return 1 / max((nv * (1 - k) + k) * (nl * (1 - k) + k), 0.0001f); }

float3 Light(float3 N, float3 Vw, float3 L, float3 colour, float3 albedo, float3 f0, float a)
{
	const float nl = saturate(dot(N, L));
	const float3 H = normalize(L + Vw);
	const float nv = saturate(abs(dot(N, Vw)) + 0.0001f), nh = saturate(dot(N, H)), vh = saturate(dot(Vw, H));
	const float3 F = f0 + (1 - f0) * pow(1 - vh, 5);
	return (albedo * nl + D(nh, a) * V(nv, nl, a) * F * 0.25f * nl) * colour;
}

// How much of the surroundings' reflection comes back at an angle (Karis's fit)
float3 EnvironmentBrdf(float3 f0, float rough, float nv)
{
	const float4 r = rough * float4(-1, -0.0275f, -0.572f, 0.022f) + float4(1, 0.0425f, 1.04f, -0.04f);
	const float a004 = min(r.x * r.x, exp2(-9.28f * nv)) * r.x + r.y;
	const float2 ab = float2(-1.04f, 1.04f) * a004 + r.zw;
	return f0 * ab.x + ab.y;
}

// Smooth noise in space, for the dissolve: a hash at each corner of a cell, blended between them
float Hash3(float3 c) { return frac(sin(dot(c, float3(127.1f, 311.7f, 74.7f))) * 43758.5453f); }
float Noise3(float3 x)
{
	const float3 c = floor(x), f = frac(x), u = f * f * (3 - 2 * f);
	const float a = lerp(lerp(Hash3(c), Hash3(c + float3(1, 0, 0)), u.x), lerp(Hash3(c + float3(0, 1, 0)), Hash3(c + float3(1, 1, 0)), u.x), u.y);
	const float b = lerp(lerp(Hash3(c + float3(0, 0, 1)), Hash3(c + float3(1, 0, 1)), u.x), lerp(Hash3(c + float3(0, 1, 1)), Hash3(c + float3(1, 1, 1)), u.x), u.y);
	return lerp(a, b, u.z);
}

float4 PS(Out i, bool front : SV_IsFrontFace) : SV_Target
{
	const float4 d = diffuseMap.Sample(surface, i.uv);
	if (eyeAndMask.w > 0 && d.a < eyeAndMask.w)
		discard;
	// A two-form creature: each form burns away in patches as the other comes, the edges between glowing like embers
	float ember = 0;
	if (forms.x > 0)
	{
		const float shown = forms.y > 0.5f ? eyeAndMask.y : 1 - eyeAndMask.y;
		const float n = Noise3(i.bound * 5.5f) * 0.65f + Noise3(i.bound * 17) * 0.35f;
		if (shown < 0.001f || n > shown * 1.02f)
			discard;
		if (shown < 0.999f)
			ember = saturate(1 - (shown * 1.02f - n) / 0.07f);
	}
	const float4 tint = flags.x > 0 ? tintMap.Sample(surface, i.uv) : float4(1, 0, 0, 1);
	const float4 nm = normalMap.Sample(surface, i.uv);
	const float2 xy = nm.xy * 2 - 1;
	float3 local = float3(xy, sqrt(saturate(1 - dot(xy, xy))));

	// The detail maps, close up as this always is
	float detailRough = 0, detailWeight = 0;
	if (detail2.z > 2.5f || (detail2.z > 0.5f && detail2.z < 1.5f))
	{
		const float4 d1 = detail1Map.Sample(surface, i.uv * detail.xy);
		detailWeight = detail2.z < 1.5f ? saturate((tint.b - 0.55f) / 0.45f) : 1;
		local = BlendDetail(local, UnpackDetail(d1), detail.z * detailWeight);
		detailRough = 0.5f * (d1.a - 0.5f);
	}
	else if (detail2.z > 1.5f)
	{
		const float4 d1 = detail1Map.Sample(surface, i.uv * detail.xy);
		const float4 d2 = detail2Map.Sample(surface, i.uv * detail2.xy);
		const float4 chosen = tint.b > 0.5f ? d1 : d2;
		detailWeight = saturate((abs(tint.b - 0.5f) - 0.05f) / 0.45f);
		local = BlendDetail(local, UnpackDetail(chosen), detail.z * detailWeight);
		detailRough = 0.5f * (chosen.a - 0.5f);
	}

	float3 N = normalize(normalize(i.t) * local.x + normalize(i.b) * local.y + normalize(i.n) * local.z);
	const float3 Vw = normalize(float3(0, 0, -eyeAndMask.z) - i.p);
	if (dot(N, Vw) < -0.2f && !front)
		N = -N;

	// pbr_std: roughness from the normal map's alpha into its range, specularity from that, the tint mask's red occlusion
	float rough = saturate(nm.a + detailRough * detail.z * (detailWeight > 0 ? 1 : 0));
	rough = saturate(lerp(spec.z, spec.w, rough));
	// The specular map as it is, or as the tint-masked graphs take it: times RSpecScale, plus RSpecBase
	const float3 sm = specularMap.Sample(surface, i.uv).rgb;
	float3 f0 = flags.y > 0 ? ToLinear(options.w > 0 ? saturate(sm * spec.x + spec.y) : sm) : saturate(specColour.rgb * ((1 - rough) * spec.x + spec.y));
	float ao = flags.x > 0 ? lerp(1, tint.r, saturate(specColour.w)) : 1;
	if (flags.z > 0)
	{
		rough = 0.55f;
		f0 = 0.03f;
		ao = 1;
	}
	rough = clamp(rough, 0.03f, 1);
	const float3 stored = flags.w > 0 ? ShiftColour(d.rgb, tint.g) : d.rgb;
	float3 coloured = CustomColoring(stored);
	if (options.z > 0)
		coloured *= i.colour.rgb;
	if (detail.w > 0 && detailWeight > 0)
		coloured *= max(0, 1 - detailRough * detailWeight * detail.w);
	const float3 albedo = ToLinear(coloured * ao);
	const float a = rough * rough;

	float3 c = 0;
	c += Light(N, Vw, normalize(float3(-0.55f, 0.65f, -0.6f)), float3(1.15f, 1.05f, 0.92f), albedo, f0, a);
	c += Light(N, Vw, normalize(float3(0.7f, 0.1f, -0.45f)), float3(0.26f, 0.3f, 0.36f), albedo, f0, a);
	c += Light(N, Vw, normalize(float3(0.1f, 0.5f, 0.85f)), float3(0.6f, 0.56f, 0.5f), albedo, f0, a);

	// Light all round and reflections, from a plain sky
	const float3 sky = float3(0.32f, 0.33f, 0.36f);
	const float3 around = lerp(sky * 0.45f, sky, saturate(N.y * 0.5f + 0.5f));
	const float nv = saturate(abs(dot(N, Vw)) + 0.0001f);
	c += albedo * around * ao;
	c += around * EnvironmentBrdf(f0, rough, nv) * ao;

	// A spectre, by the game's own materials for it. 1: a barghest's barghest_pbr_skin, its skin darkened under a green glow
	// (111, 189, 26) and a yellow-green rim at its edges (182, 164, 52). 2: Hym's ghost_prolog, all but black, seen
	// through: its opacity is the graph's (1 - fresnel) * fresnel band, so the middle and the very edge are thinnest.
	float alpha = 1;
	const float fresnel = pow(1 - nv, 2.2f);
	if (ghost.w > 1.5f)
	{
		const float lum = dot(c, float3(0.2126f, 0.7152f, 0.0722f));
		c = 0.02f + lum * 0.08f + pow(1 - nv, 3) * 0.14f;   // its edges catch a little light, like smoke
		alpha = saturate(0.82f + (1 - fresnel) * fresnel * 0.7f);
	}
	else if (ghost.w > 0.5f)
	{
		const float edge = pow(1 - nv, 7);
		const float lum = dot(c, float3(0.2126f, 0.7152f, 0.0722f));
		c = lerp(c, lum * float3(0.3f, 0.7f, 0.35f), 0.75f) * 0.35f + float3(0.16f, 0.52f, 0.006f) * 0.06f + lerp(float3(0.16f, 0.52f, 0.006f), float3(0.47f, 0.37f, 0.035f), 0.4f) * edge * 0.8f;
		alpha = lerp(0.8f, 1, edge);
	}

	// Tone mapped and graded as the Workbench's viewer has it
	c *= 1.15f;
	c = saturate((c * (2.51f * c + 0.03f)) / (c * (2.43f * c + 0.59f) + 0.14f));
	const float grey = dot(c, float3(0.2126f, 0.7152f, 0.0722f));
	c = lerp(grey.xxx, c, 0.92f);
	c = saturate((c - 0.18f) * 1.05f + 0.18f);
	c = lerp(c, float3(1.0f, 0.62f, 0.25f), ember * 0.9f);
	return float4(pow(c, 1 / 2.2f), alpha);
}
)";

	struct Constants { float world[16]; float projection[4]; float eyeAndMask[4]; float pose[4]; float fromPose[4]; float sheet[4]; float sheet2[4]; float shut[4]; };
	// The Library's book, as the window last set it (ModelViewBook)
	std::mutex g_bookLock;
	float g_bookSheet[4] = { -1.f, 1.f, 1.f, 0.235f }, g_bookSheet2[4] = { 1.f, 0.f, 1.f, 0.f }, g_bookShut[4] = {};
	// Pictures to put in place of those a part was loaded with, by the name it was loaded with
	std::vector<std::pair<std::string, std::shared_ptr<PreparedTexture>>> g_replacements;

	// A burst of thick smoke at a two-form creature's feet as it changes, as the game hides its swap behind one: soft puffs
	// that billow out and up and thin away, each worked out here from its number alone
	const char kSmokeShader[] = R"(
cbuffer View : register(b0)
{
	row_major float4x4 world;
	float4 projection;
	float4 eyeAndMask;   // z: how far back the eye is
	float4 pose;         // x: seconds since the burst began, y: how big it is, in metres, z: how many puffs there are
	float4 fromPose;     // xyz: where its feet are, as the model has it
};

struct Out
{
	float4 h : SV_Position;
	float2 uv : TEXCOORD0;
	float alpha : TEXCOORD1;
	float seed : TEXCOORD2;
	float age : TEXCOORD3;     // how far through its life the puff is
	float dense : TEXCOORD4;   // 1 the thick ring along the ground, 0 the column rising from it
};

float Hash(float n) { return frac(sin(n * 12.9898f) * 43758.5453f); }

Out VS(uint vertex : SV_VertexID, uint puff : SV_InstanceID)
{
	Out o;
	const float n = puff + 1;
	const float size = pose.y;
	// One cloud: each puff thrown from the feet in its own direction over the ground and up, all at once, slowing as the
	// cloud swells. Low ones go wide, high ones less so, so it mushrooms rather than making a ring and a column apart.
	const float angle = Hash(n) * 6.2831853f;
	const float rise = pow(Hash(n + 17.1f), 1.6f);          // most stay low; a few climb high
	const float delay = Hash(n + 3.7f) * 0.25f + rise * 0.2f;
	const float life = 2.3f + Hash(n + 9.3f) * 1.0f;
	const float u = (pose.x - delay) / life;
	const float2 corners[6] = { float2(-1, -1), float2(1, -1), float2(1, 1), float2(-1, -1), float2(1, 1), float2(-1, 1) };
	const float2 corner = corners[vertex];
	o.uv = corner;
	o.seed = Hash(n + 31.3f);
	o.age = saturate(u);
	o.dense = 1 - rise;   // the lower, the denser and darker
	if (u <= 0 || u >= 1)
	{
		o.h = float4(0, 0, -1, 1);
		o.alpha = 0;
		return o;
	}
	const float burst = 1 - pow(1 - saturate(u * 1.15f), 3);   // fast, then slowing
	const float wide = (0.25f + 0.75f * sqrt(Hash(n + 41.7f))) * lerp(1.0f, 0.45f, rise);
	const float spread = size * (0.06f + 0.9f * wide * burst);
	const float height = size * (0.04f + rise * (0.25f + 1.0f * burst) + 0.25f * u * u);
	const float3 at = fromPose.xyz + float3(cos(angle) * spread, sin(angle) * spread, height);
	const float3 view = mul(float4(at, 1), world).xyz;
	// Big, overlapping puffs, so the cloud reads as one mass and no gaps show between them
	const float radius = size * (0.18f + 0.3f * burst) * (0.75f + 0.5f * Hash(n + 13.7f));
	const float turn = Hash(n + 21.9f) * 6.2831853f + u * (Hash(n + 2.2f) - 0.5f) * 2.5f;
	const float2 spun = float2(corner.x * cos(turn) - corner.y * sin(turn), corner.x * sin(turn) + corner.y * cos(turn));
	const float3 placed = view + float3(spun * radius, 0);
	const float z = placed.z + eyeAndMask.z;
	o.h = float4(placed.x * projection.x, placed.y * projection.y, z * projection.z + projection.w, z);
	o.alpha = smoothstep(0, 0.04f, u) * (1 - smoothstep(0.35f, 1, u));
	return o;
}

float Hash2(float2 c) { return frac(sin(dot(c, float2(127.1f, 311.7f))) * 43758.5453f); }
float Noise2(float2 x)
{
	const float2 c = floor(x), f = frac(x), u = f * f * (3 - 2 * f);
	return lerp(lerp(Hash2(c), Hash2(c + float2(1, 0)), u.x), lerp(Hash2(c + float2(0, 1)), Hash2(c + float2(1, 1)), u.x), u.y);
}
// Fractal noise: the same noise at finer and finer scales, each fainter, which is what makes billows and wisps
float Fbm(float2 p)
{
	float sum = 0, amp = 0.5f;
	for (int k = 0; k < 5; ++k)
	{
		sum += Noise2(p) * amp;
		p = float2(p.x * 1.7f - p.y * 1.1f, p.x * 1.1f + p.y * 1.7f) + 3.1f;   // turned as well as scaled, so no grid shows
		amp *= 0.5f;
	}
	return sum;
}

float4 PS(Out i) : SV_Target
{
	const float r2 = dot(i.uv, i.uv);
	if (r2 >= 1 || i.alpha <= 0)
		discard;
	// Folded into itself (noise moved by noise), and churning as it ages, so it billows rather than sits
	const float2 q = i.uv * 1.7f + i.seed * 37;
	const float churn = i.age * 1.6f;
	const float2 warp = float2(Fbm(q + float2(churn, 0)), Fbm(q + float2(5.2f, 1.3f - churn)));
	const float billow = Fbm(q + warp * 1.9f);
	// Dense in the middle, ragged at the edge: the noise cuts into it more the further out it is
	const float edge = sqrt(r2);
	const float density = saturate((billow - 0.3f + (1 - edge) * 0.6f) * 2.6f) * (1 - smoothstep(0.7f, 1, edge));
	if (density <= 0.002f)
		discard;
	// Lit as a lump of smoke: its rounded face toward the light above is pale, its underside and the gaps between dark
	const float3 normal = normalize(float3(i.uv.x + (warp.x - 0.5f) * 0.9f, i.uv.y + (warp.y - 0.5f) * 0.9f, sqrt(1 - r2) + 0.25f));
	const float light = saturate(dot(normal, normalize(float3(-0.45f, 0.75f, 0.5f))));
	const float shade = lerp(0.3f, 1, light) * lerp(0.75f, 1.05f, billow) * lerp(0.8f, 1.12f, i.seed);
	// One smoke throughout: a little browner and darker low down where the dust is, greyer and lighter as it climbs, by
	// degrees, and a warm glow in its heart for the moment of the blast
	const float3 dark = lerp(float3(0.13f, 0.12f, 0.11f), float3(0.1f, 0.09f, 0.08f), i.dense);
	const float3 pale = lerp(float3(0.6f, 0.58f, 0.55f), float3(0.5f, 0.45f, 0.4f), i.dense);
	float3 colour = lerp(dark, pale, shade);
	colour += float3(1.0f, 0.55f, 0.2f) * saturate(1 - i.age / 0.12f) * (1 - edge) * i.dense * 0.6f;
	return float4(colour, saturate(density * 1.35f) * i.alpha);
}
)";

	// The stance a new one is fading in from, still playing until it's gone
	constexpr float kStanceFadeSeconds = 0.15f;   // only bridges the moment it took to work the new one out
	uint32_t g_boneIntro = 0, g_fromIntro = 0;
	ID3D12Resource* g_fromTable = nullptr;
	uint32_t g_fromFrames = 1, g_fromSlots = 1;
	float g_fromDuration = 0.f;
	std::chrono::steady_clock::time_point g_fromStart, g_fadeStart;

	// The bones' table on the card, and the clock its frames go by
	ID3D12Resource* g_boneTable = nullptr;
	D3D12_VERTEX_BUFFER_VIEW g_skinView{};
	ID3D12Resource* g_skins = nullptr;
	uint32_t g_boneFrames = 1, g_boneSlots = 1;
	float g_boneDuration = 0.f;
	float g_boneLoopStart = 0.f;   // where in its clip the loop begins
	std::chrono::steady_clock::time_point g_boneStart;
	std::shared_ptr<const void> g_boneSlotsShared;
	// Cloth: what carries each vertex, the particles' places on the card, a few frames' worth so one isn't written while it's drawn
	constexpr int kClothRing = 4;
	ID3D12Resource* g_clothVertices = nullptr;
	D3D12_VERTEX_BUFFER_VIEW g_clothView{};
	ID3D12Resource* g_shutVertices = nullptr;   // the Library's book shut (ShutVertex): a stream for every model
	D3D12_VERTEX_BUFFER_VIEW g_shutView{};
	ID3D12Resource* g_clothRing[kClothRing] = {};
	void* g_clothMapped[kClothRing] = {};
	int g_clothAt = 0;
	size_t g_clothBytes = 0;
	uint64_t g_clothSeen = 0;
	float g_clothLastYaw = 0.f;
	std::chrono::steady_clock::time_point g_clothLastAt;
	std::shared_ptr<const BakedAnimation> g_animationNow, g_animationFrom;
	std::atomic<int> g_animation{ 0 };
	std::atomic<unsigned> g_animationAsked{ 0 };
	std::shared_ptr<const BakedAnimation> g_animationArrived;
	// Changing what he wears: he goes on being drawn until the new one's ready, then it takes over where he was
	std::atomic<bool> g_keepShowing{ false };
	bool IsOnGeralt(const std::string& name) { return name.compare(0, strlen(kModelOnGeralt), kModelOnGeralt) == 0; }

	// One a part, on the card: the shader's Material
	struct MaterialValues
	{
		float spec[4], specColour[4], variance[4], flags[4];
		float red[3][4], blue[3][4];
		float detail[4], detail2[4], options[4], ghost[4], forms[4];
	};
	constexpr UINT kMaterialStride = 256;

	// What's been read, waiting to go on the card
	struct Loaded
	{
		std::string name;    // what was asked for
		int animation = 0;   // the stance it was read in
		ItemModel model;
		std::map<std::string, GameTexture> textures;
		std::vector<std::shared_ptr<ClothSim>> cloth;
		std::vector<float> clothStart;   // what it starts as
		bool ok = false;
		std::vector<std::pair<std::string, std::shared_ptr<PreparedTexture>>> prepared;   // ready to send
	};

	struct GpuPart { UINT indexCount, firstIndex; INT baseVertex; unsigned long long diffuse, normal, tint, specular, detail1, detail2; bool masked; float maskAt; };

	std::mutex g_lock;
	std::string g_wanted;
	std::atomic<unsigned> g_generation{ 0 };
	std::shared_ptr<Loaded> g_arrived;
	std::atomic<int> g_state{ kModelNone };

	// How long each stage of showing a model takes, for the log
	using Clock = std::chrono::steady_clock;
	Clock::time_point g_asked;
	double g_readMs = 0.0, g_geometryMs = 0.0;
	double Since(Clock::time_point t) { return std::chrono::duration<double, std::milli>(Clock::now() - t).count(); }

	float g_yaw = 0.f, g_pitch = 0.f;
	bool g_showThisFrame = false, g_drawnOnce = false;

	ID3D12Device* g_device = nullptr;
	ID3D12RootSignature* g_root = nullptr;
	ID3D12PipelineState* g_pipeline = nullptr;
	ID3D12PipelineState* g_smokePipeline = nullptr;   // the smoke a creature changes form behind
	ID3D12Resource* g_many = nullptr, * g_picture = nullptr, * g_depth = nullptr;
	ID3D12DescriptorHeap* g_rtv = nullptr, * g_dsv = nullptr;
	unsigned long long g_pictureView = 0;
	unsigned long long g_white = 0, g_flatNormal = 0;
	unsigned long long g_shadow = 0;   // a creature's part whose texture the game hasn't got: Hym, drawn by an effect of the game's own, as a shadow
	bool g_failed = false;

	// On the card, as the model now showing has it
	ID3D12Resource* g_vertices = nullptr, * g_indices = nullptr, * g_materials = nullptr;
	D3D12_VERTEX_BUFFER_VIEW g_vertexView{};
	D3D12_INDEX_BUFFER_VIEW g_indexView{};
	std::vector<GpuPart> g_parts;
	std::vector<std::string> g_partDiffuse;   // each part's diffuse texture, by the name it was loaded with
	bool g_modelIsBook = false;               // the Library's book: only its vertices take the book's roles, as the game's
	                                          // meshes' own vertex colours could have any alpha
	float g_fitAspect = 1.f;                  // the book's: the shape of the part of the picture it's shown in, wide over high
	std::vector<unsigned long long> g_ownTextures;
	float g_centre[3] = {}, g_radius = 1.f;
	int g_longAxis = 2;
	float g_faceYaw = 0.f;   // a blade's flat side to the viewer when it's not turned
	// A creature's shape as it stands, from its middle, a sample of its points: it's framed by what it shows at the angle it's
	// seen from, as a wyvern's tail is end on from the front and its whole length from the side. Empty for an item.
	std::vector<float> g_fitPoints;
	std::vector<uint8_t> g_fitForm;     // a two-form creature's: which form each of those points is
	std::vector<ShutVertex> g_fitShut;  // the Library's book: each of those points shut, and its role (BookPart), so it's
	std::vector<uint8_t> g_fitRole;     // framed as it is while it shuts

	// The book's case as the shader moves it (BookPart, SpineAt), for framing it: one point of it, in the model's tilted
	// space, that far shut
	void PoseShut(const float shut[4], const float sheet[4], const float sheet2[4], const ShutVertex& sv, uint8_t role, float p[3])
	{
		constexpr float kJointX = 0.030f, kBoardT = 0.0055f;
		const float c = sheet2[0], s = sheet2[1];
		float x = p[0], y = p[1] * c + p[2] * s, z = -p[1] * s + p[2] * c;
		if (shut[2] < 0.f)
		{
			// A journal, which folds its own way (book.h)
			float q[3] = { x, y, z }, turned = 0.f;
			JournalFold(static_cast<int>(sv.fold + 0.5f), sv.place, JournalShutAt(shut[0]), shut[0], q, turned);
			p[0] = q[0];
			p[1] = q[1] * c - q[2] * s;
			p[2] = q[1] * s + q[2] * c;
			return;
		}
		const float th = shut[0] * 3.14159265f, length = shut[2], m = shut[3];
		const auto spineAt = [&](float along, float& ax, float& az, float& phi)
		{
			phi = th * along / std::max(length, 1e-5f);
			if (th < 1e-3f)
			{
				ax = -along;
				az = 0.5f * along * phi;
			}
			else
			{
				const float r = length / th, h = sinf(phi * 0.5f);
				ax = -r * sinf(phi);
				az = 2.f * r * h * h;
			}
			ax += kJointX;
			az -= kBoardT;
		};
		const int piece = static_cast<int>(sv.fold + 0.5f);
		if (piece == 2)
		{
			float ax, az, phi;
			spineAt(sv.place[0] * length, ax, az, phi);
			const float outward = sv.place[1] - sv.place[2] * m;
			x = ax - sinf(phi) * outward;
			z = az - cosf(phi) * outward;
		}
		else
		{
			float qz = sv.place[2];
			if (role == 1)
				qz *= sheet[2];
			else if (role == 2)
				qz *= sheet[1];
			x += (sv.place[0] - x) * m;
			y += (sv.place[1] - y) * m;
			z += (qz - z) * m;
			if (piece == 1)
			{
				float ax, az, phi;
				spineAt(length, ax, az, phi);
				const float fx = x + kJointX, fz = z + kBoardT, ct = cosf(th), st = sinf(th);
				x = ax + fx * ct + fz * st;
				z = az - fx * st + fz * ct;
			}
		}
		x -= shut[1] * shut[0];
		p[0] = x;
		p[1] = y * c - z * s;
		p[2] = y * s + z * c;
	}
	float g_formCentre[2][3] = {};      // and each form's middle, as the camera moves from one to the other
	float g_formFeet[3] = {}, g_formSize = 1.f;   // where its smoke bursts from, and how big the bigger form is
	// When the loop began: each creature from its first form, not from where the last one shown had got to
	std::chrono::steady_clock::time_point g_formStart;

	// How far into a two-form creature's loop it is. The off-screen test can hold it at a moment (POTP_FORM_AT, seconds),
	// to see the smoke and the change as they are then.
	float FormSeconds()
	{
		const float seconds = std::chrono::duration<float>(std::chrono::steady_clock::now() - g_formStart).count();
#ifdef POTP_OVERLAY_TEST
		if (const char* at = getenv("POTP_FORM_AT"))
			return static_cast<float>(atof(at));
#endif
		return seconds;
	}
	float g_fitEye = -1.f;   // how far back the camera is now, easing to what the angle needs; -1 for at once
	std::chrono::steady_clock::time_point g_fitLast{};
	float g_zoom = 1.f;
	float g_panX = 0.f, g_panY = 0.f;
	float g_formTimes[4] = {};   // a two-form creature's: the first shown, a change, the second shown, the loop

	// Going on the card
	std::shared_ptr<Loaded> g_uploading;
	std::map<std::string, unsigned long long> g_uploaded;

	bool Fail(const char* what)
	{
		Log("item models: %s", what);
		g_failed = true;
		g_state = kModelMissing;   // not left saying it's loading
		return false;
	}

	bool MakePipeline()
	{
		using Compile_t = HRESULT(WINAPI*)(LPCVOID, SIZE_T, LPCSTR, const D3D_SHADER_MACRO*, ID3DInclude*, LPCSTR, LPCSTR, UINT, UINT, ID3DBlob**, ID3DBlob**);
		HMODULE compiler = LoadLibraryW(L"d3dcompiler_47.dll");
		const auto compile = compiler ? reinterpret_cast<Compile_t>(GetProcAddress(compiler, "D3DCompile")) : nullptr;
		if (!compile)
			return Fail("the shader compiler isn't on this computer");
		ID3DBlob* vs = nullptr, * ps = nullptr, * errors = nullptr;
		if (FAILED(compile(kShader, sizeof(kShader) - 1, "model", nullptr, nullptr, "VS", "vs_5_0", 0, 0, &vs, &errors)))
		{
			Log("item models: vertex shader: %s", errors ? static_cast<const char*>(errors->GetBufferPointer()) : "?");
			return Fail("no shader");
		}
		if (FAILED(compile(kShader, sizeof(kShader) - 1, "model", nullptr, nullptr, "PS", "ps_5_0", 0, 0, &ps, &errors)))
		{
			Log("item models: pixel shader: %s", errors ? static_cast<const char*>(errors->GetBufferPointer()) : "?");
			return Fail("no shader");
		}

		D3D12_DESCRIPTOR_RANGE ranges[6]{};
		for (UINT i = 0; i < 6; ++i)
		{
			ranges[i].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
			ranges[i].NumDescriptors = 1;
			ranges[i].BaseShaderRegister = i;
			ranges[i].OffsetInDescriptorsFromTableStart = 0;
		}
		D3D12_ROOT_PARAMETER params[11]{};
		params[10].ParameterType = D3D12_ROOT_PARAMETER_TYPE_SRV;
		params[10].Descriptor.ShaderRegister = 8;
		params[10].ShaderVisibility = D3D12_SHADER_VISIBILITY_VERTEX;
		params[9].ParameterType = D3D12_ROOT_PARAMETER_TYPE_SRV;
		params[9].Descriptor.ShaderRegister = 7;
		params[9].ShaderVisibility = D3D12_SHADER_VISIBILITY_VERTEX;
		params[8].ParameterType = D3D12_ROOT_PARAMETER_TYPE_SRV;
		params[8].Descriptor.ShaderRegister = 6;
		params[8].ShaderVisibility = D3D12_SHADER_VISIBILITY_VERTEX;
		params[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS;
		params[0].Constants.Num32BitValues = sizeof(Constants) / 4;
		params[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_ALL;
		params[1].ParameterType = D3D12_ROOT_PARAMETER_TYPE_CBV;
		params[1].Descriptor.ShaderRegister = 1;
		params[1].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
		for (int i = 0; i < 6; ++i)
		{
			params[i + 2].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
			params[i + 2].DescriptorTable.NumDescriptorRanges = 1;
			params[i + 2].DescriptorTable.pDescriptorRanges = &ranges[i];
			params[i + 2].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
		}
		D3D12_STATIC_SAMPLER_DESC sampler{};
		sampler.Filter = D3D12_FILTER_ANISOTROPIC;
		sampler.AddressU = sampler.AddressV = sampler.AddressW = D3D12_TEXTURE_ADDRESS_MODE_WRAP;
		sampler.MaxAnisotropy = 8;
		sampler.MaxLOD = D3D12_FLOAT32_MAX;
		sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
		D3D12_ROOT_SIGNATURE_DESC rootDesc{};
		rootDesc.NumParameters = 11;
		rootDesc.pParameters = params;
		rootDesc.NumStaticSamplers = 1;
		rootDesc.pStaticSamplers = &sampler;
		rootDesc.Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT;
		ID3DBlob* serialized = nullptr;
		if (FAILED(D3D12SerializeRootSignature(&rootDesc, D3D_ROOT_SIGNATURE_VERSION_1, &serialized, &errors))
			|| FAILED(g_device->CreateRootSignature(0, serialized->GetBufferPointer(), serialized->GetBufferSize(), IID_PPV_ARGS(&g_root))))
			return Fail("no root signature");

		const D3D12_INPUT_ELEMENT_DESC layout[] = {
			{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, offsetof(ModelVertex, position), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "NORMAL", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, offsetof(ModelVertex, normal), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "TANGENT", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, offsetof(ModelVertex, tangent), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0, offsetof(ModelVertex, uv), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "COLOR", 0, DXGI_FORMAT_R8G8B8A8_UNORM, 0, offsetof(ModelVertex, colour), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "BLENDINDICES", 0, DXGI_FORMAT_R16G16B16A16_UINT, 1, offsetof(SkinVertex, bones), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "BLENDWEIGHT", 0, DXGI_FORMAT_R8G8B8A8_UNORM, 1, offsetof(SkinVertex, weights), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "CLOTHINDEX", 0, DXGI_FORMAT_R32G32B32_UINT, 2, offsetof(ClothVertex, a), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "CLOTHBARY", 0, DXGI_FORMAT_R32G32B32_FLOAT, 2, offsetof(ClothVertex, bary), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "SHUTPLACE", 0, DXGI_FORMAT_R32G32B32_FLOAT, 3, offsetof(ShutVertex, place), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "SHUTNORMAL", 0, DXGI_FORMAT_R32G32B32_FLOAT, 3, offsetof(ShutVertex, normal), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "SHUTTANGENT", 0, DXGI_FORMAT_R32G32B32_FLOAT, 3, offsetof(ShutVertex, tangent), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
			{ "SHUTFOLD", 0, DXGI_FORMAT_R32_FLOAT, 3, offsetof(ShutVertex, fold), D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
		};
		D3D12_GRAPHICS_PIPELINE_STATE_DESC pso{};
		pso.pRootSignature = g_root;
		pso.VS = { vs->GetBufferPointer(), vs->GetBufferSize() };
		pso.PS = { ps->GetBufferPointer(), ps->GetBufferSize() };
		pso.InputLayout = { layout, static_cast<UINT>(sizeof(layout) / sizeof(layout[0])) };
		pso.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
		pso.NumRenderTargets = 1;
		pso.RTVFormats[0] = kColour;
		pso.DSVFormat = kDepth;
		pso.SampleDesc.Count = kSamples;
		pso.SampleMask = UINT_MAX;
		pso.BlendState.RenderTarget[0].RenderTargetWriteMask = D3D12_COLOR_WRITE_ENABLE_ALL;
		pso.RasterizerState.FillMode = D3D12_FILL_MODE_SOLID;
		pso.RasterizerState.CullMode = D3D12_CULL_MODE_NONE;   // cloth and thin parts have only the one side
		pso.RasterizerState.DepthClipEnable = TRUE;
		pso.RasterizerState.MultisampleEnable = TRUE;
		pso.DepthStencilState.DepthEnable = TRUE;
		pso.DepthStencilState.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ALL;
		pso.DepthStencilState.DepthFunc = D3D12_COMPARISON_FUNC_LESS_EQUAL;
		if (FAILED(g_device->CreateGraphicsPipelineState(&pso, IID_PPV_ARGS(&g_pipeline))))
			return Fail("no pipeline");

		// The smoke: no vertices of its own, laid over what's drawn and hidden behind it, not hiding what's behind itself
		ID3DBlob* smokeVs = nullptr, * smokePs = nullptr;
		if (FAILED(compile(kSmokeShader, sizeof(kSmokeShader) - 1, "smoke", nullptr, nullptr, "VS", "vs_5_0", 0, 0, &smokeVs, &errors))
			|| FAILED(compile(kSmokeShader, sizeof(kSmokeShader) - 1, "smoke", nullptr, nullptr, "PS", "ps_5_0", 0, 0, &smokePs, &errors)))
		{
			Log("item models: smoke shader: %s", errors ? static_cast<const char*>(errors->GetBufferPointer()) : "?");
			return true;   // a creature changes form without it
		}
		pso.VS = { smokeVs->GetBufferPointer(), smokeVs->GetBufferSize() };
		pso.PS = { smokePs->GetBufferPointer(), smokePs->GetBufferSize() };
		pso.InputLayout = { nullptr, 0 };
		D3D12_RENDER_TARGET_BLEND_DESC& blend = pso.BlendState.RenderTarget[0];
		blend.BlendEnable = TRUE;
		blend.SrcBlend = D3D12_BLEND_SRC_ALPHA;
		blend.DestBlend = D3D12_BLEND_INV_SRC_ALPHA;
		blend.BlendOp = D3D12_BLEND_OP_ADD;
		blend.SrcBlendAlpha = D3D12_BLEND_ONE;
		blend.DestBlendAlpha = D3D12_BLEND_INV_SRC_ALPHA;
		blend.BlendOpAlpha = D3D12_BLEND_OP_ADD;
		pso.DepthStencilState.DepthWriteMask = D3D12_DEPTH_WRITE_MASK_ZERO;
		if (FAILED(g_device->CreateGraphicsPipelineState(&pso, IID_PPV_ARGS(&g_smokePipeline))))
			Log("item models: no smoke pipeline");
		return true;
	}

	bool MakeTargets()
	{
		D3D12_HEAP_PROPERTIES heap{ D3D12_HEAP_TYPE_DEFAULT };
		D3D12_RESOURCE_DESC desc{};
		desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
		desc.Width = kWidth;
		desc.Height = kHeight;
		desc.DepthOrArraySize = desc.MipLevels = 1;
		desc.Format = kColour;
		desc.SampleDesc.Count = kSamples;
		desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;
		D3D12_CLEAR_VALUE clear{};
		clear.Format = kColour;
		if (FAILED(g_device->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_RENDER_TARGET, &clear, IID_PPV_ARGS(&g_many))))
			return Fail("no picture to draw in");
		desc.SampleDesc.Count = 1;
		desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_RENDER_TARGET;
		if (FAILED(g_device->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE, nullptr, IID_PPV_ARGS(&g_picture))))
			return Fail("no picture to show");
		desc.SampleDesc.Count = kSamples;
		desc.Format = kDepth;
		desc.Flags = D3D12_RESOURCE_FLAG_ALLOW_DEPTH_STENCIL;
		D3D12_CLEAR_VALUE clearDepth{};
		clearDepth.Format = kDepth;
		clearDepth.DepthStencil.Depth = 1.f;
		if (FAILED(g_device->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_DEPTH_WRITE, &clearDepth, IID_PPV_ARGS(&g_depth))))
			return Fail("no depth");

		D3D12_DESCRIPTOR_HEAP_DESC views{};
		views.NumDescriptors = 1;
		views.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
		if (FAILED(g_device->CreateDescriptorHeap(&views, IID_PPV_ARGS(&g_rtv))))
			return Fail("no view");
		views.Type = D3D12_DESCRIPTOR_HEAP_TYPE_DSV;
		if (FAILED(g_device->CreateDescriptorHeap(&views, IID_PPV_ARGS(&g_dsv))))
			return Fail("no view");
		g_device->CreateRenderTargetView(g_many, nullptr, g_rtv->GetCPUDescriptorHandleForHeapStart());
		g_device->CreateDepthStencilView(g_depth, nullptr, g_dsv->GetCPUDescriptorHandleForHeapStart());
		if (!MakeIconView(g_picture, kColour, g_pictureView))
			return Fail("no room for the picture's view");

		// For a material without one of its maps
		GameTexture one;
		one.dxgiFormat = DXGI_FORMAT_R8G8B8A8_UNORM;
		one.width = one.height = one.rows = 1;
		one.rowBytes = 4;
		one.pixels = { 200, 200, 200, 255 };
		if (!UploadIconTexture(one, g_white))
			return Fail("no plain texture");
		one.pixels = { 128, 128, 255, 170 };
		if (!UploadIconTexture(one, g_flatNormal))
			return Fail("no flat texture");
		one.pixels = { 14, 13, 16, 255 };
		if (!UploadIconTexture(one, g_shadow))
			return Fail("no shadow texture");
		return true;
	}

	void LetGoOfModel()
	{
		for (const unsigned long long t : g_ownTextures)
			RetireIconTexture(t);
		g_ownTextures.clear();
		g_parts.clear();
		g_partDiffuse.clear();
		if (g_vertices)
			RetireResource(g_vertices);
		if (g_indices)
			RetireResource(g_indices);
		if (g_materials)
			RetireResource(g_materials);
		if (g_skins)
			RetireResource(g_skins);
		if (g_boneTable)
			RetireResource(g_boneTable);
		if (g_fromTable)
			RetireResource(g_fromTable);
		g_vertices = g_indices = g_materials = g_skins = g_boneTable = g_fromTable = nullptr;
		ClothStop();
		if (g_clothVertices)
			RetireResource(g_clothVertices);
		g_clothVertices = nullptr;
		if (g_shutVertices)
			RetireResource(g_shutVertices);
		g_shutVertices = nullptr;
		for (int i = 0; i < kClothRing; ++i)
		{
			if (g_clothRing[i])
				RetireResource(g_clothRing[i]);
			g_clothRing[i] = nullptr;
			g_clothMapped[i] = nullptr;
		}
		g_clothBytes = 0;
		g_animationNow.reset();
		g_animationFrom.reset();
	}

	ID3D12Resource* MakeBuffer(const void* data, size_t size)
	{
		D3D12_HEAP_PROPERTIES heap{ D3D12_HEAP_TYPE_UPLOAD };
		D3D12_RESOURCE_DESC desc{};
		desc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
		desc.Width = size;
		desc.Height = desc.DepthOrArraySize = desc.MipLevels = 1;
		desc.SampleDesc.Count = 1;
		desc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
		ID3D12Resource* buffer = nullptr;
		if (FAILED(g_device->CreateCommittedResource(&heap, D3D12_HEAP_FLAG_NONE, &desc, D3D12_RESOURCE_STATE_GENERIC_READ, nullptr, IID_PPV_ARGS(&buffer))))
			return nullptr;
		void* mapped = nullptr;
		if (SUCCEEDED(buffer->Map(0, nullptr, &mapped)))
		{
			memcpy(mapped, data, size);
			buffer->Unmap(0, nullptr);
		}
		return buffer;
	}

	// Textures read lately, as they came out of the game's caches: unpacking them is most of a model's wait, and the same
	// ones come again as the list is gone up and down. The oldest go once they're more than a budget's worth.
	std::mutex g_textureLock;
	std::list<std::pair<std::string, std::shared_ptr<const GameTexture>>> g_recentTextures;   // most recent first
	size_t g_recentBytes = 0;
	constexpr size_t kRecentTextureBytes = 256u << 20;

	size_t TextureBytes(const GameTexture& t)
	{
		size_t bytes = t.pixels.size();
		for (const GameTexture& m : t.lowerMips)
			bytes += m.pixels.size();
		return bytes;
	}

	bool RecentTexture(const std::string& path, GameTexture& out)
	{
		std::lock_guard<std::mutex> hold(g_textureLock);
		for (auto it = g_recentTextures.begin(); it != g_recentTextures.end(); ++it)
			if (it->first == path)
			{
				g_recentTextures.splice(g_recentTextures.begin(), g_recentTextures, it);
				out = *it->second;
				return true;
			}
		return false;
	}

	void KeepTexture(const std::string& path, const GameTexture& texture)
	{
		auto kept = std::make_shared<const GameTexture>(texture);
		const size_t bytes = TextureBytes(texture);
		if (bytes == 0 || bytes > kRecentTextureBytes / 4)
			return;
		std::lock_guard<std::mutex> hold(g_textureLock);
		g_recentTextures.emplace_front(path, std::move(kept));
		g_recentBytes += bytes;
		while (g_recentBytes > kRecentTextureBytes && g_recentTextures.size() > 1)
		{
			g_recentBytes -= TextureBytes(*g_recentTextures.back().second);
			g_recentTextures.pop_back();
		}
	}

	// All of it's on the card: put it together
	void FinishUpload()
	{
		const ItemModel& model = g_uploading->model;
		std::vector<ModelVertex> vertices;
		std::vector<SkinVertex> skins;
		std::vector<uint32_t> indices;
		std::vector<ClothVertex> clothing;
		std::vector<ShutVertex> shutting;
		std::vector<uint8_t> vertexForm;   // each vertex's form, for a two-form creature
		std::vector<uint32_t> firstParticle;
		{
			uint32_t particles = 0;
			for (const std::shared_ptr<ClothData>& cloth : model.cloths)
			{
				firstParticle.push_back(particles);
				particles += static_cast<uint32_t>(cloth->particles);
			}
		}
		std::vector<uint8_t> materialBytes;
		std::vector<float> detailRanges;   // each material's, as they're laid out
		for (const ModelPart& p : model.parts)
		{
			if (p.shadowOnly || p.indices.empty())
				continue;
			const auto texture = [&](const std::string& path, unsigned long long fallback)
			{
				const auto found = g_uploaded.find(path);
				return found != g_uploaded.end() && found->second ? found->second : fallback;
			};
			const unsigned long long tint = texture(p.tintMask, 0), specular = texture(p.specular, 0);
			GpuPart part{ static_cast<UINT>(p.indices.size()), static_cast<UINT>(indices.size()), static_cast<INT>(vertices.size()), texture(p.diffuse, model.creature && !p.diffuse.empty() ? g_shadow : g_white), texture(p.normal, g_flatNormal), tint ? tint : g_white, specular ? specular : g_white, texture(p.detail1, g_flatNormal), texture(p.detail2, g_flatNormal), p.masked,
				// Hair is drawn strand by strand, its fine ends far fainter than a cut-out leaf's edge
				p.graph.find("hair") != std::string::npos ? 0.12f : 0.33f };
			MaterialValues values{};
			values.spec[0] = p.specScale;
			values.spec[1] = p.specBase;
			values.spec[2] = p.roughMin;
			values.spec[3] = p.roughMax;
			for (int i = 0; i < 3; ++i)
				values.specColour[i] = p.specColour[i];
			values.specColour[3] = p.aoPower;
			for (int i = 0; i < 4; ++i)
				values.variance[i] = p.variance[i];
			values.flags[0] = tint ? 1.f : 0.f;
			values.flags[1] = specular ? 1.f : 0.f;
			values.flags[2] = p.skin ? 1.f : 0.f;
			values.flags[3] = p.shifting && tint ? 1.f : 0.f;
			for (int i = 0; i < 3; ++i)
				for (int j = 0; j < 3; ++j)
				{
					values.red[i][j] = p.shiftRed[i * 3 + j];
					values.blue[i][j] = p.shiftBlue[i * 3 + j];
				}
			values.detail[0] = p.detailTile1[0];
			values.detail[1] = p.detailTile1[1];
			values.detail[2] = p.detailPower;
			values.detail[3] = p.detailAlbedo * p.detailPower;   // as the graphs have it: the albedo's strength times the detail's
			values.detail2[0] = p.detailTile2[0];
			values.detail2[1] = p.detailTile2[1];
			values.detail2[2] = static_cast<float>(tint ? p.detailMode : p.detailMode == 3 ? 3 : 0);
			values.options[0] = p.keepGray ? 1.f : 0.f;
			values.options[1] = p.blendColors ? 1.f : 0.f;
			values.options[2] = p.graph.find("hair") != std::string::npos ? 1.f : 0.f;
			values.options[3] = p.graph.rfind("pbr_spec_tint_mask", 0) == 0 ? 1.f : 0.f;
			for (int k = 0; k < 4; ++k)
				values.ghost[k] = p.ghost[k];
			values.forms[0] = p.form >= 0 ? 1.f : 0.f;
			values.forms[1] = p.form > 0 ? 1.f : 0.f;
			detailRanges.push_back(p.detailRange);
			const size_t at = materialBytes.size();
			materialBytes.resize(at + kMaterialStride);
			memcpy(materialBytes.data() + at, &values, sizeof(values));
			g_parts.push_back(part);
			g_partDiffuse.push_back(p.diffuse);
			g_modelIsBook = g_uploading->name.compare(0, strlen(kModelBook), kModelBook) == 0;
			vertices.insert(vertices.end(), p.vertices.begin(), p.vertices.end());
			vertexForm.insert(vertexForm.end(), p.vertices.size(), static_cast<uint8_t>(p.form > 0 ? 1 : 0));
			skins.resize(vertices.size());   // what isn't skinned stays where it is, in the table's first slot
			if (p.skinning.size() == p.vertices.size())
				std::copy(p.skinning.begin(), p.skinning.end(), skins.end() - static_cast<ptrdiff_t>(p.skinning.size()));
			clothing.resize(vertices.size());
			shutting.resize(vertices.size());
			if (p.shut.size() == p.vertices.size())
				std::copy(p.shut.begin(), p.shut.end(), shutting.end() - static_cast<ptrdiff_t>(p.shut.size()));
			if (p.cloth >= 0 && p.clothing.size() == p.vertices.size() && !g_uploading->cloth.empty())
			{
				ClothVertex* to = clothing.data() + (clothing.size() - p.clothing.size());
				const uint32_t base = firstParticle[p.cloth];
				for (size_t v = 0; v < p.clothing.size(); ++v)
				{
					to[v] = p.clothing[v];
					if (to[v].a != kClothNone)
					{
						to[v].a += base;
						to[v].b += base;
						to[v].c += base;
					}
				}
			}
			indices.insert(indices.end(), p.indices.begin(), p.indices.end());
		}
		// A pair worn apart (gloves, on hands held out to the sides) brought together, or it would show very small
		float lowest[3], highest[3];
		const auto measure = [&]
		{
			for (int i = 0; i < 3; ++i)
			{
				lowest[i] = FLT_MAX;
				highest[i] = -FLT_MAX;
			}
			for (const ModelVertex& v : vertices)
				for (int i = 0; i < 3; ++i)
				{
					lowest[i] = std::min(lowest[i], v.position[i]);
					highest[i] = std::max(highest[i], v.position[i]);
				}
		};
		measure();
		// (not the Library's book: a board's middle can have no vertex, and it isn't a pair)
		if (model.worn && !model.creature && !model.animation && !vertices.empty() && !g_modelIsBook)
		{
			float leftEdge = -FLT_MAX, rightEdge = FLT_MAX;
			for (const ModelVertex& v : vertices)
			{
				if (v.position[0] < 0.f)
					leftEdge = std::max(leftEdge, v.position[0]);
				else
					rightEdge = std::min(rightEdge, v.position[0]);
			}
			const float width = highest[0] - lowest[0];
			if (leftEdge > -FLT_MAX && rightEdge < FLT_MAX && rightEdge - leftEdge > width * 0.4f)
			{
				const float gap = (highest[2] - lowest[2]) * 0.15f;
				for (ModelVertex& v : vertices)
					v.position[0] += v.position[0] < 0.f ? -leftEdge - gap * 0.5f : -rightEdge + gap * 0.5f;
				measure();
			}
		}
		// Framed as he stands in the animation's first frame, not as he was bound
		std::vector<ModelVertex> posed;
		if (model.animation)
		{
			posed = vertices;
			const float* rows = model.animation->rows.data();
			for (size_t v = 0; v < posed.size(); ++v)
			{
				float to[3] = {};
				const ModelVertex& from = vertices[v];
				for (int k = 0; k < 4; ++k)
				{
					const float weight = skins[v].weights[k] / 255.f;
					if (weight <= 0.f)
						continue;
					const float* r = rows + static_cast<size_t>(skins[v].bones[k]) * 12;
					for (int axis = 0; axis < 3; ++axis)
						to[axis] += (r[axis * 4] * from.position[0] + r[axis * 4 + 1] * from.position[1] + r[axis * 4 + 2] * from.position[2] + r[axis * 4 + 3]) * weight;
				}
				memcpy(posed[v].position, to, sizeof(to));
			}
			for (int i = 0; i < 3; ++i)
			{
				lowest[i] = FLT_MAX;
				highest[i] = -FLT_MAX;
			}
			for (const ModelVertex& v : posed)
				for (int i = 0; i < 3; ++i)
				{
					lowest[i] = std::min(lowest[i], v.position[i]);
					highest[i] = std::max(highest[i], v.position[i]);
				}
		}
		const std::vector<ModelVertex>& framing = model.animation ? posed : vertices;
		static const float kStill[12] = { 1,0,0,0, 0,1,0,0, 0,0,1,0 };
		g_boneTable = model.animation ? MakeBuffer(model.animation->rows.data(), model.animation->rows.size() * sizeof(float)) : MakeBuffer(kStill, sizeof(kStill));
		g_boneFrames = model.animation ? model.animation->frames : 1;
		g_boneIntro = model.animation ? model.animation->introFrames : 0;
		g_boneSlots = model.animation ? model.animation->slots : 1;
		g_boneDuration = model.animation ? model.animation->duration : 0.f;
		g_boneLoopStart = model.animation ? model.animation->loopStart : 0.f;
		memcpy(g_formTimes, model.formTimes, sizeof(g_formTimes));
		// A creature in two forms starts its loop afresh, its body with it, so it's shown as its first form a while before
		// it changes; only Geralt, between pieces of armour, carries on where he was
		if (!g_keepShowing || g_formTimes[3] > 0.f)
			g_boneStart = std::chrono::steady_clock::now();
		g_formStart = g_boneStart;
		{
			// A stance baked for the last one's table doesn't fit this one. If it's changed since this was read, it's asked for again.
			std::lock_guard<std::mutex> hold(g_lock);
			g_boneSlotsShared = model.boneSlots;
			g_animationArrived.reset();
			++g_animationAsked;
			if (model.animation)
				g_animation = g_uploading->animation;
		}
		g_skins = MakeBuffer(skins.data(), skins.size() * sizeof(SkinVertex));
		g_clothVertices = MakeBuffer(clothing.data(), clothing.size() * sizeof(ClothVertex));
		g_clothView = g_clothVertices ? D3D12_VERTEX_BUFFER_VIEW{ g_clothVertices->GetGPUVirtualAddress(), static_cast<UINT>(clothing.size() * sizeof(ClothVertex)), sizeof(ClothVertex) } : D3D12_VERTEX_BUFFER_VIEW{};
		g_shutVertices = MakeBuffer(shutting.data(), shutting.size() * sizeof(ShutVertex));
		g_shutView = g_shutVertices ? D3D12_VERTEX_BUFFER_VIEW{ g_shutVertices->GetGPUVirtualAddress(), static_cast<UINT>(shutting.size() * sizeof(ShutVertex)), sizeof(ShutVertex) } : D3D12_VERTEX_BUFFER_VIEW{};
		g_animationNow = model.animation;
		g_animationFrom.reset();
		if (!g_uploading->cloth.empty() && !g_uploading->clothStart.empty())
		{
			g_clothBytes = g_uploading->clothStart.size() * sizeof(float);
			bool made = true;
			for (int i = 0; i < kClothRing && made; ++i)
			{
				g_clothRing[i] = MakeBuffer(g_uploading->clothStart.data(), g_clothBytes);
				made = g_clothRing[i] && SUCCEEDED(g_clothRing[i]->Map(0, nullptr, &g_clothMapped[i]));
			}
			if (made)
			{
				g_clothAt = 0;
				g_clothSeen = 0;
				g_clothLastYaw = g_yaw;
				g_clothLastAt = std::chrono::steady_clock::now();
				ClothRun(g_uploading->cloth);
			}
			else
			{
				g_clothBytes = 0;
				Log("item models: no room on the card for cloth");
			}
		}
		g_vertices = MakeBuffer(vertices.data(), vertices.size() * sizeof(ModelVertex));
		g_indices = MakeBuffer(indices.data(), indices.size() * sizeof(uint32_t));
		// A creature's detail as the graphs fade it, by how far the camera is (saturate(DetailRange - distance)): framed whole,
		// a big one is seen from as far as in the game, where its detail is gone. Up close a strong one washes it out white.
		if (model.creature && !framing.empty())
		{
			float centre[3], furthest = 0.f;
			for (int k = 0; k < 3; ++k)
				centre[k] = (lowest[k] + highest[k]) * 0.5f;
			for (const ModelVertex& v : framing)
			{
				const float x = v.position[0] - centre[0], y = v.position[1] - centre[1], z = v.position[2] - centre[2];
				furthest = std::max(furthest, x * x + y * y + z * z);
			}
			const float radius = sqrtf(furthest), eye = radius / sinf(13.f * 3.14159265f / 180.f) * 1.04f, distance = std::max(0.f, eye - radius);
			for (size_t m = 0; m < detailRanges.size(); ++m)
			{
				MaterialValues values;
				memcpy(&values, materialBytes.data() + m * kMaterialStride, sizeof(values));
				const float fade = std::clamp(detailRanges[m] - distance, 0.f, 1.f);
				values.detail[2] *= fade;
				values.detail[3] *= fade;
				memcpy(materialBytes.data() + m * kMaterialStride, &values, sizeof(values));
			}
		}
		g_materials = materialBytes.empty() ? nullptr : MakeBuffer(materialBytes.data(), materialBytes.size());
		if (!g_vertices || !g_indices || !g_materials || !g_skins || !g_boneTable || !g_clothVertices)
		{
			Log("item models: no room on the card for it");
			LetGoOfModel();
			g_state = kModelMissing;
			g_uploading.reset();
			return;
		}
		g_vertexView = { g_vertices->GetGPUVirtualAddress(), static_cast<UINT>(vertices.size() * sizeof(ModelVertex)), sizeof(ModelVertex) };
		g_skinView = { g_skins->GetGPUVirtualAddress(), static_cast<UINT>(skins.size() * sizeof(SkinVertex)), sizeof(SkinVertex) };
		g_indexView = { g_indices->GetGPUVirtualAddress(), static_cast<UINT>(indices.size() * sizeof(uint32_t)), DXGI_FORMAT_R32_UINT };

		const float keptCentre[3] = { g_centre[0], g_centre[1], g_centre[2] };
		const float keptRadius = g_radius;
		float extent[3];
		for (int i = 0; i < 3; ++i)
		{
			g_centre[i] = (lowest[i] + highest[i]) * 0.5f;
			extent[i] = highest[i] - lowest[i];
		}
		// As close as it can stand and still turn: how far its furthest point really is, not its box's corner
		float furthest = 0.f;
		for (const ModelVertex& v : framing)
		{
			const float x = v.position[0] - g_centre[0], y = v.position[1] - g_centre[1], z = v.position[2] - g_centre[2];
			furthest = std::max(furthest, x * x + y * y + z * z);
		}
		g_radius = std::max(0.001f, sqrtf(furthest)) * (model.animation ? 1.03f : 1.f);   // room to move in
		g_fitPoints.clear();
		g_fitForm.clear();
		g_fitShut.clear();
		g_fitRole.clear();
		g_fitEye = -1.f;
		float formLow[2][3] = { { FLT_MAX, FLT_MAX, FLT_MAX }, { FLT_MAX, FLT_MAX, FLT_MAX } };
		float formHigh[2][3] = { { -FLT_MAX, -FLT_MAX, -FLT_MAX }, { -FLT_MAX, -FLT_MAX, -FLT_MAX } };
		if (model.creature && !g_keepShowing)
		{
			// Where it gets to all through its idle, not only as it starts: a siren's wings beat well past where they begin
			const auto& anim = model.animation;
			const uint32_t frames = anim ? anim->frames : 1, slots = anim ? anim->slots : 1;
			const bool posable = anim && anim->rows.size() >= static_cast<size_t>(frames) * slots * 12 && skins.size() == vertices.size();
			const uint32_t times = posable ? std::min<uint32_t>(frames, 8) : 1;
			const size_t step = std::max<size_t>(1, framing.size() * times / 24000);
			g_fitPoints.reserve(framing.size() / step * 3 * times + 3);
			for (uint32_t t = 0; t < times; ++t)
			{
				const float* rows = posable ? anim->rows.data() + static_cast<size_t>(frames * t / times) * slots * 12 : nullptr;
				for (size_t v = 0; v < framing.size(); v += step)
				{
					float to[3] = { framing[v].position[0], framing[v].position[1], framing[v].position[2] };
					if (rows)
					{
						to[0] = to[1] = to[2] = 0.f;
						const ModelVertex& from = vertices[v];
						for (int k = 0; k < 4; ++k)
						{
							const float weight = skins[v].weights[k] / 255.f;
							if (weight <= 0.f)
								continue;
							const float* r = rows + static_cast<size_t>(skins[v].bones[k]) * 12;
							for (int axis = 0; axis < 3; ++axis)
								to[axis] += (r[axis * 4] * from.position[0] + r[axis * 4 + 1] * from.position[1] + r[axis * 4 + 2] * from.position[2] + r[axis * 4 + 3]) * weight;
						}
					}
					const uint8_t form = v < vertexForm.size() ? vertexForm[v] : 0;
					for (int k = 0; k < 3; ++k)
					{
						g_fitPoints.push_back(to[k] - g_centre[k]);
						formLow[form][k] = std::min(formLow[form][k], to[k]);
						formHigh[form][k] = std::max(formHigh[form][k], to[k]);
					}
					g_fitForm.push_back(form);
				}
			}
			for (int form = 0; form < 2; ++form)
				for (int k = 0; k < 3; ++k)
					g_formCentre[form][k] = formLow[form][k] <= formHigh[form][k] ? (formLow[form][k] + formHigh[form][k]) * 0.5f : g_centre[k];
			g_formFeet[0] = g_formCentre[0][0];
			g_formFeet[1] = g_formCentre[0][1];
			g_formFeet[2] = std::min(formLow[0][2], formLow[1][2]);
			g_formSize = 0.f;
			for (int form = 0; form < 2; ++form)
				if (formLow[form][0] <= formHigh[form][0])
					g_formSize = std::max(g_formSize, std::max(formHigh[form][0] - formLow[form][0], formHigh[form][2] - formLow[form][2]) * 0.5f);
			g_formSize = std::max(0.4f, g_formSize);
		}
		else if (g_modelIsBook && !g_keepShowing)
		{
			// The book: framed by its own shape as it's seen, not a sphere it could turn in, so it fills the picture.
			// The ribbon (role 5) left out, as its end hangs well below the book.
			g_fitPoints.reserve(vertices.size() * 3);
			for (size_t i = 0; i < vertices.size(); ++i)
			{
				const ModelVertex& v = vertices[i];
				if (v.colour[3] == 5 || v.colour[3] == 6)   // nor what's only on a journal shut, which lies where it is then
					continue;
				for (int k = 0; k < 3; ++k)
					g_fitPoints.push_back(v.position[k] - g_centre[k]);
				g_fitShut.push_back(i < shutting.size() ? shutting[i] : ShutVertex{});
				g_fitRole.push_back(v.colour[3]);
			}
		}
		if (g_keepShowing)
		{
			// He stays where he was on screen, a little further back only if this one needs the room
			memcpy(g_centre, keptCentre, sizeof(g_centre));
			g_radius = std::max(g_radius, keptRadius);
		}
		// A weapon can lie along any axis: stood up along its longest. What's worn keeps the way up it's worn.
		g_longAxis = 2;
		if (!model.worn)
			g_longAxis = extent[0] >= extent[1] && extent[0] >= extent[2] ? 0 : extent[1] >= extent[2] ? 1 : 2;
		// Across and into the screen, once the long axis is up: the thinner of them goes into the screen
		const float across = g_longAxis == 0 ? extent[2] : extent[0], into = g_longAxis == 1 ? extent[2] : extent[1];
		g_faceYaw = model.facingYaw + (!model.worn && across < into ? 90.f : 0.f);
		g_uploading.reset();
		g_uploaded.clear();
		g_state = kModelReady;
	}

	void Multiply(const float a[16], const float b[16], float out[16])
	{
		float r[16];
		for (int i = 0; i < 4; ++i)
			for (int j = 0; j < 4; ++j)
			{
				r[i * 4 + j] = 0.f;
				for (int k = 0; k < 4; ++k)
					r[i * 4 + j] += a[i * 4 + k] * b[k * 4 + j];
			}
		memcpy(out, r, sizeof(r));
	}
}

void ModelViewPrefetch(const std::vector<std::string>& creatures)
{
	// One at a time, behind what's shown, and only creatures: a model kept and its textures kept are then a moment to show.
	// Asked again each frame, so it's only those near what's chosen now.
	static std::mutex lock;
	static std::vector<std::string> waiting;
	static bool running = false;
	static std::set<std::string> done;
	std::lock_guard<std::mutex> hold(lock);
	waiting.clear();
	for (const std::string& name : creatures)
		if (name.compare(0, strlen(kModelCreature), kModelCreature) == 0 && !done.count(name))
			waiting.push_back(name);
	if (running || waiting.empty() || g_state != kModelReady)
		return;
	running = true;
	std::thread([]
	{
		SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_BELOW_NORMAL);
		for (;;)
		{
			std::string name;
			{
				std::lock_guard<std::mutex> hold(lock);
				if (waiting.empty() || g_state != kModelReady)
				{
					running = false;
					return;
				}
				name = waiting.front();
				waiting.erase(waiting.begin());
				done.insert(name);
				if (done.size() > 64)
					done.clear();   // the caches will have let most of them go by then
			}
			try
			{
				ItemModel model;
				if (!LoadCreature(name.substr(strlen(kModelCreature)), model))
					continue;
				std::set<std::string> paths;
				for (const ModelPart& p : model.parts)
					if (!p.shadowOnly)
						for (const std::string* path : { &p.diffuse, &p.normal, &p.tintMask, &p.specular, &p.detail1, &p.detail2 })
							if (!path->empty())
								paths.insert(*path);
				for (const std::string& path : paths)
				{
					GameTexture texture;
					if (!RecentTexture(path, texture) && ReadGameTexture(path, 1024, texture, true))
						KeepTexture(path, texture);
				}
			}
			catch (const std::exception& problem)
			{
				Log("item models: reading ahead %s: %s", name.c_str(), problem.what());
			}
		}
	}).detach();
}

void ModelViewRequest(const std::string& templateName)
{
	{
		std::lock_guard<std::mutex> hold(g_lock);
		if (g_wanted == templateName)
			return;
		g_keepShowing = g_drawnOnce && !g_parts.empty() && IsOnGeralt(g_wanted) && IsOnGeralt(templateName);
		g_wanted = templateName;
		g_arrived.reset();
	}
	const unsigned generation = ++g_generation;
	g_asked = Clock::now();
	if (!g_keepShowing)
		g_drawnOnce = false;
	g_state = kModelLoading;
	std::thread([templateName, generation]
	{
		auto loaded = std::make_shared<Loaded>();
		loaded->name = templateName;
		loaded->animation = g_animation;
		const auto started = Clock::now();
		for (int wait = 0; wait < 200 && !(ModelIndexReady() && GameIconIndexReady()); ++wait)
			Sleep(50);
		const size_t prefix = strlen(kModelOnGeralt), creature = strlen(kModelCreature);
		try
		{
			loaded->ok = templateName.compare(0, prefix, kModelOnGeralt) == 0
				? LoadItemOnGeralt(templateName.substr(prefix), loaded->animation, loaded->model)
				: templateName.compare(0, creature, kModelCreature) == 0
				? LoadCreature(templateName.substr(creature), loaded->model)
				: templateName.compare(0, strlen(kModelBook), kModelBook) == 0
				? LoadBookModel(templateName.substr(strlen(kModelBook)), loaded->model)
				: templateName.compare(0, strlen(kModelWithScabbard), kModelWithScabbard) == 0
				? LoadSwordWithScabbard(templateName.substr(strlen(kModelWithScabbard)), loaded->model)
				: LoadItemModel(templateName, loaded->model);
		}
		catch (const std::exception& problem)
		{
			loaded->ok = false;
			loaded->model.problem = problem.what();
		}
		// Cloth comes to rest here, so it's there at rest the moment it's shown
		if (loaded->ok && !loaded->model.cloths.empty() && GetSettings().clothSim)
		{
			try
			{
				loaded->cloth = MakeCloth(loaded->model.cloths, loaded->model.animation, loaded->clothStart);
			}
			catch (const std::exception& problem)
			{
				Log("item models: cloth: %s", problem.what());
				loaded->cloth.clear();
				loaded->clothStart.clear();
			}
		}
		const double geometry = Since(started);
		if (!loaded->ok)
			Log("item models: %s", loaded->model.problem.c_str());
		if (loaded->ok)
		{
			// Each texture on a thread of its own: the unpacking is most of the wait
			for (const ModelPart& p : loaded->model.parts)
				if (!p.shadowOnly)
					for (const std::string* path : { &p.diffuse, &p.normal, &p.tintMask, &p.specular, &p.detail1, &p.detail2 })
						if (!path->empty())
							loaded->textures.emplace(*path, GameTexture{});
			std::vector<std::thread> workers;
			std::atomic<size_t> next{ 0 };
			std::vector<std::pair<const std::string*, GameTexture*>> jobs;
			for (auto& [path, texture] : loaded->textures)
				jobs.emplace_back(&path, &texture);
			const unsigned threads = std::clamp(std::thread::hardware_concurrency() / 2, 1u, 6u);
			for (unsigned i = 0; i < threads; ++i)
				workers.emplace_back([&]
				{
					for (size_t at = next++; at < jobs.size(); at = next++)
						if (g_generation == generation)
						{
							// One bad texture costs that texture, never the game: nothing above a thread can catch this
							try
							{
								if (!RecentTexture(*jobs[at].first, *jobs[at].second) && ReadGameTexture(*jobs[at].first, 1024, *jobs[at].second, true))
									KeepTexture(*jobs[at].first, *jobs[at].second);
							}
							catch (const std::exception& problem)
							{
								Log("item models: reading %s: %s", jobs[at].first->c_str(), problem.what());
								jobs[at].second->pixels.clear();
							}
						}
				});
			for (std::thread& worker : workers)
				worker.join();
			for (auto it = loaded->textures.begin(); it != loaded->textures.end();)
			{
				if (it->second.pixels.empty() && g_generation == generation)
					Log("item models: no texture %s", it->first.c_str());
				it = it->second.pixels.empty() ? loaded->textures.erase(it) : std::next(it);
			}
			// On this thread, so the frames carry on while the memory is made and filled
			for (auto& [path, texture] : loaded->textures)
			{
				if (g_generation != generation)
					break;
				loaded->prepared.emplace_back(path, PrepareIconTexture(texture));
				texture.pixels.clear();
				texture.pixels.shrink_to_fit();
				texture.lowerMips.clear();
			}
		}
		const double read = Since(started);
		std::lock_guard<std::mutex> hold(g_lock);
		if (g_generation == generation)
		{
			g_geometryMs = geometry;
			g_readMs = read;
			g_arrived = std::move(loaded);
		}
	}).detach();
}

void ModelViewAnimation(int animation)
{
	const int from = g_animation.exchange(animation);
	if (from == animation)
		return;
	// Where he's got to in the stance he's leaving, once what led into it has played
	float fromTime = 0.f;
	if (g_boneFrames > 1 && g_boneDuration > 0.f)
	{
		// The loop starts part way into its clip, where the lead in went to
		const float seconds = std::chrono::duration<float>(std::chrono::steady_clock::now() - g_boneStart).count() - g_boneIntro / kBakedIntroRate;
		fromTime = fmodf(std::max(0.f, seconds) + g_boneLoopStart, g_boneDuration);
	}
	const unsigned asked = ++g_animationAsked;
	std::shared_ptr<const void> slots;
	{
		std::lock_guard<std::mutex> hold(g_lock);
		slots = g_boneSlotsShared;
	}
	if (!slots)
		return;
	std::thread([slots, animation, asked, from, fromTime]
	{
		try
		{
			auto baked = BakeAnimation(slots, animation, from, fromTime);
			std::lock_guard<std::mutex> hold(g_lock);
			if (baked && g_animationAsked == asked)
				g_animationArrived = std::move(baked);
		}
		catch (const std::exception& problem)
		{
			Log("item models: baking an animation: %s", problem.what());
		}
	}).detach();
}

bool ModelViewFormClock(int& phase, float& seconds)
{
	if (g_state != kModelReady || g_formTimes[3] <= 0.f)
		return false;
	const float t = fmodf(FormSeconds(), g_formTimes[3]);
	const float hold = g_formTimes[0], change = g_formTimes[1], second = g_formTimes[2];
	if (t < hold) { phase = 0; seconds = hold - t; }
	else if (t < hold + change) { phase = 1; seconds = hold + change - t; }
	else if (t < hold + change + second) { phase = 2; seconds = hold + change + second - t; }
	else { phase = 3; seconds = g_formTimes[3] - t; }
	return true;
}

ModelState ModelViewState()
{
	return g_keepShowing ? kModelReady : static_cast<ModelState>(g_state.load());
}

void ModelViewShow(float yawDegrees, float pitchDegrees, float zoom, float panX, float panY)
{
	g_yaw = yawDegrees;
	g_pitch = pitchDegrees;
	g_zoom = std::clamp(zoom, 0.25f, 8.f);
	g_panX = panX;
	g_panY = panY;
	g_showThisFrame = true;
}

float ModelViewAspect()
{
	return static_cast<float>(kWidth) / kHeight;
}

unsigned long long ModelViewTexture()
{
	return g_drawnOnce && (g_state == kModelReady || g_keepShowing) ? g_pictureView : 0;
}

void ModelViewFitAspect(float aspect)
{
	g_fitAspect = std::clamp(aspect, 0.25f, static_cast<float>(kWidth) / kHeight);
}

void ModelViewBook(const float sheet[4], const float sheet2[4], const float shut[4])
{
	std::lock_guard<std::mutex> hold(g_bookLock);
	memcpy(g_bookSheet, sheet, sizeof(g_bookSheet));
	memcpy(g_bookSheet2, sheet2, sizeof(g_bookSheet2));
	memcpy(g_bookShut, shut, sizeof(g_bookShut));
}

void ModelViewReplaceTexture(const std::string& name, const GameTexture& picture)
{
	std::shared_ptr<PreparedTexture> prepared = PrepareIconTexture(picture);
	if (!prepared)
		return;
	std::lock_guard<std::mutex> hold(g_bookLock);
	for (auto& item : g_replacements)
		if (item.first == name)
		{
			item.second = std::move(prepared);
			return;
		}
	g_replacements.emplace_back(name, std::move(prepared));
}

void ModelViewRender(ID3D12GraphicsCommandList* list)
{
	const bool show = g_showThisFrame;
	g_showThisFrame = false;
	if (g_failed)
	{
		g_state = kModelMissing;   // a later item asked for can't load either
		return;
	}

	// What's arrived: the old one goes, this one starts up
	std::shared_ptr<Loaded> arrived;
	{
		std::lock_guard<std::mutex> hold(g_lock);
		arrived = std::move(g_arrived);
		g_arrived.reset();
	}
	if (arrived)
	{
		list->GetDevice(IID_PPV_ARGS(&g_device));
		if (!g_root && !MakePipeline())
			return;
		if (!g_many && !MakeTargets())
			return;
		LetGoOfModel();
		g_uploaded.clear();
		if (arrived->ok)
		{
			const auto sendStarted = Clock::now();
			g_uploading = arrived;
			std::vector<std::shared_ptr<PreparedTexture>> textures;
			for (const auto& item : arrived->prepared)
				textures.push_back(item.second);
			std::vector<unsigned long long> views;
			SubmitIconTextures(textures, views);
			for (size_t i = 0; i < views.size(); ++i)
				if (views[i])
				{
					g_uploaded[arrived->prepared[i].first] = views[i];
					g_ownTextures.push_back(views[i]);
				}
			const size_t count = views.size();
			arrived->prepared.clear();
			const double sent = Since(sendStarted);
			FinishUpload();
			{
				PROCESS_MEMORY_COUNTERS_EX memory{};
				memory.cb = sizeof(memory);
				if (K32GetProcessMemoryInfo(GetCurrentProcess(), reinterpret_cast<PROCESS_MEMORY_COUNTERS*>(&memory), sizeof(memory)))
					Log("memory: %.0f MB private, %.0f MB in use", memory.PrivateUsage / 1048576.0, memory.WorkingSetSize / 1048576.0);
			}
			Log("item models: ready in %.0f ms: files %.0f ms (geometry %.0f), %zu textures sent in %.1f ms", Since(g_asked), g_readMs, g_geometryMs, count, sent);
		}
		else
		{
			g_uploading.reset();
			g_state = kModelMissing;
		}
		g_keepShowing = false;
	}
	// Another stance for him: its table takes over, and the old one goes when the card's done with it
	std::shared_ptr<const BakedAnimation> stance;
	{
		std::lock_guard<std::mutex> hold(g_lock);
		stance = std::move(g_animationArrived);
		g_animationArrived.reset();
	}
	if (stance && g_boneTable && g_boneFrames > 1 && g_device)
	{
		if (ID3D12Resource* table = MakeBuffer(stance->rows.data(), stance->rows.size() * sizeof(float)))
		{
			// What's playing now is what it fades from. One already fading out goes.
			if (g_fromTable)
				RetireResource(g_fromTable);
			g_animationFrom = g_animationNow;
			g_animationNow = stance;
			g_fromTable = g_boneTable;
			g_fromFrames = g_boneFrames;
			g_fromSlots = g_boneSlots;
			g_fromDuration = g_boneDuration;
			g_fromIntro = g_boneIntro;
			g_fromStart = g_boneStart;
			g_fadeStart = std::chrono::steady_clock::now();
			g_boneTable = table;
			g_boneFrames = stance->frames;
			g_boneIntro = stance->introFrames;
			g_boneSlots = stance->slots;
			g_boneDuration = stance->duration;
			g_boneLoopStart = stance->loopStart;
			g_boneStart = std::chrono::steady_clock::now();
		}
	}
	// Pictures put in place of a part's own (the Library's book, as its pages turn)
	{
		std::vector<std::pair<std::string, std::shared_ptr<PreparedTexture>>> replacing;
		{
			std::lock_guard<std::mutex> hold(g_bookLock);
			replacing.swap(g_replacements);
		}
		if (!replacing.empty() && !g_parts.empty())
		{
			std::vector<std::shared_ptr<PreparedTexture>> textures;
			for (const auto& item : replacing)
				textures.push_back(item.second);
			std::vector<unsigned long long> views;
			SubmitIconTextures(textures, views);
			for (size_t i = 0; i < views.size() && i < replacing.size(); ++i)
			{
				if (!views[i])
					continue;
				bool used = false;
				for (size_t k = 0; k < g_parts.size(); ++k)
					if (g_partDiffuse[k] == replacing[i].first)
					{
						const unsigned long long old = g_parts[k].diffuse;
						g_parts[k].diffuse = views[i];
						used = true;
						bool shared = false;
						for (const GpuPart& other : g_parts)
							shared = shared || other.diffuse == old;
						const auto owned = std::find(g_ownTextures.begin(), g_ownTextures.end(), old);
						if (!shared && owned != g_ownTextures.end())
						{
							RetireIconTexture(old);
							g_ownTextures.erase(owned);
						}
					}
				if (used)
					g_ownTextures.push_back(views[i]);
				else
					RetireIconTexture(views[i]);
			}
		}
	}

	if (!show || (g_state != kModelReady && !g_keepShowing) || g_parts.empty() || !g_pipeline)
		return;

	// Into the picture
	D3D12_RESOURCE_BARRIER barrier{};
	barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
	barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

	const D3D12_CPU_DESCRIPTOR_HANDLE rtv = g_rtv->GetCPUDescriptorHandleForHeapStart(), dsv = g_dsv->GetCPUDescriptorHandleForHeapStart();
	list->OMSetRenderTargets(1, &rtv, FALSE, &dsv);
	const float clear[4] = { 0.f, 0.f, 0.f, 0.f };
	list->ClearRenderTargetView(rtv, clear, 0, nullptr);
	list->ClearDepthStencilView(dsv, D3D12_CLEAR_FLAG_DEPTH, 1.f, 0, 0, nullptr);
	const D3D12_VIEWPORT viewport{ 0.f, 0.f, static_cast<float>(kWidth), static_cast<float>(kHeight), 0.f, 1.f };
	const D3D12_RECT scissor{ 0, 0, static_cast<LONG>(kWidth), static_cast<LONG>(kHeight) };
	list->RSSetViewports(1, &viewport);
	list->RSSetScissorRects(1, &scissor);
	list->SetGraphicsRootSignature(g_root);
	list->SetPipelineState(g_pipeline);
	list->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
	const D3D12_VERTEX_BUFFER_VIEW streams[4] = { g_vertexView, g_skinView, g_clothView, g_shutView };
	list->IASetVertexBuffers(0, 4, streams);
	list->SetGraphicsRootShaderResourceView(8, g_boneTable->GetGPUVirtualAddress());
	list->IASetIndexBuffer(&g_indexView);

	// Row vectors. To its middle, its long axis up, turned, then: the game's z up to the screen's y, its y into the screen.
	Constants c{};
	{
		std::lock_guard<std::mutex> hold(g_bookLock);
		memcpy(c.sheet, g_bookSheet, sizeof(c.sheet));
		memcpy(c.sheet2, g_bookSheet2, sizeof(c.sheet2));
		memcpy(c.shut, g_bookShut, sizeof(c.shut));
	}
	if (!g_modelIsBook)
	{
		c.sheet[3] = 0.f;
		c.shut[0] = 0.f;
	}
	// How far a two-form creature has turned, by where its loop is: the first, changing, the second, changing back
	if (g_formTimes[3] > 0.f)
	{
		const float t = fmodf(FormSeconds(), g_formTimes[3]);
		const float hold = g_formTimes[0], change = std::max(0.01f, g_formTimes[1]), second = g_formTimes[2];
		c.eyeAndMask[1] = t < hold ? 0.f : t < hold + change ? (t - hold) / change : t < hold + change + second ? 1.f : std::max(0.f, 1.f - (t - hold - change - second) / change);
	}
	// A two-form creature is framed as the form it's showing: from the middle of one to the other's as it changes
	const bool twoForms = g_formTimes[3] > 0.f && !g_fitForm.empty();
	float centre[3] = { g_centre[0], g_centre[1], g_centre[2] };
	if (twoForms)
		for (int k = 0; k < 3; ++k)
			centre[k] = g_formCentre[0][k] + (g_formCentre[1][k] - g_formCentre[0][k]) * c.eyeAndMask[1];
	float m[16] = { 1,0,0,0, 0,1,0,0, 0,0,1,0, -centre[0],-centre[1],-centre[2],1 };
	if (g_longAxis != 2)
	{
		// A turn of the long axis onto z
		const float up[16] = { 0,0,1,0, 0,1,0,0, -1,0,0,0, 0,0,0,1 };
		const float upY[16] = { 1,0,0,0, 0,0,1,0, 0,-1,0,0, 0,0,0,1 };
		Multiply(m, g_longAxis == 0 ? up : upY, m);
	}
	const float yaw = (g_yaw + g_faceYaw) * 3.14159265f / 180.f, pitch = g_pitch * 3.14159265f / 180.f;
	const float cy = cosf(yaw), sy = sinf(yaw), cp = cosf(pitch), sp = sinf(pitch);
	const float turn[16] = { cy,sy,0,0, -sy,cy,0,0, 0,0,1,0, 0,0,0,1 };
	const float tip[16] = { 1,0,0,0, 0,cp,sp,0, 0,-sp,cp,0, 0,0,0,1 };
	const float toView[16] = { 1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1 };
	Multiply(m, turn, m);
	Multiply(m, tip, m);
	Multiply(m, toView, m);
	memcpy(c.world, m, sizeof(m));

	constexpr float kFov = 26.f * 3.14159265f / 180.f;
	const float f = 1.f / tanf(kFov * 0.5f);
	const float whole = g_radius / sinf(kFov * 0.5f) * 1.04f;   // far enough back for it to turn any way and stay in
	float eye = whole;
	if (!g_fitPoints.empty() && g_modelIsBook)
	{
		// The book: centred on what's seen from here, and as close as lets all of it into the picture's shape, the panel's
		// square or the enlarged view's whole width. Eased as a creature's is, so a turn by hand doesn't jump.
		float low[2] = { FLT_MAX, FLT_MAX }, high[2] = { -FLT_MAX, -FLT_MAX };
		std::vector<float> seen(g_fitPoints.size());
		// Shutting, it's framed as it is now, its front half up in the air
		const bool shutting = c.shut[0] > 0.f && g_fitShut.size() * 3 == g_fitPoints.size();
		for (size_t i = 0; i + 2 < g_fitPoints.size(); i += 3)
		{
			float p[3] = { g_fitPoints[i], g_fitPoints[i + 1], g_fitPoints[i + 2] };
			if (shutting)
			{
				const uint8_t role = g_fitRole[i / 3];
				if (role == 3 || role == 4)
					p[0] = p[1] = p[2] = 0.f;   // the leaf, folded away
				else
				{
					for (int k = 0; k < 3; ++k)
						p[k] += g_centre[k];
					PoseShut(c.shut, c.sheet, c.sheet2, g_fitShut[i / 3], role, p);
					for (int k = 0; k < 3; ++k)
						p[k] -= g_centre[k];
				}
			}
			for (int col = 0; col < 3; ++col)
			{
				seen[i + col] = 0.f;
				for (int row = 0; row < 3; ++row)
					seen[i + col] += p[row] * m[row * 4 + col];
			}
			for (int k = 0; k < 2; ++k)
			{
				low[k] = std::min(low[k], seen[i + k]);
				high[k] = std::max(high[k], seen[i + k]);
			}
		}
		const float mid[2] = { (low[0] + high[0]) * 0.5f, (low[1] + high[1]) * 0.5f };
		c.world[12] -= mid[0];
		c.world[13] -= mid[1];
		const float wide = g_fitAspect;
		float needs = 0.f;
		for (size_t i = 0; i + 2 < seen.size(); i += 3)
			needs = std::max(needs, std::max(fabsf(seen[i] - mid[0]) / wide, fabsf(seen[i + 1] - mid[1])) * f * 1.04f - seen[i + 2]);
		const auto at = std::chrono::steady_clock::now();
		const float since = g_fitEye < 0.f ? 1.f : std::min(0.25f, std::chrono::duration<float>(at - g_fitLast).count());
		g_fitLast = at;
		g_fitEye = g_fitEye < 0.f ? needs : g_fitEye + (needs - g_fitEye) * (1.f - expf(-since * 6.f));
		if (shutting)
			g_fitEye = std::max(g_fitEye, needs);   // shutting, back at once for the cover as it rises, in again eased
		eye = g_fitEye;
	}
	else if (!g_fitPoints.empty())
	{
		// Each point in the picture, with room for where the idle takes it past how it starts. The camera's at -eye in z.
		constexpr float kRoom = 1.06f;
		float formNeeds[2] = {};
		for (size_t i = 0; i + 2 < g_fitPoints.size(); i += 3)
		{
			float p[4] = { g_fitPoints[i] + g_centre[0] - centre[0], g_fitPoints[i + 1] + g_centre[1] - centre[1], g_fitPoints[i + 2] + g_centre[2] - centre[2], 1.f }, q[4] = {};
			for (int col = 0; col < 3; ++col)
				for (int row = 0; row < 3; ++row)
					q[col] += p[row] * m[row * 4 + col];
			const float across = std::max(fabsf(q[0]), fabsf(q[1]));
			const int form = twoForms && g_fitForm[i / 3] ? 1 : 0;
			formNeeds[form] = std::max(formNeeds[form], across * f * kRoom - q[2]);
		}
		// One form: what it needs. Two: what the one showing needs, moving to the other's as it changes.
		float needs = twoForms ? formNeeds[0] + (formNeeds[1] - formNeeds[0]) * c.eyeAndMask[1] : formNeeds[0];
		// Not so close a turn brings it in and out by much more than half, and eased, so a long one breathes as it turns
		needs = std::max(needs, whole * 0.5f);
		const auto at = std::chrono::steady_clock::now();
		const float since = g_fitEye < 0.f ? 1.f : std::min(0.25f, std::chrono::duration<float>(at - g_fitLast).count());
		g_fitLast = at;
		g_fitEye = g_fitEye < 0.f ? needs : g_fitEye + (needs - g_fitEye) * (1.f - expf(-since * (needs > g_fitEye ? 5.f : 1.8f)));
		eye = g_fitEye;
	}
	eye /= g_zoom;
	// Moved across the picture after it's framed: half the picture's width at the model's distance is eye / f
	c.world[12] += g_panX * eye / f;
	c.world[13] -= g_panY * eye / f;
	const float nearZ = std::max(0.01f, eye - g_radius * 1.5f), farZ = eye + g_radius * 1.5f;
	c.projection[0] = f * kHeight / kWidth;   // wider than tall: the same scale up and down, more room across
	c.projection[1] = f;
	c.projection[2] = farZ / (farZ - nearZ);
	c.projection[3] = -nearZ * farZ / (farZ - nearZ);
	c.eyeAndMask[2] = eye;
	const auto now = std::chrono::steady_clock::now();
	const auto poseAt = [&](std::chrono::steady_clock::time_point start, float duration, uint32_t frames, uint32_t intro, uint32_t slots, float* to)
	{
		if (frames < intro + 2 || duration <= 0.f)
			return;
		const float seconds = std::chrono::duration<float>(now - start).count();
		const float introSeconds = intro / kBakedIntroRate;
		float at;
		if (seconds < introSeconds)
			at = seconds * kBakedIntroRate;   // leading in: on into the first frame of what loops
		else
			at = intro + fmodf(seconds - introSeconds, duration) / duration * static_cast<float>(frames - intro - 1);
		const uint32_t frame = std::min(static_cast<uint32_t>(at), frames - 2);
		to[0] = static_cast<float>(frame * slots);
		to[1] = static_cast<float>((frame + 1) * slots);
		to[2] = at - static_cast<float>(frame);
	};
	poseAt(g_boneStart, g_boneDuration, g_boneFrames, g_boneIntro, g_boneSlots, c.pose);
	c.fromPose[3] = 1.f;
	if (g_fromTable)
	{
		const float t = std::chrono::duration<float>(now - g_fadeStart).count() / kStanceFadeSeconds;
		if (t >= 1.f)
		{
			RetireResource(g_fromTable);
			g_fromTable = nullptr;
			g_animationFrom.reset();
		}
		else
		{
			poseAt(g_fromStart, g_fromDuration, g_fromFrames, g_fromIntro, g_fromSlots, c.fromPose);
			c.fromPose[3] = t * t * (3.f - 2.f * t);
		}
	}
	list->SetGraphicsRootShaderResourceView(9, (g_fromTable ? g_fromTable : g_boneTable)->GetGPUVirtualAddress());

	// The cloth: this frame's pose to work on, and the newest it's finished. It's worked out apart, so it can't hold a frame up.
	const bool clothOn = g_clothBytes > 0 && g_clothRing[g_clothAt] && GetSettings().clothSim;
	if (clothOn)
	{
		const float since = std::chrono::duration<float>(now - g_clothLastAt).count();
		ClothPoseSample sample;
		sample.now = g_animationNow;
		sample.from = g_animationFrom;
		for (int i = 0; i < 3; ++i)
		{
			sample.pose[i] = c.pose[i];
			sample.fromPose[i] = c.fromPose[i];
		}
		sample.fade = c.fromPose[3];
		if (since > 0.f)
			sample.spin = std::clamp((g_yaw - g_clothLastYaw) * 3.14159265f / 180.f / since, -12.f, 12.f);
		g_clothLastYaw = g_yaw;
		g_clothLastAt = now;
		ClothFeed(sample);
		const int next = (g_clothAt + 1) % kClothRing;
		if (g_clothMapped[next] && ClothLatest(g_clothMapped[next], g_clothBytes, g_clothSeen))
			g_clothAt = next;
		c.eyeAndMask[0] = 1.f;
	}
	list->SetGraphicsRootShaderResourceView(10, (clothOn ? g_clothRing[g_clothAt] : g_boneTable)->GetGPUVirtualAddress());

	for (size_t index = 0; index < g_parts.size(); ++index)
	{
		const GpuPart& part = g_parts[index];
		c.eyeAndMask[3] = part.masked ? part.maskAt : 0.f;
		list->SetGraphicsRoot32BitConstants(0, sizeof(Constants) / 4, &c, 0);
		list->SetGraphicsRootConstantBufferView(1, g_materials->GetGPUVirtualAddress() + index * kMaterialStride);
		list->SetGraphicsRootDescriptorTable(2, D3D12_GPU_DESCRIPTOR_HANDLE{ part.diffuse });
		list->SetGraphicsRootDescriptorTable(3, D3D12_GPU_DESCRIPTOR_HANDLE{ part.normal });
		list->SetGraphicsRootDescriptorTable(4, D3D12_GPU_DESCRIPTOR_HANDLE{ part.tint });
		list->SetGraphicsRootDescriptorTable(5, D3D12_GPU_DESCRIPTOR_HANDLE{ part.specular });
		list->SetGraphicsRootDescriptorTable(6, D3D12_GPU_DESCRIPTOR_HANDLE{ part.detail1 });
		list->SetGraphicsRootDescriptorTable(7, D3D12_GPU_DESCRIPTOR_HANDLE{ part.detail2 });
		list->DrawIndexedInstanced(part.indexCount, 1, part.firstIndex, part.baseVertex, 0);
	}
	// A two-form creature's smoke, from a moment before each change begins until it's thinned away
	if (g_smokePipeline && g_formTimes[3] > 0.f)
	{
		const float cycle = g_formTimes[3];
		// Since the last burst there's really been: the change back's smoke runs on into the next loop, but not into the
		// first, as nothing changed back before it was shown
		const float elapsed = FormSeconds();
		float since = FLT_MAX;
		for (const float start : { g_formTimes[0] - 0.35f, g_formTimes[0] + g_formTimes[1] + g_formTimes[2] - 0.35f })
			if (elapsed >= start)
				since = std::min(since, fmodf(elapsed - start, cycle));
		if (since < 4.f)
		{
			Constants smoke = c;
			constexpr UINT kPuffs = 260;
			smoke.pose[0] = since;
			smoke.pose[1] = g_formSize;
			smoke.pose[2] = static_cast<float>(kPuffs);
			memcpy(smoke.fromPose, g_formFeet, sizeof(g_formFeet));
			list->SetPipelineState(g_smokePipeline);
			list->SetGraphicsRoot32BitConstants(0, sizeof(Constants) / 4, &smoke, 0);
			list->DrawInstanced(6, kPuffs, 0, 0);
		}
	}

	D3D12_RESOURCE_BARRIER to[2] = { barrier, barrier };
	to[0].Transition.pResource = g_many;
	to[0].Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
	to[0].Transition.StateAfter = D3D12_RESOURCE_STATE_RESOLVE_SOURCE;
	to[1].Transition.pResource = g_picture;
	to[1].Transition.StateBefore = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
	to[1].Transition.StateAfter = D3D12_RESOURCE_STATE_RESOLVE_DEST;
	list->ResourceBarrier(2, to);
	list->ResolveSubresource(g_picture, 0, g_many, 0, kColour);
	std::swap(to[0].Transition.StateBefore, to[0].Transition.StateAfter);
	std::swap(to[1].Transition.StateBefore, to[1].Transition.StateAfter);
	list->ResourceBarrier(2, to);
	g_drawnOnce = true;
}
