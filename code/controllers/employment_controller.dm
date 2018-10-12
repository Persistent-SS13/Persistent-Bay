var/datum/controller/employment_controller/employment_controller

/datum/controller/employment_controller
	var/timerbuffer = 0 //buffer for time check
	var/checkbuffer = 0
/datum/controller/employment_controller/New()
	timerbuffer = 1 HOUR
	checkbuffer = 5 MINUTES
	START_PROCESSING(SSprocessing, src)

/datum/controller/employment_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/controller/employment_controller/Process()
	if(round_duration_in_ticks < checkbuffer)
		return

	checkbuffer += 5 MINUTES

	var/payday = round_duration_in_ticks >= timerbuffer

	for(var/obj/item/organ/internal/stack/stack in GLOB.neural_laces)
		var/mob/employee = stack.get_owner()
		if(!employee || !employee.client) continue
		var/datum/employer = get_faction(stack.connected_faction)
		if(stack.business_mode && stack.connected_business && stack.connected_business != "")
			employer = get_business(stack.connected_business)
		if(employer)
			if(employee.client.inactivity <= 15 MINUTES && stack.duty_status)
				if(!employer:unpaid["[employee.real_name]"])
					employer:unpaid["[employee.real_name]"] = 1
				else
					employer:unpaid["[employee.real_name]"]++
			if(payday)
				if(istype(employer, /datum/small_business))
					var/datum/small_business/business = employer
					if(business.ceo_name == employee.real_name)
						var/payment = business.ceo_payrate * business.unpaid["[employee.real_name]"] / 12
						if(payment && !money_transfer(business.central_account, employee.real_name, "Payroll", payment))
							business.debts["[employee.real_name]"] += payment

					else
						var/datum/empdata = business.get_employee_data(employee.real_name)
						if(empdata)
							var/payment = business.get_employee_data(employee.real_name).pay_rate * business.unpaid["[employee.real_name]"] / 12
							if(payment && !money_transfer(business.central_account, employee.real_name, "Payroll", payment))
								business.debts["[employee.real_name]"] += payment

					
				else if(istype(employer, /datum/world_faction))
					var/datum/world_faction/faction = employer
					var/datum/computer_file/crew_record/record = faction.get_record(employee.real_name)
					if(!record)
						message_admins("no record found for [employee.real_name] during payday")
						continue
					var/datum/assignment/job = faction.get_assignment(record.assignment_uid)
					var/sanity = (record.rank > 1 ? job.ranks.len >= record.rank -1 : 1)
					var/payment
					if(sanity)
						payment = job != null ? (record.rank > 1 ? text2num(job.ranks[job.ranks[record.rank - 1]]) : job.payscale) * faction.payrate * faction.unpaid["[employee.real_name]"] / 12 : 0
					else
						message_admins("INSANE PAY!! for [employee.real_name], DEFAULTING TO BASIC PAY")
						payment = job.payscale * faction.payrate * faction.unpaid["[employee.real_name]"] / 12
					if(payment && !money_transfer(faction.central_account, employee.real_name, "Payroll", 
					payment))
						faction.debts["[employee.real_name]"] += payment

				to_chat(stack.owner, "Your [stack] buzzes, letting you know that you should be getting paid.")

	if(payday)
		timerbuffer = round_duration_in_ticks + 1 HOUR

		for(var/datum/small_business/business in GLOB.all_business)
			business.unpaid = list()
			business.pay_debt()

			var/profit = business.central_account.money - business.last_balance

			if(profit > 0)
				if(length(business.ceo_name))
					money_transfer(business.central_account, business.ceo_name, "CEO Dividend", round(profit / 100 * business.ceo_dividend))
				for(var/stock_holder in business.stock_holders)
					money_transfer(business.central_account, stock_holder, "Stock Holders Dividend", round(profit / 1000 * business.stock_holders[stock_holder] * business.stock_holders_dividend))

			business.last_balance = business.central_account.money

		for(var/datum/world_faction/faction in GLOB.all_world_factions)
			faction.unpaid = list()
			faction.pay_debt()
		for(var/datum/small_business/business in GLOB.all_business)
			business.unpaid = list()
			business.pay_debt()


