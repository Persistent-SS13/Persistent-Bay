
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
	var/reinforcing = 0

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	health = 50
	cover = 25

/obj/structure/girder/New(var/newloc, var/mat, var/r_mat)
	..()
	ADD_SAVED_VAR(state)
	ADD_SAVED_VAR(reinf_material)
	ADD_SAVED_VAR(reinforcing)

	ADD_SKIP_EMPTY(reinf_material)

/obj/structure/girder/Initialize(var/mapload, var/newloc, var/mat, var/r_mat)
	set_extension(src, /datum/extension/penetration, /datum/extension/penetration/simple, 100)
	. = ..()
	if(!map_storage_loaded)
		material = mat
		reinf_material = r_mat
		update_material(1) // Handles lack of material
	else
		update_material()

/obj/structure/girder/CanFluidPass(var/coming_from)
	return TRUE

/obj/structure/girder/proc/reset_girder()
	anchored = TRUE
	cover = initial(cover)
	health = min(health,max_health)
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/on_update_icon()
	color = material.icon_colour
	overlays.Cut()
	switch(state)
		if(0)
			icon_state = "girder_d"
		if(1)
			icon_state = "girder_w"
		else
			icon_state = "girder"
	name = "[reinf_material ? "[reinf_material.display_name] reinforced " : ""][material.display_name] [initial(name)]"
	desc = "It seems to be a [reinf_material ? "[reinf_material.display_name] reinforced " : ""][material.display_name] [initial(name)]."
	if(reinf_material)
		var/image/I = image(icon, "girder_r")
		I.color = reinf_material.icon_colour
		overlays += I

