#define MINIMUM_GLOW_TEMPERATURE 323
#define MINIMUM_GLOW_VALUE       25
#define MAXIMUM_GLOW_VALUE       255
#define HEATER_MODE_HEAT         "heat"
#define HEATER_MODE_COOL         "cool"


/obj/machinery/reagent_temperature
	name = "chemical heater"
	desc = "A small electric Bunsen, used to heat beakers and vials of chemicals."
	icon = 'icons/obj/machines/heat_sources.dmi'
	icon_state = "hotplate"
	atom_flags = ATOM_FLAG_CLIMBABLE
	density =    TRUE
	anchored =   TRUE
	idle_power_usage = 0
	active_power_usage = 1.2 KILOWATTS

	var/image/glow_icon
	var/image/beaker_icon
	var/image/on_icon

	var/heater_mode =          HEATER_MODE_HEAT
	var/list/permitted_types = list(/obj/item/weapon/reagent_containers/glass)
	var/max_temperature =      300 CELCIUS
	var/min_temperature =      40  CELCIUS
	var/heating_power =        10 // K
	var/last_temperature
	var/target_temperature
	var/obj/item/container
	var/circuit_type = /obj/item/weapon/circuitboard/reagent_heater

/obj/machinery/reagent_temperature/cooler
	name = "chemical cooler"
	desc = "A small electric cooler, used to chill beakers and vials of chemicals."
	icon_state = "coldplate"
	heater_mode =      HEATER_MODE_COOL
	max_temperature =  30 CELCIUS
	min_temperature = -80 CELCIUS
	circuit_type =     /obj/item/weapon/circuitboard/reagent_heater/cooler

/obj/machinery/reagent_temperature/New()
	..()
	map_storage_saved_vars += ";container"

/obj/machinery/reagent_temperature/Initialize()

	target_temperature = min_temperature

	component_parts = list(
		new circuit_type(src),
		new /obj/item/weapon/stock_parts/micro_laser(src),
		new /obj/item/weapon/stock_parts/capacitor(src)
	)
	. = ..()
	RefreshParts()

/obj/machinery/reagent_temperature/Destroy()
	if(container)
		container.dropInto(loc)
		container = null
	. = ..()

/obj/machinery/reagent_temperature/RefreshParts()
	heating_power = initial(heating_power)

	var/obj/item/weapon/stock_parts/comp = locate(/obj/item/weapon/stock_parts/capacitor) in component_parts
	if(comp)
		heating_power *= comp.rating
	comp = locate(/obj/item/weapon/stock_parts/micro_laser) in component_parts
	if(comp)
		active_power_usage = max(0.5 KILOWATTS, initial(active_power_usage) - (comp.rating * 0.25 KILOWATTS))

/obj/machinery/reagent_temperature/Process()
	. = ..()
	if(. != PROCESS_KILL)
		if(temperature != last_temperature)
			queue_icon_update()
			SSnano.update_uis(src)
		if((inoperable() || !anchored) && use_power >= POWER_USE_ACTIVE)
			update_use_power(POWER_USE_IDLE)
			queue_icon_update()
			SSnano.update_uis(src)

/obj/machinery/reagent_temperature/attack_hand(var/mob/user)
	interact(user)

/obj/machinery/reagent_temperature/attack_ai(var/mob/user)
	interact(user)

/obj/machinery/reagent_temperature/ProcessAtomTemperature()
	if(use_power >= POWER_USE_ACTIVE)
		var/last_temperature = temperature
		if(heater_mode == HEATER_MODE_HEAT && temperature < target_temperature)
			temperature = min(target_temperature, temperature + heating_power)
		else if(heater_mode == HEATER_MODE_COOL && temperature > target_temperature)
			temperature = max(target_temperature, temperature - heating_power)
		if(temperature != last_temperature)
			if(container)
				QUEUE_TEMPERATURE_ATOMS(container)
			queue_icon_update()
		return TRUE // Don't kill this processing loop unless we're not powered.
	. = ..()

