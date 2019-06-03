var/datum/controller/employment_controller/employment_controller

/datum/controller/employment_controller
	var/timerbuffer = 0 //buffer for time check
	var/checkbuffer = 0
/datum/controller/employment_controller/New()
	timerbuffer = 30 MINUTES
	checkbuffer = 5 MINUTES
	START_PROCESSING(SSprocessing, src)

/datum/controller/employment_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/controller/employment_controller/Process()
	if(round_duration_in_ticks < checkbuffer)
		return

	checkbuffer = round_duration_in_ticks + 5 MINUTES

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
		timerbuffer = round_duration_in_ticks + 30 MINUTES

		var/list/paydata = list()
		for(var/datum/world_faction/faction in GLOB.all_world_factions)
			for(var/employee in faction.unpaid)
				var/amount = faction.unpaid[employee]
				var/datum/computer_file/report/crew_record/record = faction.get_record(employee)
				if(!record)
					message_admins("no record found for [employee] during payday")
					continue
				var/datum/assignment/job = faction.get_assignment(record.assignment_uid, record.get_name())
				var/payment
				if(job)
					payment = job.get_pay(record.rank) * amount / 6
				else
					payment = 0
				if(payment && !money_transfer(faction.central_account, employee, "Payroll ([faction.name])", payment))
					faction.debts["[employee]"] += payment
				else
					if(istype(faction, /datum/world_faction/business))
						var/datum/world_faction/business/business_faction = faction
						business_faction.employee_objectives(employee)
					if(payment)
						if(paydata[employee])
							paydata[employee] += payment
						else
							paydata[employee] = payment

			faction.unpaid = list()
			faction.pay_debt()

		for(var/obj/item/organ/internal/stack/stack in GLOB.neural_laces)
			var/mob/employee = stack.get_owner()
			if(!employee || !employee.client) continue
			if(employee.real_name in paydata)
				to_chat(employee, "Your neural lace buzzes letting you know you've been paid [paydata[employee.real_name]]$$ for work done in the last half hour.")

