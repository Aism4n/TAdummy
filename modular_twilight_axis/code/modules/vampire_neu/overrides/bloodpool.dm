#define TA_CRUCIBLE_MAX_BLOOD 20000
#define TA_INITIATE_LORDE 1
#define TA_CRUCIBLE_MIN_DONOR_BLOOD BLOOD_VOLUME_SURVIVE
#define TA_CRUCIBLE_MIN_DONATION 500
#define TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE 300
#define TA_CRUCIBLE_DONATION_VITAE 3000
#define TA_CRUCIBLE_DONATION_BLOOD 400

/obj/structure/vampire/bloodpool/Initialize(mapload)
	. = ..()
	if(type == /obj/structure/vampire/bloodpool)
		var/obj/structure/vampire/bloodpool/TA/replacement = new /obj/structure/vampire/bloodpool/TA(loc)
		copy_state_to_modular_bloodpool(replacement)
		return INITIALIZE_HINT_QDEL

	active_projects = list()
	available_project_types = available_project_types?.Copy() || list()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)

/obj/structure/vampire/bloodpool/proc/copy_state_to_modular_bloodpool(obj/structure/vampire/bloodpool/TA/replacement)
	if(!replacement)
		return

	replacement.name = name
	replacement.desc = desc
	replacement.dir = dir
	replacement.pixel_x = pixel_x
	replacement.pixel_y = pixel_y
	replacement.color = color
	replacement.alpha = alpha
	replacement.current = current
	replacement.owner_clan = owner_clan
	replacement.sunstolen = sunstolen
	replacement.available_project_types = available_project_types?.Copy() || list()
	replacement.active_projects = active_projects || list()
	active_projects = list()

	for(var/project_key in replacement.active_projects)
		var/datum/vampire_project/project = replacement.active_projects[project_key]
		if(!project)
			continue
		project.bloodpool = replacement

/obj/structure/vampire/bloodpool/TA
	name = "Crimson Crucible"
	var/list/nonvampire_vitae_snapshots = list()

/obj/structure/vampire/bloodpool/TA/attack_hand(mob/living/user)
	remember_nonvampire_vitae(user)
	ui_interact(user)

/obj/structure/vampire/bloodpool/TA/ui_state(mob/user)
	return GLOB.tgui_always_state

