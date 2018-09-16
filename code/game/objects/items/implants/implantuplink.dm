/obj/item/implant/uplink
	name = "uplink implant"
	desc = "Sneeki breeki."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "syndballoon"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	origin_tech = "materials=4;magnets=4;programming=4;biotech=4;syndicate=5;bluespace=5"
	shows_up_on_scanners = FALSE
	actions_types = list(/datum/action/item_action/hands_free/uplink)
	var/starting_tc = 0

/obj/item/implant/uplink/New()
	hidden_uplink = new(src)
	hidden_uplink.telecrystals = starting_tc
	..()

/obj/item/implant/uplink/implant(mob/living/target, mob/user, silent = 0)
	for(var/X in target.implants)
		if(istype(X, type))
			var/obj/item/implant/imp_e = X
			imp_e.hidden_uplink.telecrystals += hidden_uplink.telecrystals
			qdel(src)
			return TRUE

	if(..())
		hidden_uplink.owner = "[user ? user.key : target.key]"
		return TRUE
	return FALSE

/obj/item/implant/uplink/activate()
	if(hidden_uplink)
		hidden_uplink.interact(usr)

/obj/item/implanter/uplink
	name = "implanter (uplink)"
	imp_type = /obj/item/implant/uplink

/obj/item/implanter/uplink/precharged
	name = "implanter (precharged uplink)"
	imp_type = /obj/item/implant/uplink/precharged

/obj/item/implant/uplink/precharged
	starting_tc = 10

/obj/item/implant/uplink/infiltrator
	starting_tc = 35
