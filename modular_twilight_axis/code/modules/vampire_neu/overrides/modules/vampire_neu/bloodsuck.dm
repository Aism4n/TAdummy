/*
Bloodsuck flow overview (top-down reading order):

TA note:
	Upstream override entrypoints in this file must stay in shorthand form:
		/mob/living/carbon/human/add_bite_animation()
		/mob/living/carbon/human/remove_bite()
		/mob/living/carbon/human/vampire_conversion_prompt()
		/mob/living/carbon/human/drinksomeblood()
	New helper procs must be declared with explicit /proc/, for example:
		/mob/living/carbon/human/proc/helper_name()

add_bite_animation(), remove_bite()
	Visual feedback for blood drinking.

can_use_drinksomeblood(), check_silver_block()
	Pre-flight validation before blood interaction.

get_vampire_drinker(), get_vampire_victim()
	Resolve vampire context for actor and target.

perform_initial_blooddrink()
	Immediate blood loss, messages, sounds, signals.

force_puke(), should_puke_*
	Side effects for invalid or forbidden blood sources.

build_blood_handle(), consume_vitae()
	Blood preference flags and vitae processing.

handle_diablerie(), process_vampire_blood()
	Diablerie resolution and blood mechanics.

get_conversion_costs(), can_pay_conversion_cost(), apply_conversion_cost()
	Cost calculation for spawn creation.

use_highpop_conversion_rules(), handle_offer_conversion_refusal()
	Population-gated conversion rules and refusal handling.

finish_vampire_conversion(), attempt_siring_prompt()
	Checks and initiates siring flow.

vampire_conversion_prompt()
	Player-facing conversion and spawn creation.

resolve_blooddrink_consequences()
	Post-drink resolution logic.

drinksomeblood()
	Main entry point.
*/

/// VISUALS
/mob/living/carbon/human/add_bite_animation()
	remove_overlay(SUNDER_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('icons/effects/clan.dmi', "bite", -SUNDER_LAYER)
	overlays_standing[SUNDER_LAYER] = bite_overlay
	apply_overlay(SUNDER_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_bite)), 1.5 SECONDS)

/mob/living/carbon/human/remove_bite()
	remove_overlay(SUNDER_LAYER)

/// BASIC CHECKS
/mob/living/carbon/human/proc/can_use_drinksomeblood()
	if(world.time <= next_move)
		return FALSE
	if(world.time < last_drinkblood_use + 2 SECONDS)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/check_silver_block(mob/living/carbon/victim)
	var/datum/antagonist/vampire/VDrinker = get_vampire_drinker()
	if(!VDrinker)
		return TRUE
	if(!ishuman(victim))
		return TRUE

	var/mob/living/carbon/human/H = victim
	if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(src, span_userdanger("SILVER! HISSS!!!"))
		return FALSE
	if(HAS_TRAIT(H, TRAIT_SILVER_BLESSED))
		to_chat(src, span_userdanger("SILVER IN THE BLOOD! HISSS!!!"))
		return FALSE

	return TRUE

/// CONTEXT
/mob/living/carbon/human/proc/get_vampire_drinker()
	return mind?.has_antag_datum(/datum/antagonist/vampire)

/mob/living/carbon/human/proc/get_vampire_victim(mob/living/carbon/victim)
	return victim.mind?.has_antag_datum(/datum/antagonist/vampire)

/// INITIAL ACTION
/mob/living/carbon/human/proc/perform_initial_blooddrink(mob/living/carbon/victim, sublimb_grabbed)
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		H.add_bite_animation()

	last_drinkblood_use = world.time
	changeNext_move(CLICK_CD_MELEE)

	victim.blood_volume = max(victim.blood_volume - 5, 0)
	victim.handle_blood()

	playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	SEND_SIGNAL(src, COMSIG_LIVING_DRINKED_LIMB_BLOOD, victim)

	victim.visible_message(
		span_danger("[src] drinks from [victim]'s [parse_zone(sublimb_grabbed)]!"),
		span_userdanger("[src] drinks from my [parse_zone(sublimb_grabbed)]!"),
		span_hear("..."),
		COMBAT_MESSAGE_RANGE,
		src
	)

	to_chat(src, span_warning("I drink from [victim]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(src, victim, "drank blood from ")

/// SIDE EFFECTS
/mob/living/carbon/human/proc/force_puke(use_danger = FALSE)
	to_chat(src, use_danger ? span_danger("I'm going to puke...") : span_warning("I'm going to puke..."))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))

