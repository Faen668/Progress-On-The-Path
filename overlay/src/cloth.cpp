// Cloth as the game simulates it: a port of W3 Mod Workbench's Core/Animation/ClothSimulation.cs, itself a port of the PhysX 3
// cloth solver APEX runs (NVIDIA's software solver, SwSolverKernel, BSD licensed), on the fabric APEX cooked for the piece.
// Each frame is split into iterations at the material's solver frequency. Each iteration moves the particles on, keeps each within
// its max distance of where it's skinned to, within its tethers, at the fabric's rest lengths, behind its backstop and out of the
// spheres on the bones. Self collision and virtual particles aren't simulated.
#include "cloth.h"

#include <algorithm>
#include <atomic>
#include <cfloat>
#include <cstring>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <mutex>
#include <thread>

#include "itemmodel.h"
#include "log.h"

namespace
{
	struct V3
	{
		float x = 0.f, y = 0.f, z = 0.f;
		V3 operator+(const V3& o) const { return { x + o.x, y + o.y, z + o.z }; }
		V3 operator-(const V3& o) const { return { x - o.x, y - o.y, z - o.z }; }
		V3 operator*(float s) const { return { x * s, y * s, z * s }; }
		V3& operator+=(const V3& o) { x += o.x; y += o.y; z += o.z; return *this; }
		V3& operator-=(const V3& o) { x -= o.x; y -= o.y; z -= o.z; return *this; }
		float LengthSq() const { return x * x + y * y + z * z; }
	};
	float Dot(const V3& a, const V3& b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
	V3 Cross(const V3& a, const V3& b) { return { a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x }; }
	V3 Lerp(const V3& a, const V3& b, float t) { return a + (b - a) * t; }
	V3 Normalized(const V3& a, const V3& otherwise)
	{
		const float sq = a.LengthSq();
		return sq > 1e-20f ? a * (1.f / std::sqrt(sq)) : otherwise;
	}

	constexpr float kEpsilon = 1.1920929e-7f;
	constexpr float kGravity = 9.81f;
	constexpr float kSettleSeconds = 1.f;
	constexpr float kBreeze = 0.12f;   // metres a second: a little air, so what's standing still isn't dead still

	float SafeLog2(float x)
	{
		const float saturated = std::clamp(x, 0.f, 1.f);
		return saturated > 0.f ? std::log2(saturated) : -128.f;
	}

	V3 Through(const float* rows, const V3& p)
	{
		return { rows[0] * p.x + rows[1] * p.y + rows[2] * p.z + rows[3],
			rows[4] * p.x + rows[5] * p.y + rows[6] * p.z + rows[7],
			rows[8] * p.x + rows[9] * p.y + rows[10] * p.z + rows[11] };
	}
	V3 TurnedBy(const float* rows, const V3& p)
	{
		return { rows[0] * p.x + rows[1] * p.y + rows[2] * p.z,
			rows[4] * p.x + rows[5] * p.y + rows[6] * p.z,
			rows[8] * p.x + rows[9] * p.y + rows[10] * p.z };
	}
}

class ClothSim
{
public:
	explicit ClothSim(std::shared_ptr<ClothData> data) : d(std::move(data))
	{
		count = d->particles;
		current.resize(count);
		previous.resize(count);
		weight.resize(count);
		fromTarget.resize(count);
		toTarget.resize(count);
		fromNormal.resize(count);
		toNormal.resize(count);
		normals.resize(count);
		bones.assign(d->slotOf.size() * 12, 0.f);
		backstops = std::any_of(d->backstopRadius.begin(), d->backstopRadius.end(), [](float r) { return r > 0.f; });
		const int spheres = static_cast<int>(d->spheres.size());
		fromSpheres.resize(spheres);
		toSpheres.resize(spheres);
		centres.resize(spheres);
		moves.resize(spheres);
		radii.resize(spheres);
		axes.resize(d->capsules.size() / 2);
		inverseLengths.resize(d->capsules.size() / 2);
	}

