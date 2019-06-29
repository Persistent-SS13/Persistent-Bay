//Raritys for use with crittercrate.dm and elsewhere.

/datum/rarity/
	var/common = null
	var/uncommon = null
	var/rare = null
	var/special = null


/datum/rarity/critters

	common = list(
	/mob/living/simple_animal/mouse,
	/mob/living/simple_animal/lizard,
	/mob/living/simple_animal/chick
	)

	uncommon = list(
	/mob/living/simple_animal/cat,
	/mob/living/simple_animal/corgi,
	/mob/living/simple_animal/crab,
	/mob/living/simple_animal/chicken,
	/mob/living/simple_animal/cat/kitten,
	/mob/living/simple_animal/corgi/puppy
	)

	rare = list(
	/mob/living/simple_animal/hostile/retaliate/goat,
	/mob/living/simple_animal/parrot,
	/mob/living/carbon/human/monkey,
	/mob/living/carbon/human/farwa,
	/mob/living/simple_animal/cow,
	/mob/living/carbon/human/neaera,
	/mob/living/carbon/human/stok
	)

	special = list(
	/mob/living/simple_animal/hostile/carp)

/datum/rarity/seeds

	common = list(/obj/item/seeds/grapeseed,
	/obj/item/seeds/peanutseed,
	/obj/item/seeds/cabbageseed,
	/obj/item/seeds/berryseed,
	/obj/item/seeds/blueberryseed,
	/obj/item/seeds/eggplantseed,
	/obj/item/seeds/tomatoseed,
	/obj/item/seeds/cornseed,
	/obj/item/seeds/potatoseed,
	/obj/item/seeds/soyaseed,
	/obj/item/seeds/wheatseed,
	/obj/item/seeds/riceseed,
	/obj/item/seeds/carrotseed,
	/obj/item/seeds/chantermycelium,
	/obj/item/seeds/plumpmycelium,
	/obj/item/seeds/harebell,
	/obj/item/seeds/sunflowerseed,
	/obj/item/seeds/lavenderseed,
	/obj/item/seeds/appleseed,
	/obj/item/seeds/whitebeetseed,
	/obj/item/seeds/sugarcaneseed,
	/obj/item/seeds/watermelonseed,
	/obj/item/seeds/pumpkinseed,
	/obj/item/seeds/cocoapodseed,
	/obj/item/seeds/cherryseed,
	/obj/item/seeds/peppercornseed,
	/obj/item/seeds/garlicseed,
	/obj/item/seeds/onionseed,
	/obj/item/seeds/algaeseed,
	/obj/item/seeds/badtobaccoseed
	)

	uncommon = list(/obj/item/seeds/nettleseed,
	/obj/item/seeds/chiliseed,
	/obj/item/seeds/plastiseed,
	/obj/item/seeds/greengrapeseed,
	/obj/item/seeds/mtearseed,
	/obj/item/seeds/glowberryseed,
	/obj/item/seeds/bananaseed,
	/obj/item/seeds/bloodtomatoseed,
	/obj/item/seeds/bluetomatoseed,
	/obj/item/seeds/poppyseed,
	/obj/item/seeds/towermycelium,
	/obj/item/seeds/glowshroom,
	/obj/item/seeds/ambrosiavulgarisseed,
	/obj/item/seeds/limeseed,
	/obj/item/seeds/lemonseed,
	/obj/item/seeds/orangeseed,
	/obj/item/seeds/grassseed,
	/obj/item/seeds/shandseed,
	/obj/item/seeds/reishimycelium,
	/obj/item/seeds/tobaccoseed
	)

	rare = list(/obj/item/seeds/poisonberryseed,
	/obj/item/seeds/poisonedappleseed,
	/obj/item/seeds/deathnettleseed,
	/obj/item/seeds/amanitamycelium,
	/obj/item/seeds/icepepperseed,
	/obj/item/seeds/bluespacetomatoseed,
	/obj/item/seeds/finetobaccoseed,
	/obj/item/seeds/libertymycelium,
	/obj/item/bee_pack
	)

	special = list(/obj/item/seeds/kudzuseed,
	/obj/item/seeds/deathberryseed,
	/obj/item/seeds/puretobaccoseed,
	/obj/item/seeds/ambrosiadeusseed,
	/obj/item/seeds/goldappleseed,
	/obj/item/seeds/walkingmushroommycelium,
	/obj/item/seeds/angelmycelium,
	/obj/item/seeds/killertomatoseed
	)

///datum/rarity/artifacts
///datum/rarity/datadisks
///datum/rarity/paper
