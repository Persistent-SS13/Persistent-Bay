/obj/machinery/fabricator/autotailor/combat
	name = "auto-tailor (tactical wear)"
	desc = "An advanced machine capable of printing many types of clothing, this one is loaded with tactical clothing & armor designs."
	circuit = /obj/item/weapon/circuitboard/fabricator/autotailor/combat
	build_type = AUTOTAILOR_TACTICAL

/obj/machinery/fabricator/autotailor/combat/can_connect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(req_access_faction)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(trying.limits.limit_attactical <= trying.limits.attacticals.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	trying.limits.attacticals |= src
	req_access_faction = trying.uid
	connected_faction = src

/obj/machinery/fabricator/autotailor/combat/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	if(!trying.limits) return 0
	trying.limits.attacticals -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")



////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/autotailor/combat
	build_type = AUTOTAILOR_TACTICAL
	category = "Misc"
	req_tech = list(TECH_COMBAT = 1)
	time = 30
//
//Undersuits
//
/datum/design/item/autotailor/combat/under
	category = "Uniforms"
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/autotailor/combat/under/pcrc
	name = "PCRC uniform"
	id = "pcrc"
	build_path = /obj/item/clothing/under/pcrc
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/tactical_green
	name = "tactical jumpsuit - green"
	id = "tactical_green"
	build_path = /obj/item/clothing/under/tactical

/datum/design/item/autotailor/combat/under/turtleneck_def
	name = "tactical turtleneck"
	id = "turtleneck_def"
	build_path = /obj/item/clothing/under/syndicate
	materials = list("leather" = 5000, "plasteel" = 5000, "osmium-carbide plasteel" = 5000)

/datum/design/item/autotailor/combat/under/hos_red
	name = "Head of Security jumpsuit - red"
	id = "hos_red"
	build_path = /obj/item/clothing/under/rank/head_of_security

/datum/design/item/autotailor/combat/under/hos_black
	name = "Head of Security jumpsuit - black"
	id = "hos_black"
	build_path = /obj/item/clothing/under/rank/head_of_security/corp

/datum/design/item/autotailor/combat/under/hos_tacticalblack
	name = "Head of Security jumpsuit - tactical"
	id = "hos_tacticalblack"
	build_path = /obj/item/clothing/under/rank/head_of_security/jensen

/datum/design/item/autotailor/combat/under/hos_navy
	name = "Head of security jumpsuit - navy"
	id = "hos_navy"
	build_path = /obj/item/clothing/under/rank/head_of_security/navyblue

/datum/design/item/autotailor/combat/under/hos_hat
	name = "Head of security hat"
	id = "hos_hat"
	build_path = /obj/item/clothing/head/HoS
	materials = list("leather" = 2000)

/datum/design/item/autotailor/combat/under/warden_red
	name = "Warden jumpsuit - red"
	id = "warden_red"
	build_path = /obj/item/clothing/under/rank/warden

/datum/design/item/autotailor/combat/under/warden_black
	name = "Warden jumpsuit - black"
	id = "warden_black"
	build_path = /obj/item/clothing/under/rank/warden/corp

/datum/design/item/autotailor/combat/under/warden_navy
	name = "Warden jumpsuit - navy"
	id = "warden_navy"
	build_path = /obj/item/clothing/under/rank/warden/navyblue

/datum/design/item/autotailor/combat/under/warden_hat
	name = "Warden hat"
	id = "warden_hat"
	build_path = /obj/item/clothing/head/warden
	materials = list("leather" = 2000)

/datum/design/item/autotailor/combat/under/sec_red
	name = "Sec officer jumpsuit - red"
	id = "sec_red"
	build_path = /obj/item/clothing/under/rank/security

/datum/design/item/autotailor/combat/under/sec_black
	name = "Sec officer jumpsuit - black"
	id = "sec_black"
	build_path = /obj/item/clothing/under/rank/security/corp

/datum/design/item/autotailor/combat/under/sec_navy
	name = "Sec officer jumpsuit - navy"
	id = "sec_navy"
	build_path = /obj/item/clothing/under/rank/security/navyblue

/datum/design/item/autotailor/combat/under/sec_navyred
	name = "Sec officer jumpsuit - navy red"
	id = "sec_navyred"
	build_path = /obj/item/clothing/under/rank/guard

/datum/design/item/autotailor/combat/under/sec_navyterrac
	name = "Sec officer jumpsuit - navy terracotta"
	id = "sec_navyterrac"
	build_path = /obj/item/clothing/under/rank/securitytwo

/datum/design/item/autotailor/combat/under/dispatch
	name = "Dispatcher uniform"
	id = "dispatch"
	build_path = /obj/item/clothing/under/rank/dispatch

/datum/design/item/autotailor/combat/under/tactical_ert
	name = "ERT uniform"
	id = "tactical_ert"
	build_path = /obj/item/clothing/under/ert
	materials = list("leather" = 5000, "plasteel" = 1000, "osmium-carbide plasteel" = 1000)

/datum/design/item/autotailor/combat/under/pt_uniform
	name = "TF PT uniform"
	id = "pt_uniform"
	build_path = /obj/item/clothing/under/fed/pt
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/utility_tf
	name = "TF utility uniform"
	id = "utility_tact"
	build_path = /obj/item/clothing/under/fed
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/service_tf
	name = "TF service uniform"
	id = "service_tact"
	build_path = /obj/item/clothing/under/fed/service
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_tf
	name = "TF dress uniform"
	id = "dress_tact"
	build_path = /obj/item/clothing/under/fed/dress
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_hat
	name = "TF dress hat"
	id = "service_hat"
	build_path = /obj/item/clothing/head/soft/fed/wheel
	materials = list("leather" = 2000)

/datum/design/item/autotailor/combat/under/beanie_tact
	name = "TF beanie"
	id = "beanie_tact"
	build_path = /obj/item/clothing/head/soft/fed/garrison
	materials = list("leather" = 2000)

/datum/design/item/autotailor/combat/under/gov_tact
	name = "Sectorial governor uniform"
	id = "gov_tact"
	build_path = /obj/item/clothing/under/fed/gov
	materials = list("leather" = 5000, "phoron" = 8000)

/datum/design/item/autotailor/combat/under/fleet_utility
	name = "Fleet utility uniform"
	id = "fleet_utility"
	build_path = /obj/item/clothing/under/utility/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/fleet_service
	name = "Fleet service uniform"
	id = "fleet_service"
	build_path = /obj/item/clothing/under/service/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/fleet_dress
	name = "Fleet dress uniform"
	id = "fleet_dress"
	build_path = /obj/item/clothing/under/mildress/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/high_rank_cap
	name = "High ranking captain uniform"
	id = "high_rank_cap"
	build_path = /obj/item/clothing/under/rank/centcom
	materials = list("leather" = 5000, "phoron" = 8000)

/datum/design/item/autotailor/combat/under/high_rank_cap_hat
	name = "High ranking captain hat"
	id = "high_rank_cap_hat"
	build_path = /obj/item/clothing/head/centhat
	materials = list("leather" = 2500, "phoron" = 4000)

/datum/design/item/autotailor/combat/under/high_rank_officer
	name = "High ranking officer uniform"
	id = "high_rank_officer"
	build_path = /obj/item/clothing/under/rank/centcom_officer
	materials = list("leather" = 5000, "phoron" = 8000)

/datum/design/item/autotailor/combat/under/high_rank_admiral
	name = "High ranking admiral uniform"
	id = "high_rank_admiral"
	build_path = /obj/item/clothing/under/rank/centcom_captain
	materials = list("leather" = 5000, "phoron" = 8000)

//everything below is actually armor-less oversuit slots

/datum/design/item/autotailor/combat/under/dress_j_black
	name = "Dress jacket - black"
	id = "dress_j_black"
	build_path = /obj/item/clothing/suit/dress/mirania/intelligence
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_h_black
	name = "Dress jacket hat - black"
	id = "dress_h_black"
	build_path = /obj/item/clothing/head/dress/mirania/intelligence
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_j_bl_red
	name = "Dress jacket - black red stripes"
	id = "dress_j_bl_red"
	build_path = /obj/item/clothing/suit/dress/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_j_bk_red
	name = "Dress jacket hat - black red stripes"
	id = "dress_h_bl_red"
	build_path = /obj/item/clothing/head/dress/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_j_navy_red
	name = "Dress jacket - navy red stripes"
	id = "dress_j_navy_red"
	build_path = /obj/item/clothing/suit/storage/service/mirania
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/dress_j_navy
	name = "Dress jacket - navy"
	id = "dress_j_navy"
	build_path = /obj/item/clothing/suit/storage/service/mirania/intelligence
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/sec_navy_officer
	name = "Sec officer jacket - navy"
	id = "sec_navy_officer"
	build_path = /obj/item/clothing/suit/security/navyofficer
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/sec_navy_warden
	name = "Warden jacket - navy"
	id = "sec_navy_warden"
	build_path = /obj/item/clothing/suit/security/navywarden
	materials = list("leather" = 5000)

/datum/design/item/autotailor/combat/under/sec_navy_hos
	name = "HoS jacket - navy"
	id = "sec_navy_hos"
	build_path = /obj/item/clothing/suit/security/navyhos
	materials = list("leather" = 5000)

//
//body armor
//materials probably needs more balancing, but the general rule i had was: steel = basic/stab protection, plasteel = ballistic, ocp = thermal
//
/datum/design/item/autotailor/combat/barmour
	category = "Oversuits - Body armour"
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/barmour/basic_vest
	name = "armor vest - basic"
	id = "basic_vest"
	build_path = /obj/item/clothing/suit/armor/vest/old

/datum/design/item/autotailor/combat/barmour/basic_vest_nt	//NT item
	name = "armor vest - basic NT"
	id = "basic_vest_nt"
	build_path = /obj/item/clothing/suit/armor/vest/old/nt

/datum/design/item/autotailor/combat/barmour/basic_vest_brown
	name = "armor vest - basic brown"
	id = "basic_vest_brown"
	build_path = /obj/item/clothing/suit/armor/det_suit

/datum/design/item/autotailor/combat/barmour/basic_vest_ballistic
	name = "armor vest - basic ballistic"
	id = "basic_vest_ballistic"
	build_path = /obj/item/clothing/suit/armor/bulletproof/vest
	materials = list("leather" = 10000, "plasteel" = 10000)

/datum/design/item/autotailor/combat/barmour/basic_vest_laser
	name = "armor vest - basic laserproof"
	id = "basic_vest_laser"
	build_path = /obj/item/clothing/suit/armor/laserproof/vest
	materials = list("leather" = 10000, "osmium-carbide plasteel" = 10000)

/datum/design/item/autotailor/combat/barmour/tact_vest
	name = "armor vest - tactical"
	id = "tact_vest"
	build_path = /obj/item/clothing/suit/armor/vest
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 3000)

