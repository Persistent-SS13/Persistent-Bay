//---------------------------------------------
//	Generic powdered form for most materials
//---------------------------------------------
// Mainly meant to be used for the recycling system, and unprocessed materials
/obj/item/stack/material_dust
	name = "dust"
	icon_state = "dust"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = ITEM_SIZE_NORMAL
	amount = 1
	max_amount = 500
	var/material/material
	var/saved_material

/obj/item/stack/material_dust/New(var/newloc, var/amount, var/_mat)
	if(_mat)
		set_material_data_byname(_mat)
	..(newloc, amount)
	ADD_SAVED_VAR(saved_material)

/obj/item/stack/material_dust/before_save()
	. = ..()
	if(material)
		saved_material = material.name
/obj/item/stack/material_dust/after_save()
	. = ..()
	saved_material = null
/obj/item/stack/material_dust/after_load()
	..()
	if(saved_material) //Added the check for previous versions of materials
		set_material_data(saved_material) 

/obj/item/stack/material_dust/Initialize()
	. = ..()
	queue_icon_update()

/obj/item/stack/material_dust/proc/set_material_data_byname(var/material_name)
	set_material_data(SSmaterials.get_material_by_name(material_name))

/obj/item/stack/material_dust/proc/set_material_data(var/material/M)
	if(M && istype(M))
		name = M.name + " dust"
		desc = "A pile of powdered [M.name]."
		material = M
		color = M.icon_colour
		slot_flags = SLOT_HOLSTER
		materials_per_unit = list("[M.name]" = DUST_MATERIAL_AMOUNT)
		update_material_value() //Calculates the total matter value for the stack

//Add a quantity in the form of material "units"
/obj/item/stack/material_dust/proc/add_matter_quantity(var/matter_amt)
	var/dustamount	= round(matter_amt / DUST_MATERIAL_AMOUNT)
	var/dustadd		= abs(min(dustamount, max_amount) - amount)
	dustamount -= dustadd
	src.add(dustadd)

	//Drop the extra as new powder piles
	while(dustamount > 0)
		var/obj/item/stack/material_dust/extra = new(loc,material.name)
		extra.set_amount(min(dustamount, max_amount))
		dustamount -= extra.get_amount()

/obj/item/stack/material_dust/stacks_can_merge(var/obj/item/stack/other)
	if(istype(other, /obj/item/stack/material_dust))
		var/obj/item/stack/material_dust/otherstack = other
		if(src.material && otherstack.get_material() && otherstack.get_material().name == src.material.name)
			return TRUE //Make sure we merge only with similar materials!!!
	return FALSE

// POCKET SAND!
/obj/item/stack/material_dust/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.eye_blind += 5
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)