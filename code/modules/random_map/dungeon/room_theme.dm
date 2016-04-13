//room theme is basically the turfs that which a dungeon defaults to making a room out of.
/datum/room_theme
	var/wall_type = /turf/simulated/mineral
	var/floor_type = /turf/simulated/floor/dirt
	var/door_type = /obj/structure/door/stone
	var/xorigin = 1
	var/yorigin = 1
	var/zorigin = 1
	var/lock_complexity_min = 0
	var/lock_complexity_max = 0
	var/lock_data
	var/list/room_layouts = list()

/datum/room_theme/New(var/x,var/y,var/z)
	xorigin = x
	yorigin = y
	zorigin = z
	if(!lock_data)
		lock_data = generateRandomString(rand(lock_complexity_min,lock_complexity_max))

/datum/room_theme/proc/apply_room_theme(var/x,var/y,var/value)
	var/turf/T = locate(x,y,zorigin)
	if(!T)
		return 0
	var/path
	switch(value)
		if(WALL_CHAR)
			path = wall_type
		if(ARTIFACT_TURF_CHAR)
			path = wall_type
		else
			path = floor_type
	T.ChangeTurf(path)

/datum/room_theme/proc/apply_room_door(var/x,var/y)
	var/turf/T = locate(xorigin+x-1,yorigin+y-1,zorigin)
	if(!T)
		return 0
	if(ispath(door_type,/obj/structure/door))
		new door_type(T,null,lock_data)
	else
		new door_type(T)

/datum/room_theme/proc/get_a_room_layout()
	return pickweight(room_layouts)

/datum/room_theme/metal
	wall_type = /turf/simulated/wall
	floor_type = /turf/simulated/floor/plating
	door_type = /obj/structure/door/iron
	room_layouts = list(/datum/random_room/drop_items/clothing = 1)
	lock_complexity_max = 2