// Makes the mod's BestiaryDefinitions.ws from the game's own journal files, with the Workbench's reader.
//     dotnet run --project tools/gen_bestiary -- "<the game's folder>" "<BestiaryDefinitions.ws>"
// Every CJournalCreature with a category counts. A few files are empty stubs left in the game, with no category or text.
// Run against the game alone, so another mod's creatures don't end up in the list.
using System.IO;
using System.Text;
using System.Threading;
using W3ModWorkbench.Core.Bestiary;
using W3ModWorkbench.Core.Cr2w;
using W3ModWorkbench.Core.Strings;

string game = args[0], output = args[1];
var locator = new ResourceLocator([], null, game, otherMods: false);
var index = BestiaryIndex.Build(locator, Path.Combine(game, "content", "content0", "scripts"), null, CancellationToken.None);

// The game has two Ogrowate categories: one section, under the first's name
var categories = index.Categories.GroupBy(c => c.BaseName, StringComparer.OrdinalIgnoreCase)
    .Select(g => (Name: g.OrderBy(c => c.Order).First(), Guids: g.Select(c => c.Guid).ToHashSet()))
    .OrderBy(g => g.Name.Order).ToList();

// Chosen by hand, by their journal file's name: entries that name no template and that nothing the game spawns counts as,
// and a few whose own isn't the creature as the bestiary shows it
var kChosen = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
{
    ["etheral"] = @"dlc\ep1\data\characters\npc_entities\monsters\ethernal.w2ent",
    ["irisfrompainting"] = @"dlc\ep1\data\characters\npc_entities\monsters\nightwraith_iris.w2ent",
    ["q704alphagarkain"] = @"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_garkain.w2ent",
    ["highervampire"] = @"dlc\bob\data\quests\main_npcs\dettlaff_van_eretein_monster.w2ent",
    ["succubus"] = @"characters\npc_entities\crowd_npc\succubus\succubus.w2ent",
    ["bestiarymonsterhuntmh107"] = @"characters\npc_entities\monsters\czart_mh.w2ent",
    ["bestiarymonsterhuntmh206"] = @"characters\npc_entities\monsters\bies_mh.w2ent",
    ["doppler"] = @"characters\npc_entities\secondary_npc\doppler_guard.w2ent",
    // The journal's is the cloaked woman an alp passes for; the bestiary's about the monster
    ["alp"] = @"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp.w2ent",
    // Grottore is the stubborn knight's spriggan; spriggans as such are the base one, in its other look
    ["mq7002spriggan"] = @"dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",
};

// Creatures whose models don't show as they are in the game, by a piece of their template's path: they keep their painting
string[] kPaintingOnly = [@"\djinn"];

// The game's English names, to tell the entries apart as a player reads them
var strings = GameStringIndex.Load(game, W3Strings.Languages.First(l => l.Handle == "en"), dlcAndMods: false);
string? NameOf(BestiaryEntry e) => strings.WithId(e.Name).FirstOrDefault()?.Text is { Length: > 0 } t ? t : null;

// Every entry that counts, in the order they're listed
var counted = categories.SelectMany(c => index.Entries.Where(e => c.Guids.Contains(e.Category) && e.Descriptions.Count > 0)
    .GroupBy(e => e.Name).Select(g => g.First()).OrderBy(e => e.JournalPath, StringComparer.OrdinalIgnoreCase)).ToList();
// One with no name in the game's strings is a stub nothing shows (the Big Bad Wolf's first). Entries that read the same
// (Hearts of Stone's and Blood and Wine's Arachnomorph, the two wraiths from the painting) are one creature to a player:
// listed once, under the earliest of them (the base game's, then Hearts of Stone's) with a picture, and found when any of them is
var kept = new HashSet<BestiaryEntry>();
var alsoAs = new Dictionary<BestiaryEntry, List<uint>>();
foreach (var same in counted.Where(e => NameOf(e) is not null).GroupBy(e => NameOf(e)!, StringComparer.OrdinalIgnoreCase))
{
    var first = same.OrderBy(e => Code(e)).ThenBy(e => e.Image.Length == 0 ? 1 : 0).ThenBy(e => counted.IndexOf(e)).First();
    kept.Add(first);
    alsoAs[first] = [.. same.Where(e => e != first).Select(e => e.Name)];
}

