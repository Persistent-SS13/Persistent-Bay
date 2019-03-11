// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"

	atom_flags = ATOM_FLAG_CLIMBABLE
	anchored = 1
	density = 1
	throwpass = 1
	layer = TABLE_LAYER

	mass = 20
	max_health = 100
	damthreshold_brute 	= 5
	damthreshold_burn	= 5
	var/paint_color
	var/stripe_color

	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	var/material/material = new /material/steel

/obj/structure/wall_frame/New(var/new_loc, var/materialtype)
	..(new_loc)
	if(!materialtype)
		materialtype = new /material/steel
	
	//Since people keeps passing strings for some reasons lets double check
	if(istext(materialtype))
		material = SSmaterials.get_material_by_name(materialtype)
	else if(istype(materialtype, /material))
		material = materialtype

/obj/structure/wall_frame/Initialize()
	. = ..()
	if(!map_storage_loaded)
		health = material.integrity
	update_connections(TRUE)
	update_icon()

/obj/structure/wall_frame/examine(mob/user)
	. = ..(user)

	if(!.)
		return

	if(health == material.integrity)
		to_chat(user, "<span class='notice'>It seems to be in fine condition.</span>")
	else
		var/dam = health / material.integrity
		if(dam <= 0.3)
			to_chat(user, "<span class='notice'>It's got a few dents and scratches.</span>")
		else if(dam <= 0.7)
			to_chat(user, "<span class='warning'>A few pieces of panelling have fallen off.</span>")
		else
			to_chat(user, "<span class='danger'>It's nearly falling to pieces.</span>")
	if(paint_color)
		to_chat(user, "<span class='notice'>It has a smooth coat of paint applied.</span>")

/obj/structure/wall_frame/attackby(var/obj/item/weapon/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing begin
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/ST = W
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		if(!in_use)
			if(ST.get_amount() < 2)
				to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
				return
			to_chat(usr, "<span class='notice'>Assembling grille...</span>")
			ST.in_use = 1
			if (!do_after(user, 10))
				ST.in_use = 0
				return
			var/obj/structure/grille/F = new /obj/structure/grille(loc)
			to_chat(usr, "<span class='notice'>You assemble a grille</span>")
			ST.in_use = 0
			F.add_fingerprint(usr)
			ST.use(2)
		return
	//grille placing end

	//window placing begin
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(!ST.material.created_window)
			return 0

		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW)
				to_chat(user, "<span class='notice'>There is already a window here.</span>")
				return
		to_chat(user, "<span class='notice'>You start placing the window.</span>")
		if(do_after(user,20,src))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, "<span class='notice'>There is already a window here.</span>")
					return

			var/wtype = ST.material.created_window
			if (ST.use(4))
				var/obj/structure/window/WD = new wtype(loc, 5, 1)
				to_chat(user, "<span class='notice'>You place the [WD] on [src].</span>")
				WD.update_connections(1)
				WD.update_icon()
		return
	//window placing end

	if(isWrench(W))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, "<span class='notice'>There is still a window on the low wall!</span>")
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, "<span class='notice'>There is still a grille on the low wall!</span>")
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the low wall...</span>")
		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You dissasembled the low wall!</span>")
			dismantle()

	return ..()

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1

// icon related

/obj/structure/wall_frame/update_icon()
	overlays.Cut()
	var/image/I

	var/new_color = (paint_color ? paint_color : material.icon_colour)
	color = new_color

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image('icons/obj/wall_frame.dmi', "frame_other[connections[i]]", dir = 1<<(i-1))
		else
			I = image('icons/obj/wall_frame.dmi', "frame[connections[i]]", dir = 1<<(i-1))
		overlays += I

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image('icons/obj/wall_frame.dmi', "stripe_other[connections[i]]", dir = 1<<(i-1))
			else
				I = image('icons/obj/wall_frame.dmi', "stripe[connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			overlays += I

	..()


/obj/structure/wall_frame/dismantle()
	refund_matter()
	qdel(src)

/obj/structure/wall_frame/destroyed()
	dismantle()

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_GUNMETAL

/obj/structure/wall_frame/titanium
	material = new /material/titanium

/obj/structure/wall_frame/hull
	paint_color = COLOR_HULL
//Hull init
/obj/structure/wall_frame/hull/Initialize()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	. = ..()