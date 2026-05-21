#define TA_DEATH_GIFT_DARKSIGHT_NAME "Дар темного прозрения"
#define TA_DEATH_GIFT_POWER_NAME "Дар силы"
#define TA_DEATH_GIFT_BERSERK_NAME "Дар берсерка"
#define TA_DEATH_GIFT_SOURCE "ta_death_gift"
#define TA_DEATH_GIFT_BERSERK_DURATION (1 MINUTES)
#define TA_DEATH_GIFT_TIRED_DURATION (10 MINUTES)
#define TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE 30
#define TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE 3
#define TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN 2
#define TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX 3

/datum/antagonist/vampire
	var/ta_death_gifts_given = 0

/datum/antagonist/vampire/proc/ta_death_gift_limit()
	switch(generation)
		if(GENERATION_METHUSELAH)
			return INFINITY
		if(GENERATION_ANCILLAE)
			return 10
		if(GENERATION_NEONATE)
			return 3 // Licker/Wretch vampires use Neonate generation in this codebase.
		if(GENERATION_THINBLOOD)
			return 0
	return 0

/datum/antagonist/vampire/proc/ta_can_offer_death_gift()
	var/limit = ta_death_gift_limit()
	if(limit == INFINITY)
		return TRUE
	return ta_death_gifts_given < limit

/datum/antagonist/vampire/proc/ta_record_death_gift()
	var/limit = ta_death_gift_limit()
	if(limit <= 0)
		return FALSE
	if(limit != INFINITY)
		ta_death_gifts_given++
	return TRUE

/mob/living/carbon/human/proc/ta_stabilize_death_gift_body(revive_if_dead = FALSE, datum/mind/original_mind = null)
	if(QDELETED(src))
		return FALSE

	if(stat == DEAD)
		if(!revive_if_dead)
			return FALSE
		adjustOxyLoss(-getOxyLoss())
		if(!revive(full_heal = FALSE))
			return FALSE
		if(original_mind && original_mind.current != src)
			original_mind.transfer_to(src, TRUE)
		if(client)
			client.verbs.Remove(GLOB.ghost_verbs)
		remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
		mind?.remove_antag_datum(/datum/antagonist/zombie)

	suppress_bloodloss(TA_VAMP_DRAIN_STUN_TIME)

	for(var/datum/wound/wound as anything in simple_wounds)
		wound.set_bleed_rate(0)

	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		for(var/datum/wound/wound as anything in bodypart.wounds)
			wound.set_bleed_rate(0)
		bodypart.bleeding = 0

	bleed_rate = 0
	simple_bleeding = 0

	if(blood_volume < TA_VAMP_DRAIN_MIN_BLOOD_VOLUME)
		blood_volume = TA_VAMP_DRAIN_MIN_BLOOD_VOLUME
		handle_blood()

	adjustOxyLoss(-getOxyLoss())
	remove_status_effect(/datum/status_effect/debuff/bleeding)
	remove_status_effect(/datum/status_effect/debuff/bleedingworse)
	remove_status_effect(/datum/status_effect/debuff/bleedingworst)
	updatehealth()
	return TRUE

/mob/living/carbon/human/proc/ta_offer_death_gift(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker)
	if(QDELETED(src) || !mind || !istype(VDrinker) || !VDrinker.ta_can_offer_death_gift())
		return FALSE

	var/list/options = list()
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_darksight))
		options += TA_DEATH_GIFT_DARKSIGHT_NAME
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_power))
		options += TA_DEATH_GIFT_POWER_NAME
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_berserk))
		options += TA_DEATH_GIFT_BERSERK_NAME

	if(!length(options))
		return FALSE

	var/use_byond_alert = stat != CONSCIOUS || InCritical()
	var/choice = tgui_alert(
		src,
		"Темное создание иссушило вашу душу и тело, но ваша воля позволила вам преодолеть его проклятье.\n\nВыберите темный дар, который вы похитите.",
		"ДАР СМЕРТИ",
		options,
		2 MINUTES,
		strict_byond = use_byond_alert,
		ui_state = GLOB.tgui_always_state
	)

	if(QDELETED(src) || !mind || !istype(VDrinker) || !VDrinker.ta_can_offer_death_gift())
		return FALSE

	if(!choice || !(choice in options))
		return FALSE

	if(!ta_apply_death_gift(choice, sire))
		return FALSE

	VDrinker.ta_record_death_gift()
	return TRUE

