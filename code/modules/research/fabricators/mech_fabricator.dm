/obj/machinery/fabricator/mecha_part_fabricator
	name = "Exosuit Fabricator"
	desc = "A machine used for construction of robotics and mechas."
	req_access = list(core_access_science_programs)
	circuit = /obj/item/weapon/circuitboard/fabricator/mechfab
	build_type = MECHFAB
	
/obj/machinery/fabricator/mecha_part_fabricator/can_connect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	if(M && !has_access(list(core_access_machine_linking), list(), M.GetAccess(trying.uid)))
		to_chat(M, "You do not have access to link machines to [trying.name].")
		return 0
	if(limits.limit_mechfab <= limits.mechfabs.len)
		if(M)
			to_chat(M, "[trying.name] cannot connect any more machines of this type.")
		return 0
	limits.mechfabs |= src
	req_access_faction = trying.uid
	connected_faction = trying
	
/obj/machinery/fabricator/mecha_part_fabricator/can_disconnect(var/datum/world_faction/trying, var/mob/M)
	var/datum/machine_limits/limits = trying.get_limits()
	limits.mechfabs -= src
	req_access_faction = ""
	connected_faction = null
	if(M) to_chat(M, "The machine has been disconnected.")
	

////////////////////////////////////////////////////
//////////////////////DESIGNS///////////////////////
////////////////////////////////////////////////////

/datum/design/item/mechfab
	build_type = MECHFAB
	category = "Misc"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/robot
	category = "Robot"

/datum/design/item/mechfab/robot/exoskeleton
	name = "Robot exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(MATERIAL_STEEL = 50000)

/datum/design/item/mechfab/robot/torso
	name = "Robot torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(MATERIAL_STEEL = 40000)

/datum/design/item/mechfab/robot/head
	name = "Robot head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/robot/l_arm
	name = "Robot left arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(MATERIAL_STEEL = 18000)

/datum/design/item/mechfab/robot/r_arm
	name = "Robot right arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(MATERIAL_STEEL = 18000)

/datum/design/item/mechfab/robot/l_leg
	name = "Robot left leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/robot/r_leg
	name = "Robot right leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/robot/component
	time = 20
	materials = list(MATERIAL_STEEL = 5000)

/datum/design/item/mechfab/robot/component/binary_communication_device
	name = "Binary communication device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/mechfab/robot/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/mechfab/robot/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/mechfab/robot/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/mechfab/robot/component/armour
	name = "Armour plating"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design/item/mechfab/ripley
	category = "Ripley"

/datum/design/item/mechfab/ripley/chassis
	name = "Ripley chassis"
	id = "ripley_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley
	time = 10
	materials = list(MATERIAL_STEEL = 20000)

/datum/design/item/mechfab/ripley/chassis/firefighter
	name = "Firefigher chassis"
	id = "firefighter_chassis"
	build_path = /obj/item/mecha_parts/chassis/firefighter

/datum/design/item/mechfab/ripley/torso
	name = "Ripley torso"
	id = "ripley_torso"
	build_path = /obj/item/mecha_parts/part/ripley_torso
	time = 20
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_GLASS = 15000)

/datum/design/item/mechfab/ripley/left_arm
	name = "Ripley left arm"
	id = "ripley_left_arm"
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	time = 15
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/ripley/right_arm
	name = "Ripley right arm"
	id = "ripley_right_arm"
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	time = 15
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/ripley/left_leg
	name = "Ripley left leg"
	id = "ripley_left_leg"
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	time = 15
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/mechfab/ripley/right_leg
	name = "Ripley right leg"
	id = "ripley_right_leg"
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	time = 15
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/mechfab/odysseus
	category = "Odysseus"

/datum/design/item/mechfab/odysseus/chassis
	name = "Odysseus chassis"
	id = "odysseus_chassis"
	build_path = /obj/item/mecha_parts/chassis/odysseus
	time = 10
	materials = list(MATERIAL_STEEL = 20000)

/datum/design/item/mechfab/odysseus/torso
	name = "Odysseus torso"
	id = "odysseus_torso"
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	time = 18
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/odysseus/head
	name = "Odysseus head"
	id = "odysseus_head"
	build_path = /obj/item/mecha_parts/part/odysseus_head
	time = 10
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 10000)

