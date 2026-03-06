// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\objects\ichor_fang_stone.dm
// Loaded after upstream to shadow vampire proc implementations.

/obj/structure/ichor_stone
	name = "Bloodstained Stone"
	desc = "Pedestal for your Ichor Fang. It can also recall it!"
	max_integrity = 999999
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig2"

/obj/structure/ichor_stone/attack_hand(mob/living/carbon/human/user)
	return
