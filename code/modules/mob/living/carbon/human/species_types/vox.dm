/datum/species/vox
	name = "Vox Outcast"
	id = "vox"
	say_mod = "shrieks"
	species_traits = list(NOSCAN, NO_UNDERWEAR, NOTRANSSTING) // Robust, but cannot be cloned.
	mutant_bodyparts = list("vox_quills", "vox_body_markings",  "vox_facial_quills", "vox_tail", "vox_body", "vox_eyes", "vox_tail_markings")
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
	toxmod = 2 // Weak immune systems.
	burnmod = 0.8 // Tough hides.
	stunmod = 1.2 // Take a bit longer to get up than other species.
	breathid = "n2" // O2 is for dustlungs
	examine_text = "A vox outcast"
	husk_id = "voxhusk"
	damage_overlay_type = "vox"
	exotic_bloodtype = "V"

/datum/species/vox/random_name(unique)
	var/sounds = rand(2,8)
	var/i = 0
	var/newname = ""

	while(i<=sounds)
		i++
		newname += pick("ti","hi","ki","ya","ta","ha","ka","yi","chi","cha","kah")
	return capitalize(newname)

/datum/species/vox/on_species_gain(mob/living/carbon/C)
	. = ..()
	var/vox_body = C.dna.features["vox_body"]
	var/datum/sprite_accessory/vox_bodies/vox_body_of_choice = GLOB.vox_bodies_list[vox_body]
	C.dna.species.limbs_id = vox_body_of_choice.limbs_id
	C.dna.features["vox_tail"] = vox_body_of_choice.limbs_id
	C.dna.features["vox_eyes"] = vox_body_of_choice.eye_type

/datum/species/vox/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	H.put_in_r_hand(new /obj/item/tank/internals/emergency_oxygen/vox(H))
	to_chat(H, "<span class='notice'>You are now running on nitrogen internals from the emergency tank in your hand. Your species finds oxygen toxic, so you must breathe nitrogen only.</span>")
	H.internal = H.get_item_for_held_index(2)
	H.update_internals_hud_icon(1)
	H.grant_language(/datum/language/voxpidgin)

/datum/species/vox/spec_life(mob/living/carbon/human/H)
	if(H.disabilities & HUSK)
		H.dna.features["vox_tail"] = "voxhusk"