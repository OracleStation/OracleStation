// Banana
/obj/item/seeds/banana
	name = "pack of banana seeds"
	desc = "They're seeds that grow into banana trees. When grown, keep away from clown."
	icon_state = "seed-banana"
	species = "banana"
	plantname = "Banana Tree"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/banana
	lifespan = 50
	endurance = 30
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "banana-dead"
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list("banana" = 0.1, "potassium" = 0.1, "vitamin" = 0.04, "nutriment" = 0.02)

/obj/item/weapon/reagent_containers/food/snacks/grown/banana
	seed = /obj/item/seeds/banana
	name = "banana"
	desc = "It's an excellent prop for a clown."
	icon_state = "banana"
	item_state = "banana"
	trash = /obj/item/weapon/grown/bananapeel
	filling_color = "#FFFF00"
	bitesize = 5
	foodtype = FRUIT

/obj/item/weapon/reagent_containers/food/snacks/grown/banana/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is aiming [src] at [user.p_them()]self! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/items/bikehorn.ogg', 50, 1, -1)
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.say("BANG!")
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.visible_message("<B>[user]</B> laughs so hard they begin to suffocate!")
	return (OXYLOSS)

/obj/item/weapon/grown/bananapeel
	seed = /obj/item/seeds/banana
	name = "banana peel"
	desc = "A peel from a banana."
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/grown/bananapeel/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is deliberately slipping on [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/misc/slip.ogg', 50, 1, -1)
	return (BRUTELOSS)

// Other
/obj/item/weapon/grown/bananapeel/specialpeel     //used by /obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "synthesized banana peel"
	desc = "A synthetic banana peel."

/obj/item/weapon/grown/bananapeel/specialpeel/Crossed(AM)
	if(iscarbon(AM))
		var/mob/living/carbon/carbon = AM
		if(carbon.slip(40, src, FALSE))
			qdel(src)