	// Each of its bones' matrix at this moment
	void PoseBones(const ClothPoseSample& s)
	{
		if (!s.now || d->slotOf.empty() || s.now->rows.empty())
			return;
		const size_t slots = d->slotOf.size();
		const float* now = s.now->rows.data();
		const size_t nowSize = s.now->rows.size();
		const float* from = s.from && s.fade < 1.f ? s.from->rows.data() : nullptr;
		const size_t fromSize = from ? s.from->rows.size() : 0;
		for (size_t b = 0; b < slots; ++b)
		{
			const size_t slot = static_cast<size_t>(d->slotOf[b]);
			float* to = bones.data() + b * 12;
			const size_t a0 = (static_cast<size_t>(s.pose[0]) + slot) * 12, a1 = (static_cast<size_t>(s.pose[1]) + slot) * 12;
			if (a0 + 12 > nowSize || a1 + 12 > nowSize)
				continue;
			for (int k = 0; k < 12; ++k)
				to[k] = now[a0 + k] + (now[a1 + k] - now[a0 + k]) * s.pose[2];
			if (from)
			{
				const size_t c0 = (static_cast<size_t>(s.fromPose[0]) + slot) * 12, c1 = (static_cast<size_t>(s.fromPose[1]) + slot) * 12;
				if (c0 + 12 <= fromSize && c1 + 12 <= fromSize)
					for (int k = 0; k < 12; ++k)
					{
						const float was = from[c0 + k] + (from[c1 + k] - from[c0 + k]) * s.fromPose[2];
						to[k] = was + (to[k] - was) * s.fade;
					}
			}
		}
	}

	void Reset()
	{
		Skin(toTarget, toNormal);
		SpheresAt(toSpheres);
		current = toTarget;
		previous = toTarget;
		started = true;
		flipNormals = false;
		ComputeNormals();
		float agree = 0.f;
		for (int i = 0; i < count; ++i)
			agree += Dot(normals[i], toNormal[i]);
		if (agree < 0.f)
		{
			flipNormals = true;
			ComputeNormals();
		}
	}

	void Settle(float seconds)
	{
		if (!started)
			Reset();
		frequencyLimit = 90.f;
		for (float t = 0.f; t < seconds; t += 1.f / 30.f)
			Step(1.f / 30.f, 0.f);
		frequencyLimit = 0.f;
	}

	void Step(float dt, float spin)
	{
		if (!started)
		{
			Reset();
			return;
		}
		fromTarget.swap(toTarget);
		fromNormal.swap(toNormal);
		fromSpheres.swap(toSpheres);
		Skin(toTarget, toNormal);
		SpheresAt(toSpheres);

		// A jump further than a body moves in a step is a teleport: the cloth goes with it, not dragged there
		V3 jump;
		for (int i = 0; i < count; ++i)
			jump += toTarget[i] - fromTarget[i];
		jump = jump * (1.f / std::max(1, count));
		if (std::sqrt(jump.LengthSq()) > std::max(0.3f, 15.f * dt))
		{
			for (int i = 0; i < count; ++i)
			{
				current[i] += jump;
				previous[i] += jump;
				fromTarget[i] += jump;
			}
			for (SphereNow& s : fromSpheres)
				s.centre += jump;
		}
		if (dt <= 0.f)
		{
			ComputeNormals();
			return;
		}
		dt = std::min(dt, 0.1f);

		const ClothMaterialValues& m = d->material;
		float frequency = std::max(1.f, m.solverFrequency);
		if (frequencyLimit > 0.f)
			frequency = std::min(frequency, frequencyLimit);
		const int iterations = std::max(1, static_cast<int>(dt * frequency + 0.5f));
		const float iterDt = dt / iterations;
		const float exponent = std::max(1e-3f, m.stiffnessFrequency) * iterDt;
		const float dampScale = std::pow(1.f - std::clamp(m.damping, 0.f, 0.999f), 10.f * iterDt);
		const float windDrag = 1.f - std::pow(1.f - std::clamp(std::max(m.drag, 0.1f), 0.f, 0.999f), 10.f * iterDt);
		const V3 gravity = V3{ d->gravity[0], d->gravity[1], d->gravity[2] } * (kGravity * m.gravityScale * iterDt * iterDt);
		MakePhases(exponent);
		const float bias = -m.maxDistanceBias;

		// A little air that comes and goes, and what he's being turned through
		clock += dt;
		const V3 breeze{ std::sin(clock * 0.7f) * kBreeze, std::cos(clock * 0.43f) * kBreeze, 0.f };
		const V3 air = breeze * iterDt;
		const float airSpin = spin * iterDt;

		for (int it = 0; it < iterations; ++it)
		{
			const float alpha = (it + 1.f) / iterations;
			Integrate(dampScale, gravity, air, airSpin, windDrag);
			ConstrainMotion(alpha, bias);
			ConstrainTethers(m);
			SolveFabric();
			if (backstops)
				ConstrainSeparation(alpha);
			Collide(alpha, alpha - 1.f / iterations, m);
		}
		ComputeNormals();
	}

