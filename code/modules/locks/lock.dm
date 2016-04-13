#define LOCKED 1
#define BROKEN 2


/datum/lock
	var/status = 1 //unlocked, 1 == locked 2 == broken
	var/lock_data = "" //basically a randomized string. The longer the string the more complex the lock.

/datum/lock/New(var/complexity = 1)
	if(istext(complexity))
		lock_data = complexity
	else
		lock_data = generateRandomString(complexity)

/datum/lock/proc/unlock(var/key = "")
	if(status ^ LOCKED)
		return 2

	if(cmptext(lock_data,key))
		status &= ~LOCKED
		return 1
	return 0

/datum/lock/proc/lock(var/key = "")
	if(status & LOCKED)
		return 2

	if(cmptext(lock_data,key))
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