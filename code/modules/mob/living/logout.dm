/mob/living/Logout()
	if(ranged_ability && client)
		ranged_ability.remove_mousepointer(client)
	..()
	log_message("<font color='orange'>[worldtime2text()]: LOGOUT</font>", INDIVIDUAL_ATTACK_LOG)
	if(!key && mind)	//key and mind have become separated.
		mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
	if(mind && mind.active)
		player_logged = TRUE
	else
		player_logged = FALSE
