// Pumpkin
/obj/item/seeds/pumpkin
	name = "pack of pumpkin seeds"
	desc = "These seeds grow into pumpkin vines."
	icon_state = "seed-pumpkin"
	species = "pumpkin"
	plantname = "Pumpkin Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/pumpkin
	lifespan = 50
	endurance = 40
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "pumpkin-grow"
	icon_dead = "pumpkin-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/pumpkin/blumpkin)
	reagents_add = list("vitamin" = 0.04, "nutriment" = 0.2)

/obj/item/reagent_containers/food/snacks/grown/pumpkin
	seed = /obj/item/seeds/pumpkin
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	filling_color = "#FFA500"
	bitesize_mod = 2
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.is_sharp())
		user.show_message("<span class='notice'>You carve a face into [src]!</span>", 1)
		new /obj/item/clothing/head/hardhat/pumpkinhead(user.loc)
		qdel(src)
		return
	else
		return ..()

// Blumpkin
/obj/item/seeds/pumpkin/blumpkin
	name = "pack of plasma-pumpkin seeds"
	desc = "These seeds grow into plasma-pumpkin vines."
	icon_state = "seed-blumpkin"
	species = "blumpkin"
	plantname = "Plasma-pumpkin Vines"
	product = /obj/item/reagent_containers/food/snacks/grown/blumpkin
	mutatelist = list()
	reagents_add = list("ammonia" = 0.1, "chlorine" = 0.1, "nutriment" = 0.2, stable_plasma = 0.1)
	rarity = 20

/obj/item/reagent_containers/food/snacks/grown/blumpkin
	seed = /obj/item/seeds/pumpkin/blumpkin
	name = "plasma-pumpkin"
	desc = "A mutation of the common pumpkin containing toxic chemicals. Should not be eaten."
	icon_state = "blumpkin"
	filling_color = "#87CEFA"
	bitesize_mod = 2
	foodtype = VEGETABLES
