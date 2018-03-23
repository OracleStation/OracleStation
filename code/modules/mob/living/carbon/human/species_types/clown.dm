/datum/species/clown
	name = "Clown"
	id = "clown"
	say_mod = "honks"
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human
	examine_text = "a Clown"
	species_text_color = "#ff69b4"
	mutant_bodyparts = list("clown_hair", "clown_mask")
	default_features = list("clown_hair" = "Classic", "clown_mask" = "Classic")
	attack_sound = 'sound/items/bikehorn.ogg'
	skinned_type = /obj/item/clothing/mask/gas/clown_hat
	species_traits = list(NO_UNDERWEAR, NOPAIN)

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
		return new /obj/item/clothing/shoes/clown_shoes(M)
	if(istype(I, /obj/item/clothing/under))
		return new /obj/item/clothing/under/rank/clown(M)
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
