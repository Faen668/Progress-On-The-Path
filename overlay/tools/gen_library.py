"""Makes .../scripts/local/data/definitions/LibraryDefinitions.ws: the books and notes the Library tab lists.

    python -I overlay/tools/gen_library.py "<REDkit's r4data folder>" "<the game's English strings as a CSV>"

The CSV is content/content0/en.w3strings as W3 Mod Workbench writes it (--strings-to-csv): it says which readable
items have a text, what the game calls them, and so which shelf a loose sheet belongs on.

Reads the game's item definitions (gameplay/items/*.xml, the base game's and each DLC's). Every readable item has the
ReadableItem tag, but no tag marks a real book, or tells a letter from a journal. The shelves (SECTIONS), in order:
  0 Lore Books             named lore_... or item_book_lore_..., and the few with names of their own (LORE_NAMED)
  1 Monster Tomes          the books merchants sell that teach the bestiary: tagged PerkBook, or named bestiary_..._book
  2 Journals and Diaries   any other readable with a text whose icon is a book, a diary, a journal or a log
  3 Letters                whose icon is a letter
  4 Notices and Contracts  tagged NoticeBoardNote
  5 Notes and Documents    every other readable with a text: scrolls, treasure maps, bills, orders
Left out: recipes, diagrams and formulae (by their category), paintings, and readables with no text.

Shelves 2 to 5 are notes: listed and marked read as books are, but not counted in the mod's progress (AddNote).

Those rules (shelf()) are written into the script as PotP_LibraryShelf, which puts what mods add on their shelves as
the catalog is built (CPotP_Catalog.AddModBooks). It also knows the tags Witcher Lore Collection gives its books
(bookLore, bookBestiary; glossaryNoDesc for its glossary entries, which aren't books), and any mod that uses them.

Here alone, a sheet the rules leave on the last shelf is moved to an earlier one by what the game calls it in English
(TITLE_WORDS: a "Letter from..." with a scroll for an icon), or to the notices if it's defined among them. Only ever
from the last shelf to an earlier one: by the time the script looks for mods' sheets for the last shelf, the earlier
ones are listed, so it never lists one twice.
"""
import os
import re
import sys
import xml.etree.ElementTree as ET

TOP = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(TOP, 'progress on the path ng', 'workspace', 'scripts', 'local', 'data', 'definitions', 'LibraryDefinitions.ws')

# Lore books whose names don't say so
LORE_NAMED = [
    'Necronomicon', 'Book of Arachases', 'Glossary Temerian Dynasty', 'Journey into the mind', 'Orders from Shilard',
    'Jacob of Varazze Chronicles', 'Poems of Gonzal de Verceo', 'Norther Kingdoms arms and tactics',
    'Skelige arms and tactics', 'Gear improvement',
]
# Each shelf's header, an overlay string
SECTIONS = ['potp_ov_library_lore', 'potp_ov_library_tomes', 'potp_ov_library_journals', 'potp_ov_library_letters',
            'potp_ov_library_notices', 'potp_ov_library_notes']
FIRST_NOTES = 2   # the shelves from here on are notes
LAST = len(SECTIONS) - 1
RECIPES = ('crafting_schematic', 'alchemy_recipe', 'cooking_recipe')
JOURNAL_ICONS = ('book', 'diary', 'journal', '_log')
# A sheet on the last shelf, by a word of its English name: the shelf it's moved to
TITLE_WORDS = [
    (3, ('letter', 'letters', 'missive', 'invitation', 'message')),
    (2, ('journal', 'diary', 'log', 'memoirs', 'chronicle', 'ledger')),
    (4, ('notice', 'contract', 'flyer', 'leaflet')),
]
CHUNK = 40   # REDkit's parser runs out of memory on one very long function


def shelf(item):
    """The shelf by the rules the script has too, or -1 for what the Library leaves out. Keep PotP_LibraryShelf the same."""
    name, tags = item['name'], item['tags']
    if 'glossaryNoDesc' in tags:
        return -1
    if 'bookBestiary' in tags:
        return 1
    if 'bookLore' in tags or name.lower().startswith(('lore_', 'item_book_lore_')) or name in LORE_NAMED:
        return 0
    if 'PerkBook' in tags or (name.startswith('bestiary_') and name.endswith('_book')):
        return 1
    if item['category'] in RECIPES or 'Painting' in tags or len(item['text']) < 2:
        return -1
    if 'NoticeBoardNote' in tags:
        return 4
    if any(word in item['icon'] for word in JOURNAL_ICONS):
        return 2
    if 'letter' in item['icon']:
        return 3
    return LAST


