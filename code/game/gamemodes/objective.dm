GLOBAL_LIST_EMPTY(objectives)

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/datum/team/team //An alternative to 'owner': a team. Use this when writing new code.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/team_explanation_text	//For when there are multiple owners.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.
	var/martyr_compatible = 0			//If the objective is compatible with martyr objective, i.e. if you can still do it while dead.

/datum/objective/New(var/text)
	GLOB.objectives += src
	if(text)
		explanation_text = text


/datum/objective/proc/get_owners() // Combine owner and team into a single list.
	. = (team && team.members) ? team.members.Copy() : list()
	if(owner)
		. += owner

/datum/objective/proc/considered_escaped(datum/mind/M)
	if(!considered_alive(M))
		return FALSE
	if(SSticker.force_ending || SSticker.mode.station_was_nuked) // Just let them win.
		return TRUE
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return FALSE
	var/turf/location = get_turf(M.current)
	if(!location || istype(location, /turf/open/floor/plasteel/shuttle/red) || istype(location, /turf/open/floor/mineral/plastitanium/brig)) // Fails if they are in the shuttle brig
		return FALSE
	return location.onCentCom() || location.onSyndieBase()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/is_unique_objective(possible_target)
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		for(var/datum/objective/O in M.objectives)
			if(istype(O, type) && O.get_target() == possible_target)
				return FALSE
	return TRUE

/datum/objective/proc/get_target()
	return target


/datum/objective/proc/get_crewmember_minds()
	. = list()
	for(var/V in GLOB.data_core.locked)
		var/datum/data/record/R = V
		var/datum/mind/M = R.fields["mindref"]
		if(M)
			. += M

/
/datum/objective/proc/find_target()
	var/list/datum/mind/owners = get_owners()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(!(possible_target in owners) && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && is_unique_objective(possible_target))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/proc/find_target_by_role(role, role_type=0, invert=0)//Option sets either to check assigned role or special role. Default to assigned., invert inverts the check, eg: "Don't choose a Ling"
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(!(possible_target in owners) && ishuman(possible_target.current))
			var/is_role = 0
			if(role_type)
				if(possible_target.special_role == role)
					is_role++
			else
				if(possible_target.assigned_role == role)
					is_role++

			if(invert)
				if(is_role)
					continue
				target = possible_target
				break
			else if(is_role)
				target = possible_target
				break

	update_explanation_text()

/datum/objective/proc/update_explanation_text()
	if(team_explanation_text && LAZYLEN(get_owners()) > 1)
		explanation_text = team_explanation_text

/datum/objective/proc/give_special_equipment(special_equipment)
	var/datum/mind/receiver = pick(get_owners())
	if(receiver && receiver.current)
		if(ishuman(receiver.current))
			var/mob/living/carbon/human/H = receiver.current
			var/list/slots = list("backpack" = slot_in_backpack)
			for(var/eq_path in special_equipment)
				var/obj/O = new eq_path
				if (!H.equip_in_one_of_slots(O, slots))
					addtimer(CALLBACK(H, /mob/living/carbon/human.proc/equip_in_one_of_slots, O, slots), 50)

/datum/objective/assassinate
	var/target_role_type=0
	martyr_compatible = 1

/datum/objective/assassinate/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(!considered_alive(target.current) || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey || (H && H.dna.species.id == "memezombies")) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	return 1

/datum/objective/assassinate/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"

/datum/objective/assassinate/internal
	var/stolen = 0 		//Have we already eliminated this target?

/datum/objective/assassinate/internal/update_explanation_text()
	..()
	if(target && !target.current)
		explanation_text = "Assassinate [target.name], who was obliterated"


/datum/objective/mutiny
	var/target_role_type=0
	martyr_compatible = 1

