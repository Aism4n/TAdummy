/obj/item/book/granter/residentcard
	name = "Resident Manuscript"
	icon_state = "contractunsigned"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "This scroll grants the signer citizenship in the town of Rockhill and the right to choose an unoccupied house in the town."
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'

/obj/item/book/granter/residentcard/attack_self(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_RESIDENT))
		to_chat(user, span_danger("I already have citizenship!"))
		return FALSE
	if(icon_state == "contractsigned")
		to_chat(user, span_danger("This scroll already signed."))
		return FALSE
	else
		var/obj/item/writefeather
		for(var/obj/item/I in user.held_items)
			if(istype(I, /obj/item/natural/feather))
				writefeather = I
				break
		if(!writefeather)
			to_chat(user, span_warning("I need to hold a feather!"))
			return FALSE

		var/turf/T = get_step(user, user.dir)
		if(!(locate(/obj/structure/table) in T))
			to_chat(user, span_warning("I need to make this on a table."))
			return FALSE

		if(!do_after(user, 4 SECONDS, TRUE))
			to_chat(user, span_warning("My concentration breaks! I could not sign properly."))
			return FALSE

		to_chat(user, span_notice("I sign the scroll, receiving citizenship and the opportunity to live in a house in the city!"))
		playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
		ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_GENERIC)
		onlearned(user)

/obj/item/book/granter/residentcard/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "[user.real_name] - resident manuscript"
		desc = "A scroll confirming citizenship with the owner's signature."
		icon_state = "contractsigned"

#define MANUSCRIPT_DESCRIPTIONS list(\
	"Сим удостоверяется, что предъявитель сего манускрипта — законный житель города и подданный Короны, коему надлежит воздавать почести и права, подобающие его сословию. Грамота скреплена печатями уполномоченных лиц и не подлежит оспариванию иначе как через судебное разбирательство.",\
	"По велению и благословению Короны, а равно под надзором Канцелярии и Совета Старейшин, объявляется: носитель сего свитка принят под сень Закона как полноправный житель, и ко вреду его всякий посягнувший ответит пред Судом.",\
	"В лето текущее от Восхождения, сия грамота выдана на имя означенного жителя в знак признания прав его, имущества его и благополучия его пред лицом Короны и народа. Да не скроет её никто под сенью ночи, да не подделает пером своим.",\
	"Печатью и словом уполномоченных мужей закреплено право сего подданного на хлеб, кров и защиту закона в пределах сих стен. Всякий, кто воспрепятствует, да будет признан отступником.",\
)

#define MANUSCRIPT_DEFECT_NOTES list(\
	"На бумаге видна едва заметная клякса в углу.",\
	"Чернила на печати слегка смазаны.",\
	"Одна из букв в имени выведена нетвёрдой рукой.",\
	"Край пергамента обрезан неровно.",\
	"Подпись поставлена не вполне уверенно.",\
	"Пергамент отдаёт несвежим запахом.",\
)

#define FAKE_DEFECT_CHANCE 65

/obj/item/book/granter/residentcardvirtue
	name = "Resident Manuscript"
	desc = "Скреплённый печатями свиток, удостоверяющий гражданство."
	icon_state = "contractsigned"
	icon = 'icons/roguetown/items/misc.dmi'
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	oneuse = FALSE
	var/owner_ckey
	var/owner_name
	var/owner_age_label
	var/owner_status_label
	var/issue_date
	var/expiry_date
	var/issued_place
	var/description
	var/portrait_data
	var/is_bound = FALSE
	var/is_fake = FALSE
	var/defect_note
	var/list/seals
	var/list/detection_attempts
	var/list/detection_results

/obj/item/book/granter/residentcardvirtue/Initialize()
	. = ..()
	issued_place = SSmapping.config?.map_name || "Азурный Пик"
	description = pick(MANUSCRIPT_DESCRIPTIONS)
	var/game_year = text2num(GLOB.year) || 2026
	issue_date = "[rand(1,28)] [pick("Ясеня","Грома","Ливня","Мороза","Листопада","Златозара")], [game_year] г."
	expiry_date = "[pick("бессрочно","до смерти владельца","[game_year + 5] г.")]"
	seals = list(
		"chancellor" = null,
		"elder" = null,
		"duke" = null,
		"hand" = null,
	)
	detection_attempts = list()
	detection_results = list()

/obj/item/book/granter/residentcardvirtue/examine(mob/user)
	. = ..()
	if(is_bound && owner_name)
		. += span_info("Грамота выдана на имя: [owner_name].")
	else
		. += span_info("Грамота ещё не скреплена с владельцем.")

/obj/item/book/granter/residentcardvirtue/attack_self(mob/living/user)
	if(!is_bound)
		if(!ishuman(user))
			to_chat(user, span_warning("Грамота не признаёт вас."))
			return
		bind_to_holder(user)
		to_chat(user, span_notice("Грамота скреплена с вашим ликом."))
		playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
	ui_interact(user)

