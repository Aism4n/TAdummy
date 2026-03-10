/proc/log_familytree(text)
	if(!text || !GLOB.log_directory)
		return
	WRITE_LOG("[GLOB.log_directory]/familytree.log", "\[[logtime]] FAMILYTREE: [text]")

/proc/familytree_log_preferences(datum/preferences/P)
	if(!P)
		return "prefs=none"

	var/list/preferred_species = list()
	if(islist(P.preferred_species_types))
		for(var/entry in P.preferred_species_types)
			if(ispath(entry, /datum/species))
				preferred_species += "[entry]"
			else if(istext(entry))
				preferred_species += "[entry]"

	var/preferred_species_text = preferred_species.len ? preferred_species.Join(",") : "none"
	var/setspouse_text = length(P.setspouse) ? P.setspouse : "none"

	return "prefs{family=[P.family]; gender_pref=[P.gender_choice_pref]; species_mode=[P.species_preference_mode]; preferred_species=[preferred_species_text]; anatomy_pref=[P.preferred_species_anatomy]; setspouse=[setspouse_text]}"

/proc/familytree_log_mob(mob/living/carbon/human/H, event, details = null, datum/preferences/P = null)
	var/list/parts = list("event=[event]")

	if(H)
		var/role = H.mind?.assigned_role || H.job || "none"
		var/species_type = H.dna?.species?.type || "none"
		var/ckey_text = H.ckey ? H.ckey : "none"
		var/client_text = H.client ? "connected" : "disconnected"
		var/family_text = H.family_datum ? "[REF(H.family_datum)]" : "none"
		parts += "mob=[H.real_name]([REF(H)])"
		parts += "ckey=[ckey_text]"
		parts += "role=[role]"
		parts += "type=[H.type]"
		parts += "species=[species_type]"
		parts += "client=[client_text]"
		parts += "scheduled=[H.familytree_assignment_scheduled]"
		parts += "family=[family_text]"

	if(P)
		parts += familytree_log_preferences(P)

	if(details)
		parts += details

	log_familytree(parts.Join(" | "))
