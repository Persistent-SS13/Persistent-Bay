/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	mass = 10 //kg
	max_health = 40
	damthreshold_brute 	= 2

/obj/structure/hygiene/urinal/Initialize()
	. = ..()
	queue_icon_update()

/obj/structure/hygiene/urinal/update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = -22
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(EAST)
			src.pixel_x = 22
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = -22
			src.pixel_y = 0