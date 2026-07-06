/*
 * Crimson Curse role restrictions.
 *
 * Restrictions are appended during datum initialization so lists supplied by
 * upstream or another module are preserved.
 */

/datum/job/proc/ta_block_crimson_curse_virtue()
	if(!islist(virtue_restrictions))
		virtue_restrictions = list()
	virtue_restrictions += list(/datum/virtue/combat/crimson_curse)

/datum/advclass/proc/ta_block_crimson_curse_virtue()
	if(!islist(virtue_limits))
		virtue_limits = list()
	virtue_limits += list(/datum/virtue/combat/crimson_curse)

// Existing Scarlet Reach restrictions retained by the TA port.
// Wretch has an existing modular New() and is extended at its definition.

/datum/job/roguetown/druid/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/martyr/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/monk/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/priest/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/templar/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Rulers and court.
/datum/job/roguetown/lord/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/sultan/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/hand/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/vizier/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/magician/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Retinue. Marshal has an existing modular New().
/datum/job/roguetown/knight/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/cataphract/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/knight_enigma/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Garrison. Man at Arms has an existing modular New().
/datum/job/roguetown/sergeant/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/azebagha/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/royal_sergeant/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/janissarysergeant/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/azeb/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/warden/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/royal_guard/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Town watch variants.
/datum/job/roguetown/sheriff/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/town_watch/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/overseer/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/vanguard/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Sidefolk and antagonist jobs. Mercenary has an existing modular New().
/datum/job/roguetown/lunatic/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/absolver/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/assassin/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/bandit/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/job/roguetown/hag/New()
	ta_block_crimson_curse_virtue()
	. = ..()

// Inquisitor and Orthodoxist have existing modular New() overrides.

// Vagabond: Crimson Curse is compatible only with Abandoned Thrall.
/datum/advclass/vagabond_original/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_beggar/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_courier/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_excommunicated/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_goatherd/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_mage/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_runner/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_scholar/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_wanted/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_unraveled/New()
	ta_block_crimson_curse_virtue()
	. = ..()

/datum/advclass/vagabond_accursed/New()
	ta_block_crimson_curse_virtue()
	. = ..()
