#define ROCKHILL_MASQUERADE_MIN_POP 60
#define ROCKHILL_MASQUERADE_CLAN_GOAL_MIN_POP 50
#define ROCKHILL_MASQUERADE_MAX_ANTAGS 3
#define ROCKHILL_MASQUERADE_CLAN_SIZE 5

/*
 * Rockhill receives a second, map-specific Masquerade attempt after the normal
 * storyteller roundstart roll. The controller still uses the standard solo
 * antagonist candidate pipeline: vampire preferences, antagonist bans,
 * existing-antag exclusion, and DEFAULT_ANTAG_BLACKLISTED_ROLES.
 */
SUBSYSTEM_DEF(ta_rockhill_masquerade)
	name = "TA Rockhill Masquerade"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT
	var/attempted = FALSE

/datum/controller/subsystem/ta_rockhill_masquerade/Initialize(timeofday)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(schedule_attempt)))

/datum/controller/subsystem/ta_rockhill_masquerade/proc/schedule_attempt()
	addtimer(CALLBACK(src, PROC_REF(attempt_masquerade)), 2 SECONDS)

/datum/controller/subsystem/ta_rockhill_masquerade/proc/attempt_masquerade()
	if(attempted)
		return
	if(!SSticker.HasRoundStarted())
		addtimer(CALLBACK(src, PROC_REF(attempt_masquerade)), 1 SECONDS)
		return
	attempted = TRUE

	if(SSmapping.config.map_name != "Rockhill")
		return
	if(SSgamemode.storyteller_is(/datum/storyteller/gamemode/extended, TRUE))
		log_storyteller("Rockhill Masquerade fallback skipped: Extended is active.")
		return
	if(SSgamemode.halted_storyteller || SSgamemode.current_storyteller?.disable_distribution)
		log_storyteller("Rockhill Masquerade fallback skipped: storyteller distribution is halted.")
		return

	var/active_population = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	if(active_population < ROCKHILL_MASQUERADE_MIN_POP)
		return

	if(istype(SSgamemode.current_roundstart_event, /datum/round_event_control/antagonist/solo/masquerade))
		log_storyteller("Rockhill Masquerade fallback skipped: the normal Masquerade was already selected.")
		return

	var/datum/round_event_control/antagonist/solo/masquerade/rockhill/fallback = new
	if(!length(fallback.get_candidates()))
		log_storyteller("Rockhill Masquerade fallback skipped: no valid vampire candidates.")
		qdel(fallback)
		return

	message_admins("STORYTELLER: Rockhill Masquerade fallback is adding up to [fallback.get_antag_amount()] Masqueraders at active pop [active_population].")
	log_storyteller("Rockhill Masquerade fallback triggered at active pop [active_population].")
	SSgamemode.triggered_round_events |= fallback.name
	fallback.runEvent(random = FALSE, admin_forced = FALSE)


/datum/round_event_control/antagonist/solo/masquerade/rockhill
	name = "Rockhill Masquerade"
	typepath = /datum/round_event/antagonist/solo/rockhill_masquerade
	antag_datum = /datum/antagonist/vampire/rockhill_masquerader
	max_occurrences = 0 // Never enters the natural event pool; the Rockhill subsystem owns its single attempt.
	maximum_antags = ROCKHILL_MASQUERADE_MAX_ANTAGS

/datum/round_event_control/antagonist/solo/masquerade/rockhill/get_antag_amount()
	var/people = SSgamemode.get_correct_popcount()
	return min(base_antags + FLOOR(people / denominator, 1), ROCKHILL_MASQUERADE_MAX_ANTAGS)


/datum/round_event/antagonist/solo/rockhill_masquerade/start()
	var/list/datum/mind/masquerader_minds = setup_minds.Copy()
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ta_assign_rockhill_masquerade_objectives), masquerader_minds), 2 SECONDS)


/datum/antagonist/vampire/rockhill_masquerader
	name = "Участник Маскарада"
	show_in_roundend = TRUE
	show_in_antagpanel = FALSE

/datum/antagonist/vampire/rockhill_masquerader/New(incoming_clan = /datum/clan/crimson_fang, forced_clan = FALSE, generation = GENERATION_ANCILLAE)
	. = ..(incoming_clan, forced_clan, generation)


