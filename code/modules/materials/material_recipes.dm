//A little datum to help while generating recipes. Is discarded afterwards
//Basically all the lists correspond to a categorie that will be generated. Just add recipes you want in the correpsonding
//categorie in one of those list, and it'll be grouped with all the other recipes in that list in a sub-list.
/datum/material_recipes_helper
	var/tmp/list/items = list()
	var/tmp/list/weapons = list()
	var/tmp/list/structures = list()
	var/tmp/list/furnitures = list()
	var/tmp/list/storage = list()
	var/tmp/list/flooring = list()

/material
	var/tmp/datum/material_recipes_helper/recipes_buffer //Used to store data during recipe generation. Can be deleted afterwards

/material/proc/get_recipes(var/reinf_mat)
	var/key = reinf_mat ? reinf_mat : "base"
	if(!LAZYACCESS(recipes,key))
		var/list/generated_recipes = generate_recipes(reinf_mat)
		generated_recipes +=  finish_generate_recipes()
		LAZYSET(recipes,key,generated_recipes)
	return recipes[key]

/material/proc/create_recipe_list(base_type)
	. = list()
	for(var/recipe_type in subtypesof(base_type))
		. += new recipe_type(src)

/material/proc/generate_recipes(var/reinforce_material)
	. = list()
	//Make sure our recipe buffer is created, and clean
	recipes_buffer = new()

	if(opacity < 0.6)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/borderwindow(src, reinforce_material)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/fullwindow(src, reinforce_material)
		if(integrity > 75 || reinforce_material)
			recipes_buffer.structures += new/datum/stack_recipe/furniture/windoor(src, reinforce_material)

	if(reinforce_material)	//recipies below don't support composite materials
		return

	// If is_brittle() returns true, these are only good for a single strike.
	recipes_buffer.items += new/datum/stack_recipe/baseball_bat(src)
	recipes_buffer.items += new/datum/stack_recipe/ashtray(src)
	recipes_buffer.items += new/datum/stack_recipe/coin(src)
	recipes_buffer.items += new/datum/stack_recipe/spoon(src)
	recipes_buffer.items += new/datum/stack_recipe/ring(src)
	recipes_buffer.items += new/datum/stack_recipe/clipboard(src)

	if(integrity>50)
		recipes_buffer.furnitures += new/datum/stack_recipe/furniture/chair(src) //NOTE: the wood material has it's own special chair recipe
		. += new/datum/stack_recipe_list("padded [display_name] chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/padded))
	if(integrity>=50)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/door(src)
		recipes_buffer.furnitures += new/datum/stack_recipe/furniture/stool(src)
		recipes_buffer.furnitures += new/datum/stack_recipe/furniture/bar_stool(src)
		recipes_buffer.furnitures += new/datum/stack_recipe/furniture/bed(src)
		recipes_buffer.items += new/datum/stack_recipe/lock(src)
		recipes_buffer.items += new/datum/stack_recipe/rod(src)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/barricade(src)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/cheval(src)
		recipes_buffer.structures += new/datum/stack_recipe/railing(src)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/wall_frame(src)
		recipes_buffer.structures += new/datum/stack_recipe/furniture/girder(src)

	if(hardness>50)
		recipes_buffer.items += new/datum/stack_recipe/fork(src)
		recipes_buffer.items += new/datum/stack_recipe/knife(src)
		recipes_buffer.items += new/datum/stack_recipe/bell(src)
		recipes_buffer.items += new/datum/stack_recipe/blade(src)

//Run this after adding recipes to existing categories
/material/proc/finish_generate_recipes()
	if(!recipes_buffer)
		log_warning("[src]\ref[src] tried to add categories without a recipe buffer initialized!")
		return
	. = list()
	//Add our categories
	if(LAZYLEN(recipes_buffer.furnitures))
		. +=  new/datum/stack_recipe_list("Furnitures", recipes_buffer.furnitures.Copy())
	if(LAZYLEN(recipes_buffer.items))
		. += new/datum/stack_recipe_list("Items", recipes_buffer.items.Copy())
	if(LAZYLEN(recipes_buffer.storage))
		. += new/datum/stack_recipe_list("Storage", recipes_buffer.storage.Copy())
	if(LAZYLEN(recipes_buffer.structures))
		. += new/datum/stack_recipe_list("Structures", recipes_buffer.structures.Copy())
	if(LAZYLEN(recipes_buffer.weapons))
		. += new/datum/stack_recipe_list("Weapons", recipes_buffer.weapons.Copy())
	if(LAZYLEN(recipes_buffer.flooring))
		. += new/datum/stack_recipe_list("Flooring", recipes_buffer.flooring.Copy())

	//Clean up
	qdel(recipes_buffer)
	recipes_buffer = null

/material/steel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return

	. += new/datum/stack_recipe_list("Airlock assemblies", create_recipe_list(/datum/stack_recipe/furniture/door_assembly))
	. += new/datum/stack_recipe_list("comfy office chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/office/comfy))
	. += new/datum/stack_recipe_list("comfy chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/comfy))
	. += new/datum/stack_recipe_list("armchairs", create_recipe_list(/datum/stack_recipe/furniture/chair/arm))
	. += new/datum/stack_recipe_list("office chairs",list(
				new/datum/stack_recipe/furniture/chair/office/dark(src),
				new/datum/stack_recipe/furniture/chair/office/light(src),
			))

	recipes_buffer.flooring += create_recipe_list(/datum/stack_recipe/tile/metal)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/table_frame(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/structure/weight_lifter(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/structure/meat_spike(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/iv_drip(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/rollerbed(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/wheelchair(src)

	. += new/datum/stack_recipe_list("Machinery", list(
			new/datum/stack_recipe/furniture/machine(src),
			new/datum/stack_recipe/furniture/computerframe(src),
			new/datum/stack_recipe/furniture/turret(src),
			new/datum/stack_recipe/computer/console(src),
			new/datum/stack_recipe/computer/telescreen(src),
			new/datum/stack_recipe/computer/laptop(src),
			new/datum/stack_recipe/computer/tablet(src),
			new/datum/stack_recipe/structure/conveyorbelt_assembly(src),
			new/datum/stack_recipe/structure/conveyorbelt_switch(src),
			new/datum/stack_recipe/machinery/paper_shredder(src),
		))

	. += new/datum/stack_recipe_list("Plumbing", list(
			new/datum/stack_recipe/toilet(src),
			new/datum/stack_recipe/shower(src),
			new/datum/stack_recipe/urinal(src),
			new/datum/stack_recipe/sink(src),
			new/datum/stack_recipe/sink/kitchen(src),
			new/datum/stack_recipe/structure/drain(src),
		))

	recipes_buffer.storage += new/datum/stack_recipe/furniture/canister(src)
	recipes_buffer.storage += new/datum/stack_recipe/furniture/rack(src)
	recipes_buffer.storage += new/datum/stack_recipe/furniture/closet(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/filing_cabinet(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/chest_drawer(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/trash_bin(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/item_safe(src)
	recipes_buffer.storage += new/datum/stack_recipe/furniture/coffin(src)
	recipes_buffer.storage += new/datum/stack_recipe/morgue(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/tank_dispenser(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/reagents/watertank(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/reagents/fueltank(src)


	recipes_buffer.structures += new/datum/stack_recipe/stairs(src)
	recipes_buffer.structures += new/datum/stack_recipe/ladder(src)
	recipes_buffer.structures += new/datum/stack_recipe/handrail(src)

	. += new/datum/stack_recipe_list("Wall-Mounted Frames", list(
			new/datum/stack_recipe/light_switch(src),
			new/datum/stack_recipe/light_small(src),
			new/datum/stack_recipe/light(src),
			new/datum/stack_recipe/apc(src),
			new/datum/stack_recipe/air_alarm(src),
			new/datum/stack_recipe/fire_alarm(src),
			new/datum/stack_recipe/storage/wall_safe_frame(src),
			new/datum/stack_recipe/button(src),
			new/datum/stack_recipe/button/door(src),
			new/datum/stack_recipe/button/toggle(src),
			new/datum/stack_recipe/button/toggle/door(src),
			new/datum/stack_recipe/button/toggle/lever(src),
			new/datum/stack_recipe/button/toggle/lever/double(src),
		))

	recipes_buffer.items += new/datum/stack_recipe/key(src)
	recipes_buffer.items += new/datum/stack_recipe/grenade(src)
	recipes_buffer.weapons += new/datum/stack_recipe/cannon(src)


/material/plasteel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.structures += new/datum/stack_recipe/ai_core(src)
	recipes_buffer.storage += new/datum/stack_recipe/furniture/crate(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/anomaly_container(src)
	recipes_buffer.weapons += new/datum/stack_recipe/grip(src)

/material/stone/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.structures |= new/datum/stack_recipe/furniture/planting_bed(src)
	recipes_buffer.structures |= new/datum/stack_recipe/fountain(src)

/material/plastic/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.storage += new/datum/stack_recipe/furniture/crate/plastic(src)

	recipes_buffer.items += new/datum/stack_recipe/wetfloor_sign(src)
	recipes_buffer.items += new/datum/stack_recipe/hazard_cone(src)
	recipes_buffer.items += new/datum/stack_recipe/bag(src)
	recipes_buffer.items += new/datum/stack_recipe/ivbag(src)
	recipes_buffer.items += new/datum/stack_recipe/hair_comb(src)
	recipes_buffer.items += create_recipe_list(/datum/stack_recipe/cartridge)

	recipes_buffer.structures += new/datum/stack_recipe/furniture/flaps(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/mopbucket(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/punching_bag(src)

	. += new/datum/stack_recipe_list("Target dummies", create_recipe_list(/datum/stack_recipe/target))

/material/wood/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.flooring += new/datum/stack_recipe/tile/wood(src)

	recipes_buffer.weapons += new/datum/stack_recipe/crossbowframe(src)
	recipes_buffer.weapons += new/datum/stack_recipe/zipgunframe(src)
	recipes_buffer.weapons += new/datum/stack_recipe/coilgun(src)
	recipes_buffer.weapons += new/datum/stack_recipe/rifle_frame(src)
	recipes_buffer.weapons += new/datum/stack_recipe/shield/buckler(src)

	recipes_buffer.furnitures += create_recipe_list(/datum/stack_recipe/furniture/chair/wood)
	recipes_buffer.furnitures += new/datum/stack_recipe/beehive_assembly(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/bookcase(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/noticeboard(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/bed/psychiatrist(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/cabinet(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/dog_bed(src)

	recipes_buffer.items += new/datum/stack_recipe/beehive_frame(src)
	recipes_buffer.items += new/datum/stack_recipe/stick(src)
	recipes_buffer.items += new/datum/stack_recipe/sandals(src)
	recipes_buffer.items += new/datum/stack_recipe/gavel/hammer(src)
	recipes_buffer.items += new/datum/stack_recipe/gavel/block(src)

	recipes_buffer.storage += new/datum/stack_recipe/furniture/coffin/wooden(src)
	recipes_buffer.storage += new/datum/stack_recipe/orebox(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/shipping_crate(src)

/material/wood/mahogany/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.flooring += new/datum/stack_recipe/tile/mahogany(src)

/material/wood/maple/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.flooring += new/datum/stack_recipe/tile/maple(src)

/material/wood/ebony/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.flooring += new/datum/stack_recipe/tile/ebony(src)

/material/wood/walnut/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.flooring += new/datum/stack_recipe/tile/walnut(src)

/material/cardboard/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.items += new/datum/stack_recipe/cardborg_suit(src)
	recipes_buffer.items += new/datum/stack_recipe/cardborg_helmet(src)
	. += new/datum/stack_recipe_list("boxes", create_recipe_list(/datum/stack_recipe/box))
	. += new/datum/stack_recipe_list("folders", create_recipe_list(/datum/stack_recipe/folder))

/material/aluminium/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipies below don't support composite materials
		return
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/table_frame(src)
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/water_cooler(src)

	recipes_buffer.storage += new/datum/stack_recipe/storage/wall(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/wall/aid(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/wall/fire(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/wall/cargo(src)
	recipes_buffer.storage += new/datum/stack_recipe/storage/wall/extinguisher_cabinet(src)

	recipes_buffer.items += new/datum/stack_recipe/grenade(src)

/material/silver/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.furnitures += new/datum/stack_recipe/furniture/mirror(src)

/material/cloth/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	recipes_buffer.items += new/datum/stack_recipe/bandage(src)

/material/beeswax/generate_recipes(reinforce_material)
	. = ..()
	recipes_buffer.items += new/datum/stack_recipe/candle(src)
