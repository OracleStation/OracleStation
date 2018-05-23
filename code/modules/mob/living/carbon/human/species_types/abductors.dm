/datum/species/abductor
	name = "Abductor"
	id = "abductor"
	say_mod = "gibbers"
	sexes = 0
	species_traits = list(SPECIES_ORGANIC,NOBLOOD,NOBREATH,VIRUSIMMUNE,NOGUNS,NOHUNGER,NOPAIN,NO_BONES,NOMOUTH)
	mutanttongue = /obj/item/organ/tongue/abductor
	var/scientist = 0 // vars to not pollute spieces list with castes
	var/team = 1
	//no examine text because their examine is weird af anyway
