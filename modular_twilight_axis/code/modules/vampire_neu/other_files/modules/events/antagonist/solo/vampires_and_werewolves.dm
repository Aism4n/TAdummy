// Generated modular vampire override scaffold.
// Source: code\modules\events\antagonist\solo\vampires_and_werewolves.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/round_event_control/antagonist/solo/vampires_and_werewolves
	name = "Vampires and Verevolves"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT
	denominator = 80

	base_antags = 2
	maximum_antags = 4

	earliest_start = 0 SECONDS

	weight = 1		//Disabled cus vampires too strong.
	max_occurrences = 1

	typepath = /datum/round_event/antagonist/solo/vampires_and_werewolves

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/vampires_and_werewolves
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves/start()
	return
/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_werewolf(datum/mind/antag_mind)
	return
/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_vampire(datum/mind/antag_mind)
	return
