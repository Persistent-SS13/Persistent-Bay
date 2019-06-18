/obj/item/weapon/circuitboard/carbonator
	name = T_BOARD("carbonator")
	build_path = /obj/machinery/carbonator
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(	/obj/item/stack/cable_coil = 5,
							/obj/item/weapon/stock_parts/console_screen = 1)


/*
	A machine used to make carbonated liquids
*/
/obj/machinery/carbonator
	name = "carbonation machine"
	desc = "Use this machine to make carbonated water."
	density = 1
	anchored = 1
	//Placeholder icon
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"

	circuit_type = /obj/item/weapon/circuitboard/carbonator

	var/obj/item/weapon/reagent_containers/glass/beaker = null //output beaker
	var/obj/item/weapon/tank/co2tank = null	//Carbon dioxide canister used to fill water with carbon
	var/time_started = 0

/obj/machinery/carbonator/New()
	. = ..()
	ADD_SAVED_VAR(beaker)
	ADD_SAVED_VAR(co2tank)
	ADD_SAVED_VAR(time_started)

/obj/machinery/carbonator/Initialize()
	. = ..()
	STOP_PROCESSING(SSmachines, src)

/obj/machinery/carbonator/Destroy()
	STOP_PROCESSING(SSmachines, src)
	beaker = null
	co2tank = null
	. = ..()

/obj/machinery/carbonator/before_save()
	. = ..()
	if(time_started != 0)
		time_started -= world.time

/obj/machinery/carbonator/after_save()
	. = ..()
	if(time_started != 0)
		time_started += world.time

/obj/machinery/carbonator/after_load()
	. = ..()
	if(time_started != 0)
		time_started += world.time

/obj/machinery/carbonator/Process()
	. = ..()
	if(!isactive())
		return
	
	if(world.time >= (time_started + 2 SECONDS) && beaker && co2tank && beaker.reagents && co2tank.return_air())
		for(var/datum/reagent/R in beaker.reagents.get_reagents())
			switch(R.type)
				if(/datum/reagent/water, /datum/reagent/water/holywater)
					var/gas_needed = R.volume //Should probably be higher
					var/volumefill = R.volume
					var/datum/gas_mixture/G = co2tank.remove_air_volume(volumefill)
					if(G && G.get_gas(GAS_CO2) >= gas_needed )
						beaker.reagents.remove_reagent(R.type, R.volume)
						beaker.reagents.add_reagent(/datum/reagent/drink/sodawater, volumefill)
						playsound(src, 'sound/effects/bubbles.ogg') //Bubbling
		turn_idle()


/obj/machinery/carbonator/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return 1
	else if(default_deconstruction_crowbar(user, O))
		return 1
	else if(default_part_replacement(user, O))
		return 1
	else if(default_wrench_floor_bolts(user, O))
		return 1
	else if(istype(O, /obj/item/weapon/tank))
		if(!co2tank)
			user.unEquip(O, src)
			co2tank = O
			update_verbs()
			update_icon()
			visible_message("[user] hook up \the [O] to \the [src].")
		else
			to_chat(user, SPAN_WARNING("There is already a tank inside the machine!"))
		return 1
	else if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(!beaker)
			user.unEquip(O, src)
			beaker = O
			update_verbs()
			update_icon()
			visible_message("[user] places \the [O] inside \the [src].")
		else
			to_chat(user, SPAN_WARNING("There is already a container inside the machine!"))
		return 1
	else
		return ..()

/obj/machinery/carbonator/attack_hand(mob/user)
	. = ..()
	if(beaker && co2tank && isidle())
		turn_active()
		visible_message("[user] turn on \the [src].")
	else
		turn_idle()
		visible_message("[user] turn off \the [src].")

/obj/machinery/carbonator/CtrlClick(mob/user)
	. = ..()
	if(beaker)
		remove_beaker()

/obj/machinery/carbonator/proc/update_verbs()
	if(beaker)
		verbs |= /obj/machinery/carbonator/proc/remove_beaker
	else
		verbs -= /obj/machinery/carbonator/proc/remove_beaker
	
	if(co2tank)
		verbs |= /obj/machinery/carbonator/proc/remove_tank
	else
		verbs -= /obj/machinery/carbonator/proc/remove_tank

/obj/machinery/carbonator/turn_active()
	. = ..()
	START_PROCESSING(SSmachines, src)
	time_started = world.time
	
/obj/machinery/carbonator/turn_idle()
	. = ..()
	STOP_PROCESSING(SSmachines, src)
	time_started = 0

/obj/machinery/carbonator/proc/remove_beaker()
	set name = "Remove Beaker"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	turn_idle()
	visible_message("[user] removes \the [src]'s [beaker].")
	user.put_in_hands(beaker)
	beaker = null
	update_icon()
	update_verbs()

/obj/machinery/carbonator/proc/remove_tank()
	set name = "Remove Gas Tank"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	turn_idle()
	visible_message("[user] removes \the [src]'s [co2tank].")
	user.put_in_hands(co2tank)
	co2tank = null
	update_icon()
	update_verbs()