/datum/design/item/mechfab/odysseus/left_arm
	name = "Odysseus left arm"
	id = "odysseus_left_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	time = 12
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/mechfab/odysseus/right_arm
	name = "Odysseus right arm"
	id = "odysseus_right_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	time = 12
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/mechfab/odysseus/left_leg
	name = "Odysseus left leg"
	id = "odysseus_left_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	time = 13
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/odysseus/right_leg
	name = "Odysseus right leg"
	id = "odysseus_right_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	time = 13
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/gygax
	category = "Gygax"

/datum/design/item/mechfab/gygax/chassis
	name = "Gygax chassis"
	id = "gygax_chassis"
	build_path = /obj/item/mecha_parts/chassis/gygax
	time = 10
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/gygax/torso
	name = "Gygax torso"
	id = "gygax_torso"
	build_path = /obj/item/mecha_parts/part/gygax_torso
	time = 30
	materials = list(MATERIAL_STEEL = 50000, MATERIAL_GLASS = 20000)

/datum/design/item/mechfab/gygax/head
	name = "Gygax head"
	id = "gygax_head"
	build_path = /obj/item/mecha_parts/part/gygax_head
	time = 20
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GLASS = 10000)

/datum/design/item/mechfab/gygax/left_arm
	name = "Gygax left arm"
	id = "gygax_left_arm"
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	time = 20
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/mechfab/gygax/right_arm
	name = "Gygax right arm"
	id = "gygax_right_arm"
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	time = 20
	materials = list(MATERIAL_STEEL = 30000)

/datum/design/item/mechfab/gygax/left_leg
	name = "Gygax left leg"
	id = "gygax_left_leg"
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	time = 20
	materials = list(MATERIAL_STEEL = 35000)

/datum/design/item/mechfab/gygax/right_leg
	name = "Gygax right leg"
	id = "gygax_right_leg"
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	time = 20
	materials = list(MATERIAL_STEEL = 35000)

/datum/design/item/mechfab/gygax/armour
	name = "Gygax armour plates"
	id = "gygax_armour"
	build_path = /obj/item/mecha_parts/part/gygax_armour
	time = 60
	materials = list(MATERIAL_STEEL = 50000, MATERIAL_DIAMOND = 10000)

/datum/design/item/mechfab/durand
	category = "Durand"

/datum/design/item/mechfab/durand/chassis
	name = "Durand chassis"
	id = "durand_chassis"
	build_path = /obj/item/mecha_parts/chassis/durand
	time = 10
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/durand/torso
	name = "Durand torso"
	id = "durand_torso"
	build_path = /obj/item/mecha_parts/part/durand_torso
	time = 30
	materials = list(MATERIAL_STEEL = 55000, MATERIAL_GLASS = 20000, MATERIAL_SILVER = 10000)

/datum/design/item/mechfab/durand/head
	name = "Durand head"
	id = "durand_head"
	build_path = /obj/item/mecha_parts/part/durand_head
	time = 20
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 10000, MATERIAL_SILVER = 3000)

/datum/design/item/mechfab/durand/left_arm
	name = "Durand left arm"
	id = "durand_left_arm"
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	time = 20
	materials = list(MATERIAL_STEEL = 35000, MATERIAL_SILVER = 3000)

/datum/design/item/mechfab/durand/right_arm
	name = "Durand right arm"
	id = "durand_right_arm"
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	time = 20
	materials = list(MATERIAL_STEEL = 35000, MATERIAL_SILVER = 3000)

/datum/design/item/mechfab/durand/left_leg
	name = "Durand left leg"
	id = "durand_left_leg"
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	time = 20
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_SILVER = 3000)

/datum/design/item/mechfab/durand/right_leg
	name = "Durand right leg"
	id = "durand_right_leg"
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	time = 20
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_SILVER = 3000)

/datum/design/item/mechfab/durand/armour
	name = "Durand armour plates"
	id = "durand_armour"
	build_path = /obj/item/mecha_parts/part/durand_armour
	time = 60
	materials = list(MATERIAL_STEEL = 50000, MATERIAL_URANIUM = 10000)

///////////////////////////////////
////////// Roboot Upgrade /////////
///////////////////////////////////

/datum/design/item/robot_upgrade
	build_type = MECHFAB
	time = 12
	materials = list(MATERIAL_STEEL = 10000)
	category = "Cyborg Upgrade Modules"

