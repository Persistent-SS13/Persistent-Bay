/obj/item/weapon/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(MATERIAL_STEEL = 100)

/obj/item/weapon/hand_labeler/attack()
	return

/obj/item/weapon/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode && findtext(A.name, "("))  // if its off and target is labeled, unlabel it anyway
		A.name = copytext(A.name, 1, findtext(A.name, "(")-1) //Remove any labels
		
		user.visible_message("<span class='notice'>[user] removes the label from [A].</span>", \
							 "<span class='notice'>You remove the label from [A].</span>")
		
		return
	if(!mode)	//if it's off and the target isn't labeled, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, "<span class='notice'>No labels left.</span>")
		return
	if(!label || !length(label))
		to_chat(user, "<span class='notice'>No text set.</span>")
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, "<span class='notice'>Label too big.</span>")
		return
	if(ishuman(A))
		to_chat(user, "<span class='notice'>The label refuses to stick to [A.name].</span>")
		return
	if(issilicon(A))
		to_chat(user, "<span class='notice'>The label refuses to stick to [A.name].</span>")
		return
	if(isobserver(A))
		to_chat(user, "<span class='notice'>[src] passes through [A.name].</span>")
		return
	if(istype(A, /obj/item/weapon/reagent_containers/glass))
		to_chat(user, "<span class='notice'>The label can't stick to the [A.name].  (Try using a pen)</span>")
		return
	if(istype(A, /obj/item/weapon/card/id))
		to_chat(user, "<span class='notice'>The label refuses to stick to [A.name].</span>")
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			to_chat(user, "<span class='notice'>How are you going to label that?</span>")
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()

	if(findtext(A.name, "(")) //Check if the item is already labeled
		A.name = copytext(A.name, 1, findtext(A.name, "(")-1) //Remove any labels

		user.visible_message("<span class='notice'>[user] removes the label from [A].</span>", \
							 "<span class='notice'>You remove the label from [A].</span>")
		return

	user.visible_message("<span class='notice'>[user] labels [A] as [label].</span>", \
						 "<span class='notice'>You label [A] as [label].</span>")
	A.name = "[A.name] ([label])"

/obj/item/weapon/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, "<span class='notice'>Invalid text.</span>")
			return
		label = str
		to_chat(user, "<span class='notice'>You set the text to '[str]'.</span>")
	else
		to_chat(user, "<span class='notice'>You turn off \the [src].</span>")

/obj/item/weapon/hand_labeler/admin_delabeler
	name = "ADMIN bluespace delabeler"
	desc = "After the infamous 'Ligger Incident', Nanotrasen issued this high-powered bluespace delabeler to special response teams. It will delabel not just the target object, but anything else in the sector that bears the same label."
	icon_state = "labeler0"

/obj/item/weapon/hand_labeler/admin_delabeler/afterattack(atom/A, mob/user as mob, proximity)

	if(!check_rights(R_DEBUG|R_SERVER))	return

	if(findtext(A.name, "(")) //Check if the item is already labeled
		var badlabel = copytext(A.name, findtext(A.name, "("), 0) // If so, memorize its label
		var i = 0

		for(var/obj/Obj in world)
			if(Obj.name && findtext(Obj.name, badlabel)) // If the bad label can be found
				Obj.name = copytext(Obj.name, 1, findtext(Obj.name, "(")-1) // Remove the label from the object
				i++

		for(var/turf/T in world)
			if(T.name && findtext(T.name, badlabel)) // If the bad label can be found
				T.name = copytext(T.name, 1, findtext(T.name, "(")-1) // Remove the label from the turf
				i++

		log_admin("[key_name(user)] used the bluespace delabeler against the following: [badlabel] ([i] objects delabeled)")
		message_admins("<span class='notice'>[key_name(user)] used the bluespace delabeler against the following: [badlabel] ([i] objects delabeled)</span>")
		return

/obj/item/weapon/hand_labeler/admin_delabeler/attack_self(mob/user as mob)
	if(!check_rights(R_DEBUG|R_SERVER))	
		to_chat(user, "You are not supposed to have this and it is useless to you. Ask an admin to delete it.")
		return
	to_chat(user, "<span class='notice'>This object does not set labels - it is always on. It will memorize the label of the target and strip all similar labels from the world.</span>")
