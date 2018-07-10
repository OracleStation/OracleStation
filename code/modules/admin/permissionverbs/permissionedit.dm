/client/proc/edit_admin_permissions()
	set category = "Admin"
	set name = "Permissions Panel"
	set desc = "Edit admin permissions"
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.edit_admin_permissions()

/datum/admins/proc/edit_admin_permissions()
	if(!check_rights(R_PERMISSIONS))
		return

	var/output = {"<!DOCTYPE html>
<html>
<head>
<title>Permissions Panel</title>
<script type='text/javascript' src='search.js'></script>
<link rel='stylesheet' type='text/css' href='panels.css'>
</head>
<body onload='selectTextField();updateSearch();'>
<div id='main'><table id='searchable' cellspacing='0'>
<tr class='title'>
<th style='width:125px;text-align:right;'>CKEY <a class='small' href='?src=[REF(src)];[HrefToken()];editrights=add'>\[+\]</a></th>
<th style='width:125px;'>RANK</th>
<th style='width:375px;'>PERMISSIONS</th>
<th style='width:100%;'>VERB-OVERRIDES</th>
</tr>
"}

	for(var/adm_ckey in GLOB.admin_datums)
		var/datum/admins/D = GLOB.admin_datums[adm_ckey]
		if(!D)
			continue

		var/rights = rights2text(D.rank.rights," ")
		if(!rights)	rights = "*none*"

		output += "<tr>"
		output += "<td style='text-align:right;'>[adm_ckey] <a class='small' href='?src=[REF(src)];[HrefToken()];editrights=remove;ckey=[adm_ckey]'>\[-\]</a></td>"
		output += "<td><a href='?src=[REF(src)];[HrefToken()];editrights=rank;ckey=[adm_ckey]'>[D.rank.name]</a></td>"
		output += "<td><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=permissions;ckey=[adm_ckey]'>[rights]</a></td>"
		output += "<td><a class='small' href='?src=[REF(src)];[HrefToken()];editrights=permissions;ckey=[adm_ckey]'>[rights2text(0," ",D.rank.adds,D.rank.subs)]</a></td>"
		output += "</tr>"

	output += {"
</table></div>
<div id='top'><b>Search:</b> <input type='text' id='filter' value='' style='width:70%;' onkeyup='updateSearch();'></div>
</body>
</html>"}

	usr << browse(output,"window=editrights;size=900x650")

/datum/admins/proc/log_admin_rank_modification(adm_ckey, new_rank)
	if(CONFIG_GET(flag/admin_legacy_system))
		return

	if(!usr.client)
		return

	if (!check_rights(R_PERMISSIONS))
		return

	if(!SSdbcore.Connect())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return

	if(!adm_ckey || !new_rank)
		return

	adm_ckey = ckey(adm_ckey)

	if(!adm_ckey)
		return

	if(!istext(adm_ckey) || !istext(new_rank))
		return

	var/datum/DBQuery/query_get_admin = SSdbcore.NewQuery("SELECT id FROM [format_table_name("admin")] WHERE ckey = '[adm_ckey]'")
	if(!query_get_admin.warn_execute())
		return

	var/new_admin = 1
	var/admin_id
	while(query_get_admin.NextRow())
		new_admin = 0
		admin_id = text2num(query_get_admin.item[1])

	if(new_admin)
		var/datum/DBQuery/query_add_admin = SSdbcore.NewQuery("INSERT INTO `[format_table_name("admin")]` (`id`, `ckey`, `rank`, `level`, `flags`) VALUES (null, '[adm_ckey]', '[new_rank]', -1, 0)")
		if(!query_add_admin.warn_execute())
			return
		var/datum/DBQuery/query_add_admin_log = SSdbcore.NewQuery("INSERT INTO `[format_table_name("admin_log")]` (`id` ,`datetime` ,`adminckey` ,`adminip` ,`log` ) VALUES (NULL , NOW( ) , '[usr.ckey]', '[usr.client.address]', 'Added new admin [adm_ckey] to rank [new_rank]');")
		if(!query_add_admin_log.warn_execute())
			return
		to_chat(usr, "<span class='adminnotice'>New admin added.</span>")
	else
		if(!isnull(admin_id) && isnum(admin_id))
			var/datum/DBQuery/query_change_admin = SSdbcore.NewQuery("UPDATE `[format_table_name("admin")]` SET rank = '[new_rank]' WHERE id = [admin_id]")
			if(!query_change_admin.warn_execute())
				return
			var/datum/DBQuery/query_change_admin_log = SSdbcore.NewQuery("INSERT INTO `[format_table_name("admin_log")]` (`id` ,`datetime` ,`adminckey` ,`adminip` ,`log` ) VALUES (NULL , NOW( ) , '[usr.ckey]', '[usr.client.address]', 'Edited the rank of [adm_ckey] to [new_rank]');")
			if(!query_change_admin_log.warn_execute())
				return
			to_chat(usr, "<span class='adminnnotice'>Admin rank changed.</span>")


/datum/admins/proc/log_admin_permission_modification(adm_ckey, new_permission)
	if(CONFIG_GET(flag/admin_legacy_system))
		return
	if(!usr.client)
		return
	if(check_rights(R_PERMISSIONS))
		return

	if(!SSdbcore.Connect())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return

	if(!adm_ckey || !istext(adm_ckey) || !isnum(new_permission))
		return

	var/datum/DBQuery/query_get_perms = SSdbcore.NewQuery("SELECT id, flags FROM [format_table_name("admin")] WHERE ckey = '[adm_ckey]'")
	if(!query_get_perms.warn_execute())
		return

	var/admin_id
	while(query_get_perms.NextRow())
		admin_id = text2num(query_get_perms.item[1])

	if(!admin_id)
		return

	var/datum/DBQuery/query_change_perms = SSdbcore.NewQuery("UPDATE `[format_table_name("admin")]` SET flags = [new_permission] WHERE id = [admin_id]")
	if(!query_change_perms.warn_execute())
		return
	var/datum/DBQuery/query_change_perms_log = SSdbcore.NewQuery("INSERT INTO `[format_table_name("admin_log")]` (`id` ,`datetime` ,`adminckey` ,`adminip` ,`log` ) VALUES (NULL , NOW( ) , '[usr.ckey]', '[usr.client.address]', 'Edit permission [rights2text(new_permission)] (flag = [new_permission]) to admin [adm_ckey]');")
	query_change_perms_log.warn_execute()

//=========== MENTORS ===========

/client/proc/edit_mentor_permissions()
	set category = "Admin"
	set name = "Mentor Panel"
	set desc = "Edit mentors"
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.edit_mentor_permissions()

/datum/admins/proc/edit_mentor_permissions()
	if(!check_rights(R_PERMISSIONS))
		return

	var/output = {"<!DOCTYPE html>
<html>
<head>
<title>Permissions Panel</title>
<script type='text/javascript' src='search.js'></script>
<link rel='stylesheet' type='text/css' href='panels.css'>
</head>
<body onload='selectTextField();updateSearch();'>
<div id='main'><table id='searchable' cellspacing='0'>
<tr class='title'>
<th style='width:125px;text-align:right;'>CKEY <a class='small' href='?src=[REF(src)];[HrefToken()];editmentor=add'>\[+\]</a></th>
</tr>
"}

	for(var/men_ckey in GLOB.mentor_datums)
		output += "<tr>"
		output += "<td>[men_ckey]<a class='small' href='?src=[REF(src)];[HrefToken()];editmentor=remove;ckey=[men_ckey]'>\[-\]</a></td>"
		output += "</tr>"

	output += {"
</table></div>
<div id='top'><b>Search:</b> <input type='text' id='filter' value='' style='width:70%;' onkeyup='updateSearch();'></div>
</body>
</html>"}

	usr << browse(output,"window=editrights;size=600x200")

/datum/admins/proc/log_mentor_rank_given(target_ckey)
	if(CONFIG_GET(flag/mentor_legacy_system))
		to_chat(usr, "<span class='adminnotice'>The server is using the legacy system. Modify the config files to change mentor ranks.</span>")
		return

	if(!usr.client)
		return

	if(!check_rights(R_PERMISSIONS))
		return

	if(!SSdbcore.Connect())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return

	if(!target_ckey)
		return

	target_ckey = ckey(target_ckey)

	if(!target_ckey)
		return

	if(!istext(target_ckey))
		return

	var/datum/DBQuery/query_make_mentor = SSdbcore.NewQuery("INSERT INTO [format_table_name("mentor")] (ckey) VALUES ('[target_ckey]')")
	if(!query_make_mentor.warn_execute())
		return
	to_chat(usr, "<span class='adminnotice'><b>[target_ckey]</b> has been added as a mentor.</span>")
	edit_mentor_permissions()

/datum/admins/proc/log_mentor_rank_delete(target_ckey)
	if(CONFIG_GET(flag/mentor_legacy_system))
		to_chat(usr, "<span class='adminnotice'>The server is using the legacy system. Modify the config files to change mentor ranks.</span>")
		return

	if(!usr.client)
		return

	if(!check_rights(R_PERMISSIONS))
		return

	if(!SSdbcore.Connect())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return

	if(!target_ckey)
		return

	target_ckey = ckey(target_ckey)

	if(!target_ckey)
		return

	if(!istext(target_ckey))
		return

	var/datum/DBQuery/query_delete_mentor = SSdbcore.NewQuery("DELETE FROM [format_table_name("mentor")] WHERE ckey='[target_ckey]'")
	if(!query_delete_mentor.warn_execute())
		return
	to_chat(usr, "<span class='adminnotice'><b>[target_ckey]</b> has been removed from the mentor list.</span>")
	edit_mentor_permissions()