/mob/living/carbon/human/proc/should_puke_nonvamp()
	if(HAS_TRAIT(src, TRAIT_HORDE) || HAS_TRAIT(src, TRAIT_NASTY_EATER))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/should_puke_bad_source(mob/living/carbon/victim)
	if(victim.mind?.has_antag_datum(/datum/antagonist/werewolf))
		return TRUE
	if(victim.stat != DEAD && victim.mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	return FALSE

/// BLOOD MECHANICS
/mob/living/carbon/human/proc/build_blood_handle(mob/living/carbon/victim, datum/antagonist/vampire/VVictim)
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

/mob/living/carbon/human/proc/consume_vitae(mob/living/carbon/victim)
	var/used_vitae = 150

	victim.blood_volume = max(victim.blood_volume - 45, 0)

	if(victim.bloodpool < used_vitae)
		used_vitae = victim.bloodpool
		to_chat(src, span_warning("...But alas, only leftovers..."))

	victim.adjust_bloodpool(-used_vitae)
	victim.adjust_hydration(- used_vitae * 0.1)

	if(victim.mind && !victim.clan)
		used_vitae = used_vitae * CLIENT_VITAE_MULTIPLIER

	adjust_bloodpool(used_vitae)
	adjust_hydration(used_vitae * 0.1)

/// DIABLERIE
/mob/living/carbon/human/proc/handle_diablerie(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker, datum/antagonist/vampire/VVictim)
	if(VVictim)
		AdjustMasquerade(-1)
		message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
		log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
		to_chat(src, span_danger("I have... Consumed my kindred!"))

		if(VVictim.generation > VDrinker.generation)
			VDrinker.generation = VVictim.generation

		VDrinker.research_points += TA_VAMP_DIABLERIE_RESEARCH_BONUS
		VDrinker.research_points += VVictim.research_points
		victim.death()
		victim.adjustBruteLoss(-50, TRUE)
		victim.adjustFireLoss(-50, TRUE)
		addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, dust)), 10 SECONDS)
		return TRUE

	if(victim.blood_volume < BLOOD_VOLUME_SURVIVE && victim.stat != DEAD)
		to_chat(src, span_warning("This sad sacrifice for your own pleasure affects something deep in your mind."))
		AdjustMasquerade(-1)
		victim.death()
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/process_vampire_blood(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker, datum/antagonist/vampire/VVictim)
	var/blood_handle = build_blood_handle(victim, VVictim)
	clan.handle_bloodsuck(src, blood_handle)

	if(victim.bloodpool > 0)
		consume_vitae(victim)
		return FALSE

	if(handle_diablerie(victim, VDrinker, VVictim))
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/get_conversion_costs(datum/antagonist/vampire/VDrinker)
	var/list/costs = list(
		"research_cost" = 0,
		"maxbloodpool_cost" = 0,
	)

	switch(VDrinker.generation)
		if(GENERATION_ANCILLAE)
			costs["research_cost"] = TA_VAMP_CONVERT_ANCILLAE_RESEARCH_COST
			costs["maxbloodpool_cost"] = TA_VAMP_CONVERT_ANCILLAE_MAXBLOODPOOL_COST
		if(GENERATION_NEONATE)
			costs["research_cost"] = TA_VAMP_CONVERT_NEONATE_RESEARCH_COST
			costs["maxbloodpool_cost"] = TA_VAMP_CONVERT_NEONATE_MAXBLOODPOOL_COST

	return costs

/mob/living/carbon/human/proc/can_pay_conversion_cost(datum/antagonist/vampire/VDrinker)
	var/list/costs = get_conversion_costs(VDrinker)
	var/research_cost = costs["research_cost"]
	var/maxbloodpool_cost = costs["maxbloodpool_cost"]

	if(VDrinker.research_points < research_cost)
		return FALSE
	if(maxbloodpool <= maxbloodpool_cost)
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/apply_conversion_cost(datum/antagonist/vampire/VDrinker)
	var/list/costs = get_conversion_costs(VDrinker)
	var/research_cost = costs["research_cost"]
	var/maxbloodpool_cost = costs["maxbloodpool_cost"]

	if(!can_pay_conversion_cost(VDrinker))
		return FALSE

	VDrinker.research_points -= research_cost
	maxbloodpool = max(maxbloodpool - maxbloodpool_cost, 1)
	set_bloodpool(bloodpool)

	return TRUE

/mob/living/carbon/human/proc/show_conversion_cost_feedback(mob/living/carbon/human/target, datum/antagonist/vampire/VDrinker, voluntary = FALSE)
	var/list/costs = get_conversion_costs(VDrinker)
	var/research_cost = costs["research_cost"]
	var/maxbloodpool_cost = costs["maxbloodpool_cost"]

	if(voluntary)
		to_chat(src, span_warning("I draw [target] into the curse, spending my own strength to do it."))
	else
		to_chat(src, span_warning("I break [target]'s soul and force the curse into them, spending my own strength to do it."))

	if(research_cost || maxbloodpool_cost)
		var/list/losses = list()
		if(research_cost)
			var/research_suffix = (research_cost == 1) ? "" : "s"
			losses += "[research_cost] research point[research_suffix]"
		if(maxbloodpool_cost)
			losses += "[maxbloodpool_cost] max bloodpool"
		to_chat(src, span_notice("I lose [english_list(losses)]."))
	else
		to_chat(src, span_notice("This conversion costs me nothing."))

