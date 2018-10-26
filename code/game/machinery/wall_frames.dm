/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)

/obj/item/frame/plastic
var/refund_type = /obj/item/stack/material/plastic

/obj/item/frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/proc/try_build(turf/on_wall)
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
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed on this spot.</span>")
		return
	if (A.requires_power == 0 || A.name == "Space")
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed in this area.</span>")
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, "<span class='danger'>There's already an item on this wall!</span>")
		return

	new build_machine_type(loc, ndir, src)
	qdel(src)

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "firex"
	refund_amt = 2
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/air_alarm
	name = "air alarm frame"
	desc = "Used for building air alarms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarmx"
	refund_amt = 2
	build_machine_type = /obj/machinery/alarm

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
/*
/obj/item/frame/driver_button
	name = "mass driver button frame"
	desc = "Used for repairing or building mass driver buttons"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt_frame"
	refund_amt = 1
//	build_machine_type =
*/

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

/obj/item/frame/noticeboard/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOB.cardinal))
		return
	var/turf/loc = get_turf(usr)

	new /obj/structure/noticeboard(loc, 1, src, ndir)
	qdel(src)

/obj/item/frame/mirror
	name = "Mirror Frame"
	desc = "Used for building Mirrors"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mirror"
	refund_amt = 2
	refund_type = /obj/item/stack/material/silver
	build_machine_type = /obj/structure/mirror

/obj/item/frame/plastic/shower
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

/obj/item/frame/plastic/sink
	name = "Sink Frame"
	desc = "Used for building Sinks"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	refund_amt = 2
	build_machine_type = /obj/structure/sink

/obj/item/frame/plastic/kitchensink
	name = "Kitchen Sink Frame"
	desc = "Used for building Kitchen Sinks"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_alt"
	refund_amt = 2
	build_machine_type = /obj/structure/sink/kitchen

/obj/item/frame/newscaster
	name = "News Caster Frame"
	desc = "Used for building News Casters"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_alt"
	refund_amt = 2
	build_machine_type = /obj/machinery/newscaster

// /obj/machinery/newscaster/security_unit

/obj/item/frame/atm
	name = "atm"
	desc = "An ATM, just secure to the wall."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm_frame"
	build_machine_type = /obj/machinery/atm




