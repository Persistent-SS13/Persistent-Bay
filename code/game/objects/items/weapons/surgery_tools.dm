/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/*
 * Retractor
 */

/obj/item/var/rushed = FALSE
/obj/item/weapon/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/obj/item/weapon/retractor/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing for a careful retraction.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You tightly grip \the [src], preparing for a rushed retraction.</span> ")
/obj/item/weapon/retractor/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You hurriedly grab \the [src], preparing for a rushed retraction.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing for a careful retraction.</span> ")
/*
 * Hemostat
 */
/obj/item/weapon/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")
/obj/item/weapon/hemostat/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to carefully clamp blood flow.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You tightly grip \the [src], preparing to hurriedly clamp blood flow.</span> ")
/obj/item/weapon/hemostat/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to hurriedly clamp blood flow.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to carefully clamp blood flow.</span> ")
/*
 * Cautery
 */
/obj/item/weapon/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")
/obj/item/weapon/cautery/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to carefully cauterize an incision.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You tightly grip \the [src], preparing to hurriedly cauterize an incision.</span> ")
/obj/item/weapon/cautery/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to hurriedly cauterize an incision</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to carefully cauterize an incision.</span> ")
/*
 * Surgical Drill
 */
/obj/item/weapon/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	sound_hit = 'sound/weapons/circsawhit.ogg'
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 10000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
/obj/item/weapon/surgicaldrill/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to carefully drill something.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You whirr \the [src] dramatically, preparing to recklessly drill something.</span> ")
/obj/item/weapon/surgicaldrill/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to recklessly drill something.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to carefully drill something.</span> ")
/*
 * Scalpel
 */
/obj/item/weapon/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 10.0
	sharpness = 1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	mass = 0.050
	damtype = DAM_CUT

/obj/item/weapon/scalpel/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to make a careful cut.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You grip \the [src] tightly, preparing to make a hurried cut.</span> ")
/obj/item/weapon/scalpel/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to make a hurried cut.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to make a careful cut.</span> ")
/*
 * Researchable Scalpels
 */
/obj/item/weapon/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = DAM_LASER
	mass = 0.250

/obj/item/weapon/scalpel/laser2
	name = "improved laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = DAM_LASER
	force = 12.0
	mass = 0.275

/obj/item/weapon/scalpel/laser3
	name = "advanced laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = DAM_LASER
	force = 15.0
	mass = 0.290

/obj/item/weapon/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5
	mass = 0.5

/*
 * Circular Saw
 */
/obj/item/weapon/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	sound_attack = 'sound/weapons/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 20000,MATERIAL_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharpness = 3
	damtype = DAM_CUT
	mass = 0.6


/obj/item/weapon/circular_saw/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to carefully saw through bone.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You whirr \the [src] dramatically, preparing to recklessly saw through bone.</span> ")
/obj/item/weapon/circular_saw/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to recklessly saw through bone.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to carefully saw through bone.</span> ")

//misc, formerly from code/defines/weapons.dm
/obj/item/weapon/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0
	mass = 0.250

/obj/item/weapon/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = ITEM_SIZE_SMALL
	var/usage_amount = 10
	mass = 0.250

/obj/item/weapon/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
	damtype = DAM_BLUNT
	mass = 0.120

/obj/item/weapon/bonesetter/attack_self(mob/user)
	if (rushed)
		rushed = FALSE
		to_chat(user, "<span class='notice'>You steadily hold \the [src], preparing to carefully set bones.</span> ")
	else
		rushed = TRUE
		to_chat(user, "<span class='notice'>You tightly grip \the [src], preparing to hurriedly set bones.</span> ")
/obj/item/weapon/bonesetter/pickup(mob/user)
	if (rushed)
		to_chat(user, "<span class='notice'>You grab \the [src], preparing to carefully set bones.</span> ")
	else
		to_chat(user, "<span class='notice'>You pick up \the [src], preparing to hurriedly set bones.</span> ")
