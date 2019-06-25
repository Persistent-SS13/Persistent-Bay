GLOBAL_LIST_EMPTY(all_world_factions)
GLOBAL_LIST_EMPTY(all_business)

GLOBAL_LIST_EMPTY(recent_articles)


var/PriorityQueue/all_feeds



/datum/proc/contract_signed(var/obj/item/weapon/paper/contract/contract)
	return 0


/datum/proc/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	return 0

/datum/stock_contract

/datum/stock_contract/contract_signed(var/obj/item/weapon/paper/contract/contract)
	var/datum/world_faction/business/connected_faction = get_faction(contract.org_uid)
	if(connected_faction && istype(connected_faction))
		var/datum/stockholder/holder = connected_faction.get_stockholder_datum(contract.created_by)
		if(!holder || holder.stocks < contract.ownership)
			contract.cancelled = 1
			contract.linked = null
			contract.update_icon()
			return 0
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(contract.signed_by)
		if((contract.ownership + R.get_holdings()) > R.get_stock_limit())
			contract.cancelled = 1
			contract.linked = null
			contract.update_icon()
			return 0
		if(contract.finalize())
			var/datum/stockholder/newholder
			newholder = connected_faction.get_stockholder_datum(contract.signed_by)
			if(!newholder)
				newholder = new()
				newholder.real_name = contract.signed_by
				connected_faction.stock_holders[contract.signed_by] = newholder
			newholder.stocks += contract.ownership
			holder.stocks -= contract.ownership
			if(!holder.stocks)
				connected_faction.stock_holders -= holder.real_name

/obj/item/weapon/paper/contract/recurring
	var/sign_type = CONTRACT_BUSINESS
	var/contract_payee = ""
	var/contract_desc = ""
	var/contract_title = ""
	var/additional_function = CONTRACT_SERVICE_NONE
	var/contract_paytype = CONTRACT_PAY_NONE
	var/contract_pay = 0
/obj/item/weapon/paper/contract/recurring/update_icon()
	if(approved)
		icon_state = "contract-approved"
	else if(cancelled)
		icon_state = "contract-cancelled"
	else if(signed)
		icon_state = "contract-pending"
	else
		icon_state = "contract"


/obj/item/weapon/paper/contract/recurring/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	if(sign_type == CONTRACT_PERSON)
		if(cancelled || !linked)
			info2 += "<br>This contract has been cancelled. This can be shredded."
		else if(approved)
			info2 += "<br>This contract has been finalized. This is just for record keeping."
		else if(signed)
			info2 += "<br>This contract has been signed and is pending finalization."
		else if(src.Adjacent(user) && !signed)
			info2 += "<br><A href='?src=\ref[src];pay=1'>Scan lace to sign contract.</A>"
		else
			info2 += "<br>Scan lace to sign contract."
	else
		if(cancelled)
			info2 += "<br>This contract has been cancelled. This can be shredded."
		else if(approved)
			info2 += "<br>This contract has been finalized. This is just for record keeping."
		else if(signed)
			info2 += "<br>This contract has been signed and is pending finalization."
		else if(src.Adjacent(user) && !signed)
			info2 += "<br>This contract must be signed by an organization.<br><A href='?src=\ref[src];pay=1'>Scan or swipe ID linked to organization.</A>"
		else
			info2 += "<br>This contract must be signed by an organization.<br><A href='?src=\ref[src];pay=1'>Scan or swipe ID linked to organization.</A>"


	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/contract/recurring/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		if(signed) return
		if(sign_type == CONTRACT_BUSINESS)
			var/obj/item/weapon/card/id/id = usr.get_idcard()
			if(id)
				if(id.selected_faction == contract_payee)
					to_chat(usr, "An organization cannot sign its own contract.")
					return 0
				var/datum/world_faction/connected_faction = get_faction(id.selected_faction)
				if(connected_faction)
					if(has_access(list(core_access_contracts), list(), usr.GetAccess(connected_faction.uid)))
						if(contract_paytype == CONTRACT_PAY_NONE || contract_pay <= connected_faction.central_account.money)
							var/datum/recurring_contract/new_contract = new()
							new_contract.name = contract_title
							new_contract.payer_type = sign_type

							new_contract.payee = contract_payee

							new_contract.payer = connected_faction.uid
							new_contract.details = contract_desc

							new_contract.auto_pay = contract_paytype
							new_contract.pay_amount = contract_pay
							new_contract.func = additional_function
							new_contract.signer_name = usr.real_name

							GLOB.contract_database.add_contract(new_contract)
							signed = 1
							info = replacetext(info, "*Unsigned*", "[connected_faction.uid]")
							signed_by = usr.real_name
						else
							to_chat(usr, "Insufficent funds to sign contract.")
							return

					else
						to_chat(usr, "Access denied. Cannot sign contracts for [connected_faction.name].")
						return
		else

			var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
			if(!R)
				to_chat(usr, "Record not found. Contact AI.")
				message_admins("record not found for user [usr.real_name]")
				return
			if(contract_paytype == CONTRACT_PAY_NONE || contract_pay <= R.linked_account.money)
				var/datum/recurring_contract/new_contract = new()
				new_contract.name = contract_title
				new_contract.payer_type = sign_type

				new_contract.payee = contract_payee

				new_contract.payer = usr.real_name
				new_contract.details = contract_desc

				new_contract.auto_pay = contract_paytype
				new_contract.pay_amount = contract_pay
				new_contract.func = additional_function
				new_contract.signer_name = usr.real_name

				GLOB.contract_database.add_contract(new_contract)
				signed = 1

				info = replacetext(info, "*Unsigned*", "[usr.real_name]")
				signed_by = usr.real_name
			else
				to_chat(usr, "Insufficent funds to sign contract.")
				return

	..()




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
	var/datum/computer_file/report/crew_record/signed_record

	var/ownership = 0 // how many stocks the contract is worth (if a stock contract)
	var/org_uid = "" // what org this belongs to

	var/pay_to = ""
	var/created_by = ""
	var/func = 1
	icon_state = "contract"

/obj/item/weapon/paper/contract/proc/is_solvent()
	if(signed_account)
		if(signed_account.money < required_cash)
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
		info2 += "<br>This contract has been cancelled. This can be shredded."
	else if(approved)
		info2 += "<br>This contract has been finalized. This is just for record keeping."
	else if(signed)
		info2 += "<br>This contract has been signed and is pending finalization."
	else if(src.Adjacent(user) && !signed)
		info2 += "<br><A href='?src=\ref[src];pay=1'>Scan lace to sign contract.</A>"
	else
		info2 += "<br>Scan lace to sign contract."
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/contract/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	..()
/obj/item/weapon/paper/contract/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
		if(!R)
			to_chat(usr, "Record not found. Contact AI.")
			message_admins("record not found for user [usr.real_name]")
			return
		var/datum/money_account/linked_account = R.linked_account

		if((R.get_holdings() + ownership) > R.get_stock_limit())
			to_chat(usr, "This stock contract will exceed your stock limit.")
			return
		if(linked_account)
			if(linked_account.suspended)
				linked_account = null
				to_chat(usr, "\icon[src]<span class='warning'>Account has been suspended.</span>")
			if(required_cash > linked_account.money)
				to_chat(usr, "Unable to complete transaction: insufficient funds.")
				return
			signed_account = linked_account
			signed_record = R
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


/datum/NewsStory/proc/allowed(var/real_name)
	if(real_name in purchased)
		return 1
	return 0


/datum/NewsStory
	var/name = "None" // headline
	var/image/image1
	var/image/image2
	var/body = ""
	var/author = ""
	var/true_author = ""
	var/publish_date = 0

	var/list/purchased = list()

	var/datum/NewsIssue/parent

	var/uid

	var/announce = 0
	var/cost = 0

/datum/NewsStory/proc/view_story(var/mob/M)
	purchased |= M.real_name
	if(istype(parent.parent.parent))
		parent.parent.parent.article_view_objectives(M.real_name)


/datum/NewsIssue
	var/name = "None"
	var/list/stories = list()
	var/publish_date
	var/publisher = ""

	var/datum/NewsFeed/parent

	var/uid

	var/cost = 0


/datum/NewsFeed
	var/name = "None"
	var/visible = 0
	var/datum/NewsIssue/current_issue
	var/list/all_issues = list()
	var/per_article = 20
	var/per_issue = 60
	var/announcement = "Breaking News!"
	var/last_published = 0
	var/datum/world_faction/business/parent

/datum/NewsFeed/New()
	current_issue = new()
	current_issue.parent = src
	current_issue.name = "[name] News Issue"
	all_feeds.Enqueue(src)


/datum/NewsFeed/proc/publish_issue()

	for(var/obj/machinery/newscaster/caster in allCasters)
		caster.newsAlert("[name] just published a full issue! [current_issue.name]")
	all_issues |= current_issue
	all_feeds.Enqueue(current_issue)
	current_issue = new()
	current_issue.parent = src
	current_issue.name = "[name] News Issue"
	last_published = current_issue.publish_date
	all_feeds.ReSort(src)

/datum/NewsFeed/proc/publish_story(var/datum/NewsStory/story)
	current_issue.stories |= story
	story.parent = current_issue
	if(story.announce)
		for(var/obj/machinery/newscaster/caster in allCasters)
			caster.newsAlert("(From [name]) [announcement] ([story.name])")
	GLOB.recent_articles |= story


/datum/LibraryDatabase
	var/list/books = list()



/datum/small_business
	var/name = "" // can should never be changed and must be unique
	var/list/stock_holders = list() // Format list("real_name" = numofstocks) adding up to 100
	var/list/employees = list() // format list("real_name" = employee_data)

	var/datum/NewsFeed/feed

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
	feed = new()
	feed.name = name
	feed.parent = src
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

/datum/world_faction/proc/close_business()
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace vibrates letting you know that [src.name] is closed for business and you have been automatically clocked out.")
		if(employment_log.len > 100)
			employment_log.Cut(1,2)
		employment_log += "At [stationdate2text()] [stationtime2text()] [stack.owner.real_name] clocked out."
	connected_laces.Cut()
	status = 0

/datum/world_faction/proc/open_business()
	status = 1

/datum/world_faction/proc/get_leadername()
	return leader_name

/datum/world_faction/democratic/get_leadername()
	if(gov && gov.real_name != "")
		return gov.real_name
	else
		return leader_name


/datum/faction_research
	var/points = 0
	var/list/unlocked = list()
	map_storage_saved_vars = "points;unlocked"


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
	var/allow_unapproved_ids = 0 // **THIS VAR NO LONGER MATTERS IDS ARE ALWAYS CONSIDERED APPROVED** allows ids that are not faction-approved or faction-created to still be used to access doors IF THE registered_name OF THE CARD HAS VALID RECORDS ON FILE or allow_id_access is set to 1
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

	var/list/reserved_frequencies = list() // Reserved frequencies that the faction can create encryption keys from.

	var/datum/machine_limits/limits

	var/datum/faction_research/research

	var/status = 1

	var/list/employment_log = list()

	var/objective = ""

	var/datum/material_inventory/inventory

	var/obj/machinery/telepad_cargo/default_telepad
	var/default_telepad_x
	var/default_telepad_y
	var/default_telepad_z
	var/decl/hierarchy/outfit/starter_outfit = /decl/hierarchy/outfit/nexus/starter //Outfit members of this faction spawn with by default

	var/list/service_medical_business = list() // list of all organizations linked into the medical service for this business

	var/list/service_medical_personal = list() // list of all people linked int othe medical service for this business

	var/list/service_security_business = list() // list of all orgs linked to the security services

	var/list/service_security_personal = list() // list of all people linked to the security services

	var/datum/NewsFeed/feed
	var/datum/LibraryDatabase/library

	var/list/people_to_notify = list()

/datum/world_faction/proc/apc_alarm(var/obj/machinery/power/apc/apc)
	var/subject = "APC Alarm at [apc.area.name] ([apc.connected_faction.name])"
	var/body = "On [stationtime2text()] the APC at [apc.area.name] for [apc.connected_faction.name] went into alarm. If you want to unsubscribe to notifications like this use the personal modification program."
	for(var/name in people_to_notify)
		Send_Email(name, sender = src.name, subject, body)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace buzzes letting you know that the APC at [apc.area.name] has gone into alarm.")

/datum/world_faction/proc/employee_health_alarm(var/mob/M)
	for(var/datum/world_faction/faction in GLOB.all_world_factions)
		if(faction == src) continue
		if(M.real_name in faction.service_medical_personal) continue
		if(uid in faction.service_medical_personal)
			faction.health_alarm(M)

