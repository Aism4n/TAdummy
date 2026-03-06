// Generated modular vampire override scaffold.
// Source: code\modules\jobs\job_types\roguetown\other\vampire_guard.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/job/roguetown/vampire_guard
	title = "Vampire Guard"
	flag = VAMPIRE_GUARD
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = ""

	outfit = /datum/outfit/job/roguetown/vampire_guard
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/job/roguetown/vampire_guard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	return
/datum/outfit/job/roguetown/vampire_guard/pre_equip(mob/living/carbon/human/H)
	return
