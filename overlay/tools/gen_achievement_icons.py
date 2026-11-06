"""Makes PotP's own achievement icons: overlay/src/achievement_icons.inc.

Every icon here was drawn for Progress on the Path, as path data in a 24 by 24 box, to be stroked rather than filled,
so the overlay can draw them at any size and in any colour (a locked one in red, an unlocked one in its ring's
colour). The path data is SVG's, which WPF also reads, so the Achievement Creation Tool can show the same icons.
They're ours, so they're free for anyone to use with the mod's own licence.

Run it after changing an icon. With --preview <file.html> it also writes a page showing them all.
"""
import math
import os
import sys

TOP = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
INC = os.path.join(TOP, 'overlay', 'src', 'achievement_icons.inc')


def n(v):
    """A number as short as it can be written"""
    text = ('%.2f' % v).rstrip('0').rstrip('.')
    return '0' if text in ('-0', '') else text


def circle(cx, cy, r):
    return 'M%s %sa%s %s 0 1 0 %s 0a%s %s 0 1 0 %s 0' % (n(cx - r), n(cy), n(r), n(r), n(2 * r), n(r), n(r), n(-2 * r))


def star(cx, cy, outer, inner, points=5, turn=-90):
    parts = []
    for i in range(points * 2):
        r = outer if i % 2 == 0 else inner
        a = math.radians(turn + i * 180 / points)
        parts.append('%s %s' % (n(cx + r * math.cos(a)), n(cy + r * math.sin(a))))
    return 'M' + 'L'.join(parts) + 'z'


