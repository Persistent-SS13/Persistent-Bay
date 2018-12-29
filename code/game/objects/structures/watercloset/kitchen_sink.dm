/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"
	frame_type = /obj/item/frame/plastic/kitchensink/

/obj/structure/sink/kitchen/New(loc, dir, atom/frame)
	..(loc)

	if(dir)
		src.set_dir(dir)

	if(istype(frame))
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -20 : 20)
		pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0