	int Particles() const { return count; }

	void Write(float* out) const
	{
		for (int i = 0; i < count; ++i, out += kClothFloatsPerParticle)
		{
			out[0] = current[i].x;
			out[1] = current[i].y;
			out[2] = current[i].z;
			out[3] = 1.f;
			out[4] = normals[i].x;
			out[5] = normals[i].y;
			out[6] = normals[i].z;
			out[7] = 0.f;
		}
	}

private:
	struct SphereNow { V3 centre; float radius = 0.f; };
	struct Phase { int start, end; float stiffness, multiplier, compression, stretch; };

	std::shared_ptr<ClothData> d;
	int count = 0;
	std::vector<V3> current, previous, fromTarget, toTarget, fromNormal, toNormal, normals, centres, moves, axes;
	std::vector<float> weight, bones, radii, inverseLengths;
	std::vector<SphereNow> fromSpheres, toSpheres;
	std::vector<Phase> phases;
	bool started = false, flipNormals = false, backstops = false;
	float frequencyLimit = 0.f, clock = 0.f;

	bool HasBones() const { return d->bonesPerVertex > 0 && !d->slotOf.empty(); }

	void Skin(std::vector<V3>& positions, std::vector<V3>& outNormals) const
	{
		const int per = d->bonesPerVertex;
		const bool skinned = HasBones();
		const size_t boneCount = d->slotOf.size();
		for (int v = 0; v < count; ++v)
		{
			const V3 p{ d->positions[v * 3], d->positions[v * 3 + 1], d->positions[v * 3 + 2] };
			const V3 n{ d->normals[v * 3], d->normals[v * 3 + 1], d->normals[v * 3 + 2] };
			if (!skinned)
			{
				positions[v] = p;
				outNormals[v] = n;
				continue;
			}
			V3 sum, normal;
			float total = 0.f;
			for (int b = 0; b < per; ++b)
			{
				const float w = d->boneWeights[v * per + b];
				const size_t bone = d->boneIndices[v * per + b];
				if (w <= 0.f || bone >= boneCount)
					continue;
				const float* rows = bones.data() + bone * 12;
				sum += Through(rows, p) * w;
				normal += TurnedBy(rows, n) * w;
				total += w;
			}
			positions[v] = total > 0.f ? sum * (1.f / total) : p;
			outNormals[v] = Normalized(normal, n);
		}
	}

	void SpheresAt(std::vector<SphereNow>& out) const
	{
		const size_t binds = d->bindPoses.size() / 16;
		for (size_t i = 0; i < out.size(); ++i)
		{
			const ClothSphereValues& s = d->spheres[i];
			V3 at{ s.local[0], s.local[1], s.local[2] };
			if (s.bone >= 0 && static_cast<size_t>(s.bone) < binds)
			{
				// As bound: row vectors
				const float* m = d->bindPoses.data() + static_cast<size_t>(s.bone) * 16;
				at = { at.x * m[0] + at.y * m[4] + at.z * m[8] + m[12], at.x * m[1] + at.y * m[5] + at.z * m[9] + m[13], at.x * m[2] + at.y * m[6] + at.z * m[10] + m[14] };
			}
			if (HasBones() && s.bone >= 0 && static_cast<size_t>(s.bone) < d->slotOf.size())
				at = Through(bones.data() + static_cast<size_t>(s.bone) * 12, at);
			out[i].centre = at;
			out[i].radius = s.radius + d->thickness;
		}
	}

	void Integrate(float dampScale, const V3& gravity, const V3& air, float airSpin, float windDrag)
	{
		for (int i = 0; i < count; ++i)
		{
			const V3 now = current[i];
			weight[i] = d->inverseMasses[i];
			if (weight[i] > 0.f)
			{
				const V3 velocity = now - previous[i];
				// The air stands still while he's turned, so to him it goes the other way round
				const V3 wind{ air.x + now.y * airSpin, air.y - now.x * airSpin, air.z };
				current[i] = now + velocity * dampScale + gravity + (wind - velocity) * windDrag;
			}
			previous[i] = now;
		}
	}

