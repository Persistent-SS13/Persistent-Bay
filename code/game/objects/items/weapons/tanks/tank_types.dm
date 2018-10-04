/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Phorosian Phoron
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/weapon/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list("oxygen" = 10*ONE_ATMOSPHERE)
	volume = 180

/obj/item/weapon/tank/oxygen/yellow
	desc = "A tank of oxygen. This one is yellow."
	icon_state = "oxygen_f"

/obj/item/weapon/tank/oxygen/red
	desc = "A tank of oxygen. This one is red."
	icon_state = "oxygen_fr"


/*
 * Anesthetic
 */
/obj/item/weapon/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"
	w_class = ITEM_SIZE_HUGE
	starting_pressure = list("oxygen" = 10*ONE_ATMOSPHERE*O2STANDARD, "sleeping_agent" = 10*ONE_ATMOSPHERE*N2STANDARD)
	volume = 270

/*
 * Air
 */
/obj/item/weapon/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"
	starting_pressure = list("oxygen" = 6*ONE_ATMOSPHERE*O2STANDARD, "nitrogen" = 6*ONE_ATMOSPHERE*N2STANDARD)
	volume = 180

/*
 * Phoron
 */
/obj/item/weapon/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null	//they have no straps!
	starting_pressure = list("phoron" = 3*ONE_ATMOSPHERE)
	volume = 180

/obj/item/weapon/tank/phoron/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/weapon/flamethrower))
		var/obj/item/weapon/flamethrower/F = W
		if ((!F.status)||(F.ptank))	return
		src.master = F
		F.ptank = src
		user.remove_from_mob(src)
		forceMove(F)

/*
 * Phorosian Phoron
 */
/obj/item/weapon/tank/phoron/phorosian
	desc = "The lifeblood of Phorosians.  Warning:  Extremely flammable, do not inhale (unless you're a Phorosian)."
	icon_state = "phoronfr"
	gauge_icon = "indicator_tank"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list("phoron" = 6*ONE_ATMOSPHERE)
	volume = 180

/*
 * Emergency Oxygen
 */
/obj/item/weapon/tank/emergency
	name = "emergency tank"
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 4
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 40
	matter = list("steel" = 250)

/obj/item/weapon/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	starting_pressure = list("oxygen" = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 55
	matter = list("steel" = 350)

/obj/item/weapon/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	gauge_icon = "indicator_emergency_double"
	volume = 70
	matter = list("steel" = 500)


/obj/item/weapon/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red and issued to Vox crewmembers."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"
	starting_pressure = list("nitrogen" = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/nitrogen/double
	name = "double emergency nitrogen tank"
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 70
	matter = list("steel" = 500)

/obj/item/weapon/tank/emergency/phoron
	name = "emergency phoron tank"
	desc = "An emergency air tank hastily painted orange and issued to Phorosian crewmembers."
	icon_state = "emergency_phoron"
	gauge_icon = "indicator_emergency"
	starting_pressure = list("phoron" = 10*ONE_ATMOSPHERE)

/*
 * Nitrogen
 */
/obj/item/weapon/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list("nitrogen" = 6*ONE_ATMOSPHERE)
	volume = 180
