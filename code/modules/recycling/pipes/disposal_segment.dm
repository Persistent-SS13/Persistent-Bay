// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/New()
	..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)
	if(loc)
		update()
	return

/obj/structure/disposalpipe/segment/after_load()
	..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)
	if(loc)
		update()
	return

/obj/structure/disposalpipe/segment/corner
	icon_state = "pipe-c"

/obj/structure/disposalpipe/segment/corner/New()
	..()
	dpdir = dir | turn(dir, -90)
	if(loc)
		update()