def placed(item):
    """The shelf it's listed on: shelf(), and a sheet on the last one moved by where it's defined or what it's called"""
    number = shelf(item)
    if number != LAST:
        return number
    if 'notices' in item['file']:
        return 4
    words = re.findall(r"[a-z]+", item['title'].lower())
    for to, any_of in TITLE_WORDS:
        if any(word in words for word in any_of):
            return to
    return LAST


SHELF_WS = r'''
// A readable item's shelf: 0 Lore Books, 1 Monster Tomes, 2 Journals and Diaries, 3 Letters, 4 Notices and Contracts,
// 5 Notes and Documents, -1 not for the Library (a diagram, a formula, a painting, a readable with no text).
// The rules gen_library.py lists the game's own by, for what mods add (CPotP_Catalog.AddModBooks). bookLore,
// bookBestiary and glossaryNoDesc are the tags Witcher Lore Collection gives its books and its glossary entries.
// From 2 on they're notes, by the item's icon, as no tag tells a journal from a letter.
function PotP_LibraryShelf(defs: CDefinitionsManagerAccessor, item: name) : int
{
	var text		: string = NameToString(item);
	var category	: name;
	var icon		: string;

	if (defs.ItemHasTag(item, 'glossaryNoDesc'))
	{
		return -1;
	}
	if (defs.ItemHasTag(item, 'bookBestiary'))
	{
		return 1;
	}
	if (defs.ItemHasTag(item, 'bookLore') || StrBeginsWith(StrLower(text), "lore_") || StrBeginsWith(StrLower(text), "item_book_lore_"))
	{
		return 0;
	}
	switch (item)
	{
%s
		return 0;
	}
	if (defs.ItemHasTag(item, 'PerkBook') || (StrBeginsWith(text, "bestiary_") && StrRight(text, 5) == "_book"))
	{
		return 1;
	}

	category = defs.GetItemCategory(item);
	if (category == 'crafting_schematic' || category == 'alchemy_recipe' || category == 'cooking_recipe' || defs.ItemHasTag(item, 'Painting'))
	{
		return -1;
	}
	if (StrLen(GetLocStringByKeyExt(defs.GetItemLocalisationKeyName(item) + "_text")) < 2)
	{
		return -1;
	}
	if (defs.ItemHasTag(item, 'NoticeBoardNote'))
	{
		return 4;
	}
	icon = StrLower(defs.GetItemIconPath(item));
	if (StrFindFirst(icon, "book") >= 0 || StrFindFirst(icon, "diary") >= 0 || StrFindFirst(icon, "journal") >= 0 || StrFindFirst(icon, "_log") >= 0)
	{
		return 2;
	}
	if (StrFindFirst(icon, "letter") >= 0)
	{
		return 3;
	}
	return 5;
}
'''


def key_hash(key):
    """A string's key as a .w3strings file keeps it"""
    h = 0
    for c in key.lower():
        h = (h * 31 + ord(c)) & 0xFFFFFFFF
    return h


def strings(csv):
    found = {}
    with open(csv, encoding='utf-8') as f:
        for line in f:
            p = line.rstrip('\r\n').split('|', 3)
            if len(p) == 4 and not line.startswith(';') and p[1]:
                found[int(p[1], 16)] = p[3]
    return found


