//This file houses 99% of all donator code we'll need.
//It's mostly self-contained so we don't have to bother
//with other stuff getting in the way down the line,
//mostly when we're porting things from /tg/ and such.

GLOBAL_LIST_INIT(donator_tiers, list("Not a Donator" = 0, "Basic Donator" = 1, "Full Donator" = 2))
GLOBAL_LIST_EMPTY(donators)

/proc/load_donators()
	if(!SSdbcore.Connect())
		log_world("Failed to connect to database in load_donators(). No donators will be loaded.")
		message_admins("Failed to connect to database in load_donators(). No donators will be loaded.")
		return

	var/datum/DBQuery/query_get_donators = SSdbcore.NewQuery("SELECT ckey donator FROM [format_table_name("player")] WHERE donator > 0;")
	if(!query_get_donators.warn_execute())
		return
	while(query_get_donators.NextRow())
		var/donator_ckey = query_get_donators.item[1]
		var/donator_tier = query_get_donators.item[2]
		GLOB.donators[donator_ckey] = donator_tier

/proc/donation_to_string(name)
	switch(name)
		if(DONATOR_NONE)
			return "Not a Donator"
		if(DONATOR_BASIC)
			return "Basic Donator"
		if(DONATOR_FULL)
			return "Full Donator"
	return "UNKNOWN"

/client/proc/donator_level_check(tier)
	if(prefs.unlock_content == DONATOR_NONE)
		to_chat(src, "<span class='notice'>Become an Oracle Station donator to access member-perks and features, as well as help us cover the \
		hosting costs that make this game possible. <a href=?action=openLink;link=[CONFIG_GET(string/patreonurl)]>Click Here to find out more</a>.</span>")
		return FALSE
	if(prefs.unlock_content < tier)
		to_chat(src, "<span class='notice'>Your donator level is too low to access this perk. \
		<a href=?action=openLink;link=[CONFIG_GET(string/patreonurl)]>Click Here to find out more</a>.</span>")
		return FALSE
	return TRUE


/datum/preferences/proc/check_donator_status()
	if(!parent)
		return FALSE
	var/donator_tier = DONATOR_NONE
	donator_tier = GLOB.donators[sanitizeSQL(parent.ckey)]
	return donator_tier

///EDITING DONATOR PERMS///
/client/proc/edit_donator_permissions()
	set category = "Admin"
	set name = "Donators Panel"
	set desc = "Edit donator tiers"

	if(!check_rights(R_PERMISSIONS))
		return

	usr.client.holder.edit_donator_permissions()

/datum/admins/proc/edit_donator_permissions()
	if(!check_rights(R_PERMISSIONS))
		return

	var/output = {"<!DOCTYPE html>
	<html>
	<head>
	<title>Donators Panel</title>
	<script type='text/javascript' src='search.js'></script>
	<link rel='stylesheet' type='text/css' href='panels.css'>
	</head>
	<body onload='selectTextField();updateSearch();'>
	<div id='main'><table id='searchable' cellspacing='0'>
	<tr class='title'>
	<th style='width:125px;text-align:right;'>CKEY <a class='small' href='?src=[REF(src)];[HrefToken()];donatorperms=add'>\[+\]</a></th>
	<th style='width:125px;'>DONATOR STATUS</th>
	</tr>
	"}

	for(var/donator_ckey in GLOB.donators)
		output += "<tr>"
		output += "<td style='text-align:right;'>[donator_ckey]<a class='small' href='?src=[REF(src)];[HrefToken()];donatorperms=remove;ckey=[donator_ckey]'>\[-\]</a></td>"
		output += "<td><a href='?src=[REF(src)];[HrefToken()];donatorperms=rank;ckey=[donator_ckey]'>[donation_to_string(GLOB.donators[donator_ckey])]</a></td>"
		output += "</tr>"

	output += {"
	</table></div>
	<div id='top'><b>Search:</b> <input type='text' id='filter' value='' style='width:70%;' onkeyup='updateSearch();'></div>
	</body>
	</html>"}

	usr << browse(output,"window=donatorperms;size=900x650")

/datum/admins/proc/set_donator_status(new_ckey, new_status)
	if(!usr.client)
		return
	if(!check_rights(R_PERMISSIONS))
		return
	new_ckey = sanitizeSQL(new_ckey)
	var/datum/DBQuery/query_donator_rank_update = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET donator = '[new_status]' WHERE ckey = '[new_ckey]'")
	if(!query_donator_rank_update.warn_execute())
		load_donators()
