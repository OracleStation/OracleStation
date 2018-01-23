/mob/living/carbon/human/movement_delay()
	. = 0
	var/static/config_human_delay
	if(isnull(config_human_delay))
		config_human_delay = CONFIG_GET(number/human_delay)
	. += ..() + config_human_delay + dna.species.movement_delay(src)

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube)
	if(isobj(shoes) && (shoes.flags_1&NOSLIP_1) && !(lube&GALOSHES_DONT_HELP))
		return 0
	return ..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/effects/space_wind.ogg', 50, 1)
	if(shoes && shoes.flags_1&NOSLIP_1)
		return 0
	return ..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return ((shoes && shoes.negates_gravity()) || dna.species.negates_gravity(src))

/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	for(var/datum/mutation/human/HM in dna.mutations)
		HM.on_move(src, NewLoc)

	if(direct == EAST && lying == 270)//rotation handled on people crawling in different directions
		//yes, this is shitcode, blame FlattestGuitar
		lying = 90
		lying_prev = 270
		update_transform(TRUE)
		lying_prev = lying
	else if(direct == WEST && lying == 90)
		lying = 270
		lying_prev = 90
		update_transform(TRUE)
		lying_prev = lying

	if(shoes)
		if(!lying && !buckled)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/item/clothing/shoes/S = shoes

				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					var/obj/effect/decal/cleanable/blood/footprints/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints) in T
					if(oldFP && (oldFP.blood_state == S.blood_state && oldFP.color == bloodtype_to_color(S.last_bloodtype)))
						return
					S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state]-BLOOD_LOSS_PER_STEP)
					var/obj/effect/decal/cleanable/blood/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints(T)
					FP.blood_state = S.blood_state
					FP.entered_dirs |= dir
					FP.bloodiness = S.bloody_shoes[S.blood_state]
					if(S.last_blood_DNA && S.last_bloodtype)
						FP.blood_DNA += list(S.last_blood_DNA = S.last_bloodtype)
						//hacky as heck; we need to move the LAST entry to there, otherwise we mix all the blood
					FP.update_icon()
					update_inv_shoes()
				//End bloody footprints

				S.step_action()

/mob/living/carbon/human/Moved()
	. = ..()
	if(buckled_mobs && buckled_mobs.len && riding_datum)
		riding_datum.on_vehicle_move()
	if(!lying)
		for(var/obj/item/bodypart/B in bodyparts)
			B.on_mob_move()

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0) //Temporary laziness thing. Will change to handles by species reee.
	if(..())
		return 1
	return dna.species.space_move(src)
