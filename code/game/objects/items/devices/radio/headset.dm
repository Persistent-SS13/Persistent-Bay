#define MAX_KEYS 10
/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	var/radio_desc = ""
	icon_state = "headset"
	item_state = "headset"
	matter = list(MATERIAL_STEEL = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	cell = null
	power_usage = 0
	var/translate_binary = 0
	var/translate_hive = 0
	var/list/encryption_keys = list()
	var/max_keys = 2
	var/list/custom_radio_keys = list() // Associative list of key : ch_name e.g. :en : engineering
	var/list/starter_keys = list()
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/ears.dmi')

/obj/item/device/radio/headset/New()
	..()
	ADD_SAVED_VAR(encryption_keys)
	ADD_SAVED_VAR(custom_radio_keys)

	ADD_SKIP_EMPTY(encryption_keys)
	ADD_SKIP_EMPTY(custom_radio_keys)

/obj/item/device/radio/headset/Initialize()
	. = ..()
	internal_channels.Cut()
	if(!map_storage_loaded)
		for(var/key in starter_keys)
			encryption_keys += new key(src)
	recalculateChannels(1)

/obj/item/device/radio/headset/after_load()
	recalculateChannels(1)

/obj/item/device/radio/headset/Destroy()
	QDEL_NULL_LIST(encryption_keys)
	starter_keys = null //The list contains types, so don't delete its content
	QDEL_NULL_LIST(custom_radio_keys)
	return ..()

/obj/item/device/radio/headset/list_channels(var/mob/user)
	return list_secure_channels()

/obj/item/device/radio/headset/examine(mob/user)
	if(!(..(user, 1) && radio_desc))
		return

	to_chat(user, "The following channels are available:")
	to_chat(user, radio_desc)

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/language/binary = all_languages["Robot Talk"]
			binary.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = all_languages["Hivemind"]
			hivemind.broadcast(M, message)
		return null

	return ..()

/obj/item/device/radio/headset/receive_range(freq, level, faction_uid, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level, faction_uid)
	return -1

/obj/item/device/radio/headset/syndicate
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	starter_keys = list(/obj/item/device/encryptionkey/syndicate)

/obj/item/device/radio/headset/syndicate/alt
	icon_state = "syndie_headset"
	item_state = "syndie_headset"

/obj/item/device/radio/headset/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)

/obj/item/device/radio/headset/raider
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1
	starter_keys = list(/obj/item/device/encryptionkey/raider)

/obj/item/device/radio/headset/raider/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)

/obj/item/device/radio/headset/binary
	origin_tech = list(TECH_ILLEGAL = 3)
	starter_keys = list(/obj/item/device/encryptionkey/binary)

/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_sec)

/obj/item/device/radio/headset/headset_sec/alt
	name = "security bowman headset"
	icon_state = "sec_headset_alt"
	item_state = "sec_headset_alt"

/obj/item/device/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_eng)

/obj/item/device/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	icon_state = "eng_headset_alt"
	item_state = "eng_headset_alt"

/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_rob)

/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_med)

/obj/item/device/radio/headset/headset_med/alt
	name = "medical bowman headset"
	icon_state = "med_headset_alt"
	item_state = "med_headset_alt"

/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_sci)

/obj/item/device/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "med_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_medsci)

/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_com)

/obj/item/device/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	starter_keys = list(/obj/item/device/encryptionkey/headset_com)
	max_keys = 3

/obj/item/device/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/captain)

/obj/item/device/radio/headset/heads/captain/alt
	name = "captain's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/heads/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/ai_integrated)
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via inteliCard menu.

/obj/item/device/radio/headset/heads/ai_integrated/Destroy()
	myAi = null
	. = ..()

/obj/item/device/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/heads/rd
	name = "research director's headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/rd)

/obj/item/device/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/hos)

/obj/item/device/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/ce)

/obj/item/device/radio/headset/heads/ce/alt
	name = "chief engineer's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/cmo)

/obj/item/device/radio/headset/heads/cmo/alt
	name = "chief medical officer's bowman headset"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"

/obj/item/device/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/hop)

/obj/item/device/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon_state = "srv_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_service)

/obj/item/device/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/ert)

/obj/item/device/radio/headset/foundation
	name = "\improper Foundation radio headset"
	desc = "The headeset of the occult cavalry."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/ert)

