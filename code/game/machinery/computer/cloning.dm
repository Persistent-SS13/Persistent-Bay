/obj/machinery/computer/cloning
	name = "cloning console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	circuit = /obj/item/weapon/circuitboard/cloning
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/list/pods = list() //Linked cloning pods.
	var/temp = ""
	var/scantemp = "Scanner ready."
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/dna2/record/active_record = null
	var/obj/item/weapon/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = 0 // Nice loading text
	var/autoprocess = 0
	var/obj/machinery/clonepod/selected_pod
	// 0: Standard body scan
	// 1: The "Best" scan available
	var/scan_mode = 1
	var/selected = 0 // whether the type of cloning has been selected (and which type)
	var/list/payments = list() // a list of the authorized payments and who is making them
	var/paid = 0 // how much has been paid so far
	var/function = 0 // -- 1 = cloning from brain in cloning tube -- 2 = cloning spare body from dna scanner
	var/cancelconfirm = 0 // -- allows for double checking if you want to cancel
	light_color = LIGHT_COLOR_DARKBLUE

/obj/machinery/computer/cloning/initialize()
	..()
	updatemodules()

/obj/machinery/computer/cloning/Destroy()
	releasecloner()
	return ..()

/obj/machinery/computer/cloning/process()
	if(!scanner || !pods.len || !autoprocess || stat & NOPOWER)
		return

	if(scanner.occupant && can_autoprocess())
		scan_mob(scanner.occupant)

	for(var/obj/machinery/clonepod/pod in pods)
		if(!(pod.occupant || pod.mess) && (pod.efficiency > 5))
			for(var/datum/dna2/record/R in src.records)
				if(!(pod.occupant || pod.mess))
					if(pod.growclone(R))
						records.Remove(R)

/obj/machinery/computer/cloning/proc/updatemodules()
	src.scanner = findscanner()
	releasecloner()
	findcloner()
	if(!selected_pod && pods.len)
		selected_pod = pods[1]
/obj/machinery/computer/cloning/proc/reset_vars()
	selected = 0
	payments = list()
	paid = 0
	function = 0
	cancelconfirm = 0
	nanomanager.update_uis(src)
	return
/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	//Try to find scanner on adjacent tiles first
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
		if(scannerf)
			return scannerf

	//Then look for a free one in the area
	if(!scannerf)
		for(var/obj/machinery/dna_scannernew/S in get_area(src))
			return S

	return 0

