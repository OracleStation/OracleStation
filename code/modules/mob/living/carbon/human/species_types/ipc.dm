/datum/species/ipc
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 3 // Went cheap with Aircooling
	coldmod = 1.5 // Don't put your computer in the freezer.
	burnmod = 2 // Wiring doesn't hold up to fire well.
	brutemod = 1.8 // Thin metal, cheap materials.
	toxmod = 0.5 // Although they can't be poisoned, toxins can damage components
	clonemod = 0
	siemens_coeff = 1.5 // Overload!
	species_traits = list(NOBREATH, NOBLOOD, RADIMMUNE, VIRUSIMMUNE, NOZOMBIE, EASYDISMEMBER, EASYLIMBATTACHMENT, NOPAIN, NO_BONES, NOTRANSSTING, MUTCOLORS, REVIVESBYHEALING, NOSCAN, NOCHANGELING, NOHUSK)
	mutant_organs = list(/obj/item/organ/cyberimp/arm/power_cord/)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None", "ipc_chassis" = "Morpheus Cyberkinetics(Greyscale)")
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/metal{amount = 10}
	male_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	female_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	male_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	female_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	male_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	toxic_food = ALL
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc
	mutantstomach = /obj/item/organ/stomach/cell
	mutantears = /obj/item/organ/ears/robot
	mutant_brain = /obj/item/organ/brain/mmi_holder/posibrain
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"
	reagent_tag = PROCESS_SYNTHETIC
	species_gibs = "robotic"
	attack_sound = 'sound/items/trayhit1.ogg'
	allow_numbers_in_name = TRUE
	var/datum/action/innate/change_screen/change_screen

/datum/species/ipc/random_name(unique)
	var/ipc_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return ipc_name

/datum/species/ipc/on_species_gain(mob/living/carbon/C) // Let's make that IPC actually robotic.
	. = ..()
	var/obj/item/organ/appendix/appendix = C.getorganslot("appendix") // Easiest way to remove it.
	appendix.Remove(C)
	QDEL_NULL(appendix)
	if(ishuman(C) && !change_screen)
		change_screen = new
		change_screen.Grant(C)
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ROBOTIC) // Makes all Bodyparts robotic.
		O.render_like_organic = TRUE // Makes limbs render like organic limbs instead of augmented limbs, check bodyparts.dm
		var/chassis = C.dna.features["ipc_chassis"]
		var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.ipc_chassis_list[chassis]
		C.dna.species.limbs_id = chassis_of_choice.limbs_id
		if(chassis_of_choice.color_src == MUTCOLORS && !(MUTCOLORS in C.dna.species.species_traits)) // If it's a colorable(Greyscale) chassis, we use MUTCOLORS.
			C.dna.species.species_traits += MUTCOLORS
		else if(MUTCOLORS in C.dna.species.species_traits)
			C.dna.species.species_traits -= MUTCOLORS

datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	if(change_screen)
		change_screen.Remove(C)

/datum/species/ipc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/machine)

/datum/species/ipc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id in list("plasma", "stable_plasma")) // IPCs have plasma batteries.
		H.nutrition += 5
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/action/innate/change_screen
	name = "Change Display"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "ipc_screen"

/datum/action/innate/change_screen/Activate()
	var/choice = input(usr, "Which screen do you want to use?", "Screen Change") as null | anything in GLOB.ipc_screens_list
	if(!choice)
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.dna.features["ipc_screen"] = choice
	H.update_body()

/obj/item/apc_powercord
	name = "power cord"
	desc = "An internal power cord hooked up to a battery. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

/obj/item/apc_powercord/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!istype(target, /obj/machinery/power/apc) || !ishuman(user) || !proximity_flag)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/obj/machinery/power/apc/A = target
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/stomach/cell/cell = H.internal_organs_slot["stomach"]
	if(!cell)
		to_chat(H, "<span class='warning'>You try to siphon energy from [A], but your powercell is gone!</span>")
		return
	if(A.emagged || A.stat & BROKEN)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, A)
		s.start()
		to_chat(H, "<span class='warning'>The APC power currents surge erratically, damaging your chassis!</span>")
		H.adjustFireLoss(10)
	else if(A.cell && A.cell.charge > 0)
		if(H.nutrition >= NUTRITION_LEVEL_WELL_FED)
			to_chat(user, "<span class='warning'>You are already fully charged!</span>")
		else
			powerdraw_loop(A, H)
	else
		to_chat(user, "<span class='warning'>There is no charge to draw from that APC.</span>")

/obj/item/apc_powercord/proc/powerdraw_loop(obj/machinery/power/apc/A, mob/living/carbon/human/H)
	H.visible_message("<span class='notice'>[H] inserts a power connector into \the [A].</span>", "<span class='notice'>You begin to draw power from \the [A].</span>")
	while(do_after(H, 10, target = A))
		if(loc != H)
			to_chat(H, "<span class='warning'>You must keep your connector out while charging!</span>")
			break
		if(A.cell.charge == 0)
			to_chat(H, "<span class='warning'>\The [A] has no more charge.</span>")
			break
		A.charging = 1
		if(A.cell.charge >= 250)
			H.nutrition += 50
			A.cell.charge -= 250
			to_chat(H, "<span class='notice'>You siphon off some of the stored charge for your own use.</span>")
		else
			H.nutrition += A.cell.charge/10
			A.cell.charge = 0
			to_chat(H, "<span class='notice'>You siphon off the last of \the [A]'s charge.</span>")
			break
		if(H.nutrition > NUTRITION_LEVEL_WELL_FED)
			to_chat(H, "<span class='notice'>You are now fully charged.</span>")
			break
	H.visible_message("<span class='notice'>[H] unplugs from \the [A].</span>", "<span class='notice'>You unplug from \the [A].</span>")