// ### Preset machines  ###

//Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/preset/station
	id = "Primary Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/station/Initialize()
	listening_levels = GLOB.using_map.contact_levels
	return ..()

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/bridge
	id = "Bridge Relay"
	autolinkers = list("b_relay")

/obj/machinery/telecomms/relay/preset/firstdeck
	id = "First Deck Relay"
	autolinkers = list("1_relay")

/obj/machinery/telecomms/relay/preset/seconddeck
	id = "Second Deck Relay"
	autolinkers = list("2_relay")

/obj/machinery/telecomms/relay/preset/thirddeck
	id = "Third Deck Relay"
	autolinkers = list("3_relay")

/obj/machinery/telecomms/relay/preset/fourthdeck
	id = "Fourth Deck Relay"
	autolinkers = list("4_relay")

/obj/machinery/telecomms/relay/preset/fifthdeck
	id = "Fifth Deck Relay"
	autolinkers = list("5_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")

/obj/machinery/telecomms/relay/preset/centcom
	id = "Centcom Relay"
	hide = 1
	toggled = 1
	//anchored = 1
	//use_power = 0
	//idle_power_usage = 0
	produces_heat = 0
	autolinkers = list("c_relay")


/obj/machinery/telecomms/relay/preset/sycorax
	network = "SYCORAXCOM"

/obj/machinery/telecomms/relay/preset/sycorax/station
	id = "SYCO_RLAY"
	autolinkers = list("SYCO_RLAY")

/obj/machinery/telecomms/relay/preset/sycorax/station/Initialize()
	listening_levels = GLOB.using_map.contact_levels
	return ..()


//HUB

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "b_relay", "1_relay", "2_relay", "3_relay", "4_relay", "5_relay", "s_relay", "science", "medical",
	"supply", "service", "common", "command", "engineering", "security", "unused",
	"receiverA", "broadcasterA")

/obj/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("hub_cent", "c_relay", "s_relay", "m_relay", "r_relay",
	 "centcomm", "receiverCent", "broadcasterCent")

/obj/machinery/telecomms/hub/preset/sycorax
	id = "SYCO_HUB"
	network = "SYCORAXCOM"
	autolinkers = list("SYCO_HUB", "SYCO_RLAY", "SYCO_RCVR", "SYCO_BCST",
	"SYCO_SUP_SRVR", "SYCO_SVC_SRVR", "SYCO_UNK_SRVR", "SYCO_PUB_SRVR", "SYCO_ENT_SRVR", "SYCO_CMD_SRVR", "SYCO_SEC_SRVR", "SYCO_ENG_SRVR", "SYCO_AI_SRVR", "SYCO_SCI_SRVR", "SYCO_MED_SRVR")

//Receivers

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ)

	//Common and other radio frequencies for people to freely use
	New()
		for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
			freq_listening |= i
		..()

/obj/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("receiverCent")
	freq_listening = list(ERT_FREQ, DTH_FREQ)

/obj/machinery/telecomms/receiver/preset/sycorax
	id = "SYCO_RCVR"
	network = "SYCORAXCOM"
	autolinkers = list("SYCO_RCVR")
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ)

/obj/machinery/telecomms/receiver/preset/sycorax/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		freq_listening |= i
	..()

//Buses

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(SUP_FREQ, SRV_FREQ)
	autolinkers = list("processor2", "supply", "service", "unused")

/obj/machinery/telecomms/bus/preset_two/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == PUB_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(ERT_FREQ, DTH_FREQ, ENT_FREQ)
	produces_heat = 0
	autolinkers = list("processorCent", "centcomm")


/obj/machinery/telecomms/bus/preset/sycorax
	network = "SYCORAXCOM"

/obj/machinery/telecomms/bus/preset/sycorax/service
	id = "SYCO_SVC_BUS"
	freq_listening = list(SUP_FREQ, SRV_FREQ)
	autolinkers = list("SYCO_SVC_PROC", "SYCO_SUP_SRVR", "SYCO_SVC_SRVR", "SYCO_UNK_SRVR")
/obj/machinery/telecomms/bus/preset/sycorax/service/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == PUB_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/preset/sycorax/public
	id = "SYCO_PUB_BUS"
	freq_listening = list(PUB_FREQ, ENT_FREQ)
	autolinkers = list("SYCO_PUB_PROC", "SYCO_PUB_SRVR", "SYCO_ENT_SRVR")

/obj/machinery/telecomms/bus/preset/sycorax/command
	id = "SYCO_CMD_BUS"
	freq_listening = list(SEC_FREQ, COMM_FREQ)
	autolinkers = list("SYCO_CMD_PROC", "SYCO_CMD_SRVR", "SYCO_SEC_SRVR")

/obj/machinery/telecomms/bus/preset/sycorax/engineering
	id = "SYCO_ENG_BUS"
	freq_listening = list(ENG_FREQ, AI_FREQ)
	autolinkers = list("SYCO_ENG_PROC", "SYCO_ENG_SRVR", "SYCO_AI_SRVR")

