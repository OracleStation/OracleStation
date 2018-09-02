/datum/species/corvid
	name = "Corvid"
	id = "corvid"
	species_traits = list(SPECIES_ORGANIC, NO_UNDERWEAR, NOTRANSSTING, MUTCOLORS, SMALLSPECIES, NOAUGMENTATION)
	mutant_bodyparts = list("corvid_head_feathers", "corvid_body_feathers")
	default_features = list("mcolor" = "FFF", "corvid_head_feathers" = "None", "corvid_body_feathers" = "None", "corvid_eyes" = "default")
	attack_verb = "pecks"
	punchdamagelow = 0 // Corvid used PECK. It's not very effective...
	punchdamagehigh = 6
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	skinned_type = null
	brutemod = 3 // Fragile bird bones
	burnmod = 1.5 // Fried chicken
	coldmod = 0.8 // Warm feathers
	examine_text = "a corvid"
	species_text_color = "#000000"
	husk_id = "corvidhusk"
	creampie_id = "creampie_corvid"
	damage_overlay_type = "corvid"
	loreblurb = "Small birds that were genetically engineered by the corporation for technical detail work in cramped spaces. \
	Highly clever, they are very quick to learn and extremely adaptive.\
	Due to their mimicing nature, they speak in largely identical human voices; most find this unsettling."

/datum/species/corvid/on_species_gain(mob/living/carbon/C)
	. = ..()
	C.pass_flags |= PASSTABLE
	C.can_be_held = TRUE
	C.mob_size = MOB_SIZE_SMALL

/datum/species/corvid/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.pass_flags &= ~PASSTABLE
	C.can_be_held = FALSE
	C.mob_size = initial(C.mob_size)