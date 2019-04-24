
//GLOBAL DEFINE//
var/global/datum/discord_api/discord_api = new()
/////////////////

/datum/discord_api
	var/path_to_db = "config/DB/pss13.db"
	var/database/db

/datum/discord_api/New()
	src.db = new(src.path_to_db)
	if (src.db.ErrorMsg())
		message_admins(src.db.ErrorMsg())

	//src.debugQuery()

/datum/discord_api/proc/send_message(msg)
	var/database/query/q = new("INSERT INTO discord_api VALUES('[msg]') ")
	if(!q.Execute(db))
		message_admins(src.db.ErrorMsg())
		return



/datum/admins/proc/discord_broadcast()
	set category = "Admin"
	set name = "Broadcast to Discord"
	set desc = "VERY EARLY DEV"
	var/msg = input(usr, "Message:", "Discord") as text|null
	if (msg)
		discord_api.send_message(msg)