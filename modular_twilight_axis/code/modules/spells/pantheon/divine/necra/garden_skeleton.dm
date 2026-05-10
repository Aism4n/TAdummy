/mob/living/carbon/human/species/skeleton/npc/necra_garden
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/necra_garden

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/aggro_at(atom/target)
	if(QDELETED(src) || QDELETED(target) || stat == DEAD)
		return
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
		ai_controller.set_ai_status(AI_STATUS_ON)
		ai_controller.CancelActions()

/mob/living/carbon/human/species/skeleton/npc/necra_garden/death(gibbed, nocutscene = FALSE)
	var/list/to_delete = list()
	for(var/obj/item/I in get_equipped_items(include_pockets = TRUE))
		to_delete += I
	for(var/obj/item/I as anything in held_items)
		if(I)
			to_delete += I
	QDEL_LIST(to_delete)
	..()
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	qdel(src)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 11
	H.STASPD = 11
	H.STACON = 6
	H.STAWIL = 9
	H.STAINT = 4
	name = "Skeleton"
	head = /obj/item/clothing/head/roguetown/necrahood
	cloak = /obj/item/clothing/cloak/templar/necran
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	shoes = /obj/item/clothing/shoes/roguetown/boots
	switch(rand(1, 3))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/mace
		if(3)
			r_hand = /obj/item/rogueweapon/spear
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/I in H.get_equipped_items(include_pockets = TRUE))
		ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)
	for(var/obj/item/I as anything in H.held_items)
		if(I)
			ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)
