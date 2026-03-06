// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\obfuscate.dm
// Loaded after upstream to shadow vampire proc implementations.


/datum/coven/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticable for living and un-living beings."
	icon_state = "obfuscate"
	power_type = /datum/coven_power/obfuscate

/datum/coven_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"
	duration_length = 0.5 MINUTES

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACKBY,
	)

/datum/coven_power/obfuscate/proc/on_combat_signal(datum/source)
	return
/datum/coven_power/obfuscate/proc/is_seen_check()
	return
//CLOAK OF SHADOWS - Basic stealth, broken by movement
/datum/coven_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention. Broken by any movement."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25
	research_cost = 0

	toggled = TRUE

/datum/coven_power/obfuscate/cloak_of_shadows/pre_activation_checks()
	return
/datum/coven_power/obfuscate/cloak_of_shadows/activate()
	return
/datum/coven_power/obfuscate/cloak_of_shadows/deactivate()
	return
/datum/coven_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	return
//UNSEEN PRESENCE - Can move while stealthed, but only walking speed
/datum/coven_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility while walking."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 25

	toggled = TRUE

/datum/coven_power/obfuscate/unseen_presence/activate()
	return
/datum/coven_power/obfuscate/unseen_presence/deactivate()
	return
/datum/coven_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	return
//VANISH FROM THE MIND'S EYE - Instant stealth activation + memory wipe
/datum/coven_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view instantly, and wipe your presence from recent memory."

	level = 3
	research_cost = 2
	vitae_cost = 100
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/activate()
	return
/datum/coven_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	return
/datum/coven_power/obfuscate/vanish_from_the_minds_eye/proc/handle_move(datum/source, atom/moving_thing, dir)
	return
//CLOAK THE GATHERING - Group stealth for multiple people
/datum/coven_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others in a small area. All nearby allies become invisible."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	vitae_cost = 150

	toggled = TRUE

	var/list/cloaked_mobs = list()

/datum/coven_power/obfuscate/cloak_the_gathering/pre_activation_checks()
	return
/datum/coven_power/obfuscate/cloak_the_gathering/activate()
	return
/datum/coven_power/obfuscate/cloak_the_gathering/deactivate()
	return
/datum/coven_power/obfuscate/cloak_the_gathering/proc/handle_move(datum/source, atom/moving_thing, dir)
	return
/datum/coven_power/obfuscate/cloak_the_gathering/proc/on_ally_combat_signal(datum/source)
	return
