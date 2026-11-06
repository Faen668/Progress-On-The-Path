"""Makes the lists the Achievement Creation Tool picks from, so a pack's author never has to know an internal name.

From REDkit's copy of the game's files (r4data), decoded with W3 Mod Workbench, and from PotP's own definitions:
  quests.json        each journal quest: the name <quest journal> takes, its title in English, its kind and where
  facts.json         each fact the quests set or check, and which quest files do which
  quest_blocks.json  each quest file's blocks: GUID, kind, name and outputs, for <questBlock>
  items.json         each item: name, category, English name, icon; Gwent cards are the ones in category gwint
  kills.json         each name PotP counts kills by: the string ID <kills nameId> takes, and the English
  potp.json          PotP's sections (<potpSection id>) and entries (<potpEntry uuid>), with their English names
  achievements.json  the game's own achievements, for <vanillaAchievement>
  icons.json         PotP's own achievement icons: name and SVG path data
  meta.json          when, from what, and how many of each

  python gen_achievement_catalog.py --out <folder> [--cache <folder>] [--redkit <r4data>] [--workbench <exe>]

The decoded files are kept in --cache (in the temp folder unless given), so a second run only reads them.
"""
import argparse
import datetime
import glob
import json
import os
import re
import sqlite3
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zlib

TOP = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SCRIPTS = os.path.join(TOP, 'progress on the path ng', 'workspace', 'scripts', 'local')
DEFAULT_REDKIT = r'F:\Steam\steamapps\common\The Witcher 3 REDkit\r4data'
DEFAULT_WORKBENCH = os.path.join(os.path.dirname(TOP), 'W3 Mod Workbench', 'W3ModWorkbench', 'bin', 'Release', 'net9.0-windows', 'W3ModWorkbench.exe')
ENGLISH = 2   # LANGUAGES.ID of EN in REDkit's string database


def decode(workbench, folder, match, cache):
    """Every CR2W file under folder whose path matches, to JSON under cache, once"""
    os.makedirs(cache, exist_ok=True)
    print('decoding', folder, match, flush=True)
    result = subprocess.run([workbench, '--to-json', folder, '--recursive', '--match', match, '--out', cache],
                            capture_output=True, text=True, timeout=3600)
    tail = (result.stdout + result.stderr).strip().splitlines()[-1:] or ['']
    print('  ', tail[0], flush=True)


def load_objects(path):
    with open(path, encoding='utf-8') as f:
        data = json.load(f)
    return data.get('$source', ''), data.get('objects', [])


def export_index(ref):
    if isinstance(ref, str) and ref.startswith('export:'):
        return int(ref[7:])
    return None


class Strings:
    def __init__(self, r4data):
        self.db = sqlite3.connect(os.path.join(r4data, 'LocalEditorStringDataBaseW3_UTF8.db'))
        self.by_key = {}
        for key, text in self.db.execute('SELECT si.STRING_KEY, s.TEXT FROM STRING_INFO si JOIN STRINGS s ON s.STRING_ID = si.STRING_ID AND s.LANG = ? '
                                         'WHERE si.STRING_KEY IS NOT NULL', (ENGLISH,)):
            if key and key.strip():
                self.by_key[key.strip().lower()] = text

    def id(self, string_id):
        if not string_id:
            return ''
        row = self.db.execute('SELECT TEXT FROM STRINGS WHERE STRING_ID = ? AND LANG = ? ORDER BY VERSION DESC', (abs(int(string_id)), ENGLISH)).fetchone()
        return row[0] if row and row[0] else ''

    def key(self, key):
        return self.by_key.get((key or '').strip().lower(), '')


def dlc_of(source):
    s = source.replace('\\', '/').lower()
    m = re.match(r'dlc/([^/]+)/', s)
    if m:
        return {'ep1': 'hos', 'bob': 'baw'}.get(m.group(1), m.group(1))
    return 'base'


# ------------------------------------------------------------------ quests, facts, blocks

def read_quests(cache, strings):
    quests = []
    for path in glob.glob(os.path.join(cache, '**', '*.journal.json'), recursive=True):
        source, objects = load_objects(path)
        for o in objects:
            if o.get('$class') == 'CJournalQuest' and o.get('baseName'):
                quests.append({
                    'journal': o['baseName'],
                    'title': strings.id(o.get('title')),
                    'type': o.get('type', 'Side'),
                    'world': o.get('world', 0),
                    'guid': o.get('guid', ''),
                    'dlc': dlc_of(source),
                    'file': source.replace('\\', '/'),
                })
    quests.sort(key=lambda q: (q['dlc'], q['journal'].lower()))
    return quests