/datum/design/item/robot_upgrade/rename
	name = "Rename module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/rename

/datum/design/item/robot_upgrade/reset
	name = "Reset module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/reset

/datum/design/item/robot_upgrade/floodlight
	name = "Floodlight module"
	desc = "Used to boost cyborg's integrated light intensity."
	id = "borg_floodlight_module"
	build_path = /obj/item/borg/upgrade/floodlight

/datum/design/item/robot_upgrade/restart
	name = "Emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials = list(MATERIAL_STEEL = 60000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/item/robot_upgrade/vtec
	name = "VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/item/robot_upgrade/tasercooler
	name = "Rapid taser cooling module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/borg/upgrade/tasercooler

/datum/design/item/robot_upgrade/jetpack
	name = "Jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PHORON = 5000, MATERIAL_URANIUM = 20000)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/design/item/robot_upgrade/rcd
	name = "RCD module"
	desc = "A rapid construction device module for use during construction operations."
	id = "borg_rcd_module"
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_PHORON = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/borg/upgrade/rcd

/datum/design/item/robot_upgrade/syndicate
	name = "Illegal upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 15000, MATERIAL_PHORON = 1000, MATERIAL_DIAMOND = 10000)
	build_path = /obj/item/borg/upgrade/syndicate

// PERSISTENT ROBOT UPGRADES


//////////////////////////////////
///////////CHASSIS MOD////////////////////
////////////////////////////////////
/datum/design/item/robot_upgrade/chassis
	category = "Chassis Mods"
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_SILVER = 5000, MATERIAL_GLASS = 6000)
	desc = "A chassis mod that can be installed in a cyborg to allow it to change its appearance. It must be using the correct module."

//////////////
// Standard

/datum/design/item/robot_upgrade/chassis/droid
	name = "Standard Chassis: Droid"
	id = "borg_chassis_droid"
	build_path = /obj/item/borg/chassis_mod/standard/droid

/datum/design/item/robot_upgrade/chassis/old
	name = "Standard Chassis: Bipedal Standard"
	id = "borg_chassis_old"
	build_path = /obj/item/borg/chassis_mod/standard/old

/datum/design/item/robot_upgrade/chassis/drone
	name = "Standard Chassis: Drone"
	id = "borg_chassis_drone"
	build_path = /obj/item/borg/chassis_mod/standard/drone

/datum/design/item/robot_upgrade/chassis/eyebot
	name = "Standard Chassis: Eyebot"
	id = "borg_chassis_eyebot"
	build_path = /obj/item/borg/chassis_mod/standard/eyebot

//////////////
// Service/Clerical

/datum/design/item/robot_upgrade/chassis/waitress
	name = "Service/Clerical Chassis: Waitress"
	id = "borg_chassis_waitress"
	build_path = /obj/item/borg/chassis_mod/service/waitress

/datum/design/item/robot_upgrade/chassis/bro
	name = "Service/Clerical Chassis: Brobot"
	id = "borg_chassis_bro"
	build_path = /obj/item/borg/chassis_mod/service/bro

/datum/design/item/robot_upgrade/chassis/fountainbot
	name = "Service/Clerical Chassis: Fountain-head"
	id = "borg_chassis_fountain"
	build_path = /obj/item/borg/chassis_mod/service/fountainbot

/datum/design/item/robot_upgrade/chassis/poshbot
	name = "Service/Clerical Chassis: Poshbot"
	id = "borg_chassis_posh"
	build_path = /obj/item/borg/chassis_mod/service/poshbot

/datum/design/item/robot_upgrade/chassis/waiterbot
	name = "Service/Clerical Chassis: Waiter"
	id = "borg_chassis_waiter"
	build_path = /obj/item/borg/chassis_mod/service/waiterbot

/datum/design/item/robot_upgrade/chassis/serviceeeybot
	name = "Service/Clerical Chassis: Service Eyebot"
	id = "borg_chassis_serviceye"
	build_path = /obj/item/borg/chassis_mod/service/serviceeyebot

////////////
// Mining Chassis

/datum/design/item/robot_upgrade/chassis/minereyebot
	name = "Mining Chassis: Miner Eyebot"
	id = "borg_chassis_minereye"
	build_path = /obj/item/borg/chassis_mod/mining/minereyebot

