/decl/hierarchy/supply_pack/assignments
	name = "Assignments"

//engineering
/decl/hierarchy/supply_pack/assignments/engineer
	name = "Engineering - Engineer equipment"
	contains = list(/obj/item/clothing/under/rank/engineer,
					/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/beret/engineering,
					/obj/item/clothing/glasses/meson,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/shoes/workboots,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/taperoll/engineering,
					/obj/item/device/radio/headset/headset_eng)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/engineering_personal
	containername = "engineer's locker"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/assignments/atmostech
	name = "Engineering - Atmospheric technician equipment"
	contains = list(/obj/item/clothing/under/rank/atmospheric_technician,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/weapon/storage/belt/utility/atmostech,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/taperoll/atmos,
					/obj/item/device/radio/headset/headset_eng)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/atmos_personal
	containername = "atmospheric technician's locker"
	access = core_access_engineering_programs

/decl/hierarchy/supply_pack/assignments/ce
	name = "Engineering - Engineering chief's equipment"
	contains = list(/obj/item/clothing/under/rank/chief_engineer,
					/obj/item/clothing/accessory/storage/brown_vest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/hardhat/white,
					/obj/item/clothing/cloak/ce,
					/obj/item/clothing/gloves/insulated,
					/obj/item/clothing/glasses/meson,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/workboots,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/weapon/storage/backpack/satchel_eng,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/storage/backpack/dufflebag/eng,
					/obj/item/weapon/storage/toolbox/mechanical,
					/obj/item/weapon/crowbar/brace_jack,
					/obj/item/weapon/stamp/ce,
					/obj/item/weapon/cartridge/ce,
					/obj/item/taperoll/engineering,
					/obj/item/device/flash,
					/obj/item/device/pda/heads/ce,
					/obj/item/device/radio/headset/heads/ce)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/engineering_chief
	containername = "chief engineer's locker"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/engberet
	name = "Engineering - Beret"
	contains = list(/obj/item/clothing/head/beret/engineering = 5)
	cost = 8
	containername = "engineering berets crate"

//cargo
/decl/hierarchy/supply_pack/assignments/cargo
	name = "Cargo - Cargo technician equipment"
	contains = list(/obj/item/clothing/under/rank/cargotech,
					/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
					/obj/item/clothing/head/soft,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/storage/backpack/dufflebag,
					/obj/item/device/radio/headset/headset_cargo)
	cost = 3
	containertype = /obj/structure/closet/secure_closet/cargotech
	containername = "cargo tech equipment locker"
	access = core_access_order_approval	//Closest thing to a cargo permission

/decl/hierarchy/supply_pack/assignments/miner
	name = "Cargo - Miner equipment"
	contains = list(/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/glasses/meson,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/mining_scanner,
					/obj/item/weapon/storage/ore,
					/obj/item/weapon/shovel,
					/obj/item/weapon/pickaxe,
					/obj/item/device/analyzer,
					/obj/item/device/flashlight/lantern,
					/obj/item/device/radio/headset/headset_cargo)
	cost = 10
	containertype = /obj/structure/closet/secure_closet/miner
	containername = "miner equipment locker"
	access = core_access_order_approval

/decl/hierarchy/supply_pack/assignments/qm
	name = "Cargo - Quartermaster equipment"
	contains = list(/obj/item/clothing/under/rank/cargo,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/cloak/qm,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/head/soft,
					/obj/item/weapon/tank/emergency/oxygen,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/stamp/qm,
					/obj/item/device/pda/quartermaster,
					/obj/item/device/radio/headset/headset_cargo)
	cost = 35
	containertype = /obj/structure/closet/secure_closet/quartermaster
	containername = "quartermaster equipment locker"
	access = core_access_order_approval

/decl/hierarchy/supply_pack/assignments/minervoidsuit
	name = "Cargo - Mining voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/mining,
					/obj/item/clothing/head/helmet/space/void/mining,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/large
	containername = "mining voidsuit crate"
	access = core_access_order_approval

/decl/hierarchy/supply_pack/assignments/minervoidsuit_heavyduty
	name = "Cargo - Heavy-duty mining voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/mining/alt,
					/obj/item/clothing/head/helmet/space/void/mining/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/large
	containername = "heavy-duty mining voidsuit crate"
	access = core_access_order_approval

