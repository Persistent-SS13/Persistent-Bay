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
	if(round_duration_in_ticks > checkbuffer)
		var/list/notify = list()
		// For everyone: always advance the check countdown by five minutes when logging time worked
		checkbuffer = round_duration_in_ticks + 5 MINUTES

		
		// For each business...
		for(var/datum/small_business/connected_business in GLOB.all_business)
			for(var/obj/item/organ/internal/stack/stack in connected_business.connected_laces)
				if(stack.get_owner_name() in connected_business.unpaid)
					connected_business.unpaid[stack.get_owner_name()] = connected_business.unpaid[stack.get_owner_name()] + 1
				else
					connected_business.unpaid[stack.get_owner_name()] = 1
				notify |= stack
			if(round_duration_in_ticks > timerbuffer)
				// It is payday, pay the employee.
				for(var/real_name in connected_business.unpaid)
					var/datum/employee_data/employee = connected_business.get_employee_data(real_name)
					if(employee)
						var/worked = connected_business.unpaid[real_name]
						var/to_pay = employee.pay_rate/12*worked
						if(!money_transfer(connected_business.central_account,real_name,"Payroll",to_pay))
							if(real_name in connected_business.debts)
								var/curr = text2num(connected_business.debts[real_name])
								connected_business.debts[real_name] = "[curr+to_pay]"
							else
								connected_business.debts[real_name] = "[to_pay]"
								
				connected_business.unpaid = list()	
				connected_business.pay_debt()
				var/profit = connected_business.central_account.money - connected_business.last_balance
				var/ceo_dividend = round(profit/100*connected_business.ceo_dividend)
				
				if(ceo_dividend && connected_business.ceo_name && connected_business.ceo_name != "")
					money_transfer(connected_business.central_account,connected_business.ceo_name,"CEO Dividend",ceo_dividend)
				
				if(connected_business.stock_holders_dividend)
					for(var/stock_holder in connected_business.stock_holders)
						var/holding = text2num(connected_business.stock_holders[stock_holder])
						var/stock_holders_dividend = profit/100*(connected_business.stock_holders_dividend/10*holding)
						money_transfer(connected_business.central_account,stock_holder,"Stock Holders Dividend", stock_holders_dividend)
				connected_business.last_balance = connected_business.central_account.money		
		// For each faction...
		for(var/datum/world_faction/connected_faction in GLOB.all_world_factions)

			// LOG WORK
			// Find neural laces that are currently connected...
			for(var/obj/item/organ/internal/stack/stack in connected_faction.connected_laces)
				// Find their crew record ...
				var/datum/computer_file/crew_record/record = connected_faction.get_record(stack.get_owner_name())
				if(!record) continue
				// Make sure they are still on duty...
				if(stack.duty_status)
					for(var/mob/M in GLOB.player_list)
						if(M.real_name == stack.get_owner_name() && M.client && M.client.inactivity <= 10 * 60 * 10)
							// Log a five-minute unit of work on their crew record.
							record.worked += 1	
							connected_faction.unpaid |= record
							notify |= stack
							break
						

			// PAY PEOPLE
			// See if it is payday...
			if(round_duration_in_ticks > timerbuffer)
				// It is payday, pay the employee.
				for(var/datum/computer_file/crew_record/record in connected_faction.unpaid)
					if(record.worked)
						var/datum/assignment/assignment = connected_faction.get_assignment(record.assignment_uid)
						if(!assignment) 
							record.worked = 0
							continue
						var/payscale = 0
						if(record.rank > 1)
							var/use_rank = record.rank
							if(record.rank > assignment.ranks.len+1)
								use_rank = assignment.ranks.len+1
							payscale = text2num(assignment.ranks[assignment.ranks[use_rank-1]])
						else
							payscale = assignment.payscale
						var/to_pay = connected_faction.payrate/12*record.worked*payscale
						if(!money_transfer(connected_faction.central_account,record.get_name(),"Payroll",to_pay))
							if(record.get_name() in connected_faction.debts)
								var/curr = text2num(connected_faction.debts[record.get_name()])
								connected_faction.debts[record.get_name()] = "[curr+to_pay]"
							else
								connected_faction.debts[record.get_name()] = "[to_pay]"
						record.worked = 0
				connected_faction.unpaid = list()
				connected_faction.pay_debt()
		// For everyone: advance the payday timer by one hour, but only if it's payday
		if (round_duration_in_ticks > timerbuffer)
			for(var/obj/item/organ/internal/stack/stack in notify)
				if(stack.owner)
					to_chat(stack.owner, "Your [stack] buzzes, letting you know that you should be getting paid.")
			timerbuffer = round_duration_in_ticks + 1 HOUR
					
			
