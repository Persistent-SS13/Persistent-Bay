/obj/item/frame
	name = "frame parts"
	desc = "Used for building frames."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "frame_bitem"
	flags = CONDUCT
	var/build_machine_type = /obj/structure/frame
	var/refund_amt = 5
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)
	var/frame_type = null

/obj/item/frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/attack_self(mob/user as mob)
	..()
	if(!build_machine_type)
		return

	if(!frame_type)
		var/response = input(usr, "What kind of frame would you like to make?", "Frame type request", null) in list("Computer", "Machine", "Holopad", "Conveyor",
																													"Photocopier", "Fax", "Microwave",
																													"Recharger", "Washing Machine", "Grinder",
																													"Medical Console", "Medical Pod", "DNA Analyzer",
																													"Mass Driver",
																													"Cancel")

		if(response == "Cancel")
			return

		frame_type = lowertext(response)

		switch(response)
			if("Holopad")
				new /obj/item/stack/material/steel( usr.loc, 1 ) //holopads are smaller, they only need 4 sheets
			if("Fax")
				new /obj/item/stack/material/steel( usr.loc, 2 ) //faxes are smaller, they only need 3 sheets
			if("Microwave")
				new /obj/item/stack/material/steel( usr.loc, 1 ) //microwaves are smaller, they only need 4 sheets
			if("Recharger")
				new /obj/item/stack/material/steel( usr.loc, 2 ) //rechargers are smaller, they only need 3 sheets
			if("Washing Machine")
				frame_type = "washing"
			if("Grinder")
				new /obj/item/stack/material/steel( usr.loc, 2 ) //grinders are smaller, they only need 3 sheets
			if("Medical Console")
				frame_type = "console"
			if("Medical Pod")
				frame_type = "medpod"
			if("DNA Analyzer")
				frame_type = "dna_analyzer"
			if("Mass Driver")
				frame_type = "massdriver"

	var/ndir
	ndir = usr.dir
	if (!(ndir in GLOB.cardinal))
		return

	var/obj/machinery/M = new build_machine_type(get_turf(src.loc), ndir, 1, frame_type)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/proc/try_build(turf/on_wall, mob/user as mob)
	if(!frame_type)
		var/response = input(usr, "What kind of frame would you like to make?", "Frame type request", null) in list("Fire Alarm", "Air Alarm", "Display", "Newscaster",
																													"ATM", "Guest Pass Console", "Intercom", "Keycard Authenticator",
																													"Wall Charger", "Supply Request Console",
																													"Cancel")

		if(response == "Cancel")
			return

		frame_type = lowertext(response)

		switch(response)
			if("Fire Alarm")
				frame_type = "firealarm"
				new /obj/item/stack/material/steel( usr.loc, 3 ) //fire alarms are smaller, they only need 2 sheets
			if("Air Alarm")
				frame_type = "airalarm"
				new /obj/item/stack/material/steel( usr.loc, 3 ) //air alarms are smaller, they only need 2 sheets
			if("Intercom")
				new /obj/item/stack/material/steel( usr.loc, 3 ) //intercoms are smaller, they only need 2 sheets
			if("Newscaster")
				new /obj/item/stack/material/steel( usr.loc, 2 ) //newscasters are smaller, they only need 3 sheets
			if("Guest Pass Console")
				frame_type = "guestpass"
				new /obj/item/stack/material/steel( usr.loc, 3 ) //guestpass consoles are smaller, they only need 2 sheets
			if("Keycard Authenticator")
				frame_type = "keycard"
				new /obj/item/stack/material/steel( usr.loc, 4 ) //keycard authenticators are smaller, they only need 1 sheets
			if("Wall Charger")
				frame_type = "wrecharger"
				new /obj/item/stack/material/steel( usr.loc, 2 ) //wall rechargers are smaller, they only need 3 sheets
			if("Supply Request Console")
				frame_type = "request"

	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_wall)
	else
		ndir = get_dir(on_wall,usr)

	if (!(ndir in GLOB.cardinal))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		usr << "<span class='danger'>\The frame cannot be placed on this spot.</span>"
		return
	if (A.requires_power == 0 || A.name == "Space")
		usr << "<span class='danger'>\The [src] Alarm cannot be placed in this area.</span>"
		return

	if(gotwallitem(loc, ndir))
		usr << "<span class='danger'>There's already an item on this wall!</span>"
		return
	var/obj/machinery/M = new build_machine_type(loc, ndir, 1, frame_type)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	refund_amt = 2
	build_machine_type = /obj/machinery/light_construct
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small

/obj/item/frame/light_switch
	name = "light switch frame"
	desc = "Used for repairing or building light switches"
	icon = 'icons/obj/power.dmi'
	icon_state = "light-p"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_switch

/obj/item/frame/intercom
	name = "Intercom Frame"
	desc = "Used for building intercoms"
	icon = 'icons/obj/radio.dmi'
	icon_state = "intercom-p"
	refund_amt = 2
	build_machine_type = /obj/item/device/radio/intercom

/obj/item/frame/noticeboard
	name = "noticeboard"
	desc = "Used for building NoticeBoards"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	refund_amt = 2
	refund_type = /obj/item/stack/material/cardboard
	build_machine_type = /obj/structure/noticeboard

/obj/item/frame/shower
	name = "Shower Frame"
	desc = "Used for building Showers"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	refund_amt = 2
	build_machine_type = /obj/machinery/shower


/obj/item/frame/wallflash
	name = "Wall Flash Frame"
	desc = "Used for building Wall Mounted Flashes"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	refund_amt = 2
	build_machine_type = /obj/machinery/flasher


/obj/item/frame/barsign
	name = "Bar Sign Frame"
	desc = "Used for building Bar Signs"
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	refund_amt = 2
	build_machine_type = /obj/structure/sign/double/barsign


/obj/item/frame/kitchensink
	name = "Kitchen Sink Frame"
	desc = "Used for building Kitchen Sinks"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_alt"
	refund_amt = 2
	build_machine_type = /obj/structure/sink/kitchen

/obj/item/frame/atm_frame
	name = "atm"
	desc = "An ATM, just secure to the wall."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "firex"
	build_machine_type = /obj/machinery/atm

/obj/item/frame/mirror
	name = "mirror frame"
	desc = "Used for building mirrors."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror_frame"
	refund_amt = 1
	build_machine_type = /obj/structure/mirror
	frame_type = 1

/obj/item/frame/fireaxe_cabinet
	name = "fire axe cabinet frame"
	desc = "Used for building fire axe cabinets."
	icon = 'icons/obj/closet.dmi'
	icon_state = "fireaxe0101"
	refund_amt = 4
	build_machine_type = /obj/structure/closet/fireaxecabinet
	frame_type = 1


/obj/item/frame/extinguisher_cabinet
	name = "extinguisher cabinet frame"
	desc = "Used for building fire extinguisher cabinets."
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher_empty"
	refund_amt = 4
	build_machine_type = /obj/structure/extinguisher_cabinet
	frame_type = 1