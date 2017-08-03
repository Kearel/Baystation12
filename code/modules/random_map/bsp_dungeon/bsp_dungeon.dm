/datum/random_map/bsp_dungeon
	var/num_of_iterations = 5
	var/datum/tree_node/root
	var/list/rooms = list()

/datum/random_map/bsp_dungeon/generate_map()
	var/datum/bsp_container/room_container = new(origin_x, origin_y, limit_x, limit_y)
	root = room_container.split_container(num_of_iterations)
	for(var/t in root.get_ending_nodes())
		var/datum/tree_node/node = t
		var/datum/bsp_container/container = node.value
		rooms += container.create_room()

	for(var/r in rooms)
		var/datum/bsp_container/room = r
		for(var/i in 0 to room.width)
			for(var/j in 0 to room.height)
				var/current_cell = get_map_cell(i + room.x, j + room.y)
				map[current_cell] = FLOOR_CHAR