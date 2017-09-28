/datum/disease/anaphylactic_shock
	name = "Anaphylactic Shock"
	form = "Shock"
	max_stages = 4
	spread_flags = NON_CONTAGIOUS
	cure_text = "Epinephrine"
	cures = list("epinephrine")
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A severe allergic reaction. Untreated can prove lethal very quickly."
	severity = DANGEROUS
	cure_chance = 50
	stage_prob = 10//advances FAST

/datum/disease/anaphylactic_shock/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(8) && affected_mob.stat == CONSCIOUS)
				var/list/oh_dear = list("Your chest hurts.", "You feel a cold sweat form.", "Your stomach violently rumbles!", "Your stomach hurts.")
				to_chat(affected_mob, "<span class='danger'>[pick(oh_dear)]</span>")
				affected_mob.confused += rand(4, 6)
			if(prob(6))
				affected_mob.emote("cough")
		if(2)
			if(prob(8) && affected_mob.stat == CONSCIOUS)
				var/list/ouch = list("You're having trouble breathing!", "A horrible pain overtakes your body!", "You feel agonizing pain in your stomach!")
				to_chat(affected_mob, "<span class='warning'>[pick(ouch)]</span>")
				affected_mob.confused += rand(4, 6)
			if(prob(2))
				affected_mob.vomit()
			if(prob(6))
				affected_mob.emote("cough")
		if(3)
			if(prob(8) && affected_mob.stat == CONSCIOUS)
				var/list/wow_that_actually_is_bad = list("You're wheezing; you can barely breathe!", "You're having real trouble breathing!", "Your airwaves swell up, cutting off your air supply!")
				to_chat(affected_mob, "<span class='boldwarning'>[pick(wow_that_actually_is_bad)]</span>")
			if(prob(25))
				affected_mob.adjustOxyLoss(5)
			if(prob(6))
				affected_mob.vomit()
		if(4)
			if(prob(8) && affected_mob.stat == CONSCIOUS)
				var/list/u_ded_now = list("YOU'RE CHOKING!", "YOU NEED AIR!", "YOU CAN'T BREATHE!")
				to_chat(affected_mob, "<span class='userdanger'>[pick(u_ded_now)]</span>")
			affected_mob.adjustOxyLoss(5)