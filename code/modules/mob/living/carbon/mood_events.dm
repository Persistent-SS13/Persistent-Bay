/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 0

///For descriptions, use the span classes bold info, info, none, warning and boldwarning in order from great to horrible.

//thirst
/datum/happiness_event/thirst/filled
	description = "<span class='binfo'>I've had enough to drink for a while!</span>\n"
	happiness = 4

/datum/happiness_event/thirst/watered
	description = "<span class='info'>I have recently had something to drink.</span>\n"
	happiness = 2

/datum/happiness_event/thirst/thirsty
	description = "<span class='warning'>I'm getting a bit thirsty.</span>\n"
	happiness = -7

/datum/happiness_event/thirst/dehydrated
	description = "<span class='danger'>I need water!</span>\n"
	happiness = -14



//nutrition
/datum/happiness_event/nutrition/fat
	description = "<span class='warning'><B>I'm so fat..</B></span>\n" //muh fatshaming
	happiness = -4

/datum/happiness_event/nutrition/wellfed
	description = "<span class='binfo'>My belly feels round and full.</span>\n"
	happiness = 4

/datum/happiness_event/nutrition/fed
	description = "<span class='info'>I have recently had some food.</span>\n"
	happiness = 2

/datum/happiness_event/nutrition/hungry
	description = "<span class='warning'>I'm getting a bit hungry.</span>\n"
	happiness = -6

/datum/happiness_event/nutrition/starving
	description = "<span class='danger'>I'm starving!</span>\n"
	happiness = -12


//Hygiene
/datum/happiness_event/hygiene/clean
	description = "<span class='info'>I feel so clean!\n"
	happiness = 2

/datum/happiness_event/hygiene/smelly
	description = "<span class='warning'>I smell like shit.\n"
	happiness = -5

/datum/happiness_event/hygiene/vomitted
	description = "<span class='warning'>Ugh, I've vomitted.\n"
	happiness = -5
	timeout = 1800



//Disgust
/datum/happiness_event/disgust/gross
	description = "<span class='warning'>That was gross.</span>\n"
	happiness = -2
	timeout = 1800

/datum/happiness_event/disgust/verygross
	description = "<span class='warning'>I think I'm going to puke...</span>\n"
	happiness = -4
	timeout = 1800

/datum/happiness_event/disgust/disgusted
	description = "<span class='danger'>Oh god that's disgusting...</span>\n"
	happiness = -6
	timeout = 1800



//Generic events
/datum/happiness_event/favorite_food
	description = "<span class='info'>I really liked eating that.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='info'>I had a nice shower.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/handcuffed
	description = "<span class='warning'>I guess my antics finally caught up with me..</span>\n"
	happiness = -1

/datum/happiness_event/booze
	description = "<span class='info'>Alcohol makes the pain go away.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/relaxed//For nicotine.
	description = "<span class='info'>I feel relaxed.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/antsy//Withdrawl.
	description = "<span class='danger'>I could use a smoke.</span>\n"
	happiness = -3
	timeout = 1800

/datum/happiness_event/hot_food //Hot food feels good!
	description = "<span class='info'>I've eaten something warm.</span>\n"
	happiness = 3
	timeout = 1800

/datum/happiness_event/cold_drink //Cold drinks feel good!
	description = "<span class='info'>I've had something refreshing.</span>\n"
	happiness = 3
	timeout = 1800

/datum/happiness_event/high
	description = "<span class='binfo'>I'm high as fuck</span>\n"
	happiness = 12



//Embarassment
/datum/happiness_event/hygiene/shit
	description = "<span class='danger'>I shit myself. How embarassing.\n"
	happiness = -12
	timeout = 1800

/datum/happiness_event/hygiene/pee
	description = "<span class='danger'>I pissed myself. How embarassing.\n"
	happiness = -12
	timeout = 1800


//Unused so far but I want to remember them to use them later.
/datum/happiness_event/disturbing
	description = "<span class='danger'>I recently saw something disturbing</span>\n"
	happiness = -2

/datum/happiness_event/clown
	description = "<span class='info'>I recently saw a funny clown!</span>\n"
	happiness = 1

/datum/happiness_event/cloned_corpse
	description = "<span class='danger'>I recently saw my own corpse...</span>\n"
	happiness = -6

/datum/happiness_event/surgery
	description = "<span class='danger'>HE'S CUTTING ME OPEN!!</span>\n"
	happiness = -8