//---------------------------------------------------
//-- Kill Backfill ----------------------------------
//---------------------------------------------------
// Made by overlay/tools/gen_killnames.py from the game's files. Don't edit by hand.
// For a save PotP joins part way through: each unique foe Geralt can kill, the region its quest is in (0: not
// known), whether it's a contract's target, the facts its death sets, separated by commas, and a fact that says
// someone else killed it, or "".

function PotP_KillBackfill(out ids: array<int>, out regions: array<int>, out contracts: array<bool>, out facts: array<string>, out unless: array<string>)
{
	ids.PushBack(1086577); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_mh203_water_hag_was_killed"); unless.PushBack("");   // Abaya
	ids.PushBack(1083508); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh307_minion_was_killed"); unless.PushBack("");   // Apiarian Phantom
	ids.PushBack(1055647); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_sq102_headhunter_leader_was_killed"); unless.PushBack("");   // Arnout Vester
	ids.PushBack(170717); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_brewess_was_killed"); unless.PushBack("");   // Brewess
	ids.PushBack(335803); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_canaris_was_killed"); unless.PushBack("");   // Caranthir
	ids.PushBack(171226); regions.PushBack(3); contracts.PushBack(false); facts.PushBack("actor_willey_was_killed"); unless.PushBack("");   // Cyprian Wiley
	ids.PushBack(1164728); regions.PushBack(5); contracts.PushBack(false); facts.PushBack("actor_dettlaff_monster_was_killed,actor_dettlaff_vampire_was_killed,actor_dettlaff_was_killed"); unless.PushBack("");   // Dettlaff
	ids.PushBack(1087111); regions.PushBack(1); contracts.PushBack(true); facts.PushBack("actor_mq0003_noonwraith_was_killed"); unless.PushBack("");   // Devil by the Well
	ids.PushBack(171240); regions.PushBack(3); contracts.PushBack(false); facts.PushBack("actor_dijkstra_was_killed"); unless.PushBack("");   // Dijkstra
	ids.PushBack(575683); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh305_doppler_02_was_killed,actor_mh305_doppler_03_was_killed"); unless.PushBack("");   // Doppler
	ids.PushBack(1078453); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_mh208_forktail_was_killed"); unless.PushBack("");   // Dragon
	ids.PushBack(335796); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_eredin_was_killed,actor_sq209_eredin_vision_was_killed"); unless.PushBack("");   // Eredin
	ids.PushBack(1083507); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh304_katakan_was_killed"); unless.PushBack("");   // Gael
	ids.PushBack(1078445); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_mh202_nekker_alpha_was_killed"); unless.PushBack("");   // Hagubman
	ids.PushBack(1055581); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_mq2013_wanted_brother_2_was_killed"); unless.PushBack("");   // Hegel Grossbart
	ids.PushBack(1078461); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh107_czart_was_killed"); unless.PushBack("");   // Howler
	ids.PushBack(1063235); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh108_ancient_fogling_was_killed"); unless.PushBack("");   // Ignis Fatuus
	ids.PushBack(337979); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_imlerith_was_killed"); unless.PushBack("");   // Imlerith
	ids.PushBack(1027350); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh103_nightwraith_was_killed"); unless.PushBack("");   // Jenny o'the Woods
	ids.PushBack(1055582); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_mq2013_wanted_brother_3_was_killed"); unless.PushBack("");   // Jesse Grossbart
	ids.PushBack(1064825); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_mq1036_deserter_was_killed"); unless.PushBack("mq1036_cursing_played");   // John Verdun
	ids.PushBack(1078456); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh302_leszy_was_killed"); unless.PushBack("");   // Kernun
	ids.PushBack(1055156); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_q103_werewolf_was_killed"); unless.PushBack("");   // King of Wolves
	ids.PushBack(1055580); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_mq2013_wanted_brother_1_was_killed"); unless.PushBack("");   // Manfred Grossbart
	ids.PushBack(1078454); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_mh210_lamia_was_killed"); unless.PushBack("");   // Melusine
	ids.PushBack(1158800); regions.PushBack(5); contracts.PushBack(true); facts.PushBack("actor_mh701_sharley_matriarch_was_killed"); unless.PushBack("");   // Monster of Tufo
	ids.PushBack(501932); regions.PushBack(4); contracts.PushBack(false); facts.PushBack("actor_sq201_morkvarg_was_killed,actor_sq201_werewolf_was_killed"); unless.PushBack("");   // Morkvarg
	ids.PushBack(1083194); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_mh206_fiend_was_killed"); unless.PushBack("");   // Morvudd
	ids.PushBack(1078460); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh106_gravehag_was_killed"); unless.PushBack("");   // Mourntart
	ids.PushBack(434966); regions.PushBack(6); contracts.PushBack(false); facts.PushBack("actor_q104_boss_was_killed"); unless.PushBack("");   // Nithral
	ids.PushBack(1058290); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh301_gryphon_was_killed"); unless.PushBack("");   // Opinicus
	ids.PushBack(465466); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_q106_plague_maiden_was_killed,actor_sfx_pesta_was_killed"); unless.PushBack("");   // Pesta
	ids.PushBack(1223143); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mq1060_evil_spirit_was_killed"); unless.PushBack("");   // Red Miasmal
	ids.PushBack(503840); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_mq1033_swordsman_was_killed"); unless.PushBack("");   // Ronvid of the Small Marsh
	ids.PushBack(1085027); regions.PushBack(1); contracts.PushBack(true); facts.PushBack("actor_q002_griffin_was_killed"); unless.PushBack("");   // Royal Griffin
	ids.PushBack(557329); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh105_royal_wyvern_was_killed"); unless.PushBack("");   // Royal Wyvern
	ids.PushBack(1027742); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh303_succubus_was_killed"); unless.PushBack("");   // Salma
	ids.PushBack(1078459); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh104_ekimma_was_killed"); unless.PushBack("");   // Sarasti
	ids.PushBack(503006); regions.PushBack(2); contracts.PushBack(true); facts.PushBack("actor_mh101_cockatrice_was_killed"); unless.PushBack("");   // Shrieker
	ids.PushBack(1078457); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh306_dao_was_killed"); unless.PushBack("");   // Therazane
	ids.PushBack(170719); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_weavess_was_killed"); unless.PushBack("");   // Weavess
	ids.PushBack(170721); regions.PushBack(2); contracts.PushBack(false); facts.PushBack("actor_whispess_was_killed"); unless.PushBack("");   // Whispess
	ids.PushBack(1078458); regions.PushBack(3); contracts.PushBack(true); facts.PushBack("actor_mh308_noonwraith_was_killed"); unless.PushBack("");   // White Lady
	ids.PushBack(1087084); regions.PushBack(4); contracts.PushBack(true); facts.PushBack("actor_monster_lessog_was_killed,actor_sfx_lessog_ancient_was_killed,actor_sq204_leshy_was_killed"); unless.PushBack("");   // Woodland Spirit
}
