/obj/structure/anomaly_container
	name = "anomaly container"
	desc = "Used to safely contain and move anomalies."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anomaly_container"
	density = 1
	matter = list(MATERIAL_PLASTEEL = 10 SHEETS)

	var/obj/machinery/artifact/contained

/obj/structure/anomaly_container/New()
	. = ..()
	ADD_SAVED_VAR(contained)

/obj/structure/anomaly_container/Destroy()
	contained = null
	. = ..()

/obj/structure/anomaly_container/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/anomaly_container/LateInitialize()
	. = ..()
	if(!map_storage_loaded)
		var/obj/machinery/artifact/A = locate() in loc
		if(A)
			contain(A)

/obj/structure/anomaly_container/attackby(obj/item/O, mob/user)
	if(default_deconstruction_wrench(O, user, 10 SECONDS))
		dismantle()
		return 1
	else
		return ..()

/obj/structure/anomaly_container/attack_hand(var/mob/user)
	release()

/obj/structure/anomaly_container/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/anomaly_container/proc/contain(var/obj/machinery/artifact/artifact)
	if(contained)
		return
	contained = artifact
	artifact.forceMove(src)
	underlays += image(artifact)
	desc = "Used to safely contain and move anomalies. \The [contained] is kept inside."

/obj/structure/anomaly_container/proc/release()
	if(!contained)
		return
	contained.dropInto(src)
	contained = null
	underlays.Cut()
	desc = initial(desc)

/obj/machinery/artifact/MouseDrop(var/obj/structure/anomaly_container/over_object)
	if(istype(over_object) && Adjacent(over_object) && CanMouseDrop(over_object, usr))
		Bumped(usr)
		over_object.contain(src)