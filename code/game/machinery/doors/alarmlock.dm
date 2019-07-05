/obj/machinery/door/airlock/alarmlock
	name = "Glass Alarm Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	opacity 		= FALSE
	glass			= TRUE
	id_tag 			= null
	frequency 		= ALARMLOCKS_FREQ
	radio_filter_in = RADIO_FROM_AIRALARM
	radio_filter_out= RADIO_TO_AIRALARM
	autoclose 		= FALSE

/obj/machinery/door/airlock/alarmlock/New()
	..()
	ADD_SAVED_VAR(id_tag)
	ADD_SAVED_VAR(autoclose)

/obj/machinery/door/airlock/alarmlock/Initialize()
	. = ..()
	open()

/obj/machinery/door/airlock/alarmlock/OnSignal(datum/signal/signal)
	. = ..()
	var/alarm_area = signal.data["zone"]
	var/alert = signal.data["alert"]
	var/area/our_area = get_area(src)
	if(alarm_area == our_area.name)
		switch(alert)
			if("severe")
				autoclose = TRUE
				close()
				. = TOPIC_HANDLED
			if("minor", "clear")
				autoclose = FALSE
				open()
				. = TOPIC_HANDLED
	return .
