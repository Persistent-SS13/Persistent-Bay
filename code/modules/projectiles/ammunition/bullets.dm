/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/pistol/strong/revolver
	matter = list(DEFAULT_WALL_MATERIAL = 210, /datum/reagent/aluminum = 5)

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	matter = list(DEFAULT_WALL_MATERIAL = 260, /datum/reagent/aluminum = 15)

/obj/item/ammo_casing/a75
	desc = "A 20mm bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro
	matter = list(DEFAULT_WALL_MATERIAL = 520, /datum/reagent/aluminum = 30)

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 60, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/c38/rubber
	desc = "A .38 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list("plastic" = 60, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 60, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/c9mm/flash
	desc = "A 9mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash
	matter = list(DEFAULT_WALL_MATERIAL = 50, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/c9mm/rubber
	desc = "A 9mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list(DEFAULT_WALL_MATERIAL = 60, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/c9mm/practice
	desc = "A 9mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	matter = list(DEFAULT_WALL_MATERIAL = 50, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/c44
	desc = "A .44 magnum bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/pistol/medium/revolver
	matter = list(DEFAULT_WALL_MATERIAL = 75, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/c44/rubber
	desc = "A .44 magnum rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list("plastic" = 75, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	matter = list(DEFAULT_WALL_MATERIAL = 75, /datum/reagent/aluminum = 3)

/obj/item/ammo_casing/c45/practice
	desc = "A .45 practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	matter = list(DEFAULT_WALL_MATERIAL = 60, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/c45/rubber
	desc = "A .45 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list("plastic" = 75, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/c45/flash
	desc = "A .45 flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash
	matter = list(DEFAULT_WALL_MATERIAL = 60, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium/smg
	matter = list(DEFAULT_WALL_MATERIAL = 75, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360, /datum/reagent/aluminum = 3)

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360, /datum/reagent/aluminum = 3)

/obj/item/ammo_casing/shotgun/rubber
	name = "rubber shell"
	desc = "A 12 gauge rubber shell."
	icon_state = "rshell"
	spent_icon = "rshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/rubber
	matter = list("plastic" = 180, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(DEFAULT_WALL_MATERIAL = 90, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180, /datum/reagent/aluminum = 1)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	leaves_residue = 0
	matter = list(DEFAULT_WALL_MATERIAL = 360, "glass" = 720, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, "glass" = 90, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/rifle/a556
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	matter = list(DEFAULT_WALL_MATERIAL = 90, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 2500, /datum/reagent/aluminum = 10)

/obj/item/ammo_casing/a145/apds
	name = "APDS shell casing"
	desc = "A 14.5mm Armour Piercing Discarding Sabot shell."
	projectile_type = /obj/item/projectile/bullet/rifle/a145/apds
	matter = list(DEFAULT_WALL_MATERIAL = 2250, /datum/reagent/aluminum = 20)

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/rifle/a762
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	matter = list(DEFAULT_WALL_MATERIAL = 90, /datum/reagent/aluminum = 2)

/obj/item/ammo_casing/a762/practice
	desc = "A 7.62mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/practice
	matter = list(DEFAULT_WALL_MATERIAL = 90, /datum/reagent/aluminum = 1)

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#ff0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap
	matter = list("plastic" = 50)

// EMP ammo.
/obj/item/ammo_casing/c38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/ion/small
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100, /datum/reagent/aluminum = 3)

/obj/item/ammo_casing/c45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(DEFAULT_WALL_MATERIAL = 130, "uranium" = 100, /datum/reagent/aluminum = 4)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	matter = list(DEFAULT_WALL_MATERIAL = 260, "uranium" = 200, /datum/reagent/aluminum = 5)
