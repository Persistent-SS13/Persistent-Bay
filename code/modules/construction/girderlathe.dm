
/obj/machinery/girderlathe
	name = "Girder Lathe"
	desc = "A large machine designed to pre-fabricate girders parts from sheets"
	icon = 'icons/obj/machines/girderlathe.dmi'
	icon_state = "lathe"
	bound_width = 64
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000

	clicksound = "keyboard"
	clickvol = 30
	circuit_type = /obj/item/weapon/circuitboard/girderlathe

	var/stored_materials = list()
	var/input = 0
	var/processing = 0

/obj/machinery/girderlathe/New()
	..()
	ADD_SAVED_VAR(stored_materials)
	ADD_SAVED_VAR(input)
	ADD_SAVED_VAR(processing)

/obj/machinery/girderlathe/should_save(datum/saver)
	. = ..()
	if(!.)
		return FALSE
	var/turf/T = saver
	if(istype(saver))
		return T == get_turf(src) //only save if we're on the "base" turf on which the stairs rest on
	return FALSE

/obj/machinery/girderlathe/Process()
	if(stat & NOPOWER || use_power != 2)
		if(icon_state != "lathe")
			icon_state = "lathe"
		return

	if(use_power == 2)
		if(icon_state != "lathe_r")
			icon_state = "lathe_r"
		if(input)
			var/turf/T = get_step(src, WEST)
			for(var/i = 0, i<10 ,i++)
				var/obj/item/stack/material/M = locate() in T
				if(M)
					stored_materials[M.material.type] += M.amount
					qdel(M)
		for(var/M in stored_materials)
			if(!processing && stored_materials[M] >= 2)
				stored_materials[M] -= 2
				processing = 1
				sleep(80)
				flick("lathe_o", src)
				sleep(10)
				processing = 0
				var/turf/T = get_step(get_step(src, EAST), EAST) // Double step
				new /obj/item/girderpart(T, new M())
				return

/obj/machinery/girderlathe/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	user.set_machine(src)

	var/data[0]
	data["use_power"] = use_power
	data["processing"] = processing
	data["input"] = input

	var/list/L = list()
	for(var/item in stored_materials)
		L.Add(list(list("type" = "[item]", "amount" = stored_materials[item])))
	data["contents"] = L

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "girderlathe.tmpl", src.name, 325, 625, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/girderlathe/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.get_open_ui(user, src, "main")

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["power"])
		use_power = use_power == 1 ? 2 : 1
		return

	if(href_list["input"])
		input = !input
		return

	if(href_list["eject"])
		for(var/M in stored_materials)
			if(stored_materials[M])
				var/material/type = new M()
				var/obj/item/stack/material/stack = new type.stack_type(src.loc)
				stack.amount = stored_materials[M]
				stored_materials[M] = 0


/obj/machinery/girderlathe/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/girderlathe/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/stack/material))
		var/obj/item/stack/material/M = W
		var/amount = M.amount
		if(M.use(amount))
			stored_materials[M.material.type] += amount
	if(processing)
		to_chat(user, "You can't do that while it is running.")
	if(default_deconstruction_screwdriver(user, W))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	if(stat)
		return


/obj/item/weapon/circuitboard/girderlathe
	name = T_BOARD("girderlathe")
	build_path = /obj/machinery/girderlathe
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 3,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/datum/design/circuit/girderlathe
	name = "girder lathe board"
	id = "girderlathe"
	req_tech = list(TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/girderlathe
	sort_string = "HABAF"
