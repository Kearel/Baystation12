/datum/random_room/tomb/
	var/list/corpses = list(/obj/effect/landmark/mobcorpse/tomb)
	var/direction = 0 //0 horizontal 1 vertical
	var/chance_of_corpse = 30



//attempts to line the walls with coffins with corpses inside
/datum/random_room/tomb/apply_to_map(var/xorigin, var/yorigin, var/zorigin)
	direction = pick(0,1)
	var/limit = (direction ? height : width)
	for(var/i = 0, i < limit - 2, i++)
		var/truex = xorigin + (direction ? 0 : i) + x
		var/truey = yorigin + (direction ? i : 0) + y
		var/turf/T1 = locate(truex,truey,zorigin)
		var/turf/T2 = locate(truex + (direction ? width - 3 : 0), truey + (direction ? 0 : height - 3), zorigin)
		var/turf/check = locate(truex + (direction ? -1 : 0), truey + (direction ? 0 : -1), zorigin)
		if(check.density && !T1.density && !T1.contents.len)
			var/obj/structure/closet/coffin/C1 = new(T1)
			if(prob(chance_of_corpse))
				var/type = pickweight(corpses)
				new type(C1)
		check = locate(truex + (direction ? width - 2 : 0), truey + (direction ? 0 : height - 2), zorigin)
		if(check.density && !T2.density && !T2.contents.len)
			var/obj/structure/closet/coffin/C2 = new(T2)
			if(prob(chance_of_corpse))
				var/type = pickweight(corpses)
				new type(C2)

/datum/random_room/tomb/apply_loot(var/xorigin = 1,var/yorigin = 1,var/zorigin = 1, var/type)
	var/number = rand(0, (direction ? height : width) -2 ) //get the coffin we want to put this in.
	var/side = pick(0,1)

	var/truex = xorigin + (direction ? (side ? width - 3 : 0) : number) + x
	var/truey = yorigin + (direction ? number : (side ? height - 3 : 0)) + y
	var/turf/T = locate(truex,truey,zorigin)
	for(var/obj/structure/closet/coffin/C in T.contents)
		if(!C.contents.len || prob(C.contents.len * 15))
			return 0
		//ok we have our coffin. Now we just have to either put the item into the coffin
		//or equip it to some poor sap within
		var/obj/item/O = new type(C)
		if(!istype(O)) //if its a mob then we are done here.
			return 1
		for(var/mob/living/carbon/human/H in C.contents)
			if(H.equip_to_slot_if_possible(O))
				break
		return 1
	return 0

/obj/effect/landmark/mobcorpse/tomb
	husk = 1