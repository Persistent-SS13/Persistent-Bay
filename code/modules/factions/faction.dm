GLOBAL_LIST_EMPTY(all_world_factions)
GLOBAL_LIST_EMPTY(all_business)

GLOBAL_LIST_EMPTY(recent_articles)


var/PriorityQueue/all_feeds

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


/datum/NewsStory/proc/allowed(var/real_name)
	if(real_name in purchased)
		return 1
	if(parent.parent.parent.has_access(real_name, "Newsfeed"))
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

/datum/NewsIssue
	var/name = "None"
	var/list/stories = list()
	var/publish_date
	var/publisher = ""

	var/datum/NewsFeed/parent

	var/uid

/datum/NewsFeed
	var/name = "None"
	var/visible = 0
	var/datum/NewsIssue/current_issue
	var/list/all_issues = list()
	var/per_article = 20
	var/per_issue = 60
	var/announcement = "Breaking News!"
	var/last_published = 0


	var/datum/small_business/parent

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
	for(var/obj/machinery/newscaster/caster in allCasters)
		caster.newsAlert("(From [name]) [announcement] ([story.name])")
	GLOB.recent_articles |= story


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

/datum/world_faction/proc/get_leadername()
	return leader_name

/datum/world_faction/democratic/get_leadername()
	if(gov && gov.real_name != "")
		return gov.real_name
	else
		return leader_name


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

	var/list/reserved_frequencies() = list() // Reserved frequencies that the faction can create encryption keys from.

	var/datum/machine_limits/limits
	

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

	councillor_assignment = new()
	judge_assignment = new()
	governor_assignment = new()
	councillor_assignment.payscale = 30
	judge_assignment.payscale = 30
	governor_assignment.payscale = 45
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


/datum/world_faction/democratic

	var/datum/democracy/governor/gov

	var/datum/assignment/councillor_assignment
	var/datum/assignment/judge_assignment
	var/datum/assignment/governor_assignment

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


/datum/world_faction/business

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
	limits = new()
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

/datum/world_faction/democratic/get_assignment(var/assignment, var/real_name)
	if(is_judge(real_name))
		return judge_assignment
	if(is_councillor(real_name))
		return councillor_assignment
	if(is_governor(real_name))
		return governor_assignment
	return ..()

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
		var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
		if(assignment)
			if(assignment.parent)
				return assignment.parent.command_faction
	return 0

/datum/world_faction/proc/outranks(var/real_name, var/target)
	if(real_name == get_leadername())
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
	var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
	if(assignment)
		if(assignment.parent)
			user_command = assignment.parent.command_faction
			if(assignment.parent.head_position && assignment.parent.head_position.name == assignment.name)
				user_leader = 1
	else
		return 0
	var/datum/assignment/target_assignment = get_assignment(target_record.assignment_uid, target_record.get_name())
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

/datum/world_faction/proc/get_access_name(var/access)
	for(var/datum/access_category/access_category in access_categories)
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
	accesses["100"] = "Logistics Control, Leadership"
	accesses["101"] = "Command Machinery"
	accesses["102"] = "Promotion/Demotion Vote"
	accesses["103"] = "Reassignment"
	accesses["104"] = "Edit Employment Records"
	accesses["105"] = "Reset Expenses"
	accesses["106"] = "Suspension/Termination"
	accesses["107"] = "Engineering Programs"
	accesses["108"] = "Medical Programs"
	accesses["109"] = "Security Programs"
	accesses["110"] = "Networking Programs"
	accesses["111"] = "Lock Electronics"
	accesses["112"] = "Import Approval"
	accesses["113"] = "Invoicing & Exports"
	accesses["114"] = "Science Machinery & Programs"
	accesses["115"] = "Shuttle Control & Access"

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


/datum/beacon_objective
	var/name = "Objective name"
	var/payout = 0 // how much to pay upon completion
	var/req_level = 0 // required level of the beacon

	var/required = 10 // How much of whatever is required to fill the objective



/datum/beacon_objective/profit
	name = "Have X$$ in your business account, an increase of Y$$."

/datum/beacon_objective/sales_total
	name = "Do X$$ in sales to other residents."

/datum/beacon_objective/sales_unique
	name = "Do sales with X unique people."

/datum/beacon_objective/export
	name = "Deliver X units of Y via telepad."

/datum/beacon_objective/survey_beacon
	name = "Survey the sensor beacon X located in zone Y."

/datum/beacon_objective/publish_articles
	name = "Publish X amount of quality articles."

/datum/beacon_objective/article_sales
	name = "Have your articles purchased X amount of time."

/datum/beacon_objective/listeners
	name = "Have X amount of patrons in the vicinity of one of your music emitters."

/datum/beacon_objective/reaction
	name = "Produce X units of Y in a chemmaster."

/datum/beacon_objective/drugs
	name = "Produce X 10 unit Ys (patches, pills) in a chemmaster."

/datum/beacon_objective/production
	name = "Produce X amount of objects in a Z (fabricator type)."

/datum/beacon_objective/recycling
	name = "Break down X objects in a recycling machine."

/datum/beacon_objective/cleaning
	name = "Have a clocked in employee clean X amount of tiles."

/datum/beacon_objective/unlock_designs
	name = "Unlock X amount of designs."

/datum/beacon_objective/produce_designs
	name = "Produce X amount of design disks."

/datum/beacon_objective/farm
	name = "Grow X amount of Y."

/datum/beacon_objective/farm/food
	name = "Grow X amount of Y (food)."

/datum/beacon_objective/farm/drugs
	name = "Grow X amount of Y (drugs)."

/datum/beacon_objective/add_books
	name = "Add X unique and quality books to your library network."

/datum/beacon_objective/bind_books
	name = "Have X amount of books printed off your library network."

/datum/beacon_objective/body_scans
	name = "Have scan X unique indivduals in a body scanner."


/datum/machine_limits
	var/limit_genfab = 0
	var/list/genfabs = list()
	var/limit_engfab = 0
	var/list/engfabs = list()
	var/limit_medfab = 0
	var/list/medfabs = list()
	var/limit_mechfab = 0
	var/list/mechfabs = list()
	var/limit_voidfab = 0
	var/list/voidfabs = list()
	var/limit_ammofab = 0
	var/list/ammofabs = list()
	var/limit_ataccessories = 0
	var/list/ataccessories = list()
	var/limit_atnonstandard = 0
	var/list/atnonstandards = list()
	var/limit_atstandard = 0
	var/list/atstandards = list()
	var/limit_atstorage = 0
	var/list/atstorages = list()
	var/limit_attactical = 0
	var/list/attacticals = list()
	

/datum/business_module/minor/journalism

/datum/business_module/minor/art

/datum/business_module/minor/medical_simple

/datum/business_module/minor/mining_simple

/datum/business_module/minor/exploration

/datum/business_module/minor/catering

/datum/business_module/minor/retail

/datum/business_module/minor/manufacturing_simple

/datum/business_module/minor/engineering_simple

/datum/business_module/minor/chemistry

/datum/business_module/minor/research_simple

/datum/business_module/minor/security_simple

/datum/business_module/minor/janitorial


/datum/business_module/major/medical

/datum/business_module/major/mining

/datum/business_module/major/manufacturing

/datum/business_module/major/research

/datum/business_module/major/security



/obj/machinery/economic_beacon
	name = "Economic Beacon"
	anchored = 1
	var/datum/world_faction/holder
	var/holder_uid

	var/list/connected_orgs = list()
	var/list/connected_orgs_uids = list()
	var/completed_objectives = 0


