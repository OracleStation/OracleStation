
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	undershirt = random_undershirt(gender)
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(CONFIG_GET(keyed_number_list/roundstart_races))
		pref_species = new rando_race()
	features = random_features()
	age = rand(AGE_MIN,AGE_MAX)

/datum/preferences/proc/update_preview_icon(var/datum/species/optional_species = null, for_species_preview = FALSE)
	// Silicons only need a very basic preview since there is no customization for them.

	var/icon/new_preview_icon
	if(job_engsec_high && !for_species_preview)
		switch(job_engsec_high)
			if(AI_JF)
				new_preview_icon = icon('icons/mob/ai.dmi', "AI", SOUTH)
				new_preview_icon.Scale(64, 64)
				return
			if(CYBORG)
				new_preview_icon = icon('icons/mob/robots.dmi', "robot", SOUTH)
				new_preview_icon.Scale(64, 64)
				return

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = new()
	copy_to(mannequin)
	if(optional_species)
		mannequin.set_species(optional_species)

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	var/highRankFlag = job_civilian_high | job_medsci_high | job_engsec_high

	if(job_civilian_low & ASSISTANT)
		previewJob = SSjob.GetJob("Assistant")
	else if(highRankFlag)
		var/highDeptFlag
		if(job_civilian_high)
			highDeptFlag = CIVILIAN
		else if(job_medsci_high)
			highDeptFlag = MEDSCI
		else if(job_engsec_high)
			highDeptFlag = ENGSEC

		for(var/datum/job/job in SSjob.occupations)
			if(job.flag == highRankFlag && job.department_flag == highDeptFlag)
				previewJob = job
				break

	if(previewJob)
		mannequin.job = previewJob.title
		previewJob.equip(mannequin, TRUE)
	COMPILE_OVERLAYS(mannequin)
	CHECK_TICK
	new_preview_icon = icon('icons/effects/effects.dmi', "nothing")
	new_preview_icon.Scale(48+32, 16+32)
	CHECK_TICK
	mannequin.setDir(NORTH)

	var/icon/stamp = getFlatIcon(mannequin)
	CHECK_TICK
	new_preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)
	CHECK_TICK
	mannequin.setDir(WEST)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	new_preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)
	CHECK_TICK
	mannequin.setDir(SOUTH)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	new_preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)
	CHECK_TICK
	new_preview_icon.Scale(new_preview_icon.Width() * 2, new_preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	CHECK_TICK
	qdel(mannequin)
	
	return new_preview_icon