/datum/design/item/autotailor/combat/barmour/tact_vest_nt	//NT item
	name = "armor vest - tactical NT"
	id = "tact_vest_nt"
	build_path = /obj/item/clothing/suit/armor/vest/nt
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 3000)

/datum/design/item/autotailor/combat/barmour/tact_vest_pcrc
	name = "armor vest - tactical PCRC"
	id = "tact_vest_pcrc"
	build_path = /obj/item/clothing/suit/armor/vest/pcrc
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 3000)

/datum/design/item/autotailor/combat/barmour/tact_vest_press
	name = "armor vest - tactical press"
	id = "tact_vest_press"
	build_path = /obj/item/clothing/suit/armor/vest/press
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 3000)

/datum/design/item/autotailor/combat/barmour/tact_brown
	name = "armor vest - tactical brown"
	id = "tact_brown"
	build_path = /obj/item/clothing/suit/armor/vest/detective
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 3000)

/datum/design/item/autotailor/combat/barmour/stab_vest
	name = "armor vest - stab protection"
	id = "stab_vest"
	build_path = /obj/item/clothing/suit/armor/riot/vest
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000)

/datum/design/item/autotailor/combat/barmour/pocket_vest
	name = "armor vest - webbed"
	id = "pocket_vest"
	build_path = /obj/item/clothing/suit/storage/vest
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000)

