//////////////////////Scrying orb//////////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/user as mob)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		user << "<span class='warning'>You stare into the orb and see nothing but your own reflection.</span>"
		return

	user << "<span class='info'>You can see... everything!</span>"
	visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

	user.teleop = user.ghostize(1)
	announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
	return

/////////////////////Familiar Book////////////////////
/obj/item/weapon/monster_manual
	name = "monster manual"
	desc = "A book detailing various magical creatures."
	icon = 'icons/obj/library.dmi'
	icon_state = "anomaly"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	var/uses = 1
	var/list/monster = list(/mob/living/simple_animal/familiar/pet/cat,
							/mob/living/simple_animal/familiar/pet/mouse,
							/mob/living/simple_animal/familiar/carcinus,
							/mob/living/simple_animal/familiar/horror,
							/mob/living/simple_animal/familiar/minor_amaros
							)
	var/list/monster_info = list(   "<b>Black Cat</b> - It is well known that the blackest of cats make good familiars.",
									"<b>Mouse</b> - Mice are full of mischief and magic. A simple animal, yes, but one of the wizard's finest.",
									"<b>Carcinus</b> - A mortal decendant of the original Carcinus, it is said their shells are near impenetrable and their claws as sharp as knives.",
									"<b>Horror</b> - The physical embodiment of flesh and decay, its made from the reanimated corpse of a murdered man.",
									"<b>Minor Amaros</b> - A small magical creature known for its healing powers and pacifist ways."
									)

/obj/item/weapon/monster_manual/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/weapon/monster_manual/interact(mob/user as mob)
	var/dat = "<center><h3>Monster Manual</h3>You have [uses] uses left.</center>"
	for(var/i=1;i<=monster_info.len;i++)
		dat += "<BR><a href='byond://?src=\ref[src];path=[monster[i]]'>[monster_info[i]]</a></BR>"
	user << browse(dat,"window=monstermanual")
	onclose(user,"monstermanual")

/obj/item/weapon/monster_manual/Topic(href, href_list)
	..()
	if(href_list["path"])
		if(uses == 0)
			usr << "This book is out of uses."
			return
		var/client/C = get_player()
		if(!C)
			usr << "You were unsuccessful summoning a familiar."
			return

		var path = text2path(href_list["path"])
		if(!ispath(path))
			usr << "Invalid mob path in [src]. Contact a coder."
			return


		var/mob/living/simple_animal/familiar/F = new path(get_turf(src))
		F.ckey = C.ckey
		F.add_spell(new /spell/return_master(usr),"const_spell_ready")
		if(C.mob && C.mob.mind)
			C.mob.mind.transfer_to(F)
		F << "<B>You are [F], a familiar to [usr]. He is your master and your friend. Aid him in his wizarding duties to the best of your ability.</B>"
		uses--

	src.updateDialog()

/obj/item/weapon/monster_manual/proc/get_player()
	for(var/mob/O in dead_mob_list)
		if(O.client)
			var/getResponse = alert(O,"A wizard is requesting a familiar. Would you like to play as one?", "Wizard familiar summons","Yes","No")
			if(getResponse == "Yes")
				return O.client
	return null