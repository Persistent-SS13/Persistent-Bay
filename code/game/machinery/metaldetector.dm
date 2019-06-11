/obj/machinery/metal_detector
	name = "metal detector"
	desc = "A advanced metal detector used to detect weapons."
	icon = 'icons/obj/machines/metal_detector.dmi'
	icon_state = "metal_detector"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

	var/list/banned_objects=list(/obj/item/weapon/gun,
								/obj/item/weapon/material,
								/obj/item/weapon/melee,
								/obj/item/device/transfer_valve,
								/obj/item/weapon/grenade/,
								/obj/item/ammo_casing/,
								/obj/item/ammo_magazine
								)

/obj/machinery/metal_detector/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/metal_detector(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/metal_detector/attackby(obj/item/W, mob/usr)
	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/modular_computer/pda))
		if(!req_access_faction && W.GetFaction())
			req_access_faction = W.GetFaction()
			to_chat(usr, "<span class='notice'>\The [src] has been synced to your faction</span>")
			return

	if(default_deconstruction_screwdriver(usr, W))
		return

	if(default_deconstruction_crowbar(usr, W))
		return

/obj/machinery/metal_detector/Crossed(var/atom/A)
	if(istype(A, /mob/living))
		var/mob/living/M = A
		if(req_access_faction)
			if(has_access(list(core_access_security_programs), list(), M.GetAccess(req_access_faction)) && (M.GetFaction() == req_access_faction))
				return //Faction-members with security access are immune.

	check_items(recursive_content_check(src.loc, sight_check = FALSE, include_mobs = FALSE, recursion_limit = 4))
	..()

/obj/machinery/metal_detector/proc/check_items(var/list/L)
	for(var/O in banned_objects)
		for(var/A in L)
			if(istype(A, O))
				flick("metal_detector_anim",src)
				visible_message("<span class='danger'>\The [src] sends off an alarm!</span>")
				playsound(src, 'sound/ambience/alarm4.ogg', 60, 1)
				return