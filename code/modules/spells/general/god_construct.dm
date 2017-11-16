/spell/construction
	name = "Construction"
	desc = "This ability will let you summon a structure of your choosing."

	cast_delay = 10
	charge_max = 100
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	hud_state = "const_wall"
	cast_sound = 'sound/effects/meteorimpact.ogg'

/spell/construction/choose_targets()
	if(connected_god)
		var/list/possible_targets = connected_god.form.get_build_list()
		var/choice = input("Construct to build.", "Construction") as null|anything in possible_targets
		if(!choice)
			return
		var/list/buildable = possible_targets[choice]
		if(locate(/obj/structure/deity) in get_turf(holder))
			return
		charge_max = buildable[CONSTRUCT_SPELL_COST]
		return list(buildable[CONSTRUCT_SPELL_TYPE])


/spell/construction/cast_check(var/skipcharge, var/mob/user, var/list/targets)
	if(!..())
		return 0
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.density)
			to_chat(user, "<span class='warning'>Something here is blocking your construction!</span>")
			return 0
	if(connected_god && !connected_god.near_structure(T))
		to_chat(user, "<span class='warning'>You need to be near an important structure for this to work!</span>")
		return 0
	return 1


/spell/construction/cast(var/target, mob/user)
	if(islist(target))
		target = target[1]
	var/turf/T = get_turf(user)
	new target(T, connected_god)