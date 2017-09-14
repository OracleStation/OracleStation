/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = 0
	interact_offline = 1
	req_one_access = list(ACCESS_HEADS, ACCESS_ARMORY) //Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	var/mode = null

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/attack_ai()
	attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	add_fingerprint(usr)

	var/dat

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr

	add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryoitems")

	else if(href_list["item"])
		if(!allowed(user))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			to_chat(user, "<span class='notice'>\The [I] is no longer in storage.</span>")
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges \the [I].</span>")

		I.forceMove(get_turf(src))
		frozen_items -= I

	else if(href_list["allitems"])
		if(!allowed(user))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, "<span class='notice'>There is nothing to recover from storage.</span>")
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges the desired objects.</span>")

		for(var/obj/item/I in frozen_items)
			I.forceMove(get_turf(src))
			frozen_items -= I

	updateUsrDialog()
	return

/obj/item/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = "programming=1"

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "cryopod-open"
	density = TRUE
	anchored = TRUE
	state_open = TRUE
	unsecuring_tool = null

	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"

	// 15 minutes-ish safe period before being despawned.
	var/time_till_despawn = 15 * 600 // This is reduced by 90% if a player manually enters cryo
	var/despawn_world_time = null          // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/device/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/areaeditor/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/armor,
		/obj/item/defibrillator/compact,
		/obj/item/reagent_containers/hypospray/CMO,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/gloves/krav_maga,
		/obj/item/storage/internal,
		/obj/item/nullrod
	)
	// These items will NOT be preserved
	var/list/do_not_preserve_items = list (
		/obj/item/device/mmi/posibrain
	)

/obj/machinery/cryopod/Initialize()
	..()
	update_icon()
	find_control_computer()

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	for(var/obj/machinery/computer/cryopod/C in area_contents(get_area(src)))
		control_computer = C
		break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>")
		if(mob_occupant.client)//if they're logged in
			despawn_world_time = world.time + (time_till_despawn * 0.1)
		else
			despawn_world_time = world.time + time_till_despawn
	icon_state = "cryopod"

/obj/machinery/cryopod/open_machine()
	..()
	icon_state = "cryopod-open"
	//TODO?

/obj/machinery/crypod/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist(user)