/datum/design/item/autotailor/combat/barmour/pocket_vest_sec
	name = "armor vest - webbed security"
	id = "pocket_vest_sec"
	build_path = /obj/item/clothing/suit/storage/vest/nt
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/pocket_vest_pcrc
	name = "armor vest - webbed PCRC"
	id = "pocket_vest_pcrc"
	build_path = /obj/item/clothing/suit/storage/vest/pcrc
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/pocket_vest_warden
	name = "armor vest - webbed warden"
	id = "pocket_vest_warden"
	build_path = /obj/item/clothing/suit/storage/vest/nt/warden
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/pocket_vest_com
	name = "armor vest - webbed commander"
	id = "pocket_vest_com"
	build_path = /obj/item/clothing/suit/storage/vest/nt/hos
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/pocket_vest_tact
	name = "armor vest - large webbed tactical"
	id = "pocket_vest_tact"
	build_path = /obj/item/clothing/suit/storage/vest/tactical
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/pocket_vest_fleet
	name = "armor vest - large webbed fleet"
	id = "pocket_vest_fleet"
	build_path = /obj/item/clothing/suit/storage/vest/tactical/mirania
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/suit_vest_combat
	name = "body armor - large webbed combat"
	id = "pocket_vest_combat"
	build_path = /obj/item/clothing/suit/storage/vest/merc
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/suit_ballistic
	name = "body armor - ballistic"
	id = "suit_ballistic"
	build_path = /obj/item/clothing/suit/armor/bulletproof
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "plasteel" = 20000)

