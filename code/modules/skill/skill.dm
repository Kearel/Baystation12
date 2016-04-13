/datum/skill
	var/name = "Skill"
	var/category = "default"
	var/desc = "Undefined"
	var/level = 0
	var/level_max = 20
	var/bonus = 0

/datum/skill/proc/get_points_per_level(var/lvl)
	return 1

/datum/skill/proc/get_skill_bonus()
	return round(level/2) + bonus

/datum/skill/level/get_points_per_level(var/lvl)
	return lvl

/proc/do_after_skill(var/mob/living/user as mob, delay as num, delay_bonus as num, var/datum/skill/skill, var/dc = 0, var/allow_untrained = 0, var/numticks = 5, var/needhand = 1)
	var/modified_delay = delay_bonus
	if(skill)
		modified_delay = min(delay_bonus,modified_delay * round(skill.level_max/min(skill.level,1)))
	if(!do_after(user,delay + modified_delay,numticks,needhand))
		return 0
	return user.skill_check(skill,dc,allow_untrained)

