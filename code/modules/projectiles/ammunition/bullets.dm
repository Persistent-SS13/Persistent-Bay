//--------------------------------
//	.50 Rounds
//--------------------------------
/obj/item/ammo_casing/c50
	desc = "A .50AE bullet casing."
	caliber = CALIBER_50
	projectile_type = /obj/item/projectile/bullet/pistol/c50
	matter = list(MATERIAL_STEEL = 260)

//--------------------------------
//	.22 LR Rounds
//--------------------------------
/obj/item/ammo_casing/c22lr
	desc = "A .22LR bullet casing."
	caliber = CALIBER_22LR
	icon_state = "smallcasing"
	spent_icon = "smallcasing-spent"
	projectile_type = /obj/item/projectile/bullet/pistol/c22lr
	matter = list(MATERIAL_STEEL = 40)

//--------------------------------
//	.357 Rounds
//--------------------------------
/obj/item/ammo_casing/c357
	desc = "A .357 bullet casing."
	caliber = CALIBER_357
	icon_state = "magnumcasing"
	spent_icon = "magnumcasing-spent"
	projectile_type = /obj/item/projectile/bullet/pistol/c357
	matter = list(MATERIAL_STEEL = 210)

//--------------------------------
//	.38 Rounds
//--------------------------------
/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = CALIBER_38
	icon_state = "smallcasing"
	spent_icon = "smallcasing-spent"
	projectile_type = /obj/item/projectile/bullet/pistol/c38
	matter = list(MATERIAL_STEEL = 60)

/obj/item/ammo_casing/c38/rubber
	desc = "A .38 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list(MATERIAL_PLASTIC = 60)

/obj/item/ammo_casing/c38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/ion/small
	matter = list(MATERIAL_STEEL = 130, MATERIAL_URANIUM = 100)

//--------------------------------
//	9mm Rounds
//--------------------------------
/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = CALIBER_9MM
	icon_state = "smallcasing"
	spent_icon = "smallcasing-spent"
	projectile_type = /obj/item/projectile/bullet/pistol/c9mm
	matter = list(MATERIAL_STEEL = 60)

/obj/item/ammo_casing/c9mm/flash
	desc = "A 9mm flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash
	matter = list(MATERIAL_STEEL = 50)

/obj/item/ammo_casing/c9mm/rubber
	desc = "A 9mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list(MATERIAL_STEEL = 60)

/obj/item/ammo_casing/c9mm/practice
	desc = "A 9mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	matter = list(MATERIAL_STEEL = 50)

/obj/item/ammo_casing/c9mm/emp
	name = "9mm haywire round"
	desc = "A 9mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/tiny
	icon_state = "smallcasing_h"

//--------------------------------
//	.44 Rounds
//--------------------------------
/obj/item/ammo_casing/c44
	desc = "A .44 magnum bullet casing."
	caliber = CALIBER_44
	projectile_type = /obj/item/projectile/bullet/pistol/c44
	matter = list(MATERIAL_STEEL = 75)

/obj/item/ammo_casing/c44/rubber
	desc = "A .44 magnum rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rubber
	icon_state = "r-casing"
	spent_icon = "r-casing-spent"
	matter = list(MATERIAL_PLASTIC = 75)

/obj/item/ammo_casing/c44/emp
	name = ".44 haywire round"
	desc = "A .44 magnum rubber bullet casing."
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/ion/small
	matter = list(MATERIAL_STEEL = 130, MATERIAL_URANIUM = 100)

/obj/item/ammo_casing/c44/nullglass
	name = ".44 haywire round"
	desc = "A .44 magnum casing with a nullglass coating"
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/bullet/nullglass
	matter = list(MATERIAL_STEEL = 130, MATERIAL_NULLGLASS = 100)
/obj/item/ammo_casing/c44/nullglass/disrupts_psionics()
	return src

//--------------------------------
//	.45 Rounds
//--------------------------------
/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = CALIBER_45
	icon_state = "pistolcasing"
	spent_icon = "pistolcasing-spent"
	projectile_type = /obj/item/projectile/bullet/pistol/c45
	matter = list(MATERIAL_STEEL = 75)

/obj/item/ammo_casing/c45/practice
	desc = "A .45 practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	icon_state = "pistolcasing_p"
	matter = list(MATERIAL_STEEL = 60)