/obj/structure/vampire/bloodpool/TA/ui_interact(mob/user, datum/tgui/ui)
	var/mob/living/living_user = user
	if(!istype(living_user))
		return

	remember_nonvampire_vitae(living_user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrimsonCrucible", "Багровое горнило")
		ui.open()

/obj/structure/vampire/bloodpool/TA/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/living_user = user
	var/is_lord = is_crucible_lord(living_user)
	var/is_vampire = is_crucible_vampire(living_user)
	var/list/active_project_data = list()
	var/list/available_project_data = list()
	var/committed_vitae = 0

	if(!istype(living_user))
		data["bloodLevel"] = current
		data["maxBlood"] = max(TA_CRUCIBLE_MAX_BLOOD, current)
		data["committedVitae"] = committed_vitae
		data["isLord"] = FALSE
		data["isVampire"] = FALSE
		data["canDepositBlood"] = FALSE
		data["maxCupDeposit"] = 0
		data["activeProjects"] = active_project_data
		data["availableProjects"] = available_project_data
		return data

	if(!is_vampire)
		remember_nonvampire_vitae(living_user)

	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		if(!project)
			continue

		var/remaining = max(project.total_cost - project.paid_amount, 0)
		var/max_contribution = get_project_max_contribution(project, living_user)
		var/can_contribute = can_accept_vitae_contribution(project, max_contribution, is_vampire)
		var/list/contributor_names = list()
		for(var/mob/living/contributor in project.contributors)
			UNTYPED_LIST_ADD(contributor_names, contributor.real_name || contributor.name)

		committed_vitae += project.paid_amount
		UNTYPED_LIST_ADD(active_project_data, list(
			"ref" = REF(project),
			"name" = project.ui_project_name(),
			"description" = project.ui_project_description(),
			"cost" = project.total_cost,
			"paid" = project.paid_amount,
			"remaining" = remaining,
			"progress" = project.total_cost ? round((project.paid_amount / project.total_cost) * 100, 0.1) : 100,
			"isLordOnly" = project.can_be_initiated_by == TA_INITIATE_LORDE,
			"canContribute" = can_contribute,
			"maxContribution" = max_contribution,
			"maxBloodCost" = is_vampire ? 0 : get_blood_cost_for_vitae(max_contribution),
			"contributors" = contributor_names,
		))

	if(is_vampire)
		for(var/project_type in available_project_types)
			if(project_type in active_projects)
				continue

			var/datum/vampire_project/project = new project_type()
			var/can_start = project.can_start(living_user, src, TRUE)
			UNTYPED_LIST_ADD(available_project_data, list(
				"type_path" = "[project_type]",
				"name" = project.ui_project_name(),
				"description" = project.ui_project_description(),
				"cost" = project.total_cost,
				"isLordOnly" = project.can_be_initiated_by == TA_INITIATE_LORDE,
				"canStart" = is_lord && can_start,
				"lockedReason" = get_project_locked_reason(project, is_lord, can_start),
			))
			qdel(project)

	data["bloodLevel"] = current
	data["maxBlood"] = max(TA_CRUCIBLE_MAX_BLOOD, current)
	data["committedVitae"] = committed_vitae
	data["isLord"] = is_lord
	data["isVampire"] = is_vampire
	var/max_cup_deposit = get_max_cup_deposit(living_user)
	data["canDepositBlood"] = can_accept_cup_deposit(living_user, max_cup_deposit, is_vampire)
	data["maxCupDeposit"] = max_cup_deposit
	data["activeProjects"] = active_project_data
	data["availableProjects"] = available_project_data
	return data

/obj/structure/vampire/bloodpool/TA/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/mob/living/user = ui.user
	if(!istype(user))
		return TRUE
	remember_nonvampire_vitae(user)
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("Мне нужно быть рядом с горнилом."))
		return TRUE

	switch(action)
		if("start_project")
			if(!is_crucible_vampire(user))
				return TRUE
			var/project_path = params["type_path"]
			if(!project_path)
				project_path = params["typePath"]
			var/project_type = text2path(project_path)
			if(!ispath(project_type, /datum/vampire_project) || !(project_type in available_project_types) || (project_type in active_projects))
				to_chat(user, span_warning("Горнило не смогло распознать этот ритуал."))
				return TRUE
			if(!is_crucible_lord(user))
				to_chat(user, span_warning("Только владыка клана может начинать новые ритуалы."))
				return TRUE
			start_new_project_tgui(project_type, user)
			return TRUE
		if("contribute")
			var/datum/vampire_project/project = get_active_project_by_ref(params["ref"])
			if(!project)
				return TRUE
			contribute_to_project(project, user)
			return TRUE
		if("deposit_blood")
			deposit_blood_to_cup(user)
			return TRUE
		if("cancel_project")
			if(!is_crucible_vampire(user))
				return TRUE
			var/datum/vampire_project/project = get_active_project_by_ref(params["ref"])
			var/project_type = get_active_project_type(project)
			if(!project || !project_type)
				return TRUE
			if(!is_crucible_lord(user))
				to_chat(user, span_warning("Только владыка клана может отменять ритуалы."))
				return TRUE
			if(tgui_alert(user, "Отменить ритуал \"[project.ui_project_name()]\"? Вложенная кровь будет возвращена участникам.", "Багровое горнило", list("Отменить ритуал", "Назад")) != "Отменить ритуал")
				return TRUE
			if(QDELETED(src) || !is_crucible_lord(user) || active_projects[project_type] != project)
				return TRUE
			cancel_project(project_type)
			SStgui.update_uis(src)
			return TRUE
	return FALSE

/obj/structure/vampire/bloodpool/TA/proc/is_crucible_lord(mob/living/user)
	if(!istype(user))
		return FALSE
	return user.clan?.clan_leader == user

/obj/structure/vampire/bloodpool/TA/proc/is_crucible_vampire(mob/living/user)
	if(!istype(user))
		return FALSE
	return !!user.mind?.has_antag_datum(/datum/antagonist/vampire)

/obj/structure/vampire/bloodpool/TA/proc/get_nonvampire_crucible_bloodpool(mob/living/user, bloodpool_amount)
	if(!istype(user))
		return 0
	return max(min(bloodpool_amount, user.maxbloodpool), 0)

/obj/structure/vampire/bloodpool/TA/proc/get_nonvampire_vitae_from_bloodpool(mob/living/user, bloodpool_amount)
	return get_nonvampire_crucible_bloodpool(user, bloodpool_amount) * CLIENT_VITAE_MULTIPLIER

/obj/structure/vampire/bloodpool/TA/proc/get_nonvampire_bloodpool_cost_for_vitae(vitae_amount)
	if(vitae_amount <= 0)
		return 0
	return CEILING(vitae_amount / CLIENT_VITAE_MULTIPLIER, 1)

