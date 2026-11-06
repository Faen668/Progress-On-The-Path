#pragma once
#include <array>
#include <cstdint>
#include <memory>
#include <string>
#include <vector>

#include "cloth.h"

// An item's model, read from the game's own files wherever the game would find them (a mod, a DLC, then the game):
// the item's template, the meshes its appearance uses, and the textures their materials name.
struct ModelVertex
{
	float position[3];
	float normal[3];
	float tangent[4];   // w: which way the normal map's green runs
	float uv[2];
	uint8_t colour[4] = { 255, 255, 255, 255 };   // the mesh's vertex colour, as it's stored: the hair graphs darken by it
};

// Which bones move a vertex and how much: a second stream beside its ModelVertex
struct SkinVertex
{
	uint16_t bones[4] = { 0, 0, 0, 0 };
	uint8_t weights[4] = { 255, 0, 0, 0 };
};

struct MeshBones
{
	std::vector<std::string> names;
	std::vector<std::array<float, 16>> inverseBinds;
};

// An animation worked out ahead of time, for the card: for each frame, each bone's matrix as three rows of four, to be
// blended between two frames in the vertex shader. Slot 0 of each frame leaves a vertex where it is.
inline constexpr float kBakedIntroRate = 30.f;

struct BakedAnimation
{
	uint32_t frames = 1, slots = 1;
	uint32_t introFrames = 0;   // how many of the frames lead into it, at kBakedIntroRate, played once before it loops
	float duration = 0.f;       // of the part that loops
	std::vector<float> rows;
};

struct ModelPart
{
	std::vector<ModelVertex> vertices;
	std::vector<SkinVertex> skinning;   // as many as vertices, only when asked for and it's skinned
	int meshBones = -1;             // in ItemModel::meshBones
	std::string hungOn;             // a weapon's: the bone of the scabbards' rig it hangs on
	std::string attachBone;         // a creature's prop: the bone of its rig it's fastened to, rigidly
	bool inHand = false;            // the sword he holds, in a stance that holds one
	std::vector<uint32_t> indices;
	std::string diffuse, normal;   // texture paths, empty if its material has none
	bool shadowOnly = false;       // for shadows alone: not to be drawn
	bool masked = false;           // cut out by its diffuse map's alpha
	std::string tintMask, specular;   // its tint mask and specular map, if it has them
	std::string graph;              // its material's graph, by name

	// The material's numbers, as the game's material graphs use them
	float specScale = 1.f, specBase = 0.f, roughMin = 0.f, roughMax = 1.f;
	float specColour[3] = { 0.017f, 0.017f, 0.017f };   // linear
	float aoPower = 0.5f;
	float variance[4] = { 1.f, 1.f, 1.f, 1.f };   // colour and offset: 1 leaves the colour as it is
	bool skin = false;
	std::string detail1, detail2;   // detail normal maps
	float detailTile1[2] = { 5.f, 5.f }, detailTile2[2] = { 5.f, 5.f };
	float detailPower = 0.5f, detailAlbedo = 0.f;
	float ghost[4] = {};            // a creature's: w 1 a barghest, 2 Hym, drawn as their own spectral materials are
	float detailRange = 5.f;        // how near the camera has to be for the detail to show at all, in metres
	int detailMode = 0;   // 1 one map where the tint mask's blue says, 2 two maps, 3 one map everywhere
	bool shifting = false, keepGray = false, blendColors = false;   // recoloured by its appearance
	float shiftRed[9] = {}, shiftBlue[9] = {};   // the colour shifts' matrices, as rows
	int cloth = -1;                 // in ItemModel::cloths, if it's simulated
	std::vector<ClothVertex> clothing;   // as many as vertices then: what carries each
};

struct ItemModel
{
	std::vector<ModelPart> parts;
	float boundsMin[3] = {}, boundsMax[3] = {};
	int clothSkipped = 0;   // cloth pieces, which aren't read yet
	bool worn = false;      // skinned: it keeps the way up it's worn
	float facingYaw = 0.f;  // the turn that brings its front to the viewer
	bool keepSkin = false;  // asked for before reading: bones and weights are kept
	bool halfTurned = false;   // asked for before reading: a crossbow, for his back
	bool creature = false;  // a bestiary creature, in its own idle
	std::string idle;       // its idle's clip, and the animation set it's from
	std::vector<MeshBones> meshBones;
	std::vector<std::shared_ptr<ClothData>> cloths;
	std::shared_ptr<const BakedAnimation> animation;   // null: it stays as it is
	std::shared_ptr<const void> boneSlots;             // what another animation needs, to be baked for this body
	std::string problem;    // why there's nothing to show
};

void BuildModelIndex(const std::wstring& game);   // on a loading thread
bool ModelIndexReady();
bool LoadItemModel(const std::string& templateName, ItemModel& out);

// Worn armour on Geralt himself. The game builds him from what he has equipped, so this does the same: his head, hair and
// starting gear, as his default inventory has them, with the piece in question in place of its own kind.
inline constexpr const char* kModelOnGeralt = "geralt:";   // before a template's name, for the model viewer
bool IsWornPiece(const std::string& templateName);          // armour, trousers, boots, gloves, swords or a crossbow
// The dyes a piece of armour can take, as far as loading it has shown: its appearances called dye_something.
// A template asked for as name#dye_red comes in that appearance.
std::vector<std::string> ItemDyeLooks(const std::string& templateName);
// nothing:armor, among what he's asked to wear: that kind off him
inline constexpr const char* kWornNothing = "nothing:";
std::string WornCategory(const std::string& templateName);  // its kind, as the item definitions call it, or nothing
// The templates after "geralt:", split by |, least important first: each takes its kind's place. The last is the piece asked about.
bool LoadItemOnGeralt(const std::string& templates, int animation, ItemModel& out);

// A creature as the bestiary shows it: its npc template's model, looping one of its own idles. The template's path after
// "creature:", for the model viewer.
inline constexpr const char* kModelCreature = "creature:";
bool LoadCreature(const std::string& templatePath, ItemModel& out);

// The stances he can stand in, in order. One is worked out for the card in a moment, on a loading thread.
int AnimationCount();
// from: the stance he's coming from, fromTime how far into it, to lead into this one; -1 if there's nothing to lead from.
std::shared_ptr<const BakedAnimation> BakeAnimation(const std::shared_ptr<const void>& boneSlots, int animation, int from = -1, float fromTime = 0.f);

// One bundle on its own, as the load order check looks at each mod's
std::vector<std::string> BundleFileNames(const std::wstring& bundle);   // in lower case
bool ReadBundleFile(const std::wstring& bundle, const std::string& lowerName, std::vector<uint8_t>& out);
