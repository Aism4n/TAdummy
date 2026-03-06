// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\real_clans\abyss.dm
// Loaded after upstream to shadow vampire proc implementations.

/// Baali from aliexpress
/datum/clan/abyss
	name = "Children of the Abyss"
	desc = "The Children of the Abyss are a bloodline of vampires that worship the demons of old. Because of their affinity with the unholy, they are extremely vulnerable to the Church."
	curse = "Fear of the Religion."
	clanicon = "daimonion"
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	covens_to_select = 0

/datum/clan/abyss/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	return
/datum/clan/abyss/get_downside_string()
	return