/obj/structure/vampire/bloodpool/TA/proc/remember_nonvampire_vitae(mob/living/user)
	if(!istype(user) || is_crucible_vampire(user))
		return
	if(!nonvampire_vitae_snapshots)
		nonvampire_vitae_snapshots = list()

	var/current_bloodpool = get_nonvampire_crucible_bloodpool(user, user.bloodpool)
	var/user_ref = REF(user)
	var/list/vitae_snapshot = nonvampire_vitae_snapshots[user_ref]
	if(!islist(vitae_snapshot))
		vitae_snapshot = list(
			"bloodpool" = current_bloodpool,
			"blood_volume" = user.blood_volume
		)
		nonvampire_vitae_snapshots[user_ref] = vitae_snapshot
		return

	var/snapshotted_blood_volume = vitae_snapshot["blood_volume"] || 0
	if(user.blood_volume < snapshotted_blood_volume)
		vitae_snapshot["bloodpool"] = current_bloodpool
		vitae_snapshot["blood_volume"] = user.blood_volume
		return

	var/snapshotted_bloodpool = vitae_snapshot["bloodpool"] || 0
	if(current_bloodpool > snapshotted_bloodpool)
		vitae_snapshot["bloodpool"] = current_bloodpool
		vitae_snapshot["blood_volume"] = user.blood_volume

/obj/structure/vampire/bloodpool/TA/proc/clear_nonvampire_vitae_snapshot(mob/living/user)
	if(!istype(user) || !nonvampire_vitae_snapshots)
		return
	nonvampire_vitae_snapshots -= REF(user)

/obj/structure/vampire/bloodpool/TA/proc/get_nonvampire_snapshotted_vitae(mob/living/user)
	if(!istype(user) || !nonvampire_vitae_snapshots)
		return 0

	var/list/vitae_snapshot = nonvampire_vitae_snapshots[REF(user)]
	if(!islist(vitae_snapshot))
		return 0

	var/snapshotted_blood_volume = vitae_snapshot["blood_volume"] || 0
	if(user.blood_volume < snapshotted_blood_volume)
		clear_nonvampire_vitae_snapshot(user)
		return get_nonvampire_vitae_from_bloodpool(user, user.bloodpool)

	return get_nonvampire_vitae_from_bloodpool(user, vitae_snapshot["bloodpool"] || 0)

/obj/structure/vampire/bloodpool/TA/proc/get_available_vitae_for_contribution(mob/living/user, is_vampire)
	if(!istype(user))
		return 0

	if(is_vampire)
		var/available_vitae = get_vampire_personal_vitae_for_crucible(user)
		if(is_crucible_lord(user))
			available_vitae += current
		return available_vitae

	var/snapshotted_vitae = get_nonvampire_snapshotted_vitae(user)
	return max(get_nonvampire_vitae_from_bloodpool(user, user.bloodpool), snapshotted_vitae)

/obj/structure/vampire/bloodpool/TA/proc/get_vampire_personal_vitae_for_crucible(mob/living/user)
	if(!istype(user))
		return 0
	return max(user.bloodpool - TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE, 0)

/obj/structure/vampire/bloodpool/TA/proc/get_cup_space()
	return max(TA_CRUCIBLE_MAX_BLOOD - current, 0)

/obj/structure/vampire/bloodpool/TA/proc/get_max_cup_deposit(mob/living/user)
	if(!istype(user))
		return 0
	if(is_crucible_vampire(user))
		return min(get_vampire_personal_vitae_for_crucible(user), get_cup_space())
	return min(get_available_vitae_for_contribution(user, FALSE), get_blood_limited_vitae(user), get_cup_space())

/obj/structure/vampire/bloodpool/TA/proc/can_accept_cup_deposit(mob/living/user, deposit, is_vampire)
	if(!istype(user) || deposit < 1 || get_cup_space() <= 0)
		return FALSE
	if(is_vampire)
		return TRUE
	return deposit >= TA_CRUCIBLE_MIN_DONATION

/obj/structure/vampire/bloodpool/TA/proc/get_project_locked_reason(datum/vampire_project/project, is_lord, can_start)
	if(!is_lord)
		return "Начинать ритуалы может только владыка клана."
	if(can_start)
		return ""
	if(project.start_failure_message)
		return project.ui_project_start_failure()
	return "Условия ритуала еще не выполнены."