/datum/design/item/autotailor/combat/barmour/suit_stab
	name = "body armor - riot control"
	id = "suit_stab"
	build_path = /obj/item/clothing/suit/armor/riot
	materials = list(DEFAULT_WALL_MATERIAL = 20000)

/datum/design/item/autotailor/combat/barmour/helmet_riot
	name = "Helmet - riot control"
	id = "helmet_riot"
	build_path = /obj/item/clothing/head/helmet/riot
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "plastic" = 20000)

/datum/design/item/autotailor/combat/barmour/suit_laserproof
	name = "body armor - laserproof"
	id = "suit_laserproof"
	build_path = /obj/item/clothing/suit/armor/laserproof
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "osmium-carbide plasteel" = 15000)

/datum/design/item/autotailor/combat/barmour/suit_combat
	name = "body armor - heavy duty"
	id = "suit_combat"
	build_path = /obj/item/clothing/suit/armor/heavy
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "plasteel" = 20000, "osmium-carbide plasteel" = 10000)

/datum/design/item/autotailor/combat/barmour/suit_hofficer	//maybe remove, bad colors
	name = "body armor - high ranking officer"
	id = "suit_hofficer"
	build_path = /obj/item/clothing/suit/armor/centcomm
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "plasteel" = 20000, "osmium-carbide plasteel" = 10000)

/datum/design/item/autotailor/combat/barmour/suit_coat
	name = "body armor - coat"
	id = "suit_coat"
	build_path = /obj/item/clothing/suit/armor/hos
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 10000, "plasteel" = 10000, "osmium-carbide plasteel" = 8000)

/datum/design/item/autotailor/combat/barmour/suit_trenchcoat
	name = "body armor - trenchcoat"
	id = "suit_trenchcoat"
	build_path = /obj/item/clothing/suit/armor/hos/jensen
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 10000, "plasteel" = 10000, "osmium-carbide plasteel" = 8000)

/datum/design/item/autotailor/combat/barmour/suit_sec
	name = "body armor - red coat"
	id = "suit_sec"
	build_path = /obj/item/clothing/suit/armor/vest/warden
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 10000, "osmium-carbide plasteel" = 7000)

/datum/design/item/autotailor/combat/barmour/guard_robes
	name = "body armor - guard robes"
	id = "guard_robes"
	build_path =/obj/item/clothing/suit/armor/robes
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "plasteel" = 20000, "osmium-carbide plasteel" = 10000)

/datum/design/item/autotailor/ccombat/barmour/guard_helmet
	name = "Helmet - guard mantle"
	id = "guard_helmet"
	build_path = /obj/item/clothing/head/helmet/guard
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 2000, "osmium-carbide plasteel" = 2000)

/datum/design/item/autotailor/combat/barmour/ert_comarmor
	name = "ERT body armor - commander"
	id = "ert_comarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/ert_comhat
	name = "ERT helmet - commander"
	id = "ert_comhat"
	build_path = /obj/item/clothing/head/helmet/ert
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 2000, "osmium-carbide plasteel" = 2000)

/datum/design/item/autotailor/combat/barmour/ert_engarmor
	name = "ERT body armor - engineer"
	id = "ert_engarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/engineer
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/ert_enghat
	name = "ERT helmet - engineer"
	id = "ert_enghat"
	build_path = /obj/item/clothing/head/helmet/ert/engineer
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 2000, "osmium-carbide plasteel" = 2000)

/datum/design/item/autotailor/combat/barmour/ert_secarmor
	name = "ERT body armor - security"
	id = "ert_secarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/security
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/ert_sechat
	name = "ERT helmet - security"
	id = "ert_sechat"
	build_path = /obj/item/clothing/head/helmet/ert/security
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 2000, "osmium-carbide plasteel" = 2000)

