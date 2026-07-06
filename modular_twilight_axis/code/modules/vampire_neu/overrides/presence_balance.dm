/*
 * Presence intelligence scaling adapted from Scarlet-Reach/Scarlet-Reach#1616.
 *
 * Keeps the current upstream effects, but scales whether they fully land by
 * the intelligence gap instead of rejecting strong targets outright.
 */

/datum/coven_power/presence/proc/ta_intelligence_difference(mob/living/carbon/human/target)
	return owner.STAINT - target.STAINT

/datum/coven_power/presence/proc/ta_apply_presence_overlay(mob/living/carbon/human/target)
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

/datum/coven_power/presence/proc/ta_apply_resisted_effect(mob/living/carbon/human/target, difference)
	switch(difference)
		if(-INFINITY to -3)
			to_chat(target, span_love("<b>Я на мгновение замираю.</b>"))
			target.visible_message(span_warning("[target] на мгновение замирает."))
			target.Immobilize(2 SECONDS)
		if(-2)
			to_chat(target, span_love("<b>Я сопротивляюсь приказу.</b>"))
			target.visible_message(span_warning("[target] сопротивляется незримому приказу."))
			target.Immobilize(3 SECONDS)
		if(-1)
			to_chat(target, span_love("<b>Мир на мгновение застилает туман.</b>"))
			target.visible_message(span_warning("[target] на мгновение выглядит ошеломлённо."))
			target.Immobilize(4 SECONDS)
		else
			return FALSE
	return TRUE

/datum/coven_power/presence/awe
	cooldown_length = 30 SECONDS

/datum/coven_power/presence/awe/pre_activation_checks(mob/living/target)
	if(!can_affect_target(target))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_DETACHED))
		to_chat(owner, span_warning("Разум [target] — пустая бездна, в которой нет чувств, подвластных моему Присутствию."))
		return FALSE
	return TRUE

/datum/coven_power/presence/awe/activate(mob/living/carbon/human/target)
	. = ..()
	ta_apply_presence_overlay(target)

	var/difference = ta_intelligence_difference(target)
	if(ta_apply_resisted_effect(target, difference))
		return

	playsound(target, 'sound/villain/wonder.ogg', 40)
	target.apply_status_effect(/datum/status_effect/awestruck, owner)
	if(!owner.cmode)
		to_chat(target, span_love("<b>Подойди ближе и взгляни на меня.</b>"))
		owner.say("Взгляни на меня.")
	else
		to_chat(target, span_love("<b>ВЗГЛЯНИ НА МЕНЯ!!</b>"))
		owner.say("ВЗГЛЯНИ НА МЕНЯ!!")

/datum/coven_power/presence/dread_gaze
	cooldown_length = 30 SECONDS

/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	ta_apply_presence_overlay(target)

	var/difference = ta_intelligence_difference(target)
	if(ta_apply_resisted_effect(target, difference))
		return

	to_chat(target, span_love("<b>БОЙСЯ МЕНЯ</b>"))
	owner.say("БОЙСЯ МЕНЯ!!")
	var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	target.freak_out()
	to_chat(target, span_love("<b>БОГИ, СПАСИТЕ МЕНЯ!</b>"))
	playsound(target, 'sound/villain/wonder.ogg', 40)

/datum/coven_power/presence/fall/activate(mob/living/carbon/human/target)
	. = ..()
	ta_apply_presence_overlay(target)

	var/difference = ta_intelligence_difference(target)
	if(ta_apply_resisted_effect(target, difference))
		return

	target.Immobilize(4 SECONDS)
	to_chat(target, span_love("<b>НА КОЛЕНИ</b>"))
	to_chat(target, span_love("<b>МОЙ НОВЫЙ БОГ!</b>"))
	playsound(target, 'sound/villain/wonder_secret_known.ogg', 40)
	owner.say("НА КОЛЕНИ!!")
	target.set_resting(TRUE, TRUE)

/datum/coven_power/presence/majesty
	vitae_cost = 125

/datum/coven_power/presence/majesty/apply_majesty_effect(mob/living/target)
	if(!can_affect_target(target))
		return

	affected_mobs |= target
	target.apply_status_effect(/datum/status_effect/majesty_compulsion, owner)

	if(prob(70))
		if(target.get_active_held_item())
			target.visible_message(span_warning("[target] не выдерживает Присутствия [owner]!"))
			target.dropItemToGround(target.get_active_held_item())

		target.stop_pulling()
		if(target.cmode)
			target.toggle_cmode()
