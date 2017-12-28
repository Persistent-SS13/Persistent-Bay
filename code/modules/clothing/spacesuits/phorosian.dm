//Phorosian suits
/obj/item/clothing/suit/space/phorosian
	name = "Phorosian containment suit"
	icon = 'icons/obj/clothing/species/phorosian/suits.dmi'
	icon_state = "phorosiansuit"
	item_state = "phorosiansuit"
	allowed = list(/obj/item/weapon/tank)
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A special containment suit designed to protect a phorosians volatile body from outside exposure."
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	species_restricted = list(SPECIES_PHOROSIAN)
	sprite_sheets = list(
		SPECIES_PHOROSIAN = 'icons/mob/species/phorosian/suit.dmi'
		)
	breach_threshold = 18
	can_breach = 1
	
	
/obj/item/clothing/head/helmet/space/phorosian
	name = "Phorosian helmet"
	desc = "A helmet made to connect with a Phorosian containment suit. Has a plasma-glass visor."
	icon = 'icons/obj/clothing/species/phorosian/hats.dmi'
	icon_state = "phorosian_helmet0"
	item_state = "phorosian_helmet0"
	heat_protection = HEAD
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.4
	species_restricted = list(SPECIES_PHOROSIAN)
	light_overlay = "helmet_light"
	sprite_sheets = list(
		SPECIES_PHOROSIAN = 'icons/mob/species/phorosian/helmet.dmi'
		)
		
		
/obj/item/clothing/suit/space/phorosian/assistant
	name = "Phorosian assistant suit"
	icon_state = "phorosianAssistant_suit"
	item_state = "phorosianAssistant_suit"
/obj/item/clothing/head/helmet/space/phorosian/assistant
	name = "Phorosian assistant helmet"
	icon_state = "phorosianAssistant_helmet0"
	item_state = "phorosianAssistant_helmet0"

/obj/item/clothing/suit/space/phorosian/atmostech
	name = "Phorosian atmospheric suit"
	icon_state = "phorosianAtmos_suit"
	item_state = "phorosianAtmos_suit"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/phorosian/atmostech
	name = "Phorosian atmospheric helmet"
	icon_state = "phorosianAtmos_helmet0"
	item_state = "phorosianAtmos_helmet0"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/phorosian/engineer
	name = "Phorosian engineer suit"
	icon_state = "phorosianEngineer_suit"
	item_state = "phorosianEngineer_suit"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)

/obj/item/clothing/head/helmet/space/phorosian/engineer
	name = "Phorosian engineer helmet"
	icon_state = "phorosianEngineer_helmet0"
	item_state = "phorosianEngineer_helmet0"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	
/obj/item/clothing/suit/space/phorosian/engineer/ce
	name = "Phorosian chief engineer suit"
	icon_state = "phorosianCE"
	item_state = "phorosianCE"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)

/obj/item/clothing/head/helmet/space/phorosian/engineer/ce
	name = "Phorosian chief engineer helmet"
	icon_state = "phorosianCE_helmet0"
	item_state = "phorosianCE_helmet0"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)

//SERVICE

/obj/item/clothing/suit/space/phorosian/botanist
	name = "Phorosian botanist suit"
	icon_state = "phorosianBotanist_suit"
	item_state = "phorosianBotanist_suit"

/obj/item/clothing/head/helmet/space/phorosian/botanist
	name = "Phorosian botanist helmet"
	icon_state = "phorosianBotanist_helmet0"
	item_state = "phorosianBotanist_helmet0"

/obj/item/clothing/suit/space/phorosian/chaplain
	name = "Phorosian chaplain suit"
	icon_state = "phorosianChaplain_suit"
	item_state = "phorosianChaplain_suit"

/obj/item/clothing/head/helmet/space/phorosian/chaplain
	name = "Phorosian chaplain helmet"
	icon_state = "phorosianChaplain_helmet0"
	item_state = "phorosianChaplain_helmet0"

/obj/item/clothing/suit/space/phorosian/clown
	name = "Phorosian clown suit"
	icon_state = "phorosianClown"
	item_state = "phorosianClown"

/obj/item/clothing/head/helmet/space/phorosian/clown
	name = "Phorosian clown helmet"
	icon_state = "phorosianClown_helmet0"
	item_state = "phorosianClown_helmet0"

/obj/item/clothing/suit/space/phorosian/mime
	name = "Phorosian mime suit"
	icon_state = "phorosianMime"
	item_state = "phorosianMime"

/obj/item/clothing/head/helmet/space/phorosian/mime
	name = "Phorosian mime helmet"
	icon_state = "phorosianMime_helmet0"
	item_state = "phorosianMime_helmet0"

/obj/item/clothing/suit/space/phorosian/service
	name = "Phorosian service suit"
	icon_state = "phorosianService_suit"
	item_state = "phorosianService_suit"

/obj/item/clothing/head/helmet/space/phorosian/service
	name = "Phorosian service helmet"
	icon_state = "phorosianService_helmet0"
	item_state = "phorosianService_helmet0"

/obj/item/clothing/suit/space/phorosian/janitor
	name = "Phorosian janitor suit"
	icon_state = "phorosianJanitor_suit"
	item_state = "phorosianJanitor_suit"

/obj/item/clothing/head/helmet/space/phorosian/janitor
	name = "Phorosian janitor helmet"
	icon_state = "phorosianJanitor_helmet0"
	item_state = "phorosianJanitor_helmet0"


//CARGO

/obj/item/clothing/suit/space/phorosian/cargo
	name = "Phorosian cargo suit"
	icon_state = "phorosianCargo_suit"
	item_state = "phorosianCargo_suit"