/datum/objective/mutiny/find_target_by_role(role, role_type=0,invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/mutiny/check_completion()
	if(target && target.current)
		if(!considered_alive(target.current) || !ishuman(target.current) || !target.current.ckey)
			return 1
		var/turf/T = get_turf(target.current)
		if(T && (!(T.z in GLOB.station_z_levels)) || (target.current.client && target.current.client.is_afk()))			//If they leave the station or go afk they count as dead for this
			return 2
		return 0
	return 1

/datum/objective/mutiny/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Assassinate or exile [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/maroon
	var/target_role_type=0
	martyr_compatible = 1

/datum/objective/maroon/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/maroon/check_completion()
	if(target && target.current)
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(!considered_alive(target.current) || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey || (H && H.dna.species.id == "memezombies")) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		if(target.current.onCentCom() || target.current.onSyndieBase())
			return 0
	return 1

/datum/objective/maroon/update_explanation_text()
	if(target && target.current)
		explanation_text = "Prevent [target.name], the [!target_role_type ? target.assigned_role : target.special_role], from escaping alive."
	else
		explanation_text = "Free Objective"



/datum/objective/debrain//I want braaaainssss
	var/target_role_type=0

/datum/objective/debrain/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/debrain/check_completion()
	if(!target)//If it's a free objective.
		return TRUE
	if(!target.current || !isbrain(target.current))
		return FALSE
	var/atom/A = target.current
	var/list/datum/mind/owners = get_owners()

	while(A.loc) // Check to see if the brainmob is on our person
		A = A.loc
		for(var/datum/mind/M in owners)
			if(M.current && M.current.stat != DEAD && A == M.current)
				return TRUE
	return FALSE

/datum/objective/debrain/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Steal the brain of [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/protect//The opposite of killing a dude.
	var/target_role_type=0
	martyr_compatible = 1

/datum/objective/protect/find_target_by_role(role, role_type=0, invert=0)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/protect/check_completion()
	if(!target)			//If it's a free objective.
		return 1
	if(target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return 0
		return 1
	return 0

/datum/objective/protect/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Protect [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"



/datum/objective/hijack
	explanation_text = "Hijack the shuttle to ensure no loyalist Nanotrasen crew escape alive and out of custody."
	martyr_compatible = 0 //Technically you won't get both anyway.

/datum/objective/hijack/check_completion() // Requires all owners to escape.
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return FALSE
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_alive(M) || !SSshuttle.emergency.shuttle_areas[get_area(M.current)])
			return FALSE
	return SSshuttle.emergency.is_hijacked()


/datum/objective/hijackclone
	explanation_text = "Hijack the emergency shuttle by ensuring only you (or your copies) escape."
	martyr_compatible = 0

/datum/objective/hijackclone/check_completion()
	if(!owner.current)
		return FALSE
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return FALSE

	var/in_shuttle = FALSE
	for(var/mob/living/player in GLOB.player_list) //Make sure nobody else is onboard
		if(SSshuttle.emergency.shuttle_areas[get_area(player)])
			if(player.mind && player.mind != owner)
				if(player.stat != DEAD)
					if(issilicon(player)) //Borgs are technically dead anyways
						continue
					if(isanimal(player)) //animals don't count
						continue
					if(isbrain(player)) //also technically dead
						continue
					var/location = get_turf(player.mind.current)
					if(istype(location, /turf/open/floor/plasteel/shuttle/red))
						continue
					if(istype(location, /turf/open/floor/mineral/plastitanium/brig))
						continue
					if(player.real_name != owner.current.real_name)
						return FALSE
					else
						in_shuttle = TRUE
	return in_shuttle

/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."
	martyr_compatible = 1

/datum/objective/block/check_completion()
	if(!issilicon(owner.current))
		return 0
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return 1

	for(var/mob/living/player in GLOB.player_list)
		if(issilicon(player))
			continue
		if(player.mind)
			if(player.stat != DEAD)
				if(get_area(player) in SSshuttle.emergency.shuttle_areas)
					return 0

	return 1


/datum/objective/purge
	explanation_text = "Ensure no mutant humanoid species are present aboard the escape shuttle."
	martyr_compatible = 1

/datum/objective/purge/check_completion()
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return 1

	for(var/mob/living/player in GLOB.player_list)
		if(get_area(player) in SSshuttle.emergency.shuttle_areas && player.mind && player.stat != DEAD && ishuman(player))
			var/mob/living/carbon/human/H = player
			if(H.dna.species.id != "human")
				return 0

	return 1


/datum/objective/robot_army
	explanation_text = "Have at least eight active cyborgs synced to you."
	martyr_compatible = 0

/datum/objective/robot_army/check_completion()
	var/counter = 0
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!M.current || !isAI(M.current))
			continue
		var/mob/living/silicon/ai/A = M.current
		for(var/mob/living/silicon/robot/R in A.connected_robots)
			if(R.stat != DEAD)
				counter++
	return counter >= 8

/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and without being in custody."

/datum/objective/escape/check_completion()
	// Require all owners escape safely.
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_escaped(M))
			return FALSE
	return TRUE

/datum/objective/escape/escape_with_identity
	var/target_real_name // Has to be stored because the target's real_name can change over the course of the round
	var/target_missing_id

/datum/objective/escape/escape_with_identity/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(possible_target != owner && ishuman(possible_target.current) && possible_target.current.has_dna() && (possible_target.current.stat != DEAD) && is_unique_objective(possible_target))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	else
		target = null//we'd rather have no target than an invalid one
	update_explanation_text()

/datum/objective/escape/escape_with_identity/update_explanation_text()
	if(target && target.current)
		target_real_name = target.current.real_name
		explanation_text = "Escape on the shuttle or an escape pod with the identity of [target_real_name], the [target.assigned_role]"
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(H && H.get_id_name() != target_real_name)
			target_missing_id = 1
		else
			explanation_text += " while wearing their identification card"
		explanation_text += "." //Proper punctuation is important!

	else
		explanation_text = "Free Objective."

/datum/objective/escape/escape_with_identity/check_completion()
	if(!target || !target_real_name)
		return TRUE
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!ishuman(M.current) || !considered_escaped(M))
			continue
		var/mob/living/carbon/human/H = M.current
		if(H.dna.real_name == target_real_name && (H.get_id_name() == target_real_name || target_missing_id))
			return TRUE
	return FALSE


/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/survive/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_alive(M))
			return FALSE
	return TRUE