static string Code(BestiaryEntry e) =>
    e.JournalPath.StartsWith(@"dlc\ep1\", StringComparison.OrdinalIgnoreCase) ? "PotP_E_Primary_DLC1"
    : e.JournalPath.StartsWith(@"dlc\bob\", StringComparison.OrdinalIgnoreCase) ? "PotP_E_Primary_DLC2"
    : "PotP_E_Primary";

var text = new StringBuilder();
text.Append("//---------------------------------------------------\n//-- Bestiary Definitions ---------------------------\n//---------------------------------------------------\n");
text.Append("// Made by overlay/tools/gen_bestiary from the game's journal files. Don't edit by hand.\n\n");
// In pieces, as REDkit's parser runs out of memory on one very long function
var pieces = new List<StringBuilder> { new() };
void NewPieceIfLong()
{
    if (pieces[^1].ToString().Count(c => c == '\n') >= 120) pieces.Add(new StringBuilder());
}
int total = 0;
foreach (var (name, guids) in categories)
{
    var entries = index.Entries.Where(e => guids.Contains(e.Category) && e.Descriptions.Count > 0)
        .GroupBy(e => e.Name).Select(g => g.First()).Where(kept.Contains).ToList();
    if (entries.Count == 0) continue;
    NewPieceIfLong();
    pieces[^1].Append($"\tcatalog.BeginBestiarySection({name.Name});\n");
    foreach (var e in entries.OrderBy(e => e.JournalPath, StringComparer.OrdinalIgnoreCase))
    {
        string suffix = Path.GetFileNameWithoutExtension(e.JournalPath);
        NewPieceIfLong();
        pieces[^1].Append($"\ttracked = catalog.AddBestiary(\"{suffix}\", {Code(e)}, {e.Name}, \"{e.Image}\", \"{string.Join(",", e.Descriptions)}\");\n");
        // Its model, for the Live Bestiary: the npc template the journal names, with / for \, which a script string can't hold safely
        // or, when it names none, a monster the game spawns that counts as it: an npc template first, the lowest level, the shortest path
        string? template = kChosen.TryGetValue(suffix, out var chosen) ? chosen
            : !string.IsNullOrEmpty(e.Template) ? e.Template
            : index.Creatures.Values.Where(c => c.Entry?.Name == e.Name || c.Unique?.Name == e.Name)
                .OrderBy(c => c.Template.Contains(@"\npc_entities\", StringComparison.OrdinalIgnoreCase) ? 0 : 1)
                .ThenBy(c => c.Level).ThenBy(c => c.Template.Length).ThenBy(c => c.Template, StringComparer.OrdinalIgnoreCase)
                .Select(c => c.Template).FirstOrDefault();
        // A djinn is made of effects the overlay doesn't draw: its painting is shown instead
        if (template is not null && kPaintingOnly.Any(p => template.Contains(p, StringComparison.OrdinalIgnoreCase)))
            template = null;
        if (template is not null)
            pieces[^1].Append($"\ttracked.creature_template = \"{template.Replace('\\', '/')}\";\n");
        foreach (uint other in alsoAs[e])
            pieces[^1].Append($"\ttracked.creature_alt_ids.PushBack({other});\n");
        foreach (string item in e.ItemsAgainst)
            pieces[^1].Append($"\ttracked.creature_items.PushBack('{item}');\n");
        ++total;
    }
    pieces[^1].Append("\tcatalog.EndSection();\n\n");
}
text.Append("function PotP_DefineBestiary(catalog: CPotP_Catalog)\n{\n");
for (int i = 0; i < pieces.Count; i++)
    text.Append($"\tPotP_DefineBestiary_{i + 1}(catalog);\n");
text.Append("}\n");
for (int i = 0; i < pieces.Count; i++)
{
    text.Append($"\n// REDkit's parser runs out of memory on one very long function\nfunction PotP_DefineBestiary_{i + 1}(catalog: CPotP_Catalog)\n{{\n\tvar tracked : CPotP_Entry;\n\n");
    text.Append(pieces[i].ToString().TrimEnd('\n'));
    text.Append("\n}\n");
}
File.WriteAllText(output, text.ToString(), new UTF8Encoding(true));
Console.WriteLine($"{total} creatures in {categories.Count} categories; {index.Entries.Count - total} left out");
