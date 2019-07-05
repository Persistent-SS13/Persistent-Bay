/obj/structure/sign/double/barsign
	desc = "A jumbo-sized LED sign. This one seems to be showing its age."
	description_info = "If your ID has bar access, you may swipe it on this sign to alter its display."
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	appearance_flags = 0
	anchored = 1
	max_health = 30
	var/cult = 0

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/examine(mob/user)
	. = ..()
	switch(icon_state)
		if("Off")
			to_chat(user, "It appears to be switched off.")
		if("narsiebistro")
			to_chat(user, "It shows a picture of a large black and red being. Spooky!")
		if("on", "empty")
			to_chat(user, "The lights are on, but there's no picture.")
		else
			to_chat(user, "It says '[icon_state]'")

/obj/structure/sign/double/barsign/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))

		pixel_x = (dir & 3)? 0 : (dir == 4 ? -64 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -64 : 32) : 0
		frame.transfer_fingerprints_to(src)

	icon_state = pick(get_valid_states())

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return ..()
	var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in get_valid_states(0)
	if(!sign_type)
		return
	icon_state = sign_type
	to_chat(user, "<span class='notice'>You change the barsign.</span>")

	return ..()


/obj/structure/sign/double/barsign/attackby(obj/item/W as obj, mob/user as mob)
	if((isScrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the [src].</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the [src] to" : "unfastened the [src] from"] the floor.</span>")
		return
	else if(isWrench(W))
		to_chat(user, "You remove the [src] assembly from the wall!")
		new /obj/item/frame/barsign(get_turf(user))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return
	return ..()
