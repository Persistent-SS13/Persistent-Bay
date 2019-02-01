var/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	anchored = FALSE
	use_power = POWER_USE_OFF
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 250)
	max_health = 10
	sound_hit = 'sound/effects/Glasshit.ogg'
	sound_destroyed = "shatter"
	var/default_light_range = 4
	var/default_light_power = 2
	var/default_light_colour = "#ffffff"
	var/flicker = 0 //Used for randomizing the flicker effect

/obj/machinery/floor_light/prebuilt
	anchored = TRUE

/obj/machinery/floor_light/after_load()
	..()
	update_brightness()

/obj/machinery/floor_light/Destroy()
	turn_off()
	. = ..()


/obj/machinery/floor_light/after_load()
	..()
	update_brightness()

/obj/machinery/floor_light/Destroy()
	turn_off()
	. = ..()

/obj/machinery/floor_light/attackby(var/obj/item/W, var/mob/user)
	if(isScrewdriver(W))
		anchored = !anchored
		if(!anchored)
			turn_off()
		visible_message("<span class='notice'>\The [user] has [anchored ? "attached" : "detached"] \the [src].</span>")
		return TRUE
	else if(isWelder(W) && isbroken())
		var/obj/item/weapon/tool/weldingtool/WT = W
		if(!WT.remove_fuel(0, user))
			to_chat(user, "<span class='warning'>\The [src] must be on to complete this task.</span>")
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(!do_after(user, 20, src))
			return
		if(!src || !WT.isOn())
			return
		visible_message("<span class='notice'>\The [user] has repaired \the [src].</span>")
		set_broken(FALSE)
		update_brightness()
		return TRUE
	return ..()

/obj/machinery/floor_light/update_use_power(var/new_use_power)
	..()
	update_brightness()

/obj/machinery/floor_light/proc/toggle()
	//if(ison())
	//	turn_off()
	//else
	//	turn_on()

/obj/machinery/floor_light/attack_hand(var/mob/user)
	if(..())
		return TRUE
	if(!anchored)
		to_chat(user, "<span class='warning'>\The [src] must be screwed down first.</span>")
		return TRUE
	else if(isbroken())
		to_chat(user, "<span class='warning'>\The [src] is too damaged to be functional.</span>")
		return TRUE
	else if(!ispowered())
		to_chat(user, "<span class='warning'>\The [src] is unpowered.</span>")
		return TRUE

	toggle()
	visible_message("<span class='notice'>\The [user] turns \the [src] [use_power == POWER_USE_ACTIVE ? "on" : "off"].</span>")
	return TRUE

/obj/machinery/floor_light/proc/update_brightness()
	//if(ison())
	//	if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
	//		set_light(default_light_range, default_light_power, default_light_colour)
	//else
	//	turn_off()
	//	if(light_range || light_power)
	//		set_light(0)

	active_power_usage = ((light_range + light_power) * 10)
	update_icon()

/obj/machinery/floor_light/update_icon()
	overlays.Cut()
	//if(ison() && ispowered())
	//	if(health >= (max_health * break_threshold))
	//		var/cache_key = "floorlight-[default_light_colour]"
	//		if(!floor_light_cache[cache_key])
	//			var/image/I = image("on")
	//			I.color = default_light_colour
	//			I.plane = plane
	//			I.layer = layer+0.001
	//			floor_light_cache[cache_key] = I
	//		overlays |= floor_light_cache[cache_key]
	//	else
	//		if(flicker == 0) //Needs init.
	//			flicker = rand(1,4)
	//		var/cache_key = "floorlight-broken[flicker]-[default_light_colour]"
	//		if(!floor_light_cache[cache_key])
	//			var/image/I = image("flicker[flicker]")
	//			I.color = default_light_colour
	//			I.plane = plane
	//			I.layer = layer+0.001
	//			floor_light_cache[cache_key] = I
	//		overlays |= floor_light_cache[cache_key]
