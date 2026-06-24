/proc/resident_manuscript_uses_rockhill_titles()
	return SSmapping.config?.map_name == "Rockhill"

/datum/resident_document_role_rule
	var/document_type
	var/list/job_titles
	var/list/job_types
	var/list/advclass_types
	var/priority = 0

/datum/resident_document_role_rule/proc/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	if(!job_title)
		return FALSE
	if(LAZYLEN(job_titles) && (job_title in job_titles))
		return TRUE
	if(LAZYLEN(job_types))
		var/datum/job/job = SSjob.GetJob(job_title)
		for(var/job_type in job_types)
			if(istype(job, job_type))
				return TRUE
	if(LAZYLEN(advclass_types) && user.advjob)
		var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
		for(var/advclass_type in advclass_types)
			if(istype(advclass, advclass_type))
				return TRUE
	return FALSE

/datum/resident_document_role_rule/merchant
	document_type = /obj/item/book/granter/resident_manuscript/merchant
	job_titles = list("Merchant", "Shophand")
	priority = 100

/datum/resident_document_role_rule/innkeeper
	document_type = /obj/item/book/granter/resident_manuscript/commoner
	job_titles = list("Innkeeper")
	priority = 100

/datum/resident_document_role_rule/bathmaster
	document_type = /obj/item/book/granter/resident_manuscript/commoner
	job_titles = list("Bathmaster")
	priority = 100

/datum/resident_document_role_rule/mages
	document_type = /obj/item/book/granter/resident_manuscript/mages
	job_titles = list("Court Magician", "Magicians Associate")
	priority = 100

/datum/resident_document_role_rule/mercenary
	document_type = /obj/item/book/granter/resident_manuscript/mercenary
	job_titles = list("Mercenary")
	priority = 100

/datum/resident_document_role_rule/garrison
	document_type = /obj/item/book/granter/resident_manuscript/guards
	priority = 50

/datum/resident_document_role_rule/garrison/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && ((job_title in GLOB.garrison_positions) || (job_title in GLOB.citywatch_positions) || (job_title in GLOB.vanguard_positions))

/datum/resident_document_role_rule/church
	document_type = /obj/item/book/granter/resident_manuscript/church
	priority = 50

/datum/resident_document_role_rule/church/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.church_positions)

/datum/resident_document_role_rule/inquisition
	document_type = /obj/item/book/granter/resident_manuscript/otava
	priority = 50

/datum/resident_document_role_rule/inquisition/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.inquisition_positions)

/datum/resident_document_role_rule/craftsmen
	document_type = /obj/item/book/granter/resident_manuscript/craftsmen
	priority = 50

/datum/resident_document_role_rule/craftsmen/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.burgher_positions)

/datum/resident_document_role_rule/wanderer
	document_type = /obj/item/book/granter/resident_manuscript/roundstart
	priority = 25

/datum/resident_document_role_rule/wanderer/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.wanderer_positions)

/datum/resident_document_role_rule/noble_fallback
	document_type = /obj/item/book/granter/resident_manuscript/roundstart
	priority = -10

/datum/resident_document_role_rule/noble_fallback/matches(mob/living/carbon/human/user)
	return ishuman(user) && HAS_TRAIT(user, TRAIT_NOBLE)

/datum/resident_document_role_rule/commoner_fallback
	document_type = /obj/item/book/granter/resident_manuscript/commoner
	priority = -100

/datum/resident_document_role_rule/commoner_fallback/matches(mob/living/carbon/human/user)
	return ishuman(user) && user.mind

/proc/get_resident_document_role_rules()
	var/static/list/cached
	if(!cached)
		cached = list()
		for(var/rule_type in subtypesof(/datum/resident_document_role_rule))
			cached += new rule_type
		sortTim(cached, GLOBAL_PROC_REF(cmp_resident_document_role_rule_priority))
	return cached

/proc/cmp_resident_document_role_rule_priority(datum/resident_document_role_rule/a, datum/resident_document_role_rule/b)
	return b.priority - a.priority

/proc/get_default_manuscript_type_for_job(mob/living/carbon/human/recipient)
	if(!recipient || !recipient.mind)
		return null
	for(var/datum/resident_document_role_rule/rule as anything in get_resident_document_role_rules())
		if(rule.matches(recipient))
			return rule.document_type
	return null

