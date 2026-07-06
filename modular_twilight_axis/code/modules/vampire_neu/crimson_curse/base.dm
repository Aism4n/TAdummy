/*
 * Crimson Curse core adapted from Scarlet-Reach/Scarlet-Reach#1734, using
 * the final reduced trait set from Scarlet-Reach/Scarlet-Reach#1948.
 */

/datum/clan_leader/strays
	lord_spells = list()
	lord_verbs = list()
	lord_traits = list()
	lord_title = "Старейшина"
	vitae_bonus = 0

/datum/clan/strays
	name = "Отверженные"
	desc = "Носители слабого вампирского проклятия, обретённого через тёмные ритуалы или злонамеренные чары. Они не способны создавать порождений или поглощать витэ вместе с люксом."
	curse = "Бесцельность"
	blood_preference = BLOOD_PREFERENCE_ALL
	clane_traits = list(
		TRAIT_NOHUNGER,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_NOBREATH,
		TRAIT_NOPAINSTUN,
		TRAIT_TOXIMMUNE,
		TRAIT_NOSLEEP,
		TRAIT_VAMP_DREAMS,
		TRAIT_SILVER_WEAK,
		TRAIT_CRIMSON_CURSE,
	)
	clane_covens = list()
	leader = /datum/clan_leader/strays
	covens_to_select = 0
	selectable_by_vampires = FALSE

/datum/clan/strays/setup_vampire_abilities(mob/living/carbon/human/H)
	add_verb(H, /mob/living/carbon/human/proc/disguise_verb)
	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 1, TRUE)

/datum/clan/strays/handle_member_joining(mob/living/carbon/human/H, is_vampire = TRUE)
	return FALSE

/datum/clan/strays/post_gain(mob/living/carbon/human/H)
	// Strays have no clan leader, but the base hook is mandatory.
	var/datum/clan_leader/configured_leader = leader
	leader = null
	. = ..()
	leader = configured_leader

/datum/clan/strays/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()

	var/datum/action/clan_menu/clan_action = locate(/datum/action/clan_menu) in H.actions
	QDEL_NULL(clan_action)

	if(H.covens && H.covens["Bloodheal"])
		H.remove_coven("Bloodheal", silent = TRUE)

	H.ta_remove_vampire_transfix()

	var/datum/component/vampire_disguise/disguise = H.GetComponent(/datum/component/vampire_disguise)
	disguise?.apply_disguise(H)

/datum/antagonist/vampire/stray
	name = "Проклятый изгой"
	antag_hud_type = null
	antag_hud_name = null
	default_clan = /datum/clan/strays
	clan_selected = TRUE
	research_points = 0
	max_thralls = 0
	var/ta_constitution_penalty_applied = FALSE

/datum/antagonist/vampire/stray/New(incoming_clan = /datum/clan/strays, forced_clan = FALSE, generation = GENERATION_FAILVAMP)
	. = ..(incoming_clan, forced_clan, generation)

/datum/antagonist/vampire/stray/on_gain()
	. = ..()
	research_points = 0
	max_thralls = 0

	var/mob/living/carbon/human/H = owner?.current
	if(istype(H) && !ta_constitution_penalty_applied)
		H.change_stat(STATKEY_CON, -1)
		ta_constitution_penalty_applied = TRUE

/datum/antagonist/vampire/stray/on_removal()
	var/mob/living/carbon/human/H = owner?.current
	if(istype(H) && ta_constitution_penalty_applied)
		H.change_stat(STATKEY_CON, 1)
		ta_constitution_penalty_applied = FALSE
	return ..()

/datum/antagonist/vampire/stray/get_antag_cap_weight()
	return 0

/datum/antagonist/vampire/stray/add_antag_hud(antag_hud_type, antag_hud_name, mob/living/mob_override)
	return

/datum/virtue/combat/second_chance/check_triumphs(mob/living/carbon/human/recipient)
	var/datum/preferences/preferences = recipient.client?.prefs
	if(istype(preferences?.virtue, /datum/virtue/combat/crimson_curse) || istype(preferences?.virtuetwo, /datum/virtue/combat/crimson_curse))
		to_chat(recipient, span_warning("Багровое проклятие слишком сильно! Добродетель «Второй шанс» не может повлиять на меня!"))
		return FALSE
	return ..()

/datum/virtue/combat/crimson_curse
	name = "Багровое проклятие"
	desc = "Я несу слабую форму вампиризма, полученную через тёмный ритуал или жестокое проклятие. Я не способен создавать порождений или поглощать витэ вместе с люксом."
	custom_text = span_bloody("ВЫНОСЛИВОСТЬ снижена на 1. Солнечный свет ослабляет меня, а серебро остаётся моей погибелью. Несовместимо с добродетелью «Второй шанс».")

/datum/virtue/combat/crimson_curse/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return

	ADD_TRAIT(recipient, TRAIT_CRIMSON_CURSE, "ta_crimson_pending")
	addtimer(CALLBACK(src, PROC_REF(apply_crimson_curse), recipient), 3 SECONDS)

/datum/virtue/combat/crimson_curse/proc/apply_crimson_curse(mob/living/carbon/human/recipient)
	if(QDELETED(recipient) || !recipient.mind)
		return

	var/datum/antagonist/vampire/existing_vampire = recipient.mind.has_antag_datum(/datum/antagonist/vampire)
	if(existing_vampire)
		if(istype(recipient.mind.picked_advclass, /datum/advclass/vagabond_thrall))
			existing_vampire.generation = GENERATION_THINNERBLOOD
			existing_vampire.research_points = 0
			existing_vampire.max_thralls = 0
			recipient.ta_apply_vagabond_vampire_rules()
			remove_verb(recipient, /mob/living/carbon/human/proc/disguise_verb)
			var/datum/component/vampire_disguise/disguise = recipient.GetComponent(/datum/component/vampire_disguise)
			if(disguise)
				qdel(disguise)
		REMOVE_TRAIT(recipient, TRAIT_CRIMSON_CURSE, "ta_crimson_pending")
		return

	var/datum/antagonist/vampire/stray/new_antag = new /datum/antagonist/vampire/stray(
		incoming_clan = /datum/clan/strays,
		forced_clan = FALSE,
		generation = GENERATION_FAILVAMP,
	)
	recipient.mind.add_antag_datum(new_antag)
	REMOVE_TRAIT(recipient, TRAIT_CRIMSON_CURSE, "ta_crimson_pending")