def read_graphs(cache):
    facts = {}
    files = []
    for path in sorted(glob.glob(os.path.join(cache, '**', '*.w2phase.json'), recursive=True)
                       + glob.glob(os.path.join(cache, '**', '*.w2quest.json'), recursive=True)):
        source, objects = load_objects(path)
        source = source.replace('\\', '/')
        blocks = []
        for o in objects:
            cls = o.get('$class', '')
            # Facts: anything that names one, set by the blocks that change facts, else checked
            for key, value in o.items():
                if isinstance(value, str) and value and 'fact' in key.lower() and key.lower() not in ('factsdb',):
                    entry = facts.setdefault(value, {'set_in': set(), 'checked_in': set()})
                    changes = any(word in cls for word in ('Changing', 'Adder', 'Add', 'Set', 'Modif', 'Remov'))
                    (entry['set_in'] if changes else entry['checked_in']).add(source)
            if 'guid' in o and cls.endswith('Block'):
                outputs = []
                for ref in o.get('sockets', []):
                    i = export_index(ref)
                    if i is not None and i < len(objects):
                        socket = objects[i]
                        if socket.get('direction') == 'LSD_Output':
                            outputs.append((socket.get('name') or '').strip() or 'None')
                block = {'guid': o['guid'].lower(), 'kind': cls}
                if o.get('name'):
                    block['name'] = o['name']
                if o.get('comment'):
                    block['comment'] = o['comment']
                if outputs:
                    block['outputs'] = outputs
                blocks.append(block)
        if blocks:
            files.append({'file': source, 'dlc': dlc_of(source), 'blocks': blocks})
    fact_list = [{'name': name, 'set_in': sorted(v['set_in']), 'checked_in': sorted(v['checked_in'])} for name, v in sorted(facts.items(), key=lambda kv: kv[0].lower())]
    return fact_list, files


# ------------------------------------------------------------------ items

def read_items(r4data, strings):
    items = {}
    paths = glob.glob(os.path.join(r4data, 'gameplay', 'items', '*.xml')) + glob.glob(os.path.join(r4data, 'dlc', '*', 'data', 'gameplay', 'items*', '*.xml'))
    for path in sorted(paths):
        rel = os.path.relpath(path, r4data).replace('\\', '/')
        # Some say they're UTF-16, which ElementTree won't take: the text is read here, its declaration dropped
        raw = open(path, 'rb').read()
        if raw[:2] in (bytes([0xFF, 0xFE]), bytes([0xFE, 0xFF])):
            text = raw.decode('utf-16')
        else:
            text = raw.decode('utf-8-sig', errors='replace')
        text = re.sub(r'^\s*<\?xml[^>]*\?>', '', text)
        try:
            root = ET.fromstring(text)
        except ET.ParseError:
            try:
                root = ET.fromstring(re.sub(r'&(?!\w+;|#\d+;)', '&amp;', text))
            except ET.ParseError as e:
                print('   skipped', rel, e)
                continue
        for item in root.iter('item'):
            name = item.get('name')
            if not name or name in items:
                continue
            key = item.get('localisation_key_name', '')
            items[name] = {
                'name': name,
                'category': item.get('category', ''),
                'title': strings.key(key),
                'icon': item.get('icon_path', ''),
                'dlc': dlc_of(rel),
                'file': rel,
            }
    return sorted(items.values(), key=lambda i: (i['category'], i['name'].lower()))


# ------------------------------------------------------------------ PotP's own

def read_kills(strings):
    text = open(os.path.join(SCRIPTS, 'data', 'definitions', 'KillNames.ws'), encoding='utf-8-sig').read()
    kills = []
    for value in re.findall(r'PushBack\((-?\d+)\)', text):
        n = int(value)
        kills.append({'nameId': abs(n), 'title': strings.id(abs(n)), 'unique': n < 0})
    return kills


def clean_markup(text):
    text = re.sub(r'<[^>]+>', '', text)
    text = re.sub(r'\[[A-Z_]+\]', '', text)
    return text.strip()


def read_potp():
    strings = {}
    with open(os.path.join(TOP, 'source', 'strings', 'en.csv'), encoding='utf-8') as f:
        for line in f:
            parts = line.rstrip('\r\n').split('|', 3)
            if len(parts) == 4 and not line.startswith(';'):
                strings[parts[2]] = parts[3]
    sections, entries = [], []
    section = None
    for path in sorted(glob.glob(os.path.join(SCRIPTS, 'data', 'definitions', '*.ws'))):
        source = os.path.basename(path)
        for line in open(path, encoding='utf-8-sig'):
            m = re.search(r'\.BeginSection\(\s*(\w+)\s*,\s*"([^"]*)"\s*,\s*\w+\s*,\s*"([^"]*)"', line)
            if m:
                book, header, prefix = m.groups()
                section = {'id': prefix, 'book': book.replace('PotP_Book_', '').lower(), 'title': clean_markup(strings.get(header, header)), 'file': source}
                sections.append(section)
                continue
            m = re.search(r'\.Add(Quest|Event|World|Item|Bestiary)\(\s*"(_[^"]*)"', line)
            if m and section:
                uuid = section['id'] + m.group(2)
                entry = {'uuid': uuid, 'kind': m.group(1).lower(), 'section': section['id'], 'title': clean_markup(strings.get('option_' + uuid, ''))}
                if m.group(1) == 'Quest':
                    last = re.findall(r'"([^"]*)"', line)
                    if last:
                        entry['journal'] = last[-1]
                entries.append(entry)
    return {'sections': sections, 'entries': entries}


