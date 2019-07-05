GLOBAL_LIST_EMPTY(doppler_arrays)

///obj/machinery/doppler_array
//	name = "tachyon-doppler array"
//	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."


// /obj/machinery/doppler_array/New()
// 	..()
// 	doppler_arrays += src

// /obj/machinery/doppler_array/Destroy()
// 	doppler_arrays -= src
// 	..()

// /obj/machinery/doppler_array/proc/sense_explosion(var/x0,var/y0,var/z0,var/devastation_range,var/heavy_impact_range,var/light_impact_range,var/took)
// 	if(stat & NOPOWER)	return
// 	if(z != z0)			return

// 	var/dx = abs(x0-x)
// 	var/dy = abs(y0-y)
// 	var/distance
// 	var/direct

// 	if(dx > dy)
// 		distance = dx
// 		if(x0 > x)	direct = EAST
// 		else		direct = WEST
// 	else
// 		distance = dy
// 		if(y0 > y)	direct = NORTH
// 		else		direct = SOUTH

// 	if(distance > 100)		return
// 	if(!(direct & dir))	return

// 	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]. Temporal displacement of tachyons: [took]seconds."

// 	for(var/mob/O in hearers(src, null))
// 		O.show_message("<span class='game say'><span class='name'>[src]</span> states coldly, \"[message]\"</span>",2)

// /obj/machinery/doppler_array/update_icon()
// 	if(stat & BROKEN)
// 		icon_state = "[initial(icon_state)]-broken"
// 	else if( !(stat & NOPOWER) )
// 		icon_state = initial(icon_state)
// 	else
// 		icon_state = "[initial(icon_state)]-off"

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array.\n"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	density = TRUE
	circuit_type = /obj/item/weapon/circuitboard/doppler_array
	max_health = 100
	var/cooldown = 10
	var/next_announce = 0
	var/integrated = FALSE
	var/max_dist = 150

/obj/machinery/doppler_array/Initialize()
	. = ..()
	GLOB.doppler_arrays += src

/obj/machinery/doppler_array/Destroy()
	GLOB.doppler_arrays -= src
	return ..()

/obj/machinery/doppler_array/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("Its dish is facing to the [dir2text(dir)]."))

/obj/machinery/doppler_array/Process()
	return PROCESS_KILL

/obj/machinery/doppler_array/attackby(obj/item/I, mob/user, params)
	if(isWrench(I))
		if(!anchored && !isinspace())
			anchored = TRUE
			power_change()
			to_chat(user, "<span class='notice'>You fasten [src].</span>")
		else if(anchored)
			anchored = FALSE
			power_change()
			to_chat(user, "<span class='notice'>You unfasten [src].</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
	else
		return ..()

///obj/machinery/doppler_array/proc/rot_message(mob/user)
//	to_chat(user, "<span class='notice'>You adjust [src]'s dish to face to the [dir2text(dir)].</span>")
//	playsound(src, 'sound/items/screwdriver2.ogg', 50, 1)

/obj/machinery/doppler_array/proc/sense_explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range,
												  took, orig_dev_range, orig_heavy_range, orig_light_range)
	if(!ispowered())
		return FALSE
	var/turf/zone = get_turf(src)
	if(zone.z != epicenter.z)
		return FALSE

	if(next_announce > world.time)
		return
	next_announce = world.time + cooldown

	var/distance = get_dist(epicenter, zone)
	var/direct = get_dir(zone, epicenter)

	if(distance > max_dist)
		return FALSE
	if(!(direct & dir))
		return FALSE


	var/list/messages = list("Explosive disturbance detected.", \
							 "Epicenter at: grid ([epicenter.x],[epicenter.y]). Temporal displacement of tachyons: [took] seconds.", \
							 "Factual: Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range].")

	// If the bomb was capped, say its theoretical size.
	if(devastation_range < orig_dev_range || heavy_impact_range < orig_heavy_range || light_impact_range < orig_light_range)
		messages += "Theoretical: Epicenter radius: [orig_dev_range]. Outer radius: [orig_heavy_range]. Shockwave radius: [orig_light_range]."

	for(var/message in messages)
		state(message)
	return TRUE

/obj/machinery/doppler_array/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(powered() && anchored)
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]-off"
			stat |= NOPOWER