/obj/item/book/granter/residentcardvirtue/equipped(mob/living/user, slot)
	. = ..()
	if(is_bound || !ishuman(user))
		return
	if(istype(src, /obj/item/book/granter/residentcardvirtue/fake))
		return
	bind_to_holder(user)

/obj/item/book/granter/residentcardvirtue/proc/bind_to_holder(mob/living/carbon/human/target)
	if(is_bound || !ishuman(target))
		return
	owner_ckey = target.ckey
	owner_name = target.real_name
	owner_age_label = age_to_label(target.age)
	owner_status_label = status_label_for(target)
	capture_portrait(target)
	is_bound = TRUE
	name = "[owner_name] — грамота личности"

/obj/item/book/granter/residentcardvirtue/proc/age_to_label(age_val)
	switch(age_val)
		if(AGE_ADULT)
			return "Взрослый"
		if(AGE_MIDDLEAGED)
			return "Средних лет"
		if(AGE_OLD)
			return "Пожилой"
	return "Неизвестен"

/obj/item/book/granter/residentcardvirtue/proc/status_label_for(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		return "Благородный"
	return "Простолюдин"

/obj/item/book/granter/residentcardvirtue/proc/capture_portrait(mob/living/carbon/human/target)
	if(!target)
		return
	target.update_inv_hands()
	target.update_inv_head()
	var/image/dummy = image(target.icon, target, target.icon_state, target.layer, SOUTH)
	dummy.appearance = target.appearance
	dummy.dir = SOUTH
	var/icon/headshot = getFlatIcon(dummy, SOUTH, no_anim = TRUE)
	headshot.Scale(64, 64)
	headshot.Crop(1, 33, 64, 64)
	portrait_data = icon2base64(headshot)

/obj/item/book/granter/residentcardvirtue/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/book/granter/residentcardvirtue/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResidentManuscript", name)
		ui.open()

/obj/item/book/granter/residentcardvirtue/ui_data(mob/user)
	var/list/data = list()
	var/is_owner_viewing = (user?.ckey == owner_ckey)
	data["owner_name"] = owner_name || "Неизвестно"
	data["owner_age"] = owner_age_label || "—"
	data["owner_status"] = owner_status_label || "—"
	data["issue_date"] = issue_date || "—"
	data["expiry_date"] = expiry_date || "—"
	data["issued_place"] = issued_place || "—"
	data["description"] = description || ""
	data["portrait_data"] = portrait_data || ""
	data["is_owner"] = is_owner_viewing
	data["is_bound"] = is_bound
	data["seal_chancellor"] = seal_entry("chancellor", "Канцлер")
	data["seal_elder"] = seal_entry("elder", "Старейшина")
	data["seal_duke"] = seal_entry("duke", "Герцог")
	data["seal_hand"] = seal_entry("hand", "Длань")

	data["can_detect"] = FALSE
	data["detection_done"] = FALSE
	data["detection_result"] = ""
	data["defect_note"] = ""

	if(is_bound && user?.ckey && user.ckey != owner_ckey)
		if(LAZYACCESS(detection_attempts, user.ckey))
			data["detection_done"] = TRUE
			data["detection_result"] = LAZYACCESS(detection_results, user.ckey) || "unknown"
			if(data["detection_result"] == "fake")
				data["defect_note"] = defect_note || ""
		else
			data["can_detect"] = TRUE
	return data

/obj/item/book/granter/residentcardvirtue/proc/seal_entry(key, label)
	var/list/entry
	if(seals)
		entry = seals[key]
	if(entry)
		return list(
			"label" = label,
			"stamped" = TRUE,
			"stamper" = entry["stamper"] || "",
		)
	return list(
		"label" = label,
		"stamped" = FALSE,
		"stamper" = "",
	)

/obj/item/book/granter/residentcardvirtue/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/user = usr
	switch(action)
		if("detect")
			handle_detection(user)
			return TRUE
		if("bind")
			if(is_bound)
				return TRUE
			if(ishuman(user))
				bind_to_holder(user)
				to_chat(user, span_notice("Грамота скреплена с вашим ликом."))
			return TRUE

/obj/item/book/granter/residentcardvirtue/proc/handle_detection(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.ckey)
		return
	if(LAZYACCESS(detection_attempts, user.ckey))
		return
	LAZYSET(detection_attempts, user.ckey, TRUE)
	var/chance = 5
	if(user.STAINT > 10)
		chance += 5
	if(user.STAPER > 10 && user.STAPER <= 12)
		chance += 5
	var/reading = user.get_skill_level(/datum/skill/misc/reading)
	if(reading > 0)
		chance += 5 * reading
	if(prob(chance))
		LAZYSET(detection_results, user.ckey, is_fake ? "fake" : "real")
	else
		LAZYSET(detection_results, user.ckey, "unknown")

/obj/item/book/granter/residentcardvirtue/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/manuscript_seal))
		var/obj/item/manuscript_seal/S = I
		S.apply_to_manuscript(src, user)
		return
	return ..()

