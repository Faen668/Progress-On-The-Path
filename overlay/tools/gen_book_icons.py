"""Makes overlay/src/book_icons.inc: the shapes of the game's own menu icons that the overlay's tabs use.

    python -I overlay/tools/gen_book_icons.py "<REDkit's r4data folder>"

The icons are The Witcher 3's, by CD PROJEKT RED, taken from REDkit's copy of the game's menus (the .swf files under
gameplay/gui_new/swf), where they are plain images. Only each one's shape is kept, its alpha, as the overlay gives it its
own colour, light and shade.
"""
import os
import struct
import sys
import zlib

# Which picture of which menu, for which book, as the overlay numbers its tabs
ICONS = [
    ("kBookQuest", "common/panel_common.swf", 60),         # the journal's book
    ("kBookWorld", "common/panel_common.swf", 58),         # the map's compass
    ("kBookItems", "common/panel_common.swf", 12),         # the inventory's chest
    ("kBookGwent", "gwint/gwint_game.swf", 1160),          # a hand of cards
    ("kBookBestiary", "common/panel_common.swf", 31),      # the glossary's bestiary
    ("kTabAchievements", "common/panel_common.swf", 569),  # a crown and coins
    ("kTabKills", "hud/hud_enemyfocus.swf", 59),           # a skull and a dagger
]


def bitmaps(path):
    """Every lossless bitmap with alpha in a .swf, by its character id: (width, height, ARGB bytes)."""
    data = open(path, "rb").read()
    body = zlib.decompress(data[8:]) if data[:3] == b"CWS" else data[8:]
    at = (5 + 4 * (body[0] >> 3) + 7) // 8 + 4
    found = {}
    while at + 2 <= len(body):
        head = struct.unpack_from("<H", body, at)[0]
        at += 2
        tag, length = head >> 6, head & 63
        if length == 63:
            length = struct.unpack_from("<I", body, at)[0]
            at += 4
        if tag == 36:   # DefineBitsLossless2
            character, form, width, height = struct.unpack_from("<HBHH", body, at)
            if form == 5:
                found[character] = (width, height, zlib.decompress(body[at + 7:at + length]))
        if tag == 0:
            break
        at += length
    return found


def main():
    root = os.path.join(sys.argv[1], "gameplay", "gui_new", "swf")
    out = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "src", "book_icons.inc")
    files = {}
    lines = [
        "// Made by overlay/tools/gen_book_icons.py from REDkit's copy of the game's menus. Don't edit by hand.",
        "// The shapes (alpha) of The Witcher 3's own menu icons, (c) CD PROJEKT RED: one per book that the game has one for.",
        "// BOOK_ICON(book, width, height, alpha bytes row by row)",
    ]
    for book, menu, character in ICONS:
        if menu not in files:
            files[menu] = bitmaps(os.path.join(root, menu))
        width, height, argb = files[menu][character]
        alpha = bytes(argb[i] for i in range(0, width * height * 4, 4))
        body = ",".join(str(a) for a in alpha)
        lines.append("BOOK_ICON(%s, %d, %d, {%s})" % (book, width, height, body))
        print("%s: %s #%d, %dx%d" % (book, menu, character, width, height))
    with open(out, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
