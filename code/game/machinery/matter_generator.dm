/datum/mattergen/recipe/
	var/name = "metal name" 	//used for recipe display, use the same string as you do in the materialStored list
	var/powerUsed = 0			//power drained from cells when crafting
	var/craftResult = ""		//path to obj made
	var/requiredTier = 0		//level of scanner needed to craft
	var/id = null				//the id of the datum, equal to the craftresult's sheettype
/*
aluminum
brass
bronze
carbon
copper
deuterium
diamond
glass
gold
iron
lead
marble
ocp
osmium
phoron
plasteel
plastic
platinum
salt
sandstone
silver
steel
sulfur
tin
tritium
tungsten
uranium
zinc
*/

/obj/machinery/mattergen
	icon = 'icons/obj/machines/heavy_lathe.dmi'//If you want to change this do ctrl+f for ICON_REF
	name = "matter replicator"
	desc = "It produces sheets from sheets and power."
	icon_state = "h_lathe"//ICON_REF

	anchored = 1
	density = 1
	layer = 2.9
	dir = 4

	use_power = 0 //or use power from APC aswell?
	idle_power_usage = 0
	interact_offline = 1

	var/progress = 0
	var/autocraft = 0
	var/busy = 0

	var/maxMaterialStorage
	var/maxPowerDraw
	var/tier

	var/activeRecipe//just an index
	var/list/datum/mattergen/recipe/recipe
	var/list/amount//stores flat sheets
	var/list/enabled//slaped on the machine yet?

	var/charged
	var/heat
	var/heat_capacity = 4000

	var/obj/structure/cable/cableNode

/obj/machinery/mattergen/proc/addRecipe(datum/mattergen/recipe/R)
	recipe += R
	amount += 0
	enabled += 0

/obj/machinery/mattergen/proc/enableRecipe(int_recipe_index)
	enabled[int_recipe_index] = 1
	for(var/obj/item/weapon/circuitboard/mattergen/M in component_parts)
		M.enabled = src.enabled

/obj/machinery/mattergen/New()
	..()

	recipe = list()
	amount = list()
	enabled = list()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/mattergen()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin()
	component_parts += new /obj/item/weapon/stock_parts/scanning_module()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	component_parts += new /obj/item/weapon/stock_parts/console_screen()
	component_parts += new /obj/item/stack/cable_coil(null, 5)
	RefreshParts()

	var/turf/simulated/Turf = loc
	if(istype(Turf))
		var/datum/gas_mixture/env = loc.return_air()
		heat = env.temperature
	else
		heat = T0C + 20

/obj/machinery/mattergen/RefreshParts()
	var/turf/Turf = src.loc
	cableNode = Turf.get_cable_node()

	for(var/obj/item/weapon/circuitboard/mattergen/M in component_parts)
		if(isnull(M.enabled))
			M.enabled = src.enabled
		else
			src.enabled = M.enabled

	var/T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	maxMaterialStorage = 5 + (15 * T)

	T = 0
	for(var/obj/item/weapon/stock_parts/capacitor/M in component_parts)
		T += M.rating
	maxPowerDraw = T * 30000

	T = 1
	for(var/obj/item/weapon/stock_parts/scanning_module/M in component_parts)
		T = max(T, M.rating)
	tier = T


/obj/machinery/mattergen/proc/getModifiedCraftEnergy(int_recipe_index)
	var/datum/mattergen/recipe/R = recipe[int_recipe_index]
	return round(R.powerUsed)

/obj/machinery/mattergen/proc/canCraft(int_recipe_index)
	var/datum/mattergen/recipe/R = recipe[int_recipe_index]
	return (tier >= R.requiredTier && enabled[int_recipe_index] == 1)

/obj/machinery/mattergen/proc/addAmount(int_recipe_index, int_amount)
	amount[int_recipe_index] += int_amount
	if((amount[int_recipe_index] + int_amount) > maxMaterialStorage)
		ejectMaterial(int_recipe_index)

/obj/machinery/mattergen/proc/takeAmount(int_recipe_index, int_amount)
	if(amount[int_recipe_index] >= int_amount)
		amount[int_recipe_index] -= int_amount
		return 1
	return 0

