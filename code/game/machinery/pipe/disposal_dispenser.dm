/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	icon = 'icons/obj/machines/pipedispenser.dmi'
	icon_state = "old_pipe_d"
	density = 1

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))
		return

	if (!istype(pipe) || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='?src=\ref[src];dmake=21'>Upwards</A><BR>
<A href='?src=\ref[src];dmake=22'>Downwards</A><BR>
<A href='?src=\ref[src];dmake=8'>Sorting</A><BR>
<A href='?src=\ref[src];dmake=9'>Sorting (Wildcard)</A><BR>
<A href='?src=\ref[src];dmake=10'>Sorting (Untagged)</A><BR>
<A href='?src=\ref[src];dmake=11'>Tagger</A><BR>
<A href='?src=\ref[src];dmake=12'>Tagger (Partial)</A><BR>
<A href='?src=\ref[src];dmake=13'>Diversion</A><BR>
<A href='?src=\ref[src];dmake=14'>Diversion Switch</A><BR>
"}
///// Z-Level stuff

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list, state = GLOB.physical_state)
	if((. = ..()) || unwrenched)
		usr << browse(null, "window=pipedispenser")
		return

	if(href_list["dmake"])
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			if(p_type == 15)
				new /obj/machinery/disposal_switch (get_turf(src))
			else
				var/obj/structure/disposalconstruct/C = new (src.loc)
				switch(p_type)
					if(0)
						C.ptype = 0
					if(1)
						C.ptype = 1
					if(2)
						C.ptype = 2
					if(3)
						C.ptype = 4
					if(4)
						C.ptype = 5
					if(5)
						C.ptype = 6
						C.set_density(1)
					if(6)
						C.ptype = 7
						C.set_density(1)
					if(7)
						C.ptype = 8
						C.set_density(1)
					if(8)
						C.ptype = 9
						C.subtype = 0
					if(9)
						C.ptype = 9
						C.subtype = 1
					if(10)
						C.ptype = 9
						C.subtype = 2
					if(11)
						C.ptype = 13
					if(12)
						C.ptype = 14
					if(13)
						C.ptype = 15
///// Z-Level stuff
					if(21)
						C.ptype = 11
					if(22)
						C.ptype = 12
///// Z-Level stuff
				C.update()
			wait = 1
			flick("old_pipe_d_l", src) 
			spawn(15)
				wait = 0
	return
