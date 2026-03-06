/*
	Twilight Axis vampire module include aggregator.

	Usage:
	- Include this file below upstream vampire includes.
	- Then disable raw mirror files here by hand if they conflict in late-include mode.

	Notes:
	- Order mostly follows upstream roguetown.dme.
	- living_modifications.dm is kept before bloodsuck.dm on purpose for the
	  downstream TA_* policy hooks.
	- THRALLS_* are loaded from vampires_defines.dm and cleared at the bottom
	  via TA_Vampires_uniclude.dm.
*/

// Early define slot and shared cross-module vampire hooks.
#include "./vampires_defines.dm" // Shared TA vampire defines for vampire override files.
//#include "./other_files/vampire_disguise.dm" // Vampire disguise component mirror.
//#include "./other_files/vampires_migrants.dm" // Solo vampire round event.
//#include "./other_files/vampires_and_werewolves.dm" // Cross-antag vampire/werewolf event glue.
//#include "./other_files/vampire_guard.dm" // Vampire guard job.
//#include "./other_files/vampire_servant.dm" // Vampire servant job.
//#include "./other_files/vampire_spawn.dm" // Vampire spawn job.
//#include "./other_files/vampire_spell.dm" // Vampire spell mirror.

// Main vampire_neu block.
#include "./overrides/modules/vampire_neu/living_modifications.dm" // Downstream policy hooks and safe living-side tuning.
#include "./overrides/modules/vampire_neu/bloodsuck.dm" // Downstream drinksomeblood override and blood flow helpers.
//#include "./overrides/modules/vampire_neu/_actions.dm" // Action buttons and disguise verbs.
//#include "./overrides/modules/vampire_neu/coven_action.dm" // Coven action button datum.
//#include "./overrides/modules/vampire_neu/death_knight.dm" // Death knight support.
//#include "./overrides/modules/vampire_neu/frenzy.dm" // Frenzy systems.
#include "./overrides/modules/vampire_neu/vampire.dm" // Late-include TA supplement for upstream vampire.dm.
//#include "./overrides/modules/vampire_neu/vampirelord.dm" // Vampire lord systems.

// Clan framework and concrete clans.
//#include "./overrides/modules/vampire_neu/clan/_base_clan.dm" // Base clan datum.
//#include "./overrides/modules/vampire_neu/clan/clan_heirarchy.dm" // Clan hierarchy tree.
//#include "./overrides/modules/vampire_neu/clan/clan_leader.dm" // Clan leader tools.
//#include "./overrides/modules/vampire_neu/clan/clan_menu.dm" // Clan menu UI.
//#include "./overrides/modules/vampire_neu/clan/heirarchy_interface.dm" // Hierarchy interface UI.
//#include "./overrides/modules/vampire_neu/clan/real_clans/abyss.dm" // Abyss clan.
//#include "./overrides/modules/vampire_neu/clan/real_clans/crimson_accord.dm" // Crimson Accord clan.
//#include "./overrides/modules/vampire_neu/clan/real_clans/eoran.dm" // Eoran clan.
//#include "./overrides/modules/vampire_neu/clan/real_clans/nosferatu.dm" // Nosferatu clan.
//#include "./overrides/modules/vampire_neu/clan/real_clans/thronleer.dm" // Thronleer clan.

// Coven framework and discipline trees.
//#include "./overrides/modules/vampire_neu/covens/_base_coven.dm" // Base coven datum.
//#include "./overrides/modules/vampire_neu/covens/coven_unlock_menu.dm" // Coven unlock UI.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/_base_power.dm" // Base coven power datum.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/auspex.dm" // Auspex powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/bloodheal.dm" // Bloodheal powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/celerity.dm" // Celerity powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/demonic.dm" // Demonic powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/eoran.dm" // Eoran powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/fae_trickery.dm" // Fae Trickery powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/obfuscate.dm" // Obfuscate powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/potence.dm" // Potence powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/presence.dm" // Presence powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/quietus.dm" // Quietus powers.
//#include "./overrides/modules/vampire_neu/covens/coven_powers/siren.dm" // Siren powers.

// Objects and spell-side helpers.
//#include "./overrides/modules/vampire_neu/objects/bloodpool.dm" // Bloodpool structures and projects.
//#include "./overrides/modules/vampire_neu/objects/ichor_fang_stone.dm" // Ichor Fang Stone object.
//#include "./overrides/modules/vampire_neu/objects/portal.dm" // Vampire portal object.
//#include "./overrides/modules/vampire_neu/objects/scrying.dm" // Scrying object and telepathy helpers.
//#include "./overrides/modules/vampire_neu/objects/throne.dm" // Vampire throne object.
//#include "./overrides/modules/vampire_neu/spells/transfix_neu.dm" // Transfix spell support.

#include "./TA_Vampires_uniclude.dm" // Soft cleanup for TA vampire defines.
