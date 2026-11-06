#pragma once
#include <cstdint>
#include <memory>
#include <vector>

struct BakedAnimation;

// What it takes to simulate a piece of cloth, read from its APEX clothing asset. (W3 Mod Workbench's Core/Meshes/ClothAsset.cs
// has what each field means and where it's kept.)
struct ClothMaterialValues
{
	float vertical = 1.f, horizontal = 1.f, bending = 0.5f, shearing = 0.5f;
	float tetherStiffness = 1.f, tetherLimit = 1.f;
	float scaling[4][3] = { { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 } };   // compression, stretch, scale
	float damping = 0.1f, stiffnessFrequency = 100.f, drag = 0.f, friction = 0.25f, massScale = 25.f;
	float solverFrequency = 250.f, gravityScale = 1.f, maxDistanceBias = 0.f;
};

struct ClothSphereValues { int bone; float radius; float local[3]; };

struct ClothData
{
	ClothMaterialValues material;
	float thickness = 0.f;
	float gravity[3] = { 0.f, 0.f, -1.f };

	// The physical mesh. Its first `particles` vertices are particles, the rest are only skinned.
	std::vector<float> positions, normals;   // three each
	std::vector<uint16_t> boneIndices;
	std::vector<float> boneWeights;
	int bonesPerVertex = 0;
	std::vector<float> maxDistance, backstopRadius, backstopDistance;
	std::vector<int> triangles;

	// The fabric
	int particles = 0;
	std::vector<int> phaseTypes, phaseSets, setStarts, pairs, tetherAnchors;
	std::vector<float> restLengths, tetherLengths, inverseMasses;

	// What the body pushes it with
	std::vector<ClothSphereValues> spheres;
	std::vector<int> capsules;
	std::vector<float> bindPoses;   // sixteen each, row vectors

	int meshBones = -1;           // in ItemModel::meshBones; -1: it hangs where it was read, with no bones
	std::vector<int> slotOf;      // each of its bones' place in the baked animation's rows
};

// Where a render vertex goes: on a triangle of particles, so far along their normal. a is kClothNone for one the cloth doesn't carry.
inline constexpr uint32_t kClothNone = 0xFFFFFFFFu;
struct ClothVertex
{
	uint32_t a = kClothNone, b = 0, c = 0;
	float bary[3] = { 0.f, 0.f, 0.f };
};

// Each particle as the card gets it: where it is, then its normal, each as four floats
inline constexpr size_t kClothFloatsPerParticle = 8;

class ClothSim;

struct ClothPoseSample
{
	std::shared_ptr<const BakedAnimation> now, from;
	float pose[3] = { 0.f, 0.f, 0.f };       // where this frame and the next start in the rows, and how far between them
	float fromPose[3] = { 0.f, 0.f, 0.f };
	float fade = 1.f;                        // how far it's come from `from`
	float spin = 0.f;                        // how fast the viewer's turning him, in radians a second
};

// Made and settled on the loading thread, with the first frame of its animation, so it shows at rest straight away.
// In the order given, and `out` gets what they start as.
std::vector<std::shared_ptr<ClothSim>> MakeCloth(const std::vector<std::shared_ptr<ClothData>>& cloths, const std::shared_ptr<const BakedAnimation>& animation, std::vector<float>& out);

// They go on a thread of their own from here on: it works out the next frame while the last is being drawn.
void ClothRun(std::vector<std::shared_ptr<ClothSim>> sims);
void ClothStop();
void ClothFeed(const ClothPoseSample& sample);
// The newest frame, if there's one newer than seen. False: what was copied last is still the newest.
bool ClothLatest(void* to, size_t bytes, uint64_t& seen);
