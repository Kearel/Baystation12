/spell/targeted/torment
	name = "Torment"
	desc = "this spell causes pain to all those in its radius."

	school = "evocation"
	charge_max = 150
	spell_flags = 0
	invocation = "RAI DI KAAL"
	invocation_type = SpI_SHOUT
	range = 5
	cooldown_min = 50
	message = "<span class='danger'>So much pain! All you can hear is screaming!</span>"

	max_targets = 0
	compatible_mobs = list(/mob/living/carbon/human)


/spell/targeted/torment/cast(var/list/targets, var/mob/user)
	gibs(user.loc)
	for(var/mob/living/carbon/human/H in targets)
		H.adjustHalLoss(30)