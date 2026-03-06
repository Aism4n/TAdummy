// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\covens\coven_powers\_base_power.dm
// Loaded after upstream to shadow vampire proc implementations.

/datum/coven_power
	/// Name of the Discipline power
	var/name = "Discipline power name"
	/// Description of the Discipline power
	var/desc = "Discipline power description"

	/* BASIC INFORMATION */
	/// What rank of the Discipline this Discipline power belongs to.
	var/level = 1
	/// Bitflags determining the requirements to cast this power
	var/check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	/// How many blood points this power costs to activate
	var/vitae_cost = 50
	/// Bitflags determining what types of entities this power is allowed to target. NONE if self-targeting only.
	var/target_type = NONE
	/// How many tiles away this power can be used from.
	var/range = 0
	/// How many DOTS this shit costs
	var/research_cost = 1
	/// Minimal generation of a given vampire
	var/minimal_generation = 0

	/* EXTRA BEHAVIOUR ON ACTIVATION AND DEACTIVATION */
	/// Sound file that plays to the user when this power is activated.
	var/activate_sound
	/// Sound file that plays to the user when this power is deactivated.
	var/deactivate_sound
	/// Sound file that plays to all nearby players when this power is activated.
	var/effect_sound
	/// If this power will upset NPCs when used on them.
	var/aggravating = FALSE
	/// If this power is an aggressive action and logged as such.
	var/hostile = FALSE
	/// If use of this power creates a visible Masquerade breach.
	var/violates_masquerade = FALSE

	/* HOW AND WHEN IT'S ACTIVATED AND DEACTIVATED */
	/// If this Discipline doesn't automatically expire, but rather periodically drains blood.
	var/toggled = FALSE
	/// If this power can be turned on and off.
	var/cancelable = FALSE
	/// If this power can (theoretically, not in reality) have multiple of its effects active at once.
	var/multi_activate = FALSE
	/// Amount of time it takes until this Discipline deactivates itself. 0 if instantaneous.
	var/duration_length = 0
	/// Amount of time it takes until this Discipline can be used again after activation.
	var/cooldown_length = 0
	/// If this power uses its own duration/deactivation handling rather than the default handling
	var/duration_override = FALSE
	/// If this power uses its own cooldown handling rather than the default handling
	var/cooldown_override = FALSE
	/// List of Discipline power types that cannot be activated alongside this power and share a cooldown with it.
	var/list/grouped_powers
	/// Group this Discipline belongs to. Only one discipline of a group may be active at a time. No cooldown is shared.
	var/power_group = COVEN_POWER_GROUP_NONE
	var/cost_system = COVEN_COST_VITAE

	/* NOT MEANT TO BE OVERRIDDEN */
	/// Timer(s) tracking the duration of the power. Can have multiple if multi_activate is true.
	var/list/duration_timers = list()
	/// Timer tracking the cooldown of the power. Starts after deactivation if it has a duration and multi_active isn't true, after activation otherwise.
	var/cooldown_timer
	/// If this Discipline is currently in use.
	var/active = FALSE
	/// The Discipline that this power is part of.
	var/datum/coven/discipline
	/// The player using this Discipline power.
	var/mob/living/carbon/human/owner

	/// Track if the last use was a critical success for XP bonus
	var/last_use_was_critical = FALSE
	/// Track what type of action this was for XP categorization
	var/last_action_context = null
	/// Track the target for context-sensitive XP
	var/last_target = null

	///the gif name we use in the menu
	var/gif

/datum/coven_power/New(datum/coven/discipline)
	return
/**
 * Setter to handle registering of signals.
 */
/datum/coven_power/proc/set_owner(mob/living/carbon/human/new_owner)
	return
/**
 * Proc to handle potential hard dels.
 * Cleans up any remaining references to avoid circular reference memory leaks.
 * The GC will handle the rest.
 */
/datum/coven_power/proc/on_owner_qdel()
	return
/**
 * Returns the time left the cooldown timer, or
 * 0 if there is none. Returning 0 means not on
 * cooldown.
 */
/datum/coven_power/proc/get_cooldown()
	return
/**
 * Returns the highest time left on any duration
 * timers, or 0 if there are none. Returning 0
 * means not active.
 */
/datum/coven_power/proc/get_duration()
	return
/**
 * Returns a boolean of if the caster can afford
 * this power's vitae cost.
 */
/datum/coven_power/proc/can_afford()
	return
