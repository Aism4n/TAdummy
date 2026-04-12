// Late-include TA vampire supplement.
// Requires upstream code/modules/vampire_neu/vampire.dm to already be included.
// THRALLS_* are provided by ./vampires_defines.dm and cleaned up by
// ./TA_Vampires_uniclude.dm when using TA_Vampires_include.dm.

/datum/antagonist/vampire
	var/datum/antagonist/vampire/sire_vampire

/datum/antagonist/vampire/on_gain()
	. = ..()

	var/mob/living/carbon/human/H = owner?.current
	if(!istype(H) || !H.mind)
		return

	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/transfix_neu)
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
	H.RemoveSpell(/obj/effect/proc_holder/spell/targeted/transfix_neu)
	H.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/TA_transfix_neu)

	var/static/list/thrall_caps = alist(
		GENERATION_METHUSELAH = THRALLS_METHUSELAH,
		GENERATION_ANCILLAE  = THRALLS_ANCILLAE,
		GENERATION_NEONATE   = THRALLS_NEONATE,
		GENERATION_THINBLOOD = THRALLS_THINBLOOD,
	)

	var/cap = thrall_caps[generation]
	if(isnull(cap))
		cap = THRALLS_DEFAULT

	max_thralls = cap



/datum/antagonist/vampire/on_removal()
	var/mob/living/carbon/human/H = owner?.current
	if(istype(H))
		H.mind?.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
		H.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)

	return ..()

/datum/antagonist/vampire/proc/get_thrall_owner()
	if(sire_vampire && !QDELETED(sire_vampire) && !QDELETED(sire_vampire.owner))
		return sire_vampire.get_thrall_owner()
	return src

/datum/antagonist/vampire/proc/can_sire_thrall()
	if(generation <= GENERATION_THINBLOOD)
		return FALSE

	var/mob/living/carbon/human/H = owner?.current
	if(istype(H) && H.clan_position)
		if(H.clan_position.subordinates.len >= H.clan_position.max_subordinates)
			return FALSE

	var/datum/antagonist/vampire/owner_vamp = get_thrall_owner()
	return owner_vamp.thrall_count < owner_vamp.max_thralls

/datum/antagonist/vampire/proc/register_thrall(datum/antagonist/vampire/new_thrall)
	var/datum/antagonist/vampire/owner_vamp = get_thrall_owner()
	new_thrall.sire_vampire = src
	owner_vamp.thrall_count++

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)

	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Kaine's firstborn!")

	if(istype(examined_datum, /datum/antagonist/vampire))
		var/datum/antagonist/vampire/my_vamp = examiner?.mind?.has_antag_datum(/datum/antagonist/vampire)
		var/datum/antagonist/vampire/target_vamp = examined_datum

		if(examined != examiner && (examined in GLOB.coven_breakers_list) && !istype(target_vamp, /datum/antagonist/vampire/lord))
			return span_userdanger("A breaker of the Masquerade. SHAME!!!")

		if(my_vamp)
			if(my_vamp.generation > target_vamp.generation)
				return span_boldnotice("A child of Kaine.")

			if(my_vamp.generation == target_vamp.generation && prob(10))
				return span_boldnotice("A child of Kaine.")

		return

	if(istype(examined_datum, /datum/antagonist/zombie) || istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")