/obj/machinery/reagent_temperature/attackby(var/obj/item/thing, var/mob/user)

	if(default_deconstruction_screwdriver(user, thing))
		return

	if(default_deconstruction_crowbar(user, thing))
		return

	if(default_part_replacement(user, thing))
		return

	if(isWrench(thing))
		if(use_power)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
		else
			anchored = !anchored
			visible_message(SPAN_NOTICE("\The [user] [anchored ? "secured" : "unsecured"] \the [src]."))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		return

	if(thing.reagents)
		for(var/checktype in permitted_types)
			if(istype(thing, checktype))
				if(container)
					to_chat(user, SPAN_WARNING("\The [src] is already holding \the [container]."))
				else if(user.unEquip(thing))
					thing.forceMove(src)
					container = thing
					visible_message(SPAN_NOTICE("\The [user] places \the [container] on \the [src]."))
					update_icon()
					SSnano.update_uis(src)
				return
		to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [thing]."))
	..()

/obj/machinery/reagent_temperature/update_icon()

	var/list/adding_overlays

	if(use_power >= POWER_USE_ACTIVE)
		if(!on_icon)
			on_icon = image(icon, "[icon_state]-on")
		LAZYADD(adding_overlays, on_icon)
		if(temperature > MINIMUM_GLOW_TEMPERATURE) // 50C
			if(!glow_icon)
				glow_icon = image(icon, "[icon_state]-glow")
			glow_icon.alpha = Clamp(temperature - MINIMUM_GLOW_TEMPERATURE, MINIMUM_GLOW_VALUE, MAXIMUM_GLOW_VALUE)
			LAZYADD(adding_overlays, glow_icon)
			set_light(0.2, 0.1, 1, l_color = COLOR_RED)
		else
			set_light(0)
	else
		set_light(0)

	if(container)
		if(!beaker_icon)
			beaker_icon = image(icon, "[icon_state]-beaker")
		LAZYADD(adding_overlays, beaker_icon)

	overlays = adding_overlays

/obj/machinery/reagent_temperature/interact(var/mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/reagent_temperature/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data = list()
	data["on"] 				   = use_power >= POWER_USE_ACTIVE? 1 : 0
	data["heating_power"] 	   = heating_power
	data["target_temperature"] = target_temperature
	data["target_temperatureC"] = target_temperature - T0C
	data["temperature"] 	   = temperature
	data["temperatureC"] 	   = temperature - T0C
	if(container)
		data["container"] = list("name" = container.name, "temperature" = container.temperature, "temperatureC" = container.temperature - T0C)
	else
		data["container"] = null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "hotplate.tmpl", name, 540, 380, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


///obj/machinery/reagent_temperature/CanUseTopic(var/mob/user, var/state, var/href_list)
//	if(href_list["remove_container"])
//		. = ..(user, GLOB.physical_state, href_list)
///		if(. == STATUS_CLOSE)
	//		to_chat(user, SPAN_WARNING("You are too far away."))
	//	return STATUS_CLOSE
	//return ..()

/obj/machinery/reagent_temperature/proc/ToggleUsePower()
	update_use_power(use_power <= POWER_USE_IDLE ? POWER_USE_ACTIVE : POWER_USE_IDLE)
	QUEUE_TEMPERATURE_ATOMS(src)
	update_icon()

/obj/machinery/reagent_temperature/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	if(href_list["adjust_temperature"])
		target_temperature = Clamp(target_temperature + text2num(href_list["adjust_temperature"]), min_temperature, max_temperature)
		return TOPIC_REFRESH
	if(href_list["toggle_power"])
		if(inoperable())
			to_chat(usr, SPAN_WARNING("The button clicks, but nothing happens."))
			return
		 ToggleUsePower()
		 return TOPIC_REFRESH
	if(href_list["remove_container"])
		if(container)
			container.dropInto(loc)
			usr.put_in_hands(container)
			container = null
			update_icon()
		return TOPIC_REFRESH
	//if(. == TOPIC_REFRESH)
	//	interact(user)

#undef MINIMUM_GLOW_TEMPERATURE
#undef MINIMUM_GLOW_VALUE
#undef MAXIMUM_GLOW_VALUE
#undef HEATER_MODE_HEAT
#undef HEATER_MODE_COOL