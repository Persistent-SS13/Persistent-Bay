#define SM_CORE_SIZE 100

/obj/machinery/phoron_desublimer/resonant_chamber
	name = "Resonant Chamber"
	desc = "Uses subspace resonance to restructure multiple pieces of supermatter into one. It freezes time within, and can be unbolted from the floor, so it is also an ideal container to transport dangerous supermatter."
	icon_state = "resonant_chamber"

	anchored = 1

	var/max_pieces = 8
	var/list/sm_pieces = list()

/obj/machinery/phoron_desublimer/resonant_chamber/Destroy()
	for( var/sm_piece in sm_pieces )
		qdel( sm_piece )

	..()

/obj/machinery/phoron_desublimer/resonant_chamber/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return

	if(istype(B, /obj/item/weapon/wrench))
		switch (anchored)
			if (0)
				user.visible_message("[user] starts tightening the bolts on \the [src].", "You start tightening the bolts on \the [src].")
			if (1)
				user.visible_message("[user] starts unfastening the bolts on \the [src].", "You start unfastening the bolts on \the [src].")

		if(do_after(user, 20))
			if(!src) return
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			switch (anchored)
				if (0)
					anchored = 1
					user.visible_message("[user] tightens the bolts securing \the [src] to the floor.", "You tighten the bolts securing \the [src] to the floor.")
				if (1)
					user.visible_message("[user] unfastens the bolts securing \the [src] to the floor.", "You unfasten the bolts securing \the [src] to the floor.")
					anchored = 0
		return

	if(istype( B, /obj/item/weapon/shard/metaphoron ))
		if( sm_pieces.len < max_pieces )
			user.drop_item()
			B.loc = src
			sm_pieces += B
			user << "You put [B] into the machine."
		else
			user << "<span class='notice'>The machine is full!</span>"
	else
		user << "<span class='notice'>This machine only accepts supermatter.</span>"

	return

/obj/machinery/phoron_desublimer/resonant_chamber/Bumped(atom/AM as mob|obj)
	if( anchored )
		if( istype( AM, /obj/machinery/power/supermatter ))
			if( sm_pieces.len < max_pieces )
				var/obj/machinery/power/supermatter/SM = AM
				SM.loc = src
				sm_pieces += SM
				src.visible_message("\icon[src] <b>[src]</b> beeps, \"[SM] loaded.\"")
			else
				src.visible_message("\icon[src] <b>[src]</b> beeps, \"Machine is too full to load \the [AM].\"")

	..()

/obj/machinery/phoron_desublimer/resonant_chamber/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if( !anchored )
		return

	var/choice = input( user, "What would you like to do?", \
                        "Resonant Chamber", \
                        "Cancel") in list("Combine", "Eject", "Cancel")

	switch( choice )
		if( "Combine" )
			if( !active )
				combine()
			else
				user << "<span class='notice'>This machine is already active!</span>"
			return
		if( "Eject" )
			eject( user )
			return
		if( "Cancel" )
			return

/obj/machinery/phoron_desublimer/resonant_chamber/proc/combine()
	var/total_size = 0
	active = 1

	playsound(loc, 'sound/effects/neutron_charge.ogg', 50, 1, -1)
	flick( "resonant_chamber_on", src )
	sleep(20)
	playsound(loc, 'sound/machines/ding.ogg', 50, 1, -1)

	for( var/sm_piece in sm_pieces )
		if( istype( sm_piece, /obj/item/weapon/shard/metaphoron ))
			var/obj/item/weapon/shard/metaphoron/shard = sm_piece
			total_size += shard.size + ( 15*( shard.smlevel/MAX_SUPERMATTER_LEVEL )) // A max level shard will add +15 to its size
		if( istype( sm_piece, /obj/machinery/power/supermatter ))
			var/obj/machinery/power/supermatter/core = sm_piece
			total_size += ( SM_CORE_SIZE*core.smlevel ) // A level 3 core is worth as many as three level 1 cores

	for( var/sm_piece in sm_pieces )
		qdel( sm_piece )

	sm_pieces.Cut()

	if( total_size > SM_CORE_SIZE )
		var/smlevel = round( total_size/SM_CORE_SIZE )
		var/obj/machinery/power/supermatter/core = new ( src, smlevel )
		sm_pieces += core
	else
		var/obj/item/weapon/shard/metaphoron/shard = new( src, 1, total_size )
		sm_pieces += shard

	active = 0

/obj/machinery/phoron_desublimer/resonant_chamber/proc/eject( mob/user as mob )
	var/obj/sm_piece = input( user, "What would you like to eject?", \
                    		  		"Resonant Chamber", \
                    		  		null ) in sm_pieces

	if( !sm_piece )
		return

	sm_piece.loc = get_turf( src )
	sm_pieces -= sm_piece

#undef SM_CORE_SIZE
