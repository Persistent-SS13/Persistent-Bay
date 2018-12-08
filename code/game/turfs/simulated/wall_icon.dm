#define BLEND_TURFS			list(/turf/simulated/wall/cult)
#define BLEND_OBJECTS 		list(/obj/machinery/door, /obj/structure/wall_frame, /obj/structure/grille, /obj/structure/window/reinforced/full, /obj/structure/window/reinforced/polarized/full, /obj/structure/window/shuttle, ,/obj/structure/window/phoronbasic/full, /obj/structure/window/phoronreinforced/full) // Objects which to blend with
#define NO_BLEND_OBJECTS 	list(/obj/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.

/turf/simulated/wall/proc/update_full(var/propagate, var/integrity)
	update_material(integrity)
	update_connections(propagate)
	update_icon()


/turf/simulated/wall/proc/update_material(var/updateIntegrity)

	if(!istype(material, /material))
		if(istext(material))
			material = SSmaterials.get_material_by_name(material)
			updateIntegrity = 1
		else
			material = null
	if(!istype(r_material, /material))
		if(istext(r_material))
			r_material = SSmaterials.get_material_by_name(r_material)
			updateIntegrity = 1
		else
			r_material = null
	if(!istype(p_material, /material))
		if(istext(p_material))
			p_material = SSmaterials.get_material_by_name(p_material)
			updateIntegrity = 1
		else
			r_material = null

	if(!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	if(!p_material)
		p_material = SSmaterials.get_material_by_name(MATERIAL_STEEL)

	explosion_resistance = ExplosionArmor()

	if(updateIntegrity)
		integrity = MaxIntegrity()

	set_opacity(p_material.opacity >= 0.5)

	SSradiation.resistance_cache.Remove(src)


/turf/simulated/wall/update_icon()
	if(!material || !p_material)
		update_material(1)

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if(r_material)
		name = "[state != null ? "incomplete " : ""][r_material.display_name] reinforced [p_material.display_name] [initial(name)]"
		desc = "It seems to be [state != null ? "an incomplete" : "a"] section of hull reinforced with [r_material.display_name] and plated with [p_material.display_name]."
	else
		name = "[state != null ? "incomplete " : ""][p_material.display_name] [initial(name)]"
		desc = "It seems to be [state != null ? "an incomplete" : "a"] section of hull plated with [p_material.display_name]."

	overlays.Cut()
	var/image/I
	var/base_color = paint_color ? paint_color : p_material.icon_colour

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image('icons/turf/wall_masks.dmi', "[p_material.icon_base]_other[wall_connections[i]]", dir = 1<<(i-1))
		else
			I = image('icons/turf/wall_masks.dmi', "[p_material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = base_color
		overlays += I

	if(r_material)
		var/reinf_color = paint_color ? paint_color : r_material.icon_colour
		if(state == null)
			I = image('icons/turf/wall_masks.dmi', "reinf_over")
			I.color = reinf_color
			overlays = overlays.Copy() + I
		else
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[state]")
			I.color = reinf_color
			overlays = overlays.Copy() + I

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image('icons/turf/wall_masks.dmi', "stripe_other[wall_connections[i]]", dir = 1<<(i-1))
			else
				I = image('icons/turf/wall_masks.dmi', "stripe[wall_connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			overlays += I

	if(integrity != MaxIntegrity())
		var/overlay = round(damage_overlays.len * (1 / (integrity / MaxIntegrity())))
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		overlays = overlays.Copy() + damage_overlays[overlay]
	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!p_material)
		return
	var/list/wall_dirs = list()
	var/list/other_dirs = list()
	for(var/turf/simulated/wall/W in orange(src, 1))
		switch(can_join_with(W))
			if(0)
				continue
			if(1)
				wall_dirs += get_dir(src, W)
			if(2)
				wall_dirs += get_dir(src, W)
				other_dirs += get_dir(src, W)
		if(propagate)
			W.update_connections()
			W.update_icon()

	for(var/turf/T in orange(src, 1))
		var/success = 0
		for(var/obj/O in T)
			for(var/b_type in BLEND_OBJECTS)
				if(istype(O, b_type))
					success = 1
				for(var/nb_type in NO_BLEND_OBJECTS)
					if(istype(O, nb_type))
						success = 0
				if(success)
					break
			if(success)
				break

		if(success)
			wall_dirs += get_dir(src, T)
			if(get_dir(src, T) in GLOB.cardinal)
				other_dirs += get_dir(src, T)

	wall_connections = dirs_to_corner_states(wall_dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(p_material && W && W.p_material)
		if(state == null && W.state == null && p_material.name == W.p_material.name)
			return 1
	for(var/wb_type in BLEND_TURFS)
		if(istype(W, wb_type))
			return 2
	return 0

#undef BLEND_TURFS
#undef BLEND_OBJECTS
#undef NO_BLEND_OBJECTS
