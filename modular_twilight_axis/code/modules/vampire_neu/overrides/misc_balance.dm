/*
 * Smaller balance and quality-of-life changes from Azure-Peak/Azure-Peak#7383.
 * Isolated from the discipline rewrites so this block can be reverted alone.
 */

// FAE TRICKERY TRAPS
/obj/structure/ta_fae_trickery_trap
	name = "fae trap"
	desc = "A nearly invisible fae ward. It looks fragile enough to break."
	anchored = TRUE
	density = FALSE
	max_integrity = 20
	alpha = 25
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune1"
	color = "#4182ad"
	var/unique = FALSE
	var/mob/trap_owner

/obj/structure/ta_fae_trickery_trap/Crossed(atom/movable/crossing, oldloc)
	..()
	if(!isliving(crossing) || !trap_owner || crossing == trap_owner || unique)
		return

	var/mob/living/victim = crossing
	var/atom/throw_target
	if(!oldloc)
		throw_target = get_edge_target_turf(victim, pick(GLOB.cardinals))
	else
		throw_target = get_edge_target_turf(victim, get_dir(victim, oldloc))

	victim.apply_damage(45, BRUTE)
	victim.OffBalance(2 SECONDS)
	victim.throw_at(throw_target, rand(8, 10), 4, trap_owner, spin = TRUE)
	qdel(src)

/obj/structure/ta_fae_trickery_trap/disorient
	unique = TRUE
	icon_state = "rune2"

/obj/structure/ta_fae_trickery_trap/disorient/Crossed(atom/movable/crossing)
	..()
	if(!isliving(crossing) || !trap_owner || crossing == trap_owner)
		return

	var/mob/living/victim = crossing
	var/rotation = 50
	for(var/screen_type in victim.hud_used?.plane_masters)
		var/atom/movable/screen/plane_master/whole_screen = victim.hud_used?.plane_masters[screen_type]
		animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING)

	addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, ta_clear_fae_disorientation)), 15 SECONDS)
	qdel(src)

/mob/living/proc/ta_clear_fae_disorientation()
	for(var/screen_type in hud_used?.plane_masters)
		var/atom/movable/screen/plane_master/whole_screen = hud_used?.plane_masters[screen_type]
		animate(whole_screen, transform = matrix(), time = 0.5 SECONDS, easing = QUAD_EASING)

/obj/structure/ta_fae_trickery_trap/drop
	unique = TRUE
	icon_state = "rune3"

/obj/structure/ta_fae_trickery_trap/drop/Crossed(mob/living/carbon/crossing)
	..()
	if(!iscarbon(crossing) || !trap_owner || crossing == trap_owner)
		return

	crossing.adjustBruteLoss(35)
	crossing.Knockdown(5)
	crossing.visible_message(span_suicide("[crossing] is disarmed!"), span_boldwarning("I'm disarmed!"))
	playsound(get_turf(crossing), 'sound/magic/mockery.ogg', 40, FALSE)
	var/target_turf = get_ranged_target_turf(get_turf(crossing), pick(GLOB.cardinals), rand(2, 5))
	crossing.throw_item(target_turf, FALSE)
	qdel(src)

/datum/coven_power/fae_trickery/chanjelin_ward/activate()
	. = ..()
	var/selected_trap = input(owner, "Select a Trap:", "Trap") as null|anything in list("Brutal", "Spin", "Drop")
	if(!selected_trap)
		return

	var/obj/structure/ta_fae_trickery_trap/trap
	switch(selected_trap)
		if("Brutal")
			trap = new /obj/structure/ta_fae_trickery_trap(get_turf(owner))
		if("Spin")
			trap = new /obj/structure/ta_fae_trickery_trap/disorient(get_turf(owner))
		if("Drop")
			trap = new /obj/structure/ta_fae_trickery_trap/drop(get_turf(owner))
	trap?.trap_owner = owner

// PRESENCE
/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>FEAR ME</b></span>")
	owner.say("FEAR ME!!")
	var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	target.freak_out()
	to_chat(target, "<span class='userlove'><b>OH GOD, PLEASE SAVE ME!</b></span>")
	playsound(target, 'sound/villain/wonder.ogg', 40)

/datum/coven_power/presence/majesty
	vitae_cost = 125

/datum/coven_power/presence/majesty/apply_majesty_effect(mob/living/target)
	if(!can_affect_target(target))
		return

	affected_mobs |= target
	target.apply_status_effect(/datum/status_effect/majesty_compulsion, owner)

	if(prob(70))
		if(target.get_active_held_item())
			target.visible_message("<span class='warning'>[target] seems overwhelmed by [owner]'s presence!</span>")
			target.dropItemToGround(target.get_active_held_item())

		target.stop_pulling()
		if(target.cmode)
			target.toggle_cmode()

// SIREN
/datum/coven_power/siren/shattering_crescendo
	vitae_cost = 250
	cooldown_length = 60 SECONDS
