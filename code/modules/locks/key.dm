/obj/item/weapon/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items.dmi'
	icon_state = "keys"
	var/key_data = ""

/obj/item/weapon/key/New(var/newloc,var/data)
	if(data)
		key_data = data
	..(newloc)