/datum/species/fox
	// Furry people with bushy tails and stuff.
	name = "Foxperson"
	id = "fox"
	default_color = "#DF8134"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAIR)
	mutant_bodyparts = list("tail_fox", "body_markings", "snout_fox", "ears_anthro")
	coldmod = 0.67
	heatmod = 1.5
	brutemod = 1.2
	burnmod = 1.2
	default_features = list("mcolor" = "#DF8134", "tail_fox" = "Bushy", "body_markings" = "None", "snout_fox" = "Fox", "ears_anthro" = "Fox")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/fox
	skinned_type = /obj/item/stack/sheet/animalhide/fox
	exotic_bloodtype = "F"
	disliked_food = GRAIN | FRUIT | TOXIC
	liked_food = MEAT | DAIRY | JUNKFOOD

/datum/species/fox/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/canilunzt)

/datum/species/fox/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_fox_name(gender)

	var/randname = fox_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/fox/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()