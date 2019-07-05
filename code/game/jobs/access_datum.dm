/datum/access
	var/id = ""
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/dd_SortValue()
	return "[access_type][desc]"

/*****************
* Station access *
*****************/
/var/const/access_security = "ACCESS_SECURITY" //1
/datum/access/security
	id = access_security
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

/var/const/access_brig = "ACCESS_BRIG" // Brig timers and permabrig 2
/datum/access/holding
	id = access_brig
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

/var/const/access_armory = "ACCESS_ARMORY" //3
/datum/access/armory
	id = access_armory
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/var/const/access_forensics_lockers = "ACCESS_FORENSICS" //4
/datum/access/forensics_lockers
	id = access_forensics_lockers
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

/var/const/access_medical = "ACCESS_MEDICAL" //5
/datum/access/medical
	id = access_medical
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/var/const/access_morgue = "ACCESS_MORGUE" //6
/datum/access/morgue
	id = access_morgue
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

/var/const/access_tox = "ACCESS_TOXINS" //7
/datum/access/tox
	id = access_tox
	desc = "Research Labs"
	region = ACCESS_REGION_RESEARCH

/var/const/access_tox_storage = "ACCESS_TOX_STORAGE" //8
/datum/access/tox_storage
	id = access_tox_storage
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/access_genetics = "ACCESS_GENETICS" //9
/datum/access/genetics
	id = access_genetics
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_engine = "ACCESS_ENGINEERING" //10
/datum/access/engine
	id = access_engine
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_engine_equip = "ACCESS_ENGINE_EQUIP" //11
/datum/access/engine_equip
	id = access_engine_equip
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_maint_tunnels = "ACCESS_MAINT" //12
/datum/access/maint_tunnels
	id = access_maint_tunnels
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_external_airlocks = "ACCESS_EXTERNAL" //13
/datum/access/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_emergency_storage = "ACCESS_EMERGENCY_STORAGE" //14
/datum/access/emergency_storage
	id = access_emergency_storage
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_change_ids = "ACCESS_CHANGE_ID" //15
/datum/access/change_ids
	id = access_change_ids
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

/var/const/access_ai_upload = "ACCESS_AI_UPLOAD" //16
/datum/access/ai_upload
	id = access_ai_upload
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

/var/const/access_teleporter = "ACCESS_TELEPORTER" //17
/datum/access/teleporter
	id = access_teleporter
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/var/const/access_eva = "ACCESS_EVA" //18
/datum/access/eva
	id = access_eva
	desc = "EVA"
	region = ACCESS_REGION_COMMAND



/var/const/access_heads = "ACCESS_HEADS" //19
/datum/access/heads
	id = access_heads
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/var/const/access_captain = 83
/datum/access/captain
	id = access_captain
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/var/const/access_all_personal_lockers = 84
/datum/access/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/var/const/access_chapel_office = 85
/datum/access/chapel_office
	id = access_chapel_office
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/var/const/access_tech_storage = 86
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_atmospherics = 87
/datum/access/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_bar = 88
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/var/const/access_janitor = 89
/datum/access/janitor
	id = access_janitor
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/var/const/access_crematorium = 90
/datum/access/crematorium
	id = access_crematorium
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/var/const/access_kitchen = 91
/datum/access/kitchen
	id = access_kitchen
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

/var/const/access_robotics = 92
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/var/const/access_rd = 93
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/var/const/access_cargo = 94
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/var/const/access_construction = 95
/datum/access/construction
	id = access_construction
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_chemistry = 96
/datum/access/chemistry
	id = access_chemistry
	desc = "Chemistry Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_cargo_bot = 97
/datum/access/cargo_bot
	id = access_cargo_bot
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/var/const/access_hydroponics = 98
/datum/access/hydroponics
	id = access_hydroponics
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/var/const/access_manufacturing = 99
/datum/access/manufacturing
	id = access_manufacturing
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

/var/const/access_library = 100
/datum/access/library
	id = access_library
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/var/const/access_lawyer = 101
/datum/access/lawyer
	id = access_lawyer
	desc = "Internal Affairs"
	region = ACCESS_REGION_COMMAND

