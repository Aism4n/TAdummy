// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\clan_leader.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/clan_leader
	var/list/lord_spells = list(
	)
	var/list/lord_verbs = list(
	)
	var/list/lord_traits = list()
	var/lord_title = "Lord"
	var/vitae_bonus = 5 // Extra vitae for lords
	var/ascended = FALSE

/datum/clan_leader/lord
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED)
	lord_title = "Lord"
	vitae_bonus = 500 // Extra vitae for lords
	ascended = FALSE

/datum/clan_leader/wretch
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_title = "Lord"
	ascended = FALSE

/datum/clan_leader/proc/make_new_leader(mob/living/carbon/human/H)
	return
/datum/clan_leader/proc/remove_leader(mob/living/carbon/human/H)
	return
