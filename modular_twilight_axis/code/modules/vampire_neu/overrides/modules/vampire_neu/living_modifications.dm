// Late-include vampire tuning shim.
// Include this below upstream vampire files.
// Intentionally avoids duplicate vars, defines, and type blocks.

/mob/living/twilight_vamp_can_use_drinksomeblood()
	if(world.time <= next_move)
		return FALSE
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return FALSE
	return TRUE

/mob/living/twilight_vamp_should_puke_nonvamp()
	if(HAS_TRAIT(src, TRAIT_HORDE) || HAS_TRAIT(src, TRAIT_NASTY_EATER))
		return FALSE
	return TRUE

/mob/living/twilight_vamp_should_puke_bad_source(mob/living/carbon/victim)
	if(victim.mind?.has_antag_datum(/datum/antagonist/werewolf))
		return TRUE
	if(victim.stat != DEAD && victim.mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	return FALSE

/mob/living/twilight_vamp_can_offer_siring(mob/living/carbon/victim)
	if(victim.stat == DEAD)
		return FALSE
	if(HAS_TRAIT(victim, TRAIT_UNLYCKERABLE))
		return FALSE
	return TRUE

/mob/living/carbon/human/twilight_vamp_has_pending_conversion_prompt()
	return vampire_conversion_prompt_active

/mob/living/twilight_vamp_build_blood_handle(mob/living/carbon/victim, datum/antagonist/vampire/VVictim)
	var/blood_handle

	if(victim.stat == DEAD)
		blood_handle |= BLOOD_PREFERENCE_DEAD
	else
		blood_handle |= BLOOD_PREFERENCE_LIVING

	if(HAS_TRAIT(victim, TRAIT_CLERGY) || HAS_TRAIT(victim, TRAIT_INQUISITION))
		blood_handle |= BLOOD_PREFERENCE_HOLY

	if(VVictim)
		blood_handle |= BLOOD_PREFERENCE_KIN
		blood_handle &= ~BLOOD_PREFERENCE_LIVING

	return blood_handle
