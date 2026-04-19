/proc/grant_roundstart_resident_manuscript(mob/living/carbon/human/recipient)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(HAS_TRAIT_FROM(recipient, TRAIT_RESIDENT, TRAIT_VIRTUE))
		return FALSE
	var/job_title = recipient.job || recipient.mind.assigned_role
	if(!HAS_TRAIT(recipient, TRAIT_RESIDENT) && !(job_title in GLOB.burgher_positions) && !(job_title in GLOB.peasant_positions))
		return FALSE
	recipient.mind.special_items["Подорожная грамота"] = /obj/item/book/granter/residentcardvirtue/roundstart
	return TRUE

/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	grant_roundstart_resident_manuscript(H)

/datum/virtue/utility/notable/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(HAS_TRAIT_FROM(recipient, TRAIT_RESIDENT, TRAIT_VIRTUE))
		recipient.mind?.special_items["Подорожная грамота"] = /obj/item/book/granter/residentcardvirtue
