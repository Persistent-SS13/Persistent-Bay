//--------------------------------
//	Radio Transmitter
//--------------------------------
#define RADIO_TRANSMITTER_ID_FIELD        "tag"
#define RADIO_TRANSMITTER_SOURCE_ID_FIELD "src_tag"

//Returns the target tag of the specified signal
proc/signal_target_id(var/datum/signal/signal)
	if(signal && islist(signal.data)) 
		return signal.data[RADIO_TRANSMITTER_ID_FIELD]
	return null

//Returns the target tag of the specified signal
proc/signal_source_id(var/datum/signal/signal)
	if(signal && islist(signal.data)) 
		return signal.data[RADIO_TRANSMITTER_SOURCE_ID_FIELD]
	return null

/*
	Unified wrapper for transmissions via radio.
	Since literally all objects implement this differently and made universally
	accessing radio connection data a pain, I decided to package everything into
	this wrapper.

	Since all objects have a "receive_signal" proc, all you have to do to begin
	receiving signals is to instantiate and set this extention, and handle signals
	in your object's receive_signal proc. You can transmit signals using the proc
	this extension offers.
*/
#define RADIO_TRANSMITTER_TYPE /datum/extension/interactive/radio_transmitter

/datum/extension/interactive/radio_transmitter
	var/datum/radio_frequency/radio_connection
	var/filter_in  	= null
	var/filter_out 	= null
	var/id 			= null
	var/range 		= 0
	var/frequency 	= 0
	should_save		= TRUE
	flags 			= EXTENSION_FLAG_IMMEDIATE //Do not Lazy init this, or we won't receive messages..

// - idtag: Id tag that each signals sent will be tagged with, and optionally checked against. If set to null, id checks will always return true.
/datum/extension/interactive/radio_transmitter/New(var/holder, var/frequency, var/idtag, var/range, var/filter, var/filterout = null)
	..(holder)
	ADD_SAVED_VAR(filter_in)
	ADD_SAVED_VAR(filter_out)
	ADD_SAVED_VAR(id)
	ADD_SAVED_VAR(range)
	ADD_SAVED_VAR(frequency)
	ADD_SAVED_VAR(holder)

	if(!map_storage_loaded)
		src.id         = idtag
		src.frequency  = frequency
		src.range      = range
		src.filter_in  = filter
		src.filter_out = (filterout)? filterout : filter
		set_frequency(frequency)

/datum/extension/interactive/radio_transmitter/after_load()
	..()
	//Reset connection, since the datum will be in a limbo state on load, and we really just need the frequency to reset it
	setup_connection()

/datum/extension/interactive/radio_transmitter/Destroy()
	if(src.radio_connection)
		radio_controller.remove_object(src.holder, src.frequency)
		src.radio_connection = null  //Don't delete radio channels we don't owe them
	return ..()

//Called to refresh our subscription to radio channels
/datum/extension/interactive/radio_transmitter/proc/setup_connection()
	if(src.radio_connection)
		radio_controller.remove_object(src.holder, src.frequency)
		src.radio_connection = null
	src.radio_connection = radio_controller.add_object(src.holder, src.frequency, src.filter_in)
	//log_debug("radio_transmitter \ref[src] got channel [src.radio_connection? src.radio_connection : "null"] [src.radio_connection? src.radio_connection.frequency : "null"]")

/datum/extension/interactive/radio_transmitter/proc/is_connected()
	return src.radio_connection? TRUE : FALSE

/datum/extension/interactive/radio_transmitter/proc/set_frequency(var/newfreq)
	src.frequency = newfreq
	setup_connection()

/datum/extension/interactive/radio_transmitter/proc/get_frequency()
	return src.frequency

/datum/extension/interactive/radio_transmitter/proc/set_filter(var/filter, var/filterout = null)
	if(!filter)
		return
	src.filter_in = filter
	src.filter_out = (filterout)? filterout : filter
	setup_connection()

/datum/extension/interactive/radio_transmitter/proc/set_filter_out(var/filter)
	if(!filter)
		return
	src.filter_out = filter

/datum/extension/interactive/radio_transmitter/proc/get_filter()
	return src.filter_in
/datum/extension/interactive/radio_transmitter/proc/get_filter_out()
	return src.filter_out

