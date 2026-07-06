/*
 * Quietus rework ported from Azure-Peak/Azure-Peak#7383.
 *
 * Custom types are TA-prefixed where possible. Existing Quietus paths are
 * overridden only at the late module include point.
 */

#define TA_BLOODBLADE_BONUS 10
#define TA_BLOODBLADE_HITS 3
#define TA_BLOODBLADE_DURATION (30 SECONDS)

/atom/movable/screen/alert/status_effect/debuff/ta_black_vitae
	name = "Bloodrot"
	desc = span_bloody("BLACKENED ROT SEEPS INTO MY WOUNDS! EVERYTHING HURTS!")
	icon_state = "ritesexpended"

/datum/status_effect/debuff/ta_black_vitae
	id = "ta_black_vitae"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_black_vitae
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	var/applied_physiology_modifiers = FALSE
	var/temporary_colour = rgb(67, 67, 67)

/datum/status_effect/debuff/ta_black_vitae/on_apply()
	. = ..()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/target = owner
	var/datum/physiology/physiology = target.physiology
	physiology.bleed_mod *= 1.5
	physiology.pain_mod *= 1.5
	applied_physiology_modifiers = TRUE
	target.add_atom_colour(temporary_colour, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/ta_black_vitae/on_remove()
	if(iscarbon(owner))
		var/mob/living/carbon/target = owner
		if(applied_physiology_modifiers)
			var/datum/physiology/physiology = target.physiology
			physiology.bleed_mod /= 1.5
			physiology.pain_mod /= 1.5
		target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, temporary_colour)
	return ..()

/datum/component/ta_bloodblade
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/hits_remaining = 0
	var/original_colour
	var/timeout_timer

/datum/component/ta_bloodblade/Initialize()
	if(!istype(parent, /obj/item/rogueweapon))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/rogueweapon/weapon = parent
	hits_remaining = TA_BLOODBLADE_HITS
	original_colour = weapon.color
	weapon.force += TA_BLOODBLADE_BONUS
	weapon.force_wielded += TA_BLOODBLADE_BONUS
	weapon.update_force_dynamic()
	weapon.color = "#6b2828"
	weapon.add_filter("ta_bloodblade", 2, list("type" = "outline", "color" = "#000000", "alpha" = 200, "size" = 1))
	timeout_timer = addtimer(CALLBACK(src, PROC_REF(timeout)), TA_BLOODBLADE_DURATION, TIMER_STOPPABLE)

/datum/component/ta_bloodblade/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/ta_bloodblade/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_AFTERATTACK, COMSIG_PARENT_EXAMINE))

/datum/component/ta_bloodblade/Destroy()
	if(timeout_timer)
		deltimer(timeout_timer)
		timeout_timer = null

	if(istype(parent, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/weapon = parent
		weapon.force -= TA_BLOODBLADE_BONUS
		weapon.force_wielded -= TA_BLOODBLADE_BONUS
		weapon.update_force_dynamic()
		weapon.color = original_colour
		weapon.remove_filter("ta_bloodblade")

	return ..()

/datum/component/ta_bloodblade/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	SIGNAL_HANDLER
	if(!proximity_flag)
		return

	hits_remaining--
	if(hits_remaining <= 0)
		qdel(src)

/datum/component/ta_bloodblade/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_red("It is covered in sickly, black vitae. [hits_remaining] empowered strike[hits_remaining == 1 ? "" : "s"] remain.")

/datum/component/ta_bloodblade/proc/timeout()
	timeout_timer = null
	qdel(src)

// SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	duration_length = 20 SECONDS
	silence_range = 7

/datum/coven_power/quietus/silence_of_death/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILENT_FOOTSTEPS))
		ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!HAS_TRAIT(target, TRAIT_DEAF))
		ADD_TRAIT(target, TRAIT_DEAF, "quietus")
	if(target.confused < 5)
		target.confused += 1

// SCORPION'S TOUCH
/datum/coven_power/quietus/scorpions_touch
	desc = "Use vitae to make wounds bleed faster and hurt more."

