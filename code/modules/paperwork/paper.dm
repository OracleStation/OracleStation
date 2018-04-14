/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */

/obj/item/paper
	name = "paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	pressure_resistance = 0
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	resistance_flags = FLAMMABLE
	max_integrity = 50
	dog_fashion = /datum/dog_fashion/head

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped
	var/rigged = 0
	var/spam_flag = 0
	var/contact_poison // Reagent ID to transfer on contact
	var/contact_poison_volume = 0
	var/datum/oracle_ui/ui = null

/obj/item/paper/pickup(user)
	if(contact_poison && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(!istype(G) || G.transfer_prints)
			H.reagents.add_reagent(contact_poison,contact_poison_volume)
			contact_poison = null
	ui.check_view_all()
	..()

/obj/item/paper/dropped(mob/user)
	ui.check_view(user)
	return ..()

/obj/item/paper/Initialize()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	ui = new /datum/oracle_ui(src, 420, 600, get_asset_datum(/datum/asset/simple/paper))
	ui.can_resize = FALSE
	update_icon()
	updateinfolinks()

/obj/item/paper/oui_getcontent(mob/target)
	if(!target.is_literate())
		return "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[stars(info)]<HR>[stamps]</BODY></HTML>"
	else if(istype(target.get_active_held_item(), /obj/item/pen) | istype(target.get_active_held_item(), /obj/item/toy/crayon))
		return "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info_links]<HR>[stamps]</BODY></HTML>"
	else
		return "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info]<HR>[stamps]</BODY></HTML>"

/obj/item/paper/oui_canview(mob/target)
	if(check_rights_for(target.client, R_FUN)) //Allows admins to view faxes
		return TRUE
	if(isAI(target))
		var/mob/living/silicon/ai/ai = target
		return get_dist(src, ai.current) < 2
	if(iscyborg(target))
		return get_dist(src, target) < 2
	return ..()

/obj/item/paper/update_icon()

	if(resistance_flags & ON_FIRE)
		icon_state = "paper_onfire"
		return
	if(info)
		icon_state = "paper_words"
		return
	icon_state = "paper"


/obj/item/paper/examine(mob/user)
	..()

	if(istype(src, /obj/item/paper/talisman)) //Talismans cannot be read
		if(!iscultist(user) && !user.stat)
			to_chat(user, "<span class='danger'>There are indecipherable images scrawled on the paper in what looks to be... <i>blood?</i></span>")
			return
	if(oui_canview(user))
		ui.render(user)
	else
		to_chat(user, "<span class='notice'>It is too far away.</span>")

/obj/item/paper/proc/show_content(var/mob/user)
	user.examinate(src)

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if(usr.incapacitated() || !usr.is_literate())
		return
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.disabilities & CLUMSY && prob(25))
			to_chat(H, "<span class='warning'>You cut yourself on the paper! Ahhhh! Ahhhhh!</span>")
			H.damageoverlaytemp = 9001
			H.update_damage_hud()
			return
	var/n_name = stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN)
	if((loc == usr && usr.stat == 0))
		name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(usr)
	ui.render_all()

/obj/item/paper/attack_self(mob/user)
	show_content(user)

/obj/item/paper/attack_ai(mob/living/silicon/ai/user)
	show_content(user)

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(1)	//I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i in 1 to min(fields, 15))
		addtofield(i, "<font face=\"[PEN_FONT]\"><A href='?src=[REF(src)];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[PEN_FONT]\"><A href='?src=[REF(src)];write=end'>write</A></font>"
	ui.render_all()

/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	LAZYCLEARLIST(stamped)
	cut_overlays()
	updateinfolinks()
	update_icon()


/obj/item/paper/proc/parsepencode(t, obj/item/pen/P, mob/user, iscrayon = 0)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

//	t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)

	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[sign\]", "<font face=\"[SIGNFONT]\"><i>[user.real_name]</i></font>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\[tab\]", "&nbsp;&nbsp;&nbsp;&nbsp;")

	if(!iscrayon)
		t = replacetext(t, "\[*\]", "<li>")
		t = replacetext(t, "\[hr\]", "<HR>")
		t = replacetext(t, "\[small\]", "<font size = \"1\">")
		t = replacetext(t, "\[/small\]", "</font>")
		t = replacetext(t, "\[list\]", "<ul>")
		t = replacetext(t, "\[/list\]", "</ul>")

		t = "<font face=\"[P.font]\" color=[P.colour]>[t]</font>"
	else // If it is a crayon, and he still tries to use these, make them empty!
		var/obj/item/toy/crayon/C = P
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")

		t = "<font face=\"[CRAYON_FONT]\" color=[C.paint_color]><b>[t]</b></font>"