/datum/objective/martyr
	explanation_text = "Die a glorious death."


/datum/objective/martyr/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(considered_alive(M))
			return FALSE
	return TRUE


/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."
	martyr_compatible = 1

/datum/objective/nuclear/check_completion()
	if(SSticker && SSticker.mode && SSticker.mode.station_was_nuked)
		return 1
	return 0

GLOBAL_LIST_EMPTY(possible_items)
/datum/objective/steal
	var/datum/objective_item/targetinfo = null //Save the chosen item datum so we can access it later.
	var/obj/item/steal_target = null //Needed for custom objectives (they're just items, not datums).
	martyr_compatible = 0

/datum/objective/steal/get_target()
	return steal_target

/datum/objective/steal/New()
	..()
	if(!GLOB.possible_items.len)//Only need to fill the list when it's needed.
		for(var/I in subtypesof(/datum/objective_item/steal))
			new I

/datum/objective/steal/find_target()
	var/list/datum/mind/owners = get_owners()
	var/approved_targets = list()
	check_items:
		for(var/datum/objective_item/possible_item in GLOB.possible_items)
			if(!is_unique_objective(possible_item.targetitem))
				continue
			for(var/datum/mind/M in owners)
				if(M.current.mind.assigned_role in possible_item.excludefromjob)
					continue check_items
			approved_targets += possible_item
	return set_target(safepick(approved_targets))


/datum/objective/steal/proc/set_target(datum/objective_item/item)
	if(item)
		targetinfo = item

		steal_target = targetinfo.targetitem
		explanation_text = "Steal [targetinfo.name]"
		give_special_equipment(targetinfo.special_equipment)
		return steal_target
	else
		explanation_text = "Free objective"
		return

/datum/objective/steal/proc/select_target() //For admins setting objectives manually.
	var/list/possible_items_all = GLOB.possible_items+"custom"
	var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if (!new_target)
		return

	if (new_target == "custom") //Can set custom items.
		var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/obj/item)
		if (!custom_target)
			return
		var/custom_name = initial(custom_target.name)
		custom_name = stripped_input("Enter target name:", "Objective target", custom_name)
		if (!custom_name)
			return
		steal_target = custom_target
		explanation_text = "Steal [custom_name]."

	else
		set_target(new_target)
	return steal_target

