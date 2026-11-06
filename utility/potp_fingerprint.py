"""Takes a fingerprint of the mod's scripts, and later says what has changed since.

    python -I potp_fingerprint.py make <folder> [--uses <decompiled .ws> <label>] [--game <the game's folder>]
    python -I potp_fingerprint.py compare <folder> [<report.md>]

make writes manifest.json, which lists every class, struct, enum value, function, field, annotation, string key and
menu setting, each function with a hash of its code, and keeps a full copy of the scripts, the strings, the menu and the
compiled scripts beside it, so anything removed can be read or brought back.

--uses records which of those names another mod's decompiled scripts mention, so compare can say which removals touch
it. Only the names are kept, not the other mod's code. It goes by name, so a common name can be a false match.

compare reads the mod as it is now and reports what was removed, added or changed since the fingerprint was made.
"""
import hashlib
import json
import os
import re
import shutil
import sys
from datetime import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT = os.path.dirname(HERE)
SCRIPTS = os.path.join(PROJECT, "progress on the path ng", "workspace", "scripts", "local")
PACKED_BLOB = os.path.join(PROJECT, "progress on the path ng", "packed", "mods", "modprogressonthepathng", "content", "precompiled.rsblob")
STRINGS = os.path.join(PROJECT, "source", "strings", "en.csv")
MENU = os.path.join(PROJECT, "source", "menu", "modProgressOnThePath.xml")
DEFAULT_GAME = r"F:\Steam\steamapps\common\The Witcher 3"
TYPE_WORDS = r"(?:abstract |import |statemachine |final )*"
MEMBER_WORDS = r"(?:public |private |protected |final |latent |entry |timer |exec |import |storyscene |quest |cleanup )*"


def read_text(path):
    with open(path, encoding="utf-8-sig", errors="replace", newline="") as file:
        return file.read().replace("\r\n", "\n")


def strip_code(line):
    """The line without its strings and comment, so braces inside them aren't counted."""
    line = re.sub(r'"[^"]*"', '""', line)
    return line.split("//", 1)[0]


