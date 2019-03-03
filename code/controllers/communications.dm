/*
  HOW IT WORKS

  The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
  Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
  procs:

	add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
	  Adds listening object.
	  parameters:
		device - device receiving signals, must have proc receive_signal (see description below).
		  one device may listen several frequencies, but not same frequency twice.
		new_frequency - see possibly frequencies below;
		filter - thing for optimization. Optional, but recommended.
				 All filters should be consolidated in this file, see defines later.
				 Device without listening filter will receive all signals (on specified frequency).
				 Device with filter will receive any signals sent without filter.
				 Device with filter will not receive any signals sent with different filter.
	  returns:
	   Reference to frequency object.

	remove_object (obj/device, old_frequency)
	  Obliviously, after calling this proc, device will not receive any signals on old_frequency.
	  Other frequencies will left unaffected.

   return_frequency(var/frequency as num)
	  returns:
	   Reference to frequency object. Use it if you need to send and do not need to listen.

  radio_frequency is a global object maintaining list of devices that listening specific frequency.
  procs:

	post_signal(obj/source as obj|null, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
	  Sends signal to all devices that wants such signal.
	  parameters:
		source - object, emitted signal. Usually, devices will not receive their own signals.
		signal - see description below.
		filter - described above.
		range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

  obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param)
	Handler from received signals. By default does nothing. Define your own for your object.
	Avoid of sending signals directly from this proc, use spawn(-1). DO NOT use sleep() here or call procs that sleep please. If you must, use spawn()
	  parameters:
		signal - see description below. Extract all needed data from the signal before doing sleep(), spawn() or return!
		receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
		  TRANSMISSION_WIRE is currently unused.
		receive_param - for TRANSMISSION_RADIO here comes frequency.

  datum/signal
	vars:
	source
	  an object that emitted signal. Used for debug and bearing.
	data
	  list with transmitting data. Usual use pattern:
		data["msg"] = "hello world"
	encryption
	  Some number symbolizing "encryption key".
	  Note that game actually do not use any cryptography here.
	  If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.

*/

/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)

Radio:
1459 - standard radio chat
1351 - Science
1353 - Command
1355 - Medical
1357 - Engineering
1359 - Security
1341 - deathsquad
1443 - Confession Intercom
1347 - Cargo techs
1349 - Service people

1700

Devices:
1451 - tracking implant
1457 - RSD default

On the map:
1311 for prison shuttle console (in fact, it is not used)
1435 for status displays
1437 for atmospherics/fire alerts
1438 for engine components
1439 for air pumps, air scrubbers, atmo control
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot, secbot and ed209 control
1449 for airlock controls, electropack, magnets
1451 for toxin lab access
1453 for engineering access
1455 for AI access
*/

//Ranges
var/const/RADIO_LOW_FREQ	= 1200
var/const/PUBLIC_LOW_FREQ	= 1441
var/const/PUBLIC_HIGH_FREQ	= 1489
var/const/RADIO_HIGH_FREQ	= 1600
var/const/RADIO_CUSTOM_FREQ = 1700

//Machines
var/const/MAGNET_FREQ			= 1311
var/const/INCINERATOR_FREQ		= 1378
var/const/DOOR_FREQ				= 1379
var/const/MISC_MACHINE_FREQ		= 1202
var/const/ALARMLOCKS_FREQ		= 1437
var/const/ENGINE_FREQ			= 1438
var/const/AIRALARM_FREQ			= 1439
var/const/STATUS_FREQ 			= 1435
var/const/ATMOS_CONTROL_FREQ 	= 1441
var/const/AIRLOCK_FREQ			= 1449
var/const/POD_LAUNCHER_FREQ 	= 1452

//Other Comms
var/const/BOT_FREQ	= 1447
var/const/COMM_FREQ = 1353
var/const/ERT_FREQ	= 1345
var/const/AI_FREQ	= 1343
var/const/DTH_FREQ	= 1341
var/const/SYND_FREQ = 1213
var/const/RAID_FREQ	= 1277
var/const/ENT_FREQ	= 1461 //entertainment frequency. This is not a diona exclusive frequency.

