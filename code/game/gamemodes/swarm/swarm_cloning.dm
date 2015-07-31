/* Swarms use three machines to create things.
The Growing Vat: Creates Swarm from biological matter. Can also heal them (eventually will fix bones/organs individually. Probably not limbs.)

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
	var/biomass = 150
	var/mob/living/containing


//a combination of golem rune and cloning pod. God help us all.
/obj/machinery/swarm/vat/process()
	if(!containing) return
	if(containing.loc == src)
		//we recycle any dead bodies inside.
		if(containing.stat == DEAD)
			src.visible_message("The vat hisses as \the [containing] is dissolved into a vicious grey goo.")
			qdel(containing)
			biomass += 100
			use_power(2000)
			icon_state = "vat_empty"
			return
		var/mob/living/carbon/human/H = containing
		if(istype(H)) //if they are swarm, we heal them
			if(H.species.name == "Swarm")
				//so we are healing now. We gotta make sure we CAN heal
				if(biomass < 5 || containing.health == containing.maxHealth)
					spit_out()
					return
				containing.adjustCloneLoss(-5)
				containing.adjustBrainLoss(-5)
				containing.adjustToxLoss(-5)
				containing.adjustFireLoss(-5)
				containing.adjustBruteLoss(-5)
				containing.adjustOxyLoss(-5)
				biomass -= 5

				return
			else if(prob(10)) //we can also use this to slowly scramble the dna
				randmutb(H)
				H.dna.UpdateSE()
				H.dna.UpdateUI()
		containing.adjustCloneLoss(2)
		containing.adjustBrainLoss(2)
		containing.adjustToxLoss(2)
		containing.adjustFireLoss(2)
		containing.adjustBruteLoss(2)
		containing.adjustOxyLoss(2)
		biomass += 0.2
		// it slowly eats at you otherwise
	return

/obj/machinery/swarm/vat/proc/spawnSwarm(var/client/player)
	if(biomass < 100 || containing) return
	//alright alright. this works pretty much like cloning.

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src,"Swarm")
	containing = H

	H.ckey = player.ckey
	player.mob.mind.transfer_to(H)

	callHook("clone", list(H))
	update_antag_icons(H.mind)

	H.adjustCloneLoss(80)
	H.adjustBrainLoss(80)
	H.Paralyse(8)

	H.updatehealth()



	H << "<span class='notice'><b>You scream internally as you are forced into existance.</i></span>"

	biomass -= 100
	icon_state = "vat_full"
	return H

/obj/machinery/swarm/vat/attack_hand(var/mob/user)
	if(containing)
		user << "[containing] is inside the vat. The vat has [biomass] biomass left."
		return
	user << "The vat has [biomass] biomass left."
	return

/obj/machinery/swarm/vat/attack_ghost(var/mob/user)
	if(containing)
		user << "\the [src] is filled by [containing]."
	else
		var/answer = alert(user.client, "Would you like to spawn as a Swarm?", "Swarm Vat", "Yes", "No")
		if(answer == "Yes")
			spawnSwarm(user.client)
	return
/obj/machinery/swarm/vat/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/weapon/grab))
		if(!ismob(W:affecting))
			return
		if(containing)
			user << "Something is already inside there."
			return

		visible_message("[user] attempts to put [W:affecting] into \the [src].", 3)

		if(do_after(user,20))
			if(containing)
				user << "Something is already inside there."
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
		biomass += F.reagents.total_volume
		user.drop_item()
		src.visible_message("\the [src] bubbles as \the [F] sinks away from view.")
		qdel(F)
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
		src.visible_message("The vat spits out [containing]")
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
		usr << "<span class='warning'>The vat already has something inside it.</span>"
		return

	visible_message("[usr] starts climbing into the vat.", 3)
	if(do_after(usr,20))
		if(containing)
			usr << "<span class='warning'>The vat already has something inside it.</span>"
			return

		put_inside(usr)
	return

//