/**
 * Returns if this power can currently be activated
 * without accounting for target restrictions.
 *
 * This is where all checks according to check_flags for if a
 * power can be activated that don't concern the target are handled.
 * This is almost entirely checking traits on the owner to see if they're
 * incapacitated or whatnot, but some backend like deactivation
 * is also handled here. This is what's checked to see if the
 * power is selectable or unselectable (red).
 *
 * Arguments:
 * * alert - if this is being checked by the user and should give feedback on why it can't activate.
 */
/datum/coven_power/proc/can_activate_untargeted(alert = FALSE)
	return
/**
 * Activation requirement checking proc that determines
 * if a given target is valid while also checking
 * can_activate_untargeted().
 *
 * When activating a power, this is called to get the final
 * result on if it can be activated or not. It first checks
 * can_activate_untargeted(), then if the power is targeted,
 * it handles logic for determining if a given target is valid
 * according to the given target_type.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * alert - if this is being checked by the user and should give feedback on why it can't activate.
 */
/datum/coven_power/proc/can_activate(atom/target, alert = FALSE)
	return
/**
 * Spends necessary resources (vitae) and makes sure activation is valid
 * before fully activating the power.
 *
 * The intermediary between can_activate() and activate(), this proc spends
 * resources, sends signals, checks an overridable proc to see if it should
 * continue or not, then fully activates the power. This can only fail
 * if an override of pre_activation_checks() or a signal handler forces it to.
 * This is useful for code that should trigger after activation is initiated, but
 * before the effects (probably) start.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/pre_activation(atom/target)
	return
/**
 * An overridable proc that allows for custom pre_activation() behaviour.
 *
 * This is meant to be overridden by powers to allow for extra checks
 * on activation (eg. Social vs. Mentality for mental disciplines), to
 * delay activation with a do_after() (eg. Valeren 5 taking 10 seconds),
 * or possibly to hijack the pre_activation() proc by returning FALSE and
 * using its own logic instead (like activating on several targets in an
 * AoE rather than on one). Don't be fooled by the name, this is not just
 * for checks.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/pre_activation_checks(atom/target)
	return
/**
 * Triggers all the effects of the power being fully activated.
 *
 * An overridable proc where the effects of the power are stored.
 * This being called means that activation has fully succeeded, so
 * duration and cooldown (when multi_activate is true) also begin
 * here. Specific basic activation behaviour (like the sound it makes
 * or the message it logs) can be modified by overriding the relevant
 * proc.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/activate(atom/target)
	return
/datum/coven_power/proc/determine_action_context(atom/target)
	return
/datum/coven_power/proc/check_critical_success(atom/target)
	return
/**
 * Signal handler for members of a power_group to react to the activation of other disciplines.
 */
/datum/coven_power/proc/on_other_power_activate(mob/living/carbon/human/source, datum/coven_power/power, atom/target)
	return
/**
 * Overridable proc handling the sound played to the owner
 * only when using powers.
 */
/datum/coven_power/proc/do_activate_sound()
	return
/**
 * Overridable proc handling the sound caused by the power's
 * effects, audible to everyone around it.
 */
/datum/coven_power/proc/do_effect_sound(atom/target)
	return
/**
 * Overridable proc handling Masquerade violations as a result
 * of using this power amongst NPCs.
 */
/datum/coven_power/proc/do_masquerade_violation(atom/target)
	return
/**
 * Overridable proc handling the spending of resources (vitae/blood)
 * when casting the power. Returns TRUE if successfully spent,
 * returns FALSE otherwise.
 */
/datum/coven_power/proc/spend_resources()
	return
/**
 * Overridable proc handling the message sent to the user when activating
 * the power.
 */
/datum/coven_power/proc/do_caster_notification(target)
	return
/**
 * Overridable proc handling the combat log created by using this power.
 */
/datum/coven_power/proc/do_logging(target)
	return
/**
 * Overridable proc handling the power's duration, which is a timer that triggers the
 * duration_expire proc when it ends, and is saved in duration_timers then deleted and cut
 * when it ends. The duration_override variable stops this from being triggered by activate()
 * and allows for extra modular behaviour. Duration expiring can be done manually by calling
 * try_deactivate(direct = TRUE).
 */
/datum/coven_power/proc/do_duration(atom/target)
	return
/**
 * Overridable proc handling the power's cooldown, which is a timer that triggers the cooldown_expire
 * proc when it ends, and is saved in cooldown_timer. This is called by both activate() and deactivate(),
 * but it only actually starts the cooldown in deactivate() unless multi_activate is TRUE. The
 * cooldown_override variable stops this from being triggered by activate() and deactivate() and allows
 * for extra modular behaviour. Cooldowns can manually be started by calling try_deactivate(), then deltimer()
 * and starting a new cooldown timer with your own length.
 *
 * Arguments:
 * * on_activation - if this proc is being called by activate(), which will stop it from triggering unless multi_activate is true.
 */
