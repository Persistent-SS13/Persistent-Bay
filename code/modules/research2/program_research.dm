/datum/computer_file/program/research
	filename = "research"
	filedesc = "Research Program"
	extended_desc = "Allows access to company research storage."
	program_icon_state = "generic"
	size = 8
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/research

//Event callback
// /datum/computer_file/program/research/event_item_used(var/obj/item/I, var/mob/user)
// 	return do_on_afterattack(user, I)

//Hijack the paper scanner instead
/obj/item/weapon/computer_hardware/scanner/paper/do_on_afterattack(mob/user, obj/item/weapon/paper/researchTheorem/target, proximity)
	if(!..())
		return
	if(!holder2?.active_program)
		return
	var/datum/world_faction/faction = holder2.active_program.ConnectedFaction()
	if(!faction /*|| !faction.ModuleResearch*/)
		return
	if(istype(target))
		// faction.ModuleResearch.AddResearch(target)
		user.drop_from_inventory(target)
		qdel(target)
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
		new /obj/item/weapon/paper/researchTheorem(get_turf(program.computer))
		return 1
