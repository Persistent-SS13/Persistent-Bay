// robot_upgrades.dm
// Contains various borg upgrades.
// CHASIS AND MODULE CHIPS VVVVVVV
// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/chassis_mod
	name = "Chassis Mod."
	desc = "Insert this into a cyborg to allow it to change its appearance."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	var/req_module = 1
	var/module_type = ""
	var/chassis_type = ""

/obj/item/borg/chassis_mod/proc/action(mob/living/silicon/robot/R)
	if(R.chassis_mod && istype(R.chassis_mod, /obj/item/borg/chassis_mod))
		to_chat(R, "Chassis mod slot already filled!")
		to_chat(usr, "There's already an installed chassis mod!")
		return 0
	R.chassis_mod = src
	return 1

/obj/item/borg/chassis_mod/standard/droid
	name = "Standard Chassis: Droid"
	module_type = /obj/item/weapon/robot_module/standard
	chassis_type = "droid"

/obj/item/borg/chassis_mod/standard/old
	name = "Standard Chassis: Old"
	module_type = /obj/item/weapon/robot_module/standard
	chassis_type = "robot_old"

/obj/item/borg/chassis_mod/standard/drone
	name = "Standard Chassis: Drone"
	module_type = /obj/item/weapon/robot_module/standard
	chassis_type = "drone-standard"

/obj/item/borg/chassis_mod/standard/eyebot
	name = "Standard Chassis: Eyebot"
	module_type = /obj/item/weapon/robot_module/standard
	chassis_type = "eyebot-stand"

/obj/item/borg/chassis_mod/service/waitress
	name = "Service/Clerical Chassis: Waitress"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "Service"

/obj/item/borg/chassis_mod/service/bro
	name = "Service/Clerical Chassis: Brobot"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "Brobot"

/obj/item/borg/chassis_mod/service/fountainbot
	name = "Service/Clerical Chassis: Fountain-head"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "toiletbot"

/obj/item/borg/chassis_mod/service/poshbot
	name = "Service/Clerical Chassis: Poshbot"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "maximillion"

/obj/item/borg/chassis_mod/service/waiterbot
	name = "Service/Clerical Chassis: Waiter"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "Service2"

/obj/item/borg/chassis_mod/service/serviceeyebot
	name = "Service/Clerical Chassis: Eyebot"
	module_type = /obj/item/weapon/robot_module/clerical
	chassis_type = "eyebot-standard"

/obj/item/borg/chassis_mod/mining/minereyebot
	name = "Mining Chassis: Mining Eyebot"
	module_type = /obj/item/weapon/robot_module/miner
	chassis_type = "eyebot-miner"

/obj/item/borg/chassis_mod/mining/minerbipedal
	name = "Mining Chassis: Bipedal Miner"
	module_type = /obj/item/weapon/robot_module/miner
	chassis_type = "Miner_old"

/obj/item/borg/chassis_mod/mining/advancedminer
	name = "Mining Chassis: Advanced Miner"
	module_type = /obj/item/weapon/robot_module/miner
	chassis_type = "droid-miner"

/obj/item/borg/chassis_mod/mining/treadhead
	name = "Mining Chassis: Treadhead Miner"
	module_type = /obj/item/weapon/robot_module/miner
	chassis_type = "Miner"

/obj/item/borg/chassis_mod/medical/bipedmedic
	name = "Medical Chassis: Bipedal Medical Cyborg"
	module_type = /obj/item/weapon/robot_module/medical
	chassis_type = "Medbot"

/obj/item/borg/chassis_mod/medical/surgicalbot
	name = "Medical Chassis: Surgical Cyborg"
	module_type = /obj/item/weapon/robot_module/medical
	chassis_type = "surgeon"

/obj/item/borg/chassis_mod/medical/doctorneedles
	name = "Medical Chassis: Doctor Needles"
	module_type = /obj/item/weapon/robot_module/medical
	chassis_type = "medicalrobot"

/obj/item/borg/chassis_mod/medical/medicaleyebot
	name = "Medical Chassis: Medical Eyebot"
	module_type = /obj/item/weapon/robot_module/medical
	chassis_type = "eyebot-medical"

/obj/item/borg/chassis_mod/security/bipedalsecurity
	name = "Security Chassis: Bipedal Security Cyborg"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "secborg"

/obj/item/borg/chassis_mod/security/redknight
	name = "Security Chassis: Red Knight Cyborg Model"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "Security"

/obj/item/borg/chassis_mod/security/protector
	name = "Security Chassis: Protector Cyborg Model"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "securityrobot"

/obj/item/borg/chassis_mod/security/bloodhound
	name = "Security Chassis: Bloodhound Cyborg Model"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "bloodhound"

