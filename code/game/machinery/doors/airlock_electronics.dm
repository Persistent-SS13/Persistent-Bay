//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define ACCESS_BUSINESS_ELETRONICS "Electronics Control"
#define ACCESS_BUSINESS_DEFAULT_ALL list(ACCESS_BUSINESS_ELETRONICS,"Sales", "Newsfeed", "Budget View", "Employee Control",  "Upper Management", "Door Access 1", "Door Access 2", "Door Access 3")

/obj/item/weapon/airlock_electronics/business
	name = "business airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -Agouri
	desc = "airlock electronics that connect to business networks"
	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 50)

	req_access = list()

/obj/item/weapon/airlock_electronics/business/ui_data(mob/user)
	var/list/data = list()
	var/list/regions = list()
	var/datum/small_business/viewing = get_business(business_name)
	if(!viewing) locked = 1
	if(!locked)
		data["connected_faction"] = viewing.name
		var/list/all_access = ACCESS_BUSINESS_DEFAULT_ALL
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in all_access)
			var/list/access = list()
			access["name"] = j
			access["id"] = j
			access["req"] = (j in src.business_access)
			accesses[++accesses.len] = access
		region["name"] = "Business Accesses"
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = lockable

	return data


/obj/item/weapon/airlock_electronics/business/ui_act(action, params)
	switch(action)
		if("clear")
			business_access = list()
			one_access = 0
			return TRUE
		if("one_access")
			one_access = !one_access
			return TRUE
		if("set")
			var/access = params["access"]
			if (!(access in business_access))
				business_access += access
			else
				business_access -= access
			return TRUE
		if("unlock")
			var/select_name = input(usr,"Enter the full name of the business.\n (This [name] will be bound to that business until an employee clears the access list and locks it.)","Unlock", "") as null|text
			var/datum/small_business/viewing = get_business(select_name)

			if (business_name && (select_name != business_name) )
				to_chat(usr, "This [name] has been locked by the business [business_name] .")
				return FALSE
			if(!viewing)
				to_chat(usr, "Business not found.")
				return FALSE
			var/datum/employee_data/employee = viewing.get_employee_data(usr.get_id_name())
			if ( !(usr.get_id_name() == viewing.ceo_name) && !employee)
				to_chat(usr, "You're not part of that business.")
				return FALSE
			else if ( usr.get_id_name() == viewing.ceo_name || ( ACCESS_BUSINESS_ELETRONICS in employee.accesses) )
				locked = 0
				business_name = select_name
				return TRUE
			else
				to_chat(usr, "Only the CEO or permitted employees are able to unlock the [name].")
				return FALSE

		if("lock")
			if(!lockable)
				return TRUE
			if (!business_access.len)
				business_name = ""
				connected_faction = null
			locked = 1
			. = TRUE
	if(..())
		return TRUE
	
	
/obj/item/weapon/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -Agouri

	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 50)

	req_access = list()

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1
	var/lockable = 1
	var/autoset = FALSE // Whether the door should inherit access from surrounding areas
	var/datum/world_faction/connected_faction
	var/business_name = ""
	var/list/business_access = list()

/obj/item/weapon/airlock_electronics/New()
	..()
	ADD_SAVED_VAR(conf_access)
	ADD_SAVED_VAR(one_access)
	ADD_SAVED_VAR(locked)
	ADD_SAVED_VAR(connected_faction)
	ADD_SAVED_VAR(business_name)
	ADD_SAVED_VAR(business_access)

/obj/item/weapon/airlock_electronics/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	tg_ui_interact(user)



//tgui interact code generously lifted from tgstation.
/obj/item/weapon/airlock_electronics/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
	datum/tgui/master_ui = null, datum/ui_state/state = tg_hands_state)

	SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics", src.name, 1000, 500, master_ui, state)
		ui.open()

/obj/item/weapon/airlock_electronics/ui_data(mob/user)
	var/list/data = list()
	var/list/regions = list()
	if(!connected_faction) locked = 1
	if(!locked)
		data["connected_faction"] = connected_faction.name
		for(var/datum/access_category/i in connected_faction.access_categories) //code/game/jobs/_access_defs.dm
			var/list/region = list()
			var/list/accesses = list()
			for(var/j in i.accesses)
				var/list/access = list()
				access["name"] = i.accesses[j]
				access["id"] = j
				access["req"] = (text2num(j) in src.conf_access)
				accesses[++accesses.len] = access
			region["name"] = i.name
			region["accesses"] = accesses
			regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = lockable
	data["autoset"] = autoset

	return data

