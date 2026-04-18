/datum/virtue/utility/notable/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(HAS_TRAIT_FROM(recipient, TRAIT_RESIDENT, TRAIT_VIRTUE))
		recipient.mind?.special_items["Подорожная грамота"] = /obj/item/book/granter/residentcardvirtue