def read_vanilla_achievements():
    path = os.path.join(TOP, 'overlay', 'data', 'achievements.dat')
    data = open(path, 'rb').read()
    if data[:8] != b'POTPACH1':
        return []
    import struct
    text_size, text_packed = struct.unpack_from('<II', data, 8)
    text = zlib.decompress(data[36:36 + text_packed]).decode('utf-8')
    lines = text.split('\n')
    languages = lines[0].split('\t')
    english = languages.index('english') if 'english' in languages else 0
    out = []
    for line in lines[1:]:
        f = line.split('\t')
        if len(f) < 6:
            continue
        texts = f[4:]
        out.append({'name': f[0], 'store': f[1], 'group': ['base', 'hos', 'baw'][int(f[2])] if f[2].isdigit() and int(f[2]) < 3 else f[2],
                    'hidden': f[3] == '1', 'title': texts[english * 2] if len(texts) > english * 2 else '',
                    'description': texts[english * 2 + 1] if len(texts) > english * 2 + 1 else ''})
    return out


def read_icons():
    inc = open(os.path.join(TOP, 'overlay', 'src', 'achievement_icons.inc'), encoding='utf-8').read()
    return [{'name': n, 'path': p} for n, p in re.findall(r'X\("([^"]+)", "([^"]+)"\)', inc)]


# ------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', required=True)
    ap.add_argument('--cache', default=os.path.join(tempfile.gettempdir(), 'potp_catalog_cache'))
    ap.add_argument('--redkit', default=DEFAULT_REDKIT)
    ap.add_argument('--workbench', default=DEFAULT_WORKBENCH)
    ap.add_argument('--no-decode', action='store_true', help='use what is in the cache already')
    a = ap.parse_args()

    if not a.no_decode:
        decode(a.workbench, os.path.join(a.redkit, 'quests'), r'\.(w2phase|w2quest)$', os.path.join(a.cache, 'quests'))
        decode(a.workbench, os.path.join(a.redkit, 'dlc'), r'\.(w2phase|w2quest)$', os.path.join(a.cache, 'dlc'))
        decode(a.workbench, os.path.join(a.redkit, 'gameplay', 'journal', 'quests'), r'\.journal$', os.path.join(a.cache, 'journal'))
        decode(a.workbench, os.path.join(a.redkit, 'dlc'), r'(^|/)journal/quests/.*\.journal$', os.path.join(a.cache, 'dlc_journal'))

    strings = Strings(a.redkit)
    print('reading', flush=True)
    quests = read_quests(a.cache, strings)
    facts, blocks = read_graphs(a.cache)
    items = read_items(a.redkit, strings)
    kills = read_kills(strings)
    potp = read_potp()
    vanilla = read_vanilla_achievements()
    icons = read_icons()

    os.makedirs(a.out, exist_ok=True)
    lists = {'quests': quests, 'facts': facts, 'quest_blocks': blocks, 'items': items, 'kills': kills, 'potp': potp,
             'achievements': vanilla, 'icons': icons}
    for name, value in lists.items():
        with open(os.path.join(a.out, name + '.json'), 'w', encoding='utf-8', newline='\n') as f:
            # The quest blocks are many: one line, as no one reads that one by eye
            json.dump(value, f, ensure_ascii=False, indent=None if name == 'quest_blocks' else 1, separators=(',', ':') if name == 'quest_blocks' else None)
    meta = {
        'made': datetime.datetime.now().isoformat(timespec='seconds'),
        'from': {'r4data': a.redkit, 'potp': TOP},
        'counts': {'quests': len(quests), 'facts': len(facts), 'quest_files': len(blocks), 'quest_blocks': sum(len(f['blocks']) for f in blocks),
                   'items': len(items), 'gwent_cards': sum(1 for i in items if i['category'] == 'gwint'), 'kills': len(kills),
                   'potp_sections': len(potp['sections']), 'potp_entries': len(potp['entries']), 'achievements': len(vanilla), 'icons': len(icons)},
    }
    with open(os.path.join(a.out, 'meta.json'), 'w', encoding='utf-8', newline='\n') as f:
        json.dump(meta, f, indent=1)
    print(json.dumps(meta['counts'], indent=1))


main()