	void ConstrainMotion(float alpha, float bias)
	{
		for (int i = 0; i < count; ++i)
		{
			const V3 delta = Lerp(fromTarget[i], toTarget[i], alpha) - current[i];
			const float radius = std::max(0.f, d->maxDistance[i] + bias);
			if (radius <= 0.f)
				weight[i] = 0.f;
			const float slack = 1.f - radius / std::sqrt(kEpsilon + delta.LengthSq());
			if (slack > 0.f)
				current[i] += delta * slack;
		}
	}

	void ConstrainTethers(const ClothMaterialValues& m)
	{
		const std::vector<int>& anchors = d->tetherAnchors;
		if (anchors.empty() || m.tetherStiffness <= 0.f)
			return;
		const float stiffness = static_cast<float>(count) * m.tetherStiffness / static_cast<float>(anchors.size());
		const int total = static_cast<int>(anchors.size());
		for (int i = 0; i < count; ++i)
		{
			const V3 position = current[i];
			V3 offset;
			for (int t = i; t < total; t += count)
			{
				const V3 delta = current[anchors[t]] - position;
				const float slack = 1.f - d->tetherLengths[t] * m.tetherLimit / std::sqrt(kEpsilon + delta.LengthSq());
				if (slack > 0.f)
					offset += delta * slack;
			}
			current[i] = position + offset * stiffness;
		}
	}

	void MakePhases(float exponent)
	{
		const ClothMaterialValues& m = d->material;
		phases.resize(d->phaseTypes.size());
		for (size_t p = 0; p < phases.size(); ++p)
		{
			const int kind = d->phaseTypes[p];
			const float stiffness = kind == 1 ? m.vertical : kind == 2 ? m.horizontal : kind == 3 ? m.bending : kind == 4 ? m.shearing : 1.f;
			const float* scaling = kind >= 1 && kind <= 4 ? m.scaling[kind - 1] : nullptr;
			const float compression = scaling ? scaling[0] : 1.f, stretch = scaling ? scaling[1] : 1.f, scale = scaling ? scaling[2] : 1.f;
			const int set = d->phaseSets[p];
			phases[p] = { d->setStarts[set], d->setStarts[set + 1],
				1.f - std::pow(2.f, SafeLog2(1.f - stiffness) * exponent),
				1.f - std::pow(2.f, SafeLog2(scale) * exponent),
				compression > 0.f ? 1.f - 1.f / compression : 0.f,
				stretch > 0.f ? 1.f - 1.f / stretch : 0.f };
		}
	}

	void SolveFabric()
	{
		const float* rest = d->restLengths.data();
		const int* pairs = d->pairs.data();
		for (const Phase& phase : phases)
		{
			const bool neutral = phase.multiplier == 0.f && phase.compression == 0.f && phase.stretch == 0.f;
			for (int c = phase.start; c < phase.end; ++c)
			{
				const int i = pairs[c * 2], j = pairs[c * 2 + 1];
				const float r = rest[c];
				if (r <= kEpsilon)
					continue;
				const V3 h = current[j] - current[i];
				const float wij = weight[i] + weight[j];
				float e = 1.f - r / std::sqrt(kEpsilon + h.LengthSq());
				if (!neutral)
					e -= phase.multiplier * std::max(phase.compression, std::min(e, phase.stretch));
				const float ex = e * phase.stiffness / (kEpsilon + wij);
				current[i] += h * (ex * weight[i]);
				current[j] -= h * (ex * weight[j]);
			}
		}
	}

	void ConstrainSeparation(float alpha)
	{
		for (int i = 0; i < count; ++i)
		{
			const float radius = d->backstopRadius[i];
			if (radius <= 0.f)
				continue;
			const V3 normal = Lerp(fromNormal[i], toNormal[i], alpha);
			const V3 centre = Lerp(fromTarget[i], toTarget[i], alpha) - normal * d->backstopDistance[i];
			const V3 delta = centre - current[i];
			const float slack = 1.f - radius / std::sqrt(kEpsilon + delta.LengthSq());
			if (slack < 0.f)
				current[i] += delta * slack;
		}
	}

