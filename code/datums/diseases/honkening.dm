/datum/disease/honkening
	name = "The Honkening"
	max_stages = 5
	spread_text = "Ingesting Infected Tissue"
	spread_flags = SPECIAL
	cure_text = "Death"
	cures = list("adminordrazine")
	cure_chance = 100
	agent = "H4NK Nanomachines"
	desc = "This disease, actually acute nanomachine infection, converts the victim into a clown."
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	severity = BIOHAZARD
	var/datum/species/clown/clown = new /datum/species/clown()

/datum/disease/honkening/stage_act()
	..()
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if(istype(H.dna.species, /datum/species/clown))
		cure() // Can't make you a clown if you're already a clown
		return

	switch(stage)
		if(1)
			if(!H.dna.check_mutation(CLOWNMUT))
				H.dna.add_mutation(CLOWNMUT)
		if(2)
			if(!H.dna.check_mutation(WACKY))
				H.dna.add_mutation(WACKY)
		if(3)
			if(prob(10))
				H.say(pick("Honk", "Honk?", "Honk..."))
			var/obj/item/clothing/existing_shoes = H.shoes
			if(existing_shoes && !existing_shoes.species_can_equip(clown))
				var/obj/item/clothing/clown_shoes = clown.get_alternative_clothing(existing_shoes)
				if(clown_shoes)
					to_chat(H, "<span class='danger'>Your [existing_shoes.name] bulges at the seams, popping off and revealing [clown_shoes.name] underneath!<span>")
					H.equip_to_slot(clown_shoes, slot_shoes)
					existing_shoes.forceMove(H.loc)
					existing_shoes.layer = initial(existing_shoes.layer)
					existing_shoes.plane = initial(existing_shoes.plane)
		if(4)
			if(prob(25))
				H.say(pick("Honk!", "Honk?", "Honk?!", "Honk!?"))
			// Replace uniform, if applicable
			var/obj/item/clothing/existing_uniform = H.w_uniform
			if(existing_uniform && !existing_uniform.species_can_equip(clown))
				var/obj/item/clothing/clown_uniform = clown.get_alternative_clothing(existing_uniform)
				if(clown_uniform)
					to_chat(H, "<span class='danger'>Your [existing_uniform.name] bulges at the seams, popping off and revealing [clown_uniform.name] underneath!<span>")
					H.equip_to_slot(clown_uniform, slot_w_uniform)
					existing_uniform.forceMove(H.loc)
					existing_uniform.layer = initial(existing_uniform.layer)
					existing_uniform.plane = initial(existing_uniform.plane)
		if(5)
			if(prob(75))
				H.say("HONK!!!", "HENK!!!")
			else
				cure()
				to_chat(H, "<span class='danger'>You feel something bursting out of your face!<span>")
				H.emote("scream")
				H.Knockdown(100)
				sleep(10)
				H.jitteriness += 50
				H.do_jitter_animation(1000)
				sleep(30)
				if(H.shoes && !H.shoes.species_can_equip(clown))
					H.dropItemToGround(H.shoes)
				if(H.w_uniform && !H.w_uniform.species_can_equip(clown))
					H.dropItemToGround(H.w_uniform)
				H.real_name = H.client ? H.client.prefs.custom_names["clown"] : pick(GLOB.clown_names)
				H.set_species(clown)
				H.say(NewStutter("HONK!!!",rand(0,1000)))
		else
			return
