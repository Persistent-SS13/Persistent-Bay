/obj/item/weapon/robot_module/security
	channels = list(
		"Security" = TRUE
	)
	networks = list(
		NETWORK_SECURITY,
		NETWORK_SYCORAX,
		NETWORK_SYCORAX_SECURITY,
	)
	subsystems = list(
		/datum/nano_module/crew_monitor, 
		/datum/nano_module/digitalwarrant,
		/datum/nano_module/program/judge,
		/datum/nano_module/program/verdicts,
		/datum/nano_module/program/civil_laws,
		/datum/nano_module/program/criminal_laws,
		/datum/nano_module/program/tax_laws,
	)
	can_be_pushed = FALSE
	supported_upgrades = list(
		/obj/item/borg/upgrade/weaponcooler,
		/obj/item/borg/upgrade/floodlight,
		/obj/item/borg/upgrade/jetpack,
		/obj/item/borg/upgrade/vtec,
	)

/obj/item/weapon/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	for(var/obj/item/weapon/gun/energy/T in equipment)
		if(T && T.power_supply)
			if(T.power_supply.charge < T.power_supply.maxcharge)
				T.power_supply.give(T.charge_cost * amount)
				T.update_icon()
			else
				T.charge_tick = 0
	var/obj/item/weapon/melee/baton/robot/B = locate() in equipment
	if(B && B.bcell)
		B.bcell.give(amount)

/obj/item/weapon/robot_module/security/general
	name = "security robot module"
	display_name = "Security"
	sprites = list(
		"Basic" = "secborg",
		"Red Knight" = "Security",
		"Black Knight" = "securityrobot",
		"Bloodhound" = "bloodhound",
		"Bloodhound - Treaded" = "secborg+tread",
		"Tridroid" = "orb-security"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/weapon/handcuffs/cyborg,
		/obj/item/weapon/melee/baton/robot,
		/obj/item/weapon/gun/energy/taser/mounted/cyborg,
		/obj/item/weapon/gun/energy/gun/secure/mounted,
		/obj/item/taperoll/police/cyborg,
		/obj/item/device/megaphone,
		/obj/item/device/holowarrant,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/hailer,
		/obj/item/robot_rack/body_bag,
		/obj/item/weapon/tray/robotray,
	)
	emag = /obj/item/weapon/gun/energy/laser/mounted

/obj/item/weapon/robot_module/security/combat
	name = "combat robot module"
	display_name = "Combat"
	crisis_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Combat Android" = "droid-combat"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/weapon/handcuffs/cyborg,
		/obj/item/borg/sight/thermal,
		/obj/item/weapon/melee/baton/robot,
		/obj/item/weapon/gun/energy/taser/mounted/cyborg,
		/obj/item/weapon/gun/energy/laser/mounted,
		/obj/item/weapon/gun/energy/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/megaphone,
	)
	emag = /obj/item/weapon/gun/energy/lasercannon/mounted
