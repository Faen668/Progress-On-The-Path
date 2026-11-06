"""Makes the kill counter's list of names from the game's own files.

Every NPC template's display name is a string id. The list lets a kill be stored by id, so a count
survives a change of language, and marks the names that belong on the Unique page.

  python gen_killnames.py <folder of templates as JSON> <folder of the game's strings as CSV> [--review]

The JSON comes from W3 Mod Workbench --to-json over the REDkit copy's characters, dlc, living_world,
quests and gameplay folders; the CSVs from --strings-to-csv over each en.w3strings.
"""
import glob
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
        unique = name in ALWAYS or (all(ONE_CHARACTER.search(p) for p in paths) and not ROLE.search(name))
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


if __name__ == '__main__':
    main()
