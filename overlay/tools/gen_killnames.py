"""Makes the kill counter's list of names from the game's own files.

Every NPC template's display name is a string id. The list lets a kill be stored by id, so a count
survives a change of language, and marks the names that belong on the Unique page.

  python gen_killnames.py <folder of templates as JSON> <folder of the game's strings as CSV> [<folder of communities as JSON>] [--review]

The JSON comes from W3 Mod Workbench --to-json over the REDkit copy's characters, dlc, living_world,
quests and gameplay folders; the CSVs from --strings-to-csv over each en.w3strings.
"""
import glob
import json
import os
import re
import sys
from collections import defaultdict

TOP = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(TOP, 'progress on the path ng', 'workspace', 'scripts', 'local', 'data', 'definitions', 'KillNames.ws')
PER_FUNCTION = 200   # REDkit's parser runs out of memory on one very long function

# Templates that only ever appear in these places are one character
ONE_CHARACTER = re.compile(r'main_npc|secondary_npc|(^|/)quests?/|_quest_|boss')

# Names that say what someone is rather than who
ROLE = re.compile(r"\b(guard|guards|guardsman|soldier|warrior|shieldmaiden|elder|peasant|townsman|townswoman|woman|man|boy|girl|child|"
    r"merchant|worker|servant|sailor|seaman|fisherman|hunter|henchman|henchdwarf|bandit|thug|pirate|deserter|looter|renegade|"
    r"mercenary|prisoner|refugee|survivor|victim|patient|medic|smith|blacksmith|armorer|innkeep|barmaid|bard|cook|butcher|baker|"
    r"barber|courtesan|prostitute|strumpet|nobleman|noblewoman|aristocrat|courtier|officer|captain|sergeant|messenger|herald|"
    r"herold|scribe|student|scholar|pupil|teacher|clerk|mage|sorceress|druid|priest|skald|dancer|juggler|actor|actress|comedian|"
    r"comedienne|spectator|bystander|crowd|mob|customer|guest|traveler|pilgrim|beggar|drunk|drunkard|farmer|shepherd|lumberjack|"
    r"gravedigger|herbalist|stablemaster|squire|landlord|landlady|bouncer|bodyguard|doorman|butler|dealer|croupier|bookie|"
    r"player|voice|horse|racehorse|dog|cat|cow|pig|sheep|goat|deer|doe|rat|chicken|hen|rooster|goose|bear|wolf|boar|"
    r"cub|book|trap|chest|time|tower|fire|dummy|nilfgaardian|redanian|skelliger|elf|dwarf|halfling|foreigner|"
    r"scoia'tael|slave|driver|cultist|cannibal|vagrant|smuggler|thief|sick|old|poor|rich|wealthy|ponce|helper|"
    r"supervisor|caretaker|stagehand|swordsmith|woodcarver|boatwright|master|treasurer|executioner|jockey|contestant|"
    r"ghost|necrophage|bruiser|dodger|hussar|headhunter|pillager|mysterious|shady|concerned|outraged|enthusiast|fightmaster|"
    r"individual|stranger|majordomo|mermaid|pixie|centipede|sandcrab|wight|archespore|botchling|alpha|kikimore|donkey|raven|fleder|troll|wolpertinger|crowd|nibbles|allgod|dodger|elder|general|minister|chancellor|coach|apprentice|wife|mother|sister|friend|follower|paramour|portier|porter|addict|regular|tamer|houndmaster|warden|penitent|plague|preacher|settler|ealdorman)\b", re.I)

