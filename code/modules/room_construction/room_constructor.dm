#define ROOM_EMPTY "room_empty"
#define ROOM_MONSTER_SPAWN "room_monster"
#define ROOM_LOOT_SPAWN "room_loot"

/decl/room_constructor
	var/spawn_map
	var/list/construction_map
	var/list/variable_sets

/decl/room_constructor/New()
	..()
	spawn_map = replace_characters(spawn_map, list("	" = "", " " = "")) //Get rid of orientation characters

/decl/room_constructor/proc/spawn_room(var/turf/T)
	if(spawn_map)
		var/turf/target = T
		for(var/count in 1 to length(spawn_map))
			var/instruction = copytext(spawn_map, count, count+1)
			switch(instruction)
				if("\n")
					target = locate(T.x, target.y-1, T.z)
				else
					spawn_target(target, instruction)
					target = get_step(target, EAST)
	else
		CRASH("[src.type] does not have a spawn map")

/decl/room_constructor/proc/spawn_room_pos(var/x, var/y, var/z)
	var/turf/T = locate(x,y,z)
	return spawn_room(T)

/decl/room_constructor/proc/spawn_target(var/turf/pos, var/instruction)
	. = 0
	if(construction_map && construction_map[instruction])
		. = 1
		var/list/construction = construction_map[instruction]

		for(var/type in construction)
			if(!istext(type)) //assuming its some kind of constant
				var/atom/M
				if(ispath(type, /turf))
					M = pos.ChangeTurf(type)
				else
					M = new type(pos)
				if(construction[type] && variable_sets && variable_sets.len && variable_sets[construction[type]])
					var/list/vars = variable_sets[construction[type]]
					if(vars)
						for(var/V in vars)
							if(M.vars[V])
								M.vars[V] = vars[V]
							else
								CRASH("[V] is not a valid variable in [M]")

	if(special_instruction(pos, instruction))
		. = 1

	if(!.)
		CRASH("[instruction] is not a valid instruction for [src.type]")

/decl/room_constructor/proc/special_instruction(var/turf/pos, var/instruction)
	return 0


/decl/room_constructor/dungeon
	var/list/monster_spawns = list()
	var/list/loot_spawns = list()

/decl/room_constructor/dungeon/New()
	..()
	generate_spawns()

/decl/room_constructor/dungeon/proc/generate_spawns()
	if(construction_map && construction_map.len)
		var/w = 0
		var/h = 0
		for(var/instruction in construction_map)
			if(instruction == "\n")
				w = 0
				h++
			var/list/construction = construction_map[instruction]
			if(ROOM_MONSTER_SPAWN in construction)
				monster_spawns += "[w]:[h]"
			if(ROOM_LOOT_SPAWN in construction)
				loot_spawns += "[w]:[h]"
			w++


/decl/room_constructor/dungeon/proc/get_location_from_entry(var/bx, var/by, var/bz, var/entry)
	var/list/string_loc = splittext(entry, ":")
	bx += text2num(string_loc[1])
	by += text2num(string_loc[2])

	var/turf/T = locate(bx, by, bz)
	return T

/decl/room_constructor/dungeon/proc/spawn_monster(var/rx, ry, rz, var/monster_type)
	if(!monster_spawns)
		return

	var/list/possible_spawns = monster_spawns.Copy()

	var/turf/T
	do
		if(!possible_spawns)
			return
		var/entry = pick(possible_spawns)
		possible_spawns -= entry
		T = get_location_from_entry(rx, ry, rz, possible_spawns)
	while(locate(/mob/living) in T)
	return new monster_type(T)
	if(monster_spawns)
		return new monster_type(get_location_from_entry(rx, ry, rz, monster_spawns))

/decl/room_constructor/dungeon/proc/spawn_loot(var/rx, ry, rz, var/loot_type)
	if(loot_spawns)
		return new loot_type(get_location_from_entry(rx, ry, rz, pick(loot_spawns)))
