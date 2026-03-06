// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\_base_coven.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven
	///Name of this Coven.
	var/name = "Coven name"
	///Text description of this Coven.
	var/desc = "Coven description"
	///Icon for this Coven as in Covens.dmi
	var/icon_state
	///If this Coven is unique to a certain Clan.
	var/clan_restricted = FALSE
	///The root type of the powers this Coven uses.
	var/power_type = /datum/coven_power

	/* LEVELING SYSTEM */
	///What rank, or how many dots the caster has in this Coven.
	var/level = 1
	///Maximum level this coven can reach
	var/max_level = 5
	///Current experience points in this coven
	var/experience = 0
	///Experience needed to reach next level
	var/experience_needed = 100
	///Experience multiplier for each level (gets harder to level)
	var/experience_multiplier = 1.25

	/* BACKEND */
	///What rank of this Coven is currently being casted.
	var/level_casting = 1
	///The power that is currently in use.
	var/datum/coven_power/current_power
	///All Coven powers under this Coven that the owner knows. LIST OF INSTANCES, NOT TYPES.
	var/list/datum/coven_power/known_powers = list()
	///The typepaths of possible powers for every rank in this Coven.
	var/all_powers = list()
	///The mob that owns and is using this Coven.
	var/mob/living/carbon/human/owner
	///If this Coven has been assigned before and post_gain effects have already been applied.
	var/post_gain_applied

	///our coven action
	var/datum/action/coven/coven_action

	///Associated research interface for this coven's power tree
	var/datum/coven_research_interface/research_interface
	///List of research nodes unlocked for this coven
	var/list/unlocked_research = list()
	///Current research points available to spend
	var/research_points = 10

	///Base XP gain for successful power use
	var/base_power_xp = 10
	///XP multiplier for higher level powers
	var/power_level_multiplier = 1.5
	///XP gain for discovering new things or unique actions
	var/discovery_xp = 25
	///XP gain for teaching others or mentoring
	var/teaching_xp = 15
	///XP gain for critical successes
	var/critical_success_xp = 20

/datum/coven/New(level)
	return
/**
 * Helper proc to initialize powers for a given level
 * This ensures we don't duplicate code between New() and set_level()
 */
/datum/coven/proc/initialize_powers_for_level(target_level)
	return
/**
 * Modifies a Coven's level, updating its available powers
 * to conform to the new level. This proc will be removed when
 * power loadouts are implemented, but for now it's useful for dynamically
 * adding and removing powers.
 *
 * Arguments:
 * * level - the level to set the Coven as, powers included
 */
/datum/coven/proc/set_level(level)
	return
/**
 * Assigns the Coven to a mob, setting its owner and applying
 * post_gain effects.
 *
 * Arguments:
 * * new_owner - the mob to assign the Coven to
 */
/datum/coven/proc/assign(mob/new_owner)
	return
/**
 * Proc to handle potential hard dels.
 * Cleans up any remaining references to avoid circular reference memory leaks.
 * The GC will handle the rest.
 */
/datum/coven/proc/on_owner_qdel()
	return
/**
 * Returns a known Coven power in this Coven
 * searching by type.
 *
 * Arguments:
 * * power_type - the power type to search for
 */
/datum/coven/proc/get_power(power_type)
	return
/**
 * Check if we already have a power of this type
 */
/datum/coven/proc/has_power(power_type)
	return
/**
 * Applies effects specific to the Coven to
 * its owner. Also triggers post_gain effects of all
 * known (possessed) powers. Meant to be overridden
 * for modular code.
 */
/datum/coven/proc/post_gain()
	return
/datum/coven/proc/initialize_research_tree()
	return
/datum/coven/proc/gain_experience(amount)
	return
/datum/coven/proc/check_level_up()
	return
/datum/coven/proc/level_up()
	return
/datum/coven/proc/unlock_power_from_tree(research_type)
	return
/**
 * Unified power granting system with different sources
 * FIXED: Now properly checks for existing powers and manages instances correctly
 *
 * Arguments:
 * * power_type - The type of power to grant
 * * source - How the power was obtained ("level_unlock", "research", "discovery", "teaching", "special")
 * * silent - Whether to suppress messages
 */
/datum/coven/proc/grant_power(power_type, source = "unknown", silent = FALSE)
	return
/datum/coven/proc/apply_research_effect(effect_type)
	return
/**
 * Main XP gain function with multiple sources
 *
 * Arguments:
 * * amount - Base XP amount
 * * source - What caused the XP gain
 * * power_used - If from power use, which power
 * * multiplier - Additional multiplier
 */
/datum/coven/proc/gain_experience_from_source(amount, source, datum/coven_power/power_used = null, multiplier = 1)
	return
/**
 * XP gain triggers for various game events
 */

// Called when a power is successfully used
/datum/coven/proc/on_power_use_success(datum/coven_power/power, is_critical = FALSE, exp_multiplier = 1, vitae_spent = 0)
	return
// Called when player discovers something new about their coven
/datum/coven/proc/on_discovery_event(discovery_type)
	return
// Called when player teaches someone else
/datum/coven/proc/on_teaching_event(mob/student, datum/coven_power/power_taught)
	return
// Called during meditation or study actions
/datum/coven/proc/on_meditation_complete(duration_minutes)
	return
// Called when powers are used in combat
/datum/coven/proc/on_combat_power_use(datum/coven_power/power, target)
	return
// Called for good roleplay moments
/datum/coven/proc/on_roleplay_moment(intensity = 1)
	return
/**
 * Power discovery system - allows finding powers through experimentation
 */
/datum/coven/proc/attempt_power_discovery(experimentation_type)
	return
