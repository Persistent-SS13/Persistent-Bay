/obj/item/girderpart
	name = "girder parts"
	desc = "Parts to quickly build a girder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder_p"
	item_state = "girder_p"
	w_class = ITEM_SIZE_LARGE
	
	var/material/material

/obj/item/girderpart/New(var/newloc, var/mat)
	material = mat
	if(!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	name = "[material.display_name] " + initial(name)
	color = material.icon_colour

/obj/item/girderpart/after_load()
	name = "[material.display_name] " + initial(name)
	color = material.icon_colour

/obj/item/girderpart/attack_self(var/user)
	new /obj/structure/girder(get_turf(src), material)
	qdel(src)