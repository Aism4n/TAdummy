/datum/coven_power/do_masquerade_violation(atom/target)
	if(!violates_masquerade || !ishuman(owner))
		return

	var/atom/center = target ? target : owner

	if(!owner.CheckEyewitness(center, owner, 7, TRUE))
		return

	var/witness_count = 0

	for(var/mob/living/carbon/human/H in viewers(7, center))
		if(H == owner)
			continue

		if(H.mind?.has_antag_datum(/datum/antagonist/vampire))
			continue

		if(++witness_count > 2)
			break

	if(witness_count <= 2)
		return

	var/mob/living/carbon/human/Howner = owner
	Howner.AdjustMasquerade(-1)