/var/const/access_virology = 102
/datum/access/virology
	id = access_virology
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/var/const/access_cmo = 103
/datum/access/cmo
	id = access_cmo
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/var/const/access_qm = 104
/datum/access/qm
	id = access_qm
	desc = "Quartermaster"
	region = ACCESS_REGION_SUPPLY

/var/const/access_network = 105
/datum/access/network
	id = access_network
	desc = "Primary Network"
	region = ACCESS_REGION_RESEARCH

// /var/const/free_access_id = 106
// /var/const/free_access_id = 107

/var/const/access_surgery = 108
/datum/access/surgery
	id = access_surgery
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 46

/var/const/access_research = 109
/datum/access/research
	id = access_research
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/var/const/access_mining = 110
/datum/access/mining
	id = access_mining
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/var/const/access_mining_office = 111
/datum/access/mining_office
	id = access_mining_office
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

/var/const/access_mailsorting = 112
/datum/access/mailsorting
	id = access_mailsorting
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 113
// /var/const/free_access_id = 114

/var/const/access_heads_vault = 115
/datum/access/heads_vault
	id = access_heads_vault
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

/var/const/access_mining_station = 116
/datum/access/mining_station
	id = access_mining_station
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

/var/const/access_xenobiology = 117
/datum/access/xenobiology
	id = access_xenobiology
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/access_ce = 118
/datum/access/ce
	id = access_ce
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_hop = 119
/datum/access/hop
	id = access_hop
	desc = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

/var/const/access_hos = 120
/datum/access/hos
	id = access_hos
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_RC_announce = 121 //Request console announcements
/datum/access/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/var/const/access_keycard_auth = 122 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

/var/const/access_tcomsat = 123 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = access_tcomsat
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

/var/const/access_gateway = 124
/datum/access/gateway
	id = access_gateway
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

/var/const/access_sec_doors = 125 // Security front doors
/datum/access/sec_doors
	id = access_sec_doors
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_psychiatrist = 126 // Psychiatrist's office
/datum/access/psychiatrist
	id = access_psychiatrist
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/var/const/access_xenoarch = 127
/datum/access/xenoarch
	id = access_xenoarch
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/var/const/access_medical_equip = 128
/datum/access/medical_equip
	id = access_medical_equip
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/******************
* Central Command *
******************/
/var/const/access_cent_general = 201//General facilities.
/datum/access/cent_general
	id = access_cent_general
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_thunder = 202//Thunderdome.
/datum/access/cent_thunder
	id = access_cent_thunder
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_specops = 203//Special Ops.
/datum/access/cent_specops
	id = access_cent_specops
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_medical = 204//Medical/Research
/datum/access/cent_medical
	id = access_cent_medical
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_living = 205//Living quarters.
/datum/access/cent_living
	id = access_cent_living
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_storage = 206//Generic storage areas.
/datum/access/cent_storage
	id = access_cent_storage
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_teleporter = 207//Teleporter.
/datum/access/cent_teleporter
	id = access_cent_teleporter
	desc = "Code Blue"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_creed = 208//Creed's office.
/datum/access/cent_creed
	id = access_cent_creed
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_cent_captain = 209//Captain's office/ID comp/AI.
/datum/access/cent_captain
	id = access_cent_captain
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/***************
* Antag access *
***************/
/var/const/access_syndicate = 250//General Syndicate Access
/datum/access/syndicate
	id = access_syndicate
	desc = "Syndicate"
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
/var/const/access_synth = 299
/datum/access/synthetic
	id = access_synth
	desc = "Synthetic"
	access_type = ACCESS_TYPE_NONE

/var/const/access_crate_cash = 300
/datum/access/crate_cash
	id = access_crate_cash
	desc = "Crate cash"
	access_type = ACCESS_TYPE_NONE

/var/const/access_merchant = 301
/datum/access/merchant
	id = access_merchant
	desc = "Merchant"
	access_type = ACCESS_TYPE_NONE
