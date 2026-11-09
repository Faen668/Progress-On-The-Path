"""Makes .../scripts/local/data/definitions/LibraryDefinitions.ws: the books the Library tab lists.

    python -I overlay/tools/gen_library.py "<REDkit's r4data folder>"

Reads the game's item definitions (gameplay/items/*.xml, the base game's and each DLC's). Every readable item has the
ReadableItem tag, but most are notes, letters, diagrams and formulae, and no tag marks a real book. A book's shelf (shelf()):
  Lore Books      named lore_... or item_book_lore_..., and the few lore books with names of their own (LORE_NAMED)
  Monster Tomes   the books sold by merchants that teach the bestiary: tagged PerkBook, or named bestiary_..._book
Anything else is left out, quest notes and letters among them, even where the game files them as books.

The same rules are written into the script as PotP_LibraryShelf, which puts the books mods add on their shelves as the
catalog is built (CPotP_Catalog.AddModBooks). That also knows the tags Witcher Lore Collection gives its books
(bookLore, bookBestiary; glossaryNoDesc for its glossary entries, which aren't books), and any mod that uses them.
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
SECTIONS = ['potp_ov_library_lore', 'potp_ov_library_tomes']   # each shelf's header, an overlay string
CHUNK = 40   # REDkit's parser runs out of memory on one very long function


def shelf(name, tags):
    """0 Lore Books, 1 Monster Tomes, -1 not a book. Keep PotP_LibraryShelf below the same."""
    if 'glossaryNoDesc' in tags:
        return -1
    if 'bookBestiary' in tags:
        return 1
    if 'bookLore' in tags or name.lower().startswith(('lore_', 'item_book_lore_')) or name in LORE_NAMED:
        return 0
    if 'PerkBook' in tags or (name.startswith('bestiary_') and name.endswith('_book')):
        return 1
    return -1


SHELF_WS = r'''
// A readable item's shelf: 0 Lore Books, 1 Monster Tomes, -1 not a book (a note, a letter, a diagram, a formula).
// The rules gen_library.py lists the game's books by, for the books mods add (CPotP_Catalog.AddModBooks). bookLore,
// bookBestiary and glossaryNoDesc are the tags Witcher Lore Collection gives its books and its glossary entries.
function PotP_LibraryShelf(defs: CDefinitionsManagerAccessor, item: name) : int
{
	var text : string = NameToString(item);

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
	return -1;
}
'''


def items(r4data):
    """name -> (tags, which part of the game: 0 base, 1 Hearts of Stone, 2 Blood and Wine), for every readable item"""
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
                text = f.read()
            try:
                root = ET.fromstring(re.sub(r'^﻿?<\?xml[^>]*\?>', '', text))
            except ET.ParseError:
                continue   # a few loot tables CDPR left malformed; no item definitions in them
            for item in root.iter('item'):
                tags = set()
                for t in item.iter('tags'):
                    tags.update(x.strip() for x in (t.text or '').split(',') if x.strip())
                if 'ReadableItem' in tags and item.get('name'):
                    found.setdefault(item.get('name'), (tags, dlc))
    return found


def suffix(name):
    return re.sub(r'[^a-z0-9]+', '_', name.lower()).strip('_')


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    found = items(sys.argv[1])
    kinds = ['PotP_E_Primary', 'PotP_E_Primary_DLC1', 'PotP_E_Primary_DLC2']

    calls = []   # (header or None, line)
    for number, header in enumerate(SECTIONS):
        books = sorted(n for n, (tags, _) in found.items() if shelf(n, tags) == number)
        calls.append((header, None))
        for n in books:
            calls.append((None, '\tcatalog.AddBook("%s", %s, \'%s\');' % (suffix(n), kinds[found[n][1]], n)))
        calls.append((None, '\tcatalog.AddModBooks(%d);' % number))
        calls.append((None, '\tcatalog.EndSection();'))
        print('%s: %d' % (header, len(books)))

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
           '// A book is read when the game says so: its BookReadState_ fact (CInventoryComponent.IsBookReadByName).',
           '// Each shelf ends with the books mods add to it (CPotP_Catalog.AddModBooks).',
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
