/datum/game_mode
	var/datum/team/infiltrator/infiltration_team

/datum/game_mode/infiltration
	name = "infiltration"
	config_tag = "infiltration"
	required_players = 25
	required_enemies = 3
	recommended_enemies = 5
	antag_flag = ROLE_INFILTRATOR

	announce_span = "danger"
	announce_text = "Syndicate infiltrators are attempting to board the station!\n\
	<span class='danger'>Infiltrators</span>: Board the station stealthfully and complete your objectives!\n\
	<span class='notice'>Crew</span>: Prevent the infiltrators from completing their objectives!"

	title_icon = "infiltration"

	var/const/agents_possible = 5 //If we ever need more syndicate agents.
	var/agents_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/list/pre_sit = list()

	var/static/list/areas_that_can_finish = typecacheof(list(/area/shuttle/stealthcruiser, /area/infiltrator_base))

/datum/game_mode/infiltration/pre_setup()
	var/n_agents = min(max(Ceiling(num_players() / 7), 1), antag_candidates.len, agents_possible)
	for(var/i = 0, i < n_agents, ++i)
		var/datum/mind/new_sit = pick_n_take(antag_candidates)
		pre_sit += new_sit
		new_sit.assigned_role = "Syndicate Infiltrator"
		new_sit.special_role = "Syndicate Infiltrator"
		log_game("[new_sit.key] (ckey) has been selected as a syndicate infiltrator")
	return TRUE

/datum/game_mode/infiltration/post_setup()
	for(var/datum/mind/sit_mind in pre_sit)
		sit_mind.add_antag_datum(/datum/antagonist/infiltrator)
	return ..()

/datum/game_mode/infiltration/check_finished() //to be called by SSticker
	if(!infiltration_team || !LAZYLEN(infiltration_team.objectives) || CONFIG_GET(keyed_flag_list/continuous)["infiltration"])
		return ..()
	if(replacementmode && round_converted == 2)
		return replacementmode.check_finished()
	if((SSshuttle.emergency.mode == SHUTTLE_ENDGAME) || station_was_nuked)
		return TRUE
	var/objectives_complete = TRUE
	var/all_at_base = TRUE
	for(var/A in infiltration_team.objectives)
		var/datum/objective/O = A
		if(!O.check_completion())
			objectives_complete = FALSE
	if(objectives_complete)
		for(var/B in infiltration_team.members)
			var/datum/mind/M = B
			if(M && M.current && M.current.stat && M.current.client)
				var/turf/T = get_turf(M.current)
				var/area/A = get_area(T)
				if((T.z != ZLEVEL_CENTCOM) || !is_type_in_typecache(A, areas_that_can_finish))
					all_at_base = FALSE
	return all_at_base && objectives_complete

/datum/game_mode/infiltration/declare_completion()
	var result = infiltration_team.get_result()
	switch(result)
		if(INFILTRATION_ALLCOMPLETE)
			SSblackbox.add_details("infiltrator_win", "major")
			SSticker.mode_result = "major win - objectives complete"
		if(INFILTRATION_MOSTCOMPLETE)
			SSticker.mode_result = "semi-major win - most objectives complete"
			SSblackbox.add_details("infiltrator_win", "mostly")
		if(INFILTRATION_SOMECOMPLETE)
			SSticker.mode_result = "minor win - some objectives complete"
			SSblackbox.add_details("infiltrator_win", "minor")
		else
			SSticker.mode_result = "loss - no objectives complete"
			SSblackbox.add_details("infiltrator_win", "loss")
	return ..()

/datum/game_mode/proc/auto_declare_completion_infiltration()
	var/list/parts = list()

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""
	for(var/obj/item/device/uplink/H in infiltration_team.uplinks)
		TC_uses += H.spent_telecrystals
		uplink_true = TRUE
		purchases += H.purchase_log

	var/text = "<br><font size=3><b>The infiltrators were:</b></font>"
	text += printplayerlist(infiltration_team.members)
	text += "<br>"
	parts += text

	var/objectives_text = ""
	var/count = 1
	var/win = TRUE
	for(var/datum/objective/objective in infiltration_team.objectives)
		if(objective.check_completion())
			objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
			SSblackbox.add_details("infiltrator_objective","[objective.type]|SUCCESS")
		else
			objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
			SSblackbox.add_details("infiltrator_objective","[objective.type]|FAIL")
			win = FALSE
		count++

	parts += objectives_text

	if(uplink_true)
		parts += " (used [TC_uses] TC) [purchases]"
		if(TC_uses == 0 && win)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			parts += "<BIG>[icon2html(badass, world)]</BIG>"
	to_chat(world, parts.Join("<br>"))
	return TRUE

/datum/game_mode/infiltration/generate_credit_text()
	var/list/round_credits = list()

	round_credits += "<center><h1>The Sneaky Infiltrators:</h1>"
	for(var/datum/mind/i in infiltration_team.members)
		round_credits += "<center><h2>[i.name]</h2>"
	round_credits += "<br>"

	round_credits += ..()
	return round_credits