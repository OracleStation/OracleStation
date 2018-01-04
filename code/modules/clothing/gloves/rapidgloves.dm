/obj/item/clothing/gloves/fingerless/rapid
	name = "Gloves of the north star"
	desc = "Speeds up the wearer's punches to blinding speeds. Omae wa mou shindeiru."

/obj/item/clothing/gloves/fingerless/rapid/Touch(mob/living/target,proximity = TRUE)
	var/mob/living/M = loc

	if(M.a_intent == INTENT_HARM)
		M.changeNext_move(CLICK_CD_RAPID)
	.= FALSE