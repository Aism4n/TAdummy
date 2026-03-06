// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\spells\transfix_neu.dm
// Loaded after upstream to shadow vampire proc implementations.

/obj/effect/proc_holder/spell/targeted/transfix_neu
	name = "Transfix"
	overlay_state = "transfix"

	associated_skill = /datum/skill/magic/blood

	range = 7
	chargetime = 0
	releasedrain = 100
	recharge_time = 15 SECONDS

	/// Ignore crosses and give a different message
	var/powerful = FALSE
	/// Willpower divisor from INT
	var/int_divisor = 3.3
	/// Faces of blood die
	var/blood_dice = 9
	/// Faces of will die
	var/will_dice = 6

	var/transfix_msg

/obj/effect/proc_holder/spell/targeted/transfix_neu/choose_targets(mob/user = usr)
	return
/obj/effect/proc_holder/spell/targeted/transfix_neu/cast(list/targets, mob/user = usr)
	return
