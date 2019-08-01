/datum/computer_file/program/records_lookup
	filename = "forensic records"
	filedesc = "Forensic Records"
	extended_desc = "This program allows you to lookup a record by full name or fingerprint."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 14
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/records_lookup
	usage_flags = PROGRAM_ALL
	category = PROG_SEC

/datum/nano_module/records_lookup
	name = "Forensic Records"
	var/datum/computer_file/report/crew_record/active_record
	var/message = null

/datum/nano_module/records_lookup/proc/get_connected_faction()
	if(host)
		var/obj/item/modular_computer/comp = host
		return comp.ConnectedFaction()
	return null

/datum/nano_module/records_lookup/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)
	data["message"] = message
	if(active_record)
		data += active_record.generate_nano_data(user_access)
		data["uid"] = active_record.uid

		///////////////////////////////////////// stuff ???
		var/list/fields = list()
		for(var/datum/report_field/F in active_record.fields)
			if(F.name == "Job" || F.name == "Branch" || F.name == "Rank")
				continue
			fields.Add(list(list(
				"key" = F.type,
				"name" = F.name,
				"val" = F.get_value(),
				"editable" = 0,
				"large" = F.needs_big_box
			)))
		data["fields"] = fields
		////////////////////////////////// stuff ????
	else
		data["dnasearch"] = 1
		data["fingersearch"] = 1

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "forensic_records.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/records_lookup/proc/get_record_access(var/mob/user)
	var/list/user_access = using_access || user.GetAccess()

	var/obj/item/modular_computer/PC = nano_host()
	if(istype(PC) && PC.computer_emagged)
		user_access = user_access.Copy()
		user_access |= access_syndicate

	return user_access

/datum/nano_module/records_lookup/proc/edit_field(var/mob/user, var/field_ID)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!F.verify_access_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

/datum/nano_module/records_lookup/Topic(href, href_list)
	var/list/faction_records = list()
	if(..())
		return 1
	if(!faction_records) //safety check
		return 1
	if(href_list["clear_active"])
		active_record = null
		return 1
	if(href_list["clear_message"])
		message = null
		return 1

	if(href_list["search"])
		var/field_name = href_list["search"]
		var/search = sanitize(input("Enter the value for search for.") as null|text)
		if(!search)
			return
		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			var/datum/report_field/field = R.field_from_name(field_name)
			if(lowertext(field.get_value()) == lowertext(search))
				active_record = R
				return 1
		if(!active_record)
			active_record = Retrieve_Record(search)
			if(active_record)
				return 1
		message = "Unable to find record containing '[search]'"
		return 1

/datum/nano_module/records_lookup/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/weapon/photo))
		var/obj/item/weapon/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/weapon/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img
