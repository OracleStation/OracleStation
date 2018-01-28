/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/nanopaste.dmi'
	icon_state = "tube"
	origin_tech = "materials=2;engineering=3"
	amount = 10
	toolspeed = 1

/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob)
	if(!istype(M) || !istype(user))
		return 0
	if(istype(M,/mob/living/silicon/robot))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if(R.getBruteLoss() || R.getFireLoss() )
			R.adjustBruteLoss(-15)
			R.adjustFireLoss(-15)
			R.updatehealth()
			use(1)
			user.visible_message("<span class='notice'>\The [user] applied some [src] at [R]'s damaged areas.</span>",\
				"<span class='notice'>You apply some [src] at [R]'s damaged areas.</span>")
		else
			to_chat(user, "<span class='notice'>All [R]'s systems are nominal.</span>")

	if(istype(M,/mob/living/carbon/human))		//Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/BP = H.get_bodypart(user.zone_selected)

		if(BP && (BP.status & BODYPART_ROBOTIC) || (BP.status & ORGAN_ROBOTIC))
			if(BP.get_damage())
				BP.heal_damage(15, 15, robo_repair = 1)
				H.updatehealth()
				use(1)
				user.visible_message("<span class='notice'>\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " \the"][BP.name] with \the [src].</span>",\
				"<span class='notice'>You apply some nanite paste at [user == M ? "your" : "[M]'s"] [BP.name].</span>")
			else
				to_chat(user, "<span class='notice'>Nothing to fix here.</span>")
		else
			to_chat(user, "<span class='notice'>[src] won't work on that.</span>")
