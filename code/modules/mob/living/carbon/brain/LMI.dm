//////// LMI LACE MACHINE INTERFACE
/obj/item/device/lmi
	name = "lace-machine interface"
	desc = "A complex machine interface that connects an active neural lace. It contains an internal speaker the lace can use to communicate."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "lmi_empty"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)
	req_access = list()
	max_health = 150
	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/lace/brainmob = null//The current occupant.
	var/obj/item/organ/internal/stack/brainobj = null	//The current brain organ.
	var/obj/mecha = null//This does not appear to be used outside of reference in mecha.dm.

/obj/item/device/lmi/New()
	. = ..()
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(brainmob)
	ADD_SAVED_VAR(brainobj)

/obj/item/device/lmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		brainmob.loc = brainobj
	if(brainobj)
		brainobj.loc = get_turf(src)
		brainobj = null
		brainmob.container = brainobj
	else
		QDEL_NULL(brainmob)
	return ..()

/obj/item/device/lmi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/organ/internal/stack) && !brainmob) //Time to stick a brain in it --NEO

		var/obj/item/organ/internal/stack/B = O
		if(!B.lacemob)
			to_chat(user, "<span class='notice'>This lace is completely useless to you.</span>")
			return
		if(istype(O, /obj/item/organ/internal/stack/vat))
			to_chat(user, "<span class='warning'>[O] does not fit into [src], and you get the horrifying feeling that it was not meant to.</span>")
			return

		user.visible_message("<span class='notice'>\The [user] sticks \a [O] into \the [src].</span>")

		brainmob = B.lacemob
		B.lacemob = null
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.set_stat(CONSCIOUS)
		brainmob.switch_from_dead_to_living_mob_list() //Update dem lists

		user.drop_item()
		brainobj = O
		brainobj.loc = src

		name = "lace-machine interface ([brainmob.real_name])"
		icon_state = "lmi_full"

		locked = 1

		SSstatistics.add_field("cyborg_mmis_filled",1)

		return

	if((istype(O,/obj/item/weapon/card/id)||istype(O,/obj/item/modular_computer/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the lace holder.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	if(brainmob)
		O.attack(brainmob, user)//Oh noooeeeee
		return
	return ..()

	//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
/obj/item/device/lmi/attack_self(mob/user as mob)
	if(!brainmob)
		to_chat(user, "<span class='warning'>Theirs nothing plugged into the LMI.</span>")
	else if(locked)
		to_chat(user, "<span class='warning'>You try to unplug the lace, but it is clamped into place.</span>")
	else
		to_chat(user, "<span class='notice'>You yank out the lace.</span>")
		var/obj/item/organ/internal/stack/brain
		if (brainobj)	//Pull brain organ out of MMI.
			brainobj.loc = user.loc
			brain = brainobj
			brainobj = null
		else	//Or make a new one if empty.
			brain = new(user.loc)
		brainmob.container = brain//Reset brainmob mmi var.
		brainmob.loc = brain//Throw mob into brain.
		brainmob.remove_from_living_mob_list() //Get outta here
		brain.lacemob = brainmob//Set the brain to use the brainmob
		brainmob = null//Set mmi brainmob var to null

		icon_state = "lmi_empty"
		name = "lace-machine interface"

/obj/item/device/lmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	name = "Lace-Machine Interface: [brainmob.real_name]"
	icon_state = "lmi_full"
	locked = 1
	return

/obj/item/device/lmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)



/obj/item/device/lmi/radio_enabled
	name = "radio-enabled lace-machine interface"
	desc = "A complex machine interface that connects an active neural lace. It contains an internal speaker the lace can use to communicate. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio = null//Let's give it a radio.

/obj/item/device/lmi/radio_enabled/New()
	..()
	radio = new(src)//Spawns a radio inside the MMI.
	radio.broadcasting = 1//So it's broadcasting from the start.

/obj/item/device/lmi/radio_enabled/verb/Toggle_Broadcasting()//Allows the brain to toggle the radio functions.
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "LMI"
	set src = usr.loc//In user location, or in MMI in this case.
	set popup_menu = 0//Will not appear when right clicking.

	if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.broadcasting = radio.broadcasting==1 ? 0 : 1
	to_chat(brainmob, "<span class='notice'>Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting.</span>")

/obj/item/device/lmi/radio_enabled/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "LMI"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")

	radio.listening = radio.listening==1 ? 0 : 1
	to_chat(brainmob, "<span class='notice'>Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast.</span>")

/obj/item/device/lmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(0,10)
	return ..()

