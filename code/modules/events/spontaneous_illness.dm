/datum/round_event_control/spontaneous_illness
	name = "Spontaneous Illness"
	typepath = /datum/round_event/spontaneous_illness
	weight = 20
	max_occurrences = 4
	earliest_start = 6000
	min_players = 5 // To make your chance of getting help a bit higher.

/datum/round_event/spontaneous_illness/start()
	var/datum/disease/illness
	for(var/mob/living/carbon/human/H in shuffle(GLOB.living_mob_list))
		switch(pick(25;"appendicitis",25;"meningitis",25;"legcramp",25;"beepitisb"))
			if("appendicitis")
				illness = new /datum/disease/appendicitis
			if("meningitis")
				illness = new /datum/disease/meningitis
			if("legcramp")
				illness = new /datum/disease/legcramp
			if("beepitisb")
				illness = new /datum/disease/beepitisb
		if(!H.client)
			continue
		if(H.stat == DEAD)
			continue
		if(VIRUSIMMUNE in H.dna.species.species_traits || !H.CanContractDisease(illness)) //Check immunities
			continue
		H.ForceContractDisease(illness)
		break