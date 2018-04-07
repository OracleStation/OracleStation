// Floor painter

/obj/item/device/floor_painter
	name = "floor painter"
	icon = 'icons/obj/objects.dmi'
	icon_state = "paint sprayer2"
	item_state = "paint sprayer"

	var/floor_icon
	var/floor_state = "floor"
	var/floor_dir = SOUTH

	w_class = WEIGHT_CLASS_TINY
	item_state = "electronic"
	slot_flags = SLOT_BELT
	var/charge_per_use = 0.1

	var/obj/item/device/toner/ink = null

	var/static/list/allowed_states = list(
		"floor", "stairs", "stairs-l", "stairs-m", "stairs-r", "cafeteria", "chapel", "cmo", "barber", "bar",
		"arrival", "arrivalcorner", "escape", "escapecorner", "freezerfloor", "solarpanel",
		"delivery", "whitedelivery", "bot", "whitebot", "loadingarea", "recharge_floor",
		"red", "redcorner", "redfull", "whitered", "whiteredcorner",
		"blue", "bluecorner", "bluefull", "whiteblue", "whitebluecorner",
		"green", "greencorner", "greenfull", "whitegreen", "whitegreencorner",
		"yellow", "yellowcorner", "yellowfull", "whiteyellow", "whiteyellowcorner",
		"purple", "purplecorner", "purplefull", "whitepurple", "whitepurplecorner",
		"neutral", "neutralcorner", "neutralfull", "orange", "orangecorner", "orangefull",
		"black", "blackcorner", "caution", "cautioncorner", "cautionfull",
		"brown", "browncorner", "white", "whitehall", "whitecorner",
		"redblue", "bluered", "redbluefull", "redgreen", "redgreenfull",
		"greenyellow", "greenyellowfull", "greenblue", "greenbluefull", "blueyellow", "blueyellowfull",
		"darkpurple", "darkpurplecorners", "darkred", "darkredcorners", "darkblue", "darkbluecorners",
		"darkyellow", "darkyellowcorners", "darkbrown", "darkbrowncorners", "dark",
		"L1","L2","L3","L4","L5","L6","L7","L8","L9","L10","L11","L12","L13","L14"
		)

/obj/item/device/floor_painter/New()
	..()
	ink = new /obj/item/device/toner(src)

/obj/item/device/floor_painter/AltClick(mob/user)
	if(ink)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		ink.loc = user.loc
		user.put_in_hands(ink)
		to_chat(user, "<span class='notice'>You remove [ink] from [src].</span>")
		ink = null

/obj/item/device/floor_painter/attackby(obj/item/W, mob/user, params)
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

/obj/item/device/floor_painter/examine(mob/user)
	..()
	if(!ink)
		to_chat(user, "<span class='notice'>It doesn't have a toner cartridge installed.</span>")
		return
	var/ink_level = "high"
	if(ink.charges <= 0)
		ink_level = "empty"
	else if((ink.charges/ink.max_charges) <= 0.25) //25%
		ink_level = "low"
	else if((ink.charges/ink.max_charges) > 1) //Over 100% (admin var edit)
		ink_level = "dangerously high"
	to_chat(user, "<span class='notice'>Its ink levels look [ink_level].</span>")

/obj/item/device/floor_painter/afterattack(var/atom/A, var/mob/user, proximity, params)
	if(!proximity)
		return

	if(!ink)
		to_chat(user, "<span class='notice'>There is no toner cartridge installed in [src]!</span>")
		return FALSE
	else if(ink.charges <= 0)
		to_chat(user, "<span class='notice'>[src] is out of ink!</span>")
		return FALSE

	var/turf/open/floor/plasteel/F = A
	if(!istype(F))
		to_chat(user, "<span class='warning'>\The [src] can only be used on station flooring.</span>")
		return

	F.icon_state = floor_state
	F.icon_regular_floor = floor_state
	F.dir = floor_dir

	if(ink.charges > charge_per_use)
		playsound(src, 'sound/effects/spray2.ogg', 50, 1)
	else
		playsound(src, 'sound/effects/spray3.ogg', 50, 1)

	ink.charges -= charge_per_use

/obj/item/device/floor_painter/attack_self(var/mob/user)
	if(!user)
		return FALSE
	user.set_machine(src)
	interact(user)
	return TRUE

/obj/item/device/floor_painter/interact(mob/user as mob)
	if(!floor_icon)
		floor_icon = icon('icons/turf/floors.dmi', floor_state, floor_dir)
	user << browse_rsc(floor_icon, "floor.png")
	var/dat = {"
		<center>
		<a href="?src=[UID()];cycleleft=1">&lt;-</a>
		<img style="-ms-interpolation-mode: nearest-neighbor;" src="floor.png" width=128 height=128 border=4>
		<a href="?src=[UID()];cycleright=1">-&gt;</a>
		</center>
		<a href="?src=[UID()];choose_state=1">Choose Style</a>
		<div class='statusDisplay'>Style: [floor_state]</div>
		<a href="?src=[UID()];choose_dir=1">Choose Direction</a>
		<div class='statusDisplay'>Direction: [dir2text(floor_dir)]</div>
	"}

	var/datum/browser/popup = new(user, "floor_painter", name, 225, 300)
	popup.set_content(dat)
	popup.open()

/obj/item/device/floor_painter/Topic(href, href_list)
	if(..())
		return

	if(href_list["choose_state"])
		var/state = input("Please select a style", "[src]") as null|anything in allowed_states
		if(state)
			floor_state = state
			floor_dir = SOUTH // Reset dir, because some icon_states might not have that dir.
	if(href_list["choose_dir"])
		var/seldir = input("Please select a direction", "[src]") as null|anything in list("north", "south", "east", "west", "northeast", "northwest", "southeast", "southwest")
		if(seldir)
			floor_dir = text2dir(seldir)
	if(href_list["cycleleft"])
		var/index = allowed_states.Find(floor_state)
		index--
		if(index < 1)
			index = allowed_states.len
		floor_state = allowed_states[index]
		floor_dir = SOUTH
	if(href_list["cycleright"])
		var/index = allowed_states.Find(floor_state)
		index++
		if(index > allowed_states.len)
			index = 1
		floor_state = allowed_states[index]
		floor_dir = SOUTH

	floor_icon = icon('icons/turf/floors.dmi', floor_state, floor_dir)
	if(usr)
		attack_self(usr)
