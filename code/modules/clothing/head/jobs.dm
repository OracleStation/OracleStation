
//Chef
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	item_state = "chef"
	icon_state = "chef"
	desc = "The commander in chef's head wear."
	strip_delay = 10
	equip_delay_other = 10
	dynamic_hair_suffix = ""
	dog_fashion = /datum/dog_fashion/head/chef

//Captain
/obj/item/clothing/head/caphat
	name = "captain's hat"
	desc = "It's good being the king."
	icon_state = "captain"
	item_state = "that"
	flags_inv = 0
	armor = list(melee = 25, bullet = 15, laser = 25, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 50, acid = 50)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/captain

//Captain: This is no longer space-worthy
/obj/item/clothing/head/caphat/parade
	name = "captain's parade cap"
	desc = "Worn only by Captains with an abundance of class."
	icon_state = "capcap"

	dog_fashion = null


//Head of Personnel
/obj/item/clothing/head/hopcap
	name = "head of personnel's cap"
	icon_state = "hopcap"
	desc = "The symbol of true bureaucratic micromanagement."
	armor = list(melee = 25, bullet = 15, laser = 25, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 50, acid = 50)
	dog_fashion = /datum/dog_fashion/head/hop

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/cage
	name = "cage"
	desc = "A cage that restrains the will of the self, allowing one to see the profane world for what it is."
	alternate_worn_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	icon_state = "cage"
	item_state = "cage"
	worn_x_dimension = 64
	worn_y_dimension = 64
	dynamic_hair_suffix = ""
	species_restricted = list("exclude","Vox Outcast")

/obj/item/clothing/head/witchunter_hat
	name = "witchunter hat"
	desc = "This hat saw much use back in the day."
	icon_state = "witchhunterhat"
	item_state = "witchhunterhat"
	flags_cover = HEADCOVERSEYES
	species_restricted = list("exclude","Vox Outcast")

//Detective
/obj/item/clothing/head/fedora/det_hat
	name = "detective's fedora"
	desc = "There's only one man who can sniff out the dirty stench of crime, and he's likely wearing this hat."
	icon_state = "detective"
	var/candy_cooldown = 0
	pockets = /obj/item/storage/internal/pocket/small/detective
	dog_fashion = /datum/dog_fashion/head/detective

/obj/item/clothing/head/fedora/det_hat/AltClick()
	..()
	if(ismob(loc))
		var/mob/M = loc
		if(candy_cooldown < world.time)
			var/obj/item/reagent_containers/food/snacks/candy_corn/CC = new /obj/item/reagent_containers/food/snacks/candy_corn(src)
			M.put_in_hands(CC)
			to_chat(M, "You slip a candy corn from your hat.")
			candy_cooldown = world.time+1200
		else
			to_chat(M, "You just took a candy corn! You should wait a couple minutes, lest you burn through your stash.")


//Mime
/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, a mime's favorite headwear."
	icon_state = "beret"
	dog_fashion = /datum/dog_fashion/head/beret
	dynamic_hair_suffix = ""

/obj/item/clothing/head/beret/black
	name = "black beret"
	desc = "A black beret, perfect for war veterans and dark, brooding, anti-hero mimes."
	icon_state = "beretblack"

/obj/item/clothing/head/beret/highlander
	desc = "That was white fabric. <i>Was.</i>"
	flags_1 = NODROP_1
	dog_fashion = null //THIS IS FOR SLAUGHTER, NOT PUPPIES

//Security

/obj/item/clothing/head/HoS
	name = "head of security cap"
	desc = "The robust standard-issue cap of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	armor = list(melee = 40, bullet = 30, laser = 25, energy = 10, bomb = 25, bio = 10, rad = 0, fire = 50, acid = 60)
	strip_delay = 80
	dynamic_hair_suffix = ""

/obj/item/clothing/head/HoS/syndicate
	name = "syndicate cap"
	desc = "A black cap fit for a high ranking syndicate officer."

/obj/item/clothing/head/HoS/beret
	name = "head of security beret"
	desc = "A robust beret for the Head of Security, for looking stylish while not sacrificing protection."
	icon_state = "hosberetblack"

/obj/item/clothing/head/HoS/beret/syndicate
	name = "syndicate beret"
	desc = "A black beret with thick armor padding inside. Stylish and robust."

/obj/item/clothing/head/warden
	name = "warden's police hat"
	desc = "It's a special armored hat issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "policehelm"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 30, acid = 60)
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden

/obj/item/clothing/head/beret/warden
	name = "warden's beret"
	desc = "It's a special armored beret issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "beret_warden"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 30, acid = 60)
	strip_delay = 60

/obj/item/clothing/head/beret/corpwarden
	name = "corporate warden beret"
	desc = "A special black beret with a Warden's insignia in the middle. This one is commonly warn by wardens of the corporation."
	icon_state = "beret_corporate_warden"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 30, acid = 60)
	strip_delay = 60

/obj/item/clothing/head/beret/sec
	name = "security beret"
	desc = "A robust beret with the security insignia emblazoned on it. Uses reinforced fabric to offer sufficent protection."
	icon_state = "beret_badge"
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 10, bomb = 25, bio = 0, rad = 0, fire = 20, acid = 50)
	strip_delay = 60
	dog_fashion = null

