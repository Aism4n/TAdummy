// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\auspex.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/coven_power/auspex
	max_level = 4

/datum/coven_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	grouped_powers = list(
		/datum/coven_power/auspex/heightened_senses,
		/datum/coven_power/auspex/ear_for_lies,
		/datum/coven_power/auspex/spirit_touch,
		/datum/coven_power/auspex/psychic_projection,
	)

//HEIGHTENED SENSES
/datum/coven_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 10
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/heightened_senses/activate()
	return
/datum/coven_power/auspex/heightened_senses/deactivate()
	return
//AN EAR FOR LIES
/datum/coven_power/auspex/ear_for_lies
	name = "An Ear For Lies"
	desc = "Hear more than you should."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 13
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/ear_for_lies/activate()
	return
/datum/coven_power/auspex/ear_for_lies/deactivate()
	return
//"THE SPIRITS TOUCH" 
/datum/coven_power/auspex/spirit_touch
	name = "The Spirit's Touch"
	desc = "Be able to track down your pray by the smallest hints possible."

	level = 3
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 15
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/spirit_touch/activate()
	return
/datum/coven_power/auspex/spirit_touch/deactivate()
	return
//PSYCHIC PROJECTION
/datum/coven_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 4
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 250

/datum/coven_power/auspex/psychic_projection/activate()
	return
