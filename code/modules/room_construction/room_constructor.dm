/client/verb/test()
	set category = "TEST"

	var/decl/room_constructor/example/E = new()
	E.spawn_room(get_turf(mob))

/decl/room_constructor
	var/list/spawn_map
	var/list/construction_map
	var/width = 1

/decl/room_constructor/proc/spawn_room(var/turf/T)
	if(spawn_map)
		var/turf/target = T
		for(var/count in 1 to spawn_map.len)
			spawn_target(target, spawn_map[count])
			if(count % width == 0)
				target = locate(T.x, target.y-1, T.z)
			else
				target = get_step(target, EAST)

/decl/room_constructor/proc/spawn_room_pos(var/x, var/y, var/z)
	var/turf/T = locate(x,y,z)
	return spawn_room(T)

/decl/room_constructor/proc/spawn_target(var/turf/pos, var/instruction)
	if(!construction_map  || !construction_map[instruction])
		if(special_instruction(pos,instruction))
			return 1
		CRASH("[instruction] not correct instruction in [src.type]")
		return 0

	var/list/construction = construction_map[instruction]

	for(var/type in construction)
		var/atom/M
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
	return 1



/decl/room_constructor/proc/special_instruction(var/turf/pos, var/instruction)
	return 0

/decl/room_constructor/example
	construction_map = list("M" = list(/turf/space, /mob/living/simple_animal/mouse),
							"I" = list(/turf/space, /mob/living/simple_animal/corgi)
							)
	spawn_map = {"
	MMM
	MIM
	MMM"}
	width = 3