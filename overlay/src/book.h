#pragma once
#include <cstdint>
#include <string>
#include <vector>

struct GameTexture;
struct ItemModel;

// The Library's book (Live Book Preview): PotP's own model of a big leather-bound tome, made in Blender for the overlay
// alone (Progress on the Path - Resources/library-book) and built into PotpOverlay.asi with its textures. It never
// goes into the game. BookClosedRequest gives what to ask the model viewer for it shut, BookRequest open on a book.
inline constexpr const char* kModelBook = "book:";
bool LoadBookModel(const std::string& which, ItemModel& out);

// The book's textures, by the names its parts give them (potp:book_d, potp:page:... and so on): decoded from the .asi,
// or written, as the model viewer reads the game's, the largest side no more than asked, with their smaller levels
inline constexpr const char* kBuiltinTexture = "potp:";
bool ReadBuiltinTexture(const std::string& name, uint32_t largestSide, GameTexture& out, bool withMips);

// A book's text, laid out into pages: a title page (its name, and the shelf it's on), then the text, two pages a spread
void BookSetText(const std::string& uuid, const std::string& title, const std::string& section, const std::vector<std::string>& paragraphs);
bool BookHasText(const std::string& uuid);

// The title on a book's cover, written in gilt on the cover's plate (closed, and the open book's front cover), and the
// Library shelf it's on (0 Lore Books, 1 Monster Tomes), which with its title and id chooses the look of its binding
void BookSetTitle(const std::string& uuid, const std::string& title, int shelf = 0);
std::string BookClosedRequest(const std::string& uuid);   // the book shut, its title on the cover

// The book open on that one, where it was left: what to ask the model viewer for. The same while it's shown, as its
// pages turn without reading the model again.
std::string BookRequest(const std::string& uuid);
bool BookTurn(int direction);   // 1 the next spread, -1 the one before: false at either end, or while a page is turning
void BookTick(float dt);        // each frame it's shown: the turn moves on, and the viewer is told where the leaf is
int BookSpread();               // the spread open, from 0
int BookSpreadCount();
int BookPageCount();            // the title page included
bool BookTurning();
// The open book shut, its cover up, or opened again, turning over on its spine: false while a page is turning
bool BookShut(bool shut);
bool BookShutting();            // shut or shutting: what a second press would undo
void BookTestShut(float shut);  // the test harness's: held that far shut, 0 to 1, as it is shown; below 0 let go
