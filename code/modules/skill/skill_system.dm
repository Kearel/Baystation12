/datum/skill_system
	var/skill_point = 0
	var/list/skills = list()

/datum/skill_system/proc/get_skill(var/name = "")
	for(var/datum/skill/S in skills)
		if(cmptext(S.name,name))
			return S
	return null

/datum/skill_system/proc/do_after(var/mob/user as mob, delay as num, delay_bonus as num, var/name = "", var/allow_untrained = 0, var/numticks = 5, var/needhand = 1, )
	var/S = get_skill(name)
	if(!S && !allow_untrained)
		return -1

	return do_after_skill(user,delay,delay_bonus,S,numticks,needhand)

/datum/skill_system/proc/get_skill_level(var/name = "")
	var/datum/skill/S = get_skill(name)
	if(!S)
		return 0
	return S.level


/mob
	var/datum/skill_system/skill_system = new()

/mob/proc/skill_check_by_name(var/skill,var/dc, var/allow_untrained = 0)
	var/datum/skill/S = src.skill_system.get_skill(skill)
	src.skill_check(S,dc,allow_untrained)

/mob/proc/skill_check(var/datum/skill/S,var/dc, var/allow_untrained = 0)
	var/bonus = 0
	if(S)
		bonus = S.get_skill_bonus()
	else if(!allow_untrained)
		return -1
	return dc <= roll("1d20") + bonus