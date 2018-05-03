/datum/disease/meningitis
	name = "Meningitis"
	max_stages = 4
	spread_text = "Blood"
	spread_flags = BLOOD
	cure_text = "Mannitol"
	cures = list("mannitol")
	agent = "Neisseria Meningitis"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Meningitis is an inflammation of the protective membranes covering the brain and spinal cord. This one is viral."
	severity = DANGEROUS
	stage_prob = 2

/datum/disease/meningitis/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(6))
				to_chat(affected_mob, "<span class='danger'>The light hurts your eyes.</span>")
		if(3)
			if(prob(4))
				to_chat(affected_mob, "<span class='danger'>Your neck feels stiff.</span>")
			if(prob(3))
				to_chat(affected_mob, "<span class='danger'>Your head hurts.</span>")
				affected_mob.drowsyness += 1
		if(4)
			if(prob(4))
				to_chat(affected_mob, "<span class='danger'>Light flashes from behind your eyes!</span>")
				affected_mob.overlay_fullscreen("flash", /obj/screen/fullscreen/flash)
				affected_mob.clear_fullscreen("flash", 20)
				affected_mob.adjustStaminaLoss(20)
			if(prob(2))
				to_chat(affected_mob, "<span class='danger'>You just want to close your eyes!</span>")
				affected_mob.drowsyness += 2
	return