/obj/item/book/granter/residentcardvirtue/proc/stamp_seal(seal_key, stamper_name)
	if(!seals || !(seal_key in seals))
		return FALSE
	if(seals[seal_key])
		return FALSE
	seals[seal_key] = list("stamper" = stamper_name, "time" = world.time)
	return TRUE

/obj/item/book/granter/residentcardvirtue/fake
	name = "Resident Manuscript"
	desc = "Свиток, выдаваемый за грамоту личности."
	is_fake = TRUE

/obj/item/book/granter/residentcardvirtue/fake/Initialize()
	. = ..()
	if(prob(FAKE_DEFECT_CHANCE))
		defect_note = pick(MANUSCRIPT_DEFECT_NOTES)
	if(prob(30))
		portrait_data = ""
	for(var/seal_key in list("chancellor","elder","duke","hand"))
		if(prob(70))
			seals[seal_key] = list("stamper" = pick("неразборчиво","смазано","—"), "time" = 0)

/obj/item/book/granter/residentcardvirtue/fake/equipped(mob/living/user, slot)
	return

/obj/item/book/granter/residentcardvirtue/fake/attack_self(mob/living/user)
	if(!is_bound)
		if(!ishuman(user))
			return
		bind_to_holder(user)
		to_chat(user, span_notice("Вы скрепляете свиток со своим ликом."))
		playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
		ui_interact(user)
		return
	if(user.ckey != owner_ckey)
		to_chat(user, span_warning("Свиток не желает раскрываться чужаку."))
		return
	ui_interact(user)

/obj/item/manuscript_seal
	name = "Seal"
	desc = "Печать для заверения грамот."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "contractsigned"
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	var/seal_key = ""
	var/seal_label = ""
	var/list/allowed_jobs = list()
	var/stamper_title = ""

/obj/item/manuscript_seal/proc/apply_to_manuscript(obj/item/book/granter/residentcardvirtue/M, mob/living/user)
	if(!istype(M))
		return
	if(!M.is_bound)
		to_chat(user, span_warning("Грамота не скреплена с владельцем — печать ставить рано."))
		return
	if(!is_allowed_user(user))
		to_chat(user, span_warning("Сия печать не принадлежит вам по праву."))
		return
	if(M.seals[seal_key])
		to_chat(user, span_warning("[seal_label] уже поставлена."))
		return
	var/stamper_name = stamper_title || capitalize(user.job || "Official")
	if(!M.stamp_seal(seal_key, stamper_name))
		return
	to_chat(user, span_notice("Вы прикладываете [seal_label] к грамоте."))
	playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)

/obj/item/manuscript_seal/proc/is_allowed_user(mob/living/user)
	if(!length(allowed_jobs))
		return TRUE
	return user?.job in allowed_jobs

/obj/item/manuscript_seal/chancellor
	name = "Chancellor's Seal"
	desc = "Печать канцлера — заверяет волю Короны."
	seal_key = "chancellor"
	seal_label = "Печать Канцлера"
	allowed_jobs = list("Hand", "Consort", "Bishop", "Grand Duke")
	stamper_title = "Канцлер"

/obj/item/manuscript_seal/elder
	name = "Elder's Seal"
	desc = "Печать старейшины — знак мудрости и опыта."
	seal_key = "elder"
	seal_label = "Печать Старейшины"
	allowed_jobs = list("Bishop", "Priest", "Consort Dowager", "Inquisitor")
	stamper_title = "Старейшина"

/obj/item/manuscript_seal/duke
	name = "Duke's Seal"
	desc = "Печать герцога — знак высшей знати."
	seal_key = "duke"
	seal_label = "Печать Герцога"
	allowed_jobs = list("Grand Duke", "Consort")
	stamper_title = "Герцог"

/obj/item/manuscript_seal/hand
	name = "Hand's Seal"
	desc = "Печать Длани — десницы Короны."
	seal_key = "hand"
	seal_label = "Печать Длани"
	allowed_jobs = list("Hand", "Grand Duke")
	stamper_title = "Длань"

/datum/supply_pack/rogue/adventure_supplies/fake_manuscript
	name = "Подозрительный свиток"
	cost = 200
	contains = list(/obj/item/book/granter/residentcardvirtue/fake)

#undef MANUSCRIPT_DESCRIPTIONS
#undef MANUSCRIPT_DEFECT_NOTES
#undef FAKE_DEFECT_CHANCE
