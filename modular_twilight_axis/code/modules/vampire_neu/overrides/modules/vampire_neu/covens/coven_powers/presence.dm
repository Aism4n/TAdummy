// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\presence.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/presence
	name = "Presence"
	desc = "Invade the mortal mynd, your words are far mightier than any sword. Subjugate them."
	icon_state = "presence"
	power_type = /datum/coven_power/presence

/datum/coven_power/presence
	name = "Presence power name"
	desc = "Presence power description"

//AWE
/datum/coven_power/presence/awe
	name = "Awe"
	desc = "Make those around you admire you. Should they turn the other cheek, they will face consequences."
	gif = "Awe.gif"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	vitae_cost = 100
	range = 4
	multi_activate = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/presence/awe/pre_activation_checks(mob/living/target)
	return
/datum/coven_power/presence/awe/activate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/awe/deactivate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/awe/proc/can_affect_target(mob/living/target)
	return
/datum/status_effect/awestruck
	id = "awestruck"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/awestruck
	var/mob/living/carbon/human/awe_user
	var/mob/living/carbon/human/awe_target

/atom/movable/screen/alert/status_effect/awestruck
	name = "Awestruck"
	desc = "I can hardly take my eyes off them!"
	icon_state = "debuff"

/datum/status_effect/awestruck/on_remove()
	return
/datum/status_effect/awestruck/on_creation(mob/living/new_owner, mob/living/user)
	return
//DREAD GAZE
/datum/coven_power/presence/dread_gaze
	name = "Dread Gaze"
	desc = "Incite fear in others through only your words and gaze."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4
	vitae_cost = 100

	multi_activate = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	return
/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	return
/datum/coven_power/presence/fall
	name = "Kneel"
	desc = "Make those kneel before you."

	level = 3
	research_cost = 2
	vitae_cost = 200
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4

	multi_activate = TRUE
	cooldown_length = 1 MINUTES

/datum/coven_power/presence/fall/activate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/fall/deactivate(mob/living/carbon/human/target)
	return
//SUMMON
/datum/coven_power/presence/summon
	name = "Summon"
	desc = "Keep your friends close, but your enemies closer. Teleport a target to you."

	level = 4
	research_cost = 3
	vitae_cost = 200
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 1 MINUTES

/datum/coven_power/presence/summon/activate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/summon/proc/finish_teleport(mob/living/user, mob/living/target, turf/target_turf)
	return
/datum/coven_power/presence/summon/deactivate(mob/living/carbon/human/target)
	return
/mob/living/carbon/human/proc/step_toward_caster(mob/living/step_to)
	return
//MAJESTY
/datum/coven_power/presence/majesty
	name = "Majesty"
	desc = "Become so grand that others find it nearly impossible to disobey or harm you."

	level = 5
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	vitae_cost = 35
	toggled = TRUE
	cooldown_length = 90 SECONDS
	duration_length = 5 SECONDS
	var/list/affected_mobs = list() // Track who's affected by majesty

/datum/coven_power/presence/majesty/activate()
	return
/datum/coven_power/presence/majesty/on_refresh()
	return
/datum/coven_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	return
/datum/coven_power/presence/majesty/proc/can_affect_target(mob/living/target)
	return
/datum/coven_power/presence/majesty/proc/apply_majesty_effect(mob/living/target)
	return
/datum/coven_power/presence/majesty/proc/remove_majesty_effect(mob/living/target)
	return
/datum/status_effect/majesty_active
	id = "majesty_active"
	duration = -1
	alert_type = null

/datum/status_effect/majesty_active/on_apply()
	return
/datum/status_effect/majesty_active/on_remove()
	return
/datum/status_effect/majesty_active/proc/on_attackby(atom/source, obj/item/attacking_item, mob/living/user, params)
	return
/datum/status_effect/majesty_compulsion
	id = "majesty_compulsion"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/majesty_compulsion
	var/mob/living/majesty_user

/datum/status_effect/majesty_compulsion/on_creation(mob/living/new_owner, mob/living/user)
	return
/datum/status_effect/majesty_compulsion/on_apply()
	return
/datum/status_effect/majesty_compulsion/on_remove()
	return
/datum/status_effect/majesty_compulsion/proc/on_pre_attack(obj/item/source, atom/target, mob/user, params)
	return
/datum/status_effect/majesty_compulsion/proc/on_pre_attack_secondary(obj/item/source, atom/target, mob/user, params)
	return
/datum/status_effect/majesty_compulsion/proc/on_say(mob/source, list/speech_args)
	return
/atom/movable/screen/alert/status_effect/majesty_compulsion
	name = "Overwhelming Presence"
	desc = "You are compelled by an overwhelming presence. You find it nearly impossible to act against them."
	icon_state = "debuff"

/datum/stressevent/majesty_compelled
	desc = "There's someone here with such an overwhelming presence that I can barely think straight around them."
	stressadd = -3
