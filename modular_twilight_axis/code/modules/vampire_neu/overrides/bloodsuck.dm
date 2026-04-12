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

use_pallid_conversion_rules(), handle_offer_conversion_refusal()
	Population-gated conversion rules and refusal handling.

finish_vampire_conversion(), attempt_siring_prompt()
	Checks and initiates siring flow.

vampire_conversion_prompt()
	Player-facing conversion and spawn creation.

get_siring_block_reason()
	Validates that the target can even enter the conversion branch.

requires_finishing_blooddrink_delay()
	Delay gate for lethal blood-drinking attempts.

resolve_blooddrink_consequences()
	Post-drink resolution logic. Silently skips siring for hard-blocked targets.

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
		to_chat(src, span_userdanger("СЕРЕБРО! ШШШШ!!!"))
		return FALSE
	if(HAS_TRAIT(H, TRAIT_SILVER_BLESSED))
		to_chat(src, span_userdanger("СЕРЕБРО В КРОВИ! ШШШШ!!!"))
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

	to_chat(src, span_warning("Я пью из [parse_zone(sublimb_grabbed)] [victim]."))
	log_combat(src, victim, "drank blood from ")

/// SIDE EFFECTS
/mob/living/carbon/human/proc/force_puke(use_danger = FALSE)
	to_chat(src, use_danger ? span_danger("Меня сейчас стошнит...") : span_warning("Меня сейчас стошнит..."))
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
		to_chat(src, span_warning("...Но увы, лишь жалкие остатки..."))

	victim.adjust_bloodpool(-used_vitae)
	victim.adjust_hydration(- used_vitae * 0.1)

	if(victim.mind && !victim.clan && !HAS_TRAIT(victim, TRAIT_PALLID))
		used_vitae = used_vitae * CLIENT_VITAE_MULTIPLIER

	adjust_bloodpool(used_vitae)
	adjust_hydration(used_vitae * 0.1)

/// DIABLERIE
/mob/living/carbon/human/proc/handle_diablerie(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker, datum/antagonist/vampire/VVictim)

	if(VVictim)

		var/is_breaker = GLOB.coven_breakers_list.Find(victim)

		if(!is_breaker)
			AdjustMasquerade(-1)

		message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
		log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")

		to_chat(src, span_danger("Я... Поглотил своего сородича!"))

		if(is_breaker)
			VDrinker.research_points += 2
			GLOB.coven_breakers_list -= victim

			to_chat(src, span_danger("Их кровь провоняла нарушенными клятвами. Я забираю больше силы!"))
			to_chat(src, span_notice("Справедливость за Маскарад свершилась."))

		if(VVictim.generation > VDrinker.generation)
			VDrinker.generation = VVictim.generation
			VDrinker.recalculate_hud_visibility()

			var/victim_blood_skill = victim.get_skill_level(/datum/skill/magic/blood)
			var/drinker_blood_skill = get_skill_level(/datum/skill/magic/blood)
			if(victim_blood_skill > drinker_blood_skill)
				adjust_skillrank_up_to(/datum/skill/magic/blood, victim_blood_skill, TRUE)
				to_chat(src, span_notice("Их мастерство гемомантии перетекает в меня!"))

			var/stolen_thralls = round(VVictim.max_thralls / 2)
			if(stolen_thralls > 0)
				VDrinker.max_thralls += stolen_thralls
				to_chat(src, span_notice("Их власть над рабами усиливает мою! (+[stolen_thralls] макс. рабов)"))

		if(victim.clan != clan)
			VDrinker.research_points += TA_VAMP_DIABLERIE_RESEARCH_BONUS

		VDrinker.research_points += VVictim.research_points

		victim.dust(drop_items = TRUE)

		return TRUE

	if(victim.blood_volume < BLOOD_VOLUME_SURVIVE && victim.stat != DEAD)

		to_chat(src, span_warning("Эта жалкая жертва ради собственного удовольствия затрагивает что-то глубоко в моём разуме."))

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

	if(VVictim)
		to_chat(src, span_userdanger("<b>Я ПЫТАЮСЬ ПОГЛОТИТЬ ДУШУ [victim].</b>"))

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
	adjust_bloodpool(0)

	return TRUE

/mob/living/carbon/human/proc/show_conversion_cost_feedback(mob/living/carbon/human/target, datum/antagonist/vampire/VDrinker, voluntary = FALSE)
	if(voluntary)
		to_chat(src, span_warning("Я увлекаю [target] в проклятие."))
		return

	var/list/costs = get_conversion_costs(VDrinker)
	var/research_cost = costs["research_cost"]
	var/maxbloodpool_cost = costs["maxbloodpool_cost"]

	to_chat(src, span_warning("Я ломаю душу [target] и вбиваю проклятие силой, жертвуя собственной мощью."))

	if(research_cost || maxbloodpool_cost)
		var/list/losses = list()
		if(research_cost)
			losses += "[research_cost] RP"
		if(maxbloodpool_cost)
			losses += "[maxbloodpool_cost] макс. кровозапаса"
		to_chat(src, span_notice("Я теряю [english_list(losses)]."))
	else
		to_chat(src, span_notice("Эта конвертация мне ничего не стоит."))

