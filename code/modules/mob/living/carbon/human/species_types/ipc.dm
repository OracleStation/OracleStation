/datum/species/ipc
	// TOASTERS!
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 2 // Went cheap with Aircooling
	coldmod = 2 // Don't put your computer in the freezer.
	burnmod = 1.5 // Overcoming augmented damage reduction
	brutemod = 1.5
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOCLONE,NOLIVER,TOXINLOVER,NOTRANSSTING,MUTCOLORS,NOHUNGER,NOSTOMACH) // NOHUNGER is temporary. A liver is needed to process chems (LIKE HOLY WATER)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Blue", "ipc_antenna" = "None")
	meat = null
	damage_overlay_type = "robotic"
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
		Z.icon = 'icons/mob/augmentation/ipc.dmi' // Overrides the augmentation icons

/* /datum/species/ipc/proc/handle_emp // This is what I want it to do, but all I did was copy+paste garbage. This is just here to remind me.
		if(prob(1) && owner.stat == CONSCIOUS)
		owner.visible_message("<span class='danger'>[owner] starts having a seizure!</span>", "<span class='userdanger'>You have a seizure!</span>")
		owner.Unconscious(200)
		owner.Jitter(1000)
		playsound(src, "sparks", 50, 1)
*/

/* /datum/species/ipc/proc/handle_emag // Unlocks Breadslot

*/

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/Z = X
		Z.change_bodypart_status(BODYPART_ORGANIC,FALSE, TRUE)