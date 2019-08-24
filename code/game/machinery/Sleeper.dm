#define SLEEPER_MAX_CARTRIDGES 32

#define SLEEPER_LOWEST_STASIS	1
#define SLEEPER_LOW_STASIS		5
#define SLEEPER_MID_STASIS		10
#define SLEEPER_MAX_STASIS		25

#define SLEEPER_MAX_CHEM_UNITS  30 //maximum quantity of a chem we can inject in a single person at a time

/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner. Uses reagent cartridges. Alt + click to remove a cartridge."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = TRUE
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	var/mob/living/carbon/human/occupant = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = FALSE
	var/pump = FALSE
	var/list/stasis_settings = list(SLEEPER_LOWEST_STASIS,SLEEPER_LOW_STASIS, SLEEPER_MID_STASIS, SLEEPER_MAX_STASIS)
	var/stasis = SLEEPER_LOW_STASIS
	var/synth_modifier = 1
	var/pump_speed

	var/efficiency
	var/initial_bin_rating = 1
	var/min_treatable_health = 25

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

	//For chems handling
	var/list/cartridges = null
	var/amount_injected = 5
	var/list/amount_injectable = list(0.5, 1, 5, 10, 15)


/obj/machinery/sleeper/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/sleeper(src)

	// Customizable bin rating, used by the labor camp to stop people filling themselves with chemicals and escaping.
	var/obj/item/weapon/stock_parts/matter_bin/B = new(src)
	B.rating = initial_bin_rating
	component_parts += B

	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 1)
	RefreshParts()

/obj/machinery/sleeper/RefreshParts()
	var/E
	var/I
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		E += B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		I += M.rating

	efficiency = E
	min_treatable_health = -E * 25

/obj/machinery/sleeper/Initialize()
	. = ..()
	if(!map_storage_loaded)
		beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	if(!cartridges)
		cartridges = list()
	update_icon()

/obj/machinery/sleeper/Process()
	if(inoperable())
		return

	active_power_usage = 200

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, pump_speed)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
				active_power_usage += 25
		else
			toggle_filter()
	if(pump > 0)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/datum/reagents/ingested = occupant.get_ingested_reagents()
				if(ingested)
					for(var/datum/reagent/x in ingested.reagent_list)
						ingested.trans_to_obj(beaker, pump_speed)
				active_power_usage += 100
		else
			toggle_pump()

	if(iscarbon(occupant))
		occupant.SetStasis(stasis)
		active_power_usage += stasis * 10

/obj/machinery/sleeper/on_update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.outside_state)
	var/list/data = list()

	data["power"] = inoperable() ? 0 : 1

	var chemicals[0]
	for(var/label in cartridges)
		var/obj/item/weapon/reagent_containers/chem_disp_cartridge/cart = cartridges[label]
		var/list/cartdata = list("name" = label, "amount" = cart.reagents.total_volume )
		if(occupant && occupant.reagents)
			cartdata["contained"] = occupant.reagents.get_reagent_amount(cart.reagents.get_master_reagent_type())
		chemicals[++chemicals.len] = cartdata
	data["chemicals"] = chemicals

	if(occupant)
		var/scan = user.skill_check(SKILL_MEDICAL, SKILL_ADEPT) ? medical_scan_results(occupant) : "<span class='white'><b>Contains: \the [occupant]</b></span>"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		data["occupant"] =scan
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering
	data["pump"] = pump
	data["stasis"] = stasis
	data["skill_check"] = user.skill_check(SKILL_MEDICAL, SKILL_BASIC)
	data["stasis_modes"] = stasis_settings.Copy()
	data["amount_injectable"] = amount_injectable
	data["amount_injected"] = amount_injected

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 800, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/sleeper/CanUseTopic(user)
	if(user == occupant)
		to_chat(usr, "<span class='warning'>You can't reach the controls from the inside.</span>")
		return STATUS_CLOSE
	. = ..()

/obj/machinery/sleeper/OnTopic(user, href_list)
	add_fingerprint(user)
	if(href_list["eject"])
		go_out()
		return TOPIC_REFRESH
	if(href_list["beaker"])
		remove_beaker()
		return TOPIC_REFRESH
	if(href_list["filter"])
		var/filterstate = text2num(href_list["filter"])
		if(filtering != filterstate)
			set_filter(filterstate)
			return TOPIC_REFRESH
	if(href_list["pump"])
		var/pumpstate = text2num(href_list["pump"])
		if(pump != pumpstate)
			set_pump(pumpstate)
			return TOPIC_REFRESH
	if(href_list["quantity_index"])
		var/quantity_index = text2num(href_list["quantity_index"]) + 1
		if(quantity_index <= amount_injectable.len && quantity_index > 0)
			amount_injected = amount_injectable[quantity_index]
			return TOPIC_REFRESH
	if(href_list["inject"])
		if(occupant)
			if(href_list["inject"] in cartridges) // Your hacks are bad and you should feel bad
				inject_chemical(usr, href_list["inject"], amount_injected)
				return TOPIC_REFRESH
	if(href_list["stasis_index"])
		var/stasis_index = text2num(href_list["stasis_index"]) + 1 //nano ui indices begin at 0 for some reasons
		if(stasis_index <= stasis_settings.len && stasis_index > 0)
			stasis = stasis_settings[stasis_index]
			change_power_consumption(initial(active_power_usage) + 5 KILOWATTS * (stasis_index-1), POWER_USE_ACTIVE)
			return TOPIC_REFRESH

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel before attempting to place the subject in the sleeper.</span>")
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(inoperable())
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)

/obj/machinery/sleeper/proc/toggle_filter()
	set_filter(!filtering)

