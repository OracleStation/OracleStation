/datum/species/ipc
	// shitty toasters why do we need them
	name = "Machine"
	id = "ipc"
	say_mod = "states"
	heatmod = 3 // Went cheap with Aircooling
	coldmod = 1.5 // Don't put your computer in the freezer.
	burnmod = 2 // Wiring doesn't hold up to heat well.
	brutemod = 2 // Thin metal, cheap materials.
	toxmod = 0
	siemens_coeff = 1.5 // Overload!
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOTRANSSTING,MUTCOLORS,REVIVESBYHEALING)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None", "ipc_chassis" = "Morpheus Cyberkinetics(Greyscale)")
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/metal{amount = 10}
	damage_overlay_type = "robotic"
	male_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	female_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	male_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	female_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	male_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	toxic_food = ALL
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc
	mutantstomach = /obj/item/organ/stomach/cell
	mutantears = /obj/item/organ/ears/robot
	mutant_brain = /obj/item/organ/brain/ipc
	examine_text = "a Machine"
	species_text_color = "#2e2e2e"
	reagent_tag = PROCESS_SYN

/datum/species/ipc/random_name(unique)
	var/ipc_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return ipc_name

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/appendix/appendix = C.getorganslot("appendix")
	appendix.Remove(C)
	qdel(appendix)
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE) // Makes all Bodyparts robotic. And the rest of this string works on selecting your chassis. Color currently doesn't work.
		if( C.dna.features["ipc_chassis"] == "Morpheus Cyberkinetics(Greyscale)")
			O.icon = 'icons/mob/ipc/ipc_morpheus_cyberkinetics_greyscale.dmi'
		if(C.dna.features["ipc_chassis"] == "Morpheus Cyberkinetics(Black)")
			O.icon = 'icons/mob/ipc/ipc_morpheus_cyberkinetics_black.dmi'

/datum/species/pod/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == ("plasma" || "stable_plasma")) // Delicious Plasma
		H.nutrition += (REAGENTS_METABOLISM * 2)
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)