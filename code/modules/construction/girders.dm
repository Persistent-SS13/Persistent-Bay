
/obj/structure/girder
	name = "girder"
	desc = "The internals of a wall"
	icon_state = "girder_d"
	anchored = 0
	density = 1
	plane = OBJ_PLANE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER
	var/state = 0
	var/integrity = 150	// Placeholder until assigned
	var/material/material
	var/material/r_material

/obj/structure/girder/New(var/newloc, var/mat, var/r_mat)
	..(newloc)
	material = mat
	r_material = r_mat
	update_material(1) // Handles lack of material

/obj/structure/girder/after_load()
	update_material()

/obj/structure/girder/update_icon()
	color = material.icon_colour
	overlays.Cut()
	switch(state)
		if(0)
			icon_state = "girder_d"
		if(1)
			icon_state = "girder_w"
		else
			icon_state = "girder"
	name = "[r_material ? "[r_material.display_name] reinforced " : ""][material.display_name] [initial(name)]"
	desc = "It seems to be a [r_material ? "[r_material.display_name] reinforced " : ""][material.display_name] [initial(name)]."
	if(r_material)
		var/image/I = image('icons/obj/structures.dmi', "girder_r")
		I.color = r_material.icon_colour
		overlays += I

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	switch(state)
		if(0)
			if(Weld(W, user, null, "You start to dismantle \the [src]"))
				to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
				dismantle()
				return
			if(!anchored && Wrench(W, user, null, "You start to disassemble \the [src]"))
				to_chat(user, "<span class='notice'>You disassemble \the [src] into parts.</span>")
				new /obj/item/girderpart(get_turf(src), material)
				qdel(src)
				return
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You pry \the [src] [anchored ? "out of" : "into"] place</span>")
				anchored = !anchored
				update_icon()
				return
			if(anchored && Wrench(W, user))
				to_chat(user, "<span class='notice'>You secure \the [src] into place.</span>")
				anchored = 1
				state = 1
				update_icon()
				return
		if(1)
			if(Weld(W, user, null, "You start to weld \the [src] into place."))
				to_chat(user, "<span class='notice'>You weld \the [src] into place.</span>")
				state = 2
				update_icon()
				return
			if(Wrench(W, user, null))
				to_chat(user, "<span class='notice'>You unsecure \the [src].</span>")
				state = 0
				update_icon()
				return
		if(2)
			if(Weld(W, user, null, "You start to unweld \the [src] from the floor."))
				to_chat(user, "<span class='notice'>You unweld \the [src] from the floor.</span>")
				state = 1
				update_icon()
				return
			if(UseMaterial(W, user, null, "You start applying the material.", null, null, 4))
				to_chat(user, "<span class='notice'>You finish applying the material.</span>")
				var/obj/item/stack/material/st = W
				make_wall(st.material, FALSE)
				qdel(src)
				return
			if(Screwdriver(W, user, 0))
				to_chat(user, "<span class='notice'>\The [src] can now be reinforced.</span>")
				state = 3
				update_icon()
				return
		if(3)
			if(UseMaterial(W, user, null, "You start reinforcing \the [src].", null, null, 6))
				r_material = W:material
				to_chat(user, "<span class='notice'>You reinforced \the [src] with \the [r_material.display_name]</span>")
				state = 4
				update_icon()
				return
			if(!r_material && Screwdriver(W, user, 0))
				to_chat(user, "<span class='notice'>\The [src] can now be constructed.</span>")
				state = 2
				update_icon()
				return
			if(r_material && Wirecutter(W, user, 5, "You start removing \the [r_material.display_name]."))
				to_chat(user, "<span class='notice'>You finish removing \the [r_material.display_name].</span>")
				new r_material.stack_type(src, 6)
				r_material = null
				state = 2
				update_icon()
				return
		if(4)
			if(Wrench(W, user, 10))
				to_chat(user, "<span class='notice'>You secure the material to \the [src]</span>")
				state = 5
				update_icon()
				return
			if(Crowbar(W, user, 5, "You start prying \the [r_material.display_name] up."))
				to_chat(user, "<span class='notice'>You finish prying \the [r_material.display_name].</span>")
				new r_material.stack_type(src, 2)
				state = 3
				update_icon()
				return
		if(5)
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You bend the material around \the [src]</span>")
				state = 6
				update_icon()
				return
			if(Wrench(W, user, 10))
				to_chat(user, "<span class='notice'>You unsecure the material from \the [src].</span>")
				state = 4
				update_icon()
				return
		if(6)
			if(Weld(W, user))
				to_chat(user, "<span class='notice'>You weld the material to \the [src]</span>")
				state = 7
				update_icon()
				return
			if(Crowbar(W, user))
				to_chat(user, "<span class='notice'>You unbend the material from around \the [src]</span>")
				state = 5
				update_icon()
				return
		if(7)
			if(UseMaterial(W, user, 20, "You start applying the material to \the [src]", null, null, 4))
				to_chat(user, "<span class='notice'>You apply the material to \the [src].</span>")
				var/obj/item/stack/material/st = W
				make_wall(st.material, TRUE)
				qdel(src)
				return
			if(Weld(W, user))
				to_chat(user, "<span class='notice'>You unweld the material from \the [src]</span>")
				state = 6
				update_icon()
				return