/obj/machinery/mattergen/attackby(obj/item/O, mob/user, params)
	if(busy == 0)
		if(anchored && default_deconstruction_screwdriver(user, "h_lathe_maint", "h_lathe", O))//ICON_REF
			src.updateDialog()
			return

		if(anchored && istype(O, /obj/item/weapon/storage/part_replacer))
			if(exchange_parts(user, O))
				return
			else
				RefreshParts()
				return
		if (panel_open)
			if(istype(O, /obj/item/weapon/crowbar))
				for(var/i = 1, i <= recipe.len, i++)
					ejectMaterial(i)
				default_deconstruction_crowbar(O)
				return 1
			else if(istype(O, /obj/item/weapon/wrench))
				default_unfasten_wrench(user, O)
			else
				attack_hand(user)
				return 1
	if (stat & BROKEN)
		if(istype(O, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = O
			if(C.amount >= 5)
				user << "You start to replace the wires in [name]"
				//if(do_after(user, 25, target = src))
				if(do_after(user, 25))
					C.use(5)
					stat = 0
					if(activeRecipe > 0)
						src.overlays += "h_lathe_wloop"//ICON_REF
						busy = 1
					user << "You successfully repair the [name]"
			else
				user << "You need 5 bits of cable to repair the [name]"
			return 1
		user << "The [name] is broken, replace the wires."
	else if(stat)
		return 1
	if(istype(O, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/stack = O
//		if(!stack.is_cyborg && stack.get_amount() > 0)
		if(!istype(stack,/obj/item/stack/sheet/metal/cyborg) && stack.amount > 0)
			for(var/i = 1, i <= recipe.len, i++)
				var/datum/mattergen/recipe/R = recipe[i]
//				if(istype(stack, R.craftResult))
				if(stack.sheettype == R.id)
					if(enabled[i] == 0 && R.requiredTier <= tier)
						user << "The [name] scans the [R.name] sheet."
						enableRecipe(i)
						break
					else if(enabled[i] == 1)
						user << "The [name] has already scanned that."
						break
				else if(i == recipe.len)
					user << "The [name] can not replicate that."
	if(istype(O, /obj/item/weapon/circuitboard/mattergen))
		var/obj/item/weapon/circuitboard/mattergen/B = O
		if(isnull(B.enabled))
			B.enabled = enabled
		for(var/i = 1, i < B.enabled.len, i++)
			if(B.enabled[i] == 1)
				enableRecipe(i)
			else if(enabled[i] == 1)
				B.enabled[i] = 1
		user << "Copied recipes to and from circuitboard"
	src.updateDialog()
	return

/obj/machinery/mattergen/attack_hand(mob/user)
	if(..(user, 0))
		return
	if(heat > 360)
		//copy pasted code from light
		var/prot = 0
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
			if(!prot)
				user << "The [name] is so hot you burn your hand on it."
				var/obj/item/organ/limb/affecting = H.get_organ("[user.hand ? "l" : "r" ]_arm")
				if(affecting.take_damage( 0, round((heat-T0C-50)/10) ))
					H.update_damage_overlays(0)
				H.updatehealth()
	if(stat & BROKEN)
		user << "The [name] is broken, replace the wires."
		return
	if(panel_open)
		return
	interact(user)

/obj/machinery/mattergen/interact(mob/user)
	var/dat = "<h1>Matter Replicator interface</h1>"
	dat += "<hr>Grid status: "
	if(isnull(cableNode))
		dat += "not "
	dat += "connected."
	if(charged > 0)
		dat += " [charged]W"
	dat += "<hr>"
	dat += "Current heat level: [heat]K"
	var/overheat = isOverheated()
	if(overheat > 0)
		dat += ", wires may melt"
	/*(overheat > 1)
		dat += ", CRITICAL! REPLICATED MATERIAL MAY EXPLODE"*/
	dat += ".<hr>"
	if(activeRecipe > 0)
		var/datum/mattergen/recipe/R = recipe[activeRecipe]
		dat += "Currenly replicating [R.name]: "
		var/progressPercent = round((progress / getModifiedCraftEnergy(activeRecipe)) * 100)
		dat += "[progressPercent]%<br>"
		if(busy == 1)
			dat += "<a href='?src=\ref[src];busy=0'>Pause replication process.</a> "
		else
			dat += "<a href='?src=\ref[src];busy=1'>Resume replication process.</a> "
		dat += "<br>"
		if(amount[activeRecipe] > 0)
			dat += "<a href='?src=\ref[src];ejectMaterial=[activeRecipe]'>Eject stack</a>"
	else if(stat & BROKEN)
		dat += "Wires broken, repair machine to resume production."
	else
		dat += "RECIPES:"
		for(var/i = 1, i <= recipe.len, i++)
			var/datum/mattergen/recipe/R = recipe[i]
			if(canCraft(i))
				dat += "<br>"
				dat += "<a href='?src=\ref[src];setActiveRecipe=[i]'>Start [R.name] replication process.</a>"
				dat += "Cost: [getModifiedCraftEnergy(i)] J"
			if(amount[i] > 0)
				dat += "<br>"
				dat += "[R.name]: [amount[i]]/[maxMaterialStorage] "
				dat += "<a href='?src=\ref[src];ejectMaterial=[i]'>Eject stack</a>"
	dat += "<hr>"
	if(autocraft > 0)
		dat += "<a href='?src=\ref[src];setAutoCraft=0'>Autocraft: on </a> "
	else
		dat += "<a href='?src=\ref[src];setAutoCraft=1'>Autocraft: off </a> "
	var/datum/browser/popup = new(user, "mattergen", src.name, 400, 500)
	popup.set_content(dat)
	popup.open(1)

/obj/machinery/mattergen/Topic(href, href_list)
	if(panel_open)
		return
	if(..())
		return
	if(!busy && href_list["setActiveRecipe"])
		setActiveRecipe(text2num(href_list["setActiveRecipe"]))
	if(href_list["ejectMaterial"])
		ejectMaterial(text2num(href_list["ejectMaterial"]))
	if(href_list["setAutoCraft"])
		autocraft = text2num(href_list["setAutoCraft"])
	if(href_list["busy"])
		busy = text2num(href_list["busy"])
	src.updateDialog()

/obj/machinery/mattergen/proc/ejectMaterial(int_recipe_index)
	var/eject_count = min(50, amount[int_recipe_index])
	if(eject_count > 0)
		amount[int_recipe_index] -= eject_count
		var/datum/mattergen/recipe/R = recipe[int_recipe_index]
		var/turf/T = get_step(src.loc, src.dir)
		new R.craftResult(T, eject_count)
		flick("h_lathe_leave",src)//ICON_REF

/obj/machinery/mattergen/proc/setActiveRecipe(int_recipe_index)
	if(!busy)
		activeRecipe = int_recipe_index
		if(activeRecipe != 0)
			progress = 0
			busy = 1
			src.overlays += "h_lathe_wloop"//ICON_REF

/obj/machinery/mattergen/proc/make()
	if(busy == 1 && !stat & BROKEN && activeRecipe)
		if(charged > 0)
			progress += charged * 0.975
		if(progress >= getModifiedCraftEnergy(activeRecipe))
			progress -= getModifiedCraftEnergy(activeRecipe)
			//if(!overheatEffect())//checks to see if result material will explode
			addAmount(activeRecipe, 1)
			if(autocraft == 0)
				src.overlays -= "h_lathe_wloop"//ICON_REF
				flick("h_lathe_leave",src)//ICON_REF
				busy = 0
				setActiveRecipe(0)
				src.updateDialog()

/obj/machinery/mattergen/proc/drawPower()
	if(busy)
		if(isnull(cableNode))
			var/turf/T = src.loc
			cableNode = T.get_cable_node()
		var/mpd = getModifiedMaxPowerDraw()
		if(istype(cableNode))
			var/joules = 0
			if(cableNode.surplus() > mpd)
				joules += mpd
				cableNode.add_load(mpd)
			else
				joules += cableNode.surplus()
				cableNode.add_load(cableNode.surplus())
			src.updateDialog()
			return joules
	return 0

/obj/machinery/mattergen/process()
	charged = drawPower()
	heat()
	if(stat & BROKEN)
		return
	make()

/obj/machinery/mattergen/proc/heat()
	var/turf/simulated/Turf = loc
	if(istype(Turf))
		if(charged > 0)
			var/heat_by_charge = round(charged * 0.025)
			heat = (heat * heat_capacity + heat_by_charge) / heat_capacity
		var/datum/gas_mixture/gas_mix = Turf.return_air()
		//TODO: not sure why 25% of moles is standard, other heaters do it too
		//var/datum/gas_mixture/gas_mix = env.remove(0.25 * env.total_moles())
		//let's not shift around too many numbers, this is inside process()

		var/delta_temp = gas_mix.temperature - heat
		var/gm_hcap = gas_mix.heat_capacity()
		if(delta_temp < -0.5 || delta_temp > 0.5)//don't exchange when players can't see the difference
			var/removed_heat = heat_capacity * 0.05 * delta_temp
			if(panel_open)
				removed_heat *= 2
			heat = (heat * heat_capacity + removed_heat) / heat_capacity
			if(removed_heat > 0)
				removed_heat = min(removed_heat, gm_hcap * 5)
			else
				removed_heat = max(removed_heat, -1 * gm_hcap * 5)
				heat = (heat * heat_capacity + removed_heat) / heat_capacity
				gas_mix.temperature = (gas_mix.temperature * gm_hcap - removed_heat) / gm_hcap
			air_update_turf()
	if(!stat & BROKEN && charged > 0 && isOverheated() > 0)
		if(rand(0, 10000) <= round((heat - 260 - T0C)/ 100))//wires are robust, machine should more often explode than break.
			busy = 0
			src.overlays -= "h_lathe_wloop"//ICON_REF
			stat = BROKEN
			visible_message("<span class='warning'>The [name] ejects cloud of black smoke, the wires have melted.</span>")

/obj/machinery/mattergen/proc/getModifiedMaxPowerDraw()
	return round(maxPowerDraw * max(1,(1 + (heat-T0C)/200)))

//0 = not overheated
//1 = rng to break wires
//2 = rng to explode
/obj/machinery/mattergen/proc/isOverheated()
	//if(heat > T0C + 2000)
	//	return 2
	if(heat > T0C + 360)
		return 10
	return 0

/*
/obj/machinery/mattergen/proc/overheatEffect()
	if(isOverheated() > 1)
		if(rand(0, 100) <= 30) //30% chance to blow up
			overcharged = 0
			stat = BROKEN
			explosion(get_step(src.loc, src.dir), 0, 1, 2, -1)
			visible_message("<span class='warning'>The [name] explodes! Maybe the heat was too much to bear!</span>")
			return 1//only used to see if result material blows up, don't return 1 anywhere else in this proc
	return 0*/