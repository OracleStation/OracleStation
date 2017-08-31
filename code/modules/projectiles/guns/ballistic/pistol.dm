/obj/item/gun/ballistic/automatic/pistol
	name = "stechkin pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "combat=3;materials=2;syndicate=4"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 1
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/gun/ballistic/automatic/pistol/m1911
	name = "\improper M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = 0

/obj/item/gun/ballistic/automatic/pistol/enforcer
	name = "enforcer pistol"
	desc = "A lightweight .45 pistol for modern asset protection units. Smells like justice."
	icon_state = "enforcer_black"
	var/base_icon_state = "enforcer_black"
	mag_type = /obj/item/ammo_box/magazine/enforcer
	can_flashlight = TRUE
	unique_rename = TRUE
	unique_reskin = list("Default" = "enforcer_black",
						"Silver Finish" = "enforcer_silver",
						"Red Finish" = "enforcer_red",
						"Red Grip" = "enforcer_redgrip",
						"Green Finish" = "enforcer_green",
						"Green Grip" = "enforcer_greengrip",
						"Tan Finish" = "enforcer_tan",
						"Tan Grip" = "enforcer_tangrip"
						)

/obj/item/gun/ballistic/automatic/pistol/enforcer/reskin_obj(mob/M)
	..()
	base_icon_state = icon_state
	update_icon()

/obj/item/gun/ballistic/automatic/pistol/enforcer/update_icon()
	cut_overlays()
	icon_state = base_icon_state
	if(!chambered)
		icon_state += "-e"
	if(suppressed)
		add_overlay("enforcer_supp")
	if(gun_light)
		if(gun_light.on)
			add_overlay("enforcer_light-on")
		else
			add_overlay("enforcer_light")

/obj/item/gun/ballistic/automatic/pistol/enforcer/ui_action_click()
	toggle_gunlight()

/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "desert eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = 0

/obj/item/gun/ballistic/automatic/pistol/deagle/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("deagle_magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/deagle/gold
	desc = "A gold plated desert eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/APS
	name = "stechkin APS pistol"
	desc = "The original russian version of a widely used Syndicate sidearm. Uses 9mm ammo."
	icon_state = "aps"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "combat=3;materials=2;syndicate=3"
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/gun/ballistic/automatic/pistol/stickman
	name = "flat gun"
	desc = "A 2 dimensional gun.. what?"
	icon_state = "flatgun"
	origin_tech = "combat=3;materials=2;abductor=3"

/obj/item/gun/ballistic/automatic/pistol/stickman/pickup(mob/living/user)
	to_chat(user, "<span class='notice'>As you try to pick up [src], it slips out of your grip..</span>")
	if(prob(50))
		to_chat(user, "<span class='notice'>..and vanishes from your vision! Where the hell did it go?</span>")
		qdel(src)
		user.update_icons()
	else
		to_chat(user, "<span class='notice'>..and falls into view. Whew, that was a close one.</span>")
		user.dropItemToGround(src)

