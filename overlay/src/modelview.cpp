#include "modelview.h"
#include <windows.h>
#include <psapi.h>
#include <d3d12.h>
#include <d3dcompiler.h>
#include <algorithm>
#include <iterator>
#include <atomic>
#include <chrono>
#include <cmath>
#include <cstring>
#include <map>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>
#include "gameicons.h"
#include <exception>
#include "itemmodel.h"
#include "log.h"
#include "overlay.h"
#include "settings.h"

namespace
{
	constexpr UINT kSize = 1408;   // large enough for the enlarged view, drawn smaller in the panel
	constexpr DXGI_FORMAT kColour = DXGI_FORMAT_R8G8B8A8_UNORM, kDepth = DXGI_FORMAT_D32_FLOAT;
	constexpr UINT kSamples = 4;

	// Lit from the viewer's side, so the item turns under the light. The material as the game's pbr_std has it:
	// roughness in the normal map's alpha, the normal's z worked out. (Workbench: Rendering/Shaders/psW3Mesh.hlsl)
	const char kShader[] = R"(
cbuffer View : register(b0)
{
	row_major float4x4 world;
	float4 projection;   // x, y scale; z, w depth
	float4 eyeAndMask;   // z: how far back the eye is, w: alpha tested
	float4 pose;         // where this frame and the next start in the bones' table, and how far between them
	float4 fromPose;     // the same in the stance it's fading from; w: how far it's come, 1 is all the new one
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
};
Texture2D diffuseMap : register(t0);
Texture2D normalMap : register(t1);
Texture2D tintMap : register(t2);
Texture2D specularMap : register(t3);
Texture2D detail1Map : register(t4);
Texture2D detail2Map : register(t5);
SamplerState surface : register(s0);

struct In { float3 p : POSITION; float3 n : NORMAL; float4 t : TANGENT; float2 uv : TEXCOORD; float4 colour : COLOR; uint4 bones : BLENDINDICES; float4 weights : BLENDWEIGHT; uint3 clothAt : CLOTHINDEX; float3 clothBary : CLOTHBARY; };
struct Out { float4 h : SV_Position; float3 p : POSITION; float3 n : NORMAL; float3 t : TANGENT; float3 b : BINORMAL; float2 uv : TEXCOORD; float4 colour : COLOR; };

Out VS(In i)
{
	Out o;
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

float4 PS(Out i, bool front : SV_IsFrontFace) : SV_Target
{
	const float4 d = diffuseMap.Sample(surface, i.uv);
	if (eyeAndMask.w > 0 && d.a < eyeAndMask.w)
		discard;
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
	return float4(pow(c, 1 / 2.2f), alpha);
}
)";

	struct Constants { float world[16]; float projection[4]; float eyeAndMask[4]; float pose[4]; float fromPose[4]; };

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
	std::chrono::steady_clock::time_point g_boneStart;
	std::shared_ptr<const void> g_boneSlotsShared;
	// Cloth: what carries each vertex, the particles' places on the card, a few frames' worth so one isn't written while it's drawn
	constexpr int kClothRing = 4;
	ID3D12Resource* g_clothVertices = nullptr;
	D3D12_VERTEX_BUFFER_VIEW g_clothView{};
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
		float detail[4], detail2[4], options[4], ghost[4];
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
	std::vector<unsigned long long> g_ownTextures;
	float g_centre[3] = {}, g_radius = 1.f;
	int g_longAxis = 2;
	float g_faceYaw = 0.f;   // a blade's flat side to the viewer when it's not turned
	// A creature's shape as it stands, from its middle, a sample of its points: it's framed by what it shows at the angle it's
	// seen from, as a wyvern's tail is end on from the front and its whole length from the side. Empty for an item.
	std::vector<float> g_fitPoints;
	float g_fitEye = -1.f;   // how far back the camera is now, easing to what the angle needs; -1 for at once
	std::chrono::steady_clock::time_point g_fitLast{};
	float g_zoom = 1.f;

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
		return true;
	}

	bool MakeTargets()
	{
		D3D12_HEAP_PROPERTIES heap{ D3D12_HEAP_TYPE_DEFAULT };
		D3D12_RESOURCE_DESC desc{};
		desc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;
		desc.Width = desc.Height = kSize;
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

	// All of it's on the card: put it together
	void FinishUpload()
	{
		const ItemModel& model = g_uploading->model;
		std::vector<ModelVertex> vertices;
		std::vector<SkinVertex> skins;
		std::vector<uint32_t> indices;
		std::vector<ClothVertex> clothing;
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
				p.graph.rfind("pbr_hair", 0) == 0 ? 0.12f : 0.33f };
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
			values.options[2] = p.graph.rfind("pbr_hair", 0) == 0 ? 1.f : 0.f;
			values.options[3] = p.graph.rfind("pbr_spec_tint_mask", 0) == 0 ? 1.f : 0.f;
			for (int k = 0; k < 4; ++k)
				values.ghost[k] = p.ghost[k];
			detailRanges.push_back(p.detailRange);
			const size_t at = materialBytes.size();
			materialBytes.resize(at + kMaterialStride);
			memcpy(materialBytes.data() + at, &values, sizeof(values));
			g_parts.push_back(part);
			vertices.insert(vertices.end(), p.vertices.begin(), p.vertices.end());
			skins.resize(vertices.size());   // what isn't skinned stays where it is, in the table's first slot
			if (p.skinning.size() == p.vertices.size())
				std::copy(p.skinning.begin(), p.skinning.end(), skins.end() - static_cast<ptrdiff_t>(p.skinning.size()));
			clothing.resize(vertices.size());
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
		if (model.worn && !model.creature && !model.animation && !vertices.empty())
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
		if (!g_keepShowing)
			g_boneStart = std::chrono::steady_clock::now();
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
		g_fitEye = -1.f;
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
					for (int k = 0; k < 3; ++k)
						g_fitPoints.push_back(to[k] - g_centre[k]);
				}
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
								ReadGameTexture(*jobs[at].first, 1024, *jobs[at].second, true);
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
		const float seconds = std::chrono::duration<float>(std::chrono::steady_clock::now() - g_boneStart).count() - g_boneIntro / kBakedIntroRate;
		if (seconds > 0.f)
			fromTime = fmodf(seconds, g_boneDuration);
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

