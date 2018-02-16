/datum/controller/subsystem/ticker/proc/generate_crew_objectives()
	if(CONFIG_GET(flag/allow_crew_objectives))
		for(var/datum/mind/crewMind in SSticker.minds)
			if(crewMind.current.client.prefs.crew_objectives)
				generate_individual_objectives(crewMind)
	return

/datum/controller/subsystem/ticker/proc/generate_individual_objectives(var/datum/mind/crewMind)
	if(!(CONFIG_GET(flag/allow_crew_objectives)))
		return
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/list/validobjs = crewobjjobs["[ckey(crewMind.assigned_role)]"]
	if(!validobjs || !validobjs.len)
		return
	var/selectedObj = pick(validobjs)
	var/datum/objective/crew/newObjective = new selectedObj
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	to_chat(crewMind, "<B>As a part of Nanotrasen's anti-tide efforts, you have been assigned an optional objective. It will be checked at the end of the shift. <span class='warning'>Performing traitorous acts in pursuit of your objective may result in termination of your employment.</span></B>")
	to_chat(crewMind, "<B>Your objective:</B> [newObjective.explanation_text]")

/datum/objective/crew/
	var/jobs = ""
	explanation_text = "Yell at people on github if this ever shows up. Something involving crew objectives is broken."

/datum/objective/crew/proc/setup()
