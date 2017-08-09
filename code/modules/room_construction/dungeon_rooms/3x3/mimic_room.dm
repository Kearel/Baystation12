/decl/room_constructor/dungeon/mimic_room
	spawn_map = {"XXX
				  XMX
				  XXX"}
	construction_map = list("X" = ROOM_EMPTY)

/decl/room_constructor/dungeon/mimic_room/special_instruction(var/turf/pos, var/instruction)
	if(instruction == "M")
		var/obj/structure/closet/C = new(pos)
		if(prob(5))
			new /mob/living/simple_animal/hostile/mimic/sleeping(get_turf(C),C)
		return 1

/decl/room_constructor/dungeon/mimic_room/spawn_loot(var/rx, ry, rz, var/loot_type)
	var/atom/movable/M = ..()
	var/turf/T = get_turf(M)
	for(var/a in T)
		if(istype(a, /obj/structure/closet))
			M.forceMove(a)
			return M
		else if(istype(a, /mob/living/simple_animal/hostile/mimic))
			var/mob/living/simple_animal/hostile/mimic/mimic = a
			M.forceMove(mimic.copy_of.resolve())
			return M