#define ORE_STACK_MAX_OVERLAYS 10 //The maximum amount of ores overlay we'll ever have on the ore stack icon

//-----------------------------------------
// Stackable Ore
//-----------------------------------------
/obj/item/stack/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = ITEM_SIZE_SMALL

	//stack
	amount = 1
	max_amount = 250

	var/tmp/material/material
	var/saved_material //Material name to save. Since saving material datum is not a good idea
	var/datum/geosample/geologic_data
	stacktype = /obj/item/stack/ore

/obj/item/stack/ore/New(var/newloc, var/_mat)
	if(_mat)
		set_material_data_byname(_mat)
	..(newloc)
	ADD_SAVED_VAR(saved_material)
	ADD_SAVED_VAR(geologic_data)

/obj/item/stack/ore/after_load()
	..()
	if(saved_material)
		set_material_data_byname(saved_material)
	else if(!material)
		log_error("Loaded [src]\ref[src] with null material!")

/obj/item/stack/ore/before_save()
	. = ..()
	if(material)
		saved_material = material.name
/obj/item/stack/ore/after_save()
	. = ..()
	saved_material = null //we don't need it anymore

/obj/item/stack/ore/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/stack/ore/get_storage_cost()
	return ceil(base_storage_cost(w_class) * amount / 50)

/obj/item/stack/ore/proc/set_material_data_byname(var/material_name)
	set_material_data(SSmaterials.get_material_by_name(material_name))

/obj/item/stack/ore/proc/set_material_data(var/material/M)
	if(M && istype(M))
		name = M.ore_name
		desc = M.ore_desc ? M.ore_desc : "A lump of ore."
		material = M
		color = M.icon_colour
		icon_state = M.ore_icon_overlay
		materials_per_unit = M.get_ore_matter()
		update_material_value() //Calculates the total matter value for the stack
		if(M.ore_desc)
			desc = M.ore_desc
		if(icon_state == "dust")
			slot_flags = SLOT_HOLSTER

/obj/item/stack/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/stack/ore/attack_generic()
	qdel(src) // eaten

/obj/item/stack/ore/get_material()
	return material

/obj/item/stack/ore/on_update_icon()
	var/icstate = "lump"
	var/iccolor = src.color
	if(material)
		icstate = material.ore_icon_overlay
		iccolor = material.icon_colour
	var/nboverlays = min(ORE_STACK_MAX_OVERLAYS, round(amount/ORE_STACK_MAX_OVERLAYS))

	//Skip when we have the max nb of overlays or if the number doesn't change
	if(overlays.len >= ORE_STACK_MAX_OVERLAYS || overlays.len == nboverlays )
		return
	overlays.Cut()
	for(var/i=1, i < nboverlays, ++i)
		var/image/oreoverlay = image('icons/obj/materials/ore.dmi', icstate)
		oreoverlay.color = iccolor
		var/matrix/M = matrix()
		M.Translate(rand(-7, 7), rand(-8, 8))
		M.Turn(pick(-58, -45, -27.-5, 0, 0, 0, 0, 0, 27.5, 45, 58))
		oreoverlay.transform = M
		src.overlays += oreoverlay
	//TODO: Possibly make sprites for largers amounts leading up to the max, would look better really

/obj/item/stack/ore/stacks_can_merge(var/obj/item/stack/other)
	if(!istype(other, stacktype))
		return FALSE
	if(src.get_amount() < src.get_max_amount() && other.get_amount() < other.get_max_amount())
		var/obj/item/stack/ore/otherstack = other
		if(src.material && otherstack.get_material() && otherstack.get_material().name == src.material.name)
			return TRUE //Make sure we merge only with similar materials!!!
	return FALSE

//Called by parent stack class when spliting or creating a new stack of the same type as this one.
/obj/item/stack/ore/create_new(var/location, var/newamount)
	var/obj/item/stack/ore/newstack = new(location, material.name)
	if(newamount > newstack.amount ) //The stack begins with ore already
		newstack.add(newamount - newstack.amount)
	return newstack

// POCKET SAND!
/obj/item/stack/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

//-----------------------------------------
// Subtypes
//-----------------------------------------
/obj/item/stack/ore/uranium/New(var/newloc)
	..(newloc, MATERIAL_PITCHBLENDE)
