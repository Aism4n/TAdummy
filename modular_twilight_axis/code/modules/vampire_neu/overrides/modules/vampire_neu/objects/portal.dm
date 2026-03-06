// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\objects\portal.dm
// Loaded after upstream to shadow vampire proc implementations.

/obj/structure/vampire/portalmaker
	name = "Rift Gate"
	icon_state = "obelisk"
	var/sending = FALSE

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	return
/obj/structure/vampire/portal
	name = "Eerie Portal"
	icon_state = "portal"
	var/duration = 999
	var/spawntime = null
	density = FALSE

/obj/structure/vampire/portal/Initialize()
	return
/obj/structure/vampire/portal/proc/delete()
	return
/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	return
/obj/structure/vampire/portal/sending
	name = "Eerie Portal"
	icon_state = "portal"
	duration = 999
	spawntime = null
	var/turf/destloc

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	return
/obj/structure/vampire/portal/sending/Destroy()
	return
/obj/structure/vampire/portalmaker/proc/create_portal_return(aname,duration)
	return
/obj/structure/vampire/portalmaker/proc/create_portal(choice,duration)
	return
/obj/item/clothing/neck/portalamulet
	name = "Gate Amulet"
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'
	var/uses = 3

/obj/item/clothing/neck/portalamulet/Initialize()
	return
/obj/item/clothing/neck/portalamulet/Destroy()
	return
/* DISABLED FOR NOW
/obj/item/clothing/neck/portalamulet/attack_self(mob/user, params)
	return
*/
