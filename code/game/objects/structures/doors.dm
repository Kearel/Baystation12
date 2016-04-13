/obj/structure/door
	name = "door"
	density = 1
	anchored = 1

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.

/obj/structure/door/examine(mob/user)
	if(..(user,1) && lock)
		user << "It appears to have a lock."

/obj/structure/door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/door/proc/TemperatureAct(temperature)
	hardness -= material.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHardness()

/obj/structure/door/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	hardness = max(1,round(material.integrity/10))
	icon_state = material.door_icon_base
	name = "[material.display_name] door"
	color = material.icon_colour
	if(material.opacity < 0.5)
		opacity = 0
	else
		opacity = 1
	if(initial_lock_value)
		locked = initial_lock_value
	if(locked)
		lock = new(locked)
	if(material.products_need_process())
		processing_objects |= src
	update_nearby_tiles(need_rebuild=1)

/obj/structure/door/Destroy()
	processing_objects -= src
	update_nearby_tiles()
	..()

/obj/structure/door/get_material()
	return material

/obj/structure/door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return
/*
/obj/structure/door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)
*/
/obj/structure/door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(!material.can_open_material_door(user))
			return
		if(world.time - user.last_bumped <= 60)
			return
		if(lock && lock.isLocked())
			user << "\The [src] is locked."
			return
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
/*	else if(istype(user, /obj/mecha))
		SwitchState()*/

/obj/structure/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/door/proc/Open()
	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]opening",src)
	sleep(10)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]closing",src)
	sleep(10)
	density = 1
	opacity = 1
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/door/update_icon()
	if(state)
		icon_state = "[material.door_icon_base]open"
	else
		icon_state = material.door_icon_base

/obj/structure/door/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/digTool = W
		user << "You start digging the [name]."
		if(do_after(user,digTool.digspeed*hardness) && src)
			user << "You finished digging."
			Dismantle()
	else if(istype(W,/obj/item/weapon/key))
		if(!lock)
			user << "\The [src] doesn't have a lock."
			return
		if(state)
			user << "\The [src] is already open."
			return
		if(isSwitchingStates)
			return
		var/obj/item/weapon/key/K = W
		var/out = lock.toggle(K.key_data)
		switch(out)
			if(1)
				user << "You [lock.isLocked() ? "lock" : "unlock"] \the [src]"
			if(0)
				user << "\The [K] doesn't fit in \the [src]"
	else if(istype(W,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else if(istype(W,/obj/item/weapon)) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force/100
		user << "You hit the [name] with your [W.name]!"
		CheckHardness()
	else
		attack_hand(user)
	return

/obj/structure/door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/door/proc/Dismantle(devastated = 0)
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

/obj/structure/door/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/3),IRRADIATE,0)

/obj/structure/door/iron/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "iron", complexity)

/obj/structure/door/silver/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "silver", complexity)

/obj/structure/door/gold/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "gold", complexity)

/obj/structure/door/uranium/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "uranium", complexity)

/obj/structure/door/sandstone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "sandstone", complexity)

/obj/structure/door/phoron/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "phoron", complexity)

/obj/structure/door/diamond/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "diamond", complexity)

/obj/structure/door/wood/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "wood", complexity)

/obj/structure/door/resin/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "resin", complexity)

/obj/structure/door/cult/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "cult", complexity)

/obj/structure/door/stone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "sandstone", complexity)