/datum/world_faction/proc/health_alarm(var/mob/M)
	var/subject = "Critical Health Alarm for [M.real_name]"
	var/body = "On [stationtime2text()] [M.real_name] is in critical health status. If you want to unsubscribe to notifications like this use the personal modification program."
	for(var/name in people_to_notify)
		Send_Email(name, sender = src.name, subject, body)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace buzzes letting you know that [M.real_name] is in critical health status.")


/proc/spawn_nexus_gov()
	var/datum/world_faction/democratic/nexus = new()
	nexus.name = "Nexus City Government"
	nexus.abbreviation = "NEXUS"
	nexus.short_tag = "NEX"
	nexus.purpose = "To represent the citizenship of Nexus and keep the station operating."
	nexus.uid = "nexus"
	nexus.gov = new()
	var/datum/election/gov/gov_elect = new()
	gov_elect.ballots |= nexus.gov

	nexus.waiting_elections |= gov_elect

	var/datum/election/council_elect = new()
	var/datum/democracy/councillor/councillor1 = new()
	councillor1.title = "Councillor of Justice and Criminal Matters"
	nexus.city_council |= councillor1
	council_elect.ballots |= councillor1

	var/datum/democracy/councillor/councillor2 = new()
	councillor2.title = "Councillor of Budget and Tax Measures"
	nexus.city_council |= councillor2
	council_elect.ballots |= councillor2

	var/datum/democracy/councillor/councillor3 = new()
	councillor3.title = "Councillor of Commerce and Business Relations"
	nexus.city_council |= councillor3
	council_elect.ballots |= councillor3

	var/datum/democracy/councillor/councillor4 = new()
	councillor4.title = "Councillor for Culture and Ethical Oversight"
	nexus.city_council |= councillor4
	council_elect.ballots |= councillor4

	var/datum/democracy/councillor/councillor5 = new()
	councillor5.title = "Councillor for the Domestic Affairs"
	nexus.city_council |= councillor5
	council_elect.ballots |= councillor5

	nexus.waiting_elections |= council_elect

	nexus.network.name = "NEXUSGOV-NET"
	nexus.network.net_uid = "nexus"
	nexus.network.password = ""
	nexus.network.invisible = 0

	GLOB.all_world_factions |= nexus


/datum/world_faction/democratic/New()
	..()

	councillor_assignment = new("Councillor", 30)
	judge_assignment = new("Judge", 30)
	governor_assignment = new("Governor", 45)
	councillor_assignment.name = "Councillor"
	judge_assignment.name = "Judge"
	governor_assignment.name = "Governor"
	governor_assignment.uid = "governor"
	judge_assignment.uid = "judge"
	councillor_assignment.uid = "councillor"
	special_category = new()

	councillor_assignment.parent = special_category
	judge_assignment.parent = special_category
	governor_assignment.parent = special_category

	special_category.assignments |= councillor_assignment
	special_category.assignments |= judge_assignment
	special_category.assignments |= governor_assignment
	special_category.name = "Special Assignments"
	special_category.head_position = governor_assignment
	special_category.parent = src
	special_category.command_faction = 1
	limits = new /datum/machine_limits/democracy()

	name = "Nexus City Government"
	abbreviation = "NEXUS"
	short_tag = "NEX"
	purpose = "To represent the citizenship of Nexus and keep the station operating."
	uid = "nexus"
	gov = new()
	var/datum/election/gov/gov_elect = new()
	gov_elect.ballots |= gov

	waiting_elections |= gov_elect

	var/datum/election/council_elect = new()
	var/datum/democracy/councillor/councillor1 = new()
	councillor1.title = "Councillor of Justice and Criminal Matters"
	city_council |= councillor1
	council_elect.ballots |= councillor1

	var/datum/democracy/councillor/councillor2 = new()
	councillor2.title = "Councillor of Budget and Tax Measures"
	city_council |= councillor2
	council_elect.ballots |= councillor2

	var/datum/democracy/councillor/councillor3 = new()
	councillor3.title = "Councillor of Commerce and Business Relations"
	city_council |= councillor3
	council_elect.ballots |= councillor3

	var/datum/democracy/councillor/councillor4 = new()
	councillor4.title = "Councillor for Culture and Ethical Oversight"
	city_council |= councillor4
	council_elect.ballots |= councillor4

	var/datum/democracy/councillor/councillor5 = new()
	councillor5.title = "Councillor for the Domestic Affairs"
	city_council |= councillor5
	council_elect.ballots |= councillor5

	waiting_elections |= council_elect

	network.name = "NEXUSGOV-NET"
	network.net_uid = "nexus"
	network.password = ""
	network.invisible = 0

/datum/world_faction/democratic

	var/datum/democracy/governor/gov

	var/datum/assignment/councillor_assignment
	var/datum/assignment/judge_assignment
	var/datum/assignment/governor_assignment
	var/datum/assignment/resident_assignment
	var/datum/assignment/citizen_assignment
	var/datum/assignment/prisoner_assignment

	var/datum/assignment_category/special_category

	var/list/city_council = list()
	var/list/judges = list()

	var/council_amount = 5

	var/list/policy = list()

	var/list/criminal_laws = list()
	var/list/civil_laws = list()

	var/list/votes = list()
	var/list/vote_history = list()

	var/datum/election/current_election
	var/list/waiting_elections = list()
	var/active_elections = 1

	var/election_toggle = 0


	var/list/scheduled_trials = list()
	var/list/verdicts = list()


	var/tax_type_b = 1 // business 1 = flat, 2 = progressie
	var/tax_bprog1_rate = 0
	var/tax_bprog2_rate = 0
	var/tax_bprog3_rate = 0
	var/tax_bprog4_rate = 0
	var/tax_bprog2_amount = 0
	var/tax_bprog3_amount = 0
	var/tax_bprog4_amount = 0
	var/tax_bflat_rate = 0

	var/tax_type_p = 1 // personal 1 = flat, 2 = progressie
	var/tax_pprog1_rate = 0
	var/tax_pprog2_rate = 0
	var/tax_pprog3_rate = 0
	var/tax_pprog4_rate = 0
	var/tax_pprog2_amount = 0
	var/tax_pprog3_amount = 0
	var/tax_pprog4_amount = 0
	var/tax_pflat_rate = 0

/datum/world_faction/democratic/proc/pay_tax(var/datum/money_account/account, var/amount)
	var/tax_amount
	if(account.account_type == 2)
		if(tax_type_b == 2)
			if(account.money >= tax_bprog4_amount)
				tax_amount = amount * (tax_bprog4_rate/100)
			else if(account.money >= tax_bprog3_amount)
				tax_amount = amount * (tax_bprog3_rate/100)
			else if(account.money >= tax_bprog2_amount)
				tax_amount = amount * (tax_bprog2_rate/100)
			else
				tax_amount = amount * (tax_bprog1_rate/100)
		else
			tax_amount = amount * (tax_bflat_rate/100)

	else
		if(tax_type_p == 2)
			if(account.money >= tax_pprog4_amount)
				tax_amount = amount * (tax_pprog4_rate/100)
			else if(account.money >= tax_pprog3_amount)
				tax_amount = amount * (tax_pprog3_rate/100)
			else if(account.money >= tax_pprog2_amount)
				tax_amount = amount * (tax_pprog2_rate/100)
			else
				tax_amount = amount * (tax_pprog1_rate/100)
		else
			tax_amount = amount * (tax_pflat_rate/100)
	tax_amount = round(tax_amount)
	if(tax_amount)
		var/datum/transaction/T = new("[src.name]", "Tax", -tax_amount, "Nexus Economy Network")
		account.do_transaction(T)
		var/datum/transaction/Te = new("[account.owner_name]", "Tax", tax_amount, "Nexus Economy Network")
		central_account.do_transaction(Te)




/datum/verdict
	var/name = "" //title
	var/judge = ""
	var/defendant = ""
	var/body = ""
	var/time_rendered = 0
	var/citizenship_change = 0

/datum/judge_trial
	var/name = "" //title
	var/judge = ""
	var/defendant = ""
	var/plaintiff = ""
	var/body = ""
	var/month = ""
	var/day = 0
	var/hour = 0

/datum/world_faction/democratic/proc/render_verdict(var/datum/verdict/verdict)
	verdicts |= verdict
	command_announcement.Announce("Judge [verdict.judge] has rendered a verdict! [verdict.name].","Judicial Decision")

/datum/world_faction/democratic/proc/schedule_trial(var/datum/judge_trial/trial)
	scheduled_trials |= trial

/datum/world_faction/democratic/proc/cancel_trial(var/datum/judge_trial/trial)
	scheduled_trials -= trial


/datum/world_faction/democratic/proc/is_councillor(var/real_name)
	for(var/datum/democracy/ballot in city_council)
		if(ballot.real_name == real_name)
			return ballot

/datum/world_faction/democratic/proc/is_governor(var/real_name)
	if(!gov)
		return null
	if(gov.real_name == real_name)
		return gov

/datum/world_faction/democratic/proc/is_judge(var/real_name)
	for(var/datum/democracy/ballot in judges)
		if(ballot.real_name == real_name)
			return ballot

/datum/world_faction/democratic/proc/is_candidate(var/real_name)
	var/list/all_ballots = list()
	all_ballots |= gov
	all_ballots |= city_council
	for(var/datum/democracy/ballot in all_ballots)
		for(var/datum/candidate/candidate in ballot.candidates)
			if(candidate.real_name == real_name)
				return list(candidate, ballot)



/datum/world_faction/democratic/proc/start_election(var/datum/election/election)
	current_election = election
	if(election.typed)
		election_toggle = !election_toggle
	command_announcement.Announce("An Election has started! [election.name]. Citizens will have twelve hours to cast their votes.","Election Start")

/datum/world_faction/democratic/proc/start_trial(var/datum/judge_trial/trial)
	command_announcement.Announce("A trial should be starting soon! [trial.name] with Judge [trial.judge] presiding.","Trial Start")
	scheduled_trials -= trial


/datum/world_faction/democratic/proc/end_election()
	for(var/datum/democracy/ballot in current_election.ballots)
		if(!ballot.candidates.len)
			continue
		var/list/leaders = list()
		var/datum/candidate/leader
		for(var/datum/candidate/candidate in ballot.candidates)
			if(!leader || candidate.votes.len > leader.votes.len)
				leaders.Cut()
				leader = candidate
				leaders |= candidate
			else if(candidate.votes.len == leader.votes.len)
				leaders |= candidate
				leader = candidate
		if(!leaders.len)
			command_announcement.Announce("In the election for [ballot.title], no one was elected!","Election Result")
		else if(leaders.len > 1)
			var/leaders_names = ""
			var/first = 1
			for(var/datum/candidate/candidate in leaders)
				if(first)
					leaders_names += candidate.real_name
					first = 0
				else
					leaders_names += ", [candidate.real_name]"
			leader = pick(leaders)
			command_announcement.Announce("In the election for [ballot.title], the election was tied between [leaders_names]. [leader.real_name] was randomly selected as the winner.","Election Result")
			if(ballot.real_name != leader.real_name)
				ballot.real_name = leader.real_name
				ballot.seeking_reelection = 1
			else
				ballot.consecutive_terms++
		else
			command_announcement.Announce("In the election for [ballot.title], the election was won by [leader.real_name].","Election Result")
			if(ballot.real_name != leader.real_name)
				ballot.real_name = leader.real_name
			else
				ballot.consecutive_terms++
		ballot.candidates.Cut()
		ballot.voted_ckeys.Cut()
		if(leader)
			ballot.candidates |= leader
			ballot.seeking_reelection = 1
	current_election = null

/datum/world_faction/democratic/proc/withdraw_vote(var/datum/council_vote/vote)
	votes -= vote

/datum/world_faction/democratic/proc/defeat_vote(var/datum/council_vote/vote)
	votes -= vote

/datum/world_faction/democratic/proc/start_vote(var/datum/council_vote/vote)
	votes |= vote

/datum/world_faction/democratic/proc/has_vote(var/real_name)
	for(var/datum/council_vote/vote in votes)
		if(vote.sponsor == real_name)
			return 1

/datum/world_faction/democratic/proc/vote_yes(var/datum/council_vote/vote, var/mob/user)
	vote.yes_votes |= user.real_name
	if(vote.yes_votes.len >= 5)
		pass_vote(vote)
	else if(vote.yes_votes.len >= 3 && vote.signer != "")
		pass_vote(vote)

