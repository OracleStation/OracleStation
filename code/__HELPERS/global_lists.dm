//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_references_lists()
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, GLOB.hair_styles_list, GLOB.hair_styles_male_list, GLOB.hair_styles_female_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hair_styles_list, GLOB.facial_hair_styles_male_list, GLOB.facial_hair_styles_female_list)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	//Unathi bodyparts (blizzard intensifies)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, GLOB.body_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/unathi, GLOB.tails_list_unathi)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/unathi, GLOB.animated_tails_list_unathi)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/human, GLOB.animated_tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts, GLOB.snouts_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts_ethari, GLOB.snouts_ethari_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/horns,GLOB.horns_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, GLOB.ears_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings_open, GLOB.wings_open_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, GLOB.frills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, GLOB.spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines_animated, GLOB.animated_spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/legs, GLOB.legs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.r_wings_list,roundstart = TRUE)
	//fox bodyparts
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/ethari, GLOB.tails_list_ethari)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/ethari, GLOB.animated_tails_list_ethari)
	// Clown bodyparts
	init_sprite_accessory_subtypes(/datum/sprite_accessory/clown_hairs, GLOB.clown_hairs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/clown_mouths, GLOB.clown_mouths_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/clown_makeups, GLOB.clown_makeups_list)
	// IPC bodyparts
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_screens, GLOB.ipc_screens_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_antennas, GLOB.ipc_antennas_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_chassis, GLOB.ipc_chassis_list)
	// Vox bodyparts
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_bodies, GLOB.vox_bodies_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_quills, GLOB.vox_quills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_facial_quills, GLOB.vox_facial_quills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_eyes, GLOB.vox_eyes_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_tails, GLOB.vox_tails_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_body_markings, GLOB.vox_body_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_tail_markings, GLOB.vox_tail_markings_list)

	//Species
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		GLOB.species_list[S.id] = spath

	//Surgeries
	for(var/path in subtypesof(/datum/surgery))
		GLOB.surgeries_list += new path()

	//Materials
	for(var/path in subtypesof(/datum/material))
		var/datum/material/D = new path()
		GLOB.materials_list[D.id] = D

	//Techs
	for(var/path in subtypesof(/datum/tech))
		var/datum/tech/D = new path()
		GLOB.tech_list[D.id] = D

	//Emotes
	for(var/path in subtypesof(/datum/emote))
		var/datum/emote/E = new path()
		E.emote_list[E.key] = E

	init_subtypes(/datum/crafting_recipe, GLOB.crafting_recipes)

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	to_chat(world, .)
*/

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L
