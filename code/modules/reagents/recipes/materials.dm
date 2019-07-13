//-------------------------------------
//	Phoronsolidification
//-------------------------------------
/**
/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/frostoil = 5, /datum/reagent/toxin/phoron = 20)
	result_amount = 1
	minimum_temperature = (-80 CELSIUS) - 100
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens and begins to crystallize."

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)
**/

//-------------------------------------
//	Plastication
//-------------------------------------
/datum/chemical_reaction/plastication
	name = "Plastic"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/toxin/plasticide = 2)
	result_amount = 1
	mix_message = "The solution solidifies into a grey-white mass."

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

/datum/chemical_reaction/plastication2
	name = "Plastic"
	result = null
	required_reagents = list(/datum/reagent/ethanol = 25, /datum/reagent/aluminium = 25, /datum/reagent/oxygen = 25) //Basically, dehydrate ethanol into ethene, and then magically get it to turn into polyethene
	result_amount = 1
	mix_message = "The solution solidifies into a grey-white mass."
	minimum_temperature = T0C + 100
	maximum_temperature = T0C + 200
/datum/chemical_reaction/plastication2/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

//-------------------------------------
//	Pultrusion
//-------------------------------------
/datum/chemical_reaction/pultrusion
	name = "Fiberglass"
	result = null
	required_reagents = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasticide = 2)
	catalysts = list(/datum/reagent/toxin/plasticide = 8)
	result_amount = 1

/datum/chemical_reaction/pultrusion/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/glass/fiberglass(get_turf(holder.my_atom), created_volume)

//-------------------------------------
//	Latticing
//-------------------------------------
/datum/chemical_reaction/latticing
	name = "Glass"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/silicon = 20)
	result_amount = 1

/datum/chemical_reaction/latticing/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/stack/material/glass(get_turf(holder.my_atom), created_volume)

//-------------------------------------
//	Deuterium
//-------------------------------------
/datum/chemical_reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(/datum/reagent/water = 10)
	catalysts = list(/datum/reagent/toxin/phoron/oxygen = 5)
	result_amount = 1

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

//-------------------------------------
//	Soap key
//-------------------------------------
/datum/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/datum/reagent/frostoil = 2, /datum/reagent/space_cleaner = 5)
	var/strength = 3

/datum/chemical_reaction/soap_key/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/weapon/soap))
		return ..()
	return 0

/datum/chemical_reaction/soap_key/on_reaction(var/datum/reagents/holder)
	var/obj/item/weapon/soap/S = holder.my_atom
	if(S.key_data)
		var/obj/item/weapon/key/soap/key = new(get_turf(holder.my_atom), S.key_data)
		key.uses = strength
	..()

//-------------------------------------
//	Soap
//-------------------------------------
/datum/chemical_reaction/soap
	name = "Soap"
	result = null
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/soap/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/soap(location)

//-------------------------------------
//	Gold Soap
//-------------------------------------
/datum/chemical_reaction/gold_soap
	name = "Gold Soap"
	result = null
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/gold = 1)
	result_amount = 1

/datum/chemical_reaction/gold_soap/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/soap/gold(location)

//-------------------------------------
//	NT Soap
//-------------------------------------
/datum/chemical_reaction/nt_soap
	name = "Nanotrasen Soap"
	result = null
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/toxin/phoron = 1)
	result_amount = 1

/datum/chemical_reaction/nt_soap/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/soap/nanotrasen(location)

//-------------------------------------
//	Syndicate Soap
//-------------------------------------
/datum/chemical_reaction/syndie_soap
	name = "Syndicate Soap"
	result = null
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/space_cleaner = 1, /datum/reagent/blood = 1)
	result_amount = 1

/datum/chemical_reaction/syndie_soap/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/soap/syndie(location)

//-------------------------------------
//	Cooling beeswax
//-------------------------------------
/datum/chemical_reaction/cooling_beeswax
	name = "Cooled beeswax"
	result = null
	required_reagents = list(/datum/reagent/beeswax = 20)
	result_amount = 1
	minimum_temperature = T0C - 10 //Let it go down under 0 just so we don't possibly interfere with new reactions
	maximum_temperature = T0C
/datum/chemical_reaction/cooling_beeswax/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/material/edible/beeswax(location)