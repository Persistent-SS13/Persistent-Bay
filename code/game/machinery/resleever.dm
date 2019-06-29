/obj/machinery/resleever
	name = "neural lace resleever"
	desc = "It's a machine that allows neural laces to be sleeved into new bodies."
	icon = 'icons/obj/Cryogenic2.dmi'

	anchored = 1
	density = 1
	idle_power_usage = 4
	active_power_usage = 4 KILOWATTS // A CT scan machine uses 1-15 kW depending on the model and equipment involved.
	req_access = list(core_access_medical_programs)
	circuit_type = /obj/item/weapon/circuitboard/resleever

	icon_state = "resleever_open"
	var/empty_state = "resleever_open"
	var/occupied_state = "resleever_closed"
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/organ/internal/stack/lace = null

	var/resleeving = 0
	var/remaining = 0
	var/timetosleeve = 120

	var/occupant_name = null // Put in seperate var to prevent runtime.
	var/lace_name = null

/obj/machinery/resleever/New()
	..()
	ADD_SAVED_VAR(occupant)
	ADD_SAVED_VAR(lace)
	ADD_SAVED_VAR(remaining)
	ADD_SAVED_VAR(resleeving)

	ADD_SKIP_EMPTY(occupant)
	ADD_SKIP_EMPTY(lace)

/obj/machinery/resleever/Destroy()
	eject_occupant()
	eject_lace()
	return ..()

/obj/machinery/resleever/after_load()
	..()
	if(occupant)
		occupant_name = occupant.name
	if(lace)
		lace_name = lace.name

obj/machinery/resleever/Process()

	if(occupant)
		occupant.Paralyse(4) // We need to always keep the occupant sleeping if they're in here.
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(POWER_USE_OFF)
		return
	if(resleeving)
		update_use_power(POWER_USE_ACTIVE)
		if(remaining < timetosleeve)
			remaining += 1

			if(remaining == 90) // 30 seconds left
				to_chat(occupant, "<span class='notice'>You feel a wash of sensation as your senses begin to flood your mind. You will come to soon.</span>")
		else
			remaining = 0
			resleeving = 0
			update_use_power(POWER_USE_IDLE)
			eject_occupant()
			playsound(loc, 'sound/machines/ping.ogg', 100, vary = TRUE)
			visible_message("\The [src] pings as it completes its procedure!", "You hear a ping.", range = 3)
			return
	update_use_power(POWER_USE_OFF)
	return

/obj/machinery/resleever/proc/isOccupiedEjectable()
	return occupant && !resleeving

/obj/machinery/resleever/proc/isLaceEjectable()
	return lace && !resleeving

/obj/machinery/resleever/proc/readyToBegin()
	return (lace && occupant) && !resleeving

/obj/machinery/resleever/attack_ai(mob/user as mob)
	add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/resleever/attack_hand(mob/user as mob)
	if(!anchored)
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/resleever/ui_status(mob/user, datum/ui_state/state)
	if(!anchored || inoperable())
		return UI_CLOSE
	return ..()

/obj/machinery/resleever/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list(
		"name" = occupant_name,
		"lace" = lace_name,
		"isOccupiedEjectable" = isOccupiedEjectable(),
		"isLaceEjectable" = isLaceEjectable(),
		"active" = resleeving,
		"remaining" = remaining,
		"timetosleeve" = 120,
		"ready" = readyToBegin()
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "resleever.tmpl", "Neural Lace Resleever", 300, 370)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
	

/obj/machinery/resleever/OnTopic(var/mob/user, var/list/href_list, state)
	if (href_list["begin"])
		if(sleeve())
			resleeving = 1
		return TOPIC_REFRESH

	if (href_list["eject"])
		eject_occupant()
		return TOPIC_REFRESH

	if (href_list["ejectlace"])
		eject_lace()
		return TOPIC_REFRESH

/obj/machinery/resleever/proc/sleeve()
	if(lace && !lace.prompting && occupant) // Not only check for the lace and occupant, but also if the lace isn't already prompting the dead user.
		var/obj/item/organ/O = occupant.get_organ(lace.parent_organ)
		if(istype(O))
			lace.status &= ~ORGAN_CUT_AWAY //ensure the lace is properly attached
			if(lace.replaced(occupant, O))
				lace = null
				lace_name = null
				playsound(loc, 'sound/machines/twobeep.ogg', 50, vary = TRUE)
				visible_message("\The [src] beeps softly as it begins its procedure.", "You hear a beep.", range = 3)
				return TRUE
	return FALSE // Return false if the the lace doesn't exist, the lace is busy prompting, no occupant, or the occupant's head (parrent organ) doesn't exist.

/obj/machinery/resleever/proc/go_in(var/mob/target, var/mob/user)
	if(occupant)
		to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
		return FALSE

	if(!check_occupant_allowed(target))
		return FALSE

	visible_message("[user] starts putting [target.name] into \the [src].", 3)

	if(do_after(user, 2 SECONDS, target))
		if (target.buckled)
			target.buckled.user_unbuckle_mob(user)
			if (target.buckled)
				return FALSE
		target.forceMove(src)

		occupant = target
		occupant_name = target.name
		update_icon()
		if(target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src

		return TRUE

	return FALSE

/obj/machinery/resleever/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(default_deconstruction_crowbar(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(default_part_replacement(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(istype(W, /obj/item/organ/internal/stack))
		if(istype(W, /obj/item/organ/internal/stack/vat))
			to_chat(user, "<span class='warning'>[W] does not fit into [src], and you get the horrifying feeling that it was not meant to.</span>")
			return
		if(isnull(lace) && user.unEquip(W, src))
			to_chat(user, "<span class='notice'>You insert \the [W] into [src].</span>")
			lace = W
			if(lace.backup)
				lace_name = lace.backup.name
		else
			to_chat(user, "<span class='warning'>\The [src] already has a neural lace inside it!</span>")
			return
	else if(isWrench(W))
		if(isnull(occupant))
			if(anchored)
				anchored = 0
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
			else
				anchored = 1
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
		else
			to_chat(user, "<span class='warning'>Can not do that while [src] is occupied.</span>")

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/grab = W
		if(occupant)
			to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
			return

		if(!ismob(grab.affecting))
			return

		if(go_in(grab.affecting, user))
			qdel(grab)

/obj/machinery/resleever/MouseDrop_T(var/mob/target, var/mob/user)
	if(!istype(target))
		return
	if (!CanMouseDrop(target, user))
		return
	go_in(target, user)

/obj/machinery/resleever/proc/eject_occupant()
	if(!(occupant))
		return
	occupant.forceMove(loc)
	if(occupant.client)
		occupant.reset_view(null)
	occupant = null
	occupant_name = null
	update_icon()

/obj/machinery/resleever/proc/eject_lace()
	if(!(lace))
		return
	lace.forceMove(loc)
	lace = null
	lace_name = null

/obj/machinery/resleever/ex_act(severity)
	var/dropprob = 100
	switch(severity)
		if(2)
			dropprob = 50
		if(3)
			dropprob = 25
	if(prob(dropprob))
		for(var/atom/movable/A in src)
			A.forceMove(loc)
			A.ex_act(severity)
		//qdel(src)
	return ..()

/obj/machinery/resleever/on_update_icon()
	..()
	icon_state = empty_state
	if(occupant)
		icon_state = occupied_state


/obj/machinery/resleever/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1