/obj/structure/girder/proc/make_wall(var/material/mat, var/isrwall = FALSE)
	var/turf/simulated/wall/T = get_turf(src)
	T.ChangeTurf(/turf/simulated/wall)
	T.material = material
	T.r_material = isrwall? r_material : null
	T.p_material = mat
	T.state = 0
	T.update_material(1)
	T.update_icon()

/obj/structure/girder/proc/update_material(var/update_Integrity)
	if(!istype(material, /material))
		if(istext(material))
			material = SSmaterials.get_material_by_name(material)
			update_Integrity = 1
		else
			material = null
	if(!istype(r_material, /material))
		if(istext(r_material))
			r_material = SSmaterials.get_material_by_name(r_material)
			update_Integrity = 1
		else
			r_material = null
	if(!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
		update_Integrity = 1

	if(update_Integrity)
		integrity = maxIntegrity()
	explosion_resistance = explosionArmor()
	update_icon()

/obj/structure/girder/proc/take_damage(var/damage, var/type)
	switch(type)
		if(BRUTE)
			damage -= bruteArmor()
		if(BURN)
			damage -= burnArmor()
		else
			if(type)
				damage = 0
	integrity -= max(0, damage)
	if(integrity <= 0)
		spawn(1) dismantle()
		return 2
	return damage ? 1 : 0

/obj/structure/girder/proc/dismantle(var/devastated)
	playsound(get_turf(src), 'sound/items/Welder.ogg', 100, 1)
	if(!devastated)
		new material.stack_type(get_turf(src), 2)
		if(r_material)
			new r_material.stack_type(get_turf(src), 4)

	material = null
	r_material = null
	qdel(src)

// Get procs, different naming style
/obj/structure/girder/proc/maxIntegrity()
	return material.integrity + (r_material ? r_material.integrity + (material.integrity * r_material.integrity / 100) : 0)

/obj/structure/girder/proc/bruteArmor()
	return material.brute_armor + (r_material ? r_material.brute_armor + (material.brute_armor * r_material.brute_armor / 100) : 0)

/obj/structure/girder/proc/burnArmor()
	return material.burn_armor + (r_material ? r_material.burn_armor + (material.burn_armor * r_material.burn_armor / 100) : 0)

/obj/structure/girder/proc/explosionArmor()
	return material.hardness + (r_material ? r_material.hardness + (material.hardness * r_material.hardness / 100) : 0)


// Animal attacks
/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallreturner)
	if(!damage || !wallreturner)
		return 0
	attack_animation(user)
	if(take_damage())
		visible_message("<span class='danger'>[user] [attack_message] \the [src]!</span>")
	return 1

// Bullet "attacks"
/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.original != src && !prob(50)) // If we arn't the target, 50% pass through
		return PROJECTILE_CONTINUE // Pass through

	var/damage = Proj.get_structure_damage()
	switch(Proj.check_armour)
		if("bullet")
			take_damage(damage, BRUTE)
			return
		if("laser")
			take_damage(damage, BURN)
		else
			take_damage(damage)
	..()
