#define ROOM_MONSTER_SPAWN "room_monster"
#define ROOM_LOOT_SPAWN "room_loot"

/decl/room_constructor
	var/spawn_map
	var/list/construction_map

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
			var/atom/M
			if(!istext(type)) //assuming its some kind of constant
				if(ispath(type, /turf))
					M = pos.ChangeTurf(type)
				else
					M = new type(pos)
				var/list/vars = construction[type]
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
	var/list/monster_spawns
	var/list/loot_spawns