// Cold

/datum/disease/advance/cold/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Cold"
		symptoms = list(new/datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Flu"
		symptoms = list(new/datum/symptom/cough)
	..(process, D, copy)


// Voice Changing

/datum/disease/advance/voice_change/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Epiglottis Mutation"
		symptoms = list(new/datum/symptom/voice_change)
	..(process, D, copy)


// Toxin Filter

/datum/disease/advance/heal/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Liver Enhancer"
		symptoms = list(new/datum/symptom/heal/toxin)
	..(process, D, copy)


// Hallucigen

/datum/disease/advance/hallucigen/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Second Sight"
		symptoms = list(new/datum/symptom/hallucigen)
	..(process, D, copy)

// Sensory Restoration

/datum/disease/advance/mind_restoration/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Intelligence Booster"
		symptoms = list(new/datum/symptom/mind_restoration)
	..(process, D, copy)

// Sensory Destruction

/datum/disease/advance/narcolepsy/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Experimental Insomnia Cure"
		symptoms = list(new/datum/symptom/narcolepsy)
	..(process, D, copy)

//Randomly generated Disease, for virus crates and events
/datum/disease/advance/random
	name = "Experimental Disease"

/datum/disease/advance/random/New(max_symptoms, max_level = 8)
	if(!max_symptoms)
		max_symptoms = rand(1, 6)
	var/list/datum/symptom/possible_symptoms = list()
	for(var/symptom in subtypesof(/datum/symptom))
		var/datum/symptom/S = symptom
		if(initial(S.level) > max_level)
			continue
		if(initial(S.level) <= 0) //unobtainable symptoms
			continue
		possible_symptoms += S
	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/symptom/S = new chosen_symptom
			symptoms += S
	Refresh()
	name = "Sample #[rand(1,10000)]"