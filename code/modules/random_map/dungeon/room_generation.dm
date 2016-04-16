//a basic room generator.
//room should assume that (x,y) is the bottom left corner
//TODO make more content!
/datum/random_room
	var/width = 0
	var/height = 0
	var/x = 0
	var/y = 0

/datum/random_room/New(var/_x,var/_y,var/_width,var/_height)
	width = _width
	height = _height
	x = _x
	y = _y

/datum/random_room/proc/apply_to_map(var/xorigin = 1,var/yorigin = 1,var/zorigin = 1)
	return 1

/datum/random_room/proc/apply_loot(var/xorigin = 1,var/yorigin = 1,var/zorigin = 1, var/type)
	return 1