// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\coven_action.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/action/coven
	check_flags = NONE
	background_icon_state = "spell" //And this is the state for the background icon
	button_icon_state = "coven" //And this is the state for the action icon
	button_icon = 'icons/mob/actions/vampspells.dmi'
	icon_icon = 'icons/mob/actions/vampspells.dmi'

	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/coven/coven
	var/targeting = FALSE
	var/active = FALSE

/datum/action/coven/New(target, datum/coven/coven)
	return
/datum/action/coven/Grant(mob/M)
	return
/datum/action/coven/proc/register_to_availability_signals()
	return
/datum/action/coven/proc/update_mob_buttons()
	return
/datum/action/coven/UpdateButtonIcon(status_only, force)
	return
/datum/action/coven/IsAvailable()
	return
/datum/action/coven/Trigger(trigger_flags)
	return
/datum/action/coven/proc/switch_level(to_advance = 1)
	return
/datum/action/coven/proc/end_targeting()
	return
/datum/action/coven/proc/handle_click(mob/source, atom/target, click_parameters)
	return
/datum/action/coven/proc/begin_targeting()
	return
/atom/movable/screen/movable/action_button/Click(location, control, params)
	return
