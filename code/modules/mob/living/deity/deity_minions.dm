//Mooks are AI driven minions.

/mob/living/deity
	var/list/minions = list()

/mob/living/deity/proc/add_minion(var/mob/living/L)
	minions |= L
	GLOB.destroyed_event.register(L, src, /mob/living/deity/proc/remove_minion)
	GLOB.death_event.register(L, src, /mob/living/deity/proc/remove_minion)

/mob/living/deity/proc/remove_minion(var/mob/living/L)
	to_chat(src, "<span class='warning'>\The [L] was lost!</span>")
	GLOB.destroyed_event.unregister(L,src)
	GLOB.death_event.unregister(L,src)
	minions -= L

/mob/living/deity/proc/is_minion(var/mob/living/L, var/check_dead = 0)
	if(!(L in minions) || (check_dead && L.stat == DEAD))
		return 0
	return 1