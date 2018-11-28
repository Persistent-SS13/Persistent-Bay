/client/verb/set_client_fps()
	set category = "OOC"
	set name = "Client FPS"
	set desc = "Set your client FPS"

	var/set_fps = text2num(input("Enter FPS 20-100", "Set FPS", prefs.clientfps))
	if (set_fps >=20 && set_fps <= 100)
		prefs.clientfps = set_fps
		apply_fps(prefs.clientfps)
		prefs.save_preferences()
	else
		to_chat(src,"<span class='danger'>Not a valid number.</span>")
	return
	