/datum/world_faction/democratic/proc/vote_no(var/datum/council_vote/vote, var/mob/user)
	vote.no_votes |= user.real_name
	if(vote.no_votes.len >= 3)
		defeat_vote(vote)

/datum/world_faction/democratic/proc/repeal_policy(var/datum/council_vote/vote)
	policy -= vote
	command_announcement.Announce("Governor [vote.signer] has repealed an executive policy! [vote.name].","Governor Action")

/datum/world_faction/democratic/proc/pass_policy(var/datum/council_vote/vote)
	policy |= vote
	command_announcement.Announce("Governor [vote.signer] has passed an executive policy! [vote.name].","Governor Action")

/datum/world_faction/democratic/proc/pass_nomination_judge(var/datum/democracy/judge)
	judges |= judge
	command_announcement.Announce("The government has approved the nomination of [judge.real_name] for judge. They are now Judge [judge.real_name].","Nomination Pass")

/datum/world_faction/democratic/proc/pass_impeachment_judge(var/datum/democracy/judge)
	judges -= judge
	command_announcement.Announce("The government has voted to remove [judge.real_name] from their position of  judge.","Impeachment")

/datum/world_faction/democratic/proc/pass_vote(var/datum/council_vote/vote)
	votes -= vote
	vote.time_signed = world.realtime
	if(vote.bill_type == 3)
		if(vote.tax == 2)
			if(vote.taxtype == 2)
				tax_bprog1_rate = vote.prograte1
				tax_bprog2_rate = vote.prograte2
				tax_bprog3_rate = vote.prograte3
				tax_bprog4_rate = vote.prograte4

				tax_bprog2_amount = vote.progamount2
				tax_bprog3_amount = vote.progamount3
				tax_bprog4_amount = vote.progamount4
				tax_type_b = 2
				command_announcement.Announce("The government has just passed a new progressive tax policy for business income.","Business Tax")
			else
				tax_bflat_rate = vote.flatrate
				tax_type_b = 1
				command_announcement.Announce("The government has just passed a new flat tax policy for business income.","Business Tax")
		else
			if(vote.taxtype == 2)
				tax_pprog1_rate = vote.prograte1
				tax_pprog2_rate = vote.prograte2
				tax_pprog3_rate = vote.prograte3
				tax_pprog4_rate = vote.prograte4

				tax_pprog2_amount = vote.progamount2
				tax_pprog3_amount = vote.progamount3
				tax_pprog4_amount = vote.progamount4
				tax_type_p = 2
				command_announcement.Announce("The government has just passed a new progressive tax policy for personal income.","Personal Income Tax")
			else
				tax_pflat_rate = vote.flatrate
				tax_type_p = 1
				command_announcement.Announce("The government has just passed a new flat tax policy for personal income.","Personal Income Tax")
	else if(vote.bill_type == 4)
		for(var/datum/democracy/judge in judges)
			if(judge.real_name == vote.impeaching)
				pass_impeachment_judge(judge)
				return 1

	else if(vote.bill_type == 5)
		if(is_governor(vote.nominated) || is_councillor(vote.nominated) || is_judge(vote.nominated))
			return 0
		var/datum/democracy/judge/judge = new()
		judge.real_name = vote.nominated
		pass_nomination_judge(judge)

	else if(vote.bill_type == 1)
		criminal_laws |= vote
		command_announcement.Announce("The government has just passed a new criminal law.","New Criminal Law")

	else if(vote.bill_type == 2)
		civil_laws |= vote
		command_announcement.Announce("The government has just passed a new civil law.","New Civil Law")


/datum/council_vote
	var/name = "" // title of votes
	var/bill_type = 1 //  1 = criminal law, 2 = civil law, 3 = tax policy, 4 = impeachment (judge) 5 = nomination (judge)

	var/sponsor = "" // real_name of the vote starter
	var/time_started // realtime of when the vote started.
	var/time_signed // realtime when passed

	var/signer = ""

	var/list/yes_votes = list()
	var/list/no_votes = list()

	var/body = "" // used by civil and criminal laws

	var/tax = 0 // 1 = personal 2 = business

	var/taxtype = 1 // 1 = flat, 2 = progressive

	var/flatrate = 0

	var/prograte1 = 0
	var/prograte2 = 0
	var/prograte3 = 0
	var/prograte4 = 0

	var/progamount2 = 0
	var/progamount3 = 0
	var/progamount4 = 0

	var/impeaching = "" // real_name of impaechment target

	var/nominated = ""
/datum/election
	var/name = "Station Council Election"
	var/list/ballots = list() // populate this with the /datum/democracy for every participant of the election

	var/start_hour = 10 // time of day (in 24 hour) when the election should start by
	var/end_hour = 22
	var/cut_off = 14
	var/start_day = "Saturday"
	var/end_day = "Saturday"

	var/typed = 1
	var/num_type = 0

/datum/election/gov
	name = "Governor Election"
	typed = 1
	num_type = 1



/datum/democracy
	var/real_name // real_name of elected
	var/term_start // real time
	var/title = "Councillor"
	var/description = "Vote on laws civil and criminal, the tax code and confirming judges nominated by the governor."
	var/consecutive_terms = 0

	var/election_desc = ""
	var/seeking_reelection = 1

	var/list/candidates = list()
	var/list/voted_ckeys = list() // to prevent double voting

/datum/democracy/governor
	title = "Governor"
	description = "Manage the executive government by creating assignments, ranks and accesses while publishing executive policy documents. Nominate Judges."

/datum/democracy/councillor

/datum/democracy/judge
	title = "Judge"

/datum/candidate
	var/real_name = "" // real name of candidate
	var/ckey = "" // ckey of candidate to prevent self voting
	var/list/votes = list() // list of unqiue names voting for the candidate

	var/desc = ""



/datum/world_faction/proc/give_inventory(var/typepath, var/amount)
	var/obj/machinery/telepad_cargo/using_telepad
	var/remaining_amount = amount
	rebuild_cargo_telepads()
	if(default_telepad)
		using_telepad = default_telepad
	else
		using_telepad = pick(cargo_telepads)
	if(!using_telepad) return 0
	for(var/x in 1 to amount)
		if(!remaining_amount) break
		var/obj/item/stack/material/stack = new typepath(using_telepad.loc)
		var/distributing = min(remaining_amount, stack.max_amount)
		remaining_amount -= distributing
		stack.amount = distributing
	return 1

/datum/world_faction/proc/take_inventory(var/typepath, var/amount)
	var/remaining_amount = amount
	rebuild_cargo_telepads()
	var/list/found_stacks
	for(var/obj/machinery/telepad_cargo/telepad in cargo_telepads)
		if(!remaining_amount)
			break
		if(telepad.loc)
			var/list/stacks = telepad.loc.search_contents_for(/obj/item/stack/material, list(/mob/))
			if(!stacks.len) continue
			for(var/ind in 1 to stacks.len)
				if(!remaining_amount)
					break
				var/obj/item/stack/material/stack = stacks[ind]
				if(istype(stack, typepath))
					remaining_amount -= stack.amount
					found_stacks |= stack
	if(remaining_amount)
		return 0
	var/taken = 0
	for(var/obj/item/stack/material/stack in found_stacks)
		if(taken >= amount)
			break
		var/take = min(stack.amount, (amount-taken))
		stack.amount -= take
		if(!stack.amount)
			qdel(stack)
		taken += take
	return 1


/datum/world_faction/proc/rebuild_limits()
	return

/datum/world_faction/democratic/rebuild_limits()
	limits.limit_genfab = 5
	limits.limit_engfab = 5
	limits.limit_medicalfab = 5
	limits.limit_mechfab = 5
	limits.limit_voidfab = 5
	limits.limit_ataccessories = 5
	limits.limit_atnonstandard = 5
	limits.limit_atstandard = 5
	limits.limit_ammofab = 5
	limits.limit_consumerfab = 5
	limits.limit_servicefab = 5

	limits.limit_drills = 2

	limits.limit_botany = 2

	limits.limit_shuttles = 3

	limits.limit_area = 100000

	limits.limit_tcomms = 5

	limits.limit_tech_general = 4
	limits.limit_tech_engi = 4
	limits.limit_tech_medical = 4
	limits.limit_tech_consumer =  4
	limits.limit_tech_combat =  4

/datum/world_faction/business/rebuild_limits()
	var/datum/machine_limits/current_level = module.levels[module.current_level]
	limits.limit_genfab = module.spec.limits.limit_genfab + current_level.limit_genfab
	limits.limit_engfab = module.spec.limits.limit_engfab + current_level.limit_engfab
	limits.limit_medicalfab = module.spec.limits.limit_medicalfab + current_level.limit_medicalfab
	limits.limit_mechfab = module.spec.limits.limit_mechfab + current_level.limit_mechfab
	limits.limit_voidfab = module.spec.limits.limit_voidfab + current_level.limit_voidfab
	limits.limit_ataccessories = module.spec.limits.limit_ataccessories + current_level.limit_ataccessories
	limits.limit_atnonstandard = module.spec.limits.limit_atnonstandard + current_level.limit_atnonstandard
	limits.limit_atstandard = module.spec.limits.limit_atstandard + current_level.limit_atstandard
	limits.limit_ammofab = module.spec.limits.limit_ammofab + current_level.limit_ammofab
	limits.limit_consumerfab = module.spec.limits.limit_consumerfab + current_level.limit_consumerfab
	limits.limit_servicefab = module.spec.limits.limit_servicefab + current_level.limit_servicefab

	limits.limit_drills = module.spec.limits.limit_drills + current_level.limit_drills

	limits.limit_botany = module.spec.limits.limit_botany + current_level.limit_botany

	limits.limit_shuttles = module.spec.limits.limit_shuttles + current_level.limit_shuttles

	limits.limit_area = module.spec.limits.limit_area + current_level.limit_area

	limits.limit_tcomms = module.spec.limits.limit_tcomms + current_level.limit_tcomms

	limits.limit_tech_general = module.spec.limits.limit_tech_general + current_level.limit_tech_general
	limits.limit_tech_engi = module.spec.limits.limit_tech_engi + current_level.limit_tech_engi
	limits.limit_tech_medical = module.spec.limits.limit_tech_medical + current_level.limit_tech_medical
	limits.limit_tech_consumer =  module.spec.limits.limit_tech_consumer + current_level.limit_tech_consumer
	limits.limit_tech_combat =  module.spec.limits.limit_tech_combat + current_level.limit_tech_combat

/datum/world_faction/proc/rebuild_inventory()
	inventory.steel = 0
	inventory.glass = 0
	inventory.gold = 0
	inventory.silver = 0
	inventory.copper = 0
	inventory.wood = 0
	inventory.cloth = 0
	inventory.leather = 0
	inventory.phoron = 0
	inventory.diamond = 0
	inventory.uranium = 0
	rebuild_cargo_telepads()
	for(var/obj/machinery/telepad_cargo/telepad in cargo_telepads)
		if(telepad.loc)
			var/list/stacks = telepad.loc.search_contents_for(/obj/item/stack/material, list(/mob/))
			if(!stacks.len) continue
			for(var/ind in 1 to stacks.len)
				var/obj/item/stack/material/stack = stacks[ind]
				if(istype(stack, /obj/item/stack/material/steel))
					inventory.steel += stack.amount
				if(istype(stack, /obj/item/stack/material/glass))
					inventory.glass += stack.amount
				if(istype(stack, /obj/item/stack/material/gold))
					inventory.gold += stack.amount
				if(istype(stack, /obj/item/stack/material/silver))
					inventory.silver += stack.amount
				if(istype(stack, /obj/item/stack/material/copper))
					inventory.copper += stack.amount
				if(istype(stack, /obj/item/stack/material/wood))
					inventory.wood += stack.amount
				if(istype(stack, /obj/item/stack/material/cloth))
					inventory.cloth += stack.amount
				if(istype(stack, /obj/item/stack/material/leather))
					inventory.leather += stack.amount
				if(istype(stack, /obj/item/stack/material/phoron))
					inventory.phoron += stack.amount
				if(istype(stack, /obj/item/stack/material/diamond))
					inventory.diamond += stack.amount
				if(istype(stack, /obj/item/stack/material/uranium))
					inventory.uranium += stack.amount

