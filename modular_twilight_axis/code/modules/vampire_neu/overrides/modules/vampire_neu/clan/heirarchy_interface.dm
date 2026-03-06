// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\heirarchy_interface.dm
// Loaded after upstream to shadow vampire proc implementations.


/datum/clan_hierarchy_interface
	var/mob/living/carbon/human/user
	var/datum/clan/user_clan
	var/datum/clan_hierarchy_node/selected_position

/datum/clan_hierarchy_interface/New(mob/living/carbon/human/target_user)
	return
/datum/clan_hierarchy_interface/proc/can_manage_hierarchy()
	return
/datum/clan_hierarchy_interface/proc/can_manage_position(datum/clan_hierarchy_node/target_position)
	return
/datum/clan_hierarchy_interface/proc/can_create_position_under(datum/clan_hierarchy_node/superior_position)
	return
// This should match the coven research tree structure - Kinda important since it just replaces the dynamic content with it.
/datum/clan_hierarchy_interface/proc/generate_hierarchy_html()
	return
/datum/clan_hierarchy_interface/proc/calculate_hierarchy_positions()
	return
/datum/clan_hierarchy_interface/proc/position_node_and_children(datum/clan_hierarchy_node/node, center_x, y_pos, h_spacing, v_spacing)
	return
/datum/clan_hierarchy_interface/proc/calculate_subtree_width(datum/clan_hierarchy_node/node, h_spacing)
	return
/datum/clan_hierarchy_interface/proc/generate_hierarchy_connections_html()
	return
/datum/clan_hierarchy_interface/proc/generate_hierarchy_nodes_html()
	return
/datum/clan_hierarchy_interface/proc/generate_hierarchy_sidebar()
	return
/datum/clan_hierarchy_interface/proc/generate_position_details_html()
	return
/datum/clan_hierarchy_interface/proc/generate_management_modal()
	return
/datum/clan_hierarchy_interface/proc/show_edit_position_dialog()
	return
/datum/clan_hierarchy_interface/Topic(href, href_list)
	return
/datum/clan_hierarchy_interface/proc/refresh_hierarchy()
	return
/datum/clan_hierarchy_interface/proc/show_create_position_dialog()
	return
/datum/clan_hierarchy_interface/proc/generate_all_position_options()
	return
/datum/clan_hierarchy_interface/proc/show_assign_member_dialog()
	return
/datum/clan_hierarchy_interface/proc/generate_position_options()
	return
/datum/clan_hierarchy_interface/proc/generate_member_options(list/available_members)
	return
/datum/clan_hierarchy_interface/proc/handle_edit_position(list/params)
	return
/datum/clan_hierarchy_interface/proc/handle_create_position(list/params)
	return
/datum/clan_hierarchy_interface/proc/handle_assign_member(list/params)
	return
