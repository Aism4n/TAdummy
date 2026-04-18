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
	var/auto_stamp_seals = TRUE

/obj/item/book/granter/residentcardvirtue/Initialize()
	. = ..()
	issued_place = get_map_display_name()
	description = pick(MANUSCRIPT_DESCRIPTIONS)
	var/game_year = text2num(GLOB.year) || 2026
	expiry_date = "[pick("бессрочно","до смерти владельца","[game_year + 5] г.")]"
	seals = list(
		"chancellor" = null,
		"elder" = null,
		"duke" = null,
		"hand" = null,
	)
	detection_attempts = list()
	detection_results = list()
	if(auto_stamp_seals)
		stamp_all_seals()

/obj/item/book/granter/residentcardvirtue/proc/get_map_display_name()
	var/raw = SSmapping.config?.map_name
	switch(raw)
		if("Dun World")
			return "Герцогство Азурия"
		if("Rockhill")
			return "Рокхилл"
	return raw || "Азурный Пик"

/obj/item/book/granter/residentcardvirtue/proc/stamp_all_seals()
	seals["chancellor"] = list("stamper" = "Канцлер", "time" = world.time)
	seals["elder"] = list("stamper" = "Старейшина", "time" = world.time)
	seals["duke"] = list("stamper" = "Герцог", "time" = world.time)
	seals["hand"] = list("stamper" = "Длань", "time" = world.time)

/obj/item/book/granter/residentcardvirtue/proc/get_seal_key_for_job(datum/job/J)
	if(!J)
		return null
	if(istype(J, /datum/job/roguetown/seneschal))
		return "chancellor"
	if(istype(J, /datum/job/roguetown/priest))
		return "elder"
	if(istype(J, /datum/job/roguetown/lord))
		return "duke"
	if(istype(J, /datum/job/roguetown/hand))
		return "hand"
	return null

/obj/item/book/granter/residentcardvirtue/proc/seal_title_for_key(key)
	switch(key)
		if("chancellor")
			return "Канцлер"
		if("elder")
			return "Старейшина"
		if("duke")
			return "Герцог"
		if("hand")
			return "Длань"
	return ""

/obj/item/book/granter/residentcardvirtue/examine(mob/user)
	. = ..()
	if(is_bound && owner_name)
		. += span_info("Грамота выдана на имя: [owner_name].")
	else
		. += span_info("Грамота ещё не скреплена с владельцем.")

/obj/item/book/granter/residentcardvirtue/attack_self(mob/living/user)
	ui_interact(user)

/obj/item/book/granter/residentcardvirtue/equipped(mob/living/user, slot)
	. = ..()
	if(is_bound || !ishuman(user))
		return
	if(istype(src, /obj/item/book/granter/residentcardvirtue/fake))
		return
	if(istype(src, /obj/item/book/granter/residentcardvirtue/base))
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
	if(!target || !istype(target))
		return
	target.update_inv_hands()
	target.update_inv_belt()
	target.update_inv_back()
	target.update_inv_head()
	var/image/dummy = image(target.icon, target, target.icon_state, target.layer, target.dir)
	dummy.appearance = target.appearance
	dummy.dir = SOUTH
	target.update_inv_hands()
	target.update_inv_belt()
	target.update_inv_back()
	target.update_inv_head()
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
	if(istype(I, /obj/item/natural/feather) && ishuman(user))
		if(handle_feather_use(user))
			return
	return ..()

/obj/item/book/granter/residentcardvirtue/proc/handle_feather_use(mob/living/carbon/human/user)
	if(!is_bound)
		bind_to_holder(user)
		icon_state = "contractsigned"
		to_chat(user, span_notice("Вы вписываете своё имя и образ в грамоту."))
		playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
		return TRUE
	var/datum/job/J = SSjob.GetJob(user.mind?.assigned_role)
	var/seal_key = get_seal_key_for_job(J)
	if(!seal_key)
		to_chat(user, span_warning("Вы не имеете права ставить печать на этой грамоте."))
		return TRUE
	if(seals[seal_key])
		to_chat(user, span_warning("Ваша печать уже поставлена."))
		return TRUE
	var/title = seal_title_for_key(seal_key)
	stamp_seal(seal_key, title)
	to_chat(user, span_notice("Вы ставите печать [title] на грамоту."))
	playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
	return TRUE

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
	auto_stamp_seals = FALSE

/obj/item/book/granter/residentcardvirtue/fake/Initialize()
	. = ..()
	if(prob(FAKE_DEFECT_CHANCE))
		defect_note = pick(MANUSCRIPT_DEFECT_NOTES)
	for(var/seal_key in list("chancellor","elder","duke","hand"))
		if(prob(75))
			seals[seal_key] = list("stamper" = pick("неразборчиво","смазано","—"), "time" = 0)

/obj/item/book/granter/residentcardvirtue/fake/attack_self(mob/living/user)
	if(!is_bound)
		if(!ishuman(user))
			return
		bind_to_holder(user)
		if(prob(30))
			portrait_data = ""
		to_chat(user, span_notice("Вы скрепляете свиток со своим ликом."))
		playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
		ui_interact(user)
		return
	if(user.ckey != owner_ckey)
		to_chat(user, span_warning("Свиток не желает раскрываться чужаку."))
		return
	ui_interact(user)

/obj/item/book/granter/residentcardvirtue/base
	name = "Blank Resident Manuscript"
	desc = "Пустой бланк грамоты личности. Возьмите перо и впишите своё имя, затем отправьте к уполномоченным лицам для скрепления печатями."
	icon_state = "contractunsigned"
	auto_stamp_seals = FALSE

/datum/supply_pack/rogue/drugs/fake_manuscript
	name = "Подозрительный свиток"
	cost = 200
	contains = list(/obj/item/book/granter/residentcardvirtue/fake)

/datum/supply_pack/rogue/luxury/manuscript_base
	name = "Бланк грамоты личности"
	cost = 120
	contains = list(/obj/item/book/granter/residentcardvirtue/base)

#undef MANUSCRIPT_DESCRIPTIONS
#undef MANUSCRIPT_DEFECT_NOTES
#undef FAKE_DEFECT_CHANCE
