
#define EC_RIOTS 1
#define EC_WILD_ANIMAL_ATTACK 2
#define EC_INDUSTRIAL_ACCIDENT 3
#define EC_BIOHAZARD_OUTBREAK 4
#define EC_WARSHIPS_ARRIVE 5
#define EC_PIRATES 6
#define EC_CORPORATE_ATTACK 7
#define EC_ALIEN_RAIDERS 8
#define EC_AI_LIBERATION 9
#define EC_MOURNING 10
#define EC_CULT_CELL_REVEALED 11
#define EC_SECURITY_BREACH 12
#define EC_ANIMAL_RIGHTS_RAID 13
#define EC_FESTIVAL 14

#define EC_RESEARCH_BREAKTHROUGH 15
#define EC_BARGAINS 16
#define EC_SONG_DEBUT 17
#define EC_MOVIE_RELEASE 18
#define EC_BIG_GAME_HUNTERS 19
#define EC_ELECTION 20
#define EC_GOSSIP 21
#define EC_TOURISM 22
#define EC_CELEBRITY_DEATH 23
#define EC_RESIGNATION 24

#define EC_DEFAULT 1

#define EC_ADMINISTRATIVE 2
#define EC_CLOTHING 3
#define EC_SECURITY 4
#define EC_SPECIAL_SECURITY 5

#define EC_FOOD 6
#define EC_ANIMALS 7

#define EC_MINERALS 8

#define EC_EMERGENCY 9
#define EC_GAS 10
#define EC_MAINTENANCE 11
#define EC_ELECTRICAL 12
#define EC_ROBOTICS 13
#define EC_BIOMEDICAL 14

#define EC_GEAR_EVA 15

//---- The following corporations are friendly with NanoTrasen and loosely enable trade and travel:
//Corporation NanoTrasen - Generalised / high tech research and phoron exploitation.
//Corporation Vessel Contracting - Ship and station construction, materials research.
//Corporation Osiris Atmospherics - Atmospherics machinery construction and chemical research.
//Corporation Second Red Cross Society - 26th century Red Cross reborn as a dominating economic force in biomedical science (research and materials).
//Corporation Blue Industries - High tech and high energy research, in particular into the mysteries of bluespace manipulation and power generation.
//Corporation Kusanagi Robotics - Founded by robotics legend Kaito Kusanagi in the 2070s, they have been on the forefront of mechanical augmentation and robotics development ever since.
//Corporation Free traders - Not so much a corporation as a loose coalition of spacers, Free Traders are a roving band of smugglers, traders and fringe elements following a rigid (if informal) code of loyalty and honour. Mistrusted by most corporations, they are tolerated because of their uncanny ability to smell out a profit.

//---- Descriptions of destination types
//Space stations can be purpose built for a number of different things, but generally require regular shipments of essential supplies.
//Corvettes are small, fast warships generally assigned to border patrol or chasing down smugglers.
//Battleships are large, heavy cruisers designed for slugging it out with other heavies or razing planets.
//Yachts are fast civilian craft, often used for pleasure or smuggling.
//Destroyers are medium sized vessels, often used for escorting larger ships but able to go toe-to-toe with them if need be.
//Frigates are medium sized vessels, often used for escorting larger ships. They will rapidly find themselves outclassed if forced to face heavy warships head on.

var/global/datum/money_account/vendor_account
var/global/datum/money_account/station_account
var/global/list/datum/money_account/department_accounts = list()
var/global/num_financial_terminals = 1
var/global/next_account_number = 0
var/global/list/all_money_accounts = list()
