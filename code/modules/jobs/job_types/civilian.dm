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
Lawyer
*/
/datum/job/lawyer
	title = "Lawyer"
	flag = LAWYER
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	var/lawyers = 0 //Counts lawyer amount

	outfit = /datum/outfit/job/lawyer

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)

/datum/outfit/job/lawyer
	name = "Lawyer"
	jobtype = /datum/job/lawyer

	pda_slot = /obj/item/device/pda/lawyer
	ears = /obj/item/device/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/briefcase/lawyer
	l_pocket = /obj/item/device/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge


/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	var/datum/job/lawyer/J = SSjob.GetJobType(jobtype)
	J.lawyers++
	if(J.lawyers>1)
		uniform = /obj/item/clothing/under/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple
