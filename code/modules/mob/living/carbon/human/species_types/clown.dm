/datum/species/clown
	name = "Clown"
	id = "clown"
	say_mod = "honks"
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human
	examine_text = "a Clown"
	species_text_color = "#ff69b4"
	mutant_bodyparts = list("clown_mouth", "clown_hair", "clown_makeup")
	default_features = list("clown_hair" = "Classic", "clown_mouth" = "Classic", "clown_makeup" = "Classic")
	attack_sound = 'sound/items/bikehorn.ogg'
	skinned_type = /obj/item/clothing/mask/gas/clown_hat
	species_traits = list(NO_UNDERWEAR, NOPAIN)
	loreblurb = "What is it about clowns? They seem to be a happy enough bunch, \
	delighted to suffer a pie-in-the-face or a seltzer-down-the-pants just to \
	make us laugh, but what dark compulsion drives these men to hide behind their \
	painted-on smiles and big rubber noses? What madness turns a man into a clown?"

/datum/species/clown/random_name(gender,unique,lastname)
	return pick(GLOB.clown_names)

/datum/species/clown/on_species_gain(mob/living/carbon/C)
	C.dna.add_mutation(CLOWNMUT)
	C.dna.add_mutation(WACKY)

/datum/species/clown/on_species_loss(mob/living/carbon/C)
	C.dna.remove_mutation(CLOWNMUT)
	C.dna.remove_mutation(WACKY)

/datum/species/clown/after_equip_job(datum/job/J, mob/living/carbon/human/H)

/datum/species/clown/spec_death(gibbed, mob/living/carbon/human/H)
	playsound(H.loc, 'sound/misc/sadtrombone.ogg', 50, 0)

/datum/species/clown/get_alternative_clothing(obj/item/I, mob/M)
	if(istype(I, /obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/S = I
		switch (S.item_color)
			if("hosred")							return new /obj/item/clothing/shoes/clown/black(M)
			else									return new /obj/item/clothing/shoes/clown/sneakers(M)

	if(istype(I, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = I
		switch (U.item_color)
			if("rsecurity","rwarden","detective")	return new /obj/item/clothing/under/clown/sec(M)
			else									return new /obj/item/clothing/under/clown/grey(M)
	return null

/datum/species/clown/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "banana")
		H.adjustBruteLoss(-1)
		H.adjustToxLoss(-1)
		H.adjustFireLoss(-1)
		H.adjustOxyLoss(-1)
		H.adjustStaminaLoss(-1)
		H.adjustBrainLoss(-1)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return TRUE
