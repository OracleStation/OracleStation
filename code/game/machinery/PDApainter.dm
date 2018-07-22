/obj/machinery/pdapainter
	name = "\improper color manipulator"
	desc = "A machine able to color PDAs and IDs with ease. Insert an ID card or PDA and pick a color scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "coloriser"
	density = TRUE
	anchored = TRUE
	var/obj/item/device/pda/storedpda = null
	var/obj/item/card/id/storedid = null
	var/pda_icons = list(
		"Assistant" = "pda",
		"Atmospheric Technician" = "pda-atmos",
		"Bartender" = "pda-bartender",
		"Botanist" = "pda-hydro",
		"Captain" = "pda-captain",
		"Cargo Technician" = "pda-cargo",
		"Chaplain" = "pda-chaplain",
		"Chemist" = "pda-chemistry",
		"Chief Medical Officer" = "pda-cmo",
		"Chief Engineer" = "pda-ce",
		"Clown" = "pda-clown",
		"Cook" = "pda-cook",
		"Curator" = "pda-library",
		"Detective" = "pda-detective",
		"Engineer" = "pda-engineer",
		"Geneticist" = "pda-genetics",
		"Head of Personnel" = "pda-hop",
		"Head of Security" = "pda-hos",
		"Internal Affairs Agent" = "pda-laweyr",
		"Janitor" = "pda-janitor",
		"Medical Doctor" = "pda-medical",
		"Mime" = "pda-mime",
		"Quartermaster" = "pda-qm",
		"Research Director" = "pda-rd",
		"Roboticist" = "pda-robotocist",
		"Scienctist" = "pda-science",
		"Security Officer" = "pda-security",
		"Shaft Miner" = "pda-miner",
		"Virologist" = "pda-virology",
		"Warden" = "pda-warden")
	var/id_icons = list(
		"Assistant" = "id",
		"Captain" = "gold",
		"Cargo" = "cargo",
		"Chief Engineer" = "CE",
		"Chief Medical Officer" = "CMO",
		"Clown" = "clown",
		"Engineering" = "engineering",
		"Head of Personnel" = "silver",
		"Head of Security" = "HoS",
		"Medical" = "medical",
		"Mime" = "mime",
		"Research Director" = "RD",
		"Science" = "research",
		"Security" = "security")
	max_integrity = 200

/obj/machinery/pdapainter/update_icon()
	cut_overlays()

	if(stat & BROKEN)
		icon_state = "coloriser-broken"
		return

	if(storedpda)
		add_overlay("coloriser-pda-in")

	if(storedid)
		add_overlay("coloriser-id-in")

	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "coloriser-off"

	return

/obj/machinery/pdapainter/Destroy()
	QDEL_NULL(storedpda)
	QDEL_NULL(storedid)
	return ..()

/obj/machinery/pdapainter/on_deconstruction()
	if(storedpda)
		storedpda.forceMove(loc)
		storedpda = null
	if(storedid)
		storedid.forceMove(loc)
		storedid = null

/obj/machinery/pdapainter/contents_explosion(severity, target)
	if(storedpda)
		storedpda.ex_act(severity, target)
	if(storedid)
		storedid.ex_act(severity, target)

/obj/machinery/pdapainter/handle_atom_del(atom/A)
	if(A == storedpda)
		storedpda = null
		update_icon()
	if(A == storedid)
		storedid = null
		update_icon()

/obj/machinery/pdapainter/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/device/pda))
		if(storedpda)
			to_chat(user, "<span class='warning'>There is already a PDA inside!</span>")
			return
		else
			var/obj/item/device/pda/P = user.get_active_held_item()
			if(istype(P))
				if(!user.drop_item())
					return
				storedpda = P
				P.loc = src
				P.add_fingerprint(user)
				update_icon()

	else if(istype(O, /obj/item/card/id))
		if(storedid)
			to_chat(user, "<span class='warning'>There is already an ID card inside!</span>")
			return
		else
			var/obj/item/card/id/I = user.get_active_held_item()
			if(istype(I))
				if(!user.drop_item())
					return
				storedid = I
				I.loc = src
				I.add_fingerprint(user)
				update_icon()

	else if(istype(O, /obj/item/weldingtool) && user.a_intent != INTENT_HARM)
		var/obj/item/weldingtool/WT = O
		if(stat & BROKEN)
			if(WT.remove_fuel(0,user))
				user.visible_message("[user] is repairing [src].", \
								"<span class='notice'>You begin repairing [src]...</span>", \
								"<span class='italics'>You hear welding.</span>")
				playsound(loc, WT.usesound, 40, 1)
				if(do_after(user,40*WT.toolspeed, 1, target = src))
					if(!WT.isOn() || !(stat & BROKEN))
						return
					to_chat(user, "<span class='notice'>You repair [src].</span>")
					playsound(loc, 'sound/items/welder2.ogg', 50, 1)
					stat &= ~BROKEN
					obj_integrity = max_integrity
					update_icon()
		else
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")
	else
		return ..()

/obj/machinery/pdapainter/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(stat & BROKEN))
			stat |= BROKEN
			update_icon()

/obj/machinery/pdapainter/attack_hand(mob/user)
	if(!..())
		add_fingerprint(user)
		if(storedpda || storedid)
			if(storedpda)
				var/newpdaskin
				newpdaskin = input(user, "Select a PDA skin!", "PDA Painting") as null|anything in pda_icons
				if(!newpdaskin)
					return
				if(!in_range(src, user))
					return
				if(!storedpda)//is the pda still there?
					return
				storedpda.icon_state = pda_icons[newpdaskin]
				ejectpda()
			if(storedid)
				var/newidskin
				newidskin = input(user, "Select an ID skin!", "ID  Painting") as null|anything in id_icons
				if(!newidskin)
					return
				if(!in_range(src, user))
					return
				if(!storedid)//is the ID still there?
					return
				storedid.icon_state = id_icons[newidskin]
				ejectid()
		else
			to_chat(user, "<span class='notice'>The [src] is empty.</span>")


/obj/machinery/pdapainter/verb/ejectpda()
	set name = "Eject PDA"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	if(storedpda)
		storedpda.loc = get_turf(src.loc)
		storedpda = null
		update_icon()
	else
		to_chat(usr, "<span class='notice'>The [src] is empty.</span>")

/obj/machinery/pdapainter/verb/ejectid()
	set name = "Eject ID"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	if(storedid)
		storedid.loc = get_turf(src.loc)
		storedid = null
		update_icon()
	else
		to_chat(usr, "<span class='notice'>The [src] is empty.</span>")

/obj/machinery/pdapainter/power_change()
	..()
	update_icon()
