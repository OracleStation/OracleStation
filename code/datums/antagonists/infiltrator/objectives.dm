#define MIN_POWER_DRAIN 25000000
#define MAX_POWER_DRAIN 50000000

GLOBAL_LIST_INIT(minor_infiltrator_objectives, list(/datum/objective/assassinate, /datum/objective/steal, /datum/objective/download))
GLOBAL_LIST_INIT(single_infiltrator_objectives, list(/datum/objective/download))
GLOBAL_LIST_INIT(infiltrator_kidnap_areas, typecacheof(list(/area/shuttle/stealthcruiser, /area/infiltrator_base)))

/datum/objective/infiltrator
	explanation_text = "Generic Infiltrator Objective!"
	martyr_compatible = FALSE
	var/item_type

/datum/objective/infiltrator/New()
	..()
	if(item_type)
		for(var/turf/T in GLOB.infiltrator_objective_items)
			if(!(item_type in T.contents))
				new item_type(T)

/datum/objective/infiltrator/exploit
	explanation_text = "Ensure there is at least 1 hijacked AI. Use the serial exploitation unit to hijack an AI."
	item_type = /obj/item/ai_hijack_device
	var/hijacked = FALSE

/datum/objective/infiltrator/exploit/find_target()
	var/list/possible_targets = active_ais(1)
	var/mob/living/silicon/ai/target_ai = pick(possible_targets)
	target = target_ai.mind
	update_explanation_text()
	return target

/datum/objective/infiltrator/exploit/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Hijack [station_name()]'s AI unit, [target.name], with the serial exploitation unit."
	else
		explanation_text = "Ensure there is at least 1 hijacked AI on [station_name()]. Use the serial exploitation unit to hijack an AI."

/datum/objective/infiltrator/exploit/check_completion()
	return hijacked


/datum/objective/infiltrator/power
	explanation_text = "Drain power from the station with a power sink."

/datum/objective/infiltrator/power/New()
	target_amount = rand(MIN_POWER_DRAIN, MAX_POWER_DRAIN) //I don't do this in find_target(), because that is done AFTER New().
	for(var/turf/T in GLOB.infiltrator_objective_items)
		if(!(item_type in T.contents))
			var/obj/item/device/powersink/infiltrator/PS = new(T)
			PS.target = target_amount
	update_explanation_text()

/datum/objective/infiltrator/power/update_explanation_text()
	..()
	if(target_amount)
		explanation_text = "Drain [DisplayPower(target_amount)] from [station_name()]'s powernet with a special transmitter powersink. You do not need to bring the powersink back once the objective is complete."
	else
		explanation_text = "Free Objective"

/datum/objective/infiltrator/power/check_completion()
	return GLOB.powersink_transmitted >= target_amount


/datum/objective/infiltrator/kidnap
	explanation_text = "Well, you were supposed to kidnap somebody, but we couldn't find anyone to kidnap. Tell steamport#2763 on Discord, as this REALLY shouldn't happen!"

/datum/objective/infiltrator/kidnap/find_target()
	var/list/possible_targets = SSticker.mode.get_living_by_department(GLOB.command_positions)
	for(var/datum/mind/M in SSticker.minds)
		if(!M || !considered_alive(M) || considered_afk(M) || !M.current || !M.current.client)
			continue
		if("Head of Security" in get_department_heads(M.assigned_role))
			possible_targets += M
	target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/infiltrator/kidnap/update_explanation_text()
	if(target && target.current)
		explanation_text = "Kidnap [target.name], the [target.assigned_role], and hold [target.current.p_them()] on the shuttle or base."
	else
		explanation_text = "Free Objective"

/datum/objective/infiltrator/kidnap/check_completion()
	if(QDELETED(target) || !target)
		return TRUE
	if(target && target.current && considered_alive(target) && is_type_in_typecache(get_area(target), GLOB.infiltrator_kidnap_areas))
		return TRUE
	else if (target && target.current && target.current.stat == DEAD && is_type_in_typecache(target.current.death_area, GLOB.infiltrator_kidnap_areas))
		return TRUE
	return FALSE