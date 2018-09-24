/obj/machinery/atmospherics/unary/drain
	name = "drain"
	desc = "Guess we can lower the janitor's payroll ?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "drain"
	density = 0
	anchored = 1
	use_power = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER

	idle_power_usage = 0		//drains don't use power, for now
	power_rating = 7500
	level = 1

	var/hibernate = 0
	var/drain_per_second = 15 // drain per second is also added to 10% of the current reagent's volume.

/obj/machinery/atmospherics/unary/drain/Process()
	..()
	if (hibernate)
		return

	var/active = 0
	var/datum/gas_mixture/environment = loc.return_air()
	for (var/obj/effect/decal/cleanable/puddle_chem/puddle in loc) // loops through puddles. If there is more than one something went WROOOONG

		for(var/datum/reagent/R in puddle.reagents.reagent_list) // Loops through reagents in the puddles
			if(!lowertext(R.name) in gas_data.gases)
				continue
			var/possible_transfers = min(drain_per_second + R.volume*0.1, R.volume)
			if (!possible_transfers) continue
			puddle.reagents.remove_reagent(R.type, possible_transfers)
			var/datum/gas_mixture/GM = new (_temperature = environment.temperature)
			GM.adjust_gas(lowertext(R.name), possible_transfers/REAGENT_GAS_EXCHANGE_FACTOR, update = 1) // yes we transform liquids into gas.
			air_contents.merge(GM)
			active = 1

	if (active && network)
		network.update = 1
	if (!active)
		hibernate = 1
		spawn (rand(50,100))
			hibernate = 0

/obj/machinery/atmospherics/unary/drain/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/unary/drain/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/drain/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	if (!(stat & NOPOWER) && use_power)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], turn it off first.</span>")
		return 1
	var/turf/T = src.loc
	if (node && node.level==1 && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it is too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40, src))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
