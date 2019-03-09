// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/machines/flashers.dmi'
	icon_state = "mflash1"
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE
	
	id_tag = null
	frequency = SEC_FREQ
	radio_filter_in = RADIO_FLASHERS
	radio_filter_out = RADIO_FLASHERS
	radio_check_id = TRUE

	var/flash_range = 2 //this is roughly the size of brig cell
	var/disable = FALSE
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	var/_wifi_id
	var/datum/wifi/receiver/button/flasher/wifi_receiver

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name 		= "portable flasher"
	desc 		= "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state 	= "pflash1"
	base_state 	= "pflash"
	strength 	= 8
	anchored 	= FALSE
	density 	= TRUE
	mass		= 2.0 //kg

/obj/machinery/flasher/portable/update_icon()
	if (operable())
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]1-p"

/obj/machinery/flasher/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)
	queue_icon_update()

/obj/machinery/flasher/Destroy()
	QDEL_NULL(wifi_receiver)
	return ..()

/obj/machinery/flasher/OnSignal(var/datum/signal/signal)
	. = ..()
	if(signal.data["activate"] || signal.data["flash"])
		flash()

/obj/machinery/flasher/update_icon()
	//Those are wall mounted so align them to walls
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -26
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 26
		if(EAST)
			src.pixel_x = -22
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = 22
			src.pixel_y = 0
	
	if (operable())
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]1-p"

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWirecutter(W))
		add_fingerprint(user)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message(SPAN_WARNING("[user] has disconnected the [src]'s flashbulb!"), SPAN_WARNING("You disconnect the [src]'s flashbulb!"))
		if (!src.disable)
			user.visible_message(SPAN_WARNING("[user] has connected the [src]'s flashbulb!"), SPAN_WARNING("You connect the [src]'s flashbulb!"))

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (src.anchored)
		return src.flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if (!(powered()))
		return

	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power(1500)

	for (var/mob/O in viewers(src, null))
		if (get_dist(src, O) > src.flash_range)
			continue

		var/flash_time = strength
		if (istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			flash_time *= H.species.flash_mod
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
			if(!E)
				return
			if(E.is_bruised() && prob(E.get_damages() + 50))
				H.flash_eyes()
				E.rem_health(rand(1, 5))
		else
			if(!O.blinded && isliving(O))
				var/mob/living/L = O
				L.flash_eyes()
		O.Weaken(flash_time)

/obj/machinery/flasher/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if (!MOVING_DELIBERATELY(M) && (src.anchored))
			src.flash()

/obj/machinery/flasher/portable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		add_fingerprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_message(text(SPAN_WARNING("[src] can now be moved.")))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_message(text(SPAN_WARNING("[src] is now secured.")))
			src.overlays += "[base_state]-s"
		return TRUE
	return ..()
