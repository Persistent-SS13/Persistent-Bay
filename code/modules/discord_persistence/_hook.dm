/*
Discord Bot designed specially for the Persistence needs!

On launch, this is currently only used for mailing notifications and linking accounts.

Any troubles just contact me - Stigma
*/


//GLOBAL DEFINE//
GLOBAL_DATUM_INIT(discord_api, /datum/discord_api, new)
/////////////////

//This unique datum holds the information required to use the database-
//TODO: Make the queueTable, usersTable and path_to_db 'gettable' from a config file.
/datum/discord_api
	var/path_to_db = "config/DB/pss13.db"
	var/database/db
	var/queueTable = "discord_queue"
	var/usersTable = "discord_users"
	var/arg_sep = @"[[sep]]"

/datum/discord_api/New()
	src.connectToDb()

/datum/discord_api/proc/connectToDb()
	src.db = new(src.path_to_db)
	if (src.db.ErrorMsg())
		message_admins("Error connecting to discord DB. Trying again in 30 seconds. Err: [src.db.ErrorMsg()]")
		spawn(300)
			src.connectToDb()

//The main proc where the magic happens. Sends a message to the database to be read by the Bot
/datum/discord_api/proc/send_message(cmd, cmd_args, message)
	var/cmd_args_str = ""
	var/first = TRUE
	for (var/a in cmd_args)
		if (first)
			first = FALSE
		else
			cmd_args_str += src.arg_sep
		cmd_args_str += a
	var/database/query/q = new("INSERT INTO [queueTable] VALUES(?, ?, ?) ", cmd, cmd_args_str, message)
	if(!q.Execute(db))
		message_admins(src.db.ErrorMsg())
		return

//The mail proc, which handles sending the mail information to the Bot. The rest is taken care of by it.
/datum/discord_api/proc/mail(receiver_name, var/datum/computer_file/data/email_message/message)
	var/receiver_ckey = Retrieve_Record(receiver_name).ckey
	var/sender_name = message.source
	var/database/query/g = new("SELECT * FROM [usersTable] WHERE ckey = ? AND valid = 1", receiver_ckey)
	if (g.Execute(GLOB.discord_api.db) && g.NextRow())
		var/list/data = g.GetRowData()
		var/discordID = data["userID"]
		var/list/cmd_args = list(discordID, sender_name, receiver_name, message.title)
		src.send_message("MAIL", cmd_args, message.stored_data)

/datum/discord_api/proc/broadcast(message)
	src.send_message("BROADCAST", list(), message)

/datum/discord_api/proc/on_new_ahelp(var/mob/user, message)
	src.send_message("AHELP", list(user.ckey, "[user]"), message)

//A broadcast bot, for the broadcasting needs. (This was mainly for testing, probably should have no use at all.) EDIT: It is actually fun portraying as the all seeing AI
/datum/admins/proc/discord_broadcast()
	set category = "Admin"
	set name = "Broadcast to Discord"
	set desc = "VERY EARLY DEV"
	var/msg = input(usr, "Message:", "Discord") as text|null
	if (msg)
		GLOB.discord_api.broadcast(msg)


/client/verb/linkdiscord()
	set category = "Special Verbs"
	set name = "Discord Account - Associate"
	set desc = "Link your discord account to your BYOND account."

	usr.client.link_discord()

/client/proc/link_discord()
	var/userID = input(usr, "Enter your Discord ID. You can get this by typing !getid in the main discord server.", "Enter Discord ID") as text|null
	if (userID)
		var/database/query/g = new("SELECT * FROM [GLOB.discord_api.usersTable] WHERE ckey = ? OR userID = ?", usr.ckey, userID)
		if (g.Execute(GLOB.discord_api.db) && g.NextRow())
			to_chat(usr, SPAN_WARNING("Could not complete your Discord Account link request. It seems you have already linked this BYOND account OR this discord ID is already linked to another account."))
		else
			var/database/query/q = new("INSERT INTO [GLOB.discord_api.usersTable] VALUES(?,?,0) ", userID, usr.ckey)
			if(!q.Execute(GLOB.discord_api.db))
				message_admins(q.ErrorMsg())
				return
			to_chat(usr, SPAN_NOTICE("Your account has been successfuly linked. To finish the process, however, you MUST validate your link on your discord. Just type in '!validatelink YOUR_CKEY' on the official discord server. (Or by PMing the Bot with that command.)"))


/client/verb/unlinkdiscord()
	set category = "Special Verbs"
	set name = "Discord Account - Disassociate"
	set desc = "Devalidates the link between your BYOND and Discord account."

	var/database/query/g = new("SELECT * FROM [GLOB.discord_api.usersTable] WHERE ckey = ?", usr.ckey)
	if (g.Execute(GLOB.discord_api.db) && g.NextRow())
		var/database/query/delete = new("DELETE FROM [GLOB.discord_api.usersTable] WHERE ckey = ?", usr.ckey)
		if (delete.Execute(GLOB.discord_api.db))
			to_chat(usr, SPAN_NOTICE("You have successfuly disassociated your Discord and BYOND accounts."))
	else
		to_chat(usr, SPAN_WARNING("There is no Discord Account associated with your BYOND account."))