/datum/design/item/robot_upgrade/chassis/minerbipedal
	name = "Mining Chassis: Bipedal Miner"
	id = "borg_chassis_minerbipedal"
	build_path = /obj/item/borg/chassis_mod/mining/minerbipedal

/datum/design/item/robot_upgrade/chassis/advancedminer
	name = "Mining Chassis: Advanced Miner"
	id = "borg_chassis_advancedminer"
	build_path = /obj/item/borg/chassis_mod/mining/advancedminer

/datum/design/item/robot_upgrade/chassis/treadhead
	name = "Mining Chassis: Treadhead Miner"
	id = "borg_chassis_treadheadminer"
	build_path = /obj/item/borg/chassis_mod/mining/treadhead

/////////////
// Medical Chassis

/datum/design/item/robot_upgrade/chassis/bipedmedic
	name = "Mining Chassis: Bipedal Medical Cyborg"
	id = "borg_chassis_bipedmedical"
	build_path = /obj/item/borg/chassis_mod/medical/bipedmedic

/datum/design/item/robot_upgrade/chassis/surgicalbot
	name = "Mining Chassis: Surgical Cyborg"
	id = "borg_chassis_surgeon"
	build_path = /obj/item/borg/chassis_mod/medical/surgicalbot

/datum/design/item/robot_upgrade/chassis/doctorneedles
	name = "Mining Chassis: Doctor Needles"
	id = "borg_chassis_drneedles"
	build_path = /obj/item/borg/chassis_mod/medical/doctorneedles

/datum/design/item/robot_upgrade/chassis/medicaleyebot
	name = "Mining Chassis: Medical Eyebot"
	id = "borg_chassis_medicaleyebot"
	build_path = /obj/item/borg/chassis_mod/medical/medicaleyebot

////////////////
// Security Chassis

/datum/design/item/robot_upgrade/chassis/bipedalsecurity
	name = "Security Chassis: Bipedal Security Cyborg"
	id = "borg_chassis_bipedsecurity"
	build_path = /obj/item/borg/chassis_mod/security/bipedalsecurity

/datum/design/item/robot_upgrade/chassis/redknight
	name = "Security Chassis: Red Knight Cyborg Model"
	id = "borg_chassis_redknight"
	build_path = /obj/item/borg/chassis_mod/security/redknight

/datum/design/item/robot_upgrade/chassis/protector
	name = "Security Chassis: Protector Cyborg Model"
	id = "borg_chassis_protector"
	build_path = /obj/item/borg/chassis_mod/security/protector

/datum/design/item/robot_upgrade/chassis/bloodhound
	name = "Security Chassis: Bloodhound Cyborg Model"
	id = "borg_chassis_bloodhound"
	build_path = /obj/item/borg/chassis_mod/security/bloodhound

/datum/design/item/robot_upgrade/chassis/treadedsecurity
	name = "Security Chassis: Treaded Bloodhound"
	id = "borg_chassis_treadedsecurity"
	build_path = /obj/item/borg/chassis_mod/security/treaded

/datum/design/item/robot_upgrade/chassis/securityeyebot
	name = "Security Chassis: Security Eyebot"
	id = "borg_chassis_seceye"
	build_path = /obj/item/borg/chassis_mod/security/securityeyebot

/datum/design/item/robot_upgrade/chassis/tridroid
	name = "Security Chassis: Tridroid Cyborg Model"
	id = "borg_chassis_tridroid"
	build_path = /obj/item/borg/chassis_mod/security/tridroid

///////////////
// Engineering Chassis

/datum/design/item/robot_upgrade/chassis/bipedalengineer
	name = "Engineering Chassis: Bipedal Engineering Cyborg"
	id = "borg_chassis_engibiped"
	build_path = /obj/item/borg/chassis_mod/engineering/bipedalengineer

/datum/design/item/robot_upgrade/chassis/antique
	name = "Engineering Chassis: Outdated Engineer"
	id = "borg_chassis_antique"
	build_path = /obj/item/borg/chassis_mod/engineering/antique

/datum/design/item/robot_upgrade/chassis/landmate
	name = "Engineering Chassis: Landmate Model"
	id = "borg_chassis_landmate"
	build_path = /obj/item/borg/chassis_mod/engineering/landmate

