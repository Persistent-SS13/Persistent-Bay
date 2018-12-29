/obj/machinery/disease2/diseaseanalyser
	name = "disease analyser"
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"
	anchored = 1
	density = 1
	var/scanning = FALSE
	var/obj/item/weapon/virusdish/dish = null
	var/time_scan_end

/obj/machinery/disease2/diseaseanalyser/New()
	..()
	ADD_SAVED_VAR(scanning)
	ADD_SAVED_VAR(dish)
	ADD_SAVED_VAR(time_scan_end)

	ADD_SKIP_EMPTY(dish)
	ADD_SKIP_EMPTY(time_scan_end)

/obj/machinery/disease2/diseaseanalyser/Initialize()
	. = ..()
	if(!map_storage_loaded)
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/diseaseanalyser(src)
		component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
		component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
		component_parts += new /obj/item/weapon/computer_hardware/hard_drive/portable(src)
	RefreshParts()

/obj/machinery/disease2/diseaseanalyser/before_save()
	. = ..()
	//Convert to absolute time
	if(scanning && time_scan_end)
		time_scan_end = world.time - time_scan_end

/obj/machinery/disease2/diseaseanalyser/after_load()
	. = ..()
	//Convert to relative time
	if(scanning && time_scan_end)
		time_scan_end = world.time + time_scan_end

/obj/machinery/disease2/diseaseanalyser/update_icon()
	if(scanning)
		icon_state = "analyser_processing"
	else
		icon_state = "analyser" 

/obj/machinery/disease2/diseaseanalyser/proc/insert_dish(var/obj/item/weapon/virusdish/D, var/mob/living/user)
	if(!istype(D))
		src.state("Invalid virus dish format.. Check dish and try again..")
		return FALSE
	if(dish)
		to_chat(user, "\The [src] is already loaded.")
		return FALSE
	dish = D
	user.drop_from_inventory(D)
	D.forceMove(src)
	return TRUE

/obj/machinery/disease2/diseaseanalyser/proc/eject_dish()
	dish.forceMove(get_turf(src))
	dish = null

/obj/machinery/disease2/diseaseanalyser/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return 1
	else if(default_deconstruction_crowbar(user, O))
		return 1
	else if(istype(O,/obj/item/weapon/virusdish))
		if(!insert_dish(O, user))
			return 1
		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		if(dish.virus2 && dish.growth > 50)
			dish.growth -= 10
			time_scan_end = world.time + 5 SECONDS
			scanning = TRUE
		else
			src.state("\The [src] buzzes, \"Insufficient growth density to complete analysis.\"")
			eject_dish()
		return 1
	else 
		return ..()

/obj/machinery/disease2/diseaseanalyser/Process()
	if(inoperable())
		return

	if(scanning && world.time > time_scan_end)
		scanning = FALSE
		time_scan_end = null
		finish_scan()
	return

/obj/machinery/disease2/diseaseanalyser/proc/finish_scan()
	if(!dish || (dish && !dish.virus2))
		return
	if (dish.virus2.addToDB())
		ping("\The [src] pings, \"New pathogen added to data bank.\"")

	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
	P.name = "paper - [dish.virus2.name()]"

	var/r = dish.virus2.get_info()
	P.info = {"
		[virology_letterhead("Post-Analysis Memo")]
		[r]
		<hr>
		<u>Additional Notes:</u>&nbsp;
"}
	dish.basic_info = dish.virus2.get_basic_info()
	dish.info = r
	dish.name = "[initial(dish.name)] ([dish.virus2.name()])"
	dish.analysed = 1
	eject_dish()
	src.state("\The [src] prints a sheet of paper.")