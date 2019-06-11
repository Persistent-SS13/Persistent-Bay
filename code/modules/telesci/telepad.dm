//CARGO TELEPAD//
/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used to recieve imports and send exports."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	circuit_type = /obj/item/weapon/circuitboard/telepad
	var/stage = 0
	var/datum/world_faction/connected_faction
	req_access = core_access_order_approval
	
/obj/machinery/telepad_cargo/New()
	..()
	GLOB.cargotelepads |= src
	ADD_SAVED_VAR(stage)
	ADD_SAVED_VAR(connected_faction)

/obj/machinery/telepad_cargo/after_load()
	if(req_access_faction && req_access_faction != "")
		connected_faction = get_faction(req_access_faction)
		if(connected_faction)
			connected_faction.cargo_telepads |= src
	
/obj/machinery/telepad_cargo/attackby(obj/item/O as obj, mob/user as mob, params)
	if(istype(O, /obj/item/weapon/tool/wrench))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = 0
			to_chat(user, "<span class = 'caution'> The [src] can now be moved.</span>")
		else if(!anchored)
			anchored = 1
			to_chat(user, "<span class = 'caution'> The [src] is now secured.</span>")
	if(istype(O, /obj/item/weapon/tool/screwdriver))
		if(stage == 0)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "<span class = 'caution'> You unscrew the telepad's tracking beacon.</span>")
			stage = 1
		else if(stage == 1)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "<span class = 'caution'> You screw in the telepad's tracking beacon.</span>")
			stage = 0
	if(istype(O, /obj/item/weapon/tool/weldingtool) && stage == 1)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		to_chat(user, "<span class = 'caution'> You disassemble the telepad.</span>")
		new /obj/item/stack/material/steel(get_turf(src))
		new /obj/item/stack/material/glass(get_turf(src))
		qdel(src)

/obj/machinery/telepad_cargo/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	
	
	if(req_access_faction && req_access_faction != "" && (connected_faction && connected_faction.uid != req_access_faction))
		if(connected_faction)
			connected_faction.cargo_telepads -= src
		connected_faction = get_faction(req_access_faction)
	if(!connected_faction)
		req_access_faction = ""
	data["connected_faction"] = connected_faction ? connected_faction.name : "Not connected."
	data["anchored"] = anchored ? "Yes" : "No"
	data["beacon"] = stage ? "Unsecured" : "Secured"
	data["label"] = name
	data["connected"] = !!connected_faction
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cargo_telepad.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/telepad_cargo/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	if(href_list["connect_to_faction"])
		if(connected_faction)
			connected_faction.cargo_telepads -= src
		connected_faction = get_faction(usr.GetFaction())
		if(connected_faction)
			req_access_faction = connected_faction.uid
			if(!allowed(usr))
				connected_faction = null
				req_access_faction = ""
			else
				connected_faction.cargo_telepads |= src
				req_access_faction = connected_faction.uid
		. = 1
	else if(href_list["disconnect_from_faction"])
		if(allowed(usr))
			if(connected_faction)
				connected_faction.cargo_telepads -= src
			connected_faction = null
			req_access_faction = null
		. = 1
	else if (href_list["change_label"])
		if(allowed(usr))
			var/select_name = sanitizeName(input(usr,"Select new label for the telepad.","Label Change", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				name = select_name
		. = 1
	if(.)
		SSnano.update_uis(src)


/obj/machinery/telepad_cargo/attack_hand(mob/user as mob)
	if(!req_access_faction || req_access_faction != "" || allowed(user))
		src.ui_interact(user)
		src.add_fingerprint(user)
	else
		to_chat(user, "The telepad rejects your access.")
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
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/weapon/rcs
