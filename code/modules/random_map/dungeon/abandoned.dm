/datum/random_map/winding_dungeon/abandoned
	name = "abandoned winding dungeon"
	border_wall_type = /turf/unsimulated/wall
	room_wall_type = /turf/simulated/wall
	wall_type = /turf/simulated/mineral/random/chance
	floor_type = /turf/simulated/floor/tiled

	chance_of_room = 100
	chance_of_door = 100
	room_theme_common = list(/datum/room_theme/abandoned = 1)
	room_theme_uncommon = list(/datum/room_theme/metal = 1, /datum/room_theme/abandoned = 3)
	room_theme_rare = list(/datum/room_theme/metal = 1, /datum/room_theme/metal/secure = 1)

/datum/room_theme/abandoned
	door_type = /obj/machinery/door/airlock