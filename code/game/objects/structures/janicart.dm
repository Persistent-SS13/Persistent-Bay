/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = 0
	density = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE
	max_health = 120
	mass = 10
	armor = list(
		DAM_BLUNT  	= 20,
		DAM_PIERCE 	= 15,
		DAM_CUT 	= 30,
		DAM_BULLET 	= 0,
		DAM_ENERGY 	= 0,
		DAM_BURN 	= 0,
		DAM_BOMB 	= 0,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)
	damthreshold_brute 	= 5
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/obj/item/weapon/mop/mymop = null
	var/obj/item/weapon/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/signs = 0	//maximum capacity hardcoded below


/obj/structure/janitorialcart/New()
	..()
	ADD_SAVED_VAR(mybag)
	ADD_SAVED_VAR(mymop)
	ADD_SAVED_VAR(myspray)
	ADD_SAVED_VAR(myreplacer)
	ADD_SAVED_VAR(signs)

/obj/structure/janitorialcart/SetupReagents()
	. = ..()
	create_reagents(500)

/obj/structure/janitorialcart/after_load()
	..()
	queue_icon_update()

/obj/structure/janitorialcart/Destroy()
	mybag = null
	mymop = null
	myspray = null
	myreplacer = null
	. = ..()

/obj/structure/janitorialcart/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "[src] \icon[src] contains [reagents.total_volume] unit\s of liquid!")
	//everything else is visible, so doesn't need to be mentioned

/obj/structure/janitorialcart/proc/fill_from_bucket(var/obj/item/I, var/mob/user)
	if(I.reagents.total_volume >= I.reagents.maximum_volume)
		return
	if(reagents.total_volume < 1)
		to_chat(user, "<span class='warning'>[src] is out of water!</span>")
	else
		reagents.trans_to_obj(I, I.reagents.maximum_volume)
		to_chat(user, "<span class='notice'>You wet [I] in [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/storage/bag/trash) && !mybag)
		if(!user.unEquip(I, src))
			return
		mybag = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
	else if(istype(I, /obj/item/weapon/soap))
		fill_from_bucket(I, user)
	else if(istype(I, /obj/item/weapon/reagent_containers/glass/rag))
		fill_from_bucket(I, user)
	else if(istype(I, /obj/item/weapon/mop))
		fill_from_bucket(I, user)
		if(!mymop)
			if(!user.unEquip(I, src))
				return
			mymop = I
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/weapon/reagent_containers/spray) && !myspray)
		if(!user.unEquip(I, src))
			return
		myspray = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/device/lightreplacer) && !myreplacer)
		if(!user.unEquip(I, src))
			return
		myreplacer = I
		update_icon()
		updateUsrDialog()
		to_chat(user, "<span class='notice'>You put [I] into [src].</span>")

	else if(istype(I, /obj/item/weapon/caution))
		if(signs < 4)
			if(!user.unEquip(I, src))
				return
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] can't hold any more signs.</span>")

	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		return // So we do not put them in the trash bag as we mean to fill the mop bucket

	else if(mybag)
		mybag.attackby(I, user)
	else
		return ..()

/obj/structure/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/janitorialcart/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(href_list["take"])
		switch(href_list["take"])
			if("garbage")
				if(mybag)
					user.put_in_hands(mybag)
					to_chat(user, "<span class='notice'>You take [mybag] from [src].</span>")
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					to_chat(user, "<span class='notice'>You take [mymop] from [src].</span>")
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					to_chat(user, "<span class='notice'>You take [myspray] from [src].</span>")
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					to_chat(user, "<span class='notice'>You take [myreplacer] from [src].</span>")
					myreplacer = null
			if("sign")
				if(signs)
					var/obj/item/weapon/caution/Sign = locate() in src
					if(Sign)
						user.put_in_hands(Sign)
						to_chat(user, "<span class='notice'>You take \a [Sign] from [src].</span>")
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0

	update_icon()
	updateUsrDialog()


/obj/structure/janitorialcart/on_update_icon()
	overlays.Cut()
	if(mybag)
		overlays += "cart_garbage"
	if(mymop)
		overlays += "cart_mop"
	if(myspray)
		overlays += "cart_spray"
	if(myreplacer)
		overlays += "cart_replacer"
	if(signs)
		overlays += "cart_sign[signs]"
