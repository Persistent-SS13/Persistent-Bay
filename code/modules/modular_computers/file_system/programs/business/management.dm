/datum/computer_file/program/management
	filename = "businessmanagement"
	filedesc = "Business Central Options"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/management
	extended_desc = "Used by high ranking employees to control the status and other central options for the business."
	requires_ntnet = 1
	size = 12
	business = 1
	required_access = core_access_command_programs
	category = PROG_BUSINESS
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/management
	name = "Business Central Options"
	available_to_ai = TRUE
	var/menu = 1
	var/curr_page
/datum/nano_module/program/management/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	var/list/data = host.initial_data()
	data["business_name"] = connected_faction.name
	data["menu"] = menu
	data["account_balance"] = connected_faction.central_account.money
	if(menu == 1)
		data["business_status"] = connected_faction.status
		data["commission"] = connected_faction.commission
	if(menu == 2)
		var/list/formatted_log[0]
		if(connected_faction.employment_log.len)
			for(var/i=0; i<10; i++)
				var/minus = i+(10*(curr_page-1))
				if(minus >= connected_faction.employment_log.len || minus > 50) break
				var/entry = connected_faction.employment_log[connected_faction.employment_log.len-minus]
				formatted_log[++formatted_log.len] = list("entry" = entry)
		data["entries"] = formatted_log
		var/pages = connected_faction.employment_log.len/10
		if(pages < 1)
			pages = 1
		data["page"] = curr_page
		data["page_up"] = curr_page < pages
		data["page_down"] = curr_page > 1
	if(menu == 3)
		data["business_task"] = connected_faction.objective

	if(menu == 4)
		data["module_name"] = connected_faction.module.name
		data["module_spec"] = connected_faction.module.spec.name
		data["module_level"] = connected_faction.module.current_level
		if(connected_faction.module.current_level >= 4)
			data["max_level"] = 1
			data["upgrade_desc"] = ""
		else
			var/datum/machine_limits/limit = connected_faction.module.levels[connected_faction.module.current_level+1]
			data["upgrade_desc"] = limit.desc
			data["upgrade_cost"] = limit.cost
		var/datum/machine_limits/limits = connected_faction.get_limits()
		data["gen_tech"] = limits.limit_tech_general
		data["eng_tech"] = limits.limit_tech_engi
		data["med_tech"] = limits.limit_tech_medical
		data["consumer_tech"] = limits.limit_tech_consumer
		data["combat_tech"] = limits.limit_tech_combat
		data["shuttle_limit"] = limits.limit_shuttles
		data["shuttle_limit_used"] = limits.shuttles.len
		data["area_limit"] = limits.limit_area
		data["area_limit_used"] = connected_faction.get_claimed_area()
		data["drill_limit"] = limits.limit_drills
		data["drill_limit_used"] = limits.drills.len
		data["tray_limit"] = limits.limit_botany
		data["tray_limit_used"] = limits.botany.len
		data["tcomm_limit"] = limits.limit_tcomms
		data["tcomm_limit_used"] = limits.tcomms.len
		data["gen_limit"] = limits.limit_genfab
		data["gen_limit_used"] = limits.genfabs.len
		data["eng_limit"] = limits.limit_engfab
		data["eng_limit_used"] = limits.engfabs.len
		data["med_limit"] = limits.limit_medicalfab
		data["med_limit_used"] = limits.medicalfabs.len
		data["eva_limit"] = limits.limit_voidfab
		data["eva_limit_used"] = limits.voidfabs.len
		data["consumer_limit"] = limits.limit_consumerfab
		data["consumer_limit_used"] = limits.consumerfabs.len
		data["service_limit"] = limits.limit_servicefab
		data["service_limit_used"] = limits.servicefabs.len
		data["combat_limit"] = limits.limit_ammofab
		data["combat_limit_used"] = limits.ammofabs.len
		data["atstandard_limit"] = limits.limit_atstandard
		data["atstandard_limit_used"] = limits.atstandards.len
		data["ataccessory_limit"] = limits.limit_ataccessories
		data["ataccessory_limit_used"] = limits.ataccessories.len
		data["atspecial_limit"] = limits.limit_atnonstandard
		data["atspecial_limit_used"] = limits.atnonstandards.len

	if(menu == 5)
		if(connected_faction.hourly_objective)
			data["objective_hour"] = connected_faction.hourly_objective.name
			data["objective_hour_status"] = connected_faction.hourly_objective.get_status()
		else
			data["objective_hour_status"] = "*None*"
		data["objective_hour_timer"] = time2text(connected_faction.hourly_assigned + 2 HOURS, "MMM DD hh:mm:ss")

		if(connected_faction.module.current_level >= 2)
			data["daily_unlocked"] = 1
			if(connected_faction.daily_objective)
				data["objective_daily"] = connected_faction.daily_objective.name
				data["objective_daily_status"] = connected_faction.daily_objective.get_status()
			else
				data["objective_daily_status"] = "*None*"
			data["objective_daily_timer"] = time2text(connected_faction.daily_assigned + 1 DAY, "MMM DD hh:mm:ss")
		if(connected_faction.module.current_level >= 3)
			data["weekly_unlocked"] = 1
			if(connected_faction.weekly_objective)
				data["objective_weekly"] = connected_faction.weekly_objective.name
				data["objective_weekly_status"] = connected_faction.weekly_objective.get_status()
			else
				data["objective_weekly_status"] = "*None*"
			data["objective_weekly_timer"] = time2text(connected_faction.daily_assigned + 7 DAYS, "MMM DD hh:mm:ss")


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "management.tmpl", name, 750, 650, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/management/Topic(href, href_list)
	if(..())
		return 1
	. = SSnano.update_uis(src)
	var/datum/world_faction/business/connected_faction = program.computer.network_card.connected_network.holder
	if(!program.can_run(usr)) return 1
	if(!istype(connected_faction))
		return .
	if(href_list["page_up"])
		curr_page++
		return 1
	if(href_list["page_down"])
		curr_page--
		return 1
	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])
		if("business_open")
			connected_faction.open_business()
		if("business_close")
			connected_faction.close_business()
		if("business_name")
			var/select_name = sanitize(input(usr,"Enter the new business display name.","Business Name", "") as null|text, MAX_NAME_LEN+10)
			if(select_name)
				connected_faction.name = select_name
		if("edit_task")
			var/newValue
			newValue = replacetext(input(usr, "Edit the message displayed to all clocked in laces. You may use HTML paper formatting tags:", "General Task", replacetext(html_decode(connected_faction.objective), "\[br\]", "\n")) as null|message, "\n", "\[br\]")
			if(newValue)
				connected_faction.objective = newValue
		if("commission")
			var/choseValue
			choseValue = min(max(0, input(usr, "Enter the invoice commission percentage.", "Invoice Commission", connected_faction.commission) as null|num),95)
			if(!isnull(choseValue))
				connected_faction.commission = choseValue
		if("upgrade")
			if(connected_faction.module.current_level > 3) return
			var/datum/machine_limits/limit = connected_faction.module.levels[connected_faction.module.current_level+1]
			var/cost = limit.cost
			if(connected_faction.central_account.money < cost)
				to_chat(usr, "Insufficent funds in the business account.")
			else
				var/datum/transaction/Te = new("Upgraded by [usr.real_name]", "Business Upgrade", -cost, "Business Upgrade Cost")
				connected_faction.central_account.do_transaction(Te)
				connected_faction.module.current_level++
		if("objective_hour_abandon")
			var/curr_objective = connected_faction.hourly_objective
			var/choice = input(usr,"This will cancel the objective giving up any chance of completing it.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(connected_faction.hourly_objective == curr_objective)
					connected_faction.hourly_objective = null
		if("objective_daily_abandon")
			var/curr_objective = connected_faction.daily_objective
			var/choice = input(usr,"This will cancel the objective giving up any chance of completing it.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(connected_faction.daily_objective == curr_objective)
					connected_faction.daily_objective = null
		if("objective_weekly_abandon")
			var/curr_objective = connected_faction.weekly_objective
			var/choice = input(usr,"This will cancel the objective giving up any chance of completing it.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(connected_faction.weekly_objective == curr_objective)
					connected_faction.weekly_objective = null
					
		if("unlink_area")
			for(var/obj/machinery/power/apc/apc in connected_faction.limits.apcs)
				apc.can_disconnect(connected_faction, usr)
				
		if("unlink_drill")
			for(var/obj/machinery/mining/drill/drill in connected_faction.limits.drills)
				drill.can_disconnect(connected_faction, usr)
		
		if("unlink_tray")
			for(var/obj/machinery/portable_atmospherics/hydroponics/tray in connected_faction.limits.botany)
				tray.can_disconnect(connected_faction, usr)		

		if("unlink_gen")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.genfabs)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_eng")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.engfabs)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_med")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.medicalfabs)
				fab.can_disconnect(connected_faction, usr)
		
		if("unlink_eva")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.voidfabs)
				fab.can_disconnect(connected_faction, usr)
		
		if("unlink_consumer")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.consumerfabs)
				fab.can_disconnect(connected_faction, usr)
		
		if("unlink_service")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.servicefabs)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_combat")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.ammofabs)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_atstandard")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.atstandards)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_ataccessories")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.ataccessories)
				fab.can_disconnect(connected_faction, usr)

		if("unlink_atspecial")
			for(var/obj/machinery/fabricator/fab in connected_faction.limits.atnonstandards)
				fab.can_disconnect(connected_faction, usr)


