/decl/hierarchy/supply_pack/medical
	name = "Medical"
	containertype = /obj/structure/closet/crate/medical

//triage
/decl/hierarchy/supply_pack/medical/atk
	name = "Triage - Advanced trauma supplies"
	contains = list(/obj/item/stack/medical/advanced/bruise_pack = 6)
	cost = 15
	containername = "advanced trauma crate"

/decl/hierarchy/supply_pack/medical/abk
	name = "Triage - Advanced burn supplies"
	contains = list(/obj/item/stack/medical/advanced/ointment = 6)
	cost = 15
	containername = "advanced burn crate"

/decl/hierarchy/supply_pack/medical/firstaid
	name = "Triage - Regular first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/regular = 5)
	cost = 15
	containername = "first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidfire
	name = "Triage - Fire first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/fire = 5)
	cost = 20
	containername = "fire first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidtoxin
	name = "Triage - Toxin first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/toxin = 5)
	cost = 20
	containername = "toxin first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaido2
	name = "Triage - O2 first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/o2 = 5)
	cost = 18
	containername = "\improper O2 first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidadv
	name = "Triage - Advanced first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/adv = 5)
	cost = 25
	containername = "advanced first-aid crate"

//refills
/decl/hierarchy/supply_pack/medical/medical
	name = "Refills - Medical supplies"
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/adv,
					/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
					/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/autoinjectors)
	cost = 20
	containername = "medical crate"

/decl/hierarchy/supply_pack/medical/bloodpack
	name = "Refills - Empty blood packs"
	contains = list(/obj/item/weapon/storage/box/bloodpacks = 4)
	cost = 5
	containername = "blood pack crate"

/decl/hierarchy/supply_pack/medical/blood
	name = "Refills - O- blood packs"
	contains = list(/obj/item/weapon/reagent_containers/blood/OMinus = 4)
	cost = 100
	containername = "\improper O- blood crate"

//equipment
/decl/hierarchy/supply_pack/medical/cryobag
	name = "Equipment - Stasis bag"
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 50
	containername = "stasis bag crate"

/decl/hierarchy/supply_pack/medical/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/weapon/storage/box/bodybags = 3)
	cost = 8
	containername = "body bag crate"

/decl/hierarchy/supply_pack/medical/autopsy
	name = "Equipment - Autopsy equipment"
	contains = list(/obj/item/weapon/folder/white,
					/obj/item/device/camera,
					/obj/item/device/camera_film = 2,
					/obj/item/weapon/autopsy_scanner,
					/obj/item/weapon/scalpel,
					/obj/item/weapon/storage/box/masks,
					/obj/item/weapon/storage/box/gloves,
					/obj/item/weapon/pen)
	cost = 15
	containertype = /obj/structure/closet/crate/plastic
	containername = "autopsy equipment crate"

/decl/hierarchy/supply_pack/medical/portablefreezers
	name = "Equipment - Portable freezers"
	contains = list(/obj/item/weapon/storage/box/freezer = 7)
	cost = 25
	containertype = /obj/structure/closet/crate/medical
	containername = "portable freezers crate"

/decl/hierarchy/supply_pack/medical/anesthetic
	name = "Equipment - Anesthetic tanks"
	contains = list(/obj/item/weapon/tank/anesthetic = 8,
					/obj/item/clothing/mask/breath/medical = 2)
	cost = 75
	containername = "anesthetic tanks crate"

/decl/hierarchy/supply_pack/medical/surgery
	name = "Equipment - Surgery supplies"
	contains = list(/obj/item/weapon/cautery,
					/obj/item/weapon/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/weapon/tank/anesthetic,
					/obj/item/weapon/FixOVein,
					/obj/item/weapon/hemostat,
					/obj/item/weapon/scalpel,
					/obj/item/weapon/bonegel,
					/obj/item/weapon/retractor,
					/obj/item/weapon/bonesetter,
					/obj/item/weapon/circular_saw,
					/obj/item/stack/medical/bruise_pack)
	cost = 25
	containername = "surgery crate"

//gear
/decl/hierarchy/supply_pack/medical/medicalbiosuits
	name = "Gear - Medical bio-suit gear"
	contains = list(/obj/item/clothing/head/bio_hood = 3,
					/obj/item/clothing/suit/bio_suit = 3,
					/obj/item/clothing/head/bio_hood/virology = 2,
					/obj/item/clothing/suit/bio_suit/virology = 2,
					/obj/item/clothing/mask/gas = 5,
					/obj/item/weapon/tank/oxygen = 5)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "medical biohazard equipment crate"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/belts
	name = "Gear - Medical belts"
	contains = list(/obj/item/weapon/storage/belt/medical = 3)
	cost = 16
	containername = "medical belts crate"

//clothing
/decl/hierarchy/supply_pack/medical/medicalscrubs
	name = "Clothing - Assorted medical scrubs"
	contains = list(/obj/item/clothing/shoes/white = 16,
					/obj/item/clothing/under/rank/medical/scrubs/blue = 2,
					/obj/item/clothing/under/rank/medical/scrubs/green = 2,
					/obj/item/clothing/under/rank/medical/scrubs/purple = 2,
					/obj/item/clothing/under/rank/medical/scrubs/black = 2,
					/obj/item/clothing/under/rank/medical/scrubs/navyblue = 2,
					/obj/item/clothing/under/rank/medical/scrubs/lilac = 2,
					/obj/item/clothing/under/rank/medical/scrubs/teal = 2,
					/obj/item/clothing/under/rank/medical/scrubs/heliodor = 2,
					/obj/item/clothing/head/surgery/black = 2,
					/obj/item/clothing/head/surgery/purple = 2,
					/obj/item/clothing/head/surgery/blue = 2,
					/obj/item/clothing/head/surgery/green = 2,
					/obj/item/clothing/head/surgery/navyblue = 2,
					/obj/item/clothing/head/surgery/lilac = 2,
					/obj/item/clothing/head/surgery/teal = 2,
					/obj/item/clothing/head/surgery/heliodor = 2,
					/obj/item/clothing/suit/patientgown = 2,
					/obj/item/clothing/suit/surgicalapron = 2,
					/obj/item/weapon/storage/box/masks,
					/obj/item/weapon/storage/box/gloves)
	cost = 20
	containertype = /obj/structure/closet/crate/large
	containername = "medical scrubs crate"

//eva
/decl/hierarchy/supply_pack/medical/voidsuit
	name = "EVA - Medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical,
					/obj/item/clothing/head/helmet/space/void/medical,
					/obj/item/clothing/shoes/magboots)
	cost = 100
	containername = "medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/traumaimplant
	name = "Trauma Implant"
	contains = list(/obj/item/weapon/implantcase/trauma_alarm,
					/obj/item/weapon/implanter)
	cost = 100
	containername = "\improper Trauma implant box"
	containertype = /obj/structure/closet/crate/secure
	access = core_access_command_programs

/decl/hierarchy/supply_pack/medical/voidsuit_heavyduty
	name = "EVA - Heavy-duty medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt/prepared,
					/obj/item/clothing/head/helmet/space/void/medical/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 150
	containername = "heavy-duty medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_medical_programs