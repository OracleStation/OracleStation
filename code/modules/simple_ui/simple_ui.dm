/datum/simple_ui
	var/width = 512
	var/height = 512
	var/can_close = TRUE
	var/can_minimize = FALSE
	var/can_resize = TRUE
	var/titlebar = TRUE
	var/window_id = null
	var/viewers[0]
	var/atom/datasource = null

/datum/simple_ui/New(atom/n_datasource)
	datasource = n_datasource
	window_id = REF(src)

/datum/simple_ui/Destroy()
	close_all()
	if(isprocessing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/datum/simple_ui/process()
	check_view_all()

/datum/simple_ui/proc/get_content()
	return datasource ? call(datasource, "simpleui_getcontent")() : "ERROR: NO DATASOURCE"

/datum/simple_ui/proc/can_view(mob/target)
	return datasource ? call(datasource, "simpleui_canview")(target) : TRUE

/datum/simple_ui/proc/test_viewer(mob/target, updating)
	//If this is an update, and they have closed the window, remove from viewers and return
	if(updating && winget(target, window_id, "is-visible") != "true")
		viewers -= target
		if(viewers.len < 1 && isprocessing)
			STOP_PROCESSING(SSobj, src) //No more viewers, stop polling
		return FALSE
	//If the target is null or does not have a client, remove from viewers and return
	if(!target | !target.client | !can_view(target))
		viewers -= target
		if(viewers.len < 1 && isprocessing)
			STOP_PROCESSING(SSobj, src)  //No more viewers, stop polling
		close(target)
		return FALSE
	return TRUE

/datum/simple_ui/proc/render(mob/target, updating = FALSE)
	if(updating && !test_viewer(target, updating))
		return
	//Add them to the viewers if they aren't there already
	viewers |= target
	if(!isprocessing)
		START_PROCESSING(SSobj, src) //Start processing to poll for viewability
	//Send the content
	target << browse(get_content(), "window=[window_id];size=[width]x[height];can_close=[can_close];can_minimize=[can_minimize];can_resize=[can_resize];titlebar=[titlebar];")

/datum/simple_ui/proc/update_all()
	for(var/viewer in viewers)
		//Spawn forks off the execution to their own coroutines for better performance, since winget is a blocking call
		spawn() render(viewer, TRUE)

/datum/simple_ui/proc/close(mob/target)
	if(target && target.client)
		target << browse(null, "window=[window_id]")

/datum/simple_ui/proc/close_all()
	for(var/viewer in viewers)
		close(viewer)
	viewers = list()

/datum/simple_ui/proc/check_view_all()
	for(var/viewer in viewers)
		spawn() check_view(viewer)

/datum/simple_ui/proc/check_view(mob/target)
	if(!test_viewer(target))
		close(target)

/datum/simple_ui/proc/call_js(mob/target, js_func, list/parameters = list())
	if(!test_viewer(target))
		return
	target << output(list2params(parameters),"[window_id].browser:[js_func]")

/datum/simple_ui/proc/call_js_all(js_func, list/parameters = list())
	for(var/viewer in viewers)
		spawn() call_js(viewer, js_func, parameters)
