/datum/species/ethari
	// Furry people with bushy tails and stuff.
	name = "Ethari"
	id = "ethari"
	default_color = "#DF8134"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("tail_ethari", "body_markings", "snout_ethari", "ears_ethari")
	coldmod = 0.67
	heatmod = 1.5
	brutemod = 1.2
	burnmod = 1.2
	default_features = list("mcolor" = "#DF8134", "tail_ethari" = "Bushy", "body_markings" = "None", "snout_ethari" = "Fox", "ears_ethari" = "Fox")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/fox
	skinned_type = /obj/item/stack/sheet/animalhide/ethari
	exotic_bloodtype = "F"
	disliked_food = GRAIN | FRUIT | TOXIC
	liked_food = MEAT | DAIRY | JUNKFOOD

/datum/species/ethari/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/canilunzt)

/datum/species/ethari/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_ethari_name(gender)

	var/randname = ethari_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/ethari/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/datum/species/ethari/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "cocoa" || chem.id == "hot_coco")
		if(prob(15))
			var/datum/disease/D = new /datum/disease/anaphylactic_shock()
			H.ContractDisease(D)
	to_chat(world, chem.id)
	return 0