/datum/material_inventory
	var/steel = 0
	var/glass = 0
	var/gold = 0
	var/silver = 0
	var/copper = 0
	var/wood = 0
	var/cloth = 0
	var/leather = 0
	var/phoron = 0
	var/diamond = 0
	var/uranium = 0


/datum/world_faction/business
	var/datum/business_module/module
	var/list/stock_holders = list()
	var/datum/assignment/CEO
	var/list/proposals = list()

	var/ceo_tax = 0
	var/stockholder_tax = 0
	var/public_stock = 0

	var/datum/module_objective/hourly_objective
	var/hourly_assigned = 0
	var/datum/module_objective/daily_objective
	var/daily_assigned = 0
	var/datum/module_objective/weekly_objective
	var/weekly_assigned = 0

	var/commission = 0
	var/PriorityQueue/buyorders
	var/PriorityQueue/sellorders
	var/stock_sales = 0 // stock sales this hour
	var/list/stock_sales_data = list() // stock sales in the past 24 hours

/datum/world_faction/business/proc/verify_orders()
	for(var/datum/stock_order/order in buyorders.L)
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(order.real_name)
		if(!R || !R.linked_account)
			buyorders.L -= order
			continue
		if(R.linked_account.money < order.get_total_value())
			buyorders.L -= order
			continue
	for(var/datum/stock_order/order in sellorders.L)
		if(get_stockholder(order.real_name) < order.get_remaining_volume())
			sellorders.L -= order
			continue


/datum/world_faction/business/proc/get_last_hour()
	if(!stock_sales_data.len) return 0
	return text2num(stock_sales_data[stock_sales_data.len])

/datum/world_faction/business/proc/get_last_24()
	var/total = 0
	for(var/x in stock_sales_data)
		total += text2num(x)
	return total

/datum/world_faction/business/proc/get_best_buy()
	if(!buyorders.L.len) return null
	var/datum/stock_order/order = buyorders.L[1]
	if(order)
		return order.price
/datum/world_faction/business/proc/get_best_sell()
	if(!sellorders.L.len) return null
	var/datum/stock_order/order = sellorders.L[1]
	if(order)
		return order.price


/datum/world_faction/business/proc/fill_order(var/datum/stock_order/buyorder, var/datum/stock_order/sellorder)
	if(buyorder.price > sellorder.price) return
	var/buyer_name = buyorder.real_name
	var/datum/computer_file/report/crew_record/buyer = Retrieve_Record(buyorder.real_name)
	var/datum/computer_file/report/crew_record/seller = Retrieve_Record(sellorder.real_name)
	var/datum/stockholder/initial_holder = get_stockholder_datum()
	if(!buyer || !seller) return
	var/moving = min(buyorder.get_remaining_volume(), sellorder.get_remaining_volume())
	if(initial_holder.stocks < moving)
		moving = initial_holder.stocks
	var/cost = moving*sellorder.price

	if(!buyer.linked_account.money >= cost || ((moving + buyer.get_holdings()) > buyer.get_stock_limit()))
		var/datum/stockholder/new_holder = get_stockholder_datum(buyer_name)
		if(!new_holder)
			new_holder = new()
			new_holder.real_name = buyer_name
			stock_holders |= new_holder
		var/datum/transaction/T = new("Stock Buy", "Buy Order for [moving] stocks of [uid]", -cost, "Stock Market")
		buyer.linked_account.do_transaction(T)
		var/datum/transaction/Te = new("Stock Sale", "Sell Order for [moving] stocks of [uid]", cost, "Stock Market")
		seller.linked_account.do_transaction(Te)
		sellorder.filled += moving
		buyorder.filled += moving
		stock_sales += moving
		if(!sellorder.get_remaining_volume())
			sellorders.L -= sellorder
		if(!buyorder.get_remaining_volume())
			buyorders.L -= buyorder
	else
		buyorders.L -= buyorder
		return 0

/datum/world_faction/business/proc/cancel_order(var/datum/stock_order/order)
	buyorders.L -= order
	sellorders.L -= order

/datum/world_faction/business/proc/add_buyorder(var/price, var/volume, var/real_name)
	var/datum/stock_order/order = new()
	order.price = price
	order.volume = volume
	order.real_name = real_name
	for(var/datum/stock_order/sell_order in sellorders.L)
		if(!order.get_remaining_volume()) break
		if(sell_order.price <= order.price)
			fill_order(order, sell_order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	buyorders.Enqueue(order)

/datum/world_faction/business/proc/add_sellorder(var/price, var/volume, var/real_name)
	var/datum/stock_order/order = new()
	order.price = price
	order.volume = volume
	order.real_name = real_name
	for(var/datum/stock_order/buy_order in buyorders.L)
		if(!order.get_remaining_volume()) break
		if(order.price <= buy_order.price)
			fill_order(buy_order, order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	sellorders.Enqueue(order)

/datum/world_faction/business/proc/get_buyvolume()
	var/volume = 0
	for(var/datum/stock_order/buy_order in buyorders.L)
		volume += buy_order.volume
	return volume

/datum/world_faction/business/proc/get_sellvolume()
	var/volume = 0
	for(var/datum/stock_order/sell_order in sellorders.L)
		volume += sell_order.volume
	return volume


/datum/world_faction/business/proc/get_buyprice(var/volume)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/stock_order/sell_order in sellorders.L)
		if(!remaining_volume) break
		var/transact = min(sell_order.get_remaining_volume(), remaining_volume)
		final_price += transact*sell_order.price
		remaining_volume -= transact
	return final_price




/datum/world_faction/business/proc/surrender_stocks(var/real_name)
	var/datum/stockholder/holder = get_stockholder_datum(real_name)
	if(holder)
		if(stock_holders.len == 1) // last stock holder
			stock_holders.Cut()
			GLOB.all_world_factions -= src
			qdel(src)
			return
		else
			var/remainder = holder.stocks % (stock_holders.len-1)
			var/division = (holder.stocks-remainder)/(stock_holders.len-1)
			stock_holders -= holder
			for(var/datum/stockholder/secondholder in stock_holders)
				secondholder.stocks += division
			if(remainder)
				var/list/stock_holders_copy = stock_holders.Copy()
				for(var/x in 1 to remainder)
					if(!stock_holders_copy.len)
						stock_holders_copy = stock_holders.Copy()
					var/datum/stockholder/holderr = pick_n_take(stock_holders_copy)
					holderr.stocks++

/datum/world_faction/business/proc/revenue_objectives(var/amount) // run this anytime a revenue objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/revenue)) // checks if the hourly objective is a revenue objective
		hourly_objective.filled += amount // fill by the amount
		hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/revenue)) // repeat for daily, weekly
		daily_objective.filled += amount
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/revenue))
		weekly_objective.filled += amount
		weekly_objective.check_completion()

/datum/world_faction/business/proc/cost_objectives(var/amount) // run this anytime a cost objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/cost)) // checks if the hourly objective is a cost objective
		hourly_objective.filled += amount // fill by the amount
		hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/cost)) // repeat for daily, weekly
		daily_objective.filled += amount
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/cost))
		weekly_objective.filled += amount
		weekly_objective.check_completion()

/datum/world_faction/business/proc/monster_objectives() // run this anytime a monster objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/monsters))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/monsters)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/monsters))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/publish_article_objectives() // run this anytime a publish article objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/publish_article))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()

/datum/world_faction/business/proc/publish_book_objectives(var/real_name) // run this anytime a publish book objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/publish_book))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/publish_book) && !(real_name in daily_objective.unique_characters)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/publish_book) && !(real_name in weekly_objective.unique_characters))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/contract_objectives(var/namee, var/sale_type)
	if(istype(hourly_objective, /datum/module_objective/hourly/contract))
		if(sale_type == CONTRACT_PERSON && !(namee in hourly_objective.unique_characters)) //
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_characters |= namee
			hourly_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in hourly_objective.unique_factions)) //
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_factions |= namee
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/contract)) //
		if(sale_type == CONTRACT_PERSON && !(namee in daily_objective.unique_characters)) //
			daily_objective.filled++ // increase by one
			daily_objective.unique_characters |= namee
			daily_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in daily_objective.unique_factions)) //
			daily_objective.filled++ // increase by one
			daily_objective.unique_factions |= namee
			daily_objective.check_completion() // check if its done
	if(istype(weekly_objective, /datum/module_objective/weekly/contract)) //
		if(sale_type == CONTRACT_PERSON && !(namee in weekly_objective.unique_characters)) //
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_characters |= namee
			weekly_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in weekly_objective.unique_factions)) //
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_factions |= namee
			weekly_objective.check_completion() // check if its done




/datum/world_faction/business/proc/sales_objectives(var/namee, var/sale_type) // sale_type 1 == character, 2 == business
	if(istype(hourly_objective, /datum/module_objective/hourly/sales))
		if(sale_type == 1 && !(namee in hourly_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_characters |= namee
			hourly_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in hourly_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_factions |= namee
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/sales)) // checks if the hourly objective is a cost objective
		if(sale_type == 1 && !(namee in daily_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			daily_objective.filled++ // increase by one
			daily_objective.unique_characters |= namee
			daily_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in daily_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			daily_objective.filled++ // increase by one
			daily_objective.unique_factions |= namee
			daily_objective.check_completion() // check if its done
	if(istype(weekly_objective, /datum/module_objective/weekly/sales)) // checks if the hourly objective is a cost objective
		if(sale_type == 1 && !(namee in weekly_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_characters |= namee
			weekly_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in weekly_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_factions |= namee
			weekly_objective.check_completion() // check if its done


/datum/world_faction/business/proc/employee_objectives(var/real_name) // run anytime a employee objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/employees)) // check for objective
		if(!(real_name in hourly_objective.unique_characters)) // this means IF the name of the employee IS NOT already used to fill the objective
			hourly_objective.unique_characters |= real_name // put the name in the unique names list to prevent duplicates
			hourly_objective.filled++ // increased filled by 1 (++ increases by 1)
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/employees)) // repeat for daily, weekly
		if(!(real_name in daily_objective.unique_characters))
			daily_objective.unique_characters |= real_name
			daily_objective.filled++
			daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/employees)) // repeat for daily, weekly
		if(!(real_name in weekly_objective.unique_characters))
			weekly_objective.unique_characters |= real_name
			weekly_objective.filled++
			weekly_objective.check_completion()

/datum/world_faction/business/proc/fabricator_objectives()
	if(istype(hourly_objective, /datum/module_objective/hourly/fabricate))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/fabricate)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/fabricate))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/article_view_objectives(var/real_name) // run anytime a employee objective might be filled
	if(istype(daily_objective, /datum/module_objective/daily/article_viewers)) // repeat for daily, weekly
		if(!(real_name in daily_objective.unique_characters))
			daily_objective.unique_characters |= real_name
			daily_objective.filled++
			daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/article_viewers)) // repeat for daily, weekly
		if(!(real_name in weekly_objective.unique_characters))
			weekly_objective.unique_characters |= real_name
			weekly_objective.filled++
			weekly_objective.check_completion()


/datum/world_faction/business/proc/assign_hourly_objective()
	var/list/possible = list()
	possible |= module.hourly_objectives
	possible |= module.spec.hourly_objectives
	var/chose_type = pick(possible)
	hourly_objective = new chose_type()
	hourly_assigned = world.realtime
/datum/world_faction/business/proc/assign_daily_objective()
	var/list/possible = list()
	possible |= module.daily_objectives
	possible |= module.spec.daily_objectives
	var/chose_type = pick(possible)
	daily_objective = new chose_type()
	daily_assigned = world.realtime
/datum/world_faction/business/proc/assign_weekly_objective()
	var/list/possible = list()
	possible |= module.weekly_objectives
	possible |= module.spec.weekly_objectives
	var/chose_type = pick(possible)
	weekly_objective = new chose_type()
	weekly_assigned = world.realtime

/datum/world_faction/business/New()
	..()
	CEO = new()
	feed = new()
	library = new()
	buyorders = new /PriorityQueue(/proc/cmp_buyorders_stock)
	sellorders = new /PriorityQueue(/proc/cmp_sellorders_stock)

