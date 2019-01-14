/datum/category_item/player_setup_item/welcome
	name = "Welcome to Persistent Station 13!"
	sort_order = 1

/datum/category_item/player_setup_item/welcome/content()
	. = list()
	. += "<h2>Persistence is a codebase that makes the world and characters of SS13 save and load. Instead of rounds, the game is continuous with players creating factions and establishing space installations both peaceful and hostile, competing and cooperating in a galaxy of limited resources. After years of private Alpha Testing, the game is finally ready to be publically playable. It's still in early beta under active development however, so you can expect bugs."
	. += "<br><br>As a new player, the best way to get into the game is to take some time designing your first character. You will need to choose your starting faction and if you haven't played very long your choices for a starting faction will be limited, but most factions recruit their members from defectors of the basic starting factions. If you choose Nanotrasen, you will start on a space station with gameplay very similar to traditional SS13."
	. += "<br><br>Once you have a character, just look for an assignment so you can start putting money into your account. You can rise through the ranks anywhere, and soon you'll be ensconced in a world of intrigue and politics. Open a buisness designing atmospherics, or found an intersteller empire."
	. += "<br><br>Persistence is a collaborative project that is developed by an entire community of people. If you are intrested in joining us you can visit our forums here: https://persistentss13.com/forum or our discord here: https://discord.gg/UUpHSPp plus you can find a wiki here: https://persistentss13.com/wiki"
	. += "<br><br>Thanks for playing our game -- Brawler, Lead Developer</h3>"
	. = jointext(.,null)