def parse_file(rel, text, symbols):
    lines = text.split("\n")
    depth = 0
    container = ""          # the class, state, struct or enum we're in
    container_kind = ""
    annotation = None       # @wrapMethod(X) and so on, waiting for what it applies to
    index = 0

    def add(kind, name, signature, body=None):
        key = f"{kind}:{name}"
        entry = {"file": rel, "signature": signature}
        if body is not None:
            entry["code"] = hashlib.sha1(re.sub(r"\s+", " ", body).encode("utf-8")).hexdigest()[:16]
        symbols[key] = entry

    while index < len(lines):
        raw = lines[index]
        line = strip_code(raw)
        stripped = line.strip()
        index += 1

        match = re.match(r"@(wrapMethod|addMethod|replaceMethod|addField)(?:\((\w+)\))?", stripped)
        if match and depth == 0:
            annotation = (match.group(1), match.group(2) or "")
            continue

        if depth == 0:
            match = re.match(TYPE_WORDS + r"class\s+(\w+)(?:\s+extends\s+(\w+))?", stripped)
            if match:
                container, container_kind = match.group(1), "class"
                add("class", container, stripped)
            match_state = re.match(r"state\s+(\w+)\s+in\s+(\w+)", stripped)
            if match_state:
                container, container_kind = f"{match_state.group(2)}.state.{match_state.group(1)}", "class"
                add("state", container, stripped)
            match_struct = re.match(TYPE_WORDS + r"struct\s+(\w+)", stripped)
            if match_struct:
                container, container_kind = match_struct.group(1), "struct"
                add("struct", container, stripped)
            match_enum = re.match(r"enum\s+(\w+)", stripped)
            if match_enum:
                container, container_kind = match_enum.group(1), "enum"
                add("enum", container, stripped)

        # Fields of the annotation's own kind sit at the top level
        if depth == 0 and annotation and annotation[0] == "addField":
            match = re.match(r"var\s+(\w+)\s*:\s*(.+?);", stripped)
            if match:
                add("addField", f"{annotation[1]}.{match.group(1)}", re.sub(r"\s+", " ", stripped))
                annotation = None
                continue

        # A function or event, with its whole body
        at_function_level = depth == 0 or (depth == 1 and container_kind == "class")
        match = re.match(MEMBER_WORDS + r"(function|event)\s+(\w+)\s*\((.*)", stripped) if at_function_level else None
        if match:
            name = match.group(2)
            start = index - 1
            opened = line.count("{") - line.count("}")
            seen = "{" in line
            signature = stripped
            while not seen and index < len(lines):
                next_line = strip_code(lines[index])
                # An import has no body: it ends on a semicolon
                if signature.rstrip().endswith(";"):
                    break
                if "{" in next_line:
                    seen = True
                    opened += next_line.count("{") - next_line.count("}")
                else:
                    signature += " " + next_line.strip()
                index += 1
            while seen and opened > 0 and index < len(lines):
                next_line = strip_code(lines[index])
                opened += next_line.count("{") - next_line.count("}")
                index += 1
            body = "\n".join(strip_code(row) for row in lines[start:index])
            signature = re.sub(r"\s+", " ", signature.split("{")[0]).strip().rstrip(";")
            if depth == 0 and annotation:
                add(annotation[0], f"{annotation[1]}.{name}" if annotation[1] else name, signature, body)
                annotation = None
            elif depth == 0:
                add("function", name, signature, body)
            else:
                add("method" if match.group(1) == "function" else "event", f"{container}.{name}", signature, body)
            continue

        if depth == 1 and container_kind in ("class", "struct"):
            match = re.match(r"(?:(?:public|private|protected|editable|saved|const|import|inlined)\s+)*var\s+([\w\s,]+?)\s*:\s*(.+?);", stripped)
            if match:
                for name in match.group(1).split(","):
                    add("field", f"{container}.{name.strip()}", f"{name.strip()} : {re.sub(chr(92) + 's+', ' ', match.group(2))}")
            match = re.match(r"default\s+(\w+)\s*=", stripped)
            if match:
                add("default", f"{container}.{match.group(1)}", stripped)
        if depth == 1 and container_kind == "enum":
            match = re.match(r"(\w+)\s*(?:=\s*(-?\w+))?\s*,?$", stripped)
            if match and match.group(1):
                add("enumValue", f"{container}.{match.group(1)}", stripped.rstrip(","))

        depth += line.count("{") - line.count("}")
        if depth <= 0:
            depth = 0
            if "}" in line:
                container, container_kind = "", ""


def script_files():
    found = []
    for root, _, names in os.walk(SCRIPTS):
        for name in names:
            if name.lower().endswith(".ws"):
                path = os.path.join(root, name)
                found.append((os.path.relpath(path, SCRIPTS).replace("\\", "/"), path))
    return sorted(found)


def read_mod():
    """Everything a fingerprint holds, read from the mod as it is now."""
    symbols, files, used_keys = {}, {}, {}
    for rel, path in script_files():
        text = read_text(path)
        with open(path, "rb") as file:
            files[rel] = {"sha256": hashlib.sha256(file.read()).hexdigest(), "lines": text.count("\n") + 1}
        parse_file(rel, text, symbols)
        for key in re.findall(r'GetLocStringByKeyExt\(\s*"([^"]+)"', text):
            used_keys.setdefault(key, set()).add(rel)

    string_keys = {}
    if os.path.exists(STRINGS):
        for line in read_text(STRINGS).split("\n"):
            parts = line.split("|")
            if len(parts) >= 4 and not line.startswith(";"):
                string_keys[parts[2]] = hashlib.sha1(parts[3].encode("utf-8")).hexdigest()[:16]

    menu = {}
    if os.path.exists(MENU):
        text = read_text(MENU)
        for group in re.finditer(r'<Group id="([^"]+)"(.*?)</Group>', text, re.S):
            menu[f"group:{group.group(1)}"] = hashlib.sha1(group.group(2).encode("utf-8")).hexdigest()[:16]
            for var in re.finditer(r'<Var id="([^"]+)"', group.group(2)):
                if var.group(1):
                    menu[f"var:{group.group(1)}.{var.group(1)}"] = "present"

    return {
        "symbols": symbols,
        "files": files,
        "stringKeysUsedInScripts": {k: sorted(v) for k, v in sorted(used_keys.items())},
        "stringKeysInCsv": string_keys,
        "menu": menu,
    }


