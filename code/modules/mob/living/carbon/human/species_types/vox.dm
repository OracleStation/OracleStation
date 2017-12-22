/datum/species/vox
	// Base vox. Shouldn't be used. Look at the subspecies for the ones you should be using.
	name = "Vox"
	id = "vox"
	limbs_id = "grnvox"
	damage_overlay_type = "vox"
	mutant_bodyparts = list("vox_quills", "vox_body_markings", "tail_vox",  "vox_facial_hair")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	male_scream_sound = 'sound/voice/shriek1.ogg'
	female_scream_sound = 'sound/voice/shriek1.ogg'
	male_cough_sound = 'sound/voice/shriekcough.ogg'
	female_cough_sound = 'sound/voice/shriekcough.ogg'
	male_sneeze_sound = 'sound/voice/shrieksneeze.ogg'
	female_sneeze_sound = 'sound/voice/shrieksneeze.ogg'
	mutanttongue = /obj/item/organ/tongue/vox
	mutantlungs = /obj/item/organ/lungs/vox
	mutant_brain = /obj/item/organ/brain/cybernetic/vox
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/vox
	skinned_type = /obj/item/stack/sheet/animalhide/vox
	toxmod = 2 // Weak immune systems. Removing their masks completely skreks them.
	stunmod = 1.5 // Take a bit longer to get up than other species.
	breathid = "n2" // O2 is for dustlungs
	examine_text = "A vox"

/datum/species/vox/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(H), slot_wear_mask)
	H.put_in_l_hand(new /obj/item/tank/internals/emergency_oxygen/vox(H))
	to_chat(H, "<span class='notice'>You are now running on nitrogen internals from the emergency tank in your hand. Your species finds oxygen toxic, so you must breathe nitrogen only.</span>")
	H.internal = H.get_item_for_held_index(2)
	H.update_internals_hud_icon(1)

/*
/*
Vox Lower Caste Subspecies
*/
/datum/species/vox/prolitus
	// Shitbirds, yaya. Hardy, degenerated worker caste.
	name = "Vox Prolitus"
	id = "vox_prolitus"
	say_mod = "shrieks"
	species_traits = list(RESISTPRESSURE,RESISTHOT,RESISTCOLD,EYECOLOR,NOSCAN) // Robust, but cannot be cloned.
	mutant_bodyparts = list("vox_quills", "vox_body_markings", "tail_vox", "vox_body", "vox_facial_hair")
	examine_text = "A Vox Prolitus"
	armor = 2 // Slightly tougher hides.
	liked_food = GROSS | MEAT | RAW // Scavengers

/datum/species/vox/prolitus/on_species_gain(mob/living/carbon/C)
	. = ..()
	var/vox_body = C.dna.features["vox_prolitus_body"]
	var/datum/sprite_accessory/vox_prolitus_body/vox_body_of_choice = GLOB.vox_prolitus_body_list[vox_body]
	C.dna.species.limbs_id = vox_body_of_choice.limbs_id
*/
/*
Vox Upper Caste Subspecies
*/
/datum/species/vox/auroras
	// Non-shitbird spacebird
	name = "Vox Auroras"
	id = "vox_auroras"
	say_mod = "sings"
	species_traits = list(RESISTPRESSURE) // Not Pressure resistant, like the outcasts
	mutant_bodyparts = list("vox_quills", "vox_body", "vox_body_markings", "tail_vox", "vox_auroras_eyes",  "vox_facial_hair")
	examine_text = "A Vox Auroras"
	limbs_id = "aurvox"
	burnmod = 1.3 // Not as tough as the worker caste
	brutemod = 1.3 // Not as combat-capeable as worker caste
	liked_food = MEAT | VEGETABLES // More Refined tastes than the lower castes
	disliked_food = RAW
	toxic_food = GROSS | TOXIC