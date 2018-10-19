GLOBAL_LIST_EMPTY(all_world_factions)
GLOBAL_LIST_EMPTY(all_business)

// CONTRACTS


/datum/proc/contract_signed(var/obj/item/weapon/paper/contract/contract)
	return 0
/datum/proc/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	return 0
/obj/item/weapon/paper/contract
	name = "contract"
	var/required_cash = 0
	var/datum/linked
	var/cancelled = 0
	var/signed = 0
	var/signed_by = ""
	var/approved = 0
	var/purpose = ""
	var/datum/money_account/signed_account
	var/ownership = 1 // how many stocks the contract is worth (if a stock contract)
	var/pay_to = ""
	var/created_by = ""
	var/func = 1
	icon_state = "contract"
	
/obj/item/weapon/paper/contract/proc/is_solvent()
	if(signed_account)
		if(signed_account.money < required_cash)
			return 0
		if(signed_account.reserved > signed_account.money)
			return 0
		if(signed_account.reserved < required_cash)
			return 0
		return 1
	return 0
/obj/item/weapon/paper/contract/after_load()
	cancel()
	update_icon()
/obj/item/weapon/paper/contract/update_icon()
	if(approved)
		icon_state = "contract-approved"
	else if(cancelled || !linked)
		icon_state = "contract-cancelled"
	else if(signed)
		icon_state = "contract-pending"
	else
		icon_state = "contract"
