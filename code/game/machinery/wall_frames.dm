/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_DAMAGEABLE
	var/build_machine_type
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)
	matter = list(MATERIAL_STEEL = 2 * SHEET_MATERIAL_AMOUNT)

/obj/item/frame/plastic
	obj_flags = OBJ_FLAG_DAMAGEABLE
	matter = list(MATERIAL_PLASTIC = 2 * SHEET_MATERIAL_AMOUNT)

/obj/item/frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		for(var/material/key in matter)
			var/material/M = SSmaterials.get_material_by_name(key)
			if(M && M.units_per_sheet)
				M.place_sheet(get_turf(src.loc), matter[key] / M.units_per_sheet)
			else
				log_debug("[type] couldn't output material [key]! Possibly undefined material.")
		qdel(src)
		return
	..()

/obj/item/frame/proc/try_build(turf/on_wall)
	if(!build_machine_type)
		log_debug("[name]([type]) was placed but has no resulting machine type set..")
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
		to_chat(usr, SPAN_DANGER("\The [src] cannot be placed on this spot."))
		return
	if (A.requires_power == 0 || A.name == "Space" && !isLightFrame())
		to_chat(usr, SPAN_DANGER("\The [src] cannot be placed in this area."))
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, SPAN_DANGER("There's already an item on this wall!"))
		return

	new build_machine_type(loc, ndir, src)
	qdel(src)

/obj/item/frame/proc/isLightFrame()
	return FALSE

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "firex"
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/air_alarm
	name = "air alarm frame"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm_bitem"
	desc = "Used for building air alarms."
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct
	reverse = 1

/obj/item/frame/light/isLightFrame()
	return TRUE

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/light_construct/small

//
// Buttons
//
/obj/item/frame/button
	name = "button frame"
	desc = "Used for building buttons"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "launcherbtt_frame"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button

/obj/item/frame/button/door
	name = "door button frame"
	desc = "Used for building buttons that looks like a door control button."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "doorctrl-p"
	build_machine_type = /obj/machinery/button/alternate

/obj/item/frame/button/switch
	name = "switch button frame"
	desc = "Used for building buttons that look like a lightswitch"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "light-p"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/switch

/obj/item/frame/button/toggle
	name = "toggle button frame"
	desc = "Used for building buttons that can toggle between 2 states."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "launcherbtt_frame"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/toggle

/obj/item/frame/button/toggle/alernate
	name = "door toggle button frame"
	desc = "Used for building buttons that can toggle between 2 states."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "doorctrl-p"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/toggle/alternate

/obj/item/frame/button/toggle/switch
	name = "switch toggle button frame"
	desc = "Used for building buttons that can toggle between 2 states and look like a lightswitch."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "doorctrl-p"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/toggle/switch

/obj/item/frame/button/toggle/lever
	name = "lever frame"
	desc = "Used for building levers that can toggle between 2 states."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "switch-up"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/toggle/lever

/obj/item/frame/button/toggle/lever/double
	name = "double lever frame"
	desc = "Used for building heavy duty levers that can toggle between 2 states."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "switch-dbl-up"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/button/toggle/lever/dbl




/obj/item/frame/light_switch
	name = "light switch frame"
	desc = "Used for repairing or building light switches"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "light-p"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/light_switch

/obj/item/frame/turret_control
	name = "turret control panel frame"
	desc = "Used for building turret control panels"
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_off"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/turretid

/obj/item/frame/intercom
	name = "Intercom Frame"
	desc = "Used for building intercoms"
	icon = 'icons/obj/machines/radio_intercom.dmi'
	icon_state = "intercom-p"
	build_machine_type = /obj/item/device/radio/intercom

/obj/item/frame/noticeboard
	name = "noticeboard"
	desc = "Used for building NoticeBoards"
	icon = 'icons/obj/structures/noticeboard.dmi'
	icon_state = "nboard00"
	matter = list(MATERIAL_WOOD = 2 * SHEET_MATERIAL_AMOUNT)
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
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	matter = list(MATERIAL_SILVER = 2 SHEETS)
	build_machine_type = /obj/item/weapon/storage/mirror

/obj/item/frame/plastic/shower
	name = "Shower Frame"
	desc = "Used for building Showers"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	build_machine_type = /obj/structure/hygiene/shower

/obj/item/frame/wallflash
	name = "Wall Flash Frame"
	desc = "Used for building Wall Mounted Flashes"
	icon = 'icons/obj/machines/flashers.dmi'
	icon_state = "mflash1"
	build_machine_type = /obj/machinery/flasher

