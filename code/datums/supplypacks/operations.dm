/decl/hierarchy/supply_pack/operations
	name = "Operations"

/decl/hierarchy/supply_pack/operations/engineering
	name = "Engineering Equipment"
	contains = list(/obj/item/clothing/head/hardhat,
					/obj/item/clothing/under/rank/engineer,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/taperoll/engineering,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/device/radio/headset/headset_eng)
	cost = 12
	containertype = /obj/structure/closet/secure_closet/engineering_personal
	containername = "Engineering Equipment"
	access = 3
/decl/hierarchy/supply_pack/operations/atmostech
	name = "Atmospheric Technician Equipment"
	contains = list(/obj/item/clothing/under/rank/atmospheric_technician,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/weapon/storage/belt/utility/atmostech,
					/obj/item/taperoll/atmos,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/device/radio/headset/headset_eng)
	cost = 15
	containertype = /obj/structure/closet/secure_closet/atmos_personal
	containername = "Atmospheric Technician Equipment"
	access = 3
/decl/hierarchy/supply_pack/operations/ce
	name = "Chief Engineer's Equipment"
	contains = list(/obj/item/clothing/under/rank/chief_engineer,
					/obj/item/clothing/head/hardhat/white,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/gloves/insulated,
					/obj/item/clothing/glasses/meson,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/device/multitool,
					/obj/item/taperoll/engineering,
					/obj/item/weapon/crowbar/brace_jack,
					/obj/item/weapon/stamp/ce,
					/obj/item/weapon/cartridge/ce,
					/obj/item/clothing/cloak/ce,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/device/radio/headset/heads/ce)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/engineering_chief
	containername = "Chief Engineer's Locker"
	access = 3
/decl/hierarchy/supply_pack/operations/cargo
	name = "Cargo Technician Equipment"
	contains = list(/obj/item/clothing/under/rank/cargotech,
					/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
					/obj/item/clothing/head/soft,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/storage/backpack/dufflebag,
					/obj/item/device/radio/headset/headset_cargo)
	cost = 3
	containertype = /obj/structure/closet/secure_closet/cargotech
	containername = "Cargo Rookie Equipment"
	access = 8	//Closest thing to a cargo permission
/decl/hierarchy/supply_pack/operations/miner
	name = "Miner Equipment - Voidsuit Included"
	contains = list(/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/shoes/workboots,
					/obj/item/clothing/glasses/meson,
					/obj/item/weapon/storage/backpack/industrial,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/mining_scanner,
					/obj/item/clothing/gloves/thick,
					/obj/item/weapon/storage/ore,
					/obj/item/weapon/shovel,
					/obj/item/weapon/pickaxe,
					/obj/item/clothing/suit/space/void/mining/prepared,
					/obj/item/device/radio/headset/headset_cargo)
	cost = 100
	containertype = /obj/structure/closet/secure_closet/miner
	containername = "Miner Equipment"
	access = 8
/decl/hierarchy/supply_pack/operations/security
	name = "Security I Equipment"
	contains = list(/obj/item/clothing/under/rank/security,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/cell/crap,
					/obj/item/weapon/handcuffs/cable,
					/obj/item/taperoll/police,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/weapon/storage/backpack/messenger/sec,
					/obj/item/device/radio/headset/headset_sec)
	cost = 15
	containertype = /obj/structure/closet/secure_closet/security
	containername = "Security Cadet Equipment"
/decl/hierarchy/supply_pack/operations/securityofficer
	name = "Security II Equipment"
	contains = list(/obj/item/clothing/under/rank/security,
					/obj/item/clothing/suit/armor/vest/nt,
					/obj/item/clothing/head/helmet/nt,
					/obj/item/clothing/glasses/hud/security,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/weapon/storage/belt/security,
					/obj/item/clothing/suit/storage/hooded/wintercoat/security,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/handcuffs,
					/obj/item/device/flash,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/taperoll/police,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/weapon/storage/backpack/messenger/sec,
					/obj/item/device/radio/headset/headset_sec)
	cost = 40
	containertype = /obj/structure/closet/secure_closet/security
	containername = "Security Officer Equipment"
	access = 5
