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

/datum/disease/honkening/proc/replace_clothing(var/mob/living/carbon/human/H, obj/item/clothing/oldclothes, slot)
	if(oldclothes && !oldclothes.species_can_equip(clown))
		var/obj/item/clothing/replacement = clown.get_alternative_clothing(oldclothes)
		if(replacement)
			to_chat(H, "<span class='danger'>\The [oldclothes] bulges at the seams, popping off and revealing \a [replacement] underneath!<span>")
			H.equip_to_slot(replacement, slot)
			oldclothes.forceMove(H.loc)
			oldclothes.layer = initial(oldclothes.layer)
			oldclothes.plane = initial(oldclothes.plane)

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
			if(prob(10))
				H.say(pick("Honk", "Honk?", "Honk..."))
		if(3,4)
			if(prob(25))
				H.say(pick("Honk!", "Honk?", "Honk?!", "Honk!?"))
			replace_clothing(H, H.shoes, slot_shoes)
		if(4)
			replace_clothing(H, H.w_uniform, slot_w_uniform)
		if(5)
			if(prob(90))
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
				replace_clothing(H, H.shoes, slot_shoes)
				replace_clothing(H, H.w_uniform, slot_w_uniform)
				H.real_name = H.client ? H.client.prefs.custom_names["clown"] : pick(GLOB.clown_names)
				H.set_species(clown)
				H.say("; H-HONK!!!")
		else
			return
