/obj/item/weapon/book/multipage/sycorax_guide
	title = "Guide to Sycorax Quadrant"
	name = "Guide to Sycorax Quadrant"
	author = "Sycorax Administration"
	author_real = "premade"
	icon_state = "anomaly"

/obj/item/weapon/book/multipage/sycorax_guide/New()
	. = ..()
	pages = list(new /obj/item/weapon/paper/guidetosycoraxone(src),
		new/obj/item/weapon/paper/guidetosycoraxtwo(src),
		new/obj/item/weapon/paper/guidetosycoraxthree(src),
		new/obj/item/weapon/paper/guidetosycoraxfour(src),
		new/obj/item/weapon/paper/guidetosycoraxfive(src),
		new/obj/item/weapon/paper/guidetosycoraxsix(src),
		new/obj/item/weapon/paper/guidetosycoraxseven(src))

/obj/item/weapon/book/multipage/sycorax_guide/Destroy()
	if(LAZYLEN(pages))
		while(pages.len)
			qdel(pages[pages.len])
			pages[pages.len] = null
			--pages.len
	. = ..()