/datum/design/item/autotailor/combat/barmour/ert_docarmor
	name = "ERT body armor - medical"
	id = "ert_docarmor"
	build_path = /obj/item/clothing/suit/armor/vest/ert/medical
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 20000, "osmium-carbide plasteel" = 7500)

/datum/design/item/autotailor/combat/barmour/ert_dochat
	name = "ERT helmet - medical"
	id = "ert_dochat"
	build_path = /obj/item/clothing/head/helmet/ert/medical
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 2000, "osmium-carbide plasteel" = 2000)

/datum/design/item/autotailor/combat/barmour/bombsuit_purple
	name = "Bombsuit - purple stripes"
	id = "bomsuit_purple"
	build_path = /obj/item/clothing/suit/bomb_suit
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 30000)

/datum/design/item/autotailor/combat/barmour/bombhood_purple
	name = "Bombsuit hood - purple"
	id = "bombhood_purple"
	build_path = /obj/item/clothing/head/bomb_hood
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 20000, "plastic" = 20000)

/datum/design/item/autotailor/combat/barmour/bombsuit_green
	name = "Bombsuit - green"
	id = "bombsuit_green"
	build_path = /obj/item/clothing/suit/bomb_suit/security
	materials = list("leather" = 10000, DEFAULT_WALL_MATERIAL = 30000)

/datum/design/item/autotailor/combat/barmour/bombhood_green
	name = "Bombsuit hood - green"
	id = "bombhood_green"
	build_path = /obj/item/clothing/head/bomb_hood/security
	materials = list("leather" = 5000, DEFAULT_WALL_MATERIAL = 20000, "plastic" = 20000)

/datum/design/item/autotailor/combat/barmour/dermal	//remove this when implants exist
	name = "Dermal Patch"
	id = "dermal"
	build_path = /obj/item/clothing/head/HoS/dermal
	materials = list("plasteel" = 4000, "osmium-carbide plasteel" = 4000, "phoron" = 10000)

/datum/design/item/autotailor/combat/barmour/helmet_laserproof
	name = "Helmet - laserproof"
	id = "helmet_laserproof"
	build_path = /obj/item/clothing/head/helmet/ablative
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "osmium-carbide plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_ballistic
	name = "Helmet - ballistic"
	id = "helmet_ballistic"
	build_path = /obj/item/clothing/head/helmet/ballistic
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_tan
	name = "Helmet - tactical"
	id = "helmet_tan"
	build_path = /obj/item/clothing/head/helmet/tactical
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 7000)

/datum/design/item/autotailor/combat/barmour/helmet_navy
	name = "Helmet - navy"
	id = "helmet_navy"
	build_path = /obj/item/clothing/head/helmet/tactical/mirania
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_black
	name = "helmet - black"
	id = "helmet_black"
	build_path = /obj/item/clothing/head/helmet
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_bl_redstripe
	name = "Helmet - black w. red stripes"
	id = "helmet_bl_redstripe"
	build_path = /obj/item/clothing/head/helmet/merc
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 9000,  "osmium-carbide plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_bl_redmark
	name = "Helmet - black w. red markings"
	id = "helmet_bl_redmark"
	build_path = /obj/item/clothing/head/helmet/nt
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_bl_bluemark
	name = "Helmet - black w. blue markings"
	id = "helmet_bl_bluemark"
	build_path = /obj/item/clothing/head/helmet/pcrc
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plasteel" = 5000)

/datum/design/item/autotailor/combat/barmour/helmet_augment
	name = "Helmet - augmented"
	id = "helmet_augment"
	build_path = /obj/item/clothing/head/helmet/augment
	materials = list(DEFAULT_WALL_MATERIAL = 5000,"plasteel" = 4000, "osmium-carbide plasteel" = 4000,"phoron" = 10000)

/datum/design/item/autotailor/combat/barmour/arm_guards
	name = "Gloves - arm guards"
	id = "arm_guards"
	build_path = /obj/item/clothing/gloves/guards
	materials = list("leather" = 2000, "plasteel" = 4000, "osmium-carbide plasteel" = 4000)

/datum/design/item/autotailor/combat/barmour/guard_gloves
	name = "Gloves - guard gloves"
	id = "guard_gloves"
	build_path = /obj/item/clothing/gloves/thick/blueguard
	materials = list("leather" = 2000, "plasteel" = 2000)

