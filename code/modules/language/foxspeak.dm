/datum/language/canilunzt
	name = "Canilunzt"
	desc = "The common language of foxpeople, composed of low growls and yelps."
	speech_verb = "growls"
	ask_verb = "growls"
	exclaim_verb = "roars"
	key = "7"
	flags = TONGUELESS_SPEECH
	space_chance = 20
	syllables = list("rur","ya","cen","rawr","bar","kuk","tek","qat","uk","wu","vuh","tah","tch","schz","auch",
	"ist","ein","entch","zwichs","tut","mir","wo","bis","es","vor","nic","gro","lll","enem","zandt","tzch","noch",
	"hel","ischt","far","wa","baram","iereng","tech","lach","sam","mak","lich","gen","or","ag","eck","gec","stag","onn",
	"bin","ket","jarl","vulf","einech","cresthz","azunein","ghzth")
	icon_state = "fox"
	default_priority = 90

/proc/generate_random_names(amount = 500)
	var/syllables = list("rur","ya","cen","rawr","bar","kuk","tek","qat","uk","wu","vuh","tah","tch","schz","auch",
	"ist","ein","entch","zwichs","tut","mir","wo","bis","es","vor","nic","gro","lll","enem","zandt","tzch","noch",
	"hel","ischt","far","wa","baram","iereng","tech","lach","sam","mak","lich","gen","or","ag","eck","gec","stag","onn",
	"bin","ket","jarl","vulf","einech","cresthz","azunein","ghzth")

	for(var/i = 1 in 1 to amount)
		var/first_name_syllables = pick(2, 2, 3, 3, 3, 3, 4)
		var/last_name_syllables = pick(3, 4, 4, 4, 5)
		var/name = ""
		for(var/j = i in 1 to first_name_syllables)
			name += pick(syllables)
		name += " "
		for(var/j = i in 1 to last_name_syllables)
			name += pick(syllables)
		to_chat(world, name)

