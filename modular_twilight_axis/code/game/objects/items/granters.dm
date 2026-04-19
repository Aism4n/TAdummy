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

#define MANUSCRIPT_ITEM_DESCRIPTION "Этот эластичный свиток цвета слоновой кости идеально гладок, прохладен и на просвет лишен дефектов. Его золоченые края мерцают при разворачивании, издавая сухой хруст. Текст выведен въевшимися иссиня-черными чернилами с лазуритными инициалами, а снизу на шелково-золотом шнуре закреплена детальная сургучная печать. Документ пахнет воском, травами и дорогой кожей."

#define MANUSCRIPT_DESCRIPTION "Сим объявляется во всеуслышание: по воле Короны и надзором Совета, предъявитель сего документа признан законным обитателем земель сих и пребывает под сенью общего права. Всякому чину и званию вменяется в долг признавать в лице помянутом верного подданного, не чиня ему препятствий в делах и путях его. Всякий же, кто делом или умыслом нанесет вред носителю сей грамоты, ответит пред законом по всей строгости уложений, ибо посягает на порядок, престолом установленный"

#define MANUSCRIPT_DEFECT_NOTES list(\
	"На бумаге видна едва заметная клякса в углу.",\
	"Чернила на печати слегка смазаны.",\
	"Одна из букв в имени выведена нетвёрдой рукой.",\
	"Край пергамента обрезан неровно.",\
	"Подпись поставлена не вполне уверенно.",\
	"Пергамент отдаёт несвежим запахом.",\
)

#define MANUSCRIPT_VALIDATION_NOTES list(\
	"Печати сидят ровно, чернила легли уверенно, а шнур не несёт следов повторного крепления.",\
	"Водяные знаки проступают чисто: перед вами грамота должного образца.",\
	"Почерк, печати и золочёный край согласуются между собой. Повода сомневаться в грамоте не видно.",\
	"Сургуч принял оттиск глубоко и без разрывов, а строки не выдают чужой руки.",\
	"Документ выглядит составленным по всем правилам канцелярского обряда.",\
)

#define FAKE_DEFECT_CHANCE 65

/obj/item/book/granter/residentcardvirtue
	name = "Подорожная грамота"
	desc = MANUSCRIPT_ITEM_DESCRIPTION
	icon_state = "contractsigned"
	icon = 'icons/roguetown/items/misc.dmi'
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	oneuse = FALSE
	var/owner_character_key
	var/owner_name
	var/owner_status_label
	var/expiry_date
	var/issued_place
	var/description
	var/is_bound = FALSE
	var/is_fake = FALSE
	var/undetectable_fake = FALSE
	var/authority_validated = FALSE
	var/defect_note
	var/list/seals
	var/list/detection_attempts
	var/list/detection_results
	var/list/detection_notes
	var/auto_stamp_seals = TRUE

/obj/item/book/granter/residentcardvirtue/Initialize()
	. = ..()
	issued_place = get_map_display_name()
	description = MANUSCRIPT_DESCRIPTION
	expiry_date = compute_expiry_date()
	seals = list(
		"chancellor" = null,
		"elder" = null,
		"duke" = null,
		"hand" = null,
	)
	detection_attempts = list()
	detection_results = list()
	detection_notes = list()
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

/obj/item/book/granter/residentcardvirtue/proc/compute_expiry_date()
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)
	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset
	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/current_month = FLOOR((day_of_year - 1) / CALENDAR_DAYS_IN_MONTH, 1) + 1
	var/current_day = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	var/offset = rand(10, 20)
	var/new_day = current_day + offset
	var/new_month = current_month
	while(new_day > CALENDAR_DAYS_IN_MONTH)
		new_day -= CALENDAR_DAYS_IN_MONTH
		new_month += 1
	if(new_month > CALENDAR_MONTHS_PER_YEAR)
		new_month = ((new_month - 1) % CALENDAR_MONTHS_PER_YEAR) + 1
	return "[new_day] [get_month_number_to_text(new_month)] [CALENDAR_EPOCH_YEAR]"

/obj/item/book/granter/residentcardvirtue/proc/get_ruler_seal_title()
	if(SSmapping.config?.map_name == "Rockhill")
		return "Король"
	return "Герцог"

/obj/item/book/granter/residentcardvirtue/proc/stamp_all_seals()
	seals["chancellor"] = list("stamper" = "Канцлер", "time" = world.time)
	seals["elder"] = list("stamper" = "Старейшина", "time" = world.time)
	seals["duke"] = list("stamper" = get_ruler_seal_title(), "time" = world.time)
	seals["hand"] = list("stamper" = "Длань", "time" = world.time)