/obj/machinery/sleeper/proc/set_filter(var/state)
	if(!occupant || !beaker)
		filtering = FALSE
		return
	to_chat(occupant, "<span class='warning'>You feel like your blood is being sucked away.</span>")
	filtering = state

/obj/machinery/sleeper/proc/toggle_pump()
	set_pump(!pump)

/obj/machinery/sleeper/proc/set_pump(var/state)
	if(!occupant || !beaker)
		pump = FALSE
		return
	to_chat(occupant, "<span class='warning'>You feel a tube jammed down your throat.</span>")
	pump = state

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return FALSE
	if(inoperable())
		return FALSE
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return FALSE

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return FALSE
		set_occupant(M)
		return TRUE
	return FALSE

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	set_occupant(null)
	var/list/ejectable_content = InsertedContents()
	for(var/key in cartridges)
		ejectable_content -= cartridges[key]
	for(var/obj/O in ejectable_content) // In case an object was dropped inside or something. Excludes the beaker and component parts.
		if(O == beaker)
			continue
		O.dropInto(loc)
	update_use_power(1)
	update_icon()
	toggle_filter()

/obj/machinery/sleeper/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	update_icon()
	if(!occupant)
		SetName(initial(name))
		update_use_power(POWER_USE_IDLE)
		return
	occupant.forceMove(src)
	occupant.stop_pulling()
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	SetName("[name] ([occupant])")
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.dropInto(loc)
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical_name, var/amount)
	if(inoperable())
		return

	var/obj/item/weapon/reagent_containers/chem_disp_cartridge/cart = cartridges[chemical_name]
	if(!cart)
		return //Someone has an outdated UI display
	var/chemical_type = cart.reagents.get_master_reagent_type()

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical_type) + amount <= SLEEPER_MAX_CHEM_UNITS)
			cart.reagents.trans_to_mob(occupant, amount,CHEM_BLOOD)
			to_chat(user, "<span class='notice'>Occupant now has [occupant.reagents.get_reagent_amount(chemical_type)] unit\s of [chemical_name] in their bloodstream.</span>")
		else
			to_chat(user, "<span class='warning'>The subject has too much of that chemical in their bloodstream.</span>")
	else
		to_chat(user, "<span class='warning'>There's no suitable occupant in \the [src].</span>")


/obj/machinery/sleeper/attackby(var/obj/item/O as obj, var/mob/user as mob)
	add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	else if(default_deconstruction_crowbar(user, O))
		return
	else if(default_part_replacement(user, O))
		return
	else if(istype(O, /obj/item/grab/normal))
		var/obj/item/grab/normal/G = O
		if(ismob(G.affecting) && go_in(G.affecting, user))
			qdel(G)
		return
	else if(istype(O, /obj/item/weapon/reagent_containers/chem_disp_cartridge))
		add_cartridge(O, user)
		return
	else if(istype(O, /obj/item/weapon/reagent_containers/glass) || istype(O, /obj/item/weapon/reagent_containers/food))
		if(beaker)
			to_chat(user, "<span class='warning'>There is already \a [beaker] on \the [src]!</span>")
			return

		var/obj/item/weapon/reagent_containers/RC = O

		if(istype(RC,/obj/item/weapon/reagent_containers/food))
			to_chat(user, "<span class='warning'>This machine only accepts beakers!</span>")
			return

		if(!RC.is_open_container())
			to_chat(user, "<span class='warning'>There's no opening for \the [src] to pour into \the [RC].</span>")
			return

		beaker =  RC
		user.drop_from_inventory(RC)
		RC.loc = src
		update_icon()
		to_chat(user, "<span class='notice'>You set \the [RC] on \the [src].</span>")
		SSnano.update_uis(src) // update all UIs attached to src
	else
		..()
	return

/obj/machinery/sleeper/AltClick(var/mob/user)
	var/label = input(user, "Which cartridge would you like to remove?", "Chemical Dispenser") as null|anything in cartridges
	if(!label) return
	var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
	if(C)
		to_chat(user, "<span class='notice'>You remove \the [C] from \the [src].</span>")
		C.loc = loc
	..()

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	if (. && user.Adjacent(src))
		to_chat(user, "It has [cartridges.len] cartridges installed, and has space for [SLEEPER_MAX_CARTRIDGES - cartridges.len] more.")
		if (beaker)
			to_chat(user, "It is loaded with a beaker.")
		if(occupant)
			occupant.examine(user)
		if (emagged && user.skill_check(SKILL_MEDICAL, SKILL_EXPERT))
			to_chat(user, "The sleeper chemical synthesis controls look tampered with.")


/obj/machinery/sleeper/proc/add_cartridge(obj/item/weapon/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, "<span class='warning'>\The [C] will not fit in \the [src]!</span>")
		return
	if(cartridges.len >= SLEEPER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] does not have any slots open for \the [C] to fit into!</span>")
		return

	if(!C.get_first_label())
		if(user)
			to_chat(user, "<span class='warning'>\The [C] does not have a label!</span>")
		return

	if(cartridges[C.get_first_label()])
		if(user)
			to_chat(user, "<span class='warning'>\The [src] already contains a cartridge with that label!</span>")
		return

	if(user)
		user.drop_from_inventory(C)
		to_chat(user, "<span class='notice'>You add \the [C] to \the [src].</span>")

	C.loc = src
	cartridges[C.get_first_label()] = C
	cartridges = sortAssoc(cartridges)
	SSnano.update_uis(src)

/obj/machinery/sleeper/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SSnano.update_uis(src)

#undef SLEEPER_MAX_CARTRIDGES
#undef SLEEPER_MAX_CHEM_UNITS
#undef SLEEPER_LOWEST_STASIS
#undef SLEEPER_LOW_STASIS
#undef SLEEPER_MID_STASIS
#undef SLEEPER_MAX_STASIS
