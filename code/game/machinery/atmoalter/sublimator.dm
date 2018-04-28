/obj/machinery/portable_atmospherics/sublimator
	name = "sublimator"
	desc = "A complex machine that takes in minerals and converts them to their gaseous state"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sublimator:0"
	density = 1
	w_class = ITEM_SIZE_GARGANTUAN

	volume = 500 //shouldn't just be a better canister

	anchored = 0
	use_power = 0

	var/update_flag = 0


/obj/machinery/portable_atmospherics/sublimator/attackby(var/obj/item/weapon/O as obj, var/mob/usr as mob)

	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/stack = O
		var/material/stack_material = stack.get_material()
		var/list/gaseous_products = stack_material.gaseous_products
		var/moles_per_sheet = 0 	//Total amount of moles in a single sheet of material
		var/pressure_per_sheet = 0

		var/remaining_pressure = maximum_pressure - air_contents.return_pressure()

		if(!stack_material.gaseous_products)
			to_chat(usr, "<span class='notice'>This material contains no useful gasses. </span>")
			return

		for(var/product in gaseous_products)
			moles_per_sheet += gaseous_products[product]

		pressure_per_sheet = ((moles_per_sheet*R_IDEAL_GAS_EQUATION*T0C)/volume)//we'll assume all sheets are at STP for convenience

		if(maximum_pressure - (air_contents.return_pressure() + pressure_per_sheet) <= 0) //cannot add if less than one sheet of pressure remaining
			to_chat(usr, "<span class='notice'>The [src]'s pressure is too high, pump out some of the gas.</span>")
			return

		var/amount_to_take = max(0,min (stack.amount,round(remaining_pressure/pressure_per_sheet)))

		for(var/product in gaseous_products)
			air_contents.adjust_gas(product, gaseous_products[product]*amount_to_take, 1)//Adds the proper amount of moles to the container

		to_chat(usr, "<span class='notice'>You add [amount_to_take] sheet\s to the [src.name].</span>")
		flick("sublimator:1", src) //plays material feeding animation.
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		update_icon()

		stack.use(amount_to_take)
		return
	..()
/obj/machinery/portable_atmospherics/sublimator/update_icon()
/*
update_flag
1 = connected_port
2 = tank_pressure < 10
4 = tank_pressure < ONE_ATMOS
8 = tank_pressure < 15*ONE_ATMOS
16 = tank_pressure go boom.
*/

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	src.overlays = 0

	if(update_flag & 1)
		overlays += "can-connector"
	if(update_flag & 2)
		overlays += "can-o0"
	if(update_flag & 4)
		overlays += "can-o1"
	else if(update_flag & 8)
		overlays += "can-o2"
	else if(update_flag & 16)
		overlays += "can-o3"
	return

/obj/machinery/portable_atmospherics/sublimator/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(connected_port)
		update_flag |= 1

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 2
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 4
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 8
	else
		update_flag |= 16

	if(update_flag == old_flag)
		return 1
	else
		return 0