// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_unlock_menu.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven_research_node
	var/name = "Research Node"
	var/desc = "A research node description"
	var/list/prerequisites = list()
	var/research_cost = 10
	var/required_level = 1
	var/minimal_generation = 0
	var/unlocks_power = null
	var/special_effect = null
	var/node_x = 0
	var/node_y = 0
	var/icon = 'icons/effects/clan.dmi'
	var/icon_state = "research_node"

	var/showcase_gif = null
	var/gif_width = 160
	var/gif_height = 160

/datum/coven_research_interface
	var/datum/coven/parent_coven
	var/mob/living/carbon/human/user
	var/list/research_nodes = list()
	var/list/available_research = list()


/datum/coven_research_interface/New(datum/coven/coven)
	return
/datum/coven_research_interface/proc/initialize_coven_tree()
	return
/datum/coven_research_interface/proc/get_research_node(research_type)
	return
/datum/coven_research_interface/proc/unlock_research_node(research_type)
	return
/datum/coven_research_interface/proc/get_available_research()
	return
/datum/coven_research_interface/proc/generate_coven_connections_html()
	return
/datum/coven_research_interface/proc/generate_coven_nodes_html()
	return
/datum/coven_research_interface/proc/get_experience_percentage()
	return
/datum/coven_research_interface/Topic(href, href_list)
	return
// Additional utility functions
/datum/coven_research_interface/proc/get_node_icon_state(datum/coven_research_node/node)
	return
/datum/coven_research_interface/proc/calculate_optimal_layout()
	return