/mob/living/carbon/human/proc/grant_offer_conversion_reward(datum/antagonist/vampire/VDrinker, conversion_succeeded = FALSE)
	if(!istype(VDrinker))
		return FALSE

	VDrinker.research_points += TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD
	if(conversion_succeeded)
		to_chat(src, span_notice("Я поглотил часть жизненной силы жертвы и стал сильнее, а мое проклятие укоренилось в ней! (+[TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] RP)"))
	else
		to_chat(src, span_notice("Я поглотил часть жизненной силы жертвы и стал сильнее, но она преодолела мое проклятие! (+[TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] RP)"))
	return TRUE

/mob/living/carbon/human/proc/use_pallid_conversion_rules()
	return get_active_player_count() <= TA_VAMP_CONVERT_PALLID_THRESHOLD

/mob/living/carbon/human/proc/handle_offer_conversion_refusal(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker)
	ADD_TRAIT(src, TRAIT_REFUSED_VAMP_CONVERT, REF(sire))
	sire.grant_offer_conversion_reward(VDrinker)

	if(use_pallid_conversion_rules())
		to_chat(src, span_userdanger("Отвергнутое проклятие оставляет след на моей душе!"))
		to_chat(sire, span_danger("[src] отвергает проклятие, но скверна остаётся в крови!"))

		ADD_TRAIT(src, TRAIT_PALLID, REF(sire))
		apply_status_effect(/datum/status_effect/debuff/devitalised, 10 MINUTES)
		Paralyze(TA_VAMP_CONVERT_RESIST_STUN_TIME)

		AddComponent(/datum/component/pallid_addiction, sire)

		if(mind)
			mind.AddSpell(new /obj/effect/proc_holder/spell/self/pallid_sense(null, sire))
		if(sire.mind && !locate(/obj/effect/proc_holder/spell/self/pallid_track) in sire.mind.spell_list)
			sire.mind.AddSpell(new /obj/effect/proc_holder/spell/self/pallid_track)

		vampire_conversion_prompt_active = FALSE
		return TRUE

	to_chat(src, span_userdanger("Проклятие разрывает моё тело изнутри!"))
	to_chat(sire, span_danger("[src] отвергает проклятие и погибает от его силы!"))

	death()

	vampire_conversion_prompt_active = FALSE
	return TRUE

/mob/living/carbon/human/proc/finish_vampire_conversion(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker, voluntary = FALSE)
	if(!istype(sire) || !istype(VDrinker))
		return FALSE

	// Force convert costs resources; offer convert is free
	if(!voluntary)
		if(!sire.apply_conversion_cost(VDrinker))
			to_chat(sire, span_warning("У меня больше нет сил для создания порождения."))
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

	visible_message(span_danger("Тёмная энергия начинает перетекать от [sire] в [src]..."))
	visible_message(span_red("[src] восстаёт как новое порождение!"))

	original_mind?.transfer_to(src, TRUE)

	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(
		incoming_clan = sire.clan,
		forced_clan = TRUE,
		generation = max(VDrinker.generation - 1, GENERATION_THINBLOOD)
	)

	mind?.add_antag_datum(new_antag)
	VDrinker.register_thrall(new_antag)
	sire.show_conversion_cost_feedback(src, VDrinker, voluntary)
	if(voluntary)
		sire.grant_offer_conversion_reward(VDrinker, TRUE)
	adjust_bloodpool(VAMP_CONVERT_BLOOD_GAIN)
	apply_status_effect(/datum/status_effect/incapacitating/stun, VAMP_CONVERT_POST_STUN)

	vampire_conversion_prompt_active = FALSE
	return TRUE

/// SIRING TARGET VALIDATION
/mob/living/carbon/human/proc/get_siring_block_reason(mob/living/carbon/victim)
	if(!ishuman(victim))
		return "Только живых людей можно обратить в порождение."
	if(victim.clan)
		return "Эта цель уже принадлежит вампирскому клану."
	if(!victim.mind)
		return "У этой цели нет души, которую можно забрать."
	if(victim.blood_volume > BLOOD_VOLUME_BAD)
		return "В этой цели ещё слишком много крови."
	if(victim.stat == DEAD)
		return "Труп нельзя безопасно поднять как порождение."
	if(HAS_TRAIT(victim, TRAIT_UNLYCKERABLE))
		return "[victim] не может нести Солнечное проклятие."
	if(HAS_TRAIT(victim, TRAIT_SILVER_BLESSED))
		return "Кровь [victim] благословлена серебром и отвергает проклятие."
	if(victim.mind?.has_antag_datum(/datum/antagonist/zombie))
		return "[victim] уже является умертвием."
	if(victim.mind?.has_antag_datum(/datum/antagonist/werewolf))
		return "[victim] уже отмечен другим проклятием."

	var/mob/living/carbon/human/H = victim
	if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		return "[victim] защищён серебром."

	return null

