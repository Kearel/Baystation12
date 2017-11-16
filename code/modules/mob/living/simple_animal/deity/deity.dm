/*
This mob is controlled remotly by a deity, similar to an RTS.
If the RTS involved garbage controls.
*/
/mob/living/simple_animal/deity
	var/atom/target
	var/frustration = 100

/mob/living/simple_animal/deity/proc/order(var/atom/new_target, var/mob/living/deity/user)
	target = new_target
	if(isturf(target))
		walk_to(src,target)
	return

/mob/living/simple_animal/deity/Move()
	. = ..()
	if(get_turf(src) == target)
		target = null
		walk(src,0)

/mob/living/simple_animal/deity/death()
	target = null
	. = ..()