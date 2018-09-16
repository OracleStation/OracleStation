/datum/antagonist/infiltrator
	name = "Syndicate Infiltrator"
	var/datum/team/infiltrator/infiltrator_team
	var/always_new_team = FALSE //If not assigned a team by default ops will try to join existing ones, set this to TRUE to always create new team.
	var/send_to_spawnpoint = TRUE //Should the user be moved to default spawnpoint.

/datum/antagonist/infiltrator/proc/update_synd_icons_added(mob/living/M)
	var/datum/atom_hud/antag/sithud = GLOB.huds[ANTAG_HUD_INFILTRATOR]
	sithud.join_hud(M)
	set_antag_hud(M, "synd")

/datum/antagonist/infiltrator/proc/update_synd_icons_removed(mob/living/M)
	var/datum/atom_hud/antag/sithud = GLOB.huds[ANTAG_HUD_INFILTRATOR]
	sithud.leave_hud(M)
	set_antag_hud(M, null)

/datum/antagonist/infiltrator/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_synd_icons_added(M)

/datum/antagonist/infiltrator/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_synd_icons_removed(M)

/datum/antagonist/infiltrator/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/infiltrator.ogg', 100, 0)
	to_chat(owner, "<span class='userdanger'>You are a syndicate infiltrator!</span>")
	to_chat(owner, "<span class='notice bold'>Your job is to infiltrate [station_name()], and complete our objectives.</span>")
	to_chat(owner, "<span class='notice'>You have an uplink implant, precharged with 35 TC. Use it wisely.</span>")
	to_chat(owner, "<span class='notice'>You also have an internal radio, for communicating with your team-mates at all times.</span>")
	to_chat(owner, "<span class='notice'>You have a dusting implant, to ensure that Nanotrasen does not get their hands on Syndicate gear. Only activate it, if you are compromised.</span>")
	to_chat(owner, "<font size=2><span class='notice bold'>Do NOT kill or destroy needlessly, as this defeats the purpose of an 'infiltration'!</span></font>")
	owner.announce_objectives()

/datum/antagonist/infiltrator/on_gain()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.set_species(/datum/species/human)
		H.real_name = H.dna.species.random_name(H.gender, TRUE)
		owner.name = H.real_name
		H.equipOutfit(/datum/outfit/infiltrator)
	owner.store_memory("Do <B>NOT</B> kill or destroy needlessly, as this defeats the purpose of an 'infiltration'!")
	owner.objectives |= infiltrator_team.objectives
	. = ..()
	if(send_to_spawnpoint)
		move_to_spawnpoint()

/datum/antagonist/infiltrator/on_removal()
	owner.objectives -= infiltrator_team.objectives
	. = ..()

/datum/antagonist/infiltrator/get_team()
	return istype(SSticker.mode.infiltration_team, /datum/team/infiltrator) ? SSticker.mode.infiltration_team : infiltrator_team

/datum/antagonist/infiltrator/create_team(datum/team/infiltrator/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/infiltrator/N in GLOB.antagonists)
				if(!N.owner)
					continue
				if(N.infiltrator_team)
					infiltrator_team = N.infiltrator_team
					return
		infiltrator_team = new /datum/team/infiltrator
		SSticker.mode.infiltration_team = infiltrator_team
		infiltrator_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	infiltrator_team = new_team

/datum/antagonist/infiltrator/proc/admin_send_to_base(mob/admin)
	owner.current.forceMove(pick(GLOB.infiltrator_start))

/datum/antagonist/infiltrator/proc/move_to_spawnpoint()
	var/team_number = 1
	if(infiltrator_team)
		team_number = infiltrator_team.members.Find(owner)
	owner.current.forceMove(GLOB.infiltrator_start[((team_number - 1) % GLOB.infiltrator_start.len) + 1])