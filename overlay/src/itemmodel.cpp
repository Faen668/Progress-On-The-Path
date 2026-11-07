#include "itemmodel.h"
#include <windows.h>
#include <algorithm>
#include <atomic>
#include <cfloat>
#include <cmath>
#include <cstring>
#include <filesystem>
#include <list>
#include <map>
#include <memory>
#include <set>
#include <mutex>
#include <unordered_map>
#include <unordered_set>
#include "cardart.h"
#include "gameicons.h"
#include "log.h"

// Formats as the Workbench reads them (Core/Cr2w, Core/Entities/EntityFile.cs, Core/Meshes/MeshFile.cs, MeshMaterial.cs)
namespace
{
	uint32_t U32(const uint8_t* p) { uint32_t v; memcpy(&v, p, 4); return v; }
	int32_t I32(const uint8_t* p) { int32_t v; memcpy(&v, p, 4); return v; }
	uint16_t U16(const uint8_t* p) { uint16_t v; memcpy(&v, p, 2); return v; }
	float F32(const uint8_t* p) { float v; memcpy(&v, p, 4); return v; }

	std::string Lower(std::string s)
	{
		for (char& c : s)
			c = c == '/' ? '\\' : static_cast<char>(tolower(static_cast<unsigned char>(c)));
		return s;
	}

	uint64_t HashOf(const std::string& lowered)
	{
		uint64_t h = 0xcbf29ce484222325ull;
		for (const char c : lowered)
			h = (h ^ static_cast<uint8_t>(c)) * 0x100000001b3ull;
		return h;
	}

	bool Ends(const std::string& s, const char* tail)
	{
		const size_t n = strlen(tail);
		return s.size() >= n && s.compare(s.size() - n, n, tail) == 0;
	}

	// ---- the game's files: what's in which bundle, first found winning

	struct Located { uint32_t bundle; uint32_t size, packed, kind; uint64_t offset; };
	std::vector<std::wstring> g_bundles;
	std::unordered_map<uint64_t, Located> g_files;
	std::unordered_map<std::string, std::string> g_templates;   // a template's name, lowered, to its path
	std::vector<std::string> g_itemDefinitionFiles;             // the .xml files that can define items
	std::vector<std::string> g_journalFiles;                    // the .journal files, which hold quests among the rest
	std::vector<std::pair<std::string, uint32_t>> g_questTitles;   // each quest's base name and its title's string id
	std::atomic<bool> g_questTitlesReady{ false };

	// What the game's item definitions say about what Geralt wears
	// Another cut of an item for when certain things are worn with it, as the items' definitions give them: a category
	// (category="armor"), a list of categories, or items by name, all of them or any (all="true"). Hair is cut shorter
	// under a hood this way, and armour differently with gloves on.
	struct WornVariant
	{
		std::string equip, category;          // category: the one the attribute names
		std::vector<std::string> items, categories;   // lowered
		bool all = false;
		int Rank() const { return !items.empty() ? 2 : !categories.empty() ? 1 : 0; }   // the more particular, the more it counts
	};
	struct WornItem
	{
		std::string name, category, equipTemplate, slot;   // name and slot lowered; slot: the equip_slot it goes on, if any
		std::vector<WornVariant> variants;   // a mod's extensions first, then its own
		std::string bound;   // the item that comes with it: a sword's scabbard
	};
	std::unordered_map<std::string, WornItem> g_wornByName, g_wornByTemplate;   // lowered
	std::atomic<bool> g_ready{ false };

	void AddBundle(const std::wstring& path)
	{
		const HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
		if (file == INVALID_HANDLE_VALUE)
			return;
		uint8_t header[32];
		DWORD got = 0;
		if (ReadFile(file, header, 32, &got, nullptr) && got == 32 && memcmp(header, "POTATO70", 8) == 0 && (U16(header + 0x14) == 5 || U16(header + 0x14) == 3))
		{
			// Version 5 is the game's own, version 3 what older tools made, as many mods still are
			const bool older = U16(header + 0x14) == 3;
			const size_t kEntry = older ? 0x140 : 0x130;
			const size_t tocSize = U32(header + 0x10);
			std::vector<uint8_t> toc(tocSize);
			if (tocSize % kEntry == 0 && ReadFile(file, toc.data(), static_cast<DWORD>(tocSize), &got, nullptr) && got == tocSize)
			{
				const uint32_t bundle = static_cast<uint32_t>(g_bundles.size());
				g_bundles.push_back(path);
				for (size_t at = 0; at < tocSize; at += kEntry)
				{
					const uint8_t* e = toc.data() + at;
					std::string name = Lower(std::string(reinterpret_cast<const char*>(e), strnlen(reinterpret_cast<const char*>(e), 0x100)));
					const bool entity = Ends(name, ".w2ent");
					const bool itemFile = Ends(name, ".xml") && name.find("item") != std::string::npos;
					const bool journal = Ends(name, ".journal");
					if (itemFile)
						g_itemDefinitionFiles.push_back(name);
					if (journal)
						g_journalFiles.push_back(name);
					if (!entity && !itemFile && !journal && !Ends(name, ".w2mesh") && !Ends(name, ".w2mi") && !Ends(name, ".w2mg") && !Ends(name, ".buffer") && !Ends(name, ".redcloth") && !Ends(name, ".w2rig") && !Ends(name, ".w2anims") && !Ends(name, ".w3dyng"))
						continue;
					uint64_t offset = U32(e + 0x11C);
					if (!older)
						memcpy(&offset, e + 0x110, 8);
					g_files.emplace(HashOf(name), older ? Located{ bundle, U32(e + 0x114), U32(e + 0x118), U32(e + 0x13C), offset } : Located{ bundle, U32(e + 0x118), U32(e + 0x11C), U32(e + 0x124), offset });
					if (entity)
					{
						const size_t slash = name.find_last_of('\\');
						std::string stem = name.substr(slash == std::string::npos ? 0 : slash + 1);
						stem.resize(stem.size() - 6);
						g_templates.emplace(std::move(stem), name);
					}
				}
			}
		}
		CloseHandle(file);
	}