/obj/machinery/telecomms/bus/preset/sycorax/science
	id = "SYCO_SCI_BUS"
	freq_listening = list(SCI_FREQ, MED_FREQ)
	autolinkers = list("SYCO_SCI_PROC", "SYCO_SCI_SRVR", "SYCO_MED_SRVR")

//Processors

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("processorCent")

/obj/machinery/telecomms/processor/preset/sycorax
	network = "SYCORAXCOM"

/obj/machinery/telecomms/processor/preset/sycorax/public
	id = "SYCO_PUB_PROC"
	autolinkers = list("SYCO_PUB_PROC")

/obj/machinery/telecomms/processor/preset/sycorax/service
	id = "SYCO_SVC_PROC"
	autolinkers = list("SYCO_SVC_PROC")

/obj/machinery/telecomms/processor/preset/sycorax/command
	id = "SYCO_CMD_PROC"
	autolinkers = list("SYCO_CMD_PROC")

/obj/machinery/telecomms/processor/preset/sycorax/engineering
	id = "SYCO_ENG_PROC"
	autolinkers = list("SYCO_ENG_PROC")

/obj/machinery/telecomms/processor/preset/sycorax/science
	id = "SYCO_SCI_PROC"
	autolinkers = list("SYCO_SCI_PROC")

//Servers

/obj/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(SCI_FREQ)
	channel_tags = list(list(SCI_FREQ, "Science", "#993399"))
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	channel_tags = list(list(MED_FREQ, "Medical", "#008160"))
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(SUP_FREQ)
	channel_tags = list(list(SUP_FREQ, "Supply", "#7f6539"))
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/service
	id = "Service Server"
	freq_listening = list(SRV_FREQ)
	channel_tags = list(list(SRV_FREQ, "Service", "#6eaa2c"))
	autolinkers = list("service")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list(PUB_FREQ, AI_FREQ, ENT_FREQ) // AI Private and Common
	channel_tags = list(
		list(PUB_FREQ, "Common", "#008000"),
		list(AI_FREQ, "AI Private", "#f00ff"),
		list(ENT_FREQ, "Entertainment", "#6eaa2c")
	)
	autolinkers = list("common")

// "Unused" channels, AKA all others.
/obj/machinery/telecomms/server/presets/unused
	id = "Unused Server"
	freq_listening = list()
	autolinkers = list("unused")

/obj/machinery/telecomms/server/presets/unused/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ)
	channel_tags = list(list(COMM_FREQ, "Command", "#395a9a"))
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ)
	channel_tags = list(list(ENG_FREQ, "Engineering", "#a66300"))
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	channel_tags = list(list(SEC_FREQ, "Security", "#a30000"))
	autolinkers = list("security")

/obj/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(ERT_FREQ, DTH_FREQ)
	channel_tags = list(list(ERT_FREQ, "Response Team", "#395a9a"), list(DTH_FREQ, "Special Ops", "#6d3f40"))
	produces_heat = 0
	autolinkers = list("centcomm")

/obj/machinery/telecomms/server/presets/sycorax
	network = "SYCORAXCOM"

/obj/machinery/telecomms/server/presets/sycorax/public
	id = "SYCO_PUB_SRVR"
	freq_listening = list(PUB_FREQ)
	autolinkers = list("SYCO_PUB_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/service
	id = "SYCO_SVC_SRVR"
	freq_listening = list(SRV_FREQ)
	autolinkers = list("SYCO_SVC_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/entertainment
	id = "SYCO_ENT_SRVR"
	freq_listening = list(ENT_FREQ)
	autolinkers = list("SYCO_ENT_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/ai
	id = "SYCO_AI_SRVR"
	freq_listening = list(AI_FREQ)
	autolinkers = list("SYCO_AI_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/command
	id = "SYCO_CMD_SRVR"
	freq_listening = list(COMM_FREQ)
	autolinkers = list("SYCO_CMD_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/security
	id = "SYCO_SEC_SRVR"
	freq_listening = list(SEC_FREQ)
	autolinkers = list("SYCO_SEC_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/engineering
	id = "SYCO_ENG_SRVR"
	freq_listening = list(ENG_FREQ)
	autolinkers = list("SYCO_ENG_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/supply
	id = "SYCO_SUP_SRVR"
	freq_listening = list(SUP_FREQ)
	autolinkers = list("SYCO_SUP_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/medical
	id = "SYCO_MED_SRVR"
	freq_listening = list(MED_FREQ)
	autolinkers = list("SYCO_MED_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/science
	id = "SYCO_SCI_SRVR"
	freq_listening = list(SCI_FREQ)
	autolinkers = list("SYCO_SCI_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/unknown
	id = "SYCO_UNK_SRVR"
	freq_listening = list()
	autolinkers = list("SYCO_UNK_SRVR")

/obj/machinery/telecomms/server/presets/sycorax/unknown/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ)
			continue
		freq_listening |= i
	..()


//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

/obj/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("broadcasterCent")

/obj/machinery/telecomms/broadcaster/preset/sycorax
	id = "SYCO_BCST"
	network = "SYCORAXCOM"
	autolinkers = list("SYCO_BCST")