/mob/living/carbon/human/proc/ta_apply_death_gift(choice, mob/living/carbon/human/sire)
	switch(choice)
		if(TA_DEATH_GIFT_DARKSIGHT_NAME)
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_darksight))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_darksight)
			to_chat(src, span_notice("Мои глаза раскрываются для ночи. Темнота больше не прячет от меня мир."))
			return TRUE
		if(TA_DEATH_GIFT_POWER_NAME)
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_power))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_power)
			to_chat(src, span_notice("Темная сила наполняет мое тело и разум."))
			return TRUE
		if(TA_DEATH_GIFT_BERSERK_NAME)
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_berserk))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_berserk)
			to_chat(src, span_notice("В глубине крови просыпается ярость, готовая поднять меня на ноги в час смерти."))
			return TRUE
	return FALSE

/datum/status_effect/buff/ta_death_gift_darksight
	id = "ta_death_gift_darksight"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_darksight

/datum/status_effect/buff/ta_death_gift_darksight/on_apply()
	. = ..()
	if(.)
		RegisterSignal(owner, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(apply_undead_sight))
		owner.update_sight()

/datum/status_effect/buff/ta_death_gift_darksight/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_UPDATE_SIGHT)
		owner.update_sight()
	return ..()

/datum/status_effect/buff/ta_death_gift_darksight/proc/apply_undead_sight(mob/living/source)
	SIGNAL_HANDLER
	var/obj/item/organ/eyes/night_vision/zombie/undead_eyes = /obj/item/organ/eyes/night_vision/zombie
	source.see_in_dark = max(source.see_in_dark, initial(undead_eyes.see_in_dark))
	var/undead_lighting_alpha = initial(undead_eyes.lighting_alpha)
	if(!isnull(undead_lighting_alpha))
		source.lighting_alpha = min(source.lighting_alpha, undead_lighting_alpha)

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_darksight
	name = "Дар темного прозрения"
	desc = "Мои глаза идеально видят в темноте, подобно созданиям ночи."
	icon_state = "buff"

/datum/status_effect/buff/ta_death_gift_power
	id = "ta_death_gift_power"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_power
	var/extra_stat
	var/extra_stat_amount = 0

/datum/status_effect/buff/ta_death_gift_power/on_creation(mob/living/new_owner)
	var/list/candidates = list(STATKEY_STR, STATKEY_SPD, STATKEY_INT)
	extra_stat = pick(candidates)
	extra_stat_amount = (extra_stat == STATKEY_INT) ? 2 : 1
	effectedstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)
	effectedstats[extra_stat] += extra_stat_amount
	return ..()

/datum/status_effect/buff/ta_death_gift_power/on_apply()
	. = ..()
	if(!.)
		return
	switch(extra_stat)
		if(STATKEY_STR)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается в моих мышцах."))
		if(STATKEY_SPD)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается в моей скорости."))
		if(STATKEY_INT)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается ясностью ума."))

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_power
	name = "Дар силы"
	desc = "Темная сила укрепляет мое тело и разум."
	icon_state = "buff"

/datum/status_effect/buff/ta_death_gift_berserk
	id = "ta_death_gift_berserk"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_berserk

/datum/status_effect/buff/ta_death_gift_berserk/on_apply()
	. = ..()
	if(. && ishuman(owner))
		owner.AddComponent(/datum/component/ta_death_gift_berserk)

/datum/status_effect/buff/ta_death_gift_berserk/on_remove()
	if(owner)
		var/datum/component/ta_death_gift_berserk/berserk = owner.GetComponent(/datum/component/ta_death_gift_berserk)
		if(berserk)
			qdel(berserk)
	return ..()

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_berserk
	name = "Дар берсерка"
	desc = "Сильные раны могут пробудить во мне великую ярость."
	icon_state = "buff"

/datum/status_effect/debuff/ta_death_gift_tired
	id = "ta_death_gift_tired"
	duration = TA_DEATH_GIFT_TIRED_DURATION
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_death_gift_tired

/atom/movable/screen/alert/status_effect/debuff/ta_death_gift_tired
	name = "Tired"
	desc = "Темная ярость исчерпала меня. Я валюсь с ног от усталости."
	icon_state = "sleepy"

/datum/component/ta_death_gift_berserk
	var/active = FALSE
	var/end_time = 0
	var/applied_frenzy_visuals = FALSE
	var/gibbing = FALSE
	var/silver_hits_taken = 0
	var/silver_hits_to_break = 0

