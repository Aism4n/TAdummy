// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\fae_trickery.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/fae_trickery
	name = "Fae Trickery"
	desc = "This coven typically develops in vampires born near the swamps of Daftmarsh surrounded by the Fae."
	icon_state = "mytherceria"
	power_type = /datum/coven_power/fae_trickery

/datum/coven_power/fae_trickery
	name = "Fae Trickery power name"
	desc = "Fae Trickery power description"

//DARKLING TRICKERY
/datum/coven_power/fae_trickery/darkling_trickery
	name = "Darkling Trickery"
	desc = "Disarm your victims from afar."

	level = 1
	research_cost = 0
	vitae_cost = 150
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND | COVEN_CHECK_LYING
	target_type = TARGET_MOB
	range = 5

	cooldown_length = 1 MINUTES

/datum/coven_power/fae_trickery/darkling_trickery/activate(mob/living/target)
	return
//GOBLINISM
/datum/coven_power/fae_trickery/goblinism
	name = "Goblinism"
	desc = "Summon a mischievous goblin to latch onto your enemies' faces."

	level = 2
	research_cost = 1
	vitae_cost = 100
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 5

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 1 MINUTES

/datum/coven_power/fae_trickery/goblinism/activate(mob/living/target)
	return
/obj/item/clothing/mask/rogue/goblin_mask
	name = "goblin"
	desc = "A green changeling creature."
	icon_state = "goblin"
	max_integrity = 200
	body_parts_covered = FULL_HEAD
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	var/stat = CONSCIOUS
	var/strength = 5
	var/attached = 0
	var/obj/item/clothing/mask/rogue/headgear

/obj/item/clothing/mask/rogue/goblin_mask/Destroy()
	return
/obj/item/clothing/mask/rogue/goblin_mask/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/Die()
	return
/obj/item/clothing/mask/rogue/goblin_mask/attack_hand(mob/user)
	return
/obj/item/clothing/mask/rogue/goblin_mask/examine(mob/user)
	return
/obj/item/clothing/mask/rogue/goblin_mask/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE) //If this returns FALSE then callback will not be called.
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/clear_throw_icon_state()
	return
/obj/item/clothing/mask/rogue/goblin_mask/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/valid_to_attach(mob/living/M)
	return
/obj/item/clothing/mask/rogue/goblin_mask/equipped(mob/M)
	return
/obj/item/clothing/mask/rogue/goblin_mask/dropped(mob/living/carbon/user)
	return
/obj/item/clothing/mask/rogue/goblin_mask/Crossed(atom/target)
	return
/obj/item/clothing/mask/rogue/goblin_mask/attack(mob/living/M, mob/user)
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/Attach(mob/living/M)
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/GoIdle()
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/GoActive()
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/detach()
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/Leap(mob/living/M)
	return
/obj/item/clothing/mask/rogue/goblin_mask/proc/eat_head()
	return
/obj/fae_trickery_trap
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	alpha = 64
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune1"
	color = "#4182ad"
	var/unique = FALSE
	var/mob/owner

/obj/fae_trickery_trap/Crossed(atom/movable/AM, oldloc)
	return
/obj/fae_trickery_trap/disorient
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune2"

/obj/fae_trickery_trap/disorient/Crossed(atom/movable/AM)
	return
/obj/fae_trickery_trap/drop
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune3"

/obj/fae_trickery_trap/drop/Crossed(mob/living/carbon/AM)
	return
//CHANJELIN WARD
/datum/coven_power/fae_trickery/chanjelin_ward
	name = "Chanjelin Ward"
	desc = "Plants a symbol under you. Brutal traps throw victims violently, spin makes them dizzy, drop knocks them on the ground and throws their weapon away."

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE
	vitae_cost = 80

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 30 SECONDS

/datum/coven_power/fae_trickery/chanjelin_ward/activate()
	return
//RIDDLE PHANTASTIQUE
/datum/coven_power/fae_trickery/riddle_phantastique
	name = "Riddle Phantastique"
	desc = "Pose a confounding riddle to your victim, forcing them to answer it before they can do anything else."

	level = 4
	research_cost = 3
	vitae_cost = 250
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING
	range = 7

	cooldown_length = 0

	var/list/datum/riddle/stored_riddles = list()

/datum/coven_power/fae_trickery/riddle_phantastique/activate(mob/living/target)
	return
/datum/riddle
	var/riddle_text
	var/list/riddle_options = list()
	var/riddle_answer

/atom/movable/screen/alert/riddle
	name = "Riddle"
	desc = "You have a riddle to solve!"
	icon_state = "riddle"

	var/datum/riddle/riddle
	var/bad_answers = 0

/atom/movable/screen/alert/riddle/Click()
	return
/datum/riddle/proc/try_answer(mob/living/answerer, atom/movable/screen/alert/riddle/new_alert)
	return
/datum/riddle/proc/ask(mob/living/asking)
	return
/datum/riddle/proc/create_riddle(mob/living/carbon/human/riddler)
	return
/datum/riddle/proc/answer_riddle(mob/living/answerer, the_answer, var/atom/movable/screen/alert/riddle/alert)
	return
//FAE WRATH T5
/datum/coven_power/fae_trickery/fae_wrath
	name = "Fae Wrath"
	desc = "Unleash a barrage of strikes upon thine foes."

	level = 5
	research_cost = 4
	vitae_cost = 250
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	range = 7

	cooldown_length = 40 SECONDS

/datum/coven_power/fae_trickery/fae_wrath/activate()
	return
/datum/coven_power/fae_trickery/fae_wrath/proc/aftervisual(turf/target)
	return