//
//modular body armor
//
/datum/design/item/autotailor/combat/modular_armor
	category = "Plate carriers"
	materials = list("leather" = 10000)

/datum/design/item/autotailor/combat/modular_armor/vest_black
	name = "Plate carrier - black"
	id = "vest_black"
	build_path = /obj/item/clothing/suit/armor/pcarrier

/datum/design/item/autotailor/combat/modular_armor/vest_navy
	name = "Plate carrier - navy"
	id = "vest_navy"
	build_path = /obj/item/clothing/suit/armor/pcarrier/navy

/datum/design/item/autotailor/combat/modular_armor/vest_green
	name = "Plate carrier - green"
	id = "vest_green"
	build_path = /obj/item/clothing/suit/armor/pcarrier/green

/datum/design/item/autotailor/combat/modular_armor/vest_tan
	name = "Plate carrier - tan"
	id = "vest_tan"
	build_path = /obj/item/clothing/suit/armor/pcarrier/tan

/datum/design/item/autotailor/combat/modular_armor/vest_blue
	name = "Plate carrier - blue"
	id = "vest_blue"
	build_path = /obj/item/clothing/suit/armor/pcarrier/blue

/datum/design/item/autotailor/combat/modular_armor/chest_light
	name = "Chestplate - light"
	id = "chest_light"
	build_path = /obj/item/clothing/accessory/armorplate
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/modular_armor/chest_med
	name = "Chestplate - medium"
	id = "chest_med"
	build_path = /obj/item/clothing/accessory/armorplate/medium
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "plasteel" = 7000, "osmium-carbide plasteel" = 7000)

/datum/design/item/autotailor/combat/modular_armor/chest_medtan
	name = "Chestplate - medium tan"
	id = "chest_medtan"
	build_path = /obj/item/clothing/accessory/armorplate/tactical
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "plasteel" = 8000, "osmium-carbide plasteel" = 8000)

/datum/design/item/autotailor/combat/modular_armor/chest_heavy
	name = "Chestplate - heavy"
	id = "chest_heavy"
	build_path = /obj/item/clothing/accessory/armorplate/merc
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "plasteel" = 10000, "osmium-carbide plasteel" = 10000)

/datum/design/item/autotailor/combat/modular_armor/arm_black
	name = "Armguards - black"
	id = "arm_black"
	build_path = /obj/item/clothing/accessory/armguards
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/arm_tan
	name = "Armguards - tan"
	id = "arm_tan"
	build_path = /obj/item/clothing/accessory/armguards/tan
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/arm_green
	name = "Armguards - green"
	id = "arm_green"
	build_path = /obj/item/clothing/accessory/armguards/green
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/arm_navy
	name = "Armguards - navy"
	id = "arm_navy"
	build_path = /obj/item/clothing/accessory/armguards/navy
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/arm_blue
	name = "Armguards - blue"
	id = "arm_blue"
	build_path = /obj/item/clothing/accessory/armguards/blue
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/arm_heavy
	name = "Armguards - heavy"
	id = "arm_heavy"
	build_path = /obj/item/clothing/accessory/armguards/merc
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 9000, "osmium-carbide plasteel" = 9000)

/datum/design/item/autotailor/combat/modular_armor/leg_black
	name = "Legguards - black"
	id = "leg_black"
	build_path = /obj/item/clothing/accessory/legguards
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/leg_tan
	name = "Legguards - tan"
	id = "leg_tan"
	build_path = /obj/item/clothing/accessory/legguards/tan
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/leg_green
	name = "Legguards - green"
	id = "leg_green"
	build_path = /obj/item/clothing/accessory/legguards/green
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/leg_navy
	name = "Legguards - navy"
	id = "leg_navy"
	build_path = /obj/item/clothing/accessory/legguards/navy
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/leg_blue
	name = "Legguards - blue"
	id = "leg_blue"
	build_path = /obj/item/clothing/accessory/legguards/blue
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 6000, "osmium-carbide plasteel" = 6000)

/datum/design/item/autotailor/combat/modular_armor/leg_heavy
	name = "Legguards - heavy"
	id = "leg_heavy"
	build_path = /obj/item/clothing/accessory/legguards/merc
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plasteel" = 9000, "osmium-carbide plasteel" = 9000)

/datum/design/item/autotailor/combat/modular_armor/s_store_black
	name = "Storage pouches - small black"
	id = "s_store_black"
	build_path = /obj/item/clothing/accessory/storage/pouches
	materials = list("cloth" = 10000, "leather" = 20000)

