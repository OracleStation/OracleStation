/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/skub
	desc = "It's skub."
	name = "skub"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("skubbed")

/obj/item/blueshield_gun_package
	name = "Blueshield equipment box"
	desc = "You'll find the Blueshield's gun of choice inside. Schrödinger would be proud."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/storage.dmi'
	icon_state = "blu-wrapped"
	var/list/options = list(".38 Mars Special Revolver" = /obj/item/storage/box/blueshield/revolver,
	".45 Enforcer Semi Automatic Pistol" = /obj/item/storage/box/blueshield/enforcer,
	"Aegis SG7 Laser Gun" = /obj/item/storage/box/blueshield/laser)

/obj/item/blueshield_gun_package/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/choice = input(H, "Choose your weapon!", "Blueshield Gun") as anything in options|null
	if(!choice || !Adjacent(H))
		return
	var/path_variable = options[choice]
	var/obj/item/storage/S = new path_variable(user)
	if(!istype(S))
		return
	user.put_in_hands(S)
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	qdel(src)