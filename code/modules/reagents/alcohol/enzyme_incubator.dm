/*
	Machinery for incubating stuff that's not viruses
*/
/obj/machinery/small_incubator
	name = "small incubator"
	desc = "This is an enzyme incubator. You just need to place some fresh produces, and add some nutriments to incubate some universal enzymes."
	density = 1
	anchored = 1
	icon = 'icons/obj/machines/enzymes_incubator.dmi'
	icon_state = "base"
	circuit_type = /obj/item/weapon/circuitboard/small_incubator
	active_power_usage = 120 WATTS
	idle_power_usage = 10 WATTS

	var/obj/item/weapon/reagent_containers/glass/beaker/internal_beaker = null
	var/obj/item/weapon/reagent_containers/glass/output_beaker = null
	var/obj/item/weapon/reagent_containers/food/snacks/grown/produce = null
	var/open = FALSE					//If the cover is open
	var/working = FALSE					//If the incubator is on
	var/produces_loaded = 0				//Count of the currently loaded produces
	var/max_produces = 10				//Max amount of produce you can store in this at a time
	var/enzyme_created = 1				//nb of units of enzyme created per bunch
	var/convertion_rate = 5 			//Nb of ticks for "enzyme_created" unit of enzyme
	var/convertion_ratio = 10 			//How much nutrients are required per "enzyme_created" unit of enzyme
	var/max_temperature = 80 CELSIUS	//It can get up to this temperature to incubate the content
	var/set_temperature = 0 CELSIUS		//The current temperature setting
	var/heating_power = 10
	var/time_last_process = 0			//Time we last processed the content

/obj/machinery/small_incubator/New()
	..()
	ADD_SAVED_VAR(internal_beaker)
	ADD_SAVED_VAR(output_beaker)
	ADD_SAVED_VAR(open)
	ADD_SAVED_VAR(working)
	ADD_SAVED_VAR(set_temperature)

/obj/machinery/small_incubator/after_load()
	. = ..()
	produces_loaded = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/P in InsertedContents())
		produces_loaded++

/obj/machinery/small_incubator/Destroy()
	if(output_beaker)
		output_beaker.dropInto(loc)
		output_beaker = null
	produce = null
	internal_beaker = null
	. = ..()

/obj/machinery/small_incubator/SetupParts()
	. = ..()
	//We already create this in the base class. So just fetch it
	internal_beaker = locate(/obj/item/weapon/reagent_containers/glass/beaker) in component_parts

// /obj/machinery/small_incubator/SetupReagents()
// 	..()
// 	create_reagents(internal_beaker.volume)

/obj/machinery/small_incubator/proc/open()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	open = TRUE
	turn_idle()
	update_icon()

/obj/machinery/small_incubator/proc/close()
	atom_flags &= (~ATOM_FLAG_OPEN_CONTAINER)
	open = FALSE
	update_icon()

/obj/machinery/small_incubator/proc/eject_beaker()
	if(!output_beaker)
		return
	turn_idle()
	update_icon()
	output_beaker.dropInto(loc)
	output_beaker = null


/obj/machinery/small_incubator/proc/can_process()
	return !open && (output_beaker &&  output_beaker.reagents.get_free_space() < 0) || (produce && produce.potency >= 0) || (internal_beaker && internal_beaker.reagents.has_reagent(/datum/reagent/nutriment, convertion_ratio) )

/obj/machinery/small_incubator/on_update_icon()
	. = ..()
	overlays.Cut()
	icon_state = initial(icon_state)
	if(open)
		overlays |= image(icon, "open")
		if(internal_beaker && internal_beaker.reagents)
			var/datum/reagent/R = internal_beaker.reagents.get_master_reagent()
			if(R)
				var/image/I = image(icon, "reagent_fill")
				I.color = R.color
				overlays |= I

	if(operable())
		if(working)
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
	
	if(working)
		to_chat(user, "Its currently incubating something.")

	if(output_beaker &&  output_beaker.reagents.get_free_space() < 0)
		to_chat(user, SPAN_WARNING("It seems like \the [src] has stopped because \the [output_beaker] is full!"))

	if(produces_loaded)
		to_chat(user, "There are [produces_loaded] produces loaded in the bin.")
	else
		to_chat(user, SPAN_WARNING("There are no produces loaded in the bin."))
	
	if(internal_beaker && internal_beaker.reagents.get_free_space() < internal_beaker.volume)
		to_chat(user, "It has some reagents inside its tank..")

/obj/machinery/small_incubator/on_reagent_change()
	. = ..()
	update_icon()

/obj/machinery/small_incubator/Process()
	. = .()
	if(inoperable())
		return
	
	if((world.time + convertion_rate) >= time_last_process)
		if(can_process())
			var/datum/reagents/I = internal_beaker.reagents
			if(output_beaker.reagents.get_free_space() >= enzyme_created && I.remove_reagent(/datum/reagent/nutriment, convertion_ratio))
				output_beaker.reagents.add_reagent(/datum/reagent/enzyme, enzyme_created)
				produce.potency = max(0, produce.potency - 1) //Take some potency from the produce
				if(produce.potency <= 0)
					switch_produce()
				use_power_oneoff(active_power_usage)
		else if(working)
			turn_idle()
	
	time_last_process = world.time

//This is called when our produce got a bit too degraded by the process and has to be swaped for another in our storage
/obj/machinery/small_incubator/proc/switch_produce()
	QDEL_NULL(produce)
	produces_loaded--
	var/obj/item/weapon/reagent_containers/food/snacks/grown/P = locate() in InsertedContents()
	if(P)
		produce = P

/obj/machinery/small_incubator/ProcessAtomTemperature()
	if(working && use_power >= POWER_USE_ACTIVE)
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
	else if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		if(produces_loaded < max_produces)
			var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O 
			user.unEquip(O)
			G.forceMove(src)
			produces_loaded++
			to_chat(user, SPAN_NOTICE("You add \a [G] to \the [src]'s bin. There are now [produces_loaded] produce loaded."))
		else
			to_chat(user, SPAN_WARNING("You can't add any more. \The [src] has only room for [max_produces] produce(s)."))
	else 
		return ..()

/obj/machinery/small_incubator/attack_hand(mob/user)
	. = ..()
	if(!isactive())
		turn_active()
	else
		turn_idle()
	visible_message("[user] [isactive()? "turns on" : "turns off"] \the [src].")
	
/obj/machinery/small_incubator/CtrlAltClick(mob/user)
	. = ..()
	if(!open)
		open()
	else
		close()
	visible_message("[user] [open? "opens" : "closes"] \the [src]'s cover.")

/obj/machinery/small_incubator/CtrlClick(mob/user)
	. = ..()
	if(output_beaker)
		visible_message("[user] removes \the [src]'s [output_beaker].")
		user.put_in_hands(output_beaker)
		output_beaker = null
		turn_idle()

/obj/machinery/small_incubator/AltClick(mob/user)
	. = ..()
	if(produces_loaded)
		visible_message("[user] empties \the [src]'s bin.")
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in InsertedContents() )
			G.dropInto(loc)
		produces_loaded = 0
		

/obj/machinery/small_incubator/turn_active()
	. = ..()
	working = TRUE
	
/obj/machinery/small_incubator/turn_idle()
	. = ..()
	working = FALSE
	