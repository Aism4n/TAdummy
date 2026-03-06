// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\demonic.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven/demonic
	name = "Demonic"
	desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
	icon_state = "daimonion"
	clan_restricted = FALSE
	power_type = /datum/coven_power/demonic

/datum/coven_power/demonic
	name = "Demonic power name"
	desc = "Demonic power description"

//SENSE THE SIN
/datum/coven_power/demonic/deny_the_mother
	name = "Deny the Mother"
	desc = "Immunity to being set on fire for twenty seconds."

	level = 1
	research_cost = 0
	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 10 SECONDS

/datum/coven_power/demonic/deny_the_mother/activate()
	return
/datum/coven_power/demonic/deny_the_mother/deactivate()
	return
/datum/coven_power/demonic/fear_of_the_void_below
	name = "Fear of the Void"
	desc = "Short burst of speed and resilience."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	vitae_cost = 75
	violates_masquerade = FALSE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 1 MINUTES

/datum/coven_power/demonic/fear_of_the_void_below/activate()
	return
/datum/coven_power/demonic/fear_of_the_void_below/deactivate()
	return
//CONFLAGRATION
/datum/coven_power/demonic/conflagration
	name = "Conflagration"
	desc = "Turn your hands into deadly claws."

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	vitae_cost = 250

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 40 SECONDS
	cooldown_length = 1 MINUTES

/datum/coven_power/demonic/conflagration/activate()
	return
/datum/coven_power/demonic/conflagration/deactivate()
	return
//PSYCHOMACHIA
/datum/coven_power/demonic/psychomachia
	name = "Psychomachia"
	desc = "Set your foes on fire with a fireball."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/demonic/psychomachia/post_gain()
	return
/obj/effect/proc_holder/spell/invoked/projectile/fireball/baali
	name = "Infernal Fireball"
	desc = "This spell fires an explosive fireball at a target."
	school = "evocation"
	recharge_time = 60 SECONDS
	invocation_type = "whisper"
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue
	associated_skill = /datum/skill/magic/blood
	sound = 'sound/magic/fireball.ogg'

//CONDEMNTATION
/datum/coven_power/demonic/wall_of_fire
	name = "Wall of Fire"
	desc = "Firebolt? Fireball? No. Wall of Fire!"
	level = 5
	research_cost = 4
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE
	range = 10
	vitae_cost = 250
	cooldown_length = 120 SECONDS
	violates_masquerade = TRUE
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	var/initialized_curses = FALSE
	var/list/curse_names = list()
	var/list/curses = list()

/datum/coven_power/demonic/wall_of_fire/activate(atom/target)
	return
/datum/coven_power/demonic/wall_of_fire/proc/wall_of_fire()
	return
/obj/item/rogueweapon/gangrel
	name = "claws"
	desc = ""
	experimental_inhand = FALSE
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/special/claws.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/claws_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/claws_righthand.dmi'
	icon_state = "claws"
	max_blade_int = 900
	max_integrity = 900
	force = 11
	wdefense = 9
	armor_penetration = 100
	block_chance = 20
	associated_skill = /datum/skill/magic/blood
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	//masquerade_violating = TRUE

