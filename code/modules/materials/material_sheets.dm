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
	icon = 'icons/obj/materials.dmi'

	stacktype = /obj/item/stack/material

	var/default_type = MATERIAL_STEEL
	var/material/material
	var/default_reinf_type
	var/material/reinf_material
	var/material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
	var/plural_name
	var/matter_multiplier = 1

/obj/item/stack/material/New(loc, amount)
	. = ..()
	ADD_SAVED_VAR(material)
	ADD_SAVED_VAR(reinf_material)

/obj/item/stack/material/Initialize(mapload, var/amount, var/material, var/reinf_material)
	. = ..()
	//testing("Initialized [src] \ref[src], mapload=[mapload], amount=[amount], material=[src.material], reinf_material=[src.reinf_material]")
	if(!map_storage_loaded)
		if(material)
			src.default_type = material
		if(reinf_material)
			src.default_reinf_type = reinf_material
		if(amount > 0)
			src.amount = amount
	src.material = SSmaterials.get_material_by_name(src.default_type)
	if(!src.material)
		log_warning(" /obj/item/stack/material/Initialize() : Missing or invalid material type ([src.default_type])!")
		return INITIALIZE_HINT_QDEL
	if(src.default_reinf_type)
		src.reinf_material = SSmaterials.get_material_by_name(src.default_reinf_type)
		if(!src.reinf_material)
			log_warning(" /obj/item/stack/material/Initialize() : Missing or invalid reinf_material type([src.default_reinf_type])!")

	if(islist(src.material.stack_origin_tech))
		origin_tech = src.material.stack_origin_tech.Copy()

	if(src.material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)

	//testing("Initialized [src] \ref[src], [src.default_type] - ([src.material]), [src.default_reinf_type] - ([src.reinf_material])")
	update_strings()
	queue_icon_update()

/obj/item/stack/material/list_recipes(mob/user, recipes_sublist)
	if(!material)
		return
	recipes = material.get_recipes(reinf_material? reinf_material.name : null)
	..()

/obj/item/stack/material/get_codex_value()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.display_name)] (material)" : ..()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/update_strings()
	// Update from material datum.
	matter = material.get_matter()
	for(var/mat in matter)
		matter[mat] = round(matter[mat]*matter_multiplier*amount)
	if(reinf_material)
		var/list/rmatter = reinf_material.get_matter()
		for(var/mat in rmatter)
			rmatter[mat] = round(0.5*rmatter[mat]*matter_multiplier*amount)
			matter[mat] += rmatter[mat]

	if(material_flags & USE_MATERIAL_SINGULAR_NAME)
		singular_name = material.sheet_singular_name

	if(material_flags & USE_MATERIAL_PLURAL_NAME)
		plural_name = material.sheet_plural_name

	if(amount>1)
		SetName("[material.use_name] [plural_name]")
		desc = "A stack of [material.use_name] [plural_name]."
		gender = PLURAL
	else
		SetName("[material.use_name] [singular_name]")
		desc = "A [singular_name] of [material.use_name]."
		gender = NEUTER
	if(reinf_material)
		SetName("reinforced [name]")
		desc = "[desc]\nIt is reinforced with the [reinf_material.use_name] lattice."

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/proc/is_same(obj/item/stack/material/M)
	if((stacktype != M.stacktype))
		return FALSE
	if(matter_multiplier != M.matter_multiplier)
		return FALSE
	if(material.name != M.material.name)
		return FALSE
	if((reinf_material && reinf_material.name) != (M.reinf_material && M.reinf_material.name))
		return FALSE
	return TRUE

/obj/item/stack/material/transfer_to(obj/item/stack/material/M, var/tamount=null, var/type_verified)
	if(!is_same(M))
		return 0
	var/transfer = ..(M,tamount,1)
	if(!QDELETED(src))
		update_strings()
	if(!QDELETED(M))
		M.update_strings()
	return transfer

/obj/item/stack/material/copy_from(var/obj/item/stack/material/other)
	..()
	if(istype(other))
		material = other.material
		reinf_material = other.reinf_material
		update_strings()
		update_icon()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(isCoil(W))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/material))
		if(is_same(W))
			..()
		else if(!reinf_material)
			material.reinforce(user, W, src)
		return
	else if(reinf_material && reinf_material.stack_type && isWelder(W))
		var/obj/item/weapon/tool/weldingtool/WT = W
		if(WT.isOn() && WT.get_fuel() > 2 && use(2))
			WT.remove_fuel(2, user)
			to_chat(user,"<span class='notice'>You recover some [reinf_material.use_name] from the [src].</span>")
			reinf_material.place_sheet(get_turf(user), 1)
			return
	return ..()

/obj/item/stack/material/on_update_icon()
	if(!material)
		log_error("[src] has null material")
		return
	if(material_flags & USE_MATERIAL_COLOR)
		color = material.icon_colour
		alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

