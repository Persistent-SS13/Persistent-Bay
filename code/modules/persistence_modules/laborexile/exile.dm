/obj/machinery/teleport/hub/exile
	name = "exile hub"
	desc = "A special version of the teleporter hub, designed to prevent use by those sentenced to hard labor."

/obj/machinery/teleport/hub/exile/teleport(atom/movable/M as mob|obj)
	if(istype(M, /mob/living/carbon/human/))
		for(var/obj/item/weapon/implant/laborexile/E in M)
			if(E.time_left)
				to_chat(M, SPAN_WARNING("You can not return to society until you have repaid your crimes."))
				return

	if(istype(M, /obj/structure/closet))
		for(var/mob/living/carbon/human/H in M)
			for(var/obj/item/weapon/implant/laborexile/E in H)
				if(E.time_left)
					to_chat(H, SPAN_WARNING("You can not return to society until you have repaid your crimes."))
					return
	..()

/obj/item/weapon/implant/laborexile
	name = "exile transponder"
	desc = "You will repay your debt to society, one way or another."
	var/time_left //How much time do we have left in exile?
	var/max_time = 7 DAYS //You can't set this any longer than this.
	var/ring_ID

/obj/item/weapon/implant/laborexile/New()
	ADD_SAVED_VAR(time_left)
	ADD_SAVED_VAR(ring_ID)

/obj/item/weapon/implant/laborexile/Process()
	if (!implanted) return
	if(time_left)
		time_left -= 1
	if(!time_left)
		deactivate()

/obj/item/weapon/implant/laborexile/implanted(mob/source)
	ring_ID = source.name
	ring_ID += "-[rand(999)]"
	to_chat(source, SPAN_NOTICE("Your prisoner ID is [ring_ID]."))

/obj/item/weapon/implant/laborexile/proc/deactivate()
	to_chat(imp_in, SPAN_NOTICE("Your crimes have been repaid or pardoned. You may return to society."))
	qdel(src)

/obj/item/weapon/implant/laborexile/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> 'Solitude' EX-01 Exile Implant<BR>
	<b>Life:</b> Maximum of Seven Days<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a transponder that prevents an indentured person from returning through a exile hib.<BR>
	<HR><B>Exile Duration:</B><BR>
	<A href='byond://?src=\ref[src];exile=1'>[time_left ? time_left / 36000 : "NOT SET"] Hours</A><BR>"}

/obj/item/weapon/implant/laborexile/Topic(href, href_list)
	..()
	if (href_list["exile"])
		var/new_time = input("Exile Timer", "Enter Exile timer in hours. No more than 7 days.") as num
		new_time = new_time * 36000
		new_time = Clamp(new_time, 0, max_time)
		time_left = new_time

//EXILE IMPLANT MANAGEMENT COMPUTER - TEMPORARY - REPLACE WITH NANOUI AND MODCOMPUTE PROGRAM WHEN POSSIBLE.

/obj/machinery/computer/exilemanagement
	name = "prisoner management console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "explosive"
	light_color = "#a91515"
	req_access = list(core_access_security_programs)
	circuit = /obj/item/weapon/circuitboard/prisoner
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed


/obj/machinery/computer/exilemanagement/attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

/obj/machinery/computer/exilemanagement/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Exile Implants<BR>"
		for(var/obj/item/weapon/implant/laborexile/T in world)
			if(!T.implanted) continue
			dat += "ID: [T.ring_ID]<BR>"
			dat += "<A href='?src=\ref[src];warn=\ref[T]'>(<font color=red><i>Message Holder</i></font>)</A> | <A href='?src=\ref[src];deactivate=\ref[T]'>(<font color=red><i>Deactivate Implant</i></font>)</A><BR>"
			dat += "********************************<BR>"
	dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/exilemanagement/Process()
	if(!..())
		src.updateDialog()
	return

/obj/machinery/computer/exilemanagement/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")

		else if(href_list["warn"])
			var/warning = sanitize(input(usr,"Message:","Enter your message here!",""))
			if(!warning) return
			var/obj/item/weapon/implant/I = locate(href_list["warn"])
			if((I)&&(I.imp_in))
				var/mob/living/carbon/R = I.imp_in
				to_chat(R, "<span class='notice'>You hear a voice in your head saying: '[warning]'</span>")

		else if(href_list["deactivate"])
			var/obj/item/weapon/implant/laborexile/I = locate(href_list["deactivate"])
			I.deactivate()

	src.updateUsrDialog()
	return