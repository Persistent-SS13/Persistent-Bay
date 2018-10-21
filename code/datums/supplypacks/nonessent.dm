/decl/hierarchy/supply_pack/nonessent
	name = "Non-essentials"

//art
/decl/hierarchy/supply_pack/nonessent/artscrafts
	name = "Art - Arts and crafts supplies"
	contains = list(/obj/item/weapon/storage/fancy/crayons,
					/obj/item/device/camera,
					/obj/item/device/camera_film = 2,
					/obj/item/weapon/storage/photo_album,
					/obj/item/weapon/packageWrap,
					/obj/item/weapon/reagent_containers/glass/paint/red,
					/obj/item/weapon/reagent_containers/glass/paint/green,
					/obj/item/weapon/reagent_containers/glass/paint/blue,
					/obj/item/weapon/reagent_containers/glass/paint/yellow,
					/obj/item/weapon/reagent_containers/glass/paint/purple,
					/obj/item/weapon/reagent_containers/glass/paint/black,
					/obj/item/weapon/reagent_containers/glass/paint/white,
					/obj/item/weapon/contraband/poster,
					/obj/item/weapon/wrapping_paper = 3)
	cost = 6
	containername = "arts and crafts crate"

/decl/hierarchy/supply_pack/nonessent/painters
	name = "Art - Painting supplies"
	contains = list(/obj/item/device/pipe_painter = 2,
					/obj/item/device/floor_painter = 2,
					/obj/item/device/cable_painter = 2)
	cost = 8
	containername = "painting supplies crate"

