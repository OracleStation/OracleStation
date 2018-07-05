GLOBAL_DATUM_INIT(text_filter_datum, /datum/text_filter, new)

/datum/text_filter
	//used for some text operations that need to hold a bunch of regexes or whatever in memory
	//probably not the best way to do it, but globals are bad
	var/static/regex/reeegex = new("(^|\\W)\[Rr]\[Ee]+\[Ee]($|\\W)")

/datum/text_filter/proc/ree_check(message)
	if(reeegex.Find(message))
		return TRUE
	return FALSE