// department channels
var/const/PUB_FREQ = 1459
var/const/SEC_FREQ = 1359
var/const/ENG_FREQ = 1357
var/const/MED_FREQ = 1355
var/const/SCI_FREQ = 1351
var/const/SRV_FREQ = 1349
var/const/SUP_FREQ = 1347
var/const/EXP_FREQ = 1361

// public interesting channels
var/const/TT_FREQ = 1489

// internal department channels
var/const/MED_I_FREQ = 1485
var/const/SEC_I_FREQ = 1475

// special intercoms
var/const/SEC_INTERCOM_FREQ = 1476
var/const/CONFESSIONALS_FREQ = 1480

var/list/radiochannels = list(
	"Common"		= PUB_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Raider"		= RAID_FREQ,
	"Exploration"	= EXP_FREQ,
	"Supply" 		= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Trauma Response" = TT_FREQ,
	"Medical(I)"	= MED_I_FREQ,
	"Security(I)"	= SEC_I_FREQ
)

var/list/channel_color_presets = list(
	"Global Green" = "#008000",
	"Phenomenal Purple" = "#993399",
	"Bitchin' Blue" = "#395a9a",
	"Menacing Maroon" = "#6d3f40",
	"Pretty Periwinkle" = "#5c5c8a",
	"Painful Pink" = "#ff00ff",
	"Raging Red" = "#a30000",
	"Operational Orange" = "#a66300",
	"Tantalizing Turquoise" = "#008160",
	"Bemoaning Brown" = "#7f6539",
	"Gastric Green" = "#6eaa2c",
	"Bold Brass" = "#a3a332"
)

// central command channels, i.e deathsquid & response teams
var/list/CENT_FREQS = list(ERT_FREQ, DTH_FREQ)

// Antag channels, i.e. Syndicate
var/list/ANTAG_FREQS = list(SYND_FREQ, RAID_FREQ)

//Department channels, arranged lexically
var/list/DEPT_FREQS = list(AI_FREQ, COMM_FREQ, ENG_FREQ, MED_FREQ, SEC_FREQ, SCI_FREQ, SRV_FREQ, SUP_FREQ, EXP_FREQ, ENT_FREQ, TT_FREQ)

#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

/proc/frequency_span_class(var/frequency)
	// Antags!
	if (frequency in ANTAG_FREQS)
		return "syndradio"
	// centcomm channels (deathsquid and ert)
	if(frequency in CENT_FREQS)
		return "centradio"
	// command channel
	if(frequency == COMM_FREQ)
		return "comradio"
	// AI private channel
	if(frequency == AI_FREQ)
		return "airadio"
	// department radio formatting (poorly optimized, ugh)
	if(frequency == SEC_FREQ)
		return "secradio"
	if (frequency == ENG_FREQ)
		return "engradio"
	if(frequency == SCI_FREQ)
		return "sciradio"
	if(frequency == MED_FREQ)
		return "medradio"
	if(frequency == EXP_FREQ) // exploration
		return "EXPradio"
	if(frequency == SUP_FREQ) // cargo
		return "supradio"
	if(frequency == SRV_FREQ) // service
		return "srvradio"
	if(frequency == ENT_FREQ) //entertainment
		return "entradio"
	if(frequency == TT_FREQ) // trauma response
		return "ttradio"
	if(frequency in DEPT_FREQS)
		return "deptradio"
	if(frequency >= RADIO_CUSTOM_FREQ)
		return "custradio"

	return "radio"


