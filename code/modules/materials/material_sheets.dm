//------------------------------------
//	Material stacks
//------------------------------------
// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEM_SIZE_LARGE
	throw_speed = 3
	throw_range = 3
	max_amount = 60
	randpixel = 3

	var/default_type = MATERIAL_STEEL
	var/material/material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite

/obj/item/stack/material/New(var/loc, var/amount, var/_material)
	if(_material)
		default_type = _material
	if(!default_type)
		default_type = MATERIAL_STEEL
	..()

/obj/item/stack/material/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name("[default_type]")
	if(!material)
		return INITIALIZE_HINT_QDEL

	recipes = material.get_recipes()
	stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(apply_colour)
		color = material.icon_colour

	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)

	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	matter = material.get_matter()
	for(var/mat in matter)
		matter[mat] *= amount

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A stack of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(isCoil(W))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

//--------------------------------
//	Generic
//--------------------------------
/obj/item/stack/material/generic
	icon_state = "sheet-silver"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	if(material) color = material.icon_colour

//--------------------------------
//	Iron
//--------------------------------
/obj/item/stack/material/iron
	name = MATERIAL_IRON
	icon_state = "sheet-silver"
	default_type = MATERIAL_IRON
	apply_colour = 1

/obj/item/stack/material/iron/ten
	amount = 10

/obj/item/stack/material/iron/fifty
	amount = 50

//--------------------------------
//	Steel
//--------------------------------
/obj/item/stack/material/steel
	name = MATERIAL_STEEL
	icon_state = "sheet-metal"
	default_type = MATERIAL_STEEL

/obj/item/stack/material/steel/ten
	amount = 10

/obj/item/stack/material/steel/fifty
	amount = 50

//--------------------------------
//	Plasteel
//--------------------------------
/obj/item/stack/material/plasteel
	name = MATERIAL_PLASTEEL
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = MATERIAL_PLASTEEL

/obj/item/stack/material/plasteel/ten
	amount = 10

/obj/item/stack/material/plasteel/fifty
	amount = 50

//--------------------------------
//	Gold
//--------------------------------
/obj/item/stack/material/gold
	name = MATERIAL_GOLD
	icon_state = "sheet-gold"
	default_type = MATERIAL_GOLD

/obj/item/stack/material/gold/ten
	amount = 10

/obj/item/stack/material/gold/fifty
	amount = 50

//--------------------------------
//	Silver
//--------------------------------
/obj/item/stack/material/silver
	name = MATERIAL_SILVER
	icon_state = "sheet-silver"
	default_type = MATERIAL_SILVER

/obj/item/stack/material/silver/ten
	amount = 10

/obj/item/stack/material/silver/fifty
	amount = 50

//--------------------------------
//	Copper
//--------------------------------
/obj/item/stack/material/copper
	name = MATERIAL_COPPER
	icon_state = "sheet-silver"
	default_type = MATERIAL_COPPER
	apply_colour = 1

/obj/item/stack/material/copper/ten
	amount = 10

/obj/item/stack/material/copper/fifty
	amount = 50

//--------------------------------
//	Bronze
//--------------------------------
/obj/item/stack/material/bronze
	name = MATERIAL_BRONZE
	icon_state = "sheet-silver"
	default_type = MATERIAL_BRONZE
	apply_colour = 1

/obj/item/stack/material/bronze/ten
	amount = 10

/obj/item/stack/material/bronze/fifty
	amount = 50

//--------------------------------
//	Brass
//--------------------------------
/obj/item/stack/material/brass
	name = MATERIAL_BRASS
	icon_state = "sheet-silver"
	default_type = MATERIAL_BRASS
	apply_colour = 1

/obj/item/stack/material/brass/ten
	amount = 10

/obj/item/stack/material/brass/fifty
	amount = 50

//--------------------------------
//	Tin
//--------------------------------
/obj/item/stack/material/tin
	name = MATERIAL_TIN
	icon_state = "sheet-silver"
	default_type = MATERIAL_TIN
	apply_colour = 1
/obj/item/stack/material/tin/ten
	amount = 10
/obj/item/stack/material/tin/fifty
	amount = 50

//--------------------------------
//	Zinc
//--------------------------------
/obj/item/stack/material/zinc
	name = MATERIAL_ZINC
	icon_state = "sheet-silver"
	default_type = MATERIAL_ZINC
	apply_colour = 1
/obj/item/stack/material/zinc/ten
	amount = 10
/obj/item/stack/material/zinc/fifty
	amount = 50

//--------------------------------
//	Aluminum
//--------------------------------
/obj/item/stack/material/aluminum
	name = MATERIAL_ALUMINUM
	icon_state = "sheet-silver"
	default_type = MATERIAL_ALUMINUM
	apply_colour = 1