//clothing
/decl/hierarchy/supply_pack/nonessent/costume
	name = "Clothing - Random suits"
	num_contained = 2
	contains = list(/obj/item/clothing/under/gimmick/rank/captain/suit,
					/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
					/obj/item/clothing/under/rank/mailman,
					/obj/item/clothing/under/schoolgirl,
					/obj/item/clothing/under/owl,
					/obj/item/clothing/under/gladiator,
					/obj/item/clothing/under/soviet,
					/obj/item/clothing/under/scratch,
					/obj/item/clothing/under/redcoat,
					/obj/item/clothing/under/kilt,
					/obj/item/clothing/under/savage_hunter,
					/obj/item/clothing/under/savage_hunter/female,
					/obj/item/clothing/under/wetsuit,
					/obj/item/clothing/suit/chef,
					/obj/item/clothing/suit/pirate,
					/obj/item/clothing/suit/judgerobe,
					/obj/item/clothing/suit/hastur,
					/obj/item/clothing/suit/imperium_monk,
					/obj/item/clothing/suit/ianshirt,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
					/obj/item/clothing/suit/skeleton,
					/obj/item/clothing/suit/engicost,
					/obj/item/clothing/suit/maxman,
					/obj/item/clothing/suit/iasexy,
					/obj/item/clothing/suit/sexyminer,
					/obj/item/clothing/suit/sumo,
					/obj/item/clothing/suit/hackercost,
					/obj/item/clothing/suit/lumber,
					/obj/item/clothing/suit/eccentricjudge,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad)
	cost = 6
	containername = "actor costume crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/costume_hats
	name = "Clothing - Random hats"
	contains = list(/obj/item/clothing/head/redcoat,
					/obj/item/clothing/head/mailman,
					/obj/item/clothing/head/plaguedoctorhat,
					/obj/item/clothing/head/pirate,
					/obj/item/clothing/head/hasturhood,
					/obj/item/clothing/head/powdered_wig,
					/obj/item/clothing/head/hairflower,
					/obj/item/clothing/head/hairflower/yellow,
					/obj/item/clothing/head/hairflower/blue,
					/obj/item/clothing/head/hairflower/pink,
					/obj/item/clothing/mask/gas/owl_mask,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/head/helmet/gladiator,
					/obj/item/clothing/head/ushanka,
					/obj/item/clothing/mask/spirit,
					/obj/item/clothing/head/cowboy_hat)
	cost = 6
	containername = "actor hats crate"
	containertype = /obj/structure/closet
	num_contained = 2
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/clothing
	name = "Clothing - Bulk apparel"
	num_contained = 10
	contains = list(/obj/item/clothing/accessory/toggleable/flannel/red,
					/obj/item/clothing/accessory/toggleable/hawaii,
					/obj/item/clothing/accessory/toggleable/zhongshan,
					/obj/item/clothing/accessory/toggleable/nanotrasen_jacket,
					/obj/item/clothing/accessory/toggleable/navy_jacket,
					/obj/item/clothing/accessory/toggleable/charcoal_jacket,
					/obj/item/clothing/accessory/toggleable/burgundy_jacket,
					/obj/item/clothing/suit/storage/toggle/hoodie,
					/obj/item/clothing/suit/storage/toggle/track,
					/obj/item/clothing/suit/storage/toggle/track/blue,
					/obj/item/clothing/suit/storage/toggle/track/green,
					/obj/item/clothing/suit/storage/toggle/track/red,
					/obj/item/clothing/under/skirt,
					/obj/item/clothing/under/skirt/plaid_blue,
					/obj/item/clothing/under/skirt/plaid_red,
					/obj/item/clothing/under/skirt/plaid_purple,
					/obj/item/clothing/under/skirt/khaki,
					/obj/item/clothing/under/skirt/swept,
					/obj/item/clothing/under/skirt_c/dress/black,
					/obj/item/clothing/under/skirt_c/dress/long/black,
					/obj/item/clothing/under/shorts/red,
					/obj/item/clothing/under/shorts/green,
					/obj/item/clothing/under/shorts/blue,
					/obj/item/clothing/under/shorts/black,
					/obj/item/clothing/under/shorts/grey,
					/obj/item/clothing/under/shorts/jeans,
					/obj/item/clothing/under/shorts/jeans/female,
					/obj/item/clothing/under/shorts/jeans/classic,
					/obj/item/clothing/under/shorts/jeans/classic/female,
					/obj/item/clothing/under/shorts/jeans/mustang,
					/obj/item/clothing/under/shorts/jeans/mustang/female,
					/obj/item/clothing/under/shorts/jeans/youngfolks,
					/obj/item/clothing/under/shorts/jeans/youngfolks/female,
					/obj/item/clothing/under/shorts/jeans/black,
					/obj/item/clothing/under/shorts/jeans/black/female,
					/obj/item/clothing/under/shorts/jeans/grey,
					/obj/item/clothing/under/shorts/jeans/grey/female,
					/obj/item/clothing/under/shorts/khaki,
					/obj/item/clothing/under/shorts/khaki/female,
					/obj/item/clothing/under/color/blackjumpshorts,
					/obj/item/clothing/under/bluepyjamas,
					/obj/item/clothing/under/redpyjamas,
					/obj/item/clothing/suit/leathercoat,
					/obj/item/clothing/suit/browncoat,
					/obj/item/clothing/suit/neocoat,
					/obj/item/clothing/suit/stripper/stripper_pink,
					/obj/item/clothing/under/stripper/mankini,
					/obj/item/clothing/under/swimsuit/blue,
					/obj/item/clothing/under/swimsuit/purple,
					/obj/item/clothing/under/swimsuit/green,
					/obj/item/clothing/under/swimsuit/red,
					/obj/item/clothing/under/casual_pants,
					/obj/item/clothing/under/casual_pants/classicjeans,
					/obj/item/clothing/under/casual_pants/mustangjeans,
					/obj/item/clothing/under/casual_pants/blackjeans,
					/obj/item/clothing/under/casual_pants/greyjeans,
					/obj/item/clothing/under/casual_pants/youngfolksjeans,
					/obj/item/clothing/under/casual_pants/track,
					/obj/item/clothing/under/casual_pants/track/blue,
					/obj/item/clothing/under/casual_pants/track/green,
					/obj/item/clothing/under/casual_pants/track/white,
					/obj/item/clothing/under/casual_pants/track/red,
					/obj/item/clothing/under/casual_pants/camo,
					/obj/item/clothing/under/casual_pants/baggy,
					/obj/item/clothing/under/casual_pants/baggy/classicjeans,
					/obj/item/clothing/under/casual_pants/baggy/mustangjeans,
					/obj/item/clothing/under/casual_pants/baggy/blackjeans,
					/obj/item/clothing/under/casual_pants/baggy/greyjeans,
					/obj/item/clothing/under/casual_pants/baggy/youngfolksjeans,
					/obj/item/clothing/under/casual_pants/baggy/track,
					/obj/item/clothing/under/casual_pants/baggy/camo)
	cost = 10
	containername = "bulk clothing crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/formal_wear
	name = "Clothing - Formalwear"
	contains = list(/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/that,
					/obj/item/clothing/suit/storage/toggle/suit/blue,
					/obj/item/clothing/suit/storage/toggle/suit/purple,
					/obj/item/clothing/under/suit_jacket,
					/obj/item/clothing/under/suit_jacket/female,
					/obj/item/clothing/under/suit_jacket/really_black,
					/obj/item/clothing/under/suit_jacket/red,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/shoes/black = 2,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/accessory/wcoat,
					/obj/item/clothing/accessory/toggleable/vest,
					/obj/item/clothing/under/formal_pants,
					/obj/item/clothing/under/formal_pants/red,
					/obj/item/clothing/under/formal_pants/black,
					/obj/item/clothing/under/formal_pants/tan,
					/obj/item/clothing/under/formal_pants/khaki)
	cost = 30
	containertype = /obj/structure/closet
	containername = "formalwear closet"