/// SIRING
/mob/living/carbon/human/proc/attempt_siring_prompt(mob/living/carbon/victim, datum/antagonist/vampire/VDrinker)
	// === PRE-ALERT VALIDATION (hard blocks — nothing shown if impossible) ===
	var/block_reason = get_siring_block_reason(victim)
	if(block_reason)
		to_chat(src, span_warning(block_reason))
		return

	if(HAS_TRAIT_FROM(victim, TRAIT_REFUSED_VAMP_CONVERT, REF(src)))
		to_chat(src, span_warning("[victim] преодолел проклятие, я не смогу пленить его душу."))
		return

	if(!VDrinker.can_sire_thrall())
		to_chat(src, span_warning("Клан достиг предела порождений."))
		return

	// === DETERMINE AVAILABLE OPTIONS ===
	var/is_methuselah = (VDrinker.generation == GENERATION_METHUSELAH)
	var/can_force = is_methuselah || !use_pallid_conversion_rules()
	var/can_afford_force = can_force && (is_methuselah || can_pay_conversion_cost(VDrinker))

	// === SHOW ALERT (only options the vampire can actually take) ===
	var/choice

	if(is_methuselah)
		choice = alert(
			src,
			"Как я поступлю с [victim]?\nСиловая конвертация: бесплатно.",
			"ПРОКЛЯТИЕ КАИНА",
			"Насильно обратить",
			"Отмена"
		)
	else if(can_afford_force)
		var/list/costs = get_conversion_costs(VDrinker)
		var/research_cost = costs["research_cost"]
		var/maxbloodpool_cost = costs["maxbloodpool_cost"]
		var/force_cost_line = "Силовая конвертация: бесплатно."
		if(research_cost || maxbloodpool_cost)
			force_cost_line = "Силовая конвертация: [research_cost] RP, -[maxbloodpool_cost] макс. кровозапаса."

		var/offer_line = "Предложение: бесплатно. +[TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] RP за результат."

		choice = alert(
			src,
			"Как я поступлю с [victim]?\n[force_cost_line]\n[offer_line]",
			"ПРОКЛЯТИЕ КАИНА",
			"Приглашение в клан",
			"Насильно обратить",
			"Отмена"
		)
	else
		var/offer_line = "Предложение: бесплатно. +[TA_VAMP_CONVERT_OFFER_RESEARCH_REWARD] RP за результат."

		choice = alert(
			src,
			"Как я поступлю с [victim]?\n[offer_line]",
			"ПРОКЛЯТИЕ КАИНА",
			"Приглашение в клан",
			"Отмена"
		)

	if(choice != "Насильно обратить" && choice != "Приглашение в клан")
		return

	// === DO_MOB CHANNEL ===
	visible_message(span_danger("[src] наполняет [victim] тёмной энергией!"))
	if(!do_mob(src, victim, 7 SECONDS, double_progress = TRUE, can_move = FALSE))
		to_chat(src, span_warning("Меня прервали во время обращения!"))
		return

	// === POST-CHANNEL RE-VALIDATION (world may have changed during 7s) ===
	if(QDELETED(victim) || QDELETED(src))
		return

	block_reason = get_siring_block_reason(victim)
	if(block_reason)
		to_chat(src, span_warning(block_reason))
		return

	if(HAS_TRAIT_FROM(victim, TRAIT_REFUSED_VAMP_CONVERT, REF(src)))
		to_chat(src, span_warning("[victim] преодолел проклятие, я не смогу пленить его душу."))
		return

	if(!VDrinker.can_sire_thrall())
		to_chat(src, span_warning("Клан достиг предела порождений."))
		return

	var/mob/living/carbon/human/H = victim
	if(H.vampire_conversion_prompt_active)
		to_chat(src, span_warning("[victim] всё ещё борется с проклятием."))
		return

	if(choice == "Насильно обратить")
		if(!can_pay_conversion_cost(VDrinker))
			to_chat(src, span_warning("Мне не хватает силы для насильственного обращения."))
			return
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

	if(!VDrinker.can_sire_thrall())
		to_chat(src, span_warning("Клан вампира достиг предела порождений. Проклятие рассеивается."))
		vampire_conversion_prompt_active = FALSE
		return

	if(stat == DEAD)
		vampire_conversion_prompt_active = FALSE
		return

	if(stat != DEAD)
		apply_status_effect(/datum/status_effect/incapacitating/stun, VAMP_CONVERT_TIMEOUT)
		apply_status_effect(/datum/status_effect/incapacitating/knockdown, VAMP_CONVERT_TIMEOUT)

	var/prompt_text = "Хотите стать ВАМПИРОМ?\nВы восстанете как вампир, но ваша душа попадёт в рабство.\n\n"
	if(use_pallid_conversion_rules())
		prompt_text += "При отказе проклятие оставит неизгладимый след на вашей душе и теле."
	else
		prompt_text += "При отказе проклятие убьёт вас."

	var/use_byond_alert = stat != CONSCIOUS || blood_volume <= BLOOD_VOLUME_SURVIVE || InCritical()
	var/vampire_choice = tgui_alert(
		src,
		prompt_text,
		"ПРОКЛЯТИЕ КАИНА",
		list("ДА", "НЕТ"),
		VAMP_CONVERT_TIMEOUT,
		strict_byond = use_byond_alert,
		ui_state = GLOB.tgui_always_state
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

	var/block_reason = get_siring_block_reason(src)
	if(block_reason)
		to_chat(src, span_warning(block_reason))
		vampire_conversion_prompt_active = FALSE
		return

	if(!VDrinker.can_sire_thrall())
		to_chat(src, span_warning("Клан вампира достиг предела порождений. Проклятие рассеивается."))
		vampire_conversion_prompt_active = FALSE
		return

	if(vampire_choice != "ДА")
		if(!vampire_choice)
			vampire_conversion_prompt_active = FALSE
			return

		return handle_offer_conversion_refusal(sire, VDrinker)

	return finish_vampire_conversion(sire, VDrinker, voluntary)

/// KILL GATE
/mob/living/carbon/human/proc/requires_finishing_blooddrink_delay(mob/living/carbon/victim)
	if(victim.stat == DEAD)
		return FALSE
	if(!victim.client)
		return FALSE

	var/datum/antagonist/vampire/VVictim = get_vampire_victim(victim)
	if(VVictim)
		return victim.bloodpool <= 0

	return victim.bloodpool <= 0 && victim.blood_volume - 5 < BLOOD_VOLUME_SURVIVE

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

	// Clientless victims (NPCs) — only drain blood, no diablerie or conversion
	if(!victim.client)
		var/blood_handle = build_blood_handle(victim, null)
		clan.handle_bloodsuck(src, blood_handle)
		if(victim.bloodpool > 0)
			consume_vitae(victim)
		return

	// Conversion prompt is active — only drain blood, block diablerie and re-offer
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		if(H.vampire_conversion_prompt_active)
			var/blood_handle = build_blood_handle(victim, null)
			clan.handle_bloodsuck(src, blood_handle)
			if(victim.bloodpool > 0)
				consume_vitae(victim)
			return

	var/datum/antagonist/vampire/VVictim = get_vampire_victim(victim)

	if(process_vampire_blood(victim, VDrinker, VVictim))
		return

	if(VVictim)
		return

	if(!victim.mind)
		return

	var/block_reason = get_siring_block_reason(victim)
	if(block_reason)
		return

	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		if(HAS_TRAIT_FROM(H, TRAIT_REFUSED_VAMP_CONVERT, REF(src)))
			return

	if(!VDrinker.can_sire_thrall())
		return

	attempt_siring_prompt(victim, VDrinker)

/// ENTRY POINT
/mob/living/carbon/human/drinksomeblood(mob/living/carbon/victim, sublimb_grabbed)
	if(!can_use_drinksomeblood())
		return

	if(!istype(victim))
		to_chat(src, span_warning("Я могу пить кровь только из живых, разумных существ!"))
		return

	if(victim.dna?.species && (NOBLOOD in victim.dna.species.species_traits))
		to_chat(src, span_warning("Увы. Нет крови."))
		return

	if(victim.blood_volume <= 0)
		to_chat(src, span_warning("Увы. Нет крови."))
		return

	if(!check_silver_block(victim))
		return

	if(requires_finishing_blooddrink_delay(victim))
		visible_message(span_danger("[src] сжимает хватку и готовится выпить [victim] до последней капли!"))
		if(!do_mob(src, victim, TA_VAMP_LETHAL_BLOODDRINK_DELAY, double_progress = TRUE, can_move = FALSE))
			to_chat(src, span_warning("Мне не удалось завершить смертельное кровопитие."))
			return
		if(QDELETED(victim))
			return

	perform_initial_blooddrink(victim, sublimb_grabbed)
	resolve_blooddrink_consequences(victim)
