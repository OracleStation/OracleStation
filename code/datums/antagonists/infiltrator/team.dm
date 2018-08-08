#define MIN_MAJOR_OBJECTIVES 1
#define MAX_MAJOR_OBJECTIVES 2
#define MIN_MINOR_OBJECTIVES 3
#define MAX_MINOR_OBJECTIVES 4

/datum/team/infiltrator
	var/list/uplinks = list()

/datum/team/infiltrator/proc/add_objective(type)
	var/datum/objective/O = new type
	O.find_target()
	O.team = src
	objectives += O

/datum/team/infiltrator/proc/update_objectives()
	if(LAZYLEN(objectives))
		return
	var/list/major_objectives = subtypesof(/datum/objective/infiltrator)
	var/list/minor_objectives = GLOB.minor_infiltrator_objectives.Copy()
	var/major = rand(MIN_MAJOR_OBJECTIVES, MAX_MAJOR_OBJECTIVES)
	var/minor = rand(MIN_MINOR_OBJECTIVES, MAX_MINOR_OBJECTIVES)
	for(var/i in 1 to major)
		add_objective(pick_n_take(major_objectives))
	for(var/i in 1 to minor)
		var/objective = pick(minor_objectives)
		if(istype(objective, /datum/objective/download))
			minor -= objective
		add_objective(objective)
	for(var/datum/mind/M in members)
		M.objectives |= objectives

/datum/team/infiltrator/proc/get_result()
	var/objectives_complete = 0
	var/objectives_failed = 0

	for(var/datum/objective/O in objectives)
		if(O.check_completion())
			objectives_complete++
		else
			objectives_failed++

	if(objectives_failed == 0 && objectives_complete > 0)
		return INFILTRATION_ALLCOMPLETE
	else if (objectives_complete > objectives_failed)
		return INFILTRATION_MOSTCOMPLETE
	else if((objectives_complete == objectives_failed) || (objectives_complete > 0 && objectives_failed > objectives_complete))
		return INFILTRATION_SOMECOMPLETE
	else
		return INFILTRATION_NONECOMPLETE