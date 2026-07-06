/datum/job/proc/ta_block_crimson_curse_virtue()
	if(!islist(virtue_restrictions))
		virtue_restrictions = list()
	virtue_restrictions |= /datum/virtue/combat/crimson_curse

/datum/job/roguetown/absolver/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/inquisitor/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/orthodoxist/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/wretch/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/druid/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/martyr/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/monk/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/priest/New()
	. = ..()
	ta_block_crimson_curse_virtue()

/datum/job/roguetown/templar/New()
	. = ..()
	ta_block_crimson_curse_virtue()
