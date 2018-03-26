//CARGO TELEPAD//
/obj/machinery/telepad
	name = "cargo telepad"
	desc = "A telepad used by the Rapid Crate Sender."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 15000
/obj/machinery/telepad/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/telepad(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()
/obj/machinery/telepad/attackby(obj/item/O as obj, mob/user as mob, params)
	if(istype(O, /obj/item/weapon/wrench))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = 0
			to_chat(user, "<span class = 'caution'> The [src] can now be moved.</span>")
		else if(!anchored)
			anchored = 1
			to_chat(user, "<span class = 'caution'> The [src] is now secured.</span>")
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	..()
///TELEPAD CALLER///
/obj/item/device/telepad_beacon
	name = "telepad beacon"
	desc = "Use to warp in a cargo telepad."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = "bluespace=3"

/obj/item/device/telepad_beacon/attack_self(mob/user as mob)
	if(user)
		to_chat(user, "<span class = 'caution'> Locked In</span>")
		new /obj/machinery/telepad(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/weapon/rcs
	name = "rapid-crate-sender (RCS)"
	desc = "A device used to teleport crates and closets to cargo telepads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	item_state = "rcd"
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	var/obj/item/weapon/cell/bcell
	var/obj/machinery/pad = null
	var/mode = 0
	var/rand_x = 0
	var/rand_y = 0
	var/emagged = 0
	var/teleporting = 0
	var/chargecost = 1500

/obj/item/weapon/rcs/New()
	..()
	if(ispath(bcell))
		bcell = new bcell(src)

/obj/item/weapon/rcs/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			return 1
		else
			return 0
	return null

/obj/item/weapon/rcs/examine(mob/user)
	if(!..(user, 1))
		return 0
	examine_cell(user)
	return 1

/obj/item/weapon/rcs/proc/examine_cell(mob/user)
	..(user)
	to_chat(user, "There is [round(bcell.percent())]% charge left.")
	if(!bcell)
		to_chat(user, "<span class='warning'>The RCS does not have a power source installed.</span>")

/obj/item/weapon/rcs/Destroy()
	if(bcell && !ispath(bcell))
		qdel(bcell)
		bcell = null
	return ..()

/obj/item/weapon/rcs/attack_self(mob/user)
	if(emagged)
		if(mode == 0)
			mode = 1
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class = 'caution'> The telepad locator has become uncalibrated.</span>")
		else
			mode = 0
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class = 'caution'> You calibrate the telepad locator.</span>")

/*	I got not no idea how to fix the errors here and it is not worth the time since emags are not used, so commenting it out.
/obj/item/weapon/rcs/emag_act(user as mob)
	if(!emagged)
		emagged = 1
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		to_chat(user, "<span class = 'caution'> You emag the RCS. Activate it to toggle between modes.</span>")
		return
*/