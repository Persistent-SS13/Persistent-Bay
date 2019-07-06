#define DCORE_MAIN 1
#define DCORE_SPECIALASSIGNMENT 2
#define DCORE_ACCESSMENU 3
#define DCORE_ASSIGNMENTMENU 4
#define DCORE_ACCESSCATEGORY 5
#define DCORE_ACCESS 6
#define DCORE_ASSIGNMENTCATEGORY 7
#define DCORE_ASSIGNMENT 8
#define DCORE_ECONOMY 9
#define DCORE_PROMOTION 10
#define DCORE_CRYO 11




/datum/computer_file/program/democracy_core
	filename = "democracy_core"
	filedesc = "Executive Government Control"
	program_icon_state = "comm"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/democracy_core
	extended_desc = "Used by the Executive Branch to manage the government."
	required_access = core_access_leader
	requires_ntnet = 1
	size = 65
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN
	democratic = 1
	category = PROG_GOVERNMENT

/datum/nano_module/program/democracy_core
	name = "Executive Government Control"
	available_to_ai = TRUE
	var/connected = 0
	var/attempted_password = ""
	var/wrong_password = 0
	var/wrong_connection = 0
	var/menu = 1 // 1 = main directory 2 = central options 3 = main access control 4 = main assignment control
				// 8 5 = access category view 9 6 = access view 10 7 = assignment category view 11 8 = assignment view 12 9 = economy menu, 13 10 = promotion control, 14 11  = cryocontrol
	var/datum/access_category/selected_accesscategory
	var/selected_access = 0
	var/datum/assignment_category/selected_assignmentcategory
	var/datum/assignment/selected_assignment
	var/viewing_ranks = 0
	var/prior_menu = 3
	var/datum/access_category/core_access
	var/selected_rank = 1



