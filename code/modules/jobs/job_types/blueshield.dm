/*
Blueshield
*/

/datum/job/blueshield
	title = "Blueshield"
	flag = BLUESHIELD
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "captain and command personnel"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 600 //10 hours
	exp_type = EXP_TYPE_CREW
	special_notice = "You are a bodyguard for heads of staff. You are not a security officer. Do not do security's job."

	outfit = /datum/outfit/job/blueshield

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
			            ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_AI_UPLOAD, ACCESS_EVA,
			            ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
			            ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
			            ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_MINING_STATION,
			            ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM, ACCESS_BLUESHIELD, ACCESS_CAPTAIN, ACCESS_RD, ACCESS_HOS, ACCESS_CMO, ACCESS_CE)
	minimal_access = list(ACCESS_FORENSICS_LOCKERS, ACCESS_SEC_DOORS, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_ENGINE, ACCESS_MAINT_TUNNELS,
                  ACCESS_RESEARCH, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_BLUESHIELD, ACCESS_QM, ACCESS_HOP, ACCESS_WEAPONS, ACCESS_CAPTAIN, ACCESS_RD, ACCESS_HOS, ACCESS_CMO, ACCESS_CE)

/datum/outfit/job/blueshield
  name = "Blueshield"
  jobtype = /datum/job/blueshield
  id = /obj/item/card/id/job/nt
  uniform = /obj/item/clothing/under/rank/blueshield
  gloves = /obj/item/clothing/gloves/combat
  shoes = /obj/item/clothing/shoes/jackboots
  ears = /obj/item/device/radio/headset/heads/blueshield/alt
  glasses = /obj/item/clothing/glasses/hud/health/sunglasses
  pda_slot = /obj/item/device/pda/blueshield

  implants = list(/obj/item/implant/mindshield)

  backpack = /obj/item/storage/backpack/security
  satchel = /obj/item/storage/backpack/satchel/sec
  duffelbag = /obj/item/storage/backpack/duffelbag/sec
  courierbag = /obj/item/storage/backpack/messenger/sec

  backpack_contents = list(
    /obj/item/blueshield_gun_package = 1
  )