/obj/item/borg/chassis_mod/security/treaded
	name = "Security Chassis: Treaded Bloodhound"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "secborg+tread"

/obj/item/borg/chassis_mod/security/securityeyebot
	name = "Security Chassis: Security Eyebot"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "eyebot-security"

/obj/item/borg/chassis_mod/security/tridroid
	name = "Security Chassis: Tridoid Cyborg Model"
	module_type = /obj/item/weapon/robot_module/security
	chassis_type = "orb-security"

/obj/item/borg/chassis_mod/engineering/bipedalengineer
	name = "Engineering Chassis: Bipedal Engineering Cyborg"
	module_type = /obj/item/weapon/robot_module/engineering
	chassis_type = "Engineering"

/obj/item/borg/chassis_mod/engineering/antique
	name = "Engineering Chassis: Outdated Engineer"
	module_type = /obj/item/weapon/robot_module/engineering
	chassis_type = "engineerrobot"

/obj/item/borg/chassis_mod/engineering/landmate
	name = "Engineering Chassis: Landmate Model"
	module_type = /obj/item/weapon/robot_module/engineering
	chassis_type = "landmate"

/obj/item/borg/chassis_mod/engineering/treads
	name = "Engineering Chassis: Treaded Landmate"
	module_type = /obj/item/weapon/robot_module/engineering
	chassis_type = "engiborg+tread"

/obj/item/borg/chassis_mod/engineering/eyebotengineering
	name = "Engineering Chassis: Engineering Eyebot"
	module_type = /obj/item/weapon/robot_module/engineering
	chassis_type = "eyebot-engineering"


/obj/item/borg/chassis_mod/janitor/bipedaljanitor
	name = "Janitor Chassis: Bipedal Janitor Cyborg"
	module_type = /obj/item/weapon/robot_module/janitor
	chassis_type = "JanBot2"

/obj/item/borg/chassis_mod/janitor/buckethead
	name = "Janitor Chassis: Bucket-head Janitor"
	module_type = /obj/item/weapon/robot_module/janitor
	chassis_type = "janitorrobot"

/obj/item/borg/chassis_mod/janitor/mopgearrex
	name = "Janitor Chassis: MOP GEAR R.E.X"
	module_type = /obj/item/weapon/robot_module/janitor
	chassis_type = "mopgearrex"

/obj/item/borg/chassis_mod/janitor/janitoreyebot
	name = "Janitor Chassis: Janitorial Eyebot"
	module_type = /obj/item/weapon/robot_module/janitor
	chassis_type = "eyebot-janitor"

/obj/item/borg/chassis_mod/science/sciencedroid
	name = "Research Chassis: Science Droid"
	module_type = /obj/item/weapon/robot_module/research
	chassis_type = "droid-science"

/obj/item/borg/chassis_mod/science/scienceeyebot
	name = "Research Chassis: Science Eyebot"
	module_type = /obj/item/weapon/robot_module/research
	chassis_type = "eyebot-research"

/obj/item/borg/module_chip
	name = "cyborg module."
	desc = "Contains tools and objects that a cyborg can access."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade3"
	var/installed = 0
	var/module_type = ""
	var/default_icon = ""
	var/obj/item/weapon/robot_module/stored_module = null // used when the module gets unloaded and reloaded, preserving a single instance of /robot_module/ per chip each round

/obj/item/borg/module_chip/proc/action(mob/living/silicon/robot/R)
	if(R.installed_module && istype(R.installed_module, /obj/item/borg/module_chip))
		to_chat(R, "Module mounting error! Module slot already filled!")
		to_chat(usr, "There's already an installed module!")
		return 0
	R.installed_module = src
	installed = 1
	return 1

/obj/item/borg/module_chip/standard
	name = "Standard Module."
	desc = "Contains tools and supplies for a standard cyborg."
	module_type = /obj/item/weapon/robot_module/standard
	default_icon = "robot"
/obj/item/borg/module_chip/medical/surgeon
	name = "Surgeon Module."
	desc = "Contains tools and supplies for a surgeon class medical cyborg."
	module_type = /obj/item/weapon/robot_module/medical/surgeon
	default_icon = "robotMedi"
/obj/item/borg/module_chip/medical
	name = "Medi-Crisis Module."
	desc = "Contains tools and supplies for a crisis class medical cyborg."
	module_type = /obj/item/weapon/robot_module/medical/crisis
	default_icon = "robotMedi"
/obj/item/borg/module_chip/research
	name = "Research Module."
	desc = "Contains tools and supplies for a research cyborg."
	module_type = /obj/item/weapon/robot_module/research
	default_icon = "robotMedi"