	bool UnpackEntry(const std::wstring& bundle, const Located& at, const std::string& path, std::vector<uint8_t>& out)
	{
		const HANDLE file = CreateFileW(bundle.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
		if (file == INVALID_HANDLE_VALUE)
			return false;
		std::vector<uint8_t> packed(at.packed);
		LARGE_INTEGER offset;
		offset.QuadPart = static_cast<LONGLONG>(at.offset);
		DWORD got = 0;
		const bool read = SetFilePointerEx(file, offset, nullptr, FILE_BEGIN) && ReadFile(file, packed.data(), at.packed, &got, nullptr) && got == at.packed;
		CloseHandle(file);
		if (!read)
			return false;
		switch (at.kind)
		{
		case 0:
			out = std::move(packed);
			return true;
		case 1:
			out.resize(at.size);
			return InflateGameData(packed.data(), packed.size(), out.data(), out.size());
		case 4: case 5:
			out.resize(at.size);
			if (UnpackLz4(packed.data(), packed.size(), out.data(), out.size()))
				return true;
			if (at.packed != at.size)
				return false;
			out = std::move(packed);   // stored as it is, despite what it says
			return true;
		default:
			Log("item models: %s is packed in a way that isn't handled (%u)", path.c_str(), at.kind);
			return false;
		}
	}

	bool ReadGameFile(const std::string& path, std::vector<uint8_t>& out)
	{
		std::string key = Lower(path);
		auto found = g_files.find(HashOf(key));
		// Remastered merged some DLC into the game, while files can still name its old folder
		if (found == g_files.end() && key.rfind("dlc\\", 0) == 0)
		{
			const size_t data = key.find("\\data\\");
			if (data != std::string::npos)
				found = g_files.find(HashOf(key.substr(data + 6)));
		}
		if (found == g_files.end())
			return false;
		return UnpackEntry(g_bundles[found->second.bundle], found->second, path, out);
	}

	// ---- CR2W

	struct RedExport { uint16_t className; int32_t parent; uint32_t size, offset; };
	struct RedBuffer { int32_t index; uint32_t offset, diskSize, memorySize; };

	struct Red
	{
		std::vector<uint8_t> data;
		std::vector<std::string> names, imports;
		std::vector<RedExport> exports;
		std::vector<RedBuffer> buffers;
		bool marker = true;

		const std::string& Name(int i) const
		{
			static const std::string none;
			return i >= 0 && i < static_cast<int>(names.size()) ? names[i] : none;
		}

		bool Open()
		{
			if (data.size() < 160 || memcmp(data.data(), "CR2W", 4) != 0 || U32(data.data() + 4) < 155)
				return false;
			const uint8_t* d = data.data();
			const auto table = [&](int i, uint32_t& at, uint32_t& count) { at = U32(d + 40 + i * 12); count = U32(d + 44 + i * 12); };
			uint32_t stringsAt, stringsSize, namesAt, nameCount, importsAt, importCount, exportsAt, exportCount, buffersAt, bufferCount;
			table(0, stringsAt, stringsSize);
			table(1, namesAt, nameCount);
			table(2, importsAt, importCount);
			table(4, exportsAt, exportCount);
			table(5, buffersAt, bufferCount);
			const size_t size = data.size();
			if (static_cast<uint64_t>(stringsAt) + stringsSize > size || namesAt + nameCount * 8ull > size || importsAt + importCount * 8ull > size || exportsAt + exportCount * 24ull > size || buffersAt + bufferCount * 24ull > size)
				return false;
			const auto text = [&](uint32_t offset) -> std::string
			{
				if (offset >= stringsSize)
					return {};
				const char* s = reinterpret_cast<const char*>(d + stringsAt + offset);
				return std::string(s, strnlen(s, stringsSize - offset));
			};
			names.resize(nameCount);
			for (uint32_t i = 0; i < nameCount; ++i)
				names[i] = text(U32(d + namesAt + i * 8));
			imports.resize(importCount);
			for (uint32_t i = 0; i < importCount; ++i)
				imports[i] = text(U32(d + importsAt + i * 8));
			exports.resize(exportCount);
			for (uint32_t i = 0; i < exportCount; ++i)
			{
				const uint8_t* e = d + exportsAt + i * 24;
				exports[i] = RedExport{ U16(e), I32(e + 4) - 1, U32(e + 8), U32(e + 12) };
				if (static_cast<uint64_t>(exports[i].offset) + exports[i].size > size)
					return false;
			}
			buffers.resize(bufferCount);
			for (uint32_t i = 0; i < bufferCount; ++i)
			{
				const uint8_t* e = d + buffersAt + i * 24;
				buffers[i] = RedBuffer{ I32(e + 4), U32(e + 8), U32(e + 12), U32(e + 16) };
			}
			return true;
		}

		// One object's or struct's properties. False if they don't read as properties.
		template <typename F>
		bool Walk(size_t at, size_t end, bool withMarker, F&& visit, size_t* after = nullptr) const
		{
			if (at >= end)
			{
				if (after)
					*after = at;
				return true;
			}
			if (withMarker)
			{
				if (data[at] != 0)
					return false;
				++at;
			}
			while (at + 2 <= end)
			{
				const uint16_t name = U16(data.data() + at);
				if (name == 0)
				{
					at += 2;
					break;
				}
				if (at + 8 > end)
					return false;
				const uint16_t type = U16(data.data() + at + 2);
				const int32_t size = I32(data.data() + at + 4);
				const size_t value = at + 8;
				if (size < 4 || name >= names.size() || type >= names.size() || at + 4 + static_cast<size_t>(size) > end)
					return false;
				visit(names[name], names[type], value, at + 4 + static_cast<size_t>(size));
				at += 4 + static_cast<size_t>(size);
			}
			if (after)
				*after = at;
			return true;
		}

		// Files from 155 on can have an object's properties either way about a zero byte
		template <typename F>
		size_t Object(const RedExport& e, F&& visit)
		{
			const auto nothing = [](const std::string&, const std::string&, size_t, size_t) {};
			size_t tail = e.offset + e.size;
			if (Walk(e.offset, e.offset + e.size, true, nothing))
				marker = true;
			else if (Walk(e.offset, e.offset + e.size, false, nothing))
				marker = false;
			else
				return tail;
			Walk(e.offset, e.offset + e.size, marker, visit, &tail);
			return tail;
		}

		const std::string* Import(int32_t handle) const
		{
			const int32_t i = -handle - 1;
			return handle < 0 && i < static_cast<int32_t>(imports.size()) ? &imports[i] : nullptr;
		}

		bool Bytes(size_t value, size_t end, size_t& at, size_t& count) const
		{
			if (value + 4 > end)
				return false;
			count = U32(data.data() + value);
			at = value + 4;
			return at + count <= end;
		}

		std::vector<int32_t> Handles(size_t value, size_t end) const
		{
			std::vector<int32_t> out;
			if (value + 4 > end)
				return out;
			const uint32_t count = U32(data.data() + value);
			if (value + 4 + count * 4ull > end)
				return out;
			out.resize(count);
			memcpy(out.data(), data.data() + value + 4, count * 4ull);
			return out;
		}

		std::string Text(size_t at, size_t end) const
		{
			if (at >= end)
				return {};
			const uint8_t first = data[at++];
			int length = first & 0x3F;
			const bool narrow = (first & 0x80) != 0;
			if (first & 0x40)
				for (int shift = 6; at < end; shift += 7)
				{
					const uint8_t next = data[at++];
					length |= (next & 0x7F) << shift;
					if (!(next & 0x80))
						break;
				}
			std::string out;
			if (narrow)
			{
				if (at + length <= end)
					out.assign(reinterpret_cast<const char*>(data.data() + at), length);
			}
			else if (at + length * 2ull <= end)
			{
				out.resize(length);
				for (int i = 0; i < length; ++i)
					out[i] = static_cast<char>(data[at + i * 2ull]);
			}
			return out;
		}

		// A numbered buffer: inside the file, or the <path>.N.buffer beside it
		bool Buffer(int index, const std::string& path, std::vector<uint8_t>& out) const
		{
			for (const RedBuffer& b : buffers)
				if (b.index == index && b.offset > 0 && b.diskSize > 0 && b.offset + static_cast<uint64_t>(b.diskSize) <= data.size())
				{
					if (b.diskSize == b.memorySize)
					{
						out.assign(data.begin() + b.offset, data.begin() + b.offset + b.diskSize);
						return true;
					}
					out.resize(b.memorySize);
					return InflateGameData(data.data() + b.offset, b.diskSize, out.data(), out.size());
				}
			return ReadGameFile(path + "." + std::to_string(index) + ".buffer", out);
		}
	};

	std::shared_ptr<Red> OpenFile(const std::string& path)
	{
		auto file = std::make_shared<Red>();
		if (!ReadGameFile(path, file->data) || !file->Open())
			return nullptr;
		return file;
	}

	// ---- placing: row vectors, as the Workbench has them

	struct M4
	{
		float m[4][4] = { {1,0,0,0}, {0,1,0,0}, {0,0,1,0}, {0,0,0,1} };
		M4 operator*(const M4& o) const
		{
			M4 r;
			for (int i = 0; i < 4; ++i)
				for (int j = 0; j < 4; ++j)
				{
					r.m[i][j] = 0.f;
					for (int k = 0; k < 4; ++k)
						r.m[i][j] += m[i][k] * o.m[k][j];
				}
			return r;
		}
		bool Same(const M4& o) const { return memcmp(m, o.m, sizeof(m)) == 0; }
	};

	M4 Scale(float x, float y, float z) { M4 r; r.m[0][0] = x; r.m[1][1] = y; r.m[2][2] = z; return r; }
	M4 RotateX(float a) { M4 r; const float c = cosf(a), s = sinf(a); r.m[1][1] = c; r.m[1][2] = s; r.m[2][1] = -s; r.m[2][2] = c; return r; }
	M4 RotateY(float a) { M4 r; const float c = cosf(a), s = sinf(a); r.m[0][0] = c; r.m[0][2] = -s; r.m[2][0] = s; r.m[2][2] = c; return r; }
	M4 RotateZ(float a) { M4 r; const float c = cosf(a), s = sinf(a); r.m[0][0] = c; r.m[0][1] = s; r.m[1][0] = -s; r.m[1][1] = c; return r; }

	M4 TransformOf(const uint8_t* raw, size_t size)
	{
		if (size < 1)
			return M4{};
		const int flags = raw[0];
		size_t at = 1;
		float position[3] = { 0, 0, 0 }, rotation[3] = { 0, 0, 0 }, scale[3] = { 1, 1, 1 };
		const auto read = [&](float* to) { if (at + 12 <= size) { to[0] = F32(raw + at); to[1] = F32(raw + at + 4); to[2] = F32(raw + at + 8); at += 12; } };
		if (flags & 1) read(position);
		if (flags & 2) read(rotation);
		if (flags & 4) read(scale);
		constexpr float rad = 3.14159265358979f / 180.f;
		M4 t;
		t.m[3][0] = position[0];
		t.m[3][1] = position[1];
		t.m[3][2] = position[2];
		return Scale(scale[0], scale[1], scale[2]) * RotateY(rotation[0] * rad) * RotateX(rotation[1] * rad) * RotateZ(rotation[2] * rad) * t;
	}

	// ---- an entity's components

	struct Component
	{
		std::string name, mesh;
		std::string bone;   // fastened to this bone of the character it's on (a hard attachment's parentSlotName)
		std::string dyng;   // the dangle physics it's skinned to, or a dangle component's own
		M4 local, placed;
		bool shadow = false, skinned = false, fromAppearance = false;
	};

	// A colour entry: what an appearance does to a component's colours
	struct Coloring
	{
		std::string appearance, component;
		int first[3] = {}, second[3] = {};   // hue, saturation, luminance
	};

	struct Entity
	{
		std::vector<Coloring> colorings;
		std::vector<Component> components;
		std::vector<std::string> includes;
		struct Look { std::string name; std::vector<std::string> templates; };
		std::vector<Look> looks;
		std::vector<std::string> usedLooks;   // the ones it uses (usedAppearances): a quest's monster names its own
		std::vector<std::string> skeletons;  // a character's: the rigs its animated components move, its moving agent's first
		std::vector<std::string> animsets;   // and the animation sets its template gives it
		std::vector<std::string> dangleSkeletons;   // its dangle buffers' rigs: its rig again, with its hair's bones and the like
		std::vector<std::string> dyngs;             // its dangle constraints' physics (.w3dyng), each with a rig of its bones
	};

	void ReadComponents(Red& f, std::vector<Component>& out)
	{
		struct Link { int parent, child; M4 relative; bool hard; std::string slot; };
		std::vector<Link> links;
		std::map<int, int> byExport;
		for (int i = 0; i < static_cast<int>(f.exports.size()); ++i)
		{
			const std::string& cls = f.Name(f.exports[i].className);
			if (Ends(cls, "Attachment"))
			{
				Link link{ -1, -1, M4{}, cls == "CHardAttachment", {} };
				const bool skinning = cls == "CMeshSkinningAttachment" || cls == "CAnimatedAttachment";
				f.Object(f.exports[i], [&](const std::string& n, const std::string&, size_t v, size_t e)
				{
					if (n == "parent" && v + 4 <= e) link.parent = I32(f.data.data() + v) - 1;
					else if (n == "child" && v + 4 <= e) link.child = I32(f.data.data() + v) - 1;
					else if (n == "relativeTransform") link.relative = TransformOf(f.data.data() + v, e - v);
					else if (n == "parentSlotName" && v + 2 <= e) link.slot = f.Name(U16(f.data.data() + v));
				});
				if (skinning)
					link.relative.m[0][0] = -12345.f;   // marks it, as only the child's being skinned matters
				links.push_back(link);
				continue;
			}
			Component c;
			c.name = cls;
			bool hasGuid = false, hasName = false;
			f.Object(f.exports[i], [&](const std::string& n, const std::string& t, size_t v, size_t e)
			{
				if (n == "guid")
					hasGuid = true;
				else if (n == "name" && t == "String")
				{
					hasName = true;
					c.name = f.Text(v, e);
				}
				else if (n == "transform")
					c.local = TransformOf(f.data.data() + v, e - v);
				else if (n == "constraint" && cls == "CAnimDangleComponent" && v + 4 <= e)
				{
					const int at = I32(f.data.data() + v) - 1;
					if (at >= 0 && at < static_cast<int>(f.exports.size()) && f.Name(f.exports[at].className) == "CAnimDangleConstraint_Dyng")
						f.Object(f.exports[at], [&](const std::string& dn, const std::string&, size_t dv, size_t de)
						{
							if (dn == "dyng" && dv + 4 <= de)
								if (const std::string* p = f.Import(I32(f.data.data() + dv)))
									c.dyng = *p;
						});
				}
				else if (e >= v + 4 && (n == "mesh" || (n == "resource" && cls == "CClothComponent") || (n == "morphSource" && cls == "CMorphedMeshComponent")))
				{
					if (const std::string* path = f.Import(I32(f.data.data() + v)))
						c.mesh = *path;
				}
				else if (n == "drawableFlags")
					for (size_t at = v; at + 2 <= e; at += 2)
					{
						const uint16_t flag = U16(f.data.data() + at);
						if (flag == 0)
							break;
						if (f.Name(flag) == "DF_IsCharacterShadowFallback")
							c.shadow = true;
					}
			});
			// A component has a name and a GUID, whatever its class is called
			if (!Ends(cls, "Component") && !(hasGuid && hasName))
				continue;
			if (Lower(c.mesh).find("shadowmesh") != std::string::npos)
				c.shadow = true;
			byExport[i] = static_cast<int>(out.size());
			out.push_back(std::move(c));
		}
		std::map<int, const Link*> parentOf;
		for (const Link& link : links)
		{
			const auto child = byExport.find(link.child);
			if (child == byExport.end())
				continue;
			if (link.relative.m[0][0] == -12345.f)
			{
				out[child->second].skinned = true;
				if (const auto parent = byExport.find(link.parent); parent != byExport.end() && !out[parent->second].dyng.empty())
					out[child->second].dyng = out[parent->second].dyng;
			}
			else if (link.hard)
			{
				// Fastened to a bone, it's placed relative to that bone: the bone itself moves it from there
				if (!link.slot.empty())
					out[child->second].bone = link.slot;
				if (byExport.count(link.parent))
					parentOf.emplace(child->second, &link);
			}
		}
		for (const auto& [index, count] : byExport)
		{
			Component& c = out[count];
			M4 placed = c.local;
			int at = count;
			for (int depth = 0; depth < 16; ++depth)
			{
				const auto link = parentOf.find(at);
				if (link == parentOf.end())
					break;
				const int parent = byExport[link->second->parent];
				placed = placed * link->second->relative * out[parent].local;
				at = parent;
			}
			c.placed = placed;
		}
	}

	std::shared_ptr<Entity> ReadEntity(const std::string& path)
	{
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return nullptr;
		auto entity = std::make_shared<Entity>();
		std::shared_ptr<Red> flat;
		int32_t entityObject = 0;
		for (const RedExport& e : file->exports)
		{
			if (file->Name(e.className) != "CEntityTemplate")
				continue;
			file->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
			{
				if (n == "flatCompiledData")
				{
					size_t at, count;
					if (file->Bytes(v, end, at, count) && count > 4)
					{
						auto inner = std::make_shared<Red>();
						inner->data.assign(file->data.begin() + at, file->data.begin() + at + count);
						if (inner->Open())
							flat = inner;
					}
				}
				else if (n == "entityObject" && v + 4 <= end)
					entityObject = I32(file->data.data() + v);
				else if (n == "coloringEntries" && v + 4 <= end)
				{
					const uint32_t count = U32(file->data.data() + v);
					size_t at = v + 4;
					const auto number = [&](const std::string& type, size_t pv, size_t pe) -> int
					{
						const uint8_t* p = file->data.data() + pv;
						if ((type == "Int8") && pv < pe) return static_cast<int8_t>(p[0]);
						if ((type == "Uint8") && pv < pe) return p[0];
						if ((type == "Int16") && pv + 2 <= pe) return static_cast<int16_t>(U16(p));
						if ((type == "Uint16") && pv + 2 <= pe) return U16(p);
						if (pv + 4 <= pe) return I32(p);
						return 0;
					};
					for (uint32_t i = 0; i < count && at < end; ++i)
					{
						Coloring c;
						size_t next = end;
						if (!file->Walk(at, end, file->marker, [&](const std::string& pn, const std::string& pt, size_t pv, size_t pe)
						{
							if (pn == "appearance" && pv + 2 <= pe)
								c.appearance = file->Name(U16(file->data.data() + pv));
							else if (pn == "componentName" && pv + 2 <= pe)
								c.component = file->Name(U16(file->data.data() + pv));
							else if (pn == "colorShift1" || pn == "colorShift2")
							{
								int* shift = pn == "colorShift1" ? c.first : c.second;
								file->Walk(pv, pe, file->marker, [&](const std::string& sn, const std::string& st, size_t sv, size_t se)
								{
									if (sn == "hue") shift[0] = number(st, sv, se);
									else if (sn == "saturation") shift[1] = number(st, sv, se);
									else if (sn == "luminance") shift[2] = number(st, sv, se);
								});
							}
						}, &next))
							break;
						entity->colorings.push_back(std::move(c));
						at = next;
					}
				}
				else if (n == "includes")
				{
					for (const int32_t h : file->Handles(v, end))
						if (const std::string* p = file->Import(h))
							entity->includes.push_back(*p);
				}
				else if (n == "usedAppearances" && v + 4 <= end)
				{
					// The looks this template itself uses, of all those it and what it includes have
					const uint32_t count = U32(file->data.data() + v);
					for (uint32_t i = 0; i < count && v + 4 + i * 2 + 2 <= end; ++i)
						entity->usedLooks.push_back(file->Name(U16(file->data.data() + v + 4 + i * 2)));
				}
				else if (n == "appearances" && v + 4 <= end)
				{
					const uint32_t count = U32(file->data.data() + v);
					size_t at = v + 4;
					for (uint32_t i = 0; i < count && at < end; ++i)
					{
						Entity::Look look;
						size_t next = end;
						if (!file->Walk(at, end, file->marker, [&](const std::string& pn, const std::string&, size_t pv, size_t pe)
						{
							if (pn == "name" && pv + 2 <= pe)
								look.name = file->Name(U16(file->data.data() + pv));
							else if (pn == "includedTemplates")
								for (const int32_t h : file->Handles(pv, pe))
									if (const std::string* p = file->Import(h))
										look.templates.push_back(*p);
						}, &next))
							break;
						entity->looks.push_back(std::move(look));
						at = next;
					}
				}
			});
			break;
		}

		Red& main = flat ? *flat : *file;
		ReadComponents(main, entity->components);

		// What moves a character: the skeletons of its moving agent and its other animated components, and its animation sets
		std::vector<std::string> agentSkeleton, animatedSkeleton;
		for (Red* f : { file.get(), flat.get() })
		{
			if (!f)
				continue;
			for (const RedExport& e : f->exports)
			{
				const std::string& cls = f->Name(e.className);
				const bool sets = cls == "CAnimAnimsetsParam";
				const bool agent = Ends(cls, "AgentComponent");
				if (cls == "CAnimDangleConstraint_Dyng")
				{
					f->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
					{
						if (n == "dyng" && v + 4 <= end)
							if (const std::string* p = f->Import(I32(f->data.data() + v)); p && std::find(entity->dyngs.begin(), entity->dyngs.end(), *p) == entity->dyngs.end())
								entity->dyngs.push_back(*p);
					});
					continue;
				}
				if (cls == "CAnimDangleBufferComponent")
				{
					f->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
					{
						if (n == "skeleton" && v + 4 <= end)
							if (const std::string* p = f->Import(I32(f->data.data() + v)); p && std::find(entity->dangleSkeletons.begin(), entity->dangleSkeletons.end(), *p) == entity->dangleSkeletons.end())
								entity->dangleSkeletons.push_back(*p);
					});
					continue;
				}
				if (!sets && !agent && !Ends(cls, "AnimatedComponent"))
					continue;
				f->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
				{
					if (sets && n == "animationSets")
					{
						for (const int32_t h : f->Handles(v, end))
							if (const std::string* p = f->Import(h))
								if (std::find(entity->animsets.begin(), entity->animsets.end(), *p) == entity->animsets.end())
									entity->animsets.push_back(*p);
					}
					else if (!sets && n == "skeleton" && v + 4 <= end)
					{
						std::vector<std::string>& kept = agent ? agentSkeleton : animatedSkeleton;
						if (const std::string* p = f->Import(I32(f->data.data() + v)); p && std::find(kept.begin(), kept.end(), *p) == kept.end())
							kept.push_back(*p);
					}
				});
			}
		}
		entity->skeletons = agentSkeleton;
		for (const std::string& s : animatedSkeleton)
			if (std::find(entity->skeletons.begin(), entity->skeletons.end(), s) == entity->skeletons.end())
				entity->skeletons.push_back(s);

		// Components streamed in near the player are a file inside the entity, after its length
		const int entityIndex = flat ? 0 : entityObject - 1;
		if (entityIndex >= 0 && entityIndex < static_cast<int>(main.exports.size()))
		{
			std::shared_ptr<Red> streamed;
			main.Object(main.exports[entityIndex], [&](const std::string& n, const std::string&, size_t v, size_t end)
			{
				if (n == "streamingDataBuffer" && end > v + 8 && memcmp(main.data.data() + v + 4, "CR2W", 4) == 0)
				{
					auto inner = std::make_shared<Red>();
					inner->data.assign(main.data.begin() + v + 4, main.data.begin() + end);
					if (inner->Open())
						streamed = inner;
				}
			});
			if (streamed)
				ReadComponents(*streamed, entity->components);
		}
		return entity;
	}

	// The look's components by name, as the Workbench's EntityFile.Look: an appearance's templates and what they include
	void AddTemplate(const std::string& path, std::vector<Component>& components, std::vector<Coloring>& colorings, std::set<std::string>& seen, int depth, std::map<std::string, std::shared_ptr<Entity>>& cache)
	{
		const std::string key = Lower(path);
		if (depth > 3 || !seen.insert(key).second)
			return;
		auto cached = cache.find(key);
		const std::shared_ptr<Entity> part = cached != cache.end() ? cached->second : (cache[key] = ReadEntity(path));
		if (!part)
			return;
		colorings.insert(colorings.end(), part->colorings.begin(), part->colorings.end());
		for (const Component& c : part->components)
		{
			const auto same = std::find_if(components.begin(), components.end(), [&](const Component& o) { return o.name == c.name; });
			if (same != components.end())
			{
				if (same->fromAppearance && same->mesh.empty() && !c.mesh.empty())
				{
					*same = c;
					same->fromAppearance = true;
				}
				continue;
			}
			components.push_back(c);
			components.back().fromAppearance = true;
		}
		for (const std::string& include : part->includes)
			AddTemplate(include, components, colorings, seen, depth + 1, cache);
	}

	// ---- materials

	struct Textures
	{
		std::vector<std::pair<std::string, std::string>> found;
		int instanceMasked = -1, graphMasked = 0;   // the nearest instance that says, and the graph
		bool placeholder = false;   // the engine's default material, on a chunk nobody gave one
		struct Vector { float x, y; };
		std::map<std::string, Vector> vectors;
		bool canOverride = false;
		std::set<std::string> graphTextures;   // lowered: the textures its graph reads, as an instance can keep others it doesn't
		std::string graph;
		std::map<std::string, float> numbers;     // lowered name; nearest first
		struct Colour { uint8_t rgba[4]; };
		std::map<std::string, Colour> colours;
		bool Masked() const { return canOverride && instanceMasked >= 0 ? instanceMasked != 0 : instanceMasked >= 0 && graphMasked < 0 ? instanceMasked != 0 : graphMasked > 0; }
	};

	void AddParameter(Textures& t, const std::string& name, const std::string& path)
	{
		if (!Ends(Lower(path), ".xbm"))
			return;
		for (const auto& [have, _] : t.found)
			if (_stricmp(have.c_str(), name.c_str()) == 0)
				return;
		t.found.emplace_back(name, path);
	}

	void ReadColour(const Red& f, size_t v, size_t end, Textures::Colour& out)
	{
		f.Walk(v, end, f.marker, [&](const std::string& n, const std::string&, size_t pv, size_t pe)
		{
			if (pv >= pe)
				return;
			if (n == "Red") out.rgba[0] = f.data[pv];
			else if (n == "Green") out.rgba[1] = f.data[pv];
			else if (n == "Blue") out.rgba[2] = f.data[pv];
			else if (n == "Alpha") out.rgba[3] = f.data[pv];
		});
	}

	void ReadVector(const Red& f, size_t v, size_t end, Textures::Vector& out)
	{
		f.Walk(v, end, f.marker, [&](const std::string& n, const std::string&, size_t pv, size_t pe)
		{
			if (pv + 4 > pe)
				return;
			if (n == "X") out.x = F32(f.data.data() + pv);
			else if (n == "Y") out.y = F32(f.data.data() + pv);
		});
	}

	void ReadMaterial(std::shared_ptr<Red> file, int32_t handle, Textures& t, int depth, std::map<std::string, std::shared_ptr<Red>>& cache)
	{
		if (depth > 8 || !file)
			return;
		if (handle < 0)
		{
			const std::string* path = file->Import(handle);
			if (!path || path->empty())
				return;
			const std::string key = Lower(*path);
			if (depth == 0 && Ends(key, "engine\\materials\\defaults\\mesh.w2mg"))
				t.placeholder = true;
			auto known = cache.find(key);
			const std::shared_ptr<Red> next = known != cache.end() ? known->second : (cache[key] = OpenFile(*path));
			if (!next)
				return;
			if (Ends(key, ".w2mg"))
			{
				const size_t slash = key.find_last_of('\\');
				t.graph = key.substr(slash == std::string::npos ? 0 : slash + 1, key.size() - (slash == std::string::npos ? 0 : slash + 1) - 5);
				for (const RedExport& e : next->exports)
				{
					if (next->Name(e.className) == "CMaterialGraph")
						next->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
						{
							if (n == "isMasked" && v < end)
								t.graphMasked = next->data[v] != 0 ? 1 : 0;
							else if (n == "canOverrideMasked" && v < end)
								t.canOverride = next->data[v] != 0;
						});
					const std::string& cls = next->Name(e.className);
					if (cls != "CMaterialParameterTexture" && cls != "CMaterialParameterScalar" && cls != "CMaterialParameterColor" && cls != "CMaterialParameterVector")
						continue;
					Textures::Vector vector{ 5.f, 5.f };
					std::string name, texture;
					float scalar = 1.f;   // left at the class's default, it isn't saved
					Textures::Colour colour{ { 0, 0, 0, 255 } };
					next->Object(e, [&](const std::string& n, const std::string& type, size_t v, size_t end)
					{
						if (n == "parameterName")
							name = type == "String" ? next->Text(v, end) : v + 2 <= end ? next->Name(U16(next->data.data() + v)) : std::string();
						else if (n == "texture" && v + 4 <= end)
						{
							if (const std::string* p = next->Import(I32(next->data.data() + v)))
								texture = *p;
						}
						else if (n == "scalar" && v + 4 <= end)
							scalar = F32(next->data.data() + v);
						else if (n == "color")
							ReadColour(*next, v, end, colour);
						else if (n == "vector")
							ReadVector(*next, v, end, vector);
					});
					if (name.empty())
						continue;
					if (cls == "CMaterialParameterTexture")
					{
						t.graphTextures.insert(Lower(name));
						if (!texture.empty())
							AddParameter(t, name, texture);
					}
					else if (cls == "CMaterialParameterScalar")
						t.numbers.emplace(Lower(name), scalar);
					else if (cls == "CMaterialParameterVector")
						t.vectors.emplace(Lower(name), vector);
					else
						t.colours.emplace(Lower(name), colour);
				}
				return;
			}
			for (int i = 0; i < static_cast<int>(next->exports.size()); ++i)
				if (next->Name(next->exports[i].className) == "CMaterialInstance")
				{
					ReadMaterial(next, i + 1, t, depth + 1, cache);
					return;
				}
			return;
		}
		const int index = handle - 1;
		if (index < 0 || index >= static_cast<int>(file->exports.size()) || file->Name(file->exports[index].className) != "CMaterialInstance")
			return;
		const RedExport& e = file->exports[index];
		int32_t base = 0;
		const size_t tail = file->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
		{
			if (n == "baseMaterial" && v + 4 <= end)
				base = I32(file->data.data() + v);
			else if (n == "enableMask" && v < end && t.instanceMasked < 0)
				t.instanceMasked = file->data[v] != 0 ? 1 : 0;
		});
		const size_t end = e.offset + e.size;
		if (tail + 4 <= end)
		{
			const uint8_t* d = file->data.data();
			const uint32_t count = U32(d + tail);
			size_t at = tail + 4;
			for (uint32_t i = 0; i < count && at + 8 <= end; ++i)
			{
				const int32_t size = I32(d + at);
				if (size < 8 || at + size > end)
					break;
				const std::string& type = file->Name(U16(d + at + 6));
				const std::string& parameter = file->Name(U16(d + at + 4));
				if (type.rfind("handle:", 0) == 0 && size >= 12)
				{
					if (const std::string* p = file->Import(I32(d + at + 8)))
						AddParameter(t, parameter, *p);
				}
				else if (type == "Float" && size >= 12)
					t.numbers.emplace(Lower(parameter), F32(d + at + 8));
				else if (type == "Vector")
				{
					Textures::Vector vector{ 5.f, 5.f };
					ReadVector(*file, at + 8, at + size, vector);
					t.vectors.emplace(Lower(parameter), vector);
				}
				else if (type == "Color")
				{
					Textures::Colour colour{ { 0, 0, 0, 255 } };
					ReadColour(*file, at + 8, at + size, colour);
					t.colours.emplace(Lower(parameter), colour);
				}
				at += size;
			}
		}
		if (base != 0 && base != handle)
			ReadMaterial(file, base, t, depth + 1, cache);
	}

	std::string Pick(const Textures& t, bool normal)
	{
		const auto icontains = [](const std::string& s, const char* part) { return Lower(s).find(part) != std::string::npos; };
		if (normal)
		{
			for (const auto& [n, p] : t.found) if (_stricmp(n.c_str(), "Normal") == 0) return p;
			for (const auto& [n, p] : t.found) if (Lower(n).rfind("normal", 0) == 0) return p;
			return {};
		}
		for (const auto& [n, p] : t.found) if (_stricmp(n.c_str(), "Diffuse") == 0) return p;
		for (const auto& [n, p] : t.found) if (_stricmp(n.c_str(), "Diffusemap") == 0) return p;
		for (const auto& [n, p] : t.found) if (icontains(n, "diffuse") && !icontains(n, "snow")) return p;
		for (const auto& [n, p] : t.found) if (icontains(n, "diffuse")) return p;
		return {};
	}

	// The numbers as the Workbench's LookTextures reads them, from the game's material graphs
	struct M3 { float m[3][3]; };
	M3 Times(const M3& a, const M3& b)
	{
		M3 r{};
		for (int i = 0; i < 3; ++i)
			for (int j = 0; j < 3; ++j)
				for (int k = 0; k < 3; ++k)
					r.m[i][j] += a.m[i][k] * b.m[k][j];
		return r;
	}

	// As REDkit's CColorShift works it out, for a colour taken as a row (the Workbench's LookTextures.ShiftMatrix)
	M3 ShiftMatrix(const int shift[3])
	{
		if (shift[0] == 0 && shift[1] == 0 && shift[2] == 0)
			return M3{ { { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } } };
		const float saturation = 1.f + shift[1] / 100.f, luminance = 1.f + shift[2] / 100.f;
		const float other = (1.f - saturation) / 3.f, same = other + saturation;
		const M3 saturate{ { { same, other, other }, { other, same, other }, { other, other, same } } };
		const M3 lighten{ { { luminance, 0, 0 }, { 0, luminance, 0 }, { 0, 0, luminance } } };
		const float angle = shift[0] * 3.14159265358979f / 180.f, c = cosf(angle), s = sinf(angle);
		const M3 turn{ { { c, -s, 0 }, { s, c, 0 }, { 0, 0, 1 } } };
		static const M3 toHue{ { { 0.8165f, -0.4082f, 0.4082f }, { 0, 0.7071f, 0.7071f }, { -0.8539f, -0.7405f, 0.1377f } } };
		static const M3 fromHue{ { { 0.621f, -0.2461f, -0.5774f }, { -0.6038f, 0.461f, -0.5774f }, { 0.6038f, 0.9532f, 0.5774f } } };
		return Times(Times(Times(Times(lighten, toHue), turn), fromHue), saturate);
	}

	void ApplyMaterial(const Textures& t, ModelPart& part, const Coloring* coloring)
	{
		part.masked = t.Masked();
		part.graph = t.graph;
		// Blended over what's under it, or never meant to be seen: left out, as the Workbench does
		if (t.placeholder || t.graph.find("eye_shadow") != std::string::npos)
			part.shadowOnly = true;
		const auto number = [&](const char* name, float fallback)
		{
			const auto found = t.numbers.find(name);
			return found != t.numbers.end() ? found->second : fallback;
		};
		part.specScale = number("rspecscale", 1.f);
		part.specBase = number("rspecbase", 0.f);
		part.roughMin = number("roughness_min", 0.f);
		part.roughMax = number("roughness_max", 1.f);
		part.aoPower = number("aopower", number("ambientpower", 0.5f));
		const auto colour = t.colours.find("specularcolor");
		if (colour != t.colours.end())
			for (int i = 0; i < 3; ++i)
				part.specColour[i] = powf(colour->second.rgba[i] / 255.f, 2.2f);
		part.skin = t.graph.find("skin") != std::string::npos;
		// The hair graphs colour their grey strands the same way, by VarianceColor and VarianceOffset
		if (t.graph == "pbr_std" || t.graph == "pbr_spec" || t.graph == "pbr_det" || t.graph == "pbr_std_no_wetness" || part.skin
			|| t.graph.find("hair") != std::string::npos)   // and the bruxae's own hair graphs, by their names
		{
			const auto variance = t.colours.find("variancecolor");
			if (variance != t.colours.end())
				for (int i = 0; i < 3; ++i)
					part.variance[i] = variance->second.rgba[i] / 255.f;
			part.variance[3] = number("varianceoffset", 1.f);
		}
		for (const auto& [name, path] : t.found)
		{
			if (_stricmp(name.c_str(), "TintMask") == 0)
				part.tintMask = path;
			else if (_stricmp(name.c_str(), "SpecularTexture") == 0 && (t.graphTextures.empty() || t.graphTextures.count("speculartexture")))
				part.specular = path;   // only if its graph reads one: the griffin's keeps one its graph has no use for
		}

		// The detail maps, as each graph has them
		const auto findTexture = [&](const char* wanted) -> std::string
		{
			for (const auto& [name, path] : t.found)
				if (_stricmp(name.c_str(), wanted) == 0)
					return path;
			return {};
		};
		const auto tile = [&](const char* name, float* to)
		{
			const auto found = t.vectors.find(name);
			if (found != t.vectors.end())
			{
				to[0] = found->second.x;
				to[1] = found->second.y;
			}
		};
		if (!part.skin)
		{
			part.detailPower = number("detailpower", 0.5f);
			part.detailAlbedo = number("detailalbedopower", 0.f);
			part.detailRange = number("detailrange", 5.f);
			if (t.graph.find("2det") != std::string::npos)
			{
				part.detail1 = findTexture("DetailNormal1");
				part.detail2 = findTexture("DetailNormal2");
				tile("detailtile1", part.detailTile1);
				tile("detailtile2", part.detailTile2);
				part.detailMode = !part.detail1.empty() && !part.detail2.empty() && !part.tintMask.empty() ? 2 : 0;
			}
			else if (t.graph.find("_det") != std::string::npos || t.graph == "pbr_det")
			{
				part.detail1 = findTexture("DetailNormal");
				tile("detailtile", part.detailTile1);
				part.detailMode = part.detail1.empty() ? 0 : t.graph == "pbr_det" ? 3 : part.tintMask.empty() ? 0 : 1;
			}
		}

		// A colour entry recolours a material with a tint mask, if ColorShift_Enabled says so
		if (coloring && !part.tintMask.empty() && number("colorshift_enabled", 0.f) > 0.f)
		{
			part.shifting = true;
			part.keepGray = number("colorshift_ keepgray", 0.f) > 0.f;
			part.blendColors = number("colorshift_ blendcolors", 0.f) > 0.f;
			const M3 red = ShiftMatrix(coloring->first);
			// The matrices are made for a red colour, so the blue parts have their red and blue swapped on the way in
			const M3 swap{ { { 0, 0, 1 }, { 0, 1, 0 }, { 1, 0, 0 } } };
			const M3 blue = Times(swap, ShiftMatrix(coloring->second));
			for (int i = 0; i < 3; ++i)
				for (int j = 0; j < 3; ++j)
				{
					part.shiftRed[i * 3 + j] = red.m[i][j];
					part.shiftBlue[i * 3 + j] = blue.m[i][j];
				}
		}
	}

	// ---- a mesh

	float Half(uint16_t h)
	{
		const int sign = h >> 15, exponent = (h >> 10) & 31, mantissa = h & 1023;
		float v;
		if (exponent == 0)
			v = mantissa * (1.f / 16777216.f);
		else if (exponent == 31)
			v = FLT_MAX;
		else
			v = (1.f + mantissa / 1024.f) * ldexpf(1.f, exponent - 15);
		return sign ? -v : v;
	}

	float Ten(uint32_t bits) { return (bits & 0x3FF) / 1023.f * 2.f - 1.f; }

	void Normalise(float* v)
	{
		const float l = sqrtf(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
		if (l > 1e-6f)
			for (int i = 0; i < 3; ++i)
				v[i] /= l;
	}

	// A length as the engine packs it
	bool PackedCount(const uint8_t* d, size_t& at, size_t end, int& count)
	{
		if (at >= end)
			return false;
		const uint8_t first = d[at++];
		count = first & 0x3F;
		if (first & 0x40)
			for (int shift = 6;; shift += 7)
			{
				if (at >= end || shift > 27)
					return false;
				const uint8_t next = d[at++];
				count |= (next & 0x7F) << shift;
				if (!(next & 0x80))
					break;
			}
		return true;
	}

	// A skinned mesh's bones, kept after its properties: after a few details, a count, that many names, the count again
	// and that many 4x4 matrices. Found by that pattern, as Core/Meshes/MeshFile.cs finds them. -1 if it has none.
	int ReadMeshBones(const Red& file, size_t tail, size_t end, ItemModel& out)
	{
		const uint8_t* d = file.data.data();
		for (size_t start = tail; start < std::min(end, tail + 128); ++start)
		{
			size_t at = start;
			int count = 0;
			if (!PackedCount(d, at, end, count) || count <= 0 || count > 1024 || at + count * 2ull > end)
				continue;
			MeshBones bones;
			bones.names.reserve(count);
			bool good = true;
			for (int i = 0; i < count && good; ++i)
			{
				const uint16_t name = U16(d + at + i * 2ull);
				good = name > 0 && name < file.names.size();
				if (good)
					bones.names.push_back(file.names[name]);
			}
			if (!good)
				continue;
			at += count * 2ull;
			int again = 0;
			if (!PackedCount(d, at, end, again) || again != count || at + count * 64ull > end)
				continue;
			bones.inverseBinds.resize(count);
			memcpy(bones.inverseBinds.data(), d + at, count * 64ull);
			out.meshBones.push_back(std::move(bones));
			return static_cast<int>(out.meshBones.size()) - 1;
		}
		return -1;
	}

	bool ReadMesh(const std::string& path, const M4& placed, const Coloring* coloring, ItemModel& out, std::map<std::string, std::shared_ptr<Red>>& materials)
	{
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return false;
		const RedExport* mesh = nullptr;
		for (const RedExport& e : file->exports)
		{
			const std::string& cls = file->Name(e.className);
			if (cls == "CMesh" || cls == "CPhysicsDestructionResource")
			{
				mesh = &e;
				break;
			}
		}
		if (!mesh)
			return false;
		std::vector<int32_t> materialHandles;
		size_t chunksAt = 0, chunksSize = 0;
		int bufferIndex = 1;
		uint32_t indexBase = 0;
		float scale[3] = { 1, 1, 1 }, offset[3] = { 0, 0, 0 };
		const auto vector = [&](size_t v, size_t e, float* to)
		{
			file->Walk(v, e, file->marker, [&](const std::string& n, const std::string&, size_t pv, size_t pe)
			{
				if (pv + 4 <= pe)
				{
					if (n == "X") to[0] = F32(file->data.data() + pv);
					else if (n == "Y") to[1] = F32(file->data.data() + pv);
					else if (n == "Z") to[2] = F32(file->data.data() + pv);
				}
			});
		};
		const size_t meshTail = file->Object(*mesh, [&](const std::string& n, const std::string&, size_t v, size_t e)
		{
			if (n == "materials")
				materialHandles = file->Handles(v, e);
			else if (n == "cookedData")
				file->Walk(v, e, file->marker, [&](const std::string& cn, const std::string&, size_t cv, size_t ce)
				{
					if (cn == "renderChunks")
						file->Bytes(cv, ce, chunksAt, chunksSize);
					else if (cn == "renderBuffer" && cv + 2 <= ce)
						bufferIndex = std::max<int>(1, U16(file->data.data() + cv));
					else if (cn == "indexBufferOffset" && cv + 4 <= ce)
						indexBase = U32(file->data.data() + cv);
					else if (cn == "quantizationScale")
						vector(cv, ce, scale);
					else if (cn == "quantizationOffset")
						vector(cv, ce, offset);
				});
		});
		if (chunksSize == 0)
			return false;
		std::vector<uint8_t> buffer;
		if (!file->Buffer(bufferIndex, path, buffer))
			return false;
		const int meshBones = out.keepSkin ? ReadMeshBones(*file, meshTail, mesh->offset + mesh->size, out) : -1;

		// The count, packed as the engine packs lengths
		const uint8_t* info = file->data.data() + chunksAt;
		size_t at = 0;
		const uint8_t first = info[at++];
		int count = first & 0x3F;
		if (first & 0x40)
			for (int shift = 6; at < chunksSize; shift += 7)
			{
				const uint8_t next = info[at++];
				count |= (next & 0x7F) << shift;
				if (!(next & 0x80))
					break;
			}
		constexpr size_t kChunk = 37;
		if (at + count * kChunk > chunksSize)
			return false;

		struct Resolved { Textures t; std::string diffuse, normal; };
		std::map<int, Resolved> resolved;
		for (int c = 0; c < count; ++c)
		{
			const uint8_t* s = info + at + c * kChunk;
			const int vertexType = s[0];
			const uint32_t positionsAt = U32(s + 1), uvsAt = U32(s + 5), normalsAt = U32(s + 9), colorsAt = U32(s + 13), indicesAt = U32(s + 22);
			const int vertices = U16(s + 27);
			const uint32_t indices = U32(s + 29);
			const int material = s[33], renderMask = s[34];
			int lodMask = s[36];
			if (lodMask == 0)
				lodMask = 1;
			if (!(lodMask & 1) || indices < 3 || vertices == 0)
				continue;
			int stride = vertexType == 3 ? 16 : 8;
			if (vertexType == 3 && uvsAt > positionsAt && (uvsAt - positionsAt) / vertices == 24)
				stride = 24;
			if (positionsAt + static_cast<uint64_t>(vertices) * stride > buffer.size())
				return false;
			const uint64_t trianglesAt = static_cast<uint64_t>(indexBase) + indicesAt;
			const uint32_t triangleIndices = indices - indices % 3;
			if (trianglesAt + triangleIndices * 2ull > buffer.size())
				return false;

			ModelPart part;
			part.shadowOnly = renderMask == 0 && s[21] == 1;
			part.vertices.resize(vertices);
			const bool hasUv = uvsAt != positionsAt && uvsAt + vertices * 4ull <= buffer.size();
			const bool hasNormal = normalsAt > 0 && normalsAt + vertices * 8ull <= buffer.size();
			// Colours, eight bytes a vertex with the colour first, as the Workbench's MeshFile reads them
			const bool hasColour = colorsAt > 0 && colorsAt + vertices * 8ull <= buffer.size();
			for (int v = 0; v < vertices; ++v)
			{
				ModelVertex& o = part.vertices[v];
				const uint8_t* p = buffer.data() + positionsAt + static_cast<size_t>(v) * stride;
				const float x = U16(p) / 65535.f * scale[0] + offset[0], y = U16(p + 2) / 65535.f * scale[1] + offset[1], z = U16(p + 4) / 65535.f * scale[2] + offset[2];
				o.position[0] = x * placed.m[0][0] + y * placed.m[1][0] + z * placed.m[2][0] + placed.m[3][0];
				o.position[1] = x * placed.m[0][1] + y * placed.m[1][1] + z * placed.m[2][1] + placed.m[3][1];
				o.position[2] = x * placed.m[0][2] + y * placed.m[1][2] + z * placed.m[2][2] + placed.m[3][2];
				o.uv[0] = o.uv[1] = 0.f;
				if (hasColour)
					memcpy(o.colour, buffer.data() + colorsAt + v * 8ull, 3);
				if (hasUv)
				{
					const uint8_t* u = buffer.data() + uvsAt + v * 4ull;
					o.uv[0] = Half(U16(u));
					o.uv[1] = Half(U16(u + 2));
				}
				float n[3] = { 0, 0, 1 }, t[3] = { 1, 0, 0 };
				float handed = 1.f;
				if (hasNormal)
				{
					const uint32_t packedNormal = U32(buffer.data() + normalsAt + v * 8ull), packedTangent = U32(buffer.data() + normalsAt + v * 8ull + 4);
					n[0] = Ten(packedNormal); n[1] = Ten(packedNormal >> 10); n[2] = Ten(packedNormal >> 20);
					t[0] = Ten(packedTangent); t[1] = Ten(packedTangent >> 10); t[2] = Ten(packedTangent >> 20);
					handed = packedTangent >> 30 == 3 ? 1.f : -1.f;
				}
				for (int i = 0; i < 3; ++i)
				{
					o.normal[i] = n[0] * placed.m[0][i] + n[1] * placed.m[1][i] + n[2] * placed.m[2][i];
					o.tangent[i] = t[0] * placed.m[0][i] + t[1] * placed.m[1][i] + t[2] * placed.m[2][i];
				}
				o.tangent[3] = handed;
				Normalise(o.normal);
				Normalise(o.tangent);
			}
			if (vertexType == 3 && meshBones >= 0)
			{
				// Bone numbers, then weights as bytes, after a vertex's 8 bytes of position. The shader takes the heaviest four.
				const int perVertex = (stride - 8) / 2;
				part.meshBones = meshBones;
				part.skinning.resize(vertices);
				for (int v = 0; v < vertices; ++v)
				{
					const uint8_t* p = buffer.data() + positionsAt + static_cast<size_t>(v) * stride + 8;
					int order[8] = { 0, 1, 2, 3, 4, 5, 6, 7 };
					std::sort(order, order + perVertex, [&](int a, int b) { return p[perVertex + a] > p[perVertex + b]; });
					int total = 0;
					for (int b = 0; b < 4; ++b)
						total += p[perVertex + order[b]];
					SkinVertex& s = part.skinning[v];
					if (total == 0)
					{
						// Saved with none: it goes wholly with its first bone, as the game draws it
						s.bones[0] = p[0];
						continue;
					}
					int left = 255;
					for (int b = 0; b < 4; ++b)
					{
						s.bones[b] = p[order[b]];
						s.weights[b] = static_cast<uint8_t>(p[perVertex + order[b]] * 255 / total);
						left -= s.weights[b];
					}
					s.weights[0] = static_cast<uint8_t>(s.weights[0] + left);
				}
			}
			part.indices.resize(triangleIndices);
			for (uint32_t i = 0; i < triangleIndices; ++i)
			{
				const uint16_t index = U16(buffer.data() + trianglesAt + i * 2ull);
				part.indices[i] = index < vertices ? index : 0;
			}
			auto known = resolved.find(material);
			if (known == resolved.end())
			{
				Textures t;
				if (material < static_cast<int>(materialHandles.size()))
					ReadMaterial(file, materialHandles[material], t, 0, materials);
				known = resolved.emplace(material, Resolved{ t, Pick(t, false), Pick(t, true) }).first;
			}
			part.diffuse = known->second.diffuse;
			part.normal = known->second.normal;
			ApplyMaterial(known->second.t, part, coloring);
			if (vertexType == 3 && !part.shadowOnly)
				out.worn = true;
			out.parts.push_back(std::move(part));
		}
		return true;
	}
	// ---- cloth: an APEX asset, as the Workbench's Core/Meshes/ClothFile.cs reads it

	struct CachedCloth { uint32_t cache; uint32_t packed, size; uint64_t at; };
	std::vector<std::wstring> g_collisionCaches;
	std::unordered_map<uint64_t, CachedCloth> g_cachedCloth;

	void AddCollisionCache(const std::wstring& path)
	{
		const HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
		if (file == INVALID_HANDLE_VALUE)
			return;
		const auto read = [&](uint64_t at, void* to, size_t count)
		{
			LARGE_INTEGER offset;
			offset.QuadPart = static_cast<LONGLONG>(at);
			DWORD got = 0;
			return SetFilePointerEx(file, offset, nullptr, FILE_BEGIN) && ReadFile(file, to, static_cast<DWORD>(count), &got, nullptr) && got == count;
		};
		uint8_t header[0x40];
		if (read(0, header, sizeof(header)) && memcmp(header, "CC3W", 4) == 0)
		{
			uint64_t indexAt, namesAt;
			memcpy(&indexAt, header + 0x10, 8);
			memcpy(&namesAt, header + 0x1C, 8);
			const uint32_t count = U32(header + 0x18), namesSize = U32(header + 0x24);
			std::vector<uint8_t> names(namesSize), index(count * 64ull);
			if (read(namesAt, names.data(), names.size()) && read(indexAt, index.data(), index.size()))
			{
				const uint32_t cache = static_cast<uint32_t>(g_collisionCaches.size());
				g_collisionCaches.push_back(path);
				for (uint32_t i = 0; i < count; ++i)
				{
					const uint8_t* e = index.data() + i * 64ull;
					const uint32_t nameAt = U32(e);
					if (nameAt >= namesSize)
						continue;
					const char* text = reinterpret_cast<const char*>(names.data() + nameAt);
					const std::string name = Lower(std::string(text, strnlen(text, namesSize - nameAt)));
					if (!Ends(name, ".redcloth"))
						continue;
					uint64_t at;
					memcpy(&at, e + 0x0C, 8);
					g_cachedCloth.emplace(HashOf(name), CachedCloth{ cache, U32(e + 0x14), U32(e + 0x18), at });
				}
			}
		}
		CloseHandle(file);
	}

	bool ReadCachedCloth(const std::string& path, std::vector<uint8_t>& out)
	{
		std::string key = Lower(path);
		auto found = g_cachedCloth.find(HashOf(key));
		if (found == g_cachedCloth.end() && key.rfind("dlc\\", 0) == 0)
		{
			const size_t data = key.find("\\data\\");
			if (data != std::string::npos)
				found = g_cachedCloth.find(HashOf(key.substr(data + 6)));
		}
		if (found == g_cachedCloth.end())
			return false;
		const CachedCloth& c = found->second;
		const HANDLE file = CreateFileW(g_collisionCaches[c.cache].c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
		if (file == INVALID_HANDLE_VALUE)
			return false;
		std::vector<uint8_t> packed(c.packed);
		LARGE_INTEGER offset;
		offset.QuadPart = static_cast<LONGLONG>(c.at);
		DWORD got = 0;
		const bool read = SetFilePointerEx(file, offset, nullptr, FILE_BEGIN) && ReadFile(file, packed.data(), c.packed, &got, nullptr) && got == c.packed;
		CloseHandle(file);
		if (!read)
			return false;
		if (c.packed == c.size)
		{
			out = std::move(packed);
			return true;
		}
		out.resize(c.size);
		return InflateGameData(packed.data(), packed.size(), out.data(), out.size());
	}

	bool Invert(const M4& in, M4& out);

	class Apex
	{
		static constexpr int64_t kFields = 0x78;
		const uint8_t* d;
		size_t n;
		std::map<uint32_t, int> rel;
		std::vector<std::pair<int64_t, std::string>> objects;

		struct Items { int64_t at = -1; int size = 0, count = 0; };

		uint32_t Num(int64_t at) const { return at >= 0 && static_cast<size_t>(at) + 4 <= n ? U32(d + at) : 0; }
		float Real(int64_t at) const { return at >= 0 && static_cast<size_t>(at) + 4 <= n ? F32(d + at) : 0.f; }

		int64_t Pointer(int64_t at, int kind) const
		{
			const auto found = rel.find(static_cast<uint32_t>(at));
			if (found == rel.end() || found->second != kind || static_cast<size_t>(at) + 8 > n)
				return -1;
			uint64_t to;
			memcpy(&to, d + at, 8);
			return to < n ? static_cast<int64_t>(to) : -1;
		}

		Items Array(int64_t at) const
		{
			Items a;
			const int64_t items = Pointer(at, 0);
			if (items < 0)
				return a;
			const int size = static_cast<int>(Num(at + 12)), count = static_cast<int>(Num(at + 16));
			if (size > 0 && count > 0 && static_cast<size_t>(items) + static_cast<uint64_t>(size) * count <= n)
			{
				a.at = items;
				a.size = size;
				a.count = count;
			}
			return a;
		}

		bool IsSubmesh(int64_t o) const { return Pointer(o + kFields, 1) >= 0 && Array(o + kFields + 8).size == 4; }

		int64_t Owner(int64_t at) const
		{
			int64_t owner = -1;
			for (const auto& [header, name] : objects)
			{
				if (header > at)
					break;
				owner = header;
			}
			return owner;
		}

		int64_t First(const char* cls) const
		{
			for (const auto& [header, name] : objects)
				if (name == cls)
					return header + kFields;
			return -1;
		}

	public:
		Apex(const uint8_t* data, size_t size) : d(data), n(size)
		{
			if (n < 32)
				return;
			const uint32_t relAt = (uint32_t(d[28]) << 24) | (uint32_t(d[29]) << 16) | (uint32_t(d[30]) << 8) | d[31];
			if (static_cast<size_t>(relAt) + 4 > n)
				return;
			const uint32_t count = Num(relAt);
			for (uint32_t i = 0; i < count && relAt + 12ull + i * 8ull <= n; ++i)
				rel[Num(relAt + 8 + i * 8ll)] = static_cast<int>(Num(relAt + 4 + i * 8ll));
			std::set<int64_t> seen;
			for (const auto& [at, kind] : rel)
			{
				if (kind != 1)
					continue;
				const int64_t header = Pointer(at, 1);
				if (header < 0 || !seen.insert(header).second)
					continue;
				const int64_t name = Pointer(header + 8, 0);
				if (name >= 0)
				{
					const char* text = reinterpret_cast<const char*>(d + name);
					objects.emplace_back(header, std::string(text, strnlen(text, n - name)));
				}
			}
			std::sort(objects.begin(), objects.end(), [](const auto& a, const auto& b) { return a.first < b.first; });
		}

		// The most detailed render mesh's submeshes, and the corner its UVs count from
		bool MostDetailed(std::vector<int64_t>& submeshes, int& uvOrigin) const
		{
			std::vector<std::pair<int64_t, std::vector<int64_t>>> lists;
			for (const auto& [at, kind] : rel)
			{
				if (kind != 0)
					continue;
				const Items list = Array(at);
				if (list.size != 8)
					continue;
				std::vector<int64_t> found;
				bool all = true;
				for (int i = 0; i < list.count && all; ++i)
				{
					const int64_t s = Pointer(list.at + i * 8ll, 1);
					all = s >= 0 && IsSubmesh(s);
					found.push_back(s);
				}
				if (all)
					lists.emplace_back(Owner(at), std::move(found));
			}
			if (lists.empty())
				return false;
			const auto* chosen = &lists.front();
			const int64_t clothing = First("ClothingAssetParameters");
			if (clothing >= 0)
			{
				const Items graphical = Array(clothing + 24);
				if (graphical.size == 8 && graphical.count > 0)
				{
					const int64_t header = Pointer(graphical.at, 1);
					const int64_t lod = header >= 0 ? header + kFields : -1;
					const int64_t renderMesh = lod >= 0 ? Pointer(lod + 32, 1) : -1;
					for (const auto& l : lists)
						if (l.first == renderMesh)
							chosen = &l;
				}
			}
			submeshes = chosen->second;
			uvOrigin = 0;
			for (const auto& [header, name] : objects)
				if (header == chosen->first && name == "RenderMeshAssetParameters")
					uvOrigin = static_cast<int>(Num(header + kFields + 72));
			return true;
		}

		// What's needed to simulate it, for its most detailed level: struct layouts as NVIDIA's, see the Workbench's ClothAsset.cs.
		// mapped gets, for each of that level's render vertices (its submeshes one after another), what carries it.
		std::shared_ptr<ClothData> Simulation(std::vector<ClothVertex>& mapped, int vertices) const
		{
			const int64_t asset = First("ClothingAssetParameters");
			if (asset < 0)
				return nullptr;
			const auto fixed = [&](int64_t at, int size)
			{
				Items a = Array(at);
				if (a.size != size)
					a = Items{};
				return a;
			};
			const Items physicals = fixed(asset, 8), graphicals = fixed(asset + 24, 8);
			if (graphicals.count <= 0)
				return nullptr;
			const int64_t header = Pointer(graphicals.at, 1);
			if (header < 0)
				return nullptr;
			const int64_t lod = header + kFields;
			const int physicalId = static_cast<int>(Num(lod + 28));
			if (physicalId >= physicals.count)
				return nullptr;
			const int64_t physicalHeader = Pointer(physicals.at + physicalId * 8ll, 1);
			if (physicalHeader < 0)
				return nullptr;
			const int64_t mesh = physicalHeader + kFields;

			auto data = std::make_shared<ClothData>();
			const int count = static_cast<int>(Num(mesh));
			const int per = static_cast<int>(Num(mesh + 8));
			const Items positions = fixed(mesh + 16, 12), skinNormals = fixed(mesh + 64, 12), plainNormals = fixed(mesh + 40, 12);
			const Items coefficients = fixed(mesh + 88, 12), boneIndices = fixed(mesh + 112, 2), boneWeights = fixed(mesh + 136, 4), triangles = fixed(mesh + 192, 4);
			if (positions.count != count || count <= 0 || coefficients.count != count || triangles.count < 3)
				return nullptr;
			const Items normals = skinNormals.count == count ? skinNormals : plainNormals;
			data->positions.resize(count * 3ll);
			data->normals.assign(count * 3ll, 0.f);
			data->maxDistance.resize(count);
			data->backstopRadius.resize(count);
			data->backstopDistance.resize(count);
			for (int v = 0; v < count; ++v)
			{
				for (int k = 0; k < 3; ++k)
				{
					data->positions[v * 3ll + k] = Real(positions.at + v * 12ll + k * 4ll);
					if (normals.count == count)
						data->normals[v * 3ll + k] = Real(normals.at + v * 12ll + k * 4ll);
				}
				const int64_t c = coefficients.at + v * 12ll;
				data->maxDistance[v] = std::max(0.f, Real(c));
				data->backstopRadius[v] = Real(c + 4);
				data->backstopDistance[v] = std::max(0.f, Real(c + 8)) + data->backstopRadius[v];
			}
			if (per > 0 && boneIndices.count == count * per && boneWeights.count == count * per)
			{
				data->bonesPerVertex = per;
				data->boneIndices.resize(boneIndices.count);
				data->boneWeights.resize(boneWeights.count);
				for (int i = 0; i < boneIndices.count; ++i)
				{
					data->boneIndices[i] = U16(d + boneIndices.at + i * 2ll);
					data->boneWeights[i] = Real(boneWeights.at + i * 4ll);
				}
			}
			data->triangles.resize(triangles.count - triangles.count % 3);
			for (size_t i = 0; i < data->triangles.size(); ++i)
				data->triangles[i] = static_cast<int>(Num(triangles.at + static_cast<int64_t>(i) * 4));

			// Its fabric, by the physical mesh's number
			bool haveFabric = false;
			for (const auto& [objectHeader, name] : objects)
			{
				if (name != "ClothingCookedPhysX3Param" || haveFabric)
					continue;
				const int64_t cooked = objectHeader + kFields;
				if (static_cast<int>(Num(cooked)) != physicalId)
					continue;
				const int particles = static_cast<int>(Num(cooked + 8));
				const Items rest = fixed(cooked + 16, 4), pairs = fixed(cooked + 40, 4), sets = fixed(cooked + 136, 24), phases = fixed(cooked + 160, 12);
				const Items anchors = fixed(cooked + 184, 4), lengths = fixed(cooked + 208, 4), masses = fixed(cooked + 232, 4);
				if (particles <= 0 || particles > count || rest.count <= 0 || pairs.count != rest.count * 2 || masses.count != particles || sets.count <= 0 || phases.count <= 0)
					continue;
				data->particles = particles;
				data->setStarts.assign(sets.count + 1ll, 0);
				bool good = true;
				for (int s = 0; s < sets.count; ++s)
				{
					data->setStarts[s + 1ll] = static_cast<int>(Num(sets.at + s * 24ll));
					good = good && data->setStarts[s + 1ll] >= data->setStarts[s];
				}
				good = good && data->setStarts.back() == rest.count;
				data->phaseTypes.resize(phases.count);
				data->phaseSets.resize(phases.count);
				for (int p = 0; p < phases.count; ++p)
				{
					data->phaseTypes[p] = static_cast<int>(Num(phases.at + p * 12ll));
					data->phaseSets[p] = static_cast<int>(Num(phases.at + p * 12ll + 4));
					good = good && data->phaseSets[p] >= 0 && data->phaseSets[p] < sets.count;
				}
				data->restLengths.resize(rest.count);
				for (int i = 0; i < rest.count; ++i)
					data->restLengths[i] = Real(rest.at + i * 4ll);
				data->pairs.resize(pairs.count);
				for (int i = 0; i < pairs.count; ++i)
				{
					data->pairs[i] = static_cast<int>(Num(pairs.at + i * 4ll));
					good = good && data->pairs[i] >= 0 && data->pairs[i] < particles;
				}
				if (anchors.count > 0 && anchors.count % particles == 0 && lengths.count == anchors.count)
				{
					data->tetherAnchors.resize(anchors.count);
					data->tetherLengths.resize(lengths.count);
					for (int i = 0; i < anchors.count; ++i)
					{
						data->tetherAnchors[i] = static_cast<int>(Num(anchors.at + i * 4ll));
						data->tetherLengths[i] = Real(lengths.at + i * 4ll);
						good = good && data->tetherAnchors[i] >= 0 && data->tetherAnchors[i] < particles;
					}
				}
				data->inverseMasses.resize(particles);
				for (int i = 0; i < particles; ++i)
					data->inverseMasses[i] = Real(masses.at + i * 4ll);
				haveFabric = good;
			}
			if (!haveFabric)
				return nullptr;

			// The material the asset picks from its library
			data->thickness = Real(asset + 48 + 4);
			// The asset's own gravity is how it was authored, and some say Y. On him, and on its own, down is always -Z, which is the default.
			const int64_t libraryHeader = Pointer(asset + 320, 1);
			if (libraryHeader >= 0)
			{
				const Items library = fixed(libraryHeader + kFields, 160);
				if (library.count > 0)
				{
					const int picked = std::clamp(static_cast<int>(Num(asset + 328)), 0, library.count - 1);
					const int64_t m = library.at + picked * 160ll;
					ClothMaterialValues& out = data->material;
					out.vertical = Real(m + 16);
					out.horizontal = Real(m + 20);
					out.bending = Real(m + 24);
					out.shearing = Real(m + 28);
					out.tetherStiffness = Real(m + 36);
					out.tetherLimit = Real(m + 40);
					for (int s = 0; s < 4; ++s)
						for (int k = 0; k < 3; ++k)
							out.scaling[s][k] = Real(m + 48 + s * 12ll + k * 4ll);
					out.damping = Real(m + 96);
					out.stiffnessFrequency = Real(m + 100);
					out.drag = Real(m + 104);
					out.friction = Real(m + 112);
					out.massScale = Real(m + 116);
					out.solverFrequency = Real(m + 124);
					out.gravityScale = Real(m + 128);
					out.maxDistanceBias = Real(m + 140);
				}
			}

			// What the body pushes it with
			const Items spheres = fixed(asset + 176, 20);
			for (int i = 0; i < spheres.count; ++i)
			{
				const int64_t s = spheres.at + i * 20ll;
				data->spheres.push_back({ static_cast<int>(Num(s)), Real(s + 4), { Real(s + 8), Real(s + 12), Real(s + 16) } });
			}
			const Items joins = fixed(asset + 200, 2);
			for (int i = 0; i + 1 < joins.count; i += 2)
			{
				const int a = U16(d + joins.at + i * 2ll), b = U16(d + joins.at + i * 2ll + 2);
				if (a < spheres.count && b < spheres.count)
				{
					data->capsules.push_back(a);
					data->capsules.push_back(b);
				}
			}
			// The older way: capsules on bones, each two spheres half its height up and down its Y axis
			const Items actors = fixed(asset + 128, 68);
			for (int i = 0; i < actors.count && spheres.count == 0; ++i)
			{
				const int64_t a = actors.at + i * 68ll;
				const int bone = static_cast<int>(Num(a));
				const float radius = Real(a + 12), height = Real(a + 16);
				if (Num(a + 8) != 0 || radius <= 0.f || bone < 0)
					continue;
				const int64_t pose = a + 20;
				const auto at = [&](float y, int k) { return Real(pose + k * 12ll + 4) * y + Real(pose + (9ll + k) * 4); };
				const int first = static_cast<int>(data->spheres.size());
				data->capsules.push_back(first);
				data->capsules.push_back(first + 1);
				data->spheres.push_back({ bone, radius, { at(height * 0.5f, 0), at(height * 0.5f, 1), at(height * 0.5f, 2) } });
				data->spheres.push_back({ bone, radius, { at(-height * 0.5f, 0), at(-height * 0.5f, 1), at(-height * 0.5f, 2) } });
			}

			// How the render vertices follow the particles
			mapped.assign(vertices, ClothVertex{});
			const Items map = fixed(lod + 96, 52);
			for (int i = 0; i < map.count; ++i)
			{
				const int64_t m = map.at + i * 52ll;
				const int vertex = static_cast<int>(Num(m + 48));
				const uint32_t a = Num(m + 12), b = Num(m + 28), c = Num(m + 44);
				if (vertex < 0 || vertex >= vertices || a >= static_cast<uint32_t>(data->particles) || b >= static_cast<uint32_t>(data->particles) || c >= static_cast<uint32_t>(data->particles))
					continue;
				ClothVertex& v = mapped[vertex];
				v.a = a;
				v.b = b;
				v.c = c;
				v.bary[0] = Real(m);
				v.bary[1] = Real(m + 4);
				v.bary[2] = Real(m + 8);
			}
			const Items immediate = fixed(lod + 48, 4);
			for (int i = 0; i < immediate.count && i < vertices; ++i)
			{
				const uint32_t entry = Num(immediate.at + i * 4ll);
				if ((entry & 0x80000000u) != 0)
					continue;
				const uint32_t particle = entry & 0x0FFFFFFFu;
				if (particle >= static_cast<uint32_t>(data->particles))
					continue;
				ClothVertex& v = mapped[i];
				v.a = v.b = v.c = particle;
				v.bary[0] = 1.f;
				v.bary[1] = v.bary[2] = 0.f;
			}
			return data;
		}

		// The asset's bones, by the number the vertices use: names, and the inverse of the pose each was bound in. A bone is
		// 88 bytes: its number, its pose as a 3x4 (the 3x3 a column at a time, then where it is) at 0x14, its name's pointer at 0x48.
		bool Bones(MeshBones& out) const
		{
			for (const auto& [at, kind] : rel)
			{
				if (kind != 0)
					continue;
				const Items bones = Array(at);
				if (bones.size != 88)
					continue;
				out.names.assign(bones.count, std::string());
				out.inverseBinds.assign(bones.count, std::array<float, 16>{});
				bool good = true;
				for (int i = 0; i < bones.count && good; ++i)
				{
					const int64_t bone = bones.at + i * 88ll;
					const uint32_t number = Num(bone);
					const int64_t name = Pointer(bone + 0x48, 0);
					good = name >= 0 && number < static_cast<uint32_t>(bones.count);
					if (!good)
						break;
					out.names[number] = std::string(reinterpret_cast<const char*>(d + name), strnlen(reinterpret_cast<const char*>(d + name), n - static_cast<size_t>(name)));
					const int64_t pose = bone + 0x14;
					M4 m;
					for (int row = 0; row < 3; ++row)
						for (int column = 0; column < 3; ++column)
							m.m[row][column] = Real(pose + (row + column * 3ll) * 4);
					for (int k = 0; k < 3; ++k)
						m.m[3][k] = Real(pose + (9ll + k) * 4);
					M4 inverse;
					if (!Invert(m, inverse))
						inverse = M4{};
					memcpy(out.inverseBinds[number].data(), inverse.m, sizeof(inverse.m));
				}
				if (good)
					return true;
			}
			out.names.clear();
			out.inverseBinds.clear();
			return false;
		}

		bool Submesh(int64_t submesh, int uvOrigin, const M4& placed, ModelPart& part, bool keepSkin) const
		{
			const int64_t vertexBuffer = Pointer(submesh + kFields, 1);
			const Items indexArray = Array(submesh + kFields + 8);
			if (vertexBuffer < 0 || indexArray.count == 0)
				return false;
			const int vertices = static_cast<int>(Num(vertexBuffer + kFields));
			const Items bufferList = Array(vertexBuffer + kFields + 16);
			if (bufferList.size != 8 || vertices <= 0)
				return false;
			std::vector<Items> threes, twos, fours;
			for (int i = 0; i < bufferList.count; ++i)
			{
				const int64_t buffer = Pointer(bufferList.at + i * 8ll, 1);
				if (buffer < 0)
					continue;
				const Items items = Array(buffer + kFields);
				if (items.count != vertices)
					continue;
				if (items.size == 12) threes.push_back(items);
				else if (items.size == 8) twos.push_back(items);
				else if (items.size == 16) fours.push_back(items);
			}
			if (threes.empty())
				return false;
			part.vertices.resize(vertices);
			for (int v = 0; v < vertices; ++v)
			{
				ModelVertex& o = part.vertices[v];
				const int64_t p = threes[0].at + v * 12ll;
				const float x = Real(p), y = Real(p + 4), z = Real(p + 8);
				o.position[0] = x * placed.m[0][0] + y * placed.m[1][0] + z * placed.m[2][0] + placed.m[3][0];
				o.position[1] = x * placed.m[0][1] + y * placed.m[1][1] + z * placed.m[2][1] + placed.m[3][1];
				o.position[2] = x * placed.m[0][2] + y * placed.m[1][2] + z * placed.m[2][2] + placed.m[3][2];
				float normal[3] = { 0, 0, 1 }, tangent[3] = { 1, 0, 0 };
				float handed = 1.f;
				if (threes.size() > 1)
				{
					const int64_t q = threes[1].at + v * 12ll;
					normal[0] = Real(q);
					normal[1] = Real(q + 4);
					normal[2] = Real(q + 8);
				}
				if (fours.size() > 1)
				{
					const int64_t q = fours[0].at + v * 16ll;
					tangent[0] = Real(q);
					tangent[1] = Real(q + 4);
					tangent[2] = Real(q + 8);
					handed = Real(q + 12) < 0.f ? -1.f : 1.f;
				}
				for (int i = 0; i < 3; ++i)
				{
					o.normal[i] = normal[0] * placed.m[0][i] + normal[1] * placed.m[1][i] + normal[2] * placed.m[2][i];
					o.tangent[i] = tangent[0] * placed.m[0][i] + tangent[1] * placed.m[1][i] + tangent[2] * placed.m[2][i];
				}
				o.tangent[3] = handed;
				Normalise(o.normal);
				Normalise(o.tangent);
				o.uv[0] = o.uv[1] = 0.f;
				if (!twos.empty())
				{
					const float u = Real(twos[0].at + v * 8ll), w = Real(twos[0].at + v * 8ll + 4);
					o.uv[0] = uvOrigin == 1 || uvOrigin == 3 ? 1.f - u : u;
					o.uv[1] = uvOrigin == 2 || uvOrigin == 3 ? 1.f - w : w;
				}
			}
			// The bone numbers are four 16-bit numbers, the last eight-byte buffer; the weights four floats, the last sixteen-byte one
			if (keepSkin && twos.size() > 1 && fours.size() > 1)
			{
				const int64_t numbers = twos.back().at, weights = fours.back().at;
				part.skinning.resize(vertices);
				for (int v = 0; v < vertices; ++v)
				{
					SkinVertex& s = part.skinning[v];
					float amounts[4], total = 0.f;
					for (int k = 0; k < 4; ++k)
					{
						s.bones[k] = static_cast<uint16_t>(Num(numbers + v * 8ll + k * 2ll) & 0xFFFF);
						amounts[k] = std::max(0.f, Real(weights + v * 16ll + k * 4ll));
						total += amounts[k];
					}
					if (total <= 0.f)
						continue;
					int left = 255;
					for (int k = 0; k < 4; ++k)
					{
						s.weights[k] = static_cast<uint8_t>(amounts[k] / total * 255.f);
						left -= s.weights[k];
					}
					s.weights[0] = static_cast<uint8_t>(s.weights[0] + left);
				}
			}
			const int triangleIndices = indexArray.count - indexArray.count % 3;
			part.indices.resize(triangleIndices);
			for (int i = 0; i < triangleIndices; ++i)
			{
				const uint32_t index = Num(indexArray.at + i * 4ll);
				part.indices[i % 3 == 0 ? i : i % 3 == 1 ? i + 1 : i - 1] = index < static_cast<uint32_t>(vertices) ? index : 0;
			}
			return true;
		}
	};

	bool ReadCloth(const std::string& path, const M4& placed, const Coloring* coloring, ItemModel& out, std::map<std::string, std::shared_ptr<Red>>& materials)
	{
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return false;
		std::vector<int32_t> materialHandles;
		std::vector<uint8_t> asset;
		std::map<std::string, float> ownSettings;   // the resource's own, over the asset's
		for (const RedExport& e : file->exports)
		{
			if (file->Name(e.className) != "CApexClothResource")
				continue;
			file->Object(e, [&](const std::string& n, const std::string& type, size_t v, size_t end)
			{
				if (type == "Float" && v + 4 <= end && (n.rfind("mtl", 0) == 0 || n == "simThickness"))
					ownSettings[n] = F32(file->data.data() + v);
				if (n == "materials")
					materialHandles = file->Handles(v, end);
				else if (n == "apexBinaryAsset")
				{
					size_t at, count;
					if (file->Bytes(v, end, at, count) && count > 0)
						asset.assign(file->data.begin() + at, file->data.begin() + at + count);
				}
			});
			break;
		}
		if (asset.empty() && !ReadCachedCloth(path, asset))
			return false;
		static const uint8_t kMagic[4] = { 0x5A, 0x5B, 0x5C, 0x5D };
		const auto start = std::search(asset.begin(), asset.end(), kMagic, kMagic + 4);
		if (start == asset.end())
			return false;
		const Apex apex(&*start, static_cast<size_t>(asset.end() - start));
		std::vector<int64_t> submeshes;
		int uvOrigin = 0;
		if (!apex.MostDetailed(submeshes, uvOrigin))
			return false;
		Textures t;
		if (!materialHandles.empty())
			ReadMaterial(file, materialHandles[0], t, 0, materials);
		const std::string diffuse = Pick(t, false), normal = Pick(t, true);
		bool any = false;
		int meshBones = -1;
		if (out.keepSkin)
		{
			MeshBones bones;
			if (apex.Bones(bones))
			{
				out.meshBones.push_back(std::move(bones));
				meshBones = static_cast<int>(out.meshBones.size()) - 1;
			}
		}
		const size_t firstPart = out.parts.size();
		bool turnedUp = false;
		std::vector<size_t> partVertices;
		for (const int64_t s : submeshes)
		{
			ModelPart part;
			if (!apex.Submesh(s, uvOrigin, placed, part, meshBones >= 0))
				continue;
			part.meshBones = part.skinning.empty() ? -1 : meshBones;
			// Some cloth is kept with Y up, not Z: lying down at the feet, it would go round them and below the ground.
			// It goes up with a quarter turn, to hang where it's worn.
			float lowestZ = FLT_MAX, highestY = -FLT_MAX;
			for (const ModelVertex& v : part.vertices)
			{
				lowestZ = std::min(lowestZ, v.position[2]);
				highestY = std::max(highestY, v.position[1]);
			}
			// (On a body its bones say where it goes, so it's left as they know it.)
			if (part.skinning.empty() && lowestZ < -0.1f && highestY > 0.35f)
			{
				turnedUp = true;
				for (ModelVertex& v : part.vertices)
					for (float* axis : { v.position, v.normal, v.tangent })
					{
						const float y = axis[1], z = axis[2];
						axis[1] = -z;
						axis[2] = y;
					}
			}
			part.diffuse = diffuse;
			part.normal = normal;
			ApplyMaterial(t, part, coloring);
			out.parts.push_back(std::move(part));
			out.worn = true;
			any = true;
		}

		// If it can be simulated, each of its vertices learns what carries it
		size_t total = 0;
		for (size_t p = firstPart; p < out.parts.size(); ++p)
			total += out.parts[p].vertices.size();
		std::vector<ClothVertex> mapped;
		std::shared_ptr<ClothData> sim = any ? apex.Simulation(mapped, static_cast<int>(total)) : nullptr;
		if (sim)
		{
			const auto own = [&](const char* name, float& value)
			{
				const auto found = ownSettings.find(name);
				if (found != ownSettings.end())
					value = found->second;
			};
			ClothMaterialValues& m = sim->material;
			own("mtlFriction", m.friction);
			own("mtlMassScale", m.massScale);
			own("mtlGravityScale", m.gravityScale);
			own("mtlBendingStiffness", m.bending);
			own("mtlShearingStiffness", m.shearing);
			own("mtlTetherStiffness", m.tetherStiffness);
			own("mtlTetherLimit", m.tetherLimit);
			own("mtlDamping", m.damping);
			own("mtlDrag", m.drag);
			own("mtlMaxDistanceBias", m.maxDistanceBias);
			own("simThickness", sim->thickness);

			MeshBones bones;
			if (meshBones >= 0)
				bones = out.meshBones[meshBones];
			else
				apex.Bones(bones);
			sim->bindPoses.resize(bones.inverseBinds.size() * 16);
			for (size_t b = 0; b < bones.inverseBinds.size(); ++b)
			{
				M4 inverse, bind;
				memcpy(inverse.m, bones.inverseBinds[b].data(), sizeof(inverse.m));
				if (!Invert(inverse, bind))
					bind = M4{};
				memcpy(sim->bindPoses.data() + b * 16, bind.m, sizeof(bind.m));
			}
			sim->meshBones = meshBones;
			if (meshBones < 0)
			{
				// With no bones it hangs where the vertices were put: its particles and its spheres go there too
				const auto place = [&](float* p, bool point)
				{
					const float x = p[0], y = p[1], z = p[2];
					for (int k = 0; k < 3; ++k)
						p[k] = x * placed.m[0][k] + y * placed.m[1][k] + z * placed.m[2][k] + (point ? placed.m[3][k] : 0.f);
					if (turnedUp)
					{
						const float py = p[1], pz = p[2];
						p[1] = -pz;
						p[2] = py;
					}
				};
				for (size_t v = 0; v * 3 < sim->positions.size(); ++v)
				{
					place(sim->positions.data() + v * 3, true);
					place(sim->normals.data() + v * 3, false);
				}
				for (ClothSphereValues& s : sim->spheres)
				{
					if (s.bone >= 0 && static_cast<size_t>(s.bone) * 16 + 16 <= sim->bindPoses.size())
					{
						const float* m = sim->bindPoses.data() + static_cast<size_t>(s.bone) * 16;
						const float x = s.local[0], y = s.local[1], z = s.local[2];
						for (int k = 0; k < 3; ++k)
							s.local[k] = x * m[k] + y * m[4 + k] + z * m[8 + k] + m[12 + k];
					}
					place(s.local, true);
					s.bone = -1;
				}
				sim->bonesPerVertex = 0;
			}
			const int index = static_cast<int>(out.cloths.size());
			out.cloths.push_back(sim);
			size_t at = 0;
			for (size_t p = firstPart; p < out.parts.size(); ++p)
			{
				ModelPart& part = out.parts[p];
				part.cloth = index;
				part.clothing.assign(mapped.begin() + static_cast<ptrdiff_t>(at), mapped.begin() + static_cast<ptrdiff_t>(at + part.vertices.size()));
				at += part.vertices.size();
			}
		}
		return any;
	}
}

std::vector<std::string> BundleFileNames(const std::wstring& bundle)
{
	std::vector<std::string> names;
	const HANDLE file = CreateFileW(bundle.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, 0, nullptr);
	if (file == INVALID_HANDLE_VALUE)
		return names;
	uint8_t header[32];
	DWORD got = 0;
	if (ReadFile(file, header, 32, &got, nullptr) && got == 32 && memcmp(header, "POTATO70", 8) == 0 && (U16(header + 0x14) == 5 || U16(header + 0x14) == 3))
	{
		const size_t kEntry = U16(header + 0x14) == 3 ? 0x140 : 0x130;
		const size_t tocSize = U32(header + 0x10);
		std::vector<uint8_t> toc(tocSize);
		if (tocSize % kEntry == 0 && ReadFile(file, toc.data(), static_cast<DWORD>(tocSize), &got, nullptr) && got == tocSize)
			for (size_t at = 0; at < tocSize; at += kEntry)
				names.push_back(Lower(std::string(reinterpret_cast<const char*>(toc.data() + at), strnlen(reinterpret_cast<const char*>(toc.data() + at), 0x100))));
	}
	CloseHandle(file);
	return names;
}

bool ReadBundleFile(const std::wstring& bundle, const std::string& lowerName, std::vector<uint8_t>& out)
{
	const HANDLE file = CreateFileW(bundle.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, 0, nullptr);
	if (file == INVALID_HANDLE_VALUE)
		return false;
	uint8_t header[32];
	DWORD got = 0;
	bool found = false;
	Located entry{};
	if (ReadFile(file, header, 32, &got, nullptr) && got == 32 && memcmp(header, "POTATO70", 8) == 0 && (U16(header + 0x14) == 5 || U16(header + 0x14) == 3))
	{
		const bool older = U16(header + 0x14) == 3;
		const size_t kEntry = older ? 0x140 : 0x130;
		const size_t tocSize = U32(header + 0x10);
		std::vector<uint8_t> toc(tocSize);
		if (tocSize % kEntry == 0 && ReadFile(file, toc.data(), static_cast<DWORD>(tocSize), &got, nullptr) && got == tocSize)
			for (size_t at = 0; at < tocSize && !found; at += kEntry)
			{
				const uint8_t* e = toc.data() + at;
				if (Lower(std::string(reinterpret_cast<const char*>(e), strnlen(reinterpret_cast<const char*>(e), 0x100))) != lowerName)
					continue;
				uint64_t offset = U32(e + 0x11C);
				if (!older)
					memcpy(&offset, e + 0x110, 8);
				entry = older ? Located{ 0, U32(e + 0x114), U32(e + 0x118), U32(e + 0x13C), offset } : Located{ 0, U32(e + 0x118), U32(e + 0x11C), U32(e + 0x124), offset };
				found = true;
			}
	}
	CloseHandle(file);
	return found && UnpackEntry(bundle, entry, lowerName, out);
}

// name="value" in a tag, for a name that starts a word
static std::string TagValue(const std::string& tag, const char* name)
{
	const size_t length = strlen(name);
	for (size_t at = tag.find(name); at != std::string::npos; at = tag.find(name, at + 1))
	{
		if (at == 0 || !isspace(static_cast<unsigned char>(tag[at - 1])))
			continue;
		size_t i = at + length;
		while (i < tag.size() && isspace(static_cast<unsigned char>(tag[i])))
			++i;
		if (i >= tag.size() || tag[i] != '=')
			continue;
		++i;
		while (i < tag.size() && isspace(static_cast<unsigned char>(tag[i])))
			++i;
		if (i >= tag.size() || tag[i] != '"')
			continue;
		const size_t end = tag.find('"', i + 1);
		return end == std::string::npos ? std::string() : tag.substr(i + 1, end - i - 1);
	}
	return {};
}

static bool IsWornCategory(const std::string& category)
{
	return category == "armor" || category == "pants" || category == "boots" || category == "gloves"
		|| category == "steelsword" || category == "silversword" || category == "crossbow" || category == "mask";
}

// Every quest's title, from its journal: the files first found win, as for the rest, so a mod's own copy counts
static void ReadQuestTitles()
{
	std::unordered_set<std::string> seenFiles, seenQuests;
	for (const std::string& path : g_journalFiles)
	{
		if (!seenFiles.insert(path).second)
			continue;
		Red f;
		if (!ReadGameFile(path, f.data) || !f.Open())
			continue;
		for (const RedExport& e : f.exports)
		{
			if (f.Name(e.className) != "CJournalQuest")
				continue;
			std::string baseName;
			uint32_t title = 0;
			f.Object(e, [&](const std::string& n, const std::string& t, size_t v, size_t end)
			{
				if (n == "baseName" && t == "String")
					baseName = f.Text(v, end);
				else if (n == "title" && t == "LocalizedString" && v + 4 <= end)
					title = U32(f.data.data() + v);
			});
			if (!baseName.empty() && title != 0 && seenQuests.insert(Lower(baseName)).second)
				g_questTitles.emplace_back(baseName, title);
		}
	}
	Log("quest titles: %zu quests in %zu journal files", g_questTitles.size(), seenFiles.size());
	g_questTitlesReady = true;
}

// Each <variant> in a piece of XML: its template, and what has to be worn for it
static std::vector<WornVariant> ReadVariants(const std::string& body)
{
	std::vector<WornVariant> out;
	for (size_t v = body.find("<variant"); v != std::string::npos; v = body.find("<variant", v + 8))
	{
		if (v + 8 < body.size() && body[v + 8] == 's')
			continue;   // <variants>, the list itself
		const size_t end = body.find('>', v);
		if (end == std::string::npos)
			break;
		const std::string tag = body.substr(v, end - v);
		WornVariant variant;
		variant.equip = Lower(TagValue(tag, "equip_template"));
		variant.category = Lower(TagValue(tag, "category"));
		variant.all = Lower(TagValue(tag, "all")) == "true";
		if (variant.equip.empty())
			continue;
		// What's inside it, up to its close (a self-closed one has nothing)
		const bool selfClosed = end > v && body[end - 1] == '/';
		const size_t close = selfClosed ? end : body.find("</variant>", end);
		const std::string inside = close == std::string::npos ? std::string() : body.substr(end + 1, close - end - 1);
		const auto each = [&](const char* open, const char* shut, std::vector<std::string>& into)
		{
			const size_t openLen = strlen(open);
			for (size_t at = inside.find(open); at != std::string::npos; at = inside.find(open, at + openLen))
			{
				const size_t stop = inside.find(shut, at);
				if (stop == std::string::npos)
					break;
				std::string value = Lower(inside.substr(at + openLen, stop - at - openLen));
				value.erase(0, value.find_first_not_of(" \t\r\n"));
				value.erase(value.find_last_not_of(" \t\r\n") + 1);
				if (!value.empty())
					into.push_back(value);
			}
		};
		each("<item>", "</item>", variant.items);
		each("<item_category>", "</item_category>", variant.categories);
		if (variant.category.empty() && variant.items.empty() && variant.categories.empty())
			continue;   // nothing calls for it
		out.push_back(std::move(variant));
	}
	return out;
}

static void ReadWornItems()
{
	std::vector<std::string> texts;
	for (const std::string& path : g_itemDefinitionFiles)
	{
		std::vector<uint8_t> data;
		if (ReadGameFile(path, data))
			texts.emplace_back(data.begin(), data.end());
	}
	for (const std::string& text : texts)
	{
		// An item's own tag has attributes. A bare <item> names one bound to it.
		const auto nextItem = [&](size_t from)
		{
			for (size_t at = text.find("<item", from); at != std::string::npos; at = text.find("<item", at + 5))
				if (at + 5 < text.size() && isspace(static_cast<unsigned char>(text[at + 5])))
					return at;
			return std::string::npos;
		};
		for (size_t at = nextItem(0); at != std::string::npos;)
		{
			const size_t close = text.find('>', at);
			if (close == std::string::npos)
				break;
			const size_t next = nextItem(close);
			const std::string tag = text.substr(at, close - at);
			WornItem item;
			item.category = Lower(TagValue(tag, "category"));
			item.equipTemplate = Lower(TagValue(tag, "equip_template"));
			const std::string name = Lower(TagValue(tag, "name"));
			item.name = name;
			item.slot = Lower(TagValue(tag, "equip_slot"));
			const bool scabbard = name.find("scabbard") != std::string::npos;
			if (!name.empty() && !item.equipTemplate.empty() && (IsWornCategory(item.category) || item.category == "hair" || scabbard))
			{
				const std::string body = text.substr(close, next == std::string::npos ? std::string::npos : next - close);
				if (const size_t bound = body.find("<bound_items>"); bound != std::string::npos)
					if (const size_t open = body.find("<item>", bound); open != std::string::npos)
						if (const size_t shut = body.find("</item>", open); shut != std::string::npos)
						{
							std::string first = Lower(body.substr(open + 6, shut - open - 6));
							first.erase(0, first.find_first_not_of(" \t\r\n"));
							first.erase(first.find_last_not_of(" \t\r\n") + 1);
							item.bound = first;
						}
				// Its variants: only up to its own close. Bare <item>name</item> lines inside it (bound items, a variant's
				// items) each close themselves, so its own is the first close with no bare open before it.
				size_t own = body.size();
				int depth = 0;
				for (size_t p = 0; p < body.size(); ++p)
				{
					if (body.compare(p, 6, "<item>") == 0)
						++depth;
					else if (body.compare(p, 7, "</item>") == 0 && depth-- == 0)
					{
						own = p;
						break;
					}
				}
				item.variants = ReadVariants(body.substr(0, own));
				g_wornByName.emplace(name, std::move(item));
			}
			at = next;
		}
	}
	// Then what mods add to items they don't own: <item_extension name="..."> with more variants, ahead of the item's
	// own, as they're there to take over from them (a hood's shorter hair in place of the armour's)
	size_t extensions = 0;
	for (const std::string& text : texts)
		for (size_t at = text.find("<item_extension"); at != std::string::npos; at = text.find("<item_extension", at + 15))
		{
			const size_t close = text.find('>', at);
			const size_t end = close == std::string::npos ? std::string::npos : text.find("</item_extension>", close);
			if (end == std::string::npos)
				break;
			const auto found = g_wornByName.find(Lower(TagValue(text.substr(at, close - at), "name")));
			if (found == g_wornByName.end())
				continue;
			std::vector<WornVariant> added = ReadVariants(text.substr(close, end - close));
			extensions += added.size();
			found->second.variants.insert(found->second.variants.begin(), added.begin(), added.end());
		}
	// By template: the game can give any cut of it, and the cut for wearing with gloves is the same item
	for (const auto& [name, item] : g_wornByName)
	{
		for (const WornVariant& variant : item.variants)
			g_wornByTemplate.emplace(variant.equip, item);
		g_wornByTemplate.emplace(item.equipTemplate, item);
	}
	Log("item models: %zu worn items, %zu variants added by extensions", g_wornByName.size(), extensions);
}

void BuildModelIndex(const std::wstring& game)
{
	namespace fs = std::filesystem;
	std::error_code ec;
	const auto add = [&](const fs::path& folder)
	{
		std::vector<fs::path> found;
		for (const auto& item : fs::directory_iterator(folder, ec))
			if (item.path().extension() == L".bundle")
				found.push_back(item.path());
		std::sort(found.begin(), found.end());
		for (const fs::path& bundle : found)
			AddBundle(bundle.wstring());
	};
	for (const wchar_t* top : { L"mods", L"dlc" })
	{
		std::vector<fs::path> owners;
		for (const auto& item : fs::directory_iterator(fs::path(game) / top, ec))
			if (item.is_directory(ec))
				owners.push_back(item.path());
		std::sort(owners.begin(), owners.end());
		for (const fs::path& owner : owners)
		{
			add(owner / L"content");
			AddCollisionCache((owner / L"content" / L"collision.cache").wstring());
		}
	}
	std::vector<fs::path> contents;
	for (const auto& item : fs::directory_iterator(fs::path(game) / L"content", ec))
		if (item.is_directory(ec) && item.path().filename().wstring().rfind(L"content", 0) == 0)
			contents.push_back(item.path());
	std::sort(contents.begin(), contents.end());
	for (const fs::path& content : contents)
	{
		add(content / L"bundles");
		AddCollisionCache((content / L"collision.cache").wstring());
	}
	ReadWornItems();
	ReadQuestTitles();
	Log("item models: %zu files in %zu bundles, %zu templates, %zu worn items", g_files.size(), g_bundles.size(), g_templates.size(), g_wornByTemplate.size());
	g_ready = true;
}

bool ModelIndexReady()
{
	return g_ready;
}

const std::vector<std::pair<std::string, uint32_t>>* QuestTitles()
{
	return g_questTitlesReady ? &g_questTitles : nullptr;
}

// The turn that brings an item's front to the viewer, worked out by rendering every kind from one angle: what's worn
// is modelled facing away, a crossbow side on, a trophy with its face to one side. An item the rules get wrong goes in
// the table, by part of its template's path.
static float FacingOf(const std::string& path, bool worn)
{
	static const struct { const char* path; float yaw; } kOverrides[] = {
		{ "", 0.f },
	};
	for (const auto& o : kOverrides)
		if (o.path[0] && path.find(o.path) != std::string::npos)
			return o.yaw;
	if (path.find("trophy") != std::string::npos || path.find("trophies") != std::string::npos)
		return 120.f;
	if (path.find("crossbow") != std::string::npos)
		return 90.f;
	return worn ? 180.f : 0.f;
}

static std::string TemplateStem(const std::string& templateName);
namespace
{
	std::mutex g_dyeLooksMutex;
	std::unordered_map<std::string, std::vector<std::string>> g_dyeLooks;

	void RememberDyeLooks(const std::string& stem, std::vector<std::string> looks)
	{
		std::lock_guard lock(g_dyeLooksMutex);
		g_dyeLooks[stem] = std::move(looks);
	}
}

// Set while a piece is loaded to dress Geralt: then all of it is drawn, as the game draws it on him
static thread_local bool t_dressingGeralt = false;

// The body part a Geralt mesh or cloth is for, by its file's name: g_01_mg__... gloves, t_ torso, l_ legs, s_ shoes
static char PiecePart(const std::string& path)
{
	const size_t slash = path.find_last_of("\\/");
	const std::string file = Lower(path.substr(slash == std::string::npos ? 0 : slash + 1));
	if (file.size() > 4 && strchr("gtls", file[0]) && file[1] == '_' && isdigit(static_cast<unsigned char>(file[2])) && isdigit(static_cast<unsigned char>(file[3])))
		return file[0];
	return 0;
}

bool LoadItemModel(const std::string& templateName, ItemModel& out)
{
	if (!g_ready)
	{
		out.problem = "not ready";
		return false;
	}
	// name#dye_red: that appearance of it
	const size_t dyeAt = templateName.find('#');
	const std::string dye = dyeAt == std::string::npos ? std::string() : templateName.substr(dyeAt + 1);
	// The game gives a template's whole path; the items' definitions give its name
	const std::string asked = Lower(templateName.substr(0, dyeAt));
	std::string templatePath = asked;
	if (asked.find('\\') == std::string::npos)
	{
		const auto named = g_templates.find(asked);
		if (named == g_templates.end())
		{
			out.problem = "no template named " + templateName;
			return false;
		}
		templatePath = named->second;
	}
	std::map<std::string, std::shared_ptr<Entity>> entities;
	const std::shared_ptr<Entity> entity = ReadEntity(templatePath);
	if (!entity)
	{
		out.problem = "can't read " + templatePath;
		return false;
	}
	std::vector<Component> components = entity->components;
	std::vector<Coloring> colorings = entity->colorings;
	// The look asked for, or the default: dye_default, or the first
	const Entity::Look* look = nullptr;
	std::vector<std::string> dyeLooks;
	for (const Entity::Look& l : entity->looks)
	{
		if (_strnicmp(l.name.c_str(), "dye_", 4) == 0)
			dyeLooks.push_back(Lower(l.name));
		if (_stricmp(l.name.c_str(), "dye_default") == 0 && !look)
			look = &l;
		if (!dye.empty() && _stricmp(l.name.c_str(), dye.c_str()) == 0)
			look = &l;
	}
	RememberDyeLooks(TemplateStem(templatePath), std::move(dyeLooks));
	if (!look && !entity->looks.empty())
		look = &entity->looks.front();
	if (look)
	{
		std::set<std::string> seen;
		for (const std::string& t : look->templates)
			AddTemplate(t, components, colorings, seen, 0, entities);
	}
	{
		std::set<std::string> seen;
		for (const std::string& include : entity->includes)
			AddTemplate(include, components, colorings, seen, 0, entities);
	}
	// Its dangles' physics, from it and every template it brings in (a hood's tails are often in one of its own)
	// The ones its drawn meshes are skinned to come first, as two hairstyles' dangles have the same bone names and the
	// first to name a bone gives it its place
	for (const Component& c : components)
		if (!c.mesh.empty() && !c.shadow && !c.dyng.empty() && std::find(out.dyngs.begin(), out.dyngs.end(), c.dyng) == out.dyngs.end())
			out.dyngs.push_back(c.dyng);
	const auto addDyngs = [&](const Entity& e)
	{
		for (const std::string& d : e.dyngs)
			if (std::find(out.dyngs.begin(), out.dyngs.end(), d) == out.dyngs.end()
				&& std::find(out.spareDyngs.begin(), out.spareDyngs.end(), d) == out.spareDyngs.end())
				out.spareDyngs.push_back(d);
	};
	addDyngs(*entity);
	for (const auto& [path, part] : entities)
		if (part)
			addDyngs(*part);
	const auto coloringOf = [&](const std::string& component) -> const Coloring*
	{
		if (!look)
			return nullptr;
		for (const Coloring& c : colorings)
			if (_stricmp(c.appearance.c_str(), look->name.c_str()) == 0 && _stricmp(c.component.c_str(), component.c_str()) == 0)
				return &c;
		return nullptr;
	};

	std::map<std::string, std::shared_ptr<Red>> materials;
	std::vector<std::pair<std::string, M4>> done;
	// Shown on its own, a piece leaves out cloth made for another part of him: the Viper gauntlets bring the armour's
	// cord, which has nothing to hang from without him
	std::string ownParts;
	if (!t_dressingGeralt)
		for (const Component& c : components)
			if (!c.mesh.empty() && !c.shadow && !Ends(Lower(c.mesh), ".redcloth"))
				if (const char part = PiecePart(c.mesh); part && ownParts.find(part) == std::string::npos)
					ownParts += part;
	for (const Component& c : components)
	{
		if (c.mesh.empty() || c.shadow)
			continue;
		if (!ownParts.empty() && Ends(Lower(c.mesh), ".redcloth"))
			if (const char part = PiecePart(c.mesh); part && ownParts.find(part) == std::string::npos)
				continue;
		// A crossbow on his back hangs half turned from how it's kept: found by matching the game's own look
		// Cloth is skinned to the rig wherever its component was put: the Hoods mod's Avallach hood is moved up 1.4 m and
		// modelled at head height, so the move would count his height twice
		const std::string key = Lower(c.mesh);
		const bool cloth = Ends(key, ".redcloth");
		const M4 placed = (c.skinned || cloth ? M4{} : c.placed) * (out.halfTurned ? RotateZ(3.14159265358979f) : M4{});
		if (key.find("sphere_green") != std::string::npos)   // a marker left in one template, far from the item
			continue;
		if (key.rfind("environment\\blockout", 0) == 0)   // an editor's stand-in shape, as the pixie keeps a grey cone
			continue;
		if (std::any_of(done.begin(), done.end(), [&](const auto& d) { return d.first == key && d.second.Same(placed); }))
			continue;
		done.emplace_back(key, placed);
		if (Ends(key, ".redcloth"))
		{
			if (!ReadCloth(c.mesh, placed, coloringOf(c.name), out, materials))
			{
				++out.clothSkipped;
				Log("item models: can't read %s", c.mesh.c_str());
			}
			continue;
		}
		const size_t partsBefore = out.parts.size();
		bool readIt = ReadMesh(c.mesh, placed, coloringOf(c.name), out, materials);
		// A creature's skinned mesh goes on its rig as it's bound, wherever its component was put: the game skins it
		if (readIt && out.creature && !c.skinned && !placed.Same(M4{})
			&& std::any_of(out.parts.begin() + partsBefore, out.parts.end(), [](const ModelPart& p) { return !p.skinning.empty(); }))
		{
			out.parts.resize(partsBefore);
			readIt = ReadMesh(c.mesh, M4{}, coloringOf(c.name), out, materials);
		}
		if (readIt)
		{
			for (size_t p = partsBefore; p < out.parts.size(); ++p)
			{
				out.parts[p].attachBone = c.bone;
				out.parts[p].rigidComponent = !c.skinned;
			}
		}
		else
			Log("item models: can't read %s", c.mesh.c_str());
	}
	if (out.parts.empty())
	{
		// A quest's item can keep its look in a template beside its own
		if (Ends(templatePath, ".w2ent") && !Ends(templatePath, "_mesh.w2ent"))
		{
			const std::string beside = templatePath.substr(0, templatePath.size() - 6) + "_mesh.w2ent";
			if (g_files.count(HashOf(beside)))
				return LoadItemModel(beside, out);
		}
		out.problem = "no meshes in " + templatePath;
		return false;
	}
	out.facingYaw = FacingOf(templatePath, out.worn);
	for (int i = 0; i < 3; ++i)
	{
		out.boundsMin[i] = FLT_MAX;
		out.boundsMax[i] = -FLT_MAX;
	}
	for (const ModelPart& part : out.parts)
		if (!part.shadowOnly)
			for (const ModelVertex& v : part.vertices)
				for (int i = 0; i < 3; ++i)
				{
					out.boundsMin[i] = std::min(out.boundsMin[i], v.position[i]);
					out.boundsMax[i] = std::max(out.boundsMax[i], v.position[i]);
				}
	return true;
}

// The game gives a template's whole path, the definitions its name
static std::string TemplateStem(const std::string& templateName)
{
	std::string stem = Lower(templateName.substr(0, templateName.find('#')));
	const size_t slash = stem.find_last_of("\\/");
	if (slash != std::string::npos)
		stem.erase(0, slash + 1);
	if (Ends(stem, ".w2ent"))
		stem.resize(stem.size() - 6);
	return stem;
}

// ---- the idle he stands in, as the Workbench's Core/Animation has it: Skeleton.cs, AnimationClip.cs and Skinning.cs

namespace
{
	struct Bone { float position[3], rotation[4], scale[3]; };

	struct Rig
	{
		std::vector<std::string> names;
		std::vector<int16_t> parents;
		std::vector<Bone> pose;
		std::vector<M4> rest;   // each bone in the model as it stands
	};

	struct KeyTrack { float dt = 0.f; uint32_t count = 0, at = 0; int compression = 0; };
	struct BoneTracks { KeyTrack position, orientation, scale; };

	struct Clip
	{
		std::vector<BoneTracks> bones;
		std::vector<uint8_t> data;
		std::string method = "ABOCM_PackIn64bitsW";
		float duration = 0.f, frameTime = 1.f / 30.f;
		uint32_t frames = 1;
	};

	M4 BoneMatrix(const Bone& b)
	{
		const float x = b.rotation[0], y = b.rotation[1], z = b.rotation[2], w = b.rotation[3];
		M4 r;
		r.m[0][0] = (1 - 2 * (y * y + z * z)) * b.scale[0];
		r.m[0][1] = 2 * (x * y + w * z) * b.scale[0];
		r.m[0][2] = 2 * (x * z - w * y) * b.scale[0];
		r.m[1][0] = 2 * (x * y - w * z) * b.scale[1];
		r.m[1][1] = (1 - 2 * (z * z + x * x)) * b.scale[1];
		r.m[1][2] = 2 * (y * z + w * x) * b.scale[1];
		r.m[2][0] = 2 * (z * x + w * y) * b.scale[2];
		r.m[2][1] = 2 * (y * z - w * x) * b.scale[2];
		r.m[2][2] = (1 - 2 * (y * y + x * x)) * b.scale[2];
		r.m[3][0] = b.position[0];
		r.m[3][1] = b.position[1];
		r.m[3][2] = b.position[2];
		return r;
	}

	// A matrix of BoneMatrix's back to its turn and place (its scale taken as one)
	void BoneFromMatrix(const M4& m, Bone& b)
	{
		float q[4];
		const float trace = m.m[0][0] + m.m[1][1] + m.m[2][2];
		if (trace > 0.f)
		{
			const float s = sqrtf(trace + 1.f) * 2.f;
			q[3] = 0.25f * s;
			q[0] = (m.m[1][2] - m.m[2][1]) / s;
			q[1] = (m.m[2][0] - m.m[0][2]) / s;
			q[2] = (m.m[0][1] - m.m[1][0]) / s;
		}
		else if (m.m[0][0] > m.m[1][1] && m.m[0][0] > m.m[2][2])
		{
			const float s = sqrtf(1.f + m.m[0][0] - m.m[1][1] - m.m[2][2]) * 2.f;
			q[3] = (m.m[1][2] - m.m[2][1]) / s;
			q[0] = 0.25f * s;
			q[1] = (m.m[1][0] + m.m[0][1]) / s;
			q[2] = (m.m[2][0] + m.m[0][2]) / s;
		}
		else if (m.m[1][1] > m.m[2][2])
		{
			const float s = sqrtf(1.f + m.m[1][1] - m.m[0][0] - m.m[2][2]) * 2.f;
			q[3] = (m.m[2][0] - m.m[0][2]) / s;
			q[0] = (m.m[1][0] + m.m[0][1]) / s;
			q[1] = 0.25f * s;
			q[2] = (m.m[2][1] + m.m[1][2]) / s;
		}
		else
		{
			const float s = sqrtf(1.f + m.m[2][2] - m.m[0][0] - m.m[1][1]) * 2.f;
			q[3] = (m.m[0][1] - m.m[1][0]) / s;
			q[0] = (m.m[2][0] + m.m[0][2]) / s;
			q[1] = (m.m[2][1] + m.m[1][2]) / s;
			q[2] = 0.25f * s;
		}
		const float length = sqrtf(q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3]);
		for (int k = 0; k < 4; ++k)
			b.rotation[k] = q[k] / std::max(length, 1e-8f);
		for (int k = 0; k < 3; ++k)
			b.position[k] = m.m[3][k];
	}

	void ToModel(const Rig& rig, const std::vector<Bone>& local, std::vector<M4>& model)
	{
		model.resize(rig.parents.size());
		for (size_t i = 0; i < rig.parents.size(); ++i)
		{
			const M4 own = BoneMatrix(local[i]);
			const int parent = rig.parents[i];
			model[i] = parent >= 0 && parent < static_cast<int>(i) ? own * model[parent] : own;
		}
	}

	bool Invert(const M4& in, M4& out)
	{
		float a[4][8];
		for (int i = 0; i < 4; ++i)
			for (int j = 0; j < 4; ++j)
			{
				a[i][j] = in.m[i][j];
				a[i][j + 4] = i == j ? 1.f : 0.f;
			}
		for (int c = 0; c < 4; ++c)
		{
			int pivot = c;
			for (int r = c + 1; r < 4; ++r)
				if (fabsf(a[r][c]) > fabsf(a[pivot][c]))
					pivot = r;
			if (fabsf(a[pivot][c]) < 1e-9f)
				return false;
			if (pivot != c)
				for (int j = 0; j < 8; ++j)
					std::swap(a[c][j], a[pivot][j]);
			const float scale = 1.f / a[c][c];
			for (int j = 0; j < 8; ++j)
				a[c][j] *= scale;
			for (int r = 0; r < 4; ++r)
				if (r != c)
				{
					const float by = a[r][c];
					for (int j = 0; j < 8; ++j)
						a[r][j] -= by * a[c][j];
				}
		}
		for (int i = 0; i < 4; ++i)
			for (int j = 0; j < 4; ++j)
				out.m[i][j] = a[i][j + 4];
		return true;
	}

	// An array of structs: a count, then each one's properties
	template <typename F>
	void EachStruct(const Red& file, size_t v, size_t e, F&& each)
	{
		if (v + 4 > e)
			return;
		const uint32_t count = U32(file.data.data() + v);
		size_t at = v + 4;
		for (uint32_t i = 0; i < count && at < e; ++i)
		{
			size_t after = at;
			if (!file.Walk(at, e, file.marker, [&](const std::string& n, const std::string& t, size_t pv, size_t pe) { each(i, n, t, pv, pe); }, &after) || after <= at)
				return;
			at = after;
		}
	}

	bool ReadRig(const std::string& path, Rig& rig)
	{
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return false;
		for (const RedExport& e : file->exports)
		{
			if (file->Name(e.className) != "CSkeleton")
				continue;
			const size_t tail = file->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
			{
				if (n == "bones")
					EachStruct(*file, v, end, [&](uint32_t i, const std::string& pn, const std::string&, size_t pv, size_t pe)
					{
						if (rig.names.size() <= i)
							rig.names.resize(i + 1);
						if (pn == "nameAsCName" && pv + 2 <= pe)
							rig.names[i] = file->Name(U16(file->data.data() + pv));
					});
				else if (n == "parentIndices" && v + 4 <= end)
				{
					const uint32_t count = U32(file->data.data() + v);
					for (uint32_t i = 0; i < count && v + 4 + (i + 1) * 2ull <= end; ++i)
						rig.parents.push_back(static_cast<int16_t>(U16(file->data.data() + v + 4 + i * 2ull)));
				}
			});
			if (rig.names.empty() || rig.names.size() != rig.parents.size())
				return false;
			rig.pose.resize(rig.names.size());
			const size_t end = e.offset + e.size;
			for (size_t i = 0; i < rig.pose.size(); ++i)
			{
				Bone& b = rig.pose[i];
				const size_t at = tail + i * 48;
				if (at + 48 > end)
				{
					b = Bone{ {0,0,0}, {0,0,0,1}, {1,1,1} };
					continue;
				}
				const uint8_t* p = file->data.data() + at;
				for (int k = 0; k < 3; ++k)
				{
					b.position[k] = F32(p + k * 4);
					b.scale[k] = F32(p + 32 + k * 4);
				}
				float length = 0.f;
				for (int k = 0; k < 4; ++k)
				{
					b.rotation[k] = F32(p + 16 + k * 4);
					length += b.rotation[k] * b.rotation[k];
				}
				if (length < 1e-8f)
				{
					b.rotation[0] = b.rotation[1] = b.rotation[2] = 0.f;
					b.rotation[3] = 1.f;
					continue;
				}
				length = 1.f / sqrtf(length);
				for (float& value : b.rotation)
					value *= length;
			}
			ToModel(rig, rig.pose, rig.rest);
			return true;
		}
		return false;
	}

	int IntOf(const Red& file, const std::string& type, size_t v, size_t e)
	{
		const uint8_t* d = file.data.data();
		if ((type == "Uint8" || type == "Int8") && v + 1 <= e)
			return d[v];
		if ((type == "Uint16" || type == "Int16") && v + 2 <= e)
			return U16(d + v);
		if (v + 4 <= e)
			return I32(d + v);
		return 0;
	}

	bool ReadClip(const std::string& path, const std::string& name, Clip& clip)
	{
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return false;
		for (const RedExport& e : file->exports)
		{
			if (file->Name(e.className) != "CSkeletalAnimation")
				continue;
			std::string own;
			int32_t handle = 0;
			float duration = 0.f;
			file->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
			{
				if (n == "name" && v + 2 <= end)
					own = file->Name(U16(file->data.data() + v));
				else if (n == "animBuffer" && v + 4 <= end)
					handle = I32(file->data.data() + v);
				else if (n == "duration" && v + 4 <= end)
					duration = F32(file->data.data() + v);
			});
			if (_stricmp(own.c_str(), name.c_str()) != 0)
				continue;
			if (handle <= 0 || handle > static_cast<int>(file->exports.size()) || file->Name(file->exports[handle - 1].className) != "CAnimationBufferBitwiseCompressed")
			{
				Log("item models: %s isn't in a kind of buffer that's read", name.c_str());
				return false;
			}
			clip.duration = duration;
			int deferred = 0;
			size_t inlineAt = 0, inlineSize = 0;
			std::string streaming;
			file->Object(file->exports[handle - 1], [&](const std::string& n, const std::string& t, size_t v, size_t end)
			{
				if (n == "bones")
					EachStruct(*file, v, end, [&](uint32_t i, const std::string& kind, const std::string&, size_t pv, size_t pe)
					{
						if (clip.bones.size() <= i)
							clip.bones.resize(i + 1);
						KeyTrack* track = kind == "position" ? &clip.bones[i].position : kind == "orientation" ? &clip.bones[i].orientation : kind == "scale" ? &clip.bones[i].scale : nullptr;
						if (!track)
							return;
						file->Walk(pv, pe, file->marker, [&](const std::string& fn, const std::string& ft, size_t fv, size_t fe)
						{
							if (fn == "dt" && fv + 4 <= fe)
								track->dt = F32(file->data.data() + fv);
							else if (fn == "numFrames")
								track->count = static_cast<uint32_t>(IntOf(*file, ft, fv, fe));
							else if (fn == "dataAddr")
								track->at = static_cast<uint32_t>(IntOf(*file, ft, fv, fe));
							else if (fn == "compression")
								track->compression = IntOf(*file, ft, fv, fe);
						});
					});
				else if (n == "dt" && v + 4 <= end)
					clip.frameTime = F32(file->data.data() + v);
				else if (n == "numFrames")
					clip.frames = static_cast<uint32_t>(IntOf(*file, t, v, end));
				else if (n == "deferredData" && v + 2 <= end)
					deferred = U16(file->data.data() + v);
				else if (n == "data")
					file->Bytes(v, end, inlineAt, inlineSize);
				else if (n == "orientationCompressionMethod" && v + 2 <= end)
					clip.method = file->Name(U16(file->data.data() + v));
				else if (n == "streamingOption" && v + 2 <= end)
					streaming = file->Name(U16(file->data.data() + v));
			});
			if (inlineSize)
				clip.data.assign(file->data.begin() + inlineAt, file->data.begin() + inlineAt + inlineSize);
			if (deferred > 0)
			{
				std::vector<uint8_t> streamed;
				if (!file->Buffer(deferred, path, streamed))
					return false;
				if (streaming != "ABSO_PartiallyStreamable")
					clip.data.clear();
				clip.data.insert(clip.data.end(), streamed.begin(), streamed.end());
			}
			if (clip.bones.empty() || clip.data.empty() || clip.frames < 1)
				return false;
			if (clip.method != "ABOCM_PackIn64bitsW" && clip.method != "ABOCM_PackIn48bitsW" && clip.method != "ABOCM_AsFloat_XYZW" && clip.method != "ABOCM_AsFloat_XYZSignedWInLastBit")
			{
				Log("item models: %s packs its orientations by %s, which isn't read", name.c_str(), clip.method.c_str());
				return false;
			}
			return true;
		}
		return false;
	}

	// A float as saved: whole, or its top 24 or 16 bits with the rest zero
	float KeyFloat(const uint8_t* d, int compression)
	{
		uint32_t bits = 0;
		if (compression == 0)
			bits = U32(d);
		else if (compression == 1)
			bits = d[0] << 8 | d[1] << 16 | static_cast<uint32_t>(d[2]) << 24;
		else
			bits = d[0] << 16 | static_cast<uint32_t>(d[1]) << 24;
		float value;
		memcpy(&value, &bits, 4);
		return value;
	}

	void SampleVector(const Clip& clip, const KeyTrack& t, float time, float* out)
	{
		if (t.count == 0)
			return;
		const int size = t.compression == 0 ? 4 : t.compression == 1 ? 3 : 2;
		const auto key = [&](uint32_t index, int k)
		{
			const size_t at = t.at + static_cast<size_t>(index) * size * 3 + static_cast<size_t>(k) * size;
			return at + size <= clip.data.size() ? KeyFloat(clip.data.data() + at, t.compression) : 0.f;
		};
		if (t.count == 1 || t.dt <= 0.f)
		{
			for (int k = 0; k < 3; ++k)
				out[k] = key(0, k);
			return;
		}
		const float frame = std::clamp(time / t.dt, 0.f, static_cast<float>(t.count - 1));
		const uint32_t a = static_cast<uint32_t>(frame), b = std::min(a + 1, t.count - 1);
		const float f = frame - static_cast<float>(a);
		for (int k = 0; k < 3; ++k)
			out[k] = key(a, k) + (key(b, k) - key(a, k)) * f;
	}

	void OrientationKey(const Clip& clip, const KeyTrack& t, uint32_t index, float* q)
	{
		q[0] = q[1] = q[2] = 0.f;
		q[3] = 1.f;
		const int size = clip.method == "ABOCM_PackIn64bitsW" ? 8 : clip.method == "ABOCM_PackIn48bitsW" ? 6 : clip.method == "ABOCM_AsFloat_XYZSignedWInLastBit" ? 12 : 16;
		const size_t at = t.at + static_cast<size_t>(index) * size;
		if (at + size > clip.data.size())
			return;
		const uint8_t* d = clip.data.data() + at;
		if (size == 8)
		{
			for (int k = 0; k < 4; ++k)
				q[k] = (32767.f - U16(d + k * 2)) / 32768.f;
		}
		else if (size == 12)
		{
			// X, Y and Z as floats, W made from them, the last bit of Z's saying it's negative
			const uint32_t zBits = U32(d + 8);
			const uint32_t cleared = zBits & ~1u;
			q[0] = F32(d);
			q[1] = F32(d + 4);
			memcpy(&q[2], &cleared, 4);
			const float w = sqrtf(std::max(0.f, 1.f - q[0] * q[0] - q[1] * q[1] - q[2] * q[2]));
			q[3] = zBits & 1 ? -w : w;
		}
		else if (size == 6)
		{
			uint64_t bits = 0;
			for (int k = 0; k < 6; ++k)
				bits = bits << 8 | d[k];
			for (int k = 0; k < 4; ++k)
				q[k] = (2047.f - static_cast<float>(bits >> (36 - k * 12) & 0xFFF)) / 2048.f;
		}
		else
		{
			for (int k = 0; k < 4; ++k)
				q[k] = F32(d + k * 4);
		}
		float length = 0.f;
		for (int k = 0; k < 4; ++k)
			length += q[k] * q[k];
		if (length < 1e-8f)
		{
			q[0] = q[1] = q[2] = 0.f;
			q[3] = 1.f;
			return;
		}
		length = 1.f / sqrtf(length);
		for (int k = 0; k < 4; ++k)
			q[k] *= length;
	}

	void SampleOrientation(const Clip& clip, const KeyTrack& t, float time, float* out)
	{
		if (t.count == 0)
			return;
		if (t.count == 1 || t.dt <= 0.f)
		{
			OrientationKey(clip, t, 0, out);
			return;
		}
		const float frame = std::clamp(time / t.dt, 0.f, static_cast<float>(t.count - 1));
		const uint32_t a = static_cast<uint32_t>(frame), b = std::min(a + 1, t.count - 1);
		const float f = frame - static_cast<float>(a);
		float p[4], q[4];
		OrientationKey(clip, t, a, p);
		OrientationKey(clip, t, b, q);
		// Keys a frame or two apart: blending and normalising is as good as slerp, the short way round
		const float dot = p[0] * q[0] + p[1] * q[1] + p[2] * q[2] + p[3] * q[3];
		const float sign = dot < 0.f ? -1.f : 1.f;
		float length = 0.f;
		for (int k = 0; k < 4; ++k)
		{
			out[k] = p[k] * (1.f - f) + q[k] * sign * f;
			length += out[k] * out[k];
		}
		length = 1.f / sqrtf(std::max(length, 1e-8f));
		for (int k = 0; k < 4; ++k)
			out[k] *= length;
	}

	// One of a body's bones in the table: its offset, then the rig's bone that moves it
	struct BoneSlot { int bone; M4 offset; int heldBy = -1; bool silver = false; };   // heldBy: the bone that has it in a stance that holds a sword

	const char* const kAnimations[] = {
		"high_standing_determined_idle", "high_standing_proud_idle", "high_standing_aggressive_idle", "high_standing_happy_idle",
		"high_standing_bored_idle", "high_standing_sad_idle", "low_standing_exhausted_idle", "dialogue_witcher_combat_pose_ready",
	};
	constexpr int kAnimationCount = static_cast<int>(sizeof(kAnimations) / sizeof(kAnimations[0]));
	constexpr int kAnimationHoldsSword = 7;

	std::mutex g_animationLock;
	std::shared_ptr<const Rig> g_rig;
	bool g_rigTried = false;
	std::shared_ptr<const Clip> g_clips[kAnimationCount];
	bool g_clipTried[kAnimationCount] = {};

	std::shared_ptr<const Rig> SharedRig()
	{
		std::lock_guard<std::mutex> hold(g_animationLock);
		if (!g_rigTried)
		{
			g_rigTried = true;
			auto rig = std::make_shared<Rig>();
			if (ReadRig("characters\\base_entities\\man_base\\man_base.w2rig", *rig))
				g_rig = rig;
			else
				Log("item models: couldn't read the rig, so he'll stand still");
		}
		return g_rig;
	}

	// The small rig his scabbards hang on, fastened to his torso3: where each of its bones is on him
	std::shared_ptr<const Rig> ScabbardRig()
	{
		static std::shared_ptr<const Rig> rig;
		static bool tried = false;
		std::lock_guard<std::mutex> hold(g_animationLock);
		if (!tried)
		{
			tried = true;
			auto read = std::make_shared<Rig>();
			if (ReadRig("characters\\models\\geralt\\scabbards\\model\\scabbards_crossbow.w2rig", *read))
			{
				// As the game holds them: in this pose, which its rest position isn't
				Clip pose;
				if (ReadClip("animations\\items\\weapon\\witcher_scabbards.w2anims", "scabbard_pose", pose))
				{
					std::vector<Bone> local = read->pose;
					for (size_t b = 1; b < pose.bones.size() && b < local.size(); ++b)
					{
						SampleVector(pose, pose.bones[b].position, 0.f, local[b].position);
						SampleOrientation(pose, pose.bones[b].orientation, 0.f, local[b].rotation);
						SampleVector(pose, pose.bones[b].scale, 0.f, local[b].scale);
					}
					ToModel(*read, local, read->rest);
				}
				else
				{
					Log("item models: couldn't read the scabbards' pose, so they're as the rig has them");
				}
				rig = read;
			}
			else
				Log("item models: couldn't read the scabbards' rig, so his weapons are left off");
		}
		return rig;
	}

	std::shared_ptr<const Clip> SharedClip(int index)
	{
		std::lock_guard<std::mutex> hold(g_animationLock);
		if (!g_clipTried[index])
		{
			g_clipTried[index] = true;
			auto clip = std::make_shared<Clip>();
			if (ReadClip("animations\\man\\dialogs\\man_dialog_standing.w2anims", kAnimations[index], *clip))
			{
				g_clips[index] = clip;
				Log("item models: %s: %zu bones, %u frames, %.1f s", kAnimations[index], clip->bones.size(), clip->frames, clip->duration);
			}
			else
			{
				Log("item models: couldn't read the animation %s", kAnimations[index]);
			}
		}
		return g_clips[index];
	}

	// A clip by file and name, read once. Null if it isn't there or isn't a kind that's read: whoever asked does without.
	std::shared_ptr<const Clip> NamedClip(const char* path, const std::string& name)
	{
		static std::map<std::string, std::shared_ptr<const Clip>> known;
		std::lock_guard<std::mutex> hold(g_animationLock);
		const auto found = known.find(name);
		if (found != known.end())
			return found->second;
		auto clip = std::make_shared<Clip>();
		std::shared_ptr<const Clip> result;
		if (ReadClip(path, name, *clip))
			result = clip;
		Log("item models: %s %s", name.c_str(), result ? "read" : "isn't there");
		known[name] = result;
		return result;
	}

	float ClipSeconds(const Clip& clip)
	{
		return clip.duration > 0.f ? clip.duration : (clip.frames - 1) * clip.frameTime;
	}

	// A clip's pose at a time. The rig's root stays where it stands, as the game places a character's root itself.
	void SamplePose(const Rig& rig, const Clip& clip, float time, std::vector<Bone>& local)
	{
		local = rig.pose;
		const size_t first = !rig.parents.empty() && rig.parents[0] < 0 ? 1 : 0;
		for (size_t b = first; b < clip.bones.size() && b < local.size(); ++b)
		{
			SampleVector(clip, clip.bones[b].position, time, local[b].position);
			SampleOrientation(clip, clip.bones[b].orientation, time, local[b].rotation);
			SampleVector(clip, clip.bones[b].scale, time, local[b].scale);
		}
	}

	// What brings a clip's actor back over where he stands, facing his way, from where its first frame has him
	struct Standing { float x = 0.f, y = 0.f, yaw = 0.f; };

	// Part way from one to the other, turning the short way round
	Standing MixStanding(const Standing& a, const Standing& b, float t)
	{
		constexpr float kPi = 3.14159265358979f;
		float turn = fmodf(b.yaw - a.yaw, kPi * 2.f);
		if (turn > kPi)
			turn -= kPi * 2.f;
		else if (turn < -kPi)
			turn += kPi * 2.f;
		Standing out;
		out.x = a.x + (b.x - a.x) * t;
		out.y = a.y + (b.y - a.y) * t;
		out.yaw = a.yaw + turn * t;
		return out;
	}

	// The game's own transitions between the stances that have them, by their place in kAnimations
	constexpr int kStanceHub = 0;   // Determined: the one most lead to
	constexpr int kRoutedStances = 6;
	const bool kHasTransition[kRoutedStances][kRoutedStances] = {
		//            det    proud  aggr   happy  bored  sad
		/* det   */ { false, true,  true,  true,  false, false },
		/* proud */ { true,  false, true,  false, false, true  },
		/* aggr  */ { true,  true,  false, false, false, false },
		/* happy */ { true,  true,  false, false, false, true  },
		/* bored */ { false, false, false, false, false, true  },
		/* sad   */ { false, true,  false, true,  false, false },
	};

	// The stances to go through from one to the other, the shortest way along those. Empty if there's no way.
	std::vector<int> TransitionRoute(int from, int to)
	{
		if (from < 0 || to < 0 || from >= kRoutedStances || to >= kRoutedStances || from == to)
			return {};
		int cameFrom[kRoutedStances];
		std::fill(cameFrom, cameFrom + kRoutedStances, -1);
		cameFrom[from] = from;
		std::vector<int> queue{ from };
		for (size_t at = 0; at < queue.size(); ++at)
			for (int next = 0; next < kRoutedStances; ++next)
				if (kHasTransition[queue[at]][next] && cameFrom[next] < 0)
				{
					cameFrom[next] = queue[at];
					queue.push_back(next);
				}
		if (cameFrom[to] < 0)
			return {};
		std::vector<int> route;
		for (int at = to; at != from; at = cameFrom[at])
			route.insert(route.begin(), at);
		return route;
	}

	Standing StandingOf(const Rig& rig, const Clip& clip, int pelvis, float time = 0.f)
	{
		Standing out;
		if (pelvis < 0)
			return out;
		std::vector<Bone> local;
		std::vector<M4> model;
		SamplePose(rig, clip, time, local);
		ToModel(rig, local, model);
		M4 back;
		if (!Invert(rig.rest[pelvis], back))
			return out;
		const M4 turned = back * model[pelvis];
		if (turned.m[0][0] * turned.m[0][0] + turned.m[0][1] * turned.m[0][1] > 1e-6f)
			out.yaw = atan2f(turned.m[0][1], turned.m[0][0]);
		out.x = model[pelvis].m[3][0];
		out.y = model[pelvis].m[3][1];
		return out;
	}

	bool IsHelperBone(const std::string& name)
	{
		const std::string lower = Lower(name);
		return lower.find("roll") != std::string::npos || lower.find("twist") != std::string::npos;
	}
}

