/obj/item/modular_computer/telescreen/preset/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card(src)

/obj/item/modular_computer/telescreen/preset/generic/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	set_autorun("cammon")

/obj/item/modular_computer/telescreen/preset/medical/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
//	hard_drive.store_file(new/datum/computer_file/program/records())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors())
	set_autorun("sensormonitor")

/obj/item/modular_computer/telescreen/preset/engineering/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
//	hard_drive.store_file(new/datum/computer_file/program/shields_monitor())
	hard_drive.store_file(new/datum/computer_file/program/supermatter_monitor())
	set_autorun("alarmmonitor")

//
//Supply telescreen
//
/obj/item/modular_computer/telescreen/preset/supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/telescreen/preset/supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/materialmarket())
	set_autorun("materialmarket")
