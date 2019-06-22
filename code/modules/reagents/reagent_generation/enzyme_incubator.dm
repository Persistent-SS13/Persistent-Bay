/obj/item/weapon/circuitboard/small_incubator
	name = T_BOARD("small incubator")
	build_path = /obj/machinery/small_incubator
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1)
	req_components = list(	/obj/item/stack/cable_coil = 10,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/*
	Machinery for incubating stuff that's not viruses
*/
/obj/machinery/small_incubator
	//name = "small incubator"
	name = "Might MC crash"
	desc = "This is an enzyme incubator. You just need to place some fresh produces, and add some nutriments to incubate some universal enzymes."
	density = 1
	anchored = 1
	icon = 'icons/obj/machines/enzymes_incubator.dmi'
	icon_state = "base"
	circuit_type = /obj/item/weapon/circuitboard/small_incubator
	active_power_usage = 120 WATTS
	idle_power_usage = 10 WATTS

	var/obj/item/weapon/reagent_containers/glass/beaker/internal_beaker = null	//used to allow upgrading internal storage using larger beakers
	var/obj/item/weapon/reagent_containers/glass/output_beaker = null //This is where the enzymes come out
	var/enzyme_created = 1				//nb of units of enzyme created per bunch
	var/convertion_rate = 5 			//Nb of ticks for "enzyme_created" unit of enzyme
	var/convertion_ratio = 10 			//How much nutrients are required per "enzyme_created" unit of enzyme
	var/max_temperature = 80 CELSIUS	//It can get up to this temperature to incubate the content
	var/set_temperature = T0C			//The current temperature setting
	var/heating_power = 10
	var/time_last_process = 0			//Time we last processed the content

/obj/machinery/small_incubator/New()
	..()
	ADD_SAVED_VAR(atom_flags)	//We need to save those
	ADD_SAVED_VAR(internal_beaker)
	ADD_SAVED_VAR(output_beaker)
	ADD_SAVED_VAR(set_temperature)

/obj/machinery/small_incubator/Initialize()
	. = ..()
	STOP_PROCESSING(SSmachines, src) //Don't process yet
	update_verbs()

/obj/machinery/small_incubator/Destroy()
	STOP_PROCESSING(SSmachines, src)
	if(output_beaker)
		output_beaker.dropInto(loc)
		output_beaker = null
	internal_beaker = null
	. = ..()

/obj/machinery/small_incubator/SetupParts()
	. = ..()
	//We already create this in the base class. So just fetch it
	internal_beaker = locate(/obj/item/weapon/reagent_containers/glass/beaker) in component_parts

/obj/machinery/small_incubator/proc/can_process()
	return !(atom_flags & ATOM_FLAG_OPEN_CONTAINER) && (output_beaker &&  output_beaker.reagents.get_free_space() < 0) || (internal_beaker && internal_beaker.reagents.has_reagent(/datum/reagent/nutriment, convertion_ratio) )

/obj/machinery/small_incubator/on_update_icon()
	. = ..()
	overlays.Cut()
	icon_state = initial(icon_state)
	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		overlays |= image(icon, "open")
		if(internal_beaker && internal_beaker.reagents)
			var/image/I = image(icon, "reagent_fill")
			I.color = internal_beaker.reagents.get_color()
			overlays |= I

	if(operable())
		if(isactive())
			overlays |= image(icon, "light_orange")
		else if(!can_process())
			overlays |= image(icon, "light_red")
		else
			overlays |= image(icon, "light_green")

/obj/machinery/small_incubator/examine(mob/user)
	. = ..()
	if(output_beaker)
		to_chat(user, "There's \a [output_beaker] placed under it..")
	else
		to_chat(user, SPAN_WARNING("There's no beaker loaded.."))
	
	if(isactive())
		to_chat(user, "Its currently incubating something.")

	if(output_beaker &&  output_beaker.reagents.get_free_space() < 0)
		to_chat(user, SPAN_WARNING("It seems like \the [src] has stopped because \the [output_beaker] is full!"))

	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		to_chat(user, "The cover is open.")
	else
		to_chat(user, "The cover is closed.")
	
	if(internal_beaker && internal_beaker.reagents.get_free_space() < internal_beaker.volume)
		to_chat(user, "It has some reagents inside its tank..")

/obj/machinery/small_incubator/on_reagent_change()
	. = ..()
	update_icon()

/obj/machinery/small_incubator/Process()
	. = .()
	if(inoperable())
		return
	try
		if(world.time >= (time_last_process + convertion_rate))
			if(can_process())
				var/datum/reagents/I = internal_beaker.reagents
				if(output_beaker.reagents.get_free_space() >= enzyme_created && I.remove_reagent(/datum/reagent/nutriment, convertion_ratio))
					output_beaker.reagents.add_reagent(/datum/reagent/enzyme, enzyme_created)
					use_power_oneoff(active_power_usage)
					queue_icon_update()
			else if(isactive())
				turn_idle()
				queue_icon_update()
		
		time_last_process = world.time
	catch(var/exception/e)
		log_error("small_incubator/Process(): '[e]'([e.file]:[e.line])")
		return PROCESS_KILL

/obj/machinery/small_incubator/ProcessAtomTemperature()
	if(isactive())
		var/last_temperature = temperature
		if(temperature < set_temperature)
			temperature = min(set_temperature, temperature + heating_power)
		if(temperature != last_temperature)
			if(internal_beaker)
				QUEUE_TEMPERATURE_ATOMS(internal_beaker)
			queue_icon_update()
		return TRUE // Don't kill this processing loop unless we're not powered.
	. = ..()

/obj/machinery/small_incubator/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return 1
	else if(default_deconstruction_crowbar(user, O))
		return 1
	else if(default_wrench_floor_bolts(user, O))
		return 1
	else if(default_part_replacement(user, O))
		return 1
	else if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(!output_beaker)
			user.unEquip(O, src)
			output_beaker = O
			update_verbs()
			update_icon()
			return 1
		else if(..()) //Handles reagent pouring
			return 1
		else
			to_chat(user, SPAN_WARNING("There is already a container in \the [src]"))
			return 1
	else 
		return ..()

/obj/machinery/small_incubator/attack_hand(mob/user)
	. = ..()
	if(!isactive())
		turn_on_incubator()
	else
		turn_off_incubator()

/obj/machinery/small_incubator/CtrlAltClick(mob/user)
	. = ..()
	if(!(atom_flags & ATOM_FLAG_OPEN_CONTAINER))
		open()
	else
		close()
	visible_message("[user] [(atom_flags & ATOM_FLAG_OPEN_CONTAINER)? "opens" : "closes"] \the [src]'s cover.")

/obj/machinery/small_incubator/CtrlClick(mob/user)
	. = ..()
	remove_beaker()		

/obj/machinery/small_incubator/turn_active()
	. = ..()
	START_PROCESSING(SSmachines, src)
	
/obj/machinery/small_incubator/turn_idle()
	. = ..()
	STOP_PROCESSING(SSmachines, src)

/obj/machinery/small_incubator/proc/update_verbs()
	if(output_beaker)
		verbs |= /obj/machinery/small_incubator/verb/remove_beaker
	else
		verbs -= /obj/machinery/small_incubator/verb/remove_beaker
	
	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		verbs |= /obj/machinery/small_incubator/proc/close
		verbs -= /obj/machinery/small_incubator/proc/open
	else
		verbs -= /obj/machinery/small_incubator/proc/close
		verbs |= /obj/machinery/small_incubator/proc/open
	
	if(isactive())
		verbs |= /obj/machinery/small_incubator/proc/turn_off_incubator
		verbs -= /obj/machinery/small_incubator/proc/turn_on_incubator
	else
		verbs |= /obj/machinery/small_incubator/proc/turn_on_incubator
		verbs -= /obj/machinery/small_incubator/proc/turn_off_incubator

/obj/machinery/small_incubator/proc/turn_on_incubator()
	set name = "Turn On Incubator"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	turn_active()
	visible_message("[user] turns on \the [src].")

/obj/machinery/small_incubator/proc/turn_off_incubator()
	set name = "Turn Off Incubator"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	turn_idle()
	visible_message("[user] turns off \the [src].")

/obj/machinery/small_incubator/verb/remove_beaker()
	set name = "Remove Beaker"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	turn_idle()
	visible_message("[user] removes \the [src]'s [output_beaker].")
	user.put_in_hands(output_beaker)
	output_beaker = null
	update_icon()
	update_verbs()

/obj/machinery/small_incubator/proc/open()
	set name = "Open Cover"
	set category = "Object"
	set src in view(1)

	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	turn_idle()
	update_icon()
	update_verbs()

/obj/machinery/small_incubator/proc/close()
	set name = "Close Cover"
	set category = "Object"
	set src in view(1)

	atom_flags &= (~ATOM_FLAG_OPEN_CONTAINER)
	update_icon()
	update_verbs()
