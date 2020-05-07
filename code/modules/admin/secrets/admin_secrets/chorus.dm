/datum/admin_secret_item/admin_secret/spawn_as_chorus
	name = "Spawn Chorus"

/datum/admin_secret_item/admin_secret/spawn_as_chorus/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/mob/living/chorus/c = new(get_turf(user))
	c.key = user.key
	qdel(user)