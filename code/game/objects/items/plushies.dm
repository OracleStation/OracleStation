/obj/item/toy/plush
	name = "plush"
	desc = "this is the special coder plush, do not steal"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "debug"
	attack_verb = list("thumped", "whomped", "bumped")
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	var/list/squeak_override //Weighted list; If you want your plush to have different squeak sounds use this

/obj/item/toy/plush/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, squeak_override)

/obj/item/toy/plush/attack_self(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>You pet [src]. D'awww.</span>")

/obj/item/toy/plush/carpplushie
	name = "space carp plushie"
	desc = "An adorable stuffed toy that resembles a space carp."
	icon_state = "carpplush"
	item_state = "carp_plushie"
	attack_verb = list("bitten", "eaten", "fin slapped")
	squeak_override = list('sound/weapons/bite.ogg'=1)

/obj/item/toy/plush/bubbleplush
	name = "bubblegum plushie"
	desc = "The friendly red demon that gives good miners gifts."
	icon_state = "bubbleplush"
	attack_verb = list("rends")
	squeak_override = list('sound/magic/demon_attack1.ogg'=1)

/obj/item/toy/plush/plushvar
	name = "ratvar plushie"
	desc = "An adorable plushie of the clockwork justiciar himself with new and improved spring arm action."
	icon_state = "plushvar"

/obj/item/toy/plush/narplush
	name = "nar'sie plushie"
	desc = "A small stuffed doll of the elder god Nar'Sie. Who thought this was a good children's toy?"
	icon_state = "narplush"

/obj/item/toy/plush/red_fox
	name = "red fox plushie"
	icon_state = "redfox"

/obj/item/toy/plush/black_fox
	name = "black fox plushie"
	icon_state = "blackfox"

/obj/item/toy/plush/marble_fox
	name = "marble fox plushie"
	icon_state = "marblefox"

/obj/item/toy/plush/blue_fox
	name = "blue fox plushie"
	icon_state = "bluefox"

/obj/item/toy/plush/orange_fox
	name = "orange fox plushie"
	icon_state = "orangefox"

/obj/item/toy/plush/coffee_fox
	name = "coffee fox plushie"
	icon_state = "coffeefox"

/obj/item/toy/plush/pink_fox
	name = "pink fox plushie"
	icon_state = "pinkfox"

/obj/item/toy/plush/purple_fox
	name = "purple fox plushie"
	icon_state = "purplefox"

/obj/item/toy/plush/crimson_fox
	name = "crimson fox plushie"
	icon_state = "crimsonfox"

/obj/item/toy/plush/deer
	name = "deer plushie"
	icon_state = "deer"

/obj/item/toy/plush/black_cat
	name = "black cat plushie"
	icon_state = "blackcat"

/obj/item/toy/plush/grey_cat
	name = "grey cat plushie"
	icon_state = "greycat"

/obj/item/toy/plush/white_cat
	name = "white cat plushie"
	icon_state = "whitecat"

/obj/item/toy/plush/orange_cat
	name = "orange cat plushie"
	icon_state = "orangecat"

/obj/item/toy/plush/siamese_cat
	name = "siamese cat plushie"
	icon_state = "siamesecat"

/obj/item/toy/plush/tabby_cat
	name = "tabby cat plushie"
	icon_state = "tabbycat"

/obj/item/toy/plush/tuxedo_cat
	name = "tuxedo cat plushie"
	icon_state = "tuxedocat"

/obj/item/toy/plush/corgi
	name = "corgi plushie"
	icon_state = "corgi"

/obj/item/toy/plush/girly_corgi
	name = "corgi plushie"
	icon_state = "girlycorgi"

/obj/item/toy/plush/robo_corgi
	name = "borgi plushie"
	icon_state = "robotcorgi"

/obj/item/toy/plush/octopus
	name = "octopus plushie"
	icon_state = "loveable"

/obj/item/toy/plush/face_hugger
	name = "facehugger plushie"
	icon_state = "huggable"

/obj/item/toy/plush/carpplushie/ice
	icon_state = "icecarp"

/obj/item/toy/plush/carpplushie/silent
	icon_state = "silentcarp"

/obj/item/toy/plush/carpplushie/electric
	icon_state = "electriccarp"

/obj/item/toy/plush/carpplushie/gold
	icon_state = "goldcarp"

/obj/item/toy/plush/carpplushie/toxin
	icon_state = "toxincarp"

/obj/item/toy/plush/carpplushie/dragon
	icon_state = "dragoncarp"

/obj/item/toy/plush/carpplushie/pink
	icon_state = "pinkcarp"

/obj/item/toy/plush/carpplushie/candy
	icon_state = "candycarp"

/obj/item/toy/plush/carpplushie/nebula
	icon_state = "nebulacarp"

/obj/item/toy/plush/carpplushie/void
	icon_state = "voidcarp"

/obj/random_plushie/Initialize()
	. = ..()
	var/obj/to_spawn = pick(subtypesof(/obj/item/toy/plush))
	new to_spawn(loc)
	return INITIALIZE_HINT_QDEL

/obj/random_carp_plushie/Initialize()
	. = ..()
	var/obj/to_spawn = pick(subtypesof(/obj/item/toy/plush/carpplushie) - /obj/item/toy/plush/carpplushie/dehy_carp)
	new to_spawn(loc)
	return INITIALIZE_HINT_QDEL
