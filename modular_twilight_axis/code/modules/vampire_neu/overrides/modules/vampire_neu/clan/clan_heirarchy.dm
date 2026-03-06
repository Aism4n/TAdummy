// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\clan_heirarchy.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/clan_hierarchy_node
	var/name = "Position"
	var/desc = "A position within the clan hierarchy"
	var/mob/living/carbon/human/assigned_member
	var/datum/clan_hierarchy_node/superior // Who this position reports to
	var/list/datum/clan_hierarchy_node/subordinates = list() // Who reports to this position
	var/rank_level = 0 // 0 = leader, higher numbers = lower ranks
	var/max_subordinates = 5 // Maximum number of direct reports
	var/can_assign_positions = FALSE // Can this position create/assign sub-positions
	var/position_color = "#ffffff"
	var/node_x = 0
	var/node_y = 0
	var/mutable_appearance/cloned_look

/datum/clan_hierarchy_node/New(position_name, position_desc, level = 1)
	return
/datum/clan_hierarchy_node/proc/assign_member(mob/living/carbon/human/member)
	return
/datum/clan_hierarchy_node/proc/remove_member()
	return
/datum/clan_hierarchy_node/proc/add_subordinate(datum/clan_hierarchy_node/subordinate)
	return
/datum/clan_hierarchy_node/proc/remove_subordinate(datum/clan_hierarchy_node/subordinate)
	return
/datum/clan_hierarchy_node/proc/get_all_subordinates()
	return
/datum/clan_hierarchy_node/proc/get_all_superiors()
	return
/datum/clan_hierarchy_node/proc/get_subordinates_at_depth(depth = 1)
	return
/datum/clan_hierarchy_node/proc/get_hierarchy_root()
	return
/datum/clan_hierarchy_node/proc/get_total_subordinate_count()
	return
/datum/clan_hierarchy_node/proc/is_superior_to(datum/clan_hierarchy_node/other)
	return
/datum/clan_hierarchy_node/proc/is_subordinate_to(datum/clan_hierarchy_node/other)
	return
/datum/action/clan_hierarchy
	check_flags = NONE
	background_icon_state = "spell"
	button_icon_state = "command"
	var/cooldown = 0
	var/cooldown_time = 100
	var/sound/activation_sound

/datum/action/clan_hierarchy/IsAvailable()
	return
/datum/action/clan_hierarchy/proc/start_cooldown()
	return
// Command Subordinate Action
/datum/action/clan_hierarchy/command_subordinate
	name = "Command Subordinate"
	desc = "Give a telepathic command to a subordinate."
	button_icon_state = "command"
	cooldown_time = 100

/datum/action/clan_hierarchy/command_subordinate/IsAvailable()
	return
/datum/action/clan_hierarchy/command_subordinate/Trigger(trigger_flags)
	return
/obj/effect/temp_visual/vamp_teleport
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune_teleport"
	duration = 2 SECONDS

/obj/effect/temp_visual/vamp_summon
	icon = 'icons/effects/clan.dmi'
	icon_state = "teleport"
	duration = 2 SECONDS

/obj/effect/temp_visual/vamp_summon/end
	icon_state = "teleport_trigger"

// Summon Subordinate Action
/datum/action/clan_hierarchy/summon_subordinate
	name = "Summon Subordinate"
	desc = "Command a subordinate to come to your location immediately."
	button_icon_state = "summon"
	cooldown_time = 300

/datum/action/clan_hierarchy/summon_subordinate/IsAvailable()
	return
/datum/action/clan_hierarchy/summon_subordinate/Trigger(trigger_flags)
	return
/datum/action/clan_hierarchy/summon_subordinate/proc/finish_teleport(mob/living/user, mob/living/target, turf/target_turf)
	return
// Mass Command Action
/datum/action/clan_hierarchy/mass_command
	name = "Mass Command"
	desc = "Send a telepathic message to all your subordinates."
	button_icon_state = "mass_command"
	cooldown_time = 600

/datum/action/clan_hierarchy/mass_command/IsAvailable()
	return
/datum/action/clan_hierarchy/mass_command/Trigger(trigger_flags)
	return
// Locate Subordinate Action
/datum/action/clan_hierarchy/locate_subordinate
	name = "Locate Subordinate"
	desc = "Sense the location of your subordinates."
	button_icon_state = "locate"
	cooldown_time = 200

/datum/action/clan_hierarchy/locate_subordinate/IsAvailable()
	return
/datum/action/clan_hierarchy/locate_subordinate/Trigger(trigger_flags)
	return
