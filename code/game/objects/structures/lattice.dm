/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "lattice15"	// Only temporary for mapping. Updates in Init
	density = 0
	anchored = 1.0
	w_class = ITEM_SIZE_NORMAL
	plane = -18
	layer = LATTICE_LAYER
	//	obj_flags = OBJ_FLAG_CONDUCTIBLE
	mass = 5
	max_health = 40

/obj/structure/lattice/Initialize()
	. = ..()
	for(var/obj/structure/lattice/L in loc)
		if(L != src)
			log_debug("Found multiple [src.type] at '[log_info_line(loc)]'. Deleting self!")
			return INITIALIZE_HINT_QDEL

	update_icon(1)

/obj/structure/lattice/Destroy()
	
	// After this is deleted, the other lattices are updated.
	for(var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(src, dir))
		if(L)
			addtimer(CALLBACK(L, /obj/structure/lattice/update_icon))

	. = ..()	// Has to be called after, otherwise location is null

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return

	if(isWelder(C))
		var/obj/item/weapon/tool/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		new /obj/item/stack/rods(loc)
		qdel(src)

/**	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.use(2))
			src.alpha = 0
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/catwalk(src.loc)
			qdel(src)
			return
		else
			to_chat(user, "<span class='notice'>You require at least two rods to complete the catwalk.</span>")
			return
**/
	return

/obj/structure/lattice/update_icon(var/propagate = 0)
	. = ..()

	var/dir_sum = 0

	for(var/dir in GLOB.cardinal)
		var/turf/T = get_step(src, dir)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, T)
		
		if(L)
			dir_sum += dir
			if(propagate)
				L.update_icon()
			
		if(!istype(T, /turf/space) && !istype(T, /turf/simulated/open))
			dir_sum += dir

	icon_state = "lattice[dir_sum]"