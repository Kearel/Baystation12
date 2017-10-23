/obj/structure/deity/radiant_statue
	name = "radiant statue"
	desc = "A statue pulsing with heat."
	build_cost = 900
	health = 35
	var/time_til_process = 0
	var/charge = 0
	var/pulsing = 0

/obj/structure/deity/radiant_statue/process()
	if(!linked_god || time_til_process > world.time)
		return
	for(var/obj/structure/deity/radiant_statue/s in linked_god.structures)
		if(get_dist(s, src) <= 3)
			stop_charge()
			return
	time_til_process = world.time + 10 SECONDS
	var/list/nearby_friendlies = get_nearby_allies()
	if(pulsing)
		charge -= 10
		for(var/m in nearby_friendlies)
			var/mob/living/L = m
			to_chat(L, "<span class='notice'>You feel refreshed.</span>")
			L.adjustBruteLoss(-10)
			L.adjustFireLoss(-10)
			L.adjustToxLoss(-10)
			L.adjustOxyLoss(-10)
			for(var/s in L.mind.learned_spells)
				var/spell/spell = s
				switch(spell.charge_type)
					if(Sp_RECHARGE)
						spell.charge_counter = min(spell.charge_max, spell.charge_counter += 20)
					if(Sp_CHARGES)
						spell.charge_counter = min(spell.charge_counter + 1, spell.charge_max)
		if(charge <= 0)
			stop_charge()
		else
			src.visible_message("\The [src] pulses with energy.")
	else
		charge += nearby_friendlies.len
		if(charge >= 100)
			pulsing = 1

/obj/structure/deity/radiant_statue/proc/stop_charge()
	pulsing = 0
	src.visible_message("\The [src] lights up before turning off.")
	GLOB.processing_objects -= src

/obj/structure/deity/radiant_statue/proc/get_nearby_allies()
	if(!linked_god)
		return
	. = list()
	var/list/view = oview(2)
	for(var/mob/living/L in view)
		if(linked_god.is_follower(L, silent=1))
			. += L