int AnimationCount()
{
	return kAnimationCount;
}

// Works an animation out into the table's rows, on a loading thread. The card blends it from there on, so playing it costs
// next to nothing on the processor. Null if it can't be read: he stays in whatever he had.

namespace
{
	// Geralt's dangles: the bones of his hair, a hood's tails and the like, which the game swings by its physics and his
	// clips leave still. Each tip trails where the clip takes it, springs back and settles, as a creature's do, and is
	// kept out of his head, neck and shoulders.
	struct DangleSwing
	{
		using V3 = std::array<float, 3>;
		const Rig& rig;
		std::vector<int> dangles;
		std::vector<char> isDangle;
		std::vector<V3> tipLocal, at, was;
		bool started = false;
		int head = -1, neck = -1, chest = -1, lShoulder = -1, rShoulder = -1;

		explicit DangleSwing(const Rig& r) : rig(r)
		{
			const size_t count = rig.parents.size();
			std::vector<int> firstChild(count, -1);
			isDangle.assign(count, 0);
			for (size_t i = 0; i < count; ++i)
			{
				const int parent = rig.parents[i];
				if (parent >= 0 && parent < static_cast<int>(count) && firstChild[parent] < 0)
					firstChild[parent] = static_cast<int>(i);
				const std::string name = Lower(rig.names[i]);
				const bool helper = Ends(name, "_null") || name.find("_ik") != std::string::npos || name.find("hand") != std::string::npos
					|| name.find("distance_keep") != std::string::npos;
				if (name.rfind("dyng_", 0) == 0 && !helper && parent >= 0 && parent < static_cast<int>(i))
				{
					dangles.push_back(static_cast<int>(i));
					isDangle[i] = 1;
				}
				if (name == "head") head = static_cast<int>(i);
				if (name == "neck") neck = static_cast<int>(i);
				if (name == "torso3") chest = static_cast<int>(i);
				if (name == "l_shoulder") lShoulder = static_cast<int>(i);
				if (name == "r_shoulder") rShoulder = static_cast<int>(i);
			}
			// The point at its end, in its own space: its first child's place, or for the last of a chain, as far on as
			// it is from its parent
			tipLocal.resize(dangles.size());
			for (size_t d = 0; d < dangles.size(); ++d)
			{
				const int i = dangles[d];
				const Bone& own = rig.pose[i];
				if (firstChild[i] >= 0)
				{
					const Bone& child = rig.pose[firstChild[i]];
					tipLocal[d] = { child.position[0], child.position[1], child.position[2] };
				}
				else
				{
					const M4 turn = BoneMatrix(Bone{ { 0, 0, 0 }, { own.rotation[0], own.rotation[1], own.rotation[2], own.rotation[3] }, { 1, 1, 1 } });
					for (int c = 0; c < 3; ++c)
						tipLocal[d][c] = own.position[0] * turn.m[c][0] + own.position[1] * turn.m[c][1] + own.position[2] * turn.m[c][2];
				}
			}
			at.resize(dangles.size());
			was.resize(dangles.size());
		}

