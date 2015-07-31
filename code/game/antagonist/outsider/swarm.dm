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

	//we want to make it seem like they were just cloned, so we simulate the experience
	mob.adjustCloneLoss(80)
	mob.adjustBrainLoss(80)
	mob.Paralyse(8)
	//we cycle through the positions
	for(var/spawnpos = 1; spawnpos < starting_locations.len; spawnpos++)

		//we check to see if any of the vats aren't already occupied
		for(var/obj/machinery/swarm/vat/V in starting_locations[spawnpos])
			if(!V.containing)
				V.put_inside(mob)
				return
			break //there should only be one per tile, so going through the rest of the turf's contents wouldn't do anything

	//if we can't find an empty one we dump 'em on one of the spawn points
	mob.loc = pick(starting_locations)