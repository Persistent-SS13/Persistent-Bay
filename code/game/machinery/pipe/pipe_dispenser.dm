/obj/machinery/pipedispenser
	name 			= "Pipe Dispenser"
	icon 			= 'icons/obj/machines/pipedispenser.dmi'
	icon_state 		= "pipe_d"
	density 		= TRUE
	anchored 		= TRUE
	circuit_type 	= /obj/item/weapon/circuitboard/pipe_dispenser
	var/unwrenched 	= 0
	var/wait 		= 0

/obj/machinery/pipedispenser/attack_hand(user as mob)
	if(..())
		return
///// Z-Level stuff
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
<A href='?src=\ref[src];make=9;dir=1'>Digital Valve</A><BR>
<A href='?src=\ref[src];make=44;dir=1'>Automatic Shutoff Valve</A><BR>
<A href='?src=\ref[src];make=20;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=18;dir=1'>Manual T-Valve</A><BR>
<A href='?src=\ref[src];make=43;dir=1'>Manual T-Valve - Mirrored</A><BR>
<A href='?src=\ref[src];make=21;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=22;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='?src=\ref[src];make=29;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=30;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=33;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=41;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=35;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=37;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=39;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='?src=\ref[src];make=31;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=32;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=34;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=42;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=36;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=38;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=40;dir=1'>Downward Pipe</A><BR>
<b>Fuel pipes:</b><BR>
<A href='?src=\ref[src];make=45;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=46;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=47;dir=1'>Manifold</A><BR>
<A href='?src=\ref[src];make=51;dir=1'>Pipe Cap</A><BR>
<A href='?src=\ref[src];make=48;dir=1'>4-Way Manifold</A><BR>
<A href='?src=\ref[src];make=49;dir=1'>Upward Pipe</A><BR>
<A href='?src=\ref[src];make=50;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='?src=\ref[src];make=28;dir=1'>Universal pipe adapter</A><BR>
<A href='?src=\ref[src];make=4;dir=1'>Connector</A><BR>
<A href='?src=\ref[src];make=7;dir=1'>Unary Vent</A><BR>
<A href='?src=\ref[src];make=53;dir=1'>Binary Vent</A><BR>
<A href='?src=\ref[src];make=54;dir=1'>Passive Vent</A><BR>
<A href='?src=\ref[src];make=10;dir=1'>Gas Pump</A><BR>
<A href='?src=\ref[src];make=15;dir=1'>Pressure Regulator</A><BR>
<A href='?src=\ref[src];make=16;dir=1'>High Power Gas Pump</A><BR>
<A href='?src=\ref[src];make=11;dir=1'>Scrubber</A><BR>
<A href='?src=\ref[src];makemeter=1'>Meter</A><BR>
<A href='?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
<A href='?src=\ref[src];make=23;dir=1'>Gas Filter - Mirrored</A><BR>
<A href='?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
<A href='?src=\ref[src];make=25;dir=1'>Gas Mixer - Mirrored</A><BR>
<A href='?src=\ref[src];make=24;dir=1'>Gas Mixer - T</A><BR>
<A href='?src=\ref[src];make=26;dir=1'>Omni Gas Mixer</A><BR>
<A href='?src=\ref[src];make=27;dir=1'>Omni Gas Filter</A><BR>
<A href='?src=\ref[src];make=52;dir=1'>Gas Injector</A><BR>
<b>Heat exchange:</b><BR>
<A href='?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
<A href='?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
<A href='?src=\ref[src];make=6;dir=1'>Junction</A><BR>
<A href='?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>

"}
///// Z-Level stuff
//What number the make points to is in the define # at the top of construction.dm in same folder
	show_browser(user, "<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/machinery/pipedispenser/Topic(href, href_list, state = GLOB.physical_state)
	if((. = ..()) || unwrenched)
		close_browser(usr, "window=pipedispenser")
		return

	if(href_list["make"])
		if(!wait)
			var/p_type = text2num(href_list["make"])
			var/p_dir = text2num(href_list["dir"])
			wait = 1
			flick("pipe_d_l", src)
			spawn(2 SECONDS)
				var/obj/item/pipe/P = new (get_turf(src), pipe_type=p_type, dir=p_dir)
				P.update()
				wait = 0
	if(href_list["makemeter"])
		if(!wait)
			wait = 1
			flick("pipe_d_l", src)
			spawn(2 SECONDS)
				new /obj/item/pipe_meter(get_turf(src))
				wait = 0

/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, SPAN_NOTICE("You put \the [W] back into \the [src]."))
		user.drop_item()
		add_fingerprint(usr)
		qdel(W)
		return
	else if(default_deconstruction_screwdriver(user, W))
		return 1
	else if(default_deconstruction_crowbar(user, W))
		return 1
	else if(default_part_replacement(user, W))
		return 1
	else if(isWrench(W))
		add_fingerprint(usr)
		if (unwrenched==0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>")
			if (do_after(user, 40, src))
				user.visible_message( \
					"<span class='notice'>\The [user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = FALSE
				src.set_maintenance(TRUE)
				src.unwrenched = 1
				if (usr.machine==src)
					close_browser(usr, "window=pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to fasten \the [src] to the floor...</span>")
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				src.anchored = TRUE
				src.set_maintenance(FALSE)
				src.unwrenched = 0
				power_change()
	else
		return ..()


//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/MouseDrop_T(var/obj/item/pipe as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))
		return

	if ((!istype(pipe) && !istype(pipe, /obj/item/pipe_meter)) || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)