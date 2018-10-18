//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.

//Supply packs are in /code/defines/obj/supplypacks.dm
//Computers are in /code/game/machinery/computer/supply.dm

var/datum/controller/supply/supply_controller = new()

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/gygax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)


var/list/valid_phoron_designs = list(
	/datum/design/item/stock_part/super_capacitor,
	/datum/design/item/stock_part/adv_capacitor,
	/datum/design/item/stock_part/super_capacitor,
	/datum/design/item/stock_part/nano_mani,
	/datum/design/item/stock_part/pico_mani,
	/datum/design/item/stock_part/adv_matter_bin,
	/datum/design/item/stock_part/super_matter_bin,
	/datum/design/item/stock_part/high_micro_laser,
	/datum/design/item/stock_part/ultra_micro_laser,
	/datum/design/item/stock_part/adv_sensor,
	/datum/design/item/stock_part/phasic_sensor,
	/datum/design/item/stock_part/RPED,
	/datum/design/item/powercell/super,
	/datum/design/item/powercell/hyper,
	/datum/design/item/beaker/noreact,
	/datum/design/item/beaker/bluespace,
	/datum/design/item/scalpel_manager,
	/datum/design/item/modularcomponent/logistic_processor,
	/datum/design/item/jetpack
)

/obj/item/weapon/paper/manifest
	name = "supply manifest"
	var/is_copy = 1
	icon_state = "paper_words"



/obj/item/weapon/paper/export
	name = "export manifest"
	var/is_copy = 1
	var/export_id = 0
	icon_state = "paper_words"
	var/business_name = 0

/obj/item/weapon/paper/export/business
	name = "export manifest"
	business_name = null

/obj/item/weapon/paper/export/business/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	info2 += "LINKED BUSINESS: [business_name]<br>"
	if(src.Adjacent(user))
		info2 += "<br>Swipe business name-tag <A href='?src=\ref[src];connect=1'>or enter full business name here.</A>"
	else
		info2 += "<br>Swipe business name-tag or enter full business name here."
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")


