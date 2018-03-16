/obj/machinery/body_scanner
	name = "body scanner"
	desc = "An enclosed machine used to perform an advanced scan of any patient.\nDespite centuries of research it still can't scan for Syndicate implants."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryopod-open"
	density = FALSE
	anchored = TRUE
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/scanner
	var/mob/living/carbon/carbon_occupant
	occupant_typecache
	var/shows_illegal_implants = FALSE //change this to make the scanner also print shows_up_on_scanners implants

/obj/machinery/body_scanner/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/body_scanner/relaymove(mob/user)
	container_resist(user)

/obj/machinery/body_scanner/open_machine()
	if(!state_open && !panel_open)
		icon_state = "cryopod-open"
		carbon_occupant = null
		..()

/obj/machinery/body_scanner/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		carbon_occupant = occupant
		if(carbon_occupant && carbon_occupant.stat != DEAD)
			to_chat(carbon_occupant, "<span class='boldnotice'>You feel cool air surround you. You go numb as your senses turn inward.</span>")
		icon_state = "cryopod"

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

/obj/machinery/body_scanner/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "body_scanner", name, 375, 550, master_ui, state)
		ui.open()

/obj/machinery/body_scanner/ui_data()
	var/list/data = list()
	data["occupied"] = carbon_occupant ? 1 : 0
	data["open"] = state_open

	if(carbon_occupant)
		data["name"] = carbon_occupant.name
		data["stat"] = carbon_occupant.stat
		data["health"] = carbon_occupant.health
		data["maxHealth"] = carbon_occupant.maxHealth
		data["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["bruteLoss"] = carbon_occupant.getBruteLoss()
		data["fireLoss"] = carbon_occupant.getFireLoss()
		data["toxLoss"] = carbon_occupant.getToxLoss()
		data["oxyLoss"] = carbon_occupant.getOxyLoss()

		data["organs"] = list()
		for(var/thing in carbon_occupant.internal_organs)
			var/obj/item/organ/O = thing
			data["organs"] += list(list("name" = O.name, "damage" = O.get_damage_perc()))

		data["implants"] = list()
		for(var/thing in carbon_occupant.implants)
			var/obj/item/implant/implant = thing
			if(!implant.shows_up_on_scanners && !shows_illegal_implants)
				continue
			data["implants"] += list(list("name" = implant.name))

	return data

/obj/machinery/body_scanner/ui_act(action, params)
	if(..())
		return
	if(action == "door")
		open_machine()