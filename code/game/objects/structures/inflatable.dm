/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/inflatable/attack_self(mob/user)
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, "<span class='notice'>You inflate [src].</span>")
	var/obj/structure/inflatable/R = new /obj/structure/inflatable(user.loc)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/inflatable
	name = "inflatable wall"
	desc = "An inflated membrane. Do not puncture. Alt-click twice in quick succession to deflate."
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	var/health = 50.0
	var/click_state = 0

/obj/structure/inflatable/Initialize(location)
	..()
	air_update_turf(TRUE)

/obj/structure/inflatable/Destroy()
	air_update_turf(TRUE)
	return ..()

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height=0)
	return FALSE

/obj/structure/inflatable/CanAtmosPass(turf/T)
	return !density

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <= 0)
		deflate(TRUE)
	return

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			deflate(TRUE)
			return
		if(3.0)
			if(prob(50))
				deflate(TRUE)
				return

/obj/structure/inflatable/blob_act()
	deflate(TRUE)

/obj/structure/inflatable/attack_hand(mob/user as mob)
	add_fingerprint(user)
	return

/obj/structure/inflatable/proc/attack_inflatable(mob/user as mob, damage = 0)	//used by attack_alien, attack_animal, and attack_slime
	health -= damage
	if(health <= 0)
		user.visible_message("<span class='danger'>[user] tears open [src]!</span>")
		deflate(TRUE)
	else	//for nicer text~
		user.visible_message("<span class='danger'>[user] tears at [src]!</span>")

/obj/structure/inflatable/attack_alien(mob/user as mob)
	if(islarva(user))
		return
	attack_inflatable(user, 15)

/obj/structure/inflatable/attack_animal(mob/user as mob)
	if(!isanimal(user))
		return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0)
		return
	attack_inflatable(M, M.melee_damage_upper)

/obj/structure/inflatable/attack_slime(mob/user as mob)
	var/mob/living/simple_animal/slime/S = user
	if(!S.is_adult)
		return
	attack_inflatable(user, rand(10, 15))

/obj/structure/inflatable/attackby(obj/item/W as obj, mob/user as mob, params)
	if(!istype(W))
		return
	if(is_pointed(W))
		visible_message("<span class='danger'>[user] pierces [src] with [W]!</span>")
		deflate(TRUE)
	if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
		..()
	return

/obj/structure/inflatable/proc/hit(var/damage, var/sound_effect = TRUE)
	health = max(0, health - damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		deflate(TRUE)

/obj/structure/inflatable/AltClick(mob/user)
	if(user.stat || user.restrained())
		return
	if(!Adjacent(user))
		return
	if(!click_state)
		click_state = 1
		visible_message("<span class='danger'>[user] unlatches the safety on the [src]'s deflate valve.</span>")
		spawn(2 SECONDS) relatch()

	else
		visible_message("<span class='danger'>[user] deflates the [src].</span>")
		deflate()

/obj/structure/inflatable/proc/relatch()
	if(!src)
		return
	visible_message("<span class='danger'>The safety latch on [src]'s deflate valve re-latches itself.</span>")
	click_state = 0

/obj/structure/inflatable/proc/deflate(var/violent = FALSE)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/R = new /obj/item/inflatable(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door"

/obj/item/inflatable/door/attack_self(mob/user)
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, "<span class='notice'>You inflate [src].</span>")
	var/obj/structure/inflatable/door/R = new /obj/structure/inflatable/door(user.loc)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "door_closed"

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = FALSE

/obj/structure/inflatable/door/attack_ai(mob/user as mob)
	if(isAI(user)) //so the AI can't open it
		return
	else if(iscyborg(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/CanAtmosPass(turf/T)
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates)
		return
	if(ismob(user))
		var/mob/living/M = user
		if(world.time - M.last_bumped <= 6 SECONDS)
			return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	air_update_turf(TRUE)

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = TRUE
	flick("door_opening",src)
	sleep(10)
	density = FALSE
	opacity = FALSE
	state = 1
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/inflatable/door/proc/Close()
	isSwitchingStates = TRUE
	//playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 100, 1)
	flick("door_closing",src)
	sleep(10)
	density = TRUE
	opacity = FALSE
	state = 0
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate(var/violent = FALSE)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)
	air_update_turf(TRUE)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, "<span class='warning'>The inflatable wall is too torn to be inflated!</span>")
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, "<span class='warning'>The inflatable door is too torn to be inflated!</span>")
	add_fingerprint(user)

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	item_state = "syringe_kit"
	max_combined_w_class = 21
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/briefcase/PopulateContents()
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)

