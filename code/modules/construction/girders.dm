/obj/structure/girder
	name = "girder"
	desc = "The internals of a wall"
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder_d"
	anchored = 0
	density = 1
	plane = OBJ_PLANE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER
	max_health = 200
	armor = list()
	var/state = 0
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material

/obj/structure/girder/anchored
	icon_state = "girder"
	anchored = 1

/obj/structure/girder/New(var/newloc, var/mat, var/r_mat)
	..(newloc)
	material = istext(mat) ? SSmaterials.get_material_by_name(mat) : mat
	reinf_material = istext(r_mat) ?  SSmaterials.get_material_by_name(r_mat) : r_mat

	ADD_SAVED_VAR(state)
	ADD_SAVED_VAR(reinf_material)
	ADD_SAVED_VAR(cover)

	ADD_SKIP_EMPTY(reinf_material)

/obj/structure/girder/Initialize(var/mapload, var/mat, var/r_mat)
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/simple, 100)
	. = ..()
	if(!map_storage_loaded)
		material = (istext(mat))?  SSmaterials.get_material_by_name(mat) : mat
		reinf_material = (istext(r_mat))?  SSmaterials.get_material_by_name(r_mat) : r_mat
		update_material(1) // Handles lack of material
	else
		update_material()

/obj/structure/girder/CanFluidPass(var/coming_from)
	return TRUE

/obj/structure/girder/proc/reset_girder()
	anchored = TRUE
	cover = initial(cover)
	health = min(health,max_health)
	state = 2
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/on_update_icon()
	color = material.icon_colour
	overlays.Cut()
	if(anchored)
		switch(state)
			if(0)
				icon_state = "girder_d"
			if(1)
				icon_state = "girder_w"
			else
				icon_state = "girder"
		if(reinf_material)
			var/image/I = image(icon, "girder_r")
			I.color = reinf_material.icon_colour
			overlays += I
	else
		icon_state = "girder_d"
	name = "[reinf_material ? "[reinf_material.display_name] reinforced " : ""][material.display_name] [initial(name)]"
	desc = "It seems to be a [reinf_material ? "[reinf_material.display_name] reinforced " : ""][material.display_name] [initial(name)]."

/obj/structure/girder/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		to_chat(user, SPAN_NOTICE("You drill through \the [src]!"))
		dismantle()
		return 1
	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))
		to_chat(user, SPAN_NOTICE("Now slicing apart \the [src]..."))
		if(do_after(user, 3 SECONDS, src))
			if(!src) return
			to_chat(user, SPAN_NOTICE("You slice apart \the [src]!"))
			dismantle()
			return 1
	switch(state)
		if(0)
			if(Weld(W, user, null, "You start to dismantle \the [src]"))
				to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
				dismantle()
				return 1
			if(!anchored && Wrench(W, user, null, "You start to disassemble \the [src]"))
				to_chat(user, "<span class='notice'>You disassemble \the [src] into parts.</span>")
				new /obj/item/girderpart(get_turf(src), material)
				qdel(src)
				return 1
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You pry \the [src] [anchored ? "out of" : "into"] place</span>")
				anchored = !anchored
				update_icon()
				return 1
			if(anchored && Wrench(W, user))
				to_chat(user, "<span class='notice'>You secure \the [src] into place.</span>")
				anchored = 1
				state = 1
				update_icon()
				return 1
		if(1)
			if(Weld(W, user, null, "You start to weld \the [src] into place."))
				to_chat(user, "<span class='notice'>You weld \the [src] into place.</span>")
				state = 2
				update_icon()
				return 1
			if(Wrench(W, user, null))
				to_chat(user, "<span class='notice'>You unsecure \the [src].</span>")
				state = 0
				update_icon()
				return 1
		if(2)
			if(Weld(W, user, null, "You start to unweld \the [src] from the floor."))
				to_chat(user, "<span class='notice'>You unweld \the [src] from the floor.</span>")
				state = 1
				update_icon()
				return 1
			if(ConstructWall(W, user))
				qdel(src)
				return 1
			if(Screwdriver(W, user, 0))
				to_chat(user, "<span class='notice'>\The [src] can now be reinforced.</span>")
				state = 3
				update_icon()
				return 1
		if(3)
			if(reinforce_with_material(W, user))
				state = 4
				return 1
			if(Screwdriver(W, user, 0))
				to_chat(user, "<span class='notice'>\The [src] can now be constructed.</span>")
				state = 2
				update_icon()
				return 1
		if(4)
			if(Wrench(W, user, 10))
				to_chat(user, "<span class='notice'>You secure the material to \the [src]</span>")
				state = 5
				update_icon()
				return 1
			if(Crowbar(W, user, 5, "You start prying \the [reinf_material.display_name] up."))
				to_chat(user, "<span class='notice'>You finish prying \the [reinf_material.display_name].</span>")
				new reinf_material.stack_type(get_turf(src), 4)
				reinf_material = null
				state = 3
				update_icon()
				return 1
		if(5)
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You bend the material around \the [src]</span>")
				state = 6
				update_icon()
				return 1
			if(Wrench(W, user, 10))
				to_chat(user, "<span class='notice'>You unsecure the material from \the [src].</span>")
				state = 4
				update_icon()
				return 1
		if(6)
			if(Weld(W, user))
				to_chat(user, "<span class='notice'>You weld the material to \the [src]</span>")
				state = 7
				update_icon()
				return 1
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You unbend the material from around \the [src]</span>")
				state = 5
				update_icon()
				return 1
		if(7)
			if(ConstructWall(W, user))
				qdel(src)
				return 1
			if(Weld(W, user))
				to_chat(user, "<span class='notice'>You unweld the material from \the [src]</span>")
				state = 6
				update_icon()
				return 1
	return ..()

