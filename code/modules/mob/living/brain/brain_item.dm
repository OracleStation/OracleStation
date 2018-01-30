/obj/item/organ/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	icon_state = "brain"
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	zone = "head"
	slot = "brain"
	vital = TRUE
	origin_tech = "biotech=5"
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/brain/brainmob = null
	var/damaged_brain = FALSE //whether the brain organ is damaged.
	var/decoy_override = FALSE	//I apologize to the security players, and myself, who abused this, but this is going to go.

/obj/item/organ/brain/changeling_brain
	vital = FALSE
	decoy_override = TRUE

/obj/item/organ/brain/Insert(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	..()

	name = "brain"

	if(C.mind && C.mind.changeling && !no_id_transfer)	//congrats, you're trapped in a body you don't control
		if(brainmob && !(C.stat == DEAD || (C.status_flags & FAKEDEATH)))
			to_chat(brainmob, "<span class = danger>You can't feel your body! You're still just a brain!</span>")
		loc = C
		C.update_hair()
		return

	if(brainmob)
		if(C.key)
			C.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(C)
		else
			C.key = brainmob.key

		QDEL_NULL(brainmob)

	//Update the body's icon so it doesnt appear debrained anymore
	C.update_hair()

/obj/item/organ/brain/Remove(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	..()
	if((!gc_destroyed || (owner && !owner.gc_destroyed)) && !no_id_transfer)
		transfer_identity(C)
	C.update_hair()

/obj/item/organ/brain/prepare_eat()
	return // Too important to eat.

/obj/item/organ/brain/proc/transfer_identity(mob/living/L)
	name = "[L.name]'s brain"
	if(brainmob || decoy_override)
		return
	if(!L.mind)
		return
	brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.timeofhostdeath = L.timeofdeath
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
		if(L.disabilities & NOCLONE)
			brainmob.disabilities |= NOCLONE	//This is so you can't just decapitate a husked guy and clone them without needing to get a new body
		var/obj/item/organ/zombie_infection/ZI = L.getorganslot("zombie_infection")
		if(ZI)
			brainmob.set_species(ZI.old_species)	//For if the brain is cloned
	if(L.mind && L.mind.current)
		L.mind.transfer_to(brainmob)
	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just a brain.</span>")

/obj/item/organ/brain/attackby(obj/item/O, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(brainmob)
		O.attack(brainmob, user) //Oh noooeeeee

/obj/item/organ/brain/examine(mob/user)
	..()

	if(brainmob)
		if(brainmob.client)
			if(brainmob.health <= HEALTH_THRESHOLD_DEAD)
				to_chat(user, "It's lifeless and severely damaged.")
			else
				to_chat(user, "You can feel the small spark of life still left in this one.")
		else
			to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later.")
	else
		if(decoy_override)
			to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later.")
		else
			to_chat(user, "This one is completely devoid of life.")

/obj/item/organ/brain/attack(mob/living/carbon/C, mob/user)
	if(!istype(C))
		return ..()

	add_fingerprint(user)

	if(user.zone_selected != "head")
		return ..()

	if((C.head && (C.head.flags_cover & HEADCOVERSEYES)) || (C.wear_mask && (C.wear_mask.flags_cover & MASKCOVERSEYES)) || (C.glasses && (C.glasses.flags_1 & GLASSESCOVERSEYES)))
		to_chat(user, "<span class='warning'>You're going to need to remove their head cover first!</span>")
		return

//since these people will be dead M != usr

	if(!C.getorgan(/obj/item/organ/brain))
		if(!C.get_bodypart("head"))
			return
		user.drop_item()
		var/msg = "[C] has [src] inserted into [C.p_their()] head by [user]."
		if(C == user)
			msg = "[user] inserts [src] into [user.p_their()] head!"

		C.visible_message("<span class='danger'>[msg]</span>",
						"<span class='userdanger'>[msg]</span>")

		if(C != user)
			to_chat(C, "<span class='notice'>[user] inserts [src] into your head.</span>")
			to_chat(user, "<span class='notice'>You insert [src] into [C]'s head.</span>")
		else
			to_chat(user, "<span class='notice'>You insert [src] into your head.</span>"	)

		Insert(C)
	else
		..()

/obj/item/organ/brain/Destroy() //copypasted from MMIs.
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	return ..()

/obj/item/organ/brain/alien
	name = "alien brain"
	desc = "We barely understand the brains of terrestial animals. Who knows what we may find in the brain of such an advanced species?"
	icon_state = "brain-x"
	origin_tech = "biotech=6"

/obj/item/organ/brain/cybernetic/vox
	name = "Vox cortical stack"
	slot = "brain"
	desc = "A vox cortical stack. A truly alien organ made up of both organic and synthetic parts."
	zone = "head"
	icon_state = "voxbrain"
	status = ORGAN_ROBOTIC
	origin_tech = "biotech=3"

/obj/item/organ/brain/cybernetic/vox/emp_act(severity)
	to_chat(owner, "<span class='warning'>Your head hurts.</span>")
	switch(severity)
		if(1)
			owner.adjustBrainLoss(rand(25, 50))
		if(2)
			owner.adjustBrainLoss(rand(0, 25))

// IPC brain fuckery.
/obj/item/organ/brain/mmi_holder
	name = "brain"
	slot = "brain"
	zone = "chest"
	status = ORGAN_ROBOTIC
	remove_on_qdel = FALSE
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/brain/mmi_holder/Destroy()
	QDEL_NULL(stored_mmi)
	return ..()

/obj/item/organ/brain/mmi_holder/Insert(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	owner = C
	C.internal_organs |= src
	C.internal_organs_slot[slot] = src
	loc = null
	//the above bits are copypaste from organ/proc/Insert, because I couldn't go through the parent here.

	if(stored_mmi.brainmob)
		if(C.key)
			C.ghostize()
		var/mob/living/brain/B = stored_mmi.brainmob
		if(stored_mmi.brainmob.mind)
			B.mind.transfer_to(C)
		else
			C.key = B.key

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.dna && H.dna.species && (REVIVESBYHEALING in H.dna.species.species_traits))
			if(H.health > 0 && !H.hellbound)
				H.revive(0)

	update_from_mmi()

/obj/item/organ/brain/mmi_holder/Remove(var/mob/living/user, special = 0)
	if(!special)
		if(stored_mmi)
			. = stored_mmi
			if(owner.mind)
				owner.mind.transfer_to(stored_mmi.brainmob)
			stored_mmi.loc = owner.loc
			if(stored_mmi.brainmob)
				var/mob/living/brain/B = stored_mmi.brainmob
				spawn(0)
					if(B)
						B.stat = 0
			stored_mmi = null

	..()
	spawn(0)//so it can properly keep surgery going
		qdel(src)

/obj/item/organ/brain/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/brain/mmi_holder/posibrain/Initialize(var/obj/item/device/mmi/MMI)
	. = ..()
	if(MMI)
		stored_mmi = MMI
		MMI.forceMove(src)
	else
		stored_mmi = new /obj/item/device/mmi/posibrain/ipc(src)
	spawn(5)
		if(owner && stored_mmi)
			stored_mmi.name = "positronic brain ([owner.real_name])"
			stored_mmi.brainmob.real_name = owner.real_name
			stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
			stored_mmi.icon_state = "posibrain-occupied"
			update_from_mmi()
