/*
 * Central Crimson Curse role compatibility list.
 *
 * Both hooks preserve the base initialization behavior and append to existing
 * restriction lists instead of replacing them.
 */

/datum/job/New()
	..()
	if(length(allowed_races))
		if(!forbidden_races)
			forbidden_races = list()
		forbidden_races |= (ALL_RACES_TYPES - allowed_races)

	var/static/list/crimson_curse_banned_jobs = list(
		/datum/job/roguetown/wretch,
		/datum/job/roguetown/druid,
		/datum/job/roguetown/martyr,
		/datum/job/roguetown/monk,
		/datum/job/roguetown/priest,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/lord,
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/magician,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/knight,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/knight_enigma,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/manorguard,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/warden,
		/datum/job/roguetown/royal_guard,
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/lunatic,
		/datum/job/roguetown/mercenary,
		/datum/job/roguetown/inquisitor,
		/datum/job/roguetown/orthodoxist,
		/datum/job/roguetown/absolver,
		/datum/job/roguetown/assassin,
		/datum/job/roguetown/bandit,
		/datum/job/roguetown/hag,
	)

	if(type in crimson_curse_banned_jobs)
		if(!islist(virtue_restrictions))
			virtue_restrictions = list()
		virtue_restrictions += list(/datum/virtue/combat/crimson_curse)

/datum/advclass/New()
	if(ispath(age_mod) && !istype(age_mod))
		var/datum/class_age_mod/newmod = new age_mod()
		age_mod = newmod
	. = ..()

	var/static/list/crimson_curse_banned_vagabond_classes = list(
		/datum/advclass/vagabond_original,
		/datum/advclass/vagabond_beggar,
		/datum/advclass/vagabond_courier,
		/datum/advclass/vagabond_excommunicated,
		/datum/advclass/vagabond_goatherd,
		/datum/advclass/vagabond_mage,
		/datum/advclass/vagabond_runner,
		/datum/advclass/vagabond_scholar,
		/datum/advclass/vagabond_wanted,
		/datum/advclass/vagabond_unraveled,
		/datum/advclass/vagabond_accursed,
	)

	if(type in crimson_curse_banned_vagabond_classes)
		if(!islist(virtue_limits))
			virtue_limits = list()
		virtue_limits += list(/datum/virtue/combat/crimson_curse)
