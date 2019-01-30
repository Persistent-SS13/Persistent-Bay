/datum/computer_file/program/research
	filename = "research"
	filedesc = "Research Program"
	extended_desc = "Allows access to company research storage."
	program_icon_state = "generic"
	size = 8
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/research

/datum/computer_file/program/research/handleInteraction(var/obj/item/weapon/W, var/mob/user)
	var/datum/world_faction/faction = ConnectedFaction()
	if(!faction || !faction.ModuleResearch)
		return

	if(istype(W, /obj/item/weapon/researchTheorem))
		var/obj/item/weapon/researchTheorem/T = W
		// faction.ModuleResearch.AddResearch(T)
		user.drop_from_inventory(T)
		qdel(T)
		return 1


/datum/nano_module/program/research
	name = "Research Program"

/datum/nano_module/program/research/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["printer"] = !!program.computer.nano_printer

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "research_program.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/research/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["print"])
		new /obj/item/weapon/researchTheorem(get_turf(program.computer))
		return 1
