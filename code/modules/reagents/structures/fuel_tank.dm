/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A tank containing fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	initial_reagent_types = list(/datum/reagent/fuel = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/fueltank/empty
	initial_reagent_types = null

/obj/structure/reagent_dispensers/fueltank/New()
	. = ..()
	ADD_SAVED_VAR(modded)
	ADD_SAVED_VAR(rig)
	ADD_SKIP_EMPTY(rig)

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	if(!..(user, 2))
		return
	if (modded)
		to_chat(user, "<span class='warning'>Fuel faucet is wrenched open, leaking the fuel!</span>")
	if(rig)
		to_chat(user, "<span class='notice'>There is some kind of device rigged to the tank.</span>")

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message("<span class='notice'>\The [usr] begins to detach [rig] from \the [src].</span>", "<span class='notice'>You begin to detach [rig] from \the [src].</span>")
		if(do_after(usr, 20, src))
			usr.visible_message("<span class='notice'>\The [usr] detaches \the [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.loc = get_turf(usr)
			rig = null
			overlays = new/list()
	else
		return ..()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W,/obj/item/weapon/tool/wrench))
		user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		if (modded)
			message_admins("[key_name_admin(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
			log_game("[key_name(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)
	else if (istype(W,/obj/item/device/assembly_holder))
		if (rig)
			to_chat(user, "<span class='warning'>There is another device in the way.</span>")
			return ..()
		user.visible_message("\The [user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>The [user] rigs [W] to \the [src].</span>", "<span class='notice'>You rig [W] to \the [src].</span>")

			var/obj/item/device/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.")

			rig = W
			user.drop_item()
			W.loc = src

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test

	else if(isflamesource(W))
		log_and_message_admins("triggered a fueltank explosion with \a [W].")
		user.visible_message("<span class='danger'>\The [user] puts \the [W] to \the [src]!</span>", "<span class='danger'>You put \the [W] to \the [src] and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.</span>")
		explode()
		return

	else if(isScrewdriver(W))
		src.add_fingerprint(user)
		if(reagents.total_volume == 0)
			to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
			if(do_after(user, 20, src))
				if(!src) return
				to_chat(user, "<span class='notice'>You finish dismantling \the [src].</span>")
				new /obj/item/stack/material/steel(src.loc, 10)
				qdel(src)
		else
			to_chat(user, "<span class='notice'>Empty it first!</span>")

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			var/turf/turf = get_turf(src)
			if(turf)
				var/area/area = turf.loc || "*unknown area*"
				message_admins("[key_name_admin(Proj.firer)] shot a fueltank in \the [area] ([turf.x],[turf.y],[turf.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[turf.x];Y=[turf.y];Z=[turf.z]'>JMP</a>).")
				log_game("[key_name(Proj.firer)] shot a fueltank in \the [area] ([turf.x],[turf.y],[turf.z]).")
			else
				message_admins("[key_name_admin(Proj.firer)] shot a fueltank outside the world.")
				log_game("[key_name(Proj.firer)] shot a fueltank outside the world.")

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/destroyed(damagetype, user)
	if(IsDamageTypeBurn(damagetype)) //explode only when the damage type is one that burns
		explode(FALSE)
	. = ..()

/obj/structure/reagent_dispensers/fueltank/proc/explode(var/deleteafter = TRUE)
	if (reagents.total_volume > 500)
		explosion(src.loc,1,2,4)
	else if (reagents.total_volume > 100)
		explosion(src.loc,0,1,3)
	else if (reagents.total_volume > 50)
		explosion(src.loc,-1,1,2)
	if(src && deleteafter)
		qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	. = ..()
	if (modded)
		explode()
	else if (temperature > T0C+500)
		explode()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(/datum/reagent/fuel,amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount,1)
