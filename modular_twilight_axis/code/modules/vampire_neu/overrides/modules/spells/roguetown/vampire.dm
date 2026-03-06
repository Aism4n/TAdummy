// Generated modular vampire override scaffold.
// Source: code\modules\spells\roguetown\vampire.dm
// Loaded after upstream to shadow vampire proc implementations.

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/Shapeshift(mob/living/carbon/human/caster)
	return
/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	name = "Bat Form"
	desc = "Transform into a nimble bat, capable of flying out of harm's way."
	overlay_state = "bat_transform"
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat

/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	name = "Mist Form"
	desc = "Transform into an impermient cloud of mist, invulnerable to harm and unblocked by most worldly obstructions."
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/gaseousform

/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	name = "Rous Form"
	desc = "Transform into a chittering rous, unblocked by the presence of giants and tables alike."
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat

/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit
	name = "Cabbit Form"
	desc = "Transform into a not-so-unlucky cabbit, swift-footed and hard to catch."
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit

/obj/effect/proc_holder/spell/invoked/vampire_float
	name = "Float"
	desc = "Levitate in the air through the manipulation of vitae, without making so much as a single sound."
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	releasedrain = 1
	chargedrain = 1
	chargetime = 2
	warnie = "spellwarning"
	school = "blood"
	no_early_release = TRUE
	movement_interrupt = FALSE
	invocation_type = "whisper"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic.blood
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_MEDIUM

/obj/effect/proc_holder/spell/invoked/vampire_float/cast(list/targets, mob/living/user)
	return


/datum/status_effect/buff/vampire_float/on_apply()
	return
/datum/status_effect/buff/vampire_float/on_remove()
	return