/obj/structure/girder/proc/ConstructWall(var/obj/item/stack/material/S, var/mob/user)
	if(!istype(S))
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)

	if(M.integrity < 50)
		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
		return 0

	if(!UseMaterial(S, user, null, "You start applying the material.", null, null, 4))
		return 0

	to_chat(user, "<span class='notice'>You finish applying the material.</span>")
	add_hiddenprint(usr)
	

	var/turf/myTurf = get_turf(src)
	myTurf.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, null) //Don't set the reinforced material yet
	T.girder_material = material
	T.girder_reinf_material = reinf_material
	T.update_material(1)
	T.state = 0
	T.can_open = !anchored
	T.add_hiddenprint(usr)
	T.update_icon()
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user)
	if(!istype(S))
		return 0

	if(reinf_material)
		to_chat(user, SPAN_NOTICE("This girder has already been reinforced."))
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)

	if(M.integrity < 50)
		to_chat(user, "<span class='notice'>This material is too soft for use in girder reinforcement.</span>")
		return 0

	if(!UseMaterial(S, user, null, "You start applying the reinforcement.", null, null, 4))
		return 0

	to_chat(user, "<span class='notice'>You finish applying the reinforcement.</span>")
	add_hiddenprint(usr)

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = 75
	update_material(1)
	state = 7
	update_icon()

/obj/structure/girder/proc/update_material(var/update_Integrity)
	if(!istype(material, /material))
		if(istext(material))
			material = SSmaterials.get_material_by_name(material)
			update_Integrity = 1
		else
			material = null
	if(!istype(reinf_material, /material))
		if(istext(reinf_material))
			reinf_material = SSmaterials.get_material_by_name(reinf_material)
			update_Integrity = 1
		else
			reinf_material = null
	if(!material)
		material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)
		update_Integrity = 1

	if(update_Integrity)
		max_health = maxIntegrity()
		health = max_health
	armor[DAM_BOMB]  = explosionArmor()
	armor[DAM_BURN]  = burnArmor()
	armor[DAM_BLUNT] = bruteArmor()
	on_update_icon()

/obj/structure/girder/make_debris()
	var/curturf = get_turf(src)
	if(material)
		material.place_shard(curturf)
		material.place_shard(curturf)
	if(reinf_material)
		reinf_material.place_shard(curturf)

/obj/structure/girder/dismantle()
	var/turf/curturf = get_turf(src)
	playsound(curturf, 'sound/items/Welder.ogg', 100, 1)
	new /obj/item/girderpart(curturf, material)
	if(reinf_material)
		new reinf_material.stack_type(curturf, 4)
	material = null
	reinf_material = null
	qdel(src)

// Get procs, different naming style
/obj/structure/girder/proc/maxIntegrity()
	return material.integrity + (reinf_material ? reinf_material.integrity + (material.integrity * reinf_material.integrity / 100) : 0)

/obj/structure/girder/proc/bruteArmor()
	return material.brute_armor + (reinf_material ? reinf_material.brute_armor + (material.brute_armor * reinf_material.brute_armor / 100) : 0)

/obj/structure/girder/proc/burnArmor()
	return material.burn_armor + (reinf_material ? reinf_material.burn_armor + (material.burn_armor * reinf_material.burn_armor / 100) : 0)

/obj/structure/girder/proc/explosionArmor()
	return material.hardness + (reinf_material ? reinf_material.hardness + (material.hardness * reinf_material.hardness / 100) : 0)
