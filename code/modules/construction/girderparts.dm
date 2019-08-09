/obj/item/girderpart
	name = "girder parts"
	desc = "Parts to quickly build a girder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder_p"
	item_state = "girder_p"
	w_class = ITEM_SIZE_LARGE
	
	var/material/material
	var/saved_material

/obj/item/girderpart/New(var/newLoc, var/material_name)
	..()
	ADD_SAVED_VAR(saved_material)

	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL

	material = SSmaterials.get_material_by_name(material_name)
	
/obj/item/girderpart/Initialize()
	if(!material)
		material = DEFAULT_WALL_MATERIAL
	if(istext(material))
		material = SSmaterials.get_material_by_name(material)

	queue_icon_update()
	. = ..()
	
/obj/item/girderpart/on_update_icon()
	SetName("[material.display_name] [initial(name)]")
	color = material.icon_colour
	. = ..()

/obj/item/girderpart/Write(savefile/f)
	// Save the material name instead. Initialize will load it.
	to_file(f["material"], material.name)	
	. = ..()

/obj/item/girderpart/Read(savefile/f)
	from_file(f["material"], material)
	. = ..()	

/obj/item/girderpart/after_load()
	// Legacy Support
	if(saved_material)
		material = SSmaterials.get_material_by_name(saved_material)
		saved_material = null
	. = ..()

/obj/item/girderpart/attack_self(var/user)
	new /obj/structure/girder(get_turf(src), material)
	qdel(src)