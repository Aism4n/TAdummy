#define TA_NOTABLE_BEAUTY "Beauty"
#define TA_NOTABLE_STASH "Stashed Riches"
#define TA_NOTABLE_RESIDENCY "Жительство"
#define TA_NOTABLE_RESIDENCY_LEGACY "Residency"
#define TA_NOTABLE_SHREWD "Shrewd Appraisal"

/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	grant_roundstart_faction_manuscript(H)

/datum/virtue/utility/notable
	extra_choices = list(
		TA_NOTABLE_BEAUTY,
		TA_NOTABLE_STASH,
		TA_NOTABLE_RESIDENCY,
		TA_NOTABLE_SHREWD
	)
	choice_tooltips = list(
		TA_NOTABLE_BEAUTY = "Одна моя внешность облегчает тяготы мира, и в постели я весьма хорош.",
		TA_NOTABLE_STASH = "У меня припрятан кошель на особенно темный день.",
		TA_NOTABLE_RESIDENCY = "Я признанный житель города и имею доступ к одному из его зданий.",
		TA_NOTABLE_SHREWD = "Дает светскую оценку - заклинание, позволяющее понять, сколько богатства у человека при себе и в мейстере."
	)

/datum/virtue/utility/notable/New()
	. = ..()
	extra_choices = extra_choices.Copy()
	choice_tooltips = choice_tooltips.Copy()
	if(!resident_manuscripts_enabled())
		extra_choices -= TA_NOTABLE_RESIDENCY
		choice_tooltips.Remove(TA_NOTABLE_RESIDENCY)

/datum/virtue/utility/notable/proc/is_resident_tavern_role(mob/living/carbon/human/recipient)
	switch(recipient.mind?.assigned_role)
		if("Adventurer", "Mercenary", "Court Agent")
			return TRUE
	return FALSE

/datum/virtue/utility/notable/proc/find_resident_tavern_area()
	for(var/area/A in world)
		if(istype(A, /area/rogue/indoors/town/tavern))
			return A
	return null

/datum/virtue/utility/notable/proc/is_valid_resident_tavern_turf(turf/T, use_dun_filter = FALSE, y_offset = 0)
	if(!T || T.density || T.is_blocked_turf(FALSE))
		return FALSE
	if(use_dun_filter && (T.z != 3 || T.y <= (234 + y_offset)))
		return FALSE
	return TRUE

/datum/virtue/utility/notable/proc/place_resident_in_tavern(mob/living/carbon/human/recipient)
	if(!resident_manuscript_uses_resident_tavern_spawn() || !is_resident_tavern_role(recipient))
		return
	var/area/spawn_area = find_resident_tavern_area()
	if(!spawn_area)
		return
	var/use_dun_filter = resident_manuscript_uses_dun_world_tavern_filter()
	var/list/possible_chairs = list()
	for(var/obj/structure/chair/C in spawn_area)
		var/turf/T = get_turf(C)
		if(istype(C, /obj/structure/chair/wood/rogue) && is_valid_resident_tavern_turf(T, use_dun_filter))
			possible_chairs += C
	if(length(possible_chairs))
		var/obj/structure/chair/chosen_chair = pick(possible_chairs)
		recipient.forceMove(get_turf(chosen_chair))
		chosen_chair.buckle_mob(recipient)
		to_chat(recipient, span_notice("Как житель города, вы оказываетесь на стуле в местной таверне."))
		return
	var/list/possible_spawns = list()
	for(var/turf/T in spawn_area)
		if(is_valid_resident_tavern_turf(T, use_dun_filter, 4))
			possible_spawns += T
	if(length(possible_spawns))
		var/turf/spawn_loc = pick(possible_spawns)
		recipient.forceMove(spawn_loc)
		to_chat(recipient, span_notice("Как житель города, вы оказываетесь в местной таверне."))

/datum/virtue/utility/notable/apply_to_human(mob/living/carbon/human/recipient)
	if(!triumph_check(recipient))
		return
	for(var/choice in picked_choices)
		switch(choice)
			if(TA_NOTABLE_BEAUTY)
				ADD_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_GOODLOVER, TRAIT_VIRTUE)
				if(isdullahan(recipient))
					REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_BEAUTIFUL_UNCANNY, TRAIT_VIRTUE)
				recipient.mind?.special_items["Hand Mirror"] = /obj/item/handmirror
			if(TA_NOTABLE_STASH)
				recipient.mind?.special_items["Weighty Coinpurse"] = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
			if(TA_NOTABLE_SHREWD)
				ADD_TRAIT(recipient, TRAIT_SEEPRICES, TRAIT_VIRTUE)
				recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
			if(TA_NOTABLE_RESIDENCY, TA_NOTABLE_RESIDENCY_LEGACY)
				if(resident_manuscripts_enabled())
					ADD_TRAIT(recipient, TRAIT_RESIDENT, TRAIT_VIRTUE)
					grant_roundstart_resident_manuscript(recipient)
					place_resident_in_tavern(recipient)

#undef TA_NOTABLE_BEAUTY
#undef TA_NOTABLE_STASH
#undef TA_NOTABLE_RESIDENCY
#undef TA_NOTABLE_RESIDENCY_LEGACY
#undef TA_NOTABLE_SHREWD
