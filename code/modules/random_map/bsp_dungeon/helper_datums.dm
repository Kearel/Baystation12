/datum/tree_node
	var/datum/bsp_container/value
	var/datum/tree_node/left
	var/datum/tree_node/right
	var/datum/bsp_container/room

/datum/tree_node/New(var/_value)
	value = _value
	..()

/datum/tree_node/proc/get_total_nodes()
	var/list/nodes = list(src)
	if(left)
		nodes += left.get_total_nodes()
	if(right)
		nodes += right.get_total_nodes()
	return nodes

/datum/tree_node/proc/get_ending_nodes()
	if(!left && !right)
		return list(src)
	. = list()
	if(left)
		. += left.get_ending_nodes()
	if(right)
		. += right.get_ending_nodes()

/datum/tree_node/proc/get_room()
	if(room)
		return room
	var/lroom
	var/rroom
	if(left)
		lroom = left.get_room()
	if(right)
		rroom = right.get_room()
	if(!lroom && !rroom)
		return
	else if(!rroom)
		return lroom
	else if(!lroom)
		return rroom
	else if(prob(50))
		return lroom
	return rroom

/datum/tree_node/proc/create_room()
	if(!room)
		room = value.create_room()
	return room

/datum/bsp_container
	var/x
	var/y
	var/width
	var/height

/datum/bsp_container/New(var/_x, var/_y, var/_width, var/_height)
	x = _x
	y = _y
	width = _width
	height = _height
	..()

/datum/bsp_container/proc/split_container(var/min_size)
	var/datum/tree_node/root = new(src)
	var/split_height = prob(50)
	if(width > height && width/height >= BSP_WH_RATIO)
		split_height = 0
	else if(height > width && height/width >= BSP_WH_RATIO)
		split_height = 1
	var/max_split = (split_height ? height : width) - BSP_MIN_SIZE
	if(max_split >= BSP_MIN_SIZE)
		var/datum/bsp_container/cone
		var/datum/bsp_container/ctwo
		var/split = rand(BSP_MIN_SIZE, max_split)
		if(split_height)
			cone = new(x,y,width, split)
			ctwo = new(x,y + split, width, height-split)
		else
			cone = new(x,y,split, height)
			ctwo = new(x + split, y, width-split, height)
		root.left = cone.split_container()
		root.right = ctwo.split_container()
	return root

/datum/bsp_container/proc/create_room()
	var/ww = rand(BSP_MIN_ROOM_SIZE, width-2)
	var/hh = rand(BSP_MIN_ROOM_SIZE, height-2)
	var/xx = x + rand(1, width - ww - 1)
	var/yy = y + rand(1, height - hh - 1)
	return new /datum/bsp_container(xx,yy,ww,hh)