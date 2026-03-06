// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\clan_menu.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/clan_menu_interface
	var/mob/living/carbon/human/user
	var/datum/clan/user_clan
	var/list/datum/coven/user_covens
	var/current_coven // Currently selected coven for research view
	var/datum/clan_hierarchy_interface/hierarchy_interface // Hierarchy management
	var/datum/clan_hierarchy_node/selected_position // Currently selected position

	var/datum/coven/coven_one_preliminary
	var/datum/coven/coven_two_preliminary
	var/datum/coven/coven_three_preliminary

/datum/clan_menu_interface/New(mob/living/carbon/human/target_user)
	return
/datum/clan_menu_interface/proc/show_hierarchy()
	return
/datum/clan_menu_interface/proc/generate_interface()
	return
/datum/clan_menu_interface/proc/generate_welcome_screen_html()
	return
/datum/clan_menu_interface/proc/generate_setup_html()
	return
/datum/clan_menu_interface/proc/generate_coven_selection()
	return
/datum/clan_menu_interface/proc/coven_choice()
	return
/datum/clan_menu_interface/proc/generate_coven_list_html()
	return
/datum/clan_menu_interface/proc/generate_combined_html(research_content, in_preview = FALSE)
	return
/datum/clan_menu_interface/proc/load_coven_research_tree(coven_name, preview = FALSE)
	return
/datum/clan_menu_interface/Topic(href, href_list)
	return