/obj/item/clothing/head/helmet/space/phorosian/cargo
	name = "Phorosian cargo helmet"
	icon_state = "phorosianCargo_helmet0"
	item_state = "phorosianCargo_helmet0"

/obj/item/clothing/suit/space/phorosian/miner
	name = "Phorosian miner suit"
	icon_state = "phorosianMiner_suit"
	item_state = "phorosianMiner_suit"
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/phorosian/miner
	name = "Phorosian miner helmet"
	icon_state = "phorosianMiner_helmet0"
	item_state = "phorosianMiner_helmet0"
	armor = list(melee = 50, bullet = 5, laser = 20,energy = 5, bomb = 55, bio = 100, rad = 20)


// MEDSCI

/obj/item/clothing/suit/space/phorosian/medical
	name = "Phorosian medical suit"
	icon_state = "phorosianMedical_suit"
	item_state = "phorosianMedical_suit"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/phorosian/medical
	name = "Phorosian medical helmet"
	icon_state = "phorosianMedical_helmet0"
	item_state = "phorosianMedical_helmet0"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 25, bio = 100, rad = 50)
	
/obj/item/clothing/suit/space/phorosian/medical/paramedic
	name = "Phorosian paramedic suit"
	icon_state = "phorosianParamedic"
	item_state = "phorosianParamedic"

/obj/item/clothing/head/helmet/space/phorosian/medical/paramedic
	name = "Phorosian paramedic helmet"
	icon_state = "phorosianParamedic_helmet0"
	item_state = "phorosianParamedic_helmet0"

/obj/item/clothing/suit/space/phorosian/medical/chemist
	name = "Phorosian chemist suit"
	icon_state = "phorosianChemist"
	item_state = "phorosianChemist"

/obj/item/clothing/head/helmet/space/phorosian/medical/chemist
	name = "Phorosian chemist helmet"
	icon_state = "phorosianChemist_helmet0"
	item_state = "phorosianChemist_helmet0"

/obj/item/clothing/suit/space/phorosian/medical/cmo
	name = "Phorosian chief medical officer suit"
	icon_state = "phorosianCMO"
	item_state = "phorosianCMO"

/obj/item/clothing/head/helmet/space/phorosian/medical/cmo
	name = "Phorosian chief medical officer helmet"
	icon_state = "phorosianCMO_helmet0"
	item_state = "phorosianCMO_helmet0"

/obj/item/clothing/suit/space/phorosian/science
	name = "Phorosian scientist suit"
	icon_state = "phorosianScience_suit"
	item_state = "phorosianScience_suit"

/obj/item/clothing/head/helmet/space/phorosian/science
	name = "Phorosian scientist helmet"
	icon_state = "phorosianScience_helmet0"
	item_state = "phorosianScience_helmet0"

/obj/item/clothing/suit/space/phorosian/science/rd
	name = "Phorosian research director suit"
	icon_state = "phorosianRD"
	item_state = "phorosianRD"

/obj/item/clothing/head/helmet/space/phorosian/science/rd
	name = "Phorosian research director helmet"
	icon_state = "phorosianRD_helmet0"
	item_state = "phorosianRD_helmet0"

//MAGISTRATE
/obj/item/clothing/suit/space/phorosian/magistrate
	name = "Phorosian magistrate suit"
	icon_state = "phorosianHoS"
	item_state = "phorosianHoS"

/obj/item/clothing/head/helmet/space/phorosian/magistrate
	name = "Phorosian magistrate helmet"
	icon_state = "phorosianHoS_helmet0"
	item_state = "phorosianHoS_helmet0"

//SECURITY

/obj/item/clothing/suit/space/phorosian/security
	name = "Phorosian security suit"
	icon_state = "phorosianSecurity_suit"
	item_state = "phorosianSecurity_suit"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)

/obj/item/clothing/head/helmet/space/phorosian/security
	name = "Phorosian security helmet"
	icon_state = "phorosianSecurity_helmet0"
	item_state = "phorosianSecurity_helmet0"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)

/obj/item/clothing/suit/space/phorosian/security/hos
	name = "Phorosian head of security suit"
	icon_state = "phorosianHoS"
	item_state = "phorosianHoS"

/obj/item/clothing/head/helmet/space/phorosian/security/hos
	name = "Phorosian head of security helmet"
	icon_state = "phorosianHoS_helmet0"
	item_state = "phorosianHoS_helmet0"

/obj/item/clothing/suit/space/phorosian/security/hop
	name = "Phorosian head of personnel suit"
	icon_state = "phorosianHoP"
	item_state = "phorosianHoP"

/obj/item/clothing/head/helmet/space/phorosian/security/hop
	name = "Phorosian head of personnel helmet"
	icon_state = "phorosianHoP_helmet0"
	item_state = "phorosianHoP_helmet0"

/obj/item/clothing/suit/space/phorosian/security/captain
	name = "Phorosian captain suit"
	icon_state = "phorosianCaptain"
	item_state = "phorosianCaptain"

/obj/item/clothing/head/helmet/space/phorosian/security/captain
	name = "Phorosian captain helmet"
	icon_state = "phorosianCaptain_helmet0"
	item_state = "phorosianCaptain_helmet0"

//NUKEOPS

/obj/item/clothing/suit/space/phorosian/nuclear
	name = "blood red Phorosian suit"
	icon_state = "phorosianNukeops"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/phorosian/nuclear
	name = "blood red Phorosian helmet"
	icon_state = "phorosianNukeops_helmet0"
	item_state = "phorosianNukeops_helmet0"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)