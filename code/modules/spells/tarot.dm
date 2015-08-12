/* Magicians like their tarot cards to be a bit magical...er.
*/

/obj/item/weapon/deck/tarot/wizard
	desc = "This deck makes you shudder just looking at it."


//when you draw a card, you get effected!

/obj/item/weapon/deck/tarot/wizard/draw_card()
	var/datum/playingcard/card = cards[1]
	..()
	//now we have to parse it. luckily for us, we can use its name, and its icon to find out what it does.
	var/list/words = text2list(card.name, " ")
	var/reversed = findtext(card.name,"reversed")
	var/potency = 0
	if(card.card_icon != "tarot_major")
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
	else
		switch(words[1])
			if("Fool") fool(usr,reversed)
			if("Magician") magician(usr,reversed)
			if("High") highpriestess(usr,reversed)
			if("Empress") empress(usr,reversed)
			if("Emperor") emperor(usr,reversed)
			if("Hierophant") hierophant(usr,reversed)
			if("Lovers") lovers(usr,reversed)
			if("Chariot") chariot(usr,reversed)
			else usr.show_message("Wait a minute... these cards are FAKE!")

	if(card.card_icon == "tarot_swords")
		sword(potency,usr,reversed)
	else if(card.card_icon == "tarot_pentacles")
		pentancle(potency,usr,reversed)
	else if(card.card_icon == "tarot_cups")
		cup(potency,usr,reversed)
	else if(card.card_icon == "tarot_wands")
		wand(potency,usr,reversed)

/obj/item/weapon/deck/tarot/wizard/proc/wand(var/potency,var/mob/living/user,var/reversed)
	user << "You feel as if you drew a wand of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/pentancle(var/potency,var/mob/living/user,var/reversed)
	user << "You feel as if you drew a pentacle of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/cup(var/potency,var/mob/living/user,var/reversed)
	user << "You feel as if you drew a cup of potency [potency]!"
	return

/obj/item/weapon/deck/tarot/wizard/proc/sword(var/potency,var/mob/living/user,var/reversed)
	user << "You feel as if you drew a sword of potency [potency]!"
	return


/obj/item/weapon/deck/tarot/wizard/proc/fool(var/mob/living/user,var/reversed)
	if(!reversed)
		//The Fool is a card all about mania/dilusions.
		//So lets make them drunk, disallusioned, in (fake) pain and maybe a bit dimmer.
		user.show_message("<span class='danger'>You hear someone laughing...</span>")
		user.confused += rand(5,20)
		user.dizziness += rand(5,20)
		user.slurring += rand(5,20)
		user.adjustHalLoss(rand(10,50))
		user.hallucination += rand(5,20)
		if(prob(25))
			user.adjustBrainLoss(rand(0,20))
	else
		//The reverse is negligance, carelessness, apathy
		//This is probably a 'flavor' one. So mechanically nothing.
		user.show_message("<font color='red'>You feel detached, like suddenly you don't care about anything.</font>")

/obj/item/weapon/deck/tarot/wizard/proc/magician(var/mob/living/user,var/reversed)
	if(!reversed)
		//The Magician is about skill, smartness, and pain and loss.

		user.show_message("<font color='blue'>You feel very, very smart. As if everything is crystal clear.</font>")
		user.confused = 0
		user.dizziness = 0
		user.slurring = 0
		//var/mob/living/carbon/human/H = user
		//if(istype(H))
		user.hallucination = 0
		user.adjustHalLoss(rand(-15,5))
		user.adjustBrainLoss(rand(-30,-5))
	else
		//Reversed it represent doctors, magus's and brain disease!
		if(prob(50))
			user.adjustBrainLoss(rand(0,25))
		if(user.mind && prob(5))
			//small chance of wizarding
			if(!jobban_isbanned(user.mind,"wizard"))
				wizards.add_antagonist(user.mind,0,1,0,0,1)
				user.show_message("<font color='blue'>You feel.... magical!</font>")
				return

		user.show_message("<font color='red'>You feel... off. Like something isn't working right.</font>")

/obj/item/weapon/deck/tarot/wizard/proc/highpriestess(var/mob/living/user,var/reversed)
	if(!reversed)
		//The High Priestess is all about mystery! Give them a mysterious message....
		var/msg
		msg += pick("potato","carrot","tajaran","unathi","skrell","gun","knife","food","vox","cake","marriage","dead","poison","medicine","bad","good","death","life","human","meat")
		while(prob(75))
			msg += " "
			msg += pick("potato","carrot","tajaran","unathi","skrell","gun","knife","food","vox","cake","marriage","dead","poison","medicine","bad","good","death","life","human","meat")
		user.show_message("You hear a voice whisper into your ear, <i>[msg].</i>")
	else
		//Reversed, its all about passion! Love! Smarts.
		//Pick a mob for their affection.
		var/list/creatures = list()
		for(var/mob/living/carbon/h in world)
			creatures += h
		var/mob/living/M = pick(creatures)
		user.show_message("<font color='blue'>You feel a sudden passion for [M.name].</font>")

		//heal some brian damage.
		var/mob/living/carbon/human/H = user
		if(istype(H))
			H.adjustBrainLoss(-15)