/obj/item/weapon/paper/contract/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	if(cancelled || !linked)
		info2 += "<br>This contract has been cancelled. Any pending charges have been dropped, this can be shredded."
	else if(approved)
		info2 += "<br>This contract has been finalized. Any pending charges have gone through, this is just for record keeping."
	else if(signed)
		info2 += "<br>This contract has been signed and is pending finalization. Any pending charges will go through when the deal is finalized."
	else if(src.Adjacent(user) && !signed)
		info2 += "<br><A href='?src=\ref[src];pay=1'>Or enter account info here.</A>"
	else
		info2 += "<br>Or enter account info here."
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/contract/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	else if(istype(P, /obj/item/weapon/card/id))
		if(signed || !linked || approved || cancelled) return 1
		var/obj/item/weapon/card/id/id = P
		if(!id.valid) return 0
		
		if(required_cash)
			var/datum/money_account/account = get_account(id.associated_account_number)
			if(!account) return
			if(account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
				var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
				if(account.remote_access_pin != attempt_pin)
					to_chat(user, "Unable to access account: incorrect credentials.")
					return

			if(required_cash > account.money-account.reserved)
				to_chat(user, "Unable to complete transaction: insufficient funds.")
				return
			signed_account = account
			signed_account.reserved += required_cash
		signed_by = id.registered_name
		if(linked.contract_signed(src))
			signed = 1
			info = replacetext(info, "*Unsigned*", "[signed_account.owner_name]")
		else
			signed_by = ""
			signed_account = null
		update_icon()
		return 1
	..()
/obj/item/weapon/paper/contract/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		if(signed || !linked || approved || cancelled) return 1
		var/datum/money_account/linked_account
		var/attempt_account_num = input("Enter account number to pay the contract with.", "account number") as num
		var/attempt_pin = input("Enter pin code", "Account pin") as num
		linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
		if(linked_account)
			if(linked_account.suspended)
				linked_account = null
				to_chat(usr, "\icon[src]<span class='warning'>Account has been suspended.</span>")
			if(required_cash > linked_account.money-linked_account.reserved)
				to_chat(usr, "Unable to complete transaction: insufficient funds.")
				return
			signed_account = linked_account
			signed_account.reserved += required_cash
		else
			to_chat(usr, "\icon[src]<span class='warning'>Account not found.</span>")
			return
		signed_by = signed_account.owner_name
		if(linked.contract_signed(src))
			signed = 1
			info = replacetext(info, "*Unsigned*", "[signed_account.owner_name]")
		else
			signed_by = ""
			signed_account = null
		update_icon()
	..()	
/obj/item/weapon/paper/contract/proc/cancel()
	if(linked)
		linked.contract_cancelled(src)
	if(signed_account)
		signed_account.reserved -= required_cash
		if(signed_account.reserved < 0)
			signed_account.reserved = 0
	cancelled = 1
	info = replacetext(info, "*Unsigned*", "*Cancelled*")
	update_icon()
/obj/item/weapon/paper/contract/proc/finalize()
	if(!signed_by || signed_by == "")
		return 0
	if(required_cash && (!signed_account || signed_account.money < required_cash))
		return 0
	if(required_cash)
		var/datum/transaction/T = new("[pay_to] (via digital contract)", purpose, -required_cash, "Digital Contract")
		signed_account.do_transaction(T)
		signed_account.reserved -= required_cash
		if(signed_account.reserved < 0)
			signed_account.reserved = 0
	approved = 1
	update_icon()
	return 1
// PROPOSALS


/datum/proposal
	var/name = "Unnamed proposal"
	var/started_by = ""
	var/required = 51
	var/support = 0
	var/denyrequired = 49
	var/deny = 0
	var/connected_uid = ""
	var/connected_type = 1 // 1 = faction, 2 = business
	var/list/supporters = list() //format = list(real_name = "10")
	var/list/deniers = list()
	var/func = 1
	var/change = ""

/datum/proposal/proc/calculate_support()	
	var/new_support = 0
	for(var/x in supporters)
		new_support += text2num(supporters[x])
	support = new_support
	if(support >= required)
		approved()
		return support
	var/new_deny = 0
	for(var/x in deniers)
		new_deny += text2num(deniers[x])
	deny = deny
	if(deny >= denyrequired)
		denied()
		return deny
	
/datum/proposal/proc/get_support()
	var/new_support = 0
	for(var/x in supporters)
		new_support += text2num(supporters[x])
	support = new_support
	return new_support
/datum/proposal/proc/get_deny()
	var/new_support = 0
	for(var/x in deniers)
		new_support += text2num(deniers[x])
	deny = new_support
	return new_support

/datum/proposal/proc/add_support(var/name, var/support)
	if(!name || !support) return
	supporters[name] = support
	deniers -= name
	calculate_support()
/datum/proposal/proc/remove_support(var/name)
	supporters -= name
	calculate_support()
/datum/proposal/proc/add_denial(var/name, var/support)
	if(!name || !support) return
	deniers[name] = support
	supporters -= name
	calculate_support()
	
/datum/proposal/proc/remove_denial(var/name)
	deniers -= name
	calculate_support()	
	
/datum/proposal/proc/approved()
	if(connected_type == 1)
		var/datum/world_faction/connected_faction = get_faction(connected_uid)
		connected_faction.proposal_approved(src)
	else
		var/datum/small_business/connected_business = get_business(connected_uid)
		connected_business.proposal_approved(src)

/datum/proposal/proc/denied()
	if(connected_type == 1)
		var/datum/world_faction/connected_faction = get_faction(connected_uid)
		connected_faction.proposal_denied(src)
	else
		var/datum/small_business/connected_business = get_business(connected_uid)
		connected_business.proposal_denied(src)
	
		
// business

/datum/small_business
	var/name = "" // can should never be changed and must be unique
	var/list/stock_holders = list() // Format list("real_name" = numofstocks) adding up to 100
	var/list/employees = list() // format list("real_name" = employee_data)
	
	var/datum/money_account/central_account
	
	var/ceo_name = ""
	var/ceo_payrate = 100
	var/ceo_title
	var/ceo_dividend = 0
	
	var/stock_holders_dividend = 0
	
	
	var/list/debts = list() // format list("Ro Laren" = "550") real_name = debt amount
	var/list/unpaid = list() // format list("Ro Laren" = numofshifts)
		
	var/list/connected_laces = list()
	
	var/tasks = ""
	var/sales_short = 0
	
	var/list/sales_long = list() // sales over the last 6 active hours
	var/list/proposals = list()
	var/list/proposals_old = list()
	
	var/tax_network = ""
	var/last_id_print = 0
	var/last_expense_print = 0
	var/last_balance = 0
	var/status = 1 // 1 = opened, 0 = closed
		
/datum/small_business/New()
	central_account = create_account(name, 0)

/datum/small_business/proc/get_debt()
	var/debt = 0
	for(var/x in debts)
		debt += text2num(debts[x])
	return debt
/datum/small_business/proc/pay_debt()
	for(var/x in debts)
		var/debt = text2num(debts[x])
		if(!money_transfer(central_account,x,"Postpaid Payroll",debt))
			return 0
		debts -= x
	
/datum/small_business/contract_signed(var/obj/item/weapon/paper/contract/contract)
	if(get_stocks(contract.created_by) < contract.ownership)
		contract.cancel()
		return 0
	if(contract.finalize())
		if(contract.required_cash)
			var/datum/money_account/account = get_account_record(contract.pay_to)
			if(account)
				var/datum/transaction/T = new("[contract.signed_by] (via digital contract)", contract.purpose, contract.required_cash, "Digital Contract")
				account.do_transaction(T)
		transfer_stock(contract.created_by, contract.signed_by, contract.ownership)
		return 1

/datum/small_business/proc/transfer_stock(var/owner, var/new_owner, var/amount)
	var/holding = get_stocks(owner) 
	if(holding < amount)
		return 0
	if(holding == amount)
		stock_holders -= owner
		if(new_owner in stock_holders)
			var/old_holding = get_stocks(new_owner)
			stock_holders[new_owner] = (old_holding + amount)
		else
			stock_holders[new_owner] = amount
	else
		stock_holders[owner] = (holding - amount)
		if(new_owner in stock_holders)
			var/old_holding = get_stocks(new_owner)
			stock_holders[new_owner] = (old_holding + amount)
		else
			stock_holders[new_owner] = amount
			
/datum/small_business/proc/has_proposal(var/real_name)
	for(var/datum/proposal/proposal in proposals)
		if(proposal.started_by == real_name)
			return 1
	return 0
		

	
/datum/small_business/proc/close()
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		clock_out(stack)
	status = 0
	
/datum/small_business/proc/open()
	status = 1
/datum/small_business/proc/is_allowed(var/real_name)
	if(real_name in employees)
		return 1
	if(real_name in stock_holders)
		return 1
	if(real_name == ceo_name)
		return 1
		
/datum/small_business/proc/is_stock_holder(var/real_name)
	if(real_name in stock_holders)
		return 1 
		
/datum/small_business/proc/get_stocks(var/real_name)
	if(real_name in stock_holders)
		return text2num(stock_holders[real_name])
	return 0
/datum/small_business/proc/is_clocked_in(var/real_name)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.get_owner_name() == real_name) return 1
	return 0
	
