
///obj/item/weapon/ore
//	name = "ore"
//	icon_state = "lump"
//	icon = 'icons/obj/materials/ore.dmi'
//	randpixel = 8
//	w_class = 2
//	var/material/material
//	var/datum/geosample/geologic_data

/obj/item/weapon/ore/after_load() //Remove me after first save reload!
	var/obj/item/stack/ore/newore = new()
	newore.drop_to_stacks(loc)
	qdel(src)

/obj/item/stack/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = 2

	//stack
	amount = 1
	max_amount = 250

	var/material/material
	var/datum/geosample/geologic_data

/obj/item/stack/ore/attack_generic()
	qdel(src) // eaten
/obj/item/stack/ore/get_material()
	return material

/obj/item/stack/ore/after_load()
	for(var/stuff in matter)
		var/material/M = SSmaterials.get_material_by_name(stuff)
		if(M)
			name = M.ore_name
			desc = M.ore_desc ? M.ore_desc : "A lump of ore."
			material = M
			color = M.icon_colour
			icon_state = M.ore_icon_overlay
			if(M.ore_desc)
				desc = M.ore_desc
			if(icon_state == "dust")
				slot_flags = SLOT_HOLSTER
			break
	. = ..()


/obj/item/stack/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/stack/ore/New(var/newloc, var/_mat)
	if(_mat)
		matter = list()
		matter[_mat] = SHEET_MATERIAL_AMOUNT
	..(newloc)

/obj/item/stack/ore/Initialize()

// POCKET SAND!
/obj/item/stack/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			H.eye_blind += 5
			H.eye_blurry += 10
			spawn(1)
				if(istype(loc, /turf/)) qdel(src)

// Map definitions.
/obj/item/stack/ore/uranium/New(var/newloc)
	..(newloc, "pitchblende")
/obj/item/stack/ore/iron/New(var/newloc)
	..(newloc, "hematite")
/obj/item/stack/ore/coal/New(var/newloc)
	..(newloc, "graphene")
/obj/item/stack/ore/glass/New(var/newloc)
	..(newloc, "sand")
/obj/item/stack/ore/silver/New(var/newloc)
	..(newloc, "silver")
/obj/item/stack/ore/gold/New(var/newloc)
	..(newloc, "gold")
/obj/item/stack/ore/diamond/New(var/newloc)
	..(newloc, "diamond")
/obj/item/stack/ore/osmium/New(var/newloc)
	..(newloc, "platinum")
/obj/item/stack/ore/hydrogen/New(var/newloc)
	..(newloc, "mhydrogen")
/obj/item/stack/ore/slag/New(var/newloc)
	..(newloc, "waste")
/obj/item/stack/ore/phoron/New(var/newloc)
	..(newloc, "phoron")

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