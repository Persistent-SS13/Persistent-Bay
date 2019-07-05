/obj/item/device/radio/intercom
	name = "intercom (General)"
	desc = "Talk through this."
	icon = 'icons/obj/machines/radio_intercom.dmi'
	icon_state = "intercom"
	randpixel = 0
	anchored = TRUE
	w_class = ITEM_SIZE_HUGE
	canhear_range = 2
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	layer = ABOVE_WINDOW_LAYER
	cell = null
	power_usage = 0
	var/number = 0
	var/last_tick //used to delay the powercheck
	var/buildstage = 0
	var/wiresexposed = FALSE
	var/circuitry_installed = TRUE


/obj/item/device/radio/intercom/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/device/radio/intercom/custom
	name = "intercom (Custom)"
	broadcasting = FALSE
	listening = FALSE

/obj/item/device/radio/intercom/interrogation
	name = "intercom (Interrogation)"
	frequency  = SEC_INTERCOM_FREQ

/obj/item/device/radio/intercom/private
	name = "intercom (Private)"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = ERT_FREQ

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = FALSE
	listening = TRUE

/obj/item/device/radio/intercom/department/medbay
	name = "intercom (Medbay)"
	frequency = MED_I_FREQ

/obj/item/device/radio/intercom/department/security
	name = "intercom (Security)"
	frequency = SEC_I_FREQ

/obj/item/device/radio/intercom/entertainment
	name = "entertainment intercom"
	frequency = ENT_FREQ
	canhear_range = 4

/obj/item/device/radio/intercom/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	queue_icon_update()

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/entertainment/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(ENT_FREQ) = list()
	)

/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly."
	frequency = SYND_FREQ
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/raider
	name = "illicit intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	frequency = RAID_FREQ
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/raider/Initialize()
	. = ..()
	internal_channels[num2text(RAID_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/receive_range(freq, level, faction)
	if (!on)
		return -1
	if(faction && faction != "" && faction != faction_uid)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/device/radio/intercom/Process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday
		var/old_on = on

		if(!src.loc)
			on = FALSE
		else
			var/area/A = get_area(src)
			if(!A)
				on = FALSE
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if (on != old_on)
			queue_icon_update()

/obj/item/device/radio/intercom/on_update_icon()
	if(!on)
		icon_state = "intercom-p"
	else if (broadcasting && listening)
		icon_state = "intercom_11"
	else if (broadcasting)
		icon_state = "intercom_10"
	else if (listening)
		icon_state = "intercom_01"
	else
		icon_state = "intercom_00"

/obj/item/device/radio/intercom/ToggleBroadcast()
	..()
	update_icon()

/obj/item/device/radio/intercom/ToggleReception()
	..()
	update_icon()

/obj/item/device/radio/intercom/broadcasting
	broadcasting = TRUE

/obj/item/device/radio/intercom/locked
	var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency()
	..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	locked_frequency = AI_FREQ
	broadcasting = TRUE
	listening = TRUE

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	locked_frequency = CONFESSIONALS_FREQ

/obj/item/device/radio/intercom/locked/prison
	name = "\improper prison intercom"
	desc = "Talk through this. It looks like it has been modified to not broadcast."

/obj/item/device/radio/intercom/locked/prison/New()
	..()
	wires.CutWireIndex(WIRE_TRANSMIT)

/obj/item/device/radio/intercom/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/device/scanner/reagent))
		return
	if(istype(W, /obj/item/weapon/tool/wrench))
		to_chat(user, "<span class='notice'>You detach \the [src] from the wall.</span>")
		new /obj/item/frame/intercom(get_turf(src))
		qdel(src)
		return 1
	return src.attack_hand(user)

/obj/item/device/radio/intercom/New(loc, dir, atom/frame)
	..(loc)
	if(dir)
		src.set_dir(dir)
	if(istype(frame))
		buildstage = 0
		wiresexposed = TRUE
		frame.transfer_fingerprints_to(src)

/obj/item/device/radio/intercom/Initialize()
	. = ..()
	update_icon()

/obj/item/device/radio/intercom/update_icon()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -28
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 24
		if(EAST)
			src.pixel_x = -22
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 22
			src.pixel_y = 0
	if(!circuitry_installed)
		icon_state="intercom-frame"
		return
	icon_state = "intercom[!on?"-p":""][b_stat ? "-open":""]"

/obj/item/weapon/intercom_electronics
	name = "intercom electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	origin_tech = "engineering=2;programming=1"


/obj/item/device/radio/intercom/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(isScrewdriver(W))  // Opening that Intercom up.
				to_chat(user, "You pop the [src] maintence panel open.")
				wiresexposed = !wiresexposed
				to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
				update_icon()
				return

			if (wiresexposed && isWirecutter(W))
				user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You have cut the wires inside \the [src].")
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				new/obj/item/stack/cable_coil(get_turf(src), 5)
				buildstage = 1
				update_icon()
				return


		if(1)
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if (C.use(5))
					to_chat(user, "<span class='notice'>You wire \the [src].</span>")
					buildstage = 2
					update_icon()
					return
				else
					to_chat(user, "<span class='warning'>You need 5 pieces of cable to do wire \the [src].</span>")
					return

			else if(isCrowbar(W))
				to_chat(user, "You start prying out the [src] circuit.")
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user,20))
					to_chat(user, "You pry out the [src] circuit!")
					var/obj/item/weapon/intercom_electronics/circuit = new /obj/item/weapon/intercom_electronics()
					circuit.dropInto(user.loc)
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/weapon/intercom_electronics))
				to_chat(user, "You insert the [src] circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(isWrench(W))
				to_chat(user, "You remove the [src] assembly from the wall!")
				new /obj/item/frame/intercom(get_turf(user))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				qdel(src)

	return ..()
