/datum/threat_region/desert_near
	region_name = THREAT_REGION_DESERT_NEAR
	latent_ambush = 250
	min_ambush = 0
	max_ambush = 500
	fixed_ambush = FALSE
	// BEGIN DESERT TOWN CONTRACTS (Rollback by removing down to END and restoring lowpop_tick = 1 / highpop_tick = 1)
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 50,
		QUEST_FACTION_WILD_BEAST = 35,
		QUEST_FACTION_MADMAN = 15,
	)
	tp_budget_multiplier = 0.85
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2
	// END DESERT TOWN CONTRACTS

/datum/threat_region/desert_deep
	region_name = THREAT_REGION_DESERT_DEEP
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	// BEGIN DESERT TOWN CONTRACTS (Rollback by removing down to END and restoring lowpop_tick = 1 / highpop_tick = 2)
	lowpop_tick = 900 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 900 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_WILD_BEAST = 30,
		QUEST_FACTION_TARICHEA_DEADITE = 25,
		QUEST_FACTION_GREAT_BEAST = 15,
	)
	tp_budget_multiplier = 1.15
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2
	// END DESERT TOWN CONTRACTS