/datum/objective/steal/check_completion()
	var/list/datum/mind/owners = get_owners()
	if(!steal_target)
		return TRUE
	for(var/datum/mind/M in owners)
		if(!isliving(M.current))
			continue

		var/list/all_items = M.current.GetAllContents()	//this should get things in cheesewheels, books, etc.

		for(var/obj/item/I in all_items) //Check for items
			if(istype(I, steal_target))
				if(!targetinfo) //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
					return TRUE
				else if(targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
					return TRUE
			if(targetinfo && (I.type in targetinfo.altitems)) //Ok, so you don't have the item. Do you have an alternative, at least?
				if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
					return TRUE
	var/list/ok_areas = list(/area/infiltrator_base, /area/syndicate_mothership, /area/shuttle/stealthcruiser)
	var/list/compiled_areas = list()
	for(var/A in ok_areas)
		compiled_areas += typesof(A)
	for(var/A in compiled_areas)
		for(var/obj/item/I in area_contents(get_area_by_type(A))) //Check for items
			if(istype(I, steal_target))
				if(!targetinfo) //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
					return TRUE
				else if(targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
					return TRUE
			if(targetinfo && (I.type in targetinfo.altitems)) //Ok, so you don't have the item. Do you have an alternative, at least?
				if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
					return TRUE
			CHECK_TICK
		CHECK_TICK
	return FALSE


GLOBAL_LIST_EMPTY(possible_items_special)
/datum/objective/steal/special //ninjas are so special they get their own subtype good for them

/datum/objective/steal/special/New()
	..()
	if(!GLOB.possible_items_special.len)
		for(var/I in subtypesof(/datum/objective_item/special) + subtypesof(/datum/objective_item/stack))
			new I

/datum/objective/steal/special/find_target()
	return set_target(pick(GLOB.possible_items_special))

/datum/objective/steal/exchange
	martyr_compatible = 0

/datum/objective/steal/exchange/proc/set_faction(faction,otheragent)
	target = otheragent
	if(faction == "red")
		targetinfo = new/datum/objective_item/unique/docs_blue
	else if(faction == "blue")
		targetinfo = new/datum/objective_item/unique/docs_red
	explanation_text = "Acquire [targetinfo.name] held by [target.current.real_name], the [target.assigned_role] and syndicate agent"
	steal_target = targetinfo.targetitem


/datum/objective/steal/exchange/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Acquire [targetinfo.name] held by [target.name], the [target.assigned_role] and syndicate agent"
	else
		explanation_text = "Free Objective"


/datum/objective/steal/exchange/backstab

/datum/objective/steal/exchange/backstab/set_faction(faction)
	if(faction == "red")
		targetinfo = new/datum/objective_item/unique/docs_red
	else if(faction == "blue")
		targetinfo = new/datum/objective_item/unique/docs_blue
	explanation_text = "Do not give up or lose [targetinfo.name]."
	steal_target = targetinfo.targetitem


/datum/objective/download

/datum/objective/download/find_target()
	target_amount = rand(10,20)
	explanation_text = "Download [target_amount] research level\s."
	return target_amount

/datum/objective/download/check_completion()
	var/list/current_tech = list()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/owner in owners)
		if(ismob(owner.current))
			var/mob/M = owner.current			//Yeah if you get morphed and you eat a quantum tech disk with the RD's latest backup good on you soldier.
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H && (H.stat != DEAD) && istype(H.wear_suit, /obj/item/clothing/suit/space/space_ninja))
					var/obj/item/clothing/suit/space/space_ninja/S = H.wear_suit
					for(var/datum/tech/T in S.stored_research)
						current_tech[T.id] = T.level? T.level : 0
			var/list/otherwise = M.GetAllContents()
			for(var/obj/item/disk/tech_disk/TD in otherwise)
				for(var/datum/tech/T in TD.tech_stored)
					if(!T.id || !T.level)
						continue
					else if(!current_tech[T.id])
						current_tech[T.id] = T.level
					else if(T.level > current_tech[T.id])
						current_tech[T.id] = T.level
	var/list/ok_areas = list(/area/infiltrator_base, /area/syndicate_mothership, /area/shuttle/stealthcruiser)
	var/list/compiled_areas = list()
	for(var/A in ok_areas)
		compiled_areas += typesof(A)
	for(var/A in compiled_areas)
		for(var/obj/item/disk/tech_disk/TD in area_contents(get_area_by_type(A)))
			for(var/datum/tech/T in TD.tech_stored)
				if(!T.id || !T.level)
					continue
				else if(!current_tech[T.id])
					current_tech[T.id] = T.level
				else if(T.level > current_tech[T.id])
					current_tech[T.id] = T.level
			CHECK_TICK
		CHECK_TICK
	var/total = 0
	for(var/i in current_tech)
		total += current_tech[i]
	return total >= target_amount



/datum/objective/capture