/obj/machinery/cryopod/process()
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		// Eject dead people
		if(mob_occupant.stat == DEAD)
			open_machine()

		if(!(world.time > despawn_world_time + 100))//+ 10 seconds
			return

		if(!mob_occupant.client && mob_occupant.stat < 2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer(urgent = 1))
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
/obj/machinery/cryopod/proc/despawn_occupant()
	var/mob/living/mob_occupant = occupant
	for(var/obj/item/W in mob_occupant.GetAllContents())
		W.forceMove(src)
		for(var/T in preserve_items)
			if(!istype(W, T))
				if(control_computer && control_computer.allow_items)
					control_computer.frozen_items += W
					W.loc = null
				else
					W.forceMove(loc)
			else
				qdel(W)
	if(istype(SSticker.mode, /datum/game_mode/cult))//thank
		if("sacrifice" in SSticker.mode.cult_objectives)
			var/list/possible_targets = list()
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.mind && !is_convertable_to_cult(H) && !iscultist(H))
					possible_targets += H

			possible_targets -= mob_occupant.mind
			if(!possible_targets.len)
				message_admins("Cult Sacrifice: Could not find unconvertable target, checking for convertable target.")
				for(var/mob/living/carbon/human/player in GLOB.player_list)
					if(player.mind && !iscultist(player))
						possible_targets += player.mind

			if(possible_targets.len > 0)
				GLOB.sac_mind = pick(possible_targets)
				if(!GLOB.sac_mind)
					message_admins("Cult Sacrifice: ERROR -  Null target chosen!")
				else
					var/datum/job/sacjob = SSjob.GetJob(GLOB.sac_mind.assigned_role)
					var/datum/preferences/sacface = GLOB.sac_mind.current.client.prefs
					var/icon/reshape = get_flat_human_icon(null, sacjob, sacface)
					reshape.Shift(SOUTH, 4)
					reshape.Shift(EAST, 1)
					reshape.Crop(7,4,26,31)
					reshape.Crop(-5,-3,26,30)
					GLOB.sac_image = reshape

					for(var/datum/mind/H in SSticker.mode.cult)
						if(H.current)
							to_chat(H.current, "<span class='danger'>Nar'Sie</span> murmurs, <span class='cultlarge'>[occupant] is beyond your reach. Sacrifice [GLOB.sac_mind.current] instead...</span></span>")

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in world)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(istype(O,/datum/objective/mutiny) && O.target == mob_occupant.mind)
			qdel(O)
		else if(O.target && istype(O.target,/datum/mind))
			if(O.target == mob_occupant.mind)
				if(O.owner && O.owner.current)
					to_chat(O.owner.current, "<BR><span class='userdanger'>You get the feeling your target is no longer within reach. Time for Plan [pick("A","B","C","D","X","Y","Z")]. Objectives updated!</span>")
				O.target = null
				spawn(1) //This should ideally fire after the occupant is deleted.
					if(!O) return
					O.find_target()
					if(!(O.target))
						O.owner.objectives -= O
						qdel(O)
	if(mob_occupant.mind && mob_occupant.mind.assigned_role)
		//Handle job slot/tater cleanup.
		var/job = mob_occupant.mind.assigned_role
		SSjob.FreeRole(job)
		if(mob_occupant.mind.objectives.len)
			mob_occupant.mind.objectives.Cut()
			mob_occupant.mind.special_role = null

	// Delete them from datacore.

	var/announce_rank = null
	for(var/datum/data/record/R in GLOB.data_core.medical)
		if((R.fields["name"] == mob_occupant.real_name))
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["name"] == mob_occupant.real_name))
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == mob_occupant.real_name))
			announce_rank = G.fields["rank"]
			qdel(G)

	for(var/obj/machinery/computer/cloning/cloner in world)
		for(var/datum/data/record/R in cloner.records)
			if(R.fields["name"] == mob_occupant.real_name)
				cloner.records.Remove(R)

	//Make an announcement and log the person entering storage.
	control_computer.frozen_crew += "[mob_occupant.real_name]"

	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())
		visible_message("<span class='notice'>\The [src] hums and hisses as it moves [mob_occupant.real_name] into storage.</span>")

	// Ghost and delete the mob.
	if(!mob_occupant.get_ghost(1))
		if(world.time < 30 * 600)//before the 30 minute mark
			mob_occupant.ghostize(0) // Players despawned too early may not re-enter the game
		else
			mob_occupant.ghostize(1)
	QDEL_NULL(occupant)
	open_machine()
	name = initial(name)

