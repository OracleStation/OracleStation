/datum/proc/oui_canview(mob/user)
	return TRUE

/datum/proc/oui_getcontent(mob/user)
	return "Default Implementation"

/datum/proc/oui_canuse(mob/user)
	if(isobserver(user))
		return FALSE
	return oui_canview(user)

/datum/proc/oui_data(mob/user)
	return list()

/datum/proc/oui_act(mob/user, action, list/params)
	// No Implementation

/atom/oui_canview(mob/user)
	if(isobserver(user))
		return TRUE
	if(isturf(src.loc) && Adjacent(user))
		return TRUE
	return FALSE

/obj/item/oui_canview(mob/user)
	if(src.loc == user)
		return src in user.held_items
	return ..()

/obj/machinery/oui_canview(mob/user)
	if(!is_interactable())
		return FALSE
	if(iscyborg(user))
		return can_see(user, src, 7)
	if(isAI(user))
		return GLOB.cameranet.checkTurfVis(get_turf_pixel(src))
	return ..()