//security
/decl/hierarchy/supply_pack/assignments/security
	name = "Security - Security I equipment"
	contains = list(/obj/item/clothing/under/rank/dispatch,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/head/soft/sec,
					/obj/item/weapon/storage/backpack/messenger/sec,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/cell/crap,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/taperoll/police,
					/obj/item/device/radio/headset/headset_sec)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/security
	containername = "security cadet equipment locker"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/assignments/securityofficer
	name = "Security - Security II equipment"
	contains = list(/obj/item/clothing/under/rank/security,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/storage/hooded/wintercoat/security,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/weapon/storage/belt/security,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/cell,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/taperoll/police,
					/obj/item/device/flash,
					/obj/item/device/hailer,
					/obj/item/device/radio/headset/headset_sec)
	cost = 25
	containertype = /obj/structure/closet/secure_closet/security
	containername = "security officer's locker"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/assignments/hos
	name = "Security - Security III equipment"
	contains = list(/obj/item/clothing/under/rank/head_of_security/corp,
					/obj/item/clothing/under/hosformalfem,
					/obj/item/clothing/under/hosformalmale,
					/obj/item/clothing/suit/armor/hos,
					/obj/item/clothing/suit/storage/vest/nt/hos,
					/obj/item/clothing/suit/storage/hooded/wintercoat/security,
					/obj/item/clothing/cloak/hos,
					/obj/item/clothing/head/HoS,
					/obj/item/clothing/head/HoS/dermal,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/accessory/holster/waist,
					/obj/item/weapon/storage/belt/security,
					/obj/item/weapon/storage/backpack/satchel_sec,
					/obj/item/weapon/melee/telebaton,
					/obj/item/weapon/cell,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/weapon/stamp/hos,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/taperoll/police,
					/obj/item/device/flash,
					/obj/item/device/pda/heads/hos,
					/obj/item/device/radio/headset/heads/hos)
	cost = 100
	containertype = /obj/structure/closet/secure_closet/hos
	containername = "head of security's locker"
	access = core_access_leader

/decl/hierarchy/supply_pack/assignments/warden
	name = "Security - Warden equipment"
	contains = list(/obj/item/clothing/under/rank/warden,
					/obj/item/clothing/suit/armor/vest/warden,
					/obj/item/clothing/suit/storage/vest/nt/warden,
					/obj/item/clothing/head/warden,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/storage/backpack/dufflebag/sec,
					/obj/item/weapon/storage/belt/security,
					/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas,
					/obj/item/weapon/storage/box/holobadge,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/stamp/ward,
					/obj/item/taperoll/police,
					/obj/item/device/holowarrant,
					/obj/item/device/radio/headset/headset_sec)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/warden
	containername = "warden's locker"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/detective
	name = "Security - Criminal investigator equipment"
	contains = list(/obj/item/clothing/under/det,
					/obj/item/clothing/suit/armor/det_suit,
					/obj/item/clothing/suit/storage/det_trench,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/head/det,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/accessory/holster/armpit,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/weapon/handcuffs,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/weapon/reagent_containers/food/drinks/flask/detflask,
					/obj/item/taperoll/police,
					/obj/item/device/radio/headset/headset_sec)
	cost = 25
	containertype = /obj/structure/closet/secure_closet/detective
	containername = "criminal investigator equipment cabinet"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/assignments/secberet
	name = "Security - Berets"
	contains = list(/obj/item/clothing/head/beret/sec/corporate/hos,
					/obj/item/clothing/head/beret/sec/corporate/warden,
					/obj/item/clothing/head/beret/guard,
					/obj/item/clothing/head/beret/sec = 3,
					/obj/item/clothing/head/beret/sec/corporate/officer = 2)
	cost = 15
	containername = "security berets crate"

