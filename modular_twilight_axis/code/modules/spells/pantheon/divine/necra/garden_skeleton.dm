#define NECRA_GARDEN_HOWL_MIN 8 SECONDS
#define NECRA_GARDEN_HOWL_MAX 18 SECONDS
#define NECRA_GARDEN_LIFESPAN 5 MINUTES
#define MOVESPEED_ID_NECRA_GARDEN "necra_garden_swift"

/datum/ai_controller/human_npc/necra_garden
	planning_subtrees = list(
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/kick_attack,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/leap_attack,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
	)

/mob/living/carbon/human/species/skeleton/npc/necra_garden
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/necra_garden
	ai_controller = /datum/ai_controller/human_npc/necra_garden
	pass_flags = PASSCLOSEDTURF

/mob/living/carbon/human/species/skeleton/npc/necra_garden/after_creation()
	..()
	pass_flags |= PASSCLOSEDTURF
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STUNIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	add_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN, multiplicative_slowdown = -1.0)
	add_filter("necra_garden_aura", 2, list("type" = "outline", "color" = "#dcdcdc", "alpha" = 220, "size" = 1.5))
	add_filter("necra_garden_glow", 1, list("type" = "drop_shadow", "color" = "#c8c8c8a8", "size" = 2.5, "offset" = 0))
	addtimer(CALLBACK(src, PROC_REF(necra_garden_howl)), rand(2 SECONDS, 5 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(necra_garden_expire)), NECRA_GARDEN_LIFESPAN)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_howl()
	if(QDELETED(src))
		return
	if(stat != DEAD)
		playsound(get_turf(src), 'sound/effects/ghost.ogg', 70, TRUE)
	addtimer(CALLBACK(src, PROC_REF(necra_garden_howl)), rand(NECRA_GARDEN_HOWL_MIN, NECRA_GARDEN_HOWL_MAX))

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/aggro_at(atom/target)
	if(QDELETED(src) || QDELETED(target) || stat == DEAD)
		return
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
		ai_controller.set_ai_status(AI_STATUS_ON)
		ai_controller.CancelActions()

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_purge_inventory()
	var/list/to_delete = list()
	for(var/obj/item/I in get_equipped_items(include_pockets = TRUE))
		to_delete += I
	for(var/obj/item/I as anything in held_items)
		if(I)
			to_delete += I
	QDEL_LIST(to_delete)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/death(gibbed, nocutscene = FALSE)
	necra_garden_purge_inventory()
	..()
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	qdel(src)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_expire()
	if(QDELETED(src))
		return
	necra_garden_purge_inventory()
	visible_message(span_warning("[src] crumbles into ash as Necra's gardens call it back."))
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	qdel(src)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 14
	H.STASPD = 10
	H.STACON = 12
	H.STAWIL = 16
	H.STAINT = 3
	H.STALUC = 8
	name = "Skeleton"
	if(prob(75))
		head = /obj/item/clothing/head/roguetown/necrahood
	else
		mask = /obj/item/clothing/head/roguetown/necramask
		head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
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
	H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/I in H.get_equipped_items(include_pockets = TRUE))
		ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)
	for(var/obj/item/I as anything in H.held_items)
		if(I)
			ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)
