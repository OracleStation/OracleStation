/datum/emote/silicon
	mob_type_allowed_typecache = list(/mob/living/silicon)
	emote_type = EMOTE_AUDIBLE
	robotic_emote = TRUE

/datum/emote/sound/silicon
	mob_type_allowed_typecache = list(/mob/living/silicon)
	emote_type = EMOTE_AUDIBLE
	robotic_emote = TRUE

/datum/emote/silicon/boop
	key = "boop"
	key_third_person = "boops"
	message = "boops."

/datum/emote/sound/silicon/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'

/datum/emote/sound/silicon/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs."
	sound = 'sound/effects/mob_effects/machine_cough.ogg'

/datum/emote/sound/silicon/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes!"
	sound = 'sound/effects/mob_effects/machine_sneeze.ogg'

/datum/emote/sound/silicon/buzz
	key = "buzz"
	key_third_person = "buzzes"
	message = "buzzes."
	message_param = "buzzes at %t."
	sound = 'sound/machines/buzz-sigh.ogg'

/datum/emote/sound/silicon/buzz2
	key = "buzz2"
	message = "buzzes twice."
	sound = 'sound/machines/buzz-two.ogg'

/datum/emote/sound/silicon/chime
	key = "chime"
	key_third_person = "chimes"
	message = "chimes."
	sound = 'sound/machines/chime.ogg'

/datum/emote/sound/silicon/honk
	key = "honk"
	key_third_person = "honks"
	message = "honks."
	vary = TRUE
	sound = 'sound/items/bikehorn.ogg'

/datum/emote/sound/silicon/ping
	key = "ping"
	key_third_person = "pings"
	message = "pings."
	message_param = "pings at %t."
	sound = 'sound/machines/ping.ogg'

/datum/emote/sound/silicon/sad
	key = "sad"
	message = "plays a sad trombone..."
	sound = 'sound/misc/sadtrombone.ogg'

/datum/emote/sound/silicon/warn
	key = "warn"
	message = "blares an alarm!"
	sound = 'sound/machines/warning-buzzer.ogg'
	cooldown = 100

/mob/living/silicon/robot/verb/powerwarn()
	set category = "Robot Commands"
	set name = "Power Warning"

	if(stat == CONSCIOUS)
		if(!cell || !cell.charge)
			visible_message("The power warning light on <span class='name'>[src]</span> flashes urgently.",\
							"You announce you are operating in low power mode.")
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
		else
			to_chat(src, "<span class='warning'>You can only use this emote when you're out of charge.</span>")

/datum/emote/sound/silicon/yes
	key = "yes"
	message = "blips affirmatively."
	sound = 'sound/effects/mob_effects/synth_yes.ogg'

/datum/emote/sound/silicon/no
	key = "no"
	message = "buzzes negatively."
	sound = 'sound/effects/mob_effects/synth_no.ogg'
