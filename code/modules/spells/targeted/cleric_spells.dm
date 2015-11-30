/spell/targeted/heal_target
	name = "cure light wounds"
	desc = "a rudimentary spell used mainly by wizards to heal papercuts."

	school = "cleric"
	charge_max = 100
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Di'Nath"
	invocation_type = SpI_SHOUT
	range = 2
	max_targets = 1
	cooldown_min = 50
	hud_state = "heal_minor"

	amt_dam_brute = -6
	amt_dam_fire = -1

	message = "You feel a pleasant rush of heat move through your body."


/spell/targeted/heal_target/major
	name = "cure major wounds"
	desc = "A spell used to fix others that cannot be fixed with regular medicine."

	charge_max = 300
	spell_flags = SELECTABLE
	invocation = "Borv Di'Nath"
	range = 1
	cooldown_min = 100
	hud_state = "heal_major"

	amt_dam_brute = -15
	amt_dam_fire  = -5

	message = "Your body feels like a furnace."

/spell/targeted/heal_target/area
	name = "cure area"
	desc = "This spell heals everyone in an area."

	charge_max = 600
	spell_flags = INCLUDEUSER
	invocation = "Nal Di'Nath"
	range = 2
	max_targets = 0
	cooldown_min = 300
	hud_state = "heal_area"

	amt_dam_brute = -7
	amt_dam_fire = -7