		bool Any() const { return !dangles.empty(); }

		static V3 Apply(const M4& m, const V3& p)
		{
			V3 r;
			for (int c = 0; c < 3; ++c)
				r[c] = p[0] * m.m[0][c] + p[1] * m.m[1][c] + p[2] * m.m[2][c] + m.m[3][c];
			return r;
		}
		static V3 Sub(const V3& a, const V3& b) { return V3{ a[0] - b[0], a[1] - b[1], a[2] - b[2] }; }
		static float Length(const V3& a) { return sqrtf(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]); }

		// Turns the bone about its own place so its end points along `toward`, and its children with it
		static void Bend(M4& m, const V3& tip, const V3& toward)
		{
			const V3 pivot{ m.m[3][0], m.m[3][1], m.m[3][2] };
			V3 a = Sub(tip, pivot), b = toward;
			const float la = Length(a), lb = Length(b);
			if (la < 1e-5f || lb < 1e-5f)
				return;
			for (int c = 0; c < 3; ++c) { a[c] /= la; b[c] /= lb; }
			const V3 axis{ a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0] };
			const float s = Length(axis), cosine = std::clamp(a[0] * b[0] + a[1] * b[1] + a[2] * b[2], -1.f, 1.f);
			if (s < 1e-6f)
				return;
			const float x = axis[0] / s, y = axis[1] / s, z = axis[2] / s, k = 1.f - cosine;
			M4 r;
			r.m[0][0] = cosine + x * x * k;     r.m[0][1] = x * y * k + z * s;     r.m[0][2] = x * z * k - y * s;
			r.m[1][0] = y * x * k - z * s;      r.m[1][1] = cosine + y * y * k;    r.m[1][2] = y * z * k + x * s;
			r.m[2][0] = z * x * k + y * s;      r.m[2][1] = z * y * k - x * s;     r.m[2][2] = cosine + z * z * k;
			M4 there, back;
			there.m[3][0] = -pivot[0]; there.m[3][1] = -pivot[1]; there.m[3][2] = -pivot[2];
			back.m[3][0] = pivot[0]; back.m[3][1] = pivot[1]; back.m[3][2] = pivot[2];
			m = m * there * r * back;
		}

		// The bones again from the first dangle down, each dangle pointed as `aim` says, its children following it
		template <typename Aim>
		void Rebuild(const std::vector<Bone>& local, std::vector<M4>& model, Aim&& aim) const
		{
			size_t d = 0;
			const size_t count = std::min(rig.parents.size(), std::min(local.size(), model.size()));
			for (size_t i = dangles.empty() ? count : static_cast<size_t>(dangles[0]); i < count; ++i)
			{
				const int parent = rig.parents[i];
				if (parent >= 0 && parent < static_cast<int>(i))
					model[i] = BoneMatrix(local[i]) * model[parent];
				if (!isDangle[i])
					continue;
				const V3 pivot{ model[i].m[3][0], model[i].m[3][1], model[i].m[3][2] };
				const V3 tip = Apply(model[i], tipLocal[d]);
				Bend(model[i], tip, aim(d, pivot, tip));
				++d;
			}
		}

		// One frame on: each tip trails, springs back, swings no further than a lock would, stays its length and keeps out
		// of him. `aims` gets where each points, if asked.
		void Step(const std::vector<Bone>& local, std::vector<M4>& model, std::vector<V3>* aims)
		{
			// What it can't pass through, from where he is this frame: his skull, neck, chest and shoulders
			struct Ball { V3 centre; float radius; };
			std::vector<Ball> balls;
			const auto ball = [&](int bone, V3 along, float radius)
			{
				if (bone >= 0 && bone < static_cast<int>(model.size()))
					balls.push_back({ Apply(model[bone], along), radius });
			};
			ball(head, { 0.09f, 0.015f, 0.f }, 0.105f);
			ball(neck, { 0.05f, 0.f, 0.f }, 0.065f);
			ball(chest, { 0.12f, -0.02f, 0.f }, 0.13f);
			ball(lShoulder, { 0.02f, 0.f, 0.f }, 0.075f);
			ball(rShoulder, { 0.02f, 0.f, 0.f }, 0.075f);
			if (aims)
				aims->resize(dangles.size());
			Rebuild(local, model, [&](size_t d, const V3& pivot, const V3& tip)
			{
				if (!started)
					at[d] = was[d] = tip;
				constexpr float kKeep = 0.82f, kPull = 0.16f;   // how much of its swing it keeps each frame, how hard it's drawn back
				V3 next;
				for (int c = 0; c < 3; ++c)
					next[c] = at[d][c] + (at[d][c] - was[d][c]) * kKeep;
				for (int c = 0; c < 3; ++c)
					next[c] += (tip[c] - next[c]) * kPull;
				// Its weight: the meshes are modelled with their locks held out clear of armour, and the game's physics lets
				// them fall from there. Settled, a tip hangs kSag below where it's modelled, before its length is kept.
				constexpr float kSag = 0.03f;
				next[2] -= kSag * kPull;
				constexpr float kMostCos = 0.64f;   // 50 degrees from where the clip has it
				const V3 rest = Sub(tip, pivot);
				const float want = Length(rest);
				for (int tries = 0; tries < 8 && want > 1e-6f; ++tries)
				{
					const V3 out = Sub(next, pivot);
					const float now = Length(out);
					if (now < 1e-6f || (out[0] * rest[0] + out[1] * rest[1] + out[2] * rest[2]) / (now * want) >= kMostCos)
						break;
					for (int c = 0; c < 3; ++c)
						next[c] = (next[c] + tip[c]) * 0.5f;
				}
				const auto keepLength = [&]
				{
					const float now = Length(Sub(next, pivot));
					if (now > 1e-6f && want > 1e-6f)
						for (int c = 0; c < 3; ++c)
							next[c] = pivot[c] + (next[c] - pivot[c]) * (want / now);
				};
				keepLength();
				// Out of him: a ball its root isn't already inside (a lock grows from inside his scalp)
				for (int pass = 0; pass < 2; ++pass)
				{
					for (const Ball& b : balls)
					{
						if (Length(Sub(pivot, b.centre)) < b.radius)
							continue;
						const V3 from = Sub(next, b.centre);
						const float distance = Length(from);
						if (distance < b.radius && distance > 1e-6f)
							for (int c = 0; c < 3; ++c)
								next[c] = b.centre[c] + from[c] * (b.radius / distance);
					}
					keepLength();
				}
				was[d] = at[d];
				at[d] = next;
				const V3 toward = Sub(next, pivot);
				if (aims)
					(*aims)[d] = toward;
				return toward;
			});
			started = true;
		}
	};

	// Geralt's rig with each worn piece's dangle bones on it, kept with the slot table made for it, so a stance baked
	// later swings the same bones
	std::mutex g_slotRigLock;
	std::vector<std::pair<std::weak_ptr<const void>, std::shared_ptr<const Rig>>> g_slotRigs;

	void RememberSlotRig(const std::shared_ptr<const void>& slots, std::shared_ptr<const Rig> rig)
	{
		std::lock_guard hold(g_slotRigLock);
		g_slotRigs.erase(std::remove_if(g_slotRigs.begin(), g_slotRigs.end(), [](const auto& e) { return e.first.expired(); }), g_slotRigs.end());
		g_slotRigs.emplace_back(slots, std::move(rig));
	}

	std::shared_ptr<const Rig> SlotRig(const std::shared_ptr<const void>& slots)
	{
		std::lock_guard hold(g_slotRigLock);
		for (const auto& [weak, rig] : g_slotRigs)
			if (weak.lock() == slots)
				return rig;
		return nullptr;
	}

	// His rig, and after it each dangle's bones it hasn't, under the bone of the same name
	std::shared_ptr<const Rig> GeraltRig(const std::vector<std::string>& dyngs)
	{
		const auto base = SharedRig();
		if (!base || dyngs.empty())
			return base;
		static std::mutex lock;
		static std::map<std::string, std::shared_ptr<const Rig>> made;
		std::string key;
		for (const std::string& d : dyngs)
			key += Lower(d) + "|";
		{
			std::lock_guard hold(lock);
			const auto found = made.find(key);
			if (found != made.end())
				return found->second;
		}
		auto rig = std::make_shared<Rig>(*base);
		std::map<std::string, int> have;
		for (size_t i = 0; i < rig->names.size(); ++i)
			have[Lower(rig->names[i])] = static_cast<int>(i);
		for (const std::string& path : dyngs)
		{
			Rig dangle;
			if (!ReadRig(path, dangle))
			{
				Log("item models: can't read the dangles of %s", path.c_str());
				continue;
			}
			for (size_t i = 0; i < dangle.names.size() && i < dangle.pose.size(); ++i)
			{
				const std::string name = Lower(dangle.names[i]);
				const int parent = dangle.parents[i];
				if (have.count(name) || parent < 0 || parent >= static_cast<int>(dangle.names.size()))
					continue;
				const auto up = have.find(Lower(dangle.names[parent]));
				if (up == have.end() || rig->names.size() >= 0x7fff)
					continue;
				have[name] = static_cast<int>(rig->names.size());
				rig->names.push_back(dangle.names[i]);
				rig->parents.push_back(static_cast<int16_t>(up->second));
				rig->pose.push_back(dangle.pose[i]);
				rig->rest.push_back(BoneMatrix(dangle.pose[i]) * rig->rest[up->second]);
			}
		}
		std::lock_guard hold(lock);
		made[key] = rig;
		return rig;
	}
}

