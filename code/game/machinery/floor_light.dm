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
	var/default_light_max_bright = 0.75
	var/default_light_inner_range = 1
	var/default_light_outer_range = 3
	var/default_light_colour = "#ffffff"

/obj/machinery/floor_light/prebuilt
	anchored = TRUE

/obj/machinery/floor_light/New()
	..()
	testing("created [src]\ref[src] ([x], [y], [z]) loc: [loc]")

/obj/machinery/floor_light/after_load()
	..()
	update_brightness()

/obj/machinery/floor_light/Destroy()
	testing("Deleting floor_light from [loc]")
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
	else if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		to_chat(user, "<span class='notice'>You dismantle the floor light.</span>")
		new /obj/item/stack/material/steel(src.loc, 1)
		new /obj/item/stack/material/glass(src.loc, 1)
		qdel(src)
		return TRUE
	return ..()

/obj/machinery/floor_light/update_use_power(var/new_use_power)
	..()
	update_brightness()

/obj/machinery/floor_light/proc/toggle()
	if(ison())
		turn_off()
	else
		turn_on()

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
	if(ison())
		if(light_outer_range != default_light_outer_range || light_max_bright != default_light_max_bright || light_color != default_light_colour)
			set_light(default_light_max_bright, default_light_inner_range, default_light_outer_range, l_color = default_light_colour)
	else
		if(light_outer_range || light_max_bright)
			set_light(0)

	change_power_consumption((light_outer_range + light_max_bright) * 20, POWER_USE_ACTIVE)
	queue_icon_update()

/obj/machinery/floor_light/on_update_icon()
	overlays.Cut()
	var/damaged = isdamaged()
	if(ison() && ispowered())
		if(!isbroken())
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
