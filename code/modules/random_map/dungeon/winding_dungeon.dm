#define BORDER_CHAR -1
/*basic dungeon algorithm. Based off of http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm (specifically the C++ version).
 *The jist of how the dungeon algorithm works is as follows:
 *Corridors and rooms are both considered features of a dungeon.
 *The dungeon continues to spawn rooms and corridors attached to previously created rooms and corridors (by detecting the walls/floors) until the amount of features is equal to a predefined number.
 *This number is calculated at the beginning of the dungeon. I went with limit_x*limit_y/100. It seems to work well.
 *It is supposed to create a 'winding' aspect to the dungeons. It works.... relatively well?

 *THINGS TO KNOW
 *ARTIFACT_TURF_CHAR is used for room walls, used primarily for code used for corridors.
 *ARTIFACT_TURF is used to mark gaps in walls for rooms - this is checked so that we dont have three corridors in a row. This isn't done for corridors so that we can have branching paths.
 *Rooms will generate a room_theme, a datum that points to a few different types to generate the room with.
 *room_themes will also generate stuff inside. This is a random_room datum.


 *TODO change randomly picking point on map to picking from a list of available spots.
 *make generally more efficient, less repeated code and the like.
*/
/datum/random_map/winding_dungeon
	descriptor = "winding dungeon"
	wall_type = /turf/simulated/mineral/random/chance
	floor_type = /turf/simulated/floor/dirt
	var/room_wall_type = /turf/simulated/mineral/random/chance
	var/border_wall_type = /turf/unsimulated/mineral
	var/door_type = /obj/structure/door/stone

	target_turf_type = /turf/unsimulated/mask

	var/chance_of_room = 65
	var/chance_of_room_empty = 50
	var/chance_of_door = 30
	var/corridor_min_length = 2
	var/corridor_max_length = 6
	var/room_size_min = 4
	var/room_size_max = 8
	var/minimum_monsters = 8
	var/maximum_monsters = 20
	var/minimum_loot = 7
	var/maximum_loot = 10

	var/list/open_positions = list() //organized as: x:y
	var/list/room_themes = list(/datum/room_theme/metal = 1, /datum/room_theme = 3)
	var/list/monsters = list()
	var/list/rooms = list()
	var/log = 0
	limit_x = 50
	limit_y = 50

/datum/random_map/winding_dungeon/proc/logging(var/text)
	if(log)
		log_to_dd(text)

/datum/random_map/winding_dungeon/apply_to_map()
	for(var/datum/room/R in rooms)
		R.apply_to_map(origin_x,origin_y,origin_z,src)
	..()


/datum/random_map/winding_dungeon/generate_map()
	logging("Winding Dungeon Generation Start")
	//first generate the border
	for(var/xx = 1, xx <= limit_x, xx++)
		map[get_map_cell(xx,1)] = BORDER_CHAR
		map[get_map_cell(xx,limit_y)] = BORDER_CHAR
	for(var/yy = 1, yy < limit_y, yy++)
		map[get_map_cell(1,yy)] = BORDER_CHAR
		map[get_map_cell(limit_x,yy)] = BORDER_CHAR

	var/num_of_features = limit_x * limit_y / 100
	logging("Number of features: [num_of_features]")
	var/currentFeatures = 1
	create_room(round(limit_x/2)+1,2,5,5,2)
	var/sanity = 0
	for(sanity = 0, sanity < 1000, sanity++)
		if(currentFeatures == num_of_features)
			break
		var/newx = 0
		var/xmod = 0
		var/newy = 0
		var/ymod = 0
		var/validTile = -1
		for(var/testing = 0, testing < 1000, testing++)
			if(open_positions.len)
				var/list/coords = splittext(pick(open_positions), ":")
				newx = text2num(coords[1])
				newy = text2num(coords[2])
				open_positions -= "[newx]:[newy]"
				logging("Picked coords ([newx],[newy]) from open_positions. Removing it. (length: [open_positions.len])")
			else
				newx = rand(1,limit_x)
				newy = rand(1,limit_y)
				logging("open_positions empty. Using randomly chosen coords ([newx],[newy])")
			validTile = -1

			if(map[get_map_cell(newx, newy)] == ARTIFACT_TURF_CHAR || map[get_map_cell(newx, newy)] == CORRIDOR_TURF_CHAR)
				if(map[get_map_cell(newx,newy+1)] == FLOOR_CHAR || map[get_map_cell(newx,newy+1)] == CORRIDOR_TURF_CHAR)
					validTile = 0
					xmod = 0
					ymod = -1
				else if(map[get_map_cell(newx-1,newy)] == FLOOR_CHAR || map[get_map_cell(newx-1,newy)] == CORRIDOR_TURF_CHAR)
					validTile = 1
					xmod = 1
					ymod = 0
				else if(map[get_map_cell(newx,newy-1)] == FLOOR_CHAR || map[get_map_cell(newx,newy-1)] == CORRIDOR_TURF_CHAR)
					validTile = 2
					xmod = 0
					ymod = 1
				else if(map[get_map_cell(newx+1,newy)] == FLOOR_CHAR || map[get_map_cell(newx+1,newy)] == CORRIDOR_TURF_CHAR)
					validTile = 3
					xmod = -1
					ymod = 0

			if(map[get_map_cell(newx,newy+1)] == ARTIFACT_CHAR || map[get_map_cell(newx-1,newy)] == ARTIFACT_CHAR || map[get_map_cell(newx,newy-1)] == ARTIFACT_CHAR || map[get_map_cell(newx+1,newy)] == ARTIFACT_CHAR)
				logging("Coords ([newx],[newy]) are too close to an ARTIFACT_CHAR position.")
				validTile = -1

			if(validTile > -1)
				logging("Coords ([newx],[newy]) valid. xmod: [xmod], ymod: [ymod]. Attempts at creating a feature: [testing]")
				break
		if(validTile > -1)
			if(rand(0,100) <= chance_of_room)
				var/rw = rand(room_size_min,room_size_max)
				var/rh = rand(room_size_min,room_size_max)
				logging("Creating room of size [rw] by [rh]")
				if(create_room(newx+xmod,newy+ymod,rw,rh,validTile))
					currentFeatures++
					if(rand(0,100) >= chance_of_room_empty)
						create_room_features(newx+xmod,newy+ymod,rw,rh,validTile)
					map[get_map_cell(newx,newy)] = FLOOR_CHAR
					map[get_map_cell(newx+xmod,newy+ymod)] = ARTIFACT_CHAR
				else
					logging("Room invalid. Retrying")

			else
				logging("Creating corridor.")
				if(create_corridor(newx+xmod,newy+ymod,validTile))
					currentFeatures++
					var/door = get_map_cell(newx,newy)
					if(map[door] == ARTIFACT_TURF_CHAR)
						map[door] = ARTIFACT_CHAR
				else
					logging("Corridor invalid.")
	logging("Map completed. Loops: [sanity]")
	open_positions.Cut()