/datum/small_business/proc/clock_in(var/obj/item/organ/internal/stack/stack)
	if(!stack) return
	connected_laces |= stack
	stack.business_mode = 1
	stack.connected_business = src.name
	stack.duty_status = 1
/datum/small_business/proc/clock_out(var/obj/item/organ/internal/stack/stack)
	connected_laces -= stack
	stack.business_mode = 0
	stack.connected_business = ""
	stack.duty_status = 0
/datum/small_business/proc/proposal_approved(var/datum/proposal/proposal)
	switch(proposal.func)
		if(1)
			if(ceo_name && ceo_name != "")
				var/old_name = ceo_name
				ceo_name = proposal.change
				update_ids(old_name)
			ceo_name = proposal.change
			update_ids(proposal.change)
		if(2)
			if(ceo_name && ceo_name != "")
				var/old_name = ceo_name
				ceo_name = ""
				update_ids(old_name)
				
		if(3)
			ceo_title = proposal.change
			if(ceo_name && ceo_name != "")
				update_ids(ceo_name)
		if(4)
			ceo_payrate = proposal.change
		if(5)
			ceo_dividend = proposal.change
		if(6)
			stock_holders_dividend = proposal.change
			
	if(proposals_old.len > 10)
		central_account.transaction_log.Cut(1,2)
	proposals -= proposal
	proposals_old += "*APPROVED* [proposal.name](Started by [proposal.started_by])"
	
/datum/small_business/proc/proposal_denied(var/datum/proposal/proposal)
	proposals -= proposal
	proposals_old += "*DENIED* [proposal.name] (Started by [proposal.started_by])"
	
/datum/small_business/proc/proposal_cancelled(var/datum/proposal/proposal)
	proposals -= proposal
	proposals_old += "*CANCELLED* [proposal.name] (Started by [proposal.started_by])"

	
/datum/employee_data
	var/name = "" // real_name of the employee
	var/job_title = "New Hire"
	var/pay_rate = 25 // hourly rate of pay
	var/list/accesses = list() 
	var/expense_limit = 0
	var/expenses = 0
	
/datum/small_business/proc/get_expense_limit(var/real_name)
	if(real_name == ceo_name) return 100000
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		return employee.expense_limit
	return 0
	
/datum/small_business/proc/get_expenses(var/real_name)
	if(real_name == ceo_name) return 0
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		return employee.expenses
	return 0

/datum/small_business/proc/add_expenses(var/real_name, amount)
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		employee.expenses += amount
		return 1
	return 0	
	
