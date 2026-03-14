/mob/living/carbon/human/proc/AdjustMasquerade()
	if(!clan)
		return
	if (!forced)
		if(value > 0)
			if(HAS_TRAIT(src, TRAIT_VIOLATOR))
				return
		if(!CheckZoneCoven(src))
			return
	if(((last_masquerade_violation + MASQUERADE_COOLDOWN) < world.time) || forced)
		last_masquerade_violation = world.time
		if(value < 0)
			if(masquerade > 0)
				masquerade = max(0, masquerade+value)
				to_chat(src, span_boldwarning("MASQUERADE VIOLATION!"))
		if(value > 0)
			if(masquerade < 5)
				masquerade = min(5, masquerade+value)
				to_chat(src, span_boldnotice("MASQUERADE REINFORCED!"))

	if(src in GLOB.coven_breakers_list)
		if(masquerade > 2)
			GLOB.coven_breakers_list -= src
	else if(masquerade < 3)
		GLOB.coven_breakers_list |= src
