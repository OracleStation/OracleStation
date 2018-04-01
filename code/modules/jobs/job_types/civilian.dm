/*
Clown
*/
/datum/job/clown
	title = "Clown"
	flag = CLOWN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	special_notice = "There is a difference between harmless pranks and griefing. Know it."
	wiki_page = "Clown"

	outfit = /datum/outfit/job/clown

	access = list(ACCESS_THEATRE)
	minimal_access = list(ACCESS_THEATRE)

/datum/job/clown/after_spawn(mob/living/carbon/human/H, mob/M)
	H.rename_self("clown", M.client)

/datum/outfit/job/clown
	name = "Clown"
	jobtype = /datum/job/clown
	id = /obj/item/card/id/job/clown
	pda_slot = /obj/item/device/pda/clown
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/bikehorn
	backpack_contents = list(
		/obj/item/stamp/clown = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/reagent_containers/food/snacks/grown/banana = 1,
		)

	implants = list(/obj/item/implant/sad_trombone)

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	duffelbag = /obj/item/storage/backpack/duffelbag/clown //strangely has a duffel

	box = /obj/item/storage/box/hug/survival


/datum/outfit/job/clown/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	H.fully_replace_character_name(H.real_name, pick(GLOB.clown_names))

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	H.dna.add_mutation(CLOWNMUT)
	H.dna.add_mutation(WACKY)
/*
Mime
*/
/datum/job/mime
	title = "Mime"
	flag = MIME
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	special_notice = "There is a difference between harmless pranks and griefing. Know it."
	wiki_page = "Mime"

	outfit = /datum/outfit/job/mime

	access = list(ACCESS_THEATRE)
	minimal_access = list(ACCESS_THEATRE)

/datum/job/mime/after_spawn(mob/living/carbon/human/H, mob/M)
	H.rename_self("mime", M.client)

/datum/outfit/job/mime
	name = "Mime"
	jobtype = /datum/job/mime
	id = /obj/item/card/id/job/mime
	pda_slot = /obj/item/device/pda/mime
	uniform = /obj/item/clothing/under/rank/mime
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/beret
	suit = /obj/item/clothing/suit/suspenders
	backpack_contents = list(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing=1)

	accessory = /obj/item/clothing/accessory/pocketprotector/cosmetology
	backpack = /obj/item/storage/backpack/mime
	satchel = /obj/item/storage/backpack/mime


/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak(null))
		H.mind.miming = 1

/*
Curator
*/
/datum/job/curator
	title = "Curator"
	flag = CURATOR
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/curator

	access = list(ACCESS_LIBRARY)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_CONSTRUCTION,ACCESS_MINING_STATION)

/datum/outfit/job/curator
	name = "Curator"
	jobtype = /datum/job/curator

	pda_slot = /obj/item/device/pda/curator
	uniform = /obj/item/clothing/under/rank/curator
	l_hand = /obj/item/storage/bag/books
	r_pocket = /obj/item/key/displaycase
	l_pocket = /obj/item/device/laser_pointer
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/melee/curator_whip = 1,
		/obj/item/soapstone = 1,
		/obj/item/barcodescanner = 1
	)


/datum/outfit/job/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	H.grant_all_languages(omnitongue=TRUE)

/*
Internal Affairs Agent
*/
/datum/job/iaa
	title = "Internal Affairs Agent"
	flag = IAA
	department_head = list("CentCom")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "central command"
	selection_color = "#dddddd"
	minimal_player_age = 14
	exp_requirements = 180 //3 hours
	exp_type = EXP_TYPE_CREW
	wiki_page = "Standard_Operating_Procedure"

	outfit = /datum/outfit/job/iaa
	//Basic access to each department
	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_IAA, ACCESS_MAINT_TUNNELS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_CARGO)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_IAA, ACCESS_MAINT_TUNNELS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_CARGO)

/datum/outfit/job/iaa
	name = "Internal Affairs Agent"
	jobtype = /datum/job/iaa
	id = /obj/item/card/id/job/sec
	pda_slot = /obj/item/device/pda/iaa
	ears = /obj/item/device/radio/headset/iaa
	uniform = /obj/item/clothing/under/iaa/blacksuit
	suit = /obj/item/clothing/suit/toggle/iaa/black
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/briefcase
	l_pocket = /obj/item/device/laser_pointer
	r_pocket = /obj/item/device/assembly/flash/handheld

	implants = list(/obj/item/implant/mindshield)