//medical
/decl/hierarchy/supply_pack/assignments/nurse
	name = "Medical - Nurse equipment"
	contains = list(/obj/item/clothing/under/rank/nurse,
					/obj/item/clothing/under/rank/nursesuit,
					/obj/item/clothing/under/rank/orderly,
					/obj/item/clothing/head/nursehat,
					/obj/item/clothing/shoes/white,
					/obj/item/weapon/storage/backpack/messenger/med,
					/obj/item/device/radio/headset/headset_med)
	cost = 3
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "nurse equipment locker"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/assignments/doctor
	name = "Medical - Doctor equipment"
	contains = list(/obj/item/clothing/under/rank/medical,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/backpack/medic,
					/obj/item/device/flashlight/pen,
					/obj/item/device/radio/headset/headset_med)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "doctor equipment locker"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/assignments/paramedic
	name = "Medical - Paramedic equipment"
	contains = list(/obj/item/clothing/under/rank/medical/paramedic,
					/obj/item/clothing/suit/storage/toggle/fr_jacket,
					/obj/item/clothing/accessory/armband/medgreen,
					/obj/item/clothing/accessory/storage/white_vest,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/gloves/latex,
					/obj/item/weapon/storage/belt/medical/emt,
					/obj/item/weapon/storage/backpack/dufflebag/med,
					/obj/item/weapon/storage/backpack/medic,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/tank/emergency/oxygen/engi,
					/obj/item/weapon/extinguisher/mini,
					/obj/item/weapon/crowbar,
					/obj/item/device/radio/off,
					/obj/item/device/flashlight,
					/obj/item/device/flashlight/pen,
					/obj/item/taperoll/medical,
					/obj/item/device/radio/headset/headset_med)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/paramedic
	containername = "paramedic equipment locker"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/assignments/psychiatrist
	name = "Medical - Psychiatrist equipment"
	contains = list(/obj/item/clothing/under/rank/psych,
					/obj/item/clothing/under/rank/psych/turtleneck,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/shoes/laceup,
					/obj/item/weapon/storage/backpack/messenger/med,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/folder/white,
					/obj/item/weapon/pen,
					/obj/item/device/radio/headset/headset_med)
	cost = 10
	containertype = /obj/structure/closet/secure_closet/psychiatry
	containername = "psychiatrist's locker"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/assignments/virologist
	name = "Medical - Virologist equipment"
	contains = list(/obj/item/clothing/under/rank/virologist,
					/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/gloves/latex,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/shoes/white,
					/obj/item/weapon/storage/backpack/satchel_vir,
					/obj/item/weapon/reagent_containers/syringe/antiviral,
					/obj/item/device/radio/headset/headset_med)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/virology
	access = core_access_medical_programs
	containername = "virologist equipment locker"

/decl/hierarchy/supply_pack/assignments/cmo
	name = "Medical - Chief medical officer's equipment"
	contains = list(/obj/item/clothing/under/rank/chief_medical_officer,
					/obj/item/clothing/suit/bio_suit/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/coat_cmo,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/cloak/cmo,
					/obj/item/clothing/head/bio_hood/cmo,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/gloves/latex/nitrile,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/weapon/storage/belt/medical,
					/obj/item/weapon/storage/backpack/satchel_med,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/stamp/cmo,
					/obj/item/taperoll/medical,
					/obj/item/device/flashlight/pen,
					/obj/item/device/flash,
					/obj/item/device/pda/heads/cmo,
					/obj/item/device/radio/headset/heads/cmo)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/CMO
	containername = "chief medical officer's locker"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/chemist
	name = "Medical - Chemist equipment"
	contains = list(/obj/item/clothing/under/rank/chemist,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/glasses/science,
					/obj/item/clothing/shoes/white,
					/obj/item/weapon/storage/box/pillbottles,
					/obj/item/weapon/storage/backpack/satchel_chem,
					/obj/item/device/radio/headset/headset_med)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "chemist equipment locker"
	access = core_access_medical_programs

//science
/decl/hierarchy/supply_pack/assignments/scientist
	name = "Science - Scientist equipment"
	contains = list(/obj/item/clothing/under/rank/scientist,
					/obj/item/clothing/suit/storage/toggle/labcoat/science,
					/obj/item/clothing/suit/storage/hooded/wintercoat/science,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/glasses/science,
					/obj/item/clothing/gloves/latex,
					/obj/item/clothing/shoes/white,
					/obj/item/weapon/storage/backpack/messenger/tox,
					/obj/item/weapon/clipboard,
					/obj/item/device/radio/headset/headset_sci)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/scientist
	containername = "scientist equipment locker"
	access = core_access_science_programs

/decl/hierarchy/supply_pack/assignments/roboticist
	name = "Science - Roboticist equipment"
	contains = list(/obj/item/clothing/under/rank/roboticist,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/weapon/storage/backpack/toxins,
					/obj/item/device/robotanalyzer,
					/obj/item/device/pda/roboticist,
					/obj/item/device/radio/headset/headset_sci)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/scientist
	containername = "roboticist equipment locker"
	access = core_access_science_programs