/obj/item/device/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/heads/hos)

/obj/item/device/radio/headset/headset_mining
	name = "mining radio headset"
	desc = "Headset used by dwarves. It has an inbuilt subspace antenna for better reception."
	icon_state = "mine_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_mining)

/obj/item/device/radio/headset/headset_mining/alt
	name = "mining bowman radio headset"
	icon_state = "mine_headset_alt"
	item_state = "mine_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the box-pushers."
	icon_state = "cargo_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/headset_cargo)

/obj/item/device/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	icon_state = "cargo_headset_alt"
	item_state = "cargo_headset_alt"
	max_keys = 3

/obj/item/device/radio/headset/entertainment
	name = "actor's radio headset"
	desc = "specially made to make you sound less cheesy."
	icon_state = "com_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/entertainment)

/obj/item/device/radio/headset/specops
	name = "special operations radio headset"
	desc = "The headset of the spooks."
	icon_state = "cent_headset"
	item_state = "headset"
	starter_keys = list(/obj/item/device/encryptionkey/specops)

/obj/item/device/radio/headset/attackby(obj/item/weapon/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if (!( isScrewdriver(W) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(isScrewdriver(W))
		if(encryption_keys && encryption_keys.len)

			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null
			if(custom_channels && custom_channels.len)
				for(var/ch_name in custom_channels)
					radio_controller.remove_object(src, custom_channels[ch_name])
					secure_radio_connections[ch_name] = null

			for(var/obj/item/device/encryptionkey/key in encryption_keys)
				var/turf/T = get_turf(user)
				if(T)
					key.loc = T

			encryption_keys = list()

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(encryption_keys.len >= max_keys)
			to_chat(user, "The headset can't hold another key!")
			return
		if(user.unEquip(W, target = src))
			to_chat(user, "<span class='notice'>You put \the [W] into \the [src].</span>")
			encryption_keys += W
			recalculateChannels(1)

/obj/item/device/radio/headset/MouseDrop(var/obj/over_object)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && (src in M) && CanUseTopic(M))
		return attack_self(M)
	return

/obj/item/device/radio/headset/recalculateChannels(var/setDescription = 0)
	src.channels = list()
	src.custom_channels = list()
	src.custom_radio_keys = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0
	for(var/obj/ekey in encryption_keys)
		import_key_data(ekey)
	for (var/ch_name in channels)
		if(!radio_controller)
			sleep(30) // Waiting for the radio_controller to be created.
		if(!radio_controller)
			src.SetName("broken radio headset")
			return
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	for (var/ch_name in custom_channels)
		if(!radio_controller)
			src.name = "broken radio headset"
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, custom_channels[ch_name],  RADIO_CHAT)


	if(setDescription)
		setupRadioDescription()

/obj/item/device/radio/headset/proc/import_key_data(obj/item/device/encryptionkey/key)
	if(!key)
		return
	if(!istype(key, /obj/item/device/encryptionkey/custom))
		for(var/ch_name in key.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = key.channels[ch_name]
		if(key.translate_binary)
			src.translate_binary = 1
		if(key.translate_hive)
			src.translate_hive = 1
		if(key.syndie)
			src.syndie = 1
	else// Custom channels
		var/obj/item/device/encryptionkey/custom/cust_key = key
		if(!istype(cust_key))
			return
		if(cust_key.ch_name in src.custom_channels || cust_key.rad_key in src.custom_radio_keys)
			return
		src.custom_channels += cust_key.ch_name
		src.custom_channels[cust_key.ch_name] = cust_key.freq

		src.custom_radio_keys += cust_key.rad_key
		src.custom_radio_keys[cust_key.rad_key] = cust_key.ch_name

/obj/item/device/radio/headset/proc/setupRadioDescription()
	var/radio_text = ""
	for(var/i = 1 to channels.len)
		var/channel = channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != channels.len)
			radio_text += ", "

	for(var/i = 1 to custom_channels.len)
		var/channel = custom_channels[i]
		var/key
		for(var/radio_key in custom_radio_keys)
			if(radio_key == channel)
				key = radio_key
		if(key)
			radio_text += "[key] - [channel]"
			if(i != custom_channels.len)
				radio_text += ", "

	radio_desc = radio_text

#undef MAX_KEYS
