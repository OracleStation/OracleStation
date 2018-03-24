/obj/item/clothing/shoes/clown
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	item_color = "clown"
	pockets = /obj/item/storage/internal/pocket/shoes/clown
	species_restricted = null

/obj/item/clothing/shoes/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50)

/obj/item/clothing/shoes/clown/sneakers
	name = "clown sneakers"
	icon_state = "clown_sneakers"
	item_state = "clown"
	item_color = "clown_sneakers"

/obj/item/clothing/shoes/clown/black
	name = "clown boots"
	icon_state = "clown_black"
	item_state = "clown"
	item_color = "clown_black"
