/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Hydrogen
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
	starting_pressure = list(GAS_OXYGEN = 10*ONE_ATMOSPHERE)
	volume = 180
	matter = list(MATERIAL_STEEL = 2000)

/obj/item/weapon/tank/oxygen/yellow
	desc = "A tank of oxygen. This one is yellow."
	icon_state = "oxygen_f"
	starting_pressure = list(GAS_OXYGEN = 0)

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
	starting_pressure = list(GAS_OXYGEN = 10*ONE_ATMOSPHERE*O2STANDARD, GAS_N2O = 10*ONE_ATMOSPHERE*N2STANDARD)
	volume = 270
	matter = list(MATERIAL_STEEL = 3000)

/*
 * Air
 */
/obj/item/weapon/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE*O2STANDARD, GAS_NITROGEN = 6*ONE_ATMOSPHERE*N2STANDARD)
	volume = 180
	matter = list(MATERIAL_STEEL = 2000)

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
	starting_pressure = list(GAS_PHORON = 3*ONE_ATMOSPHERE)
	volume = 180
	matter = list(MATERIAL_STEEL = 2500)

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
 * Hydrogen
 */
/obj/item/weapon/tank/hydrogen
	name = "hydrogen tank"
	desc = "Contains hydrogen. Warning: flammable."
	icon_state = "hydrogen"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null
	starting_pressure = list(GAS_HYDROGEN = 3*ONE_ATMOSPHERE)
	matter = list(MATERIAL_STEEL = 2500)

/obj/item/weapon/tank/hydrogen/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/flamethrower))
		var/obj/item/weapon/flamethrower/F = W
		if (!F.status || F.ptank || user.unEquip(src, F))
			return
		master = F
		F.ptank = src

/*
 * Phorosian Phoron
 */
/obj/item/weapon/tank/phoron/phorosian
	desc = "The lifeblood of Phorosians.  Warning:  Extremely flammable, do not inhale (unless you're a Phorosian)."
	icon_state = "phoronfr"
	gauge_icon = "indicator_tank"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(GAS_PHORON = 6*ONE_ATMOSPHERE)
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
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 40
	matter = list(MATERIAL_STEEL = 800)

/obj/item/weapon/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	starting_pressure = list(GAS_OXYGEN = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 60
	matter = list(MATERIAL_STEEL = 950)

/obj/item/weapon/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	gauge_icon = "indicator_emergency_double"
	volume = 90
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 1200)

/obj/item/weapon/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red and issued to Vox crewmembers."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"
	starting_pressure = list(GAS_NITROGEN = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/nitrogen/double
	name = "double emergency nitrogen tank"
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 70
	matter = list(MATERIAL_STEEL = 1200)

/obj/item/weapon/tank/emergency/phoron
	name = "emergency phoron tank"
	desc = "An emergency air tank hastily painted orange and issued to Phorosian crewmembers."
	icon_state = "emergency_phoron"
	gauge_icon = "indicator_emergency"
	starting_pressure = list(GAS_PHORON = 10*ONE_ATMOSPHERE)

/*
 * Nitrogen
 */
/obj/item/weapon/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(GAS_NITROGEN = 6*ONE_ATMOSPHERE)
	volume = 180
	matter = list(MATERIAL_STEEL = 2000)

/*
 * Empty Tanks
 */

/obj/item/weapon/tank/oxygen/empty
	starting_pressure = null
/obj/item/weapon/tank/oxygen/yellow/empty
	starting_pressure = null
/obj/item/weapon/tank/oxygen/red/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/oxygen/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/oxygen/engi/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/oxygen/double/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/empty
	starting_pressure = null

/obj/item/weapon/tank/hydrogen/empty //fuel
	starting_pressure = null

/obj/item/weapon/tank/phoron/empty //fuel tank
	starting_pressure = null
/obj/item/weapon/tank/emergency/phoron/empty
	starting_pressure = null

/obj/item/weapon/tank/nitrogen/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/nitrogen/empty
	starting_pressure = null
/obj/item/weapon/tank/emergency/nitrogen/double/empty
	starting_pressure = null