/proc/ta_assign_rockhill_masquerade_objectives(list/datum/mind/masquerader_minds, methuselah_retries = 0)
	if(!length(masquerader_minds))
		return

	var/list/datum/mind/valid_masqueraders = list()
	for(var/datum/mind/masquerader_mind as anything in masquerader_minds)
		var/datum/antagonist/vampire/rockhill_masquerader/masquerader = masquerader_mind?.has_antag_datum(/datum/antagonist/vampire/rockhill_masquerader)
		if(masquerader?.owner?.current)
			valid_masqueraders += masquerader_mind
	if(!length(valid_masqueraders))
		return

	var/datum/mind/methuselah = ta_find_living_methuselah()
	var/methuselah_expected = istype(SSgamemode.current_roundstart_event, /datum/round_event_control/antagonist/solo/vampires)
	if(methuselah_expected && !methuselah && methuselah_retries < 5)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ta_assign_rockhill_masquerade_objectives), masquerader_minds, methuselah_retries + 1), 2 SECONDS)
		return
	if(methuselah)
		var/support_methuselah = prob(10)
		for(var/datum/mind/masquerader_mind as anything in valid_masqueraders)
			var/datum/objective/rockhill_masquerade/methuselah/objective
			if(support_methuselah)
				objective = new /datum/objective/rockhill_masquerade/methuselah/support(owner = masquerader_mind)
			else
				objective = new /datum/objective/rockhill_masquerade/methuselah/destroy(owner = masquerader_mind)
			objective.target = methuselah
			objective.update_explanation_text()
			ta_add_rockhill_masquerade_objective(masquerader_mind, objective)
		return

	var/list/inquisition_targets = ta_get_inquisition_targets()
	var/list/royal_targets = ta_get_royal_family_targets()
	var/active_population = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	var/list/used_goal_ids = list()

	for(var/datum/mind/masquerader_mind as anything in valid_masqueraders)
		var/list/available_goal_ids = list()
		if(length(valid_masqueraders) > 1)
			available_goal_ids += "rival_clans"
		if(length(inquisition_targets))
			available_goal_ids += "inquisition"
		if(length(royal_targets))
			available_goal_ids += "royal_conversion"
		if(active_population >= ROCKHILL_MASQUERADE_CLAN_GOAL_MIN_POP)
			available_goal_ids += "clan_growth"

		var/list/unused_goal_ids = available_goal_ids - used_goal_ids
		var/goal_id = pick(length(unused_goal_ids) ? unused_goal_ids : available_goal_ids)
		used_goal_ids |= goal_id

		var/datum/objective/rockhill_masquerade/objective
		switch(goal_id)
			if("rival_clans")
				var/datum/objective/rockhill_masquerade/rival_clans/rival_objective = new(owner = masquerader_mind)
				rival_objective.rival_minds = valid_masqueraders - masquerader_mind
				objective = rival_objective
			if("inquisition")
				var/datum/objective/rockhill_masquerade/inquisition/inquisition_objective = new(owner = masquerader_mind)
				inquisition_objective.target_minds = ta_pick_inquisition_objective_targets(inquisition_targets)
				inquisition_objective.update_explanation_text()
				objective = inquisition_objective
			if("royal_conversion")
				var/datum/objective/rockhill_masquerade/royal_conversion/royal_objective = new(owner = masquerader_mind)
				royal_objective.target = pick(royal_targets)
				royal_objective.update_explanation_text()
				objective = royal_objective
			if("clan_growth")
				objective = new /datum/objective/rockhill_masquerade/clan_growth(owner = masquerader_mind)

		ta_add_rockhill_masquerade_objective(masquerader_mind, objective)


/proc/ta_add_rockhill_masquerade_objective(datum/mind/masquerader_mind, datum/objective/rockhill_masquerade/objective)
	if(!masquerader_mind || !objective)
		return
	var/datum/antagonist/vampire/rockhill_masquerader/masquerader = masquerader_mind.has_antag_datum(/datum/antagonist/vampire/rockhill_masquerader)
	if(!masquerader)
		qdel(objective)
		return
	masquerader.objectives += objective
	to_chat(masquerader_mind.current, span_userdanger("За Маскарадом скрываются мои тайные амбиции."))
	to_chat(masquerader_mind.current, span_boldnotice("<b>Цель клана:</b> [objective.explanation_text]"))


/proc/ta_find_living_methuselah()
	for(var/datum/antagonist/antagonist as anything in GLOB.antagonists)
		if(!istype(antagonist, /datum/antagonist/vampire/lord))
			continue
		var/datum/antagonist/vampire/lord/methuselah = antagonist
		if(considered_alive(methuselah.owner))
			return methuselah.owner
	return null

/proc/ta_get_inquisition_targets()
	var/list/datum/mind/targets = list()
	var/has_inquisitor = FALSE
	for(var/datum/mind/candidate as anything in SSticker.minds)
		if(!considered_alive(candidate))
			continue
		if(candidate.assigned_role in list("Inquisitor", "Orthodoxist", "Absolver"))
			targets += candidate
			if(candidate.assigned_role == "Inquisitor")
				has_inquisitor = TRUE
	return has_inquisitor ? targets : list()

/proc/ta_pick_inquisition_objective_targets(list/datum/mind/inquisition_targets)
	var/list/datum/mind/picked_targets = list()
	var/list/datum/mind/retinue = list()
	for(var/datum/mind/candidate as anything in inquisition_targets)
		if(candidate.assigned_role == "Inquisitor")
			picked_targets |= candidate
		else
			retinue += candidate
	if(!length(picked_targets))
		return list()

	var/retinue_count = min(rand(2, 3), length(retinue))
	for(var/i in 1 to retinue_count)
		picked_targets += pick_n_take(retinue)
	return picked_targets

