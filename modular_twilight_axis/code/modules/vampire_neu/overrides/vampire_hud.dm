/datum/antagonist/vampire/after_gain()
	. = ..()
	var/datum/atom_hud/antag/vamp_hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	var/mob/our_mob = owner.current
	if(!our_mob)
		return
	var/mob/living/carbon/human/our_human = our_mob
	var/datum/clan/our_clan = istype(our_human) ? our_human.clan : null
	for(var/mob/M in vamp_hud.hudusers)
		if(M == our_mob)
			continue
		var/datum/antagonist/vampire/other_vamp = M.mind?.has_antag_datum(/datum/antagonist/vampire)
		var/mob/living/carbon/human/other_human = M
		var/same_clan = our_clan && istype(other_human) && (other_human.clan == our_clan)
		if(same_clan)
			continue
		if(generation > (other_vamp?.generation || 0))
			vamp_hud.hide_single_atomhud_from(M, our_mob)
		else
			vamp_hud.hide_single_atomhud_from(our_mob, M)
			vamp_hud.hide_single_atomhud_from(M, our_mob)

/datum/antagonist/vampire/proc/recalculate_hud_visibility()
	var/datum/atom_hud/antag/vamp_hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	var/mob/our_mob = owner?.current
	if(!our_mob)
		return
	for(var/mob/M in vamp_hud.hudusers)
		if(M == our_mob)
			continue
		var/datum/antagonist/vampire/other_vamp = M.mind?.has_antag_datum(/datum/antagonist/vampire)
		if(!other_vamp)
			continue
		if(generation > other_vamp.generation)
			vamp_hud.unhide_single_atomhud_from(our_mob, M)

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	. = ..()
	if(!.)
		return
	if(!istype(examined_datum, /datum/antagonist/vampire))
		return
	var/datum/atom_hud/antag/vamp_hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	vamp_hud.unhide_single_atomhud_from(examiner, examined)