/datum/coven_power/proc/do_cooldown(on_activation = FALSE)
	return
/**
 * Checks if activation is possible through can_activate(), then calls pre_activation() if it is.
 * Returns if activation successfully begun or not.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/try_activate(atom/target)
	return
/datum/coven_power/proc/grant_usage_xp(atom/target, is_refresh = FALSE)
	return
/**
 * Overridable proc called by the duration timer to handle
 * duration expiring. Will refresh if toggled, or deactivate
 * otherwise after deleting the timer calling it.
 */
/datum/coven_power/proc/duration_expire(atom/target)
	return
/**
 * Overridable proc called by the cooldown timer to handle
 * cooldown expiring. Has no behaviour besides making the action
 * visibly available again.
 */
/datum/coven_power/proc/cooldown_expire()
	return
/**
 * Overridable proc called by try_deactivate() to make sure that
 * deactivating won't result in a runtime in case of the power
 * targeting the owner with them not existing. The equivalent
 * of can_activate_untargeted().
 */
/datum/coven_power/proc/can_deactivate_untargeted()
	return
/**
 * Overridable proc mirroring can_activate(), making sure
 * that deactivation won't result in a runtime in case of
 * the target not existing anymore while also checking
 * can_deactivate_untargeted(). Also sends signals that
 * allow for manual prevention of deactivation.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/can_deactivate(atom/target)
	return
/**
 * Cancels the effects of the previously activated power.
 *
 * Handles all logic for deactivating the power, including
 * playing the deactivation sound, sending relevant signals,
 * and starting the cooldown. If directly called rather
 * than as a result of duration_expire, this also deletes
 * the relevant duration timer. Still called if duration_length
 * is 0.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * direct - if this is being directly called instead of by duration_expire, and should delete the timer.
 */
/datum/coven_power/proc/deactivate(atom/target, direct = FALSE)
	return
/**
 * Checks if the power can_deactivate() and deactivate()s if it can.
 * Also sends feedback the user if they successfully manually cancel it.
 * The deactivation equivalent of try_activate().
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * direct - if the power is being directly deactivated or as a result of duration_expire.
 * * alert - if the caster is manually deactivating and feedback should be sent on success.
 */
/datum/coven_power/proc/try_deactivate(atom/target, direct = FALSE, alert = FALSE)
	return
/**
 * Overridable proc that allows for code to affect the power's owner
 * when it is gained. Triggered by parent /datum/coven/post_gain().
 */
/datum/coven_power/proc/post_gain()
	return
/**
 * Handles refreshing toggled powers on a loop, spending necessary
 * resources and restarting the duration timer if it can proceed. If
 * it can't proceed, it directly deactivates the power.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/refresh(atom/target)
	return
/**
 * Handles doing effects after a refresh has been spent
 * resources and restarting the duration timer if it can proceed. If
 * it can't proceed, it directly deactivates the power.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/coven_power/proc/on_refresh(atom/target)
	return
/**
 * Overridable proc that allows for extra modular code
 * in refreshing behaviour. Can do custom checks to see if activation
 * proceeds or not (must give its own feedback!) or can hijack
 * the refresh proc for its own behaviour.
 */
/datum/coven_power/proc/do_refresh_checks(atom/target)
	return
/**
 * Clears the last active timer (usually the first in the list).
 * If called before it expires, this immediately makes the
 * duration_timer expire without calling the relevant proc.
 */
/datum/coven_power/proc/clear_duration_timer(to_clear = 1)
	return
/// Trigger discovery XP when using powers in new ways
/datum/coven_power/proc/trigger_discovery_xp(discovery_type)
	return
/// Trigger teaching XP when demonstrating powers to others
/datum/coven_power/proc/trigger_teaching_xp(mob/living/carbon/human/student)
	return
/// Trigger roleplay XP for good character moments
/datum/coven_power/proc/trigger_roleplay_xp(intensity = 1)
	return
/datum/coven_power/proc/setup_xp_hooks()
	return
/// XP trigger for dangerous situations
/datum/coven_power/proc/on_owner_death(mob/living/source)
	return
/// XP trigger for speaking while using social powers
/datum/coven_power/proc/on_owner_speak(mob/living/source, message)
	return
/// XP trigger for being attacked while using defensive powers
/datum/coven_power/proc/on_owner_attacked(mob/living/source, obj/item/weapon)
	return
/datum/coven_power/proc/admin_grant_xp(amount, reason)
	return
/// Admin proc to view XP statistics
/datum/coven_power/proc/admin_view_xp_stats()
	return