/datum/world_faction/business/proc/pay_dividends(var/datum/money_account/account, var/amount)
	var/ceo_amount
	var/stock_amount
	if(ceo_tax)
		ceo_amount = round((amount/100)*ceo_tax)
	if(stockholder_tax)
		stock_amount = round((amount/100)*ceo_tax)
	if(ceo_amount)
		var/datum/money_account/target_account = get_account_record(leader_name)
		if(target_account)
			var/datum/transaction/T = new(leader_name, "CEO Revenue Share", -ceo_amount, "Nexus Economy Network")
			account.do_transaction(T)
			var/datum/transaction/Te = new("[account.owner_name]", "CEO Revenue Share", ceo_amount, "Nexus Economy Network")
			target_account.do_transaction(Te)
	if(stock_amount)
		var/amount_taken = 0
		for(var/x in stock_holders)
			var/datum/stockholder/holder = stock_holders[x]
			var/holder_amount = round((stock_amount/100)*holder.stocks)
			if(holder_amount)
				var/datum/money_account/target_account = get_account_record(holder.real_name)
				if(target_account)
					var/datum/transaction/Te = new("[account.owner_name]", "Stockholder Revenue Share", holder_amount, "Nexus Economy Network")
					target_account.do_transaction(Te)
					amount_taken += holder_amount
			if(amount_taken)
				var/datum/transaction/T = new("Shareholders", "Shareholder Revenue Share", -amount_taken, "Nexus Economy Network")
				account.do_transaction(T)

/datum/world_faction/business/proc/get_ceo_wage()
	return CEO.get_pay(1)

/datum/world_faction/business/proc/get_ceo()
	if(!leader_name || leader_name == "") return "**NONE**"
	return leader_name


/datum/world_faction/business/proc/subscribe_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		holder.subscribed = 1

/datum/world_faction/business/proc/unsubscribe_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		holder.subscribed = 0