/obj/item/weapon/airlock_electronics/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("clear")
			conf_access = list()
			one_access = 0
			return TRUE
		if("one_access")
			one_access = !one_access
			return TRUE
		if("autoset")
			autoset = !autoset
			return TRUE
		if("set")
			var/access = text2num(params["access"])
			if (!(access in conf_access))
				conf_access += access
			else
				conf_access -= access
			return TRUE
		if("unlock")
			if(!lockable)
				return TRUE
			if(!req_access || istype(usr,/mob/living/silicon))
				locked = 0
				last_configurator = usr.name
				return TRUE
			else
				var/obj/item/weapon/card/id/I = usr.GetIdCard()
				if(!istype(I, /obj/item/weapon/card/id))
					to_chat(usr, "<span class='warning'>[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?</span>")
					return TRUE
				connected_faction = get_faction(I.selected_faction)
				if(!connected_faction)
					to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
					return TRUE
				if(connected_faction.uid != req_access_faction) conf_access = list()
				req_access_faction = connected_faction.uid
				if (check_access(I))
					locked = 0
					last_configurator = I.registered_name
				else
					req_access_faction = ""
					to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
					return TRUE
		if("lock")
			if(!lockable)
				return TRUE
			if (!conf_access.len)
				connected_faction = null
			locked = 1
			. = TRUE

/obj/item/weapon/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1

/obj/item/weapon/airlock_electronics/brace
	name = "airlock brace access circuit"
	req_access = list()
	locked = 0
	lockable = 0

/obj/item/weapon/airlock_electronics/brace/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = tg_deep_inventory_state)
	SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics", src.name, 1000, 500, master_ui, state)
		ui.open()

/obj/item/weapon/airlock_electronics/proc/set_access(var/obj/object)
	if(!object.req_access || !object.req_one_access || !object.req_access_faction)
		object.check_access()
	if(object.req_one_access.len)
		for(var/entry in object.req_one_access)
			req_one_access |= entry
	if(object.req_access.len)
		conf_access = list()
		for(var/entry in object.req_access)
			conf_access |= entry // This flattens the list, turning everything into AND
			// Can be reworked to have the electronics inherit a precise access set, but requires UI changes.
	if(object.req_access_faction)
		src.req_access_faction = object.req_access_faction

/obj/item/weapon/airlock_electronics/attackby(var/obj/item/W, var/mob/user)
	var/obj/item/weapon/card/id/I = W
	if(istype(I, /obj/item/weapon/card/id) && (!req_access_faction || req_access_faction == ""))
		connected_faction = get_faction(I.selected_faction)
		if(!connected_faction)
			to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
			return TRUE
		if(connected_faction.uid != req_access_faction) conf_access = list()
		req_access_faction = connected_faction.uid
		if (check_access(I))
			locked = 0
			last_configurator = I.registered_name
		else
			req_access_faction = ""
			to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
			return TRUE
	..()

/obj/item/weapon/airlock_electronics/keypad_electronics
 	name = "keypad airlock electronics"
 	icon_state = "door_electronics_keypad"
 	desc = "An upgraded version airlock electronics board, with a keypad to lock the door."

/obj/item/weapon/airlock_electronics/personal_electronics
 	name = "personal airlock electronics"
 	desc = "An alternative to airlock electronics that locks access to specific personnel"
 										// 1 in list controls door bolting
 	var/list/registered_names = list()	// all others can open the door as normal

/obj/item/weapon/airlock_electronics/personal_electronics/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/ID = I

		if(ID.registered_name in registered_names)
			return

		if(!registered_names.len)
			to_chat(user, "You set [ID.registered_name] as \the [src]' owner.")
		else
			to_chat(user, "You add [ID.registered_name] to \the [src]' allowed access list.")

		registered_names += ID.registered_name

 	if(isMultitool(I))
 		registered_names.Cut()

 		to_chat(user, "You pulse \the [src], resetting the allowed access list.")
