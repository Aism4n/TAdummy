/proc/resident_manuscript_uses_rockhill_titles()
	return SSmapping.config?.map_name == "Rockhill"

/proc/resident_manuscript_uses_azuria_titles()
	return (SSmapping.config?.map_name in list("Dun World", "Dun_world"))

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

/datum/resident_document_role_rule/azurian_imperial_patronage
	document_type = /obj/item/book/granter/resident_manuscript/imperial
	job_titles = list(
		"Grand Duke",
		"Bishop",
		"Inquisitor",
		"Magister",
		"Otavan Magister",
		"High Magister",
		"Supreme Magister",
		"Магистр Отавы",
	)
	priority = 125

/datum/resident_document_role_rule/azurian_imperial_patronage/matches(mob/living/carbon/human/user)
	return resident_manuscript_uses_azuria_titles() && ..()

/datum/resident_document_role_rule/rockhill_crown
	document_type = /obj/item/book/granter/resident_manuscript/enigma_crown
	job_titles = list("Grand Duke")
	priority = 125

/datum/resident_document_role_rule/rockhill_crown/matches(mob/living/carbon/human/user)
	return resident_manuscript_uses_rockhill_titles() && ..()

/datum/resident_document_role_rule/rockhill_bishop
	document_type = /obj/item/book/granter/resident_manuscript/valorian_church
	job_titles = list("Bishop")
	priority = 125

/datum/resident_document_role_rule/rockhill_bishop/matches(mob/living/carbon/human/user)
	return resident_manuscript_uses_rockhill_titles() && ..()

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

/datum/resident_document_role_rule/retinue
	document_type = /obj/item/book/granter/resident_manuscript/retinue
	priority = 90