	void Collide(float alpha, float previousAlpha, const ClothMaterialValues& m)
	{
		const size_t spheres = toSpheres.size();
		if (spheres == 0)
			return;
		V3 low{ FLT_MAX, FLT_MAX, FLT_MAX }, high{ -FLT_MAX, -FLT_MAX, -FLT_MAX };
		for (size_t s = 0; s < spheres; ++s)
		{
			const V3 now = Lerp(fromSpheres[s].centre, toSpheres[s].centre, alpha);
			const V3 before = Lerp(fromSpheres[s].centre, toSpheres[s].centre, std::max(0.f, previousAlpha));
			const float r = fromSpheres[s].radius + (toSpheres[s].radius - fromSpheres[s].radius) * alpha;
			centres[s] = now;
			moves[s] = now - before;
			radii[s] = r;
			low = { std::min(low.x, now.x - r), std::min(low.y, now.y - r), std::min(low.z, now.z - r) };
			high = { std::max(high.x, now.x + r), std::max(high.y, now.y + r), std::max(high.z, now.z + r) };
		}
		const size_t capsules = axes.size();
		const std::vector<int>& joined = d->capsules;
		for (size_t k = 0; k < capsules; ++k)
		{
			const V3 axis = centres[joined[k * 2 + 1]] - centres[joined[k * 2]];
			const float sq = axis.LengthSq();
			axes[k] = axis;
			inverseLengths[k] = sq < 1e-10f ? 0.f : 1.f / sq;
		}
		for (int i = 0; i < count; ++i)
		{
			if (d->inverseMasses[i] <= 0.f)
				continue;
			const V3 p = current[i];
			if (p.x < low.x || p.y < low.y || p.z < low.z || p.x > high.x || p.y > high.y || p.z > high.z)
				continue;
			V3 push, shapeMove;
			int collisions = 0;
			for (size_t s = 0; s < spheres; ++s)
			{
				const V3 delta = p - centres[s];
				const float r = radii[s], sq = delta.LengthSq();
				if (sq >= r * r || r <= 0.f)
					continue;
				const float length = std::sqrt(sq);
				push += length > 1e-6f ? delta * (r / length - 1.f) : V3{ 0.f, 0.f, r };
				shapeMove += moves[s];
				++collisions;
			}
			for (size_t k = 0; k < capsules; ++k)
			{
				if (inverseLengths[k] == 0.f)
					continue;
				const int a = joined[k * 2], b = joined[k * 2 + 1];
				const float t = Dot(p - centres[a], axes[k]) * inverseLengths[k];
				if (t <= 0.f || t >= 1.f)
					continue;
				const V3 delta = p - (centres[a] + axes[k] * t);
				const float r = radii[a] + (radii[b] - radii[a]) * t, sq = delta.LengthSq();
				if (sq >= r * r || sq < 1e-12f)
					continue;
				push += delta * (r / std::sqrt(sq) - 1.f);
				shapeMove += Lerp(moves[a], moves[b], t);
				++collisions;
			}
			if (collisions == 0)
				continue;
			const V3 delta = push * (1.f / collisions);
			if (m.friction > 0.f)
			{
				const float deltaSq = delta.LengthSq();
				const V3 n = delta * (1.f / std::sqrt(deltaSq + kEpsilon));
				const V3 relative = p - previous[i] - shapeMove * (1.f / collisions);
				const V3 tangent = relative - n * Dot(relative, n);
				const float j = std::max(-m.friction * deltaSq / std::sqrt(deltaSq + kEpsilon) / std::sqrt(tangent.LengthSq() + kEpsilon), -1.f);
				previous[i] -= tangent * j;
			}
			if (m.massScale > 0.f)
				weight[i] /= 1.f + m.massScale * delta.LengthSq();
			current[i] = p + delta;
		}
	}

