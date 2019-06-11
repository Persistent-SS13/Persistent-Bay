/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheet.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	randpixel = 0
	slot_flags = SLOT_BACK
	plane = ABOVE_OBJ_PLANE
	layer = BASE_ABOVE_OBJ_LAYER
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_SMALL
	max_health = 10

/obj/item/weapon/bedsheet/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up \the [src] with \a [I].</span>", "<span class='notice'>You begin cutting up \the [src] with \the [I].</span>")
		if(do_after(user, 50, src))
			to_chat(user, "<span class='notice'>You cut \the [src] into pieces!</span>")
			for(var/i in 1 to rand(2,5))
				new /obj/item/weapon/reagent_containers/glass/rag(get_turf(src))
			qdel(src)
		return
	..()

/obj/item/weapon/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/weapon/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/weapon/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/weapon/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/weapon/bedsheet/rainbow
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/weapon/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/weapon/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/weapon/bedsheet/mime
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/weapon/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/weapon/bedsheet/captain
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/weapon/bedsheet/rd
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/weapon/bedsheet/medical
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/weapon/bedsheet/hos
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/weapon/bedsheet/hop
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/weapon/bedsheet/ce
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/weapon/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures/bedsheets_bin.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	max_health = 50
	matter = list(MATERIAL_PLASTIC = 4 * SHEET_MATERIAL_AMOUNT)
	var/amount = 0
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/filled
	amount = 20

/obj/structure/bedsheetbin/New()
	..()
	ADD_SAVED_VAR(hidden)
	ADD_SAVED_VAR(amount)

/obj/structure/bedsheetbin/Destroy()
	if(hidden)
		hidden.forceMove(get_turf(loc))
	..()

/obj/structure/bedsheetbin/examine(mob/user)
	. = ..(user)

	if(amount < 1)
		to_chat(user, "There are no bed sheets in the bin.")
		return
	if(amount == 1)
		to_chat(user, "There is one bed sheet in the bin.")
		return
	to_chat(user, "There are [amount] bed sheets in the bin.")


/obj/structure/bedsheetbin/on_update_icon()
	switch(amount)
		if(0)				icon_state = "linenbin-empty"
		if(1 to amount / 2)	icon_state = "linenbin-half"
		else				icon_state = "linenbin-full"

/obj/structure/bedsheetbin/proc/can_hide_item(obj/item/I)
	return amount && !hidden && I.w_class < ITEM_SIZE_HUGE

/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/bedsheet))
		if(!user.unEquip(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		return 1
	else if(isWrench(I))
		refund_matter()
		qdel(src)
		return 1
	else if(user.a_intent != I_HURT && can_hide_item(I))	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.unEquip(I, src))
			return
		hidden = I
		to_chat(user, SPAN_NOTICE("You hide [I] among the sheets."))
		return 1
	else
		return ..()

/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(user.a_intent != I_HURT)
		var/obj/item/weapon/bedsheet/B = take_sheet()
		if(!B)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
			return
		add_fingerprint(user)
		B.forceMove(user.loc)
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You take [B] out of [src]."))

		if(hidden)
			hidden.forceMove(user.loc)
			to_chat(user, SPAN_NOTICE("[hidden] falls out of [B]!"))
			hidden = null
	else
		..()

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	var/obj/item/weapon/bedsheet/B = take_sheet()
	if(!B)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return
	B.dropInto(loc)
	to_chat(user, SPAN_NOTICE("You telekinetically remove [B] from [src]."))

	if(hidden)
		hidden.dropInto(loc)
		hidden = null

/obj/structure/bedsheetbin/proc/take_sheet()
	if(amount >= 1)
		amount--

		var/obj/item/weapon/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/weapon/bedsheet(loc)
		. = B
		update_icon()
	return .
