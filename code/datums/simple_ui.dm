/datum/simple_ui
	var/width = 512
	var/height = 512
	var/can_close = TRUE
	var/can_minimize = FALSE
	var/can_resize = TRUE
	var/titlebar = TRUE
	var/window_id = null
	var/viewers[0]

/datum/simple_ui/New()
	window_id = REF(src)
	START_PROCESSING(SSobj, src)

/datum/simple_ui/Destroy()
	close_all()
	STOP_PROCESSING(SSobj, src)
	..()

/datum/simple_ui/process()
	update_all()

/datum/simple_ui/proc/get_content()
	return "CONTENT [rand(1,100)]"

/datum/simple_ui/proc/can_view(mob/target)
	return TRUE

/datum/simple_ui/proc/render(mob/target, updating = FALSE)
	//If the target is null or does not have a client, remove from viewers and return
	if(!target | !target.client | !can_view(target))
		viewers -= target
		return
	//If this is an update, and they have closed the window, remove from viewers and return
	if(updating && winget(target, window_id, "is-visible") != "true")
		viewers -= target
		return
	//Add them to the viewers if they aren't there already
	viewers |= target
	//Send the content
	target << browse(get_content(), "window=[window_id];size=[width]x[height];can_close=[can_close];can_minimize=[can_minimize];can_resize=[can_resize];titlebar=[titlebar];")

/datum/simple_ui/proc/update_all()
	for(var/viewer in viewers)
		//Spawn forks off the execution to their own coroutines for better performance, since winget is a blocking call
		spawn() render(viewer, TRUE)

/datum/simple_ui/proc/close(mob/target)
	target << browse(null, "window=[window_id]")

/datum/simple_ui/proc/close_all()
	for(var/viewer in viewers)
		close(viewer)
	viewers = list()
