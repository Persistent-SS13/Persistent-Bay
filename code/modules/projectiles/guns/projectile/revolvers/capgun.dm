/obj/item/weapon/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon_state = "revolver-toy"
	caliber = CALIBER_CAPS
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_PLASTIC = 500)

/obj/item/weapon/gun/projectile/revolver/capgun/attackby(obj/item/weapon/tool/W, mob/user)
	if(!isWirecutter(W) || icon_state == "revolver")
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	name = "revolver"
	icon_state = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	return 1