/datum/coven_power/do_masquerade_violation(atom/target)
	if (violates_masquerade)
		if (owner.CheckEyewitness(target ? target : owner, owner, 7, TRUE))
			//TODO: detach this from being a human
			if (ishuman(owner))
				var/atom/center = target ? target : owner
				var/has_mortal_witness = FALSE
				for(var/mob/living/carbon/human/H in viewers(7, center))
					if(H == owner)
						continue
					if(H.mind?.has_antag_datum(/datum/antagonist))
						continue
					has_mortal_witness = TRUE
					break
				if(!has_mortal_witness)
					return
				var/mob/living/carbon/human/human = owner
				human.AdjustMasquerade(-1)