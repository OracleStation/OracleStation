/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control of this locker until the lock is removed."
	name = "personal closet"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/examine(mob/user)
	..()
	if(registered_name)
		to_chat(user, "<span class='notice'>The display reads, \"Owned by [registered_name]\".</span>")

/obj/structure/closet/secure_closet/personal/check_access(obj/item/card/id/I)
	. = ..()
	if(!I || !istype(I))
		return
	if(registered_name == I.registered_name)
		return TRUE

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(40))
		new /obj/item/storage/backpack/duffelbag(src)
	if(prob(40))
		new /obj/item/storage/backpack(src)
	if(prob(40))
		new /obj/item/storage/backpack/messenger(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/device/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70

/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet(src)
	new /obj/item/device/instrument/piano_synth(src)
	new /obj/item/device/radio/headset(src)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/user, params)
	var/obj/item/card/id/I = W.GetID()
	if(!I || !istype(I))
		return ..()
	if(!can_lock(user, FALSE)) //Can't do anything if there isn't a lock!
		return
	if(!I.registered_name)
		return ..()
	else if(!registered_name)
		to_chat(user, "<span class='notice'>You claim [src].</span>")
	else if(registered_name == I.registered_name)
		togglelock(user)
		registered_name = I.registered_name
	else
		return ..()

/obj/structure/closet/secure_closet/personal/handle_lock_addition() //If lock construction is successful we don't care what access the electronics had, so we override it
	if(..())
		req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
		lockerelectronics.accesses = req_access

/obj/structure/closet/secure_closet/personal/handle_lock_removal()
	if(..())
		registered_name = null