//--------------------------------
//	Generic
//--------------------------------
///obj/item/stack/material/generic
	// icon_state = "sheet"
	// plural_icon_state = "sheet-mult"
	// max_icon_state = "sheet-max"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	// if(material) color = material.icon_colour
	//This should make any existing stacks of generic material on the save turn into regular old material stacks
	if(material && loc)
		material.place_sheet(get_turf(src), amount)
	return INITIALIZE_HINT_QDEL

//--------------------------------
//	Iron
//--------------------------------
/obj/item/stack/material/iron
	name = MATERIAL_IRON
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_IRON

/obj/item/stack/material/iron/ten
	amount = 10

/obj/item/stack/material/iron/fifty
	amount = 50

//--------------------------------
//	Steel
//--------------------------------
/obj/item/stack/material/steel
	name = MATERIAL_STEEL
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
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
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
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
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
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
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
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
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	default_type = MATERIAL_COPPER

/obj/item/stack/material/copper/ten
	amount = 10

/obj/item/stack/material/copper/fifty
	amount = 50

//--------------------------------
//	Bronze
//--------------------------------
/obj/item/stack/material/bronze
	name = MATERIAL_BRONZE
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	default_type = MATERIAL_BRONZE

/obj/item/stack/material/bronze/ten
	amount = 10

/obj/item/stack/material/bronze/fifty
	amount = 50

//--------------------------------
//	Brass
//--------------------------------
/obj/item/stack/material/brass
	name = MATERIAL_BRASS
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	default_type = MATERIAL_BRASS

/obj/item/stack/material/brass/ten
	amount = 10

/obj/item/stack/material/brass/fifty
	amount = 50

//--------------------------------
//	Tin
//--------------------------------
/obj/item/stack/material/tin
	name = MATERIAL_TIN
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_TIN
/obj/item/stack/material/tin/ten
	amount = 10
/obj/item/stack/material/tin/fifty
	amount = 50

//--------------------------------
//	Zinc
//--------------------------------
/obj/item/stack/material/zinc
	name = MATERIAL_ZINC
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_ZINC
/obj/item/stack/material/zinc/ten
	amount = 10
/obj/item/stack/material/zinc/fifty
	amount = 50

//--------------------------------
//	Aluminum
//--------------------------------
/obj/item/stack/material/aluminium
	name = MATERIAL_ALUMINIUM
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	default_type = MATERIAL_ALUMINIUM

/obj/item/stack/material/aluminium/ten
	amount = 10

/obj/item/stack/material/aluminium/fifty
	amount = 50

//--------------------------------
//	Platinum
//--------------------------------
/obj/item/stack/material/platinum
	name = MATERIAL_PLATINUM
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
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
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_TUNGSTEN

/obj/item/stack/material/tungsten/ten
	amount = 10

/obj/item/stack/material/tungsten/fifty
	amount = 50

//--------------------------------
//	Lead
//--------------------------------
/obj/item/stack/material/lead
	name = MATERIAL_LEAD
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_LEAD

/obj/item/stack/material/lead/ten
	amount = 10

/obj/item/stack/material/lead/fifty
	amount = 50

//--------------------------------
//	Osmium
//--------------------------------
/obj/item/stack/material/osmium
	name = MATERIAL_OSMIUM
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	default_type = MATERIAL_OSMIUM

/obj/item/stack/material/osmium/ten
	amount = 10

//--------------------------------
//	Osmium Carbide
//--------------------------------
/obj/item/stack/material/ocp
	name = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	default_type = MATERIAL_OSMIUM_CARBIDE_PLASTEEL

/obj/item/stack/material/ocp/ten
	amount = 10

/obj/item/stack/material/ocp/fifty
	amount = 50

//--------------------------------
//	Titanium
//--------------------------------
/obj/item/stack/material/titanium
	name = MATERIAL_TITANIUM
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	default_type = MATERIAL_TITANIUM

/obj/item/stack/material/titanium/ten
	amount = 10

/obj/item/stack/material/titanium/fifty
	amount = 50

//--------------------------------
//	Stone
//--------------------------------
/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
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
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
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
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
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
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	default_type = MATERIAL_GRAPHITE

/obj/item/stack/material/carbon/ten
	amount = 10

/obj/item/stack/material/carbon/fifty
	amount = 50

//--------------------------------
//	Graphene
//--------------------------------
/obj/item/stack/material/graphene
	name = "graphene sheet"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	default_type = MATERIAL_GRAPHENE

/obj/item/stack/material/graphene/ten
	amount = 10

/obj/item/stack/material/graphene/fifty
	amount = 50

