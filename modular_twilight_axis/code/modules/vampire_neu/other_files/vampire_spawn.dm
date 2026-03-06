// Generated modular vampire override scaffold.
// Source: code\modules\jobs\job_types\roguetown\other\vampire_spawn.dm
// Loaded after upstream to shadow vampire proc implementations.

#define CTAG_VAMPIRE_SPAWN "ctag_vspawn"

/datum/job/roguetown/vampire_spawn
	title = "Vampire Spawn"
	flag = VAMPIRE_SERVANT
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = ""

	advclass_cat_rolls = list(CTAG_VAMPIRE_SPAWN = 20)
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/job/roguetown/vampire_servant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	return
/datum/advclass/vampire_spawn
	name = "Vampire Spawn"
	outfit = /datum/outfit/job/roguetown/vampire_spawn

	category_tags = list(CTAG_VAMPIRE_SPAWN)

	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vampire_spawn/pre_equip(mob/living/carbon/human/H)
	return

#undef CTAG_VAMPIRE_SPAWN
