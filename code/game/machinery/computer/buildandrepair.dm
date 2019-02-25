#define CF_STATE_DEFAULT       0
#define CF_STATE_WRENCHED      1
#define CF_STATE_CIRCUIT_BOARD 2
#define CF_STATE_CABLED        3
#define CF_STATE_GLASS_PANEL   4
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = TRUE
	anchored = FALSE
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	atom_flags = ATOM_FLAG_CLIMBABLE
	mass = 40.0 //kg
	var/state = CF_STATE_DEFAULT
	var/obj/item/weapon/circuitboard/circuit = null

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(CF_STATE_DEFAULT) //0
			if(isWrench(P))
				var/obj/item/weapon/tool/T = P
				if(T.use_tool(user, src, 20))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					src.anchored = TRUE
					src.state = CF_STATE_WRENCHED
			if(isWelder(P))
				var/obj/item/weapon/tool/weldingtool/WT = P
				if(WT.use_tool(user, src, 20))
					if(!src) return
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
		if(CF_STATE_WRENCHED) //1
			if(isWrench(P))
				var/obj/item/weapon/tool/W = P
				if(W.use_tool(user, src, 2 SECONDS))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					src.anchored = FALSE
					src.state = CF_STATE_DEFAULT
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
					src.icon_state = "1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			if(isScrewdriver(P) && circuit)
				var/obj/item/weapon/tool/S = P
				if(S.use_tool(user, src, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You screw the circuit board into place."))
					src.state = CF_STATE_CIRCUIT_BOARD
					src.icon_state = "2"
			if(isCrowbar(P) && circuit)
				var/obj/item/weapon/tool/C = P
				if(C.use_tool(user, usr, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
					src.state = CF_STATE_WRENCHED
					src.icon_state = "0"
					circuit.loc = src.loc
					src.circuit = null
		if(CF_STATE_CIRCUIT_BOARD) //2
			if(isScrewdriver(P) && circuit)
				var/obj/item/weapon/tool/S = P
				if(S.use_tool(user, src, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
					src.state = CF_STATE_WRENCHED
					src.icon_state = "1"
			if(isCoil(P))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20, src) && state == CF_STATE_CIRCUIT_BOARD)
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = CF_STATE_CABLED
						icon_state = "3"
		if(CF_STATE_CABLED) //3
			if(isWirecutter(P))
				var/obj/item/weapon/tool/W = P
				if(W.use_tool(user, src, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					src.state = CF_STATE_CIRCUIT_BOARD
					src.icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
					A.amount = 5

			if(istype(P, /obj/item/stack/material) && P.get_material_name() == MATERIAL_GLASS)
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two sheets of glass to put in the glass panel."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to put in the glass panel."))
				if(do_after(user, 20, src) && state == CF_STATE_CABLED)
					if (G.use(2))
						to_chat(user, SPAN_NOTICE("You put in the glass panel."))
						src.state = CF_STATE_GLASS_PANEL
						src.icon_state = "4"
		if(CF_STATE_GLASS_PANEL) //4
			if(isCrowbar(P))
				var/obj/item/weapon/tool/C = P
				if(C.use_tool(user, usr, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You remove the glass panel."))
					src.state = CF_STATE_CABLED
					src.icon_state = "3"
					new /obj/item/stack/material/glass( src.loc, 2 )
			if(isScrewdriver(P))
				var/obj/item/weapon/tool/S = P
				if(S.use_tool(user, src, 1 SECOND))
					to_chat(user, SPAN_NOTICE("You connect the monitor."))
					var/B = new src.circuit.build_path ( src.loc )
					src.circuit.construct(B)
					qdel(src)

#undef CF_STATE_DEFAULT
#undef CF_STATE_WRENCHED
#undef CF_STATE_CIRCUIT_BOARD
#undef CF_STATE_CABLED
#undef CF_STATE_GLASS_PANEL