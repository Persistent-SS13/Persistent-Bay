/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 *		Mattresses
 */

/*
 * Beds
 */

/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	buckle_lying = 1
	mass = 50
	max_health = 200
	damthreshold_brute 	= 5
	matter = list()
	var/material/padding_material
	var/base_icon = "bed"
	var/buckling_sound = 'sound/effects/buckle.ogg'

	// It's fine if statics are inited right away
	var/static/list/icon_cache = list()

/obj/structure/bed/New(newloc, new_material = DEFAULT_FURNITURE_MATERIAL, new_padding_material)
	..()
	ADD_SAVED_VAR(padding_material)

/obj/structure/bed/Initialize(mapload, new_material = DEFAULT_FURNITURE_MATERIAL, new_padding_material)
	. = ..()
	if(!map_storage_loaded)
		color = null
		material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		log_warning("obj/structure/bed/Initialize(): [src]\ref[src] has a bad material type. Deleting!")
		qdel(src)
		return
	if(new_padding_material && !map_storage_loaded)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
	
	update_material()
	queue_icon_update()

/obj/structure/bed/proc/update_material()
	//Setup matter values so refunds works properly
	matter = list()
	matter[material.name] = 2 SHEETS
	if(padding_material)
		matter[padding_material.name] = 1 SHEET

