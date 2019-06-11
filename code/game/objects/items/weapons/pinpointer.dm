/obj/item/weapon/pinpointer
	name = "pinpointer"
	icon = 'icons/obj/pinpointer.dmi'
	icon_state = "pinoff"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	matter = list(MATERIAL_STEEL = 500)
	var/weakref/target
	var/active = 0
	var/beeping = 2

/obj/item/weapon/pinpointer/Destroy()
	STOP_PROCESSING(SSobj,src)
	target = null
	. = ..()

/obj/item/weapon/pinpointer/attack_self(mob/user)
	toggle(user)

/obj/item/weapon/pinpointer/proc/toggle(mob/user)
	active = !active
	to_chat(user, "You [active ? "" : "de"]activate [src].")
	if(!active)
		STOP_PROCESSING(SSobj,src)
	else
		if(!target)
			target = acquire_target()
		START_PROCESSING(SSobj,src)
	update_icon()

/obj/item/weapon/pinpointer/advpinpointer/verb/toggle_sound()
	set category = "Object"
	set name = "Toggle Pinpointer Beeping"
	set src in view(1)

	if(beeping >= 0)
		beeping = -1
		to_chat(usr, "You mute [src].")
	else
		beeping = 0
		to_chat(usr, "You enable the sound indication on [src].")

/obj/item/weapon/pinpointer/proc/acquire_target()
	var/obj/item/weapon/disk/nuclear/the_disk = locate()
	return weakref(the_disk)

/obj/item/weapon/pinpointer/Process()
	update_icon()
	if(!target)
		return
	if(!target.resolve())
		target = null
		return

	if(beeping < 0)
		return
	if(beeping == 0)
		var/turf/here = get_turf(src)
		var/turf/there = get_turf(target.resolve())
		if(!istype(there))
			return
		var/distance = max(1,get_dist(here, there))
		var/freq_mod = 1
		if(distance < world.view)
			freq_mod = min(world.view/distance, 2)
		else if (distance > 3*world.view)
			freq_mod = max(3*world.view/distance, 0.6)
		playsound(loc, 'sound/machines/buttonbeep.ogg', 1, frequency = freq_mod)
		if(distance > world.view || here.z != there.z)
			beeping = initial(beeping)
	else
		beeping--

/obj/item/weapon/pinpointer/on_update_icon()
	overlays.Cut()
	if(!active)
		return
	if(!target || !target.resolve())
		overlays += image(icon,"pin_invalid")
		return

	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target.resolve())
	if(!istype(there))
		overlays += image(icon,"pin_invalid")
		return

	if(here == there)
		overlays += image(icon,"pin_here")
		return

	if(!(there.z in GetConnectedZlevels(here.z)))
		overlays += image(icon,"pin_invalid")
		return
	if(here.z > there.z)
		overlays += image(icon,"pin_down")
		return
	if(here.z < there.z)
		overlays += image(icon,"pin_up")
		return

	dir = get_dir(here,there)
	var/image/pointer = image(icon,"pin_point")
	var/distance = get_dist(here,there)
	if(distance < world.view)
		pointer.color = COLOR_LIME
	else if(distance > 4*world.view)
		pointer.color = COLOR_RED
	else
		pointer.color = COLOR_YELLOW
	overlays += pointer