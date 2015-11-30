/spell/return_master
	name = "Return to Master"
	desc = "Teleport back to your master"

	school = "abjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	cooldown_min = 200

	smoke_spread = 1
	smoke_amt = 5

	hud_state = "wiz_tele"

	var/mob/master

/spell/return_master/New(var/mob/M)
	..()
	master = M

/spell/return_master/choose_targets()
	return list(master)

/spell/return_master/cast(mob/target,mob/user)
	if(!master)
		user << "<span class='warning'>You do not have a master.</span>"
		return

	if(istype(target,/list))
		target = target[1]

	user.forceMove(get_turf(target))