/obj/item/clothing/head/beret/corpsec
	name = "corporate security beret"
	desc = "A special black beret for the mundane life of a corporate security officer."
	icon_state = "beret_corporate_officer"
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 10, bomb = 25, bio = 0, rad = 0, fire = 20, acid = 50)
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyhos
	name = "head of security's beret"
	desc = "A special beret with the Head of Security's insignia emblazoned on it. A symbol of excellence, a badge of courage, a mark of distinction."
	icon_state = "hosberet"

/obj/item/clothing/head/beret/sec/navywarden
	name = "warden's beret"
	desc = "A special beret with the Warden's insignia emblazoned on it. For wardens with class."
	icon_state = "wardenberet"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, fire = 30, acid = 50)
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "A special beret with the security insignia emblazoned on it. For officers with class."
	icon_state = "officerberet"

//Curator
/obj/item/clothing/head/fedora/curator
	name = "treasure hunter's fedora"
	desc = "You got red text today kid, but it doesn't mean you have to like it."
	icon_state = "curator"
	species_restricted = list("exclude","Vox Outcast")

/obj/item/clothing/head/beret/eng
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. For engineers that are more inclined towards style than safety."
	icon_state = "beret_engineering"
	armor = list(rad = 10, fire = 10)
	strip_delay = 60

/obj/item/clothing/head/beret/atmos
	name = "atmospherics beret"
	desc = "A beret for those who have shown immaculate proficienty in piping. Or plumbing."
	icon_state = "beret_atmospherics"
	armor = list(rad = 10, fire = 10)
	strip_delay = 60

/obj/item/clothing/head/beret/ce
	name = "chief engineer beret"
	desc = "A white beret with the engineering insignia emblazoned on it. Its owner knows what they're doing. Probably."
	icon_state = "beret_ce"
	armor = list(rad = 20, fire = 30)
	strip_delay = 60

/obj/item/clothing/head/beret/sci
	name = "science beret"
	desc = "A purple beret with the science insignia emblazoned on it. It has that authentic burning plasma smell."
	icon_state = "beret_sci"
	armor = list(bomb = 5, bio = 5, fire = 5, acid = 10)
	strip_delay = 60

//Medical
/obj/item/clothing/head/beret/med
	name = "medical beret"
	desc = "A white beret with a blue cross finely threaded into it. It has that sterile smell about it."
	icon_state = "beret_med"
	armor = list(bio = 20)
	strip_delay = 60

/obj/item/clothing/head/beret/cmo
	name = "chief medical officer beret"
	desc = "A baby blue beret with the insignia of Medistan. It smells very sterile."
	icon_state = "beret_cmo"
	armor = list(bio = 30, acid = 20)
	strip_delay = 60

//Centcomm
/obj/item/clothing/head/beret/cccaptain
	name = "central command captain beret"
	desc = "A pure white beret with a Captain insignia of Central Command."
	icon_state = "beret_centcom_captain"
	armor = list(melee = 80, bullet = 80, laser = 80, energy = 80, bomb = 80, bio = 80, rad = 80, fire = 80, acid = 80)
	strip_delay = 120

/obj/item/clothing/head/beret/ccofficer
	name = "central command officer beret"
	desc = "A black Central Command Officer beret with matching insignia."
	icon_state = "beret_centcom_officer"
	armor = list(melee = 80, bullet = 80, laser = 80, energy = 80, bomb = 80, bio = 80, rad = 80, fire = 80, acid = 80)
	strip_delay = 120

/obj/item/clothing/head/beret/ccofficernavy
	name = "central command naval officer beret"
	desc = "A Navy beret commonly worn by Central Command Naval Officers."
	icon_state = "beret_centcom_officer_navy"
	armor = list(melee = 80, bullet = 80, laser = 80, energy = 80, bomb = 80, bio = 80, rad = 80, fire = 80, acid = 80)
	strip_delay = 120

/obj/item/clothing/head/beret/blueshield
	name = "officer beret"
	desc = "A black Blueshield beret."
	icon_state = "beret_centcom_officer"
	armor = list(melee = 40, bullet = 20, laser = 10, energy = 10, bomb = 10, bio = 5, rad = 5, fire = 5, acid = 30)
	strip_delay = 60

/obj/item/clothing/head/beret/blueshieldnavy
	name = "navy officer beret"
	desc = "A navy Blueshield beret."
	icon_state = "beret_centcom_officer_navy"
	armor = list(melee = 40, bullet = 20, laser = 10, energy = 10, bomb = 10, bio = 5, rad = 5, fire = 5, acid = 30)
	strip_delay = 60

/obj/item/clothing/head/beret/captain
	name = "captain beret"
	desc = "A lovely blue Captain beret with a gold and white insignia."
	icon_state = "beret_captain"
	armor = list(melee = 50, bullet = 30, laser = 20, energy = 10, bomb = 15, bio = 10, rad = 10, fire = 10, acid = 60)
	strip_delay = 90