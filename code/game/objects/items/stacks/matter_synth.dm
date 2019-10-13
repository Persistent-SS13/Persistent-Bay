/datum/matter_synth
	var/name = "Generic Synthesizer"
	var/max_energy = 60000
	var/recharge_rate = 2000
	var/max_energy_multiplied = 60000
	var/multiplier = 1						// Robot may be upgraded with better matter bin to multiply capacity of it's synthetisers
	var/energy

/datum/matter_synth/New(var/store = 0)
	..()
	ADD_SAVED_VAR(name)
	ADD_SAVED_VAR(max_energy)
	ADD_SAVED_VAR(recharge_rate)
	ADD_SAVED_VAR(max_energy_multiplied)
	ADD_SAVED_VAR(multiplier)
	ADD_SAVED_VAR(energy)
	if(store)
		max_energy = store
	energy = max_energy_multiplied
	set_multiplier(1)

/datum/matter_synth/proc/get_charge()
	return energy

/datum/matter_synth/proc/use_charge(var/amount)
	if (energy >= amount)
		energy -= amount
		return 1
	return 0

//Returns the amount of charge leftover
/datum/matter_synth/proc/add_charge(var/amount)
	var/accepted = min(energy + amount, max_energy_multiplied)
	energy = accepted
	return min(0, amount - accepted)

/datum/matter_synth/proc/emp_act(var/severity)
	use_charge(max_energy_multiplied * 0.1 / severity)

/datum/matter_synth/proc/set_multiplier(var/new_multiplier)
	multiplier = new_multiplier
	max_energy_multiplied = max_energy * multiplier
	energy = min(max_energy_multiplied, energy)

//Subclass for matter_synths that need to be fed something to recharge their capacity
/datum/matter_synth/rechargeable
	recharge_rate = 0
	var/list/accepted_materials = list() //The material names of the materials that are accepted to recharge this synth
	var/list/accepted_reagents = list()	//The reagents names of the accepted reagents to recharge this synth

/datum/matter_synth/rechargeable/proc/charge_from_matter(var/obj/item/I)
	var/consumed = FALSE //Whether the item had anything we would want from it
	var/success = FALSE
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/ST = I
		for(var/k in ST.matter)
			if(k in accepted_materials)
				add_charge(I.matter[k])
				consumed = TRUE //No matter how little we take from the stack, the whole thing is destroyed
				success = TRUE
	else if(istype(I, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/C = I
		if(C.reagents && C.reagents.reagent_list)
			for(var/datum/reagent/A in C.reagents.reagent_list)
				if(A.type in accepted_reagents)
					C.reagents.remove_reagent(A.type, add_charge(A.volume)) //Just take what we need
					success = TRUE
	
	if(consumed)
		qdel(I)
	return success



/datum/matter_synth/medicine
	name = "Medicine Synthesizer"

/datum/matter_synth/nanite
	name = "Nanite Synthesizer"

/datum/matter_synth/metal
	name = "Metal Synthesizer"

/datum/matter_synth/plasteel
	name = "Plasteel Synthesizer"
	max_energy = 10000

/datum/matter_synth/glass
	name = "Glass Synthesizer"

/datum/matter_synth/wood
	name = "Wood Synthesizer"

/datum/matter_synth/plastic
	name = "Plastic Synthesizer"

/datum/matter_synth/wire
	name = "Wire Synthesizer"
	max_energy = 50
	recharge_rate = 2

/datum/matter_synth/package_wrap
	name = "Package Wrapper Synthesizer"
	max_energy = 50
	recharge_rate = 2

/datum/matter_synth/rechargeable/nanite
	name = "Nanite Dispenser"
	accepted_reagents = list(/datum/reagent/nanitefluid)
/datum/matter_synth/rechargeable/aluminium
	name = "Aluminium Dispenser"
	accepted_materials = list(MATERIAL_ALUMINIUM)
/datum/matter_synth/rechargeable/steel
	name = "Steel Dispenser"
	accepted_materials = list(MATERIAL_STEEL)
/datum/matter_synth/rechargeable/plasteel
	name = "Plasteel Dispenser"
	max_energy = 10000
	accepted_materials = list(MATERIAL_PLASTEEL)
/datum/matter_synth/rechargeable/glass
	name = "Glass Dispenser"
	accepted_materials = list(MATERIAL_GLASS)
/datum/matter_synth/rechargeable/rglass
	name = "Reinforced Glass Dispenser"
	accepted_materials = list(MATERIAL_REINFORCED_GLASS)
/datum/matter_synth/rechargeable/wood
	name = "Wood Dispenser"
	accepted_materials = list(MATERIAL_WOOD)
/datum/matter_synth/rechargeable/plastic
	name = "Plastic Dispenser"
	accepted_materials = list(MATERIAL_PLASTIC)
/datum/matter_synth/rechargeable/wire
	name = "Wire Dispenser"
	max_energy = 50
	accepted_materials = list(MATERIAL_COPPER)
/datum/matter_synth/rechargeable/package_wrap
	name = "Package Wrapper Dispenser"
	max_energy = 50
	accepted_materials = list(MATERIAL_WOOD)