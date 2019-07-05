//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	max_health = 100
	var/on = 0
	var/obj/item/weapon/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0

	var/l_max_bright = 0.8 //brightness of light when on, can be negative
	var/l_inner_range = 1 //inner range of light when on, can be negative
	var/l_outer_range = 6 //outer range of light when on, can be negative

/obj/machinery/floodlight/New()
	if(!map_storage_loaded)
		cell = new/obj/item/weapon/cell/apc(src)
	..()

/obj/machinery/floodlight/on_update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/Process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off()
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(l_max_bright / 2, l_inner_range, l_outer_range)
		spawn(20)
			if(on)
				set_light(l_max_bright, l_inner_range, l_outer_range)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/turn_on(var/loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light(l_max_bright, l_inner_range, l_outer_range)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return 1

/obj/machinery/floodlight/turn_off(var/loud = 0)
	on = 0
	set_light(0, 0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off()
	else
		if(!turn_on())
			to_chat(user, "You try to turn on \the [src] but it does not work.")


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
		else
			cell.dropInto(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light(0)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off()
	else
		if(!turn_on())
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			return
	playsound(src, "sound/machines/switch-big-power.ogg", 30)

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")
			update_icon()
			return

	if(isCrowbar(W))
		if(unlocked)
			if(open)
				open = 0
				overlays.Cut()
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")
			update_icon()
			return
	if(default_wrench_floor_bolts(user,W))
		return
	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				if(!user.unEquip(W, src))
					return
				cell = W
				to_chat(user, "You insert the power cell.")
		update_icon()
		return

	return ..()

/obj/machinery/floodlight/verb/rotate()
	set name = "Rotate Light"
	set category = "Object"
	set src in oview(1)

	if(!usr || !Adjacent(usr))
		return

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return
	else if(usr.incapacitated())
		return

	src.set_dir(turn(src.dir, 90))
	return

/obj/machinery/floodlight/AltClick()
	rotate()