/mob/living/carbon/human/proc/grant_offer_conversion_reward(datum/antagonist/vampire/VDrinker)
	if(!istype(VDrinker))
		return FALSE

	VDrinker.research_points += TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD
	to_chat(src, span_notice("The offered conversion grants me [TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] research point."))
	return TRUE

/mob/living/carbon/human/proc/use_highpop_conversion_rules()
	return get_active_player_count() > TA_VAMP_CONVERT_HIGHPOP_THRESHOLD

/mob/living/carbon/human/proc/handle_offer_conversion_refusal(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker)
	ADD_TRAIT(src, TRAIT_REFUSED_VAMP_CONVERT, TRAIT_GENERIC)
	sire.grant_offer_conversion_reward(VDrinker)

	if(!use_highpop_conversion_rules())
		to_chat(src, span_warning("I reject the curse and deny [sire]'s offer."))
		to_chat(sire, span_warning("[src] rejects the offered curse."))
		vampire_conversion_prompt_active = FALSE
		return FALSE

	var/datum/antagonist/zombie/zombie_antag = zombie_check_can_convert()
	if(!zombie_antag)
		to_chat(sire, span_warning("[src] resists the curse, but cannot be dragged into undeath."))
		vampire_conversion_prompt_active = FALSE
		return FALSE

	to_chat(src, span_userdanger("My resistance twists the curse into something foul and deathless!"))
	to_chat(sire, span_danger("[src] rejects the offered curse and rises as a deadite!"))

	zombie_antag.wake_zombie(TRUE)
	Paralyze(TA_VAMP_CONVERT_RESIST_STUN_TIME)

	vampire_conversion_prompt_active = FALSE
	return TRUE

/mob/living/carbon/human/proc/finish_vampire_conversion(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker, voluntary = FALSE)
	if(!istype(sire) || !istype(VDrinker))
		return FALSE

	if(!sire.apply_conversion_cost(VDrinker))
		to_chat(sire, span_warning("I no longer have the strength to create a spawn."))
		vampire_conversion_prompt_active = FALSE
		return FALSE

	var/datum/mind/original_mind = mind

	if(stat == DEAD)
		revive(full_heal = TRUE)
	else
		heal_overall_damage(INFINITY, INFINITY)

	stat = CONSCIOUS

	remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	mind?.remove_antag_datum(/datum/antagonist/zombie)

	if(client)
		client.verbs.Remove(GLOB.ghost_verbs)

	visible_message(span_danger("Some dark energy begins to flow from [sire] into [src]..."))
	visible_message(span_red("[src] rises as a new spawn!"))

	original_mind?.transfer_to(src, TRUE)

	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(
		incoming_clan = sire.clan,
		forced_clan = TRUE,
		generation = max(VDrinker.generation - 1, GENERATION_THINBLOOD)
	)

	mind?.add_antag_datum(new_antag)
	VDrinker.thrall_count++
	sire.show_conversion_cost_feedback(src, VDrinker, voluntary)
	if(voluntary)
		sire.grant_offer_conversion_reward(VDrinker)
	adjust_bloodpool(VAMP_CONVERT_BLOOD_GAIN)
	apply_status_effect(/datum/status_effect/incapacitating/stun, VAMP_CONVERT_POST_STUN)

	vampire_conversion_prompt_active = FALSE
	return TRUE