/* range */
var/const/RADIO_DEFAULT_RANGE	= 0
var/const/AIRLOCK_CONTROL_RANGE = 22

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also recieve signals sent to any other filter.
var/const/RADIO_DEFAULT 		= "radio_default"
var/const/RADIO_TO_AIRALARM 	= "radio_airalarm" 		//air alarms
var/const/RADIO_FROM_AIRALARM 	= "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
var/const/RADIO_CHAT 			= "radio_telecoms"
var/const/RADIO_ATMOSIA 		= "radio_atmos"
var/const/RADIO_ENGI			= "radio_engi"
var/const/RADIO_NAVBEACONS 		= "radio_navbeacon"
var/const/RADIO_AIRLOCK 		= "radio_airlock"
var/const/RADIO_BLAST_DOORS		= "radio_blastdoor"
var/const/RADIO_SECBOT 			= "radio_secbot"
var/const/RADIO_MULEBOT 		= "radio_mulebot"
var/const/RADIO_MAGNETS 		= "radio_magnet"
var/const/RADIO_EMITTERS 		= "radio_emitter"
var/const/RADIO_MASSDRIVER		= "radio_massdriver"
var/const/RADIO_FLASHERS		= "radio_flasher"
var/const/RADIO_STATUS_DISPLAY  = "radio_status_display"
var/const/RADIO_INCINERATOR  	= "radio_incinerator"
var/const/RADIO_POD_LAUNCHER	= "radio_podlauncher"

var/global/datum/controller/radio/radio_controller

/hook/startup/proc/createRadioController()
	radio_controller = new /datum/controller/radio()
	return 1

//The global radio controller
/datum/controller/radio
	var/list/datum/radio_frequency/frequencies = list()

/datum/controller/radio/proc/add_object(obj/device as obj, var/new_frequency as num, var/filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(frequency)
		frequency.remove_listener(device)

		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text

	return 1

/datum/controller/radio/proc/return_frequency(var/new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency

/datum/radio_frequency
	var/frequency as num
	var/list/list/obj/devices = list()
	var/signalcount = 0

/datum/radio_frequency/proc/post_signal(obj/source as obj|null, datum/signal/signal, var/filter = null as text|null, var/range = null as num|null)
	var/turf/start_point
	if(range)
		start_point = get_turf(source)
		if(!start_point)
			qdel(signal)
			return 0
	if (filter)
		send_to_filter(source, signal, filter, start_point, range)
		send_to_filter(source, signal, RADIO_DEFAULT, start_point, range)
	else
		//Broadcast the signal to everyone!
		for (var/next_filter in devices)
			send_to_filter(source, signal, next_filter, start_point, range)

//Sends a signal to all machines belonging to a given filter. Should be called by post_signal()
/datum/radio_frequency/proc/send_to_filter(obj/source, datum/signal/signal, var/filter, var/turf/start_point = null, var/range = null)
	if (range && !start_point)
		return
	signalcount++
	// if((signalcount % 100) == 0)
	// 	testing("Signals sent on [frequency] : [signalcount]")
	for(var/obj/device in devices[filter])
		if(device == source)
			continue
		if(range)
			var/turf/end_point = get_turf(device)
			if(!end_point)
				continue
			if(start_point.z!=end_point.z || get_dist(start_point, end_point) > range)
				continue
		
		INVOKE_ASYNC(device, /obj/.proc/receive_signal, signal, TRANSMISSION_RADIO, frequency)
		// spawn(0)
		// 	device.receive_signal(signal, TRANSMISSION_RADIO, frequency)
		CHECK_TICK

/datum/radio_frequency/proc/add_listener(obj/device as obj, var/filter as text|null)
	if (!filter)
		filter = RADIO_DEFAULT
	//log_admin("add_listener(device=[device],filter=[filter]) frequency=[frequency]")
	var/list/obj/devices_line = devices[filter]
	if (!devices_line)
		devices_line = new
		devices[filter] = devices_line
	devices_line+=device
//			var/list/obj/devices_line___ = devices[filter_str]
//			var/l = devices_line___.len
	//log_admin("DEBUG: devices_line.len=[devices_line.len]")
	//log_admin("DEBUG: devices(filter_str).len=[l]")

/datum/radio_frequency/proc/remove_listener(obj/device)
	for (var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line-=device
		while (null in devices_line)
			devices_line -= null
		if (devices_line.len==0)
			devices -= devices_filter

/datum/signal
	var/obj/source

	var/transmission_method = 0 //unused at the moment
	//0 = wire
	//1 = radio transmission
	//2 = subspace transmission

	var/list/data = list()
	var/encryption

	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"
