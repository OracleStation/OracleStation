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

/datum/simple_ui/proc/get_content()
	return "CONTENT [rand(1,100)]"

/datum/simple_ui/proc/render(mob/target, updating = FALSE)
	if(!target | !target.client)
		viewers -= target
		return
	if(updating && winget(target, window_id, "is-visible") != "true")
		viewers -= target
		return
	else
		viewers |= target
	var/extras = ""
	if(updating)
		extras += "focus=false;"
	target << browse(get_content(), "window=[window_id];size=[width]x[height];can_close=[can_close];can_minimize=[can_minimize];can_resize=[can_resize];titlebar=[titlebar];[extras]")

/datum/simple_ui/proc/update()
	for(var/mob/viewer in viewers)
		spawn() render(viewer, TRUE)

/datum/simple_ui/proc/closeall()
	for(var/mob/viewer in viewers)
		viewer << browse(null, "window=[window_id]")
	viewers = list()
