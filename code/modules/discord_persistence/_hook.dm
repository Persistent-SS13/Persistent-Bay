
//GLOBAL DEFINE//
var/global/datum/discord_api/discord_api = new()
/////////////////

/datum/discord_api
	var/path_to_db = "config/DB/pss13.db"
	var/database/db
	var/queueTable = "discord_queue"
	var/usersTable = "discord_users"

/datum/discord_api/New()
	src.db = new(src.path_to_db)
	if (src.db.ErrorMsg())
		message_admins(src.db.ErrorMsg())

	//src.debugQuery()

/datum/discord_api/proc/send_message(msg)
	var/database/query/q = new("INSERT INTO [queueTable] VALUES('[msg]') ")
	if(!q.Execute(db))
		message_admins(src.db.ErrorMsg())
		return

/datum/discord_api/proc/mail(receiver_name, var/datum/computer_file/data/email_message/message)
	message_admins("CHECK 2")
	var/receiver_ckey = Retrieve_Record(receiver_name).ckey
	var/sender_name = message.source
	var/database/query/g = new("SELECT * FROM [discord_api.usersTable] WHERE ckey = ? AND valid = 1", receiver_ckey)
	if (g.Execute(discord_api.db) && g.NextRow())
		message_admins("CHECK 3")
		var/list/data = g.GetRowData()
		var/discordID = data["userID"]
		if (isnum(discordID))
			message_admins("DISCORD_ID IS A NUMBER!! OH NOES")
		var/msg = "MAIL|[discordID]|[sender_name]|[receiver_name]|**[message.title]**\n`[message.stored_data]`"
		src.send_message(msg)
	else
		message_admins(g.Error())


/datum/admins/proc/discord_broadcast()
	set category = "Admin"
	set name = "Broadcast to Discord"
	set desc = "VERY EARLY DEV"
	var/msg = input(usr, "Message:", "Discord") as text|null
	if (msg)
		discord_api.send_message("BROADCAST|[msg]")


/client/verb/linkdiscord()
	set category = "Special Verbs"
	set name = "Link Discord Account"
	set desc = "Link your discord account to your BYOND account."

	var/userID = input(usr, "Discord User ID:", "Discord") as text|null
	if (userID)
		userID = "\"[userID]\""
		var/database/query/g = new("SELECT * FROM [discord_api.usersTable] WHERE ckey = ? OR userID = ?", usr.ckey, userID)
		if (g.Execute(discord_api.db) && g.NextRow())
			to_chat(usr, SPAN_WARNING("Could not complete your Discord Account link request. It seems you have already linked this BYOND account OR this discord ID is already linked to another account."))
		else
			var/database/query/q = new("INSERT INTO [discord_api.usersTable] VALUES(?,?,0) ", userID, usr.ckey)
			if(!q.Execute(discord_api.db))
				message_admins(q.Error())
				return
			to_chat(usr, SPAN_NOTICE("Your account has been successfuly linked. To finish the process, however, you MUST validate your link on your discord. Just type in '!validatelink YOUR_CKEY' on the official discord server. (Or by PMing the Bot with that command.)"))