//--------------------------------
//	Diamond
//--------------------------------
/obj/item/stack/material/diamond
	name = MATERIAL_DIAMOND
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
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
	icon_state = "sheet-faery-uranium"
	plural_icon_state = "sheet-faery-uranium-mult"
	max_icon_state = "sheet-faery-uranium-max"
	default_type = MATERIAL_URANIUM
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

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
	plural_icon_state = "sheet-phoron-mult"
	max_icon_state = "sheet-phoron-max"
	default_type = MATERIAL_PHORON
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

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
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
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
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	default_type = MATERIAL_SULFUR

/obj/item/stack/material/sulfur/ten
	amount = 10

/obj/item/stack/material/sulfur/fifty
	amount = 50

//--------------------------------
//	Metallic Hydrogen
//--------------------------------
//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = MATERIAL_HYDROGEN
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

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
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	default_type = MATERIAL_TRITIUM

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
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	default_type = MATERIAL_DEUTERIUM

/obj/item/stack/material/deuterium/fifty
	amount = 50

//--------------------------------
//	Glass
//--------------------------------
/obj/item/stack/material/glass
	name = MATERIAL_GLASS
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	default_type = MATERIAL_GLASS

/obj/item/stack/material/glass/on_update_icon()
	if(reinf_material)
		icon_state = "sheet-glass-reinf"
		base_state = icon_state
		plural_icon_state = "sheet-glass-reinf-mult"
		max_icon_state = "sheet-glass-reinf-max"
	else
		icon_state = "sheet-clear"
		base_state = icon_state
		plural_icon_state = "sheet-clear-mult"
		max_icon_state = "sheet-clear-max"
	..()

/obj/item/stack/material/glass/ten
	amount = 10

/obj/item/stack/material/glass/fifty
	amount = 50

//--------------------------------
//	Reinforced Glass
//--------------------------------
/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-reinf"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	default_type = MATERIAL_GLASS
	default_reinf_type = MATERIAL_STEEL

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

//--------------------------------
//	Borosilicate Glass
//--------------------------------
/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
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
	default_type = MATERIAL_PHORON_GLASS
	default_reinf_type = MATERIAL_STEEL

/obj/item/stack/material/glass/phoronrglass/ten
	amount = 10

/obj/item/stack/material/glass/phoronrglass/fifty
	amount = 50

//--------------------------------
//	Fiberglass
//--------------------------------
/obj/item/stack/material/glass/fiberglass
	name = "fiberglass"
	default_type = MATERIAL_FIBERGLASS

/obj/item/stack/material/glass/fiberglass/ten
	amount = 10

/obj/item/stack/material/glass/fiberglass/fifty
	amount = 50

//--------------------------------
//	Quartz
//--------------------------------
/obj/item/stack/material/glass/quartz
	name = MATERIAL_QUARTZ
	default_type = MATERIAL_QUARTZ
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
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	default_type = MATERIAL_WOOD

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	default_type = MATERIAL_MAHOGANY

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	default_type = MATERIAL_MAPLE

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	default_type = MATERIAL_EBONY

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	default_type = MATERIAL_WALNUT

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	default_type = MATERIAL_BAMBOO

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

//--------------------------------
//	Cotton
//--------------------------------
/obj/item/stack/material/cotton
	name = MATERIAL_COTTON
	icon_state = "sheet-cloth"
	color = COLOR_WHITE
	default_type = MATERIAL_COTTON

/obj/item/stack/material/cotton/ten
	amount = 10

/obj/item/stack/material/cotton/fifty
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
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	default_type = MATERIAL_CARDBOARD
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

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
	material_flags = USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/leather/ten
	amount = 10

/obj/item/stack/material/leather/fifty
	amount = 50

/obj/item/stack/material/generic/Initialize()
	. = ..()
	if(material) color = material.icon_colour

//--------------------------------
//	Edible
//--------------------------------
//Edible materials!
/obj/item/stack/material/edible
	name = "edible"
	icon_state = "sheet-leather"
	default_type = "pinkgoo"

//--------------------------------
//	Pink Goo
//--------------------------------
/obj/item/stack/material/edible/pink_goo_slab
	name = MATERIAL_PINK_GOO
	desc = "A mix of meats, from various origins and species, grinded finely and pressed into thick meaty slabs.."
	singular_name = "pink goo slab"
	icon_state = "sheet-leather"
	default_type = MATERIAL_PINK_GOO

/obj/item/stack/material/edible/pink_goo_slab/ten
	amount = 10
/obj/item/stack/material/edible/pink_goo_slab/fifty
	amount = 50

//--------------------------------
//	Beeswax
//--------------------------------
/obj/item/stack/material/edible/beeswax
	name = MATERIAL_BEESWAX
	desc = "Soft substance produced by bees. Used to make candles mainly."
	singular_name = "piece"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "Wax"
	default_type = MATERIAL_BEESWAX

/obj/item/stack/material/edible/beeswax/ten
	amount = 10
/obj/item/stack/material/edible/beeswax/fifty
	amount = 50