/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	door_color = COLOR_SUN
	mineral = MATERIAL_GOLD
	armor = list(
		DAM_BLUNT  	= 60,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 40,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	door_color = COLOR_SILVER
	mineral = MATERIAL_SILVER
	armor = list(
		DAM_BLUNT  	= 60,
		DAM_PIERCE 	= 20,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 20,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 20,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 40,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	door_color = COLOR_CYAN_BLUE
	mineral = MATERIAL_DIAMOND
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= MaxArmorValue,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 80,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 20,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	door_color = COLOR_PAKISTAN_GREEN
	mineral = MATERIAL_URANIUM
	var/last_event = 0
	var/rad_power = 7.5
	armor = list(
		DAM_BLUNT  	= 60,
		DAM_PIERCE 	= 50,
		DAM_CUT 	= 60,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 50,
		DAM_BOMB 	= 30,
		DAM_EMP 	= 40,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/sandstone
	name = "\improper Sandstone Airlock"
	door_color = COLOR_BEIGE
	mineral = MATERIAL_SANDSTONE
	armor = list(
		DAM_BLUNT  	= 60,
		DAM_PIERCE 	= 60,
		DAM_CUT 	= 80,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 80,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 10,
		DAM_EMP 	= 80,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/airlock/phoron
	name = "\improper Phoron Airlock"
	desc = "No way this can end badly."
	door_color = COLOR_PURPLE
	mineral = MATERIAL_PHORON

/obj/machinery/door/airlock/uranium/Process()
	if(world.time > last_event+20)
		if(prob(50))
			SSradiation.radiate(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas(GAS_PHORON, 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)