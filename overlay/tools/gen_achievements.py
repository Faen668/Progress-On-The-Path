"""Makes achievements.dat: every store's achievement titles, descriptions and icons, for the overlay's Achievements tab.

    python -I gen_achievements.py <UserGameStatsSchema_292030.bin> <achievements.xml> <dlc achievements.xml> <icon folder> <out.dat>

The schema is Steam's cached list, in appcache/stats. The two XML files are game\\achievements.xml and
dlc\\bob\\data\\game\\achievements.xml, from the game's bundles: they tie the scripts' EA_ names to each store's own.
The icon folder holds the list's colour and grey JPGs, named as the list names them; any it lacks come from Steam's
public image server.

The file: "POTPACH1", then u32 text size, packed text size, atlas width, height, packed atlas size, cell size and
columns, then the zlib-packed text, then the zlib-packed RGBA atlas: colour icons above, the same layout in grey below.
The text is one line per achievement, tab-separated: script name, store name, group (0 the base game, 1 Hearts of
Stone, 2 Blood and Wine), hidden, then a title and description for each language on the first line.
"""
import io
import os
import re
import struct
import sys
import urllib.request
import zlib

from PIL import Image

CELL = 64
COLUMNS = 10
ICON_URL = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/292030/"


def text(raw):
    # Most of it is UTF-8. A few older strings are in the Windows code page.
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw.decode("cp1252", "replace")


def parse(data, at=0):
    out = {}
    while True:
        kind = data[at]
        at += 1
        if kind == 8:
            return out, at
        end = data.index(b"\0", at)
        key = data[at:end].decode("utf-8", "replace")
        at = end + 1
        if kind == 0:
            value, at = parse(data, at)
        elif kind == 1:
            end = data.index(b"\0", at)
            value = text(data[at:end])
            at = end + 1
        elif kind in (2, 3):
            value = data[at:at + 4]
            value = struct.unpack("<i" if kind == 2 else "<f", value)[0]
            at += 4
        elif kind == 7:
            value = struct.unpack_from("<Q", data, at)[0]
            at += 8
        else:
            raise ValueError(f"unknown type {kind} at {at}")
        out[key] = value


def script_names(paths):
    """Store name -> the scripts' EA_ name."""
    names = {}
    for path in paths:
        with open(path, encoding="utf-8-sig", errors="replace") as file:
            xml = re.sub(r"<!--.*?-->", "", file.read(), flags=re.S)
        for match in re.finditer(r'<achievement name="(\w+)"(.*?)</achievement>', xml, re.S):
            platforms = dict(re.findall(r'<platform name="(\w+)">([^<]*)<', match.group(2)))
            if platforms.get("steam") != platforms.get("gog"):
                raise ValueError(f"{match.group(1)}: Steam and GOG differ")
            if platforms.get("steam"):   # the DLC's file repeats some with the names left empty: the base file has them
                names[platforms["steam"]] = match.group(1)
    return names


def icon(folder, name):
    path = os.path.join(folder, name)
    if not os.path.exists(path):
        request = urllib.request.Request(ICON_URL + name, headers={"User-Agent": "potp-overlay-build"})
        with urllib.request.urlopen(request, timeout=30) as reply:
            data = reply.read()
        with open(path, "wb") as file:
            file.write(data)
    with open(path, "rb") as file:
        return Image.open(io.BytesIO(file.read())).convert("RGBA").resize((CELL, CELL), Image.LANCZOS)


def main():
    schema_path, xml_base, xml_bob, icons, out_path = sys.argv[1:6]
    with open(schema_path, "rb") as file:
        root, _ = parse(file.read())
    stats = next(iter(root.values()))["stats"]
    bits = [bit for stat in stats.values() if isinstance(stat, dict) and "bits" in stat for bit in stat["bits"].values()]
    scripts = script_names([xml_base, xml_bob])
    if len(bits) != len(scripts) or any(bit["name"] not in scripts for bit in bits):
        raise ValueError(f"the list has {len(bits)}, the game's files {len(scripts)}")

    languages = sorted({language for bit in bits for language in bit["display"]["name"] if language != "token"}, key=lambda l: (l != "english", l))
    lines = ["\t".join(languages)]
    rows = (len(bits) + COLUMNS - 1) // COLUMNS
    atlas = Image.new("RGBA", (COLUMNS * CELL, rows * CELL * 2))
    os.makedirs(icons, exist_ok=True)
    clean = lambda s: re.sub(r"\s+", " ", s).strip()

    for index, bit in enumerate(bits):
        store = bit["name"]
        display = bit["display"]
        group = 1 if store.startswith("EP1") else 2 if store.startswith("EP2") else 0
        fields = [scripts[store], store, str(group), str(int(display.get("hidden", 0) or 0))]
        for language in languages:
            fields.append(clean(display["name"].get(language, "")))
            fields.append(clean(display["desc"].get(language, "")))
        lines.append("\t".join(fields))
        x, y = index % COLUMNS * CELL, index // COLUMNS * CELL
        atlas.paste(icon(icons, display["icon"]), (x, y))
        atlas.paste(icon(icons, display["icon_gray"]), (x, y + rows * CELL))

    packed_text = zlib.compress("\n".join(lines).encode("utf-8"), 9)
    raw_text = "\n".join(lines).encode("utf-8")
    packed_atlas = zlib.compress(atlas.tobytes(), 9)
    with open(out_path, "wb") as file:
        file.write(b"POTPACH1")
        file.write(struct.pack("<7I", len(raw_text), len(packed_text), atlas.width, atlas.height, len(packed_atlas), CELL, COLUMNS))
        file.write(packed_text)
        file.write(packed_atlas)
    groups = [sum(1 for bit in bits if (1 if bit["name"].startswith("EP1") else 2 if bit["name"].startswith("EP2") else 0) == g) for g in range(3)]
    print(f"{len(bits)} achievements ({groups[0]} base, {groups[1]} Hearts of Stone, {groups[2]} Blood and Wine), "
          f"{len(languages)} languages, {sum(1 for b in bits if b['display'].get('hidden'))} hidden, {os.path.getsize(out_path)} bytes")
    print("languages:", ", ".join(languages))


if __name__ == "__main__":
    main()
