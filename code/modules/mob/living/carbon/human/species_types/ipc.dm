/datum/species/ipc
	// TOASTERS!
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 3 // Went cheap with Aircooling
	coldmod = 1.5 // Don't put your computer in the freezer.
	burnmod = 1.5 // Overcoming augmented damage reduction - 1.5 puts it on par with unaugged organics.
	brutemod = 1.5
	toxmod = 0
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOTRANSSTING,MUTCOLORS)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna")
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
	mutanteyes = /obj/item/organ/eyes/robotic // Temporary Blindness when EMP'd.
	mutanttongue = /obj/item/organ/tongue/robot // TO DO: Screams and stutters when EMP'd.
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc // Damaged when EMP'd.
	mutantstomach = /obj/item/organ/stomach/cell // Dumps nutrition when EMP'd.
	mutantears = /obj/item/organ/ears/robot // Jitters, deafens, dizzys when EMP'd.
	// mutant_brain = /var/obj/item/device/mmi/mmi // 'Mutant_brain' exists further downstream. Not even sure if it's actually what I'd need.
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE) // Makes all Bodyparts robotic
		Z.icon = 'icons/mob/augmentation/ipc.dmi' // Overrides the augmentation icons.

/* // Some day, IPCs will be knocked down, spark, and scream when EMP'd. But that day is not today.
/datum/species/emp_act()
    return

/datum/species/ipc/emp_act(mob/living/carbon/)
    ..()
    Knockdown(5)
    visible_message("<span class='danger'>[owner] emits a shower of sparks!</span>", "<span class='userdanger'>!#%$*^ERROR:EMP DETECTED%@$%</span>")
*/

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)