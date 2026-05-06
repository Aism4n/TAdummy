#define PALLID_BLOOD_INTERVAL (45 MINUTES)
#define PALLID_WITHDRAWAL_REPEAT_INTERVAL (25 MINUTES)
#define PALLID_WITHDRAWAL_TOX_DAMAGE 40
#define PALLID_WITHDRAWAL_ROT_LIMBS 3
#define PALLID_WITHDRAWAL_WEAKNESS_CHANCE 40

/// STATUS EFFECTS

/datum/status_effect/buff/pallid_blood
	id = "pallid_blood"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/pallid_blood
	var/enhanced = FALSE
	var/extra_stat
	var/extra_stat_amount = 0

/datum/status_effect/buff/pallid_blood/on_creation(mob/living/new_owner, enhanced_pallid = FALSE, selected_extra_stat = null, selected_extra_stat_amount = 0)
	enhanced = enhanced_pallid
	if(selected_extra_stat)
		extra_stat = selected_extra_stat
		extra_stat_amount = selected_extra_stat_amount

	effectedstats = list()
	if(enhanced)
		effectedstats = list(
			STATKEY_STR = 1,
			STATKEY_PER = 1,
			STATKEY_INT = 1,
			STATKEY_CON = 1,
			STATKEY_WIL = 1,
			STATKEY_SPD = 1,
			STATKEY_LCK = 1,
		)
	if(extra_stat)
		if(isnull(effectedstats[extra_stat]))
			effectedstats[extra_stat] = 0
		effectedstats[extra_stat] += extra_stat_amount
	return ..()

/datum/status_effect/buff/pallid_blood/str
	id = "pallid_blood_str"
	extra_stat = STATKEY_STR
	extra_stat_amount = 1

/datum/status_effect/buff/pallid_blood/spd
	id = "pallid_blood_spd"
	extra_stat = STATKEY_SPD
	extra_stat_amount = 1

/datum/status_effect/buff/pallid_blood/int
	id = "pallid_blood_int"
	extra_stat = STATKEY_INT
	extra_stat_amount = 2

/atom/movable/screen/alert/status_effect/buff/pallid_blood
	name = "Cursed Blood"
	desc = "Проклятая кровь вампира наделяет меня силой. Мне нужно пить её, чтобы не потерять рассудок."
	icon_state = "buff"

/datum/status_effect/debuff/pallid_withdrawal
	id = "pallid_withdrawal"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/debuff/pallid_withdrawal
	effectedstats = list()

/datum/status_effect/debuff/pallid_withdrawal/on_creation(mob/living/new_owner, list/pallid_buff_stats)
	if(islist(pallid_buff_stats))
		effectedstats = list()
		for(var/stat_key in pallid_buff_stats)
			effectedstats[stat_key] = -pallid_buff_stats[stat_key]
	else
		effectedstats = list(
			STATKEY_STR = -1,
			STATKEY_PER = -1,
			STATKEY_INT = -1,
			STATKEY_CON = -1,
			STATKEY_WIL = -1,
			STATKEY_SPD = -1,
			STATKEY_LCK = -1,
		)
	return ..()

/datum/status_effect/debuff/pallid_withdrawal/on_apply()
	. = ..()
	if(. && prob(PALLID_WITHDRAWAL_WEAKNESS_CHANCE))
		ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, id)

/datum/status_effect/debuff/pallid_withdrawal/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, id)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/pallid_withdrawal
	name = "Blood Withdrawal"
	desc = "Проклятие разъедает моё тело. Мне нужна кровь вампира, пока не стало слишком поздно."
	icon_state = "hunger1"

/// COMPONENT

/datum/component/pallid_addiction
	var/mob/living/carbon/human/sire = null
	var/last_fed_time
	var/buff_path
	var/enhanced = FALSE
	var/extra_stat
	var/extra_stat_amount = 0
	var/list/buff_stats
	var/withdrawal_active = FALSE
	var/next_withdrawal_effect_time = 0

