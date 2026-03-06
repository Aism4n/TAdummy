// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\objects\bloodpool.dm
// Loaded after upstream to shadow vampire proc implementations.



/obj/structure/vampire/bloodpool
	name = "Crimson Crucible"
	icon_state = "vat"
	var/current = 0
	var/datum/clan/owner_clan

	var/list/active_projects = list()
	var/list/available_project_types = list(
		/datum/vampire_project/power_growth,
		/datum/vampire_project/armor_crafting,
		/datum/vampire_project/servant/servant_t1,
		/datum/vampire_project/servant/servant_t2,
		/datum/vampire_project/servant/servant_t3,
		/datum/vampire_project/sunsteal,
	)
	var/sunstolen = FALSE

/obj/structure/vampire/bloodpool/Initialize()
	return
/obj/structure/vampire/bloodpool/examine(mob/user)
	return
/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	return
/obj/structure/vampire/bloodpool/proc/start_new_project(project_type, mob/living/user)
	return
/obj/structure/vampire/bloodpool/proc/handle_project_contribution(mob/living/user)
	return
/obj/structure/vampire/bloodpool/proc/handle_project_management(mob/living/user)
	return
/obj/structure/vampire/bloodpool/proc/complete_project(project_type)
	return
/obj/structure/vampire/bloodpool/proc/cancel_project(project_type)
	return
/datum/vampire_project
	var/display_name = "Unknown Project"
	var/description = "A mysterious undertaking."
	var/total_cost = 1000
	var/paid_amount = 0
	var/list/contributors = list()
	var/obj/structure/vampire/bloodpool/bloodpool
	var/mob/living/initiator
	var/datum/clan/initiator_clan
	var/start_failure_message = "This project cannot be started."
	var/completion_sound = 'sound/misc/batsound.ogg'
	var/can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/proc/can_start(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool, silent = FALSE)
	return
/datum/vampire_project/proc/confirm_start(mob/living/user)
	return
/datum/vampire_project/proc/on_start(mob/living/user)
	return
/datum/vampire_project/proc/handle_contribution(mob/living/user)
	return
/datum/vampire_project/proc/show_details(mob/living/user)
	return
/datum/vampire_project/proc/on_complete()
	return
/datum/vampire_project/proc/on_cancel()
	return
// Specific project types
/datum/vampire_project/power_growth
	display_name = "Rite of Stirring"
	description = "The ancient blood stirs once more. Forgotten whispers echo through the marrow of the land."
	total_cost = VAMPCOST_ONE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	return
/datum/vampire_project/power_growth/on_complete()
	return
/datum/vampire_project/power_growth_2
	display_name = "Rite of Reclamation"
	description = "Strength long sealed returns. The soil, the stone, and the shadows bend again to their rightful master."
	total_cost = VAMPCOST_TWO
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_2/on_complete()
	return
/datum/vampire_project/power_growth_3
	display_name = "Rite of Dominion"
	description = "The veil of time shreds. The Elder's will pours forth, binding trespassers within the grasp of the Land."
	total_cost = VAMPCOST_THREE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_3/on_complete()
	return
/datum/vampire_project/power_growth_4
	display_name = "Rite of Sovereignty"
	description = "The Lord is whole. Ancient power saturates every stone and vein, for the Land and its master are one."
	total_cost = VAMPCOST_FOUR
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_4/on_complete()
	return
/datum/vampire_project/armor_crafting
	display_name = "Wicked Plate"
	description = "Summon a complete set of vampiric plate armor from crystallized blood. Let not steel, silver, nor salvation inhibit the Lord's plan."
	total_cost = 5000
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/armor_crafting/on_complete(atom/movable/creation_point)
	return
/datum/vampire_project/sunsteal
	display_name = "Steal the Sun"
	description = "The scorching gaze of the Sun-Tyrant shall hamper our plans no more. This project can only be initiated by your Lorde."
	total_cost = SUN_STEAL_COST
	completion_sound = 'sound/misc/vcraft.ogg'
	can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/sunsteal/on_complete(atom/movable/creation_point)
	return
/datum/vampire_project/servant/proc/summon(type, atom/feedback_atom)
	return
/datum/vampire_project/servant/servant_t1
	display_name = "Summon Servant"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t1/on_complete(obj/structure/vampire/bloodpool/creation_point)
	return
/datum/vampire_project/servant/servant_t2
	display_name = "Summon Guard"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_T2_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t2/on_complete(obj/structure/vampire/bloodpool/creation_point)
	return
/datum/vampire_project/servant/servant_t3
	display_name = "Summon Knight Spawn"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_T3_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t3/on_complete(obj/structure/vampire/bloodpool/creation_point)
	return