/datum/design/item/autotailor/combat/modular_armor/s_store_tan
	name = "Storage pouches - small tan"
	id = "s_store_tan"
	build_path = /obj/item/clothing/accessory/storage/pouches/tan
	materials = list("cloth" = 10000, "leather" = 20000)

/datum/design/item/autotailor/combat/modular_armor/s_store_green
	name = "Storage pouches - small green"
	id = "s_store_green"
	build_path = /obj/item/clothing/accessory/storage/pouches/green
	materials = list("cloth" = 10000, "leather" = 20000)

/datum/design/item/autotailor/combat/modular_armor/s_store_navy
	name = "Storage pouches - small navy "
	id = "s_store_navy"
	build_path = /obj/item/clothing/accessory/storage/pouches/navy
	materials = list("cloth" = 10000, "leather" = 20000)

/datum/design/item/autotailor/combat/modular_armor/s_store_blue
	name = "Storage pouches - small blue"
	id = "s_store_blue"
	build_path = /obj/item/clothing/accessory/storage/pouches/blue
	materials = list("cloth" = 10000, "leather" = 20000)

/datum/design/item/autotailor/combat/modular_armor/l_store_black
	name = "Storage pouches - large black"
	id = "l_store_black"
	build_path = /obj/item/clothing/accessory/storage/pouches/large
	materials = list("cloth" = 20000, "leather" = 40000)

/datum/design/item/autotailor/combat/modular_armor/l_store_tan
	name = "Storage pouches - large tan"
	id = "l_store_tan"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/tan
	materials = list("cloth" = 20000, "leather" = 40000)

/datum/design/item/autotailor/combat/modular_armor/l_store_green
	name = "Storage pouches - large green"
	id = "l_store_green"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/green
	materials = list("cloth" = 20000, "leather" = 40000)

/datum/design/item/autotailor/combat/modular_armor/l_store_navy
	name = "Storage pouches - large navy "
	id = "l_store_navy"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/navy
	materials = list("cloth" = 20000, "leather" = 40000)

/datum/design/item/autotailor/combat/modular_armor/l_store_blue
	name = "Storage pouches - large blue"
	id = "l_store_blue"
	build_path = /obj/item/clothing/accessory/storage/pouches/large/blue
	materials = list("cloth" = 20000, "leather" = 40000)

