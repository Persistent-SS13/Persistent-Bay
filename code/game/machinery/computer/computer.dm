/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	clicksound = "keyboard"
	frame_type = /obj/structure/computerframe

	var/circuit = null //The path to the circuit board type. If circuit==null, the computer can't be disassembled.
	var/processing = FALSE
	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_max_bright_on = 0.2
	var/light_inner_range_on = 0.1
	var/light_outer_range_on = 2
	var/overlay_layer

/obj/machinery/computer/New()
	overlay_layer = layer
	..()

/obj/machinery/computer/Initialize()
	. = ..()
	power_change()
	queue_icon_update()

/obj/machinery/computer/on_update_icon()
	overlays.Cut()
	if(!ispowered() || isoff())
		set_light(0)
		if(icon_keyboard)
			overlays += image(icon,"[icon_keyboard]_off", overlay_layer)
		return
	else
		set_light(light_max_bright_on, light_inner_range_on, light_outer_range_on, 2, light_color)

	if(isbroken())
		overlays += image(icon,"[icon_state]_broken", overlay_layer)
	else
		overlays += image(icon,icon_screen, overlay_layer)

	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(var/obj/item/weapon/tool/I, var/mob/user)
	if(isScrewdriver(I) && circuit)
		to_chat(user, SPAN_NOTICE("You begin disassembling the computer monitor.."))
		if(I.use_tool(user, src, 20))
			to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
			dismantle()
		return TRUE
	return ..()


/obj/machinery/computer/dismantle()
	var/obj/structure/computerframe/A = new frame_type(src.loc)
	var/obj/item/weapon/circuitboard/M = new circuit(A)
	A.set_dir(dir)
	A.circuit = M
	A.anchored = TRUE
	for (var/obj/C in src)
		C.dropInto(src.loc)
	if (src.isbroken())
		to_chat(usr, SPAN_NOTICE("The broken glass falls out."))
		new /obj/item/weapon/material/shard(src.loc)
		A.state = 3
		A.icon_state = "3"
	else
		A.state = 4
		A.icon_state = "4"
	M.deconstruct(src)
	qdel(src)


/obj/machinery/computer/attack_ghost(var/mob/ghost)
	attack_hand(ghost)
