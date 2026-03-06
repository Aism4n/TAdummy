// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\bloodheal.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/bloodheal
	name = "Bloodheal"
	desc = "Use the power of your Vitae to slowly regenerate your flesh."
	icon_state = "bloodheal"
	power_type = /datum/coven_power/bloodheal
	max_level = 5
	experience_multiplier = 1.25
	clan_restricted = TRUE

/datum/coven_power/bloodheal
	name = "Bloodheal power name"
	desc = "Bloodheal power description"

	level = 1
	check_flags = COVEN_CHECK_TORPORED
	vitae_cost = 10
	toggled = TRUE
	cooldown_length = 30 SECONDS
	duration_length = 3 SECONDS

	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/coven_power/bloodheal/one,
		/datum/coven_power/bloodheal/two,
		/datum/coven_power/bloodheal/three,
		/datum/coven_power/bloodheal/four,
		/datum/coven_power/bloodheal/five,
	)

/datum/coven_power/bloodheal/activate()
	return
/datum/coven_power/bloodheal/on_refresh()
	return
/datum/coven_power/bloodheal/proc/trigger_healing()
	return
//BLOODHEAL 1
/datum/coven_power/bloodheal/one
	name = "Minor Bloodheal"
	desc = "Slowly regenerate minor wounds using your vitae."

	level = 1
	research_cost = 0
	vitae_cost = 5
	duration_length = 3 SECONDS
	violates_masquerade = FALSE
	research_cost = 0

//BLOODHEAL 2
/datum/coven_power/bloodheal/two
	name = "Bloodheal"
	desc = "Regenerate wounds at a steady pace."

	level = 2
	research_cost = 1
	vitae_cost = 8
	duration_length = 2 SECONDS
	violates_masquerade = FALSE

//BLOODHEAL 3
/datum/coven_power/bloodheal/three
	name = "Quick Bloodheal"
	desc = "Regenerate wounds with visible speed, this violates the masquerade!"

	level = 3
	research_cost = 2
	vitae_cost = 16
	duration_length = 1.5 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 4
/datum/coven_power/bloodheal/four
	name = "Major Bloodheal"
	desc = "Rapidly regenerate even serious injuries. This violates the masquerade!"

	level = 4
	research_cost = 3
	vitae_cost = 20
	duration_length = 1 SECONDS
	violates_masquerade = TRUE

//BLOODHEAL 5
/datum/coven_power/bloodheal/five
	name = "Greater Bloodheal"
	desc = "Regenerate injuries and restore damaged organs. This violates the masquerade!"

	level = 5
	research_cost = 4
	vitae_cost = 30
	duration_length = 0.8 SECONDS
	violates_masquerade = TRUE

/datum/coven_power/bloodheal/five/trigger_healing()
	return
