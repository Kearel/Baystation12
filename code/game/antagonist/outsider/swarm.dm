var/datum/antagonist/swarm/swarmians

/datum/antagonist/swarm
	id = MODE_SWARM
	role_text = "Swarm"
	role_text_plural = "Swarm"
	landmark_id = "Swarm-Spawn"
	bantype = "operative"
	leader_welcome_text = "You lead the march. Serve it well."
	welcome_text = "You are a soldier. You are replacable. Respect your leader. Respect the march."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT

/datum/antagonist/swarm/New()
	..()
	swarmians = src

