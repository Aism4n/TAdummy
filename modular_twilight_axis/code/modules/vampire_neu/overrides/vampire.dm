// Late-include TA vampire supplement.
// Requires upstream code/modules/vampire_neu/vampire.dm to already be included.
// THRALLS_* are provided by ./vampires_defines.dm and cleaned up by
// ./TA_Vampires_uniclude.dm when using TA_Vampires_include.dm.

/datum/antagonist/vampire/on_gain()
	. = ..()

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