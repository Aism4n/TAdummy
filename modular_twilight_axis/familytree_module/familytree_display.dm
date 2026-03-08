/datum/familytree_display_panel
	var/mob/living/carbon/human/viewer
	var/panel_title = "Family"
	var/panel_subtitle = ""
	var/empty_message = "Nothing to show."
	var/list/sections = list()

/datum/familytree_display_panel/New(mob/living/carbon/human/new_viewer, panel_title = "Family", panel_subtitle = "", panel_empty_message = "Nothing to show.")
	. = ..()
	viewer = new_viewer
	src.panel_title = panel_title
	src.panel_subtitle = panel_subtitle
	empty_message = panel_empty_message
	sections = list()

/datum/familytree_display_panel/Destroy(force)
	viewer = null
	sections = null
	return ..()

/datum/familytree_display_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/familytree_display_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FamilyDisplayPanel")
		ui.open()

	return TRUE

/datum/familytree_display_panel/ui_data(mob/user)
	if(user != viewer)
		return list(
			"title" = panel_title,
			"subtitle" = panel_subtitle,
			"emptyMessage" = empty_message,
			"sections" = list(),
		)

	return list(
		"title" = panel_title,
		"subtitle" = panel_subtitle,
		"emptyMessage" = empty_message,
		"sections" = sections,
	)

/datum/familytree_display_panel/ui_close()
	QDEL_NULL(src)

/datum/familytree_display_panel/proc/add_section(section_title, list/entries)
	if(!entries?.len)
		return

	sections += list(list(
		"title" = section_title,
		"entries" = entries,
	))
