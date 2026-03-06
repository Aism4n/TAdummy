// Generated modular vampire override scaffold.
// Source: code\datums\components\vampire_disguise.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/component/vampire_disguise
	/// Current disguise state
	var/disguised = FALSE
	/// Cached appearance for disguise
	var/cache_skin
	var/cache_eyes
	var/cache_hair
	var/cache_facial
	var/cache_boobs
	var/cache_ears
	/// Transform cooldown
	/// Bloodpool cost per life tick while disguised
	var/disguise_upkeep = 0
	/// Minimum bloodpool required to maintain disguise
	var/min_bloodpool = 50

/datum/component/vampire_disguise/Initialize(upkeep = 0, min_blood = 50)
	return
/datum/component/vampire_disguise/proc/cache_original_appearance(mob/living/carbon/human/H)
	return
/datum/component/vampire_disguise/proc/handle_disguise_upkeep(mob/living/carbon/human/source)
	return
/datum/component/vampire_disguise/proc/apply_disguise(mob/living/carbon/human/H)
	return
/datum/component/vampire_disguise/proc/remove_disguise(mob/living/carbon/human/H)
	return
/datum/component/vampire_disguise/proc/force_undisguise(mob/living/carbon/human/H)
	return
/datum/component/vampire_disguise/proc/disguise_status()
	return
/datum/component/vampire_disguise/nosferatu
	var/original_ear_accessory_type
	var/original_ear_accessory_colors

/datum/component/vampire_disguise/nosferatu/cache_original_appearance(mob/living/carbon/human/H)
	return
/datum/component/vampire_disguise/nosferatu/apply_disguise(mob/living/carbon/human/H)
	return
