/datum/disease/legcramp
	name = "Leg Cramp"
	max_stages = 4
	spread_text = "Can't spread"
	spread_flags = NON_CONTAGIOUS
	cure_text = "time"
	cures = list("null")
	agent = "Charlie Horses"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Happens often due to fatigue or lack of proper exercise. Leg cramps dissapear on their own after one episode."
	severity = MINOR
	disease_flags = CURABLE|CAN_CARRY
	infectable_hosts = list(SPECIES_ORGANIC, SPECIES_ROBOTIC)
	stage_prob = 25
	cure_chance = 100

/datum/disease/legcramp/stage_act()
	..()
	switch(stage)
		if(1)
			if(affected_mob.get_num_legs() < 1) //No legs, no cramps
				cure()
			else
				to_chat(affected_mob, "<span class='userdanger'>Your leg is seizing up!.</span>")
				stage++
		if(3)
			if(isipc(affected_mob))
				to_chat(affected_mob, "<span class='userdanger'>Standingup.exe failure. Rebooting.</span>")
			else
				to_chat(affected_mob, "<span class='userdanger'>Your leg seizes up! It's a cramp!</span>")
			affected_mob.Knockdown(rand(250,450))
			affected_mob.adjustStaminaLoss(60)
			affected_mob.emote("scream")
			stage++
		if(4)
			cure()
	return

/datum/disease/legcramp/cure()
	..()
	stage = 0 //Straight to 0 and cure.