std::shared_ptr<const BakedAnimation> BakeAnimation(const std::shared_ptr<const void>& boneSlots, int animation, int from, float fromTime)
{
	auto rigShared = SlotRig(boneSlots);
	if (!rigShared)
		rigShared = SharedRig();
	if (!rigShared || !boneSlots || animation < 0 || animation >= kAnimationCount)
		return nullptr;
	const auto clipShared = SharedClip(animation);
	if (!clipShared)
		return nullptr;
	const Rig& rig = *rigShared;
	const Clip& clip = *clipShared;
	const std::vector<BoneSlot>& slots = *static_cast<const std::vector<BoneSlot>*>(boneSlots.get());

	int pelvis = -1, hand = -1;
	for (size_t i = 0; i < rig.names.size(); ++i)
		if (_stricmp(rig.names[i].c_str(), "pelvis") == 0)
			pelvis = static_cast<int>(i);
	float restX = 0.f, restY = 0.f;
	if (pelvis >= 0)
	{
		restX = rig.rest[pelvis].m[3][0];
		restY = rig.rest[pelvis].m[3][1];
	}
	const auto placingOf = [&](const Standing& at)
	{
		M4 start, into;
		start.m[3][0] = -at.x;
		start.m[3][1] = -at.y;
		into.m[3][0] = restX;
		into.m[3][1] = restY;
		return start * RotateZ(-at.yaw) * into;
	};
	const Standing standing = StandingOf(rig, clip, pelvis);

	// What leads into it: each joint turned toward where it's going, so limbs swing round rather than cutting through him
	struct LeadFrame { std::vector<Bone> local; Standing at; bool held = false; };
	std::vector<LeadFrame> lead;
	// From `from` to `to` seconds into the clip
	const auto addClip = [&](const Clip& c, const Standing& atFirst, const Standing& atLast, float from = 0.f, float to = -1.f)
	{
		if (to < 0.f)
			to = ClipSeconds(c);
		const int count = std::max(2, static_cast<int>((to - from) * kBakedIntroRate));
		for (int i = 0; i < count; ++i)
		{
			LeadFrame f;
			SamplePose(rig, c, std::min(to, from + i / kBakedIntroRate), f.local);
			f.at = MixStanding(atFirst, atLast, static_cast<float>(i) / (count - 1));
			lead.push_back(std::move(f));
		}
	};
	// How far apart two poses are: the most any joint you'd see turns between them, in degrees. Not the root's motion bone,
	// the IK and weapon helpers, twist bones or fingers: they turn a long way and show little.
	std::vector<char> seen(rig.names.size(), 0);
	// What his pelvis hangs from: the clips' root bones. Some clips have them turned half round with the pelvis turned back,
	// so the pelvis is compared and blended as it ends up, not as each has it.
	std::vector<int> rootward;
	for (int at = pelvis >= 0 ? rig.parents[pelvis] : -1; at >= 0 && at < static_cast<int>(rig.parents.size()); at = rig.parents[at])
		rootward.push_back(at);
	const auto above = [&](const std::vector<Bone>& pose)
	{
		M4 m;
		for (auto it = rootward.rbegin(); it != rootward.rend(); ++it)
			if (static_cast<size_t>(*it) < pose.size())
				m = BoneMatrix(pose[*it]) * m;
		return m;
	};
	// The pelvis as it's seen: through its root bones and placed as its clip is, so each clip's own way round is taken out
	const auto pelvisTurn = [&](const std::vector<Bone>& pose, const Standing& at, Bone& out)
	{
		BoneFromMatrix(BoneMatrix(pose[pelvis]) * above(pose) * placingOf(at), out);
	};
	for (size_t n = 0; n < rig.names.size(); ++n)
	{
		const std::string name = Lower(rig.names[n]);
		seen[n] = !(static_cast<int>(n) == pelvis || std::find(rootward.begin(), rootward.end(), static_cast<int>(n)) != rootward.end()
			|| name == "trajectory" || name == "reference" || name.rfind("ik_", 0) == 0 || name.find("weapon") != std::string::npos || name.find("roll") != std::string::npos
			|| name.rfind("dyng_", 0) == 0 || name.find("thumb") != std::string::npos || name.find("index") != std::string::npos
			|| name.find("middle") != std::string::npos || name.find("ring") != std::string::npos || name.find("pinky") != std::string::npos);
	}
	const auto gap = [&](const std::vector<Bone>& a, const std::vector<Bone>& b, const Standing& atA = Standing{}, const Standing& atB = Standing{})
	{
		float most = 0.f;
		if (pelvis >= 0 && static_cast<size_t>(pelvis) < a.size() && static_cast<size_t>(pelvis) < b.size())
		{
			Bone pa, pb;
			pelvisTurn(a, atA, pa);
			pelvisTurn(b, atB, pb);
			float dot = 0.f;
			for (int k = 0; k < 4; ++k)
				dot += pa.rotation[k] * pb.rotation[k];
			most = 2.f * acosf(std::min(1.f, fabsf(dot))) * 57.29578f;
		}
		for (size_t n = 0; n < a.size() && n < b.size() && n < seen.size(); ++n)
		{
			if (!seen[n])
				continue;
			float dot = 0.f;
			for (int k = 0; k < 4; ++k)
				dot += a[n].rotation[k] * b[n].rotation[k];
			most = std::max(most, 2.f * acosf(std::min(1.f, fabsf(dot))) * 57.29578f);
		}
		return most;
	};
	// Frames for a blend: long enough that no joint turns faster than about 150 degrees a second at its steepest (an
	// eased blend's steepest is half again its average). Four frames between the game's clips were snapping his arms round.
	const auto blendFrames = [&](const std::vector<Bone>& a, const Standing& atA, const std::vector<Bone>& b, const Standing& atB, int fewest)
	{
		const int frames = std::clamp(static_cast<int>(gap(a, b, atA, atB) * 1.5f / 5.f), fewest, 45);
		return frames;
	};
	// Where a clip's motion starts and stops: the game's transitions often hold still a while at either end, and that
	// reads as him not answering the button
	const auto moving = [&](const Clip& c, float& start, float& end)
	{
		const float seconds = ClipSeconds(c);
		std::vector<Bone> first, last, at;
		SamplePose(rig, c, 0.f, first);
		SamplePose(rig, c, seconds, last);
		start = 0.f;
		end = seconds;
		for (float t = 0.f; t < seconds; t += 1.f / kBakedIntroRate)
		{
			SamplePose(rig, c, t, at);
			if (gap(first, at) > 2.f)
			{
				start = std::max(0.f, t - 2.f / kBakedIntroRate);
				break;
			}
		}
		for (float t = seconds; t > start; t -= 1.f / kBakedIntroRate)
		{
			SamplePose(rig, c, t, at);
			if (gap(last, at) > 2.f)
			{
				end = std::min(seconds, t + 2.f / kBakedIntroRate);
				break;
			}
		}
		if (end - start < 0.3f)
		{
			start = 0.f;
			end = seconds;
		}
	};
	// The frame of the stance's loop most like a pose, so the lead in goes the shortest way into it
	uint32_t loopFrom = 0;
	const uint32_t loopLength = clip.frames > 2 ? clip.frames - 1 : 0;
	const auto startNear = [&](const std::vector<Bone>& pose, const Standing& poseAt, std::vector<Bone>& target)
	{
		float best = FLT_MAX;
		std::vector<Bone> at;
		for (uint32_t f = 0; f < loopLength; ++f)
		{
			SamplePose(rig, clip, f * clip.frameTime, at);
			const float g = gap(pose, at, poseAt, standing);
			if (g < best - 0.5f)
			{
				best = g;
				loopFrom = f;
			}
		}
		SamplePose(rig, clip, loopFrom * clip.frameTime, target);
	};
	const auto addBlend = [&](const std::vector<Bone>& a, const Standing& atA, const std::vector<Bone>& b, const Standing& atB, int count)
	{
		for (int i = 1; i <= count; ++i)
		{
			const float raw = static_cast<float>(i) / (count + 1);
			const float t = raw * raw * (3.f - 2.f * raw);
			LeadFrame f;
			f.local = a;
			for (size_t n = 0; n < f.local.size() && n < b.size(); ++n)
			{
				Bone& o = f.local[n];
				const Bone& to = b[n];
				float dot = 0.f, length = 0.f;
				for (int k = 0; k < 4; ++k)
					dot += o.rotation[k] * to.rotation[k];
				for (int k = 0; k < 4; ++k)
				{
					o.rotation[k] = o.rotation[k] * (1.f - t) + to.rotation[k] * (dot < 0.f ? -t : t);
					length += o.rotation[k] * o.rotation[k];
				}
				length = 1.f / sqrtf(std::max(length, 1e-8f));
				for (float& value : o.rotation)
					value *= length;
				for (int k = 0; k < 3; ++k)
				{
					o.position[k] += (to.position[k] - o.position[k]) * t;
					o.scale[k] += (to.scale[k] - o.scale[k]) * t;
				}
			}
			// The root bones held as the first pose has them, and the pelvis turned the short way as it ends up: blended bone
			// by bone, a root turned half round one way and a pelvis turned back the other wobble him about as they go
			f.at = MixStanding(atA, atB, t);
			if (pelvis >= 0 && static_cast<size_t>(pelvis) < f.local.size() && static_cast<size_t>(pelvis) < b.size())
			{
				Bone pa, pb;
				pelvisTurn(a, atA, pa);
				pelvisTurn(b, atB, pb);
				float dot = 0.f, length = 0.f;
				for (int k = 0; k < 4; ++k)
					dot += pa.rotation[k] * pb.rotation[k];
				Bone mixed = pa;
				for (int k = 0; k < 4; ++k)
				{
					mixed.rotation[k] = pa.rotation[k] * (1.f - t) + pb.rotation[k] * (dot < 0.f ? -t : t);
					length += mixed.rotation[k] * mixed.rotation[k];
				}
				length = 1.f / sqrtf(std::max(length, 1e-8f));
				for (float& value : mixed.rotation)
					value *= length;
				for (int k = 0; k < 3; ++k)
				{
					mixed.position[k] = pa.position[k] + (pb.position[k] - pa.position[k]) * t;
					mixed.scale[k] = 1.f;
				}
				for (const int r : rootward)
					if (static_cast<size_t>(r) < f.local.size())
						f.local[r] = a[r];
				// Back from as it's seen, through this frame's placing and the first pose's root bones
				M4 unplace, back;
				if (Invert(placingOf(f.at), unplace) && Invert(above(a), back))
				{
					const float scale[3] = { f.local[pelvis].scale[0], f.local[pelvis].scale[1], f.local[pelvis].scale[2] };
					BoneFromMatrix(BoneMatrix(mixed) * unplace * back, f.local[pelvis]);
					memcpy(f.local[pelvis].scale, scale, sizeof(scale));
				}
			}
			lead.push_back(std::move(f));
		}
	};

	const auto fromShared = from >= 0 && from < kAnimationCount && from != animation ? SharedClip(from) : nullptr;
	const bool holdsNow = animation == kAnimationHoldsSword, heldBefore = from == kAnimationHoldsSword;
	// With no sword on his back there's nothing to draw or put away: he'd reach over his shoulder for nothing
	const bool hasSword = std::any_of(slots.begin(), slots.end(), [](const BoneSlot& s) { return s.heldBy >= 0; });
	size_t grabFirst = 0, grabEnd = 0;   // the frames where the sword changes over, when it does
	if (fromShared)
	{
		std::vector<Bone> was, target;
		SamplePose(rig, *fromShared, fromTime, was);
		SamplePose(rig, clip, 0.f, target);
		const Standing wasAt = StandingOf(rig, *fromShared, pelvis);
		if (holdsNow != heldBefore)
		{
			bool silver = false;
			for (const BoneSlot& slot : slots)
				if (slot.heldBy >= 0)
				{
					silver = slot.silver;
					hand = slot.heldBy;
				}
			const std::string action = std::string(holdsNow ? "man_geralt_sword_unsheathe_" : "man_geralt_sword_sheathe_") + (silver ? "silver" : "steel");
			const auto drawing = hasSword ? NamedClip("animations\\man\\combat\\man_geralt_sword.w2anims", action) : nullptr;
			if (drawing)
			{
				const Clip* const moving = drawing.get();
				std::vector<Bone> first, last;
				SamplePose(rig, *moving, 0.f, first);
				SamplePose(rig, *moving, ClipSeconds(*moving), last);
				startNear(last, StandingOf(rig, *moving, pelvis), target);
				const Standing movingAt = StandingOf(rig, *moving, pelvis);
				// The combat clips' arm and knee helpers don't hold up as they're kept, twisting his forearms into a funnel: the
				// game drives those itself. They go from the stance he's leaving to the one he's going to instead.
				const auto isHelper = [&](size_t n)
				{
					const std::string name = Lower(rig.names[n]);
					return name.find("thumb") == std::string::npos && (name.find("roll") != std::string::npos || name.find("bicep2") != std::string::npos);
				};
				for (size_t n = 0; n < rig.names.size() && n < was.size() && n < target.size(); ++n)
					if (isHelper(n))
					{
						memcpy(first[n].rotation, was[n].rotation, sizeof(first[n].rotation));
						memcpy(last[n].rotation, target[n].rotation, sizeof(last[n].rotation));
					}
				addBlend(was, wasAt, first, movingAt, blendFrames(was, wasAt, first, movingAt, 9));
				grabFirst = lead.size();
				addClip(*moving, movingAt, movingAt);
				grabEnd = lead.size();
				for (size_t i = grabFirst; i < grabEnd; ++i)
				{
					const float t = static_cast<float>(i - grabFirst) / std::max<size_t>(1, grabEnd - grabFirst - 1);
					for (size_t n = 0; n < lead[i].local.size() && n < was.size() && n < target.size(); ++n)
					{
						if (!isHelper(n))
							continue;
						float dot = 0.f, length = 0.f;
						for (int k = 0; k < 4; ++k)
							dot += was[n].rotation[k] * target[n].rotation[k];
						float* to = lead[i].local[n].rotation;
						for (int k = 0; k < 4; ++k)
						{
							to[k] = was[n].rotation[k] * (1.f - t) + target[n].rotation[k] * (dot < 0.f ? -t : t);
							length += to[k] * to[k];
						}
						length = 1.f / sqrtf(std::max(length, 1e-8f));
						for (int k = 0; k < 4; ++k)
							to[k] *= length;
					}
				}
				addBlend(last, movingAt, target, standing, blendFrames(last, movingAt, target, standing, 11));
			}
			else
			{
				startNear(was, wasAt, target);
				addBlend(was, wasAt, target, standing, blendFrames(was, wasAt, target, standing, 15));
				grabEnd = lead.size();
			}
		}
		else
		{
			const auto stem = [](int index)
			{
				std::string text = kAnimations[index];
				const size_t idle = text.rfind("_idle");
				return idle == std::string::npos ? text : text.substr(0, idle);
			};
			// Along the game's own transitions as far as they go. Nothing leads into some stances, so the nearest
			// they come is the hub, where his arms are down and the last stretch has nothing to cut through.
			std::vector<int> route = TransitionRoute(from, animation);
			if (route.empty() && from < kRoutedStances && animation < kRoutedStances && from != kStanceHub)
				route = TransitionRoute(from, kStanceHub);
			std::vector<Bone> now = was;
			Standing nowAt = wasAt;
			int at = from;
			bool played = false;
			for (const int next : route)
			{
				const auto real = NamedClip("animations\\man\\dialogs\\man_dialog_standing.w2anims", stem(at) + "_to_" + stem(next));
				if (!real)
					break;
				// Each clip is kept facing its own way, and some turn as they go: it's brought from over him at its
				// first frame to over him at its last, so nothing has to snap when it's done
				float start = 0.f, end = 0.f;
				moving(*real, start, end);
				std::vector<Bone> first, last;
				SamplePose(rig, *real, start, first);
				SamplePose(rig, *real, end, last);
				const Standing realFirst = StandingOf(rig, *real, pelvis, start), realLast = StandingOf(rig, *real, pelvis, end);
				addBlend(now, nowAt, first, realFirst, blendFrames(now, nowAt, first, realFirst, played ? 4 : 6));
				addClip(*real, realFirst, realLast, start, end);
				now = last;
				nowAt = realLast;
				at = next;
				played = true;
			}
			startNear(now, nowAt, target);
			addBlend(now, nowAt, target, standing, blendFrames(now, nowAt, target, standing, at == animation ? 6 : 15));
		}
	}

	// The sword changes over at the moment his hand is nearest it
	std::vector<M4> model;
	size_t grab = lead.size();
	if (grabEnd > grabFirst && hand >= 0)
	{
		float best = FLT_MAX;
		for (size_t i = grabFirst; i < grabEnd; ++i)
		{
			ToModel(rig, lead[i].local, model);
			for (const BoneSlot& slot : slots)
				if (slot.heldBy >= 0)
				{
					const M4 onBack = slot.offset * model[slot.bone];
					float distance = 0.f;
					for (int k = 0; k < 3; ++k)
					{
						const float d = onBack.m[3][k] - model[hand].m[3][k];
						distance += d * d;
					}
					if (distance < best)
					{
						best = distance;
						grab = i;
					}
				}
		}
	}
	for (size_t i = 0; i < lead.size(); ++i)
		lead[i].held = holdsNow != heldBefore ? (i < grab ? heldBefore : holdsNow) : holdsNow;

	auto baked = std::make_shared<BakedAnimation>();
	baked->introFrames = static_cast<uint32_t>(lead.size());
	baked->frames = baked->introFrames + clip.frames;
	baked->slots = static_cast<uint32_t>(slots.size());
	baked->duration = ClipSeconds(clip);
	baked->rows.resize(static_cast<size_t>(baked->frames) * baked->slots * 12);
	float* to = baked->rows.data();
	DangleSwing swing(rig);
	using V3 = DangleSwing::V3;
	baked->dangling.resize(slots.size());
	for (size_t s = 0; s < slots.size(); ++s)
		baked->dangling[s] = slots[s].bone >= 0 && static_cast<size_t>(slots[s].bone) < swing.isDangle.size() && swing.isDangle[slots[s].bone];
	// aims: where each dangle points, as worked out already. joinTo, joinBy: where the loop has them first, and how far
	// toward it this frame's swing is taken, so the lead in ends where the loop starts.
	const auto writeFrame = [&](const std::vector<Bone>& local, const Standing& at, bool held, const std::vector<V3>* aims = nullptr,
		const std::vector<V3>* joinTo = nullptr, float joinBy = 0.f)
	{
		ToModel(rig, local, model);
		if (swing.Any())
		{
			if (aims)
				swing.Rebuild(local, model, [&](size_t d, const V3&, const V3&) { return (*aims)[d]; });
			else if (joinTo)
			{
				std::vector<V3> own;
				swing.Step(local, model, &own);
				swing.Rebuild(local, model, [&](size_t d, const V3&, const V3&)
				{
					const V3& a = own[d];
					const V3& b = (*joinTo)[d];
					return V3{ a[0] + (b[0] - a[0]) * joinBy, a[1] + (b[1] - a[1]) * joinBy, a[2] + (b[2] - a[2]) * joinBy };
				});
			}
			else
				swing.Step(local, model, nullptr);
		}
		const M4 placing = placingOf(at);
		for (const BoneSlot& slot : slots)
		{
			const bool inHand = held && slot.heldBy >= 0;
			const M4 m = slot.bone < 0 ? M4{} : inHand ? model[slot.heldBy] * placing : slot.offset * model[slot.bone] * placing;
			for (int r = 0; r < 3; ++r)
				for (int c = 0; c < 4; ++c)
					*to++ = m.m[c][r];
		}
	};

	// The dangles' loop first, on a swing of its own: worked out three times, and the third laid over the second, so it
	// joins up where it starts again
	const uint32_t loop = loopLength;   // its last frame is its first again
	const size_t n = swing.dangles.size();
	const bool dangles = swing.Any() && loop > 0;
	std::vector<V3> second, third;
	std::vector<Bone> local;
	if (dangles)
	{
		DangleSwing looping(rig);
		second.resize(static_cast<size_t>(loop) * n);
		third.resize(second.size());
		std::vector<V3> aims;
		for (uint32_t step = 0; step < loop * 3; ++step)
		{
			const uint32_t frame = step % loop;
			SamplePose(rig, clip, frame * clip.frameTime, local);
			ToModel(rig, local, model);
			looping.Step(local, model, &aims);
			if (step >= loop)
				std::copy(aims.begin(), aims.end(), (step < loop * 2 ? second : third).begin() + static_cast<size_t>(frame) * n);
		}
	}
	const auto loopAims = [&](uint32_t f, std::vector<V3>& out)
	{
		out.resize(n);
		const float w = static_cast<float>(f) / static_cast<float>(loop);
		for (size_t d = 0; d < n; ++d)
		{
			const V3& a = third[static_cast<size_t>(f) * n + d];
			const V3& b = second[static_cast<size_t>(f) * n + d];
			out[d] = V3{ a[0] + (b[0] - a[0]) * w, a[1] + (b[1] - a[1]) * w, a[2] + (b[2] - a[2]) * w };
		}
	};

	// The lead in, its last half second of swing drawn to where the loop has it
	std::vector<V3> joinTo;
	if (dangles)
		loopAims(loopFrom, joinTo);
	const size_t joinFrames = std::min<size_t>(lead.size(), 15);
	for (size_t i = 0; i < lead.size(); ++i)
	{
		const LeadFrame& f = lead[i];
		if (dangles && i + joinFrames >= lead.size())
		{
			const float raw = static_cast<float>(i + joinFrames + 1 - lead.size()) / static_cast<float>(joinFrames + 1);
			writeFrame(f.local, f.at, f.held, nullptr, &joinTo, raw * raw * (3.f - 2.f * raw));
		}
		else
			writeFrame(f.local, f.at, f.held);
	}

	// The loop, from the frame the lead in went to
	baked->loopStart = loopFrom * clip.frameTime;
	std::vector<V3> aims;
	for (uint32_t frame = 0; frame < clip.frames; ++frame)
	{
		const uint32_t f = loop > 0 ? (frame + loopFrom) % loop : frame;
		SamplePose(rig, clip, f * clip.frameTime, local);
		if (dangles)
		{
			loopAims(f, aims);
			writeFrame(local, standing, holdsNow, &aims);
		}
		else
			writeFrame(local, standing, holdsNow);
	}
	return baked;
}

