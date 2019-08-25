/*
Some standard magazines, speedloaders and clips
*/

//----------------------------------
//	Clips
//----------------------------------
/obj/item/ammo_magazine/clip
	name = "clip"
	desc = "A clip for reloading a fixed magazine rifle quickly."
	mag_type = SPEEDLOADER
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 100)
	mass = 5 GRAMS
/obj/item/ammo_magazine/speedloader/Initialize()
	. = ..()
	SetName("clip ([caliber])")

//----------------------------------
//	Clip 9mm
//----------------------------------
/obj/item/ammo_magazine/clip/c9mm
	icon_state = "7.63mm_clip" //Since this should be a modern replica, we'll avoid the 7.63mm round..
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 9
	multiple_sprites = 1
/obj/item/ammo_magazine/clip/c9mm/empty
	initial_ammo = 0

//----------------------------------
//	Clip 7.62mm
//----------------------------------
/obj/item/ammo_magazine/clip/c762
	icon_state = "stripper"
	caliber = CALIBER_762MM
	ammo_type = /obj/item/ammo_casing/c762
	max_ammo = 5
	multiple_sprites = 1
/obj/item/ammo_magazine/clip/c762/empty
	initial_ammo = 0

//----------------------------------
//	Speedloaders
//----------------------------------
/obj/item/ammo_magazine/speedloader
	name = "speed loader"
	desc = "A speed loader for revolvers."
	mag_type = SPEEDLOADER
	w_class = ITEM_SIZE_SMALL
	mass = 10 GRAMS
/obj/item/ammo_magazine/speedloader/Initialize()
	. = ..()
	if(!map_storage_loaded)
		SetName("speed loader ([caliber])")

//----------------------------------
//	Caps Speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/caps
	name = "speed loader (caps)"
	desc = "A cheap plastic speed loader for some kind of revolver."
	icon_state = "T38"
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 600)
	max_ammo = 7
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/caps/empty
	initial_ammo = 0

//----------------------------------
//	standard .22lr speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/c22lr
	icon_state = "spdloader_small"
	caliber = CALIBER_22LR
	ammo_type = /obj/item/ammo_casing/c22lr
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 6
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/c22lr/empty
	initial_ammo = 0

//----------------------------------
//	standard .357 speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/c357
	icon_state = "spdloader"
	caliber = CALIBER_357
	ammo_type = /obj/item/ammo_casing/c357
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 6
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/c357/empty
	initial_ammo = 0

//----------------------------------
//	standard .38 speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/c38
	icon_state = "spdloader"
	caliber = CALIBER_38
	ammo_type = /obj/item/ammo_casing/c38
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/c38/empty
	initial_ammo = 0
/obj/item/ammo_magazine/speedloader/c38/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c38/rubber

//----------------------------------
//	standard .44 speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/c44
	icon_state = "spdloader_magnum"
	caliber = CALIBER_44
	ammo_type = /obj/item/ammo_casing/c44
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/c44/empty
	initial_ammo = 0
/obj/item/ammo_magazine/speedloader/c44/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c44/rubber
/obj/item/ammo_magazine/speedloader/c44/emp
	labels = list("emp")
	ammo_type = /obj/item/ammo_casing/c44/emp
/obj/item/ammo_magazine/speedloader/c44/nullglass
	labels = list("psi")
	ammo_type = /obj/item/ammo_casing/c44/nullglass

//----------------------------------
//	standard .50 speedloader
//----------------------------------
/obj/item/ammo_magazine/speedloader/c50
	icon_state = "spdloader_magnum"
	caliber = CALIBER_50
	ammo_type = /obj/item/ammo_casing/c50
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1
/obj/item/ammo_magazine/speedloader/c50/empty
	initial_ammo = 0

//----------------------------------
//	standard 12g shotholder
//----------------------------------
/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 4
	multiple_sprites = 1
	mass = 80 GRAMS
	var/marking_color

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I
	
/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/beanbag
	name = "beanbag shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 720)
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/flash
	name = "illumination shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	matter = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 360)
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	name = "stun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	matter = list(MATERIAL_STEEL = 1440, MATERIAL_GLASS = 2880)
	marking_color = COLOR_MUZZLE_FLASH

/obj/item/ammo_magazine/shotholder/practice
	name = "practice shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/practice
	matter = list(MATERIAL_STEEL = 1440, MATERIAL_GLASS = 2880)
	marking_color = COLOR_ALUMINIUM

/obj/item/ammo_magazine/shotholder/empty
	name = "shotgun ammunition holder"
	matter = list(MATERIAL_STEEL = 250)
	initial_ammo = 0

//----------------------------------
//	Box Magazines
//----------------------------------
/obj/item/ammo_magazine/box
	w_class = ITEM_SIZE_SMALL
	mag_type = MAGAZINE
	mass = 100 GRAMS

//----------------------------------
//	standard 9mm Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c9mm
	name = "8rnds magazine (9mm)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 1800)
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 8
	multiple_sprites = 1
