/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "bspacerelay"
	anchored = 1
	density = 1
	circuit_type = /obj/item/weapon/circuitboard/bluespacerelay
	idle_power_usage = 15 KILOWATTS
	var/on = 1

/obj/machinery/bluespacerelay/New()
	. = ..()
	ADD_SAVED_VAR(on)

/obj/machinery/bluespacerelay/on_update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[initial(icon_state)]_off"
	else
		icon_state = initial(icon_state)

/obj/machinery/bluespacerelay/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	..()
