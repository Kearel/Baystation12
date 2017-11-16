/obj/structure/build_site //This is a structure that the engineer mobs 'activate' to build onto.
	name = "build site"
	desc = "a mix of materials set in preparation for construction of some kind."
	icon = 'icons/obj/cult.dmi'
	var/expected_type
	var/required_build_time = 100
	var/build_time = 0
	var/linked_deity

/obj/structure/build_site/New(var/newloc, var/construction_type, var/deity)
	..(newloc)
	var/atom/a = construction_type
	name = "[name] ([initial(a.name)]"
	icon_state = initial(a.icon_state)
	alpha = 100
	linked_deity = deity

/obj/structure/build_site/proc/build(var/amount)
	build_time += amount
	alpha = 100 + 155 * (build_time/required_build_time)
	if(build_time > required_build_time)
		new expected_type(get_turf(src), linked_deity)
		qdel(src)

/mob/living/simple_animal/deity/engineer
	var/build_per_tick = 1
	var/build_verb = "works"

/mob/living/simple_animal/deity/engineer/order(var/atom/target, var/mob/living/deity/user)
	if(target == src)
		//BUILDMENU
		var/list/buildables = user.form.get_build_list()
		var/choice = input(user,"Construct to build.", "Construction") as null|anything in buildables
		if(choice)
			var/list/building = buildables[choice]
			new /obj/structure/build_site(get_turf(src), building[CONSTRUCT_SPELL_TYPE], user)

/mob/living/simple_animal/deity/engineer/Life()
	. = ..()
	if(.)
		if(istype(target, /obj/structure/build_site))
			if(get_dist(src, target) > 1)
				walk_to(src,target)
			else
				walk(src,0)
				build()

/mob/living/simple_animal/deity/engineer/proc/build_fluff()
	var/obj/structure/build_site/bs = target
	src.visible_message("<span class='notice'>\The [src] [build_verb] \the [bs].</span>")
	if(prob(50))
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)

/mob/living/simple_animal/deity/engineer/proc/build()
	var/obj/structure/build_site/bs = target
	bs.build(build_per_tick)
	build_fluff()