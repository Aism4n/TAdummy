/*
 * Crimson Curse interactions adapted from Scarlet-Reach/Scarlet-Reach#1948.
 */

/datum/clan/handle_bloodsuck(mob/living/carbon/human/drinker, blood_types)
	var/unwanted_blood = (blood_types & ~blood_preference & ~BLOOD_PREFERENCE_CC)

	if(blood_types & BLOOD_PREFERENCE_CC)
		drinker.apply_status_effect(/datum/status_effect/buff/ta_crimson_curse_blood)

	if(!unwanted_blood)
		return

	drinker.apply_status_effect(/datum/status_effect/debuff/blood_disgust)
	to_chat(drinker, span_warning("Вкус этой крови отвратителен!"))

/datum/status_effect/buff/ta_crimson_curse_blood
	id = "ta_crimson_curse_blood"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_crimson_curse_blood
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/buff/ta_crimson_curse_blood
	name = "Багровая кровь"
	desc = "Я испил витэ, осквернённую слабым Багровым проклятием."
	icon_state = "bloodheal"

/datum/status_effect/buff/ta_crimson_curse_blood/on_apply()
	. = ..()
	if(.)
		owner.add_stress(/datum/stressevent/ta_nourishing_crimson_blood)

/datum/status_effect/buff/ta_crimson_curse_blood/on_remove()
	owner.remove_stress(/datum/stressevent/ta_nourishing_crimson_blood)
	return ..()

/datum/stressevent/ta_nourishing_crimson_blood
	desc = span_good("Эта проклятая кровь была восхитительна.")
	stressadd = -2
	max_stacks = 10
	stressadd_per_extra_stack = -2
	timer = 10 MINUTES
