/datum/computer_file/program/invoicing
	filename = "invoicing-program"
	filedesc = "Organization Invoice Creation"
	nanomodule_path = /datum/nano_module/program/invoicing
	program_icon_state = "supply"
	program_menu_icon = "cart"
	extended_desc = "A tool for creating digital invoices that act as one time payment processors for networks to recieve payment from individual accounts."
	size = 2
	available_on_ntnet = 1
	requires_ntnet = 1
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

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

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		var/newtext = sanitize(input(usr, "Enter the reason for the invoice, used in related transactions.", "Change reason", reason) as message|null, MAX_TEXTFILE_LENGTH)
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
	if(amount < 0) return
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
	t += "<td></font><font size='4'><b>Swipe Expense Card to confirm transaction.</b></font></center></font>"
	var/obj/item/weapon/paper/invoice/invoice = new()
	invoice.info = t
	invoice.purpose = reason
	invoice.transaction_amount = amount
	invoice.linked_faction = connected_faction.uid
	invoice.loc = get_turf(program.computer)
	playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
	invoice.name = "[connected_faction.abbreviation] digital invoice"
	invoice.salesperson = idname
	

	
/obj/item/weapon/paper/invoice
	name = "Invoice"
	var/transaction_amount
	var/linked_faction
	var/paid = 0
	var/purpose = ""
	icon_state = "invoice"
	
	var/salesperson = ""
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
	else if(istype(P, /obj/item/weapon/card/expense))
		var/datum/world_faction/connected_faction = get_faction(linked_faction)
		if(!connected_faction) return
		var/datum/money_account/target_account = connected_faction.central_account
		var/obj/item/weapon/card/expense/expense_card = P
		if(expense_card.pay(transaction_amount, user, src))
			var/account_name
			if(expense_card.ctype == 1)
				var/datum/world_faction/fac = get_faction(expense_card.linked)
				account_name = fac.name
			else
				var/datum/small_business/bus = get_business(expense_card.linked)
				account_name = bus.name
			var/datum/transaction/Te = new("[account_name]", purpose, transaction_amount, "Digital Invoice")
			target_account.do_transaction(Te)
			paid = 1
			if(istype(connected_faction, /datum/world_faction/business))
				var/datum/world_faction/business/business_faction = connected_faction
				business_faction.sales_objectives(account_name, 2)
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account_name]")
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
		var/datum/money_account/linked_account = get_account_record(usr.real_name)
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
		var/final_amount = transaction_amount
		if(istype(connected_faction, /datum/world_faction/business))
			var/datum/world_faction/business/business_faction = connected_faction
			business_faction.sales_objectives(usr.real_name, 1)
			if(business_faction.commission)
				var/datum/money_account/sales_account = get_account_record(salesperson)
				if(sales_account)
					var/commission_amount = round(final_amount/100*business_faction.commission)
					if(commission_amount)
						final_amount -= commission_amount
						var/datum/transaction/T = new("[connected_faction.name] (via invoice commission)", "Commission", commission_amount, "Digital Invoice")
						sales_account.do_transaction(T)
		var/datum/transaction/T = new("[connected_faction.name] (via digital invoice)", purpose, -transaction_amount, "Digital Invoice")
		linked_account.do_transaction(T)
		var/datum/transaction/Te = new("[linked_account.owner_name]", purpose, final_amount, "Digital Invoice")
		target_account.do_transaction(Te)
		paid = 1
		
		info = replacetext(info, "*Unpaid*", "*Paid*")
		info = replacetext(info, "*None*", "[linked_account.owner_name]")
		to_chat(usr, "Payment succesful")
		update_icon()
		
/obj/item/weapon/paper/invoice/import
	name = "Import invoice"
	var/datum/supply_order/linked_order
	var/true_amount = 0
	
/obj/item/weapon/paper/invoice/import/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	else if(istype(P, /obj/item/weapon/card/id))
		if(!linked_order) return
		if(paid) return 1
		var/datum/world_faction/connected_faction = get_faction(linked_faction)
		if(!connected_faction) return
		var/datum/money_account/target_account = connected_faction.central_account
		var/obj/item/weapon/card/id/id = P
		if(!id.valid) return 0
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
			var/faction_cut = transaction_amount - true_amount
			var/datum/transaction/T = new("Import ([linked_order.object.name]) by [connected_faction.name]", purpose, -transaction_amount, "Import Invoice")
			account.do_transaction(T)
			//transfer the money
			var/datum/transaction/Te = new("[account.owner_name]", purpose, faction_cut, "Import Invoice")
			target_account.do_transaction(Te)
			paid = 1
			connected_faction.pending_orders -= linked_order
			connected_faction.approved_orders += linked_order
			linked_order.paidby = account.owner_name
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account.owner_name]")
			to_chat(user, "Payment succesful")
			update_icon()
		return
	else if(istype(P, /obj/item/weapon/card/expense))
		if(paid) return
		if(!linked_order) return
		var/datum/world_faction/connected_faction = get_faction(linked_faction)
		if(!connected_faction) return
		var/datum/money_account/target_account = connected_faction.central_account
		var/obj/item/weapon/card/expense/expense_card = P
		if(expense_card.pay(transaction_amount, user, src))
			var/account_name
			if(expense_card.ctype == 1)
				var/datum/world_faction/fac = get_faction(expense_card.linked)
				account_name = fac.name
			else
				var/datum/small_business/bus = get_business(expense_card.linked)
				account_name = bus.name
			var/faction_cut = transaction_amount - true_amount
			var/datum/transaction/Te = new("[account_name]", purpose, faction_cut, "Import Invoice")
			target_account.do_transaction(Te)
			paid = 1
			connected_faction.pending_orders -= linked_order
			connected_faction.approved_orders += linked_order
			linked_order.paidby = account_name
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account_name]")
			to_chat(user, "Payment succesful")
			update_icon()
		return
	..()