/obj/item/stack/material/aluminum/ten
	amount = 10

/obj/item/stack/material/aluminum/fifty
	amount = 50

//--------------------------------
//	Platinum
//--------------------------------
/obj/item/stack/material/platinum
	name = MATERIAL_PLATINUM
	icon_state = "sheet-adamantine"
	default_type = MATERIAL_PLATINUM

/obj/item/stack/material/platinum/ten
	amount = 10

/obj/item/stack/material/platinum/fifty
	amount = 50

//--------------------------------
//	Tungsten
//--------------------------------
/obj/item/stack/material/tungsten
	name = MATERIAL_TUNGSTEN
	icon_state = "sheet-silver"
	default_type = MATERIAL_TUNGSTEN
	apply_colour = 1

/obj/item/stack/material/tungsten/ten
	amount = 10

/obj/item/stack/material/tungsten/fifty
	amount = 50

//--------------------------------
//	Lead
//--------------------------------
/obj/item/stack/material/lead
	name = MATERIAL_LEAD
	icon_state = "sheet-silver"
	default_type = MATERIAL_LEAD
	apply_colour = 1

/obj/item/stack/material/lead/ten
	amount = 10

/obj/item/stack/material/lead/fifty
	amount = 50

//--------------------------------
//	Osmium
//--------------------------------
/obj/item/stack/material/osmium
	name = MATERIAL_OSMIUM
	icon_state = "sheet-silver"
	default_type = MATERIAL_OSMIUM
	apply_colour = 1

/obj/item/stack/material/osmium/ten
	amount = 10

//--------------------------------
//	Osmium Carbide
//--------------------------------
/obj/item/stack/material/ocp
	name = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	apply_colour = 1

/obj/item/stack/material/ocp/ten
	amount = 10

/obj/item/stack/material/ocp/fifty
	amount = 50

//--------------------------------
//	Titanium
//--------------------------------
/obj/item/stack/material/titanium
	name = MATERIAL_TITANIUM
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = MATERIAL_TITANIUM
	apply_colour = 1

/obj/item/stack/material/titanium/ten
	amount = 10

/obj/item/stack/material/titanium/fifty
	amount = 50

//--------------------------------
//	Stone
//--------------------------------
/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type = MATERIAL_SANDSTONE

/obj/item/stack/material/sandstone/ten
	amount = 10

/obj/item/stack/material/sandstone/fifty
	amount = 50

//--------------------------------
//	Marble
//--------------------------------
/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type = MATERIAL_MARBLE

/obj/item/stack/material/marble/ten
	amount = 10

/obj/item/stack/material/marble/fifty
	amount = 50

//--------------------------------
//	Salt
//--------------------------------
/obj/item/stack/material/salt
	name = "salt brick"
	icon_state = "sheet-marble"
	default_type = MATERIAL_ROCK_SALT

/obj/item/stack/material/salt/ten
	amount = 10

/obj/item/stack/material/salt/fifty
	amount = 50

//--------------------------------
//	Carbon
//--------------------------------
/obj/item/stack/material/carbon
	name = "graphite brick"
	icon_state = "sheet-marble"
	default_type = MATERIAL_GRAPHITE
	apply_colour = 1

/obj/item/stack/material/carbon/ten
	amount = 10

/obj/item/stack/material/carbon/fifty
	amount = 50

//--------------------------------
//	Diamond
//--------------------------------
/obj/item/stack/material/diamond
	name = MATERIAL_DIAMOND
	icon_state = "sheet-diamond"
	default_type = MATERIAL_DIAMOND

/obj/item/stack/material/diamond/ten
	amount = 10

/obj/item/stack/material/diamond/fifty
	amount = 50

//--------------------------------
//	Uranium
//--------------------------------
/obj/item/stack/material/uranium
	name = MATERIAL_URANIUM
	icon_state = "sheet-uranium"
	default_type = MATERIAL_URANIUM

/obj/item/stack/material/uranium/ten
	amount = 10

/obj/item/stack/material/uranium/fifty
	amount = 50

//--------------------------------
//	Phoron
//--------------------------------
/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = MATERIAL_PHORON


// Lay the groundwork for an engaging phoron experience
/obj/item/stack/material/phoron/pickup(mob/user)
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
		H.phoronation += 2
		to_chat(user, "<span class='warning'>The phoron crystal stings your hands as you pick it up.</span>")
		return

/obj/item/stack/material/phoron/ten
	amount = 10

/obj/item/stack/material/phoron/fifty
	amount = 50