/datum/design/item/robot_upgrade/chassis/treads
	name = "Engineering Chassis: Treaded Landmate"
	id = "borg_chassis_landmatetread"
	build_path = /obj/item/borg/chassis_mod/engineering/treads

/datum/design/item/robot_upgrade/chassis/eyebotengineering
	name = "Engineering Chassis: Engineering Eyebot"
	id = "borg_chassis_engieye"
	build_path = /obj/item/borg/chassis_mod/engineering/eyebotengineering

///////////////
// Janitor Chassis

/datum/design/item/robot_upgrade/chassis/bipedaljanitor
	name = "Janitor Chassis: Bipedal Janitor Cyborg"
	id = "borg_chassis_janitbiped"
	build_path = /obj/item/borg/chassis_mod/janitor/bipedaljanitor

/datum/design/item/robot_upgrade/chassis/buckethead
	name = "Janitor Chassis: Bucket-head Janitor"
	id = "borg_chassis_buckethead"
	build_path = /obj/item/borg/chassis_mod/janitor/buckethead

/datum/design/item/robot_upgrade/chassis/mopgearrex
	name = "Janitor Chassis: MOP GEAR R.E.X"
	id = "borg_chassis_rex"
	build_path = /obj/item/borg/chassis_mod/janitor/mopgearrex

/datum/design/item/robot_upgrade/chassis/bipedaljanitor
	name = "Janitor Chassis: Bipedal Janitor Cyborg"
	id = "borg_chassis_janitbiped"
	build_path = /obj/item/borg/chassis_mod/janitor/bipedaljanitor

/////////////
// Science Chassis

/datum/design/item/robot_upgrade/chassis/sciencedroid
	name = "Research Chassis: Science Droid"
	id = "borg_chassis_scidroid"
	build_path = /obj/item/borg/chassis_mod/science/sciencedroid

/datum/design/item/robot_upgrade/chassis/scienceeyebot
	name = "Research Chassis: Science Eyebot"
	id = "borg_chassis_scieye"
	build_path = /obj/item/borg/chassis_mod/science/scienceeyebot

////////////////////////////////////////////////////
//////////////////////MODULE CHIPS//////////////////
////////////////////////////////////////////////////

/datum/design/item/robot_upgrade/module
	category = "Cyborg Modules"
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_PHORON = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 1000)
	desc = "A module that contains tools and equipment that the cyborg can use."

/datum/design/item/robot_upgrade/module/standard
	name = "Module Chip: Standard"
	id = "borg_module_standard"
	build_path = /obj/item/borg/module_chip/standard
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 7500, MATERIAL_PHORON = 1500, MATERIAL_GOLD = 2500, MATERIAL_SILVER = 2500)

/datum/design/item/robot_upgrade/module/surgeon
	name = "Module Chip: Medical Surgeon"
	id = "borg_module_surgeon"
	build_path = /obj/item/borg/module_chip/medical/surgeon
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000)

/datum/design/item/robot_upgrade/module/crisis
	name = "Module Chip: Medical Crisis"
	id = "borg_module_crisis"
	build_path = /obj/item/borg/module_chip/medical
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000)

/datum/design/item/robot_upgrade/module/engineering
	name = "Module Chip: Engineering"
	id = "borg_module_engineering"
	build_path = /obj/item/borg/module_chip/engineering
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 500, MATERIAL_GOLD = 3000, MATERIAL_SILVER = 2000)

/datum/design/item/robot_upgrade/module/security
	name = "Module Chip: Security"
	id = "borg_module_security"
	build_path = /obj/item/borg/module_chip/security
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 5000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 2000)

/datum/design/item/robot_upgrade/module/mining
	name = "Module Chip: Mining"
	id = "borg_module_mining"
	build_path = /obj/item/borg/module_chip/mining
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, MATERIAL_URANIUM = 500)

/datum/design/item/robot_upgrade/module/research
	name = "Module Chip: Research"
	id = "borg_module_research"
	build_path = /obj/item/borg/module_chip/research
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, MATERIAL_PHORON = 2000, MATERIAL_GOLD = 500, MATERIAL_SILVER = 500)

/datum/design/item/robot_upgrade/module/janitor
	name = "Module Chip: Janitor"
	id = "borg_module_janitor"
	build_path = /obj/item/borg/module_chip/janitor
	materials = list(MATERIAL_STEEL = 12000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 500, MATERIAL_SILVER = 500)