/datum/world_faction/business/proc/get_stockholder_datum(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder

/datum/world_faction/proc/get_stockholder(var/real_name)
	return 0
/datum/world_faction/business/get_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder.stocks

/datum/world_faction/business/proc/get_stockholder_subscribed(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder.subscribed

/datum/world_faction/business/proc/has_proposal(var/real_name)
	for(var/datum/stock_proposal/proposal in proposals)
		if(proposal.started_by == real_name) return 1

/datum/world_faction/business/proc/instant_dividend(var/target)
	if(target > 100) target = 100
	var/amount = (central_account.money/100)*target
	var/amount_taken = 0
	for(var/x in stock_holders)
		var/datum/stockholder/holder = stock_holders[x]
		var/holder_amount = round((amount/100)*holder.stocks)
		if(holder_amount)
			var/datum/money_account/target_account = get_account_record(holder.real_name)
			if(target_account)
				var/datum/transaction/Te = new("[central_account.owner_name]", "Instant Dividend", holder_amount, "Nexus Economy Network")
				target_account.do_transaction(Te)
				amount_taken += holder_amount
	if(amount_taken)
		var/datum/transaction/T = new("Shareholders", "Instant Dividend", -amount_taken, "Nexus Economy Network")
		central_account.do_transaction(T)



/datum/world_faction/business/proc/pass_proposal(var/datum/stock_proposal/proposal)
	if(!proposal) return
	switch(proposal.func)
		if(STOCKPROPOSAL_CEOFIRE)
			leader_name = ""
		if(STOCKPROPOSAL_CEOREPLACE)
			leader_name = proposal.target
			if(!get_record(proposal.target))
				var/datum/computer_file/report/crew_record/record = new()
				if(record.load_from_global(proposal.target))
					records.faction_records |= record
		if(STOCKPROPOSAL_CEOWAGE)
			var/datum/accesses/access = CEO.accesses[1]
			access.pay = proposal.target
		if(STOCKPROPOSAL_CEOTAX)
			ceo_tax = proposal.target
		if(STOCKPROPOSAL_STOCKHOLDERTAX)
			stockholder_tax = proposal.target
		if(STOCKPROPOSAL_INSTANTDIVIDEND)
			instant_dividend(proposal.target)
		if(STOCKPROPOSAL_PUBLIC)
			public_stock = 1
		if(STOCKPROPOSAL_UNPUBLIC)
			public_stock = 0
			buyorders.L.Cut()
			sellorders.L.Cut()

	proposals -= proposal


/datum/world_faction/business/proc/create_proposal(var/real_name, var/func, var/target)
	var/datum/stock_proposal/proposal = new()
	proposal.started_by = real_name
	proposal.func = func
	proposal.target = target
	switch(func)
		if(STOCKPROPOSAL_CEOFIRE)
			proposal.required = 51
			proposal.name = "Proposal to fire the current CEO."
		if(STOCKPROPOSAL_CEOREPLACE)
			proposal.required = 51
			proposal.name = "Proposal to make [target] the CEO of the business."
		if(STOCKPROPOSAL_CEOWAGE)
			proposal.name = "Proposal to change CEO wage to [target]."
			if(target > get_ceo_wage())
				proposal.required = 75
			else
				proposal.required = 51
		if(STOCKPROPOSAL_CEOTAX)
			proposal.name = "Proposal to change CEO revenue share to [target]."
			if(target > ceo_tax)
				proposal.required = 75
			else
				proposal.required = 51
		if(STOCKPROPOSAL_STOCKHOLDERTAX)
			proposal.name = "Proposal to change stockholders revenue share to [target]."
			if(target < ceo_tax)
				proposal.required = 61
			else
				proposal.required = 51
		if(STOCKPROPOSAL_INSTANTDIVIDEND)
			proposal.name = "Proposal to enact an instant dividend of [target]%."
			proposal.required = 51
		if(STOCKPROPOSAL_PUBLIC)
			proposal.name = "Proposal to publically list the business on the stock market."
			proposal.required = 51
		if(STOCKPROPOSAL_UNPUBLIC)
			proposal.name = "Proposal to remove the business from the stock market listings.."
			proposal.required = 75
	proposals |= proposal
	proposal.connected_faction = src


/datum/stockholder
	var/real_name = ""
	var/stocks = 0
	var/subscribed = 0

/datum/stock_proposal
	var/func = 0
	var/required = 0
	var/list/supporting = list()
	var/datum/stockholder/started_by
	var/name
	var/target
	var/datum/world_faction/business/connected_faction


/datum/stock_proposal/proc/is_supporting(var/real_name)
	for(var/datum/stockholder/holder in supporting)
		if(holder.real_name == real_name) return 1

/datum/stock_proposal/proc/is_started_by(var/real_name)
	if(started_by == real_name) return 1


/datum/stock_proposal/proc/get_support()
	var/amount = 0
	for(var/datum/stockholder/holder in supporting)
		amount += holder.stocks
	if(amount > required)
		pass_proposal()
	return amount

/datum/stock_proposal/proc/pass_proposal()
	connected_faction.pass_proposal(src)


/datum/world_faction/before_save()
	if(default_telepad)
		default_telepad_x = default_telepad.x
		default_telepad_y = default_telepad.y
		default_telepad_z = default_telepad.z

/datum/world_faction/after_load()
	if(default_telepad_x && default_telepad_y && default_telepad_z)
		var/turf/T = locate(default_telepad_x, default_telepad_y, default_telepad_z)
		for(var/obj/machinery/telepad_cargo/telepad in T.contents)
			default_telepad = telepad
			break
	if(!debts)
		debts = list()
	if(central_account)
		central_account.connected_business = src
	..()

/datum/world_faction/business/after_load()
	if(CEO)
		if(!CEO.accesses.len)
			var/datum/accesses/access = new()
			access.name = "CEO"
			access.pay = 45

/datum/world_faction/proc/get_limits()
	return limits


//(Re)Calculates the current claimed area and returns it.
/datum/world_faction/proc/get_claimed_area()
	src.calculate_claimed_area()
	return limits.claimed_area

//Calculates the current claimed area. Only used by "get_claimed_area()" and "apc/can_disconnect()" procs.~
//Call "get_claimed_area()" directly instead (in most cases).
/datum/world_faction/proc/calculate_claimed_area()
	var/new_claimed_area = 0

	for(var/obj/machinery/power/apc/apc in limits.apcs)
		if(!apc.area || apc.area.shuttle) continue
		var/list/apc_turfs = get_area_turfs(apc.area)
		new_claimed_area += apc_turfs.len
	limits.claimed_area = new_claimed_area

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
/datum/world_faction/proc/get_tech_points()
	return research.points

/datum/world_faction/proc/take_tech_points(var/amount)
	research.points -= amount


/datum/world_faction/proc/unlock_tech(var/uid)
	research.unlocked |= uid

/datum/world_faction/proc/is_tech_unlocked(var/uid)
	if(uid in research.unlocked)
		return 1

/datum/world_faction/proc/meets_prereqs(var/datum/tech_entry/tech)
	for(var/x in tech.prereqs)
		if(!(x in research.unlocked))
			return 0
	return 1

/datum/world_faction/New()
	network = new()
	network.holder = src
	records = new()
	create_faction_account()
	limits = new()
	research = new()
	inventory = new()


/datum/world_faction/proc/rebuild_cargo_telepads()
	cargo_telepads.Cut()
	for(var/obj/machinery/telepad_cargo/telepad in GLOB.cargotelepads)
		if(telepad.req_access_faction == uid)
			telepad.connected_faction = src
			cargo_telepads |= telepad

/datum/world_faction/proc/rebuild_all_access()
	all_access = list()
	var/datum/access_category/core/core = new()
	for(var/datum/access_category/access_category in access_categories+core)
		for(var/x in access_category.accesses)
			all_access |= x

/datum/world_faction/proc/rebuild_all_assignments()
	all_assignments = list()
	for(var/datum/assignment_category/assignment_category in assignment_categories)
		for(var/x in assignment_category.assignments)
			all_assignments |= x

/datum/world_faction/proc/get_assignment(var/assignment, var/real_name)
	if(!assignment) return null
	rebuild_all_assignments()
	for(var/datum/assignment/assignmentt in all_assignments)
		if(assignmentt.uid == assignment) return assignmentt

/datum/world_faction/business/get_assignment(var/assignment, var/real_name)
	if(real_name == leader_name)
		return CEO
	return ..()


/datum/world_faction/democratic/get_assignment(var/assignment, var/real_name)
	if(is_judge(real_name))
		return judge_assignment
	if(is_councillor(real_name))
		return councillor_assignment
	if(is_governor(real_name))
		return governor_assignment
	return ..()

//Just a way to customize the starting money for new characters joining a specific faction on spawn
// Can be expanded to check the specie and origins and etc too
/datum/world_faction/proc/get_new_character_money(var/mob/living/carbon/human/H)
	return DEFAULT_NEW_CHARACTER_MONEY //By default just throw the default amount at them

/datum/records_holder
	var/use_standard = 1
	var/list/custom_records = list() // format-- list("")
	var/list/faction_records = list() // stores all employee record files, format-- list("[M.real_name]" = /datum/crew_record)

/datum/world_faction/proc/get_records()
	return records.faction_records

/datum/world_faction/proc/get_record(var/real_name)
	for(var/datum/computer_file/report/crew_record/R in records.faction_records)
		if(R.get_name() == real_name)
			return R
	var/datum/computer_file/report/crew_record/L = Retrieve_Record_Faction(real_name, src)
	return L

/datum/world_faction/proc/in_command(var/real_name)
	var/datum/computer_file/report/crew_record/R = get_record(real_name)
	if(R)
		var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
		if(assignment)
			if(assignment.parent)
				return assignment.parent.command_faction
	return 0

/datum/world_faction/proc/outranks(var/real_name, var/target)
	if(real_name == get_leadername())
		return 1
	var/datum/computer_file/report/crew_record/R = get_record(real_name)
	if(!R) return 0
	var/datum/computer_file/report/crew_record/target_record = get_record(target)
	if(!target_record) return 1
	var/user_command = 0
//	var/target_command = 0
	var/user_leader = 0
	var/target_leader = 0
	var/same_department = 0
	var/user_auth = 0
	var/target_auth = 0

	var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
	if(assignment)
		user_auth = assignment.edit_authority
		if(assignment.parent)
			user_command = assignment.parent.command_faction
			if(assignment.parent.head_position && assignment.parent.head_position.name == assignment.name)
				user_leader = 1
	else
		return 0
	var/datum/assignment/target_assignment = get_assignment(target_record.assignment_uid, target_record.get_name())
	if(target_assignment)
		target_auth = target_assignment.authority_restriction
		if(target_assignment.any_assign)
			same_department = 1
		if(target_assignment.parent)
	//		target_command = target_assignment.parent.command_faction
			if(target_assignment.parent.head_position && target_assignment.parent.head_position.name == target_assignment.name)
				target_leader = 1
			if(assignment.parent && target_assignment.parent.name == assignment.parent.name)
				same_department = 1
	else
		return 1
	if(user_command)
	//	if(!target_command) return 1
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
	//	if(user_rank >= target_rank) return 1
		if(user_auth >= target_auth) return 1
		else return 0
	if(same_department)
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
	//	if(user_rank >= target_rank) return 1
		if(user_auth >= target_auth) return 1
		else return 0
	return 0



/datum/world_faction/proc/create_faction_account()
	central_account = create_account(name, 0)
	central_account.account_type = 2

/datum/world_faction/proc/proposal_approved(var/datum/proposal/proposal)
	return 0

/datum/world_faction/proc/proposal_denied(var/datum/proposal/proposal)
	return 0

/datum/world_faction/proc/get_access_name(var/access)
	var/datum/access_category/core/core = new()
	for(var/datum/access_category/access_category in access_categories+core)
		if(access in access_category.accesses) return access_category.accesses[access]
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


/datum/assignment/New(var/title, var/pay)
	if(title && pay)
		var/datum/accesses/access = new()
		access.name = title
		access.pay = pay
		accesses |= access
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

	var/task
	var/edit_authority = 1
	var/authority_restriction = 1

/datum/assignment/proc/get_title(var/rank)
	if(!rank)	rank = 1
	if(!accesses.len)
		message_admins("broken assignment [src.uid]")
		return "BROKEN"
	if(accesses.len < rank)
		var/datum/accesses/access = accesses[accesses.len]
		return access.name
	else
		var/datum/accesses/access = accesses[rank]
		return access.name


/datum/assignment/proc/get_pay(var/rank)
	if(!rank)	rank = 1
	if(!accesses.len)
		message_admins("broken assignment [src.uid]")
		return 0
	if(accesses.len < rank)
		var/datum/accesses/access = accesses[accesses.len]
		return access.pay
	else
		var/datum/accesses/access = accesses[rank]
		return access.pay


/datum/accesses
	var/list/accesses = list()
	var/expense_limit = 0
	var/pay
	var/name
	var/auth_req
	var/auth_level

/datum/assignment/after_load()
	..()

/datum/access_category
	var/name = ""
	var/list/accesses = list() // format-- list("11" = "Bridge Access")

/datum/access_category/core
	name = "Core Access"

/datum/access_category/core/New()
	accesses["101"] = "Access & Assignment Control"
	accesses["102"] = "Command Programs"
	accesses["103"] = "Reassignment/Promotion Vote"
	accesses["104"] = "Research Control"
	accesses["105"] = "Engineering Programs"
	accesses["106"] = "Medical Programs"
	accesses["107"] = "Security Programs"
	accesses["108"] = "Shuttle Control"
	accesses["109"] = "Machine Linking"
	accesses["110"] = "Computer Linking"
	accesses["111"] = "Budget View"
	accesses["112"] = "Contract Signing/Control"
	accesses["113"] = "Material Marketplace"

/obj/faction_spawner
	name = "Name to start faction with"
	var/name_short = "Faction Abbreviation"
	var/name_tag = "Faction Tag"
	var/uid = "faction_uid"
	var/password = "starting_password"
	var/network_name = "network name"
	var/network_uid = "network_uid"
	var/network_password
	var/network_invisible = FALSE
	var/decl/hierarchy/outfit/starter_outfit = /decl/hierarchy/outfit/job //Faction's base outfit, is overriden by creation screen

//Psy_commando:
//In order to reliably have the faction spawn and not be deleted, we need to have the faction spawned in LateInitialize().
//Otherwise, when globabl variables are initialized, the all_world_faction list may or may not be overwritten on startup, when not loading a save.
/obj/faction_spawner/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/faction_spawner/LateInitialize()
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
	fact.starter_outfit = starter_outfit
	LAZYDISTINCTADD(GLOB.all_world_factions, fact)
	qdel(src)
	return

/obj/faction_spawner/democratic
	var/purpose = ""

/obj/faction_spawner/democratic/LateInitialize()
	for(var/datum/world_faction/existing_faction in GLOB.all_world_factions)
		if(existing_faction.uid == uid)
			qdel(src)
			return
	var/datum/world_faction/democratic/fact = new()
	fact.name = name
	fact.abbreviation = name_short
	fact.short_tag = name_tag
	fact.uid = uid
	fact.password = password
	fact.network.name = network_name
	fact.network.net_uid = network_uid
	fact.purpose = src.purpose
	if(network_password)
		fact.network.secured = 1
		fact.network.password = network_password
	fact.network.invisible = network_invisible
	fact.starter_outfit = starter_outfit
	LAZYDISTINCTADD(GLOB.all_world_factions, fact)
	qdel(src)
	return



/datum/module_objective
	var/name = "Objective name"
	var/payout = 0 // how much to pay upon completion
	var/research_payout = 0 // ho many research points to award

	var/filled = 0 // how much has been provided of whatever is required
	var/required = 10 // How much of whatever is required to fill the objective

	var/completed = 0 // is the objective completed

	var/list/unique_characters = list() // a list of unique characters for objective tracking
	var/list/unique_factions = list() // a list of unique factions for objective tracking

	var/datum/world_faction/business/parent


/datum/module_objective/proc/check_completion()
	if(completed) return 1
	if(filled >= required)
		completed = 1
		if(parent)
			var/datum/transaction/Te = new("Completed Objective", "Nexus Economic Stimulus", payout, "Nexus Economic Module")
			parent.central_account.do_transaction(Te)
		return 1

/datum/module_objective/proc/get_status()
	if(completed)
		return "Objective Complete. [payout]$$ and [research_payout] tech has been awarded to the business."
	else
		return "[filled] out of [required] complete."

/datum/module_objective/hourly // these are for every 2 hours
	payout = 250
	research_payout = 100


/datum/module_objective/hourly/visitors
	name = "Have 7 people visit an area controlled by your business and remain for long enough to be counted."
	required = 7

/datum/module_objective/hourly/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/hourly/revenue
	name = "Earn 350$$ in revenue from any source by providing a useful function in the economy."
	required = 350

/datum/module_objective/hourly/employees
	name = "Have 3 employees get paid for productively working."
	required = 3

/datum/module_objective/hourly/cost
	name = "Spend 300$$ out of the business account for useful goods and services."
	required = 300

/datum/module_objective/hourly/sales
	name = "Have 4 people or businesses pay us through an invoice."
	required = 4

/datum/module_objective/hourly/monsters
	name = "Have clocked in employees kill 5 wilderness creatures."
	required = 5

/datum/module_objective/hourly/travel
	name = "Have clocked in employees travel to 2 different wilderness sectors and remain long enough to be counted."
	required = 2

/datum/module_objective/hourly/travel/check_completion()
	if(parent)
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()
/datum/module_objective/hourly/publish_article
	name = "Publish a quality article in the news feed."
	required = 1

/datum/module_objective/hourly/publish_book
	name = "Add a new book to the library database."
	required = 1

/datum/module_objective/hourly/contract
	name = "Have an individual or organization sign a new contract with us."
	required = 1

/datum/module_objective/hourly/fabricate
	name = "Fabricate 15 items to sell or help us conduct business."
	required = 15


/datum/module_objective/daily
	payout = 650
	research_payout = 400

/datum/module_objective/daily/visitors
	name = "Have 20 people visit an area controlled by your business and remain for long enough to be counted."
	required = 20

/datum/module_objective/daily/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/daily/revenue
	name = "Earn 1100$$ in revenue from any source by providing a useful function in the economy."
	required = 1100

/datum/module_objective/daily/employees
	name = "Have 6 employees get paid for productively working."
	required = 6

/datum/module_objective/daily/cost
	name = "Spend 1000$$ out of the business account for useful goods and services."
	required = 1000

/datum/module_objective/daily/sales
	name = "Have 10 people or businesses pay us through an invoice."
	required = 10

/datum/module_objective/daily/monsters
	name = "Have 25 wilderness creatures die in proximity to a clocked in employee."
	required = 25

/datum/module_objective/daily/travel
	name = "Have clocked in employees travel to 4 different wilderness sectors and remain long enough to be counted."
	required = 4


/datum/module_objective/daily/travel/check_completion()
	if(parent)
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()

/datum/module_objective/daily/article_viewers
	name = "Have 15 unique viewers for articles in your news feed."
	required = 15

/datum/module_objective/daily/publish_book
	name = "Add 3 books printed by seperate individuals to the library database."
	required = 3

/datum/module_objective/daily/contract
	name = "Have 2 individuals or organizations sign new contracts with us."
	required = 2

/datum/module_objective/daily/fabricate
	name = "Fabricate 40 items to sell or help us conduct business."
	required = 40


/datum/module_objective/weekly
	payout = 1200
	research_payout = 1000

/datum/module_objective/weekly/visitors
	name = "Have 60 people visit an area controlled by your business and remain for long enough to be counted."
	required = 60

/datum/module_objective/weekly/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/weekly/employees
	name = "Have 12 employees get paid for productively working."
	required = 12

/datum/module_objective/weekly/revenue
	name = "Earn 6500$$ in revenue from any source by providing a useful function in the economy."
	required = 6500


/datum/module_objective/weekly/cost
	name = "Spend 6000$$ out of the business account for useful goods and services."
	required = 6000

/datum/module_objective/weekly/sales
	name = "Have 40 people or businesses pay us through an invoice."
	required = 40

/datum/module_objective/weekly/monsters
	name = "Have 100 wilderness creatures die in proximity to a clocked in employee."
	required = 100

/datum/module_objective/weekly/travel
	name = "Have clocked in employees travel to 8 different wilderness sectors and remain long enough to be counted."
	required = 8

/datum/module_objective/weekly/travel/check_completion()
	if(parent)
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()

/datum/module_objective/weekly/article_viewers
	name = "Have 40 unique viewers for articles in your news feed."
	required = 40

/datum/module_objective/weekly/publish_book
	name = "Add 7 books printed by seperate individuals to the library database."
	required = 3

/datum/module_objective/weekly/contract
	name = "Have 6 individuals or organizations sign new contracts with us."
	required = 6

/datum/module_objective/weekly/fabricate
	name = "Fabricate 200 items to sell or help us conduct business."
	required = 200










/datum/world_faction/business/get_limits()
	rebuild_limits()
	return limits
	/**
	var/datum/machine_limits/final_limits = new()
	var/datum/machine_limits/module_limits = module.levels[module.current_level]
	var/datum/machine_limits/spec_limits = module.spec.limits

	final_limits.genfabs = module_limits.genfabs
	final_limits.engfabs = module_limits.engfabs
	final_limits.medicalfabs = module_limits.medicalfabs
	final_limits.voidfabs = module_limits.voidfabs
	final_limits.ataccessories = module_limits.ataccessories
	final_limits.atnonstandards = module_limits.atnonstandards
	final_limits.atstandards = module_limits.atstandards
	final_limits.ammofabs = module_limits.ammofabs
	final_limits.consumerfabs = module_limits.consumerfabs
	final_limits.servicefabs = module_limits.servicefabs
	final_limits.drills = module_limits.drills
	final_limits.botany = module_limits.botany
	final_limits.shuttles = module_limits.shuttles
	final_limits.apcs = module_limits.apcs
	final_limits.tcomms = module_limits.tcomms


	final_limits.limit_genfab = module_limits.limit_genfab + spec_limits.limit_genfab
	final_limits.limit_engfab = module_limits.limit_engfab + spec_limits.limit_engfab
	final_limits.limit_medicalfab = module_limits.limit_medicalfab + spec_limits.limit_medicalfab
	final_limits.limit_voidfab = module_limits.limit_voidfab + spec_limits.limit_voidfab
	final_limits.limit_ataccessories = module_limits.limit_ataccessories + spec_limits.limit_ataccessories
	final_limits.limit_atnonstandard = module_limits.limit_atnonstandard + spec_limits.limit_atnonstandard
	final_limits.limit_atstandard = module_limits.limit_atstandard + spec_limits.limit_atstandard
	final_limits.limit_ammofab = module_limits.limit_ammofab + spec_limits.limit_ammofab
	final_limits.limit_consumerfab = module_limits.limit_consumerfab + spec_limits.limit_consumerfab
	final_limits.limit_servicefab = module_limits.limit_servicefab + spec_limits.limit_servicefab
	final_limits.limit_drills = module_limits.limit_drills + spec_limits.limit_drills
	final_limits.limit_botany = module_limits.limit_botany + spec_limits.limit_botany
	final_limits.limit_shuttles = module_limits.limit_shuttles + spec_limits.limit_shuttles
	final_limits.limit_area = module_limits.limit_area + spec_limits.limit_area
	final_limits.limit_tcomms = module_limits.limit_tcomms + spec_limits.limit_tcomms
	final_limits.limit_tech_combat = min(4, module_limits.limit_tech_combat + spec_limits.limit_tech_combat)
	final_limits.limit_tech_consumer = min(4, module_limits.limit_tech_consumer + spec_limits.limit_tech_consumer)
	final_limits.limit_tech_engi = min(4, module_limits.limit_tech_engi + spec_limits.limit_tech_engi)
	final_limits.limit_tech_general = min(4, module_limits.limit_tech_general + spec_limits.limit_tech_general)
	final_limits.limit_tech_medical = min(4, module_limits.limit_tech_medical + spec_limits.limit_tech_medical)
	return final_limits
	**/
/datum/machine_limits
	var/cost = 0 // used when this serves as a business level datum

	var/limit_genfab = 0
	var/list/genfabs = list()
	var/limit_engfab = 0
	var/list/engfabs = list()
	var/limit_medicalfab = 0
	var/list/medicalfabs = list()
	var/limit_mechfab = 0
	var/list/mechfabs = list()
	var/limit_voidfab = 0
	var/list/voidfabs = list()
	var/limit_ataccessories = 0
	var/list/ataccessories = list()
	var/limit_atnonstandard = 0
	var/list/atnonstandards = list()
	var/limit_atstandard = 0
	var/list/atstandards = list()
	var/limit_ammofab = 0
	var/list/ammofabs = list()
	var/limit_consumerfab = 0
	var/list/consumerfabs = list()
	var/limit_servicefab = 0
	var/list/servicefabs = list()

	var/limit_drills = 0
	var/list/drills = list()

	var/limit_botany = 0
	var/list/botany = list()

	var/limit_shuttles = 0
	var/list/shuttles = list()

	var/limit_area = 0
	var/list/apcs = list()
	var/claimed_area = 0


	var/limit_tcomms = 0
	var/list/tcomms = list()



	var/limit_tech_general = 0
	var/limit_tech_engi = 0
	var/limit_tech_medical = 0
	var/limit_tech_consumer = 0
	var/limit_tech_combat = 0


	var/desc = ""


/datum/machine_limits/democracy
	limit_genfab = 5
	limit_engfab = 5
	limit_medicalfab = 5
	limit_mechfab = 5
	limit_voidfab = 5
	limit_ataccessories = 5
	limit_atnonstandard = 5
	limit_atstandard = 5
	limit_ammofab = 5
	limit_consumerfab = 5
	limit_servicefab = 5
	limit_drills = 5
	limit_botany = 10
	limit_shuttles = 10
	limit_area = 100000
	limit_tcomms = 5
	limit_tech_general = 4
	limit_tech_engi = 4
	limit_tech_medical = 4
	limit_tech_consumer = 4
	limit_tech_combat = 4




// ENGINEERING LIMITS

/datum/machine_limits/eng/spec/tcomms
	limit_tcomms = 3
	limit_shuttles = 2
	limit_voidfab = 1

/datum/machine_limits/eng/spec/realestate
	cost = 0
	limit_tech_consumer = 2
	limit_area = 400
	limit_consumerfab = 1

/datum/machine_limits/eng/one
	limit_tech_engi = 2
	limit_tech_general = 1
	limit_shuttles = 1
	limit_area = 300
	limit_genfab = 2
	limit_engfab = 2
	limit_tcomms = 1
	limit_voidfab = 1


/datum/machine_limits/eng/two
	cost = 1000
	limit_tech_engi = 3
	limit_tech_general = 2
	limit_shuttles = 1
	limit_area = 400
	limit_genfab = 3
	limit_engfab = 3
	limit_voidfab = 1
	limit_tcomms = 1
	desc = "Increase area size, tech levels and add an extra to engineering and general fabricator limit."

/datum/machine_limits/eng/three
	cost = 3000
	limit_tech_engi = 4
	limit_tech_general = 3
	limit_shuttles = 2
	limit_area = 500
	limit_genfab = 4
	limit_engfab = 4
	limit_voidfab = 2
	limit_tcomms = 2
	desc = "Increase area size, tech levels and adds an extra shuttle, telecomms machine and extra fabricators."

/datum/machine_limits/eng/four
	cost = 7500
	limit_tech_engi = 4
	limit_tech_general = 4
	limit_tech_medical = 1
	limit_tech_consumer = 1
	limit_shuttles = 3
	limit_area = 600
	limit_genfab = 5
	limit_engfab = 5
	limit_voidfab = 3
	limit_tcomms = 3
	limit_consumerfab = 1
	limit_medicalfab = 1
	desc = "Gain final tech levels, area limit, extra fabricators plus gain an extra shuttle and a medical fabricator."
// END ENGINEERING LIMITS

// RETAIL LIMITS

/datum/machine_limits/retail/spec/combat
	limit_tech_combat = 2
	limit_ammofab = 1
	limit_shuttles = 1
/datum/machine_limits/retail/spec/bigstore
	limit_tech_engi = 2
	limit_engfab = 1
	limit_voidfab = 1
	limit_area = 200

/datum/machine_limits/retail/one
	limit_tech_consumer = 2
	limit_tech_general = 1
	limit_area = 200
	limit_genfab = 2
	limit_consumerfab = 2
	limit_ataccessories = 1
	limit_atstandard = 1
	limit_atnonstandard = 1


/datum/machine_limits/retail/two
	cost = 1000
	limit_tech_consumer = 3
	limit_tech_general = 2
	limit_area = 300
	limit_genfab = 3
	limit_consumerfab = 3
	limit_ataccessories = 2
	limit_atstandard = 2
	limit_atnonstandard = 2
	desc = "Increase area size, tech levels and add an extra to many fabricator limits."



/datum/machine_limits/retail/three
	cost = 3000
	limit_tech_consumer = 4
	limit_tech_general = 3
	limit_tech_combat = 1
	limit_tech_engi = 1
	limit_area = 400
	limit_genfab = 3
	limit_consumerfab = 3
	limit_ataccessories = 2
	limit_atstandard = 2
	limit_atnonstandard = 2
	limit_voidfab = 1
	limit_shuttles = 1
	desc = "Increase area size, tech levels, fabricator limits but most importantly adds a shuttle and EVA fabricator."

/datum/machine_limits/retail/four
	cost = 7500
	limit_tech_consumer = 4
	limit_tech_general = 4
	limit_tech_combat = 2
	limit_tech_engi = 2
	limit_area = 500
	limit_genfab = 3
	limit_consumerfab = 3
	limit_ataccessories = 3
	limit_atstandard = 3
	limit_atnonstandard = 3
	limit_voidfab = 2
	limit_shuttles = 2
	limit_ammofab = 1
	limit_engfab = 1
	desc = "Gain final tech levels, area limit, extra fabricators including an engineering and combat fabricator, plus an extra shuttle."

// END RETAIL LIMITS

// MEDICAL LIMITS

/datum/machine_limits/medical/spec/paramedic
	limit_voidfab = 1
	limit_shuttles = 2

/datum/machine_limits/medical/spec/pharma
	limit_servicefab = 1
	limit_botany = 2
	limit_area = 200

/datum/machine_limits/medical/one
	limit_tech_medical = 2
	limit_tech_general = 1
	limit_area = 300
	limit_genfab = 2
	limit_medicalfab = 2


/datum/machine_limits/medical/two
	cost = 1000
	limit_tech_medical = 3
	limit_tech_general = 2
	limit_area = 400
	limit_genfab = 3
	limit_medicalfab = 3
	limit_voidfab = 1
	desc = "Increase area size, tech levels, fabricator limits and gain an EVA equipment fabricator."

/datum/machine_limits/medical/three
	cost = 3000
	limit_tech_medical = 4
	limit_tech_general = 3
	limit_area = 500
	limit_genfab = 3
	limit_medicalfab = 3
	limit_voidfab = 2
	limit_shuttles = 1
	limit_botany = 1
	limit_servicefab = 1
	desc = "Increase area size, tech levels, fabricator limits, botany tray, service fabricator, and a shuttle limit."
/datum/machine_limits/medical/four
	cost = 7500
	limit_tech_medical = 4
	limit_tech_general = 4
	limit_area = 600
	limit_genfab = 4
	limit_medicalfab = 4
	limit_voidfab = 3
	limit_shuttles = 2
	limit_botany = 3
	limit_servicefab = 1
	desc = "Gain final tech levels, area limit, extra fabricators, botany trays, plus an extra shuttle."
// END MEDICAL LIMITS

// SERVICE LIMITS

/datum/machine_limits/service/spec/culinary
	limit_tech_engi = 1
	limit_engfab = 1
	limit_area = 200

/datum/machine_limits/service/spec/farmer
	limit_botany = 4
	limit_atstandard = 1
	limit_ataccessories = 1

/datum/machine_limits/service/one
	limit_tech_consumer = 2
	limit_tech_general = 1
	limit_area = 200
	limit_genfab = 2
	limit_servicefab = 2
	limit_botany = 2

/datum/machine_limits/service/two
	cost = 1250
	limit_tech_consumer = 3
	limit_tech_general = 2
	limit_area = 300
	limit_genfab = 3
	limit_servicefab = 3
	limit_botany = 3
	desc = "Increase area size, tech levels, fabricator limits and get an extra botany tray."
/datum/machine_limits/service/three
	cost = 2500
	limit_tech_consumer = 4
	limit_tech_general = 3
	limit_area = 400
	limit_genfab = 3
	limit_servicefab = 3
	limit_botany = 3
	limit_voidfab = 1
	limit_shuttles = 1
	desc = "Increase area size, tech levels, fabricator limits and get an EVA fabricator and shuttle limit."
/datum/machine_limits/service/four
	cost = 5000
	limit_tech_consumer = 4
	limit_tech_general = 4
	limit_tech_medical = 1
	limit_tech_engi = 1
	limit_area = 500
	limit_genfab = 3
	limit_servicefab = 3
	limit_botany = 4
	limit_voidfab = 2
	limit_shuttles = 2
	limit_engfab = 1
	limit_medicalfab = 1
	desc = "Gain final tech levels, area limit, extra fabricators including a medical and engineering fabricator, botany trays, plus an extra shuttle."
// END SERVICE LIMITS

// MINING LIMITS

/datum/machine_limits/mining/spec/monsterhunter
	limit_tech_medical = 2
	limit_medicalfab = 1
	limit_area = 200
	limit_botany = 2

/datum/machine_limits/mining/spec/massdrill
	limit_tech_engi = 1
	limit_engfab = 1
	limit_drills = 2
	limit_shuttles = 1

/datum/machine_limits/mining/one
	limit_tech_combat = 2
	limit_tech_general = 1
	limit_area = 200
	limit_genfab = 2
	limit_ammofab = 2
	limit_drills = 1
	limit_voidfab = 1
	limit_shuttles = 1

/datum/machine_limits/mining/two
	cost = 1000
	limit_tech_combat = 3
	limit_tech_general = 2
	limit_area = 300
	limit_genfab = 3
	limit_ammofab = 3
	limit_drills = 2
	limit_voidfab = 2
	limit_shuttles = 1
	desc = "Increase area size, tech levels, fabricator limits and an extra drill."

/datum/machine_limits/mining/three
	cost = 3000
	limit_tech_combat = 4
	limit_tech_general = 3
	limit_area = 400
	limit_genfab = 3
	limit_ammofab = 3
	limit_drills = 3
	limit_voidfab = 3
	limit_shuttles = 2
	limit_botany = 1
	desc = "Increase area size, tech levels, fabricators, drills, and adds a botany tray plus an extra shuttle."

/datum/machine_limits/mining/four
	cost = 7500
	limit_tech_combat = 4
	limit_tech_general = 4
	limit_tech_engi = 1
	limit_tech_medical = 1
	limit_area = 500
	limit_genfab = 3
	limit_ammofab = 3
	limit_drills = 4
	limit_voidfab = 3
	limit_shuttles = 3
	limit_botany = 2
	limit_engfab = 1
	limit_medicalfab = 1
	desc = "Gain final tech levels, area limit, extra fabricators including a medical and engineering fabricator, botany trays, drills plus an extra shuttle."


// END MINING LIMITS


// MEDIA LIMITS

/datum/machine_limits/media/spec/journalism
	limit_voidfab = 1
	limit_shuttles = 1
	limit_tech_medical = 1
	limit_medicalfab = 1

/datum/machine_limits/media/spec/bookpublishing
	limit_tech_engi = 1
	limit_engfab = 1
	limit_area = 200

/datum/machine_limits/media/one
	limit_tech_consumer = 1
	limit_tech_general = 1
	limit_area = 200
	limit_genfab = 2
	limit_consumerfab = 1

/datum/machine_limits/media/two
	cost = 750
	limit_tech_consumer = 2
	limit_tech_general = 2
	limit_area = 300
	limit_genfab = 3
	limit_consumerfab = 2
	desc = "Increase area size, tech levels and fabricator limits."
/datum/machine_limits/media/three
	cost = 1600
	limit_tech_consumer = 3
	limit_tech_general = 3
	limit_area = 400
	limit_genfab = 3
	limit_consumerfab = 2
	desc = "Increase area size, tech levels and fabricator limits."
/datum/machine_limits/media/four
	cost = 3200
	limit_tech_consumer = 4
	limit_tech_general = 4
	limit_area = 500
	limit_genfab = 3
	limit_consumerfab = 2
	limit_shuttles = 1
	desc = "Gain final tech levels, area limit, fabricators and a shuttle."


// END MEDIA LIMITS


/datum/business_spec
	var/name = ""
	var/desc = ""
	var/datum/machine_limits/limits
	var/list/hourly_objectives = list()
	var/list/daily_objectives = list()
	var/list/weekly_objectives = list()
/datum/business_spec/New()
	limits = new limits()

/datum/business_module
	var/cost = 750
	var/name = ""
	var/desc = ""
	var/current_level = 1
	var/list/levels = list()
	var/datum/business_spec/spec
	var/list/specs = list()

	var/list/hourly_objectives = list()
	var/list/daily_objectives = list()
	var/list/weekly_objectives = list()

	var/list/starting_items = list()

/datum/business_module/New()
	var/list/specs_c = specs.Copy()
	specs = list()
	for(var/x in specs_c)
		specs |= new x()
	var/list/levels_c = levels.Copy()
	levels = list()
	for(var/x in levels_c)
		levels |= new x()

/datum/business_module/engineering
	cost = 800
	name = "Engineering"
	desc = "An engineering business has tools to develop areas of the station and construct shuttles plus the unique capacity to manage private radio communications. Engineering businesses can reserve larger spaces than other businesses and develop those into residential areas to be leased to individuals."
	levels = list(/datum/machine_limits/eng/one, /datum/machine_limits/eng/two, /datum/machine_limits/eng/three, /datum/machine_limits/eng/four)
	specs = list(/datum/business_spec/eng/realestate, /datum/business_spec/eng/tcomms)
	hourly_objectives = list(/datum/module_objective/hourly/revenue, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/contract)
	daily_objectives = list(/datum/module_objective/daily/revenue, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/contract)
	weekly_objectives = list(/datum/module_objective/weekly/revenue, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/contract)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/clothing/gloves/insulated/cheap = 2, /obj/item/weapon/storage/belt/utility/full = 2)

/datum/business_spec/eng/realestate
	name = "Real-Estate"
	desc = "With this specialization the engineering business gains another 200 tiles of area limit plus a consumer fabricator limit and two levels of consumer tech limit so that you can better furnish interiors."
	limits = /datum/machine_limits/eng/spec/realestate

/datum/business_spec/eng/tcomms
	name = "Communication & Travel"
	desc = "This specialization grants operation of three extra telecomms machines that can operate three frequencies each. It also allows for two shuttles and an extra EVA fabricator."
	limits = /datum/machine_limits/eng/spec/realestate


/datum/business_module/medical
	cost = 700
	name = "Medical"
	desc = "A medical firm has unqiue capacity to develop medications and implants. Programs can be used to register clients under your care and recieve a weekly insurance payment from them, in exchange for tracking their health and responding to medical emergencies."
	specs = list(/datum/business_spec/medical/pharma, /datum/business_spec/medical/paramedic)
	levels = list(/datum/machine_limits/medical/one, /datum/machine_limits/medical/two, /datum/machine_limits/medical/three, /datum/machine_limits/medical/four)
	hourly_objectives = list(/datum/module_objective/hourly/visitors, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/contract)
	daily_objectives = list(/datum/module_objective/daily/visitors, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/contract)
	weekly_objectives = list(/datum/module_objective/weekly/visitors, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/contract)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/weapon/storage/firstaid/surgery/full = 1, /obj/item/clothing/gloves/latex = 2, /obj/item/device/scanner/health = 2)

