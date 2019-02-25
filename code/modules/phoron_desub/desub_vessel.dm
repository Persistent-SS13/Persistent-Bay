/*  //////// PHORON FORMATION VESSEL ////////
	Uses phoron gas to grow a supermatter shard
*/

/obj/machinery/phoron_desublimer/vessel
	name = "Formation Vessel"
	desc = "Grows supermatter shards by seeding them with phoron."
	icon_state = "ProcessorEmpty"
	var/obj/item/weapon/tank/loaded_tank
	var/obj/item/weapon/shard/supermatter/loaded_shard
	var/datum/gas_mixture/air_contents

	active_power_usage = 10000

/obj/machinery/phoron_desublimer/vessel/New()
	..()

	air_contents = new
	air_contents.volume = 84

	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

/obj/machinery/phoron_desublimer/vessel/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	else if(istype(B, /obj/item/weapon/shard/supermatter))
		if( !loaded_shard )
			user.drop_item()
			B.loc = src
			loaded_shard = B
			user << "You put [B] into the machine."
		else
			user << "There is already a shard in the machine."
	else if( istype( B, /obj/item/weapon/tank ))
		if( !loaded_tank )
			user.drop_item()
			B.loc = src
			loaded_tank = B
			user << "You put [B] into the machine."
		else
			user << "There is already a tank in the machine."
	else
		user << "/red That's not a valid item!"

	update_icon()
	return

/obj/machinery/phoron_desublimer/vessel/proc/filled()
	if( air_contents.total_moles > 1 )
		return 1
	else
		return 0

/obj/machinery/phoron_desublimer/vessel/proc/fill()
	if( !loaded_tank )
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"No tank loaded!\"")
		return
	if( loaded_tank.air_contents.total_moles < 1 )
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Loaded tank is empty!\"")
		return

	air_contents.merge( loaded_tank.air_contents.remove( loaded_tank.air_contents.total_moles ))

	if( icon_state != "ProcessorFull" )
		flick("ProcessorFill", src)
		sleep(12)
		icon_state = "ProcessorFull"

/obj/machinery/phoron_desublimer/vessel/proc/crystalize()
	if( !loaded_shard )
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"No gas present in system!\"")
		return
	if( !filled() )
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Need a supermatter shard to feed!\"")
		return
	if( !report_ready() )
		return

	active = 1

	loaded_shard.feed( air_contents.remove( air_contents.total_moles ))

	flick("ProcessorCrystalize", src)
	sleep(22)
	icon_state = "ProcessorEmpty"

	if( !loaded_shard ) //If our shard turned into something else, aka full crystal
		explosion( get_turf( src ), 0, 0, 5, 10, 1 )
		qdel( src )

	src.visible_message("\icon[src] <b>[src]</b> beeps, \"Crystal successfully fed.\"")

	active = 0

/obj/machinery/phoron_desublimer/vessel/proc/eject_shard()
	if( !loaded_shard )
		return

	loaded_shard.loc = get_turf( src )
	loaded_shard = null

/obj/machinery/phoron_desublimer/vessel/proc/eject_tank()
	if( !loaded_tank )
		return

	loaded_tank.loc = get_turf( src )
	loaded_tank = null

/obj/machinery/phoron_desublimer/vessel/report_ready()
	ready = 1

	..()

	return ready