/obj/structure/bed/get_material()
	return material

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/on_update_icon()
	// Clear prior icon
	icon_state = "blank"
	overlays.Cut()

	var/cache_key

	// Base Icon
	cache_key = "[base_icon]-[material.name]"
	if(!icon_cache[cache_key])
		var/image/I = image(src.icon, "[base_icon]")
		I.color = material.icon_colour
		icon_cache[cache_key] = I
	
	overlays |= icon_cache[cache_key]

	// Padding Icon
	if(padding_material)
		cache_key = "[base_icon]-padding-[padding_material.name]"
		if(!icon_cache[cache_key])
			var/image/I = image(src.icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			icon_cache[cache_key] = I

		overlays |= icon_cache[cache_key]

	// Fluff
	// This is not perfect but it will do for now.
	SetName(padding_material ? "[padding_material.adjective_name] [initial(name)]" : "[material.adjective_name] [initial(name)]") 
	desc = padding_material ? "[initial(desc)] It's made of [material.use_name] and covered with [padding_material.use_name]." : "[initial(desc)] It's made of [material.use_name]."

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return ..()

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/structure/bed/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = MATERIAL_CARPET
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			src.forceMove(get_turf(src))
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return

	else if(isWirecutter(W))
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		user.visible_message("<span class='notice'>[user] attempts to buckle [affecting] into \the [src]!</span>")
		if(do_after(user, 20, src))
			if(user_buckle_mob(affecting, user))
				qdel(W)
	else
		..()

/obj/structure/bed/buckle_mob(mob/living/M)
	. = ..()
	if(. && buckling_sound)
		playsound(src, buckling_sound, 20)

/obj/structure/bed/Move()
	. = ..()
	if(buckled_mob)
		buckled_mob.forceMove(src.loc)

/obj/structure/bed/forceMove()
	. = ..()
	if(buckled_mob)
		if(isturf(src.loc))
			buckled_mob.forceMove(src.loc)
		else
			unbuckle_mob()

/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_material()
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	padding_material = SSmaterials.get_material_by_name(padding_type)
	update_material()
	update_icon()

/obj/structure/bed/dismantle()
	refund_matter()
	return ..()

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"

/obj/structure/bed/psych/New(var/newloc)
	..(newloc,MATERIAL_WOOD, MATERIAL_LEATHER)

/obj/structure/bed/padded/New(var/newloc)
	..(newloc,MATERIAL_ALUMINIUM,MATERIAL_COTTON)

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"

/obj/structure/bed/alien/New(var/newloc)
	..(newloc,MATERIAL_RESIN)

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	buckle_pixel_shift = "x=0;y=6"
	var/item_form_type = /obj/item/roller	//The folded-up object path.
	var/obj/item/weapon/reagent_containers/beaker
	var/iv_attached = 0
	var/iv_stand = TRUE

/obj/structure/bed/roller/New(newloc, new_material, new_padding_material)
	. = ..()
	ADD_SAVED_VAR(beaker)
	ADD_SAVED_VAR(iv_attached)
	ADD_SAVED_VAR(iv_stand)

/obj/structure/bed/roller/on_update_icon()
	overlays.Cut()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"
	if(beaker)
		var/image/iv = image(icon, "iv[iv_attached]")
		var/percentage = round((beaker.reagents.total_volume / beaker.volume) * 100, 25)
		var/image/filling = image(icon, "iv_filling[percentage]")
		filling.color = beaker.reagents.get_color()
		iv.overlays += filling
		if(percentage < 25)
			iv.overlays += image(icon, "light_low")
		if(density)
			iv.pixel_y = 6
		overlays += iv

/obj/structure/bed/roller/attackby(obj/item/I, mob/user)
	if(isWrench(I) || istype(I, /obj/item/stack) || isWirecutter(I))
		return 1
	if(iv_stand && !beaker && istype(I, /obj/item/weapon/reagent_containers))
		if(!user.unEquip(I, src))
			return
		to_chat(user, "You attach \the [I] to \the [src].")
		beaker = I
		queue_icon_update()
		return 1
	..()

/obj/structure/bed/roller/attack_hand(mob/living/user)
	if(beaker && !buckled_mob)
		remove_beaker(user)
	else
		..()

/obj/structure/bed/roller/proc/collapse()
	visible_message("[usr] collapses [src].")
	new item_form_type(get_turf(src))
	qdel(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	. = ..()
	if(M == buckled_mob)
		set_density(1)
		queue_icon_update()
	else
		set_density(0)
		if(iv_attached)
			detach_iv(M, usr)
		queue_icon_update()

/obj/structure/bed/roller/Process()
	if(!iv_attached || !buckled_mob || !beaker)
		return PROCESS_KILL

	//SSObj fires twice as fast as SSMobs, so gotta slow down to not OD our victims.
	if(SSobj.times_fired % 2)
		return

	if(beaker.volume > 0)
		beaker.reagents.trans_to_mob(buckled_mob, beaker.amount_per_transfer_from_this, CHEM_BLOOD)
		queue_icon_update()

/obj/structure/bed/roller/proc/remove_beaker(mob/user)
	to_chat(user, "You detach \the [beaker] to \the [src].")
	iv_attached = FALSE
	beaker.dropInto(loc)
	beaker = null
	queue_icon_update()

/obj/structure/bed/roller/proc/attach_iv(mob/living/carbon/human/target, mob/user)
	if(!beaker)
		return
	if(do_IV_hookup(target, user, beaker))
		iv_attached = TRUE
		queue_icon_update()
		START_PROCESSING(SSobj,src)

/obj/structure/bed/roller/proc/detach_iv(mob/living/carbon/human/target, mob/user)
	visible_message("\The [target] is taken off the IV on \the [src].")
	iv_attached = FALSE
	queue_icon_update()
	STOP_PROCESSING(SSobj,src)

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(!CanMouseDrop(over_object))	return
	if(!(ishuman(usr) || isrobot(usr)))	return
	if(over_object == buckled_mob && beaker)
		if(iv_attached)
			detach_iv(buckled_mob, usr)
		else
			attach_iv(buckled_mob, usr)
		return
	if(ishuman(over_object))
		if(user_buckle_mob(over_object, usr))
			attach_iv(buckled_mob, usr)
			return
	if(beaker)
		remove_beaker(usr)
		return
	if(buckled_mob)	return
	collapse()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	item_state = "rbed"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	var/structure_form_type = /obj/structure/bed/roller	//The deployed form path.

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/bed/roller/R = new structure_form_type(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/robot_rack/roller
	name = "roller bed rack"
	desc = "A rack for carrying collapsed roller beds. Can also be used for carrying ironing boards."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	object_type = /obj/item/roller
	interact_type = /obj/structure/bed/roller
/*
 * Mattresses
 */
/obj/structure/mattress
	name = "mattress"
	icon = 'icons/obj/furniture.dmi'
	icon_state = "mattress"
	desc = "A bare mattress. It doesn't look very comfortable."
	anchored = 0

/obj/structure/mattress/dirty
	name = "dirty mattress"
	icon_state = "dirty_mattress"
	desc = "A dirty, smelly mattress covered in body fluids. You wouldn't want to touch this."
