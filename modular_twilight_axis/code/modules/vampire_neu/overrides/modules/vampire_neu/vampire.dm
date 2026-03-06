// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\vampire.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/antagonist/vampire
	name = "Vampire"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "Vspawn"
	confess_lines = list(
		"I WANT YOUR BLOOD!",
		"DRINK THE BLOOD!",
		"CHILD OF KAIN!",
	)
	rogue_enabled = TRUE
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE // Base vampire shouldn't be directly selectable - use Vampire Lord or specific subtypes
	var/datum/clan/default_clan = /datum/clan/nosferatu
	// New variables for clan selection
	var/clan_selected = FALSE
	var/custom_clan_name = ""
	var/list/selected_covens = list()
	var/forced = FALSE
	var/datum/clan/forcing_clan
	var/generation
	var/research_points = 10
	var/max_thralls = 1
	var/thrall_count = 0

/datum/antagonist/vampire/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation)
	return
/datum/antagonist/vampire/get_antag_cap_weight()
	return
/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	return
/datum/antagonist/vampire/on_gain()
	return
/datum/antagonist/vampire/proc/show_clan_selection(mob/living/carbon/human/vampdude)
	return
/datum/antagonist/vampire/proc/create_custom_clan(mob/living/carbon/human/vampdude)
	return
/datum/antagonist/vampire/proc/after_gain()
	return
/datum/antagonist/vampire/on_removal()
	return
/datum/antagonist/vampire/proc/equip()
	return
// Custom clan datum for player-created clans
/datum/clan/custom
	name = "Custom Clan"
	selectable_by_vampires = FALSE

/obj/structure/vampire
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	density = TRUE

/obj/structure/vampire/Initialize()
	return
/obj/structure/vampire/Destroy()
	return
// LANDMARKS
/obj/effect/landmark/start/vampirelord
	name = "Vampire Lord"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirelord/Initialize()
	return
/obj/effect/landmark/start/vampirespawn
	name = "Vampire Spawn"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirespawn/Initialize()
	return
/obj/effect/landmark/start/vampireknight
	name = "Death Knight"
	icon_state = "arrow"
	jobspawn_override = list("Death Knight")
	delete_after_roundstart = FALSE

/obj/effect/landmark/vteleport
	name = "Teleport Destination"
	icon_state = "x2"

/obj/effect/landmark/vteleportsending
	name = "Teleport Sending"
	icon_state = "x2"

/obj/effect/landmark/vteleportdestination
	name = "Return Destination"
	icon_state = "x2"
	var/amuletname

/obj/effect/landmark/vteleportsenddest
	name = "Sending Destination"
	icon_state = "x2"

// Prefabs for admin
/datum/antagonist/vampire/thinblood
	name = "Thinblood"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/thinblood/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_THINBLOOD)
	return
/// Similarly as before, just a prefab for admins to give them via Traitor Panel
/datum/antagonist/vampire/licker
	name = "Licker - Neonate"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/licker/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_NEONATE)
	return
/// Just a prefab for admins to give them via Traitor Panel, otherwise unused because vars can be normally passed in parent's New()
/datum/antagonist/vampire/ancillae
	name = "Ancillae"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/ancillae/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_ANCILLAE)
	return