/datum/component/ta_death_gift_berserk/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_unarmed_attack))
	RegisterSignal(parent, COMSIG_ITEM_ATTACKED_SUCCESS, PROC_REF(on_item_attacked_success))
	START_PROCESSING(SSprocessing, src)

/datum/component/ta_death_gift_berserk/Destroy()
	var/mob/living/carbon/human/owner = parent
	if(active && istype(owner))
		set_berserk_traits(owner, FALSE)
	UnregisterSignal(parent, list(COMSIG_MOB_STATCHANGE, COMSIG_LIVING_DEATH, COMSIG_MOB_ATTACK_HAND, COMSIG_ITEM_ATTACKED_SUCCESS))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/ta_death_gift_berserk/process()
	var/mob/living/carbon/human/owner = parent
	if(!istype(owner) || QDELETED(owner))
		qdel(src)
		return

	if(active)
		if(owner.stat == DEAD || !owner.get_bodypart(BODY_ZONE_HEAD))
			ta_bloody_gib(owner)
			return
		keep_berserk_upright(owner)
		if(world.time >= end_time)
			end_berserk(owner)
			return
		owner.frenzy_target = find_berserk_target(owner)
		owner.clear_frenzy_cache()
		return

	if(can_start_berserk(owner))
		start_berserk(owner)

/datum/component/ta_death_gift_berserk/proc/can_start_berserk(mob/living/carbon/human/owner)
	if(!istype(owner) || owner.stat == DEAD || active)
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/debuff/sleepytime) || owner.has_status_effect(/datum/status_effect/debuff/ta_death_gift_tired))
		return FALSE
	if(!owner.get_bodypart(BODY_ZONE_HEAD))
		return FALSE
	return owner.InCritical()

/datum/component/ta_death_gift_berserk/proc/start_berserk(mob/living/carbon/human/owner)
	active = TRUE
	end_time = world.time + TA_DEATH_GIFT_BERSERK_DURATION
	applied_frenzy_visuals = !HAS_TRAIT(owner, TRAIT_IN_FRENZY)
	silver_hits_taken = 0
	silver_hits_to_break = rand(TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN, TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX)

	set_berserk_traits(owner, TRUE)

	if(applied_frenzy_visuals)
		owner.add_client_colour(/datum/client_colour/glass_colour/red)
		GLOB.frenzy_list |= owner

	owner.a_intent = INTENT_HARM
	owner.ta_stabilize_death_gift_body(FALSE)
	keep_berserk_upright(owner)
	owner.frenzy_target = find_berserk_target(owner)
	owner.clear_frenzy_cache()
	owner.visible_message(span_userdanger("[owner] поднимается в кровавой ярости!"), span_userdanger("Темная ярость окутала мой разум. Я ГОТОВ ПОГУБИТЬ ЭТОТ МИР."))

/datum/component/ta_death_gift_berserk/proc/end_berserk(mob/living/carbon/human/owner, broken_by_silver = FALSE)
	active = FALSE
	set_berserk_traits(owner, FALSE)
	owner.ta_stabilize_death_gift_body(FALSE)
	owner.apply_status_effect(/datum/status_effect/debuff/ta_death_gift_tired)
	owner.clear_frenzy_cache()
	if(broken_by_silver)
		owner.visible_message(span_warning("Серебро гасит темную ярость [owner]."), span_userdanger("Серебро прожигает мою ярость и бросает меня обратно в слабость."))
	else
		owner.visible_message(span_warning("[owner] содрогается и падает после вспышки темной ярости."), span_warning("Темная ярость отпускает меня, оставляя изнурение."))

