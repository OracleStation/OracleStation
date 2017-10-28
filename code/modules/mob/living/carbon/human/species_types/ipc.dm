/datum/species/ipc
	// TOASTERS!
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 2 // Went cheap with Aircooling
	coldmod = 2 // Don't put your computer in the freezer.
	burnmod = 1.5 // Overcoming augmented damage reduction - 1.5 puts it on par with unaugged organics.
	brutemod = 1.5
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOTRANSSTING,MUTCOLORS,TOXINLOVER) // NOHUNGER is temporary. A liver is needed to process chems (LIKE HOLY WATER)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None")
	meat = null
	damage_overlay_type = "robotic"
	mutanteyes = /obj/item/organ/eyes/robotic // NOT WORKING?: Vision is obfruscated when EMP'd
	mutanttongue = /obj/item/organ/tongue/robot // TO DO: Screams and stutters when EMP'd.
	mutantliver = /obj/item/organ/liver/ipc // Morality core. No EMP effect. Interactions with emagging.
	mutantstomach = /obj/item/organ/stomach/ipc // The power cell of the IPC. Dumps nutrition when EMP'd.
	mutantears = /obj/item/organ/ears/robot // Jitters, deafens, dizzys when EMP'd.
	// mutant_brain = /var/obj/item/device/mmi/mmi // 'Mutant_brain' exists further downstream. Not even sure if it's actually what I'd need.
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ROBOTIC, FALSE, TRUE) // Makes all Bodyparts robotic
		Z.icon = 'icons/mob/augmentation/ipc.dmi' // Overrides the augmentation icons
/*
/datum/species/ipc/proc/emp_act // Other EMP effects are handled in the individual organs. I'd like the IPC to spark though.
	Knockdown(5)
	visible_message("<span class='danger'>[owner] emits a shower of sparks!</span>", "<span class='userdanger'>!#%$*^ERROR:EMP DETECTED%@$%</span>")
*/

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)