//--------------------------------
//	Plastic
//--------------------------------
/obj/item/stack/material/plastic
	name = MATERIAL_PLASTIC
	icon_state = "sheet-plastic"
	default_type = MATERIAL_PLASTIC

/obj/item/stack/material/plastic/ten
	amount = 10

/obj/item/stack/material/plastic/fifty
	amount = 50

//--------------------------------
//	Sulfur
//--------------------------------
/obj/item/stack/material/sulfur
	name = MATERIAL_SULFUR
	icon_state = "sheet-marble"
	default_type = MATERIAL_SULFUR
	apply_colour = 1

/obj/item/stack/material/sulfur/ten
	amount = 10

/obj/item/stack/material/sulfur/fifty
	amount = 50
/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-silver"
	default_type = "lead"
	apply_colour = 1

/obj/item/stack/material/lead/ten
	amount = 10

//--------------------------------
//	Metallic Hydrogen
//--------------------------------
//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = MATERIAL_HYDROGEN

/obj/item/stack/material/mhydrogen/ten
	amount = 10

/obj/item/stack/material/mhydrogen/fifty
	amount = 50

//--------------------------------
//	Tritium
//--------------------------------
//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = MATERIAL_TRITIUM
	icon_state = "sheet-silver"
	default_type = MATERIAL_TRITIUM
	apply_colour = 1

/obj/item/stack/material/tritium/ten
	amount = 10

/obj/item/stack/material/tritium/fifty
	amount = 50

//--------------------------------
//	Deuterium
//--------------------------------
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = MATERIAL_DEUTERIUM
	icon_state = "sheet-silver"
	default_type = MATERIAL_DEUTERIUM
	apply_colour = 1

/obj/item/stack/material/deuterium/fifty
	amount = 50

//--------------------------------
//	Glass
//--------------------------------
/obj/item/stack/material/glass
	name = MATERIAL_GLASS
	icon_state = "sheet-glass"
	default_type = MATERIAL_GLASS

/obj/item/stack/material/glass/ten
	amount = 10

/obj/item/stack/material/glass/fifty
	amount = 50

//--------------------------------
//	Reinforced Glass
//--------------------------------
/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type = MATERIAL_REINFORCED_GLASS

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

//--------------------------------
//	Borosilicate Glass
//--------------------------------
/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures."
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	default_type = MATERIAL_PHORON_GLASS

/obj/item/stack/material/glass/phoronglass/ten
	amount = 10

/obj/item/stack/material/glass/phoronglass/fifty
	amount = 50

//--------------------------------
//	Reinforced Borosilicate Glass
//--------------------------------
/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	default_type = MATERIAL_REINFORCED_PHORON_GLASS

/obj/item/stack/material/glass/phoronrglass/ten
	amount = 10

/obj/item/stack/material/glass/phoronrglass/fifty
	amount = 50

//--------------------------------
//	Fiberglass
//--------------------------------
/obj/item/stack/material/glass/fiberglass
	name = "fiberglass"
	icon_state = "sheet-fiberglass"
	default_type = "fiberglass"

/obj/item/stack/material/glass/fiberglass/ten
	amount = 10

/obj/item/stack/material/glass/fiberglass/fifty
	amount = 50

//--------------------------------
//	Quartz
//--------------------------------
/obj/item/stack/material/glass/quartz
	name = MATERIAL_QUARTZ
	icon_state = "sheet-glass"
	default_type = MATERIAL_QUARTZ
	apply_colour = 1

/obj/item/stack/material/glass/quartz/ten
	amount = 10

/obj/item/stack/material/glass/quartz/fifty
	amount = 50

//--------------------------------
//	Wood
//--------------------------------
/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

//--------------------------------
//	Cloth
//--------------------------------
/obj/item/stack/material/cloth
	name = MATERIAL_CLOTH
	icon_state = "sheet-cloth"
	default_type = MATERIAL_CLOTH

/obj/item/stack/material/cloth/ten
	amount = 10

/obj/item/stack/material/cloth/fifty
	amount = 50

//--------------------------------
//	Cardboard
//--------------------------------
/obj/item/stack/material/cardboard
	name = MATERIAL_CARDBOARD
	icon_state = "sheet-card"
	default_type = MATERIAL_CARDBOARD

/obj/item/stack/material/cardboard/ten
	amount = 10

/obj/item/stack/material/cardboard/fifty
	amount = 50

//--------------------------------
//	Leather
//--------------------------------
/obj/item/stack/material/leather
	name = MATERIAL_LEATHER
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	default_type = MATERIAL_LEATHER

/obj/item/stack/material/leather/ten
	amount = 10

/obj/item/stack/material/leather/fifty
	amount = 50