/datum/design/item/autotailor/combat/modular_armor/tag_red
	name = "Accessory - red tag"
	id = "tag_red"
	build_path = /obj/item/clothing/accessory/armor/tag/nt
	materials = list(DEFAULT_WALL_MATERIAL = 500, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/tag_blue
	name = "Accessory - blue tag"
	id = "tag_blue"
	build_path = /obj/item/clothing/accessory/armor/tag/pcrc
	materials = list(DEFAULT_WALL_MATERIAL = 500, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/tag_green
	name = "Accessory - green tag"
	id = "tag_green"
	build_path = /obj/item/clothing/accessory/armor/tag/saare
	materials = list(DEFAULT_WALL_MATERIAL = 500, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/tag_white
	name = "Accessory - white tag"
	id = "tag_white"
	build_path = /obj/item/clothing/accessory/armor/tag/press
	materials = list(DEFAULT_WALL_MATERIAL = 500, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/apos_tag
	name = "Accessory - A+ tag"
	id = "apos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/apos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/aneg_tag
	name = "Accessory - A- tag"
	id = "aneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/aneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/abpos_tag
	name = "Accessory - AB+ tag "
	id = "abpos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/abpos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/abneg_tag
	name = "Accessory - AB- tag"
	id = "abneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/abneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/bpos_tag
	name = "Accessory - B+ tag"
	id = "bpos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/bpos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/bneg_tag
	name = "Accessory - B- tag"
	id = "bneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/bneg
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/opos_tag
	name = "Accessory - O+ tag"
	id = "opos_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/opos
	materials = list("cloth" = 1000, "plastic" = 500)

/datum/design/item/autotailor/combat/modular_armor/oneg_tag
	name = "Accessory - O- tag"
	id = "oneg_tag"
	build_path = /obj/item/clothing/accessory/armor/tag/oneg
	materials = list("cloth" = 1000, "plastic" = 500)

//
//accessories
//
/datum/design/item/autotailor/combat/accessory
	category = "Tactical accessories"

/datum/design/item/autotailor/combat/accessory/bandolier_access
	name = "Accessory - bandolier"
	id = "bandolier_access"
	build_path = /obj/item/clothing/accessory/storage/bandolier
	materials = list("leather" = 30000)

/datum/design/item/autotailor/combat/accessory/holster_waist
	name = "Holster - waist"
	id = "holster_waist"
	build_path = /obj/item/clothing/accessory/holster/waist
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/holster_arm
	name = "Holster - armpit"
	id = "holster_arm"
	build_path = /obj/item/clothing/accessory/holster/armpit
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/holster_hip
	name = "Holster - hip"
	id = "holster_hip"
	build_path = /obj/item/clothing/accessory/holster/hip
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/holster_thigh
	name = "Holster - thigh"
	id = "holster_thigh"
	build_path = /obj/item/clothing/accessory/holster/thigh
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/holster_machete
	name = "Holster - machete"
	id = "holster_machete"
	build_path = /obj/item/clothing/accessory/holster/machete
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/holster_knife
	name = "Dectroated harness - knife"
	id = "holster_knife"
	build_path = /obj/item/clothing/accessory/storage/knifeharness
	materials = list("leather" = 30000, DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/autotailor/combat/accessory/access_ubac_bla
	name = "Accessory - black ubac"
	id = "access_ubac_bla"
	build_path = /obj/item/clothing/accessory/ubac
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/combat/accessory/access_ubac_blue
	name = "Accessory - blue ubac"
	id = "access_ubac_blue"
	build_path = /obj/item/clothing/accessory/ubac/blue
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/combat/accessory/access_ubac_tan
	name = "Accessory - tan ubac"
	id = "access_ubac_tan"
	build_path = /obj/item/clothing/accessory/ubac/tan
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/combat/accessory/access_ubac_green
	name = "Accessory - green ubac"
	id = "access_ubac_green"
	build_path = /obj/item/clothing/accessory/ubac/green
	materials = list("cloth" = 2000)

/datum/design/item/autotailor/combat/accessory/holobadge
	name = "Holobadge - security"
	id = "holobadge"
	build_path = /obj/item/clothing/accessory/badge/holo
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holotag
	name = "Holobadge tags - security"
	id = "holotag"
	build_path = /obj/item/clothing/accessory/badge/holo/cord
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holobadge_det
	name = "Holobadge - detective"
	id = "holobadge_det"
	build_path = /obj/item/clothing/accessory/badge/defenseintel
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holobadge_det_old
	name = "Holobadge old - detective"
	id = "holobadge_det_old"
	build_path = /obj/item/clothing/accessory/badge/old
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holobadge_marshal
	name = "Holobadge - marshal"
	id = "holobadge_marshal"
	build_path = /obj/item/clothing/accessory/badge/marshal
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holotag_det
	name = "Holotag - detective"
	id = "holotag_det"
	build_path = /obj/item/clothing/accessory/badge
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holotag_agent
	name = "Holotag - agent"
	id = "holotag_agent"
	build_path = /obj/item/clothing/accessory/badge/interstellarintel
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holotag_press
	name = "Holotag - press"
	id = "holotag_press"
	build_path = /obj/item/clothing/accessory/badge/press
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

/datum/design/item/autotailor/combat/accessory/holotag_nt	//nt item
	name = "Holotag - NT"
	id = "holotag_nt"
	build_path = /obj/item/clothing/accessory/badge/nanotrasen
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "phoron" = 2000)

//
//restraints
//
/datum/design/item/autotailor/combat/restaint
	category = "Restraints"

/datum/design/item/autotailor/combat/restaint/straitjacket
	name = "Straitjacket"
	id = "straitjacket"
	build_path = /obj/item/clothing/suit/straight_jacket
	materials = list("leather" = 120000)

/datum/design/item/autotailor/combat/restaint/muzzle
	name = "Muzzle"
	id = "muzzle"
	build_path = /obj/item/clothing/mask/muzzle
	materials = list("cloth" = 1000)

/datum/design/item/autotailor/combat/restaint/blindfold
	name = "Blindfold"
	id = "blindfold"
	build_path = /obj/item/clothing/glasses/sunglasses/blindfold
	materials = list("cloth" = 1000)

/datum/design/item/autotailor/combat/restaint/facecover
	name = "Face cover"
	id = "facecover"
	build_path = /obj/item/clothing/head/helmet/facecover
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "plastic" = 1000)