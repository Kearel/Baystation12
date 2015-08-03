/obj/vehicle/swarm/
	name = "space-bike"
	desc = "Designed by Swarm for Swarm. "
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_back_off"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 7

	health = 100
	maxhealth = 100

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5

	var/datum/effect/effect/system/ion_trail_follow/ion
	var/kickstand = 1

/obj/vehicle/swarm/New()
	..()
	ion = new /datum/effect/effect/system/ion_trail_follow()
	ion.set_up(src)
	turn_off()
	overlays += image('icons/obj/bike.dmi', "bike_front_off", MOB_LAYER + 1)

/obj/vehicle/swarm/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat != 0) return

	if(!on)
		turn_on()
		src.visible_message("\the [src] rumbles to life.", "You hear something rumble deeply.")
	else
		turn_off()
		src.visible_message("\the [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/swarm/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat != 0) return

	if(kickstand)
		src.visible_message("You put up \the [src]'s kickstand.")
	else
		if(istype(src.loc,/turf/space))
			usr << "\red You don't think kickstands work in space..."
			return
		src.visible_message("You put down \the [src]'s kickstand.")
		if(pulledby)
			pulledby.stop_pulling()

	kickstand = !kickstand
	anchored = (kickstand || on)

/obj/vehicle/swarm/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/swarm/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		user << "\red You were unable to load [C] on [src]."
		return

/obj/vehicle/swarm/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		user << "You unbuckle yourself from \the [src]"

/obj/vehicle/swarm/relaymove(mob/user, direction)
	if(user != load || !on)
		return
	return Move(get_step(src, direction))

/obj/vehicle/swarm/Move(var/turf/destination)
	if(kickstand) return


	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(istype(destination,/turf/space) || pulledby)
		move_delay = 1
	else
		move_delay = 10
	var ret = ..()
	//overlay.dir = dir
	//update_icon()
	return ret

/obj/vehicle/swarm/turn_on()
	ion.start()
	anchored = 1
	overlays.Cut()
	overlays += image('icons/obj/bike.dmi', "bike_front_on", MOB_LAYER + 1)

	icon_state = "bike_back_on"

	if(pulledby)
		pulledby.stop_pulling()
	..()
/obj/vehicle/swarm/turn_off()
	ion.stop()
	anchored = kickstand

	overlays.Cut()
	overlays += image('icons/obj/bike.dmi', "bike_front_off", MOB_LAYER + 1)

	icon_state = "bike_back_off"
	..()

/obj/vehicle/swarm/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(40))
		buckled_mob.bullet_act(Proj)
		return
	..()