/datum/tree_node
	var/value
	var/datum/tree_node/left
	var/datum/tree_node/right

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

/datum/bsp_container/proc/split_container(var/iteration)
	var/datum/tree_node/root = new(src)
	if(iteration != 0)
		var/datum/bsp_container/cone
		var/datum/bsp_container/ctwo
		if(prob(50))
			cone = new(x,y,round(rand(width/4,width/2)), height)
			ctwo = new(x + cone.width, y, width-cone.width, height)
		else
			cone = new(x,y,width, round(rand(height/4, width/2)))
			ctwo = new(x,y + cone.height, width, height-cone.height)
		root.left = cone.split_container(iteration-1)
		root.right = ctwo.split_container(iteration-1)
	return root

/datum/bsp_container/proc/create_room()
	var/xx = x + rand(1, round(width/3))
	var/yy = y + rand(1, round(height/3))
	var/ww = width - (xx - x) - rand(1, round(width/3))
	var/hh = height - (yy - y) - rand(1, round(height/3))
	world << "=======ROOM ID: \ref[src]========"
	world << "x:[x] y:[y] w:[width] h:[height]"
	world << "xx:[xx] yy:[yy] ww:[ww] hh:[hh]"
	return new /datum/bsp_container(xx,yy,ww,hh)