/decl/hierarchy/supply_pack/nonessent/hats
	name = "Clothing - Collectable hats!"
	num_contained = 4
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	cost = 15
	containername = "\improper Collectable hats crate! Brought to you by Bass.inc!"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/luxury
	name = "Clothing - Luxury accessories"
	num_contained = 1
	contains = list(/obj/item/clothing/ears/earring/stud/diamond,
					/obj/item/clothing/ears/earring/dangle/gold,
					/obj/item/clothing/ears/earring/dangle/diamond,
					/obj/item/clothing/ears/earring/stud/gold,
					/obj/item/clothing/ears/earring/stud/platinum,
					/obj/item/clothing/ears/earring/dangle/silver,
					/obj/item/clothing/ears/earring/dangle/platinum,
					/obj/item/clothing/ears/earring/stud/silver,
					/obj/item/clothing/gloves/color/evening,
					/obj/item/clothing/ring/material/gold,
					/obj/item/clothing/ring/material/silver,
					/obj/item/clothing/accessory/locket,
					/obj/item/clothing/accessory/black/expensive,
					/obj/item/clothing/accessory/scarf,
					/obj/item/clothing/head/crown,
					/obj/item/clothing/mask/smokable/pipe
					)
	cost = 95
	containername = "luxury crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/witch
	name = "Clothing - Witch costume"
	contains = list(/obj/item/clothing/under/color/lightpurple,
					/obj/item/clothing/suit/wizrobe/marisa/fake,
					/obj/item/clothing/head/wizard/marisa/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/weapon/staff/broom)
	cost = 8
	containername = "witch costume crate"

/decl/hierarchy/supply_pack/nonessent/wizard
	name = "Clothing - Wizard costume"
	contains = list(/obj/item/clothing/under/color/lightpurple,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/head/wizard/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/weapon/staff)
	cost = 8
	containername = "wizard costume crate"

/decl/hierarchy/supply_pack/nonessent/dresses
	name = "Clothing - Women formal dresses"
	contains = list(/obj/item/clothing/under/wedding/bride_orange,
					/obj/item/clothing/under/wedding/bride_purple,
					/obj/item/clothing/under/wedding/bride_blue,
					/obj/item/clothing/under/wedding/bride_red,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/clothing/under/sundress,
					/obj/item/clothing/under/dress/dress_green,
					/obj/item/clothing/under/dress/dress_pink,
					/obj/item/clothing/under/dress/dress_orange,
					/obj/item/clothing/under/dress/dress_yellow,
					/obj/item/clothing/under/dress/dress_saloon)
	cost = 10
	containername = "pretty dress closet"
	containertype = /obj/structure/closet
	num_contained = 2
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/athletic
	name = "Clothing - Athletic apparel"
	contains = list(/obj/item/clothing/under/shorts/blue,
					/obj/item/clothing/under/shorts/red,
					/obj/item/clothing/under/shorts/green,
					/obj/item/clothing/under/shorts/black,
					/obj/item/clothing/gloves/boxing/green,
					/obj/item/clothing/gloves/boxing,
					/obj/item/weapon/beach_ball/holoball = 2)
	cost = 6
	containertype = /obj/structure/closet/athletic_mixed
	containername = "athletics closet"

//gaming
/decl/hierarchy/supply_pack/nonessent/gambling
	name = "Recreation - Gambling set"
	contains = list(/obj/item/weapon/deck/cards,
					/obj/item/weapon/dice = 4)
	cost = 2
	containername = "gambling crate"

/decl/hierarchy/supply_pack/nonessent/tabletop
	name = "Recreation - Tabletop starter kit"
	contains = list(/obj/item/weapon/paper_bin,
					/obj/item/weapon/dice/d4 = 1,
					/obj/item/weapon/dice = 1,
					/obj/item/weapon/dice/d8 = 1,
					/obj/item/weapon/dice/d10 = 1,
					/obj/item/weapon/dice/d12 = 1,
					/obj/item/weapon/dice/d20 = 1)
	cost = 3
	containername = "tabletop gaming crate"

