/obj/item/device/service
	name = "big red button"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "syndicate=3"

/obj/item/device/service/manifest
	desc = "Adds the name of whoever pressed it to the crew manifest. Cannot be changed or undone after the fact!"

/obj/item/device/service/manifest/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/ID = H.wear_id.GetID()
		if(!ID)
			to_chat(user, "<span class='notice'>You need to wear your ID to properly spoof the manifest! Try again.</span>")
			return
		if(alert(user, "Are you sure you want your crew manifest entry to be [H.real_name], [ID.assignment]?", "", "Yes", "No") == "Yes")
			GLOB.data_core.manifest_inject(H, H.client, ID.assignment)
			to_chat(user, "<span class='notice'>Added to manifest.</span>")
			do_sparks(2, FALSE, src)
			qdel(src)

/obj/item/device/service/ion
	desc = "Announces a fake ion storm."

/obj/item/device/service/ion/attack_self(mob/user)
	priority_announce("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", 'sound/ai/ionstorm.ogg')
	message_admins("[key_name_admin(user)] made a fake ion storm announcement!")
	log_game("[key_name_admin(user)] made a fake ion storm announcement!")
	do_sparks(2, FALSE, src)
	qdel(src)

/obj/item/device/service/meteor
	desc = "Announces a fake meteor storm."

/obj/item/device/service/meteor/attack_self(mob/user)
	priority_announce("Meteors have been detected on collision course with the station.", "Meteor Alert", 'sound/ai/meteors.ogg')
	message_admins("[key_name_admin(user)] made a fake meteor storm announcement!")
	log_game("[key_name_admin(user)] made a fake meteor storm announcement!")
	do_sparks(2, FALSE, src)
	qdel(src)

/obj/item/device/service/rodgod
	desc = "Announces a fake immovable rod."

/obj/item/device/service/rodgod/attack_self(mob/user)
	priority_announce("What the fuck was that?!", "General Alert")
	message_admins("[key_name_admin(user)] made a fake immovable rod announcement!")
	log_game("[key_name_admin(user)] made a fake immovable rod announcement!")
	do_sparks(2, FALSE, src)
	qdel(src)

/obj/item/device/service/a_really_bad_idea
	desc = "Allows you to send any custom Centcom announcement."

/obj/item/device/service/a_really_bad_idea/attack_self(mob/user)
	var/msg = stripped_input(user, "Please enter anything you want. Anything. Serious.", "What?", "") as message|null
	if(msg)
		priority_announce(msg, null, 'sound/ai/commandreport.ogg')
		message_admins("[key_name_admin(user)] made a fake Centcom announcement!")
		log_game("[key_name_admin(user)] made a fake Centcom announcement!")
		do_sparks(2, FALSE, src)
		qdel(src)