	void ComputeNormals()
	{
		std::fill(normals.begin(), normals.end(), V3{});
		const std::vector<int>& t = d->triangles;
		for (size_t f = 0; f + 2 < t.size(); f += 3)
		{
			const int a = t[f], b = t[f + 1], c = t[f + 2];
			if (a >= count || b >= count || c >= count)
				continue;
			V3 face = Cross(current[b] - current[a], current[c] - current[a]);
			if (flipNormals)
				face = face * -1.f;
			normals[a] += face;
			normals[b] += face;
			normals[c] += face;
		}
		for (int i = 0; i < count; ++i)
			normals[i] = Normalized(normals[i], toNormal[i]);
	}
};

std::vector<std::shared_ptr<ClothSim>> MakeCloth(const std::vector<std::shared_ptr<ClothData>>& cloths, const std::shared_ptr<const BakedAnimation>& animation, std::vector<float>& out)
{
	std::vector<std::shared_ptr<ClothSim>> sims;
	ClothPoseSample start;
	start.now = animation;
	size_t particles = 0;
	for (const std::shared_ptr<ClothData>& cloth : cloths)
	{
		auto sim = std::make_shared<ClothSim>(cloth);
		sim->PoseBones(start);
		sim->Reset();
		sim->Settle(kSettleSeconds);
		particles += static_cast<size_t>(sim->Particles());
		sims.push_back(std::move(sim));
	}
	out.resize(particles * kClothFloatsPerParticle);
	float* at = out.data();
	for (const std::shared_ptr<ClothSim>& sim : sims)
	{
		sim->Write(at);
		at += static_cast<size_t>(sim->Particles()) * kClothFloatsPerParticle;
	}
	return sims;
}

namespace
{
	std::mutex g_runLock;
	std::condition_variable g_runWake;
	bool g_runnerStarted = false;
	std::vector<std::shared_ptr<ClothSim>> g_running;
	uint64_t g_runGeneration = 0;
	bool g_haveSample = false;
	ClothPoseSample g_sample;
	std::vector<float> g_published;
	uint64_t g_publishedVersion = 0;

	void RunnerLoop()
	{
		using Clock = std::chrono::steady_clock;
		std::vector<std::shared_ptr<ClothSim>> sims;
		uint64_t generation = 0;
		Clock::time_point last = Clock::now();
		std::vector<float> frame;
		for (;;)
		{
			ClothPoseSample sample;
			{
				std::unique_lock lock(g_runLock);
				g_runWake.wait(lock, [] { return g_haveSample; });
				g_haveSample = false;
				sample = g_sample;
				if (generation != g_runGeneration)
				{
					generation = g_runGeneration;
					sims = g_running;
					last = Clock::now();
				}
			}
			const Clock::time_point now = Clock::now();
			const float dt = std::chrono::duration<float>(now - last).count();
			last = now;
			size_t particles = 0;
			for (const std::shared_ptr<ClothSim>& sim : sims)
			{
				sim->PoseBones(sample);
				sim->Step(std::min(dt, 0.1f), sample.spin);
				particles += static_cast<size_t>(sim->Particles());
			}
			// What it costs, once in a while
			static int stepped = 0;
			static float spent = 0.f;
			spent += std::chrono::duration<float, std::milli>(Clock::now() - now).count();
			if (++stepped == 3600)
			{
				Log("cloth: %d pieces, %d particles, %.2f ms a frame on its own thread", static_cast<int>(sims.size()), static_cast<int>(particles), spent / stepped);
				stepped = 0;
				spent = 0.f;
			}
			frame.resize(particles * kClothFloatsPerParticle);
			float* at = frame.data();
			for (const std::shared_ptr<ClothSim>& sim : sims)
			{
				sim->Write(at);
				at += static_cast<size_t>(sim->Particles()) * kClothFloatsPerParticle;
			}
			std::lock_guard lock(g_runLock);
			if (generation == g_runGeneration)
			{
				g_published.swap(frame);
				++g_publishedVersion;
			}
		}
	}
}

void ClothRun(std::vector<std::shared_ptr<ClothSim>> sims)
{
	std::lock_guard lock(g_runLock);
	g_running = std::move(sims);
	++g_runGeneration;
	g_haveSample = false;
	if (!g_runnerStarted)
	{
		// Just the one: it waits for work for as long as the game runs, and goes with it
		g_runnerStarted = true;
		std::thread(RunnerLoop).detach();
	}
}

void ClothStop()
{
	std::lock_guard lock(g_runLock);
	g_running.clear();
	++g_runGeneration;
	g_haveSample = false;
}

void ClothFeed(const ClothPoseSample& sample)
{
	std::lock_guard lock(g_runLock);
	if (g_running.empty())
		return;
	g_sample = sample;
	g_haveSample = true;
	g_runWake.notify_one();
}

bool ClothLatest(void* to, size_t bytes, uint64_t& seen)
{
	std::lock_guard lock(g_runLock);
	if (g_publishedVersion == seen || g_published.size() * sizeof(float) != bytes)
		return false;
	memcpy(to, g_published.data(), bytes);
	seen = g_publishedVersion;
	return true;
}