/obj/item/weapon/deck/tarot/wizard/proc/empress(var/mob/living/user,var/reversed)
	if(!reversed)
		//The Empress is about action and reward! This one should reward them with something.
		user.show_message("You hear something whisper into your ear, <i>'A reward for the lucky one.'</i>")
		var/list/items = typesof(/obj/item/weapon) - /obj/item/weapon/grab
		var/choose = pick(items)
		var/obj/item = new choose
		if(item)
			user.put_in_hands(item)
	else
		//Reversed its about Truth! So... XRAY vision? Xray vision.
		user.show_message("<font color='blue'> It all makes sense now!</font>")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			H.dna.SetSEValue(XRAYBLOCK,1)

/obj/item/weapon/deck/tarot/wizard/proc/emperor(var/mob/living/user,var/reversed)
	if(!reversed)
		//The Emperor is aaaall about POWER and AUTHORITY! Make an ID for them worthy of their splender!
		var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id/captains_spare()
		var/mob/living/carbon/human/H = user
		if(istype(H))
			C.blood_type = H.dna.b_type
			C.dna_hash = H.dna.unique_enzymes
			C.fingerprint_hash = md5(H.dna.uni_identity)

		C.registered_name = user.name
		C.assignment = H.job
		C.name = "[C.registered_name]'s ID Card ([C.assignment])"

		user.put_in_hands(C)
	else
		//Reversed its all about... credit! GIVE THEM MONEY!
		var/obj/item/weapon/spacecash/bundle/cash = new /obj/item/weapon/spacecash/bundle()
		cash.worth = rand(100,100000)
		cash.update_icon()
		user.put_in_hands(cash)
		user.show_message("<i>A loan.... from the Emperor. Spend wisely.</i>")

/obj/item/weapon/deck/tarot/wizard/proc/hierophant(var/mob/living/user,var/reversed)
	if(!reversed)
		//THE HIEROPHANT! All about union, alliance, and servitude! Spawn a friendly creature.
		var/list/simple = typesof(/mob/living/simple_animal) - typesof(/mob/living/simple_animal/hostile)
		var/chosen = pick(simple)
		var/mob/living/simple_animal/L = new chosen

		L.forceMove(user.loc)
		L.name = "Pet [L]"
		L.desc = "It has a little nametag that says 'Owned by [user]'"
		L.visible_message("With a flash of smoke, \the [L] appears below [user]'s feet!")
	else
		//Reversed its about being TOO kind and showing weakness. Lets... put 'em out. I don't know.
		user.show_message("<span class='danger'>You feel very, very weak all of a sudden.</span>")
		user.Weaken(10)

/obj/item/weapon/deck/tarot/wizard/proc/lovers(var/mob/living/user,var/reversed)
	if(!reversed)
		//The lovers is all about... love and beauty. Not much to work with.
		user.visible_message("<span class='good'>\The [user] looks unbearably beautiful.</span>")
	else
		//Reversed its all about FAILURE!
		var/mob/living/carbon/human/H = user
		if(istype(H))
			var/obj/item/organ/O = H.organs_by_name["chest"]
			O.take_damage(rand(1,10),0,0)
		else
			user.adjustBruteLoss(rand(1,10))
			user.visible_message("\The [user] clumsily jabs themselves on the edge of the card. Do you hear laughing?")
			user.show_message("<span class='warning'>Its really deep!</span>")

/obj/item/weapon/deck/tarot/wizard/proc/chariot(var/mob/living/user,var/reversed)
	if(!reversed)
		//The chariot is all about assistance and WAAAAR! Give them an honorable weapon.
		var/list/possibles = typesof(/obj/item/weapon/melee) + typesof(/obj/item/weapon/material) + /obj/item/weapon/sord
		var/chosen = pick(possibles)
		var/obj/item/W = new chosen
		user.show_message("Something whispers into your ear, <i>'You have been chosen. Use it well.'</i>")

		W.name = "Holy [W.name]"
		user.put_in_hands(W)
	else
		//In reverse, its all about RIOTING! Disputing! Anger! make 'em Hulk!
		user.show_message("<alert class='warning'>You feel angry!</alert>")
		var/mob/living/carbon/human/H = user
		if(istype(H))
			H.dna.SetSEValue(HULKBLOCK,1)