/datum/resident_manuscript_seal_rule
	var/key
	var/title
	var/stamper
	var/list/job_types
	var/list/advclass_types
	var/priority = 0
	var/list/allowed_statuses

/datum/resident_manuscript_seal_rule/proc/can_stamp(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/datum/job/job = SSjob.GetJob(user.mind?.assigned_role)
	for(var/job_type in job_types)
		if(istype(job, job_type))
			return TRUE
	var/datum/advclass/advclass
	if(user.advjob)
		advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
	for(var/advclass_type in advclass_types)
		if(istype(advclass, advclass_type))
			return TRUE
	return FALSE

/datum/resident_manuscript_seal_rule/proc/can_apply_to_status(status_key)
	if(!LAZYLEN(allowed_statuses))
		return TRUE
	return status_key in allowed_statuses

/datum/resident_manuscript_seal_rule/proc/get_title()
	return title || key

/datum/resident_manuscript_seal_rule/proc/get_stamper()
	return stamper || get_title()

/datum/resident_manuscript_seal_rule/elder
	key = "elder"
	title = "Старейшина"
	stamper = "Старейшина"
	advclass_types = list(/datum/advclass/elder)
	priority = RESIDENT_SEAL_PRIORITY_ELDER

/datum/resident_manuscript_seal_rule/elder/can_stamp(mob/living/carbon/human/user)
	if(..())
		return TRUE
	if(!resident_manuscript_uses_rockhill_titles() || !ishuman(user))
		return FALSE
	var/job_title = user.job || user.mind?.assigned_role
	var/datum/job/job = SSjob.GetJob(job_title)
	if(istype(job, /datum/job/roguetown/mayor))
		return TRUE
	var/datum/advclass/advclass
	if(user.advjob)
		advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
	if(istype(advclass, /datum/advclass/mayor))
		return TRUE
	if(job_title == "Mayor" || user.advjob == "Mayor")
		return TRUE
	return FALSE

/datum/resident_manuscript_seal_rule/elder/get_title()
	if(resident_manuscript_uses_rockhill_titles())
		return "Мэр"
	return ..()

/datum/resident_manuscript_seal_rule/elder/get_stamper()
	if(resident_manuscript_uses_rockhill_titles())
		return "Мэр"
	return ..()

/datum/resident_manuscript_seal_rule/chancellor
	key = "chancellor"
	title = "Канцлер"
	stamper = "Канцлер"
	job_types = list(/datum/job/roguetown/councillor)
	priority = RESIDENT_SEAL_PRIORITY_CHANCELLOR

/datum/resident_manuscript_seal_rule/hand
	key = "hand"
	title = "Десница"
	stamper = "Десница"
	job_types = list(/datum/job/roguetown/hand)
	priority = RESIDENT_SEAL_PRIORITY_HAND

/datum/resident_manuscript_seal_rule/ruler
	key = "ruler"
	title = "Герцог"
	stamper = "Герцог"
	job_types = list(/datum/job/roguetown/lord)
	priority = RESIDENT_SEAL_PRIORITY_RULER
	allowed_statuses = list(RESIDENT_MANUSCRIPT_STATUS_NOBLE)

/datum/resident_manuscript_seal_rule/ruler/get_title()
	if(resident_manuscript_uses_rockhill_titles())
		return "Король"
	return ..()

/datum/resident_manuscript_seal_rule/ruler/get_stamper()
	if(resident_manuscript_uses_rockhill_titles())
		return "Король"
	return ..()

/datum/resident_manuscript_seal_rule/sergeant
	key = "sergeant"
	title = "Сержант"
	stamper = "Сержант стражи"
	job_types = list(/datum/job/roguetown/sergeant)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_LOW

/datum/resident_manuscript_seal_rule/marshal
	key = "marshal"
	title = "Маршал"
	stamper = "Маршал"
	job_types = list(/datum/job/roguetown/marshal)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/bishop
	key = "bishop"
	title = "Епископ"
	stamper = "Епископ"
	job_types = list(/datum/job/roguetown/priest)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/guild_leader
	key = "guild_leader"
	title = "Глава гильдии"
	stamper = "Глава гильдии"
	advclass_types = list(/datum/advclass/guildmaster)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/inquisitor
	key = "inquisitor"
	title = "Инквизитор"
	stamper = "Инквизитор"
	job_types = list(/datum/job/roguetown/inquisitor)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/court_magician
	key = "court_magician"
	title = "Придворный маг"
	stamper = "Придворный маг"
	job_types = list(/datum/job/roguetown/magician)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/datum/resident_manuscript_seal_rule/merchant_master
	key = "merchant_master"
	title = "Старший торговец"
	stamper = "Старший торговец"
	job_types = list(/datum/job/roguetown/merchant)
	priority = RESIDENT_SEAL_PRIORITY_FACTION_MID

/proc/get_resident_manuscript_seal_rules()
	var/static/list/seal_rules
	if(!seal_rules)
		seal_rules = list()
		for(var/rule_type in subtypesof(/datum/resident_manuscript_seal_rule))
			var/datum/resident_manuscript_seal_rule/rule = rule_type
			var/key = initial(rule.key)
			if(!key)
				continue
			seal_rules[key] = rule_type
	return seal_rules

/datum/resident_document_profile
	var/id
	var/display_name
	var/subtitle
	var/description
	var/list/allowed_seals
	var/list/default_seal_keys
	var/list/default_commoner_seal_keys
	var/list/default_noble_seal_keys
	var/paper_color
	var/ink_color
	var/accent_color
	var/seal_color
	var/requires_seal_for_claim = TRUE
	var/grants_residence_claim = FALSE

/datum/resident_document_profile/proc/has_seal(seal_key)
	return seal_key && (seal_key in allowed_seals)

/datum/resident_document_profile/proc/get_default_seal_keys(status_key)
	if(status_key == RESIDENT_MANUSCRIPT_STATUS_NOBLE && default_noble_seal_keys)
		return default_noble_seal_keys
	if(status_key == RESIDENT_MANUSCRIPT_STATUS_COMMONER && default_commoner_seal_keys)
		return default_commoner_seal_keys
	return default_seal_keys || allowed_seals

/datum/resident_document_profile/proc/get_display_name()
	return display_name

/datum/resident_document_profile/proc/get_subtitle()
	return subtitle

/datum/resident_document_profile/proc/get_description()
	return description

/datum/resident_document_profile/resident
	id = "resident"
	display_name = "Грамота жителя"
	subtitle = "Под рукой Короны"
	description = "Да будет ведомо: под холодным коронным воском и черными чернилами предъявитель числится среди названных душ этих земель. Врата, очаг и виселица должны знать его имя, пока закон или смерть не вычеркнут его из реестра."
	allowed_seals = list("chancellor", "elder", "ruler", "hand")
	default_commoner_seal_keys = list("chancellor")
	default_noble_seal_keys = list("ruler")
	paper_color = "#e3d2ad"
	ink_color = "#3a2518"
	accent_color = "#8b5e2f"
	seal_color = "#8b2a22"
	grants_residence_claim = TRUE

/datum/resident_document_profile/guards
	id = "guards"
	display_name = "Гарнизонная грамота"
	subtitle = "От гарнизона и Короны"
	description = "Да будет ведомо: предъявитель стоит солдатом городского гарнизона, присягнув держать врата, стены и улицы, когда обнажается сталь. Его служба проста как железо: ночные дозоры, кровь на камне и жалованье за верность."
	allowed_seals = list("sergeant", "marshal", "elder")
	paper_color = "#d9cfb0"
	ink_color = "#2f3028"
	accent_color = "#4c6f79"
	seal_color = "#6d2a24"

/datum/resident_document_profile/church
	id = "church"
	display_name = "Церковная грамота веры"
	subtitle = "Под Десятеричным Светом"
	description = "Да будет ведомо: предъявитель отмечен под Десятеричным Светом, где милость горит так же остро, как суд. Пусть святилище и алтарь принимают его, пока тень или ересь не взыщут его имя."
	allowed_seals = list("bishop")
	paper_color = "#ead8ad"
	ink_color = "#322414"
	accent_color = "#9c7440"
	seal_color = "#8d5b35"

/datum/resident_document_profile/craftsmen
	id = "craftsmen"
	display_name = "Хартия ремесленной гильдии"
	subtitle = "Честной рукой и бронзой"
	description = "Да будет ведомо: предъявитель связан с горном, шилом, резцом и клятвой. Его труд может идти под защитой гильдии, а долг ремеслу будет взвешен монетой, потом и кровью."
	allowed_seals = list("guild_leader", "chancellor", "elder")
	paper_color = "#ded1a9"
	ink_color = "#2f2b19"
	accent_color = "#7b7f4a"
	seal_color = "#7a432a"

/datum/resident_document_profile/commoner
	id = "commoner"
	display_name = "Грамота горожанина"
	subtitle = "Знаком городского старейшины"
	description = "Да будет ведомо: предъявитель есть простая душа города, вписанная дешевыми чернилами на грубой бумаге. Ему дозволено быть среди законного люда без блеска, привилегий и дворянской милости."
	allowed_seals = list("elder", "chancellor", "hand")
	default_commoner_seal_keys = list("elder", "chancellor")
	default_noble_seal_keys = list("hand")
	paper_color = "#c4ad81"
	ink_color = "#352618"
	accent_color = "#6f5840"
	seal_color = "#5e3826"
	requires_seal_for_claim = FALSE

/datum/resident_document_profile/commoner/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "Знаком городского мэра"
	return ..()

/datum/resident_document_profile/merchant
	id = "merchant"
	display_name = "Хартия торговой лавки"
	subtitle = "Монетой и клыком"
	description = "Да будет ведомо: предъявитель служит счетному дому, где монету взвешивают как грех, а каждая сделка имеет тень. Его торговля законна, его книги подотчетны, а долги памятны."
	allowed_seals = list("merchant_master", "chancellor")
	paper_color = "#e0c79a"
	ink_color = "#2a1a10"
	accent_color = "#a35c2a"
	seal_color = "#7e2418"

/datum/resident_document_profile/mages
	id = "mages"
	display_name = "Патент гильдии магов"
	subtitle = "Светом Короны, звездой и сигилом"
	description = "Да будет ведомо: коронным дозволением и гильдейским знаком предъявитель вправе иметь дело со звездой, зельем и призванным шепотом. Пусть никто не препятствует его искусству, пока само искусство не возжаждет сорваться с цепи."
	allowed_seals = list("court_magician")
	paper_color = "#dccdde"
	ink_color = "#1c1226"
	accent_color = "#6a4490"
	seal_color = "#3d1d5a"

/datum/resident_document_profile/mercenary
	id = "mercenary"
	display_name = "Наемный контракт"
	subtitle = "Монетой, сталью и словом"
	description = "Да будет ведомо: предъявитель есть клинок, проданный при свидетеле и связанный монетой, сталью и словом капитана. Он может проливать кровь по договору и отвечать за нее, когда высохнут чернила."
	allowed_seals = list("elder", "chancellor", "hand")
	default_commoner_seal_keys = list("elder", "chancellor")
	default_noble_seal_keys = list("hand")
	paper_color = "#d7b88e"
	ink_color = "#2c1d16"
	accent_color = "#8c5b3a"
	seal_color = "#6f3327"

/datum/resident_document_profile/otava
	id = "otava"
	display_name = "Инквизиторский эдикт"
	subtitle = "Истиной, дознанием и очищающим пламенем"
	description = "Да будет ведомо: серебряным эдиктом Отавы предъявитель вправе вырывать истину из запертых уст и призывать пламя на гниль ереси. Преградить ему путь значит встать там, где причитается пепел."
	allowed_seals = list("inquisitor")
	paper_color = "#d8d1c0"
	ink_color = "#18130f"
	accent_color = "#8f7a48"
	seal_color = "#1f1a14"

/proc/get_resident_document_profiles()
	var/static/list/profiles
	if(!profiles)
		profiles = list()
		for(var/profile_type in subtypesof(/datum/resident_document_profile))
			var/datum/resident_document_profile/profile = profile_type
			var/profile_id = initial(profile.id)
			if(!profile_id)
				continue
			profiles[profile_id] = profile_type
	return profiles

/proc/get_resident_document_profile(profile_id)
	var/static/list/cache
	if(!cache)
		cache = list()
	if(cache[profile_id])
		return cache[profile_id]
	var/list/profiles = get_resident_document_profiles()
	var/profile_type = profiles[profile_id] || profiles["resident"]
	if(!profile_type)
		return null
	var/datum/resident_document_profile/profile = new profile_type
	cache[profile_id] = profile
	return profile
