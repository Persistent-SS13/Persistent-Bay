/*  //////// NEUTRON FURNACE /////////
	Put a supermatter shard inside of it, set neutron flow to specific level, get materials out
*/
/obj/machinery/phoron_desublimer/furnace
	name = "Neutron Furnace"
	desc = "A modern day alchemist's best friend."
	icon_state = "Open"

	var/min_neutron_flow = 1
	var/neutron_flow = 30
	var/max_neutron_flow = 350
	var/obj/item/weapon/shard/supermatter/shard = null

	var/list/mat = list( "Osmium", "Phoron", "Diamonds", "Platinum", "Gold", "Uranium",  "Silver", "Steel", "Supermatter" )
	var/list/mat_mod = list(    "Steel" = 3.5,
								"Silver" = 1.5,
								"Uranium" = 0.8,
								"Gold" = 1,
								"Platinum" = 0.7,
								"Diamonds" = 0.55,
								"Phoron" = 0.55,
								"Osmium" = 1,
								"Supermatter" = 1.0 ) // modifier for output amount

	var/list/mat_peak = list()

	var/list/obj/item/stack/sheet/mat_obj = list( 	"Diamonds" = /obj/item/stack/sheet/mineral/diamond,
													"Steel" = /obj/item/stack/sheet/metal,
													"Silver" = /obj/item/stack/sheet/mineral/silver,
													"Platinum" = /obj/item/stack/sheet/mineral/platinum,
													"Osmium" = /obj/item/stack/sheet/mineral/osmium,
													"Gold" = /obj/item/stack/sheet/mineral/gold,
													"Uranium" = /obj/item/stack/sheet/mineral/uranium,
													"Phoron" = /obj/item/stack/sheet/mineral/phoron,
													"Supermatter" = /obj/item/weapon/shard/supermatter ) // cost per each mod # of bars

/obj/machinery/phoron_desublimer/furnace/New()
		..()

		mat_peak = list(		"Steel" = 30, \
								"Silver" = rand(40, 70), \
								"Uranium" = rand(80, 110), \
								"Gold" = rand(120, 150), \
								"Platinum" = rand(160, 190), \
								"Diamonds" = rand(200, 230), \
								"Phoron" = rand(240, 270), \
								"Osmium" = rand(280, 300), \
								"Supermatter" = rand(310, 340)) // Setting peak locations

		neutron_flow = rand(1,350)

		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

/obj/machinery/phoron_desublimer/furnace/process()
	..()

/obj/machinery/phoron_desublimer/furnace/proc/eject_shard()
	if( !shard )
		return

	shard.loc = get_turf( src )
	shard = null
	update_icon()

/obj/machinery/phoron_desublimer/furnace/proc/modify_flow(var/change)
	neutron_flow += change
	if( neutron_flow > max_neutron_flow )
		neutron_flow = max_neutron_flow

	if( neutron_flow < 0 )
		neutron_flow = 0

	// Produces the resultant material
/obj/machinery/phoron_desublimer/furnace/proc/produce()
	if( !shard )
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Needs a supermatter shard to transmutate.\"")
		return

	active = 1
	playsound(loc, 'sound/effects/neutron_charge.ogg', 50, 1, -1)
	flick( "Active", src )
	for(var/mob/living/l in oview(src, round(sqrt(neutron_flow / 2))))
		var/rads = (neutron_flow / 3) * sqrt( 1 / get_dist(l, src) )
		l.apply_effect(rads, IRRADIATE)
	sleep(28)
	playsound(loc, 'sound/effects/laser_sustained.ogg', 75, 1, -1)
	sleep(8)
	playsound(loc, 'sound/machines/ding.ogg', 50, 1, -1)
	sleep(10)

	var/list/peak_distances = list()
	peak_distances = get_peak_distances( neutron_flow )
	var/max_distance = 5.0 // Max peak distance from neutron flow which will still produce materials

	var/amount = 0
	for( var/cur_mat in peak_distances )
		var/distance = peak_distances[cur_mat]

		if( distance <= max_distance )
			if( cur_mat == "Supermatter" )
				new /obj/item/weapon/shard/supermatter( get_turf( src ), shard.smlevel+1 )
				break
			else
				var/size_modifier = shard.size*0.2
				// Produces amount based on distance from flow and modifier
				//amount = (( max_distance-distance )/max_distance )*mat_mod[cur_mat]
				//amount += amount*size_modifier

				var/k = (2 * PI) / (max_distance * 4)
				var/sin_exp = (k * PI * distance) + (PI / 2)

				amount = mat_mod[cur_mat] * size_modifier * sin(ToDegrees(sin_exp)) // u suck dm
				amount = round( amount )

				if( amount > 0 ) // Will only do anything if any amount was actually created
					var/obj/item/stack/sheet/T = mat_obj[cur_mat]
					var/obj/item/stack/sheet/I = new T
					I.amount = amount
					I.loc = src.loc

	eat_shard()
	src.visible_message("\icon[src] <b>[src]</b> beeps, \"Supermatter transmutation complete.\"")
	active = 0

	// This sorts a list of peaks within max_distance units of the given flow and returns a sorted list of the nearest ones
/obj/machinery/phoron_desublimer/furnace/proc/get_peak_distances( var/flow )
	var/list/peak_distances = new/list()

	for( var/cur_mat in mat_peak )
		var/peak = mat_peak[cur_mat]
		var/peak_distance = abs( peak-flow )
		peak_distances[cur_mat] = peak_distance

	return peak_distances

	// Eats the shard, duh
/obj/machinery/phoron_desublimer/furnace/proc/eat_shard()
	if( !shard )
		return 0

	qdel(shard)
	shard = null

	update_icon()
	return 1

	// Returns true if the machine is ready to perform
/obj/machinery/phoron_desublimer/furnace/report_ready()
	ready = 1

	..()

	return ready

/obj/machinery/phoron_desublimer/furnace/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	if(istype(B, /obj/item/weapon/shard/supermatter))
		if( !shard )
			user.drop_item()
			B.loc = src
			shard = B
			user << "You put [B] into the machine."
		else
			user << "There is already a shard in the machine."
	else
		user << "<span class='notice'>This machine only accepts supermatter shards</span>"

	update_icon()
	return


/obj/machinery/phoron_desublimer/furnace/update_icon()
	..()

	if( shard )
		icon_state = "OpenCrystal"
	else
		icon_state = "Open"
