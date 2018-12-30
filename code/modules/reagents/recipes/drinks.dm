/* Alcohol */

/datum/chemical_reaction/goldschlager
	name = "Goldschlager"
	result = /datum/reagent/ethanol/goldschlager
	required_reagents = list(/datum/reagent/ethanol/vodka = 10, /datum/reagent/gold = 1)
	result_amount = 10

/datum/chemical_reaction/patron
	name = "Patron"
	result = /datum/reagent/ethanol/patron
	required_reagents = list(/datum/reagent/ethanol/tequilla = 10, MATERIAL_SILVER = 1)
	result_amount = 10

/datum/chemical_reaction/bilk
	name = "Bilk"
	result = /datum/reagent/ethanol/bilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/ethanol/beer = 1)
	result_amount = 2

/datum/chemical_reaction/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea = 2, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/sweettea
	name = "Sweet Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list(/datum/chemical_reaction/icetea = 3, /datum/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3

/datum/chemical_reaction/nuka_cola
	name = "Nuka Cola"
	result = /datum/reagent/drink/nuka_cola
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/drink/space_cola = 5)
	result_amount = 5

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	result = /datum/reagent/ethanol/moonshine
	required_reagents = list(/datum/reagent/nutriment = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = list(/datum/reagent/drink/juice/berry = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	result = /datum/reagent/ethanol/wine
	required_reagents = list(/datum/reagent/drink/juice/grape = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	result = /datum/reagent/ethanol/pwine
	required_reagents = list(/datum/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	result = /datum/reagent/ethanol/melonliquor
	required_reagents = list(/datum/reagent/drink/juice/watermelon = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	result = /datum/reagent/ethanol/bluecuracao
	required_reagents = list(/datum/reagent/drink/juice/orange = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	result = /datum/reagent/ethanol/beer
	required_reagents = list(/datum/reagent/nutriment/cornoil = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/vodka
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/potato = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/sake
	name = "Sake"
	result = /datum/reagent/ethanol/sake
	required_reagents = list(/datum/reagent/nutriment/rice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	result = /datum/reagent/ethanol/coffee/kahlua
	required_reagents = list(/datum/reagent/drink/coffee = 5, /datum/reagent/sugar = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5

/datum/chemical_reaction/gin_tonic
	name = "Gin and Tonic"
	result = /datum/reagent/ethanol/gintonic
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/cuba_libre
	name = "Cuba Libre"
	result = /datum/reagent/ethanol/cuba_libre
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/martini
	name = "Classic Martini"
	result = /datum/reagent/ethanol/martini
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/vodkamartini
	name = "Vodka Martini"
	result = /datum/reagent/ethanol/vodkamartini
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/black_russian = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/whiskey_cola
	name = "Whiskey Cola"
	result = /datum/reagent/ethanol/whiskey_cola
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/screwdriver
	name = "Screwdriver"
	result = /datum/reagent/ethanol/screwdrivercocktail
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/battuta
	name = "Ibn Battuta"
	result = /datum/reagent/ethanol/battuta
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/drink/juice/orange = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/magellan
	name = "Magellan"
	result = /datum/reagent/ethanol/magellan
	required_reagents = list(/datum/reagent/ethanol/wine = 1, /datum/reagent/ethanol/specialwhiskey = 1)
	catalysts = list(/datum/reagent/sugar)
	result_amount = 2

/datum/chemical_reaction/zhenghe
	name = "Zheng He"
	result = /datum/reagent/ethanol/zhenghe
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/armstrong
	name = "Armstrong"
	result = /datum/reagent/ethanol/armstrong
	required_reagents = list(/datum/reagent/ethanol/beer = 2, /datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4

/datum/chemical_reaction/bloody_mary
	name = "Bloody Mary"
	result = /datum/reagent/ethanol/bloody_mary
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/tomato = 3, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	result = /datum/reagent/ethanol/gargle_blaster
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/brave_bull
	name = "Brave Bull"
	result = /datum/reagent/ethanol/coffee/brave_bull
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /datum/reagent/ethanol/tequilla_sunrise
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/phoron_special
	name = "Toxins Special"
	result = /datum/reagent/ethanol/toxins_special
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/vermouth = 2, /datum/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/beepsky_smash
	name = "Beepksy Smash"
	result = /datum/reagent/ethanol/beepsky_smash
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/drink/doctor_delight
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/milk/cream = 2, /datum/reagent/tricordrazine = 1)
	result_amount = 6

/datum/chemical_reaction/irish_cream
	name = "Irish Cream"
	result = /datum/reagent/ethanol/irish_cream
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/manly_dorf
	name = "The Manly Dorf"
	result = /datum/reagent/ethanol/manly_dorf
	required_reagents = list (/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/hooch
	name = "Hooch"
	result = /datum/reagent/ethanol/hooch
	required_reagents = list (/datum/reagent/sugar = 1, /datum/reagent/ethanol = 2, /datum/reagent/fuel = 1)
	result_amount = 3

/datum/chemical_reaction/irish_coffee
	name = "Irish Coffee"
	result = /datum/reagent/ethanol/coffee/irishcoffee
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/b52
	name = "B-52"
	result = /datum/reagent/ethanol/coffee/b52
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/atomicbomb
	name = "Atomic Bomb"
	result = /datum/reagent/ethanol/atomicbomb
	required_reagents = list(/datum/reagent/ethanol/coffee/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/margarita
	name = "Margarita"
	result = /datum/reagent/ethanol/margarita
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/longislandicedtea
	name = "Long Island Iced Tea"
	result = /datum/reagent/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/tequilla = 1, /datum/reagent/ethanol/cuba_libre = 3)
	result_amount = 6

/datum/chemical_reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /datum/reagent/ethanol/threemileisland
	required_reagents = list(/datum/reagent/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/whiskeysoda
	name = "Whiskey Soda"
	result = /datum/reagent/ethanol/whiskeysoda
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/black_russian
	name = "Black Russian"
	result = /datum/reagent/ethanol/black_russian
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan
	name = "Manhattan"
	result = /datum/reagent/ethanol/manhattan
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan_proj
	name = "Manhattan Project"
	result = /datum/reagent/ethanol/manhattan_proj
	required_reagents = list(/datum/reagent/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/vodka_tonic
	name = "Vodka and Tonic"
	result = /datum/reagent/ethanol/vodkatonic
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/gin_fizz
	name = "Gin Fizz"
	result = /datum/reagent/ethanol/ginfizz
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/bahama_mama
	name = "Bahama mama"
	result = /datum/reagent/ethanol/bahama_mama
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/singulo
	name = "Singulo"
	result = /datum/reagent/ethanol/singulo
	required_reagents = list(/datum/reagent/ethanol/vodka = 5, /datum/reagent/radium = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/alliescocktail
	name = "Allies Cocktail"
	result = /datum/reagent/ethanol/alliescocktail
	required_reagents = list(/datum/reagent/ethanol/vodkamartini = 1, /datum/reagent/ethanol/martini = 1)
	result_amount = 2

/datum/chemical_reaction/demonsblood
	name = "Demons Blood"
	result = /datum/reagent/ethanol/demonsblood
	required_reagents = list(/datum/reagent/ethanol/rum = 3, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/blood = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/booger
	name = "Booger"
	result = /datum/reagent/ethanol/booger
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/juice/banana = 1, /datum/reagent/ethanol/rum = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 5

/datum/chemical_reaction/antifreeze
	name = "Anti-freeze"
	result = /datum/reagent/ethanol/antifreeze
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	result_amount = 3

/datum/chemical_reaction/barefoot
	name = "Barefoot"
	result = /datum/reagent/ethanol/barefoot
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/juice/grape = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/sbiten
	name = "Sbiten"
	result = /datum/reagent/ethanol/sbiten
	required_reagents = list(/datum/reagent/ethanol/mead = 10, /datum/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/red_mead
	name = "Red Mead"
	result = /datum/reagent/ethanol/red_mead
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/mead
	name = "Mead"
	result = /datum/reagent/ethanol/mead
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/iced_beer
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10

/datum/chemical_reaction/iced_beer2
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 5, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/grog
	name = "Grog"
	result = /datum/reagent/ethanol/grog
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2

/datum/chemical_reaction/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2

/datum/chemical_reaction/acidspit
	name = "Acid Spit"
	result = /datum/reagent/ethanol/acid_spit
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 6

/datum/chemical_reaction/amasec
	name = "Amasec"
	result = /datum/reagent/ethanol/amasec
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/ethanol/wine = 5, /datum/reagent/ethanol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/changelingsting
	name = "Changeling Sting"
	result = /datum/reagent/ethanol/changelingsting
	required_reagents = list("screwdrivercocktail" = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/aloe
	name = "Aloe"
	result = /datum/reagent/ethanol/aloe
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 3

/datum/chemical_reaction/andalusia
	name = "Andalusia"
	result = /datum/reagent/ethanol/andalusia
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	result = /datum/reagent/ethanol/neurotoxin
	required_reagents = list(/datum/reagent/ethanol/gargle_blaster = 1, /datum/reagent/soporific = 1)
	result_amount = 2

/datum/chemical_reaction/snowwhite
	name = "Snow White"
	result = /datum/reagent/ethanol/snowwhite
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/irishcarbomb
	name = "Irish Car Bomb"
	result = /datum/reagent/ethanol/irishcarbomb
	required_reagents = list(/datum/reagent/ethanol/ale = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/syndicatebomb
	name = "Syndicate Bomb"
	result = /datum/reagent/ethanol/syndicatebomb
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/erikasurprise
	name = "Erika Surprise"
	result = /datum/reagent/ethanol/erikasurprise
	required_reagents = list(/datum/reagent/ethanol/ale = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/devilskiss
	name = "Devils Kiss"
	result = /datum/reagent/ethanol/devilskiss
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/hippiesdelight
	name = "Hippies Delight"
	result = /datum/reagent/ethanol/hippies_delight
	required_reagents = list(/datum/reagent/psilocybin = 1, /datum/reagent/ethanol/gargle_blaster = 1)
	result_amount = 2

/datum/chemical_reaction/bananahonk
	name = "Banana Honk"
	result = /datum/reagent/ethanol/bananahonk
	required_reagents = list(/datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/silencer
	name = "Silencer"
	result = /datum/reagent/ethanol/silencer
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/driestmartini
	name = "Driest Martini"
	result = /datum/reagent/ethanol/driestmartini
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/bluebird
	name = "Blue Bird"
	result = /datum/reagent/ethanol/bluebird
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/bj
	name = "BJ"
	result = /datum/reagent/ethanol/bj
	required_reagents = list(/datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 2

/datum/chemical_reaction/starrycola
	name = "Starry Cola"
	result = /datum/reagent/ethanol/starrycola
	required_reagents = list(/datum/reagent/ethanol/moonshine = 1, /datum/reagent/drink/space_cola = 2)
	result_amount = 3

/datum/chemical_reaction/calvincraig
	name = "Calvin Craig"
	result = /datum/reagent/ethanol/calvincraig
	required_reagents = list(/datum/reagent/drink/dr_gibb = 1, /datum/reagent/drink/space_up = 1, /datum/reagent/sugar = 1,  /datum/reagent/drink/juice/lemon = 1, /datum/reagent/ethanol/melonliquor = 2)
	result_amount = 6

/datum/chemical_reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/bj = 2, /datum/reagent/ethanol/vodka = 1)
	result_amount = 3

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/juice/lemon = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/kiraspecial
	name = "Kira Special"
	result = /datum/reagent/drink/kiraspecial
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/brownstar
	name = "Brown Star"
	result = /datum/reagent/drink/brownstar
	required_reagents = list(/datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/suidream
	name = "Sui Dream"
	result = /datum/reagent/ethanol/suidream
	required_reagents = list(/datum/reagent/drink/space_up = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/ethanol/melonliquor = 1)
	result_amount = 3

/datum/chemical_reaction/rum
	name = "Rum"
	result = /datum/reagent/ethanol/rum
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/ships_surgeon
	name = "Ship's Surgeon"
	result = /datum/reagent/ethanol/ships_surgeon
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/drink/dr_gibb = 2, /datum/reagent/drink/ice = 1)
	result_amount = 4