// Generated modular vampire override scaffold.
// Source: code\modules\vampire_neu\clan\_base_clan.dm
// Loaded after upstream to shadow vampire proc implementations.


/*
This datum stores a declarative description of clans, in order to make an instance of the clan component from this implementation in runtime
And it also helps for the character set panel
*/
/datum/clan
	var/name = "Caitiff"
	var/desc = "The clanless. The rabble. Of no importance."
	var/clanicon

	var/list/clane_covens = list() //coven datums
	var/list/restricted_covens = list()
	var/list/common_covens = list() //Covens that you don't start with but are easier to purchase like catiff instead of non clan discs

	/// List of traits that are applied to members of this Clan
	var/list/clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
		TRAIT_VAMPMANSION,
	)

	var/blood_preference = BLOOD_PREFERENCE_ALL

	var/list/disliked_clans = list()
	var/list/liked_clans = list()


	var/list/clan_members = list()
	var/list/non_vampire_members = list()
	/// Whether this clan allows non-vampire members
	var/allows_non_vampires = TRUE
	/// Title for non-vampire members
	var/non_vampire_title = "Slave"
	var/datum/clan_hierarchy_node/hierarchy_root
	var/list/datum/clan_hierarchy_node/all_positions = list()

	var/curse = "None."

	var/clane_curse //There should be a reference here.
	///The Clan's unique body sprite
	var/alt_sprite
	///If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale = FALSE

	var/humanitymod = 1
	var/frenzymod = 1
	var/start_humanity = 7
	var/is_enlightened = FALSE
	var/whitelisted = FALSE
	var/accessories = list()
	var/accessories_layers = list()
	var/current_accessory

	var/mob/living/clan_leader
	var/leader_title = "Vampire Lord"
	var/datum/clan_leader/leader = /datum/clan_leader/wretch
	/// Set to FALSE for clans that shouldn't be selectable
	var/selectable_by_vampires = TRUE

	var/covens_to_select = COVENS_PER_CLAN
	var/handling_organ_loss = FALSE

/datum/clan/proc/get_downside_string()
	return
/datum/clan/proc/get_blood_preference_string()
	return
/datum/clan/proc/handle_bloodsuck(mob/living/carbon/human/drinker, blood_types)
	return
/datum/clan/proc/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	return
/datum/clan/proc/apply_non_vampire_look(mob/living/carbon/human/H)
	return
/datum/clan/proc/add_non_vampire_member(mob/living/carbon/human/H)
	return
/datum/clan/proc/handle_member_joining(mob/living/carbon/human/H, is_vampire = TRUE)
	return
/datum/clan/proc/initialize_hierarchy()
	return
/datum/clan/proc/create_position(position_name, position_desc, datum/clan_hierarchy_node/superior_position, rank_level)
	return
/datum/clan/proc/remove_position(datum/clan_hierarchy_node/position)
	return
/datum/clan/proc/apply_clan_components(mob/living/carbon/human/H)
	return
/datum/clan/proc/disable_covens(mob/living/carbon/human/vampire)
	return
/**
 * Undoes the effects of on_gain to more or less
 * remove the effects of gaining the Clan. By default,
 * this proc only removes unique traits and resets
 * the mob's alternative sprite.
 *
 * Arguments:
 * * vampire - Human losing the Clan.
 */
/datum/clan/proc/on_lose(mob/living/carbon/human/vampire)
	return
/datum/clan/proc/handle_leadership_succession()
	return
/datum/clan/proc/frenzy_message(mob/living/message)
	return
/datum/clan/proc/adjust_bloodpool_size(adjust)
	return
/datum/clan/proc/on_vampire_life(mob/living/carbon/human/H)
	return
/datum/clan/proc/setup_vampire_abilities(mob/living/carbon/human/H)
	return
/// Applies clan-specific vampire look.
/datum/clan/proc/apply_vampire_look(mob/living/carbon/human/H)
	return
/// Removes clan-specific vampire look. Called from disguise comment.
/datum/clan/proc/remove_vampire_look(mob/living/carbon/human/H)
	return
/datum/clan/proc/post_gain(mob/living/carbon/human/H)
	return
/datum/clan/proc/add_coven_to_clan(datum/coven/new_coven, give_to_all = TRUE)
	return
/datum/clan/proc/handle_fear(mob/vampire, atom/fear)
	return
/datum/clan/proc/return_fear_list()
	return
/datum/clan/proc/return_fear(mob/vampire)
	return
/**
 * Gives the human an established vampiric Clan, applying
 * on_gain effects and post_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */
/mob/living/carbon/human/proc/set_clan_direct(datum/clan/new_clan)
	return
/**
 * Gives the human a vampiric Clan, applying
 * on_gain effects and post_gain effects if the
 * parameter is true. Can also remove Clans
 * with or without a replacement, and apply
 * on_lose effects. Will have no effect the human
 * is being given the Clan it already has.
 *
 * Arguments:
 * * setting_clan - Typepath or Clan singleton to give to the human
 * * joining_round - If this Clan is being given at roundstart and should call on_join_round
 */

/mob/living/carbon/human/proc/set_clan(setting_clan, joining_round)
	return
/// Sets vampire eyes into the owner
/datum/clan/proc/implant_vampire_eyes(mob/living/carbon/human/to_insert)
	return
/// Prevents tongue and eye loss by the vampyre
/datum/clan/proc/on_organ_loss(mob/living/carbon/lost_organ, obj/item/organ/removed, special, drop_if_replaced)
	return
/datum/clan/proc/open_clan_menu(mob/living/carbon/human/user)
	return
/datum/action/clan_menu
	name = "Clan Menu"
	desc = "Open your clan's power management interface"
	background_icon_state = "spell"
	button_icon_state = "coven"

/datum/action/clan_menu/Trigger(trigger_flags)
	return
/datum/status_effect/debuff/blood_disgust
	id = "blood_disgust"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_disgust
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/blood_disgust
	name = "Sanguine Curse"
	desc = "<span class='warning'>This type of blood does not go down well.</span>\n"
	icon_state = "hunger2"

/datum/status_effect/debuff/blood_disgust/on_apply()
	return
/datum/status_effect/debuff/blood_disgust/on_remove()
	return
/datum/stressevent/bad_blood
	desc = span_warning("That blood was revolting!")
	stressadd = 3
	max_stacks = 10
	stressadd_per_extra_stack = 3
	timer = 10 MINUTES
