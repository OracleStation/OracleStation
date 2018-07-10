/datum/species/unathi
	// Reptilian humanoids with scaled skin and tails.
	name = "Unathi"
	id = "unathi"
	say_mod = "hisses"
	default_color = "00FF00"
	species_traits = list(SPECIES_ORGANIC,MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("tail_unathi", "snout", "spines", "horns", "frills", "body_markings", "legs")
	mutanttongue = /obj/item/organ/tongue/unathi
	coldmod = 1.5
	heatmod = 0.67
	default_features = list("mcolor" = "0F0", "tail" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/unathi
	skinned_type = /obj/item/stack/sheet/animalhide/unathi
	exotic_bloodtype = "L"
	disliked_food = GRAIN | DAIRY
	liked_food = GROSS | MEAT
	ass_pic = "unathi"
	examine_text = "a Unathi"
	species_text_color = "#3d0000"
	creampie_id = "creampie_lizard"
	loreblurb = "Cold-blooded and covered in scales, Unathi may seem like a vicious predator put in a fancy jumpsuit, \
	but due to some recent pressure from HR they're generally well-behaved. Most of them don't even fight all that well. \
	Confusing them with Ash Walkers (the similarly lizard-like natives of the Lavaland Wastes) might lead to having a spear lodged in your skull."

/datum/species/unathi/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/draconic)

/datum/species/unathi/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_unathi_name(gender)

	var/randname = unathi_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

//I wag in death
/datum/species/unathi/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/*
 Lizard subspecies: ASHWALKERS
*/
/datum/species/unathi/ashwalker
	name = "Ash Walker"
	id = "ashlizard"
	limbs_id = "unathi"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,NOBREATH,NOGUNS,DIGITIGRADE,NO_BONES)
	examine_text = "an Ash Walker"
	mutanteyes = /obj/item/organ/eyes/night_vision

/datum/species/unathi/ashwalker/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.weather_immunities |= "ash"

/datum/species/unathi/ashwalker/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.weather_immunities -= "ash"
