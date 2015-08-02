/datum/species/swarm
	name = "Swarm"
	name_plural = "Swarm"
	default_language = "Swarmian"
	language = "Galactic Common"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Jesus, how did this get on the station? Damn things breed faster then diona."

	flags = CAN_JOIN 	| HAS_EYE_COLOR | HAS_SKIN_TONE

	blood_color = "#2299FC"
	flesh_color = "#808D11"


	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes
		)

	total_health = 50