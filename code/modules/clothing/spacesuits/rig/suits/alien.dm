/obj/item/weapon/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon_state = "breacher_rig_cheap"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 60, bomb = 70, bio = 100, rad = 50)
	emp_protection = -20
	online_slowdown = 6
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/unathi
	helm_type = /obj/item/clothing/head/helmet/space/rig/unathi
	boot_type = /obj/item/clothing/shoes/magboots/rig/unathi
	glove_type = /obj/item/clothing/gloves/rig/unathi

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(melee = 90, bullet = 90, laser = 90, energy = 90, bomb = 90, bio = 100, rad = 80) //Takes TEN TIMES as much damage to stop someone in a breacher. In exchange, it's slow.
	vision_restriction = TINT_NONE //Still blind when offline. It is fully armoured after all

/obj/item/clothing/head/helmet/space/rig/unathi
	species_restricted = list("Unathi")
	force = 5
	sharp = 1 //poking people with the horn

/obj/item/clothing/suit/space/rig/unathi
	species_restricted = list("Unathi")

/obj/item/clothing/shoes/magboots/rig/unathi
	species_restricted = list("Unathi")

/obj/item/clothing/gloves/rig/unathi
	species_restricted = list("Unathi")


////////////VOX HARDSUITS//////////
/obj/item/weapon/rig/vox
	name = "Vox control module"
	suit_type = "Vox armor"
	armor = list(melee = 60, bullet = 60, laser = 60,energy = 30, bomb = 50, bio = 70, rad = 50)
	emp_protection = -20
	online_slowdown = 5
	offline_slowdown = 15
	siemens_coefficient = 0.6
	allowed = list(/obj/item/weapon/tank)

/obj/item/clothing/head/helmet/space/rig/vox
	species_restricted = list("Vox")

/obj/item/clothing/suit/space/rig/vox
	species_restricted = list("Vox")

/obj/item/clothing/shoes/magboots/rig/vox
	species_restricted = list("Vox")

/obj/item/clothing/gloves/rig/vox
	species_restricted = list("Vox")
	siemens_coefficient = 0
	permeability_coefficient = 0.05

/obj/item/weapon/rig/vox/carapace
	name = "Carapace control module"
	desc = "A small box covered in a bone like shell. If you put your head up to it, you can feel a pulse..."
	suit_type = "Vox carapace armor"
	icon_state = "vox-carapace"
	offline_vision_restriction = TINT_HEAVY

/obj/item/weapon/rig/vox/pressure
	name = "Pressure control module"
	desc = "A small, metal box. If you put your head up to it, you can feel a pulse..."
	suit_type = "Vox pressure armor"
	icon_state = "vox-pressure"

/obj/item/weapon/rig/vox/stealth
	name = "Stealth control module"
	desc = "A small box thats unnaturally hard to look at. If you put your head up to it, you can feel a pulse..."
	suit_type = "Vox stealth armor"
	icon_state = "vox-stealth"

/obj/item/weapon/rig/vox/medical
	name = "Medical control module"
	desc = "A small box. If you put your head up to it, you can feel a rather healthy pulse..."
	suit_type = "Vox medical armor"
	icon_state = "vox-medic"