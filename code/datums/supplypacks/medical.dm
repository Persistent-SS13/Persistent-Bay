/decl/hierarchy/supply_pack/medical
	name = "Medical"
	containertype = /obj/structure/closet/crate/medical

/decl/hierarchy/supply_pack/medical/bulkfirstaid
	name = "Bulk Medkit Crate"
	contains = list(/obj/item/weapon/storage/firstaid/regular = 10,
					/obj/item/weapon/storage/firstaid/fire = 10,
					/obj/item/weapon/storage/firstaid/toxin = 10,
					/obj/item/weapon/storage/firstaid/adv = 10,
					/obj/item/weapon/storage/firstaid/o2 = 10)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Bulk Medkit Crate (x10)"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/medical
	name = "Medical crate"
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
	containername = "\improper Medical crate"

/decl/hierarchy/supply_pack/medical/bloodpack
	name = "Blood pack crate"
	contains = list(/obj/item/weapon/storage/box/bloodpacks = 4)
	cost = 10
	containername = "\improper Blood pack crate"

/decl/hierarchy/supply_pack/medical/blood
	name = "O- blood crate"
	contains = list(/obj/item/weapon/reagent_containers/blood/OMinus = 4)
	cost = 100
	containername = "\improper O- blood crate"

/decl/hierarchy/supply_pack/medical/firstaid
	name = "Regular first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/regular = 4)
	cost = 15
	containername = "\improper First-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidfire
	name = "Fire first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/fire = 3)
	cost = 20
	containername = "\improper Fire first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidtoxin
	name = "Toxin first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/toxin = 3)
	cost = 20
	containername = "\improper Toxin first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaido2
	name = "O2 first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/o2 = 3)
	cost = 20
	containername = "\improper O2 first-aid crate"

/decl/hierarchy/supply_pack/medical/firstaidadv
	name = "Advanced first-aid kits"
	contains = list(/obj/item/weapon/storage/firstaid/adv = 3)
	cost = 25
	containername = "\improper Advanced first-aid crate"

/decl/hierarchy/supply_pack/medical/bodybag
	name = "Body bag crate"
	contains = list(/obj/item/weapon/storage/box/bodybags = 3)
	cost = 10
	containername = "\improper Body bag crate"

/decl/hierarchy/supply_pack/medical/belts
	name = "Medical Belts crate"
	contains = list(/obj/item/weapon/storage/belt/medical = 3)
	cost = 20
	containername = "\improper Medical Belts crate"

/decl/hierarchy/supply_pack/medical/cryobag
	name = "Stasis bag crate"
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 50
	containername = "\improper Stasis bag crate"

/decl/hierarchy/supply_pack/medical/medicalextragear
	name = "Medical Surplus Supplies"
	num_contained = 5
	contains = list(/obj/item/weapon/storage/belt/medical,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/adv,
					/obj/item/weapon/cautery,
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
					/obj/item/stack/medical/bruise_pack,
					/obj/item/weapon/storage/box/bloodpacks,
					/obj/item/weapon/storage/box/bodybags,
					/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
					/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/autoinjectors,
					/obj/item/bodybag/cryobag)
	cost = 15
	containertype = /obj/structure/closet/crate/plastic
	containername = "\improper Medical Surplus Equipment"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/medical/medicalscrubs
	name = "Assorted Medical Scrubs"
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
	containername = "\improper Medical scrubs crate"

/decl/hierarchy/supply_pack/medical/autopsy
	name = "Autopsy equipment"
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
	containername = "\improper Autopsy equipment crate"

/decl/hierarchy/supply_pack/medical/medicaluniforms
	name = "Professional Medical Uniforms"
	contains = list(/obj/item/clothing/shoes/white = 11,
					/obj/item/clothing/under/rank/chemist,
					/obj/item/clothing/under/rank/virologist,
					/obj/item/clothing/under/rank/nursesuit,
					/obj/item/clothing/under/rank/nurse,
					/obj/item/clothing/under/rank/orderly,
					/obj/item/clothing/under/rank/medical = 5,
					/obj/item/clothing/under/rank/medical/paramedic,
					/obj/item/clothing/suit/storage/toggle/labcoat = 5,
					/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/weapon/storage/box/masks,
					/obj/item/weapon/storage/box/gloves)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Medical uniform crate"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/medicalbiosuits
	name = "Medical Biohazard Gear"
	contains = list(/obj/item/clothing/head/bio_hood = 3,
					/obj/item/clothing/suit/bio_suit = 3,
					/obj/item/clothing/head/bio_hood/virology = 2,
					/obj/item/clothing/suit/bio_suit/virology = 2,
					/obj/item/clothing/mask/gas = 5,
					/obj/item/weapon/tank/oxygen = 5,
					/obj/item/weapon/storage/box/masks,
					/obj/item/weapon/storage/box/gloves)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Medical biohazard equipment"
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/portablefreezers
	name = "Portable freezers crate"
	contains = list(/obj/item/weapon/storage/box/freezer = 7)
	cost = 25
	containertype = /obj/structure/closet/crate/medical
	containername = "\improper Portable freezers"

/decl/hierarchy/supply_pack/medical/surgery
	name = "Surgery crate"
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
	containertype = /obj/structure/closet/crate/medical
	containername = "\improper Surgery crate"

/decl/hierarchy/supply_pack/medical/voidsuit
	name = "Medical Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/prepared)
	cost = 100
	containername = "\improper Medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/voidsuit_heavyduty
	name = "Heavy Duty Medical Voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt/prepared)
	cost = 150
	containername = "\improper Medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = core_access_medical_programs

/decl/hierarchy/supply_pack/medical/anesthetic
	name = "Anesthetic Tanks and Masks (x10)"
	contains = list(/obj/item/weapon/tank/anesthetic = 8,
					/obj/item/clothing/mask/breath/medical = 2)
	cost = 75
	containertype = /obj/structure/closet/crate/medical
	containername = "\improper Anesthetic Tanks crate"