// Turns his parts' bones into slots of a table, and bakes the animation he's in. If the rig or the animation can't be
// read, he just stands as he was bound.
static bool MakeSlots(ItemModel& out, const Rig& rig, bool geralt)
{

	std::unordered_map<std::string, int> byName;
	for (size_t i = 0; i < rig.names.size(); ++i)
		byName.emplace(Lower(rig.names[i]), static_cast<int>(i));

	// Each of a mesh's bones to a slot
	std::vector<BoneSlot> slots(1, BoneSlot{ -1, M4{} });
	std::unordered_map<std::string, int> known;
	std::vector<std::vector<int>> slotOf(out.meshBones.size());
	const auto scabbards = geralt ? ScabbardRig() : nullptr;
	const auto chest = byName.find("torso3");
	const int chestBone = chest == byName.end() ? -1 : chest->second;
	const auto addSlot = [&](int bone, const M4& offset)
	{
		std::string key(reinterpret_cast<const char*>(offset.m), sizeof(offset.m));
		key.append(reinterpret_cast<const char*>(&bone), sizeof(int));
		const auto [entry, added] = known.emplace(std::move(key), static_cast<int>(slots.size()));
		if (added)
			slots.push_back(BoneSlot{ bone, offset });
		return entry->second;
	};
	// Whether any of a mesh's bones is one of the rig's by name: a mask bound to bones of its own isn't on him at all
	std::vector<char> meshNamed(out.meshBones.size(), 0);
	// On him, a bone a modder's export left in (Blender's "Armature") does nothing in the game: its weight goes to the rest
	std::vector<std::vector<char>> ignored(out.meshBones.size());
	for (size_t mesh = 0; mesh < out.meshBones.size(); ++mesh)
	{
		const MeshBones& bones = out.meshBones[mesh];
		const size_t count = bones.names.size();
		std::vector<int> map(count, -1);
		std::vector<char> named(count, 0);
		std::vector<int> onScabbards(count, -1);
		for (size_t i = 0; i < count; ++i)
		{
			auto found = byName.find(Lower(bones.names[i]));
			bool aliased = false;
			// A human's piece on a creature (a pixie's cap, on a nekker): its bone by the creature rig's own name for it,
			// k_head_g for head, k_lshoulder_g for l_shoulder. Bound by its own inverse bind, it sits there as it should.
			if (found == byName.end() && !geralt)
			{
				std::string plain = Lower(bones.names[i]);
				if (plain.size() > 2 && (plain[0] == 'l' || plain[0] == 'r') && plain[1] == '_')
					plain.erase(1, 1);
				for (const std::string& alias : { "k_" + plain + "_g", "k_" + plain })
					if ((found = byName.find(alias)) != byName.end())
					{
						aliased = true;
						break;
					}
			}
			if (found != byName.end())
			{
				map[i] = found->second;
				named[i] = aliased ? 2 : 1;
			}
		}
		meshNamed[mesh] = std::any_of(named.begin(), named.end(), [](char n) { return n != 0; }) ? 1 : 0;
		ignored[mesh].assign(count, 0);
		if (geralt)
			for (size_t i = 0; i < count; ++i)
				if (!named[i] && Lower(bones.names[i]).rfind("armature", 0) == 0)
					ignored[mesh][i] = 1;
		// A bone the rig hasn't got goes with the nearest joint the mesh is bound to by name, never a helper that turns on its own
		std::vector<int> candidates;
		for (size_t i = 0; i < count; ++i)
			if (named[i] && !IsHelperBone(rig.names[map[i]]) && std::find(candidates.begin(), candidates.end(), map[i]) == candidates.end())
				candidates.push_back(map[i]);
		if (candidates.empty())
			for (size_t r = 0; r < rig.names.size(); ++r)
				if (!IsHelperBone(rig.names[r]))
					candidates.push_back(static_cast<int>(r));
		const auto bind = [&](size_t i)
		{
			M4 m;
			memcpy(m.m, bones.inverseBinds[i].data(), sizeof(m.m));
			return m;
		};
		for (size_t i = 0; i < count; ++i)
		{
			if (named[i])
				continue;
			// A scabbard's bones are on the small rig
			if (scabbards)
			{
				const std::string name = Lower(bones.names[i]);
				for (size_t b = 0; b < scabbards->names.size(); ++b)
					if (Lower(scabbards->names[b]) == name && chestBone >= 0)
					{
						map[i] = chestBone;
						onScabbards[i] = static_cast<int>(b);
						break;
					}
				if (onScabbards[i] >= 0)
					continue;
			}
			// A necklace rides on his chest. By the nearest joint it would go with a shoulder, and up to his mouth when he folds his arms.
			const std::string lower = Lower(bones.names[i]);
			const bool necklace = lower.find("medal") != std::string::npos || lower.find("chain") != std::string::npos
				|| lower.find("necklace") != std::string::npos || lower.find("amulet") != std::string::npos || lower.find("pendant") != std::string::npos;
			if (geralt && lower.rfind("dyng_", 0) == 0 && necklace)
			{
				const auto chest = byName.find("torso3");
				if (chest != byName.end())
				{
					map[i] = chest->second;
					continue;
				}
			}
			M4 bound;
			if (!Invert(bind(i), bound))
				continue;
			float best = FLT_MAX;
			for (const int r : candidates)
			{
				float distance = 0.f;
				for (int k = 0; k < 3; ++k)
				{
					const float d = rig.rest[r].m[3][k] - bound.m[3][k];
					distance += d * d;
				}
				if (distance < best)
				{
					best = distance;
					map[i] = r;
				}
			}
		}
		slotOf[mesh].resize(count, 0);
		for (size_t i = 0; i < count; ++i)
		{
			if (map[i] < 0)
				continue;
			M4 offset;
			if (named[i] == 2)
			{
				// The other rig turns its bone another way: the piece keeps its own way up, carried from where its own
				// rig's bone stands to where this one's does
				M4 bound, back, carry;
				if (!Invert(bind(i), bound) || !Invert(rig.rest[map[i]], back))
					continue;
				for (int k = 0; k < 3; ++k)
					carry.m[3][k] = rig.rest[map[i]].m[3][k] - bound.m[3][k];
				offset = carry * back;
			}
			else if (named[i])
			{
				offset = bind(i);
			}
			else if (onScabbards[i] >= 0)
			{
				offset = bind(i) * scabbards->rest[onScabbards[i]];
			}
			else
			{
				// Carried by a joint: as this mesh bound that joint, if it does, or the joint would part from what it carries
				size_t carrier = count;
				for (size_t c = 0; c < count; ++c)
					if (named[c] && map[c] == map[i])
					{
						carrier = c;
						break;
					}
				if (carrier < count)
					offset = bind(carrier);
				else if (!Invert(rig.rest[map[i]], offset))
					continue;
			}
			slotOf[mesh][i] = addSlot(map[i], offset);
		}
	}
	if (slots.size() > 65535 || slots.size() == 1)
		return false;
	for (const std::shared_ptr<ClothData>& cloth : out.cloths)
		if (cloth->meshBones >= 0 && static_cast<size_t>(cloth->meshBones) < slotOf.size())
			cloth->slotOf = slotOf[cloth->meshBones];

	// The vertices' bones, from the mesh's numbers to the table's. A part with none stays in slot 0.
	for (ModelPart& part : out.parts)
	{
		// A weapon hangs whole from one bone of the small rig
		// A creature's prop goes wholly with the bone it's fastened to, as it's placed relative to that bone
		if (!geralt && !part.attachBone.empty())
		{
			const auto found = byName.find(Lower(part.attachBone));
			if (found != byName.end())
			{
				const int slot = addSlot(found->second, M4{});
				part.skinning.assign(part.vertices.size(), SkinVertex{});
				for (SkinVertex& v : part.skinning)
					v.bones[0] = static_cast<uint16_t>(slot);
				continue;
			}
		}
		// A mask the game equips on his head slot, with no skinning to his bones (none, or only bones of its own, which
		// would leave it by his feet): fastened to his head bone as the slot is, turned 90 degrees in pitch
		// (player.w2ent's "head" slot)
		// A component with no skinning attachment is drawn as placed even when its mesh has bones (the heists' masks are
		// bound to his head bone but placed at the slot: skinned, they'd count his height twice)
		const bool ownBonesOnly = part.meshBones >= 0 && static_cast<size_t>(part.meshBones) < meshNamed.size() && !meshNamed[part.meshBones];
		if (geralt && part.onHeadSlot && (part.skinning.empty() || part.meshBones < 0 || ownBonesOnly || part.rigidComponent))
		{
			const auto head = byName.find("head");
			if (head != byName.end())
			{
				constexpr float kQuarter = 3.14159265358979f * 0.5f;
				const int slot = addSlot(head->second, RotateY(kQuarter));
				part.skinning.assign(part.vertices.size(), SkinVertex{});
				for (SkinVertex& v : part.skinning)
					v.bones[0] = static_cast<uint16_t>(slot);
				continue;
			}
		}
		if (!part.hungOn.empty())
		{
			int slot = 0;
			if (scabbards && chestBone >= 0)
				for (size_t b = 0; b < scabbards->names.size(); ++b)
					if (_stricmp(scabbards->names[b].c_str(), part.hungOn.c_str()) == 0)
					{
						slot = addSlot(chestBone, scabbards->rest[b]);
						const auto hand = byName.find("r_weapon");
						if (part.inHand && hand != byName.end())
						{
							slots[slot].heldBy = hand->second;
							slots[slot].silver = _stricmp(part.hungOn.c_str(), "silver_sword_back") == 0;
						}
					}
			if (slot == 0)
				Log("item models: no bone %s to hang a weapon on", part.hungOn.c_str());
			part.skinning.assign(part.vertices.size(), SkinVertex{});
			for (SkinVertex& v : part.skinning)
				v.bones[0] = static_cast<uint16_t>(slot);
			continue;
		}
		if (part.skinning.empty() || part.meshBones < 0)
			continue;
		const std::vector<int>& map = slotOf[part.meshBones];
		const std::vector<char>& skip = ignored[part.meshBones];
		for (SkinVertex& v : part.skinning)
		{
			// The weight on a bone that does nothing shared out among the others, if there are others
			int kept = 0, dropped = 0;
			for (int k = 0; k < 4; ++k)
				(v.bones[k] < skip.size() && skip[v.bones[k]] ? dropped : kept) += v.weights[k];
			if (dropped > 0 && kept > 0)
			{
				int total = 0, last = -1;
				for (int k = 0; k < 4; ++k)
				{
					if (v.bones[k] < skip.size() && skip[v.bones[k]])
						v.weights[k] = 0;
					else if (v.weights[k] > 0)
					{
						v.weights[k] = static_cast<uint8_t>(std::min(255, v.weights[k] * 255 / kept));
						total += v.weights[k];
						last = k;
					}
				}
				if (last >= 0)
					v.weights[last] = static_cast<uint8_t>(std::clamp(v.weights[last] + 255 - total, 0, 255));
			}
			for (uint16_t& bone : v.bones)
				bone = static_cast<uint16_t>(bone < map.size() ? map[bone] : 0);
		}
	}

	out.boneSlots = std::make_shared<std::vector<BoneSlot>>(std::move(slots));
	return true;
}