/decl/hierarchy/supply_pack/operations/hos
	name = "Security III Equipment"
	contains = list(/obj/item/clothing/under/rank/head_of_security/corp,
					/obj/item/clothing/under/hosformalfem,
					/obj/item/clothing/under/hosformalmale,
					/obj/item/clothing/suit/armor/hos,
					/obj/item/clothing/suit/storage/vest/nt/hos,
					/obj/item/clothing/head/HoS,
					/obj/item/clothing/head/helmet/nt,
					/obj/item/clothing/glasses/sunglasses/sechud,
					/obj/item/clothing/head/beret/sec/corporate/hos,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/weapon/storage/belt/security,
					/obj/item/clothing/suit/storage/hooded/wintercoat/security,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/cell,
					/obj/item/weapon/handcuffs,
					/obj/item/device/flash,
					/obj/item/weapon/reagent_containers/spray/pepper,
					/obj/item/taperoll/police,
					/obj/item/weapon/stamp/hos,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/clothing/cloak/hos,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/device/radio/headset/heads/hos)
	cost = 100
	containertype = /obj/structure/closet/secure_closet/hos
	containername = "Security Corporal Equipment"
	access = 5
/decl/hierarchy/supply_pack/operations/detective
	name = "Criminal Investigator Equipment"
	contains = list(/obj/item/clothing/under/det,
					/obj/item/clothing/suit/armor/det_suit,
					/obj/item/clothing/suit/storage/det_trench,
					/obj/item/clothing/head/det,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/accessory/black,
					/obj/item/clothing/accessory/holster/armpit,
					/obj/item/clothing/glasses/hud/security,
					/obj/item/weapon/gun/projectile/revolver/detective,
					/obj/item/weapon/handcuffs,
					/obj/item/taperoll/police,
					/obj/item/weapon/book/manual/nt_regs,
					/obj/item/weapon/storage/backpack/security,
					/obj/item/device/radio/headset/headset_sec)
	cost = 20
	containertype = /obj/structure/closet/secure_closet/detective
	containername = "Criminal Investigator Equipment"
	access = 5
/decl/hierarchy/supply_pack/operations/medical
	name = "Medical Intern Equipment"
	contains = list(/obj/item/clothing/under/rank/medical,
					/obj/item/weapon/storage/backpack/medic,
					/obj/item/device/radio/headset/headset_med)
	cost = 5
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "Medical Intern Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/nurse
	name = "Nurse Equipment"
	contains = list(/obj/item/clothing/under/rank/nurse,
					/obj/item/clothing/under/rank/nursesuit,
					/obj/item/clothing/head/nursehat,
					/obj/item/weapon/storage/backpack/medic,
					/obj/item/device/radio/headset/headset_med)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "Nurse Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/doctor
	name = "Doctor Equipment"
	contains = list(/obj/item/clothing/under/rank/medical,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/gloves/latex,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/backpack/satchel_med,
					/obj/item/weapon/storage/backpack/messenger/med,
					/obj/item/device/radio/headset/headset_med)
	cost = 10
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "Doctor Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/paramedic
	name = "Paramedic Equipment"
	contains = list(/obj/item/clothing/under/rank/medical/paramedic,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/suit/storage/toggle/fr_jacket,
					/obj/item/weapon/storage/belt/medical/emt,
					/obj/item/clothing/accessory/armband/medgreen,
					/obj/item/clothing/accessory/storage/white_vest,
					/obj/item/clothing/gloves/latex,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/device/flashlight/pen,
					/obj/item/weapon/storage/backpack/dufflebag/med,
					/obj/item/device/radio/headset/headset_med)
	cost = 10
	containertype = /obj/structure/closet/secure_closet/paramedic
	containername = "Paramedic Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/psychiatrist
	name = "Psychiatrist Equipment"
	contains = list(/obj/item/clothing/under/rank/psych,
					/obj/item/clothing/under/rank/psych/turtleneck,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/folder/white,
					/obj/item/weapon/pen,
					/obj/item/weapon/storage/backpack/messenger/med,
					/obj/item/device/radio/headset/headset_med)
	cost = 6
	containertype = /obj/structure/closet/secure_closet/psychiatry
	containername = "Psychiatrist Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/virologist
	name = "Virologist Equipment"
	contains = list(/obj/item/clothing/under/rank/virologist,
					/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/gloves/latex,
					/obj/item/clothing/mask/surgical,
					/obj/item/weapon/storage/backpack/satchel_vir,
					/obj/item/device/radio/headset/headset_med)
	cost = 7
	containertype = /obj/structure/closet/secure_closet/virology
	containername = "Virologist Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/cmo
	name = "Chief Medical Officer's Equipment"
	contains = list(/obj/item/clothing/under/rank/chief_medical_officer,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/suit/storage/toggle/labcoat/coat_cmo,
					/obj/item/clothing/shoes/white,
					/obj/item/weapon/storage/belt/medical,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
					/obj/item/clothing/gloves/latex/nitrile,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/clothing/mask/surgical,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/device/flashlight/pen,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/taperoll/medical,
					/obj/item/weapon/stamp/cmo,
					/obj/item/clothing/cloak/cmo,
					/obj/item/weapon/storage/backpack/satchel_med,
					/obj/item/weapon/storage/backpack/messenger/med,
					/obj/item/weapon/cartridge/cmo,
					/obj/item/device/radio/headset/heads/cmo)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/CMO
	containername = "Chief Medical Officer's Locker"
	access = 4
