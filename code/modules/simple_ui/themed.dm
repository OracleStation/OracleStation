/datum/simple_ui/themed
	var/theme = ""
	var/content_root = ""
	var/current_page = "index.html"
	var/root_template = ""

/datum/simple_ui/themed/New(atom/n_datasource, n_width = 512, n_height = 512, n_content_root = "")
	root_template = get_themed_file("index.html")
	content_root = n_content_root
	return ..(n_datasource, n_width, n_height, get_asset_datum(/datum/asset/simple/simpleui_theme_nano))

/datum/simple_ui/themed/process()
	if(auto_check_view)
		check_view_all()
	if(auto_refresh)
		soft_update_fields()

GLOBAL_LIST_EMPTY(simpleui_template_variables)
GLOBAL_LIST_EMPTY(simpleui_file_cache)

/datum/simple_ui/themed/proc/get_file(path)
	if(GLOB.simpleui_file_cache[path])
		return GLOB.simpleui_file_cache[path]
	else if(fexists(path))
		var/data = file2text(path)
		GLOB.simpleui_file_cache[path] = data
		return data
	else
		var/errormsg = "MISSING PATH '[path]'"
		log_world(errormsg)
		return errormsg

/datum/simple_ui/themed/proc/get_content_file(filename)
	return get_file("html/simple_ui/content/[content_root]/[filename]")

/datum/simple_ui/themed/proc/get_themed_file(filename)
	return get_file("html/simple_ui/themes/[theme]/[filename]")

/datum/simple_ui/themed/proc/process_template(template, variables)
	var/regex/pattern = regex("\\@\\{(\\w+)\\}","gi")
	GLOB.simpleui_template_variables = variables
	var/replaced = pattern.Replace(template, /proc/simpleui_process_template_replace)
	GLOB.simpleui_template_variables = null
	return replaced

/proc/simpleui_process_template_replace(match, group1)
	var/value = GLOB.simpleui_template_variables[group1]
	return "[value]"

/datum/simple_ui/themed/proc/get_inner_content(mob/target)
	var/list/data = call(datasource, "simpleui_data")(target)
	return process_template(get_content_file(current_page), data)

/datum/simple_ui/themed/get_content(mob/target)
	var/list/template_data = list("title" = datasource.name, "body" = get_inner_content(target))
	return process_template(root_template, template_data)

/datum/simple_ui/themed/proc/soft_update_fields()
	for(var/viewer in viewers)
		var/json = json_encode(call(datasource, "simpleui_data")(viewer))
		call_js(viewer, "updateFields", list(json))

/datum/simple_ui/themed/proc/soft_update_all()
	for(var/viewer in viewers)
		call_js(viewer, "replaceContent", list(get_inner_content(viewer)))

/datum/simple_ui/themed/nano
	theme = "nano"
