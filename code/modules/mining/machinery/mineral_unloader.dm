/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"
	input_turf =  WEST
	output_turf = EAST
	circuit_type = /obj/item/weapon/circuitboard/mining_unloader

/obj/machinery/mineral/unloading_machine/Process()
	if(input_turf && output_turf)
		var/ore_this_tick = 25
		for(var/obj/structure/ore_box/unloading in input_turf)
			for(var/obj/item/stack/ore/_ore in unloading)
				_ore.drop_to_stacks(output_turf)
				if(--ore_this_tick<=0) return
		for(var/obj/item/thing in input_turf)
			if(thing.simulated && !thing.anchored)
				if(istype(thing,/obj/item/stack))
					var/obj/item/stack/thestack = thing
					thestack.drop_to_stacks(output_turf)
				else
					thing.dropInto(output_turf)
				if(--ore_this_tick<=0) return