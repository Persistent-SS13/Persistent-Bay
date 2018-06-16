// RELAY
/area/relay
	name = "\improper Relay Station"
	icon_state = "green"
	dynamic_lighting = 0
	requires_power = 0

/area/relay/teleporter
	name = "\improper Relay Teleporter"
	icon_state = "teleporter"

// ACTORS GUILD
/area/acting
	name = "\improper Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0

/area/acting/backstage
	name = "\improper Backstage"

/area/acting/stage
	name = "\improper Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

// TURBOLIFTS
/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	flags = AREA_RAD_SHIELDED

/area/turbolift/Deck1L1
	name = "Deck 1"
/area/turbolift/Deck2L1
	name = "Deck 2"

/area/turbolift/Deck1L2
	name = "Deck 1"
/area/turbolift/Deck2L2
	name = "Deck 2"

/area/turbolift/Deck1L3
	name = "Deck 1"
/area/turbolift/Deck2L3
	name = "Deck 2"

// GENERIC MINING AREAS
/area/mine
	icon_state = "mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	sound_env = ASTEROID

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"

/area/mine/cave
	name = "Cave"
	icon_state = "cave"

// CONTOUR
// Chapel
/area/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')
	sound_env = LARGE_ENCLOSED

/area/chapel/crematorium
	name = "\improper Crematorium"
	icon_state = "chapel"
	sound_env = SMALL_ENCLOSED

// Contour First Deck
/area/hallway/firstdeck
	name = "\improper First Deck Hallway"
	icon_state = "hallC1"

/area/maintenance/firstdeck
	name = "\improper First Deck Maintenance"
	icon_state = "maintcentral"

/area/comms
	name = "\improper Contour Telecommunications"
	icon_state = "tcomsatcham"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')

// Contour Second Deck
/area/hallway/seconddeck
	name = "\improper First Deck Hallway"
	icon_state = "hallC2"

/area/maintenance/seconddeck
	name = "\improper Second Deck Maintenance"
	icon_state = "maintcentral"

// Contour Arrivals

/area/arrivals
	name = "\improper Contour Arrivals"
	icon_state = "entry_pods"

/area/security/checkpoint/C1
	name = "\improper Security Checkpoint 1"
	icon_state = "checkpoint"

/area/security/checkpoint/C2
	name = "\improper Security Checkpoint 2"
	icon_state = "checkpoint"

// Contour Engineering
/area/engineering
	name = "\improper Engineering"
	icon_state = "engineering"

/area/engineering/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
