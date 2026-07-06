/datum/job/roguetown/orthodoxist/New()
	if(!islist(virtue_restrictions))
		virtue_restrictions = list()
	virtue_restrictions += list(/datum/virtue/combat/crimson_curse)
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/blackpowder_legionnaire,
		/datum/advclass/naledimage
		)
	. = ..()