/obj/item/ammo_magazine/box/c9mm/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c9mm/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
/obj/item/ammo_magazine/box/c9mm/emp
	labels = list("emp")
	origin_tech = list(TECH_COMBAT = 2)
	ammo_type = /obj/item/ammo_casing/c9mm/emp

//----------------------------------
//	Standard 9mm 20 Rounds Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c9mm/_20
	name = "20rnds magazine (9mm)"
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 1800)
	caliber = CALIBER_9MM
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 20
	multiple_sprites = 1
	mass = 150 GRAMS
/obj/item/ammo_magazine/box/c9mm/_20/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c9mm/_20/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

//----------------------------------
//	.44 Pistol Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c44
	name = "6rnds magazine (.44)"
	icon_state = "magnum"
	ammo_type = /obj/item/ammo_casing/c44
	matter = list(MATERIAL_STEEL = 450)
	caliber = CALIBER_44
	max_ammo = 7
	multiple_sprites = 1
/obj/item/ammo_magazine/box/c44/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c44/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c44/rubber

//----------------------------------
//	.45 Standard Pistol Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c45
	name = "10rnds magazine (.45)"
	icon_state = "pistol"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_45
	matter = list(MATERIAL_STEEL = 2250)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 10
	multiple_sprites = 1
/obj/item/ammo_magazine/box/c45/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c45/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c45/rubber
/obj/item/ammo_magazine/box/c45/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c45/practice
/obj/item/ammo_magazine/box/c45/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/c45/flash
/obj/item/ammo_magazine/box/c45/emp
	labels = list("emp")
	ammo_type = /obj/item/ammo_casing/c45/emp

//----------------------------------
//	.45 Standard 15 rounds magazine
//----------------------------------
/obj/item/ammo_magazine/box/c45/_15
	name = "15rnds magazine (.45)"
	icon_state = "pistolds"
	caliber = CALIBER_45
	matter = list(MATERIAL_STEEL = 1050)
	max_ammo = 15
	mass = 120 GRAMS
/obj/item/ammo_magazine/box/c45/_15/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c45/_15/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c45/rubber
/obj/item/ammo_magazine/box/c45/_15/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c45/practice
/obj/item/ammo_magazine/box/c45/_15/emp
	labels = list("emp")
	ammo_type = /obj/item/ammo_casing/c45/emp


//----------------------------------
//	.45 Standard 20 Rounds Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c45/_20
	name = "20rnds magazine (.45)"
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_10MM
	matter = list(MATERIAL_STEEL = 1500)
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20
	multiple_sprites = 1
	mass = 150 GRAMS
/obj/item/ammo_magazine/box/c45/_20/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c45/_20/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/c45/rubber
/obj/item/ammo_magazine/box/c45/_20/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c45/practice
/obj/item/ammo_magazine/box/c45/_20/emp
	labels = list("emp")
	ammo_type = /obj/item/ammo_casing/c45/emp

//----------------------------------
//	.50 standard magazine
//----------------------------------
/obj/item/ammo_magazine/box/c50
	name = "7rnds standard magazine (.50)"
	icon_state = "magnum"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_50
	matter = list(MATERIAL_STEEL = 1260)
	ammo_type = /obj/item/ammo_casing/c50
	max_ammo = 7
	multiple_sprites = 1
	mass = 200 GRAMS
/obj/item/ammo_magazine/box/c50/empty
	initial_ammo = 0

//----------------------------------
//	5.56mm Standard Machine Gun Box
//----------------------------------
/obj/item/ammo_magazine/box/machinegun
	name = "magazine box (5.56mm)"
	icon_state = "machinegun"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_556MM
	matter = list(MATERIAL_STEEL = 4500)
	ammo_type = /obj/item/ammo_casing/c556
	max_ammo = 50
	multiple_sprites = 1
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_LARGE
	mass = 500 GRAMS
/obj/item/ammo_magazine/box/machinegun/empty
	initial_ammo = 0

//----------------------------------
//	5.56mm Standard 20 Rounds Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c556
	name = "20rnds magazine (5.56mm)"
	icon_state = "assault_rifle"
	caliber = CALIBER_556MM
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/c556
	max_ammo = 20
	multiple_sprites = 1
	mass = 120 GRAMS
/obj/item/ammo_magazine/box/c556/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c556/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c556/practice

//----------------------------------
//	7.62mm Standard 15 Rounds Magazine
//----------------------------------
/obj/item/ammo_magazine/box/c762
	name = "15rnds magazine (7.62mm)"
	icon_state = "bullup"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_762MM
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/c762
	max_ammo = 15 //if we lived in a world where normal mags had 30 rounds, this would be a 20 round mag
	multiple_sprites = 1
	mass = 180 GRAMS
/obj/item/ammo_magazine/box/c762/empty
	initial_ammo = 0
/obj/item/ammo_magazine/box/c762/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/c762/practice