/obj/structure/vampire/bloodpool/TA/proc/get_active_project_by_ref(project_ref)
	if(!istext(project_ref))
		return null

	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		if(project && REF(project) == project_ref)
			return project

/obj/structure/vampire/bloodpool/TA/proc/get_active_project_type(datum/vampire_project/project)
	if(!project)
		return null

	for(var/project_type in active_projects)
		if(active_projects[project_type] == project)
			return project_type

/obj/structure/vampire/bloodpool/TA/proc/get_project_max_contribution(datum/vampire_project/project, mob/living/user)
	if(!project || !istype(user))
		return 0

	var/is_vampire = is_crucible_vampire(user)
	var/max_contribution = min(get_available_vitae_for_contribution(user, is_vampire), max(project.total_cost - project.paid_amount, 0))
	if(is_vampire)
		if(!is_crucible_lord(user) && project.display_name != "Wicked Plate" && project.display_name != "World Anchor")
			max_contribution = min(max_contribution, max((project.total_cost - project.paid_amount) - 100, 0))
	else
		max_contribution = min(max_contribution, get_blood_limited_vitae(user))
	if(max_contribution < 0)
		max_contribution = 0

	return max(round(max_contribution), 0)

/obj/structure/vampire/bloodpool/TA/proc/can_accept_vitae_contribution(datum/vampire_project/project, contribution, is_vampire)
	if(!project || contribution < 1)
		return FALSE

	var/remaining = max(project.total_cost - project.paid_amount, 0)
	if(remaining <= 0)
		return FALSE
	if(is_vampire)
		return TRUE
	return contribution >= TA_CRUCIBLE_MIN_DONATION

/obj/structure/vampire/bloodpool/TA/proc/get_blood_limited_vitae(mob/living/user)
	if(!istype(user))
		return 0

	var/available_blood = max(user.blood_volume - TA_CRUCIBLE_MIN_DONOR_BLOOD, 0)
	return max(FLOOR((available_blood * TA_CRUCIBLE_DONATION_VITAE) / TA_CRUCIBLE_DONATION_BLOOD, 1), 0)

/obj/structure/vampire/bloodpool/TA/proc/get_blood_cost_for_vitae(vitae_amount)
	if(vitae_amount <= 0)
		return 0

	return CEILING((vitae_amount * TA_CRUCIBLE_DONATION_BLOOD) / TA_CRUCIBLE_DONATION_VITAE, 1)

