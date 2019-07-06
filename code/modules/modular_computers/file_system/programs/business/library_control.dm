/datum/computer_file/program/library_control
	filename = "librarycontrol"
	filedesc = "Library Control"
	nanomodule_path = /datum/nano_module/program/library_control
	program_icon_state = "comm"
	program_menu_icon = "note"
	extended_desc = "Used to scan books to add them to a database where copies can be made of them."
	requires_ntnet = TRUE
	size = 8
	required_access = core_access_security_programs
	business = 1
	required_module = /datum/business_module/media
	category = PROG_OFFICE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TELESCREEN

/datum/nano_module/program/library_control
	name = "Library Control"
	var/menu = 1
	var/obj/item/weapon/book/multipage/selected_book
	var/obj/item/weapon/book/multipage/scanned_book
	var/print = 0

/datum/nano_module/program/library_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder

	data["connected_faction"] = connected_faction.name
	data["src"] = "\ref[src]"
	data["feed_invis"] = !connected_faction.feed.visible
	if(menu == 1)
		var/list/formatted_titles[0]
		for(var/obj/item/weapon/book/multipage/book in connected_faction.library.books)
			formatted_titles[++formatted_titles.len] = list("name" = book.name, "ref" = "\ref[book]")
		data["titles"] = formatted_titles
	if(menu == 2)
		if(scanned_book)
			data["book_name"] = scanned_book.name
			data["book_author"] = scanned_book.author
		else
			data["book_name"] = "*None*"
			data["book_author"] = "*None*"

	if(menu == 3)
		if(selected_book)
			data["book_name"] = selected_book.name
			data["book_author"] = selected_book.author
		else
			data["book_name"] = "*None*"
			data["book_author"] = "*None*"

	data["menu"] = menu


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "library_control.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/library_control/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/datum/world_faction/business/connected_faction
	if(program.computer.network_card && program.computer.network_card.connected_network)
		connected_faction = program.computer.network_card.connected_network.holder
	if(!user_id_card) return

	switch(href_list["action"])
		if("select_book")
			selected_book = locate(href_list["ref"])
			if(selected_book)
				menu = 3
		if("change_menu")
			menu = text2num(href_list["target"])
			selected_book = null
		if("select_title")
			selected_book = locate(href_list["ref"])
		if("scan_book")

			if(istype(usr.get_active_hand(), /obj/item/weapon/book/multipage))
				var/obj/item/weapon/book/multipage/book = usr.get_active_hand()
				if(!book.original)
					to_chat(usr, "You cannot scan this book as it is not an original copy. Only books made through a bookbinder can be scanned and added to library networks.")
				else
					scanned_book = usr.get_active_hand()
			else if(istype(usr.get_active_hand(), /obj/item/weapon/book))
				to_chat(usr, "This book is not properly formatted for the library system. Use a newer book.")
			else
				to_chat(usr, "Hold the book you want to scan in your active hand.")

		if("publish")
			if(scanned_book)
				var/obj/item/weapon/book/multipage/book = new()

				for(var/obj/item/weapon/page in scanned_book.pages)
					if(istype(page, /obj/item/weapon/paper))
						copy(page, book)
					else if(istype(page, /obj/item/weapon/photo))
						photocopy(page, book)
				book.author = scanned_book.author
				book.author_real = scanned_book.author_real
				book.title = scanned_book.title
				book.name = scanned_book.title
				book.icon_state = scanned_book.icon_state
				connected_faction.library.books |= book
				connected_faction.publish_book_objectives(book.author_real)
				scanned_book = null
				selected_book = book
				menu = 3
			else
				to_chat(usr, "You must scan a book first.")

		if("print")
			if(world.time < print)
				to_chat(usr, "You must wait 10 seconds between printing a book.")
			if(selected_book)
				var/obj/item/weapon/book/multipage/book = new(program.computer.loc)

				for(var/obj/item/weapon/page in selected_book.pages)
					if(istype(page, /obj/item/weapon/paper))
						copy(page, book)
					else if(istype(page, /obj/item/weapon/photo))
						photocopy(page, book)
				book.author = selected_book.author
				book.author_real = selected_book.author_real
				book.title = selected_book.title
				book.name = book.title
				book.icon_state = selected_book.icon_state
				print = world.time + 10 SECONDS
				playsound(get_turf(program.computer), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
			else
				to_chat(usr, "You must scan a book first.")
		if("delete")
			var/x = selected_book
			var/choice = input(usr,"This will delete this [selected_book.title] from the database and you will need the original copy to add it again..") in list("Confirm", "Cancel")
			if(choice == "Confirm")
				if(x && x == selected_book)
					connected_faction.library.books -= selected_book

	SSnano.update_uis(src)
	return 1

/datum/nano_module/program/library_control/proc/copy(var/obj/item/weapon/paper/copy, var/obj/item/weapon/book/multipage/book)
	var/obj/item/weapon/paper/c = new /obj/item/weapon/paper()
	var/copied = html_decode(copy.info)
	c.info += copied
	c.name = copy.name // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.update_icon()
	c.loc = book
	book.pages |= c


/datum/nano_module/program/library_control/proc/photocopy(var/obj/item/weapon/photo/photocopy, var/obj/item/weapon/book/multipage/book)
	var/obj/item/weapon/photo/p = photocopy.copy()
	p.loc = book
	book.pages |= p