/obj/item/stack/ore/iron/New(var/newloc)
	..(newloc, MATERIAL_HEMATITE)
/obj/item/stack/ore/graphite/New(var/newloc)
	..(newloc, MATERIAL_GRAPHITE)
/obj/item/stack/ore/glass/New(var/newloc)
	..(newloc, MATERIAL_SAND)
/obj/item/stack/ore/silver/New(var/newloc)
	..(newloc, MATERIAL_SILVER)
/obj/item/stack/ore/gold/New(var/newloc)
	..(newloc, MATERIAL_GOLD)
/obj/item/stack/ore/diamond/New(var/newloc)
	..(newloc, MATERIAL_DIAMOND)
/obj/item/stack/ore/osmium/New(var/newloc)
	..(newloc, MATERIAL_PLATINUM)
/obj/item/stack/ore/hydrogen/New(var/newloc)
	..(newloc, MATERIAL_HYDROGEN)
/obj/item/stack/ore/slag/New(var/newloc)
	..(newloc, MATERIAL_SLAG)
/obj/item/stack/ore/copper/New(var/newloc)
	..(newloc, MATERIAL_TETRAHEDRITE)
/obj/item/stack/ore/rutile/New(var/newloc)
	..(newloc, MATERIAL_RUTILE)

//-----------------------------------------
// Phoron-specific
//-----------------------------------------
/obj/item/stack/ore/phoron/New(var/newloc)
	..(newloc, MATERIAL_PHORON)

// Phoron ore is just as engaging!
/obj/item/stack/ore/phoron/pickup(mob/user)
	var/mob/living/carbon/human/H = user
	var/prot = 0
	if(istype(H))
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.permeability_coefficient)
				if(G.permeability_coefficient < 0.2)
					prot = 1
	else
		prot = 1

	if(prot > 0)
		return
	else
		H.phoronation += 1
		to_chat(user, "<span class='warning'>The phoron ore stings your hands as you pick it up.</span>")
		return

//-----------------------------------------
// Stackable Ices
//-----------------------------------------
/obj/item/stack/ore/ices
	name = "ices"
	stacktype = /obj/item/stack/ore/ices
	atom_flags = 0 //Wanna have those react
	temperature = 5 //k so all ices shouldn't melt immediately
	var/tmp/time_next_melt = 0 //Time at which one nugget might melt

/obj/item/stack/ore/ices/melt(user)
	//#TODO leave something behind
	return ..() 

//Handles melting ices - Disabled for now
// /obj/item/stack/ore/ices/ProcessAtomTemperature()
// 	if(..() == PROCESS_KILL || !material || amount <= 0)
// 		return PROCESS_KILL
	
// 	if(!time_next_melt && src.temperature > src.material.melting_point)
// 		time_next_melt = world.time + 5 SECONDS
// 	else if(src.temperature < src.material.melting_point)
// 		time_next_melt = 0
	
// 	if(world.time > time_next_melt && amount > 0)
// 		time_next_melt = 0
// 		use(1)
// 		if(!amount)
// 			spawn(1)
// 				src.melt()
// 			return PROCESS_KILL

//-----------------------------------------
// Subtypes
//-----------------------------------------
/obj/item/stack/ore/ices/water/New(var/newloc)
	..(newloc, MATERIAL_ICES_WATER)
/obj/item/stack/ore/ices/nitrogen/New(var/newloc)
	..(newloc, MATERIAL_ICES_NITROGEN)
/obj/item/stack/ore/ices/amonia/New(var/newloc)
	..(newloc, MATERIAL_ICES_AMONIA)
/obj/item/stack/ore/ices/hydrogen/New(var/newloc)
	..(newloc, MATERIAL_ICES_HYDROGEN)
/obj/item/stack/ore/ices/sulfur_dioxide/New(var/newloc)
	..(newloc, MATERIAL_ICES_SULFUR_DIOXIDE)
/obj/item/stack/ore/ices/carbon_dioxide/New(var/newloc)
	..(newloc, MATERIAL_ICES_CARBON_DIOXIDE)
/obj/item/stack/ore/ices/methane/New(var/newloc)
	..(newloc, MATERIAL_ICES_METHANE)
/obj/item/stack/ore/ices/acetone/New(var/newloc)
	..(newloc, MATERIAL_ICES_ACETONE)

#undef ORE_STACK_MAX_OVERLAYS
