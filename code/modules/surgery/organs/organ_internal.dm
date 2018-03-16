/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC
	origin_tech = "biotech=3"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	var/zone = "chest"
	var/slot
	// DO NOT add slots with matching names to different zones - it will break internal_organs_slot list!
	var/vital = 0
	///Was this organ implanted/inserted/etc, if true will not be removed during species change.
	var/external = FALSE
	//whether to call Remove() when qdeling the organ.
	var/remove_on_qdel = TRUE

	var/maxDamage = ORGAN_DEFAULT_HEALTH
	var/damage = 0

/obj/item/organ/proc/organ_take_damage(amount)
	damage = Clamp(damage + amount, 0, maxDamage)

/obj/item/organ/proc/organ_heal_damage(amount)//for the purists
	take_damage(-amount)

/obj/item/organ/proc/organ_set_damage(amount)
	damage = Clamp(amount, 0, maxDamage)

/obj/item/organ/proc/get_damage_perc()
	return maxDamage ? damage / maxDamage * 100 : 0 //returns the percentage of damage an organ has; returns 0 if maxDamage is 0

/obj/item/organ/proc/damage_effect_check()//used to do bad things to people
	if(owner.reagents.get_reagent_amount("corazone"))//corazone stops all organ damage effects
		return FALSE
	var/damage_level = get_damage_perc()
	if(damage_level > 30 && prob(sqrt(damage_level) && owner))//triggers once every 18 2 second ticks at 30 damage and once every 10 2 second ticks at 100 damage.
		return TRUE

/obj/item/organ/proc/damage_effect()
	if(owner)
		to_chat(owner, "<span class='warning'>You feel a sharp pain in your [parse_zone(zone)]!</span>")

/obj/item/organ/proc/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	if(!iscarbon(M) || owner == M)
		return

	var/obj/item/organ/replaced = M.getorganslot(slot)
	if(replaced)
		replaced.Remove(M, special = 1)
		if(drop_if_replaced)
			replaced.forceMove(get_turf(src))
		else
			qdel(replaced)

	owner = M
	M.internal_organs |= src
	M.internal_organs_slot[slot] = src
	loc = null
	for(var/X in actions)
		var/datum/action/A = X
		A.Grant(M)

//Special is for instant replacement like autosurgeons
/obj/item/organ/proc/Remove(mob/living/carbon/M, special = 0)
	owner = null
	if(M)
		M.internal_organs -= src
		if(M.internal_organs_slot[slot] == src)
			M.internal_organs_slot.Remove(slot)
		if(vital && !special && !(M.status_flags & GODMODE))
			M.death()
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(M)


/obj/item/organ/proc/on_find(mob/living/finder)
	return

/obj/item/organ/proc/on_life()
	if(damage_effect_check())
		damage_effect()
	return

/obj/item/organ/examine(mob/user)
	..()
	switch(get_damage_perc())
		if(0 to 10)
			to_chat(user, "<span class='warning'>It's in pristine condition!</span>")
		if(10 to 35)
			to_chat(user, "<span class='warning'>It looks pretty banged up!</span>")
		if(35 to 70)
			to_chat(user, "<span class='warning'>It looks badly damaged!</span>")
		if(70 to 100)
			to_chat(user, "<span class='warning'>It's completely obliterated!</span>")

	if(status == ORGAN_ROBOTIC && crit_fail)
		to_chat(user, "<span class='warning'>[src]'s circuits don't seem to be functioning properly!</span>")//for electronic organs; before they reboot; not *quite* related to damage


/obj/item/organ/proc/prepare_eat()
	var/obj/item/reagent_containers/food/snacks/organ/S = new
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.origin_tech = origin_tech
	S.w_class = w_class

	return S

/obj/item/reagent_containers/food/snacks/organ
	name = "appendix"
	icon_state = "appendix"
	icon = 'icons/obj/surgery.dmi'
	list_reagents = list("nutriment" = 5)
	foodtype = RAW | MEAT | GROSS


/obj/item/organ/Destroy()
	if(owner && remove_on_qdel)
		// The special flag is important, because otherwise mobs can die
		// while undergoing transformation into different mobs.
		Remove(owner, special=TRUE)
	return ..()

/obj/item/organ/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(status == ORGAN_ORGANIC)
			var/obj/item/reagent_containers/food/snacks/S = prepare_eat()
			if(S)
				H.drop_item()
				H.put_in_active_hand(S)
				S.attack(H, H)
				qdel(src)
	else
		..()

/obj/item/organ/item_action_slot_check(slot,mob/user)
	return //so we don't grant the organ's action to mobs who pick up the organ.

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm

/mob/living/proc/regenerate_organs()
	return 0

/mob/living/carbon/regenerate_organs()
	var/breathes = TRUE
	var/blooded = TRUE
	if(dna && dna.species)
		if(NOBREATH in dna.species.species_traits)
			breathes = FALSE
		if(NOBLOOD in dna.species.species_traits)
			blooded = FALSE
		var/has_liver = (!(NOLIVER in dna.species.species_traits))
		var/has_stomach = (!(NOSTOMACH in dna.species.species_traits))

		if(has_liver && !getorganslot("liver"))
			var/obj/item/organ/liver/LI

			if(dna.species.mutantliver)
				LI = new dna.species.mutantliver()
			else
				LI = new()
			LI.Insert(src)

		if(has_stomach && !getorganslot("stomach"))
			var/obj/item/organ/stomach/S

			if(dna.species.mutantstomach)
				S = new dna.species.mutantstomach()
			else
				S = new()
			S.Insert(src)

	if(breathes && !getorganslot("lungs"))
		var/obj/item/organ/lungs/L = new()
		L.Insert(src)

	if(blooded && !getorganslot("heart"))
		var/obj/item/organ/heart/H = new()
		H.Insert(src)

	if(!getorganslot("tongue"))
		var/obj/item/organ/tongue/T

		if(dna && dna.species && dna.species.mutanttongue)
			T = new dna.species.mutanttongue()
		else
			T = new()

		// if they have no mutant tongues, give them a regular one
		T.Insert(src)

	if(!getorganslot("eye_sight"))
		var/obj/item/organ/eyes/E

		if(dna && dna.species && dna.species.mutanteyes)
			E = new dna.species.mutanteyes()

		else
			E = new()
		E.Insert(src)

	if(!getorganslot("ears"))
		var/obj/item/organ/ears/ears
		if(dna && dna.species && dna.species.mutantears)
			ears = new dna.species.mutantears
		else
			ears = new

		ears.Insert(src)