/obj/machinery/fabricator/ammo_fabricator
	name = "Ammunition Fabricator"
	desc = "A machine used for the production of ammunitions of many calibers."
	circuit = /obj/item/weapon/circuitboard/fabricator/ammofab
	build_type = AMMOFAB

	icon_state = 	 "circuitfab-idle"
	icon_idle = 	 "circuitfab-idle"
	icon_open = 	 "circuitfab-o"
	overlay_active = "circuitfab-active"
	metal_load_anim = FALSE

	has_reagents = TRUE

/obj/machinery/fabricator/ammo_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_ammofab <= trying.limits.ammofabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.ammofabs |= src
	req_access_faction = trying.uid
	connected_faction = src
	
/obj/machinery/fabricator/ammo_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.ammofabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")



////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

//Ammunition
/datum/design/item/ammofab
	build_type = AMMOFAB
	category = "Ammunition"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 1)
	time = 2

/datum/design/item/ammofab/ammo
	category = "Ammunition"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 1)

/datum/design/item/ammofab/a357
	name = ".357 Bullet"
	id = "a357"
	build_path = /obj/item/ammo_casing/a357
	materials = list(MATERIAL_STEEL = 210)
	chemicals = list(/datum/reagent/aluminum = 5)

/datum/design/item/ammofab/a50
	name = ".50 Bullet"
	id = "a50"
	build_path = /obj/item/ammo_casing/a50
	materials = list(MATERIAL_STEEL = 260)
	chemicals = list(/datum/reagent/aluminum = 15)

/datum/design/item/ammofab/a75
	name = "20mm Bullet"
	id = "75"
	build_path = /obj/item/ammo_casing/a75
	materials = list(MATERIAL_STEEL = 320)
	chemicals = list(/datum/reagent/aluminum = 30)

/datum/design/item/ammofab/c38
	name = ".38 Bullet"
	id = "c38"
	build_path = /obj/item/ammo_casing/c38
	materials = list(MATERIAL_STEEL = 60)
	chemicals = list(/datum/reagent/aluminum = 4)

/datum/design/item/ammofab/c38/rubber
	name = "Rubber .38 Bullet"
	id = "c38r"
	build_path = /obj/item/ammo_casing/c38/rubber
	materials = list(MATERIAL_PLASTIC = 60)
	chemicals = list(/datum/reagent/aluminum = 4)

/datum/design/item/ammofab/c9mm
	name = "9mm Bullet"
	id = "c9mm"
	build_path = /obj/item/ammo_casing/c9mm
	materials = list(MATERIAL_STEEL = 60)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/c9mm/flash
	name = "Flash 9mm Bullet"
	id = "c9mmf"
	build_path = /obj/item/ammo_casing/c9mm/flash
	materials = list(MATERIAL_STEEL = 50)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/c9mm/rubber
	name = "Rubber 9mm Bullet"
	id = "c9mmr"
	build_path = /obj/item/ammo_casing/c9mm/rubber
	materials = list(MATERIAL_STEEL = 60)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/c9mm/practice
	name = "Practice 9mm Bullet"
	id = "c9mmp"
	build_path = /obj/item/ammo_casing/c9mm/practice
	materials = list(MATERIAL_STEEL = 50)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/c44
	name = ".44 Bullet"
	id = "c44"
	build_path = /obj/item/ammo_casing/c44
	materials = list(MATERIAL_STEEL = 75)
	chemicals = list(/datum/reagent/aluminum = 4)

/datum/design/item/ammofab/c44/rubber
	name = "Rubber .44 Bullet"
	id = "c44r"
	build_path = /obj/item/ammo_casing/c44/rubber
	materials = list(MATERIAL_PLASTIC = 75)
	chemicals = list(/datum/reagent/aluminum = 4)

/datum/design/item/ammofab/c45
	name = ".45 Bullet"
	id = "c45"
	build_path = /obj/item/ammo_casing/c45
	materials = list(MATERIAL_STEEL = 75)
	chemicals = list(/datum/reagent/aluminum = 3)

/datum/design/item/ammofab/c45/rubber
	name = "Rubber.45 Bullet"
	id = "c45r"
	build_path = /obj/item/ammo_casing/c45/rubber
	materials = list(MATERIAL_PLASTIC = 75)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/c45/practice
	name = "Practice .45 Bullet"
	id = "c45p"
	build_path = /obj/item/ammo_casing/c45/practice
	materials = list(MATERIAL_STEEL = 75)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/c45/flash
	name = "Flash .45 Bullet"
	id = "c45f"
	build_path = /obj/item/ammo_casing/c45/flash
	materials = list(MATERIAL_STEEL = 60)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/a10mm
	name = "10mm Bullet"
	id = "a10mm"
	build_path = /obj/item/ammo_casing/a10mm
	materials = list(MATERIAL_STEEL = 75)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/shotgun
	name = "Shotgun Slug"
	id = "slug"
	build_path = /obj/item/ammo_casing/shotgun
	materials = list(MATERIAL_STEEL = 360)
	chemicals = list(/datum/reagent/aluminum = 3)