/datum/small_business/proc/get_employee_data(var/real_name)
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		return employee
	return 0
/datum/small_business/proc/is_employee(var/real_name)
	if(real_name in employees)
		return 1
	return 0	
	
/datum/small_business/proc/add_employee(var/real_name)
	if(real_name in employees)
		return 0
	var/datum/employee_data/employee = new()
	employee.name = real_name
	employees[real_name] = employee
	return 1
	
/datum/small_business/proc/get_title(var/real_name)
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		return employee.job_title
	return 0	
	
/datum/small_business/proc/get_access(var/real_name)
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		return employee.accesses
	return 0	

/datum/small_business/proc/has_access(var/real_name, access)
	if(real_name == ceo_name) return 1
	if(real_name in employees)
		var/datum/employee_data/employee = employees[real_name]
		if(access in employee.accesses)
			return 1
	return 0	
	
	
/datum/small_business/proc/pay_tax(var/amount)
	if(!tax_network || tax_network == "") return 0
	var/datum/world_faction/connected_faction = get_faction(tax_network)
	if(!connected_faction) return 0
	var/datum/transaction/Te = new("Sales Tax from [name]", "Tax", round(amount/100*connected_faction.tax_rate), "Tax Network")
	connected_faction.central_account.do_transaction(Te)
	Te = new("Sales Tax to [connected_faction.name]", "Tax", round(-amount/100*connected_faction.tax_rate), "Tax Network")
	central_account.do_transaction(Te)
	
/datum/small_business/proc/pay_export_tax(var/amount, var/datum/world_faction/connected_faction)
	var/datum/transaction/Te = new("Export from [name]", "Tax", round(amount/100*connected_faction.export_profit), "Tax Network")
	connected_faction.central_account.do_transaction(Te)
	Te = new("Export Tax to [connected_faction.name]", "Tax", round(-amount/100*connected_faction.export_profit), "Tax Network")
	central_account.do_transaction(Te)
	return (amount/100*connected_faction.export_profit)
	
/proc/get_business(var/name)
	var/datum/small_business/found_faction
	for(var/datum/small_business/fac in GLOB.all_business)
		if(fac.name == name) 
			found_faction = fac 
			break
	return found_faction

/proc/get_businesses(var/real_name)	
	var/list/lis = list()
	for(var/datum/small_business/fac in GLOB.all_business)
		if(fac.is_allowed(real_name)) lis |= fac		
	return lis
	
	
// FACTIONs
/proc/get_faction(var/name, var/password)
	if(password)
		var/datum/world_faction/found_faction
		for(var/datum/world_faction/fac in GLOB.all_world_factions)
			if(fac.uid == name)
				found_faction = fac
				break
		if(!found_faction) return
		if(found_faction.password != password) return
		return found_faction
	var/datum/world_faction/found_faction
	for(var/datum/world_faction/fac in GLOB.all_world_factions)
		if(fac.uid == name)
			found_faction = fac
			break
	return found_faction

/proc/get_faction_tag(var/name)
	var/datum/world_faction/fac = get_faction(name)
	if(fac)
		return fac.short_tag
	else
		return "BROKE"

/datum/world_faction
	var/name = "" // can be safely changed
	var/abbreviation = "" // can be safely changed
	var/short_tag = "" // This can be safely changed as long as it doesn't conflict
	var/purpose = "" // can be safely changed
	var/uid = "" // THIS SHOULD NEVER BE CHANGED!
	var/password = "password" // this is used to access the faction, can be safely changed
	var/list/assignment_categories = list()
	var/list/access_categories = list()
	var/list/all_access = list() // format list("10", "11", "12", "13") used to determine which accesses are already given out.
	var/list/all_assignments
	var/datum/records_holder/records
	var/datum/ntnet/network
	var/datum/money_account/central_account
	var/allow_id_access = 0 // allows access off the ID (the IDs access var instead of directly from faction records, assuming its a faction-approved ID
	var/allow_unapproved_ids = 0 // allows ids that are not faction-approved or faction-created to still be used to access doors IF THE registered_name OF THE CARD HAS VALID RECORDS ON FILE or allow_id_access is set to 1
	var/list/connected_laces = list()

	var/all_promote_req = 3
	var/three_promote_req = 2
	var/five_promote_req = 1

	var/payrate = 100
	var/leader_name = ""
	var/list/debts = list() // format list("Ro Laren" = "550") real_name = debt amount
	var/joinable = 0

	var/list/cargo_telepads = list()
	var/list/approved_orders = list()
	var/list/pending_orders = list()

	var/list/cryo_networks = list() // "default" is always a cryo_network
  
	var/list/unpaid = list()
	
	var/tax_rate = 10
	var/import_profit = 10
	var/export_profit = 20
	
	var/hiring_policy = 0 // if hiring_policy, anyone with reassignment can add people to the network, else only people in command a command category with reassignment can add people
	var/last_expense_print = 0
	

