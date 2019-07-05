// a broken pipe
/obj/structure/disposalpipe/broken
	name = "broken disposal pipe"
	desc = "A broken piece of disposal pipe."
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf

/obj/structure/disposalpipe/broken/Initialize()
	. = ..()
	update()

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
	qdel(src)