def make(folder, uses, game):
    if os.path.exists(os.path.join(folder, "manifest.json")):
        sys.exit(f"{folder} already has a fingerprint: it's the record of that moment, so make a new folder instead")
    os.makedirs(folder, exist_ok=True)
    manifest = read_mod()
    manifest["taken"] = datetime.now().isoformat(timespec="seconds")

    shutil.copytree(SCRIPTS, os.path.join(folder, "scripts", "local"))
    copies = {"strings_en.csv": STRINGS, "modProgressOnThePath.xml": MENU, "packed.precompiled.rsblob": PACKED_BLOB,
              "installed.precompiled.rsblob": os.path.join(game, "mods", "modProgressOnThePathNG", "content", "precompiled.rsblob")}
    manifest["copies"] = {}
    for name, source in copies.items():
        if os.path.exists(source):
            shutil.copy2(source, os.path.join(folder, name))
            with open(source, "rb") as file:
                manifest["copies"][name] = hashlib.sha256(file.read()).hexdigest()

    manifest["usedBy"] = {}
    for path, label in uses:
        text = read_text(path)
        words = set(re.findall(r"\w+", text))
        named = set()
        for key in manifest["symbols"]:
            name = key.split(":", 1)[1].split(".")[-1]
            if name in words:
                named.add(key)
        wrapped = sorted(set(re.findall(r"@(?:wrapMethod|addMethod|addField)(?:\((\w+)\))?\s*\n\s*(?:function|var)\s+(\w+)", text)))
        manifest["usedBy"][label] = {"names": sorted(named), "annotations": [f"{a}.{b}" if a else b for a, b in wrapped]}

    with open(os.path.join(folder, "manifest.json"), "w", encoding="utf-8") as file:
        json.dump(manifest, file, indent=1, sort_keys=True)
    counts = {}
    for key in manifest["symbols"]:
        kind = key.split(":", 1)[0]
        counts[kind] = counts.get(kind, 0) + 1
    print(f"{len(manifest['files'])} script files, {len(manifest['symbols'])} symbols: " + ", ".join(f"{v} {k}" for k, v in sorted(counts.items())))
    print(f"{len(manifest['stringKeysInCsv'])} strings in en.csv, {len(manifest['stringKeysUsedInScripts'])} keys named in scripts, {len(manifest['menu'])} menu items")
    print("copies kept: " + ", ".join(manifest["copies"]))
    for label, data in manifest["usedBy"].items():
        print(f"{label}: mentions {len(data['names'])} names, annotates {len(data['annotations'])}")


def section(out, title, rows):
    if rows:
        out.append(f"\n## {title} ({len(rows)})\n")
        out.extend(f"- {row}" for row in rows)


