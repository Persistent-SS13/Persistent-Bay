/datum/researchDesign/adv_capacitor
	name = "Advanced Capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	category = RESEARCH_CATEGORY_PART
	buildPath = /obj/item/weapon/stock_parts/capacitor/adv
	sortString = "CAAAA"

	chemicals = list(/datum/reagent/aluminum = 20, /datum/reagent/acid = 10)
	techPoints = list(TECH_ELECTRICAL = 1000, TECH_MATERIAL = 1000)

/datum/researchDesign/super_capacitor
	name = "Super Capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	category = RESEARCH_CATEGORY_PART
	buildPath = /obj/item/weapon/stock_parts/capacitor/super
	sortString = "CAAAB"

	chemicals = list(/datum/reagent/aluminum = 10, /datum/reagent/lithium = 10, /datum/reagent/acid = 10)
	techPoints = list(TECH_ELECTRICAL = 5000, TECH_MATERIAL = 2000)

/datum/researchDesign/adv_scanner
	name = "Advanced Scanner"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	category = RESEARCH_CATEGORY_PART
	buildPath = /obj/item/weapon/stock_parts/scanning_module/adv
	sortString = "CAAAC"

	chemicals = ""
	techPoints = list()
