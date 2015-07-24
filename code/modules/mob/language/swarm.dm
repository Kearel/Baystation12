/datum/language/swarm
	name = "Swarmian"
	desc = "Primitive and simple."
	key = "p"
	syllables = list("bo", "do", "ke", "lo", "ge", "ed", "od", "oo", "ee")
	space_chance = 50

/datum/species/swarm/get_random_name(var/gender)
	var/datum/language/species_language = all_languages[default_language]
	return species_language.get_random_name(gender)