//	t = replacetext(t, "#", "") // Junk converted to nothing!

//Count the fields
	var/laststart = 1
	while(1)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++

	return t

/obj/item/paper/proc/reload_fields() // Useful if you made the paper programicly and want to include fields. Also runs updateinfolinks() for you.
	fields = 0
	var/laststart = 1
	while(1)
		var/i = findtext(info, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++
	updateinfolinks()


/obj/item/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><TITLE>Paper Help</TITLE></HEAD>
	<BODY>
		<b><center>Crayon&Pen commands</center></b><br>
		<br>
		\[br\] : Creates a linebreak.<br>
		\[center\] - \[/center\] : Centers the text.<br>
		\[b\] - \[/b\] : Makes the text <b>bold</b>.<br>
		\[i\] - \[/i\] : Makes the text <i>italic</i>.<br>
		\[u\] - \[/u\] : Makes the text <u>underlined</u>.<br>
		\[large\] - \[/large\] : Increases the <font size = \"4\">size</font> of the text.<br>
		\[sign\] : Inserts a signature of your name in a foolproof way.<br>
		\[field\] : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
		<br>
		<b><center>Pen exclusive commands</center></b><br>
		\[small\] - \[/small\] : Decreases the <font size = \"1\">size</font> of the text.<br>
		\[list\] - \[/list\] : A list.<br>
		\[*\] : A dot used for lists.<br>
		\[hr\] : Adds a horizontal rule.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/paper/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return

	if(href_list["help"])
		openhelp(usr)
		return
	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  stripped_multiline_input("Enter what you want to write:", "Write", no_trim=TRUE)
		if(!t)
			return
		var/obj/item/i = usr.get_active_held_item()	//Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0
		if(!istype(i, /obj/item/pen))
			if(!istype(i, /obj/item/toy/crayon))
				return
			iscrayon = 1

		if(!in_range(src, usr) && loc != usr && !istype(loc, /obj/item/clipboard) && loc.loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return

		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html

		if(t != null)	//No input from the user means nothing needs to be added
			if(id!="end")
				addtofield(text2num(id), t) // He wants to edit a field, let him.
				ui.render(usr)
			else
				info += t // Oh, he wants to edit to the end of the file, let him.
				updateinfolinks()

			update_icon()


/obj/item/paper/attackby(obj/item/P, mob/living/carbon/human/user, params)
	..()

	if(resistance_flags & ON_FIRE)
		return

	if(is_blind(user))
		return

	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		if(user.is_literate())
			user.examinate(src)
			return
		else
			to_chat(user, "<span class='notice'>You don't know how to read or write.</span>")
			return
		if(istype(src, /obj/item/paper/talisman/))
			to_chat(user, "<span class='warning'>[P]'s ink fades away shortly after it is written.</span>")
			return

	else if(istype(P, /obj/item/stamp))

		if(!in_range(src, user))
			return

		stamps += "<img src=large_[P.icon_state].png>"
		var/mutable_appearance/stampoverlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_[P.icon_state]")
		stampoverlay.pixel_x = rand(-2, 2)
		stampoverlay.pixel_y = rand(-3, 2)

		LAZYADD(stamped, P.icon_state)
		add_overlay(stampoverlay)

		to_chat(user, "<span class='notice'>You stamp the paper with your rubber stamp.</span>")
		ui.render_all()

	if(P.is_hot())
		if(user.disabilities & CLUMSY && prob(10))
			user.visible_message("<span class='warning'>[user] accidentally ignites themselves!</span>", \
								"<span class='userdanger'>You miss the paper and accidentally light yourself on fire!</span>")
			user.dropItemToGround(P)
			user.adjust_fire_stacks(1)
			user.IgniteMob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return

		user.dropItemToGround(src)
		user.visible_message("<span class='danger'>[user] lights [src] ablaze with [P]!</span>", "<span class='danger'>You light [src] on fire!</span>")
		fire_act()


	add_fingerprint(user)

/obj/item/paper/fire_act(exposed_temperature, exposed_volume)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		icon_state = "paper_onfire"
		info = "[stars(info)]"


/obj/item/paper/extinguish()
	..()
	update_icon()

/*
 * Construction paper
 */

/obj/item/paper/construction

/obj/item/paper/construction/Initialize()
	. = ..()
	color = pick("FF0000", "#33cc33", "#ffb366", "#551A8B", "#ff80d5", "#4d94ff")

/*
 * Natural paper
 */

/obj/item/paper/natural/Initialize()
	. = ..()
	color = "#FFF5ED"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"
	slot_flags = null

/obj/item/paper/crumpled/update_icon()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/evilfax
	name = "Centcomm Reply"
	info = ""
	var/mytarget = null
	var/myeffect = null
	var/used = FALSE
	var/countdown = 60
	var/activate_on_timeout = FALSE

/obj/item/paper/evilfax/show_content(var/mob/user, var/forceshow = FALSE, var/forcestars = FALSE, var/infolinks = FALSE, var/view = TRUE)
	if(user == mytarget)
		if(istype(user, /mob/living/carbon))
			var/mob/living/carbon/C = user
			evilpaper_specialaction(C)
			..()
		else
			// This should never happen, but just in case someone is adminbussing
			evilpaper_selfdestruct()
	else
		if(mytarget)
			to_chat(user,"<span class='notice'>This page appears to be covered in some sort of bizzare code. The only bit you recognize is the name of [mytarget]. Perhaps [mytarget] can make sense of it?</span>")
		else
			evilpaper_selfdestruct()


/obj/item/paper/evilfax/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)


/obj/item/paper/evilfax/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(mytarget && !used)
		var/mob/living/carbon/target = mytarget
		target.ForceContractDisease(new /datum/disease/transformation/corgi(0))
	return ..()


/obj/item/paper/evilfax/process()
	if(!countdown)
		if(mytarget)
			if(activate_on_timeout)
				evilpaper_specialaction(mytarget)
			else
				message_admins("[mytarget] ignored an evil fax until it timed out.")
		else
			message_admins("Evil paper '[src]' timed out, after not being assigned a target.")
		used = TRUE
		evilpaper_selfdestruct()
	else
		countdown--

/obj/item/paper/evilfax/proc/evilpaper_specialaction(target)
	addtimer(CALLBACK(src, .proc/handle_specialaction, target), 30)

/obj/item/paper/evilfax/proc/handle_specialaction(var/mob/living/carbon/target)
	if(istype(target,/mob/living/carbon))
		if(myeffect == "Borgification")
			to_chat(target,"<span class='userdanger'>You seem to comprehend the AI a little better. Why are your muscles so stiff?</span>")
			target.ForceContractDisease(new /datum/disease/transformation/robot(0))
		else if(myeffect == "Corgification")
			to_chat(target,"<span class='userdanger'>You hear distant howling as the world seems to grow bigger around you. Boy, that itch sure is getting worse!</span>")
			target.ForceContractDisease(new /datum/disease/transformation/corgi(0))
		else if(myeffect == "Death By Fire")
			to_chat(target,"<span class='userdanger'>You feel hotter than usual. Maybe you should lowe-wait, is that your hand melting?</span>")
			var/turf/open/fire_spot = get_turf(target)
			new /obj/effect/hotspot(fire_spot)
			target.adjustFireLoss(150) // hard crit, the burning takes care of the rest.
		else if(myeffect == "Demotion Notice")
			priority_announce("[mytarget] is hereby demoted to the rank of Assistant. Process this demotion immediately. Failure to comply with these orders is grounds for termination.","CC Demotion Order")
		else
			message_admins("Evil paper [src] was activated without a proper effect set! This is a bug.")
	used = TRUE
	evilpaper_selfdestruct()

/obj/item/paper/evilfax/proc/evilpaper_selfdestruct()
	visible_message("<span class='danger'>[src] spontaneously catches fire, and burns up!</span>")
	qdel(src)

/obj/item/paper/telecomms
	name = "Telecommunications Manual"
	info = "<b>Congratulations On Your Purchase Of An NT-07 Telecommunications System!</b><br>\
	WARNING: Should this machinery become destroyed or non-functional, please contact Central Command Tech Support.<br>\
	INFO: This machinery is very susceptible to ionspheric interference. Should an ionspheric anomaly occur, the machinery may be offline for a brief period of time.<br>\
	<br>\
	List of authorised channels and corresponding frequencies:<br>\
	<li>Science: 135.1</li>\
	<li>Medical: 135.5</li>\
	<li>Supply: 134.7</li>\
	<li>Service: 134.9</li>\
	<li>Command: 135.3</li>\
	<li>Security: 135.9</li>\
	<li>Engineering: 135.7</li>\
	<li>Common: 145.7</li><br>\
	<br>\
	The Topology:<br>\
	This topology is split into aisles, each aisle having 1 bus and 1 CPU responsible for 2 channels, each with their own servers. The channel specific servers are marked with floor tiles similar to each channel identifier.<br>\
	<br>\
	Telecommunication Machinery Functionality<br>\
	All machines share similar features, such as networks and filtering frequencies, but each machine has a very specific role<br>\
	Servers:<br>\
	Servers store a data packet every time audio is sent down a corresponding channel, this data can be viewed with a Telecomms Server Monitor. Servers can also be used for scripting, but sadly this is no longer supported.<br>\
	<br>\
	Hubs:<br>\
	Hubs are the 'Hub' of the setup, quite literally. All the machine except processors (see below) link to this, including distant ones such as relays (See below).<br>\
	<br>\
	Processors:<br>\
	Processors are an essential part of a telecomms setup if you want to be able to understand anything. They take an encoded signal and decode it into standard audio which is sent off to the broadcasters (See below). These link to the bus mainframes.<br>\
	<br>\
	Bus Mainframes<br>\
	Bus Mainframes play a similar role to hubs. Networks without hubs will use a Bus Mainframe as a hub, as they can do local machinery but not relays. The bus links to all machines that cover the channels it manages. So to the hub, the processor and the server.<br>\
	<br>\
	Receiver:<br>\
	Receivers are what they say on the tin, they receive subspace signals. If you are using a hub, link it to the hub, if you are not, link it to the mainframe.<br>\
	<br>\
	Broadcasters:<br>\
	Broadcasters are what they say on the tin, they take decoded signals from the processors, and broadcast them through subspace. If you are using a hub, link it to the hub, if you are not, link it to the mainframe.<br>\
	<br>\
	Other Machinery:<br>\
	This machinery is not linked directly to the network, but is still important for communications.<br>\
	<br>\
	PDA Server:<br>\
	This is the server responsible for PDA messaging, if this is disabled, PDA messaging will not function.<br>\
	<br>\
	Blackbox Recorder:<br>\
	This is important should and disaster happen to the station, this keeps a record of everything that happens to the station.<br>\
	<br>\
	NTNet Quantum Relay:<br>\
	This is the machine which makes NTNet (Used by consoles and tablets) able to reach devices. Warning: This machine is very fragile.<br>\
	<br>\
	This room is split into four isles, each one with a corresponding bus and CPU, as well as two servers.<br>\
	<li>Isle 1: Medical And Science</li>\
	<li>Isle 2: Service And Supply</li>\
	<li>Isle 3: Command And Security</li>\
	<li>Isle 4: Supply And Service</li>\
	<br>\
	NOTE: In this setup, the Common server also listens on frequencies 144.4 - 148.7<br>\
	<br>\
	Bottom Section:<br>\
	In the bottom section, you will find two broadcasters (one for output, one for redundancy) and two receivers. The west receiver handles Science, Medical, Supply and Service. The east receiver handles Command, Security, Engineering, Common and all the other frequencies.<br>"