/datum/nano_module/program/democracy_core/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(connected_faction)
		data["faction_name"] = connected_faction.name
		data["faction_uid"] = connected_faction.uid
		if(menu == DCORE_ACCESSMENU)
			var/list/access_categories[0]
			var/datum/access_category/core/core
			if(!core_access)
				core = new()
				core_access = core
			var/list/all_categories = list()
			all_categories |= core_access
			all_categories |= connected_faction.access_categories
			for(var/datum/access_category/category in all_categories)
				access_categories[++access_categories.len] = list("name" = category.name, "accesses" = list(), "ref" = "\ref[category]")
				var/ind = 0
				for(var/x in category.accesses)
					ind++
					var/name = category.accesses[x]
					if(!name) continue
					access_categories[access_categories.len]["accesses"] += list(list(
					"name" = sanitize("([x]) [name]"),
					"ind" = ind))
			data["access_categories"] = access_categories
		if(menu == DCORE_ASSIGNMENTMENU)
			var/list/assignment_categories[0]
			for(var/datum/assignment_category/category in connected_faction.assignment_categories)
				assignment_categories[++assignment_categories.len] = list("name" = category.name, "assignments" = list(), "ref" = "\ref[category]")
				for(var/datum/assignment/assignment in category.assignments)
					assignment_categories[assignment_categories.len]["assignments"] += list(list(
					"name" = sanitize(assignment.uid),
					"ref2" = "\ref[assignment]"
					))
			data["assignment_categories"] = assignment_categories
		if(menu == DCORE_ACCESSCATEGORY)
			if(!selected_accesscategory)
				menu = DCORE_ACCESSMENU
				return ui_interact(user, ui_key, ui, force_open, state)
			var/list/accesses[0]
			var/ind = 0
			for(var/x in selected_accesscategory.accesses)
				ind++
				var/name = selected_accesscategory.accesses[x]
				accesses[++accesses.len] = list("name" = "([x]) [name]", "ind" = ind)
			data["accesses"] = accesses
		if(menu == DCORE_ACCESS)
			if(!selected_access)
				menu = DCORE_ACCESSMENU
				return ui_interact(user, ui_key, ui, force_open, state)
		if(menu == DCORE_ASSIGNMENTCATEGORY) // assignment category view
			if(!selected_assignmentcategory)
				menu = DCORE_ASSIGNMENTMENU
				return ui_interact(user, ui_key, ui, force_open, state)
			data["leader_faction"] = selected_assignmentcategory.command_faction
			data["membership_faction"] = selected_assignmentcategory.member_faction
			data["account_status"] = selected_assignmentcategory.account_status
			data["faction_leader"] = selected_assignmentcategory.head_position ? selected_assignmentcategory.head_position.uid : "None"

			var/list/assignments[0]
			for(var/datum/assignment/assignment in selected_assignmentcategory.assignments)
				assignments[++assignments.len] = list("name" = "([assignment.uid]) [assignment.name]", "ref" = "\ref[assignment]")
			data["assignments"] = assignments
		if(menu == DCORE_ASSIGNMENT)
			if(!selected_assignment)
				menu = DCORE_ASSIGNMENTMENU
				return ui_interact(user, ui_key, ui, force_open, state)
			data["pay"] = selected_assignment.payscale
			data["title"] = selected_assignment.name
			data["cryonetwork"] = selected_assignment.cryo_net
			data["selected_rank"] = selected_rank
			if(selected_rank < selected_assignment.accesses.len)
				data["increase_button"] = 1
			if(selected_rank != 1)
				data["decrease_button"] = 1
			if(selected_assignment.accesses.len)
				if(selected_assignment.accesses[1] && !istype(selected_assignment.accesses[1], /datum/accesses))
					var/datum/accesses/copy = new()
					selected_assignment.accesses |= copy
					message_admins("Broken assignment [selected_assignment.uid]")
			else
				var/datum/accesses/copy = new()
				selected_assignment.accesses |= copy

			var/list/all_access = list()
			var/expense_limit = 0
			var/title = ""
			var/auth_level = 0
			var/auth_req = 0
			var/pay = 0
			if(selected_rank > selected_assignment.accesses.len)
				selected_rank = selected_assignment.accesses.len
			for(var/i=1;i<=selected_rank;i++)
				var/datum/accesses/copy = selected_assignment.accesses[i]
				if(istype(copy))
					expense_limit = copy.expense_limit
					title = copy.name
					auth_level = copy.auth_level
					auth_req = copy.auth_req
					pay = copy.pay
					all_access |= copy.accesses
			data["expense_limit"] = expense_limit
			data["rank_title"] = title
			data["rank_wage"] = pay
			data["auth_level"] = auth_level
			data["auth_req"] = auth_req
			var/list/access_categories[0]
			var/datum/access_category/core/core
			if(!core_access)
				core = new()
				core_access = core
			var/list/all_categories = list()
			all_categories |= core_access
			all_categories |= connected_faction.access_categories
			for(var/datum/access_category/category in all_categories)
				access_categories[++access_categories.len] = list("name" = category.name, "accesses" = list(), "ref" = "\ref[category]")
				var/ind = 0
				for(var/x in category.accesses)
					var/existing = 0
					if(all_access.Find(x))
						existing = 1
					ind++
					var/name = category.accesses[x]
					if(!name) continue
					access_categories[access_categories.len]["accesses"] += list(list(
					"name" = sanitize("([x]) [name]"),
					"ind" = ind,
					"existing" = existing))
			data["access_categories"] = access_categories
			var/list/ranks[0]
			var/ind = 0
			for(var/datum/accesses/access in selected_assignment.accesses)
				var/rtitle = access.name
				ind++
				ranks[++ranks.len] = list("name" = "[rtitle]", "ind" = "[ind]")


			data["ranks"] = ranks
			data["view_ranks"] = viewing_ranks
		if(menu == DCORE_ECONOMY)
			data["money_rate"] = connected_faction.payrate
			data["money_debt"] = connected_faction.get_debt()
			data["money_balance"] = connected_faction.central_account.money
			data["tax_rate"] = connected_faction.tax_rate
			data["import_rate"] = connected_faction.import_profit
			data["export_rate"] = connected_faction.export_profit
		if(menu == DCORE_PROMOTION)
			data["rank1_req"] = connected_faction.all_promote_req
			data["rank3_req"] = connected_faction.three_promote_req
			data["rank5_req"] = connected_faction.five_promote_req
		if(menu == DCORE_CRYO) // cryo menu
			var/list/cryos[0]
			cryos[++cryos.len] = list("name" = "default")
			for(var/cryoname in connected_faction.cryo_networks)
				cryos[++cryos.len] = list("name" = cryoname)
			data["cryos"] = cryos
		if(menu == DCORE_SPECIALASSIGNMENT)
			if(!selected_assignment)
				menu = DCORE_ASSIGNMENTMENU
				return ui_interact(user, ui_key, ui, force_open, state)
			data["pay"] = selected_assignment.payscale
			data["cryonetwork"] = selected_assignment.cryo_net
			var/list/all_access = list()
			var/expense_limit = 0
			var/title = ""
			var/auth_level = 0
			var/auth_req = 0
			var/pay = 0
			if(selected_rank > selected_assignment.accesses.len)
				selected_rank = selected_assignment.accesses.len
			for(var/i=1;i<=selected_rank;i++)
				var/datum/accesses/copy = selected_assignment.accesses[i]
				if(istype(copy))
					expense_limit = copy.expense_limit
					title = copy.name
					auth_level = copy.auth_level
					auth_req = copy.auth_req
					pay = copy.pay
					all_access |= copy.accesses
			data["expense_limit"] = expense_limit
			data["rank_title"] = title
			data["rank_wage"] = pay
			data["auth_level"] = auth_level
			data["auth_req"] = auth_req
			var/list/access_categories[0]
			var/datum/access_category/core/core
			if(!core_access)
				core = new()
				core_access = core
			var/list/all_categories = list()
			all_categories |= core_access
			all_categories |= connected_faction.access_categories
			for(var/datum/access_category/category in all_categories)
				access_categories[++access_categories.len] = list("name" = category.name, "accesses" = list(), "ref" = "\ref[category]")
				var/ind = 0
				for(var/x in category.accesses)
					var/existing = 0
					if(all_access.Find(x))
						existing = 1
					ind++
					var/name = category.accesses[x]
					if(!name) continue
					access_categories[access_categories.len]["accesses"] += list(list(
					"name" = sanitize("([x]) [name]"),
					"ind" = ind,
					"existing" = existing))
			data["access_categories"] = access_categories

	if(selected_accesscategory)
		data["selected_accesscategory"] = selected_accesscategory.name
	if(selected_access && selected_accesscategory)
		var/x = selected_accesscategory.accesses[selected_access]
		var/name = selected_accesscategory.accesses[x]
		data["selected_access"] = name
		data["accessnum"] = x
	if(selected_assignmentcategory)
		data["selected_assignmentcategory"] = selected_assignmentcategory.name
	if(selected_assignment)
		if(selected_rank > selected_assignment.accesses.len)
			selected_rank = selected_assignment.accesses.len
		var/datum/accesses/access = selected_assignment.accesses[selected_rank]
		data["selected_assignment"] = "([selected_assignment.uid]) [access.name]"
	data["prior_menu"] = prior_menu
	data["menu"] = menu


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "democracy_core.tmpl", name, 550, 650, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/democracy_core/Topic(href, href_list)
	if(..())
		return 1
	var/datum/world_faction/democratic/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!program.can_run(usr)) return 1
	switch (href_list["action"])

		if("change_menu")
			var/select_menu = text2num(href_list["menu_target"])
			menu = select_menu
			selected_rank = 1
			prior_menu = DCORE_MAIN
		if("menu_back")
			menu = DCORE_MAIN
		if("create_accesscategory")
			var/select_name = sanitizeName(input(usr,"Enter new access category name.","Create Access Category", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				for(var/datum/access_category/category in connected_faction.access_categories)
					if(category.name == select_name)
						to_chat(usr, "Error! That access category already exists!")
						return 1
				var/datum/access_category/category = new()
				category.name = select_name
				connected_faction.access_categories |= category
				to_chat(usr, "Access category successfully created.")
		if("select_accesscategory")
			selected_accesscategory = locate(href_list["selected_ref"])
			if(!selected_accesscategory) return 1
			menu = DCORE_ACCESSCATEGORY
			prior_menu = DCORE_ASSIGNMENTMENU
		if("edit_accesscategory")
			var/curr_name = selected_accesscategory.name
			var/select_name = sanitizeName(input(usr,"Enter new name.","Change Access Category Name", curr_name) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(select_name == curr_name) return
				for(var/datum/access_category/category in connected_faction.access_categories)
					if(category.name == select_name)
						to_chat(usr, "Error! That access category already exists!")
						return 1
				selected_accesscategory.name = select_name
				to_chat(usr, "Access category successfully edited.")
		if("delete_accesscategory")
			if(selected_accesscategory.accesses.len)
				to_chat(usr, "You must delete the accesses first. You can only delete empty access categories.")
				return 1
			connected_faction.access_categories -= selected_accesscategory
			qdel(selected_accesscategory)
			selected_accesscategory = null
			menu = DCORE_ACCESSMENU
		if("select_access")
			selected_accesscategory = locate(href_list["selected_ref"])
			if(!selected_accesscategory) return 1
			selected_access = text2num(href_list["selected_ind"])
			menu = DCORE_ACCESS
			prior_menu = DCORE_ACCESSMENU
		if("create_access")
			var/selected_uid = input(usr,"Enter unique access number (1 - 99)", "Enter Access Number") as null|num
			if(!selected_uid || selected_uid < 1 || selected_uid > 99)
				to_chat(usr, "Invalid number.")
				return 1
			var/text_uid = num2text(selected_uid)
			connected_faction.rebuild_all_access()
			if(connected_faction.all_access.Find(text_uid))
				to_chat(usr, "This access number is already in use.")
				return 1
			var/select_name = sanitizeName(input(usr,"Enter access label. This can be changed afterwards.","Create new access", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				selected_accesscategory.accesses[text_uid] = select_name
				to_chat(usr, "Access successfully created.")
		if("create_access_two")
			var/datum/access_category/selected_accesscategory2 = locate(href_list["selected_ref"])
			var/selected_uid = input(usr,"Enter unique access number (1 - 99)", "Enter Access Number") as null|num
			if(!selected_uid || selected_uid < 1 || selected_uid > 99)
				to_chat(usr, "Invalid number.")
				return 1
			var/text_uid = num2text(selected_uid)
			connected_faction.rebuild_all_access()
			if(connected_faction.all_access.Find(text_uid))
				to_chat(usr, "This access number is already in use.")
				return 1
			var/select_name = sanitizeName(input(usr,"Enter access label. This can be changed afterwards.","Create new access", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				selected_accesscategory2.accesses[text_uid] = select_name
				to_chat(usr, "Access successfully created.")
		if("edit_access")
			var/x = selected_accesscategory.accesses[selected_access]
			var/curr_name = selected_accesscategory.accesses[x]
			var/select_name = sanitizeName(input(usr,"Change access label.","Edit access label", curr_name) as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(curr_name == select_name) return 1
				selected_accesscategory.accesses[x] = select_name
				to_chat(usr, "Access successfully edited.")
		if("delete_access")
			var/x = selected_accesscategory.accesses[selected_access]
			selected_accesscategory.accesses -= x
			connected_faction.rebuild_all_access()
			to_chat(usr, "Access successfully deleted.")
			menu = DCORE_ACCESSMENU
		if("select_access_noref")
			if(!selected_accesscategory) return 1
			selected_access = text2num(href_list["selected_ind"])
			menu = DCORE_ACCESS
			prior_menu = DCORE_ACCESSCATEGORY
		if("create_assignmentcategory")
			var/select_name = sanitizeName(input(usr,"Enter new assignment category name.","Create Assignment Category", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				for(var/datum/assignment_category/category in connected_faction.assignment_categories)
					if(category.name == select_name)
						to_chat(usr, "Error! That assignment category already exists!")
						return 1
				var/datum/assignment_category/category = new()
				category.name = select_name
				category.parent = connected_faction
				connected_faction.assignment_categories |= category
				to_chat(usr, "Assignment category successfully created.")
		if("select_assignmentcategory")
			selected_assignmentcategory = locate(href_list["selected_ref"])
			if(!selected_assignmentcategory) return 1
			menu = DCORE_ASSIGNMENTCATEGORY
			prior_menu = DCORE_ASSIGNMENTMENU
		if("select_assignment")
			selected_assignmentcategory = locate(href_list["category_ref"])
			if(!selected_assignmentcategory) return 1
			selected_assignment = locate(href_list["selected_ref"])
			if(!selected_assignment) return 1
			menu = DCORE_ASSIGNMENT
			prior_menu = DCORE_ASSIGNMENTMENU
		if("select_judge")
			selected_assignment = connected_faction.judge_assignment
			if(!selected_assignment) return 1
			menu = DCORE_SPECIALASSIGNMENT
			prior_menu = DCORE_ASSIGNMENTMENU

		if("select_councillor")
			selected_assignment = connected_faction.councillor_assignment
			if(!selected_assignment) return 1
			menu = DCORE_SPECIALASSIGNMENT
			prior_menu = DCORE_ASSIGNMENTMENU

		if("select_assignment_two")
			selected_assignment = locate(href_list["selected_ref"])
			if(!selected_assignment) return 1
			menu = DCORE_ASSIGNMENT
			prior_menu = DCORE_ASSIGNMENTCATEGORY
		if("assignmentcategory_leadership_yes")
			selected_assignmentcategory.command_faction = 1
		if("assignmentcategory_leadership_no")
			selected_assignmentcategory.command_faction = 0
		if("assignmentcategory_membership_yes")
			selected_assignmentcategory.member_faction = 1
		if("assignmentcategory_membership_no")
			selected_assignmentcategory.member_faction = 0
		if("assignmentcategory_account_on")
			selected_assignmentcategory.account_status = 1
		if("assignmentcategory_account_off")
			selected_assignmentcategory.account_status = 0
		if("assignmentcategory_changeleader")
			var/curr = selected_assignmentcategory.head_position
			var/datum/assignment/selected = input(usr,"Choose which assignment","Enter Parameter",null) as null|anything in (selected_assignmentcategory.assignments + "None")
			if(selected_assignmentcategory.head_position != curr)
				to_chat(usr, "Your inputs expired because someone used the terminal first.")
				SSnano.update_uis(src)
				return 1
			if(!selected || selected == "None")
				selected_assignmentcategory.head_position = null
			else
				selected_assignmentcategory.head_position = selected
		if("create_assignment")
			var/x = selected_assignmentcategory
			var/select_name = sanitizeName(input(usr,"Enter the new assignments uid. This cannot be changed. Spaces are not allowed.","New Assignment UID", "") as null|text, MAX_NAME_LEN, 1, 0,1)
			if(select_name)
				connected_faction.rebuild_all_assignments()
				for(var/datum/assignment/assignment in connected_faction.all_assignments)
					if(assignment.uid == select_name)
						to_chat(usr, "Error! An assignment with that UID already exists")
						return 1
				var/select_title = sanitizeName(input(usr,"Enter Assignment Rank 1 Title.","Create Starting Title", "") as null|text, MAX_NAME_LEN, 1, 0)
				if(select_title)
					if(x != selected_assignmentcategory)
						to_chat(usr, "Your inputs expired because someone used the terminal first.")
						SSnano.update_uis(src)
						return 1
					var/datum/assignment/new_assignment = new()
					new_assignment.parent = selected_assignmentcategory
					new_assignment.name = select_title
					new_assignment.uid = select_name
					new_assignment.cryo_net = "Last Known Cryonet"
					selected_assignmentcategory.assignments |= new_assignment
					to_chat(usr, "Assignment successfully created.")
					var/datum/accesses/access = new()
					access.name = select_title
					access.pay = 0
					access.auth_level = 0
					access.auth_req = 0
					access.expense_limit = 0
					new_assignment.accesses |= access
		if("create_assignment_two")
			var/datum/assignment_category/selected_assignmentcategory2 = locate(href_list["selected_ref"])
			var/x = selected_assignmentcategory2
			var/select_name = sanitizeName(input(usr,"Enter the new assignments uid. This cannot be changed. Spaces are not allowed.","New Assignment UID", "") as null|text, MAX_NAME_LEN, 1, 0,1)
			if(select_name)
				connected_faction.rebuild_all_assignments()
				for(var/datum/assignment/assignment in connected_faction.all_assignments)
					if(assignment.uid == select_name)
						to_chat(usr, "Error! An assignment with that UID already exists")
						return 1
				var/select_title = sanitizeName(input(usr,"Enter Assignment Rank 1 Title.","Create Starting Title", "") as null|text, MAX_NAME_LEN, 1, 0)
				if(select_title)
					if(x != selected_assignmentcategory2)
						to_chat(usr, "Your inputs expired because someone used the terminal first.")
						SSnano.update_uis(src)
						return 1
					var/datum/assignment/new_assignment = new()
					new_assignment.parent = selected_assignmentcategory2
					new_assignment.name = select_title
					new_assignment.uid = select_name
					new_assignment.cryo_net = "Last Known Cryonet"
					selected_assignmentcategory2.assignments |= new_assignment
					to_chat(usr, "Assignment successfully created.")
					var/datum/accesses/access = new()
					access.name = select_title
					access.pay = 0
					access.auth_level = 0
					access.auth_req = 0
					access.expense_limit = 0
					new_assignment.accesses |= access
		if("edit_assignmentcategory")
			var/curr_name = selected_assignmentcategory.name
			var/select_name = sanitizeName(input(usr,"Enter new assignment category name.","Edit Assignment Category", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(curr_name != selected_assignmentcategory.name)
					to_chat(usr, "Your inputs expired because someone used the terminal first.")
					SSnano.update_uis(src)
					return 1
				selected_assignmentcategory.name = select_name
		if("change_rank_wage")
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			if(istype(copy))
				var/new_pay = input("Enter new wage. This wage is paid every thirty minutes.","Rank 1 Wage") as null|num
				if(!new_pay && new_pay != 0) return 1
				copy.pay = new_pay
			else
				selected_assignment.accesses |= new /datum/accesses()
		
		
		if("change_auth_level")
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			if(istype(copy))
				var/new_pay = input("Enter new authority level. This assignment can modify those with the same or lower authority requirement.","Authority Requirement", copy.auth_level) as null|num
				if(!new_pay && new_pay != 0) return 1
				copy.auth_level = new_pay
			else
				selected_assignment.accesses |= new /datum/accesses()
		
		if("change_auth_req")
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			if(istype(copy))
				var/new_pay = input("Enter new authority level. This assignment can modify those with the same or lower authority requirement.","Authority Requirement", copy.auth_req) as null|num
				if(!new_pay && new_pay != 0) return 1
				copy.auth_req = new_pay
			else
				selected_assignment.accesses |= new /datum/accesses()

		
		if("edit_rank_title")
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			if(istype(copy))
				var/curr_name = copy.name
				var/select_name = sanitize(input(usr,"Enter new title.","New Title", curr_name) as null|text, MAX_NAME_LEN)
				if(select_name)
					if(curr_name != copy.name)
						to_chat(usr, "Your inputs expired because someone used the terminal first.")
						SSnano.update_uis(src)
						return 1
					copy.name = select_name
			else
				selected_assignment.accesses |= new /datum/accesses()

		if("delete_assignmentcategory")
			if(selected_assignmentcategory.assignments.len)
				to_chat(usr,"You must delete all assignments inside a category before removing the category.")
				return
			var/choice = input(usr,"Are you sure you want to delete this assignment category?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				connected_faction.assignment_categories -= selected_assignmentcategory
				qdel(selected_assignmentcategory)
				to_chat(usr, "Assignment Category successfully deleted.")
			menu = DCORE_ASSIGNMENTMENU
		if("delete_assignment")
			var/choice = input(usr,"Are you sure you want to delete this assignment? All ranking data will be lost.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				selected_assignmentcategory.assignments -= selected_assignment
				qdel(selected_assignment)
				connected_faction.rebuild_all_assignments()
				to_chat(usr, "Assignment successfully deleted.")
			menu = prior_menu
		if("view_access")
			viewing_ranks = 0
		if("view_ranks")
			viewing_ranks = 1
			selected_rank = 1
		if("create_rank")
			var/select_name = sanitizeName(input(usr,"Enter new rank title.","New rank title", "") as null|text, MAX_NAME_LEN, 1, 0)

			if(select_name)
				var/new_pay = input("Enter new rank wage.","Rank Wage") as null|num
				if(!new_pay && new_pay != 0) return 1
				var/datum/accesses/copy2 = selected_assignment.accesses[selected_assignment.accesses.len]
				var/datum/accesses/copy = new()
				selected_assignment.accesses |= copy
				if(copy2)
					copy.expense_limit = copy2.expense_limit
					copy.accesses = copy2.accesses.Copy()
				copy.name = select_name
				copy.pay = new_pay
				to_chat(usr, "Rank successfully created.")
		if("delete_rank")
			if(selected_assignment.accesses.len < 2)
				to_chat(usr, "You cannot delete the first rank. Delete the whole assignment instead.")
				return 0
			var/choice2 = input(usr, "Are you sure you want to delete the highest rank?") in list("Confirm", "Cancel")
			if(choice2 == "Cancel") return 1
			selected_assignment.accesses.Cut(selected_assignment.accesses.len)
			to_chat(usr, "Rank successfully deleted.")
		if("pick_access")
			var/datum/access_category/category = locate(href_list["selected_ref"])
			var/ind = text2num(href_list["selected_ind"])
			var/x = category.accesses[ind]
			if(selected_rank > selected_assignment.accesses.len)
				selected_rank = selected_assignment.accesses.len
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			var/list/all_access = copy.accesses
			if(all_access.Find(x))
				all_access -= x
			else
				all_access |= x


		if("money_settle")
			connected_faction.pay_debt()
		if("req1_change")
			var/selected_uid = input(usr,"How many any-rank promotion votes required? 100 is maximum", "Enter Access Number") as null|num
			if(!selected_uid || selected_uid > 100)
				to_chat(usr, "Invalid number.")
				return 1
			connected_faction.all_promote_req = selected_uid
		if("req3_change")
			var/selected_uid = input(usr,"How many rank 3+ promotion votes required? 100 is maximum", "Enter Access Number") as null|num
			if(!selected_uid || selected_uid > 100)
				to_chat(usr, "Invalid number.")
				return 1
			connected_faction.three_promote_req = selected_uid
		if("req5_change")
			var/selected_uid = input(usr,"How many rank 5+ promotion votes required? 100 is maximum", "Enter Access Number") as null|num
			if(!selected_uid || selected_uid > 100)
				to_chat(usr, "Invalid number.")
				return 1
			connected_faction.five_promote_req = selected_uid
		if("add_cryo")
			var/select_name = sanitizeName(input(usr,"Enter new cryo network name.","Add Cryo-net", "") as null|text, MAX_NAME_LEN, 1, 0)
			if(select_name)
				if(select_name in connected_faction.cryo_networks || select_name == "default")
					to_chat(usr, "Their is already a cryo network with this name.")
					return 1
				connected_faction.cryo_networks |= select_name
			else
				to_chat(usr, "Invalid cryo network name")
		if("remove_cryo")
			var/choice = input(usr,"Choose which cryo network to delete.","Remove Cryo-net",null) as null|anything in connected_faction.cryo_networks
			if(choice)
				connected_faction.cryo_networks -= choice
		if("edit_assignment_cryonet")
			var/list/choices = connected_faction.cryo_networks.Copy()
			choices |= "Last Known Cryonet"
			choices |= "default"
			var/choice = input(usr,"Choose which cryo network the assignment should use.","Choose Cryo-net",null) as null|anything in choices
			if(choice)
				selected_assignment.cryo_net = choice
		if("increase_selected_rank")
			if(selected_rank < selected_assignment.accesses.len)
				selected_rank++
		if("decrease_selected_rank")
			if(selected_rank != 1)
				selected_rank--
		if("change_expense_limit")
			var/datum/accesses/copy = selected_assignment.accesses[selected_rank]
			if(istype(copy))
				var/new_pay = input("Enter new expense limit. Expenses are used when approving orders and paying invoices with an expense card.","Change expense limit") as null|num
				if(!new_pay && new_pay != 0) return 1
				copy.expense_limit = new_pay
			else
				selected_assignment.accesses[selected_rank] = new /datum/accesses()
		
		if("print_expense")
			if(connected_faction.last_expense_print > world.realtime)
				to_chat(usr, "Your  print was rejected. You have printed an expense card in the last 3 minutes.")
				return
			var/obj/item/weapon/card/expense/expense = new()
			expense.ctype = 1
			expense.linked = connected_faction.uid
			connected_faction.last_expense_print = world.realtime + 3 MINUTES
			playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			expense.forceMove(get_turf(program.computer))
		if("devalidate_expense")
			var/choice = input(usr,"This will devalidate all existing expense cards, and you will need to print new ones.") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				devalidate_expense_cards(1, connected_faction.uid)
	SSnano.update_uis(src)