/datum/business_spec/medical/paramedic
	name = "Paramedic"
	desc = "The Paramedic specialization allows the business to operate a voidsuit fabricator and two shuttles to retrieve clients from the dangerous sectors of the Nexus outer-space."
	limits = /datum/machine_limits/medical/spec/paramedic
	hourly_objectives = list(/datum/module_objective/hourly/travel)
	daily_objectives = list(/datum/module_objective/daily/travel)
	weekly_objectives = list(/datum/module_objective/weekly/travel)

/datum/business_spec/medical/pharma
	name = "Pharmacy"
	desc = "This specialization gives the business capacity for a service fabricator and two botany trays that can produce reagents that can be further refined into valuable and effective medicines. It also grants 200 extra tiles to the area limit so you can have larger medical facilities."
	limits = /datum/machine_limits/medical/spec/pharma


/datum/business_module/retail
	cost = 700
	name = "Retail"
	desc = "A retail business has exclusive production capacity so that they can sell clothing and furniture to individuals and organizations. With additional specialization they can branch out into combat equipment or engineering supplies, but they are reliant on the material market to supply their production."
	levels = list(/datum/machine_limits/retail/one, /datum/machine_limits/retail/two, /datum/machine_limits/retail/three, /datum/machine_limits/retail/four)
	specs = list(/datum/business_spec/retail/combat, /datum/business_spec/retail/bigstore)
	hourly_objectives = list(/datum/module_objective/hourly/visitors, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/sales, /datum/module_objective/weekly/fabricate, /datum/module_objective/hourly/revenue)
	daily_objectives = list(/datum/module_objective/daily/visitors, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/sales, /datum/module_objective/weekly/fabricate, /datum/module_objective/daily/revenue)
	weekly_objectives = list(/datum/module_objective/weekly/visitors, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/sales, /datum/module_objective/weekly/fabricate, /datum/module_objective/weekly/revenue)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 4, /obj/item/stack/material/glass/ten = 4)