ICONS = [
    # name, path
    ('trophy', 'M8 21h8M12 16v5M6.5 3.5h11v5.5a5.5 5.5 0 0 1-11 0zM6.5 5.5H4.5c0 3 1 4.5 3 5M17.5 5.5h2c0 3-1 4.5-3 5'),
    ('medal', 'M8 2.5l4 7 4-7M6.5 2.5h3M14.5 2.5h3' + circle(12, 15.5, 5.5) + star(12, 15.8, 3, 1.3)),
    ('crown', 'M4 18L3 7.5l5 4 4-7.5 4 7.5 5-4L20 18zM4 21h16' + circle(12, 14, 1.2)),
    ('star', star(12, 12.6, 9.5, 4)),
    ('sword', 'M12 2l2 3v10.5h-4V5zM12 6.5v7M6.5 15.5h11M12 15.5V20' + circle(12, 21.3, 1.3)),
    ('swords', 'M4 3.5l11 11M20 3.5l-11 11M13 17l4.5-4.5M6.5 12.5L11 17M16 16l3.5 3.5M8 16l-3.5 3.5'),
    ('gem', 'M6.5 4h11l4 5.5L12 21 2.5 9.5zM2.5 9.5h19M9.5 4L8 9.5 12 21l4-11.5L14.5 4'),
    ('bow', 'M6 2.5c9 3.5 9 15.5 0 19M6 2.5v19M3 12h16M16 9l3 3-3 3M3 10l2 2-2 2'),
    ('shield', 'M12 2.5l8 3v6c0 5-3.5 8.7-8 10-4.5-1.3-8-5-8-10v-6zM12 6.5v11M7.5 11h9'),
    ('skull', 'M5.5 11a6.5 6.5 0 0 1 13 0v3l-2 1v3.5h-9V15l-2-1z' + circle(9.3, 11.5, 1.5) + circle(14.7, 11.5, 1.5)
     + 'M12 13.8l-.9 1.7h1.8zM10 18.5v-2M12 18.5v-2M14 18.5v-2'),
    ('wolf', 'M5 3.5l3.5 5h7l3.5-5 1 9.5L12 21 4 13zM8.5 12.5l2 1.2M15.5 12.5l-2 1.2M10.8 17.5h2.4'),
    ('cat', 'M5 4l3.5 4.5h7L19 4v9a7 7 0 0 1-14 0zM9 12.5h.01M15 12.5h.01M10.5 16.5l1.5 1 1.5-1M3 15.5l4 .5M21 15.5l-4 .5'),
    ('paw', circle(12, 15.5, 4) + circle(6.3, 10, 1.8) + circle(9.6, 6.2, 1.8) + circle(14.4, 6.2, 1.8) + circle(17.7, 10, 1.8)),
    ('eye', 'M2.5 12c3-5 6-7 9.5-7s6.5 2 9.5 7c-3 5-6 7-9.5 7s-6.5-2-9.5-7z' + circle(12, 12, 3.2) + circle(12, 12, .6)),
    ('heart', 'M12 20.5S3.5 15.5 3.5 9A4.6 4.6 0 0 1 12 6.3 4.6 4.6 0 0 1 20.5 9c0 6.5-8.5 11.5-8.5 11.5z'),
    ('drop', 'M12 2.5c3.5 5 6.5 8.5 6.5 12a6.5 6.5 0 0 1-13 0c0-3.5 3-7 6.5-12zM9 15a3 3 0 0 0 3 3'),
    ('flame', 'M12 2.5c1 4 6.5 6 6.5 11.5a6.5 6.5 0 0 1-13 0c0-3 2-5.2 3.5-6.5 0 2.2 1 3.7 2.5 4.3-1-3.8-.4-6.8.5-9.3z'),
    ('potion', 'M10 2.5h4M10.5 2.5v5.7a6.8 6.8 0 1 0 3 0V2.5M5.6 15h12.8' + circle(14.5, 17.5, .8)),
    ('bottle', 'M10 2.5h4v3.5l2 3V21H8V9l2-3zM8 13h8M8 17h8'),
    ('wine', 'M7 2.5h10c0 5.5-2 8.5-5 8.5s-5-3-5-8.5zM7.4 6h9.2M12 11v8.5M8 21h8'),
    ('grapes', 'M12 6.5V3.5l2.5-1' + circle(8, 9, 2.1) + circle(12, 9, 2.1) + circle(16, 9, 2.1) + circle(10, 13, 2.1)
     + circle(14, 13, 2.1) + circle(12, 17, 2.1)),
    ('mushroom', 'M3 12.5a9 7.5 0 0 1 18 0zM9.5 12.5l-.6 8h6.2l-.6-8' + circle(8.5, 9, 1) + circle(14, 7.5, 1.2)),
    ('leaf', 'M5 19.5C5 10.5 10 4 20 4c0 10-6 15.5-15 15.5zM5 19.5l9.5-9.5M10 14h4M12 12V8'),
    ('tree', 'M12 21.5v-8M12 15l-3-2.5M12 17l3-2.5' + circle(12, 8.5, 6) + 'M8.5 21.5h7'),
    ('mountain', 'M2 20.5l7-12.5 4 6 2.5-3.5 6.5 10zM7.3 11h3.4M9 8l1.5 3'),
    ('moon', 'M15 3a9 9 0 1 0 6 13.8A7.2 7.2 0 0 1 15 3z' + circle(7.5, 6.5, .7) + circle(5, 10, .5)),
    ('map', 'M3 6l6-2 6 2 6-2v14l-6 2-6-2-6 2zM9 4v14M15 6v14M16.8 9.2l2.4 2.4M19.2 9.2l-2.4 2.4'),
    ('compass', circle(12, 12, 9.2) + 'M12 5.5l2.5 6.5-2.5 6.5-2.5-6.5zM12 2.8v1.7M12 19.5v1.7M2.8 12h1.7M19.5 12h1.7'),
    ('signpost', 'M12 2.5v19M12 4.5h7.5l2 2-2 2H12M12 10.5H4.5l-2 2 2 2H12M8.5 21.5h7'),
    ('castle', 'M4 21V8h3v2.5h2V8h2v2.5h2V8h2v2.5h2V8h3v13zM10 21v-4.5a2 2 0 0 1 4 0V21M7 14h2M15 14h2'),
    ('house', 'M3 11.5l9-8 9 8M5 9.8V21h14V9.8M10 21v-6h4v6'),
    ('ship', 'M3 15h18l-3.5 5.5h-11zM12 2.5V15M12 4l6.5 9H12M12 6l-5 7h5M12 2.5l2.5 1-2.5 1'),
    ('anchor', circle(12, 4.3, 1.8) + 'M12 6.1V21M8 9.5h8M4 13.5a8 8 0 0 0 16 0M2.5 15.5L4 13l2.5 1.5M21.5 15.5L20 13l-2.5 1.5'),
    ('key', circle(7, 12, 4) + 'M11 12h10.5M17.5 12v3.5M20.5 12v2.5'),
    ('chest', 'M3 10h18v10.5H3zM3 10a9 4.5 0 0 1 18 0M3 13.5h18M10.8 12.3h2.4v3h-2.4z'),
    ('coin', circle(12, 12, 9) + circle(12, 12, 6.2) + star(12, 12.3, 3.3, 1.4)),
    ('book', 'M12 6.3c-2-1.6-5-2.1-8.5-1.6v14.8c3.5-.5 6.5 0 8.5 1.6 2-1.6 5-2.1 8.5-1.6V4.7c-3.5-.5-6.5 0-8.5 1.6zM12 6.3v14.8'),
    ('quill', 'M20.5 3C11.5 4 6.5 10 5 19.5M20.5 3c-1 6.5-5 11-11.5 13M5 19.5L3 21.5M9.5 10.5h5M8 14.5h4'),
    ('scroll', 'M7 4h11.5a2 2 0 0 1 0 4H17v10a2 2 0 0 1-2 2H5.5a2 2 0 0 1 0-4H7zM7 16h8M10 8h4.5M10 11.5h4.5'),
    ('music', 'M9 18.5V5.5l10.5-2.5v13' + circle(6.8, 18.5, 2.2) + circle(17.3, 16, 2.2) + 'M9 9l10.5-2.5'),
    ('bell', 'M6 16.5V11a6 6 0 0 1 12 0v5.5l2 2.5H4zM10 21.5h4M12 3V5'),
    ('candle', 'M9 10.5h6V21H9zM12 10.5V8.5M12 2.5c1.3 1.6 1.6 2.8 0 4.3-1.6-1.5-1.3-2.7 0-4.3zM7 21h10'),
    ('campfire', 'M4 21l16-4M4 17l16 4M12 3c1 3 4.5 4.5 4.5 8.5a4.5 4.5 0 0 1-9 0c0-2 1.3-3.5 2.3-4.3.2 1.4.8 2.3 1.8 2.6-.6-2.5-.2-4.7.4-6.8z'),
    ('hourglass', 'M6 2.5h12M6 21.5h12M7.5 2.5V5c0 3 4.5 4.5 4.5 7s-4.5 4-4.5 7v2.5M16.5 2.5V5c0 3-4.5 4.5-4.5 7s4.5 4 4.5 7v2.5M9.5 19.5h5'),
    ('helmet', 'M4.5 14a7.5 7.5 0 0 1 15 0v6.5h-4.5V15h-6v5.5H4.5zM12 6.5V15M4.5 12.5h4.5M15 12.5h4.5'),
    ('dice', 'M4 4h16v16H4z' + circle(8, 8, 1) + circle(16, 8, 1) + circle(12, 12, 1) + circle(8, 16, 1) + circle(16, 16, 1)),
    ('target', circle(12, 12, 9.2) + circle(12, 12, 5.6) + circle(12, 12, 2) + 'M12 2.8v3.5M12 17.7v3.5M2.8 12h3.5M17.7 12h3.5'),
]