ModelState ModelViewState()
{
	return g_keepShowing ? kModelReady : static_cast<ModelState>(g_state.load());
}

void ModelViewShow(float yawDegrees, float pitchDegrees, float zoom)
{
	g_yaw = yawDegrees;
	g_pitch = pitchDegrees;
	g_zoom = std::clamp(zoom, 0.25f, 8.f);
	g_showThisFrame = true;
}

unsigned long long ModelViewTexture()
{
	return g_drawnOnce && (g_state == kModelReady || g_keepShowing) ? g_pictureView : 0;
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
			g_boneStart = std::chrono::steady_clock::now();
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
	const D3D12_VIEWPORT viewport{ 0.f, 0.f, static_cast<float>(kSize), static_cast<float>(kSize), 0.f, 1.f };
	const D3D12_RECT scissor{ 0, 0, static_cast<LONG>(kSize), static_cast<LONG>(kSize) };
	list->RSSetViewports(1, &viewport);
	list->RSSetScissorRects(1, &scissor);
	list->SetGraphicsRootSignature(g_root);
	list->SetPipelineState(g_pipeline);
	list->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
	const D3D12_VERTEX_BUFFER_VIEW streams[3] = { g_vertexView, g_skinView, g_clothView };
	list->IASetVertexBuffers(0, 3, streams);
	list->SetGraphicsRootShaderResourceView(8, g_boneTable->GetGPUVirtualAddress());
	list->IASetIndexBuffer(&g_indexView);

	// Row vectors. To its middle, its long axis up, turned, then: the game's z up to the screen's y, its y into the screen.
	Constants c{};
	float m[16] = { 1,0,0,0, 0,1,0,0, 0,0,1,0, -g_centre[0],-g_centre[1],-g_centre[2],1 };
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
	if (!g_fitPoints.empty())
	{
		// Each point in the picture, with room for where the idle takes it past how it starts. The camera's at -eye in z.
		constexpr float kRoom = 1.06f;
		float needs = 0.f;
		for (size_t i = 0; i + 2 < g_fitPoints.size(); i += 3)
		{
			float p[4] = { g_fitPoints[i], g_fitPoints[i + 1], g_fitPoints[i + 2], 1.f }, q[4] = {};
			for (int col = 0; col < 3; ++col)
				for (int row = 0; row < 3; ++row)
					q[col] += p[row] * m[row * 4 + col];
			const float across = std::max(fabsf(q[0]), fabsf(q[1]));
			needs = std::max(needs, across * f * kRoom - q[2]);
		}
		// Not so close a turn brings it in and out by much more than half, and eased, so a long one breathes as it turns
		needs = std::max(needs, whole * 0.5f);
		const auto at = std::chrono::steady_clock::now();
		const float since = g_fitEye < 0.f ? 1.f : std::min(0.25f, std::chrono::duration<float>(at - g_fitLast).count());
		g_fitLast = at;
		g_fitEye = g_fitEye < 0.f ? needs : g_fitEye + (needs - g_fitEye) * (1.f - expf(-since * (needs > g_fitEye ? 5.f : 1.8f)));
		eye = g_fitEye;
	}
	eye /= g_zoom;
	const float nearZ = std::max(0.01f, eye - g_radius * 1.5f), farZ = eye + g_radius * 1.5f;
	c.projection[0] = c.projection[1] = f;
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