/decl/hierarchy/supply_pack/operations/chemist
	name = "Chemist Equipment"
	contains = list(/obj/item/clothing/under/rank/medical,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/clothing/glasses/science,
					/obj/item/weapon/storage/backpack/satchel_chem,
					/obj/item/device/radio/headset/headset_med)
	cost = 7
	containertype = /obj/structure/closet/secure_closet/medical3
	containername = "Chemist Equipment"
	access = 4
/decl/hierarchy/supply_pack/operations/scienceintern
	name = "Science Intern Equipment"
	contains = list(/obj/item/clothing/under/rank/scientist,
					/obj/item/weapon/storage/backpack/messenger/tox,
					/obj/item/device/radio/headset/headset_sci)
	cost = 5
	containertype = /obj/structure/closet/secure_closet/scientist
	containername = "Science Intern Equipment"
	access = 9
/decl/hierarchy/supply_pack/operations/scientist
	name = "Scientist Equipment"
	contains = list(/obj/item/clothing/under/rank/scientist,
					/obj/item/clothing/suit/storage/toggle/labcoat/science,
					/obj/item/clothing/suit/storage/hooded/wintercoat/science,
					/obj/item/clothing/glasses/science,
					/obj/item/weapon/storage/backpack/messenger/tox,
					/obj/item/device/radio/headset/headset_sci)
	cost = 7
	containertype = /obj/structure/closet/secure_closet/scientist
	containername = "Scientist Equipment"
	access = 9
/decl/hierarchy/supply_pack/operations/roboticist
	name = "Roboticist Equipment"
	contains = list(/obj/item/clothing/under/rank/roboticist,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/weapon/storage/belt/utility/full,
					/obj/item/device/robotanalyzer,
					/obj/item/weapon/storage/backpack/messenger/tox,
					/obj/item/device/radio/headset/headset_sci)
	cost = 8
	containertype = /obj/structure/closet/secure_closet/scientist
	containername = "Roboticist Equipment"
	access = 9
/decl/hierarchy/supply_pack/operations/rd
	name = "Research Director's Equipment"
	contains = list(/obj/item/clothing/under/rank/research_director,
					/obj/item/clothing/under/rank/research_director/rdalt,
					/obj/item/clothing/under/rank/research_director/dress_rd,
					/obj/item/clothing/under/rank/scientist/executive,
					/obj/item/clothing/suit/storage/hooded/wintercoat/science,
					/obj/item/clothing/suit/storage/toggle/labcoat/rd,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/shoes/leather,
					/obj/item/weapon/stamp/rd,
					/obj/item/taperoll/research,
					/obj/item/weapon/cartridge/rd,
					/obj/item/clothing/cloak/rd,
					/obj/item/weapon/storage/backpack/messenger/tox,
					/obj/item/device/radio/headset/heads/rd)
	cost = 50
	containertype = /obj/structure/closet/secure_closet/RD
	containername = "Research Director's Locker"
	access = 9
/decl/hierarchy/supply_pack/operations/janitor
	name = "Janitor Equipment"
	contains = list(/obj/item/clothing/under/rank/janitor,
					/obj/item/clothing/head/soft/purple,
					/obj/item/clothing/shoes/workboots,
					/obj/item/weapon/mop,
					/obj/structure/mopbucket,
					/obj/item/weapon/soap,
					/obj/item/device/lightreplacer,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/device/radio/headset/headset_service)
	cost = 10
	containertype = /obj/structure/closet/jcloset
	containername = "Janitor Equipment"
/decl/hierarchy/supply_pack/operations/chef
	name = "Chef Equipment"
	contains = list(/obj/item/clothing/under/rank/chef,
					/obj/item/clothing/head/chefhat,
					/obj/item/clothing/suit/chef/classic,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme,
					/obj/item/device/radio/headset/headset_service)
	cost = 6
	containertype = /obj/structure/closet/chefcloset
	containername = "Chef Equipment"
