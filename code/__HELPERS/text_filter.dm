GLOBAL_DATUM_INIT(text_filter_datum, /datum/text_filter, new)

/datum/text_filter
	//used for some text operations that need to hold a bunch of regexes or whatever in memory
	//probably not the best way to do it, but globals are bad
	var/list/regex/regexes = list()

/datum/text_filter/New()
	var/list/raw_regexes = world.file2list("strings/retard_regex.txt")
	for(var/r in raw_regexes)
		var/regex/tmp = new(r)
		regexes += tmp

/datum/text_filter/proc/do_checks(message)
	for(var/regex/r  in regexes)
		if(r.Find(message))
			return TRUE