/obj/item/frame/oxypump
	name = "Emergency Oxygen Pump Frame"
	desc = "Used for building wall-mounted oxygen pumps"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "emerg_open"
	matter = list(MATERIAL_STEEL = 5 * SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/oxygen_pump

/obj/item/frame/anestheticpump
	name = "Anesthetic Pump Frame"
	desc = "Used for building wall-mounted oxygen pumps"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "anesthetic_tank_open"
	matter = list(MATERIAL_STEEL = 5 * SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/oxygen_pump/anesthetic
	reverse = 1

/obj/item/frame/barsign
	name = "Bar Sign Frame"
	desc = "Used for building Bar Signs"
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	build_machine_type = /obj/structure/sign/double/barsign

/obj/item/frame/plastic/sink
	name = "Sink Frame"
	desc = "Used for building Sinks"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	build_machine_type = /obj/structure/hygiene/sink

/obj/item/frame/plastic/urinal
	name = "Urinal Frame"
	desc = "Used for building urinals"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	build_machine_type = /obj/structure/hygiene/urinal

/obj/item/frame/plastic/kitchensink
	name = "Kitchen Sink Frame"
	desc = "Used for building Kitchen Sinks"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_alt"
	build_machine_type = /obj/structure/hygiene/sink/kitchen

/obj/item/frame/plastic/virusfoodtank
	name = "Virus Food Dispenser Frame"
	desc = "Used for building wall-mounted virus food dispensers."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	matter = list(MATERIAL_PLASTIC = 5 * SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/structure/reagent_dispensers/wall/virusfood/empty

/obj/item/frame/plastic/acidtank
	name = "Sulphuric Acid Dispenser Frame"
	desc = "Used for building wall-mounted acid dispensers."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	matter = list(MATERIAL_PLASTIC = 5 * SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/structure/reagent_dispensers/wall/acid/empty

/obj/item/frame/plastic/peppertank
	name = "Pepper Spray Refiller Frame"
	desc = "Used for building wall-mounted pepper spray refillers."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	matter = list(MATERIAL_PLASTIC = 5 * SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/structure/reagent_dispensers/wall/peppertank/empty

/obj/item/frame/newscaster
	name = "News Caster Frame"
	desc = "Used for building News Casters"
	icon = 'icons/obj/machines/terminals/newscaster.dmi'
	icon_state = "newscaster_off"
	build_machine_type = /obj/machinery/newscaster

/obj/item/frame/newscaster/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOB.cardinal))
		return
	var/turf/loc = get_turf(usr)

	new /obj/machinery/newscaster(loc, 1, src, ndir)
	qdel(src)

/obj/item/frame/atm
	name = "atm"
	desc = "An ATM, just secure to the wall."
	icon = 'icons/obj/machines/terminals/atm.dmi'
	icon_state = "atm_frame"
	build_machine_type = /obj/machinery/atm
	reverse = 1

/obj/item/frame/status_display
	name = "status display frame"
	desc = "A status display screen frame."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	build_machine_type = /obj/machinery/status_display

/obj/item/frame/pager
	name = "pager frame"
	desc = "A department pager frame."
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "doorbell"
	build_machine_type = /obj/machinery/pager

/obj/item/frame/request_console
	name = "request console frame"
	desc = "A frame for a wall mounted request console."
	icon = 'icons/obj/machines/terminals/reqterm.dmi'
	icon_state = "req_comp_off"
	build_machine_type = /obj/machinery/requests_console
	reverse = 1

/obj/item/frame/sparker
	name = "mounted igniter"
	desc = "A frame for a wall mounted igniter."
	icon = 'icons/obj/machines/igniters.dmi'
	icon_state = "migniter"
	build_machine_type = /obj/machinery/sparker
	reverse = 1


//---------------------------------
// Wall mounted closets
//---------------------------------
/obj/item/frame/hydrant_closet
	name = "fire-safety closet frame"
	desc = "Used for building wall-mounted fire safety closets"
	icon = 'icons/obj/closet.dmi'
	icon_state = "hydrant_open"
	build_machine_type = /obj/structure/closet/wall/hydrant

/obj/item/frame/medical_closet
	name = "first-aid closet frame"
	desc = "Used for building wall-mounted first aid closets"
	icon = 'icons/obj/closet.dmi'
	icon_state = "medical_wall_first_aid_open"
	build_machine_type = /obj/structure/closet/wall/medical

/obj/item/frame/general_closet
	name = "genera closet frame"
	desc = "Used for building wall-mounted closets"
	icon = 'icons/obj/closet.dmi'
	icon_state = "wall_general_open"
	build_machine_type = /obj/structure/closet/wall

/obj/item/frame/shipping_closet
	name = "shipping closet frame"
	desc = "Used for building wall-mounted shipping supplies closets"
	icon = 'icons/obj/closet.dmi'
	icon_state = "shipping_wall_open"
	build_machine_type = /obj/structure/closet/wall/shipping

/obj/item/frame/extinguisher_cabinet
	name = "extinguisher cabinet frame"
	desc = "Used for building wall-mounted extinguisher cabinets"
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher_empty"
	build_machine_type = /obj/structure/extinguisher_cabinet

/obj/item/frame/wall_safe
	name = "wall safe frame"
	desc = "Used for building wall-mounted secure safe"
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher_empty"
	build_machine_type = /obj/item/weapon/storage/secure/safe


/obj/item/frame/light/small/floor
	name = "small floor light fixture frame"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor-construct-stage1"
	build_machine_type = /obj/machinery/light_construct/small/floor

/obj/item/frame/light/small/floor/try_build(turf/on_wall)
	if(!build_machine_type)
		log_debug("[name]([type]) was placed but has no resulting machine type set..")
		return
	if (get_dist(on_wall,usr)>1)
		return
	var/turf/T = get_turf(usr)
	var/area/A = get_area(on_wall)
	if (!istype(on_wall, /turf/simulated/floor))
		to_chat(usr, SPAN_DANGER("\The [src] cannot be placed on this spot."))
		return
	if (A.requires_power == 0 || A.name == "Space" && !isLightFrame())
		to_chat(usr, SPAN_DANGER("\The [src] cannot be placed in this area."))
		return
	new build_machine_type(T, dir, src)
	qdel(src)

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	icon = 'icons/obj/lighting_nav.dmi'
	icon_state = "nav-construct-item"
	matter = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT)
	build_machine_type = /obj/machinery/light_construct/nav

/obj/item/frame/light/nav/try_build(turf/on_wall)
	if(!build_machine_type)
		log_debug("[name]([type]) was placed but has no resulting machine type set..")
		return
	if (get_dist(on_wall,usr)>1)
		return
	var/turf/T = get_turf(usr)
	if (!istype(on_wall, /turf/simulated/floor))
		to_chat(usr, SPAN_DANGER("\The [src] cannot be placed on this spot."))
		return
	new build_machine_type(T, src.dir, src)
	qdel(src)