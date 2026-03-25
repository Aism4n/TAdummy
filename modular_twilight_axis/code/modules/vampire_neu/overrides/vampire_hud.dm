/datum/antagonist/vampire/after_gain()
	. = ..()
	var/datum/atom_hud/antag/vamp_hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	var/mob/our_mob = owner.current
	if(!our_mob)
		return
	for(var/mob/M in vamp_hud.hudusers)
		if(M == our_mob)
			continue
		vamp_hud.hide_single_atomhud_from(our_mob, M)
		vamp_hud.hide_single_atomhud_from(M, our_mob)

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	. = ..()
	if(!.)
		return
	if(!istype(examined_datum, /datum/antagonist/vampire))
		return
	var/datum/atom_hud/antag/vamp_hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	vamp_hud.unhide_single_atomhud_from(examiner, examined)
