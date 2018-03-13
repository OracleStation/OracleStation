/*				COMMAND OBJECTIVES				*/
/*
/datum/objective/crew/caphat //Ported from Goon
	explanation_text = "Don't lose your hat."
	jobs = "captain"

/datum/objective/crew/caphat/check_completion()
	if(owner && owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
		return TRUE
	else
		return FALSE

/datum/objective/crew/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."
	jobs = "captain" //give this to other heads at your own risk.

/datum/objective/crew/datfukkendisk/check_completion()
	if(owner && owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return TRUE
	else
		return FALSE
*/
/datum/objective/crew/downwiththestation
	explanation_text = "Go down with your station. Do not leave on the shuttle or an escape pod. Instead, stay on the bridge."
	jobs = "captain"

/datum/objective/crew/downwiththestation/check_completion()
	if(owner && owner.current)
		if(istype(get_area(owner.current), /area/bridge))
			return TRUE
	return FALSE

/datum/objective/crew/ian //Ported from old Hippie
	explanation_text = "Defend Ian at all costs, and ensure he gets delivered to Centcom at the end of the shift."
	jobs = "headofpersonnel"

/datum/objective/crew/ian/check_completion()
	if(owner && owner.current)
		for(var/mob/living/simple_animal/pet/dog/corgi/Ian/goodboy in GLOB.mob_list)
			if(goodboy.stat != DEAD && SSshuttle.emergency.shuttle_areas[get_area(goodboy)])
				return TRUE
		return FALSE
	return FALSE

/datum/objective/crew/peashooter
	explanation_text = "Don't lose your pistol."
	jobs = "blueshield"

/datum/objective/crew/peashooter/check_completion()
	if(owner && owner.current && (owner.current.check_contents_for(/obj/item/gun/ballistic/revolver/detective) || owner.current.check_contents_for(/obj/item/gun/ballistic/automatic/pistol/enforcer) || owner.current.check_contents_for(/obj/item/gun/energy/e_gun/blueshield)))
		return TRUE
	return FALSE

/datum/objective/crew/coveryourhead
	explanation_text = "Make sure (Something broke, yell on github) survives the shift."
	jobs = "blueshield"
	var/datum/mind/protection_target

/datum/objective/crew/coveryourhead/New()
	var/list/heads = SSticker.mode.get_living_heads() //the proc returns the mind not the mob
	protection_target = pick(heads)
	update_explanation_text()

/datum/objective/crew/coveryourhead/update_explanation_text()
	. = ..()
	explanation_text = "Make sure [protection_target.name], the [protection_target.assigned_role] survives."

/datum/objective/crew/coveryourhead/check_completion()
	var/list/heads = SSticker.mode.get_living_heads()
	if(protection_target in heads)
		return TRUE
	return FALSE
