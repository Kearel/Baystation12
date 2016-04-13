

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


/datum/random_room/drop_items
	var/chance_of_item = 10
	var/total_allowed_items = 5
	var/list/items = list()

/datum/random_room/drop_items/apply_to_map(var/xorigin = 1,var/yorigin = 1,var/zorigin = 1)
	var/truex = xorigin + x - 1
	var/truey = yorigin + y - 1
	var/current_num = 0
	for(var/i = 1, i < width-1, i++)
		for(var/j = 1, j < height-1, j++)
			var/turf/T = locate(truex+i,truey+j,zorigin)
			if(!T)
				return 0
			if(rand(0,100) <= chance_of_item)
				current_num++
				var/type = pickweight(items)
				var/obj/O = new type
				O.loc = T
				if(current_num >= total_allowed_items)
					return 1
	return 1

/datum/random_room/drop_items/clothing
	total_allowed_items = 2
	items = list(/obj/item/clothing/suit/armor/vest = 1, /obj/item/clothing/under/rank/cargo = 3)

/datum/random_room/encounter
	var/num_of_monsters_min = 1
	var/num_of_monsters_max = 3
	var/list/monsters = list()

/datum/random_room/encounter/New(var/min,var/max,var/list/mon)
	num_of_monsters_min = min
	num_of_monsters_max = max
	monsters += mon

/datum/random_room/encounter/apply_to_map(var/xorigin = 1, var/yorigin = 1, var/zorigin = 1)
	var/generate_num = rand(num_of_monsters_min,num_of_monsters_max)

	while(generate_num > 0)
		var/mx = xorigin + x + rand(0,width-1)
		var/my = yorigin + y + rand(0,height-1)
		var/turf/T = locate(mx,my,zorigin)
		for(var/mob/M in T)
			continue
		var/type = pickweight(monsters)
		if(!type)
			return 0
		new type(T)