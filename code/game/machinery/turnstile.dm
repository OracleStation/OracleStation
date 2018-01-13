/obj/machinery/turnstile
	name = "turnstile"
	desc = "A remote control switch."
	icon = 'icons/obj/turnstile.dmi'
	icon_state = "turnstile_map"
	power_channel = ENVIRON
	density = TRUE
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, bio = 100, rad = 100, fire = 90, acid = 70)
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = OPEN_DOOR_LAYER

/obj/machinery/turnstile/Initialize()
	. = ..()
	icon_state = "turnstile"

/obj/machinery/turnstile/CollidedWith(atom/movable/AM)
	if(ismob(AM))
		var/mob/B = AM
		if(isliving(AM))
			var/mob/living/M = AM

			if(world.time - M.last_bumped <= 10)
				return
			M.last_bumped = world.time

			var/allowed_access = FALSE
			var/turf/behind = get_step(src, dir)

			if(AM in behind.contents)
				allowed_access = allowed(B)
			else
				to_chat(usr, "<span class='notice'>\the [src] resists your efforts.</span>")
				return

			if(allowed_access)
				var/mob/living/carbon/human/HU = AM
				if(istype(HU))
					var/obj/item/restraints/handcuffs/cable/zipties = HU.handcuffed
					if(istype(zipties))
						qdel(zipties)
						to_chat(usr, "<span class='notice'>\the [src] cuts off \the [zipties].</span>")
				flick("operate", src)
				sleep(CONFIG_GET(number/run_delay))
				AM.x = src.x
				AM.y = src.y
				playsound(src,'sound/items/ratchet.ogg',50,0,3)
				var/outdir = null
				switch(dir)
					if(NORTH)
						outdir = SOUTH
					if(SOUTH)
						outdir = NORTH
					if(EAST)
						outdir = WEST
					if(WEST)
						outdir = EAST
				var/turf/outturf = get_step(src, outdir)
				sleep(CONFIG_GET(number/run_delay))
				AM.x = outturf.x
				AM.y = outturf.y
			else
				flick("deny", src)
				playsound(src,'sound/machines/deniedbeep.ogg',50,0,3)
