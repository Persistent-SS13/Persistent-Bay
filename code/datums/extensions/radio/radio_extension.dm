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
	var/filter_in  = RADIO_DEFAULT
	var/filter_out = RADIO_DEFAULT
	var/id = null
	var/range = null
	should_save = TRUE

/datum/extension/interactive/radio_transmitter/New(var/idtag = null, var/range = null, var/filter = RADIO_DEFAULT, var/filterout = null)
	..()
	ADD_SAVED_VAR(radio_connection)
	ADD_SAVED_VAR(filter_in)
	ADD_SAVED_VAR(filter_out)
	ADD_SAVED_VAR(id)
	ADD_SAVED_VAR(range)

	ADD_SKIP_EMPTY(radio_connection)
	if(!map_storage_loaded)
		src.id         = idtag
		src.range      = range
		src.filter_in  = filter
		src.filter_out = (filterout)? filterout : filter

/datum/extension/interactive/radio_transmitter/after_load()
	..()
	//Reset connection, since the datum will be in a limbo state on load, and we really just need the frequency to reset it
	if(src.radio_connection)
		set_frequency(src.radio_connection.frequency)

/datum/extension/interactive/radio_transmitter/Destroy()
	if(src.radio_connection)
		radio_controller.remove_object(src.holder, src.radio_connection.frequency)
		QDEL_NULL(src.radio_connection)
	return ..()

/datum/extension/interactive/radio_transmitter/proc/is_connected()
	return src.radio_connection? TRUE : FALSE

/datum/extension/interactive/radio_transmitter/proc/set_frequency(var/newfreq)
	if(src.radio_connection)
		radio_controller.remove_object(src.holder, src.radio_connection.frequency)
		QDEL_NULL(src.radio_connection)
	src.radio_connection = radio_controller.add_object(holder, newfreq, filter_in)

/datum/extension/interactive/radio_transmitter/proc/get_frequency()
	return src.radio_connection? src.radio_connection.frequency : null

/datum/extension/interactive/radio_transmitter/proc/set_filter(var/filter, var/filterout = null)
	if(!filter)
		return
	src.filter_in = filter
	src.filter_out = (filterout)? filterout : filter
	if(radio_connection)
		set_frequency(radio_connection.frequency) //reset connection

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

//Compare two ids and return true if identical
/datum/extension/interactive/radio_transmitter/proc/signal_match_id(var/datum/signal/signal)
	return signal && islist(signal.data) && signal.data[RADIO_TRANSMITTER_ID_FIELD] == src.id

/datum/extension/interactive/radio_transmitter/proc/set_range(var/newrange)
	src.range = newrange
/datum/extension/interactive/radio_transmitter/proc/get_range()
	return src.range

/datum/extension/interactive/radio_transmitter/proc/post_signal(datum/signal/signal, var/overridefilter = null)
	if(!src.radio_connection)
		log_debug("[src.holder] tried to send a signal with no radio connection!")
		return
	signal.data[RADIO_TRANSMITTER_SOURCE_ID_FIELD] = src.id
	src.radio_connection.post_signal(src.holder, signal, (overridefilter)? overridefilter : src.filter_out, src.range)

/datum/extension/interactive/radio_transmitter/proc/add_listener(obj/device as obj)
	if(!src.radio_connection)
		log_debug("[src.holder] tried to add a listener with no radio connections!")
		return
	src.radio_connection.add_listener(device, src.filter_in)

/datum/extension/interactive/radio_transmitter/proc/remove_listener(obj/device)
	if(!src.radio_connection)
		log_debug("[src.holder] tried to remove a listener with no radio connections!")
		return
	src.radio_connection.remove_listener(device)

//This handles "Topics" calls to the extension. So we can associate a UI to this and etc..
/datum/extension/interactive/radio_transmitter/extension_act(var/href, var/list/href_list, var/mob/user)
	if(href_list["set_radio_id"])
		var/newid = sanitize(href_list["set_radio_id"]) as text|null
		if(newid)
			src.set_id(newid)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid id!"))
	if(href_list["set_radio_filter"])
		var/newfiler = sanitize(href_list["set_radio_filter"]) as text|null
		if(newfiler)
			src.set_filter(newfiler)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid filter!"))
	if(href_list["set_radio_filter_out"])
		var/newfiler = sanitize(href_list["set_radio_filter_out"]) as text|null
		if(newfiler)
			src.set_filter_out(newfiler)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid filter!"))
	if(href_list["set_radio_frequency"])
		var/newfreq = text2num(sanitize(href_list["set_radio_frequency"])) as num
		if(newfreq)
			src.set_frequency(newfreq)
		else if(user)
			to_chat(user, SPAN_WARNING("Invalid frequency!"))
	if(href_list["set_radio_range"])
		var/newrange = text2num(sanitize(href_list["set_radio_range"])) as num|null
		src.set_range(newrange)
	return ..()