/datum/objective/capture/proc/gen_amount_goal()
		target_amount = rand(5,10)
		explanation_text = "Capture [target_amount] lifeform\s with an energy net. Live, rare specimens are worth more."
		return target_amount

/datum/objective/capture/check_completion()//Basically runs through all the mobs in the area to determine how much they are worth.
	var/captured_amount = 0
	var/area/centcom/holding/A = locate() in GLOB.sortedAreas
	for(var/mob/living/carbon/human/M in A)//Humans.
		if(M.stat==2)//Dead folks are worth less.
			captured_amount+=0.5
			continue
		captured_amount+=1
	for(var/mob/living/carbon/monkey/M in A)//Monkeys are almost worthless, you failure.
		captured_amount+=0.1
	for(var/mob/living/carbon/alien/larva/M in A)//Larva are important for research.
		if(M.stat==2)
			captured_amount+=0.5
			continue
		captured_amount+=1
	for(var/mob/living/carbon/alien/humanoid/M in A)//Aliens are worth twice as much as humans.
		if(istype(M, /mob/living/carbon/alien/humanoid/royal/queen))//Queens are worth three times as much as humans.
			if(M.stat==2)
				captured_amount+=1.5
			else
				captured_amount+=3
			continue
		if(M.stat==2)
			captured_amount+=1
			continue
		captured_amount+=2
	if(captured_amount<target_amount)
		return 0
	return 1



/datum/objective/absorb

/datum/objective/absorb/proc/gen_amount_goal(lowbound = 4, highbound = 6)
	target_amount = rand (lowbound,highbound)
	var/n_p = 1 //autowin
	if (SSticker.current_state == GAME_STATE_SETTING_UP)
		for(var/mob/dead/new_player/P in GLOB.player_list)
			if(P.client && P.ready == PLAYER_READY_TO_PLAY && P.mind!=owner)
				n_p ++
	else if (SSticker.IsRoundInProgress())
		for(var/mob/living/carbon/human/P in GLOB.player_list)
			if(P.client && !(P.mind in SSticker.mode.changelings) && P.mind!=owner)
				n_p ++
	target_amount = min(target_amount, n_p)

	explanation_text = "Extract [target_amount] compatible genome\s."
	return target_amount

/datum/objective/absorb/check_completion()
	if(owner && owner.changeling && owner.changeling.stored_profiles && (owner.changeling.absorbedcount >= target_amount))
		return 1
	else
		return 0



/datum/objective/destroy
	martyr_compatible = 1

/datum/objective/destroy/find_target()
	var/list/possible_targets = active_ais(1)
	var/mob/living/silicon/ai/target_ai = pick(possible_targets)
	target = target_ai.mind
	update_explanation_text()
	return target

/datum/objective/destroy/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	return 1

/datum/objective/destroy/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "Destroy [target.name], the experimental AI."
	else
		explanation_text = "Free Objective"

/datum/objective/destroy/internal
	var/stolen = FALSE 		//Have we already eliminated this target?

/datum/objective/steal_five_of_type
	explanation_text = "Steal at least five items!"
	var/list/wanted_items = list(/obj/item)

/datum/objective/steal_five_of_type/New()
	..()
	wanted_items = typecacheof(wanted_items)

/datum/objective/steal_five_of_type/summon_guns
	explanation_text = "Steal at least five guns!"
	wanted_items = list(/obj/item/gun)

/datum/objective/steal_five_of_type/summon_magic
	explanation_text = "Steal at least five magical artefacts!"
	wanted_items = list(/obj/item/spellbook, /obj/item/gun/magic, /obj/item/clothing/suit/space/hardsuit/wizard, /obj/item/scrying, /obj/item/antag_spawner/contract, /obj/item/device/necromantic_stone)

/datum/objective/steal_five_of_type/check_completion()
	if(!isliving(owner.current))
		return 0
	var/stolen_count = 0
	var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
	for(var/obj/I in all_items) //Check for wanted items
		if(is_type_in_typecache(I, wanted_items))
			stolen_count++
	if(stolen_count >= 5)
		return 1
	else
		return 0
	return 0

/datum/objective/wizard
	completed = TRUE

/datum/objective/wizard/New()
	explanation_text = "[pick("Wreak havoc", "Sow carnage", "Unleash destruction")] on these [pick("wandless", "spelless", "absolutely not magical")] Nanotrasen scum."
