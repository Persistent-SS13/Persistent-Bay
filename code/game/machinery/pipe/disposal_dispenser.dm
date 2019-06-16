var/list/DISPOSAL_PIPES_DISPENSER_BUILDABLES = list(
	"Pipe" 					= DISPOSAL_TYPE_PIPE,
	"Bent Pipe" 			= DISPOSAL_TYPE_BENT_PIPE,
	"Junction" 				= DISPOSAL_TYPE_JUNCTION,
	"Y-Junction" 			= DISPOSAL_TYPE_Y_JUNCTION,
	"Trunk" 				= DISPOSAL_TYPE_TRUNK,
	"Bin" 					= DISPOSAL_TYPE_BIN,
	"Outlet" 				= DISPOSAL_TYPE_OUTLET,
	"Chute" 				= DISPOSAL_TYPE_INTAKE,
	"Upwards"				= DISPOSAL_TYPE_Z_UP,
	"Downwards"				= DISPOSAL_TYPE_Z_DOWN,
	"Sorting"				= DISPOSAL_TYPE_SORT, //DISPOSAL_SORT_SUBTYPE_DEFAULT,
	"Sorting (Wildcard)"	= DISPOSAL_TYPE_SORT, //DISPOSAL_SORT_SUBTYPE_WILDCARD,
	"Sorting (Untagged)"	= DISPOSAL_TYPE_SORT, //DISPOSAL_SORT_SUBTYPE_UNTAGGED,
	"Tagger"				= DISPOSAL_TYPE_TAGGER,
	"Tagger (Partial)"		= DISPOSAL_TYPE_PARTIAL_TAGGER,
	"Diversion"				= DISPOSAL_TYPE_DIVERSION,
	"Diversion Switch"		= 16,
)

/obj/machinery/pipedispenser/disposal
	name 			= "Disposal Pipe Dispenser"
	icon 			= 'icons/obj/machines/pipedispenser.dmi'
	icon_state 		= "old_pipe_d"
	density 		= TRUE
	circuit_type 	= /obj/item/weapon/circuitboard/disposal_pipe_dispenser

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))
		return

	if ( (!istype(pipe) && !istype(pipe, /obj/item/disposal_switch_construct) ) || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_PIPE]'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_BENT_PIPE]'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_JUNCTION]'>Junction</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_Y_JUNCTION]'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_TRUNK]'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_BIN]'>Bin</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_OUTLET]'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_INTAKE]'>Chute</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_Z_UP]'>Upwards</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_Z_DOWN]'>Downwards</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_SORT];subtype=[DISPOSAL_SORT_SUBTYPE_DEFAULT]'>Sorting</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_SORT];subtype=[DISPOSAL_SORT_SUBTYPE_WILDCARD]'>Sorting (Wildcard)</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_SORT];subtype=[DISPOSAL_SORT_SUBTYPE_UNTAGGED]'>Sorting (Untagged)</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_TAGGER]'>Tagger</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_PARTIAL_TAGGER]'>Tagger (Partial)</A><BR>
<A href='?src=\ref[src];dmake=[DISPOSAL_TYPE_DIVERSION]'>Diversion</A><BR>
<A href='?src=\ref[src];dmake=[16]'>Diversion Switch</A><BR>
"}
///// Z-Level stuff
	show_browser(user, "<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list, state = GLOB.physical_state)
	if((. = ..()) || unwrenched)
		close_browser(usr, "window=pipedispenser")
		return

	if(href_list["dmake"])
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			var/s_type = text2num(href_list["subtype"])
			wait = 1
			flick("old_pipe_d_l", src)

			var/obj/structure/disposalconstruct/C
			spawn(2 SECONDS)
				if(p_type == 16)
					new /obj/item/disposal_switch_construct(get_turf(src))
				else
					C = new /obj/structure/disposalconstruct(get_turf(src))
					C.ptype = p_type
					switch(p_type)
						if(DISPOSAL_TYPE_SORT)
							C.subtype = s_type
						if(DISPOSAL_TYPE_BIN, DISPOSAL_TYPE_OUTLET, DISPOSAL_TYPE_INTAKE)
							C.set_density(TRUE)
					C.update()
				wait = 0
	return
