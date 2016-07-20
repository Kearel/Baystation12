/mob/living/deity
	name = "deity"
	desc = "A being from beyond the void, their very presence in our reality is unnerving and unnatural."
	icon = 'icons/obj/narsie.dmi'
	icon_state = "narsie"
	var/faith = 0
	var/stats = list("altar_faith_gain" = 1)
	var/obj/structure/altar/altar = null

/mob/living/deity/Life()
	if(!..())
		return

	if(altar)
		faith += stats["altar_faith_gain"]

/mob/living/deity/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Faith: [faith]")