/datum/coven_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.put_in_hands(new /obj/item/melee/touch_attack/quietus(owner))

/obj/item/melee/touch_attack/quietus
	desc = "Vile, black vitae dribbling down a hand, ready to seep into a wound."
	color = COLOR_ALMOST_BLACK
	catchphrase = ""
	on_use_sound = 'sound/magic/heartbeat.ogg'

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/debuff/ta_black_vitae)
		living_target.visible_message(span_warning("[living_target]'s wounds begin to fester and rot!"))
		to_chat(living_target, span_danger("WHAT ACHES NOW SEETHES WITH AGONY! EVERYTHING HURTS MORE!"))
	return ..()

// DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	level = 3
	research_cost = 2
	vitae_cost = 200
	minimal_generation = null
	cooldown_length = 120 SECONDS

/datum/coven_power/quietus/dagons_call/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/last_attacker = owner.lastattacker_weakref?.resolve()
	if(isliving(last_attacker))
		return TRUE

	if(alert)
		to_chat(owner, span_warning("I have no recent attacker to curse."))
	return FALSE

/datum/coven_power/quietus/dagons_call/activate()
	. = ..()
	var/mob/living/last_attacker = owner.lastattacker_weakref?.resolve()
	if(!isliving(last_attacker))
		return FALSE

	owner.emote("snap", forced = TRUE)
	playsound(last_attacker, 'sound/magic/heartbeat.ogg', 40, FALSE)
	last_attacker.reagents?.add_reagent(/datum/reagent/bloodacid, 3)
	to_chat(owner, span_notice("I send my curse into [last_attacker], the last creature to attack me."))

// BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	desc = "Impale yourself to empower a sharp weapon for three strikes and poison its first victim."
	level = 4
	research_cost = 3
	vitae_cost = 250
	target_type = NONE
	range = 0

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(!istype(target_weapon))
		if(alert)
			to_chat(owner, span_warning("[src] requires a weapon in my active hand."))
		return FALSE
	if(!target_weapon.sharpness)
		if(alert)
			to_chat(owner, span_warning("[src] can only empower a sharp weapon."))
		return FALSE
	return TRUE

/datum/coven_power/quietus/baals_caress/activate(obj/item/rogueweapon/ignored_target)
	. = ..()
	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(!istype(target_weapon) || !target_weapon.sharpness)
		return FALSE

	if(!do_after(owner, 1 SECONDS, target = target_weapon))
		to_chat(owner, span_warning("The blood rite was interrupted!"))
		return FALSE

	var/datum/component/ta_bloodblade/existing_coating = target_weapon.GetComponent(/datum/component/ta_bloodblade)
	owner.visible_message(span_danger("[owner] impales themselves with [target_weapon]!"))
	playsound(owner, 'sound/combat/wound_tear.ogg', 100, TRUE, -2)

	if(!do_after(owner, 2 SECONDS, target = target_weapon) || owner.get_active_held_item() != target_weapon)
		to_chat(owner, span_warning("The blood rite was interrupted!"))
		return FALSE

	if(existing_coating)
		qdel(existing_coating)
	playsound(owner, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
	target_weapon.AddComponent(/datum/component/ta_bloodblade)
	target_weapon.AddElement(/datum/element/one_time_poison, list(/datum/reagent/bloodacid = 1))
	return TRUE

// TASTE OF DEATH
/datum/coven_power/quietus/taste_of_death
	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE

/obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	invocations = list(" lobs a glob of acid!")
	invocation_type = "emote"

/obj/projectile/magic/acidsplash/quietus
	damage = 40
	flag = "acid"

/obj/projectile/magic/acidsplash/quietus/on_hit(atom/target, blocked = FALSE)
	. = ..()
	for(var/mob/living/carbon/victim in range(aoe_range, get_turf(src)))
		victim.reagents?.add_reagent(/datum/reagent/bloodacid, 1)

#undef TA_BLOODBLADE_BONUS
#undef TA_BLOODBLADE_HITS
#undef TA_BLOODBLADE_DURATION
