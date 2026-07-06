/datum/status_effect/debuff/ta_sunspurn
	id = "ta_sunspurn"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_sunspurn
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -3)
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/ta_sunspurn
	name = "Отвергнутый Солнцем"
	desc = "Астрата отвергает меня. Я чувствую ужасную слабость."
	icon_state = "muscles"

/datum/component/sunlight_vulnerability/check_sunlight(mob/living/source)
	var/mob/living/carbon/human/H = source
	if(!H || H.stat == DEAD || H.advsetup)
		return

	if(GLOB.tod != "day")
		in_sunlight = FALSE
		return

	if(!isturf(H.loc))
		in_sunlight = FALSE
		return

	var/turf/T = H.loc
	if(!T.can_see_sky())
		if(in_sunlight)
			to_chat(H, span_notice("Палящее око Солнечного Тирана больше меня не мучает."))
		in_sunlight = FALSE
		return

	if(HAS_TRAIT(H, TRAIT_WEATHER_PROTECTED))
		if(!in_sunlight)
			in_sunlight = TRUE
			to_chat(H, span_danger("Я защищён от гнева Солнечного Тирана."))
		return

	if(!in_sunlight)
		in_sunlight = TRUE
		if(HAS_TRAIT(H, TRAIT_CRIMSON_CURSE))
			to_chat(H, span_danger("Я едва выдерживаю взгляд проклятого солнца!"))
		else
			to_chat(H, span_danger("Солнечный свет сжигает мою плоть!"))

	apply_sunlight_damage(H)

/datum/component/sunlight_vulnerability/apply_sunlight_damage(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_CRIMSON_CURSE))
		H.apply_status_effect(/datum/status_effect/debuff/ta_sunspurn)
		return

	H.adjust_bloodpool(-bloodpool_drain)
	var/datum/component/vampire_disguise/disguise_comp = H.GetComponent(/datum/component/vampire_disguise)
	if(disguise_comp?.disguised)
		if(H.bloodpool > disguise_comp.min_bloodpool * 2)
			return
		disguise_comp.force_undisguise(H)
		to_chat(H, span_warning("Солнечный свет разрушает мою маскировку!"))

	H.fire_act(1, burn_damage)
	if(H.on_fire)
		H.freak_out()