# Foes the rules above would miss, because a generic template shares the name or there's only a generic template
ALWAYS = {'Caranthir', 'Eredin', 'Imlerith', 'Dettlaff', 'Weavess', 'Brewess', 'Whispess', 'Johnny', "Jenny o'the Woods",
    'Shrieker', 'Monster of Tufo', 'Olgierd von Everec', 'Morkvarg', 'Letho', 'Ancient Leshen', 'Royal Griffin', 'Royal Wyvern',
    'Opinicus', 'Melusine', 'King of Wolves', 'Devil by the Well', 'Woodland Spirit', 'Djinn', 'Dragon', 'Therazane',
    'Ignis Fatuus', 'Red Miasmal', 'Apiarian Phantom', 'Little Red', 'Syanna', "Gaunter O'Dimm", 'Pesta', 'Hym', 'Iris'}
# Names that pass the rules but aren't people or monsters anyone fights
NEVER = {'Book', 'Trap', 'Treasure Chest', 'Time', 'Tower', 'Target Dummy', 'Actor', 'Player', 'Geralt', 'Roach', 'Poppy', 'Black Beauty', "Lil' Bleater", 'Speedy Osvald', 'Racehorse'}
# Names that pass the rules but say what someone is rather than who: Monsters and Men, not Unique
GENERIC = {'Adventurer', 'Duke', 'Earl', 'Endrega', 'Pearl Diver', 'Princess', 'Succubus', 'Ticket Seller', 'Troubadour',
    'Vildkaarl', 'Village Witch', 'Widow', 'Witcher', 'Young One'}

# For a save PotP joins part way through: the unique foes the player (Geralt, or Ciri in her parts) can kill. Their deaths are in the save as
# actor_<spawn tag>_was_killed facts, which the game sets for any tagged NPC that dies, whoever killed it. So this lists
# only foes nobody but the player kills, checked against the wiki and the quests. Left out on purpose:
#   Roche and Ves (Dijkstra's men kill them), Letho (his death is staged), Albin Hart (ghouls), Djenge Frett (the Grossbarts), Orianna (let go; her duel is a trailer), Iris
#   (released), Napp (Nilfgaardians, in a cutscene), Hal, Sofus the Bull and Boris (fistfights),
#   Hans of Cidaris (the contract's employer), the La Valette Champion (a horse race).
KILLABLE = {
    # Monsters and bosses
    'Abaya', 'Apiarian Phantom', 'Brewess', 'Caranthir', 'Dettlaff', 'Devil by the Well', 'Doppler', 'Dragon', 'Eredin', 'Gael',
    'Hagubman', 'Howler', 'Ignis Fatuus', 'Imlerith', "Jenny o'the Woods", 'Kernun', 'King of Wolves', 'Melusine', 'Monster of Tufo',
    'Morkvarg', 'Morvudd', 'Mourntart', 'Nithral', 'Opinicus', 'Pesta', 'Red Miasmal', 'Royal Griffin', 'Royal Wyvern',
    'Salma', 'Sarasti', 'Shrieker', 'Therazane', 'Weavess', 'Whispess', 'White Lady', 'Woodland Spirit',
    # People the player fights and kills
    'Arnout Vester', 'Cyprian Wiley', 'Dijkstra', 'Hegel Grossbart', 'Jesse Grossbart', 'John Verdun', 'Manfred Grossbart',
    'Ronvid of the Small Marsh',
}
# Tags whose death doesn't say the player killed that foe: the Crones' fog forms only hunt Ciri in her flashback in Ladies of the Wood
NOT_THE_PLAYER = {'q105_fog_brewess', 'q105_fog_weavess', 'q105_fog_whispess'}
# A foe someone else can also kill, and the fact that says it went that way: then the death isn't the player's
UNLESS = {
    # At the Mercy of Strangers: left on the river bank, he curses Geralt and the drowners get him; Geralt can only kill him later
    'John Verdun': 'mq1036_cursing_played',
}

# Where a community's quest is, by its folder, as PotP numbers regions (PotP_R_WO and on); 0 when the folder doesn't say
# Where the main story's foes die, which their quests' folders don't say
REGION_WHERE = {'Brewess': 2, 'Whispess': 2, 'Weavess': 2, 'Imlerith': 2, 'King of Wolves': 2, 'Pesta': 2,
    'Royal Griffin': 1, 'Cyprian Wiley': 3, 'Dijkstra': 3, 'Caranthir': 4, 'Eredin': 4, 'Nithral': 6}
