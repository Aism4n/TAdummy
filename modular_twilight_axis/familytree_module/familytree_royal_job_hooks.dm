/datum/job/roguetown/lady/special_check_latejoin(client/C)
	return SSfamilytree.royal_partner_candidate_allowed(C, src)

/datum/job/roguetown/suitor/special_check_latejoin(client/C)
	return SSfamilytree.royal_partner_candidate_allowed(C, src)
