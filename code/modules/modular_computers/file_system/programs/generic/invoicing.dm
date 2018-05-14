/datum/computer_file/program/invoicing
	filename = "invoicing-program"
	filedesc = "Invoicing creation"
	nanomodule_path = /datum/nano_module/program/invoicing
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A tool for creating digital invoices that act as one time payment processors for networks to recieve payment from individual accounts. ."
	size = 21
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/nano_module/program/invoicing
	name = "Invoicing program"
	var/screen = 1		// 0: Ordering menu, 1: Statistics 2: Shuttle control, 3: Orders menu
	var/selected_category
	var/list/category_names
	var/list/category_contents
	var/current_security_level
	var/reason
	var/amount = 0
/datum/nano_module/program/invoicing/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		program.computer.kill_program()
	data["faction_name"] = connected_faction.name
	data["credits"] = connected_faction.central_account.money
	data["can_print"] = can_print()
	data["screen"] = screen
	data["amount"] = amount
	data["reason"] = reason ? reason : "Unset"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "invoicing.tmpl", name, 1050, 500, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/invoicing/Topic(href, href_list)
	if(..())
		return 1
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1

	if(href_list["change_reason"])
		var/newtext = sanitize(input(usr, "Enter the reason for the invoice, used in related transacrtions.", "Change reason", reason) as message|null, MAX_TEXTFILE_LENGTH)
		if(!newtext)
			to_chat(usr,"Text was not valid.")
			return 1
		reason = newtext
		return 1

	if(href_list["change_amount"])
		var/newtext = input("Invoice amount", "Invoice amount", amount) as null|num
		if(!newtext)
			to_chat(usr,"You cannot create an invoice for nothing.")
			return 1
		amount = newtext
		return 1
	if(href_list["finish"])
		if(!amount || !reason || reason == "")
			to_chat(usr,"You must have a valid amount and reason before you can print the invoice.")
			return 1
		print_invoice(usr)
		amount = 0
		reason = null
		return 1

/datum/nano_module/program/invoicing/proc/can_print()
	var/obj/item/modular_computer/MC = nano_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/nano_module/program/invoicing/proc/print_invoice(var/mob/user)
	var/datum/world_faction/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!connected_faction)
		return 1
	var/idname = "*None Provided*"
	var/idrank = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
		idrank = H.get_assignment()
	else if(issilicon(user))
		idname = user.real_name
	var/t = ""
	t += "<font face='Verdana' color=blue><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><center></td><tr><td><H1>[connected_faction.name]</td>"
	t += "<tr><td><br><b>Status:</b>*Unpaid*<br>"
	t += "<b>Total:</b> [amount] $$ Ethericoins<br><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
	t += "<td>Authorized by:<br>[idname] [idrank]<br><td>Paid by:<br>*None*</td></tr></table><br></td>"
	t += "<tr><td><h3>Reason</H3><font size = '1'>[reason]<br></td></tr></table><br><table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>"
	t += "<td></font><font size='4'><b>Swipe ID to confirm transaction.</b></font></center></font>"
	var/obj/item/weapon/paper/invoice/invoice = new()
	invoice.info = t
	invoice.purpose = reason
	invoice.transaction_amount = amount
	invoice.linked_faction = connected_faction.uid
	invoice.loc = program.computer.loc
	invoice.name = "[connected_faction.abbreviation] digital invoice"
/obj/item/weapon/paper/invoice
	name = "Invoice"
	var/transaction_amount
	var/linked_faction
	var/paid = 0
	var/purpose = ""
	icon_state = "invoice"
/obj/item/weapon/paper/invoice/update_icon()
	if(paid)
		icon_state = "invoice-paid"
	else
		icon_state = "invoice"
/obj/item/weapon/paper/invoice/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	if(src.Adjacent(user) && !paid)
		info2 += "<br><A href='?src=\ref[src];pay=1'>Or enter account info here.</A>"
	else
		info2 += "<br>Or enter account info here."
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/invoice/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	else if(istype(P, /obj/item/weapon/card/id))
		if(paid) return 1
		var/datum/world_faction/connected_faction = get_faction(linked_faction)
		if(!connected_faction) return
		var/datum/money_account/target_account = connected_faction.central_account
		var/obj/item/weapon/card/id/id = P
		var/datum/money_account/account = get_account(id.associated_account_number)
		if(!account) return
		if(account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
			var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
			if(account.remote_access_pin != attempt_pin)
				to_chat(user, "Unable to access account: incorrect credentials.")
				return

		if(transaction_amount > account.money)
			to_chat(user, "Unable to complete transaction: insufficient funds.")
			return
		else
			var/datum/transaction/T = new("[connected_faction.name] (via digital invoice)", purpose, -transaction_amount, "Digital Invoice")
			account.do_transaction(T)
			//transfer the money
			var/datum/transaction/Te = new("[account.owner_name]", purpose, transaction_amount, "Digital Invoice")
			target_account.do_transaction(Te)
			paid = 1
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account.owner_name]")
			to_chat(user, "Payment succesful")
			update_icon()
		return

	..()
/obj/item/weapon/paper/invoice/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		if(paid) return 1
		var/datum/world_faction/connected_faction = get_faction(linked_faction)
		if(!connected_faction) return
		var/datum/money_account/target_account = connected_faction.central_account
		var/datum/money_account/linked_account
		var/attempt_account_num = input("Enter account number to pay the digital invoice with.", "account number") as num
		var/attempt_pin = input("Enter pin code", "Account pin") as num
		linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
		if(linked_account)
			if(linked_account.suspended)
				linked_account = null
				to_chat(usr, "\icon[src]<span class='warning'>Account has been suspended.</span>")
			if(transaction_amount > linked_account.money)
				to_chat(usr, "Unable to complete transaction: insufficient funds.")
				return
		else
			to_chat(usr, "\icon[src]<span class='warning'>Account not found.</span>")
		if(!linked_account) return
		var/datum/transaction/T = new("[connected_faction.name] (via digital invoice)", purpose, -transaction_amount, "Digital Invoice")
		linked_account.do_transaction(T)
		var/datum/transaction/Te = new("[linked_account.owner_name]", purpose, transaction_amount, "Digital Invoice")
		target_account.do_transaction(Te)
		paid = 1
		info = replacetext(info, "*Unpaid*", "*Paid*")
		info = replacetext(info, "*None*", "[linked_account.owner_name]")
		to_chat(usr, "Payment succesful")
		update_icon()