static void MakeBoneTable(ItemModel& out, int animation)
{
	// Spare ones last, and only those the drawn ones don't name already
	std::vector<std::string> dyngs = out.dyngs;
	for (const std::string& d : out.spareDyngs)
		if (std::find(dyngs.begin(), dyngs.end(), d) == dyngs.end())
			dyngs.push_back(d);
#ifdef POTP_OVERLAY_TEST
	for (const std::string& d : dyngs)
		Log("dyng probe: %s", d.c_str());
#endif
	const auto rigShared = GeraltRig(dyngs);
	if (!rigShared || !MakeSlots(out, *rigShared, true))
		return;
	RememberSlotRig(out.boneSlots, rigShared);
	out.animation = BakeAnimation(out.boneSlots, animation);
	if (!out.animation)
		out.animation = BakeAnimation(out.boneSlots, 0);
}

bool IsWornPiece(const std::string& templateName)
{
	if (!g_ready)
		return false;
	const auto found = g_wornByTemplate.find(TemplateStem(templateName));
	return found != g_wornByTemplate.end() && IsWornCategory(found->second.category);
}

std::vector<std::string> ItemDyeLooks(const std::string& templateName)
{
	// Whichever cut of it was loaded, it's the same piece with the same dyes
	const auto worn = g_ready ? g_wornByTemplate.find(TemplateStem(templateName)) : g_wornByTemplate.end();
	std::vector<std::string> stems = { TemplateStem(templateName) };
	if (worn != g_wornByTemplate.end())
	{
		stems.push_back(TemplateStem(worn->second.equipTemplate));
		for (const auto& variant : worn->second.variants)
			stems.push_back(TemplateStem(variant.equip));
	}
	std::lock_guard lock(g_dyeLooksMutex);
	for (const std::string& stem : stems)
	{
		const auto found = g_dyeLooks.find(stem);
		if (found != g_dyeLooks.end() && !found->second.empty())
			return found->second;
	}
	return {};
}

std::string WornCategory(const std::string& templateName)
{
	if (templateName.rfind(kWornNothing, 0) == 0)
		return templateName.substr(strlen(kWornNothing));
	if (!g_ready)
		return {};
	const auto found = g_wornByTemplate.find(TemplateStem(templateName));
	return found == g_wornByTemplate.end() ? std::string() : found->second.category;
}

bool LoadItemOnGeralt(const std::string& asked, int animation, ItemModel& out)
{
	if (!g_ready)
	{
		out.problem = "not ready";
		return false;
	}
	// His starting gear, then each one named takes its kind's place
	std::map<std::string, const WornItem*> wearing;
	for (const char* starting : { "starting armor", "starting pants", "starting boots", "starting gloves", "shaved with tail hairstyle", "long steel sword", "witcher silver sword" })
	{
		const auto found = g_wornByName.find(starting);
		if (found != g_wornByName.end())
			wearing[found->second.category] = &found->second;
	}
	std::map<std::string, std::string> dyes;   // by kind: what each is dyed
	std::string last;
	for (size_t from = 0; from <= asked.size();)
	{
		const size_t bar = asked.find('|', from);
		last = asked.substr(from, bar == std::string::npos ? std::string::npos : bar - from);
		if (last.rfind(kWornNothing, 0) == 0)
		{
			// Bare: his body under it, as the game's own bare pieces have it. A weapon's just gone.
			static const std::map<std::string, WornItem> kBare = {
				{ "armor", { "", "armor", "items\\bodyparts\\geralt_items\\trunk\\bare\\t_01_mg__body_medalion.w2ent", {}, {} } },
				{ "pants", { "", "pants", "items\\bodyparts\\geralt_items\\legs\\bare\\l_01_mg__body_underwear.w2ent", {}, {} } },
				{ "boots", { "", "boots", "items\\bodyparts\\geralt_items\\shoes\\bare\\s_01_mg__body.w2ent", {}, {} } },
				{ "gloves", { "", "gloves", "items\\bodyparts\\geralt_items\\gloves\\bare\\g_01_mg__body.w2ent", {}, {} } },
			};
			const std::string kind = last.substr(strlen(kWornNothing));
			const auto bare = kBare.find(kind);
			if (bare != kBare.end())
				wearing[kind] = &bare->second;
			else
				wearing.erase(kind);
			dyes.erase(kind);
			if (bar == std::string::npos)
				break;
			from = bar + 1;
			continue;
		}
		const auto found = g_wornByTemplate.find(TemplateStem(last));
		if (found != g_wornByTemplate.end())
		{
			wearing[found->second.category] = &found->second;
			const size_t dye = last.find('#');
			dyes[found->second.category] = dye == std::string::npos ? std::string() : last.substr(dye + 1);
		}
		if (bar == std::string::npos)
			break;
		from = bar + 1;
	}
	// Each in the variant that goes with the rest: armour is cut differently with gloves on
	// In a stance that holds a sword: the silver if that's what's being looked at, else the steel
	const bool holdSilver = WornCategory(last) == "silversword";
	struct Piece { std::string name, hungOn; bool inHand = false, headSlot = false; };
	std::vector<Piece> templates = {
		{ "gameplay\\templates\\characters\\player\\player.w2ent", "" },   // the seam at his neck
		{ "items\\bodyparts\\geralt_items\\heads\\h_01_mg__geralt.w2ent", "" },
	};
	// What he has on, by name, for the variants that name what they go with
	std::set<std::string> wornNames;
	for (const auto& [category, item] : wearing)
		wornNames.insert(item->name);
	for (const auto& [category, item] : wearing)
	{
		// The most particular variant that what he has on calls for: one naming items over one listing categories over
		// one naming a category, and the first of those (a mod's extension before the item's own)
		std::string use = item->equipTemplate;
		int best = -1;
		for (const WornVariant& variant : item->variants)
		{
			int asked = 0, met = 0;
			const auto check = [&](bool ok) { ++asked; met += ok ? 1 : 0; };
			if (!variant.category.empty())
				check(wearing.count(variant.category) != 0);
			for (const std::string& c : variant.categories)
				check(wearing.count(c) != 0);
			for (const std::string& n : variant.items)
				check(wornNames.count(n) != 0);
			const bool fits = asked > 0 && (variant.all ? met == asked : met > 0);
			if (fits && variant.Rank() > best)
			{
				best = variant.Rank();
				use = variant.equip;
			}
		}
		const char* hung = category == "steelsword" ? "steel_sword_back" : category == "silversword" ? "silver_sword_back" : category == "crossbow" ? "crossbow_back" : "";
		const auto dyed = dyes.find(category);
		if (dyed != dyes.end() && !dyed->second.empty())
			use += "#" + dyed->second;
		templates.push_back({ use, hung, category == (holdSilver ? "silversword" : "steelsword"), item->slot == "head" });
		// A sword's scabbard: the one it's bound to, else the plain one he starts with
		if (category == "steelsword" || category == "silversword")
		{
			const auto bound = g_wornByName.find(!item->bound.empty() ? item->bound : category == "steelsword" ? "steel scabbard" : "silver scabbard");
			if (bound != g_wornByName.end())
				templates.push_back({ bound->second.equipTemplate, "" });
		}
	}

	for (const Piece& worn : templates)
	{
		ItemModel piece;
		piece.keepSkin = true;
		piece.halfTurned = worn.hungOn == "crossbow_back";
		t_dressingGeralt = true;
		const bool loadedPiece = LoadItemModel(worn.name, piece);
		t_dressingGeralt = false;
		if (!loadedPiece)
		{
			Log("item models: dressing Geralt, %s", piece.problem.c_str());
			continue;
		}
		out.clothSkipped += piece.clothSkipped;
		for (const std::string& d : piece.dyngs)
			if (std::find(out.dyngs.begin(), out.dyngs.end(), d) == out.dyngs.end())
				out.dyngs.push_back(d);
		for (const std::string& d : piece.spareDyngs)
			if (std::find(out.spareDyngs.begin(), out.spareDyngs.end(), d) == out.spareDyngs.end())
				out.spareDyngs.push_back(d);
		const int firstBones = static_cast<int>(out.meshBones.size());
		for (MeshBones& bones : piece.meshBones)
			out.meshBones.push_back(std::move(bones));
		const int firstCloth = static_cast<int>(out.cloths.size());
		for (const std::shared_ptr<ClothData>& cloth : piece.cloths)
		{
			if (cloth->meshBones >= 0)
				cloth->meshBones += firstBones;
			out.cloths.push_back(cloth);
		}
		for (ModelPart& part : piece.parts)
		{
			if (part.meshBones >= 0)
				part.meshBones += firstBones;
			if (part.cloth >= 0)
				part.cloth += firstCloth;
			part.hungOn = worn.hungOn;
			part.inHand = worn.inHand;
			part.onHeadSlot = worn.headSlot;
			out.parts.push_back(std::move(part));
		}
	}
	if (out.parts.empty())
	{
		out.problem = "nothing to dress Geralt in";
		return false;
	}
	out.worn = true;
	out.facingYaw = FacingOf("", true);
	MakeBoneTable(out, animation);
	for (int i = 0; i < 3; ++i)
	{
		out.boundsMin[i] = FLT_MAX;
		out.boundsMax[i] = -FLT_MAX;
	}
	for (const ModelPart& part : out.parts)
		if (!part.shadowOnly)
			for (const ModelVertex& v : part.vertices)
				for (int i = 0; i < 3; ++i)
				{
					out.boundsMin[i] = std::min(out.boundsMin[i], v.position[i]);
					out.boundsMax[i] = std::max(out.boundsMax[i], v.position[i]);
				}
	return true;
}

// ---- a creature, as the bestiary shows it: its own model, standing in one of its own idles

namespace
{
	struct CreatureMotion { std::vector<std::string> skeletons, animsets, dangleSkeletons; };

	// The npc's template first, then what it includes: its base entity has the rig and the animations
	void FindMotion(const std::string& path, CreatureMotion& out, std::set<std::string>& seen, int depth)
	{
		if (depth > 4 || !seen.insert(Lower(path)).second)
			return;
		const std::shared_ptr<Entity> entity = ReadEntity(path);
		if (!entity)
			return;
		for (const std::string& s : entity->skeletons)
			if (std::find(out.skeletons.begin(), out.skeletons.end(), s) == out.skeletons.end())
				out.skeletons.push_back(s);
		for (const std::string& s : entity->dangleSkeletons)
			if (std::find(out.dangleSkeletons.begin(), out.dangleSkeletons.end(), s) == out.dangleSkeletons.end())
				out.dangleSkeletons.push_back(s);
		for (const std::string& set : entity->animsets)
			if (std::find(out.animsets.begin(), out.animsets.end(), set) == out.animsets.end())
				out.animsets.push_back(set);
		for (const std::string& include : entity->includes)
			FindMotion(include, out, seen, depth + 1);
	}

	// A set's clips, by name. Kept once read: a man's dozens of sets take a while to open, and every creature with a man's
	// form opens them to choose its idle.
	std::vector<std::string> ClipNames(const std::string& path)
	{
		static std::mutex lock;
		static std::map<std::string, std::vector<std::string>> known;
		{
			std::lock_guard<std::mutex> hold(lock);
			const auto found = known.find(path);
			if (found != known.end())
				return found->second;
		}
		std::vector<std::string> names;
		const std::shared_ptr<Red> file = OpenFile(path);
		if (!file)
			return names;
		for (const RedExport& e : file->exports)
			if (file->Name(e.className) == "CSkeletalAnimation")
				file->Object(e, [&](const std::string& n, const std::string&, size_t v, size_t end)
				{
					if (n == "name" && v + 2 <= end)
						names.push_back(file->Name(U16(file->data.data() + v)));
				});
		std::lock_guard<std::mutex> hold(lock);
		known[path] = names;
		return names;
	}

	// How well a clip does as the one it stands in: lower is better, -1 not at all. A plain "..._idle" first, one that
	// fights or flies after it, never one that moves it somewhere, hurts it or is a layer on top of another.
	int IdleRank(const std::string& name)
	{
		const std::string lower = Lower(name);
		if (lower.find("idle") == std::string::npos)
			return -1;
		static const char* const kNever[] = {
			"_to_", "2idle", "idle2", "turn", "swim", "water", "hit", "death", "dead", "dying", "additive", "_add", "lookat", "look_at",
			"sleep", "fall", "land", "takeoff", "take_off", "start", "stop", "_end", "trans", "mimic", "face", "sit", "lie", "lying",
			"kneel", "eat", "feed", "hang", "stun", "knock", "jump", "dodge", "attack", "taunt", "pain", "burn", "frozen", "ground",
			"climb", "ladder", "crouch", "work", "lean", "cower", "boat", "drunk",
		};
		for (const char* word : kNever)
			if (lower.find(word) != std::string::npos)
				return -1;
		// A number or "loop" after it is still the plain one: idle_03, monster_cave_troll_idle_1, idle_loop
		std::string stem = lower;
		if (Ends(stem, "_loop"))
			stem.resize(stem.size() - 5);
		while (!stem.empty() && (isdigit(static_cast<unsigned char>(stem.back())) || stem.back() == '_'))
			stem.pop_back();
		// One that stands as people do in a dialogue first (a godling's is a child's), then a plain "..._idle"
		int rank = stem.find("standing_determined_idle") != std::string::npos ? 0 : Ends(stem, "_idle") || stem == "idle" ? 1 : 2;
		for (const char* worse : { "combat", "fight", "fly", "air", "alert", "aggressive", "angry", "spawn", "summon", "block", "echo", "cage", "anchor" })
			if (lower.find(worse) != std::string::npos)
				rank += 2;
		return rank;
	}

