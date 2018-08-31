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
		material = SSmaterials.get_material_by_name("steel")
	if(!p_material)
		p_material = SSmaterials.get_material_by_name("steel")

	explosion_resistance = ExplosionArmor()

	if(updateIntegrity)
		integrity = MaxIntegrity()

	set_opacity(p_material.opacity >= 0.5)

	radiation_repository.resistance_cache.Remove(src)

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
	for(var/i = 1 to 4)
		I = image('icons/turf/wall_masks.dmi', "[r_material ? p_material.icon_reinf : p_material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = p_material.icon_colour
		overlays = overlays.Copy() + I

	if(r_material)
		if(state == null)
			I = image('icons/turf/wall_masks.dmi', "reinf_over")
			I.color = r_material.icon_colour
			overlays = overlays.Copy() + I
		else
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[state]")
			I.color = r_material.icon_colour
			overlays = overlays.Copy() + I
		if(state >= 5 || state == null)
			I = image('icons/turf/wall_masks.dmi', "reinf_metal")
			I.color = "#666666"
			overlays = overlays.Copy() + I

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
	var/list/dirs = list()
	for(var/turf/simulated/wall/W in orange(src, 1))
		if(!W.p_material)
			continue
		if(propagate)
			W.update_connections()
		if(can_join_with(W))
			dirs += get_dir(src, W)
		W.update_icon()

	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(state == null && W.state == null && p_material.name == W.p_material.name)
		return 1
	return 0