/obj/structure/girder/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		to_chat(user, SPAN_NOTICE("You drill through the girder!"))
		dismantle()
		return 1
	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter) || istype(W, /obj/item/psychic_power/psiblade/master/grand/paramount))
		to_chat(user, SPAN_NOTICE("Now slicing apart the girder..."))
		if(do_after(user, 3 SECONDS, src))
			if(!src) return
			to_chat(user, SPAN_NOTICE("You slice apart the girder!"))
			dismantle()
			return 1
	switch(state)
		if(0)
			if(isWrench(W))
				var/obj/item/weapon/tool/T = W
				if(anchored && !reinf_material)
					to_chat(user, SPAN_NOTICE("Now disassembling the girder..."))
					if(T.use_tool(user, src, 4 SECONDS))
						to_chat(user, SPAN_NOTICE("You dissasembled the girder!"))
						dismantle()
					return 1
				else if(!anchored)
					to_chat(user, SPAN_NOTICE("Now securing the girder..."))
					if(T.use_tool(user, src, 4 SECONDS))
						to_chat(user, SPAN_NOTICE("You secured the girder!"))
						reset_girder()
					return 1
		
			if(isCrowbar(W) && anchored)
				var/obj/item/weapon/tool/T = W
				to_chat(user, SPAN_NOTICE("Now dislodging the girder..."))
				if(T.use_tool(user, src, 4 SECONDS))
					to_chat(user, SPAN_NOTICE("You dislodged the girder!"))
					icon_state = "displaced"
					anchored = 0
					health = 50
					cover = 25
					update_icon()
				return 1
		if(1)
			if(isWrench(W))
				var/obj/item/weapon/tool/T = W
				to_chat(user, SPAN_NOTICE("You begin unsecuring \the [src]..."))
				if(T.use_tool(user, src, 4 SECONDS))
					to_chat(user, SPAN_NOTICE("You unsecure \the [src]."))
					if(reinf_material)
						reinf_material.place_dismantled_product(get_turf(src))
						reinf_material = null
					reset_girder()
				return 1

			if(isWelder(W))
				var/obj/item/weapon/tool/T = W
				to_chat(user, SPAN_NOTICE("You start to weld \the [src] into place."))
				if(T.use_tool(user, src, 3 SECONDS))
					to_chat(user, "<span class='notice'>You weld \the [src] into place.</span>")
					state = 2
					update_icon()
				return 1
		if(2)

			if(isWelder(W))
				var/obj/item/weapon/tool/T = W
				to_chat(user, SPAN_NOTICE("You start to unweld \the [src] from the floor."))
				if(T.use_tool(user, src, 4 SECONDS))
					state = 1
					update_icon()
				return 1

			if(isScrewdriver(W))
				var/obj/item/weapon/tool/T = W
				if(anchored && !reinf_material && T.use_tool(user, src, 1 SECONDS))
					reinforcing = !reinforcing
					to_chat(user, SPAN_NOTICE("\The [src] can now be [reinforcing? "reinforced" : "constructed"]!"))
				return 1

			if(istype(W, /obj/item/stack/material))
				if(reinforcing && !reinf_material)
					if(!reinforce_with_material(W, user))
						reinforcing = FALSE
						state = 3 //Reinforcing means extra steps
						return ..()
				else
					if(!construct_wall(W, user))
						return ..()

		if(3)

			if(reinf_material && isCrowbar(W))
				var/obj/item/weapon/tool/T = W
				to_chat(user, SPAN_NOTICE("You start removing \the [reinf_material.display_name]."))
				if(T.use_tool(user, src, 5 SECONDS))
					to_chat(user, SPAN_NOTICE("You finish removing \the [reinf_material.display_name]."))
					reinf_material.place_sheet(get_turf(src), 6)
					reinf_material = null
					state = 2
					update_icon()
				return 1

			if(isWrench(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 4 SECONDS))
					to_chat(user, "<span class='notice'>You secure the material to \the [src]</span>")
					state = 4
					update_icon()
				return 1

		if(4)
			
			if(isCrowbar(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 1 SECOND))
					to_chat(user, "<span class='notice'>You bend the material around \the [src]</span>")
					state = 5
					update_icon()
				return 1
			
			if(isWrench(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 1 SECOND))
					to_chat(user, "<span class='notice'>You unsecure the material from \the [src].</span>")
					state = 3
					update_icon()
				return 1
		
		if(5)
		
			if(isWelder(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 4 SECOND))
					to_chat(user, "<span class='notice'>You weld the material to \the [src]</span>")
					state = 6
					update_icon()
				return 1

			if(isCrowbar(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 2 SECOND))
					to_chat(user, "<span class='notice'>You unbend the material from around \the [src]</span>")
					state = 4
					update_icon()
				return 1

		if(6)

			if(istype(W, /obj/item/stack/material))
				if(!construct_wall(W, user))
					return ..()

			if(isWelder(W))
				var/obj/item/weapon/tool/T = W
				if(T.use_tool(user, src, 4 SECONDS))
					to_chat(user, "<span class='notice'>You unweld the material from \the [src]</span>")
					state = 5
					update_icon()
				return 1
	return ..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 2)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
		return 0

	to_chat(user, "<span class='notice'>You begin adding the plating...</span>")

	if(!do_after(user,40,src) || !S.use(2))
		return 1 //once we've gotten this far don't call parent attackby()

	if(anchored)
		to_chat(user, "<span class='notice'>You added the plating!</span>")
	else
		to_chat(user, "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, null) //Don't set the reinforced material yet
	T.girder_material = material
	T.girder_reinf_material = reinf_material
	T.construction_stage = 0
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	T.update_material(1)
	T.update_icon()
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, "<span class='notice'>\The [src] is already reinforced.</span>")
		return 0

	if(S.get_amount() < 2)
		to_chat(user, "<span class='notice'>There isn't enough material here to reinforce the girder.</span>")
		return 0

	var/material/M = S.material
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, "<span class='notice'>Now reinforcing...</span>")
	if (!do_after(user, 4 SECONDS, src) || !S.use(2))
		return 1 //don't call parent attackby() past this point
	to_chat(user, "<span class='notice'>You added reinforcement!</span>")

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = 75
	health = 500
	state = 2
	icon_state = "reinforced"
	reinforcing = 0

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
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
		update_Integrity = 1

	if(update_Integrity)
		max_health = maxIntegrity()
		health = max_health
	armor[DAM_BOMB]  = explosionArmor()
	armor[DAM_BURN]  = burnArmor()
	armor[DAM_BLUNT] = bruteArmor()
	queue_icon_update()

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
