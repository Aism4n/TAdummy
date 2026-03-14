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

/mob/living/carbon/human/CheckEyewitness(atom/source, mob/living/attacker, range = 7, affects_source = FALSE, required = 1)
	var/actual_range = max(1, round(range * (attacker.alpha / 255.0)))
	var/witness_count = 0

	for(var/mob/living/carbon/human/H in viewers(actual_range, source))
		if(H == source && !affects_source)
			continue

		if(H.stat != CONSCIOUS)
			continue

		var/turf/T = get_turf(attacker)
		if(!T) continue

		if(T.get_lumcount() > 0.25 || get_dist(H, attacker) <= 1)
			if(H.InCone(attacker))
				witness_count++
				if(witness_count >= required)
					return TRUE

	return FALSE