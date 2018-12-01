/*
	Mining and plant bags, can store a ridiculous number of items in order to deal with the ridiculous amount of ores or plant products
	that can be produced by mining or (xeno)botany, however it can only hold those items.

	These storages typically should also support quick gather and quick empty to make managing large numbers of items easier.
*/

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/weapon/storage/ore
	name = "mining satchel"
	desc = "This sturdy bag can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/stack/ore, /obj/item/stack/material_dust)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1

/obj/item/weapon/storage/ore/handle_item_insertion(var/obj/item/W, var/prevent_warning = 0, var/NoUpdate = 0)
	if(!istype(W))
		return 0
	if(istype(W.loc, /mob))
		var/mob/M = W.loc
		M.remove_from_mob(W)
	W.forceMove(src)
	if(istype(W,/obj/item/stack))
		var/obj/item/stack/st = W
		st.drop_to_stacks(src)
	W.on_enter_storage(src)
	if(usr)
		add_fingerprint(usr)

		if(!prevent_warning)
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					to_chat(usr, "<span class='notice'>You put \the [W] into [src].</span>")
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is... TODO replace with distance check
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")
				else if (W && W.w_class >= ITEM_SIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")

		if(!NoUpdate)
			update_ui_after_item_insertion()
	update_icon()
	return 1

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/weapon/storage/plants
	name = "botanical satchel"
	desc = "This bag can be used to store all kinds of plant products and botanical specimen."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	slot_flags = SLOT_BELT
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/weapon/grown)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1

// ----------------------------- //A NOTE ON THESE AMMO BOXES! They are kinda messy, clean them up if you get the chance.
//          Ammo boxes
// -----------------------------

/obj/item/weapon/storage/ammobox
	name = "ammo box"
	desc = "An ammo box. Able to hold all sorts of ammunition types. Needs a transport box to place ammunition into it."
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/ammo_casing/)
	icon = 'icons/obj/ammo.dmi'
	icon_state = "ammobox"
	slot_flags = SLOT_BACK
	allow_quick_empty = 1
	matter = list(MATERIAL_STEEL = 10000)

/obj/item/weapon/storage/ammobox/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(istype(O,/obj/item/weapon/storage/ammotbox))
		var/failed = 1
		for(var/obj/item/G in O.contents)
			failed = 0

			if(!can_be_inserted(G, user, FALSE))
				break

			handle_item_insertion(G, TRUE, FALSE)

		if(failed)
			to_chat(user, "Nothing in \the [O] is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(istype(O,/obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/mag = O
		if(!src.contents.len)
			to_chat(user, "[src] is empty.")
			return
		if(mag.max_ammo <= mag.stored_ammo.len)
			to_chat(user, "[O] is full.")
			return
		var/failed = 1
		for(var/obj/item/G in src.contents)
			if(!istype(G, mag.ammo_type))
				continue
			if(do_after(user, 10, mag))
				failed = 0
				G.loc = mag
				mag.stored_ammo |= G
				to_chat(user, "You load a casing into [O].")
				playsound(src.loc, 'sound/weapons/empty.ogg', 2, 1)
				mag.update_icon()
				if(mag.stored_ammo.len >= mag.max_ammo)
					to_chat(user, "You filled \the [O].")
					break
			else
				failed = 0
				return
		if(failed)
			to_chat(user, "There was nothing suitable to load into \the [O] in \the [src].")

			src.updateUsrDialog()
			return 0

/obj/item/weapon/storage/ammotbox
	name = "ammo transport box"
	desc = "This box holds all sorts of ammunition to fill larger ammo boxes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "smallbox"
	max_storage_space = 50
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/ammo_casing/)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1
	matter = list(MATERIAL_STEEL = 5000)

/obj/item/weapon/storage/ammobox/big
	name = "big ammo box"
	desc = "A large ammo box. It comes with a leather strap. Needs a transport box to transfer ammo into it."
	max_storage_space = 600
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/ammo_casing/)
	icon = 'icons/obj/ammo.dmi'
	icon_state = "bigammobox"
	slot_flags = SLOT_BACK
	allow_quick_empty = 1
	matter = list(MATERIAL_STEEL = 30000)


// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu
// This is old and terrible

/obj/item/weapon/storage/sheetsnatcher
	name = "material coverbag"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A small bag designed to safely transport exotic materials."

	storage_ui = /datum/storage_ui/default/sheetsnatcher

	var/capacity = 60; //the number of sheets it can carry.
	w_class = ITEM_SIZE_LARGE
	storage_slots = 7

	allow_quick_empty = 1 // this function is superceded
	use_to_pickup = 1
	New()
		..()
		//verbs -= /obj/item/weapon/storage/verb/quick_empty
		//verbs += /obj/item/weapon/storage/sheetsnatcher/quick_empty

	can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
		if(!istype(W,/obj/item/stack/material))
			if(!stop_messages)
				to_chat(user, "The snatcher does not accept [W].")
			return 0
		var/current = 0
		for(var/obj/item/stack/material/S in contents)
			current += S.amount
		if(capacity == current)//If it's full, you're done
			if(!stop_messages)
				to_chat(user, "<span class='warning'>The snatcher is full.</span>")
			return 0
		return 1


// Modified handle_item_insertion.  Would prefer not to, but...
	handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
		var/obj/item/stack/material/S = W
		if(!istype(S)) return 0

		var/amount
		var/inserted = 0
		var/current = 0
		for(var/obj/item/stack/material/S2 in contents)
			current += S2.amount
		if(capacity < current + S.amount)//If the stack will fill it up
			amount = capacity - current
		else
			amount = S.amount

		for(var/obj/item/stack/material/sheet in contents)
			if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
				sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
				S.amount -= amount
				inserted = 1
				break

		if(!inserted || !S.amount)
			usr.drop_from_inventory(S, src)
			if(!S.amount)
				qdel(S)
			usr.update_icons()	//update our overlays

		prepare_ui(usr)
		update_icon()
		return 1

// Modified quick_empty verb drops appropriate sized stacks
	quick_empty()
		var/location = get_turf(src)
		for(var/obj/item/stack/material/S in contents)
			while(S.amount)
				var/obj/item/stack/material/N = new S.type(location)
				var/stacksize = min(S.amount,N.max_amount)
				N.amount = stacksize
				S.amount -= stacksize
			if(!S.amount)
				qdel(S) // todo: there's probably something missing here
		prepare_ui()
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()

// Instead of removing
	remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/stack/material/S = W
		if(!istype(S)) return 0

		//I would prefer to drop a new stack, but the item/attack_hand code
		// that calls this can't recieve a different object than you clicked on.
		//Therefore, make a new stack internally that has the remainder.
		// -Sayu

		if(S.amount > S.max_amount)
			var/obj/item/stack/material/temp = new S.type(src)
			temp.amount = S.amount - S.max_amount
			S.amount = S.max_amount

		return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/weapon/storage/sheetsnatcher/borg	//Borgs probably shouldn't have this
	name = "material carrybag"
	desc = ""
