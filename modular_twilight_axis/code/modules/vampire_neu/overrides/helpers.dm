/datum/clan/apply_clan_components(mob/living/carbon/human/H)
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
	if(!H.GetComponent(/datum/component/TA_sunlight_vulnerability))
		H.AddComponent(/datum/component/TA_sunlight_vulnerability)
	if(!H.GetComponent(/datum/component/TA_vampire_disguise))
		H.AddComponent(/datum/component/TA_vampire_disguise)

/mob/living/carbon/human/disguise_verb()
	set name = "Disguise"
	set category = "VAMPIRE"

	var/datum/component/TA_vampire_disguise/disguise_comp = GetComponent(/datum/component/TA_vampire_disguise)
	if(!disguise_comp)
		to_chat(src, span_warning("I cannot disguise myself."))
		return

	if(disguise_comp.disguised)
		disguise_comp.remove_disguise(src)
	else
		disguise_comp.apply_disguise(src)

/mob/living/carbon/human/vampire_disguise(datum/antagonist/vampire/VD)
	if(clan)
		return

	var/datum/component/TA_vampire_disguise/disguise_comp = GetComponent(/datum/component/TA_vampire_disguise)
	if(!disguise_comp)
		return

	disguise_comp.apply_disguise(src)


/mob/living/carbon/human/vampire_undisguise(datum/antagonist/vampire/VD)
	if(clan)
		return

	var/datum/component/TA_vampire_disguise/disguise_comp = GetComponent(/datum/component/TA_vampire_disguise)
	if(!disguise_comp)
		return

	disguise_comp.remove_disguise(src)

/datum/coven_power/do_masquerade_violation(atom/target)
	if(!violates_masquerade || !ishuman(owner))
		return

	var/atom/center = target ? target : owner

	if(!owner.CheckEyewitness(center, owner, 7, TRUE, 1))
		return

	owner.AdjustMasquerade(-1)