/datum/component/ta_death_gift_berserk/proc/set_berserk_traits(mob/living/carbon/human/owner, enabled)
	var/static/list/berserk_traits = list(
		TRAIT_IN_FRENZY,
		TRAIT_SLEEPIMMUNE,
		TRAIT_STUNIMMUNE,
		TRAIT_NOSOFTCRIT,
		TRAIT_NOHARDCRIT,
		TRAIT_NOCRITDAMAGE,
		TRAIT_IGNOREDAMAGESLOWDOWN,
	)
	for(var/trait in berserk_traits)
		if(enabled)
			ADD_TRAIT(owner, trait, TA_DEATH_GIFT_SOURCE)
		else
			REMOVE_TRAIT(owner, trait, TA_DEATH_GIFT_SOURCE)
	if(applied_frenzy_visuals && !HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		owner.remove_client_colour(/datum/client_colour/glass_colour/red)
		GLOB.frenzy_list -= owner
	if(!enabled)
		applied_frenzy_visuals = FALSE

/datum/component/ta_death_gift_berserk/proc/keep_berserk_upright(mob/living/carbon/human/owner)
	owner.remove_CC(FALSE)
	owner.setStaminaLoss(0)
	owner.a_intent = INTENT_HARM
	owner.updatehealth()
	owner.update_mobility()

/datum/component/ta_death_gift_berserk/proc/find_berserk_target(mob/living/carbon/human/owner, mob/living/excluded_target = null)
	var/mob/living/best_target = null
	var/best_dist = INFINITY
	for(var/mob/living/possible_target in oviewers(7, owner))
		if(possible_target == owner || possible_target == excluded_target || possible_target.stat == DEAD)
			continue
		var/current_dist = get_dist(owner, possible_target)
		if(current_dist < best_dist)
			best_target = possible_target
			best_dist = current_dist
	if(best_target)
		return best_target
	if(excluded_target && !QDELETED(excluded_target) && excluded_target.stat != DEAD)
		return excluded_target
	return null

/datum/component/ta_death_gift_berserk/proc/on_stat_change(mob/living/carbon/human/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(active || new_stat == DEAD)
		return
	if(can_start_berserk(source))
		start_berserk(source)

/datum/component/ta_death_gift_berserk/proc/on_death(mob/living/carbon/human/source, gibbed)
	SIGNAL_HANDLER
	if(active && !gibbed)
		ta_bloody_gib(source)

/datum/component/ta_death_gift_berserk/proc/on_item_attacked_success(mob/living/carbon/human/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(!active || source != owner || !ta_is_silver_weapon(weapon))
		return
	silver_hits_taken++
	if(silver_hits_taken < silver_hits_to_break)
		to_chat(owner, span_userdanger("Серебро вгрызается в темную ярость. Еще немного, и оно погасит ее."))
		return
	end_berserk(owner, TRUE)

/datum/component/ta_death_gift_berserk/proc/ta_is_silver_weapon(obj/item/weapon)
	var/static/list/silver_smeltresults = list(
		/obj/item/ingot/silver,
		/obj/item/ingot/aaslag,
		/obj/item/ingot/aalloy,
		/obj/item/ingot/purifiedaalloy,
	)
	if(!istype(weapon))
		return FALSE
	if(weapon.is_silver || weapon.is_lesser_silver)
		return TRUE
	return weapon.smeltresult in silver_smeltresults

/datum/component/ta_death_gift_berserk/proc/on_unarmed_attack(mob/living/carbon/human/source, mob/living/carbon/human/attacker, mob/living/target, datum/martial_art/attacker_style)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(!active || source != owner || attacker != owner || !isliving(target) || target == owner || target.stat == DEAD)
		return
	if(!istype(owner.used_intent, INTENT_HARM))
		return

	var/zone = check_zone(owner.zone_selected)
	if(!zone)
		zone = BODY_ZONE_CHEST
	target.apply_damage(TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, BRUTE, zone, forced = TRUE)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(zone)
		affecting?.bodypart_attacked_by(BCLASS_BLUNT, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, zone, crit_message = TRUE, armor = 0)
	else
		target.simple_woundcritroll(BCLASS_BLUNT, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, zone, crit_message = TRUE)

	var/push_dir = get_dir(owner, target)
	if(push_dir)
		var/turf/throw_target = get_ranged_target_turf(target, push_dir, TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE)
		target.safe_throw_at(throw_target, TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE, 1, owner, force = MOVE_FORCE_STRONG)

	owner.frenzy_target = find_berserk_target(owner, target)
	owner.clear_frenzy_cache()

/datum/component/ta_death_gift_berserk/proc/ta_bloody_gib(mob/living/carbon/human/owner)
	if(gibbing || !istype(owner) || QDELETED(owner))
		return
	gibbing = TRUE
	owner.visible_message(span_userdanger("[owner] разрывается кровавыми ошметками, когда темная ярость пожирает тело!"))
	owner.gib(FALSE, FALSE, FALSE)

#undef TA_DEATH_GIFT_DARKSIGHT_NAME
#undef TA_DEATH_GIFT_POWER_NAME
#undef TA_DEATH_GIFT_BERSERK_NAME
#undef TA_DEATH_GIFT_SOURCE
#undef TA_DEATH_GIFT_BERSERK_DURATION
#undef TA_DEATH_GIFT_TIRED_DURATION
#undef TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE
#undef TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE
#undef TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN
#undef TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX
