/* Swarm machines:
The Growing Vat: Creates Swarm from biological matter. Can also heal them.
The Tube: Makes the biomass and transfers it where it is needed. Very dangerous. Will disintegrate basically anything.
*/

//the vat works like a primordial soup sort of deal. Give it a jolt of electricity and you never know what will come out.

/obj/machinery/swarm/vat
	name = "Growing Vat"
	desc = "This machine spits and spews liquid you would much rather not know the origin of."
	icon = 'icons/obj/swarm.dmi'
	icon_state = "vat_empty"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 50
	active_power_usage = 500
	var/mob/living/containing

	var/obj/machinery/swarm/distillery/connected


//a combination of golem rune and cloning pod. God help us all.
/obj/machinery/swarm/vat/process()
	if(!connected)
		return

	if(!containing) return

	if(containing.loc == src)
		//we recycle any dead bodies inside.
		if(containing.stat == DEAD)
			return
		var/mob/living/carbon/human/H = containing
		if(istype(H)) //if they are swarm, we heal them
			if(H.species.name == "Swarm")
				//so we are healing now. We gotta make sure we CAN heal
				if(connected.biomass < 5 || containing.health == containing.maxHealth)
					spit_out()
					return
				containing.adjustCloneLoss(-5)
				containing.adjustBrainLoss(-5)
				containing.adjustToxLoss(-5)
				containing.adjustFireLoss(-5)
				containing.adjustBruteLoss(-5)
				containing.adjustOxyLoss(-5)
				connected.biomass -= 5
	return

/obj/machinery/swarm/vat/proc/spawn_damage(var/mob/living/carbon/human/H)
	H.adjustCloneLoss(80)
	H.adjustBrainLoss(80)
	log_admin("Something something.")
	//1 good 1 bad max
	randmutb(H)
	randmutg(H)
	H.dna.UpdateSE()
	domutcheck(H, null)
	var/amount = 0
	for(var/obj/item/organ/external/E in H.organs)
		if(prob(5) && (istype(E,/obj/item/organ/external/arm) || istype(E,/obj/item/organ/external/hand) || istype(E,/obj/item/organ/external/foot)) )
			H.organs_by_name[E.limb_name] = null
			H.organs -= E
			for(var/obj/item/organ/external/child in E.children)
				H.organs_by_name[child.limb_name] = null
				H.organs -= child
			amount++
			if(amount == 2) break

	H.updatehealth()

/obj/machinery/swarm/vat/proc/spawn_swarm(var/client/player)
	if(!connected) return
	if(connected.biomass < 100 || containing) return
	//alright alright. this works pretty much like cloning.

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src,"Swarm")
	containing = H

	H.ckey = player.ckey
	player.mob.mind.transfer_to(H)

	callHook("clone", list(H))
	update_antag_icons(H.mind)

	spawn_damage(H)

	H << "<span class='notice'><b>You scream internally as you are forced into existance.</i></span>"

	connected.biomass -= 100
	icon_state = "vat_full"
	return H

/obj/machinery/swarm/vat/attack_hand(var/mob/user)
	if(containing)
		user << "[containing] is inside the vat."
	return

/obj/machinery/swarm/vat/attack_ghost(var/mob/user)
	if(containing)
		user << "\the [src] is filled by [containing]."
	else
		var/answer = alert(user.client, "Would you like to spawn as a Swarm?", "Swarm Vat", "Yes", "No")
		if(answer == "Yes")
			spawn_swarm(user.client)
	return
/obj/machinery/swarm/vat/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/weapon/grab))
		if(!ismob(W:affecting))
			return
		if(containing)
			user << "[containing] is already inside \the [src]."
			return

		visible_message("[user] attempts to put [W:affecting] into \the [src].", 3)

		if(do_after(user,20))
			if(containing)
				user << "[containing] is already inside \the [src]."
				return

			visible_message("[user] puts [W:affecting] into \the [src].", 3)

			put_inside(W:affecting)

			del(W)
		return
	return


/obj/machinery/swarm/vat/verb/eject()
	set name = "Eject Vat"
	set category = "Object"
	set src in oview(1)

	if(src.stat != 0) return

	spit_out()

/obj/machinery/swarm/vat/proc/spit_out()
	if(containing)
		src.visible_message("\the [src] buzzes, spitting out [containing]")
		containing.loc = loc
		if(containing.client)
			containing.client.eye = containing.client.mob
			containing.client.perspective = MOB_PERSPECTIVE

		domutcheck(containing)
		containing = null
		icon_state = "vat_empty"
		update_use_power(1)
	else
		usr << "<span class='warning'>The vat is empty.</span>"
	return

/obj/machinery/swarm/vat/proc/put_inside(var/mob/M)
	M.stop_pulling()
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	containing = M
	icon_state = "vat_full"
	update_use_power(2)

/obj/machinery/swarm/vat/verb/enter()
	set name = "Enter Vat"
	set category = "Object"
	set src in oview(1)

	if(src.stat != 0) return

	if(containing)
		usr << "<span class='warning'>\the [src] already has [containing] inside it.</span>"
		return

	visible_message("[usr] starts climbing into the vat.", 3)
	if(do_after(usr,20))
		if(containing)
			usr << "<span class='warning'>\the [src] already has [containing] inside it.</span>"
			return

		put_inside(usr)
	return

/* This is where the gunk comes from
*/

/obj/machinery/swarm/distillery
	name = "Bio-Distillery Tube"
	desc = "Turns living things into gravy!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = 1
	anchored = 1

	var/biomass = 1000
	var/mob/living/containing

	use_power = 1
	idle_power_usage = 50

/obj/machinery/swarm/distillery/proc/locate_vats()

	for(var/obj/machinery/swarm/vat/V in oview(3))
		V.connected = src

	return

/obj/machinery/swarm/distillery/proc/put_inside(var/mob/M)
	M.stop_pulling()
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	containing = M

/obj/machinery/swarm/distillery/verb/connect()
	set name = "Connect Vats"
	set category = "Object"
	set src in oview(1)

	if(src.stat != 0) return

	locate_vats()


/obj/machinery/swarm/distillery/verb/enter()
	set name = "Enter Bio-Distillery"
	set category = "Object"
	set src in oview(1)

	if(src.stat != 0) return

	if(containing)
		usr << "<span class='warning'>\the [src] already has [containing] inside it.</span>"
		return

	visible_message("[usr] starts climbing into \the [src].", 3)
	if(do_after(usr,20))
		if(containing)
			usr << "<span class='warning'>\the [src] already has [containing] inside it.</span>"
			return

		put_inside(usr)
	return

/obj/machinery/swarm/distillery/verb/exit()
	set name = "Eject Bio-Distillery"
	set category = "Object"
	set src in oview(1)

	if(src.stat != 0) return

	spit_out()

/obj/machinery/swarm/distillery/proc/spit_out()
	if(containing)
		src.visible_message("\the [src] buzzes, spitting out [containing]")
		containing.loc = loc
		if(containing.client)
			containing.client.eye = containing.client.mob
			containing.client.perspective = MOB_PERSPECTIVE

		domutcheck(containing)
		containing = null
	else
		usr << "<span class='warning'>\the [src] is empty.</span>"
	return

/obj/machinery/swarm/distillery/attack_ghost(var/mob/user)
	//EVENTUALLY: Make it so that this only works during swarm game mode.
	locate_vats()


/obj/machinery/swarm/distillery/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/weapon/grab))
		if(!ismob(W:affecting))
			return
		if(containing)
			user << "[containing] is already inside \the [src]."
			return

		visible_message("[user] attempts to put [W:affecting] into \the [src].", 3)

		if(do_after(user,20))
			if(containing)
				user << "[containing] is already inside \the [src]."
				return

			visible_message("[user] puts [W:affecting] into \the [src].", 3)

			put_inside(W:affecting)

			del(W)
		return
	var/obj/item/organ/O = W
	if(istype(O))
		biomass += 10
		user.drop_item()
		src.visible_message("\the [src] bubbles as \the [O] sinks away from view.")
		qdel(O)
	var/obj/item/weapon/reagent_containers/food/F = W
	if(istype(F))
		biomass += round(F.reagents.total_volume/2)
		user.drop_item()
		src.visible_message("\the [src] bubbles as \the [F] sinks away from view.")
		qdel(F)
		return
	return


/obj/machinery/swarm/distillery/process()
	if(!containing) return

	if(containing.stat == DEAD)
		src.visible_message("\the [src] hisses as \the [containing] is dissolved completely.")

		qdel(containing)
		containing = null

		biomass += 100

		return

	//now we disintegrate whatever is inside, slowly.
	containing.adjustBruteLoss(5)
	containing.adjustCloneLoss(5)
	containing.adjustFireLoss(5)
	biomass += 0.2
	var/mob/living/carbon/human/H = containing
	if(prob(15) && istype(H))
		H.custom_pain("Your flesh burns so much!",1)


/* This is where all their "fancy" weapons come from.
Just insert metal.
*/

