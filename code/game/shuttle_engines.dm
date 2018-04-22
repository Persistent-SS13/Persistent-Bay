/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = 1
	opacity = 0
	anchored = 1

	CanPass(atom/movable/mover, turf/target, height, air_group)
		if(!height || air_group) return 0
		else return ..()

/obj/structure/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"

//I'll just define a new "machine" instead
/obj/machinery/shuttleengine
	name = "propulsion"
	density = 1
	anchored = 1.0
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "propulsion"
	opacity = 1

	CanPass(atom/movable/mover, turf/target, height, air_group)
		if(!height || air_group) return 0
		else return ..()

/obj/machinery/shuttleengine/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/shuttleengine(src)
	component_parts += new /obj/item/device/assembly/igniter(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/stack/cable_coil(src, 30)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/uranium(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	component_parts += new /obj/item/stack/material/ocp(src)
	RefreshParts()

/obj/machinery/shuttleengine/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	..()