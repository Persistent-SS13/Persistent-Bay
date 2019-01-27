/obj/item/weapon/computer_hardware/logistic_processor
	name = "Logistic Processor"
	desc = "A large advanced computer processor designed specifically for logistics computing."
	power_usage = 100 //W
	critical = 0
	icon_state = "cpu_normal_photonic"
	hardware_size = 3
	origin_tech = list(TECH_DATA = 2)
	var/faction_uid = ""
	var/faction_password = ""

/obj/item/weapon/computer_hardware/logistic_processor/New()
	..()
	ADD_SAVED_VAR(faction_uid)
	ADD_SAVED_VAR(faction_password)

	ADD_SKIP_EMPTY(faction_uid)
	ADD_SKIP_EMPTY(faction_password)

/obj/item/weapon/computer_hardware/logistic_processor/Destroy()
	if(holder2 && (holder2.logistic_processor == src))
		holder2.logistic_processor = null
	holder2 = null
	return ..()