/datum/world_faction/after_load()	
	if(!debts)
		debts = list()
	..()
/datum/world_faction/proc/get_duty_status(var/real_name)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.get_owner_name() == real_name)
			return stack.duty_status + 1
	return 0
/datum/world_faction/proc/get_debt()
	var/debt = 0
	for(var/x in debts)
		debt += text2num(debts[x])
	return debt
/datum/world_faction/proc/pay_debt()
	for(var/x in debts)
		var/debt = text2num(debts[x])
		if(!money_transfer(central_account,x,"Postpaid Payroll",debt))
			return 0
		debts -= x

/datum/world_faction/New()
	network = new()
	network.holder = src
	records = new()
	create_faction_account()
/datum/world_faction/proc/rebuild_cargo_telepads()
	cargo_telepads.Cut()
	for(var/obj/machinery/telepad_cargo/telepad in GLOB.cargotelepads)
		if(telepad.req_access_faction == uid)
			telepad.connected_faction = src
			cargo_telepads |= telepad
/datum/world_faction/proc/rebuild_all_access()
	all_access = list()
	for(var/datum/access_category/access_category in access_categories)
		for(var/x in access_category.accesses)
			all_access |= x
	all_access |= "1"
	all_access |= "2"
	all_access |= "3"
	all_access |= "4"
	all_access |= "5"
	all_access |= "6"
	all_access |= "7"
	all_access |= "8"
	all_access |= "9"
	all_access |= "10"
	all_access |= "11"
	all_access |= "12"
	all_access |= "13"
	all_access |= "14"
	all_access |= "15"
	all_access |= "16"
	all_access |= "17"
	all_access |= "18"
	all_access |= "19"
	all_access |= "20"
	
/datum/world_faction/proc/rebuild_all_assignments()
	all_assignments = list()
	for(var/datum/assignment_category/assignment_category in assignment_categories)
		for(var/x in assignment_category.assignments)
			all_assignments |= x
/datum/world_faction/proc/get_assignment(var/assignment)
	if(!assignment) return null
	rebuild_all_assignments()
	for(var/datum/assignment/assignmentt in all_assignments)
		if(assignmentt.uid == assignment) return assignmentt
/datum/records_holder
	var/use_standard = 1
	var/list/custom_records = list() // format-- list("")
	var/list/faction_records = list() // stores all employee record files, format-- list("[M.real_name]" = /datum/crew_record)

/datum/world_faction/proc/get_records()
	return records.faction_records

/datum/world_faction/proc/get_record(var/real_name)
	for(var/datum/computer_file/crew_record/R in records.faction_records)
		if(R.get_name() == real_name)
			return R
	var/datum/computer_file/crew_record/L = Retrieve_Record_Faction(real_name, src)
	return L

/datum/world_faction/proc/in_command(var/real_name)
	var/datum/computer_file/crew_record/R = get_record(real_name)
	if(R)
		var/datum/assignment/assignment = get_assignment(R.assignment_uid)
		if(assignment)
			if(assignment.parent)
				return assignment.parent.command_faction
	return 0

/datum/world_faction/proc/outranks(var/real_name, var/target)
	if(real_name == leader_name)
		return 1
	var/datum/computer_file/crew_record/R = get_record(real_name)
	if(!R) return 0
	var/datum/computer_file/crew_record/target_record = get_record(target)
	if(!target_record) return 1
	var/user_command = 0
	var/target_command = 0
	var/user_rank = R.rank
	var/target_rank = target_record.rank
	var/user_leader = 0
	var/target_leader = 0
	var/same_department = 0
	var/datum/assignment/assignment = get_assignment(R.assignment_uid)
	if(assignment)
		if(assignment.parent)
			user_command = assignment.parent.command_faction
			if(assignment.parent.head_position && assignment.parent.head_position.name == assignment.name)
				user_leader = 1
	else
		return 0
	var/datum/assignment/target_assignment = get_assignment(target_record.assignment_uid)
	if(target_assignment)
		if(target_assignment.any_assign)
			same_department = 1
		if(target_assignment.parent)
			target_command = target_assignment.parent.command_faction
			if(target_assignment.parent.head_position && target_assignment.parent.head_position.name == target_assignment.name)
				target_leader = 1
			if(assignment.parent && target_assignment.parent.name == assignment.parent.name)
				same_department = 1
	else
		return 1
	if(user_command)
		if(!target_command) return 1
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
		if(user_rank >= target_rank) return 1
		else return 0
	if(same_department)
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
		if(user_rank >= target_rank) return 1
		else return 0
	return 0
	
	
	