/datum/component/pallid_addiction/Initialize(mob/living/carbon/human/linked_sire, enhanced_pallid = FALSE)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	sire = linked_sire
	enhanced = enhanced_pallid
	last_fed_time = world.time

	var/mob/living/carbon/human/owner = parent

	var/list/candidates = list()
	if(owner.STASTR < 15)
		candidates += STATKEY_STR
	if(owner.STASPD < 15)
		candidates += STATKEY_SPD
	if(owner.STAINT < 17)
		candidates += STATKEY_INT
	if(length(candidates))
		extra_stat = pick(candidates)
		extra_stat_amount = (extra_stat == STATKEY_INT) ? 2 : 1
	else
		extra_stat = STATKEY_LCK
		extra_stat_amount = 1
	buff_path = /datum/status_effect/buff/pallid_blood

	RegisterSignal(parent, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

	START_PROCESSING(SSprocessing, src)

	apply_pallid_buff(owner, TRUE)

/datum/component/pallid_addiction/Destroy()
	UnregisterSignal(parent, list(COMSIG_LIVING_DRINKED_LIMB_BLOOD, COMSIG_LIVING_DEATH))
	STOP_PROCESSING(SSprocessing, src)
	var/mob/living/carbon/human/owner = parent
	if(istype(owner))
		owner.remove_status_effect(buff_path)
		owner.remove_status_effect(/datum/status_effect/debuff/pallid_withdrawal)
	return ..()

/datum/component/pallid_addiction/proc/apply_pallid_buff(mob/living/carbon/human/owner, announce = FALSE)
	if(!istype(owner) || !buff_path)
		return null

	var/datum/status_effect/buff/pallid_blood/buff = owner.has_status_effect(buff_path)
	if(!buff)
		buff = owner.apply_status_effect(buff_path, enhanced, extra_stat, extra_stat_amount)
	if(buff?.effectedstats)
		buff_stats = buff.effectedstats.Copy()

	if(!announce)
		return buff

	switch(extra_stat)
		if(STATKEY_STR)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной силой."))
		if(STATKEY_SPD)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной скоростью."))
		if(STATKEY_INT)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной ясностью ума."))
		else
			to_chat(owner, span_notice("Проклятая кровь разливается по телу противоестественной мощью."))
	return buff

/datum/component/pallid_addiction/proc/clear_pallid_withdrawal(mob/living/carbon/human/owner)
	if(!istype(owner))
		return
	owner.remove_status_effect(/datum/status_effect/debuff/pallid_withdrawal)
	withdrawal_active = FALSE
	next_withdrawal_effect_time = 0

/datum/component/pallid_addiction/proc/apply_withdrawal_effects(mob/living/carbon/human/owner)
	if(!istype(owner))
		return
	owner.apply_damage(PALLID_WITHDRAWAL_TOX_DAMAGE, TOX, forced = TRUE)
	apply_random_rot(PALLID_WITHDRAWAL_ROT_LIMBS)
	to_chat(owner, span_userdanger("Недостаток вампирской крови травит меня и заставляет плоть гнить."))

/datum/component/pallid_addiction/proc/on_drink_blood(mob/living/drinker, mob/living/victim)
	SIGNAL_HANDLER

	if(victim != sire)
		return

	last_fed_time = world.time

	var/mob/living/carbon/human/owner = parent
	if(!istype(owner))
		return

	if(withdrawal_active)
		clear_pallid_withdrawal(owner)

	if(!owner.has_status_effect(buff_path))
		apply_pallid_buff(owner)

/datum/component/pallid_addiction/proc/on_death()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/pallid_addiction/proc/apply_random_rot(rot_count = 1)
	var/mob/living/carbon/human/owner = parent
	if(!istype(owner))
		return

	var/list/valid_limbs = list()
	for(var/obj/item/bodypart/B in owner.bodyparts)
		if(!B.rotted && !B.skeletonized && B.is_organic_limb())
			valid_limbs += B

	if(!length(valid_limbs))
		return

	for(var/i in 1 to rot_count)
		if(!length(valid_limbs))
			break
		var/obj/item/bodypart/target_limb = pick(valid_limbs)
		valid_limbs -= target_limb
		target_limb.rotted = TRUE
		to_chat(owner, span_userdanger("Я чувствую как гниль расползается по моей [target_limb.name]!"))

	owner.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)
	owner.update_body()

/datum/component/pallid_addiction/process()
	var/mob/living/carbon/human/owner = parent
	if(!istype(owner) || owner.stat == DEAD || QDELETED(owner))
		return

	var/time_since_fed = world.time - last_fed_time

	if(time_since_fed < PALLID_BLOOD_INTERVAL)
		return

	if(!withdrawal_active)
		withdrawal_active = TRUE
		owner.remove_status_effect(buff_path)
		owner.apply_status_effect(/datum/status_effect/debuff/pallid_withdrawal, buff_stats)
		to_chat(owner, span_userdanger("Мне нужна кровь вампира или лекарство, иначе я превращусь в умертвие. Я чувствую как проклятие ползёт по моим венам."))

	if(world.time >= next_withdrawal_effect_time)
		apply_withdrawal_effects(owner)
		next_withdrawal_effect_time = world.time + PALLID_WITHDRAWAL_REPEAT_INTERVAL

#undef PALLID_BLOOD_INTERVAL
#undef PALLID_WITHDRAWAL_REPEAT_INTERVAL
#undef PALLID_WITHDRAWAL_TOX_DAMAGE
#undef PALLID_WITHDRAWAL_ROT_LIMBS
#undef PALLID_WITHDRAWAL_WEAKNESS_CHANCE
