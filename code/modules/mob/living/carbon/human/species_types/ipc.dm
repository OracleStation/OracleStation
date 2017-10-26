/datum/species/ipc
	// TOASTERS!
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 2 // Went cheap with Aircooling
	burnmod = 2.5 // BODYPART_ROBOTIC has some inherent burn reduction we have to overcome, as well as apply weakness. Variable.
	brutemod = 1.2 // Here to be adjusted for balance.
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOLIVER,TOXINLOVER,NOTRANSSTING,MUTCOLORS,NOHUNGER,NOSTOMACH) // NOHUNGER is temporary
	meat = null
	damage_overlay_type = "synth"
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	// mutantears = /obj/item/organ/ears/robot // Haven't made these yet.
	// mutant_brain = /obj/item/device/mmi/posibrain // 'Mutant_brain' exists further downstream. Not even sure if it's actually what I'd need.
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE) // Makes all Bodyparts robotic
		Z.icon = 'icons/mob/augmentation/augments_ipc.dmi' // Overrides the augmentation icons
		Z.species_color = fixed_mut_color // This pulls forward the color and adds it to the limb.

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)