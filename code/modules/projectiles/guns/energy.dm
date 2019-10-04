GLOBAL_LIST_INIT(registered_weapons, list())
GLOBAL_LIST_INIT(registered_cyborg_weapons, list())
#define ENERGY_LOAD_FIXED_CELL 0
#define ENERGY_LOAD_HOTSWAP_CELL 1
#define ENERGY_LOAD_REMOVABLE_CELL 2

/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/weapons/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = /obj/item/weapon/cell/device/variable
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0
	var/load_method = ENERGY_LOAD_REMOVABLE_CELL
	var/cell_secured = TRUE //For energy weapons that needs their cells unsecured first
	var/accepted_cell_types = list(
		/obj/item/weapon/cell/device/variable,
		/obj/item/weapon/cell/device/standard,
		/obj/item/weapon/cell/device/high,
		/obj/item/weapon/cell/device/super
		) //Cells typepaths that are accepted by this weapon

/obj/item/weapon/gun/energy/New()
	..()
	ADD_SAVED_VAR(cell_secured)
	ADD_SAVED_VAR(power_supply)
	ADD_SKIP_EMPTY(power_supply)

/obj/item/weapon/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/Initialize()
	. = ..()
	if(!map_storage_loaded)
		if(cell_type)
			power_supply = new cell_type(src,max_shots*charge_cost)
		else
			power_supply = new /obj/item/weapon/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/energy/get_cell()
	return power_supply

/obj/item/weapon/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/gun/energy/examine(mob/user)
	. = ..(user)
	if(power_supply)
		var/shots_remaining = round(power_supply.charge / charge_cost)
		to_chat(user, "Has [shots_remaining] shot\s remaining.")
	else
		to_chat(usr, "Has no power source inserted.")
	return

/obj/item/weapon/gun/energy/on_update_icon()
	..()
	if(charge_meter)
		var/ratio = 0
		if(power_supply)
			ratio = power_supply.percent()
			//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
			if(power_supply.charge < charge_cost)
				ratio = 0
			else
				ratio = Clamp(round(ratio, 25), 25, 100)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"


/obj/item/weapon/gun/energy/proc/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/weapon/cell))
		if(power_supply)
			user.visible_message("[user] quickly swap [power_supply] for a [A] into \the [src]!", "<span class='warning'>You quickly swap the current [power_supply] for the new [A], dropping the old one!</span>")
			power_supply.dropInto(user.loc)
			power_supply = null
		else
			user.visible_message("[user] insert \the [A] into [src].", "<span class='notice'>You insert the [A]!</span>")
		user.remove_from_mob(A)
		A.loc = src
		power_supply = A
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	update_icon()

/obj/item/weapon/gun/energy/proc/unload_ammo(mob/user)
	if(!power_supply)
		to_chat(user, "<span class='warning'>There is no cell in the [src]!</span>")
		return
	if(load_method == ENERGY_LOAD_HOTSWAP_CELL || load_method == ENERGY_LOAD_REMOVABLE_CELL)
		user.put_in_hands(power_supply)
		user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You remove [power_supply] from [src].</span>")
		power_supply = null
	update_icon()

/obj/item/weapon/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/cell))
		if(!is_valid_cell(A))
			to_chat(user,"<span class='warning'>This weapon is not compatible with \the [A]!</span>")
			return
		switch(load_method)
			if(ENERGY_LOAD_HOTSWAP_CELL)
				load_ammo(A, user)
				return
			if(ENERGY_LOAD_REMOVABLE_CELL)
				if(check_cover_open())
					load_ammo(A, user)
				return
			else
				to_chat(user,"<span class='warning'>This weapon does not accepts powercells!</span>")
				return
	else if(isScrewdriver(A))
		switch(load_method)
			if(ENERGY_LOAD_REMOVABLE_CELL)
				var/curact = cell_secured? "unscrew": "screw"
				user.visible_message("[user] [curact] the cover.","<span class='notice'>You [curact] the cover.</span>")
				cell_secured = !cell_secured
			else
				to_chat(user,"<span class='warning'>There are no covers to unscrew on this weapon!</span>")
				return
	return ..()

/obj/item/weapon/gun/energy/proc/check_cover_open()
	if(cell_secured)
		to_chat(usr,"<span class='warning'>You must first unscrew the cover!</span>")
	return !cell_secured

/obj/item/weapon/gun/energy/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		..()
	else
		switch(load_method)
			if(ENERGY_LOAD_REMOVABLE_CELL)
				if(check_cover_open())
					unload_ammo(user)
			if(ENERGY_LOAD_HOTSWAP_CELL)
				unload_ammo(user)

/obj/item/weapon/gun/energy/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		switch(load_method)
			if(ENERGY_LOAD_REMOVABLE_CELL)
				if(check_cover_open())
					unload_ammo(user)
				return
			if(ENERGY_LOAD_HOTSWAP_CELL)
				unload_ammo(user)
				return
	else
		return ..()

/obj/item/weapon/gun/energy/proc/is_valid_cell(var/obj/item/weapon/cell/pcell)
	return(ispath(accepted_cell_types) && istype(pcell, accepted_cell_types) || islist(accepted_cell_types) && is_type_in_list(pcell, accepted_cell_types))