/obj/structure/vampire/bloodpool/TA/proc/start_new_project_tgui(project_type, mob/living/user)
	var/datum/vampire_project/project = new project_type()

	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.ui_project_start_failure()))
		qdel(project)
		return

	if(QDELETED(src) || !istype(user) || !is_crucible_vampire(user) || !is_crucible_lord(user))
		qdel(project)
		return
	if(!ispath(project_type, /datum/vampire_project) || !(project_type in available_project_types) || (project_type in active_projects))
		qdel(project)
		return
	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.ui_project_start_failure()))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.on_start(user)

	active_projects[project_type] = project
	to_chat(user, span_greentext("Ритуал \"[project.ui_project_name()]\" начат. Теперь горнилу нужна витэ."))
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/TA/proc/deposit_blood_to_cup(mob/living/user)
	if(!istype(user))
		return

	var/is_vampire = is_crucible_vampire(user)
	var/max_deposit = get_max_cup_deposit(user)
	if(!can_accept_cup_deposit(user, max_deposit, is_vampire))
		if(get_cup_space() <= 0)
			to_chat(user, span_warning("Чаша горнила уже полна."))
		else if(is_vampire)
			to_chat(user, span_warning("Последние [TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE] витэ нельзя отдать горнилу."))
		else
			to_chat(user, span_warning("Горнило требует не меньше [TA_CRUCIBLE_MIN_DONATION] витэ за раз."))
		return

	var/deposit = max_deposit
	if(is_vampire)
		deposit = tgui_input_number(user, "Сколько витэ влить в чашу? Максимум: [max_deposit].", "Багровое горнило", max_deposit, max_deposit, 1)
		if(!deposit || QDELETED(src) || QDELETED(user))
			return
		if(get_dist(user, src) > 1 || !is_crucible_vampire(user))
			return

	max_deposit = get_max_cup_deposit(user)
	if(!can_accept_cup_deposit(user, max_deposit, is_vampire))
		return
	deposit = clamp(round(deposit), 1, max_deposit)
	if(deposit < 1)
		return

	var/blood_cost = 0
	if(is_vampire)
		user.adjust_bloodpool(-deposit)
	else
		blood_cost = get_blood_cost_for_vitae(deposit)
		if(user.blood_volume - blood_cost < TA_CRUCIBLE_MIN_DONOR_BLOOD)
			to_chat(user, span_warning("Горнило не возьмет столько крови. Мне нужно остаться хотя бы с [TA_CRUCIBLE_MIN_DONOR_BLOOD]."))
			return
		var/bloodpool_cost = get_nonvampire_bloodpool_cost_for_vitae(deposit)
		user.bloodpool = max(get_nonvampire_crucible_bloodpool(user, user.bloodpool) - bloodpool_cost, 0)
		user.blood_volume = max(user.blood_volume - blood_cost, TA_CRUCIBLE_MIN_DONOR_BLOOD)
		clear_nonvampire_vitae_snapshot(user)

	current = min(current + deposit, TA_CRUCIBLE_MAX_BLOOD)
	if(is_vampire)
		to_chat(user, span_greentext("Я влил [deposit] витэ в чашу горнила. ([current]/[TA_CRUCIBLE_MAX_BLOOD])"))
	else
		to_chat(user, span_userdanger("Проклятая магия вытягивает из вас все силы."))
		to_chat(user, span_greentext("Я отдал свою кровь чаше горнила. Чаша приняла [deposit] витэ. ([current]/[TA_CRUCIBLE_MAX_BLOOD])"))
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/TA/proc/contribute_to_project(datum/vampire_project/project, mob/living/user)
	var/project_type = get_active_project_type(project)
	if(!project_type)
		return

	var/max_contribution = get_project_max_contribution(project, user)
	var/is_vampire = is_crucible_vampire(user)
	if(!can_accept_vitae_contribution(project, max_contribution, is_vampire))
		if(is_vampire)
			if(user.bloodpool <= TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE)
				to_chat(user, span_warning("Последние [TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE] витэ нельзя отдать горнилу."))
			else
				to_chat(user, span_warning("Мне нечего пожертвовать этому ритуалу."))
		else
			to_chat(user, span_warning("Горнило требует не меньше [TA_CRUCIBLE_MIN_DONATION] витэ за раз."))
		return

	var/contribution = max_contribution
	if(is_vampire)
		contribution = tgui_input_number(user, "Сколько витэ пожертвовать в \"[project.ui_project_name()]\"? Максимум: [max_contribution].", "Багровое горнило", max_contribution, max_contribution, 1)
		if(!contribution || QDELETED(src) || QDELETED(project))
			return
		if(active_projects[project_type] != project || get_dist(user, src) > 1)
			return
		max_contribution = get_project_max_contribution(project, user)
		contribution = clamp(round(contribution), 1, max_contribution)
		if(contribution < 1)
			return

	var/blood_cost = 0
	if(!is_vampire)
		blood_cost = get_blood_cost_for_vitae(contribution)
		if(user.blood_volume - blood_cost < TA_CRUCIBLE_MIN_DONOR_BLOOD)
			to_chat(user, span_warning("Горнило не возьмет столько крови. Мне нужно остаться хотя бы с [TA_CRUCIBLE_MIN_DONOR_BLOOD]."))
			return

	if(get_available_vitae_for_contribution(user, is_vampire) < contribution)
		to_chat(user, span_warning("Мне не хватает витэ."))
		return

	var/cup_contribution = 0
	var/personal_contribution = contribution
	if(is_vampire && is_crucible_lord(user))
		cup_contribution = min(current, contribution)
		personal_contribution = contribution - cup_contribution

	if(is_vampire)
		if(personal_contribution > get_vampire_personal_vitae_for_crucible(user))
			to_chat(user, span_warning("Мне не хватает витэ."))
			return
		current = max(current - cup_contribution, 0)
		if(personal_contribution > 0)
			user.adjust_bloodpool(-personal_contribution)
	else
		var/bloodpool_cost = get_nonvampire_bloodpool_cost_for_vitae(contribution)
		user.bloodpool = max(get_nonvampire_crucible_bloodpool(user, user.bloodpool) - bloodpool_cost, 0)
	if(!is_vampire)
		user.blood_volume = max(user.blood_volume - blood_cost, TA_CRUCIBLE_MIN_DONOR_BLOOD)
		clear_nonvampire_vitae_snapshot(user)
	project.paid_amount += contribution
	project.TA_cup_paid_amount += cup_contribution
	if(!(user in project.contributors))
		project.contributors += user

	if(is_vampire)
		if(cup_contribution > 0)
			to_chat(user, span_greentext("Я направил [contribution] витэ в \"[project.ui_project_name()]\". Из чаши: [cup_contribution], моей крови: [personal_contribution]. ([project.paid_amount]/[project.total_cost])"))
		else
			to_chat(user, span_greentext("Я пожертвовал [contribution] витэ в \"[project.ui_project_name()]\". ([project.paid_amount]/[project.total_cost])"))
	else
		to_chat(user, span_userdanger("Проклятая магия вытягивает из вас все силы."))
		if(project.paid_amount >= project.total_cost)
			to_chat(user, span_greentext("Я отдал свои силы для проклятого ритуала! Ритуал \"[project.ui_project_name()]\" завершен."))
		else
			to_chat(user, span_greentext("Я отдал свои силы для проклятого ритуала! Ритуал \"[project.ui_project_name()]\" прогрессирует. ([project.paid_amount]/[project.total_cost])"))
	if(project.paid_amount >= project.total_cost)
		complete_project(project_type)
	else
		SStgui.update_uis(src)