/datum/design/item/ammofab/shotgun/pellet
	name = "Shotgun Shell"
	id = "shell"
	build_path = /obj/item/ammo_casing/shotgun/pellet
	materials = list(MATERIAL_STEEL = 360)
	chemicals = list(/datum/reagent/aluminum = 3)

/datum/design/item/ammofab/shotgun/rubber
	name = "Rubber Shotgun Shell"
	id = "shellr"
	build_path = /obj/item/ammo_casing/shotgun/rubber
	materials = list(MATERIAL_PLASTIC = 180)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/shotgun/blank
	name = "Blank Shotgun Shell"
	id = "shellb"
	build_path = /obj/item/ammo_casing/shotgun/blank
	materials = list(MATERIAL_STEEL = 90)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/shotgun/practice
	name = "Practice Shotgun Shell"
	id = "shellp"
	build_path = /obj/item/ammo_casing/shotgun/practice
	materials = list(MATERIAL_STEEL = 90)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/shotgun/beanbag
	name = "Beanbag Shotgun Shell"
	id = "shellbb"
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	materials = list(MATERIAL_STEEL = 180)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/shotgun/stunshell
	name = "Stun Shell"
	id = "stunshell"
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	materials = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 720)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/a556
	name = "5.56mm Bullet"
	id = "a556"
	build_path = /obj/item/ammo_casing/a556
	materials = list(MATERIAL_STEEL = 90)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/a762
	name = "7.76mm Bullet"
	id = "a762"
	build_path = /obj/item/ammo_casing/a762
	materials = list(MATERIAL_STEEL = 90)
	chemicals = list(/datum/reagent/aluminum = 2)

/datum/design/item/ammofab/a762/practice
	name = "Practice 7.76mm Bullet"
	id = "a762p"
	build_path = /obj/item/ammo_casing/a762/practice
	materials = list(MATERIAL_STEEL = 90)
	chemicals = list(/datum/reagent/aluminum = 1)

/datum/design/item/ammofab/cap
	name = "Popgun Cap"
	id = "cap"
	build_path = /obj/item/ammo_casing/cap
	materials = list(MATERIAL_PLASTIC = 50)

//Magazines

/datum/design/item/ammofab/magazines/
	category = "Magazines"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 1)
	materials = list(MATERIAL_STEEL = 1000)
	time = 10

/datum/design/item/ammofab/magazines/a357
	name = ".357 Speedloader"
	id = "a357m"
	build_path = /obj/item/ammo_magazine/a357/empty

/datum/design/item/ammofab/magazines/c38
	name = ".38 Speedloader"
	id = "c38m"
	build_path = /obj/item/ammo_magazine/c38/empty

/datum/design/item/ammofab/magazines/c44
	name = ".44 Speedloader"
	id = "c44m"
	build_path = /obj/item/ammo_magazine/c44/empty

/datum/design/item/ammofab/magazines/c50
	name = ".50 Speedloader"
	id = "c50m"
	build_path = /obj/item/ammo_magazine/c50/empty

/datum/design/item/ammofab/magazines/c45
	name = ".45 Magazine"
	id = "c45m"
	build_path = /obj/item/ammo_magazine/c45m/empty

/datum/design/item/ammofab/magazines/c45uzi
	name = ".45 SMG Magazine"
	id = "c45ms"
	build_path = /obj/item/ammo_magazine/c45uzi/empty

/datum/design/item/ammofab/magazines/mc9mm
	name = "9mm Magazine"
	id = "mc9mmm"
	build_path = /obj/item/ammo_magazine/mc9mm/empty

/datum/design/item/ammofab/magazines/mc9mmt
	name = "9mm Topmount Magazine"
	id = "mc9mmtm"
	build_path = /obj/item/ammo_magazine/mc9mmt/empty

/datum/design/item/ammofab/magazines/a10mm
	name = "10mm Magazine"
	id = "a10mmm"
	build_path = /obj/item/ammo_magazine/a10mm/empty

/datum/design/item/ammofab/magazines/a50
	name = ".50 Magazine"
	id = "a50m"
	build_path = /obj/item/ammo_magazine/a50/empty

/datum/design/item/ammofab/magazines/a762
	name = "7.62 Magazine"
	id = "a762m"
	build_path = /obj/item/ammo_magazine/a762/empty

/datum/design/item/ammofab/magazines/a75
	name = "20mm Magazine"
	id = "a75m"
	build_path = /obj/item/ammo_magazine/a75/empty

/datum/design/item/ammofab/magazines/c556
	name = "5.56 Magazine"
	id = "c556m"
	build_path = /obj/item/ammo_magazine/c556/empty

// Ammo Boxes

/datum/design/item/ammofab/ammobox
	category = "Ammo Boxes"

/datum/design/item/ammofab/ammobox/ammobox
	time = 20
	name = "Ammo Box"
	id = "ammobox"
	build_path = /obj/item/weapon/storage/ammobox
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/ammofab/ammobox/ammobox/big
	time = 40
	name = "Big Ammo Box"
	id = "bigammobox"
	build_path = /obj/item/weapon/storage/ammobox/big
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/ammofab/ammobox/ammotbox
	time = 10
	name = "Ammo Transport Box"
	id = "ammotbox"
	build_path = /obj/item/weapon/storage/ammotbox
	materials = list(MATERIAL_STEEL = 5000)
