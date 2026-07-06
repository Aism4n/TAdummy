/*
 * Declarative Crimson Curse role restrictions.
 *
 * Jobs use virtue_restrictions during preference eligibility checks. Vagabond
 * is intentionally handled through advclass virtue_limits below so only the
 * Abandoned Thrall subclass remains compatible.
 */

// Existing Scarlet Reach restrictions retained by the TA port.
/datum/job/roguetown/wretch
	virtue_restrictions = list(
		/datum/virtue/heretic/zchurch_keyholder,
		/datum/virtue/combat/crimson_curse,
	)

/datum/job/roguetown/druid
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/crimson_curse,
	)

/datum/job/roguetown/martyr
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/second_chance,
		/datum/virtue/utility/hollow,
		/datum/virtue/combat/dualwielder,
		/datum/virtue/heretic/zchurch_keyholder,
		/datum/virtue/combat/crimson_curse,
	)

/datum/job/roguetown/monk
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/crimson_curse,
	)

/datum/job/roguetown/priest
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/crimson_curse,
	)

/datum/job/roguetown/templar
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/crimson_curse,
	)

// Rulers and court.
/datum/job/roguetown/lord
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/sultan
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/hand
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/vizier
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/magician
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

// Retinue.
/datum/job/roguetown/marshal
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/knight
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/cataphract
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/knight_enigma
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

// Garrison.
/datum/job/roguetown/sergeant
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/azebagha
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/royal_sergeant
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/janissarysergeant
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/manorguard
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/azeb
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/warden
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/royal_guard
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

// Town watch variants.
/datum/job/roguetown/sheriff
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/town_watch
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/overseer
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/vanguard
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

// Sidefolk and antagonist jobs.
/datum/job/roguetown/lunatic
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/mercenary
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/inquisitor
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/orthodoxist
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/absolver
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/assassin
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/bandit
	virtue_restrictions = list(/datum/virtue/combat/crimson_curse)

/datum/job/roguetown/hag
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/dualwielder,
		/datum/virtue/combat/combat_virtue,
		/datum/virtue/utility/notable,
		/datum/virtue/utility/bronzelimbs,
		/datum/virtue/movement/acrobatic,
		/datum/virtue/utility/woodwalker,
		/datum/virtue/combat/crossbowman,
		/datum/virtue/combat/bowman,
		/datum/virtue/utility/feytouched,
		/datum/virtue/utility/riding,
		/datum/virtue/combat/crimson_curse,
	)

// Vagabond: Crimson Curse is compatible only with Abandoned Thrall.
/datum/advclass/vagabond_original
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_beggar
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_courier
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_excommunicated
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_goatherd
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_mage
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_runner
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_scholar
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_wanted
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_unraveled
	virtue_limits = list(/datum/virtue/combat/crimson_curse)

/datum/advclass/vagabond_accursed
	virtue_limits = list(/datum/virtue/combat/crimson_curse)
