// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\eoran.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/eora
	name = "Eoran Embrace"
	desc = "Blessed by the Goddess of Love, Family, and Art, these vampires have developed powers that strengthen bonds, inspire beauty, and heal emotional wounds."
	icon_state = "eora"
	power_type = /datum/coven_power/eora
	max_level = 4

/datum/coven_power/eora
	name = "Eora power name"
	desc = "Eora power description"

//EMPATHIC BOND
/datum/coven_power/eora/empathic_bond
	name = "Empathic Bond"
	desc = "Touch someone to sense their emotional state and immediate needs, making you obsessed with them for a short time."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 1

	cooldown_length = 10 SECONDS

/datum/coven_power/eora/empathic_bond/activate(mob/living/target)
	return
//ARTISTIC INSPIRATION
/datum/coven_power/eora/artistic_inspiration
	name = "Artistic Inspiration"
	desc = "Inspire others with divine creativity, enhancing their artistic abilities and mood."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 3

	cooldown_length = 30 SECONDS
	duration_length = 5 MINUTES

/datum/coven_power/eora/artistic_inspiration/activate(mob/living/target)
	return
/datum/coven_power/eora/artistic_inspiration/deactivate(mob/living/carbon/human/target)
	return
//FAMILIAL BOND
/datum/coven_power/eora/familial_bond
	name = "Familial Bond"
	desc = "Create a temporary spiritual connection between two people, allowing them to sense each other's location and well-being."

	level = 3
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 5

	cooldown_length = 60 SECONDS
	duration_length = 10 MINUTES

/datum/coven_power/eora/familial_bond/activate(mob/living/target)
	return
//BEAUTY'S RESTORATION
/datum/coven_power/eora/beautys_restoration
	name = "Beauty's Restoration"
	desc = "Channel Eora's power to restore physical beauty and heal disfigurements."

	level = 4
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN | TARGET_SELF
	range = 1

	cooldown_length = 90 SECONDS

/datum/coven_power/eora/beautys_restoration/activate(mob/living/target)
	return
/datum/coven_power/eora/beautys_restoration/deactivate(mob/living/carbon/human/target)
	return
/datum/stressevent/artistic_inspiration
	desc = span_love("I feel divinely inspired to create something beautiful!")
	stressadd = -3
	timer = 5 MINUTES
	quality_modifier = 3

/datum/stressevent/artistic_inspiration_minor
	desc = span_love("I feel... Inspired!")
	stressadd = -1
	timer = 2 MINUTES
	quality_modifier = 1

