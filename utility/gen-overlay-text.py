"""Makes the overlay's two views of its text from source/strings/en.csv, the only place the text is written.

The block between ;overlay-text-begin and ;overlay-text-end holds one line per string, with keys starting potp_ov_.
From it this writes:
  overlay/src/text_table.inc   the ids, and the English the overlay shows before the scripts have said anything
  .../scripts/local/overlay/PotPOverlayText.ws   the keys the scripts look up in the player's language and pass over

To add a string: add a line to the block, run this (each overlay build also does), then use Tx(T_name) in the overlay.
A new key only reaches the game once the scripts have been compiled again; until then it shows in English.
Files are only written when they change, so a build doesn't recompile for nothing.
"""
import os
import sys

TOP = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CSV = os.path.join(TOP, 'source', 'strings', 'en.csv')
INC = os.path.join(TOP, 'overlay', 'src', 'text_table.inc')
WS = os.path.join(TOP, 'progress on the path ng', 'workspace', 'scripts', 'local', 'overlay', 'PotPOverlayText.ws')
PREFIX = 'potp_ov_'


def write_if_changed(path, text, bom=False):
    # bom: the scripts keep the UTF-8 BOM REDkit gives them, which the game needs; read with it stripped to compare
    encoding = 'utf-8-sig' if bom else 'utf-8'
    try:
        with open(path, encoding='utf-8', newline='') as f:
            if f.read() == ('﻿' if bom else '') + text:
                return
    except FileNotFoundError:
        pass
    with open(path, 'w', encoding=encoding, newline='') as f:
        f.write(text)
    print('wrote', os.path.relpath(path, TOP))


def main():
    strings = []
    inside = False
    with open(CSV, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\r\n')
            if line == ';overlay-text-begin':
                inside = True
            elif line == ';overlay-text-end':
                inside = False
            elif inside and line and not line.startswith(';'):
                _, _, key, text = line.split('|', 3)
                if not key.startswith(PREFIX):
                    sys.exit('overlay text key without ' + PREFIX + ': ' + key)
                strings.append((key[len(PREFIX):], text))
    if not strings:
        sys.exit('no overlay text found in en.csv')
    if len({k for k, _ in strings}) != len(strings):
        sys.exit('a key is in the overlay text block twice')

    inc = '// Made by utility/gen-overlay-text.py from source/strings/en.csv. Change it there.\n'
    for key, text in strings:
        escaped = text.replace('\\', '\\\\').replace('"', '\\"')
        inc += 'X(' + key + ', "' + escaped + '")\n'
    write_if_changed(INC, inc)

    ws = '// Made by utility/gen-overlay-text.py from source/strings/en.csv. Change it there.\n'
    ws += '// The overlay\'s own text, in the language the game is in. What comes back empty stays in English.\n\n'
    # REDkit's parser runs out of memory on one very long function
    per_function = 250
    parts = [strings[i:i + per_function] for i in range(0, len(strings), per_function)]
    for number, part in enumerate(parts, 1):
        ws += 'function PotPOverlay_TextKeys_' + str(number) + '(out keys: array<string>)\n{\n'
        for key, _ in part:
            ws += '\tkeys.PushBack("' + key + '");\n'
        ws += '}\n\n'
    ws += 'function PotPOverlay_ExportText() : string\n{\n\tvar keys\t: array<string>;\n\tvar result\t: string;\n\tvar text\t: string;\n\tvar Idx\t\t: int;\n\n'
    for number in range(1, len(parts) + 1):
        ws += '\tPotPOverlay_TextKeys_' + str(number) + '(keys);\n'
    ws += '\n\tfor (Idx = 0; Idx < keys.Size(); Idx += 1)\n\t{\n'
    ws += '\t\ttext = GetLocStringByKeyExt("' + PREFIX + '" + keys[Idx]);\n'
    ws += '\t\tif (text != "" && !StrStartsWith(text, "#"))\n\t\t{\n'
    ws += '\t\t\tresult += "\\nT|" + keys[Idx] + "|" + PotPOverlay_Clean(text);\n\t\t}\n\t}\n\treturn result;\n}\n'
    write_if_changed(WS, ws, bom=True)


main()