REGION_FOLDERS = [('prologue_village', 1), ('no_mans_land', 2), ('novigrad', 3), ('skellige', 4), ('dlc/bob/', 5),
    ('kaer_morhen', 6), ('vizima', 7), ('wyzima', 7)]


def read_names(folder):
    names = {}
    for path in glob.glob(os.path.join(folder, '**', '*.csv'), recursive=True):
        with open(path, encoding='utf-8', errors='replace') as f:
            for line in f:
                p = line.rstrip('\n').split('|')
                if len(p) >= 4 and p[0].isdigit():
                    names[int(p[0])] = p[-1]
    return names


def read_templates(folder):
    by_id = defaultdict(set)
    for root, _, files in os.walk(folder):
        for name in files:
            if not name.endswith('.json'):
                continue
            path = os.path.join(root, name)
            with open(path, encoding='utf-8', errors='replace') as f:
                text = f.read()
            if 'CNewNPC' not in text and 'W3MonsterHuntNPC' not in text:
                continue
            m = re.search(r'"displayName": (\d+)', text)
            if m and int(m.group(1)):
                by_id[int(m.group(1))].add(os.path.relpath(path, folder).replace(os.sep, '/'))
    return by_id


def main():
    by_id = read_templates(sys.argv[1])
    names = read_names(sys.argv[2])
    rows = []
    templates_of = defaultdict(set)
    for string_id, paths in by_id.items():
        if string_id in names:
            templates_of[names[string_id]] |= paths
    for string_id in sorted(by_id):
        name = names.get(string_id)
        if not name or name in NEVER:
            continue
        paths = templates_of[name]
        unique = name not in GENERIC and (name in ALWAYS or (all(ONE_CHARACTER.search(p) for p in paths) and not ROLE.search(name)))
        rows.append((string_id, unique, name))

    if '--review' in sys.argv:
        print('UNIQUE', sum(1 for r in rows if r[1]))
        print('; '.join(sorted(set(r[2] for r in rows if r[1]))))
        print('GENERIC', sum(1 for r in rows if not r[1]))
        print('; '.join(sorted(set(r[2] for r in rows if not r[1]))))

    out = ['//---------------------------------------------------',
           '//-- Kill Names -------------------------------------',
           '//---------------------------------------------------',
           "// Made by overlay/tools/gen_killnames.py from the game's files. Don't edit by hand.",
           "// Each display name's string id; negative: it belongs on the Unique page.",
           '']
    parts = [rows[i:i + PER_FUNCTION] for i in range(0, len(rows), PER_FUNCTION)]
    out.append('function PotP_KillNameIds(out ids: array<int>)')
    out.append('{')
    for i in range(len(parts)):
        out.append('\tPotP_KillNameIds_%d(ids);' % (i + 1))
    out.append('}')
    out.append('')
    for i, part in enumerate(parts):
        out.append('function PotP_KillNameIds_%d(out ids: array<int>)' % (i + 1))
        out.append('{')
        for string_id, unique, name in part:
            out.append('\tids.PushBack(%d);' % (-string_id if unique else string_id))
        out.append('}')
        out.append('')
    with open(OUT, 'w', encoding='utf-8', newline='\r\n') as f:
        f.write('\n'.join(out))

    if len(sys.argv) > 3 and not sys.argv[3].startswith('--'):
        write_backfill(sys.argv[1], sys.argv[3], by_id, names, rows)


