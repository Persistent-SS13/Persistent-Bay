/obj/item/weapon/gun/projectile/revolver
	name = "\improper AMM .357 revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, positively need to put a hole in the other guy."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	caliber = CALIBER_357
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	fire_delay = 12 //Revolvers are naturally slower-firing
	ammo_type = /obj/item/ammo_casing/c357
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	accuracy = 2
	accuracy_power = 8
	one_hand_penalty = 2
	bulk = 3
	slot_flags = SLOT_HOLSTER

/obj/item/weapon/gun/projectile/revolver/AltClick()
	if(CanPhysicallyInteract(usr))
		spin_cylinder()

/obj/item/weapon/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/weapon/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/weapon/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()