/// SIRING
/mob/living/carbon/human/proc/attempt_siring_prompt(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker)
	if(!victim.clan && victim.mind && ishuman(victim) && victim.blood_volume <= BLOOD_VOLUME_BAD)
		if(HAS_TRAIT(victim, TRAIT_REFUSED_VAMP_CONVERT))
			to_chat(src, span_warning("[victim] has already rejected the curse and cannot be offered it again."))
		else if(!can_pay_conversion_cost(VDrinker))
			to_chat(src, span_warning("I lack the power to create a new spawn."))
		else
			var/highpop_rules = use_highpop_conversion_rules()
			var/list/costs = get_conversion_costs(VDrinker)
			var/research_cost = costs["research_cost"]
			var/maxbloodpool_cost = costs["maxbloodpool_cost"]
			var/cost_line = "Cost: free."
			if(research_cost || maxbloodpool_cost)
				var/research_suffix = (research_cost == 1) ? "" : "s"
				cost_line = "Cost on success: [research_cost] research point[research_suffix], -[maxbloodpool_cost] max bloodpool."

			var/choice
			if(VDrinker.generation == GENERATION_METHUSELAH)
				choice = alert(
					src,
					"How will I claim [victim]?\n[cost_line]",
					"THE CURSE OF KAIN",
					"Force",
					"Cancel"
				)
			else if(highpop_rules)
				choice = alert(
					src,
					"How will I claim [victim]?\n[cost_line]\nOffer Convert grants [TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] research point whether [victim.p_they()] submit or resist.",
					"THE CURSE OF KAIN",
					"Offer",
					"Force",
					"Cancel"
				)
			else
				choice = alert(
					src,
					"How will I claim [victim]?\n[cost_line]\nOffer Convert grants [TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] research point whether [victim.p_they()] accept or refuse.",
					"THE CURSE OF KAIN",
					"Offer",
					"Cancel"
				)

			if(choice != "Force" && choice != "Offer")
				to_chat(src, span_warning("I decide [victim] is unworthy."))
			else
				visible_message(span_danger("[src] begins channeling their energies to [victim]!"))
				if(!do_mob(src, victim, 7 SECONDS, double_progress = TRUE, can_move = FALSE))
					to_chat(src, span_warning("I was interrupted during my siring!"))
				else if(HAS_TRAIT(victim, TRAIT_UNLYCKERABLE))
					return FALSE
				else if(HAS_TRAIT(victim, TRAIT_REFUSED_VAMP_CONVERT))
					to_chat(src, span_warning("[victim] has already rejected the curse and cannot be offered it again."))
				else
					var/mob/living/carbon/human/H = victim
					if(H.vampire_conversion_prompt_active)
						to_chat(src, span_warning("[victim] still fights the curse."))
					else if(choice == "Force")
						H.finish_vampire_conversion(src, VDrinker, FALSE)
					else
						INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src, TRUE)

/// CONVERSION
/mob/living/carbon/human/vampire_conversion_prompt(mob/living/carbon/sire, voluntary = FALSE)
	if(!mind || QDELETED(src))
		return

	if(vampire_conversion_prompt_active)
		return
	vampire_conversion_prompt_active = TRUE

	var/datum/antagonist/vampire/VDrinker = sire?.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!istype(VDrinker))
		vampire_conversion_prompt_active = FALSE
		return

	if(stat != DEAD)
		apply_status_effect(/datum/status_effect/incapacitating/stun, VAMP_CONVERT_TIMEOUT)
		apply_status_effect(/datum/status_effect/incapacitating/knockdown, VAMP_CONVERT_TIMEOUT)

	var/prompt_text = "Do you want to become a vampire?"
	if(use_highpop_conversion_rules())
		prompt_text += " If you refuse, you will rise as a deadite instead."

	var/vampire_choice = tgui_alert(
		src,
		prompt_text,
		"THE CURSE OF KAIN",
		list("ACCEPT", "REFUSE"),
		VAMP_CONVERT_TIMEOUT
	)
	remove_status_effect(/datum/status_effect/incapacitating/stun)
	remove_status_effect(/datum/status_effect/incapacitating/knockdown)

	if(QDELETED(src) || !mind)
		vampire_conversion_prompt_active = FALSE
		return

	if(QDELETED(sire) || !sire?.mind)
		vampire_conversion_prompt_active = FALSE
		return

	VDrinker = sire.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!istype(VDrinker))
		vampire_conversion_prompt_active = FALSE
		return

	if(vampire_choice != "ACCEPT")
		if(!vampire_choice)
			vampire_conversion_prompt_active = FALSE
			return

		return handle_offer_conversion_refusal(sire, VDrinker)

	return finish_vampire_conversion(sire, VDrinker, voluntary)

/// RESOLUTION
/mob/living/carbon/human/proc/resolve_blooddrink_consequences(mob/living/carbon/victim)
	var/datum/antagonist/vampire/VDrinker = get_vampire_drinker()

	if(!VDrinker)
		if(should_puke_nonvamp())
			force_puke()
		return

	if(should_puke_bad_source(victim))
		force_puke(TRUE)
		return

	var/datum/antagonist/vampire/VVictim = get_vampire_victim(victim)
	if(VVictim)
		to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))

	if(process_vampire_blood(victim, VDrinker, VVictim))
		return

	attempt_siring_prompt(victim, VDrinker)

/// ENTRY POINT
/mob/living/carbon/human/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(!can_use_drinksomeblood())
		return

	if(!istype(victim))
		to_chat(src, span_warning("I can only drink blood from living, intelligent beings!"))
		return

	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("Sigh. No blood."))
		return

	if(victim.blood_volume <= 0)
		to_chat(src, span_warning("Sigh. No blood."))
		return

	if(!check_silver_block(victim))
		return

	perform_initial_blooddrink(victim, sublimb_grabbed)
	resolve_blooddrink_consequences(victim)
