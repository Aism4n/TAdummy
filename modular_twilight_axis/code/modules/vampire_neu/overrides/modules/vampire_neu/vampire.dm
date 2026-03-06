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
