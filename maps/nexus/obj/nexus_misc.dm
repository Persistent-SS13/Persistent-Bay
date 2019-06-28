/obj/item/weapon/book/multipage/nexus_guide
	title = "Guide to Nexus City"
	name = "Guide to Nexus City"
	author = "NEX"
	author_real = "premade"
	icon_state = "anomaly"

/obj/item/weapon/book/multipage/nexus_guide/New()
	. = ..()
	pages = list(new /obj/item/weapon/paper/guidetonexusone(src), 
		new/obj/item/weapon/paper/guidetonexustwo(src), 
		new/obj/item/weapon/paper/guidetonexusthree(src), 
		new/obj/item/weapon/paper/guidetonexusfour(src), 
		new/obj/item/weapon/paper/guidetonexusfive(src), 
		new/obj/item/weapon/paper/guidetonexussix(src), 
		new/obj/item/weapon/paper/guidetonexusseven(src))

/obj/item/weapon/book/multipage/nexus_guide/Destroy()
	if(LAZYLEN(pages))
		while(pages.len)
			qdel(pages[pages.len])
			pages[pages.len] = null
			--pages.len
	. = ..()