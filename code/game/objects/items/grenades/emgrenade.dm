/obj/item/grenade/empgrenade
	name = "classic EMP grenade"
	desc = "It is designed to wreak havoc on electronic systems."
	icon_state = "emp"
	item_state = "emp"
	arming_sound = 'sound/weapons/armbomb.ogg'
	origin_tech = "magnets=3;combat=2"

/obj/item/grenade/empgrenade/prime()
	update_mob()
	empulse(src, 4, 10)
	qdel(src)
