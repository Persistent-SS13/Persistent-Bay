/* Library Machines
 *
 * Contains:
 *		Library Scanner
 *		Book Binder
 */

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "\improper Book Scanner"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = 1
	density = 1
	var/obj/item/weapon/book/cache		// Last scanned book

/obj/machinery/libraryscanner/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/libraryscanner(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/computer_hardware/hard_drive/portable(src)
	RefreshParts()

/obj/machinery/libraryscanner/attackby(var/obj/O as obj, var/mob/living/user as mob)
	if(istype(O, /obj/item/weapon/book))
		user.drop_item()
		O.loc = src
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	..()

/obj/machinery/libraryscanner/attack_hand(var/mob/user as mob)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Scanner Control Interface</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "<FONT color=#005500>Data stored in memory.</FONT><BR>"
	else
		dat += "No data stored in memory.<BR>"
	dat += "<A href='?src=\ref[src];scan=1'>\[Scan\]</A>"
	if(cache)
		dat += "       <A href='?src=\ref[src];clear=1'>\[Clear Memory\]</A><BR><BR><A href='?src=\ref[src];eject=1'>\[Remove Book\]</A>"
	else
		dat += "<BR>"
	user << browse(dat, "window=scanner")
	onclose(user, "scanner")

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=scanner")
		onclose(usr, "scanner")
		return

	if(href_list["scan"])
		for(var/obj/item/weapon/book/B in contents)
			cache = B
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/weapon/book/B in contents)
			B.loc = src.loc
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "Book Binder"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = 1
	density = 1
	var/printing = 0
	var/obj/item/weapon/paper_bundle/held_bundle
	var/obj/item/weapon/paper/held_paper
	var/title = ""
	var/author = ""
	var/list/covers = list()
	var/cover = "red"
/obj/machinery/bookbinder/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/bookbinder(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/computer_hardware/nano_printer(src)
	covers["black"] = "book1"
	covers["red"] = "book2"
	covers["yellow"] = "book3"
	covers["dark green"] = "book4"
	covers["green"] = "book5"
	covers["purple"] = "book6"
	covers["white"] = "book7"
	covers["red"] = "book2"
	RefreshParts()
	
	
/obj/machinery/bookbinder/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["running"] = printing
	data["title"] = title
	data["author"] = author
	if(held_bundle)
		data["held"] = held_bundle.name
		data["pages"] = held_bundle.pages.len
	else if(held_paper)
		data["held"] = held_paper.name
		data["pages"] = 1
	else
		data["pages"] = 0
	data["cover"] = cover
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bookbinder.tmpl", src.name, 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/bookbinder/OnTopic(var/mob/user, href_list)
	if(href_list["title"])
		var/select_name = sanitizeName(input(usr,"Enter the title for the book","Title") as null|text, MAX_NAME_LEN+5)
		if(select_name)
			title = select_name
	if(href_list["author"])
		var/select_name = sanitizeName(input(usr,"Enter the name of the author of the book","Author") as null|text, MAX_NAME_LEN+5)
		if(select_name)
			author = select_name
	if(href_list["insert"])
		if(held_bundle || held_paper)
			return 0
		var/obj/item/weapon/in_hand = usr.get_active_hand()
		if(in_hand && istype(in_hand, /obj/item/weapon/paper))
			held_paper = in_hand
			user.drop_item()
			held_paper.loc = src
		if(in_hand && istype(in_hand, /obj/item/weapon/paper_bundle))
			held_bundle = in_hand
			user.drop_item()
			held_bundle.loc = src
	if(href_list["remove"])
		if(held_bundle)
			held_bundle.loc = loc
			held_bundle = null
		if(held_paper)
			held_paper.loc = loc
			held_paper = null
	if(href_list["print"])
		if(!title || title == "")
			to_chat(user, "An title must be chosen.")
			return
		if(!author || author == "")
			to_chat(user, "An author must be chosen.")
			return
		if(!held_bundle && !held_paper)
			to_chat(user, "The scanning tray must be filled.")
			return
		src.visible_message("[src] begins to hum as it warms up its printing drums.")
		printing = 1
		sleep(100)
		printing = 0
		src.visible_message("[src] whirs as it prints and binds a new book.")
		var/obj/item/weapon/book/multipage/book = new(loc)
		if(held_paper)
			book.pages |= held_paper
			held_paper.loc = book
			held_paper = null
		if(held_bundle)
			book.pages |= held_bundle.pages
			held_bundle.loc = book
			held_bundle = null
		book.author = author
		book.author_real = user.real_name
		book.title = title
		book.icon_state = covers[cover]
		
	if(href_list["cover"])
		var/potential_cover = input(user, "choose book cover", "choose book cover") as null|anything in covers
		if(potential_cover)
			cover = potential_cover
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return TOPIC_REFRESH
		
		
/obj/machinery/bookbinder/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/bookbinder/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/paper))
		if(held_paper || held_bundle)
			to_chat(user, "Theirs already paper loaded")
			return
		user.drop_item()
		O.loc = src
		user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
		held_paper = O
		return
	if(istype(O, /obj/item/weapon/paper_bundle))
		if(held_paper || held_bundle)
			to_chat(user, "Theirs already paper loaded")
			return
		user.drop_item()
		O.loc = src
		user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
		held_bundle = O
		return
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	else
		..()
