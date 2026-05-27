/datum/job/roguetown/freeman
	title = "Freeman"
	flag = BANDIT
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	
	tutorial = "Long ago you did a crime worthy of your bounty being hung on the wall outside of the local inn. You now live with your fellow freemen in the bog, and generally get up to no good."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 25
	max_pq = null
	round_contrib_points = null

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of freemans, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_STEELHEARTED)//Bandits and knaves truly though
	vice_restrictions = list(/datum/charflaw/noeyer, /datum/charflaw/noeyel, /datum/charflaw/mute, /datum/charflaw/limbloss/arm_r, /datum/charflaw/limbloss/arm_l)
	same_job_respawn_delay = 30 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	job_subclasses = list(
		/datum/advclass/sahir_maradun,
		/datum/advclass/twilight_afreet,
		/datum/advclass/faris_sarid,
	)

/datum/job/roguetown/freeman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/freeman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting

/datum/outfit/job/roguetown/freeman/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "BANDIT"), 5 SECONDS)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input("Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return

/proc/update_freemans_slots()
	var/datum/job/freeman_job = SSjob.GetJob("Freeman")
	if(!freeman_job)
		return
	
	freeman_job.total_positions = 0
	freeman_job.spawn_positions = 0
	freeman_job.always_show_on_latechoices = FALSE

	if(SSmapping.config.map_name != "Desert Town")
		return

	if(!istype(SSgamemode.current_storyteller, /datum/storyteller/matthios))
		return

	if(is_storyteller_soft_antag_blocked())
		return

	freeman_job.always_show_on_latechoices = TRUE

	var/player_count = length(GLOB.joined_player_list)
	var/ready_player_count = length(GLOB.ready_player_list)
	var/current_players = (SSticker.current_state == GAME_STATE_PREGAME) ? ready_player_count : player_count

	var/slots = 0

	if(current_players > 60)
		slots = 5

	freeman_job.total_positions = slots
	freeman_job.spawn_positions = slots