/obj/item/ammo_casing/c45/rubber
	desc = "A .45 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/rubber
	icon_state = "pistolcasing_r"
	matter = list(MATERIAL_PLASTIC = 75)

/obj/item/ammo_casing/c45/flash
	desc = "A .45 flash shell casing."
	projectile_type = /obj/item/projectile/energy/flash
	matter = list(MATERIAL_STEEL = 60)

/obj/item/ammo_casing/c45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "pistolcasing_h"
	matter = list(MATERIAL_STEEL = 130, MATERIAL_URANIUM = 100)

//--------------------------------
//	"10mm" Rounds (10mm is the same size as .45...)
//--------------------------------
/obj/item/ammo_casing/c10mm
	desc = "A 10mm bullet casing."
	caliber = CALIBER_10MM
	projectile_type = /obj/item/projectile/bullet/smg/c45
	matter = list(MATERIAL_STEEL = 75)

//--------------------------------
//	Gyrojet Rounds
//--------------------------------
//obj/item/ammo_casing/gyrojet
//	desc = "A gyrojet bullet casing."
//	caliber = CALIBER_GYROJET
//	projectile_type = /obj/item/projectile/bullet/gyro
//	icon_state = "gyro-casing"
//	spent_icon = "gyro-casing" //Its a single piece rocket, there's no spent casing
//	matter = list(MATERIAL_STEEL = 520, /datum/reagent/aluminum = 30)

//--------------------------------
//	4mm Flechettes Rounds
//--------------------------------
/obj/item/ammo_casing/flechette
	desc = "A 4mm flechette casing."
	caliber = CALIBER_PISTOL_FLECHETTE
	projectile_type = /obj/item/projectile/bullet/flechette
	icon_state = "flechette-casing"
	spent_icon = "flechette-casing-spent"

//--------------------------------
//	12 Gauge Rounds
//--------------------------------
/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MATERIAL_STEEL = 360)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(MATERIAL_STEEL = 360)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 180)

/obj/item/ammo_casing/shotgun/rubber
	name = "rubber shell"
	desc = "A rubber ball filled shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/rubber
	matter = list(MATERIAL_STEEL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	leaves_residue = 0
	matter = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 720)

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
	matter = list(MATERIAL_STEEL = 90, MATERIAL_GLASS = 90)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	matter = list(MATERIAL_STEEL = 260, MATERIAL_URANIUM = 200)

//--------------------------------
//	5.56mm Rounds
//--------------------------------
/obj/item/ammo_casing/c556
	desc = "A 5.56mm bullet casing."
	caliber = CALIBER_556MM
	projectile_type = /obj/item/projectile/bullet/rifle/c556
	icon_state = "riflecasing"
	spent_icon = "riflecasing-spent"
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/c556/practice
	desc = "A 5.56mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/c556/practice
	icon_state = "rifle_mil_p"
	matter = list(MATERIAL_STEEL = 90)

//--------------------------------
//	14.5mm Rounds
//--------------------------------
/obj/item/ammo_casing/c145
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = CALIBER_145MM
	projectile_type = /obj/item/projectile/bullet/rifle/c145
	matter = list(MATERIAL_STEEL = 2500)

/obj/item/ammo_casing/c145/apds
	name = "APDS shell casing"
	desc = "A 14.5mm Armour Piercing Discarding Sabot shell."
	projectile_type = /obj/item/projectile/bullet/rifle/c145/apds
	matter = list(MATERIAL_STEEL = 2250)

//--------------------------------
//	7.62mm Rounds (.308)
//--------------------------------
/obj/item/ammo_casing/c762
	desc = "A 7.62mm bullet casing."
	caliber = CALIBER_762MM
	projectile_type = /obj/item/projectile/bullet/rifle/c762
	icon_state = "rifle_mil"
	spent_icon = "rifle_mil-spent"
	matter = list(MATERIAL_STEEL = 90)

/obj/item/ammo_casing/c762/practice
	desc = "A 7.62mm practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/c762/practice
	icon_state = "rifle_mil_p"
	matter = list(MATERIAL_STEEL = 90)

//--------------------------------
//	40mm Rocket Rounds
//--------------------------------
/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = CALIBER_40MM_ROCKET

//--------------------------------
//	Cap Gun Caps
//--------------------------------
/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = CALIBER_CAPS
	color = "#ff0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap
	matter = list(MATERIAL_PLASTIC = 50)