/datum/world_faction/proc/create_faction_account()
	central_account = create_account(name, 0)
	
/datum/world_faction/proc/proposal_approved(var/datum/proposal/proposal)
	return 0

/datum/world_faction/proc/proposal_denied(var/datum/proposal/proposal)
	return 0
	
/datum/assignment_category
	var/name = ""
	var/list/assignments = list()
	var/datum/assignment/head_position
	var/datum/world_faction/parent
	var/command_faction = 0
	var/member_faction = 1
	var/account_status = 0
	var/datum/money_account/account

/datum/assignment_category/proc/create_account()
	account = create_account(name, 0)

/datum/assignment
	var/name = ""
	var/list/accesses[0]
	var/uid = ""
	var/datum/assignment_category/parent
	var/payscale = 1.0
	var/list/ranks = list() // format-- list("Apprentice Engineer (2)" = "1.1", "Journeyman Engineer (3)" = "1.2")
	var/duty_able = 1
	var/cryo_net = "default"
	var/any_assign = 0 // this makes it so that the assignment can be assigned by anyone with the reassignment access,
	
/datum/accesses
	var/list/accesses = list()
	var/expense_limit = 0
/datum/assignment/after_load()
	..()

/datum/access_category
	var/name = ""
	var/list/accesses = list() // format-- list("11" = "Bridge Access")

/datum/access_category/core
	name = "Core Access"

/datum/access_category/core/New()
	accesses["1"] = "Logistics Control, Leadership"
	accesses["2"] = "Command Machinery"
	accesses["3"] = "Promotion/Demotion Vote"
	accesses["4"] = "Reassignment"
	accesses["5"] = "Edit Employment Records"
	accesses["6"] = "Reset Expenses"
	accesses["7"] = "Suspension/Termination"
	accesses["8"] = "Engineering Programs"
	accesses["9"] = "Medical Programs"
	accesses["10"] = "Security Programs"
	accesses["11"] = "Networking Programs"
	accesses["12"] = "Lock Electronics"
	accesses["13"] = "Import Approval"
	accesses["14"] = "Invoicing & Exports"
	accesses["15"] = "Science Machinery & Programs"
	accesses["16"] = "Shuttle Control & Access"

/obj/faction_spawner
	name = "Name to start faction with"
	var/name_short = "Faction Abbreviation"
	var/name_tag = "Faction Tag"
	var/uid = "faction_uid"
	var/password = "starting_password"
	var/network_name = "network name"
	var/network_uid = "network_uid"
	var/network_password
	var/network_invisible = 0

/obj/faction_spawner/New()
	if(!GLOB.all_world_factions)
		GLOB.all_world_factions = list()
	for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
		if(existing_faction.uid == uid)
			qdel(src)
			return
	var/datum/world_faction/fact = new()
	fact.name = name
	fact.abbreviation = name_short
	fact.short_tag = name_tag
	fact.uid = uid
	fact.password = password
	fact.network.name = network_name
	fact.network.net_uid = network_uid
	if(network_password)
		fact.network.secured = 1
		fact.network.password = network_password
	fact.network.invisible = network_invisible
	GLOB.all_world_factions |= fact
	qdel(src)
	return

/obj/faction_spawner/Nanotrasen
	name = "Nanotrasen Corporate Colony"
	name_short = "Nanotrasen"
	name_tag = "NT"
	uid = "nanotrasen"
	password = "rosebud"
	network_name = "Nanotrasen Network"
	network_uid = "nt_net"

/obj/faction_spawner/Refugee
	name = "Refugee Network"
	name_short = "Refugee Net"
	name_tag = "RG"
	uid = "refugee"
	password = "Hope97"
	network_name = "freenet"
	network_uid = "freenet"