def items(r4data, text):
    """Every readable item, by name: its tags, category, icon, the file it's defined in, which part of the game that is
    (0 base, 1 Hearts of Stone, 2 Blood and Wine), and from the game's strings its name and its text"""
    found = {}
    for folder, _, files in os.walk(r4data):
        if not folder.replace('\\', '/').endswith('gameplay/items'):
            continue
        rel = os.path.relpath(folder, r4data).replace('\\', '/')
        dlc = 1 if rel.startswith('dlc/ep1/') else 2 if rel.startswith('dlc/bob/') else 0
        for file in sorted(files):
            if not file.endswith('.xml'):
                continue
            # Read as text: some say they're UTF-16 in their heading, which they aren't
            with open(os.path.join(folder, file), encoding='utf-8', errors='replace') as f:
                source = f.read()
            try:
                root = ET.fromstring(re.sub(r'^﻿?<\?xml[^>]*\?>', '', source))
            except ET.ParseError:
                continue   # a few loot tables CDPR left malformed; no item definitions in them
            for item in root.iter('item'):
                tags = set()
                for t in item.iter('tags'):
                    tags.update(x.strip() for x in (t.text or '').split(',') if x.strip())
                name = item.get('name')
                if 'ReadableItem' in tags and name and name not in found:
                    key = item.get('localisation_key_name', '')
                    found[name] = dict(name=name, tags=tags, dlc=dlc, file=file, category=item.get('category', ''),
                                       icon=item.get('icon_path', '').replace('\\', '/').lower(),
                                       title=text.get(key_hash(key), ''), text=text.get(key_hash(key + '_text'), ''))
    return found


def suffix(name):
    return re.sub(r'[^a-z0-9]+', '_', name.lower()).strip('_')


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    found = items(sys.argv[1], strings(sys.argv[2]))
    kinds = ['PotP_E_Primary', 'PotP_E_Primary_DLC1', 'PotP_E_Primary_DLC2']

    for item in found.values():
        item['shelf'] = placed(item)
        # The script would list it on the last shelf as a mod's, before or after its own: see the top of the file
        if item['shelf'] != shelf(item) and shelf(item) != LAST:
            sys.exit('%s is moved from a shelf that is not the last' % item['name'])
    listed = [item for item in found.values() if item['shelf'] >= 0]
    if len({suffix(item['name']) for item in listed}) != len(listed):
        sys.exit('two items would share an id')

    calls = []   # (header or None, line)
    for number, header in enumerate(SECTIONS):
        # Notes in the order of their English names, as the catalog sorts each shelf: sorted already, it has little to do
        on_shelf = sorted((item for item in listed if item['shelf'] == number),
                          key=lambda item: item['name'] if number < FIRST_NOTES else (item['title'], item['name']))
        add = 'AddBook' if number < FIRST_NOTES else 'AddNote'
        calls.append((header, None))
        for item in on_shelf:
            calls.append((None, '\tcatalog.%s("%s", %s, \'%s\');' % (add, suffix(item['name']), kinds[item['dlc']], item['name'])))
        calls.append((None, '\tcatalog.AddModBooks(%d);' % number))
        calls.append((None, '\tcatalog.EndSection();'))
        print('%s: %d' % (header, len(on_shelf)))

    # Split into functions of CHUNK lines; a section can run on from one into the next, as the catalog keeps it open
    bodies, body = [], []
    for header, line in calls:
        body.append('\tcatalog.BeginLibrarySection("%s");' % header if header else line)
        if len(body) >= CHUNK:
            bodies.append(body)
            body = []
    if body:
        bodies.append(body)

    out = ['﻿//---------------------------------------------------',
           '//-- Library Definitions ----------------------------',
           '//---------------------------------------------------',
           '// Made by overlay/tools/gen_library.py from the game\'s item definitions. Don\'t edit by hand.',
           '// A book or a note is read when the game says so: its BookReadState_ fact (CInventoryComponent.IsBookReadByName).',
           '// Each shelf ends with what mods add to it (CPotP_Catalog.AddModBooks). Notes (AddNote) aren\'t counted in progress.',
           '',
           'function PotP_DefineLibrary(catalog: CPotP_Catalog)',
           '{']
    out += ['\tPotP_DefineLibrary_%d(catalog);' % (i + 1) for i in range(len(bodies))]
    out.append('}')
    for i, b in enumerate(bodies):
        out += ['', '// REDkit\'s parser runs out of memory on one very long function' if i == 0 else '',
                'function PotP_DefineLibrary_%d(catalog: CPotP_Catalog)' % (i + 1), '{']
        out += b
        out.append('}')
    cases = '\n'.join("\tcase '%s':" % n for n in LORE_NAMED)
    out += (SHELF_WS % cases).rstrip('\n').split('\n')
    text = '\r\n'.join(out) + '\r\n'
    text = re.sub(r'(\r\n){3,}', '\r\n\r\n', text)
    with open(OUT, 'w', encoding='utf-8', newline='') as f:
        f.write(text)
    print('wrote', os.path.relpath(OUT, TOP))


if __name__ == '__main__':
    main()