/datum/random_map/winding_dungeon/proc/create_corridor(var/cx, var/cy, var/dir)
	var/length = rand(corridor_min_length,corridor_max_length)
	var/width = 1
	var/height = 1
	var/truex = cx
	var/truey = cy
	switch(dir)
		if(0)
			height = length
			truey = cy - length + 1
		if(1)
			width = length
		if(2)
			height = length
		if(3)
			width = length
			truex = cx - length + 1
	for(var/mode = 0, mode <= 1, mode++)
		for(var/ytemp = truey, ytemp < truey + height, ytemp++)
			if(ytemp < 0 || ytemp > limit_y)
				return 0
			for(var/xtemp = truex, xtemp < truex + width, xtemp++)
				if(!mode)
					if(xtemp < 0 || xtemp > limit_x)
						return 0
					if(map[get_map_cell(xtemp,ytemp)] != WALL_CHAR)
						return 0
				else
					map[get_map_cell(xtemp,ytemp)] = CORRIDOR_TURF_CHAR
					if(!("[xtemp]:[ytemp]" in open_positions))
						open_positions += "[xtemp]:[ytemp]"
						logging("Adding \"[xtemp]:[ytemp]\" to open_positions (length: [open_positions.len])")
	return 1

/datum/random_map/winding_dungeon/proc/create_room(var/rx,var/ry, var/width, var/height, var/dir)
	var/truex = 0
	var/truey = 0
	switch(dir)
		if(0)
			truey = ry - height + 1
			truex = round(rx-width/2)
		if(1)
			truex = rx
			truey = round(ry-height/2)
		if(2)
			truex = round(rx-width/2)
			truey = ry
		if(3)
			truex = rx-width + 1
			truey = round(ry-height/2)
	for(var/mode = 0, mode <= 1, mode++)
		for(var/ytemp = truey, ytemp < truey + height, ytemp++)
			if(ytemp < 1 || ytemp > limit_y)
				return 0
			for(var/xtemp = truex, xtemp < truex + width, xtemp++)
				if(!mode)
					if(xtemp < 1 || xtemp > limit_x)
						return 0
					if(map[get_map_cell(xtemp,ytemp)] != WALL_CHAR)
						return 0
				else
					var/cell = get_map_cell(xtemp,ytemp)
					if(xtemp == truex || xtemp == truex+width-1| ytemp == truey || ytemp == truey+height-1)
						map[cell] = ARTIFACT_TURF_CHAR
						if(!("[xtemp]:[ytemp]" in open_positions))
							open_positions += "[xtemp]:[ytemp]"
							logging("Adding \"[xtemp]:[ytemp]\" to open_positions (length: [open_positions.len])")
					else
						map[cell] = FLOOR_CHAR
	return 1

/datum/random_map/winding_dungeon/proc/create_room_features(var/rox,var/roy,var/width,var/height,var/dir)
	var/truex = 0
	var/truey = 0
	switch(dir)
		if(0)
			truey = roy - height + 1
			truex = round(rox-width/2)
		if(1)
			truex = rox
			truey = round(roy-height/2)
		if(2)
			truex = round(rox-width/2)
			truey = roy
		if(3)
			truex = rox-width + 1
			truey = round(roy-height/2)
	var/theme_type = pickweight(room_themes)
	var/room_theme = new theme_type(origin_x,origin_y,origin_z)
	var/datum/room/R = new(room_theme,truex,truey,width,height,rand(0,100) <= chance_of_door)
	if(!R)
		return 0
	rooms.Add(R)
	return 1

/datum/random_map/winding_dungeon/proc/add_loot(var/rox, var/roy, var/type)
	//TODO

/datum/random_map/winding_dungeon/get_appropriate_path(var/value)
	switch(value)
		if(WALL_CHAR)
			return wall_type
		if(ARTIFACT_TURF_CHAR)
			return room_wall_type
		if(BORDER_CHAR)
			return border_wall_type
		else
			return floor_type

/datum/random_map/winding_dungeon/get_map_char(var/value)
	. = ..(value)
	switch(value)
		if(BORDER_CHAR)
			. = "#"