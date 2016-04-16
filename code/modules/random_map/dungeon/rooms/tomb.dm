/datum/random_room/tomb/
	var/list/corpses = list(/obj/effect/landmark/mobcorpse)
	var/direction = 0 //0 horizontal 1 vertical
	var/chance_of_corpse = 90


/datum/random_room/tomb/apply_to_map(var/xorigin, var/yorigin, var/zorigin)

	direction = pick(0,1)
	var/limit = (direction ? height : width)
	for(var/i = 0, i < limit - 2, i++)
		var/truex = xorigin + (direction ? 0 : i) + x
		var/truey = yorigin + (direction ? i : 0) + y
		var/turf/T1 = locate(truex,truey,zorigin)
		var/turf/T2 = locate(truex + (direction ? width - 3 : 0), truey + (direction ? 0 : height - 3), zorigin)
		var/obj/structure/closet/coffin/C1 = new(T1)
		var/obj/structure/closet/coffin/C2 = new(T2)
		if(prob(chance_of_corpse))
			var/type = pickweight(corpses)
			new type(C1)
		if(prob(chance_of_corpse))
			var/type = pickweight(corpses)
			new type(C2)