/decl/hierarchy/supply_pack/operations/bartender
	name = "Bartender Equipment"
	contains = list(/obj/item/clothing/head/that,
					/obj/item/device/radio/headset/headset_service,
					/obj/item/clothing/head/hairflower,
					/obj/item/clothing/head/hairflower/pink,
					/obj/item/clothing/head/hairflower/yellow,
					/obj/item/clothing/head/hairflower/blue,
					/obj/item/clothing/under/sl_suit,
					/obj/item/clothing/under/rank/bartender,
					/obj/item/clothing/under/dress/dress_saloon,
					/obj/item/clothing/accessory/wcoat,
					/obj/item/clothing/shoes/black)
	cost = 6
	containertype = /obj/structure/closet/gmcloset
	containername = "Bartender Equipment"
/decl/hierarchy/supply_pack/operations/botanist
	name = "Botany Equipment"
	contains = list(/obj/item/clothing/under/rank/hydroponics,
					/obj/item/clothing/suit/storage/hooded/wintercoat/hydro,
					/obj/item/clothing/head/greenbandana,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/device/analyzer/plant_analyzer,
					/obj/item/weapon/storage/plants,
					/obj/item/weapon/storage/backpack/hydroponics,
					/obj/item/device/radio/headset/headset_service)
	cost = 7
	containertype = /obj/structure/closet/secure_closet/hydroponics
	containername = "Botanist Equipment"
/decl/hierarchy/supply_pack/operations/clown
	name = "Clown Equipment"
	contains = list(/obj/item/clothing/under/rank/clown,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/weapon/bikehorn,
					/obj/item/weapon/pen/crayon/rainbow,
					/obj/item/weapon/bedsheet/clown,
					/obj/item/weapon/stamp/clown,
					/obj/item/weapon/cartridge/clown,
					/obj/item/weapon/storage/backpack/clown)
	cost = 15
	containertype = /obj/structure/closet/secure_closet
	containername = "Clown Equipment"
/decl/hierarchy/supply_pack/operations/mime
	name = "Mime Equipment"
	contains = list(/obj/item/clothing/under/mime,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/shoes/mime,
					/obj/item/clothing/head/beret,
					/obj/item/weapon/pen/crayon/mime,
					/obj/item/weapon/bedsheet/mime,
					/obj/item/weapon/cartridge/mime,
					/obj/item/weapon/storage/backpack/mime)
	cost = 15
	containertype = /obj/structure/closet/secure_closet
	containername = "Mime Equipment"
/decl/hierarchy/supply_pack/operations/lawyer
	name = "Bureaucrat Equipment"
	contains = list(/obj/item/clothing/under/lawyer/female,
					/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/under/lawyer/red,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/suit/storage/toggle/suit/blue,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/suit/storage/toggle/suit/purple,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/black)
	cost = 6
	containertype = /obj/structure/closet/lawcloset
	containername = "Bureaucrat Equipment"

/decl/hierarchy/supply_pack/operations/journalist
	name = "Journalist Equipment"
	contains = list(/obj/item/clothing/accessory/badge/press,
					/obj/item/device/radio/headset/entertainment,
					/obj/item/clothing/accessory/armor/tag/press,
					/obj/item/clothing/suit/armor/vest/press,
					/obj/item/device/tvcamera,
					/obj/item/device/taperecorder,
					/obj/item/device/camera_film = 2,
					/obj/item/device/camera)
	cost = 20
	containertype = /obj/structure/closet
	containername = "Journalist Equipment"

/decl/hierarchy/supply_pack/operations/beret
	name = "Beret Locker"
	contains = list(/obj/item/clothing/head/beret/sec = 4,
					/obj/item/clothing/head/beret/sec/corporate/officer,
					/obj/item/clothing/head/beret/sec/corporate/hos,
					/obj/item/clothing/head/beret/sec/corporate/warden,
					/obj/item/clothing/head/beret/engineering = 4,
					/obj/item/clothing/head/beret/plaincolor = 2,
					/obj/item/clothing/head/beret/purple,
					/obj/item/clothing/head/beret/guard)
	cost = 20
	containertype = /obj/structure/closet
	containername = "\improper Beret Locker"
/decl/hierarchy/supply_pack/operations/personal
	name = "Personal Locker"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/empty
	containername = "Personal Locker"
/decl/hierarchy/supply_pack/operations/patient
	name = "Patient's Closet"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/patient
	containername = "Patient's Closet"
/decl/hierarchy/supply_pack/operations/personal_cabinet
	name = "Personal Cabinet"
	contains = list()
	cost = 2
	containertype = /obj/structure/closet/secure_closet/personal/cabinet/empty
	containername = "Personal Cabinet"