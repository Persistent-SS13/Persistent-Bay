/obj/item/girderpart
	name = "girder parts"
	desc = "Parts to quickly build a girder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder_p"
	item_state = "girder_p"
	w_class = ITEM_SIZE_LARGE
	
	var/material/material
	var/saved_material

/obj/item/girderpart/New(var/newloc, var/mat)
	..()
	material = mat
	name = "[material.display_name] " + initial(name)
	color = material.icon_colour
	ADD_SAVED_VAR(saved_material)

/obj/item/girderpart/Initialize()
	. = ..()
	if(!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	name = "[material.display_name] " + initial(name)
	color = material.icon_colour

/obj/item/girderpart/after_load()
	..()
	if(saved_material)
		material = SSmaterials.get_material_by_name(saved_material)
		saved_material = null

/obj/item/girderpart/before_save()
	. = ..()
	saved_material = material?.name

/obj/item/girderpart/after_save()
	. = ..()
	saved_material = null

/obj/item/girderpart/attack_self(var/user)
	new /obj/structure/girder(get_turf(src), material)
	qdel(src)