/datum/extension/interactive/radio_transmitter/proc/set_id(var/newid)
	src.id = newid
/datum/extension/interactive/radio_transmitter/proc/get_id()
	return src.id

//Compare a signal's ids and return true if identical to our
/datum/extension/interactive/radio_transmitter/proc/match_id(var/datum/signal/signal)
	if(src.id)
		return signal_target_id(signal) == src.id
	else
		return TRUE

/datum/extension/interactive/radio_transmitter/proc/set_range(var/newrange)
	src.range = newrange
/datum/extension/interactive/radio_transmitter/proc/get_range()
	return src.range

//Send a signal to a target id_tag
/datum/extension/interactive/radio_transmitter/proc/post_signal(datum/signal/signal, var/overridefilter = null, var/overridetargetid = null, var/overridefreq = null)
	signal.data[RADIO_TRANSMITTER_ID_FIELD] = overridetargetid? overridetargetid : src.id
	return broadcast_signal(signal, overridefilter, overridefreq)

//Broadcast a signal without a target
/datum/extension/interactive/radio_transmitter/proc/broadcast_signal(datum/signal/signal, var/overridefilter = null, var/overridefreq = null)
	if(!src.radio_connection)
		log_debug("[src.holder] \ref[src.holder] tried to send a signal with no radio connection!")
		return
	signal.data[RADIO_TRANSMITTER_SOURCE_ID_FIELD] = src.id
	//Send the message to the right frquency
	if(overridefreq && overridefreq != src.frequency)
		var/datum/radio_frequency/otherfrequency = radio_controller.return_frequency(overridefreq)
		if(!otherfrequency)
			log_warning("[src]/ref[src] tried to send radio signal to empty radio frequency: [overridefreq]!!")
			return
		otherfrequency.post_signal(src.holder, signal, (overridefilter)? overridefilter : src.filter_out, src.range)
	else //Same frequency as the one we're listening on
		src.radio_connection.post_signal(src.holder, signal, (overridefilter)? overridefilter : src.filter_out, src.range)

/datum/extension/interactive/radio_transmitter/proc/add_listener(obj/device as obj)
	if(!src.radio_connection)
		log_debug("[src.holder] \ref[src.holder] tried to add a listener with no radio connections!")
		return
	src.radio_connection.add_listener(device, src.filter_in)

/datum/extension/interactive/radio_transmitter/proc/remove_listener(obj/device)
	if(!src.radio_connection)
		log_debug("[src.holder] \ref[src.holder] tried to remove a listener with no radio connections!")
		return
	src.radio_connection.remove_listener(device)

//This handles "Topics" calls to the extension. So we can associate a UI to this and etc..
/datum/extension/interactive/radio_transmitter/extension_act(var/href, var/list/href_list, var/mob/user)
	// if(href_list["set_radio_id"])
	// 	var/newid = sanitize(href_list["set_radio_id"]) as text|null
	// 	if(newid)
	// 		src.set_id(newid)
	// 	else if(user)
	// 		to_chat(user, SPAN_WARNING("Invalid id!"))
	// if(href_list["set_radio_filter"])
	// 	var/newfiler = sanitize(href_list["set_radio_filter"]) as text|null
	// 	if(newfiler)
	// 		src.set_filter(newfiler)
	// 	else if(user)
	// 		to_chat(user, SPAN_WARNING("Invalid filter!"))
	// if(href_list["set_radio_filter_out"])
	// 	var/newfiler = sanitize(href_list["set_radio_filter_out"]) as text|null
	// 	if(newfiler)
	// 		src.set_filter_out(newfiler)
	// 	else if(user)
	// 		to_chat(user, SPAN_WARNING("Invalid filter!"))
	// if(href_list["set_radio_frequency"])
	// 	var/newfreq = text2num(sanitize(href_list["set_radio_frequency"])) as num
	// 	if(newfreq)
	// 		src.set_frequency(newfreq)
	// 	else if(user)
	// 		to_chat(user, SPAN_WARNING("Invalid frequency!"))
	// if(href_list["set_radio_range"])
	// 	var/newrange = text2num(sanitize(href_list["set_radio_range"])) as num|null
	// 	src.set_range(newrange)
	return ..()
