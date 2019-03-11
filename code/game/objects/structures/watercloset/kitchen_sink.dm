/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"
	frame_type = /obj/item/frame/plastic/kitchensink/

/obj/structure/sink/kitchen/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

/obj/structure/sink/kitchen/Initialize()
	. = ..()
	queue_icon_update()

/obj/structure/sink/kitchen/update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			src.pixel_x = 0
			src.pixel_y = 30
		if(SOUTH)
			src.pixel_x = 0
			src.pixel_y = -30
		if(EAST)
			src.pixel_x = 30
			src.pixel_y = 0
		if(WEST)
			src.pixel_x = -30
			src.pixel_y = 0
