//--------------------------------
//	Radio Transmitter
//--------------------------------
#define RADIO_TRANSMITTER_ID_FIELD "id"
#define RADIO_TRANSMITTER_SOURCE_ID_FIELD "src_id"
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
	var/datum/radio_frequency/radio_connection = null
	var/filter = RADIO_DEFAULT
	var/id = null
	var/range = null
	should_save = 1

/datum/extension/interactive/radio_transmitter/New(var/id = null, var/range = null, var/filter = RADIO_DEFAULT)
	..()
	ADD_SAVED_VAR(radio_connection)
	ADD_SAVED_VAR(filter)
	ADD_SAVED_VAR(id)
	ADD_SAVED_VAR(range)
	if(!map_storage_loaded)
		src.id      = id
		src.range   = range
		src.filter  = filter

/datum/extension/interactive/radio_transmitter/after_load()
	..()
	//Reset connection, since the datum will be in a limbo state on load, and we really just need the frequency to reset it
	if(radio_connection)
		set_frequency(radio_connection.frequency)

/datum/extension/interactive/radio_transmitter/Destroy()
	if(radio_connection)
		radio_controller.remove_object(holder, radio_connection.frequency)
		QDEL_NULL(radio_connection)
	return ..()

/datum/extension/interactive/radio_transmitter/proc/is_connected()
	return radio_connection? TRUE : FALSE

/datum/extension/interactive/radio_transmitter/proc/set_frequency(var/newfreq)
	if(radio_connection)
		radio_controller.remove_object(holder, radio_connection.frequency)
		QDEL_NULL(radio_connection)
	radio_connection = radio_controller.add_object(holder, newfreq, filter)

/datum/extension/interactive/radio_transmitter/proc/get_frequency()
	return radio_connection? radio_connection.frequency : null

/datum/extension/interactive/radio_transmitter/proc/set_filter(var/newfilter)
	if(newfilter)
		filter = newfilter
	if(radio_connection)
		set_frequency(radio_connection.frequency) //reset connection
/datum/extension/interactive/radio_transmitter/proc/get_filter()
	return filter

/datum/extension/interactive/radio_transmitter/proc/set_id(var/newid)
	id = newid
/datum/extension/interactive/radio_transmitter/proc/get_id()
	return id

//Compare two ids and return true if identical
/datum/extension/interactive/radio_transmitter/proc/signal_match_id(var/datum/signal/signal)
	return signal && islist(signal.data) && signal.data[RADIO_TRANSMITTER_ID_FIELD] == src.id

/datum/extension/interactive/radio_transmitter/proc/set_range(var/newrange)
	range = newrange
/datum/extension/interactive/radio_transmitter/proc/get_range()
	return range

/datum/extension/interactive/radio_transmitter/proc/post_signal(datum/signal/signal)
	if(!radio_connection)
		log_debug("[holder] tried to send a signal with no radio connection!")
		return
	signal.data[RADIO_TRANSMITTER_SOURCE_ID_FIELD] = id
	radio_connection.post_signal(holder, signal, filter, range)

/datum/extension/interactive/radio_transmitter/proc/add_listener(obj/device as obj)
	if(!radio_connection)
		log_debug("[holder] tried to add a listener with no radio connections!")
		return
	radio_connection.add_listener(device, filter)

/datum/extension/interactive/radio_transmitter/proc/remove_listener(obj/device)
	if(!radio_connection)
		log_debug("[holder] tried to remove a listener with no radio connections!")
		return
	radio_connection.remove_listener(device)

//This handles "Topics" calls to the extension. So we can associate a UI to this and etc..
/datum/extension/interactive/radio_transmitter/extension_act(var/href, var/list/href_list, var/mob/user)
	if(href_list["set_radio_id"])
		var/newid = sanitize(href_list["set_radio_id"]) as text|null
		if(newid)
			set_id(newid)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid id!"))
	if(href_list["set_radio_filter"])
		var/newfiler = sanitize(href_list["set_radio_filter"]) as text|null
		if(newfiler)
			set_filter(newfiler)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid filter!"))
	if(href_list["set_radio_frequency"])
		var/newfreq = text2num(sanitize(href_list["set_radio_frequency"])) as num
		if(newfreq)
			set_frequency(newfreq)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid frequency!"))
	if(href_list["set_radio_range"])
		var/newrange = text2num(sanitize(href_list["set_radio_range"])) as num|null
		set_range(newrange)
	return ..()
