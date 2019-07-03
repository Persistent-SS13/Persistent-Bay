/obj/item/weapon/gun/projectile/revolver/foundation
	name = "CF 'Troubleshooter' revolver"
	icon = 'icons/obj/guns/foundation.dmi'
	icon_state = "foundation"
	desc = "The CF 'Troubleshooter', a compact plastic-composite weapon designed for concealed carry by Cuchulain Foundation field agents. Smells faintly of copper. Uses .44 rounds."
	ammo_type = /obj/item/ammo_casing/pistol/magnum/nullglass
	matter = list(MATERIAL_STEEL = 2500)
	mass = 1.2 KILOGRAMS

/obj/item/weapon/gun/projectile/revolver/foundation/disrupts_psionics()
	return FALSE