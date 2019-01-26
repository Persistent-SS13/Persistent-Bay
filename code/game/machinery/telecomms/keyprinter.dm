/obj/machinery/keyprinter
	name = "encryption key printer"
	desc = "An advanced ciper machine used to generate physical cypher keys for telecommunications."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "keyprinter"

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40
	active_power_usage = 300

	var/tmp/datum/world_faction/connected_faction
	var/printing

/obj/machinery/keyprinter/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/keyprinter(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	RefreshParts()

/obj/machinery/keyprinter/update_icon()
	overlays.Cut()
	if(printing)
		overlays += "keyprinter_o"

/obj/machinery/keyprinter/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	return ..()

/obj/machinery/keyprinter/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))
		if(!connected_faction && O.GetFaction())
			req_access_faction = O.GetFaction()
			connected_faction = get_faction(req_access_faction)
		return
	..()
/obj/machinery/keyprinter/attack_hand(mob/user)

	if(printing || (stat & (BROKEN|NOPOWER)))
		return

	if(!connected_faction)
		return

	var/list/reserved_frequencies = connected_faction.reserved_frequencies
	var/reserved = input("For what reserved frequency would you like to print?") as null|anything in reserved_frequencies

	if(!reserved)
		return

	var/inpt = input("Enter two characters to use for the radio key. The radio prefix will be added automatically", "Enter radio key") as null|text
	var/radio_key
	if(inpt)
		if(length(inpt) != 2)
			alert(user, "You must use two characters.", "Key Rejected", "Ok")
		else
			radio_key = ":" + inpt

	if(!reserved ||!radio_key ||printing || (stat & (BROKEN|NOPOWER)))
		return

	use_power = 2
	printing = 1
	update_icon()

	sleep(20)

	use_power = 1
	printing = 0
	update_icon()

	if(!reserved ||!radio_key ||printing || (stat & (BROKEN|NOPOWER)))
		return

	new /obj/item/device/encryptionkey/custom(src.loc, reserved_frequencies[reserved], radio_key, reserved)