/decl/hierarchy/supply_pack/nonessent/card_packs
	name = "Recreation - Trading cards"
	num_contained = 5
	contains = list(/obj/item/weapon/pack/cardemon,
					/obj/item/weapon/pack/spaceball,
					/obj/item/weapon/deck/holder)
	cost = 5
	containername = "trading cards crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/lasertag
	name = "Recreation - Lasertag equipment"
	contains = list(/obj/item/weapon/gun/energy/lasertag/red = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/weapon/gun/energy/lasertag/blue = 3,
					/obj/item/clothing/suit/bluetag = 3)
	cost = 10
	containertype = /obj/structure/closet
	containername = "lasertag closet"

//modkits
/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl1
	name = "Mod - Ripley APLU modkit"
	contains = list(/obj/item/device/kit/paint/ripley)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl2
	name = "Mod - Death APLU modkit"
	contains = list(/obj/item/device/kit/paint/ripley/death)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl3
	name = "Mod - Hot Rod APLU modkit"
	contains = list(/obj/item/device/kit/paint/ripley/flames_red)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl4
	name = "Mod - Cool Ice APLU modkit"
	contains = list(/obj/item/device/kit/paint/ripley/flames_blue)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_durand1
	name = "Mod - Durand exosuit modkit"
	contains = list(/obj/item/device/kit/paint/durand)
	cost = 15
	containername = "exosuit modkit crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_durand2
	name = "Mod - Seraph Durand exosuit modkit"
	contains = list(/obj/item/device/kit/paint/durand/seraph)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_durand3
	name = "Mod - Phazon Durand exosuit modkit"
	contains = list(/obj/item/device/kit/paint/durand/phazon)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_gygax1
	name = "Mod - Gygax exosuit modkit"
	contains = list(/obj/item/device/kit/paint/gygax)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_gygax2
	name = "Mod - Dark Gygax exosuit modkit"
	contains = list(/obj/item/device/kit/paint/gygax/darkgygax)
	cost = 15
	containername = "exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_gygax3
	name = "Mod - Recitence Gygax exosuit modkit"
	contains = list(/obj/item/device/kit/paint/gygax/recitence)
	cost = 15
	containername = "exosuit modkit crate"

//equipment
/decl/hierarchy/supply_pack/nonessent/chaplaingear
	name = "Equipment - Religious supplies"
	contains = list(/obj/item/clothing/ring/engagement = 2,
					/obj/item/weapon/storage/fancy/candle_box = 3,
					/obj/item/weapon/storage/bible,
					/obj/item/weapon/deck/tarot,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater = 2,
					/obj/item/weapon/nullrod)
	cost = 66
	containername = "religious equipment crate"

/decl/hierarchy/supply_pack/nonessent/phorosian
	name = "Equipment - Phorosian suit adapter"
	contains = list(/obj/item/device/phorosiansuit_changer)
	cost = 12
	containername = "phorosian suit adapter crate"

//decorations
/decl/hierarchy/supply_pack/nonessent/bedsheets
	name = "Decoration - Bedsheet variety pack"
	contains = list(/obj/item/weapon/bedsheet,
					/obj/item/weapon/bedsheet/blue,
					/obj/item/weapon/bedsheet/green,
					/obj/item/weapon/bedsheet/orange,
					/obj/item/weapon/bedsheet/purple,
					/obj/item/weapon/bedsheet/red,
					/obj/item/weapon/bedsheet/yellow,
					/obj/item/weapon/bedsheet/brown,
					/obj/item/weapon/bedsheet/rainbow)
	cost = 7
	containername = "bedsheet crate"

/decl/hierarchy/supply_pack/nonessent/posters
	name = "Decoration - Random posters"
	contains = list(/obj/item/weapon/contraband/poster = 4)
	cost = 4
	containername = "posters crate"

//music
/decl/hierarchy/supply_pack/nonessent/jukebox
	name = "Music - Jukebox"
	contains = list(/obj/machinery/media/jukebox)
	cost = 260
	containertype = /obj/structure/largecrate
	containername = "jukebox crate"

/decl/hierarchy/supply_pack/nonessent/piano
	name = "Music - Piano"
	contains = list(/obj/structure/device/piano)
	cost = 500
	containertype = /obj/structure/largecrate
	containername = "piano crate"

/decl/hierarchy/supply_pack/nonessent/guitar
	name = "Music - Guitar"
	contains = list(/obj/item/instrument/guitar)
	cost = 20
	containername = "guitar crate"

/decl/hierarchy/supply_pack/nonessent/piano
	name = "Music - Violin"
	contains = list(/obj/item/device/violin)
	cost = 40
	containername = "violin crate"