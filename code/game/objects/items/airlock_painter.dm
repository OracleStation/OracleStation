/obj/item/airlock_painter
	name = "airlock painter"
	desc = "An advanced autopainter preprogrammed with several paintjobs for airlocks. Use it on an airlock during or after construction to change the paintjob."
	icon = 'icons/obj/objects.dmi'
	icon_state = "paint sprayer"
	item_state = "paint sprayer"

	w_class = WEIGHT_CLASS_SMALL

	materials = list(MAT_METAL=50, MAT_GLASS=50)
	origin_tech = "engineering=2"

	flags_1 = CONDUCT_1 | NOBLUDGEON_1
	slot_flags = SLOT_BELT

	var/obj/item/device/toner/ink = null

/obj/item/airlock_painter/New()
	..()
	ink = new /obj/item/device/toner(src)

//This proc doesn't just check if the painter can be used, but also uses it.
//Only call this if you are certain that the painter will be used right after this check!
/obj/item/airlock_painter/proc/use(mob/user)
	if(can_use(user))
		ink.charges--
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1)
		return 1
	else
		return 0

//This proc only checks if the painter can be used.
//Call this if you don't want the painter to be used right after this check, for example
//because you're expecting user input.
/obj/item/airlock_painter/proc/can_use(mob/user)
	if(!ink)
		to_chat(user, "<span class='notice'>There is no toner cartridge installed in [src]!</span>")
		return 0
	else if(ink.charges < 1)
		to_chat(user, "<span class='notice'>[src] is out of ink!</span>")
		return 0
	else
		return 1

/obj/item/airlock_painter/examine(mob/user)
	..()
	if(!ink)
		to_chat(user, "<span class='notice'>It doesn't have a toner cartridge installed.</span>")
		return
	var/ink_level = "high"
	if(ink.charges < 1)
		ink_level = "empty"
	else if((ink.charges/ink.max_charges) <= 0.25) //25%
		ink_level = "low"
	else if((ink.charges/ink.max_charges) > 1) //Over 100% (admin var edit)
		ink_level = "dangerously high"
	to_chat(user, "<span class='notice'>Its ink levels look [ink_level].</span>")


/obj/item/airlock_painter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/device/toner))
		if(ink)
			to_chat(user, "<span class='notice'>[src] already contains \a [ink].</span>")
			return
		if(!user.transferItemToLoc(W, src))
			return
		to_chat(user, "<span class='notice'>You install [W] into [src].</span>")
		ink = W
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	else
		return ..()

/obj/item/airlock_painter/attack_self(mob/user)
	if(ink)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		ink.loc = user.loc
		user.put_in_hands(ink)
		to_chat(user, "<span class='notice'>You remove [ink] from [src].</span>")
		ink = null
