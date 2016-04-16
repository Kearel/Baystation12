/datum/random_room/mimic
	var/mimic_type = /obj/structure/closet/crate
	var/list/mimic_vars = list()
	var/chance_of_mimic = 5

/datum/random_room/mimic/apply_to_map(var/xorigin,var/yorigin,var/zorigin)
	var/truex = xorigin + x - 1
	var/truey = yorigin + y - 1
	var/turf/T = locate(truex + round(width/2), truey+round(height/2), zorigin)
	var/obj/structure/closet/C = new mimic_type(T)
	if(prob(chance_of_mimic) && mimic_type)
		new /mob/living/simple_animal/hostile/mimic/copy/sleeping(get_turf(C),C)



/datum/random_room/mimic/apply_loot(var/xorigin = 1,var/yorigin = 1,var/zorigin = 1, var/type)
	var/truex = xorigin + x - 1
	var/truey = yorigin + y - 1
	if(!mimic_type || !type)
		return 0
	var/obj/structure/closet/C

	var/turf/T = locate(truex + round(width/2), truey+round(height/2), zorigin)
	for(var/obj/structure/closet/O in T.contents)
		C = O
	if(!C)
		for(var/mob/M in T.contents)
			for(var/obj/structure/closet/O in M.contents)
				C = O
				break
	if(!C)
		return 0
	if(prob(C.contents.len * 25)) //25% chance per object already in there. So a max of 4 objects.
		return 0
	new type(C)
	return 1

//BASICALLY:
//Create mimic in center of room.
//put loot inside said mimic


//dont want to keep references to said mimic or closet. Would cause qdel issues.
//so since we know nothing should get moved since we placed it we just find it again.
//inefficient yes but will not cause issues with qdel