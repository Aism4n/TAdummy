// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\objects\scrying.dm
// Loaded after upstream to shadow vampire proc implementations.

/obj/structure/vampire/scryingorb // Method of spying on the town
	name = "Eye of Night"
	icon_state = "scrying"

/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	return
/mob/dead/observer/rogue/arcaneeye
	sight = 0
	see_in_dark = 2
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER

	misting = 0
	var/mob/living/carbon/human/vampirelord = null
	icon_state = "arcaneeye"
	draw_icon = FALSE
	hud_type = /datum/hud/eye

/mob/dead/observer/rogue/arcaneeye/proc/scry_tele()
	return
/mob/dead/observer/rogue/arcaneeye/Initialize()
	return
/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry()
	return
/mob/dead/observer/rogue/arcaneeye/Crossed(mob/living/L)
	return
/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy()
	return
/mob/dead/observer/rogue/arcaneeye/proc/eye_up()
	return
/mob/dead/observer/rogue/arcaneeye/proc/eye_down()
	return
/mob/dead/observer/rogue/arcaneeye/Move(NewLoc, direct)
	return
/mob/proc/scry(can_reenter_corpse = 1, force_respawn = FALSE, drawskip)
	return