/datum/resident_document_role_rule/retinue/matches(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	return job_title && (job_title in GLOB.retinue_positions)

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
	if(!ishuman(user) || !user.mind)
		return FALSE
	var/job_title = user.job || user.mind.assigned_role
	if(job_title && ((job_title in GLOB.noble_positions) || (job_title in GLOB.courtier_positions)))
		return TRUE
	return HAS_TRAIT(user, TRAIT_NOBLE)

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

/datum/resident_manuscript_seal_rule/kaiser
	key = "kaiser"
	title = "Кайзер"
	stamper = "Кайзер Грензельхофта"
	priority = RESIDENT_SEAL_PRIORITY_KAISER

/datum/resident_manuscript_seal_rule/valorian
	key = "valorian"
	title = "Валорийская торговая гильдия"
	stamper = "Торговая гильдия Астинии-ди-Сала"
	priority = RESIDENT_SEAL_PRIORITY_FACTION_HIGH

/datum/resident_manuscript_seal_rule/valorian_holy_see
	key = "valorian_holy_see"
	title = "Валорийский Святой Престол"
	stamper = "Святой Престол Валории"
	priority = RESIDENT_SEAL_PRIORITY_FACTION_HIGH

/datum/resident_manuscript_seal_rule/royal_protection
	key = "royal_protection"
	title = "Королевская протекция"
	stamper = "Король"
	job_types = list(/datum/job/roguetown/lord)
	priority = RESIDENT_SEAL_PRIORITY_RULER

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
	description = "Да будет ведомо: предъявитель внесен в реестр жителей этих земель. Ему дозволено проживание, обращение к городскому праву и проход через городские ворота до истечения срока грамоты."
	allowed_seals = list("chancellor", "elder", "ruler", "hand")
	default_commoner_seal_keys = list("chancellor")
	default_noble_seal_keys = list("ruler")
	grants_residence_claim = TRUE

/datum/resident_document_profile/resident/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель внесен в реестр жителей Королевства Энигмы на Рокхилле. Ему дозволено проживание, обращение к городскому праву и проход через городские ворота до истечения срока грамоты."
	return ..()

/datum/resident_document_profile/imperial
	id = "imperial"
	display_name = "Имперская грамота покровительства"
	subtitle = "Под кайзеровской контрасигнацией"
	description = "Да будет ведомо: предъявитель занимает должность, сан или службу, признанную канцелярией Кайзера Грензельхофта и властью Герцогства Азурия. Грамота удостоверяет его полномочия и не передается иным лицам."
	allowed_seals = list("kaiser", "ruler", "bishop", "inquisitor", "hand")
	default_seal_keys = list("kaiser")
	grants_residence_claim = TRUE

/datum/resident_document_profile/enigma_crown
	id = "enigma_crown"
	display_name = "Коронная грамота Энигмы"
	subtitle = "Под рукой Короля Рокхилла"
	description = "Да будет ведомо: предъявитель признан коронной властью Королевства Энигмы на Рокхилле. Его распоряжения и достоинство признаются в пределах королевского закона и срока настоящей грамоты."
	allowed_seals = list("ruler", "hand")
	default_seal_keys = list("ruler")
	grants_residence_claim = TRUE

/datum/resident_document_profile/valorian_church
	id = "valorian_church"
	display_name = "Валорийская грамота Святого Престола"
	subtitle = "Под церковью Неделимых Десяти"
	description = "Да будет ведомо: предъявитель признан Святым Престолом Валории и вправе совершать церковную службу на Рокхилле. Его сан, печать и церковные распоряжения подлежат признанию в пределах настоящей грамоты."
	allowed_seals = list("valorian_holy_see", "bishop", "ruler")
	default_seal_keys = list("valorian_holy_see")
	grants_residence_claim = TRUE

/datum/resident_document_profile/guards
	id = "guards"
	display_name = "Гарнизонная грамота"
	subtitle = "От гарнизона и Короны"
	description = "Да будет ведомо: предъявитель принят на службу городского гарнизона. Ему дозволено носить оружие при исполнении, требовать содействия в пределах приказа и отвечать перед своим начальством."
	allowed_seals = list("sergeant", "marshal", "elder")

/datum/resident_document_profile/guards/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "От королевской стражи и Рокхилла"
	return ..()

/datum/resident_document_profile/guards/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель принят на службу королевской стражи Рокхилла. Ему дозволено носить оружие при исполнении, требовать содействия в пределах приказа и отвечать перед своим начальством."
	return ..()

/datum/resident_document_profile/church
	id = "church"
	display_name = "Церковная грамота веры"
	subtitle = "Под Десятеричным Светом"
	description = "Да будет ведомо: предъявитель состоит при церкви и допускается к храмовой службе в пределах своего сана или должности. Его церковное положение признается до отмены грамоты либо истечения срока."
	allowed_seals = list("bishop")

/datum/resident_document_profile/church/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "Под валорийским Святым Престолом"
	return ..()

/datum/resident_document_profile/church/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель состоит при церкви Неделимых Десяти на Рокхилле и допускается к храмовой службе в пределах своего сана или должности. Его церковное положение признается до отмены грамоты либо истечения срока."
	return ..()

/datum/resident_document_profile/craftsmen
	id = "craftsmen"
	display_name = "Хартия ремесленной гильдии"
	subtitle = "Честной рукой и бронзой"
	description = "Да будет ведомо: предъявитель признан ремесленником или служащим ремесленной гильдии. Ему дозволено вести работу по своему ремеслу, заключать заказы и пользоваться защитой гильдейского порядка."
	allowed_seals = list("guild_leader", "chancellor", "elder")

/datum/resident_document_profile/commoner
	id = "commoner"
	display_name = "Грамота горожанина"
	subtitle = "Знаком городского старейшины"
	description = "Да будет ведомо: предъявитель внесен в городской учет как простолюдин. Ему дозволено находиться среди законного люда города без дворянских прав и особых привилегий."
	allowed_seals = list("elder", "chancellor", "hand")
	default_commoner_seal_keys = list("elder", "chancellor")
	default_noble_seal_keys = list("hand")
	requires_seal_for_claim = FALSE

/datum/resident_document_profile/commoner/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "Знаком городского мэра"
	return ..()

/datum/resident_document_profile/commoner/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель внесен в городской учет Рокхилла как простолюдин. Ему дозволено находиться среди законного люда Королевства Энигмы без дворянских прав и особых привилегий."
	return ..()

/datum/resident_document_profile/merchant
	id = "merchant"
	display_name = "Валорийское торговое разрешение"
	subtitle = "Печатью Торговой гильдии Астинии-ди-Сала"
	description = "Да будет ведомо: предъявитель действует по разрешению валорийской Торговой гильдии. Ему дозволено вести торговлю, принимать товары, заключать сделки и держать торговые книги под гильдейской печатью."
	allowed_seals = list("valorian", "merchant_master", "chancellor")
	default_seal_keys = list("valorian")

/datum/resident_document_profile/merchant/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель действует на Рокхилле по разрешению валорийской Торговой гильдии. Ему дозволено вести торговлю, принимать товары, заключать сделки и держать торговые книги под гильдейской печатью."
	return ..()

/datum/resident_document_profile/mages
	id = "mages"
	display_name = "Патент гильдии магов"
	subtitle = "Светом Короны, звездой и сигилом"
	description = "Да будет ведомо: предъявитель признан дозволенным практиком магического ремесла. Ему разрешено вести утвержденные работы, хранить необходимые инструменты и отвечать перед гильдией или двором."
	allowed_seals = list("court_magician")

/datum/resident_document_profile/mercenary
	id = "mercenary"
	display_name = "Наемный контракт"
	subtitle = "Монетой, сталью и словом"
	description = "Да будет ведомо: предъявитель принят на наемную службу по договору. Ему дозволено носить оружие, исполнять оплаченный контракт и отвечать за свои действия перед нанимателем и законом."
	allowed_seals = list("elder", "chancellor", "hand")
	default_commoner_seal_keys = list("elder", "chancellor")
	default_noble_seal_keys = list("hand")

/datum/resident_document_profile/otava
	id = "otava"
	display_name = "Инквизиторский эдикт"
	subtitle = "Истиной, дознанием и очищающим пламенем"
	description = "Да будет ведомо: предъявитель состоит при Инквизиции Отавы. Ему дозволено проводить дознания, предъявлять требования по делам веры и действовать в пределах признанных полномочий."
	allowed_seals = list("inquisitor", "royal_protection")

/datum/resident_document_profile/otava/get_display_name()
	if(resident_manuscript_uses_rockhill_titles())
		return "Грамота королевской протекции"
	return ..()

/datum/resident_document_profile/otava/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "Отаванская миссия под рукой Короля"
	return ..()

/datum/resident_document_profile/otava/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель состоит при отаванской миссии на Рокхилле и находится под личной протекцией Короля. Препятствовать ему дозволено только по законному основанию либо прямому распоряжению короны."
	return ..()

/datum/resident_document_profile/otava/get_default_seal_keys(status_key)
	if(resident_manuscript_uses_rockhill_titles())
		return list("royal_protection")
	return list("inquisitor")

/datum/resident_document_profile/retinue
	id = "retinue"
	display_name = "Грамота дворцовой службы"
	subtitle = "Под герцогской рукой и присягой"
	description = "Да будет ведомо: предъявитель состоит при дворе Герцогства Азурия и несет личную службу герцогу. Его место, обязанности и право находиться при дворе подтверждаются настоящей грамотой."
	allowed_seals = list("hand", "ruler", "marshal")
	default_commoner_seal_keys = list("hand")
	default_noble_seal_keys = list("hand")
	grants_residence_claim = TRUE

/datum/resident_document_profile/retinue/get_subtitle()
	if(resident_manuscript_uses_rockhill_titles())
		return "Под королевской рукой и присягой"
	return ..()

/datum/resident_document_profile/retinue/get_description()
	if(resident_manuscript_uses_rockhill_titles())
		return "Да будет ведомо: предъявитель состоит при дворе Королевства Энигмы на Рокхилле и несет личную службу Королю. Его место, обязанности и право находиться при дворе подтверждаются настоящей грамотой."
	return ..()

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
