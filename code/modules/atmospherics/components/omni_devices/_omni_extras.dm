//--------------------------------------------
// Omni device port types
//--------------------------------------------
#define ATM_NONE	0
#define ATM_INPUT	1
#define ATM_OUTPUT	2

#define ATM_O2		3
#define ATM_N2		4
#define ATM_CO2		5
#define ATM_P		6	//Phoron
#define ATM_N2O		7
#define ATM_H2		8
#define ATM_RG		9	//Reagent Gases

//--------------------------------------------
// Omni port datum
//
// Used by omni devices to manage connections
//  to other atmospheric objects.
//--------------------------------------------
/datum/omni_port
	var/obj/machinery/atmospherics/omni/master
	var/dir
	var/update = 1
	var/mode = 0
	var/concentration = 0
	var/con_lock = 0
	var/transfer_moles = 0
	var/datum/gas_mixture/air
	var/obj/machinery/atmospherics/node
	var/datum/pipe_network/network

	var/saved_netid

/datum/omni_port/New(var/obj/machinery/atmospherics/omni/M, var/direction = NORTH)
	..()
	dir = direction
	if(istype(M))
		master = M
	air = new
	air.volume = 200

/datum/omni_port/before_save()
	..()

/datum/omni_port/after_load()
	..()

/datum/omni_port/proc/connect()
	if(node)
		return
	master.atmos_init()
	master.build_network()
	if(node)
		node.atmos_init()
		node.build_network()

/datum/omni_port/proc/disconnect()
	if(node)
		node.disconnect(master)
		master.disconnect(node)


//--------------------------------------------
// Need to find somewhere else for these
//--------------------------------------------

//returns a text string based on the direction flag input
// if capitalize is true, it will return the string capitalized
// otherwise it will return the direction string in lower case
/proc/dir_name(var/dir, var/capitalize = 0)
	var/string = null
	switch(dir)
		if(NORTH)
			string = "North"
		if(SOUTH)
			string = "South"
		if(EAST)
			string = "East"
		if(WEST)
			string = "West"

	if(!capitalize && string)
		string = lowertext(string)

	return string

//returns a direction flag based on the string passed to it
// case insensitive
/proc/dir_flag(var/dir)
	dir = lowertext(dir)
	switch(dir)
		if("north")
			return NORTH
		if("south")
			return SOUTH
		if("east")
			return EAST
		if("west")
			return WEST
		else
			return 0

/proc/mode_to_gasid(var/mode)
	switch(mode)
		if(ATM_O2)
			return list(GAS_OXYGEN)
		if(ATM_N2)
			return list(GAS_NITROGEN)
		if(ATM_CO2)
			return list(GAS_CO2)
		if(ATM_P)
			return list(GAS_PHORON)
		if(ATM_N2O)
			return list(GAS_N2O)
		if(ATM_H2)
			return list(GAS_HYDROGEN)
		if(ATM_RG)
			var/list/reagent_gases_list = list()
			for(var/g in gas_data.gases) //This only fires when initially selecting the filter type, so impact on performance is minimal
				if(gas_data.flags[g] & XGM_GAS_REAGENT_GAS)
					reagent_gases_list += g
			return reagent_gases_list
		else
			return null
