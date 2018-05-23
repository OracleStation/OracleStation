/datum/species/ethari
	// Furry people with bushy tails and stuff.
	name = "Ethari"
	id = "ethari"
	default_color = "#DF8134"
	species_traits = list(SPECIES_ORGANIC,MUTCOLORS,EYECOLOR,LIPS,HAIR)
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
	ass_pic = "ethari"
	examine_text = "an Ethari"
	species_text_color = "#e23f03"
	creampie_id = "creampie_lizard"
	loreblurb = "A bipedal, fur-covered race, mostly notable for its abysmal public opinion. \
	Armed with sharp claws, they are strict carnivores and fierce hand-to-hand combatants. \
	Following a major PR disaster Nanotrasen crews are no longer allowed to make Ethari crewmembers fetch the nuclear authentication disk or call them \"good boy\"."

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