	// One loop of a clip, for a creature's own rig: nothing leads into it, and nothing changes it after
	std::shared_ptr<const BakedAnimation> BakeLoop(const Rig& rig, const Clip& clip, const std::vector<BoneSlot>& slots, bool forceClipRoot)
	{
		auto baked = std::make_shared<BakedAnimation>();
		baked->frames = std::max<uint32_t>(1, clip.frames);
		baked->slots = static_cast<uint32_t>(slots.size());
		baked->duration = ClipSeconds(clip);
		baked->rows.resize(static_cast<size_t>(baked->frames) * baked->slots * 12);
		float* to = baked->rows.data();
		std::vector<Bone> local;
		std::vector<M4> model;
		// Its root: kept as the rig has it, as most stand on it, or turned as the clip has it for one that lies along its
		// rig's and is stood up by its clips, as a leshy is
		const bool clipRoot = forceClipRoot && !clip.bones.empty() && !rig.parents.empty() && rig.parents[0] < 0;
		const auto pose = [&](float time)
		{
			SamplePose(rig, clip, time, local);
			if (clipRoot && !local.empty())
				SampleOrientation(clip, clip.bones[0].orientation, time, local[0].rotation);
			ToModel(rig, local, model);
		};

		// Hair, beards, tails of cloth and the like hang from dangle bones (dyng_...), which the game swings by its physics
		// and the clips leave still. Here each one's tip lags where the idle takes it, springs back and settles: worked out
		// over a few loops, and the last laid over the one before so that it joins up where the loop starts again.
		const size_t boneCount = rig.parents.size();
		std::vector<int> dangles, firstChild(boneCount, -1);
		for (size_t i = 0; i < boneCount; ++i)
		{
			const int parent = rig.parents[i];
			if (parent >= 0 && parent < static_cast<int>(boneCount) && firstChild[parent] < 0)
				firstChild[parent] = static_cast<int>(i);
			// Not the helpers among them: a chain's end (_null), or a point something reaches for (_ik, a hand's)
			const std::string name = Lower(rig.names[i]);
			const bool helper = Ends(name, "_null") || name.find("_ik") != std::string::npos || name.find("hand") != std::string::npos;
			if (name.rfind("dyng_", 0) == 0 && !helper && parent >= 0 && parent < static_cast<int>(i))
				dangles.push_back(static_cast<int>(i));
		}
		const uint32_t loop = baked->frames > 2 ? baked->frames - 1 : 0;   // its last frame is its first again
		using V3 = std::array<float, 3>;
		const auto apply = [](const M4& m, const V3& p)
		{
			V3 r;
			for (int c = 0; c < 3; ++c)
				r[c] = p[0] * m.m[0][c] + p[1] * m.m[1][c] + p[2] * m.m[2][c] + m.m[3][c];
			return r;
		};
		const auto sub = [](const V3& a, const V3& b) { return V3{ a[0] - b[0], a[1] - b[1], a[2] - b[2] }; };
		const auto length = [](const V3& a) { return sqrtf(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]); };
		// The point at its end, in its own space: its first child's place, or for the last of a chain, as far on as it is
		// from its parent
		std::vector<V3> tipLocal(dangles.size());
		if (!dangles.empty() && loop > 0)
		{
			pose(0.f);
			for (size_t d = 0; d < dangles.size(); ++d)
			{
				const int i = dangles[d];
				const Bone& own = local[i];
				if (firstChild[i] >= 0)
					tipLocal[d] = { local[firstChild[i]].position[0], local[firstChild[i]].position[1], local[firstChild[i]].position[2] };
				else
				{
					// The step from its parent, turned into its own space (the transpose of its turn, as it has no skew)
					const M4 r = BoneMatrix(Bone{ { 0, 0, 0 }, { own.rotation[0], own.rotation[1], own.rotation[2], own.rotation[3] }, { 1, 1, 1 } });
					const V3 p{ own.position[0], own.position[1], own.position[2] };
					for (int c = 0; c < 3; ++c)
						tipLocal[d][c] = p[0] * r.m[c][0] + p[1] * r.m[c][1] + p[2] * r.m[c][2];
				}
			}
		}
		// Turns the bone about its own place so its end points along `toward`, and its children with it
		const auto bend = [&](M4& m, const V3& tip, const V3& toward)
		{
			const V3 pivot{ m.m[3][0], m.m[3][1], m.m[3][2] };
			V3 a = sub(tip, pivot), b = toward;
			const float la = length(a), lb = length(b);
			if (la < 1e-5f || lb < 1e-5f)
				return;
			for (int c = 0; c < 3; ++c) { a[c] /= la; b[c] /= lb; }
			const V3 axis{ a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0] };
			const float s = length(axis), cosine = std::clamp(a[0] * b[0] + a[1] * b[1] + a[2] * b[2], -1.f, 1.f);
			if (s < 1e-6f)
				return;
			const float x = axis[0] / s, y = axis[1] / s, z = axis[2] / s, k = 1.f - cosine;
			// Turning a row vector by `s` about the axis: v' = v * R
			M4 r;
			r.m[0][0] = cosine + x * x * k;     r.m[0][1] = x * y * k + z * s;     r.m[0][2] = x * z * k - y * s;
			r.m[1][0] = y * x * k - z * s;      r.m[1][1] = cosine + y * y * k;    r.m[1][2] = y * z * k + x * s;
			r.m[2][0] = z * x * k + y * s;      r.m[2][1] = z * y * k - x * s;     r.m[2][2] = cosine + z * z * k;
			M4 there, back;
			there.m[3][0] = -pivot[0]; there.m[3][1] = -pivot[1]; there.m[3][2] = -pivot[2];
			back.m[3][0] = pivot[0]; back.m[3][1] = pivot[1]; back.m[3][2] = pivot[2];
			m = m * there * r * back;
		};
		// The bones again from the first dangle down, each dangle pointed as `aim` says, its children following it
		std::vector<char> isDangle(boneCount, 0);
		for (int i : dangles)
			isDangle[i] = 1;
		const auto rebuild = [&](auto&& aim)   // aim(dangle, its place, its tip as the idle has it): where it points
		{
			size_t d = 0;
			for (size_t i = dangles.empty() ? boneCount : static_cast<size_t>(dangles[0]); i < boneCount; ++i)
			{
				const int parent = rig.parents[i];
				if (parent >= 0 && parent < static_cast<int>(i))
					model[i] = BoneMatrix(local[i]) * model[parent];
				if (!isDangle[i])
					continue;
				const V3 pivot{ model[i].m[3][0], model[i].m[3][1], model[i].m[3][2] };
				const V3 tip = apply(model[i], tipLocal[d]);
				bend(model[i], tip, aim(d, pivot, tip));
				++d;
			}
		};
		// Where each tip points, from its bone, in the second loop worked out and the third
		std::vector<V3> second, third;
		if (!dangles.empty() && loop > 0)
		{
			second.resize(static_cast<size_t>(loop) * dangles.size());
			third.resize(second.size());
			std::vector<V3> at(dangles.size()), was(dangles.size());
			bool started = false;
			constexpr float kKeep = 0.82f, kPull = 0.16f;   // how much of its swing it keeps each frame, how hard it's drawn back
			for (uint32_t step = 0; step < loop * 3; ++step)
			{
				const uint32_t frame = step % loop;
				pose(frame * clip.frameTime);
				rebuild([&](size_t d, const V3& pivot, const V3& tip)
				{
					if (!started)
						at[d] = was[d] = tip;
					V3 next;
					for (int c = 0; c < 3; ++c)
						next[c] = at[d][c] + (at[d][c] - was[d][c]) * kKeep;
					for (int c = 0; c < 3; ++c)
						next[c] += (tip[c] - next[c]) * kPull;
					// It swings no further than a hanging lock would from where the idle has it
					constexpr float kMostCos = 0.94f;   // 20 degrees
					const V3 rest = sub(tip, pivot);
					const float want = length(rest);
					for (int tries = 0; tries < 8 && want > 1e-6f; ++tries)
					{
						const V3 out = sub(next, pivot);
						const float now = length(out);
						if (now < 1e-6f || (out[0] * rest[0] + out[1] * rest[1] + out[2] * rest[2]) / (now * want) >= kMostCos)
							break;
						for (int c = 0; c < 3; ++c)
							next[c] = (next[c] + tip[c]) * 0.5f;
					}
					// It stays as long as it is
					const float now = length(sub(next, pivot));
					if (now > 1e-6f)
						for (int c = 0; c < 3; ++c)
							next[c] = pivot[c] + (next[c] - pivot[c]) * (want / now);
					was[d] = at[d];
					at[d] = next;
					const V3 toward = sub(next, pivot);
					if (step >= loop && step < loop * 2)
						second[static_cast<size_t>(frame) * dangles.size() + d] = toward;
					else if (step >= loop * 2)
						third[static_cast<size_t>(frame) * dangles.size() + d] = toward;
					return toward;
				});
				started = true;
			}
		}

		for (uint32_t frame = 0; frame < baked->frames; ++frame)
		{
			pose(frame * clip.frameTime);
			if (!second.empty())
			{
				// The third loop, giving way across it to the second, whose end the third began from
				const uint32_t f = frame % loop;
				const float w = static_cast<float>(f) / static_cast<float>(loop);
				rebuild([&](size_t d, const V3&, const V3&)
				{
					const V3& a = third[static_cast<size_t>(f) * dangles.size() + d];
					const V3& b = second[static_cast<size_t>(f) * dangles.size() + d];
					return V3{ a[0] + (b[0] - a[0]) * w, a[1] + (b[1] - a[1]) * w, a[2] + (b[2] - a[2]) * w };
				});
			}
			for (const BoneSlot& slot : slots)
			{
				const M4 m = slot.bone < 0 || slot.bone >= static_cast<int>(model.size()) ? M4{} : slot.offset * model[slot.bone];
				for (int r = 0; r < 3; ++r)
					for (int c = 0; c < 4; ++c)
						*to++ = m.m[c][r];
			}
		}
		return baked;
	}
}

static bool LoadOneCreature(const std::string& asked, ItemModel& out)
{
	if (!g_ready)
	{
		out.problem = "not ready";
		return false;
	}
	const std::string templatePath = Lower(asked);
	const std::shared_ptr<Entity> entity = ReadEntity(templatePath);
	if (!entity)
	{
		out.problem = "can't read " + templatePath;
		return false;
	}
	// Its appearance: one the table names, else one called monster, as one that changes shape has its others first, else
	// the first with something to see. A quest's monster can start out as an empty one, to be shown later.
	static const struct { const char* path; const char* look; } kLooks[] = {
		{ "\\monsters\\spriggan.w2ent", "spriggan_02" },   // Grottore, the quest's, has the first
		{ "\\mh207_wraith.w2ent", "wraith_02" },   // the Penitent, hooded in red; a plain wraith has the first
	};
	std::vector<const Entity::Look*> order;
	for (const auto& o : kLooks)
		if (o.path[0] && templatePath.find(o.path) != std::string::npos)
			for (const Entity::Look& l : entity->looks)
				if (_stricmp(l.name.c_str(), o.look) == 0)
					order.push_back(&l);
	// Then those the template says it uses, as Salma's is one succubus's and a beann'shie's not Longlocks', and after them the
	// rest; each lot with its monster first, and last a quest's own looks, named with __ in front: a succubus's disguise
	for (int pass = 0; pass < 6; ++pass)
		for (const Entity::Look& l : entity->looks)
		{
			const bool used = std::any_of(entity->usedLooks.begin(), entity->usedLooks.end(), [&](const std::string& u) { return _stricmp(u.c_str(), l.name.c_str()) == 0; });
			if (pass < 3 && !used)
				continue;
			const std::string name = Lower(l.name);
			const bool monster = name.find("monster") != std::string::npos && name.find("morph") == std::string::npos && name.find("cs") == std::string::npos && name.find("cutscene") == std::string::npos;
			const int kind = monster ? 0 : name.rfind("__", 0) == 0 || name.find("shadow") != std::string::npos || name.find("outline") != std::string::npos ? 2 : 1;   // and a ghost's shadow or outline, as Him has
			if (kind == pass % 3 && name != "invisible" && std::find(order.begin(), order.end(), &l) == order.end())
				order.push_back(&l);
		}
	bool read = false;
	const Entity::Look* look = nullptr;
	for (const Entity::Look* l : order)
	{
		ItemModel tried;
		tried.keepSkin = true;
		tried.creature = true;
		if ((read = LoadItemModel(templatePath + "#" + l->name, tried)))
		{
			out = std::move(tried);
			look = l;
			break;
		}
	}
	if (!read)
	{
		out.keepSkin = true;
		out.creature = true;
		read = LoadItemModel(templatePath, out);
	}
	if (!read)
		return false;
	// A part with no texture at all is a layer the game draws over it in some way of its own (the toad's): left out, as
	// it would otherwise cover it in plain grey. So is one textured to be unseen (the siren's second hair, which its human
	// look shows): that texture isn't in the game, and it would be drawn black.
	for (ModelPart& part : out.parts)
		if (part.diffuse.empty() || Lower(part.diffuse).find("invisible") != std::string::npos)
			part.shadowOnly = true;
	// Spectres, drawn by materials of their own: a barghest's skin graph, and Hym's ghost, which his always playing smoke
	// effect puts over him (the shader has what they do)
	const std::string lookName = look ? Lower(look->name) : std::string();
	const float spectre = lookName.find("barghest") != std::string::npos ? 1.f : lookName.rfind("him_", 0) == 0 ? 2.f : 0.f;
	if (spectre > 0.f)
		for (ModelPart& part : out.parts)
			part.ghost[3] = spectre;
	out.worn = true;          // it keeps the way up it stands
	out.creature = true;
	out.facingYaw = 180.f;    // modelled facing away, as a character is

	CreatureMotion motion;
	std::set<std::string> seen;
	FindMotion(templatePath, motion, seen, 0);
	if (look)
		for (const std::string& part : look->templates)
			FindMotion(part, motion, seen, 1);
	// Its rig: of those its components have, the one that names the most of its meshes' bones. A monster's template can
	// also hold a human's, for a form it takes.
	std::set<std::string> meshBones;
	for (const MeshBones& bones : out.meshBones)
		for (const std::string& name : bones.names)
			meshBones.insert(Lower(name));
	std::shared_ptr<Rig> rig;
	std::string rigPath;
	size_t rigNamed = 0;
	for (const std::string& path : motion.skeletons)
	{
		auto read = std::make_shared<Rig>();
		if (!ReadRig(path, *read))
			continue;
		size_t named = 0;
		for (const std::string& name : read->names)
			named += meshBones.count(Lower(name));
		if (!rig || named > rigNamed)
		{
			rig = read;
			rigPath = path;
			rigNamed = named;
		}
	}
	if (!rig)
	{
		Log("item models: %s: no rig to move it by (%zu named), so it stands as it was bound", templatePath.c_str(), motion.skeletons.size());
		return true;
	}

	// Which idle it stands in: the table's, for one the rules choose badly, else the best by name, earliest set first
	// A siren's flying idle sweeps her a few metres about, so she'd be framed small; on the ground she keeps still
	static const struct { const char* path; const char* clip; } kIdles[] = {
		{ "\\monsters\\siren", "monster_siren_ground_idle" },
		{ "\\mh210_lamia", "monster_siren_ground_idle" },
		// The ice giant's anchor follows his hand only in the idles made for it; in the others it lies where it was bound
		{ "\\monsters\\ice_giant", "giant_combat_anchor_idle_2" },
	};
	std::string set, clipName;
	size_t clips = 0;
	for (const auto& o : kIdles)
		if (o.path[0] && templatePath.find(o.path) != std::string::npos)
			for (const std::string& s : motion.animsets)
				for (const std::string& name : ClipNames(s))
					if (_stricmp(name.c_str(), o.clip) == 0 && clipName.empty())
					{
						set = s;
						clipName = name;
					}
	Clip clip;
	bool fits = !clipName.empty() && ReadClip(set, clipName, clip);
	if (!fits)
	{
		// The best by name that's made for its rig: a template can also give it a human's sets, whose clips would twist it
		struct Candidate { int rank; size_t order; std::string set, name; };
		std::vector<Candidate> candidates;
		for (const std::string& s : motion.animsets)
			for (const std::string& name : ClipNames(s))
			{
				++clips;
				const int rank = IdleRank(name);
				if (rank >= 0)
					candidates.push_back({ rank, candidates.size(), s, name });
			}
		std::stable_sort(candidates.begin(), candidates.end(), [](const Candidate& a, const Candidate& b)
		{
			return a.rank != b.rank ? a.rank < b.rank : a.name.size() != b.name.size() ? a.name.size() < b.name.size() : a.order < b.order;
		});
		clipName.clear();
		// A clip covers a rig's bones in order. One made for this rig can leave off a few at the end that nothing animates;
		// failing that, one made for a bigger rig of the same creature (its rig with a cloak's bones after) fits by its first
		// ones, as long as it isn't a human's, whose bones only line up with a human's rig.
		std::vector<std::pair<std::string, std::string>> longer;
		const auto human = [](const std::string& path)
		{
			const std::string lower = Lower(path);
			return lower.find("\\man\\") != std::string::npos || lower.find("\\woman\\") != std::string::npos || lower.find("\\child\\") != std::string::npos;
		};
		for (size_t i = 0; i < candidates.size() && i < 24 && !fits; ++i)
		{
			Clip tried;
			if (!ReadClip(candidates[i].set, candidates[i].name, tried))
				continue;
			if (tried.bones.size() <= rig->names.size() && tried.bones.size() + 4 >= rig->names.size())
			{
				clip = std::move(tried);
				set = candidates[i].set;
				clipName = candidates[i].name;
				fits = true;
			}
			else if (tried.bones.size() > rig->names.size() && !human(candidates[i].set))
				longer.emplace_back(candidates[i].set, candidates[i].name);
		}
		if (!fits && !longer.empty() && ReadClip(longer.front().first, longer.front().second, clip))
		{
			set = longer.front().first;
			clipName = longer.front().second;
			fits = true;
		}
	}
	if (!fits)
	{
		const std::string why = clipName.empty() ? std::string("no idle made for its rig") : "can't read " + clipName;
		Log("item models: %s: %s in %zu animation sets (%zu clips), so it stands as it was bound", templatePath.c_str(), why.c_str(), motion.animsets.size(), clips);
		return true;
	}
	// Its hair's, beard's and the like's bones are on its dangle buffers' rigs, which the game swings by its physics: each
	// one this rig hasn't, after it, under the bone of the same name. The idle leaves them as they hang.
	for (const std::string& path : motion.dangleSkeletons)
	{
		Rig dangle;
		if (!ReadRig(path, dangle))
			continue;
		std::map<std::string, int> have;
		for (size_t i = 0; i < rig->names.size(); ++i)
			have[Lower(rig->names[i])] = static_cast<int>(i);
		for (size_t i = 0; i < dangle.names.size() && i < dangle.pose.size(); ++i)
		{
			const std::string name = Lower(dangle.names[i]);
			const int parent = dangle.parents[i];
			if (have.count(name) || parent < 0 || parent >= static_cast<int>(dangle.names.size()))
				continue;
			const auto up = have.find(Lower(dangle.names[parent]));
			if (up == have.end() || rig->names.size() >= 0x7fff)
				continue;
			have[name] = static_cast<int>(rig->names.size());
			rig->names.push_back(dangle.names[i]);
			rig->parents.push_back(static_cast<int16_t>(up->second));
			rig->pose.push_back(dangle.pose[i]);
			rig->rest.push_back(BoneMatrix(dangle.pose[i]) * rig->rest[up->second]);
		}
	}
	if (!MakeSlots(out, *rig, false))
	{
		Log("item models: %s: its meshes' bones don't fit %s", templatePath.c_str(), rigPath.c_str());
		return true;
	}
	// The animation sets whose creatures lie along their rig's root, and stand (or fly level) on their clips': found by
	// showing every bestiary creature
	bool clipRoot = false;
	for (const char* part : { "monster_lessun", "monster_spriggan", "monster_siren", "miscreant", "monster_scolopendromorph", "monster_red_plague" })
		clipRoot = clipRoot || Lower(set).find(part) != std::string::npos;
	// A siren on the ground stands on her rig's root: her clip's would lay her on her side
	if (Lower(clipName).find("_ground_") != std::string::npos)
		clipRoot = false;
	out.animation = BakeLoop(*rig, clip, *static_cast<const std::vector<BoneSlot>*>(out.boneSlots.get()), clipRoot);

	// Which way it faces, from how it stands in the idle's first frame: its toes point ahead of the joints they hang from,
	// and failing toes, its head is ahead of the middle of it. Rigs don't all face the same way, a wolf's not as a drowner's.
	{
		std::vector<Bone> local;
		std::vector<M4> model;
		SamplePose(*rig, clip, 0.f, local);
		if (clipRoot && !clip.bones.empty() && !local.empty())
			SampleOrientation(clip, clip.bones[0].orientation, 0.f, local[0].rotation);
		ToModel(*rig, local, model);
		float ahead[2] = { 0.f, 0.f };
		int toes = 0;
		for (size_t b = 0; b < rig->names.size() && b < model.size(); ++b)
		{
			const std::string name = Lower(rig->names[b]);
			if (name.find("toe") == std::string::npos || name.find("finger") != std::string::npos)
				continue;
			// From its foot, not just the joint it hangs from: a human's toe hangs from a helper below the shin
			int parent = rig->parents[b];
			for (int up = 0; up < 3 && parent >= 0 && Lower(rig->names[parent]).find("foot") == std::string::npos; ++up)
				parent = rig->parents[parent];
			if (parent < 0 || Lower(rig->names[parent]).find("foot") == std::string::npos)
				parent = rig->parents[b];
			if (parent < 0)
				continue;
			ahead[0] += model[b].m[3][0] - model[parent].m[3][0];
			ahead[1] += model[b].m[3][1] - model[parent].m[3][1];
			++toes;
		}
		// On two legs, ahead is square to the line through its hips, which splayed feet don't throw off; the toes say which way
		std::vector<int> thighs;
		for (size_t b = 0; b < rig->names.size() && b < model.size(); ++b)
			if (Lower(rig->names[b]).find("thigh") != std::string::npos && Lower(rig->names[b]).find("roll") == std::string::npos)
				thighs.push_back(static_cast<int>(b));
		if (toes > 0 && thighs.size() == 2)
		{
			const float across[2] = { model[thighs[1]].m[3][0] - model[thighs[0]].m[3][0], model[thighs[1]].m[3][1] - model[thighs[0]].m[3][1] };
			float square[2] = { -across[1], across[0] };
			if (square[0] * ahead[0] + square[1] * ahead[1] < 0.f)
			{
				square[0] = -square[0];
				square[1] = -square[1];
			}
			if (square[0] * square[0] + square[1] * square[1] > 1e-6f)
			{
				ahead[0] = square[0];
				ahead[1] = square[1];
			}
		}
		if (toes == 0 || ahead[0] * ahead[0] + ahead[1] * ahead[1] < 1e-6f)
		{
			// From its pelvis, else the middle of its bones: a siren's wings and tail would pull the middle behind her head
			float middle[2] = { 0.f, 0.f };
			int pelvis = -1;
			for (size_t b = 0; b < rig->names.size() && b < model.size() && pelvis < 0; ++b)
				if (Lower(rig->names[b]).find("pelvis") != std::string::npos)
					pelvis = static_cast<int>(b);
			if (pelvis >= 0)
			{
				middle[0] = model[pelvis].m[3][0];
				middle[1] = model[pelvis].m[3][1];
			}
			else
				for (const M4& m : model)
				{
					middle[0] += m.m[3][0] / model.size();
					middle[1] += m.m[3][1] / model.size();
				}
			for (size_t b = 0; b < rig->names.size() && b < model.size(); ++b)
				if (Lower(rig->names[b]).find("head") != std::string::npos)
				{
					ahead[0] = model[b].m[3][0] - middle[0];
					ahead[1] = model[b].m[3][1] - middle[1];
					break;
				}
		}
		if (ahead[0] * ahead[0] + ahead[1] * ahead[1] > 1e-6f)
		{
			// A character modelled facing +Y is shown at 180, as Geralt is
			out.facingYaw = 270.f - atan2f(ahead[1], ahead[0]) * 180.f / 3.14159265f;
		}
		// Where that's wrong, by its rig, found by looking: a hag or a wight crouches side on with her face over her shoulder, a
		// giant looks off to one side of where he stands, and the insectoids' feet point the other way from their heads
		static const struct { const char* rig; float turn; } kTurns[] = {
			{ "\\gravehag_base.w2rig", -55.f },
			{ "\\wight_base.w2rig", -55.f },
			{ "\\giant_base.w2rig", -30.f },
			{ "\\arachas_base.w2rig", 180.f },
			{ "\\endriaga_base.w2rig", 180.f },
			{ "\\kikimore_base.w2rig", 180.f },
			{ "\\miscreant_base.w2rig", 180.f },   // the botchling, crawling
		};
		for (const auto& t : kTurns)
			if (Lower(rigPath).find(t.rig) != std::string::npos)
				out.facingYaw += t.turn;
	}
	out.boneSlots.reset();   // the wardrobe's stances are Geralt's: nothing else is baked for it
	out.idle = clipName + " (" + set + ")" + (look ? " look " + look->name : std::string()) + " rig " + rigPath;
	Log("item models: %s: %s from %s, %u frames, %.1f s", templatePath.c_str(), clipName.c_str(), set.c_str(), clip.frames, ClipSeconds(clip));
	return true;
}

// ---- a creature in two forms, as an alp is a cloaked woman until she turns: each in its own idle, one dissolving into
// the other and back, on one loop

namespace
{
	// A bone's matrix at a moment of a baked loop, between the two frames either side
	M4 BakedAt(const BakedAnimation& anim, uint32_t slot, float seconds)
	{
		M4 m;
		if (anim.frames < 2 || anim.duration <= 0.f)
		{
			const float* r = anim.rows.data() + static_cast<size_t>(slot) * 12;
			for (int row = 0; row < 3; ++row)
				for (int c = 0; c < 4; ++c)
					m.m[c][row] = r[row * 4 + c];
			return m;
		}
		const float at = fmodf(std::max(0.f, seconds), anim.duration) / anim.duration * static_cast<float>(anim.frames - 1);
		const uint32_t frame = std::min(static_cast<uint32_t>(at), anim.frames - 2);
		const float t = at - static_cast<float>(frame);
		const float* a = anim.rows.data() + (static_cast<size_t>(frame) * anim.slots + slot) * 12;
		const float* b = a + static_cast<size_t>(anim.slots) * 12;
		for (int row = 0; row < 3; ++row)
			for (int c = 0; c < 4; ++c)
				m.m[c][row] = a[row * 4 + c] + (b[row * 4 + c] - a[row * 4 + c]) * t;
		return m;
	}

	// The two in one model: the first form's parts, then the second's, their bones' slots after the first's, and both idles
	// on one loop. The second is turned to face as the first does.
	void MergeForms(ItemModel& first, ItemModel& second, ItemModel& out)
	{
		// How long each is shown and how long a change takes; the loop is made a whole number of the first's idles long, so
		// it carries on unbroken where the loop starts again, while the second's is out of sight
		constexpr float kHold = 4.f, kChange = 1.8f, kSecondHold = 7.f;
		const float firstLoop = std::max(0.5f, first.animation->duration);
		const float wanted = kHold + kSecondHold + kChange * 2.f;
		const float cycle = std::ceil(wanted / firstLoop) * firstLoop;
		const float secondHold = cycle - kHold - kChange * 2.f;

		const uint32_t firstSlots = first.animation->slots, secondSlots = second.animation->slots;
		out = std::move(first);
		const size_t bonesBefore = out.meshBones.size(), clothsBefore = out.cloths.size();
		for (ModelPart& p : out.parts)
			p.form = 0;
		for (ModelPart& p : second.parts)
		{
			p.form = 1;
			if (p.meshBones >= 0)
				p.meshBones += static_cast<int>(bonesBefore);
			if (p.cloth >= 0)
				p.cloth += static_cast<int>(clothsBefore);
			// Unskinned, it would stay with the first's slot 0: its own, turned with it, carries it
			if (p.skinning.empty())
				p.skinning.assign(p.vertices.size(), SkinVertex{});
			for (SkinVertex& s : p.skinning)
				for (uint16_t& b : s.bones)
					b = static_cast<uint16_t>(b + firstSlots);
			out.parts.push_back(std::move(p));
		}
		for (MeshBones& b : second.meshBones)
			out.meshBones.push_back(std::move(b));
		for (auto& c : second.cloths)
			out.cloths.push_back(std::move(c));
		for (int k = 0; k < 3; ++k)
		{
			out.boundsMin[k] = std::min(out.boundsMin[k], second.boundsMin[k]);
			out.boundsMax[k] = std::max(out.boundsMax[k], second.boundsMax[k]);
		}

		// The second turned by the difference in how they face, as the viewer turns them (row vectors)
		const float turn = (second.facingYaw - out.facingYaw) * 3.14159265f / 180.f;
		M4 rotate;
		rotate.m[0][0] = cosf(turn); rotate.m[0][1] = sinf(turn);
		rotate.m[1][0] = -sinf(turn); rotate.m[1][1] = cosf(turn);

		auto baked = std::make_shared<BakedAnimation>();
		baked->slots = firstSlots + secondSlots;
		baked->frames = static_cast<uint32_t>(std::lround(cycle * kBakedIntroRate)) + 1;
		baked->duration = cycle;
		baked->rows.resize(static_cast<size_t>(baked->frames) * baked->slots * 12);
		float* to = baked->rows.data();
		const auto put = [&](const M4& m)
		{
			for (int row = 0; row < 3; ++row)
				for (int c = 0; c < 4; ++c)
					*to++ = m.m[c][row];
		};
		for (uint32_t f = 0; f < baked->frames; ++f)
		{
			const float t = static_cast<float>(f) / kBakedIntroRate;
			for (uint32_t s = 0; s < firstSlots; ++s)
				put(BakedAt(*out.animation, s, t));
			// The second's idle starts as it begins to show
			for (uint32_t s = 0; s < secondSlots; ++s)
				put(BakedAt(*second.animation, s, t - kHold) * rotate);
		}
		out.animation = baked;
		out.formTimes[0] = kHold;
		out.formTimes[1] = kChange;
		out.formTimes[2] = secondHold;
		out.formTimes[3] = cycle;
		out.idle += " then " + second.idle;
	}
}

// The last few creatures shown, as they were made: going back to one is then a moment, not reading and baking it again
static bool LoadCreatureAnew(const std::string& asked, ItemModel& out);

bool LoadCreature(const std::string& asked, ItemModel& out)
{
	static std::mutex lock;
	static std::list<std::pair<std::string, ItemModel>> recent;   // most recent first
	constexpr size_t kKept = 4;
	{
		std::lock_guard<std::mutex> hold(lock);
		for (auto it = recent.begin(); it != recent.end(); ++it)
			if (it->first == asked)
			{
				recent.splice(recent.begin(), recent, it);
				out = it->second;
				return true;
			}
	}
	if (!LoadCreatureAnew(asked, out))
		return false;
	std::lock_guard<std::mutex> hold(lock);
	recent.emplace_front(asked, out);
	if (recent.size() > kKept)
		recent.pop_back();
	return true;
}

static bool LoadCreatureAnew(const std::string& asked, ItemModel& out)
{
	// monster+human: shown as the human first, turning into the monster and back
	const size_t plus = asked.find('+');
	if (plus == std::string::npos)
		return LoadOneCreature(asked, out);
	ItemModel monster, human;
	const bool gotMonster = LoadOneCreature(asked.substr(0, plus), monster);
	if (!gotMonster)
	{
		out = std::move(monster);
		return false;
	}
	if (!LoadOneCreature(asked.substr(plus + 1), human) || !human.animation || !monster.animation)
	{
		Log("item models: %s: its other form didn't come, so it's shown as itself", asked.c_str());
		out = std::move(monster);
		return true;
	}
	MergeForms(human, monster, out);
	return true;
}
