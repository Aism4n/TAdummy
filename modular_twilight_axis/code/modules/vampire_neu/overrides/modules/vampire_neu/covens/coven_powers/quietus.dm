// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\quietus.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/quietus
	name = "Quietus"
	desc = "Live in the shadows striking only when needed. Poisons, mass-confusion and fire."
	icon_state = "daimonion"
	power_type = /datum/coven_power/quietus
	clan_restricted = FALSE

/datum/coven_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

//SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	name = "Silence of Death"
	desc = "Create an area of pure silence around you, confusing those within it."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	duration_length = 2 SECONDS
	cooldown_length = 60 SECONDS
	var/datum/proximity_monitor/advanced/silence_field/proximity_field
	var/silence_range = 4
	var/validation_timer

/datum/coven_power/quietus/silence_of_death/activate()
	return
/datum/coven_power/quietus/silence_of_death/deactivate()
	return
/datum/coven_power/quietus/silence_of_death/proc/apply_initial_silence()
	return
/datum/coven_power/quietus/silence_of_death/proc/validate_silence_field()
	return
/datum/coven_power/quietus/silence_of_death/proc/should_affect_target(mob/living/carbon/human/target)
	return
/datum/coven_power/quietus/silence_of_death/proc/apply_silence(mob/living/carbon/human/target)
	return
/datum/coven_power/quietus/silence_of_death/proc/remove_silence(mob/living/carbon/human/target)
	return
// Proximity monitor for the silence field
/datum/proximity_monitor/advanced/silence_field
	var/datum/coven_power/quietus/silence_of_death/parent_power
	var/list/affected_mobs = list()

/datum/proximity_monitor/advanced/silence_field/New(atom/center, range, ignore_if_not_on_turf, datum/coven_power/quietus/silence_of_death/power)
	return
/datum/proximity_monitor/advanced/silence_field/setup_field_turf(turf/target)
	return
/datum/proximity_monitor/advanced/silence_field/field_edge_crossed(atom/movable/movable, turf/location, direction)
	return
/datum/proximity_monitor/advanced/silence_field/field_edge_uncrossed(atom/movable/movable, turf/location, direction)
	return
/datum/proximity_monitor/advanced/silence_field/proc/add_affected_mob(mob/living/carbon/human/target)
	return
/datum/proximity_monitor/advanced/silence_field/proc/remove_affected_mob(mob/living/carbon/human/target)
	return
/datum/proximity_monitor/advanced/silence_field/Destroy()
	return
/datum/coven_power/quietus/scorpions_touch
	name = "Scorpion's Touch"
	desc = "Create a powerful substance to set your enemies on fire."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING | COVEN_CHECK_FREE_HAND
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS
	vitae_cost = 150

/datum/coven_power/quietus/scorpions_touch/activate()
	return
//SCORPION'S TOUCH
/obj/item/melee/touch_attack/quietus
	name = "\improper poison touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = COLOR_RED_LIGHT

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	return
//BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	name = "Baal's Caress"
	desc = "Transmute your vitae into a toxin that destroys all flesh it touches. Must be used on a SHARP weapon."

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	vitae_cost = 150
	target_type = TARGET_OBJ
	range = 3
	violates_masquerade = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	return
/datum/coven_power/quietus/baals_caress/activate(obj/item/rogueweapon/target)
	return
/datum/coven_power/quietus/taste_of_death
	name = "Taste of Death"
	desc = "Spit a glob of caustic blood at your enemies."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	violates_masquerade = TRUE

/datum/coven_power/quietus/taste_of_death/post_gain()
	return
/obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	projectile_type = /obj/projectile/magic/acidsplash/quietus

/obj/projectile/magic/acidsplash/quietus
	damage = 80
	flag = "magic"
	speed = 2

//DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	name = "Dagon's Call"
	desc = "Curse the last person you attacked to drown in their own blood."

	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_CONSCIOUS | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	cooldown_length = 30 SECONDS

/datum/coven_power/quietus/dagons_call/activate()
	return
