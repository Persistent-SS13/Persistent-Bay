/obj/machinery/keyprinter
	name = "encryption key printer"
	desc = "An advanced ciper machine used to generate physical cypher keys for telecommunications."
	icon = 'icons/obj/machines/keyprinter.dmi'
	icon_state = "keyprinter"
	anchored = TRUE
	density = 1
	idle_power_usage = 40
	active_power_usage = 300
	circuit_type = /obj/item/weapon/circuitboard/keyprinter
	var/obj/item/device/encryptionkey/custom/printing // The key being printed
	var/time_printing_end = 0
	//Ui stuff
	var/selected_frequency = 0 //The frequency selected on the UI for printing

/obj/machinery/keyprinter/New()
	. = ..()
	ADD_SAVED_VAR(printing)

/obj/machinery/keyprinter/ShouldInitProcess()
	return FALSE

/obj/machinery/keyprinter/Read(savefile/f)
	. = ..()
	from_file(f["time_printing_end"], time_printing_end)
	if(time_printing_end > 0)
		time_printing_end += world.time

/obj/machinery/keyprinter/Write(savefile/f)
	. = ..()
	var/timediff = max(time_printing_end - world.time, 0)
	to_file(f["time_printing_end"], timediff)

/obj/machinery/keyprinter/update_icon()
	overlays.Cut()
	if(printing)
		overlays += "keyprinter_o"

/obj/machinery/keyprinter/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/modular_computer/pda))
		if(!faction && O.GetFaction())
			faction_uid = O.GetFaction()
			connect_faction(faction_uid)
			to_chat(user, SPAN_NOTICE("You set \the [src]'s faction to [faction? faction.name : "null"]!"))
		return
	return ..()

/obj/machinery/keyprinter/interact(mob/user)
	if(inoperable())
		return
	var/list/data = list()
	user.set_machine(src)
	if(!printing)
		data += "<div class='item'>"
		data += "<div class='itemLabel'>Connected faction: </div><div class='itemContent'>[faction? faction.name : "None"] <span><a href='?src=\ref[src];connect=1'>Set</a></span> <span><a href='?src=\ref[src];disconnect=1'>Remove</a></span></div>"
		data += "</div>"

		if(faction)
			data += "<div class='item'>"
			for(var/freq in faction.reserved_frequencies)
				data += "<div class='itemLabel'>[freq]</div><div class='itemContents'>"
				data += selected_frequency == freq ? "<a href='?src=\ref[src];selectfreq=0'>Unselect</a>" : "<a href='?src=\ref[src];selectfreq=[freq]'>Select</a>"
				data += "</div>"
			if(length(faction.reserved_frequencies) <= 0)
				data += "<span class='bad'>No radio frequencies were reserved for this faction!</span>"
			data += "</div>"
			data += "<div class='item'>"
			if(selected_frequency)
				data += "<div class='itemContents'><a href='?src=\ref[src];print=1'>Print Key</a></div>"
			data += "</div>"
	else
		data += "<div class='item'>Printing in progress... ([max(time_printing_end - world.time, 0)/10] seconds)</div>"

	var/datum/browser/popup = new(user, "keyprinter", "Encryption key printer", 520, 350)
	popup.set_content(JOINTEXT(data))
	popup.open()

/obj/machinery/keyprinter/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["selectfreq"])
		selected_frequency = text2num(href_list["selectfreq"])
		updateDialog()
		return TOPIC_REFRESH
	if(href_list["reserve_freq"])
		if(!faction)
			to_chat(user, SPAN_WARNING("No faction set to reserve frequency from!"))
			return
		var/newfreq = sanitize_frequency(input("Enter frequency to reserve! (usually between [RADIO_CUSTOM_FREQ] and [RADIO_CUSTOM_FREQ_MAX]!)", "Adding reserved frequency", RADIO_CUSTOM_FREQ) as num, RADIO_CUSTOM_FREQ, RADIO_CUSTOM_FREQ_MAX)
		if(!newfreq)
			return
		if(newfreq in faction.reserved_frequencies)
			to_chat(user, SPAN_WARNING("This frequency is already reserved!"))
			return 
		faction.reserved_frequencies.Add(newfreq)
		state("Frequency reserved successfully!")
		updateDialog()
		return TOPIC_REFRESH
	if(href_list["connect"])
		var/obj/item/weapon/card/id/ID = user.GetIdCard()
		if(!ID)
			to_chat(user, SPAN_WARNING("Couldn't obtain user's ID card information!"))
			return
		var/datum/world_faction/F = get_faction(ID.selected_faction)
		if(!F)
			to_chat(user, SPAN_WARNING("Couldn't connect to faction '[ID.selected_faction]'! Please select a valid faction on your ID card!"))
			return
		connect_faction(F.uid, user)
		updateDialog()
		return TOPIC_REFRESH
	if(href_list["disconnect"])
		disconnect_faction()
		updateDialog()
		return TOPIC_REFRESH
	if(href_list["print"])
		if(!selected_frequency || !faction)
			return
		var/prefix = sanitizeName(input("Enter two characters to use for the radio key. The radio prefix will be added automatically", "Enter radio key") as null|text, 2, FALSE, FALSE)
		if(!prefix)
			return
		if(length(prefix) < 2)
			to_chat(user, SPAN_WARNING("You must enter 2 characters, no more, no less!"))
			return
		update_use_power(POWER_USE_ACTIVE)
		printing = new(src, selected_frequency, ":[prefix]", selected_frequency)
		time_printing_end = world.time + 5 SECONDS
		START_PROCESSING(SSmachines, src)
		update_icon()
		return TOPIC_REFRESH

/obj/machinery/keyprinter/Process()
	if(inoperable() || !printing)
		return
	updateDialog()
	if(world.time >= time_printing_end)
		update_use_power(POWER_USE_IDLE)
		printing.dropInto(get_turf(src))
		printing = null
		time_printing_end = 0
		queue_icon_update()
		STOP_PROCESSING(SSmachines, src)
		updateDialog()
