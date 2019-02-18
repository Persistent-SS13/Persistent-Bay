/obj/structure/disposalpipe/diversion_junction
	name = "diversion junction"
	desc = "An underfloor disposal pipe with a flip mechanism. Must be linked to a disposal divert switch of a matching id. Use the switch construct on this."
	icon_state = "pipe-j1s"

	var/active = FALSE
	var/active_dir = 0
	var/inactive_dir = 0
	var/sortdir = 0

	var/id_tag
	var/obj/machinery/disposal_switch/linked

/obj/structure/disposalpipe/diversion_junction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2s"

/obj/structure/disposalpipe/diversion_junction/New()
	..()
	ADD_SAVED_VAR(id_tag)

/obj/structure/disposalpipe/diversion_junction/Initialize()
	. = ..()
	updatedir()
	updatedesc()
	update()

/obj/structure/disposalpipe/diversion_junction/Destroy()
	if(linked)
		linked.junctions.Remove(src)
	linked = null
	return ..()

/obj/structure/disposalpipe/diversion_junction/proc/updatedesc()
	desc = initial(desc)
	if(sortType)
		desc += "\nIt's currently [active ? "" : "un"]active!"

/obj/structure/disposalpipe/diversion_junction/proc/updatedir()
	inactive_dir = dir
	active_dir = turn(inactive_dir, 180)
	if(icon_state == "pipe-j1s")
		sortdir = turn(inactive_dir, -90)
	else if(icon_state == "pipe-j2s")
		sortdir = turn(inactive_dir, 90)

	dpdir = sortdir | inactive_dir | active_dir

/obj/structure/disposalpipe/diversion_junction/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return 1

	if(istype(I, /obj/item/disposal_switch_construct))
		var/obj/item/disposal_switch_construct/C = I
		if(C.id_tag)
			id_tag = C.id_tag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, 1)
			user.visible_message(SPAN_NOTICE("\The [user] changes \the [src]'s tag."))

/obj/structure/disposalpipe/diversion_junction/nextdir(var/fromdir, var/sortTag)
	if(fromdir != sortdir)
		if(active)
			return sortdir
		else
			return inactive_dir
	else
		return inactive_dir

/obj/structure/disposalpipe/diversion_junction/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else
		H.forceMove(T)
		return null

	return P
