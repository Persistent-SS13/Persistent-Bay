/obj/machinery/computer/curer
	name = "cure research machine"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	circuit = /obj/item/weapon/circuitboard/curefab
	active_power_usage = 500//Watts
	idle_power_usage = 50
	var/curing = FALSE
	var/virusing = FALSE
	var/obj/item/weapon/reagent_containers/container = null
	var/obj/item/weapon/virusdish/dish = null
	var/time_curing_end
	var/time_virusing_end

/obj/machinery/computer/curer/New()
	..()
	ADD_SAVED_VAR(curing)
	ADD_SAVED_VAR(virusing)
	ADD_SAVED_VAR(container)
	ADD_SAVED_VAR(time_curing_end)
	ADD_SAVED_VAR(time_virusing_end)
	ADD_SAVED_VAR(dish)
	ADD_SKIP_EMPTY(container)
	ADD_SKIP_EMPTY(time_curing_end)
	ADD_SKIP_EMPTY(time_virusing_end)
	ADD_SKIP_EMPTY(dish)

/obj/machinery/computer/curer/before_save()
	. = ..()
	//Convert to absolute time
	if(curing && time_curing_end)
		time_curing_end = world.time - time_curing_end
	if(virusing && time_virusing_end)
		time_virusing_end = world.time - time_virusing_end

/obj/machinery/computer/curer/after_load()
	. = ..()
	//Convert to relative time
	if(curing && time_curing_end)
		time_curing_end = world.time + time_curing_end
	if(virusing && time_virusing_end)
		time_virusing_end = world.time + time_virusing_end

/obj/machinery/computer/curer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, I))
		return 1
	else if(default_deconstruction_crowbar(user, I))
		return 1
	else if(istype(I,/obj/item/weapon/reagent_containers))
		if(!container)
			if(!user.unEquip(I, src))
				return
			container = I
		return 1
	else if(istype(I,/obj/item/weapon/virusdish))
		if(virusing)
			to_chat(user, "<b>The pathogen materializer is still recharging..</b>")
			return
		if(dish)
			to_chat(user, SPAN_WARNING("There is already a virus dish."))
			return
		dish = I
		user.drop_from_inventory(I)
		I.forceMove(src)
		virusing = 1
		time_virusing_end = world.time + 120 SECONDS
		return 1
	else
		return ..()

/obj/machinery/computer/curer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress.. [(time_curing_end - world.time) / 1 SECONDS] seconds left.."
	else if(virusing)
		dat = "Virus production in progress.. [(time_virusing_end - world.time) / 1 SECONDS] seconds left.."
	else if(container)
		// see if there's any blood in the container
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in container.reagents.reagent_list

		if(B)
			dat = "Blood sample inserted."
			dat += "<BR>Antibodies: [antigens2string(B.data["antibodies"])]"
			dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/curer/Process()
	..()
	if(inoperable())
		return
	
	if(curing && world.time > time_curing_end)
		curing = FALSE
		time_curing_end = null
		createcure()
	if(virusing && world.time > time_virusing_end)
		virusing = FALSE
		time_virusing_end = null
		createvirus()
	return

/obj/machinery/computer/curer/OnTopic(var/mob/living/user, href_list)
	if (href_list["antibody"])
		curing = TRUE
		time_curing_end = world.time + 10 SECONDS
		. = TOPIC_REFRESH
	else if(href_list["eject"])
		container.dropInto(loc)
		if(Adjacent(user) && !issilicon(user))
			user.put_in_hands(container)
		container = null
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/computer/curer/proc/createvirus()
	if(!dish)
		state("No virus dish inserted!")
		return
	var/obj/item/weapon/reagent_containers/glass/beaker/product = new(src.loc)
	var/list/data = list("donor" = null, "donor_name" = "", "blood_DNA" = null, "blood_type" = null, "trace_chem" = null, "virus2" = list(), "antibodies" = list())
	data["virus2"] |= dish.virus2
	product.reagents.add_reagent(/datum/reagent/blood,30,data)
	state("\The [src] Buzzes", "blue")
	dish.forceMove(get_turf(src))
	dish = null

/obj/machinery/computer/curer/proc/createcure()
	if(!container)
		state("Error: No container present to receive cure!", "red")
		return

	var/obj/item/weapon/reagent_containers/glass/beaker/product = new(src.loc)

	var/datum/reagent/blood/B = locate() in container.reagents.reagent_list

	var/list/data = list()
	data["antibodies"] = B.data["antibodies"]
	product.reagents.add_reagent(/datum/reagent/antibodies,30,data)

	state("\The [src.name] buzzes", "blue")