/decl/hierarchy/supply_pack/assignments/rd
	name = "Science - Research director's equipment"
	contains = list(/obj/item/clothing/under/rank/research_director,
					/obj/item/clothing/under/rank/research_director/rdalt,
					/obj/item/clothing/under/rank/research_director/dress_rd,
					/obj/item/clothing/under/rank/scientist/executive,
					/obj/item/clothing/suit/storage/hooded/wintercoat/science,
					/obj/item/clothing/suit/storage/toggle/labcoat/rd,
					/obj/item/clothing/cloak/rd,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/leather,
					/obj/item/weapon/storage/backpack/satchel_tox,
					/obj/item/weapon/stamp/rd,
					/obj/item/taperoll/research,
					/obj/item/device/pda/heads/rd,
					/obj/item/device/radio/headset/heads/rd)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/RD
	containername = "research director's locker"
	access = core_access_command_programs

//service
/decl/hierarchy/supply_pack/assignments/janitor
	name = "Service - Janitor equipment"
	contains = list(/obj/item/clothing/under/rank/janitor,
					/obj/item/clothing/head/soft/purple,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/device/pda/janitor,
					/obj/item/device/radio/headset/headset_service)
	cost = 3
	containertype = /obj/structure/closet/jcloset
	containername = "janitor equipment closet"

/decl/hierarchy/supply_pack/assignments/chef
	name = "Service - Chef equipment"
	contains = list(/obj/item/clothing/under/rank/chef,
					/obj/item/clothing/under/waiter,
					/obj/item/clothing/suit/chef/classic,
					/obj/item/clothing/head/chefhat,
					/obj/item/device/radio/headset/headset_service)
	cost = 3
	containertype = /obj/structure/closet/chefcloset
	containername = "chef equipment closet"

/decl/hierarchy/supply_pack/assignments/bartender
	name = "Service - Bartender equipment"
	contains = list(/obj/item/clothing/under/sl_suit,
					/obj/item/clothing/under/rank/bartender,
					/obj/item/clothing/under/dress/dress_saloon,
					/obj/item/clothing/head/that,
					/obj/item/clothing/accessory/wcoat,
					/obj/item/device/radio/headset/headset_service)
	cost = 3
	containertype = /obj/structure/closet/gmcloset
	containername = "bartender equipment closet"

/decl/hierarchy/supply_pack/assignments/botanist
	name = "Service - Botany equipment"
	contains = list(/obj/item/clothing/under/rank/hydroponics,
					/obj/item/clothing/suit/apron/overalls,
					/obj/item/clothing/suit/storage/hooded/wintercoat/hydro,
					/obj/item/clothing/head/greenbandana,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/weapon/storage/backpack/hydroponics,
					/obj/item/weapon/storage/plants,
					/obj/item/device/radio/headset/headset_service)
	cost = 3
	containertype = /obj/structure/closet/secure_closet/hydroponics
	containername = "botany equipment locker"
	access = core_access_reassignment //imperfect, but the closest thing to service access

//civilian
/decl/hierarchy/supply_pack/assignments/journalist
	name = "Civilian - Journalist equipment"
	contains = list(/obj/item/clothing/accessory/badge/press,
					/obj/item/clothing/accessory/armor/tag/press,
					/obj/item/clothing/suit/armor/vest/press,
					/obj/item/device/tvcamera,
					/obj/item/device/taperecorder,
					/obj/item/device/camera_film = 2,
					/obj/item/device/camera)
	cost = 15
	containertype = /obj/structure/closet
	containername = "journalist equipment closet"

/decl/hierarchy/supply_pack/assignments/lawyer
	name = "Civilian - Bureaucrat equipment"
	contains = list(/obj/item/clothing/under/lawyer/female,
					/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/under/lawyer/red,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/suit/storage/toggle/suit/blue,
					/obj/item/clothing/suit/storage/toggle/suit/purple,
					/obj/item/clothing/shoes/brown = 2)
	cost = 10
	containertype = /obj/structure/closet/lawcloset
	containername = "bureaucrat equipment closet"

/decl/hierarchy/supply_pack/assignments/clown
	name = "Civilian - Clown equipment"
	contains = list(/obj/item/clothing/under/rank/clown,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/weapon/storage/backpack/clown,
					/obj/item/weapon/bikehorn,
					/obj/item/weapon/pen/crayon/rainbow,
					/obj/item/weapon/bedsheet/clown,
					/obj/item/weapon/stamp/clown,
					/obj/item/device/pda/clown)
	cost = 15
	containertype = /obj/structure/closet
	containername = "clown equipment closet"

