/mob/living/carbon/human/AdjustMasquerade(value, forced = FALSE)
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

/mob/living/carbon/human/CheckEyewitness(mob/living/source, mob/attacker, range = 0, affects_source = FALSE)
	var/actual_range = max(1, round(range*(attacker.alpha/255)))
	var/list/seenby = list()
	for(var/mob/living/carbon/human/human in oviewers(1, source))
		if(get_turf(src) != turn(human.dir, 180))
			seenby |= human
	for(var/mob/living/carbon/human/human in viewers(actual_range, source))
		if(affects_source)
			if(human == source)
				seenby |= human
		if(!human.pulledby)
			var/turf/LC = get_turf(attacker)
			if(LC.get_lumcount() > 0.25 || get_dist(human, attacker) <= 1)
				if(!attacker.InCone(human))
					if((human == source) && !affects_source)
						continue
					seenby |= human
	if(length(seenby) >= 1)
		return TRUE
	return FALSE