/obj/item/borg/module_chip/security
	name = "Security Module."
	desc = "Contains tools and supplies for a security cyborg."
	module_type = /obj/item/weapon/robot_module/security/general
	default_icon = "robotSecy"
/obj/item/borg/module_chip/clerical
	name = "Clerical Module."
	desc = "Contains tools and supplies for a clerical cyborg."
	module_type = /obj/item/weapon/robot_module/clerical/general
	default_icon = "robotServ"
/obj/item/borg/module_chip/service
	name = "Service Module."
	desc = "Contains tools and supplies for a service cyborg."
	module_type = /obj/item/weapon/robot_module/clerical/butler
	default_icon = "robotServ"
/obj/item/borg/module_chip/mining
	name = "Mining Module."
	desc = "Contains tools and supplies for a mining cyborg."
	module_type = /obj/item/weapon/robot_module/miner
	default_icon = "robotMine"
/obj/item/borg/module_chip/engineering
	name = "Engineering Module."
	desc = "Contains tools and supplies for an engineering cyborg."
	module_type = /obj/item/weapon/robot_module/engineering
	default_icon = "robotEngi"
/obj/item/borg/module_chip/janitor
	name = "Service Module."
	desc = "Contains tools and supplies for a janitorial cyborg."
	module_type = /obj/item/weapon/robot_module/janitor
	default_icon = "robotJani"

//////////// CHASIS AND MODULE CHIPS ^^^^

/obj/item/borg/upgrade
	name = "robot upgrade module"
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, "<span class='warning'>The [src] will not function on a deceased robot.</span>")
		return 1
	return 0


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = 1

/obj/item/borg/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if((. = ..())) return 0
	R.uneq_all()
	R.modtype = initial(R.modtype)
	R.hands.icon_state = initial(R.hands.icon_state)

	R.reset_module()
	return 1

/obj/item/borg/upgrade/uncertified
	name = "uncertified robotic module"
	desc = "You shouldn't be seeing this!"
	icon_state = "cyborg_upgrade5"
	require_module = 0
	var/new_module = null

/obj/item/borg/upgrade/uncertified/action(var/mob/living/silicon/robot/R)
	if((. = ..())) return 0
	if(!new_module)
		to_chat(usr, "<span class='warning'>[R]'s error lights strobe repeatedly - something seems to be wrong with the chip.</span>")
		return 0

	// Suppress the alert so the AI doesn't see a reset message.
	R.reset_module(TRUE)
	R.pick_module(new_module)
	return 1

/obj/item/borg/upgrade/uncertified/party
	name = "\improper Madhouse Productions Official Party Module"
	desc = "A weird-looking chip with third-party additions crudely soldered in. It feels cheap and chintzy in the hand. Inscribed into the cheap-feeling circuit is the logo of Madhouse Productions, a group that arranges parties and entertainment venues."
	new_module = "Party"

/obj/item/borg/upgrade/uncertified/combat
	name = "ancient module"
	desc = "A well-made but somewhat archaic looking bit of circuitry. The chip is stamped with an insignia: a gun protruding from a stylized fist."
	new_module = "Combat"

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as mob)
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname), MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.SetName(heldname)
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/floodlight
	name = "robot floodlight module"
	desc = "Used to boost cyborg's light intensity."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/floodlight/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.intenselight)
		to_chat(usr, "This cyborg's light was already upgraded")
		return 0
	else
		R.intenselight = 1
		R.update_robot_light()
		to_chat(R, "Lighting systems upgrade detected.")
	return 1

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"


/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(!R.key)
		for(var/mob/observer/ghost/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	R.switch_from_dead_to_living_mob_list()
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return 1


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = 1

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.speed == -1)
		return 0

	R.speed--
	return 1


/obj/item/borg/upgrade/weaponcooler
	name = "robotic Rapid Weapon Cooling Module"
	desc = "Used to cool a mounted energy gun, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	require_module = 1


/obj/item/borg/upgrade/weaponcooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/weapon/gun/energy/gun/secure/mounted/T = locate() in R.module
	if(!T)
		T = locate() in R.module.equipment
	if(!T)
		to_chat(usr, "This robot has had its energy gun removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return 1

/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.equipment += new/obj/item/weapon/tank/jetpack/carbondioxide
		for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.equipment)
			R.internals = src
		//R.icon_state="Miner+j"
		return 1

/obj/item/borg/upgrade/rcd
	name = "engineering robot RCD"
	desc = "A rapid construction device module for use during construction operations."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/rcd/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.equipment += new/obj/item/weapon/rcd/borg(R.module)
		return 1

/obj/item/borg/upgrade/syndicate/
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.emagged == 1)
		return 0

	R.emagged = 1
	return 1