/obj/machinery/cryopod/MouseDrop_T(mob/living/target, mob/user)
	if(!istype(target) || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || !ismob(target) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, "<span class='boldnotice'>The cryo pod is already occupied!</span>")
		return

	if(target.stat == DEAD)
		to_chat(user, "<span class='notice'>Dead people can not be put into cryo.</span>")
		return

	if(target.client && user != target)
		to_chat(user, "<span class='notice'>You can't put conscious people into [src]!</span>")
	else if(target.client)
		if(alert(target,"Would you like to enter cryosleep?",,"Yes","No") == "No")
			return

	var/generic_plsnoleave_message = " Please adminhelp before leaving the round, unless there are no administrators online."

	if(target == user && world.time - target.client.cryo_warned > 5 * 600)//if we haven't warned them in the last 5 minutes
		if(target.mind.assigned_role in GLOB.command_positions)
			to_chat(target, "<span class='danger'>You're a Head of Staff![generic_plsnoleave_message]</span>")
		if(iscultist(target) || is_servant_of_ratvar(target))
			to_chat(target, "<span class='danger'>You're a Cultist![generic_plsnoleave_message]</span>")
		if(istype(SSticker.mode, /datum/game_mode/blob))
			var/datum/game_mode/blob/G = SSticker.mode
			if(target.mind in G.blob_overminds)
				to_chat(target, "<span class='danger'>You're a Blob![generic_plsnoleave_message]</span>")
		if(is_devil(target))
			to_chat(target, "<span class='danger'>You're a Devil![generic_plsnoleave_message]</span>")
		if(is_gangster(target))
			to_chat(target, "<span class='danger'>You're a Gangster![generic_plsnoleave_message]</span>")
		if(istype(SSticker.mode, /datum/game_mode/revolution))
			var/datum/game_mode/revolution/G = SSticker.mode
			if(target.mind in G.head_revolutionaries)
				to_chat(target, "<span class='danger'>You're a Head Revolutionary![generic_plsnoleave_message]</span>")
			else if(target.mind in G.revolutionaries)
				to_chat(target, "<span class='danger'>You're a Revolutionary![generic_plsnoleave_message]</span>")
		target.client.cryo_warned = world.time
		return

	if(target == user)
		visible_message("[user] starts climbing into the cryo pod.")
	else
		visible_message("[user] starts putting [target] into the cryo pod.")

	if(occupant)
		to_chat(user, "<span class='boldnotice'>\The [src] is in use.</span>")
		return
	close_machine(target)

	to_chat(target, "<span class='boldnotice'>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</span>")
	name = "[name] ([occupant.name])"
	log_admin("<span class='notice'>[key_name(target)] entered a stasis pod.</span>")
	message_admins("[key_name_admin(target)] entered a stasis pod. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	add_fingerprint(target)

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.

// /obj/machinery/computer/cryopod/robot
// 	name = "robotic storage console"
// 	desc = "An interface between crew and the robotic storage systems"
// 	icon = 'icons/obj/robot_storage.dmi'
// 	icon_state = "console"
// 	circuit = /obj/item/circuitboard/robotstoragecontrol
//
// 	storage_type = "cyborgs"
// 	storage_name = "Robotic Storage Control"
// 	allow_items = 0
//
// /obj/machinery/cryopod/robot
// 	name = "robotic storage unit"
// 	desc = "A storage unit for robots."
// 	icon = 'icons/obj/robot_storage.dmi'
// 	icon_state = "pod_0"
// 	base_icon_state = "pod_0"
// 	occupied_icon_state = "pod_1"
// 	on_store_message = "has entered robotic storage."
// 	on_store_name = "Robotic Storage Oversight"
// 	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
// 	allow_occupant_types = list(/mob/living/silicon/robot)
// 	disallow_occupant_types = list(/mob/living/silicon/robot/drone)
//
// /obj/machinery/cryopod/robot/right
// 	orient_right = 1
// 	icon_state = "pod_0-r"
//
// /obj/machinery/cryopod/robot/despawn_occupant()
// 	var/mob/living/silicon/robot/R = occupant
// 	if(!istype(R)) return ..()
//
// 	R.contents -= R.mmi
// 	qdel(R.mmi)
// 	for(var/obj/item/I in R.module) // the tools the borg has; metal, glass, guns etc
// 		for(var/obj/item/O in I) // the things inside the tools, if anything; mainly for janiborg trash bags
// 			O.loc = R
// 		qdel(I)
// 	R.module.remove_subsystems_and_actions(R)
// 	qdel(R.module)
//
// 	return ..()
//
// /proc/cryo_ssd(var/mob/living/carbon/person_to_cryo)
// 	if(istype(person_to_cryo.loc, /obj/machinery/cryopod))
// 		return 0
// 	var/list/free_cryopods = list()
// 	for(var/obj/machinery/cryopod/P in machines)
// 		if(!P.occupant && istype(get_area(P), /area/crew_quarters/sleep))
// 			free_cryopods += P
// 	var/obj/machinery/cryopod/target_cryopod = null
// 	if(free_cryopods.len)
// 		target_cryopod = safepick(free_cryopods)
// 		if(target_cryopod.check_occupant_allowed(person_to_cryo))
// 			target_cryopod.take_occupant(person_to_cryo, 1)
// 			return 1
// 	return 0