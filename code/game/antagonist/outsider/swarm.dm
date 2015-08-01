var/datum/antagonist/swarm/swarmians

/datum/antagonist/swarm
	id = MODE_SWARM
	role_text = "Swarm"
	role_text_plural = "Swarm"
	bantype = "operative"
	landmark_id = "swarmspawn"
	welcome_text = "You are forced into existance with only one thought screaming in your head: March."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT

/datum/antagonist/swarm/New()
	..()
	swarmians = src

/datum/antagonist/swarm/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return

	//we cycle through the positions
	for(var/spawnpos = 1; spawnpos < starting_locations.len; spawnpos++)

		//we check to see if any of the vats aren't already occupied
		for(var/obj/machinery/swarm/vat/V in starting_locations[spawnpos])

			V.spawn_damage(mob) //regardless of whether it holds them or not, we want to use the vat
			// to simulate the damage from 'existing'

			if(!V.containing)
				V.put_inside(mob)
				return
			break //there should only be one per tile, so going through the rest of the turf's contents wouldn't do anything

	//if we can't find an empty one we dump 'em on one of the spawn points
	mob.loc = pick(starting_locations)