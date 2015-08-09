/* Magicians like their tarot cards to be a bit magical...er.
*/

/obj/item/weapon/deck/tarot/wizard
	desc = "This deck makes you shudder just looking at it."


//when you draw a card, you get effected!

/obj/item/weapon/deck/tarot/wizard/draw_card()
	var/datum/playingcard/card = cards[1]
	..()
	//now we have to parse it. luckily for us, we can use its name, and its icon to find out what it does.
	if(card.card_icon == "tarot_major")
		//major are each in their own right unique
		usr << "You did something MAJOR in the [card.name] degree!"
		return

	//the rest depends on their number so lets figure out that.
	//to do this, we know that it will be [number] of [suit] so we just take the first word.
	var/list/words = text2list(card.name, " ")
	var/potency = 0
	switch(words[1])
		if("ace") potency = 1
		if("two") potency = 2
		if("three") potency = 3
		if("four") potency = 4
		if("five") potency = 5
		if("six") potency = 6
		if("seven") potency = 7
		if("eight") potency = 8
		if("nine") potency = 9
		if("ten") potency = 10
		if("page") potency = 11
		if("knight") potency = 12
		if("queen") potency = 13
		if("king") potency = 14
		else potency = 0

	if(card.card_icon == "tarot_swords")
		sword(potency,usr)
	if(card.card_icon == "tarot_pentacles")
		pentancle(potency,usr)
	if(card.card_icon == "tarot_cups")
		cup(potency,usr)
	if(card.card_icon == "tarot_wands")
		wand(potency,usr)

/obj/item/weapon/deck/tarot/wizard/proc/wand(var/potency,var/mob/user)
	user << "You feel as if you drew a wand of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/pentancle(var/potency,var/mob/user)
	user << "You feel as if you drew a pentacle of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/cup(var/potency,var/mob/user)
	user << "You feel as if you drew a cup of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/sword(var/potency,var/mob/user)
	user << "You feel as if you drew a sword of potency [potency]!"
	return