/obj/item/weapon/paper/invoice/import/Topic(href, href_list)
	if(!linked_order)
		return
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
		
		var/faction_cut = transaction_amount - true_amount
		var/datum/transaction/T = new("Import ([linked_order.object.name]) by [connected_faction.name]", purpose, -transaction_amount, "Import Invoice")
		linked_account.do_transaction(T)
		//transfer the money
		var/datum/transaction/Te = new("[linked_account.owner_name]", purpose, faction_cut, "Import Invoice")
		target_account.do_transaction(Te)
		paid = 1
		connected_faction.pending_orders -= linked_order
		connected_faction.approved_orders += linked_order
		linked_order.paidby = linked_account.owner_name
		info = replacetext(info, "*Unpaid*", "*Paid*")
		info = replacetext(info, "*None*", "[linked_account.owner_name]")
		to_chat(usr, "Payment succesful")
		update_icon()
		return
	..()	
		
		
/obj/item/weapon/paper/invoice/business
	var/linked_business
		
		
/obj/item/weapon/paper/invoice/business/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	else if(istype(P, /obj/item/weapon/card/id))
		if(paid) return 1
		var/datum/small_business/connected_business = get_business(linked_business)
		if(!connected_business) return
		var/datum/money_account/target_account = connected_business.central_account
		var/obj/item/weapon/card/id/id = P
		if(!id.valid) return 0
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
			var/datum/transaction/T = new("[connected_business.name] (via digital invoice)", purpose, -transaction_amount, "Digital Invoice")
			account.do_transaction(T)
			//transfer the money
			var/datum/transaction/Te = new("[account.owner_name]", purpose, transaction_amount, "Digital Invoice")
			target_account.do_transaction(Te)
			connected_business.pay_tax(transaction_amount)
			connected_business.sales_short += transaction_amount
			paid = 1
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account.owner_name]")
			to_chat(user, "Payment succesful")
			update_icon()
		return
	else if(istype(P, /obj/item/weapon/card/expense))
		if(paid) return
		var/datum/small_business/connected_business = get_business(linked_business)
		if(!connected_business) return
		var/datum/money_account/target_account = connected_business.central_account
		var/obj/item/weapon/card/expense/expense_card = P
		if(expense_card.pay(transaction_amount, user, src))
			var/account_name
			if(expense_card.ctype == 1)
				var/datum/world_faction/fac = get_faction(expense_card.linked)
				account_name = fac.name
			else
				var/datum/small_business/bus = get_business(expense_card.linked)
				account_name = bus.name
			var/datum/transaction/Te = new("[account_name]", purpose, transaction_amount, "Digital Invoice")
			target_account.do_transaction(Te)
			paid = 1
			connected_business.pay_tax(transaction_amount)
			connected_business.sales_short += transaction_amount
			info = replacetext(info, "*Unpaid*", "Paid")
			info = replacetext(info, "*None*", "[account_name]")
			to_chat(user, "Payment succesful")
			update_icon()
		return
	..()
/obj/item/weapon/paper/invoice/business/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		if(paid) return 1
		var/datum/small_business/connected_business = get_business(linked_business)
		if(!connected_business) return
		var/datum/money_account/target_account = connected_business.central_account
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
		var/datum/transaction/T = new("[connected_business.name] (via digital invoice)", purpose, -transaction_amount, "Digital Invoice")
		linked_account.do_transaction(T)
		var/datum/transaction/Te = new("[linked_account.owner_name]", purpose, transaction_amount, "Digital Invoice")
		target_account.do_transaction(Te)
		paid = 1
		connected_business.pay_tax(transaction_amount)
		connected_business.sales_short += transaction_amount
		info = replacetext(info, "*Unpaid*", "*Paid*")
		info = replacetext(info, "*None*", "[linked_account.owner_name]")
		to_chat(usr, "Payment succesful")
		update_icon()
		return
	..()

		