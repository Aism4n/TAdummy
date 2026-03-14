/datum/clan/proc/apply_clan_components(mob/living/carbon/human/H)
	if(!H)
		return

	// Remove upstream sunlight component
	var/datum/component/sunlight_vulnerability/old_sun = H.GetComponent(/datum/component/sunlight_vulnerability)
	if(old_sun)
		qdel(old_sun)

	// Remove upstream disguise component
	var/datum/component/vampire_disguise/old_disguise = H.GetComponent(/datum/component/vampire_disguise)
	if(old_disguise)
		qdel(old_disguise)

	// Remove previous TA versions (safety if proc runs twice)
	var/datum/component/TA_sunlight_vulnerability/ta_sun = H.GetComponent(/datum/component/TA_sunlight_vulnerability)
	if(ta_sun)
		qdel(ta_sun)

	var/datum/component/TA_vampire_disguise/ta_disguise = H.GetComponent(/datum/component/TA_vampire_disguise)
	if(ta_disguise)
		qdel(ta_disguise)

	// Add Twilight Axis versions
	H.AddComponent(/datum/component/TA_sunlight_vulnerability)
	H.AddComponent(/datum/component/TA_vampire_disguise)