/datum/business_spec/retail/combat
	name = "Combat"
	desc = "The Combat specialization gives limits for a combat fabricator and an early combat tech limit which will increase as the business network expands. You can also maintain a shuttle, but you'll need to purchase the EVA equipment elsewhere."
	limits = /datum/machine_limits/retail/spec/combat

/datum/business_spec/retail/bigstore
	name = "Grand Emporium"
	desc = "This specialization gives the business capacity for an engineering fabricator, an EVA fabricator, an engineering tech limit, plus 200 extra tiles for the area limit so that you can produce a grand emporium that sells all manner of things."
	limits = /datum/machine_limits/retail/spec/bigstore



/datum/business_module/service
	cost = 700
	name = "Service"
	desc = "A service business has a fabricator that can produce culinary and botany equipment. A service business can serve food or drink and supply freshly grown plants for other organizations, a crucial source of cloth and biomass."
	levels = list(/datum/machine_limits/service/one, /datum/machine_limits/service/two, /datum/machine_limits/service/three, /datum/machine_limits/service/four)
	specs = list(/datum/business_spec/service/culinary, /datum/business_spec/service/farmer)
	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/sales, /datum/module_objective/hourly/cost)
	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/sales, /datum/module_objective/daily/cost)
	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/sales, /datum/module_objective/weekly/cost)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 3, /obj/item/stack/material/glass/ten = 3, /obj/item/seeds/potatoseed = 1, /obj/item/seeds/towermycelium = 1)

/datum/business_spec/service/culinary
	name = "Culinary"
	desc = "This specialization gives 200 extra tiles to the area limit, plus an engineering fabricator and tech level so that you can put together the perfect space for your customers."
	limits = /datum/machine_limits/service/spec/culinary
	hourly_objectives = list(/datum/module_objective/hourly/visitors)
	daily_objectives = list(/datum/module_objective/daily/visitors)
	weekly_objectives = list(/datum/module_objective/weekly/visitors)


/datum/business_spec/service/farmer
	name = "Farming"
	desc = "Farming gives four additional botany trays and limits for two of the exclusive auto-tailor types, so you can process cloth into a finished product for selling. The extra botany trays can produce plants or reagents to be sold to all sorts of other businesses."
	limits = /datum/machine_limits/service/spec/farmer


/datum/business_module/mining
	cost = 800
	name = "Mining"
	desc = "Mining companies send teams out into the hostile outer-space armed with picks, drills and a variety of other EVA equipment plus weapons and armor to defend themselves. The ores they recover can be processed and then sold on the Material Marketplace to other organizations for massive profits."
	levels = list(/datum/machine_limits/mining/one, /datum/machine_limits/mining/two, /datum/machine_limits/mining/three, /datum/machine_limits/mining/four)
	specs = list(/datum/business_spec/mining/massdrill, /datum/business_spec/mining/monsterhunter)
	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/travel, /datum/module_objective/hourly/cost)
	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/travel, /datum/module_objective/daily/cost)
	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/travel, /datum/module_objective/weekly/cost)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/weapon/pickaxe = 2, /obj/item/clothing/head/helmet/space/mining = 2, /obj/item/clothing/suit/space/mining = 2)



/datum/business_spec/mining/massdrill
	name = "Mass Production"
	desc = "The Mass Production specialization allows operation of two extra drills, an extra shuttle, plus an engineering fabricator and a engineering tech limit. Take multiple teams to harvest materials from the managable sectors of outer-space."
	limits = /datum/machine_limits/mining/spec/massdrill

/datum/business_spec/mining/monsterhunter
	name = "Monster Hunter"
	desc = "This specialization gives the business capacity for a medical fabricator and tech that can produce machines and equipment to keep employees alive while fighting the top tier of monsters. Travel to the outer reaches and dig for riches, let the monsters come to you."
	limits = /datum/machine_limits/retail/spec/bigstore
	hourly_objectives = list(/datum/module_objective/hourly/monsters)
	daily_objectives = list(/datum/module_objective/daily/monsters)
	weekly_objectives = list(/datum/module_objective/weekly/monsters)

/datum/business_module/media
	cost = 600
	name = "Media"
	desc = "Media companies have simple production and tech capacities but exclusive access to programs that can publish books and news articles for paid redistribution. It is also much less expensive than other types, making it a good choice for generic business."
	levels = list(/datum/machine_limits/media/one, /datum/machine_limits/media/two, /datum/machine_limits/media/three, /datum/machine_limits/media/four)
	specs = list(/datum/business_spec/media/journalism, /datum/business_spec/media/bookpublishing)
	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/sales)
	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/sales)
	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/sales)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/device/camera = 2, /obj/item/weapon/paper_bin = 1, /obj/item/weapon/pen = 2)


/datum/business_spec/media/journalism
	name = "Journalism"
	desc = "Specializing in Journalism gives capacity for an EVA fabricator and shuttle, plus a medical fabricator with basic medical tech limitation. Explore every corner of Nexus-space, but best to carry basic medical supplies."
	limits = /datum/machine_limits/media/spec/journalism
	hourly_objectives = list(/datum/module_objective/hourly/publish_article)
	daily_objectives = list(/datum/module_objective/daily/article_viewers)
	weekly_objectives = list(/datum/module_objective/weekly/article_viewers)



/datum/business_spec/media/bookpublishing
	name = "Publishing"
	desc = "The Publishing specialization grants 200 extra tiles to the area limit and an engineering fabricator and tech limit. You can build a proper library and publishing house, or perhaps some other artistic facility."
	limits = /datum/machine_limits/media/spec/bookpublishing
	hourly_objectives = list(/datum/module_objective/hourly/publish_book)
	daily_objectives = list(/datum/module_objective/daily/publish_book)
	weekly_objectives = list(/datum/module_objective/weekly/publish_book)



/obj/machinery/economic_beacon
	name = "Economic Beacon"
	anchored = 1
	var/datum/world_faction/holder
	var/holder_uid

	var/list/connected_orgs = list()
	var/list/connected_orgs_uids = list()
	var/completed_objectives = 0
