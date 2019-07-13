
/datum/money_account
	var/owner_name = ""
	var/account_number = 0
	var/remote_access_pin = 0
	var/money = 0
	var/reserved = 0
	var/list/transaction_log = list()
	var/suspended = 0
	var/security_level = 1	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login


	var/account_type = 1	//1 - personal account
							//2 - business account

	var/datum/world_faction/business/connected_business
	var/list/recently_paid = list()
	var/dupe_fixed = 0
	
/datum/money_account/New()
	ADD_SAVED_VAR(dupe_fixed)
	..()
	
/datum/money_account/after_load()
	all_money_accounts.Add(src)
	if(money < 0)
		money = 0
	..()
	return src

/datum/money_account/proc/do_transaction(var/datum/transaction/T)
	var/datum/money_account/nexus_account
	var/datum/world_faction/democratic/nexus = get_faction("nexus")
	if(nexus)
		nexus_account = nexus.central_account
	money = money + T.amount
	if(transaction_log.len > 50)
		transaction_log.Cut(1,2)
	transaction_log += T
	if(T.amount > 0 && connected_business)
		if(istype(connected_business))
			connected_business.pay_dividends(src, T.amount)
			connected_business.revenue_objectives(T.amount)
	else
		if(istype(connected_business))
			connected_business.cost_objectives(-T.amount)
	if(T.amount > 0 && nexus_account && nexus_account != src)
		nexus.pay_tax(src, T.amount)

/datum/money_account/proc/get_balance()
	. = 0
	for(var/datum/transaction/T in transaction_log)
		if(T.purpose == "Account creation")
			continue
		T.sanitize_amount()
		. += T.amount

/datum/transaction
	var/target_name = ""
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""
	var/source_terminal = ""

/datum/transaction/New(_target, _purpose, _amount, _source)
	..()
	date = stationdate2text()
	time = stationtime2text()
	target_name = _target
	purpose = _purpose
	amount = _amount
	source_terminal = _source

/datum/transaction/proc/sanitize_amount() //some place still uses (number) for negative amounts and I can't find it
	if(!istext(amount))
		return

	// Check if the text is numeric.
	var/text = amount
	amount = text2num(text)

	// Otherwise, the (digits) thing is going on.
	if(!amount)
		var/regex/R = regex("\\d+")
		R.Find(text)
		amount = -text2num(R.match)

/proc/create_account(var/new_owner_name = "Default user", var/starting_funds = 0, var/obj/machinery/computer/account_database/source_db)

	//create a new account
	var/datum/money_account/M = new()
	M.owner_name = new_owner_name
	M.remote_access_pin = rand(1111, 111111)
	M.money = starting_funds

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = new_owner_name
	T.purpose = "Account creation"
	T.amount = starting_funds
	if(!source_db)
		T.date = stationdate2text()
		T.time = stationtime2text()
		T.source_terminal = "NTGalaxyNet Frontier Accounts"

		M.account_number = random_id("station_account_number", 111111, 999999)
	else
		T.source_terminal = source_db.machine_id

		M.account_number = next_account_number
		next_account_number += rand(1,25)

		//create a sealed package containing the account details
		var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(source_db.loc)

		var/obj/item/weapon/paper/R = new /obj/item/weapon/paper(P)
		P.wrapped = R
		R.SetName("Account information: [M.owner_name]")
		R.info = "<b>Account details (confidential)</b><br><hr><br>"
		R.info += "<i>Account holder:</i> [M.owner_name]<br>"
		R.info += "<i>Account number:</i> [M.account_number]<br>"
		R.info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		R.info += "<i>Starting balance:</i> T[M.money]<br>"
		R.info += "<i>Date and time:</i> [stationtime2text()], [stationdate2text()]<br><br>"
		R.info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		R.info += "<i>Authorised officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		//stamp the paper
		var/image/stampoverlay = image('icons/obj/items/paper.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!R.stamped)
			R.stamped = new
		R.stamped += /obj/item/weapon/stamp
		R.overlays += stampoverlay
		R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	//add the account
	M.transaction_log.Add(T)
	all_money_accounts.Add(M)

	return M

/proc/charge_to_account(var/attempt_account_number, var/source_name, var/purpose, var/terminal_id, var/amount)
	var/datum/money_account/D = get_account(attempt_account_number)
	if(!D || D.suspended)
		return 0
	D.money = max(0, D.money + amount)

	//create a transaction log entry
	var/datum/transaction/T = new(source_name, purpose, amount, terminal_id)
	if(D.transaction_log.len > 50)
		D.transaction_log.Cut(1,2)
	D.transaction_log.Add(T)

	return 1



/proc/money_transfer(var/datum/money_account/payer, var/attempt_real_name, var/purpose, var/amount)
	if(!payer || amount > payer.money)
		return 0
	var/datum/money_account/D = get_account_record(attempt_real_name)
	if(!D || D.suspended)
		message_admins("no account found for [attempt_real_name]")
		return 0
	payer.recently_paid |= D
	var/datum/transaction/Te = new("[attempt_real_name]", purpose, -amount, 0)
	if(payer.transaction_log.len > 50)
		payer.transaction_log.Cut(1,2)
	payer.do_transaction(Te)

	//create a transaction log entry
	var/datum/transaction/T = new(payer.owner_name, purpose, amount, 0)
	if(D.transaction_log.len > 50)
		D.transaction_log.Cut(1,2)
	D.do_transaction(T)

	return 1

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	var/datum/money_account/D = get_account(attempt_account_number)
	if(D && D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
		return D

/proc/get_account_loadless(var/account_number)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == account_number)
			return D
/proc/get_account(var/account_number)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == account_number)
			return D
	var/datum/computer_file/report/crew_record/L = Retrieve_Record(account_number, 2)
	if(L)
		return L.linked_account
/proc/get_account_record(var/real_name)
	for(var/datum/computer_file/report/crew_record/L in GLOB.all_crew_records)
		if(L.get_name() == real_name)
			if(!L.linked_account)
				message_admins("NULL ACCOUNT FOR [real_name]")
				return null
			return L.linked_account
	var/datum/computer_file/report/crew_record/L = Retrieve_Record(real_name)
	if(L)
		return L.linked_account