def main():
    names = [name for name, _ in ICONS]
    if len(set(names)) != len(names):
        sys.exit('an icon name is used twice')
    inc = '// Made by overlay/tools/gen_achievement_icons.py. Change it there.\n'
    inc += '// PotP\'s own achievement icons: SVG path data in a 24 by 24 box, drawn as lines.\n'
    for name, path in ICONS:
        inc += 'X("%s", "%s")\n' % (name, path)
    with open(INC, 'w', encoding='utf-8', newline='\n') as f:
        f.write(inc)
    print('wrote', os.path.relpath(INC, TOP), len(ICONS), 'icons')

    if len(sys.argv) == 3 and sys.argv[1] == '--preview':
        cells = ''
        for name, path in ICONS:
            cells += ('<figure><div class="locked"><svg viewBox="0 0 24 24"><path d="%s"/></svg></div>'
                      '<div><svg viewBox="0 0 24 24"><path d="%s"/></svg></div><figcaption>%s</figcaption></figure>\n') % (path, path, name)
        page = ('<!doctype html><meta charset="utf-8"><title>PotP achievement icons</title><style>'
                'body{background:#14110c;color:#d8cdb4;font:14px Georgia,serif;margin:16px}'
                'main{display:grid;grid-template-columns:repeat(8,1fr);gap:14px}'
                'figure{margin:0;text-align:center}figure>div{display:inline-flex;width:64px;height:64px;margin:2px;'
                'align-items:center;justify-content:center;background:#0e0c09;border:1.5px solid #ab8952}'
                'figure>div.locked{background:radial-gradient(circle,#46162a 0%,#16080d 75%);border-color:#463a26}'
                'svg{width:40px;height:40px;fill:none;stroke:#ab8952;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round}'
                '.locked svg{stroke:#80424a}'
                '</style><main>' + cells + '</main>')
        with open(sys.argv[2], 'w', encoding='utf-8') as f:
            f.write(page)
        print('wrote', sys.argv[2])


main()