/obj/item/weapon/paper/export/business/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	else if(istype(P, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/id = P
		if(id.selected_business)
			var/datum/small_business/business = get_business(id.selected_business)
			if(business)
				business_name = business.name
				to_chat(user, "Business linked to export.")
		return
	..()
/obj/item/weapon/paper/export/business/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["connect"])
		var/select_name = input(usr,"Enter the full name of the business.","Connect Business", "") as null|text
		var/datum/small_business/viewing = get_business(select_name)
		if(viewing && src.Adjacent(usr))
			business_name = viewing.name
			to_chat(usr, "Business linked to export.")

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
	var/paidby = null
	var/last_print = 0
var/list/point_source_descriptions = list(
	"time" = "Base station supply",
	"manifest" = "From exported manifests",
	"crate" = "From exported crates",
	"phoron" = "From exported phoron",
	"platinum" = "From exported platinum",
	"virology" = "From uploaded antibody data",
	"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

//Adds the points from different sources together and saves them for the export overview
/datum/controller/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

/datum/export_order
	var/name = "" // summary of the order, should be set on runtime
	var/required = 0 // how many items the order will take
	var/supplied = 0
	var/id = 0
	var/typepath // should be the typepath of the item we're looking for..
	var/parent_typepath
	var/looking_name = ""
	var/rate = 0
	var/order_type = ""

/datum/export_order/proc/fill(var/obj/structure/closet/crate)
	var/filled = 0
	var/overfilled = 0
	var/list/filling = list()
	for(var/obj/A in crate.contents)
		if(istype(A, /obj/item/weapon/paper/export))
			filling |= A
			continue
		if(!istype(A, typepath) && (A.name != looking_name || !istype(A, parent_typepath)))
			message_admins("fill failed due to invalid object [A.name]")
			return 0
		if(filled >= (required - supplied))
			overfilled = 1
		else
			filling |= A
			filled++
	if(overfilled)
		for(var/atom/movable/A in crate.contents)
			if(A in filling)
				continue
			A.loc = crate.loc
	if(filled)
		crate.loc = null
		playsound(crate.loc,'sound/effects/teleport.ogg',40,1)
		qdel(crate)
		supplied += filled
		. = filled*rate
		spawn(10)
			if(supplied >= required)
				supply_controller.close_order(src)


/obj/var/export_value = 10

/datum/export_order/static

/datum/export_order/static/fill(var/obj/structure/closet/crate)
	var/filled = 0
	var/total = 0
	var/list/filling = list()
	for(var/obj/A in crate.contents)
		if(istype(A, /obj/item/weapon/paper/export))
			filling |= A
			continue
		if(!istype(A, typepath) && A.name != looking_name)
			message_admins("fill failed due to invalid object [A.name]")
			return 0
		filling |= A
		total += A.export_value
		filled++

	if(filled)
		crate.loc = null
		playsound(crate.loc,'sound/effects/teleport.ogg',40,1)
		qdel(crate)
		. = total





/datum/export_order/stack

/datum/export_order/stack/fill(var/obj/structure/closet/crate)
	if(!crate)
		return 0
	var/filled = 0
	var/overfilled = 0
	var/list/filling = list()
	for(var/obj/A in crate.contents)
		if(istype(A, /obj/item/weapon/paper/export))
			filling |= A
			continue
		if(!istype(A, typepath) && A.name != looking_name)
			return 0
		var/obj/item/stack/stack = A
		var/max = (required - (supplied+filled))
		if(max < stack.amount)
			stack.amount -= max
			filled += max
		else
			filled += stack.amount
		if(filled >= (required - supplied))
			overfilled = 1
		else
			filling |= A
			filled++
	if(overfilled)
		for(var/atom/movable/A in crate.contents)
			if(A in filling)
				continue
			A.loc = crate.loc
	if(filled)
		crate.loc = null
		playsound(crate.loc,'sound/effects/teleport.ogg',40,1)
		qdel(crate)
		supplied += filled
		. = filled*rate
		spawn(10)
			if(supplied >= required)
				supply_controller.close_order(src)
/datum/controller/supply
	//supply points
	var/points = 50
	var/points_per_process = 1.5
	var/points_per_slip = 2
	var/points_per_platinum = 5 // 5 points per sheet
	var/points_per_phoron = 5
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle

	var/exportnum = 0
	var/list/all_exports = list()
	var/list/old_exports = list()
/datum/controller/supply/New()
	ordernum = rand(1,9000)

	//Build master supply list
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				master_supply_list += spc


	// Supply shuttle ticker - handles supply point regeneration
	// This is called by the process scheduler every thirty seconds

/datum/controller/supply/proc/generate_initial()
	generate_export("manufacturing-basic")
	generate_export("manufacturing-advanced")
	generate_export("manufacturing-phoron")
	generate_export("manufacturing-phoron")
	generate_export("phoron")
	generate_export("bluespace crystal")
	generate_export("xenobiology")
	generate_export("cooking")
/datum/controller/supply/proc/close_order(var/datum/export_order/export)
	var/order_type = export.order_type
	old_exports |= export
	all_exports -= export
	sleep(rand(25 MINUTES, 35 MINUTES))
	generate_export(order_type)


/datum/controller/supply/proc/get_export_name(var/id)
	for(var/datum/export_order/export in all_exports)
		if(export.id == id)
			return export.name
	return "None"

/datum/controller/supply/proc/fill_order(var/id, var/closet)
	for(var/datum/export_order/export in all_exports)
		if(export.id == id)
			return export.fill(closet)
	return 0
/datum/controller/supply/proc/generate_export(var/typee = "")
	exportnum++
	var/datum/export_order/export
	switch(typee)
		if("manufacturing-basic")
			var/datum/autolathe/recipe/recipe = pick(autolathe_recipes)
			var/per = rand(5,10)
			if(recipe.is_stack)
				export = new /datum/export_order/stack()
				export.required = rand(50,150)
			else
				export = new()
				export.required = rand(30, 50)
			for(var/x in recipe.resources)
				if(!x)
					to_world("[recipe] had a blank resource")
					continue
				var/material/mat = SSmaterials.get_material_by_name(x)
				if(mat)
					per += round(mat.value*recipe.resources[x]/2000,0.01)
			export.typepath = recipe.path
			export.rate = per
			export.order_type = typee
			export.id = exportnum
			var/obj/ob = new recipe.path()
			export.parent_typepath = ob.parent_type
			export.looking_name = ob.name
			export.name = recipe.is_stack ? "Order for [export.required] [ob.name]\s at [export.rate] for each unit." : "Order for [export.required] [ob.name]\s at [export.rate] for each item."
			all_exports |= export
			return export
		if("manufacturing-advanced")
			export = new()
			var/list/possible_designs = list()
			for(var/D in subtypesof(/datum/design))
				possible_designs += new D(src)
			if(!possible_designs.len)
				return
			var/datum/design/design = pick(possible_designs)
			var/valid = 0
			var/per = rand(10,20)
			while(!valid)
				if(TECH_ILLEGAL in design.req_tech)
					design = pick(possible_designs)
				else
					var/restart = 0
					for(var/x in design.req_tech)
						if(design.req_tech[x] > 4)
							restart = 1
							design = pick(possible_designs)
					if(!restart) valid = 1
			export.required = rand(30, 70)
			for(var/x in design.materials)
				if(!x)
					to_world("[design] had a blank resource")
					continue
				var/material/mat = SSmaterials.get_material_by_name(x)
				if(mat)
					per += round(mat.value*design.materials[x]/2000,0.01)
			for(var/x in design.req_tech)
				per += design.req_tech[x]*5
			export.typepath = design.build_path
			export.rate = per
			export.order_type = typee
			export.id = exportnum
			if(design.build_path)
				var/obj/ob = new design.build_path()
				export.typepath = ob.parent_type
				export.parent_typepath = ob.parent_type
				export.name = "Order for [export.required] [ob.name]\s at [export.rate] for each item."
				all_exports |= export
				return export

		if("cooking")
			export = new()
			var/list/possible_designs = list()
			for(var/D in subtypesof(/obj/item/weapon/reagent_containers/food/snacks/variable))
				possible_designs += D
			export.required = rand(12, 32)
			var/per = rand(10,30)
			export.typepath = pick(possible_designs)
			export.rate = per
			export.order_type = typee
			export.id = exportnum
			var/obj/ob = new export.typepath()
			export.name = "Order for [export.required] [ob.name]\s at [export.rate] for each item."
			all_exports |= export
			qdel(ob)
			return export

		if("xenobiology")
			export = new /datum/export_order/static()
			export.typepath = /obj/item/slime_extract
			export.name = "Order for slime extracts of any type. Payment depends on the rarity of the extract."
			export.order_type = typee
			export.id = exportnum
			all_exports |= export
			return export

		if("material")
			export = new /datum/export_order/stack()
			var/list/possible = list(
								/obj/item/stack/material/diamond = 50,
								/obj/item/stack/material/uranium = 50,
								/obj/item/stack/material/gold = 30,
								/obj/item/stack/material/platinum = 30,
								/obj/item/stack/material/osmium = 30,
								)
			var/x = pick(possible)
			var/per = possible[x]+rand(0,5)
			export.typepath = x
			export.rate = per
			export.order_type = typee
			export.id = exportnum
			export.required = rand(50, 150)
			var/obj/ob = new x()
			export.name = "Order for [export.required] [ob.name]\s at [export.rate] for each unit."
			qdel(ob)
			all_exports |= export
			return export

		if("phoron")
			export = new /datum/export_order/stack()
			export.typepath = /obj/item/stack/material/phoron
			export.rate = rand(60,100)
			export.order_type = typee
			export.id = exportnum
			export.required = rand(300, 500)
			var/obj/ob = new export.typepath()
			export.name = "Order for [export.required] [ob.name]\s at [export.rate] for each unit."
			qdel(ob)
			all_exports |= export
			return export

		if("bluespace crystal")
			export = new /datum/export_order/static()
			export.typepath = /obj/item/bluespace_crystal
			export.name = "Order for bluespace crystals. $$500 per crystal."
			export.order_type = typee
			export.id = exportnum
			export.rate = 500
			all_exports |= export
			return export


		if("manufacturing-phoron")
			export = new()
			var/list/possible_designs = list()
			for(var/D in valid_phoron_designs)
				possible_designs += new D(src)
			if(!possible_designs.len)
				return
			var/datum/design/design = pick(possible_designs)
			export.required = rand(50, 100)
			var/per = rand(10,30)
			for(var/x in design.materials)
				if(!x)
					to_world("[design] had a blank resource")
					continue
				var/material/mat = SSmaterials.get_material_by_name(x)
				if(mat)
					per += round(mat.value*design.materials[x]/2000,0.01)
			for(var/x in design.req_tech)
				per += design.req_tech[x]*5
			export.typepath = design.build_path
			export.rate = per
			export.order_type = typee
			export.id = exportnum
			if(design.build_path)
				var/obj/ob = new design.build_path()
				export.typepath = ob.parent_type
				export.parent_typepath = ob.parent_type
				export.name = "Order for [export.required] [ob.name]\s at [export.rate] for each item."
				all_exports |= export
				return export


/datum/controller/supply/proc/process()
	add_points_from_source(points_per_process, "time")

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

	//Sellin
/datum/controller/supply/proc/sell()
	var/phoron_count = 0
	var/plat_count = 0
	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/MA in subarea)
			if(MA.anchored)	continue

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = MA
				callHook("sell_crate", list(CR, subarea))

				add_points_from_source(CR.points_per_crate, "crate")
				var/find_slip = 1

				for(var/atom in CR)
					// Sell manifests
					var/atom/A = atom
					if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Sell phoron and platinum
					if(istype(A, /obj/item/stack))
						var/obj/item/stack/P = A
						switch(P.get_material_name())
							if("phoron") phoron_count += P.get_amount()
							if("platinum") plat_count += P.get_amount()
			qdel(MA)

	if(phoron_count)
		var/temp = phoron_count * points_per_phoron
		add_points_from_source(temp, "phoron")

	if(plat_count)
		var/temp = plat_count * points_per_platinum
		add_points_from_source(temp, "platinum")

	//Buyin
/datum/controller/supply/proc/buy()
	if(!shoppinglist.len) return
	var/list/clear_turfs = list()
	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)	continue
			var/contcount
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T
	for(var/S in shoppinglist)
		if(!clear_turfs.len)	break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		shoppinglist -= S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername][SO.comment ? " ([SO.comment])":"" ]"
		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			slip = new /obj/item/weapon/paper/manifest(A)
			slip.is_copy = 0
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [GLOB.using_map.station_name]<br>"
			slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(isnum(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()
			else
				log_debug("<span class='danger'>Supply pack with invalid access restriction [SP.access] encountered!</span>")

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

	return
