// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\potence.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/potence
	name = "Potence"
	desc = "Boosts melee and unarmed damage."
	icon_state = "potence"
	power_type = /datum/coven_power/potence

/datum/coven_power/potence
	name = "Potence power name"
	desc = "Potence power description"

	grouped_powers = list(
		/datum/coven_power/potence/one,
		/datum/coven_power/potence/two,
		/datum/coven_power/potence/three,
		/datum/coven_power/potence/four,
		/datum/coven_power/potence/five
	)

//POTENCE 1
/datum/coven_power/potence/one
	name = "Potence 1"
	desc = "Enhance your muscles. Never hit softly."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/one/activate()
	return
/datum/coven_power/potence/one/deactivate()
	return
//POTENCE 2
/datum/coven_power/potence/two
	name = "Potence 2"
	desc = "Become powerful beyond your muscles. Wreck people and things."

	level = 2
	research_cost = 1
	vitae_cost = 55
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/two/activate()
	return
/datum/coven_power/potence/two/deactivate()
	return
//POTENCE 3
/datum/coven_power/potence/three
	name = "Potence 3"
	desc = "Become a force of destruction. Lift and break the unliftable and the unbreakable."

	level = 3
	research_cost = 2
	vitae_cost = 60
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/three/activate()
	return
/datum/coven_power/potence/three/deactivate()
	return
//POTENCE 4
/datum/coven_power/potence/four
	name = "Potence 4"
	desc = "Become an unyielding machine for as long as your Vitae lasts."

	level = 4
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/four/activate()
	return
/datum/coven_power/potence/four/deactivate()
	return
//POTENCE 5
/datum/coven_power/potence/five
	name = "Potence 5"
	desc = "The people could worship you as a god if you showed them this."

	level = 5
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/five/activate()
	return
/datum/coven_power/potence/five/deactivate()
	return
