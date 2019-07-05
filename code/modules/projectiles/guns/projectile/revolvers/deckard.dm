// Blade Runner pistol.
/obj/item/weapon/gun/projectile/revolver/deckard
	name = "\improper Deckard .44"
	desc = "A custom-built revolver, based off the semi-popular Detective Special model."
	icon = 'icons/obj/weapons/guns/pistol_deckard.dmi'
	icon_state = "deckard-empty"
	ammo_type = /obj/item/ammo_magazine/speedloader/c44
	one_hand_penalty = 1
	matter = list(MATERIAL_STEEL = 2500, MATERIAL_COPPER = 500)
	mass = 1.2 KILOGRAMS

/obj/item/weapon/gun/projectile/revolver/deckard/emp
	ammo_type = /obj/item/ammo_magazine/speedloader/c44/emp

/obj/item/weapon/gun/projectile/revolver/deckard/update_icon()
	..()
	if(loaded.len)
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/weapon/gun/projectile/revolver/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reload",src)
	..()