def compare(folder, report):
    with open(os.path.join(folder, "manifest.json"), encoding="utf-8") as file:
        old = json.load(file)
    new = read_mod()
    out = [f"# What has changed since the fingerprint of {old['taken']}", f"\nCompared {datetime.now().isoformat(timespec='seconds')}."]

    before, after = old["symbols"], new["symbols"]
    removed = sorted(set(before) - set(after))
    added = sorted(set(after) - set(before))
    signature = sorted(k for k in set(before) & set(after) if before[k]["signature"] != after[k]["signature"])
    code = sorted(k for k in set(before) & set(after) if before[k].get("code") != after[k].get("code") and before[k]["signature"] == after[k]["signature"])
    moved = sorted(k for k in set(before) & set(after) if before[k]["file"] != after[k]["file"])

    section(out, "Removed", [f"`{k}` ({before[k]['file']}): `{before[k]['signature']}`" for k in removed])
    section(out, "Signature changed", [f"`{k}`: `{before[k]['signature']}` is now `{after[k]['signature']}`" for k in signature])
    section(out, "Code changed", [f"`{k}` ({after[k]['file']})" for k in code])
    section(out, "Added", [f"`{k}` ({after[k]['file']}): `{after[k]['signature']}`" for k in added])
    section(out, "Moved to another file", [f"`{k}`: {before[k]['file']} to {after[k]['file']}" for k in moved])

    for label, data in old.get("usedBy", {}).items():
        names = set(data["names"])
        section(out, f"Removed or changed, and named by {label}", [f"`{k}`" for k in removed + signature if k in names])
        # Only its annotations on the mod's own code: it also annotates the game's classes and adds its own fields
        ours = [a for a in data["annotations"] if any(k.endswith(":" + a) or k.endswith("." + a) for k in before)]
        gone = [a for a in ours if not any(k.endswith(":" + a) or k.endswith("." + a) for k in after)]
        section(out, f"Annotation targets of {label} that no longer exist", [f"`{a}`" for a in gone])

    old_files, new_files = old["files"], new["files"]
    section(out, "Script files removed", [f"{f} ({old_files[f]['lines']} lines)" for f in sorted(set(old_files) - set(new_files))])
    section(out, "Script files added", [f"{f} ({new_files[f]['lines']} lines)" for f in sorted(set(new_files) - set(old_files))])
    section(out, "Script files changed", [f"{f}: {old_files[f]['lines']} to {new_files[f]['lines']} lines" for f in sorted(set(old_files) & set(new_files)) if old_files[f]["sha256"] != new_files[f]["sha256"]])

    old_used, new_used = old["stringKeysUsedInScripts"], new["stringKeysUsedInScripts"]
    no_longer = sorted(set(old_used) - set(new_used))
    section(out, "String keys the scripts no longer name", [f"`{k}`{' (still in en.csv)' if k in new['stringKeysInCsv'] else ''}" for k in no_longer])
    section(out, "String keys removed from en.csv", [f"`{k}`" for k in sorted(set(old["stringKeysInCsv"]) - set(new["stringKeysInCsv"]))])
    section(out, "String keys added to en.csv", [f"`{k}`" for k in sorted(set(new["stringKeysInCsv"]) - set(old["stringKeysInCsv"]))])
    section(out, "String text changed in en.csv", [f"`{k}`" for k in sorted(set(old["stringKeysInCsv"]) & set(new["stringKeysInCsv"])) if old["stringKeysInCsv"][k] != new["stringKeysInCsv"][k]])
    section(out, "Menu items removed", [f"`{k}`" for k in sorted(set(old["menu"]) - set(new["menu"]))])
    section(out, "Menu items added", [f"`{k}`" for k in sorted(set(new["menu"]) - set(old["menu"]))])

    if len(out) == 2:
        out.append("\nNothing has changed.")
    text = "\n".join(out) + "\n"
    if report:
        with open(report, "w", encoding="utf-8") as file:
            file.write(text)
        print(f"written to {report}")
    print(f"{len(removed)} removed, {len(signature)} signatures changed, {len(code)} changed inside, {len(added)} added, {len(moved)} moved")
    if not report:
        print(text)


def main():
    arguments = sys.argv[1:]
    if len(arguments) < 2 or arguments[0] not in ("make", "compare"):
        sys.exit(__doc__)
    if arguments[0] == "compare":
        compare(arguments[1], arguments[2] if len(arguments) > 2 else None)
        return
    uses, game, at = [], DEFAULT_GAME, 2
    while at < len(arguments):
        if arguments[at] == "--uses":
            uses.append((arguments[at + 1], arguments[at + 2]))
            at += 3
        elif arguments[at] == "--game":
            game = arguments[at + 1]
            at += 2
        else:
            sys.exit(f"don't know {arguments[at]}")
    make(arguments[1], uses, game)


if __name__ == "__main__":
    main()
