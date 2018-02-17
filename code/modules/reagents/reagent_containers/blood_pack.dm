/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Must be attached to an IV drip."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200
	var/blood_type = null
	var/labelled = 0
	var/color_to_apply = "#FFFFFF"
	var/mutable_appearance/fill_overlay

/obj/item/reagent_containers/blood/Initialize()
	. = ..()
	if(blood_type != null)
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
		update_icon()

/obj/item/reagent_containers/blood/on_reagent_change()
	if(reagents)
		var/datum/reagent/blood/B = reagents.has_reagent("blood")
		if(B && B.data && B.data["blood_type"])
			blood_type = B.data["blood_type"]
			color_to_apply = bloodtype_to_color(blood_type)
		else
			blood_type = null
	update_pack_name()
	update_icon()

/obj/item/reagent_containers/blood/proc/update_pack_name()
	if(!labelled)
		if(blood_type)
			name = "blood pack - [blood_type]"
		else
			name = "blood pack"

/obj/item/reagent_containers/blood/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	var/picked_state = "empty"
	switch(percent)
		if(0 to 5)
			picked_state = "empty"
		if(5 to 9)
			picked_state = "barely-anything-left"
		if(9 to 25)
			picked_state = "twenty-five"
		if(25 to 50)
			picked_state = "this-one-is-like-fifty"
		if(50 to 90)
			picked_state = "like-seventy-five-percent-okay"
		if(90 to INFINITY)
			picked_state = "full"
	cut_overlay(fill_overlay)
	QDEL_NULL(fill_overlay)
	fill_overlay = mutable_appearance(icon = 'icons/obj/bloodpack.dmi', icon_state = picked_state, color = color_to_apply)
	add_overlay(fill_overlay)


/obj/item/reagent_containers/blood/random/Initialize()
	blood_type = pick("A+", "A-", "B+", "B-", "O+", "O-", "L", "F")
	. = ..()

/obj/item/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/reagent_containers/blood/unathi
	blood_type = "L"

/obj/item/reagent_containers/blood/ethari
	blood_type = "F"

/obj/item/reagent_containers/blood/empty
	name = "blood pack"

/obj/item/reagent_containers/blood/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/pen) || istype(I, /obj/item/toy/crayon))

		var/t = stripped_input(user, "What would you like to label the blood pack?", name, null, 53)
		if(!user.canUseTopic(src))
			return
		if(user.get_active_held_item() != I)
			return
		if(loc != user)
			return
		if(t)
			labelled = 1
			name = "blood pack - [t]"
		else
			labelled = 0
			update_pack_name()
	else
		return ..()
