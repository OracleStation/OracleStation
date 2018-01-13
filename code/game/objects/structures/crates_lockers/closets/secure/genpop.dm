/obj/structure/closet/secure_closet/genpop
	desc = "It's a secure locker for prisoner effects."
	name = "prisoner closet"
	req_access = list(ACCESS_BRIG)
	var/obj/item/card/id/prisoner/registered_id = null
	locked = FALSE
	anchored = TRUE
	opened = TRUE
	density = FALSE

/obj/structure/closet/secure_closet/genpop/attackby(obj/item/W, mob/user, params)
	if(!broken && locked && W == registered_id) //Prisoner opening
		handle_prisoner_id(user)
		return

	return ..()

/obj/structure/closet/secure_closet/genpop/proc/handle_prisoner_id(mob/user)
	qdel(registered_id)
	registered_id = null
	locked = FALSE
	open(user)
	desc = "It's a secure locker for prisoner effects."
	to_chat(user, "<span class='notice'>You insert your prisoner id into \the [src] and it springs open!</span>")

/obj/structure/closet/secure_closet/genpop/togglelock(mob/living/user)
	if(!broken && locked && registered_id != null)
		var/result = alert("Are you sure? This will reset the locker!","Unlock Locker","Yes","No")
		if(result == "Yes")
			desc = "It's a secure locker for prisoner effects."
			registered_id = null
		else
			return
	return ..()

/obj/structure/closet/secure_closet/genpop/attack_hand(mob/user)
	if(user.lying && get_dist(src, user) > 0)
		return

	if(!broken && registered_id in user.contents)
		handle_prisoner_id(user)
		return

	if(!broken && opened && !locked && allowed(user)) //Genpop setup
		var/prisoner_name = input(user, "Please input the name of the prisoner.", "Prisoner Name") as text|null
		if(prisoner_name == null)
			return
		var/sentence_length = input(user, "Please input the length of their sentence in minutes.", "Sentence Length") as num|null
		if(sentence_length == null)
			return
		var/crimes = input(user, "Please input their crimes.", "Crimes") as text|null
		if(crimes == null)
			return

		close(user)
		locked = TRUE
		update_icon()

		registered_id = new /obj/item/card/id/prisoner/(src.loc)
		registered_id.registered_name = prisoner_name
		registered_id.sentence = text2num(sentence_length)
		registered_id.crime = crimes
		registered_id.update_label(prisoner_name, registered_id.assignment)

		desc = "It's a secure locker for personal effects. It contains the personal effects of [prisoner_name]."
		return

	..()
