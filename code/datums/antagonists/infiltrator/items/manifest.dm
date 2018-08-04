/obj/item/device/manifestspoof
	name = "big red button"
	desc = "Adds the name of whoever pressed it to the crew manifest. Cannot be changed or undone after the fact!"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "syndicate=3"

/obj/item/device/manifestspoof/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/ID = H.wear_id.GetID()
		if(!ID)
			to_chat(user, "<span class='notice'>You need to wear your ID to properly spoof the manifest! Try again.</span>")
			return
		if(input(user, "Are you sure you want your crew manifest entry to be [H.real_name], [ID.assignment]?", "", "Yes", "No") == "Yes")
			GLOB.data_core.manifest_inject(H, H.client, ID.assignment)
			to_chat(user, "<span class='notice'>Added to manifest.</span>")
			do_sparks(2, FALSE, src)
			qdel(src)