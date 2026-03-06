// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\siren.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/siren
	name = "Siren Blessing"
	desc = "Typically found in vampires who frequent the seas of Enigma, they've developed the ability to adapt much like sirens. Use your voice to INCAPACITATE your foes."
	icon_state = "melpominee"
	power_type = /datum/coven_power/siren

/datum/coven_power/siren
	name = "Siren Blessing power name"
	desc = "Siren Blessing power description"

//THE MISSING VOICE
/datum/coven_power/siren/the_missing_voice
	name = "The Missing Voice"
	desc = "Throw your voice to any place you can see."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_OBJ | TARGET_LIVING
	range = 7

	cooldown_length = 30 SECONDS

/datum/coven_power/siren/the_missing_voice/activate(atom/movable/target)
	return
//PHANTOM SPEAKER
/datum/coven_power/siren/phantom_speaker
	name = "Phantom Speaker"
	desc = "Project your voice to anyone you've met, speaking to them from afar."

	level = 2
	research_cost = 1
	vitae_cost = 50
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_SPEAK

	cooldown_length = 10 SECONDS

/datum/coven_power/siren/phantom_speaker/activate()
	return
//MADRIGAL
/datum/coven_power/siren/madrigal
	name = "Madrigal"
	desc = "Sing a siren song, calling all nearby to you."

	level = 3
	research_cost = 2
	vitae_cost = 200
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	cooldown_length = 1 MINUTES
	duration_length = 2 SECONDS

/datum/coven_power/siren/madrigal/activate()
	return
/datum/coven_power/siren/madrigal/proc/remove_effects(mob/living/carbon/human/target)
	return
//SIREN'S BECKONING
/datum/coven_power/siren/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Sing an unearthly song to stun those around you."

	level = 4
	research_cost = 3
	vitae_cost = 250
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	duration_length = 2 SECONDS
	cooldown_length = 2 MINUTES

/datum/coven_power/siren/sirens_beckoning/activate()
	return
/datum/coven_power/siren/sirens_beckoning/proc/remove_effects(mob/living/carbon/human/target)
	return
//SHATTERING CRESCENDO
/datum/coven_power/siren/shattering_crescendo
	name = "Shattering Crescendo"
	desc = "Scream at an unnatural pitch, shattering the bodies of your enemies."

	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	duration_length = 3 SECONDS
	cooldown_length = 30 SECONDS

/datum/coven_power/siren/shattering_crescendo/activate()
	return
/datum/coven_power/siren/shattering_crescendo/proc/remove_effects(mob/living/carbon/human/target)
	return