/obj/machinery/computer/cloning/proc/releasecloner()
	for(var/obj/machinery/clonepod/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()

/obj/machinery/computer/cloning/proc/findcloner()
	var/num = 1
	for(var/obj/machinery/clonepod/P in get_area(src))
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		if(M.buffer && istype(M.buffer, /obj/machinery/clonepod))
			var/obj/machinery/clonepod/P = M.buffer
			if(P && !(P in pods))
				pods += P
				P.connected = src
				P.name = "[initial(P.name)] #[pods.len]"
				to_chat(user, "<span class='notice'>You connect [P] to [src].</span>")
	else if(istype(W, /obj/item/weapon/card/id))
		if(!selected)
			return
		var/obj/item/weapon/card/id/C = W
		var/datum/money_account/account = get_card_account(C)
		if(!account)
			to_chat(user, "No account associated with the ID")
			return
		else
			make_payment(user, account)

	else if(istype(W, /obj/item/device/pda))
		if(!selected)
			return
		var/obj/item/device/pda/PDA = W
		if(PDA.id)
			var/datum/money_account/account = get_card_account(PDA.id)
			if(!account)
				to_chat(user, "No account associated with the ID")
				return
			else
				make_payment(user, account)
				src.add_fingerprint(user)
				nanomanager.update_uis(src)
				return
		else
			return
	else
		..()
	return

/obj/machinery/computer/cloning/proc/make_payment(mob/user as mob, var/datum/money_account/account)
	var/suggest = 0
	if(selected == 1)
		suggest = 1500 - paid
	if(selected == 2)
		suggest = 2500 - paid
	if(account.security_level != 0 || account != user.mind.initial_account) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		if(account.remote_access_pin != attempt_pin)
			to_chat(user, "Unable to access account: incorrect credentials.")
			return
	var/amount = input("How much would you like to pay?", "Pay-4-Clone", suggest) as num|null
	if(amount > suggest)
		amount = suggest
	if(amount > account.money)
		to_chat(user, "Unable to complete transaction: insufficient funds.")
		return
	else
		if(payments[account.owner_name])
			var/list/temp = payments[account.owner_name]
			var/ta = 0
			ta = temp["amount"]
			payments[account.owner_name] = list("account" = account, "amount" = amount + ta)
		else
			payments[account.owner_name] = list("account" = account, "amount" = amount)
		paid += amount
		to_chat(user, "Payment authorized. Charge will be made when the cloning begins.")
		return
/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()
	ui_interact(user)

/obj/machinery/computer/cloning/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (NOPOWER|BROKEN))
		return
	var/data[0]
	data["menu"] = src.menu
	data["scanner"] = sanitize("[src.scanner]")
	data["biomass"] = 0
	var/canpodautoprocess = 0
	if(pods.len)
		data["numberofpods"] = src.pods.len

		var/list/tempods[0]
		for(var/obj/machinery/clonepod/pod in pods)
			var/occupant_name = ""
			var/occupied = 0
			var/processing = pod.attempting
			if(pod.held_brain.brainmob)
				occupied = 1
				occupant_name = pod.held_brain.brainmob.name + " (Brain)"
			else if(pod.occupant)
				occupied = 1
				occupant_name = pod.occupant.name
			tempods.Add(list(list("pod" = "\ref[pod]", "name" = sanitize(capitalize(pod.name)),"occupied" = occupied, "occupant" = occupant_name, "processing" = processing)))
		data["pods"] = tempods

	if(payments.len)
		var/list/tempay[0]
		var/list/templist
		for(var/x in payments)
			var/tname = x
			templist = payments[x]
			var/tamount = templist["amount"]
			tempay.Add(list(list("name" = tname, "amount" = tamount)))
		data["payments"] = tempay
	data["selected"] = selected
	if(selected == 1)
		data["remaining"] = 1500 - paid
	if(selected == 2)
		data["remaining"] = 2500 - paid
	data["loading"] = loading
	data["autoprocess"] = autoprocess
	data["can_brainscan"] = can_brainscan() // You'll need tier 4s for this
	data["scan_mode"] = scan_mode
	if(src.scanner)
		data["occupant"] = src.scanner.occupant
		data["locked"] = src.scanner.locked
	data["temp"] = temp
	data["scantemp"] = scantemp
	data["disk"] = src.diskette
	data["selected_pod"] = "\ref[selected_pod]"
	data["cancelconfirm"] = cancelconfirm
	var/list/temprecords[0]
	for(var/datum/dna2/record/R in records)
		var tempRealName = R.dna.real_name
		temprecords.Add(list(list("record" = "\ref[R]", "realname" = sanitize(tempRealName))))
	data["records"] = temprecords

	if(src.menu == 3)
		if(src.active_record)
			data["activerecord"] = "\ref[src.active_record]"
			var/obj/item/weapon/implant/health/H = null
			if(src.active_record.implant)
				H = locate(src.active_record.implant)

			if((H) && (istype(H)))
				data["health"] = H.sensehealth()
			data["realname"] = sanitize(src.active_record.dna.real_name)
			data["unidentity"] = src.active_record.dna.uni_identity
			data["strucenzymes"] = src.active_record.dna.struc_enzymes
		if(selected_pod && (selected_pod in pods) && selected_pod.biomass >= CLONE_BIOMASS)
			data["podready"] = 1
		else
			data["podready"] = 0

	// Set up the Nano UI
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cloning_console.tmpl", "Cloning Console UI", 640, 520)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return 1

	if(loading)
		return

	if(href_list["scan"] && scanner && scanner.occupant)
		scantemp = "Scanner ready."

		loading = 1

		spawn(20)
			if(can_brainscan() && scan_mode)
				scan_mob(scanner.occupant, scan_brain = 1)
			else
				scan_mob(scanner.occupant)

			loading = 0
			nanomanager.update_uis(src)

	if(href_list["task"])
		switch(href_list["task"])
			if("autoprocess")
				autoprocess = 1
				nanomanager.update_uis(src)
			if("stopautoprocess")
				autoprocess = 0
				nanomanager.update_uis(src)

	//No locking an open scanner.
	else if((href_list["lock"]) && (!isnull(src.scanner)))
		if((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = 1
		else
			src.scanner.locked = 0

	else if(href_list["refresh"])
		nanomanager.update_uis(src)
	else if(href_list["cancel"])
		cancelconfirm = 1
	else if(href_list["cancelcancel"])
		cancelconfirm = 0
	else if(href_list["cancelconfirm"])
		reset_vars()
		menu = 1
	else if(href_list["selectpod"])
		var/obj/machinery/clonepod/selected = locate(href_list["selectpod"])
		if(istype(selected) && (selected in pods))
			selected_pod = selected
		menu = 2
		function = 1
	else if(href_list["selectpodscanner"])
		var/obj/machinery/clonepod/selected = locate(href_list["selectpod"])
		if(istype(selected) && (selected in pods))
			selected_pod = selected
		menu = 2
		function = 2
	else if(href_list["selectpackage"])
		if(menu != 2)
			message_admins("selectpackage made in invalid menu. hacking?")
			return
		if(selected)
			message_admins("cloner reselecting package? Possible exploit")
			return
		selected = text2num(href_list["selectpackage"])
	else if(href_list["payment"])
		if(menu != 2)
			message_admins("payment made in invalid menu. hacking?")
			return
		if(!selected)
			message_admins("payment being made before package selected")
			return
		if(selected == 1 && paid >= 1500)
			message_admins("overpayment at cloning machine")
			return
		if(selected == 2 && paid >= 2500)
			message_admins("overpayment at cloning machine")
			return
		if(!usr.mind.initial_account)
			to_chat(usr, "ERROR! No account found for this DNA.")
		else
			make_payment(usr, usr.mind.initial_account)
	else if(href_list["clone"])
		if(!selected)
			message_admins("clone attempt without selected package")
			return
		if(selected == 1 && paid < 1500)
			message_admins("clone attempt without enough payment")
			return
		if(selected == 2 && paid < 2500)
			message_admins("clone attempt without enough payment")
			return
		if(!selected_pod)
			message_admins("clone attempt with no pod selected")
			return
		for(var/i in payments)
			var/list/x = payments[i]
			var/datum/money_account/tempacc = x["account"]
			if(tempacc.money < x["amount"])
				paid -= x["amount"]
				payments -= x
				to_chat(usr, "ERROR! One of the payments had insufficent funds and has been removed. Secure funding and try again.")
				return
		if(function == 1)
			if(!selected_pod.held_brain.held_brain)
				message_admins("cloning attempt without brain in pod")
				return
			var/obj/machinery/clonepod/pod = selected_pod
			var/datum/dna2/record/R = new /datum/dna2/record()
			var/obj/item/organ/B = selected_pod.held_brain.held_brain
			B.dna.check_integrity()
			R.dna=B.dna.Clone()
			var/datum/species/S = all_species[R.dna.species]
			R.id= copytext(md5(B.dna.real_name), 2, 6)
			if(!B.dna.real_name)
				B.dna.real_name = selected_pod.held_brain.brainmob.name
			R.name=B.dna.real_name
			if(pod.growclone(R, selected, 1))
				temp = "Initiating cloning cycle..."
				qdel(R)
				menu = 3
				for(var/i in payments)
					var/list/x = payments[i]
					var/datum/money_account/tempacc = x["account"]
					message_admins("ATTEMPTING TO CHARGE!")
					tempacc.charge(x["amount"], null, "Pay-4-Clone", "Cloning Computer", 0, "Nanotransen Cloning Department")
				reset_vars()
				spawn(30)
					menu = 1
			else
				qdel(R)
		if(function == 2)
			if(!scanner.occupant)
				message_admins("cloning attempt without body in scanner")
				return
			var/obj/machinery/clonepod/pod = selected_pod
			var/datum/dna2/record/R = new /datum/dna2/record()
			var/mob/living/carbon/human/B = scanner.occupant
			B.dna.check_integrity()
			R.dna=B.dna.Clone()
			var/datum/species/S = all_species[R.dna.species]
			if(!B.dna.real_name)
				B.dna.real_name = B.real_name
			R.id= copytext(md5(B.dna.real_name), 2, 6)
			R.name=B.dna.real_name
			if(pod.growclone(R, selected))
				temp = "Initiating cloning cycle..."
				qdel(R)
				menu = 3
				for(var/i in payments)
					var/list/x = payments[i]
					var/datum/money_account/tempacc = x["account"]
					tempacc.charge(x["amount"], null, "Pay-4-Clone", "Cloning Computer", 0, "Nanotransen Cloning Department")
				reset_vars()
				spawn(30)
					menu = 1
			else
				qdel(R)

	else if(href_list["menu"])
		src.menu = text2num(href_list["menu"])
		temp = ""
		scantemp = "Scanner ready."
	else if(href_list["toggle_mode"])
		if(can_brainscan())
			scan_mode = !scan_mode
		else
			scan_mode = 0

	src.add_fingerprint(usr)
	nanomanager.update_uis(src)
	return

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob, var/scan_brain = 0)
	if(stat & NOPOWER)
		return
	if(scanner.stat & (NOPOWER|BROKEN))
		return
	if(scan_brain && !can_brainscan())
		return
	if((isnull(subject)) || (!(ishuman(subject))) || (!subject.dna) || (subject.species.flags & NO_SCAN))
		scantemp = "<span class=\"bad\">Error: Unable to locate valid genetic data.</span>"
		nanomanager.update_uis(src)
		return
	if(subject.get_int_organ(/obj/item/organ/internal/brain))
		var/obj/item/organ/internal/brain/Brn = subject.get_int_organ(/obj/item/organ/internal/brain)
		if(istype(Brn))
			var/datum/species/S = all_species[Brn.dna.species] // stepladder code wooooo
			if(S.flags & NO_SCAN)
				scantemp = "<span class=\"bad\">Error: Subject's brain is incompatible.</span>"
				nanomanager.update_uis(src)
				return
	if(!subject.get_int_organ(/obj/item/organ/internal/brain))
		scantemp = "<span class=\"bad\">Error: No signs of intelligence detected.</span>"
		nanomanager.update_uis(src)
		return
	if(subject.suiciding == 1 && src.scanner.scan_level < 2)
		scantemp = "<span class=\"bad\">Error: Subject's brain is not responding to scanning stimuli.</span>"
		nanomanager.update_uis(src)
		return
	if((!subject.ckey) || (!subject.client))
		scantemp = "<span class=\"bad\">Error: Mental interface failure.</span>"
		nanomanager.update_uis(src)
		return
	if((NOCLONE in subject.mutations) && src.scanner.scan_level < 2)
		scantemp = "<span class=\"bad\">Error: Mental interface failure.</span>"
		nanomanager.update_uis(src)
		return
	if(scan_brain && !subject.get_int_organ(/obj/item/organ/internal/brain))
		scantemp = "<span class=\"bad\">Error: No brain found.</span>"
		nanomanager.update_uis(src)
		return
	if(!isnull(find_record(subject.ckey)))
		scantemp = "Subject already in database."
		nanomanager.update_uis(src)
		return

	subject.dna.check_integrity()

	var/datum/dna2/record/R = new /datum/dna2/record()
	R.ckey = subject.ckey
	var/extra_info = ""
	if(scan_brain)
		var/obj/item/organ/B = subject.get_int_organ(/obj/item/organ/internal/brain)
		B.dna.check_integrity()
		R.dna=B.dna.Clone()
		var/datum/species/S = all_species[R.dna.species]
		if(S.flags & NO_SCAN)
			extra_info = "Proper genetic interface not found, defaulting to genetic data of the body."
			R.dna.species = subject.species.name
		R.id= copytext(md5(B.dna.real_name), 2, 6)
		R.name=B.dna.real_name
	else
		R.dna=subject.dna.Clone()
		R.id= copytext(md5(subject.real_name), 2, 6)
		R.name=R.dna.real_name

	R.types=DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages=subject.languages
	//Add an implant if needed
	var/obj/item/weapon/implant/health/imp = locate(/obj/item/weapon/implant/health, subject)
	if(isnull(imp))
		imp = new /obj/item/weapon/implant/health(subject)
		imp.implanted = subject
		R.implant = "\ref[imp]"
	//Update it if needed
	else
		R.implant = "\ref[imp]"

	if(!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		R.mind = "\ref[subject.mind]"

	src.records += R
	scantemp = "Subject successfully scanned. " + extra_info
	nanomanager.update_uis(src)

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/dna2/record/R in src.records)
		if(R.ckey == find_key)
			selected_record = R
			break
	return selected_record

/obj/machinery/computer/cloning/proc/can_autoprocess()
	return (scanner && scanner.scan_level > 2)

/obj/machinery/computer/cloning/proc/can_brainscan()
	return (scanner && scanner.scan_level > 3)