/proc/ta_get_royal_family_targets()
	var/list/datum/mind/targets = list()
	for(var/datum/mind/candidate as anything in SSticker.minds)
		if(!considered_alive(candidate))
			continue
		if(!(candidate.assigned_role in list("Grand Duke", "Consort", "Consort Dowager", "Prince")))
			continue
		if(candidate.has_antag_datum(/datum/antagonist/vampire))
			continue
		targets += candidate
	return targets

/proc/ta_rockhill_role_name_ru(role_name)
	switch(role_name)
		if("Inquisitor")
			return "Инквизитор"
		if("Orthodoxist")
			return "Ортодокс"
		if("Absolver")
			return "Абсолвер"
		if("Grand Duke")
			return "Король"
		if("Consort")
			return "Консорт"
		if("Consort Dowager")
			return "Вдовствующий консорт"
		if("Prince")
			return "Принц или принцесса"
	return role_name


/datum/objective/rockhill_masquerade
	name = "амбиции клана"
	flavor = "Цель клана"

/datum/objective/rockhill_masquerade/rival_clans
	name = "уничтожить лидеров соперничающих кланов"
	explanation_text = "Уничтожить лидеров других кланов и сделать свой клан господствующей силой в городе."
	var/list/datum/mind/rival_minds = list()

/datum/objective/rockhill_masquerade/rival_clans/check_completion()
	if(!length(rival_minds))
		return FALSE
	for(var/datum/mind/rival as anything in rival_minds)
		if(considered_alive(rival))
			return FALSE
	return TRUE


/datum/objective/rockhill_masquerade/inquisition
	name = "ослабить влияние Отавы"
	var/list/datum/mind/target_minds = list()

/datum/objective/rockhill_masquerade/inquisition/update_explanation_text()
	var/list/target_descriptions = list()
	for(var/datum/mind/target_mind as anything in target_minds)
		target_descriptions += "[target_mind.name] ([ta_rockhill_role_name_ru(target_mind.assigned_role)])"
	explanation_text = "Ослабить влияние Отавы в Рокхилле. Ликвидировать следующие цели: [jointext(target_descriptions, ", ")]."

/datum/objective/rockhill_masquerade/inquisition/check_completion()
	if(!length(target_minds))
		return FALSE
	for(var/datum/mind/target_mind as anything in target_minds)
		if(considered_alive(target_mind))
			return FALSE
	return TRUE


/datum/objective/rockhill_masquerade/royal_conversion
	name = "обратить представителя королевской семьи"

/datum/objective/rockhill_masquerade/royal_conversion/update_explanation_text()
	if(target)
		explanation_text = "Тайно обратить [target.name] ([ta_rockhill_role_name_ru(target.assigned_role)]) и принять эту особу в свой клан."
	else
		explanation_text = "Тайно обратить представителя королевской семьи и принять эту особу в свой клан."

/datum/objective/rockhill_masquerade/royal_conversion/check_completion()
	var/mob/living/carbon/human/owner_body = owner?.current
	var/mob/living/carbon/human/target_body = target?.current
	if(!istype(owner_body) || !istype(target_body) || !owner_body.clan)
		return FALSE
	if(!target.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	return target_body.clan == owner_body.clan


/datum/objective/rockhill_masquerade/clan_growth
	name = "расширить клан"
	explanation_text = "Расширить свой клан как минимум до [ROCKHILL_MASQUERADE_CLAN_SIZE] живых вампиров."

/datum/objective/rockhill_masquerade/clan_growth/check_completion()
	var/mob/living/carbon/human/owner_body = owner?.current
	if(!istype(owner_body) || !owner_body.clan)
		return FALSE
	var/living_vampires = 0
	for(var/mob/living/carbon/human/member as anything in owner_body.clan.clan_members)
		if(considered_alive(member.mind) && member.mind?.has_antag_datum(/datum/antagonist/vampire))
			living_vampires++
	return living_vampires >= ROCKHILL_MASQUERADE_CLAN_SIZE


/datum/objective/rockhill_masquerade/methuselah
	name = "решить судьбу Метсуфелата"

/datum/objective/rockhill_masquerade/methuselah/update_explanation_text()
	return

/datum/objective/rockhill_masquerade/methuselah/destroy
	name = "уничтожить Метсуфелата"
	explanation_text = "Явилось древнее зло — угроза всему вампирскому миру. Оно готово уничтожить наши кланы и низвергнуть весь мир в пучину войны. Мы должны объединиться против него и уничтожить Метсуфелата."

/datum/objective/rockhill_masquerade/methuselah/destroy/check_completion()
	return target && !considered_alive(target)

/datum/objective/rockhill_masquerade/methuselah/support
	name = "поддержать Метсуфелата"
	explanation_text = "Пробудилась древняя сила. Следует отвергнуть страх других кланов, поддержать возвращение Метсуфелата и обеспечить его выживание."

/datum/objective/rockhill_masquerade/methuselah/support/check_completion()
	return target && considered_alive(target)


#undef ROCKHILL_MASQUERADE_MIN_POP
#undef ROCKHILL_MASQUERADE_CLAN_GOAL_MIN_POP
#undef ROCKHILL_MASQUERADE_MAX_ANTAGS
#undef ROCKHILL_MASQUERADE_CLAN_SIZE