/datum/vampire_project
	var/TA_cup_paid_amount = 0

/datum/vampire_project/on_cancel()
	if(TA_cup_paid_amount > 0 && bloodpool)
		bloodpool.current = min(bloodpool.current + TA_cup_paid_amount, TA_CRUCIBLE_MAX_BLOOD)
		paid_amount = max(paid_amount - TA_cup_paid_amount, 0)
		TA_cup_paid_amount = 0
	if(paid_amount <= 0)
		return
	return ..()

/datum/vampire_project/proc/ui_project_name()
	switch(display_name)
		if("Rite of Stirring")
			return "Обряд пробуждения"
		if("Rite of Reclamation")
			return "Обряд возвращения"
		if("Rite of Dominion")
			return "Обряд владычества"
		if("Rite of Sovereignty")
			return "Обряд суверенитета"
		if("Wicked Plate")
			return "Порочные латы"
		if("Steal the Sun")
			return "Украсть солнце"
		if("Summon Servant")
			return "Призвать слугу"
		if("Summon Guard")
			return "Призвать стража"
		if("Summon Knight Spawn")
			return "Призвать рыцаря-отродье"
	return display_name

/datum/vampire_project/proc/ui_project_description()
	switch(display_name)
		if("Rite of Stirring")
			return "Древняя кровь вновь шевелится. Забытые шепоты отзываются в костях земли. Владыка рядом с горнилом получает +2 ко всем характеристикам и +1000 к запасу витэ. Открывает следующий этап вознесения."
		if("Rite of Reclamation")
			return "Запечатанная сила возвращается. Почва, камень и тени вспоминают своего хозяина. Владыка рядом с горнилом получает еще +2 ко всем характеристикам и +1000 к запасу витэ. Открывает третий этап."
		if("Rite of Dominion")
			return "Завеса времени рвется. Воля Старшего связывает незваных в хватке Земли. Владыка рядом с горнилом получает еще +2 ко всем характеристикам и +1000 к запасу витэ. Открывает финальный ритуал."
		if("Rite of Sovereignty")
			return "Владыка становится целым. Древняя мощь насыщает каждый камень и каждую жилу. Владыка возносится: получает +2 ко всем характеристикам и +1000 к запасу витэ. Все подчиненные клана получают такой же дар."
		if("Wicked Plate")
			return "Полный комплект вампирских лат из кристаллизованной крови."
		if("Steal the Sun")
			return "Жгучий взор Солнца-Тирана больше не должен мешать планам клана."
		if("Summon Servant")
			return "Верный слуга поднимется из глубин багрового горнила."
		if("Summon Guard")
			return "Страж с кровью клана ответит на зов."
		if("Summon Knight Spawn")
			return "Сильное отродье в рыцарском обличье выйдет из горнила."
	return description

/datum/vampire_project/proc/ui_project_start_failure()
	switch(start_failure_message)
		if("This project cannot be started.")
			return "Этот ритуал нельзя начать."
		if("This project can only be initiate by your Lorde.")
			return "Этот ритуал может начать только владыка клана."
	return start_failure_message

#undef TA_CRUCIBLE_MAX_BLOOD
#undef TA_INITIATE_LORDE
#undef TA_CRUCIBLE_MIN_DONOR_BLOOD
#undef TA_CRUCIBLE_MIN_DONATION
#undef TA_CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE
#undef TA_CRUCIBLE_DONATION_VITAE
#undef TA_CRUCIBLE_DONATION_BLOOD