/decl/hierarchy/supply_pack/assignments/mime
	name = "Civilian - Mime equipment"
	contains = list(/obj/item/clothing/under/mime,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/shoes/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/soft/mime,
					/obj/item/clothing/accessory/suspenders,
					/obj/item/weapon/storage/backpack/mime,
					/obj/item/weapon/pen/crayon/mime,
					/obj/item/weapon/bedsheet/mime,
					/obj/item/device/pda/mime)
	cost = 15
	containertype = /obj/structure/closet
	containername = "mime equipment closet"

/decl/hierarchy/supply_pack/assignments/iaa
	name = "Civilian - Internal affairs agent equipment"
	contains = list(/obj/item/clothing/under/rank/internalaffairs = 2,
					/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/suit/storage/toggle/suit/black = 2,
					/obj/item/clothing/glasses/sunglasses/big = 2,
					/obj/item/clothing/shoes/brown = 2,
					/obj/item/weapon/storage/briefcase,
					/obj/item/device/pda/lawyer = 2,
					/obj/item/device/radio/headset/ia = 2)
	cost = 20
	containertype = /obj/structure/closet/secure_closet/lawyer
	containername = "internal affairs agent equipment locker"
	access = core_access_security_programs

/decl/hierarchy/supply_pack/assignments/librarian
	name = "Civilian - Librarian equipment"
	contains = list(/obj/item/clothing/under/suit_jacket/red,
					/obj/item/clothing/under/librarian,
					/obj/item/clothing/head/fez,
					/obj/item/device/pda/librarian)
	cost = 3
	containertype = /obj/structure/closet
	containername = "librarian equipment closet"

/decl/hierarchy/supply_pack/assignments/chaplain
	name = "Civilian - Chaplain equipment"
	contains = list(/obj/item/clothing/under/rank/chaplain,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/suit/chaplain_hoodie,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/head/chaplain_hood,
					/obj/item/clothing/head/nun_hood,
					/obj/item/clothing/head/kippa,
					/obj/item/clothing/head/turban,
					/obj/item/clothing/head/taqiyah,
					/obj/item/weapon/storage/backpack/cultpack,
					/obj/item/device/pda/chaplain)
	cost = 6
	containertype = /obj/structure/closet/wardrobe/chaplain_black
	containername = "chaplain equipment closet"

/decl/hierarchy/supply_pack/assignments/beret
	name = "Civilian - Berets"
	contains = list(/obj/item/clothing/head/beret,
					/obj/item/clothing/head/beret/plaincolor = 2,
					/obj/item/clothing/head/beret/purple = 2)
	cost = 5
	containername = "berets crate"

//personal
/decl/hierarchy/supply_pack/assignments/personal
	name = "Personal - Personal locker"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/empty
	containername = "personal locker"
	access = core_access_command_programs //personal locker code should still allow any player to claim the locker

/decl/hierarchy/supply_pack/assignments/patient
	name = "Personal - Patient's closet"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/patient
	containername = "patient's closet"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/personal_cabinet
	name = "Personal - Personal cabinet"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/cabinet/empty
	containername = "personal cabinet"
	access = core_access_command_programs

//command
/decl/hierarchy/supply_pack/assignments/hop
	name = "Command - Personnel officer equipment"
	contains = list(/obj/item/clothing/under/rank/head_of_personnel,
					/obj/item/clothing/head/caphat/hop,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/weapon/storage/backpack/satchel/pocketbook,
					/obj/item/weapon/stamp/hop,
					/obj/item/device/flash,
					/obj/item/device/pda/heads/hop,
					/obj/item/device/radio/headset/heads/hop)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/hop
	containername = "head of personnel's locker"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/hopattire
	name = "Command - Assorted personnel officer attire"
	contains = list(/obj/item/clothing/under/rank/head_of_personnel,
					/obj/item/clothing/under/rank/head_of_personnel_whimsy,
					/obj/item/clothing/under/dress/dress_hop,
					/obj/item/clothing/under/dress/dress_hr,
					/obj/item/clothing/under/lawyer/female,
					/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/under/lawyer/red,
					/obj/item/clothing/under/lawyer/oldman,
					/obj/item/clothing/head/caphat/hop,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/shoes/white)
	cost = 20
	containertype = /obj/structure/closet/secure_closet/hop2
	containername = "personnel officer attire locker"
	access = core_access_command_programs

/decl/hierarchy/supply_pack/assignments/secretary
	name = "Command - Bridge secretary equipment"
	contains = list(/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/shoes/brown,
					/obj/item/device/flash,
					/obj/item/device/pda/heads,
					/obj/item/device/radio/headset/headset_com)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/hop
	containername = "bridge secretary equipment locker"
	access = core_access_reassignment