/datum/design/item/robot_upgrade/module/clerical
	name = "Module Chip: Clerical"
	id = "borg_module_clerical"
	build_path = /obj/item/borg/module_chip/clerical
	materials = list(MATERIAL_STEEL = 12000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 500, MATERIAL_SILVER = 500)

/datum/design/item/robot_upgrade/module/service
	name = "Module Chip: Service"
	id = "borg_module_service"
	build_path = /obj/item/borg/module_chip/service
	materials = list(MATERIAL_STEEL = 12000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 500, MATERIAL_SILVER = 500)




/datum/design/item/mecha_tracking
	name = "Exosuit tracking beacon"
	build_type = MECHFAB
	time = 5
	materials = list(MATERIAL_STEEL = 500)
	build_path = /obj/item/mecha_parts/mecha_tracking
	category = "Misc"

/datum/design/item/mecha
	build_type = MECHFAB
	category = "Exosuit Equipment"
	time = 10
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

/datum/design/item/mecha/hydraulic_clamp
	name = "Hydraulic clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/item/mecha/drill
	name = "Drill"
	id = "mech_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill

/datum/design/item/mecha/cable_layer
	name = "Cable layer"
	id = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer

/datum/design/item/mecha/flaregun
	name = "Flare launcher"
	id = "mecha_flare_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	materials = list(MATERIAL_STEEL = 12500)

/datum/design/item/mecha/sleeper
	name = "Sleeper"
	id = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 10000)

/datum/design/item/mecha/syringe_gun
	name = "Syringe gun"
	id = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	time = 20
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 2000)

/*
/datum/design/item/mecha/syringe_gun
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_MAGNET = 4, TECH_DATA = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	*/

/datum/design/item/mecha/passenger
	name = "Passenger compartment"
	id = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 5000)

//obj/item/mecha_parts/mecha_equipment/repair_droid,
//obj/item/mecha_parts/mecha_equipment/jetpack, //TODO MECHA JETPACK SPRITE MISSING

/datum/design/item/mecha/taser
	name = "PBT \"Pacifier\" mounted taser"
	id = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design/item/mecha/lmg
	name = "Ultra AC 2"
	id = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design/item/mecha/weapon
	req_tech = list(TECH_COMBAT = 3)

// *** Weapon modules
/datum/design/item/mecha/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
/*
/datum/design/item/mecha/weapon/laser
	name = "CH-PS \"Immolator\" laser"
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
*/
/datum/design/item/mecha/weapon/laser_rigged
	name = "Jury-rigged welder-laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
/*
/datum/design/item/mecha/weapon/laser_heavy
	name = "CH-LC \"Solaris\" laser cannon"
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
*/
/datum/design/item/mecha/weapon/ion
	name = "mkIV ion heavy cannon"
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/item/mecha/weapon/grenade_launcher
	name = "SGL-6 grenade launcher"
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

/datum/design/item/mecha/weapon/clusterbang_launcher
	name = "SOP-6 grenade launcher"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GOLD = 6000, MATERIAL_URANIUM = 6000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited

// *** Nonweapon modules
/datum/design/item/mecha/wormhole_gen
	name = "Wormhole generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/item/mecha/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter
/**
/datum/design/item/mecha/rcd
	name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	time = 120
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_PHORON = 25000, MATERIAL_SILVER = 20000, MATERIAL_GOLD = 20000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd
**/
/datum/design/item/mecha/gravcatapult
	name = "Gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/item/mecha/repair_droid
	name = "Repair droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 2000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/item/mecha/phoron_generator
	desc = "Phoron reactor."
	id = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 500, MATERIAL_GLASS = 1000)

/datum/design/item/mecha/energy_relay
	name = "Energy relay"
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000, MATERIAL_GLASS = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/item/mecha/ccw_armor
	name = "CCW armor booster"
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_SILVER = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster

/datum/design/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster

/datum/design/item/mecha/diamond_drill
	name = "Diamond drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_DIAMOND = 6500)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/item/mecha/generator_nuclear
	name = "Nuclear reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 500, MATERIAL_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/item/synthetic_flash
	name = "Synthetic flash"
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MATERIAL_STEEL = 750, MATERIAL_GLASS = 750)
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"
