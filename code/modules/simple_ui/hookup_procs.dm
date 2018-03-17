/datum/proc/simpleui_canview(mob/user)
	return TRUE

/datum/proc/simpleui_getcontent(mob/user)
	return "Default Implementation"

/datum/proc/simpleui_canuse(mob/user)
	if(isobserver(user))
		return FALSE
	return simpleui_canview(user)

/datum/proc/simpleui_data(mob/user)
	return list()

/datum/proc/simpleui_act(mob/user, action, list/params)
	// No Implementation

/atom/simpleui_canview(mob/user)
	if(isobserver(user))
		return TRUE
	if(isturf(src.loc) && Adjacent(user))
		return TRUE
	return FALSE

/obj/item/simpleui_canview(mob/user)
	if(src.loc == user)
		return src in user.held_items
	return ..()

/obj/machinery/simpleui_canview(mob/user)
	if(!is_interactable())
		return FALSE
	if(iscyborg(user))
		return can_see(user, src, 7)
	if(isAI(user))
		return GLOB.cameranet.checkTurfVis(get_turf_pixel(src))
	return ..()
