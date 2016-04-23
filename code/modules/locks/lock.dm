#define LOCKED 1
#define BROKEN 2


/datum/lock
	var/status = 1 //unlocked, 1 == locked 2 == broken
	var/lock_data = "" //basically a randomized string. The longer the string the more complex the lock.
	var/atom/holder

/datum/lock/New(var/atom/h, var/complexity = 1)
	holder = h
	if(istext(complexity))
		lock_data = complexity
	else
		lock_data = generateRandomString(complexity)

/datum/lock/Destroy()
	holder = null
	..()

/datum/lock/proc/unlock(var/key = "")
	if(status ^ LOCKED)
		return 2

	if(cmptext(lock_data,key) && (status ^ BROKEN))
		status &= ~LOCKED
		return 1
	return 0

/datum/lock/proc/lock(var/key = "")
	if(status & LOCKED)
		return 2

	if(cmptext(lock_data,key) && (status ^ BROKEN))
		status |= LOCKED
		return 1
	return 0

/datum/lock/proc/toggle(var/key = "")
	if(status & LOCKED)
		return unlock(key)
	else
		return lock(key)

/datum/lock/proc/getComplexity()
	return length(lock_data)

/datum/lock/proc/isLocked()
	return status & LOCKED

/datum/lock/proc/pick_lock(var/obj/item/I, var/mob/user)
	if(!istype(I) && (status ^ LOCKED))
		return
	var/unlock_power = 0
	if(istype(I, /obj/item/weapon/screwdriver))
		unlock_power = 5
	else if(istype(I, /obj/item/stack/rods))
		unlock_power = 3
	if(!unlock_power)
		return
	user.visible_message("\The [user] takes out \the [I], picking \the [holder]'s lock.")
	if(!do_after(user, 20, holder))
		return
	if(prob(20*(unlock_power/getComplexity())))
		user << "<span class='notice'>You pick open \the [holder]'s lock!</span>"
		unlock(lock_data)
		return
	else if(prob(5 * unlock_power))
		user << "<span class='warning'>You accidently break \the [holder]'s lock with your [I]!</span>"
		status |= BROKEN