/datum/disease/beepitisb
	name = "Beepitis B"
	max_stages = 4
	spread_text = "By touch"
	spread_flags = CONTACT_GENERAL
	cure_text = "Long moments splashed in water"
	cures = list("null")
	agent = "Aceria Industrialis X-486"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Beepitis B is a minor illness originating from microscopic robotic mites burying inside robotic lifeforms"
	severity = MINOR
	infectable_hosts = list(SPECIES_ROBOTIC)

/datum/disease/beepitisb/stage_act()
	if(carrier && !affected_mob.fire_stacks <= 0)
		return
	stage = min(stage, max_stages)
	if(affected_mob.fire_stacks >= 0) //This cure is a long shower to get the Mites to leave.
		if(prob(stage_prob))
			stage = min(stage + 1,max_stages)
	else
		if(prob(cure_chance))
			stage = max(stage - 1, 1)
	if(disease_flags & CURABLE)
		if(affected_mob.fire_stacks < 0 && prob(cure_chance))
			cure()
	switch(stage)
		if(2)
			if(prob(5))
				to_chat(affected_mob, "<span class='danger'>You feel the need to Beep.</span>")
		if(3)
			if(prob(5))
				to_chat(affected_mob, "<span class='danger'>01100010011001010110010101110000.</span>")
		if(4)
			if(prob(4))
				affected_mob.say(pick( list("Beep!", "*beep", "BEEP.", "Beep?", "Beep...") ) )
	return