def write_backfill(templates_folder, comms_folder, by_id, names, rows):
    """KillBackfill.ws: for each foe in KILLABLE, the facts its death sets, from the communities that spawn it with tags."""
    template_name = {}
    for string_id, paths in by_id.items():
        for p in paths:
            template_name[p[:-5].lower() if p.endswith('.json') else p.lower()] = names.get(string_id)

    spawns = defaultdict(list)          # template -> [(tags, community path)]
    tag_names = defaultdict(set)        # tag -> the names of everything spawned with it

    def walk(node, rel):
        if isinstance(node, dict):
            if 'entityTemplate' in node and 'entitySpawnTags' in node:
                template = node['entityTemplate'].split(':', 1)[-1].replace('\\', '/').lower()
                tags = node['entitySpawnTags'] or []
                spawns[template].append((tags, rel))
                for t in tags:
                    tag_names[t].add(template_name.get(template))
            for v in node.values():
                walk(v, rel)
        elif isinstance(node, list):
            for v in node:
                walk(v, rel)

    for root, _, files in os.walk(comms_folder):
        for file in files:
            if file.endswith('.json'):
                path = os.path.join(root, file)
                try:
                    with open(path, encoding='utf-8') as f:
                        walk(json.load(f), os.path.relpath(path, comms_folder).replace(os.sep, '/'))
                except ValueError:
                    pass

    first_id = {}
    for string_id, unique, name in rows:
        if unique:
            first_id.setdefault(name, string_id)   # the scripts take a name's first id, as this list has them

    entries = []
    for name in sorted(KILLABLE):
        if name not in first_id:
            print('backfill: %s is not on the Unique page' % name)
            continue
        facts, places = set(), []
        contract = False
        for template, name_of in template_name.items():
            if name_of != name:
                continue
            for tags, rel in spawns.get(template, []):
                # A tag only this foe is spawned with (nameless stand-ins, such as an invisible double, aside): its death and no one else's
                own = [t for t in tags if tag_names[t] - {None} == {name} and t not in NOT_THE_PLAYER]
                facts |= {'actor_%s_was_killed' % t for t in own}
                if own:
                    places.append(next((region for folder, region in REGION_FOLDERS if folder in rel), 0))
            # A contract's target as the live count has it: the template is a monster hunt NPC or tagged as its target
            with open(os.path.join(templates_folder, template + '.json'), encoding='utf-8', errors='replace') as f:
                text = f.read()
            contract |= 'MonsterHuntTarget' in text or 'W3MonsterHuntNPC' in text
        if not facts:
            print('backfill: no tag of its own for %s' % name)
            continue
        region = places[0] if places and all(p == places[0] for p in places) else 0
        region = REGION_WHERE.get(name, region)
        entries.append((first_id[name], region, contract, sorted(facts), name))

    out = ['//---------------------------------------------------',
           '//-- Kill Backfill ----------------------------------',
           '//---------------------------------------------------',
           "// Made by overlay/tools/gen_killnames.py from the game's files. Don't edit by hand.",
           '// For a save PotP joins part way through: each unique foe Geralt can kill, the region its quest is in (0: not',
           "// known), whether it's a contract's target, the facts its death sets, separated by commas, and a fact that says",
           "// someone else killed it, or \"\".",
           '',
           'function PotP_KillBackfill(out ids: array<int>, out regions: array<int>, out contracts: array<bool>, out facts: array<string>, out unless: array<string>)',
           '{']
    for string_id, region, contract, facts, name in entries:
        out.append('\tids.PushBack(%d); regions.PushBack(%d); contracts.PushBack(%s); facts.PushBack("%s"); unless.PushBack("%s");   // %s'
                   % (string_id, region, 'true' if contract else 'false', ','.join(facts), UNLESS.get(name, ''), name))
    out.append('}')
    out.append('')
    path = os.path.join(os.path.dirname(OUT), 'KillBackfill.ws')
    with open(path, 'w', encoding='utf-8', newline='\r\n') as f:
        f.write('\n'.join(out))
    print('backfill: %d foes' % len(entries))


if __name__ == '__main__':
    main()