/obj/item/book/granter/residentcardvirtue/proc/get_seal_key_for_user(mob/living/carbon/human/user)
	if(!user)
		return null
	var/datum/job/J = SSjob.GetJob(user.mind?.assigned_role)
	if(istype(J, /datum/job/roguetown/councillor))
		return "chancellor"
	var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
	if(istype(advclass, /datum/advclass/elder))
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
			return get_ruler_seal_title()
		if("hand")
			return "Длань"
	return ""

/obj/item/book/granter/residentcardvirtue/proc/get_detection_character_key(mob/living/carbon/human/user)
	if(!user)
		return null
	if(user.mobid)
		return "[user.mobid]"
	return user.real_name || user.name

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
	owner_character_key = get_detection_character_key(target)
	owner_name = target.real_name
	owner_status_label = status_label_for(target)
	is_bound = TRUE
	name = "Подорожная грамота"

/obj/item/book/granter/residentcardvirtue/proc/can_make_undetectable_forgery(mob/living/carbon/human/user)
	return can_write_master_forgery(user) && (is_fake || istype(src, /obj/item/book/granter/residentcardvirtue/base))

/obj/item/book/granter/residentcardvirtue/proc/can_write_master_forgery(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	return HAS_TRAIT(user, TRAIT_GOODWRITER) || user.get_true_stat(STATKEY_INT) >= 17

/obj/item/book/granter/residentcardvirtue/proc/can_edit_fake_manuscript(mob/living/carbon/human/user)
	return ishuman(user) && is_fake && !is_bound

/obj/item/book/granter/residentcardvirtue/proc/is_ruling_authority(mob/living/carbon/human/user)
	var/seal_key = get_seal_key_for_user(user)
	return seal_key == "duke" || seal_key == "hand"

/obj/item/book/granter/residentcardvirtue/proc/forge_undetectable_fake(mob/living/carbon/human/forger)
	if(!ishuman(forger))
		return FALSE
	is_fake = TRUE
	undetectable_fake = TRUE
	authority_validated = FALSE
	defect_note = null
	if(!is_bound)
		bind_to_holder(forger)
	icon_state = "contractsigned"
	stamp_all_seals()
	return TRUE

/obj/item/book/granter/residentcardvirtue/proc/status_label_for(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		return "Под милостью Астраты"
	return "Безызвестное"

/obj/item/book/granter/residentcardvirtue/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/book/granter/residentcardvirtue/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResidentManuscript", name)
		ui.open()

/obj/item/book/granter/residentcardvirtue/ui_data(mob/user)
	var/list/data = list()
	var/detection_key
	var/can_edit_fake = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		detection_key = get_detection_character_key(human_user)
		can_edit_fake = can_edit_fake_manuscript(human_user)
	var/is_owner_viewing = (detection_key && owner_character_key && detection_key == owner_character_key)
	data["owner_name"] = owner_name || (can_edit_fake ? "" : "Неизвестно")
	data["owner_status"] = owner_status_label || (can_edit_fake ? "Безызвестное" : "—")
	data["expiry_date"] = expiry_date || "—"
	data["issued_place"] = issued_place || "—"
	data["description"] = description || ""
	data["is_owner"] = is_owner_viewing
	data["is_bound"] = is_bound
	data["can_edit_fake"] = can_edit_fake
	data["seal_chancellor"] = seal_entry("chancellor", "Канцлер")
	data["seal_elder"] = seal_entry("elder", "Старейшина")
	data["seal_duke"] = seal_entry("duke", get_ruler_seal_title())
	data["seal_hand"] = seal_entry("hand", "Длань")

	data["can_detect"] = FALSE
	data["detection_done"] = FALSE
	data["detection_result"] = ""
	data["detection_note"] = ""
	data["defect_note"] = ""

	if(is_bound && detection_key && !is_owner_viewing)
		if(LAZYACCESS(detection_attempts, detection_key))
			data["detection_done"] = TRUE
			data["detection_result"] = LAZYACCESS(detection_results, detection_key) || "unknown"
			data["detection_note"] = LAZYACCESS(detection_notes, detection_key) || ""
			if(data["detection_result"] == "fake")
				data["defect_note"] = defect_note || ""
		else if(!authority_validated)
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
		if("save_fake")
			save_fake_manuscript(user, params)
			return TRUE
		if("bind")
			return TRUE

/obj/item/book/granter/residentcardvirtue/proc/sanitize_manuscript_field(value, max_length, fallback)
	var/text_value = ""
	if(!isnull(value))
		text_value = "[value]"
	text_value = trim(html_encode(text_value), max_length)
	return length(text_value) ? text_value : fallback

/obj/item/book/granter/residentcardvirtue/proc/save_fake_manuscript(mob/living/carbon/human/user, list/params)
	if(!can_edit_fake_manuscript(user))
		return FALSE
	if(!params)
		params = list()
	owner_character_key = null
	owner_name = sanitize_manuscript_field(params["owner_name"], MAX_NAME_LEN, "Неизвестно")
	owner_status_label = sanitize_manuscript_field(params["owner_status"], MAX_NAME_LEN, "Безызвестное")
	expiry_date = sanitize_manuscript_field(params["expiry_date"], MAX_NAME_LEN, expiry_date || compute_expiry_date())
	issued_place = sanitize_manuscript_field(params["issued_place"], MAX_NAME_LEN, issued_place || get_map_display_name())
	description = sanitize_manuscript_field(params["description"], 1400, MANUSCRIPT_DESCRIPTION)
	is_bound = TRUE
	name = "Подорожная грамота"
	icon_state = "contractsigned"
	stamp_all_seals()
	authority_validated = FALSE
	if(can_make_undetectable_forgery(user))
		undetectable_fake = TRUE
		defect_note = null
	else
		undetectable_fake = FALSE
	detection_attempts = list()
	detection_results = list()
	detection_notes = list()
	to_chat(user, span_notice("Вы сохраняете поддельную грамоту, придавая ей вид настоящей."))
	playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
	return TRUE

/obj/item/book/granter/residentcardvirtue/proc/handle_detection(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	var/detection_key = get_detection_character_key(user)
	if(!detection_key)
		return
	if(owner_character_key && detection_key == owner_character_key)
		return
	if(LAZYACCESS(detection_attempts, detection_key))
		return
	var/base_int = user.get_true_stat(STATKEY_INT)
	if(is_ruling_authority(user))
		handle_authority_detection(detection_key, base_int)
		return
	if(authority_validated)
		return
	LAZYSET(detection_attempts, detection_key, TRUE)
	var/chance = 5
	var/base_per = user.get_true_stat(STATKEY_PER)
	if(base_int > 10)
		chance += 5
	if(base_per > 10 && base_per <= 12)
		chance += 5
	if(HAS_TRAIT(user, TRAIT_INTELLECTUAL))
		chance += 15
	var/reading = user.get_skill_level(/datum/skill/misc/reading)
	if(reading > 0)
		chance += 10 * reading
	var/result = "unknown"
	if(prob(chance))
		if(is_fake && !undetectable_fake)
			if(!defect_note)
				defect_note = pick(MANUSCRIPT_DEFECT_NOTES)
			result = "fake"
		else
			result = "real"
	LAZYSET(detection_results, detection_key, result)
	if(result != "fake")
		LAZYSET(detection_notes, detection_key, pick(MANUSCRIPT_VALIDATION_NOTES))

/obj/item/book/granter/residentcardvirtue/proc/handle_authority_detection(detection_key, base_int)
	if(authority_validated)
		return
	LAZYSET(detection_attempts, detection_key, TRUE)
	var/result = "real"
	if(is_fake)
		var/detected_fake = base_int > 10 || prob(25)
		if(detected_fake)
			if(!defect_note)
				defect_note = pick(MANUSCRIPT_DEFECT_NOTES)
			result = "fake"
		else
			authority_validated = TRUE
	LAZYSET(detection_results, detection_key, result)
	if(result != "fake")
		LAZYSET(detection_notes, detection_key, pick(MANUSCRIPT_VALIDATION_NOTES))

/obj/item/book/granter/residentcardvirtue/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/feather) && ishuman(user))
		if(handle_feather_use(user))
			return
	return ..()

/obj/item/book/granter/residentcardvirtue/proc/handle_feather_use(mob/living/carbon/human/user)
	if(!is_bound)
		if(can_make_undetectable_forgery(user))
			forge_undetectable_fake(user)
		else
			bind_to_holder(user)
		icon_state = "contractsigned"
		to_chat(user, span_notice("Вы вписываете своё имя и образ в грамоту."))
		playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
		return TRUE
	var/seal_key = get_seal_key_for_user(user)
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
	name = "Подорожная грамота"
	desc = MANUSCRIPT_ITEM_DESCRIPTION
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
	ui_interact(user)

/obj/item/book/granter/residentcardvirtue/base
	name = "Бланк подорожной грамоты"
	desc = "Пустой бланк подорожной грамоты. Возьмите перо и впишите своё имя, затем отправьте к уполномоченным лицам для скрепления печатями."
	icon_state = "contractunsigned"
	auto_stamp_seals = FALSE

/datum/supply_pack/rogue/drugs/fake_manuscript
	name = "Подозрительный свиток"
	cost = 100
	contains = list(/obj/item/book/granter/residentcardvirtue/fake)

/datum/supply_pack/rogue/luxury/manuscript_base
	name = "Бланк подорожной грамоты"
	cost = 50
	contains = list(/obj/item/book/granter/residentcardvirtue/base)

#undef MANUSCRIPT_ITEM_DESCRIPTION
#undef MANUSCRIPT_DESCRIPTION
#undef MANUSCRIPT_DEFECT_NOTES
#undef MANUSCRIPT_VALIDATION_NOTES
#undef FAKE_DEFECT_CHANCE
