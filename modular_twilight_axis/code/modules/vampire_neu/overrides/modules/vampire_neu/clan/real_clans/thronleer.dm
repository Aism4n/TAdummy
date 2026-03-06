// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\real_clans\thronleer.dm
// Loaded after upstream to shadow vampire proc implementations.


/datum/clan_leader/thronleer
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED)
	vitae_bonus = 500
	lord_title = "Elder"

/datum/clan/thronleer
	name = "House Thronleer"
	desc = "House Thronleer is a secretive, tradition‑bound clan that favors ritual, subtlety, and guile."
	curse = "Weakness of the soul."
	clanicon = "bloodheal"
	blood_preference = BLOOD_PREFERENCE_FANCY
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	leader = /datum/clan_leader/thronleer
	covens_to_select = 0

/datum/clan/thronleer/get_blood_preference_string()
	return
/datum/clan/thronleer/get_downside_string()
	return
/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	return
