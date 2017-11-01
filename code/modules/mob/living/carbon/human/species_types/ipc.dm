/datum/species/ipc
	// shitty toasters why do we need them
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 3 // Went cheap with Aircooling
	coldmod = 1.5 // Don't put your computer in the freezer.
	burnmod = 1.5 // Wiring doesn't hold up to heat well.
	brutemod = 1.6 // Thin metal, cheap materials.
	toxmod = 0
	siemens_coeff = 1.5 // Overload!
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOTRANSSTING,MUTCOLORS)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None")
	meat = /obj/item/stack/sheet/metal
	skinned_type = null
	damage_overlay_type = "robotic"
	male_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	female_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	male_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	female_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	male_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	toxic_food = ALL
	mutanteyes = /obj/item/organ/eyes/robotic // Temporary Blindness when EMP'd.
	mutanttongue = /obj/item/organ/tongue/robot // TO DO: Screams and stutters when EMP'd.
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc // Damaged when EMP'd.
	mutantstomach = /obj/item/organ/stomach/cell // Dumps nutrition when EMP'd.
	mutantears = /obj/item/organ/ears/robot // Jitters, deafens, dizzys when EMP'd.
	// mutant_brain = /var/obj/item/device/mmi/mmi // 'Mutant_brain' exists further downstream. Not even sure if it's actually what I'd need.
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"

/datum/species/ipc/random_name(unique)
	var/ipc_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return ipc_name

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE) // Makes all Bodyparts robotic. And the rest of this string works on selecting your chassis and coloring them correctly. Half of it works
		Z.species_color = fixed_mut_color
		if(("ipc_chassis" in C.dna.species.mutant_bodyparts) && C.dna.features["ipc_chassis"] == "Morpheus Cyberkinetics(Greyscale)")
			Z.icon = 'icons/mob/ipc/ipc_morpheus_cyberkinetics_greyscale.dmi'
		if(("ipc_chassis" in C.dna.species.mutant_bodyparts) && C.dna.features["ipc_chassis"] == "Morpheus Cyberkinetics(Black)")
			Z.icon = 'icons/mob/ipc/ipc_morpheus_cyberkinetics_black.dmi'

/*
// Some day, IPCs will be knocked down, spark, and scream when EMP'd. But that day is not today.
/datum/proc/emp_act()
    return

/datum/species/ipc/proc/emp_act(mob/living/carbon/
    . = ..()
    Knockdown(5)
    new /obj/effect/particle_effect/sparks(get_turf(H))
	playsound(get_turf(H), "sparks", 50, 1)
    visible_message("<span class='danger'>[owner] emits a shower of sparks!</span>", "<span class='userdanger'>!#%$*^ERROR:EMP DETECTED%@$%</span>")
    return
*/

/datum/species/ipc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H) // This isn't quite right yet. An IPC should ignore all chems except for this whitelist.
    if(chem.id in list("holywater", "unholywater", "facid"))
        H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
    if(chem.id in list("plasma","stable_plasma"))
        H.nutrition += 5 // Delicious plasma!
        H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
    else
        H.reagents.del_reagent(chem.id)

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)

