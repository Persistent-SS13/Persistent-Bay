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
		// For everyone: always advance the check countdown by five minutes when logging time worked
		checkbuffer = round_duration_in_ticks + 5 MINUTES

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
							break

				if(round_duration_in_ticks > timerbuffer)
					// It is payday, inform the employee they are being paid.
					to_chat(stack.owner, "Your [stack] buzzes, letting you know that you should be getting paid.")

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
		// For everyone: advance the payday timer by one hour, but only if it's payday
		if (round_duration_in_ticks > timerbuffer)
			timerbuffer = round_duration_in_ticks + 1 HOUR
					
			
