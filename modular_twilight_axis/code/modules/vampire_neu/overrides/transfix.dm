/obj/effect/proc_holder/spell/targeted/TA_transfix_neu
	name = "Заворожить"
	overlay_state = "transfix"
	associated_skill = /datum/skill/magic/blood
	range = 7
	chargetime = 0
	releasedrain = 100
	recharge_time = 17 SECONDS
	var/powerful = FALSE
	var/int_divisor = 3.3
	var/blood_dice = 9
	var/will_dice = 6
	var/min_transfix_msg_length = 15
	var/transfix_msg

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/choose_targets(mob/user = usr)
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, usr))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			continue
		if(HAS_TRAIT(target, TRAIT_SILVER_BLESSED))
			continue
		selection += target

	if(!selection.len)
		revert_cast(user)
		return

	perform(selection, user=user)

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, span_warning("Рядом нет смертных..."))
		revert_cast(user)
		return

	if(QDELETED(user))
		return

	if(is_transfix_mouth_blocked(user))
		show_transfix_speech_failure(user)
		revert_cast(user)
		return

	if(!user.can_speak())
		show_transfix_speech_failure(user)
		revert_cast(user)
		return
	transfix_msg = tgui_input_text(user, "Произнесите фразу вслух. Нужно минимум [min_transfix_msg_length] символов; счетчик снизу.", "Заворожить", max_length = MAX_MESSAGE_LEN, encode = FALSE)

	if(QDELETED(user))
		return

	if(user.stat != CONSCIOUS)
		revert_cast(user)
		return

	if(is_transfix_mouth_blocked(user))
		show_transfix_speech_failure(user)
		revert_cast(user)
		return

	if(!user.can_speak())
		show_transfix_speech_failure(user)
		revert_cast(user)
		return

	var/transfix_msg_length = transfix_msg ? length_char(transfix_msg) : 0
	if(transfix_msg_length < min_transfix_msg_length)
		to_chat(user, span_userdanger("Слишком короткая фраза ([transfix_msg_length]/[min_transfix_msg_length]) — разум жертвы не поддастся!"))
		revert_cast(user)
		return

	if(!powerful)
		var/mob/selected = input(user, "Выберите цель для ворожбы.", "Заворожить") as null|anything in targets
		if(QDELETED(src) || QDELETED(user) || QDELETED(selected))
			if(!QDELETED(user))
				revert_cast(user)
			return
		targets = list(selected)

	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	user.say(transfix_msg, forced = "spell ([name])")
	if(powerful)
		user.visible_message(span_danger("Глаза [user] вспыхивают жутким красным светом!"))

	for(var/mob/living/carbon/human/target as anything in targets)
		if(QDELETED(target) || target.stat != CONSCIOUS)
			continue

		var/current_will_dice = will_dice
		if(target.cmode)
			current_will_dice += 1

		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, current_will_dice)
		var/knowledgable = (willroll - bloodroll) >= 3

		if(!powerful)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
					var/extra = "!"
					if(knowledgable)
						extra = ", кажется, это был [user]!"
					to_chat(target, span_notice("Серебряный крест сияет и защищает меня от нечестивой магии[extra]"))
					to_chat(user, span_userdanger("У [target] моя ПОГИБЕЛЬ! Я не могу опутать разум!"))
					continue

		if(bloodroll >= willroll)
			target.drowsyness = min(target.drowsyness + 50, 150)
			switch(target.drowsyness)
				if(0 to 50)
					to_chat(target, span_warning("Мой разум словно застилает пелена..."))
					to_chat(user, span_notice("Разум [target] слегка поддаётся."))
					target.Slowdown(20)
				if(51 to 90)
					to_chat(target, span_warning("Веки смыкаются, тело наполняет свинцовая усталость."))
					to_chat(user, span_notice("[target] долго не продержится."))
					force_close_eyes(target)
					target.Slowdown(50)
				if(91 to INFINITY)
					to_chat(target, span_userdanger("Больше не могу... Ноги подкашиваются, мир уплывает."))
					to_chat(user, span_boldnotice("[target] теперь мой."))
					force_close_eyes(target)
					target.Slowdown(50)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = round(target.get_skill_level(/datum/skill/magic/arcane) * 0.6, 1)
			var/counterroll = roll(1 + holypower + magicpower, 5)
			if(counterroll > bloodroll)
				to_chat(target, span_warning("Нечестивая магия... Кажется, она исходит от [user]."))

		to_chat(user, span_userdanger("Мне не удалось опутать разум [target]!"))
		to_chat(target, span_userdanger("Что-то не так в этом месте. Я чувствую, что моя жизнь под угрозой!"))

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/show_transfix_speech_failure(mob/user)
	if(is_transfix_mouth_blocked(user))
		to_chat(user, span_warning("Мой рот закрыт. Я не могу произнести фразу для ворожбы."))
		return

	to_chat(user, span_warning("Вы не можете говорить!"))

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/is_transfix_mouth_blocked(mob/user)
	if(!iscarbon(user))
		return FALSE

	var/mob/living/carbon/carbon_user = user
	if(carbon_user.is_muzzled() || carbon_user.is_mouth_covered())
		return TRUE
	if(carbon_user.mouth?.muteinmouth)
		return TRUE
	for(var/obj/item/grabbing/grab in carbon_user.grabbedby)
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/force_close_eyes(mob/living/carbon/human/target)
	target.eyesclosed = TRUE
	target.become_blind("eyelids")
	if(target.hud_used)
		for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
			eyet.update_icon(target)
