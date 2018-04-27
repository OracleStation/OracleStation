/obj/machinery/body_scanner
	name = "body scanner"
	desc = "An enclosed machine used to perform an advanced scan of any patient.\nDespite centuries of research it still can't scan for Syndicate implants."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "bscanner_open"
	density = FALSE
	anchored = TRUE
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/body_scanner
	var/mob/living/carbon/carbon_occupant
	var/shows_illegal_implants = FALSE //change this to make the scanner also print shows_up_on_scanners implants
	var/datum/oracle_ui/themed/nano/ui

/obj/machinery/body_scanner/Initialize()
	. = ..()
	ui = new /datum/oracle_ui/themed/nano(src, 400, 600, "body_scanner")
	ui.auto_refresh = TRUE
	ui.current_page = "empty.html"

/obj/machinery/body_scanner/update_icon()
	if(!carbon_occupant)
		icon_state = "bscanner_open"
		return

	if(stat & BROKEN & NOPOWER)
		icon_state = "bscanner_off"
		return

	switch(carbon_occupant.health)
		if(50 to INFINITY)
			icon_state = "bscanner_green"
		if(0 to 50)
			icon_state = "bscanner_yellow"
		if(-99 to 0)
			icon_state = "bscanner_red"
		else
			icon_state = "bscanner_death"

/obj/machinery/body_scanner/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/body_scanner/relaymove(mob/user)
	container_resist(user)

/obj/machinery/body_scanner/open_machine()
	if(!state_open && !panel_open)
		carbon_occupant = null
		..()
		ui.change_page("empty.html")
		update_icon()

/obj/machinery/body_scanner/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		carbon_occupant = occupant
		if(carbon_occupant && carbon_occupant.stat != DEAD)
			to_chat(carbon_occupant, "<span class='boldnotice'>You feel cool air surround you. You go numb as your senses turn inward.</span>")
		update_icon()
		ui.change_page("index.html")

/obj/machinery/body_scanner/emp_act(severity)
	if(is_operational() && occupant)
		open_machine()
	..(severity)

/obj/machinery/body_scanner/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)

/obj/machinery/body_scanner/attackby(obj/item/I, mob/user, params)
	if(!state_open && !occupant)
		if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(exchange_parts(user, I))
		return
	if(default_pry_open(I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/body_scanner/ui_interact(mob/user, state = GLOB.notcontained_state)
	if(stat & BROKEN)
		return
	if(user.loc == src)
		to_chat(user, "<span class='notice'>You can't reach the controls from the inside!</span>")
		return
	ui.render(user)

/obj/machinery/body_scanner/oui_data(mob/user)
	var/list/data = list()

	if(carbon_occupant)
		data["name"] = carbon_occupant.name
		switch(carbon_occupant.stat)
			if(CONSCIOUS)
				data["stat"] = "<span class='good'><b>Alive</b></span>"
			if(UNCONSCIOUS)
				data["stat"] = "<span class='average'><b>Unconscious</b></span>"
			else
				data["stat"] = "<span class='bad'><b>Dead</b></span>"

		data["bruteloss"] = "[carbon_occupant.getBruteLoss()]%"
		data["fireloss"] = "[carbon_occupant.getFireLoss()]%"
		data["toxloss"] = "[carbon_occupant.getToxLoss()]%"
		data["oxyloss"] = "[carbon_occupant.getOxyLoss()]%"
		data["blood"] = "[(carbon_occupant.blood_volume / BLOOD_VOLUME_NORMAL)*100]%"

		if(carbon_occupant.bodyparts.len)
			data["bodyparts"] = ""//we have to pass HTML because of OUI works
			for(var/thing in carbon_occupant.bodyparts)
				var/obj/item/bodypart/B = thing
				var/damage = round((B.brute_dam + B.burn_dam) / B.max_damage * 100)
				data["bodyparts"] +=	 "<section>\
										<span class='label'>[B.name]:</span>\
										<div class='progressBar'>\
											<div class='progressFill bad' style=\"width: [damage]%\"></div>\
										<div class='progressLabel'>[damage]%</div></div>\
										[B.broken ? "<span class='average'>FRACTURE</span>" : ""]\
										</section>"

		if(!data["bodyparts"])
			data["bodyparts"] = "<span class='average'><b>No Bodyparts Found!</b></span>"

		if(carbon_occupant.internal_organs.len)
			data["organs"] = ""
			for(var/thing in carbon_occupant.internal_organs)
				var/obj/item/organ/O = thing
				var/damage = round(O.get_damage_perc())
				data["organs"] += 	"<section>\
									<span class='label'>[O.name]:</span>\
									<div class='progressBar'>\
										<div class='progressFill bad' style=\"width: [damage]%\"></div>\
										<div class='progressLabel'>[damage]%</div></div>\
									</section>"

		if(!data["organs"])
			data["organs"] = "<span class='average'><b>No Organs Found!</b></span>"

		if(carbon_occupant.implants && carbon_occupant.implants.len)
			data["implants"] = ""
			for(var/thing in carbon_occupant.implants)
				var/obj/item/implant/implant = thing
				if(!implant.shows_up_on_scanners && !shows_illegal_implants)
					continue
				data["implants"] += "<section>[implant.name]</section>"

		if(!data["implants"])
			data["implants"] = "<span class='average'><b>No Implants Found!</b></span>"

		data["eject_button"] = ui.act("Open Scanner", user, "door")

	return data

/obj/machinery/body_scanner/oui_act(user, action, params)
	if(..())
		return
	if(action == "door")
		open_machine()
