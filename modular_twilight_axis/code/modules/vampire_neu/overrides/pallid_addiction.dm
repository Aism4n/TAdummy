#define PALLID_BLOOD_INTERVAL (60 MINUTES)
#define PALLID_ROT_FIRST_INTERVAL (15 MINUTES)
#define PALLID_ROT_REPEAT_INTERVAL (45 MINUTES)

/// STATUS EFFECTS

/datum/status_effect/buff/pallid_blood
	id = "pallid_blood"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/pallid_blood

/datum/status_effect/buff/pallid_blood/str
	id = "pallid_blood_str"
	effectedstats = list(STATKEY_STR = 1)

/datum/status_effect/buff/pallid_blood/spd
	id = "pallid_blood_spd"
	effectedstats = list(STATKEY_SPD = 1)

/datum/status_effect/buff/pallid_blood/int
	id = "pallid_blood_int"
	effectedstats = list(STATKEY_INT = 2)

/datum/status_effect/buff/pallid_blood/lck
	id = "pallid_blood_lck"
	effectedstats = list(STATKEY_LCK = 1)

/atom/movable/screen/alert/status_effect/buff/pallid_blood
	name = "Cursed Blood"
	desc = "Проклятая кровь вампира наделяет меня силой. Мне нужно пить её, чтобы не потерять рассудок."
	icon_state = "buff"

/datum/status_effect/debuff/pallid_withdrawal
	id = "pallid_withdrawal"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/debuff/pallid_withdrawal
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1, STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/pallid_withdrawal
	name = "Blood Withdrawal"
	desc = "Проклятие разъедает моё тело. Мне нужна кровь вампира, пока не стало слишком поздно."
	icon_state = "hunger1"

/// COMPONENT

/datum/component/pallid_addiction
	var/mob/living/carbon/human/sire = null
	var/last_fed_time
	var/buff_path
	var/withdrawal_active = FALSE
	var/last_rot_time
	var/first_rot_done = FALSE

/datum/component/pallid_addiction/Initialize(mob/living/carbon/human/linked_sire)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	sire = linked_sire
	last_fed_time = world.time
	last_rot_time = world.time

	var/mob/living/carbon/human/owner = parent

	var/list/candidates = list()
	if(owner.STASTR < 15)
		candidates += /datum/status_effect/buff/pallid_blood/str
	if(owner.STASPD < 15)
		candidates += /datum/status_effect/buff/pallid_blood/spd
	if(owner.STAINT < 17)
		candidates += /datum/status_effect/buff/pallid_blood/int
	if(length(candidates))
		buff_path = pick(candidates)
	else
		buff_path = /datum/status_effect/buff/pallid_blood/lck

	RegisterSignal(parent, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

	START_PROCESSING(SSprocessing, src)

	owner.apply_status_effect(buff_path)
	switch(buff_path)
		if(/datum/status_effect/buff/pallid_blood/str)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной силой."))
		if(/datum/status_effect/buff/pallid_blood/spd)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной скоростью."))
		if(/datum/status_effect/buff/pallid_blood/int)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной ясностью ума."))
		if(/datum/status_effect/buff/pallid_blood/lck)
			to_chat(owner, span_notice("Проклятая кровь наделяет меня противоестественной удачей."))

/datum/component/pallid_addiction/Destroy()
	UnregisterSignal(parent, list(COMSIG_LIVING_DRINKED_LIMB_BLOOD, COMSIG_LIVING_DEATH))
	STOP_PROCESSING(SSprocessing, src)
	var/mob/living/carbon/human/owner = parent
	if(istype(owner))
		owner.remove_status_effect(buff_path)
		owner.remove_status_effect(/datum/status_effect/debuff/pallid_withdrawal)
	return ..()

/datum/component/pallid_addiction/proc/on_drink_blood(mob/living/drinker, mob/living/victim)
	SIGNAL_HANDLER

	if(victim != sire)
		return

	last_fed_time = world.time
	last_rot_time = world.time

	var/mob/living/carbon/human/owner = parent
	if(!istype(owner))
		return

	if(withdrawal_active)
		owner.remove_status_effect(/datum/status_effect/debuff/pallid_withdrawal)
		withdrawal_active = FALSE
		first_rot_done = FALSE

	if(!owner.has_status_effect(buff_path))
		owner.apply_status_effect(buff_path)

/datum/component/pallid_addiction/proc/on_death()
	SIGNAL_HANDLER
	qdel(src)

/datum/component/pallid_addiction/proc/apply_random_rot()
	var/mob/living/carbon/human/owner = parent
	if(!istype(owner))
		return

	var/list/valid_limbs = list()
	for(var/obj/item/bodypart/B in owner.bodyparts)
		if(!B.rotted && !B.skeletonized && B.is_organic_limb())
			valid_limbs += B

	if(!length(valid_limbs))
		return

	var/obj/item/bodypart/target_limb = pick(valid_limbs)
	target_limb.rotted = TRUE
	owner.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)
	owner.update_body()

	to_chat(owner, span_userdanger("Я чувствую как гниль расползается по моей [target_limb.name]!"))

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
		owner.apply_status_effect(/datum/status_effect/debuff/pallid_withdrawal)
		to_chat(owner, span_userdanger("Мне нужна кровь вампира или лекарство, иначе я превращусь в умертвие. Я чувствую как проклятие ползёт по моим венам."))

	var/rot_interval = first_rot_done ? PALLID_ROT_REPEAT_INTERVAL : PALLID_ROT_FIRST_INTERVAL
	var/time_since_rot = world.time - last_rot_time
	if(time_since_rot >= rot_interval)
		apply_random_rot()
		last_rot_time = world.time
		first_rot_done = TRUE

#undef PALLID_BLOOD_INTERVAL
#undef PALLID_ROT_FIRST_INTERVAL
#undef PALLID_ROT_REPEAT_INTERVAL
