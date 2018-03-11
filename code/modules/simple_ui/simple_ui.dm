/datum/simple_ui
	var/width = 512
	var/height = 512
	var/can_close = TRUE
	var/can_minimize = FALSE
	var/can_resize = TRUE
	var/titlebar = TRUE
	var/window_id = null
	var/viewers[0]
	var/auto_check_view = TRUE
	var/auto_refresh = FALSE
	var/atom/datasource = null
	var/datum/asset/assets = null

/datum/simple_ui/New(atom/n_datasource, n_width = 512, n_height = 512, n_assets = null)
	if(hascall(n_datasource, "simpleui_canview") && hascall(n_datasource, "simpleui_getcontent"))
		datasource = n_datasource
	else
		log_world("[n_datasource] does not have the correct procs for use with /datum/simple_ui!")
	window_id = REF(src)
	width = n_width
	height = n_height

/datum/simple_ui/Destroy()
	close_all()
	if(isprocessing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/datum/simple_ui/process()
	if(auto_check_view)
		check_view_all()
	if(auto_refresh)
		update_all()

/datum/simple_ui/proc/get_content(mob/target)
	return datasource ? call(datasource, "simpleui_getcontent")(target) : "ERROR: NO DATASOURCE"

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
	//Check to see if they have the window open still if updating
	if(updating && !test_viewer(target, updating))
		return
	//Send assets
	if(!updating && assets)
		assets.send(target)
	//Add them to the viewers if they aren't there already
	viewers |= target
	if(!isprocessing && (auto_refresh | auto_check_view))
		START_PROCESSING(SSobj, src) //Start processing to poll for viewability
	//Send the content
	target << browse(get_content(target), "window=[window_id];size=[width]x[height];can_close=[can_close];can_minimize=[can_minimize];can_resize=[can_resize];titlebar=[titlebar];")

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
	if(!test_viewer(target, TRUE))
		close(target)

/datum/simple_ui/proc/call_js(mob/target, js_func, list/parameters = list())
	if(!test_viewer(target, TRUE))
		return
	target << output(list2params(parameters),"[window_id].browser:[js_func]")

/datum/simple_ui/proc/call_js_all(js_func, list/parameters = list())
	for(var/viewer in viewers)
		spawn() call_js(viewer, js_func, parameters)
