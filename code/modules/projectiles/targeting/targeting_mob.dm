/mob/living/var/obj/aiming_overlay/aiming
/mob/living/var/list/aimed = list()

/mob/verb/toggle_gun_mode()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"

	if(isliving(src)) //Needs to be a mob verb to prevent error messages when using hotkeys
		var/mob/living/M = src
		if(!M.aiming)
			M.aiming = new(src)
		M.aiming.toggle_active()
	else
		to_chat(src, "<span class='warning'>This verb may only be used by living mobs, sorry.</span>")
	return
	
/mob/verb/remember_money_account()
	set name = "Remember Money Account"
	set desc = "Remember your money account."
	set category = "IC"

	if(isliving(src)) //Needs to be a mob verb to prevent error messages when using hotkeys
		var/mob/living/M = src
		
		for(var/datum/computer_file/crew_record/record in GLOB.all_crew_records)
			if(record.get_name() == M.real_name)
				if(record.linked_account && istype(record.linked_account, /datum/money_account))
					if(record.linked_account.account_number == 0)
						message_admins("BROKEN ACCOUNT FOR [real_name] GENERATING")
						record.linked_account = create_account(record.get_name(), 0, null)
						record.linked_account.remote_access_pin = rand(1111,9999)
						record.linked_account = record.linked_account.after_load()
						record.linked_account.money = 1000
						to_chat(usr, "Account details: account number # [record.linked_account.account_number] pin # [record.linked_account.remote_access_pin]")
						return
					to_chat(usr, "Account details: account number # [record.linked_account.account_number] pin # [record.linked_account.remote_access_pin]")
				else
					message_admins("BROKEN ACCOUNT FOR [real_name] GENERATING")
					record.linked_account = create_account(record.get_name(), 0, null)
					record.linked_account.remote_access_pin = rand(1111,9999)
					record.linked_account = record.linked_account.after_load()
					record.linked_account.money = 1000
					to_chat(usr, "Your account was broke. Ahelp admins to have your money restored, and reprint an ID. Account details: account number # [record.linked_account.account_number] pin # [record.linked_account.remote_access_pin]")
	else
		to_chat(src, "<span class='warning'>This verb may only be used by living mobs, sorry.</span>")
	return
	

/mob/living/proc/stop_aiming(var/obj/item/thing, var/no_message = 0)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)

/mob/living/death(gibbed, deathmessage="seizes up and falls limp...", show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(.)
		stop_aiming(no_message=1)

/mob/living/UpdateLyingBuckledAndVerbStatus()
	..()
	if(lying)
		stop_aiming(no_message=1)

/mob/living/Weaken(amount)
	stop_aiming(no_message=1)
	..()

/mob/living/Destroy()
	if(aiming)
		qdel(aiming)
		aiming = null
	aimed.Cut()
	return ..()

