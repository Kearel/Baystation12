#define BSP_MIN_SIZE 6
#define BSP_WH_RATIO 1.25
#define BSP_MIN_ROOM_SIZE 3

/datum/random_map/dungeon/bsp_dungeon
	var/datum/tree_node/root
	var/list/rooms = list()
	var/list/corridors = list()
	wall_type = /turf/simulated/wall/voxshuttle
	floor_type = /turf/simulated/floor/tiled
	target_turf_type = /turf/unsimulated/mask
	room_theme_common = list(/decl/room_constructor/dungeon/mimic_room = 10)

/datum/random_map/dungeon/bsp_dungeon/generate_map()
	var/datum/bsp_container/room_container = new(origin_x, origin_y, limit_x, limit_y)
	root = room_container.split_container()

	create_room(root)

	for(var/r in rooms + corridors)
		var/datum/bsp_container/room = r
		for(var/i in 0 to room.width-1)
			for(var/j in 0 to room.height-1)
				var/current_cell = get_map_cell(i + room.x, j + room.y)
				if(!isnull(current_cell))
					map[current_cell] = FLOOR_CHAR

/datum/random_map/dungeon/bsp_dungeon/apply_to_map()
	logging("Generating [rooms.len] rooms.")
	for(var/d in rooms)
		var/datum/bsp_container/room = d
		var/decl/room_constructor/dungeon/theme
		var/fits = 0
		var/sanity = 100
		var/ox = 0
		var/oy = 0
		do
			sanity--
			if(sanity == 0)
				logging("Sanity limit was reached on room [d]")
				continue
			theme = decls_repository.get_decl(pick(get_appropriate_list(room_theme_common, room_theme_uncommon, room_theme_rare, 45)))
			var/list/size = theme.get_size()
			if(size["width"] <= room.width && size["height"] <= room.height)
				fits = 1
				ox = room.width - size["width"]
				oy = room.height - size["height"]
		while(!fits)
		var/midx = room.x + rand(ox)
		var/midy = room.y + rand(oy)
		theme.spawn_room_pos(midx + origin_x, midy + origin_y, origin_z)
	..()

/datum/random_map/dungeon/bsp_dungeon/proc/create_room(var/datum/tree_node/node)
	if(node.left || node.right)
		if(node.left)
			create_room(node.left)
		if(node.right)
			create_room(node.right)
		if(node.left && node.right)
			var/corridor = create_corridor(node.left.get_room(), node.right.get_room())
			if(corridor)
				corridors += corridor
	else
		rooms += node.create_room()


//Take two points within the two rooms and then
//Find the a way to have up to two straight lines to meet those points.
/datum/random_map/dungeon/bsp_dungeon/proc/create_corridor(var/datum/bsp_container/lroom, var/datum/bsp_container/rroom)
	var/w1 = rand(lroom.x + 1, lroom.x + lroom.width - 2)
	var/w2 = rand(rroom.x + 1, rroom.x + rroom.width - 2)
	var/h1 = rand(lroom.y + 1, lroom.y + lroom.height - 2)
	var/h2 = rand(rroom.y + 1, rroom.y + rroom.height - 2)

	var/ww = w2 - w1
	var/hh = h2 - h1
	if(ww < 0)
		if(hh < 0)
			if(prob(50))
				corridors += new /datum/bsp_container(w2,h1,abs(ww),1)
				corridors += new /datum/bsp_container(w2,h2,1,abs(hh))
			else
				corridors += new /datum/bsp_container(w2,h2,abs(ww),1)
				corridors += new /datum/bsp_container(w1, h2, 1, abs(ww))
		else if(hh > 0)
			if(prob(50))
				corridors += new /datum/bsp_container(w2, h1, abs(ww), 1)
				corridors += new /datum/bsp_container(w2, h1, 1, abs(hh))
			else
				corridors += new /datum/bsp_container(w2, h2, abs(ww), 1)
				corridors += new /datum/bsp_container(w1, h1, 1, abs(hh))
		else
			corridors += new /datum/bsp_container(w2, h2, abs(ww), 1)
	else if(ww > 0)
		if(hh < 0)
			if(prob(50))
				corridors += new /datum/bsp_container(w1,h2,abs(ww),1)
				corridors += new /datum/bsp_container(w1,h2,1,abs(hh))
			else
				corridors += new /datum/bsp_container(w1,h1,abs(ww),1)
				corridors += new /datum/bsp_container(w2, h2, 1, abs(ww))
		else if(hh > 0)
			if(prob(50))
				corridors += new /datum/bsp_container(w1, h1, abs(ww), 1)
				corridors += new /datum/bsp_container(w2, h1, 1, abs(hh))
			else
				corridors += new /datum/bsp_container(w1, h2, abs(ww), 1)
				corridors += new /datum/bsp_container(w1, h1, 1, abs(hh))
		else
			corridors += new /datum/bsp_container(w1, h1, abs(ww), 1)
	else
		if(hh < 0)
			corridors += new /datum/bsp_container(w2,h2,1,abs(hh))
		else if(hh > 0)
			corridors += new /datum/bsp_container(w1, w2, 1, abs(hh))
	return