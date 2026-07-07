
/datum/charflaw/limbloss
	var/lost_zone

/datum/charflaw/limbloss/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/O = H.get_bodypart(lost_zone)
	if(O)
		O.drop_limb()
		qdel(O)
	return

/datum/charflaw/limbloss/arm_r
	name = "Wood Arm (R)"
	desc = "I lost my right arm long ago, but the wooden arm doesn't bleed as much... but it is flammable.<br><i>(Incompatible with Bronze Arm (R) virtue)</i>"
	lost_zone = BODY_ZONE_R_ARM
	restricted_species = list(/datum/species/ooze)

/datum/charflaw/limbloss/arm_r/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/r_arm/prosthetic/woodright/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/arm_l
	name = "Wood Arm (L)"
	desc = "I lost my left arm long ago, but the wooden arm doesn't bleed as much... but it is flammable.<br><i>(Incompatible with Bronze Arm (L) virtue)</i>"
	lost_zone = BODY_ZONE_L_ARM
	restricted_species = list(/datum/species/ooze)

/datum/charflaw/limbloss/arm_l/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_arm/prosthetic/woodleft/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/leg_r
	name = "Wood leg (R)"
	desc = "I lost my right leg long ago, but the wooden leg doesn't bleed as much... but it is flammable.<br><i>(Incompatible with Bronze Leg (R) virtue)</i>"
	restricted_species = list(/datum/species/ooze)

/datum/charflaw/limbloss/leg_r/on_mob_creation(mob/user)
	lost_zone = BODY_ZONE_R_LEG
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/r_leg/prosthetic/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/leg_l
	name = "Wood leg (L)"
	desc = "I lost my left leg long ago, but the wooden leg doesn't bleed as much... but it is flammable.<br><i>(Incompatible with Bronze Leg (L) virtue)</i>"
	restricted_species = list(/datum/species/ooze)

/datum/charflaw/limbloss/leg_l/on_mob_creation(mob/user)
	lost_zone = BODY_ZONE_L_LEG
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_leg/prosthetic/L = new()
	L.attach_limb(H)
