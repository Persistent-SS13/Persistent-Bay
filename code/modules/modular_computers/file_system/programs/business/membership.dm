/datum/computer_file/program/membership
	filename = "membership"
	filedesc = "Religion/Club Management"
	nanomodule_path = /datum/nano_module/program/membership
	program_icon_state = "comm"
	program_menu_icon = "note"
	extended_desc = "Used to create membership contracts, view the roster and remove existing members."
	requires_ntnet = TRUE
	size = 8
	required_access = core_access_command_programs
	business = 1
	required_module = /datum/business_module/social
	category = PROG_OFFICE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN
/datum/nano_module/program/membership
	name = "Religion/Club Management"
	var/menu = 1

	var/title = ""

	var/body = ""


/datum/nano_module/program/membership/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder

	data["connected_faction"] = connected_faction.name
	data["src"] = "\ref[src]"
	data["menu"] = menu
	if(menu == 1)
		var/list/members = connected_faction.get_members()
		var/list/online_members = list()
		var/list/offline_members = list()
		for(var/datum/recurring_contract/contract in members)
			offline_members |= contract
			for(var/client/C in GLOB.clients)
				if(C.mob && C.mob.real_name == contract.payer)
					online_members |= contract
					offline_members -= contract
		var/list/formatted_online_members[0]
		for(var/datum/recurring_contract/contract in online_members)
			formatted_online_members[++formatted_online_members.len] = list("name" = "[contract.payer]", "ref" = "\ref[contract]")
		data["online_members"] = formatted_online_members
		var/list/formatted_offline_members[0]
		for(var/datum/recurring_contract/contract in offline_members)
			formatted_offline_members[++formatted_offline_members.len] = list("name" = "[contract.payer]", "ref" = "\ref[contract]")
		data["offline_members"] = formatted_offline_members

	if(menu == 2)
		data["title"] = title
		data["body"] = body
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "membership.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/membership/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!user_id_card) return

	switch(href_list["action"])
		if("change_menu")
			menu = text2num(href_list["menu_target"])

		if("remove_member")
			var/datum/recurring_contract/contract = locate(href_list["ref"])
			var/choice = input(usr,"This will remove the member from the voluntary member list. Are you sure?") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				contract.payee_cancelled = 1


		if("new_member")
			var/obj/item/weapon/paper/contract/recurring/contract = new()
			contract.sign_type = CONTRACT_PERSON

			contract.contract_payee = connected_faction.uid
			contract.contract_desc = "Membership contract to join [connected_faction.name]"
			contract.contract_title = "Membership contract to join [connected_faction.name]"
			contract.additional_function = CONTRACT_SERVICE_MEMBERSHIP
			contract.name = "[connected_faction.name] Membership Contract"
			var/t = {"
					<font face='Verdana' color=blue>
						<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
							<tr>
								<td>
									<center><h1>Membership Contract for [connected_faction.name]</h1></center>
								</td>
							</tr>
							<tr>
								<td>
									<i>You may leave the organization at any time by canceling this contract through the personal management program.</i>
								</td>
							</tr>
							<tr>
								<td>
									<h3>Status</h3>*Unsigned*<br>
								</td>
							</tr>
						</table>
					</font>
			"}
			contract.info = t
			contract.loc = get_turf(program.computer)
			contract.update_icon()
			menu = 1

		if("edit_title")
			var/newtitle = sanitize(input(user,"Enter title for your message:", "Message title", title), 100)
			if(newtitle)
				title = newtitle

		if("edit_body")
			var/oldtext = html_decode(body)
			oldtext = replacetext(oldtext, "\[br\]", "\n")
			var/newtext = sanitize(replacetext(input(usr, "Enter your message. You may use most tags from paper formatting", "Message Editor", oldtext) as message|null, "\n", "\[br\]"), 20000)
			if(newtext)
				body = newtext

		if("send")
			if(title && title != "" && body && body != "")
				var/list/members = connected_faction.get_members()
				for(var/datum/recurring_contract/contract in members)
					Send_Email(contract.payer, connected_faction.name, title, body)
				to_chat(usr, "Email sent successfully.")
				title = ""
				body = ""
				menu = 1

	SSnano.update_uis(src)
	return 1
