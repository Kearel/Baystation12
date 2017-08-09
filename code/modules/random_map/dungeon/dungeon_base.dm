/datum/random_map/dungeon
	var/monster_multiplier = 0.007
	var/loot_multiplier = 0.01
	var/monster_faction = "dungeon" //if set, factions of the mobs spawned will be set to this.
	//without this they will attack each other.

	var/log = 0 //Whether we send log messages to dd
	var/list/room_theme_common = list()
	var/list/room_theme_uncommon = list()
	var/list/room_theme_rare = list()
	var/list/monsters_common = list()
	var/list/monsters_uncommon = list()
	var/list/monsters_rare = list()
	var/list/loot_common = list()
	var/list/loot_uncommon = list()
	var/list/loot_rare = list()

	var/list/monster_available = list()//turfs that monsters can spawn on. Pregenerated to guard against lag.

/datum/random_map/dungeon/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/list/variable_list)
	for(var/variable in variable_list)
		if(variable in src.vars)
			src.vars[variable] = variable_list[variable]
	..()

/datum/random_map/dungeon/proc/get_appropriate_list(var/list/common, var/list/uncommon, var/list/rare, var/loot_upgrade)
	if(prob(loot_upgrade))
		if(prob(max(1,loot_upgrade/100)) && rare && rare.len)
			logging("Returning rare list.")
			return rare
		else if(uncommon && uncommon.len)
			logging("Returning uncommon list.")
			return uncommon
	logging("Returning common list.")
	return common

/datum/random_map/dungeon/proc/spawn_loot()
	var/num_of_loot = round(limit_x * limit_y * loot_multiplier)
	logging("Attempting to add [num_of_loot] # of loot")
	var/sanity = 0
	if((loot_common && loot_common.len) || (loot_uncommon && loot_uncommon.len) || (loot_rare && loot_rare.len)) //no monsters no problem
		while(num_of_loot > 0)
			if(!priority_process)
				sleep(-1)
			var/loot_location = get_loot_location()
			if(!loot_location)
				return
			var/list/loot_list = get_appropriate_list(loot_common, loot_uncommon, loot_rare, calculate_loot_chance(loot_location))
			if(!loot_list || !loot_list.len || place_loot(origin_x, origin_y, origin_z, pickweight(loot_list), loot_location))
				num_of_loot--
				sanity -= 10 //we hahve success so more tries
				continue
			sanity++
			if(sanity > 100)
				logging("Sanity limit reached on loot spawning #[num_of_loot]")
				num_of_loot = 0

/datum/random_map/dungeon/proc/get_loot_location()
	return

/datum/random_map/dungeon/proc/calculate_loot_chance(var/loot_location)
	return 0

/datum/random_map/dungeon/proc/place_loot(var/ox, var/oy, var/oz, var/loot_type, var/loot_location)
	return 0

/datum/random_map/dungeon/proc/place_monsters()
	if((!monsters_common || !monsters_common.len) && (!monsters_uncommon || !monsters_uncommon.len) && (!monsters_rare || !monsters_rare.len)) //no monsters no problem
		logging("No monster lists detected. Not spawning monsters.")
		return

	var/num_of_monsters = round(limit_x * limit_y * monster_multiplier)
	logging("Attempting to add [num_of_monsters] # of monsters")

	while(num_of_monsters > 0)
		if(!priority_process)
			sleep(-1)
		if(!monster_available || !monster_available.len)
			logging("There are no available turfs left.")
			num_of_monsters = 0
			continue
		var/turf/T = pick(monster_available)
		monster_available -= T
		var/list/monster_list = get_appropriate_list(monsters_common, monsters_uncommon, monsters_rare, T.x, T.y)
		if(monster_list && monster_list.len)
			var/type = pickweight(monster_list)
			logging("Generating a monster of type [type] at position ([T.x],[T.y],[origin_z])")
			var/mob/M = new type(T)
			if(monster_faction)
				M.faction = monster_faction
		else
			logging("The monster list is empty.")
		num_of_monsters--

	monster_available = null //Get rid of all the references

/datum/random_map/dungeon/apply_to_turf(var/x, var/y)
	. = ..()
	var/turf/T = locate((origin_x-1)+x,(origin_y-1)+y,origin_z)
	if(T && !T.density)
		var/can = 1
		for(var/atom/movable/M in T)
			if(istype(M,/mob/living) || M.density)
				can = 0
				break
		if(can)
			monster_available += T

/datum/random_map/dungeon/proc/logging(var/text)
	if(log)
		log_to_dd(text)