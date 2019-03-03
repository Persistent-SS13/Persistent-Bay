// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are supposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

/obj/machinery/door/blast
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null
	closed_layer = ABOVE_WINDOW_LAYER
	dir = NORTH
	explosion_resistance = 25
	max_health = 2000
	armor = list(
		DAM_BLUNT  	= MaxArmorValue,
		DAM_PIERCE 	= MaxArmorValue,
		DAM_CUT 	= MaxArmorValue,
		DAM_BULLET 	= MaxArmorValue,
		DAM_ENERGY 	= MaxArmorValue,
		DAM_BURN 	= MaxArmorValue,
		DAM_BOMB 	= MaxArmorValue,
		DAM_EMP 	= MaxArmorValue,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	//Radio stuff
	id_tag 				= null
	frequency 			= DOOR_FREQ
	radio_filter_in 	= RADIO_BLAST_DOORS
	radio_filter_out 	= RADIO_BLAST_DOORS
	radio_check_id 		= TRUE

	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null

	var/open_sound = 'sound/machines/airlock_heavy.ogg'
	var/close_sound = 'sound/machines/AirlockClose_heavy.ogg'

	var/begins_closed = TRUE
	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/material/implicit_material

/obj/machinery/door/blast/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

	if(!map_storage_loaded)
		if(!begins_closed)
			icon_state = icon_state_open
			set_density(0)
			set_opacity(0)
			layer = open_layer

		implicit_material = SSmaterials.get_material_by_name(MATERIAL_PLASTEEL)
	queue_icon_update()

/obj/machinery/door/airlock/Destroy()
	QDEL_NULL(wifi_receiver)
	return ..()

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	SSradiation.resistance_cache.Remove(get_turf(src))
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	playsound(src.loc, open_sound, 100, 1)
	flick(icon_state_opening, src)
	src.set_density(0)
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operating = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	src.operating = 1
	playsound(src.loc, close_sound, 100, 1)
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.set_density(1)
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(1)
	sleep(15)
	src.operating = 0

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle()
	if(src.density)
		src.force_open()
	else
		src.force_close()

/obj/machinery/door/blast/get_material()
	return implicit_material

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(isCrowbar(C) || (istype(C, /obj/item/weapon/material/twohanded/fireaxe) && C:wielded == 1))
		if(inoperable() && !( src.operating ))
			force_toggle()
		else
			to_chat(usr, SPAN_NOTICE("[src]'s motors resist your effort."))
		return
	if(istype(C, /obj/item/stack/material) && C.get_material_name() == MATERIAL_PLASTEEL)
		var/amt = Ceiling((max_health - health)/150)
		if(!amt)
			to_chat(usr, SPAN_NOTICE("\The [src] is already fully repaired."))
			return
		var/obj/item/stack/P = C
		if(P.amount < amt)
			to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
			return
		to_chat(usr, SPAN_NOTICE("You begin repairing [src]..."))
		if(do_after(usr, 30, src))
			if(P.use(amt))
				to_chat(usr, SPAN_NOTICE("You have repaired \the [src]"))
				src.repair()
			else
				to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
	..()


// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open()
	if (src.operating || inoperable())
		return
	force_open()
	if(autoclose)
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()
	if (src.operating || inoperable())
		return
	force_close()


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = max_health
	set_broken(FALSE)

/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()



// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	max_health = 2000
	block_air_zones = 1

/obj/machinery/door/blast/regular/open
	begins_closed = FALSE
	icon_state = "pdoor0"

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	open_sound = 'sound/machines/shutters_open.ogg'
	close_sound = 'sound/machines/shutters_close.ogg'
	max_health = 1200
	armor = list(
		DAM_BLUNT  	= 80,
		DAM_PIERCE 	= 80,
		DAM_CUT 	= 90,
		DAM_BULLET 	= 50,
		DAM_ENERGY 	= 50,
		DAM_BURN 	= 90,
		DAM_BOMB 	= 60,
		DAM_EMP 	= 50,
		DAM_BIO 	= MaxArmorValue,
		DAM_RADS 	= MaxArmorValue,
		DAM_STUN 	= MaxArmorValue,
		DAM_PAIN	= MaxArmorValue,
		DAM_CLONE   = MaxArmorValue)

/obj/machinery/door/blast/shutters/open
	begins_closed = FALSE
	icon_state = "shutter0"
