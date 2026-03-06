// Late-include vampire drinksomeblood override.
// Include this below upstream vampire files and after living_modifications.dm.
// Intentionally overrides only the public entry proc and uses uniquely named
// helper procs so upstream vars and type definitions remain authoritative.

/mob/living/twilight_vamp_get_drinker()
	return mind?.has_antag_datum(/datum/antagonist/vampire)

/mob/living/twilight_vamp_get_victim(mob/living/carbon/victim)
	return victim.mind?.has_antag_datum(/datum/antagonist/vampire)

/mob/living/twilight_vamp_check_silver_block(mob/living/carbon/victim)
	var/datum/antagonist/vampire/VDrinker = twilight_vamp_get_drinker()
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

/mob/living/twilight_vamp_perform_initial_blooddrink(mob/living/carbon/victim, sublimb_grabbed)
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

/mob/living/twilight_vamp_force_puke()
	to_chat(src, span_warning("I'm going to puke..."))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))

/mob/living/twilight_vamp_consume_vitae(mob/living/carbon/victim)
	var/used_vitae = 150

	victim.blood_volume = max(victim.blood_volume - 45, 0)

	if(victim.bloodpool < used_vitae)
		used_vitae = victim.bloodpool
		to_chat(src, span_warning("...But alas, only leftovers..."))

	victim.adjust_bloodpool(-used_vitae)
	victim.adjust_hydration(-used_vitae * 0.1)

	if(victim.mind && !victim.clan)
		used_vitae = used_vitae * CLIENT_VITAE_MULTIPLIER

	adjust_bloodpool(used_vitae)
	adjust_hydration(used_vitae * 0.1)

/mob/living/twilight_vamp_handle_diablerie(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker, datum/antagonist/vampire/VVictim)
	if(VVictim)
		AdjustMasquerade(-1)
		message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
		log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
		to_chat(src, span_danger("I have... Consumed my kindred!"))

		if(VVictim.generation > VDrinker.generation)
			VDrinker.generation = VVictim.generation

		VDrinker.research_points += VVictim.research_points
		victim.death()
		victim.adjustBruteLoss(-50, TRUE)
		victim.adjustFireLoss(-50, TRUE)
		return TRUE

	if(victim.blood_volume < BLOOD_VOLUME_SURVIVE && victim.stat != DEAD)
		to_chat(src, span_warning("This sad sacrifice for your own pleasure affects something deep in your mind."))
		AdjustMasquerade(-1)
		victim.death()
		return TRUE

	return FALSE

/mob/living/twilight_vamp_process_vampire_blood(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker, datum/antagonist/vampire/VVictim)
	var/blood_handle = twilight_vamp_build_blood_handle(victim, VVictim)
	clan.handle_bloodsuck(src, blood_handle)

	if(victim.bloodpool > 0)
		twilight_vamp_consume_vitae(victim)
		return FALSE

	if(twilight_vamp_handle_diablerie(victim, VDrinker, VVictim))
		return TRUE

	return FALSE

/mob/living/twilight_vamp_attempt_siring_prompt(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker)
	if(victim.clan || !victim.mind || !ishuman(victim))
		return
	if(VDrinker.generation <= GENERATION_THINBLOOD)
		return
	if(victim.blood_volume > BLOOD_VOLUME_BAD)
		return

	var/datum/antagonist/vampire/vdrinker = twilight_vamp_get_drinker()
	if(!istype(vdrinker))
		return

	if((vdrinker.max_thralls <= 0) || (isnull(vdrinker.max_thralls || VDrinker.generation == GENERATION_THINBLOOD)))
		to_chat(src, span_warning("I cannot sire thralls, my blood is too weak!"))
		return

	if(vdrinker.thrall_count >= vdrinker.max_thralls)
		to_chat(src, span_warning("I cannot sire anymore thralls.."))
		return

	if(alert(src, "Would you like to sire a new spawn?", "THE CURSE OF KAIN", "MAKE IT SO", "I RESCIND") != "MAKE IT SO")
		to_chat(src, span_warning("I decide [victim] is unworthy."))
		return

	visible_message(span_danger("[src] begins channeling their energies to [victim]!"))
	if(!do_mob(src, victim, 7 SECONDS, double_progress = TRUE, can_move = FALSE))
		to_chat(src, span_warning("I was interrupted during my siring!"))
		return

	if(HAS_TRAIT_FROM(victim, TRAIT_REFUSED_VAMP_CONVERT, REF(src)))
		to_chat(src, span_warning("[victim] has already refused your offer to sire them."))
		return

	if(!twilight_vamp_can_offer_siring(victim))
		return

	var/mob/living/carbon/human/H = victim
	if(H.twilight_vamp_has_pending_conversion_prompt())
		to_chat(src, span_warning("[victim] still fights the curse."))
		return

	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living/carbon/human, vampire_conversion_prompt), src)

/mob/living/twilight_vamp_resolve_blooddrink_consequences(mob/living/carbon/victim)
	var/datum/antagonist/vampire/VDrinker = twilight_vamp_get_drinker()

	if(!VDrinker)
		if(twilight_vamp_should_puke_nonvamp())
			twilight_vamp_force_puke()
		return

	if(twilight_vamp_should_puke_bad_source(victim))
		twilight_vamp_force_puke()
		return

	var/datum/antagonist/vampire/VVictim = twilight_vamp_get_victim(victim)
	if(VVictim)
		to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))

	if(twilight_vamp_process_vampire_blood(victim, VDrinker, VVictim))
		return

	twilight_vamp_attempt_siring_prompt(victim, VDrinker)

/mob/living/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(!twilight_vamp_can_use_drinksomeblood())
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

	if(!twilight_vamp_check_silver_block(victim))
		return

	twilight_vamp_perform_initial_blooddrink(victim, sublimb_grabbed)
	twilight_vamp_resolve_blooddrink_consequences(victim)
