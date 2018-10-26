/decl/hierarchy/supply_pack/security
	name = "Security"

//armor
/decl/hierarchy/supply_pack/security/lightarmor
	name = "Armor - Light (x4)"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/light = 4,
					/obj/item/clothing/head/helmet = 4)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "light armor crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/armor
	name = "Armor - Medium (x4)"
	contains = list(/obj/item/clothing/suit/armor/pcarrier/medium = 4,
					/obj/item/clothing/head/helmet = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "armor crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/tacticalarmor
	name = "Armor - Full set tactical armor"
	contains = list(/obj/item/clothing/under/tactical,
					/obj/item/clothing/suit/armor/pcarrier/tan/tactical,
					/obj/item/clothing/head/helmet/tactical,
					/obj/item/clothing/mask/balaclava/tactical,
					/obj/item/clothing/glasses/tacgoggles,
					/obj/item/weapon/storage/belt/security/tactical,
					/obj/item/clothing/shoes/tactical,
					/obj/item/clothing/gloves/tactical)
	cost = 45
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "tactical armor crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/armguards
	name = "Armor - Black arm guards (x4)"
	contains = list(/obj/item/clothing/accessory/armguards = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "arm guards crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/legguards
	name = "Armor - Black leg guards (x4)"
	contains = list(/obj/item/clothing/accessory/legguards = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "leg guards crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/armguards_random
	name = "Armor - Assorted arm guards (x4)"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/armguards/blue,
					/obj/item/clothing/accessory/armguards/navy,
					/obj/item/clothing/accessory/armguards/green,
					/obj/item/clothing/accessory/armguards/tan)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "arm guards crate"
	access = core_access_security_programs
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/legguards_random
	name = "Armor - Assorted leg guards (x4)"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/legguards/blue,
					/obj/item/clothing/accessory/legguards/navy,
					/obj/item/clothing/accessory/legguards/green,
					/obj/item/clothing/accessory/legguards/tan)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "leg guards crate"
	access = core_access_security_programs
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/security/riotarmor
	name = "Armor - Riot gear"
	contains = list(/obj/item/weapon/shield/riot = 4,
					/obj/item/clothing/head/helmet/riot = 4,
					/obj/item/clothing/suit/armor/riot = 4,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "riot gear crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/ballisticarmor
	name = "Armor - Ballistic (x4)"
	contains = list(/obj/item/clothing/head/helmet/ballistic = 4,
					/obj/item/clothing/suit/armor/bulletproof = 4)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "ballistic armor crate"
	access = core_access_security_programs

//voidsuits
/decl/hierarchy/supply_pack/security/voidsuit
	name = "EVA - Security voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security,
					/obj/item/clothing/head/helmet/space/void/security,
					/obj/item/clothing/shoes/magboots)
	cost = 150
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/voidsuit_heavyduty
	name = "EVA - Heavy-duty security voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 250
	containername = "heavy-duty security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_security_programs

//weapons
/decl/hierarchy/supply_pack/security/weapons_stunbatons
	name = "Weapons - Stun Batons (x5)"
	contains = list(/obj/item/weapon/melee/baton/loaded = 5)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "stun batons crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_flashes
	name = "Weapons - Flashes (x5)"
	contains = list(/obj/item/device/flash = 5)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "flashes crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_pepperspray
	name = "Weapons - Pepper Spray (x5)"
	contains = list(/obj/item/weapon/reagent_containers/spray/pepper = 5)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "pepper spray crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_tasers
	name = "Weapons - Tasers (x5)"
	contains = list(/obj/item/weapon/gun/energy/taser = 5)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "tasers crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_detrevolver
	name = "Weapons - Detective revolvers"
	contains = list(/obj/item/weapon/gun/projectile/revolver/detective = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "detective revolver crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_detcolt
	name = "Weapons - Detective handguns"
	contains = list(/obj/item/weapon/gun/projectile/colt/detective = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "detective handgun crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_shotguns
	name = "Weapons - Riot shotguns (x3)"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/pump = 3)
	cost = 120
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "riot shotguns crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/weapons_civshotgun
	name = "Weapons - Civilian double-barreled shotgun"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/doublebarrel)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "double-barreled shotgun crate"
	access = core_access_security_programs

//ammunition
/decl/hierarchy/supply_pack/security/pistolammopractice
	name = "Ammunition - .45 practice"
	contains = list(/obj/item/ammo_magazine/c45m/practice = 8)
	cost = 8
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper .45 practice ammunition crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/pdwammopractice
	name = "Ammunition - 9mm top mounted practice"
	contains = list(/obj/item/ammo_magazine/mc9mmt/practice = 8)
	cost = 8
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 9mm practice ammunition crate"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/security/bullpupammopractice
	name = "Ammunition - 7.62 practice"
	contains = list(/obj/item/ammo_magazine/a762/practice = 8)
	cost = 8
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "\improper 7.62 practice ammunition crate"
	access = core_access_security_programs

//clothing
/decl/hierarchy/supply_pack/security/prisoneruniforms
	name = "Clothing - Prisoner uniforms"
	contains = list(/obj/item/clothing/under/color/orange = 4,
					/obj/item/clothing/shoes/orange = 4)
	cost = 20
	containername = "prisoner uniforms crate"

/decl/hierarchy/supply_pack/security/securitybiosuit
	name = "Clothing - Security biohazard suit"
	contains = list(/obj/item/clothing/head/bio_hood/security,
					/obj/item/clothing/suit/bio_suit/security,
					/obj/item/clothing/mask/gas/half,
					/obj/item/weapon/tank/emergency/oxygen/engi)
	cost = 15
	containertype = /obj/structure/closet/l3closet/security
	containername = "level-3 biohazard suit closet"

//forensics
/decl/hierarchy/supply_pack/security/forensics
	name = "Forensics - Forensics kit"
	contains = list(/obj/item/weapon/storage/box/evidence = 2,
					/obj/item/weapon/cartridge/detective,
					/obj/item/taperoll/police,
					/obj/item/device/camera,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/blue,
					/obj/item/clothing/gloves/forensic,
					/obj/item/device/taperecorder,
					/obj/item/device/mass_spectrometer,
					/obj/item/device/camera_film = 2,
					/obj/item/weapon/storage/photo_album,
					/obj/item/device/reagent_scanner,
					/obj/item/weapon/storage/briefcase/crimekit)
	cost = 30
	containername = "forensics kit crate"

/decl/hierarchy/supply_pack/security/forensics_gear
	name = "Forensics - Refills"
	contains = list(/obj/item/weapon/forensics/sample_kit,
					/obj/item/weapon/forensics/sample_kit/powder,
					/obj/item/weapon/storage/box/swabs = 3,
					/obj/item/weapon/storage/box/fingerprints = 3,
					/obj/item/weapon/storage/box/evidence = 3,
					/obj/item/weapon/reagent_containers/spray/luminol)
	cost = 20
	containername = "forensics gear crate"

//devices
/decl/hierarchy/supply_pack/security/holowarrants
	name = "Devices - Holowarrant projectors"
	contains = list(/obj/item/device/holowarrant = 4)
	cost = 32
	containername = "holowarrants crate"

/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Devices - Deployable barriers (x4)"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "security barrier crate"

/decl/hierarchy/supply_pack/security/portableflash
	name = "Devices - Portable flashers (x2)"
	contains = list(/obj/machinery/flasher/portable = 2)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "portable flasher crate"